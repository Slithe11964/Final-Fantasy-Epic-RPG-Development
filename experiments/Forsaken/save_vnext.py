"""Bounded reference format prototype. Not registered with any Warcraft save route."""
from dataclasses import dataclass
import math
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'tools'))
from savecode import ALPHABET

MAGIC = 'FSV'  # Research envelope, deliberately not a legacy I/J dispatch marker.
MAX_INT = 2147483647
MAX_PAYLOAD = 16384
MAX_SECTIONS = 32
MAX_OPAQUE = 4096
MAX_ITEMS = 57
MAX_RECORDS = 2048
MAX_UNKNOWN_RECORDS = 256
HOLDERS = {1: 6, 2: 30, 3: 9, 4: 6, 5: 6}


class Error(ValueError):
    pass


def uint(value):
    if type(value) is not int or not 0 <= value <= MAX_INT:
        raise Error('unsigned integer outside signed JASS-safe range')
    result = ''
    while True:
        part = value & 31
        value >>= 5
        result += ALPHABET[part | (32 if value else 0)]
        if not value:
            return result


def alphabet(text):
    if not isinstance(text, str) or any(c not in ALPHABET for c in text):
        raise Error('invalid payload alphabet')


class Reader:
    def __init__(self, text):
        alphabet(text)
        self.text, self.pos = text, 0

    def take(self, size):
        if size < 0 or size > len(self.text) - self.pos:
            raise Error('truncated length-delimited value')
        value = self.text[self.pos:self.pos + size]
        self.pos += size
        return value

    def uint(self):
        value = 0
        for index in range(7):
            digit = ALPHABET.index(self.take(1))
            part = digit & 31
            if index == 6 and part > 1:
                raise Error('integer overflow')
            value |= part << (5 * index)
            if not digit & 32:
                if index and part == 0:
                    raise Error('noncanonical integer')
                return value
        raise Error('overlong integer')

    def finish(self):
        if self.pos != len(self.text):
            raise Error('trailing data')


def checksum(text):
    # Two bounded modular accumulators. Every intermediate fits signed32 in JASS.
    # Integrity only: this is not a signature or anti-forgery mechanism.
    a, b = 1, 0
    for char in text:
        a = (a + ALPHABET.index(char) + 1) % 32749
        b = (b + a) % 32749
    return (b << 15) | a


@dataclass(frozen=True)
class Section:
    id: int
    version: int
    required: bool
    payload: str


@dataclass(frozen=True)
class Envelope:
    account_hash: int
    sections: tuple


def encode(envelope):
    if type(envelope.account_hash) is not int or not 0 <= envelope.account_hash < 1048576:
        raise Error('invalid account hash')
    if not 1 <= len(envelope.sections) <= MAX_SECTIONS:
        raise Error('invalid section count')
    ids, opaque, records, parts = set(), 0, 0, []
    for section in envelope.sections:
        if section.id <= 0 or section.version <= 0 or section.id in ids or type(section.required) is not bool:
            raise Error('invalid or duplicate section')
        ids.add(section.id)
        if len(section.payload) > MAX_PAYLOAD:
            raise Error('section payload budget exceeded')
        alphabet(section.payload)
        extra, extra_records = validate_section(section)
        opaque += extra
        records += extra_records
        parts.append(uint(section.id) + uint(section.version) + uint(int(section.required)) +
                     uint(len(section.payload)) + section.payload)
    if opaque > MAX_OPAQUE or records > MAX_UNKNOWN_RECORDS:
        raise Error('opaque preservation budget exceeded')
    body = ''.join(parts)
    if len(body) > MAX_PAYLOAD:
        raise Error('payload budget exceeded')
    header = MAGIC + uint(1) + uint(envelope.account_hash) + uint(len(body)) + uint(len(parts))
    return header + uint(checksum(header + body)) + body


def decode(text, expected_account=None):
    if not isinstance(text, str) or len(text) > MAX_PAYLOAD + 64:
        raise Error('envelope budget exceeded')
    reader = Reader(text)
    if reader.take(3) != MAGIC or reader.uint() != 1:
        raise Error('unsupported envelope')
    account, length, count = reader.uint(), reader.uint(), reader.uint()
    if account >= 1048576 or (expected_account is not None and account != expected_account):
        raise Error('account mismatch')
    if length > MAX_PAYLOAD or not 1 <= count <= MAX_SECTIONS:
        raise Error('invalid envelope lengths/counts')
    header = text[:reader.pos]
    stored = reader.uint()
    body = reader.take(length)
    reader.finish()
    if checksum(header + body) != stored:
        raise Error('checksum mismatch')
    payload = Reader(body)
    sections = []
    for _ in range(count):
        sid, version, flags, size = payload.uint(), payload.uint(), payload.uint(), payload.uint()
        if flags not in (0, 1):
            raise Error('unknown section flags')
        sections.append(Section(sid, version, bool(flags), payload.take(size)))
    payload.finish()
    result = Envelope(account, tuple(sections))
    # Same shape/budget/schema validation in both directions, including nested data.
    if encode(result) != text:
        raise Error('noncanonical envelope')
    return result


def pairs(records):
    """ID-keyed unsigned scalar records (jobs or future optional progression)."""
    if len(records) > MAX_RECORDS:
        raise Error('record budget exceeded')
    ids, result = set(), uint(len(records))
    for identity, value in records:
        if identity <= 0 or identity in ids:
            raise Error('invalid or duplicate permanent ID')
        ids.add(identity)
        result += uint(identity) + uint(value)
    return result


def read_pairs(text):
    r = Reader(text)
    count = r.uint()
    if count > MAX_RECORDS:
        raise Error('record budget exceeded')
    records = [(r.uint(), r.uint()) for _ in range(count)]
    r.finish()
    if pairs(records) != text:
        raise Error('noncanonical records')
    return records


def life_words(value):
    if not math.isfinite(value) or value <= 0:
        raise Error('invalid item life')
    try:
        bits = struct.unpack('>I', struct.pack('>f', value))[0]
    except (OverflowError, struct.error) as exc:
        raise Error('unrepresentable item life') from exc
    if not math.isfinite(struct.unpack('>f', struct.pack('>I', bits))[0]) or bits == 0:
        raise Error('unrepresentable item life')
    return uint(bits >> 16) + uint(bits & 65535)


def read_life(text):
    r = Reader(text)
    high, low = r.uint(), r.uint()
    r.finish()
    if high > 65535 or low > 65535:
        raise Error('invalid item life words')
    value = struct.unpack('>f', struct.pack('>I', (high << 16) | low))[0]
    if not math.isfinite(value) or value <= 0:
        raise Error('invalid item life')
    return value


def inventory(records):
    if len(records) > MAX_ITEMS:
        raise Error('item budget exceeded')
    parts = []
    for record in records:
        ordinal, item_id, holder, slot, quantity, bound, metadata = record
        raw = uint(ordinal) + uint(item_id) + uint(holder) + uint(slot)
        raw += uint(int(quantity is not None))
        if quantity is not None:
            if type(quantity) is not int or not 0 <= quantity <= 127:
                raise Error('quantity does not fit seven bits')
            raw += ALPHABET[quantity & 63] + ALPHABET[quantity >> 6]
        if type(bound) is not bool:
            raise Error('binding must be account-relative boolean')
        raw += uint(int(bound)) + uint(len(metadata))
        for sid, required, data in metadata:
            alphabet(data)
            if type(required) is not bool:
                raise Error('metadata flags must be boolean')
            raw += uint(sid) + uint(int(required)) + uint(len(data)) + data
        if len(raw) > MAX_PAYLOAD:
            raise Error('item payload budget exceeded')
        parts.append(uint(len(raw)) + raw)
    text = uint(len(records)) + ''.join(parts)
    if len(text) > MAX_PAYLOAD:
        raise Error('inventory payload budget exceeded')
    read_inventory(text)  # Encoder also rejects duplicate slots/ordinals and bad metadata.
    return text


def read_inventory(text):
    r = Reader(text)
    count = r.uint()
    if count > MAX_ITEMS:
        raise Error('item budget exceeded')
    records, slots, ordinals, opaque = [], set(), set(), 0
    for _ in range(count):
        item = Reader(r.take(r.uint()))
        ordinal, identity, holder, slot = [item.uint() for _ in range(4)]
        if ordinal <= 0 or identity <= 0 or ordinal in ordinals:
            raise Error('invalid or duplicate item ordinal')
        if holder not in HOLDERS or slot >= HOLDERS[holder] or (holder, slot) in slots:
            raise Error('invalid or duplicate inventory position')
        ordinals.add(ordinal); slots.add((holder, slot))
        has_quantity = item.uint()
        if has_quantity not in (0, 1):
            raise Error('invalid quantity flag')
        quantity = None
        if has_quantity:
            digits = item.take(2)
            low, high = [ALPHABET.index(c) for c in digits]
            if high > 1:
                raise Error('quantity exceeds seven bits')
            quantity = low + 64 * high
        binding, meta_count = item.uint(), item.uint()
        if binding not in (0, 1) or meta_count > 16:
            raise Error('invalid binding/metadata count')
        metadata, meta_ids = [], set()
        for _ in range(meta_count):
            sid, flags, length = item.uint(), item.uint(), item.uint()
            data = item.take(length)
            if sid <= 0 or sid in meta_ids or flags not in (0, 1):
                raise Error('invalid or duplicate item metadata')
            meta_ids.add(sid)
            if sid == 1:
                read_life(data)
            elif sid == 2:
                flag_reader = Reader(data)
                if flag_reader.uint() > 7:
                    raise Error('invalid persistent item flags')
                flag_reader.finish()
            elif flags:
                raise Error('unsupported required item metadata')
            else:
                opaque += len(data)
            metadata.append((sid, bool(flags), data))
        item.finish()
        records.append((ordinal, identity, holder, slot, quantity, bool(binding), tuple(metadata)))
    r.finish()
    if opaque > MAX_OPAQUE:
        raise Error('opaque item metadata budget exceeded')
    return records, opaque


def validate_section(section):
    if section.version == 2 and section.id == 2:
        from save_progression import read_jobs2
        read_jobs2(section.payload)
        return 0, 0
    if section.version == 2 and section.id == 4:
        from save_progression import validate_payload
        validate_payload(section.id, section.payload, 2)
        return 0, 0
    if section.version == 1 and section.id in range(4, 10):
        from save_progression import validate_payload
        validate_payload(section.id, section.payload)
        return 0, 0
    if section.version != 1 or section.id not in (1, 2, 3):
        if section.required:
            raise Error('unsupported required section/schema')
        return len(section.payload), 0
    if section.id == 1:
        _, opaque = read_inventory(section.payload)
        return opaque, 0
    records = read_pairs(section.payload)
    if section.id == 2:  # Counted permanent job IDs; no live job-count dependency.
        if any(value > 100 for _, value in records):
            raise Error('job saved level exceeds supported schema')
        return 0, 0
    # Section3 is optional extension progression, kept dormant in this prototype.
    # It has a counted shape, so unknown-record preservation has an enforceable cap.
    if section.required:
        raise Error('extension progression cannot be required')
    return len(section.payload), len(records)

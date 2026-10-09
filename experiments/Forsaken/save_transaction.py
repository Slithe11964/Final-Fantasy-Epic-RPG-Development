"""Reference capture/restore orchestration. No Warcraft backend or entry route exists."""
from dataclasses import dataclass

import save_progression as progression
import save_vnext as codec


class Failure(ValueError):
    pass


@dataclass(frozen=True)
class ItemType:
    identity: int
    charged: bool
    default_charges: int


@dataclass(frozen=True)
class LiveItem:
    handle: int
    rawcode: str
    holder: int
    slot: int
    charges: int
    life: float
    user_data: int
    flags: object  # None means the runtime flags have not been authoritatively captured.


def capture_inventory(items, pid, aliases, reserved=(), ready=True):
    """Read-only projection; caller must supply authoritative flags/eligibility.

    Aliases contain only eligible canonical/variant/offhand rawcodes for this
    actual load mode. No unknown/foreign item is silently omitted. Unavailable
    records retain their complete tuple and ordinal, reserving their position.
    """
    if type(pid) is not int or not 0 <= pid < 8 or ready is not True:
        raise Failure('capture context is not ready')
    if len(items)+len(reserved) > codec.MAX_ITEMS:
        raise Failure('capture exceeds inventory bound')
    records = list(reserved)
    codec.inventory(records)
    known_ids = {entry.identity for entry in aliases.values()}
    for record in reserved:
        unknown_metadata = any(m[0] not in (1, 2) for m in record[6])
        if record[1] in known_ids and not unknown_metadata:
            raise Failure('available reserved item requires reconciliation')
    ordinals = {r[0] for r in records}
    handles, ordinal = set(), 1
    for item in sorted(items, key=lambda item: (item.holder, item.slot)):
        if type(item.handle) is not int or item.handle <= 0 or item.handle in handles:
            raise Failure('duplicate or invalid live handle')
        handles.add(item.handle)
        definition = aliases.get(item.rawcode)
        if definition is None:
            raise Failure('occupied item is unknown/ineligible')
        if item.user_data not in (0, pid+1):
            raise Failure('foreign-bound item cannot be captured')
        if type(item.flags) is not int or not 0 <= item.flags <= 7:
            raise Failure('persistent flags are unresolved')
        if not definition.charged and item.charges != definition.default_charges:
            raise Failure('noncharged item differs from reviewed charge default')
        while ordinal in ordinals:
            ordinal += 1
        record = (ordinal, definition.identity, item.holder, item.slot,
                  item.charges if definition.charged else None, item.user_data != 0,
                  ((1, True, codec.life_words(item.life)), (2, True, codec.uint(item.flags))))
        records.append(record)
        ordinals.add(ordinal)
        ordinal += 1
    # Bounds, duplicate reserved/live positions and all nested metadata validate.
    return codec.inventory(records)


@dataclass(frozen=True)
class Material:
    record: tuple
    rawcode: str
    charges: int
    life: float
    flags: int
    user_data: int
    owner: int


@dataclass(frozen=True)
class Dormant:
    record: tuple


@dataclass(frozen=True)
class Defaults:
    rawcode: str
    charges: int
    life: float
    flags: int


def resolve_item(record, pid, available, defaults, has_legacy_evidence=False):
    """Resolve reviewed per-position rawcodes/defaults without creating anything.

    Defaults keys are (canonical ID, holder ID, slot). An adapter must derive
    these from reviewed current definitions/equip rules, never experimental
    aliases serialized in a code. Unknown optional metadata keeps the item dormant.
    """
    _, identity, holder, slot, quantity, bound, metadata = record
    if identity not in available or any(i not in (1, 2) for i, _, _ in metadata):
        return Dormant(record)
    definition = defaults.get((identity, holder, slot))
    if definition is None:
        raise Failure('reviewed item/container defaults are unavailable')
    values = {identity: payload for identity, _, payload in metadata}
    if not {1, 2} <= values.keys() and not has_legacy_evidence:
        raise Failure('missing captured metadata has no legacy provenance')
    life = codec.read_life(values[1]) if 1 in values else codec.read_life(codec.life_words(definition.life))
    flag_reader = codec.Reader(values[2] if 2 in values else codec.uint(definition.flags))
    flags = flag_reader.uint()
    flag_reader.finish()
    if flags > 7 or not definition.rawcode:
        raise Failure('invalid reviewed defaults')
    charges = quantity if quantity is not None else definition.charges
    if type(charges) is not int or not 0 <= charges <= 127:
        raise Failure('unrepresentable resolved charges')
    return Material(record, definition.rawcode, charges, life, flags, pid+1 if bound else 0, pid)


@dataclass(frozen=True)
class Result:
    status: str
    reason: str = ''


def restore(encoded, expected_account, backend):
    """Reference protocol for a FUTURE synchronized runtime backend.

    Required backend operations are exercised by the fault-injection tests.
    Recovery must restore original handles and all journaled state, and verify
    it. Failed/unverified recovery leaves the backend guard locked. Publishing
    is the sole success point; cleanup after it cannot turn success into rollback.
    Python exceptions do not model a Warcraft thread killed by its operation cap.
    """
    if type(expected_account) is not int or not 0 <= expected_account < 1048576:
        return Result('rejected', 'account comparison is mandatory')
    try:
        envelope = codec.decode(encoded, expected_account)
        snapshot = progression.snapshot(envelope)
        if snapshot['core']['cheater_flag']:
            raise Failure('cheat status requires separate policy')
        if snapshot['migration'] is not None:
            import migrate_save
            if not migrate_save.comparison(envelope)['equal']:
                raise Failure('legacy evidence comparison failed')
        backend.validate_policy(snapshot)
    except (codec.Error, Failure) as exc:
        return Result('rejected', str(exc))
    if not backend.acquire():
        return Result('rejected', 'load guard is unavailable')
    journal, created = None, []
    try:
        journal = backend.journal()
        target = backend.project_progression(snapshot)
        resolved = [backend.resolve(record, snapshot['migration'] is not None)
                    for record in snapshot['inventory']]
        for item in resolved:
            if isinstance(item, Material):
                handle = backend.create_hidden(item)
                if handle is None:
                    raise Failure('item creation failed')
                # Record ownership before any fallible metadata operation.
                created.append(handle)
                backend.configure_hidden(handle, item)
            elif not isinstance(item, Dormant):
                raise Failure('backend returned an invalid resolution')
        backend.verify_original(journal)
        # Old handles remain alive and inaccessible, never destroyed here.
        backend.quarantine_originals(journal)
        next_handle = iter(created)
        for item in resolved:
            if isinstance(item, Material):
                backend.place(next(next_handle), item)
            else:
                backend.reserve(item)
        backend.apply_progression(target)
        backend.verify_staged(resolved, target)
        backend.publish(envelope)
    except Exception as exc:
        try:
            if journal is None:
                # No item was created/quarantined; journal acquisition itself failed.
                backend.verify_unstarted()
            else:
                backend.recover(journal, created)
                backend.verify_recovery(journal, created)
        except Exception as recovery:
            try:
                backend.contain()
            except Exception as containment:
                return Result('blocked', str(exc)+'; recovery and containment unverified: '+str(containment))
            return Result('blocked', str(exc)+'; recovery unverified: '+str(recovery))
        backend.release()
        return Result('rolled_back', str(exc))
    # Commit is durable at the backend's publish boundary. Deleting old handles
    # is irreversible: cleanup failure retains quarantined originals for retry.
    try:
        backend.retire_originals(journal)
    except Exception as exc:
        backend.release()
        return Result('committed_cleanup_pending', str(exc))
    backend.release()
    return Result('committed')

"""Logical progression schema and profile validation; no gameplay mutation."""
import save_vnext as codec

# Permanent field IDs in section4. None in a legacy snapshot means ABSENT,
# never an invented zero. Shards were folded into legacy gold and are not separable.
CORE = {
    1: ('difficulty', 6), 2: ('gold', codec.MAX_INT), 3: ('shards', codec.MAX_INT),
    4: ('freelancer', 100), 5: ('new_game_plus', 10), 6: ('miracle_stage', 3),
    7: ('meta_fragments', 7), 8: ('speedrun_level', 15),
    9: ('legendary_guardian', 1), 10: ('armory_allowed_on_hard', 1),
    11: ('cheater_flag', 1),
}
GAYA = {1: ('mastered', 1), 2: ('level', 100), 3: ('break_stun', 3),
        4: ('mana_transfer', 3), 5: ('mega_heal', 3), 6: ('tarugaya', 1),
        7: ('sukugaya', 1), 8: ('rakugaya', 1)}
# Schema2 separates real levels from the old enhanced-mastery sentinel.
CORE2 = dict(CORE)
CORE2[4] = ('freelancer', 999)
CORE2[7] = ('meta_fragments', codec.MAX_INT)
CORE2.update({12: ('freelancer_mastery', 3), 13: ('current_job', 22),
              14: ('freelancer_variant', 3), 15: ('speedrun_mode', 1)})


def mastery_valid(level, tier):
    return (type(level) is int and type(tier) is int and 0 <= level <= 999 and
            0 <= tier <= 3 and ((level < 50 and tier == 0) or
            (50 <= level < 99 and tier == 1) or (level >= 99 and tier in (2, 3))))


def jobs2(records):
    if len(records) > codec.MAX_RECORDS:
        raise codec.Error('too many job records')
    ids = set()
    payload = codec.uint(len(records))
    for identity, level, tier in records:
        if type(identity) is not int or identity <= 0 or identity in ids or not mastery_valid(level, tier):
            raise codec.Error('invalid job identity, level or mastery tier')
        ids.add(identity)
        payload += codec.uint(identity)+codec.uint(level)+codec.uint(tier)
    return payload


def read_jobs2(text):
    reader = codec.Reader(text)
    count = reader.uint()
    if count > codec.MAX_RECORDS:
        raise codec.Error('too many job records')
    records = [(reader.uint(), reader.uint(), reader.uint()) for _ in range(count)]
    reader.finish()
    if jobs2(records) != text:
        raise codec.Error('invalid job records')
    return records


def legacy_job(saved):
    if type(saved) is not int or not 0 <= saved <= 100:
        raise codec.Error('invalid legacy job marker')
    return (99, 3) if saved == 100 else (saved, 2 if saved == 99 else 1 if saved >= 50 else 0)


MAX_EVIDENCE = 4096
LEGACY_CHARS = codec.ALPHABET + '()'
PROFILE_SECTIONS = {1, 2, 4, 5, 6, 7, 8}


def scalars(values, fields):
    """Encode present named fields; omitted values do not acquire defaults."""
    names = {name for name, _ in fields.values()}
    if set(values) - names:
        raise codec.Error('unknown named progression field')
    if any(value is not None and type(value) not in (int, bool) for value in values.values()):
        raise codec.Error('progression values must be integers/booleans')
    return codec.pairs([(identity, int(values[name])) for identity, (name, _) in fields.items()
                        if name in values and values[name] is not None])


def read_scalars(text, fields):
    result = {}
    for identity, value in codec.read_pairs(text):
        if identity not in fields or value > fields[identity][1]:
            raise codec.Error('unsupported progression field/value')
        result[fields[identity][0]] = value
    return result


def evidence(code, speedrun=False):
    if type(speedrun) is not bool or not 8 <= len(code) <= MAX_EVIDENCE:
        raise codec.Error('invalid migration evidence size/context')
    if code[0] not in 'EFGH' or any(c not in LEGACY_CHARS for c in code):
        raise codec.Error('invalid migration evidence alphabet/version')
    # Policy1 and explicit mode context. ASCII values use the same bounded varints.
    return codec.uint(1) + codec.uint(int(speedrun)) + codec.uint(len(code)) + ''.join(
        codec.uint(ord(c)) for c in code)


def read_evidence(text):
    r = codec.Reader(text)
    policy, speedrun, count = r.uint(), r.uint(), r.uint()
    if policy != 1 or speedrun > 1 or not 8 <= count <= MAX_EVIDENCE:
        raise codec.Error('unsupported migration policy/context/size')
    values = [r.uint() for _ in range(count)]
    if any(value > 127 for value in values):
        raise codec.Error('non-ASCII migration evidence')
    code = ''.join(chr(value) for value in values)
    r.finish()
    if evidence(code, bool(speedrun)) != text:
        raise codec.Error('noncanonical migration evidence')
    return code, bool(speedrun)


def validate_payload(identity, text, version=1):
    if identity == 9:
        read_evidence(text)
        return
    if identity in (4, 5):
        read_scalars(text, (CORE2 if version == 2 else CORE) if identity == 4 else GAYA)
        return
    records = codec.read_pairs(text)
    if identity == 6 and any(i > 15 or value > 15 for i, value in records):
        raise codec.Error('unsupported upgrade field/value')
    if identity in (7, 8) and any(value != 1 for _, value in records):
        raise codec.Error('ownership flags must be one')


def snapshot(envelope):
    """Validate the logical profile, beyond the permissive generic envelope."""
    codec.encode(envelope)
    sections = {s.id: s for s in envelope.sections}
    if not PROFILE_SECTIONS <= sections.keys():
        raise codec.Error('missing logical snapshot section')
    for identity in PROFILE_SECTIONS | ({9} if 9 in sections else set()):
        if sections[identity].version not in ((1, 2) if identity in (2, 4) else (1,)) or not sections[identity].required:
            raise codec.Error('logical snapshot section must use required schema1')
    modern = sections[2].version == 2
    if modern != (sections[4].version == 2):
        raise codec.Error('job and core schemas must agree')
    if modern and 9 in sections:
        raise codec.Error('migration evidence requires frozen schema1')
    fields = CORE2 if modern else CORE
    core = read_scalars(sections[4].payload, fields)
    gaya = read_scalars(sections[5].payload, GAYA)
    rows = read_jobs2(sections[2].payload) if modern else [(i, *legacy_job(v)) for i, v in codec.read_pairs(sections[2].payload)]
    levels = {i: level for i, level, _ in rows}
    tiers = {i: tier for i, _, tier in rows}
    jobs = levels if modern else dict(codec.read_pairs(sections[2].payload))
    upgrades = dict(codec.read_pairs(sections[6].payload))
    if not {1, 2, 4, 6, 7, 11} <= {i for i, _ in codec.read_pairs(sections[4].payload)}:
        raise codec.Error('missing core progression field')
    if set(gaya) != {name for name, _ in GAYA.values()}:
        raise codec.Error('missing Gaya field')
    if gaya['mastered'] and (gaya['level'] != 99 or any(
            gaya[name] != maximum for identity, (name, maximum) in GAYA.items() if identity >= 3)):
        raise codec.Error('inconsistent mastered Gaya')
    if set(upgrades) != set(range(1, 16)) or not set(range(1, 23)) <= jobs.keys():
        raise codec.Error('missing frozen upgrade/job ID')
    if 9 not in sections:
        # Newly captured snapshots must provide fields absent in older versions.
        if set(core) != {name for name, _ in fields.values()}:
            raise codec.Error('new capture requires all core fields')
        for record in codec.read_inventory(sections[1].payload)[0]:
            if not {1, 2} <= {m[0] for m in record[6]}:
                raise codec.Error('new capture requires item life/flags')
    if modern:
        free = core['freelancer']
        if not mastery_valid(free, core['freelancer_mastery']):
            raise codec.Error('inconsistent Freelancer level/mastery')
        if (free == 0) != (core['freelancer_variant'] == 0):
            raise codec.Error('missing or unexpected Freelancer variant')
        selected = core['current_job']
        if (selected == 0 and free < 1) or (selected != 0 and levels[selected] < 1):
            raise codec.Error('active job has no saved level')
    return dict(job_schema=sections[2].version, job_levels=levels, job_mastery=tiers,
                account_hash=envelope.account_hash, core=core, gaya=gaya, jobs=jobs,
                upgrades=upgrades, titles=[i for i, _ in codec.read_pairs(sections[7].payload)],
                armory=[i for i, _ in codec.read_pairs(sections[8].payload)],
                inventory=codec.read_inventory(sections[1].payload)[0],
                migration=read_evidence(sections[9].payload) if 9 in sections else None)

"""Detached legacy -> reference translation and field comparison. Never loads a game."""
import argparse
import json
from pathlib import Path

import legacy_snapshot as legacy
import save_progression as progression
import save_vnext as codec

HERE = Path(__file__).resolve().parent
POLICY = HERE / 'migration-policy.json'


def policy():
    rules = json.loads(POLICY.read_text(encoding='utf-8'))
    if rules['schema'] != 1:
        raise codec.Error('unsupported migration policy')
    return rules


def placements(source, speedrun):
    """Policy1: packed legacy order; gear to bag, other hero items to quick."""
    rules = policy()
    gear, food = set(rules['gear_item_ids']), set(rules['speedrun_food_ids'])
    rejected = set(rules['v2_rejected_item_ids']) if source['source_version'] in 'EF' else set()
    next_slot, records, decisions, ordinal = {1: 0, 2: 0, 4: 0, 5: 0}, [], [], 0
    for container, holder in [('hero', 1), ('gaya', 4), ('house', 5)]:
        for original in source['inventories'][container]:
            ordinal += 1
            identity = original['item_id']
            reason = 'legacy-v2-rejected' if identity in rejected else (
                'speedrun-food' if speedrun and identity in food else None)
            destination = 2 if container == 'hero' and identity in gear else holder
            decision = dict(container=container, legacy_ordinal=original['legacy_ordinal'],
                            item_id=identity, record_ordinal=ordinal, reason=reason)
            if reason:
                decision['action'] = 'excluded-with-evidence'
            else:
                slot = next_slot[destination]
                if slot >= codec.HOLDERS[destination]:
                    raise codec.Error('migration placement exceeds holder capacity')
                next_slot[destination] += 1
                # Legacy did not capture life/flags. No guessed metadata is emitted.
                records.append((ordinal, identity, destination, slot, original['quantity'], True, ()))
                decision.update(action='retained', holder=destination, slot=slot,
                                metadata_provenance='legacy-object-defaults-unresolved')
            decisions.append(decision)
    return records, decisions


def translate(code, player=None, speedrun=False):
    if type(speedrun) is not bool:
        raise codec.Error('speedrun context must be explicit boolean')
    cleaned = legacy.clean(code)
    source, _ = legacy.decode(cleaned, player)
    if source['cheater_flag']:
        raise codec.Error('legacy cheat status requires review; no clean successor export')
    if source['armory_pending']:
        raise codec.Error('legacy Armory is pending; supply the linked segment before migration')
    records, _ = placements(source, speedrun)
    core = {name: source[name] for name, _ in progression.CORE.values()
            if name in source}
    core['gold'] = source['currency']  # Exactly what the old loader assigns to GOLD.
    gaya = dict(source['gaya']['abilities'], mastered=source['gaya']['mastered'],
                level=source['gaya']['level'])
    sections = [codec.Section(1, 1, True, codec.inventory(records)),
                codec.Section(2, 1, True, codec.pairs(sorted((int(i), v) for i, v in source['jobs'].items()))),
                codec.Section(4, 1, True, progression.scalars(core, progression.CORE)),
                codec.Section(5, 1, True, progression.scalars(gaya, progression.GAYA)),
                codec.Section(6, 1, True, codec.pairs(sorted((int(i), v) for i, v in source['upgrades'].items()))),
                codec.Section(7, 1, True, codec.pairs([(i, 1) for i in source['titles']])),
                codec.Section(8, 1, True, codec.pairs([(i, 1) for i in sorted(
                    source['armory']['effective_item_ids'] if source['armory'] else [])])),
                codec.Section(9, 1, True, progression.evidence(cleaned, speedrun))]
    result = codec.Envelope(source['account_hash'], tuple(sections))
    progression.snapshot(result)
    return codec.decode(codec.encode(result), source['account_hash'])


def comparison(envelope):
    """Compare typed target fields with retained source evidence, without mutation."""
    target = progression.snapshot(envelope)
    if target['migration'] is None:
        raise codec.Error('comparison requires migration evidence')
    code, speedrun = target['migration']
    source, _ = legacy.decode(code)
    checks = []

    def check(path, before, after):
        checks.append(dict(field=path, source=before, restored=after, equal=before == after))

    check('account_hash', source['account_hash'], target['account_hash'])
    for name, _ in progression.CORE.values():
        before = source['currency'] if name == 'gold' else source.get(name)
        check('core.' + name, None if before is None else int(before), target['core'].get(name))
    for identity, value in source['jobs'].items():
        check('jobs.' + identity, value, target['jobs'].get(int(identity)))
    check('jobs.ids', sorted(map(int, source['jobs'])), sorted(target['jobs']))
    for identity, value in source['upgrades'].items():
        check('upgrades.' + identity, value, target['upgrades'].get(int(identity)))
    for name, _ in progression.GAYA.values():
        before = source['gaya'].get(name, source['gaya']['abilities'].get(name))
        check('gaya.' + name, int(before), target['gaya'].get(name))
    check('titles', source['titles'], sorted(target['titles']))
    check('armory', sorted(source['armory']['effective_item_ids'] if source['armory'] else []),
          sorted(target['armory']))
    expected, decisions = placements(source, speedrun)
    check('inventory.records', expected, target['inventory'])
    # The original code preserves fields with no successor gameplay meaning:
    # ignored bits, rejected raw items, old NG wire value and pre-filter Armory.
    check('source.ready', not source['armory_pending'] and not source['cheater_flag'], True)
    return dict(source_version=source['source_version'], equal=all(c['equal'] for c in checks),
                checks=checks, differences=[c for c in checks if not c['equal']],
                inventory_decisions=decisions, encoded_characters=len(codec.encode(envelope)),
                evidence_characters=len(code),
                status='detached semantic comparison only; runtime acceptance not evaluated')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, required=True, help='plain legacy code text')
    parser.add_argument('--player', help='optional account name check')
    parser.add_argument('--speedrun', action='store_true', help='apply existing food exclusion policy')
    args = parser.parse_args()
    envelope = translate(args.input.read_text(encoding='utf-8'), args.player, args.speedrun)
    report = comparison(envelope)
    if not report['equal']:
        raise codec.Error('migration comparison failed')
    print(json.dumps(dict(code=codec.encode(envelope), report=report), indent=2))


if __name__ == '__main__':
    main()

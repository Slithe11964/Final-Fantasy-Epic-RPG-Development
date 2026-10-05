"""Validate and inspect quest definitions without running Warcraft.

python tools/check_quests.py --map MAP.w3x [--quest TEXT] [--json]
Dynamic event-driven quest progress is intentionally not simulated.
"""
import argparse
import json
import re
from pathlib import Path

from source_checks import ROOT, sources, calls, invocations, literal_int, literal_string, object_ids
from jtok import functions, strip_comments
from vjass_lite import split_libraries, jasshelper_order

STEPS = {'Quest_Talk', 'Quest_Return', 'Quest_Kill', 'Quest_Hunt', 'Quest_Deliver', 'Quest_Reach', 'Quest_Custom'}
MODIFIERS = {'Quest_Say', 'Quest_SayAs', 'Quest_SayIfSideQuestDone', 'Quest_Reward', 'Quest_OnDone',
             'Quest_Message', 'Quest_Camera', 'Quest_PingUnit', 'Quest_PingItem', 'Quest_OnPickup', 'Quest_HuntTarget'}


def waiting_chain(name, all_functions, stack=(), trigger_actions=None):
    if name in stack or name not in all_functions:
        return None
    body = strip_comments(all_functions[name])
    if re.search(r'\b(?:TriggerSleepAction|Wait_Polled|PolledWait|Text_Say|Text_Transmission|TransmissionFromUnitWithNameBJ)\s*\(', body):
        return stack + (name,)
    # Timer callbacks run later, not in the hook's engine thread. Group/force callbacks run now.
    for target, args in invocations(body):
        if target in ('Reward_Give', 'Reward_GiveAll') and len(args) == 3 and args[2] in ('null', 'udg_NarratorUnit'):
            continue  # This reward branch displays ordinary text and cannot enter Text_Transmission.
        names = [target]
        if target in ('ForForce', 'ForGroup', 'ForGroupBJ', 'EnumDestructablesInRectAll'):
            names += [a[len('function'):] for a in args if a.startswith('function')]
        if target in ('ExecuteFunc', 'TriggerExecute', 'ConditionalTriggerExecute'):
            if args and literal_string(args[0]):
                names.append(literal_string(args[0]))
            elif args and trigger_actions:
                names += trigger_actions.get(args[0], [])
        for child in names:
            found = waiting_chain(child, all_functions, stack + (name,), trigger_actions)
            if found:
                return found
    return None


def definition_bodies(text):
    for fn, body in functions(text).items():
        lines = body.splitlines()
        starts = [i for i, line in enumerate(lines) if any(call == 'Quest_Define' for _, call, _ in calls(line))]
        for variant, start in enumerate(starts):
            end = starts[variant + 1] if variant + 1 < len(starts) else len(lines)
            yield fn + (f' variant {variant + 1}' if len(starts) > 1 else ''), '\n'.join(lines[start:end])


def validate(texts, map_path=None):
    libraries, _, _ = split_libraries(list(texts.values()))
    errors, notes, quests = [], [], []
    try:
        jasshelper_order(libraries)
    except ValueError as exc:
        errors.append(str(exc))
    all_functions = {}
    for text in texts.values():
        all_functions.update(functions(text))
    trigger_actions = {}
    for body in all_functions.values():
        for _, call, args in calls(body):
            if call == 'TriggerAddAction' and len(args) == 2 and args[1].startswith('function'):
                trigger_actions.setdefault(args[0], []).append(args[1][len('function'):])
    declared = set(re.findall(r'\b(?:gg_unit|gg_rct|gg_cam)_\w+', '\n'.join(texts.values())))
    ids = None
    if map_path:
        from source_checks import map_sources
        archive, _, _ = map_sources(map_path)
        runtime = archive.read('war3map.j').decode('utf-8')
        globals_ = re.search(r'^globals\s*\n(.*?)^endglobals', runtime, re.M | re.S)[1]
        declared = set(re.findall(r'\b(?:gg_unit|gg_rct|gg_cam)_\w+', globals_))
        ids, _, object_errors = object_ids(map_path)
        errors.extend(object_errors)
    for module, text in texts.items():
        for fn, body in definition_bodies(text):
            rows = list(calls(body))
            definitions = [args for _, call, args in rows if call == 'Quest_Define']
            if not definitions:
                continue
            if len(definitions) != 1:
                errors.append(f'{module}/{fn}: expected one Quest_Define per definition function'); continue
            args = definitions[0]
            if len(args) != 4:
                errors.append(f'{fn}: Quest_Define requires four arguments'); continue
            name, kind, index = literal_string(args[0]), args[1], literal_int(args[2])
            label = f'{module}/{fn}'
            if not name or kind not in ('QUEST_MAIN', 'QUEST_SIDE') or index is None or not 0 <= index < 8192:
                errors.append(f'{label}: invalid name/kind/log index {args[:3]}')
            lib = re.search(r'^library\s+(\w+)', text, re.M)[1]
            if 'TQuestEngine' not in libraries[lib]['requires']:
                errors.append(f'{label}: missing requires TQuestEngine')
            steps, hooks = [], []
            global_id = re.search(r'\bset\s+(QUEST_\w+)\s*=\s*q\b', body)
            for number, call, a in rows:
                signature = all_functions.get(call, '').splitlines()
                if call.startswith('Quest_') and signature:
                    params = re.search(r'\btakes (.*?) returns\b', signature[0])
                    if params and len(a) != (0 if params[1] == 'nothing' else len(params[1].split(','))):
                        errors.append(f'{label}:{number}: wrong argument count for {call}')
                        continue
                for value in a:
                    if value.startswith(('gg_unit_', 'gg_rct_', 'gg_cam_')) and value not in declared:
                        errors.append(f'{label}:{number}: unknown map reference {value}')
                if ids and call in ('Quest_Deliver', 'Quest_HuntTarget'):
                    raw = a[2] if call == 'Quest_Deliver' else a[1]
                    kind_ = 'item' if call == 'Quest_Deliver' else 'unit'
                    if re.fullmatch(r"'[^']{4}'", raw) and raw[1:-1] not in ids.get(kind_, set()):
                        errors.append(f'{label}:{number}: unknown {kind_} rawcode {raw}')
                if call in STEPS:
                    steps.append({'type': call[6:], 'arguments': a[1:]})
                    if call in ('Quest_Talk', 'Quest_Return', 'Quest_Kill', 'Quest_Reach') and len(a) > 1 and a[1] == 'null':
                        errors.append(f'{label}:{number}: {call} requires a target')
                    if call in ('Quest_Hunt', 'Quest_Deliver'):
                        needed = literal_int(a[2] if call == 'Quest_Hunt' else a[3])
                        if needed is None or needed <= 0:
                            errors.append(f'{label}:{number}: invalid target count')
                    if call == 'Quest_Hunt' and (literal_int(a[1]) is None or not 1 <= literal_int(a[1]) <= 16):
                        errors.append(f'{label}:{number}: hunt board row must be 1..16')
                elif call in MODIFIERS:
                    if not steps:
                        errors.append(f'{label}:{number}: {call} used before a step')
                    if call in ('Quest_OnDone', 'Quest_OnPickup'):
                        hook = literal_string(a[-1])
                        if hook is None:
                            errors.append(f'{label}:{number}: hook must name a literal function')
                        elif hook:
                            hooks.append(hook)
                            if hook not in all_functions:
                                errors.append(f'{label}: missing hook {hook}')
                            else:
                                chain = waiting_chain(hook, all_functions, trigger_actions=trigger_actions)
                                if chain:
                                    errors.append(f'{label}: hook waits synchronously: {" -> ".join(chain)}')
                    if call == 'Quest_Camera' and a[1].startswith('gg_cam_') and a[1] not in declared:
                        errors.append(f'{label}: unknown camera {a[1]}')
            if not steps or len(steps) > 16:
                errors.append(f'{label}: {len(steps)} step declarations; limit is 16 (including branches conservatively)')
            quests.append({'name': name, 'module': module, 'function': fn, 'kind': kind,
                           'index': index, 'steps': steps, 'hooks': hooks,
                           'global': global_id[1] if global_id else None,
                           'custom': any(s['type'] == 'Custom' for s in steps)})
    by_global = {q['global']: q for q in quests if q['global']}
    for module, text in texts.items():
        for _, call, args in calls(text):
            if call == 'Quest_StartSilent' and args and args[0] in by_global:
                q = by_global[args[0]]
                if not q['steps'] or q['steps'][0]['type'] != 'Custom':
                    errors.append(f'{module}: silent start requires a first Custom step ({args[0]})')
    # 16 slots per quest, with slot 0 unused; the highest classic-compatible array index is 8191.
    if len(quests) > 510:
        errors.append('quest definitions exceed safe 16-step array capacity (510 quests)')
    lines = sum(1 for text in texts.values() for _, call, _ in calls(text)
                if call in ('Quest_Say', 'Quest_SayAs', 'Quest_SayIfSideQuestDone'))
    if lines > 8191:
        errors.append('dialogue definitions exceed classic-compatible array capacity (8191 lines)')
    notes.append(f'{len(quests)} definition functions; {lines} dialogue declarations (branch counts are conservative)')
    notes.append('Custom event progress and mutually exclusive/shared log slots remain module-owned; no live state is inferred.')
    return errors, notes, quests


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--map', type=Path)
    p.add_argument('--quest', help='inspect matching quest name or module')
    p.add_argument('--json', action='store_true')
    a = p.parse_args()
    _, texts = sources()
    errors, notes, quests = validate(texts, a.map)
    selected = [q for q in quests if not a.quest or a.quest.lower() in (str(q['name']) + q['module']).lower()]
    if a.json:
        print(json.dumps({'errors': errors, 'notes': notes, 'quests': selected}, indent=2))
    else:
        for note in notes:
            print(note)
        for error in errors:
            print('FAIL ' + error)
        if a.quest:
            for q in selected:
                print(f"{q['name']} ({q['module']}, {q['kind']}[{q['index']}])")
                for i, step in enumerate(q['steps'], 1):
                    print(f"  {i}: {step['type']} {' '.join(step['arguments'])}")
                print('  hooks: ' + ', '.join(q['hooks']))
        if not errors:
            print('PASS quest definitions, references, dependencies and non-waiting hooks')
    return int(bool(errors))


if __name__ == '__main__':
    raise SystemExit(main())

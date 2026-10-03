"""Survey the quests: how each one is built, and how well it would fit a data-driven quest engine.

    python tools/quest_survey.py            writes docs/QUEST_SURVEY.md and docs/quest-survey.csv

A quest here is a quest-log entry: `set udg_MainQuest[n]=CreateQuestBJ(...)` or `udg_SideQuest[n]`.
For each one the tool finds
  * the trigger that creates it (how the quest starts),
  * the trigger(s) that complete it (QuestSetCompletedBJ),
  * the triggers in between: the shortest EnableTrigger / TriggerExecute link paths from the start
    trigger to the completing trigger(s), plus every trigger that touches the quest-log entry - these
    are the quest's steps,
  * what each step waits for (its events), and what the steps do (dialogue, cinematics, spawns,
    rewards, waits ...),
and sorts the quest into one of three groups:
  fits    - only standard steps (talk to an NPC, kill a unit or N units, pick up an item, reach a
            place, buy something) and standard rewards; can be written entirely as data;
  hooks   - standard steps, plus some custom actions (spawning a boss, special effects, doors ...)
            that would stay as small functions the quest table points to;
  custom  - timers, periodic checks, spells, several ways to finish or fail: keep hand-written code.
"""
import collections, csv, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from jtok import strip_comments

ROOT = os.path.dirname(HERE)
FUNC = re.compile(r'^\s*(?:constant\s+)?function\s+(\w+)\s+takes.*?^\s*endfunction', re.M | re.S)

def num(s):
    s = s.strip()
    return int(s[1:], 16) if s.startswith('$') else int(s)

EVENT_KINDS = [
    ('talk',      r'TriggerRegisterPlayerSelectionEventBJ'),   # select the NPC while a hero is close (udg_TalkRange)
    ('kill unit', r'TriggerRegisterUnitEvent\s*\([^,]+,\s*gg_unit_\w+\s*,\s*EVENT_UNIT_DEATH'),
    ('kill any',  r'EVENT_PLAYER_UNIT_DEATH'),
    ('get item',  r'EVENT_PLAYER_UNIT_PICKUP_ITEM'),
    ('use item',  r'EVENT_PLAYER_UNIT_USE_ITEM'),
    ('drop item', r'EVENT_PLAYER_UNIT_DROP_ITEM'),
    ('buy',       r'EVENT_PLAYER_UNIT_SELL(?:_ITEM)?|EVENT_PLAYER_UNIT_PAWN_ITEM'),
    ('reach place', r'TriggerRegisterEnterRectSimple|TriggerRegisterEnterRegion'),
    ('leave place', r'TriggerRegisterLeaveRectSimple|TriggerRegisterLeaveRegion'),
    ('spell',     r'EVENT_PLAYER_UNIT_SPELL_\w+'),
    ('attacked',  r'EVENT_PLAYER_UNIT_ATTACKED|EVENT_UNIT_ATTACKED|EVENT_UNIT_DAMAGED'),
    ('timer',     r'TriggerRegisterTimerExpireEventBJ|TriggerRegisterTimerEventSingle'),
    ('periodic',  r'TriggerRegisterTimerEventPeriodic'),
    ('chat',      r'TriggerRegisterPlayerChatEvent'),
    ('dialog',    r'TriggerRegisterDialogButtonEvent|TriggerRegisterDialogEventBJ'),
    ('life',      r'TriggerRegisterUnitLifeEvent|TriggerRegisterUnitStateEvent'),
    ('in range',  r'TriggerRegisterUnitInRangeSimple'),        # a hero walks up to a unit
    ('variable',  r'TriggerRegisterVariableEvent'),
]
STANDARD_STEPS = {'talk', 'in range', 'kill unit', 'kill any', 'get item', 'buy', 'reach place', 'run by another step',
                  'attacked', 'minimap ping'}
FEATURES = [
    ('dialogue', r'\bText_Say\s*\('),
    ('cinematic', r'\bCine_Enter\s*\('),
    ('waits', r'\b(?:TriggerSleepAction|PolledWait|Wait_Polled)\s*\('),
    ('spawns units', r'\bCreateNUnitsAt\w*\s*\(|\bCreateUnit\w*\s*\('),
    ('gives gold', r'PLAYER_STATE_RESOURCE_GOLD'),
    ('gives XP', r'\bAddHeroXP\w*\s*\(|\bReward_Give\s*\('),
    ('gives item', r'\bCreateItem\w*\s*\(|\bUnitAddItem\w*\s*\('),
    ('gives title', r'udg_TitleForce\['),
    ('effects', r'\bAddSpecialEffect\w*\s*\(|\bDestroyEffect\w*\s*\('),
    ('doors/gates', r'\b(?:KillDestructable|ModifyGateBJ|SetDestructableAnimation\w*|DestructableRestoreLife)\s*\('),
    ('moves units', r'\bSetUnitPosition\w*\s*\(|\bIssue\w*Order\w*\s*\('),
    ('can fail', r'\bQuestSetFailedBJ\s*\('),
    ('loops/counters', r'\bloop\b'),
]
CUSTOM_FEATURES = {'can fail'}
HOOK_FEATURES = {'spawns units', 'doors/gates', 'moves units', 'loops/counters'}   # effects/waits: quest markers and dialogue pacing, standard

def load():
    entries = json.load(open(os.path.join(ROOT, 'src', 'trigger-list.json'), encoding='utf-8'))
    mods = collections.OrderedDict()
    for e in entries:
        if e.get('library'):
            p = os.path.join(ROOT, 'src', 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = strip_comments(open(p, encoding='utf-8').read().replace('\r\n', '\n'))
    return mods

def main():
    mods = load()
    reg, trig_module = {}, {}
    for n, text in mods.items():
        for fm in FUNC.finditer(text):
            if fm.group(1).startswith('Register_'):
                t = fm.group(1)[len('Register_'):]
                reg[t] = fm.group(0)
                trig_module[t] = n
    by_len = sorted(trig_module, key=len, reverse=True)
    def owner(fn):
        if fn.startswith('Trig_'):
            for t in by_len:
                if fn.startswith('Trig_' + t + '_'):
                    return t
        return None
    code = collections.defaultdict(str)                  # trigger -> all its functions
    for n, text in mods.items():
        for fm in FUNC.finditer(text):
            t = owner(fm.group(1))
            if t:
                code[t] += fm.group(0) + '\n'
    # trigger links: t -> triggers it enables or runs
    nxt = collections.defaultdict(set)
    for t, c in code.items():
        for d in re.findall(r'\b(?:EnableTrigger|(?:Conditional)?TriggerExecute)\s*\(\s*gg_trg_(\w+)\s*\)', c):
            if d in trig_module and d != t:
                nxt[t].add(d)
    def events(t):
        r = reg.get(t, '')
        kinds = [k for k, p in EVENT_KINDS if re.search(p, r)]
        if t.endswith('_Ping') and 'periodic' in kinds:      # minimap ping on the quest target every few seconds
            kinds = ['minimap ping' if k == 'periodic' else k for k in kinds]
        return kinds or ['run by another step']
    # quests
    quests = collections.OrderedDict()
    for t, c in code.items():
        for m in re.finditer(r'set\s+udg_(MainQuest|SideQuest)\[([^\]]+)\]\s*=\s*CreateQuestBJ\((.*)$', c, re.M):
            key = '%s[%d]' % (m.group(1), num(m.group(2)))
            lits = re.findall(r'"((?:\\.|[^"\\])*)"', m.group(3))
            title = next((x for x in lits if x and not x.startswith('ReplaceableTextures')), '?')
            quests.setdefault(key, dict(key=key, kind='main' if m.group(1) == 'MainQuest' else 'side',
                                        title=title, start=t, starts=[]))['starts'].append(t)
    rows = []
    # quests already written for the quest engine (QuestEngine module)
    for n, text in mods.items():
        for m in re.finditer(r'Quest_Define\(\s*"([^"]*)"\s*,\s*QUEST_(SIDE|MAIN)\s*,\s*(\$?\w+)', text):
            key = '%sQuest[%d]' % ('Side' if m.group(2) == 'SIDE' else 'Main', num(m.group(3)))
            steps = len(re.findall(r'\bcall\s+Quest_(?:Talk|Return|Kill|Hunt|Deliver|Custom)\s*\(', text))
            rows.append(dict(key=key, kind=m.group(2).lower(), title=m.group(1), start='', start_event='quest engine',
                             steps=steps, step_kinds='', dialogue_lines=len(re.findall(r'\bcall\s+Quest_Say(?:As|IfSideQuestDone)?\s*\(', text)),
                             features='', modules=n, finished_by='quest engine', group='engine', why=''))
    for key, q in quests.items():
        kind, idx = key[:-1].split('[')
        var = r'udg_%s\[\s*(?:%d|\$%X|\$%x)\s*\]' % (kind, int(idx), int(idx), int(idx))
        touch = [t for t, c in code.items() if re.search(var, c)]
        done = [t for t in touch if re.search(r'QuestSetCompletedBJ\s*\(\s*' + var + r'\s*,\s*true', code[t])]
        # steps: the triggers on the shortest link paths from the starting trigger(s) to the completing
        # trigger(s), plus every trigger that touches the quest-log entry
        def path(a, b):
            prev, frontier = {a: None}, [a]
            while frontier:
                nf = []
                for x in frontier:
                    for y in sorted(nxt[x]):
                        if y not in prev:
                            prev[y] = x; nf.append(y)
                if b in prev:
                    break
                frontier = nf
            if b not in prev:
                return []
            p, x = [], b
            while x is not None:
                p.append(x); x = prev[x]
            return p[::-1]
        steps = []
        for a in q['starts']:
            steps.append(a)
            for b in done:
                steps += path(a, b)
        steps += done + touch
        steps = list(dict.fromkeys(steps))
        allcode = '\n'.join(code[t] for t in steps)
        step_kinds = []
        for t in steps:
            for k in events(t):
                if k not in step_kinds:
                    step_kinds.append(k)
        feats = [f for f, p in FEATURES if re.search(p, allcode)]
        lines = len(re.findall(r'\bText_Say\s*\(', allcode))
        modules = list(dict.fromkeys(trig_module[t] for t in steps))
        # boss fights stay as they are: the quest only needs "this boss died", so a boss module's own
        # timers/spells/periodic checks don't make the quest custom
        own = [t for t in steps if not trig_module[t].startswith('Boss_')]
        own_kinds = {k for t in own for k in events(t)}
        own_code = '\n'.join(code[t] for t in own)
        own_feats = {f for f, p in FEATURES if re.search(p, own_code)}
        bosses = sorted({trig_module[t] for t in steps if trig_module[t].startswith('Boss_')})
        if not done:
            group = 'custom'
            why = 'no step marks it completed (finished elsewhere or never)'
        elif (own_kinds - STANDARD_STEPS) or (own_feats & CUSTOM_FEATURES) or len(done) > 1:
            group = 'custom'
            extra = sorted(own_kinds - STANDARD_STEPS) + sorted(own_feats & CUSTOM_FEATURES)
            why = ', '.join(extra) + (' ' if extra else '') + ('several finishing triggers' if len(done) > 1 else '')
        elif (own_feats & HOOK_FEATURES) or bosses:
            group = 'hooks'
            why = ', '.join(sorted(own_feats & HOOK_FEATURES) + (['boss fight (%s)' % ', '.join(bosses)] if bosses else []))
        else:
            group = 'fits'
            why = ''
        rows.append(dict(key=key, kind=q['kind'], title=re.sub(r'\|c[0-9A-Fa-f]{8}|\|r', '', q['title']),
                         start=q['start'], start_event=', '.join(events(q['start'])),
                         steps=len(steps), step_kinds=', '.join(step_kinds), dialogue_lines=lines,
                         features=', '.join(feats), modules=', '.join(modules), finished_by=', '.join(done),
                         group=group, why=why.strip()))
    write(rows)

def FINDINGS(g, rows):
    total = len(rows)
    return [
        '- **Already on the quest engine: %d.** Of the rest, %d of %d quests (%d%%) can move to the quest engine with'
        % (g['engine'], g['fits'] + g['hooks'], total, round(100 * (g['fits'] + g['hooks']) / total)),
        '  standard steps only: %d fully as data, %d with small custom hooks (spawning' % (g['fits'], g['hooks']),
        '  a boss, opening a gate, moving an NPC) or a boss fight that stays in its boss module.',
        '- **%d need custom steps** (`Quest_Custom` + `Quest_StepDone`): the main story chapters, the Kalm sieges, the' % g['custom'],
        '  Tower of Summoning and Eidolon quests, the hunt festival, quests with timers or that can fail. Their special',
        '  code stays in their modules; the engine runs the quest log, markers, step order and rewards around it.',
        '- **Quests are shared by the whole party**: one quest-log entry for everyone, announced to all players.',
        '  The engine can keep that: per-player progress is not needed.',
        '- **Quest progress is not in the save code**, so changing how quests work cannot break player codes.',
        '- **Other systems check quests** (`IsQuestCompleted(...)`, 99 places, 33 of them outside the quest folder: News, hunts,',
        '  spawns, bosses ...). The engine must keep creating the same `udg_MainQuest[n]`/`udg_SideQuest[n]`',
        '  entries so those checks keep working.',
        '- **Step types the engine has** (docs/QUEST_ENGINE.md): talk to an NPC, walk up to it, kill a unit, kill',
        '  N units of some types (hunt leaderboard), deliver an item (with a pickup note and a minimap ping), and',
        '  custom steps. **Per step**: dialogue lines (skipped when cinematics are off), quest-log text and',
        '  announcement, the "!" / "?" markers, rewards, a camera, custom code. Still to add when a quest needs',
        '  them: reach a place, attack a unit.',
    ]

def write(rows):
    out = os.path.join(ROOT, 'docs')
    with open(os.path.join(out, 'quest-survey.csv'), 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]))
        w.writeheader(); w.writerows(rows)
    g = collections.Counter(r['group'] for r in rows)
    kinds = collections.Counter(k for r in rows for k in r['step_kinds'].split(', ') if k)
    feats = collections.Counter(k for r in rows for k in r['features'].split(', ') if k)
    L = ['# Quest survey: how the quests are built', '',
         'Generated by `tools/quest_survey.py` (full table: `docs/quest-survey.csv`). One row per quest-log entry',
         '(`udg_MainQuest[n]` / `udg_SideQuest[n]`). Steps are the triggers on the shortest EnableTrigger/TriggerExecute',
         'link paths from the trigger that creates the quest to the one that completes it, plus every trigger that',
         'touches the quest-log entry.', '',
         '## Summary', '',
         '| Group | Quests | Meaning |', '|---|---|---|',
         '| engine | %d | Already written for the quest engine (docs/QUEST_ENGINE.md). |' % g['engine'],
         '| fits | %d | Only standard steps and rewards: can be written entirely as data. |' % g['fits'],
         '| hooks | %d | Standard steps plus some custom actions (spawning units, gates, moving NPCs) or a boss fight; those stay as small functions or boss modules the quest points to. |' % g['hooks'],
         '| custom | %d | Timers, spells, failing, several endings, or no clear finish: these use custom steps whose special code stays in the module. |' % g['custom'],
         '', '## What this means for a quest engine', '', *FINDINGS(g, rows), '', 'Step types across all quests (a quest can have several):', '',
         '| Step waits for | Quests |', '|---|---|']
    L += ['| %s | %d |' % kv for kv in kinds.most_common()]
    L += ['', 'What the steps do:', '', '| Feature | Quests |', '|---|---|']
    L += ['| %s | %d |' % kv for kv in feats.most_common()]
    for grp in ('engine', 'fits', 'hooks', 'custom'):
        sel = [r for r in rows if r['group'] == grp]
        L += ['', '## %s (%d)' % (grp, len(sel)), '',
              '| Quest | Title | Starts with | Steps | Waits for | Dialogue lines | Modules |' + (' Why |' if grp != 'fits' else ''),
              '|---|---|---|---|---|---|---|' + ('---|' if grp != 'fits' else '')]
        for r in sorted(sel, key=lambda r: (r['steps'], r['key'])):
            L.append('| %s | %s | %s | %d | %s | %d | %s |%s' % (r['key'], r['title'], r['start_event'], r['steps'], r['step_kinds'],
                     r['dialogue_lines'], r['modules'], (' %s |' % r['why']) if grp != 'fits' else ''))
    open(os.path.join(out, 'QUEST_SURVEY.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print('quests: %d  engine: %d  fits: %d  hooks: %d  custom: %d' % (len(rows), g['engine'], g['fits'], g['hooks'], g['custom']))

if __name__ == '__main__':
    main()

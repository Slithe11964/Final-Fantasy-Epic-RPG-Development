"""Regenerate the reference docs from src/ (run after changing triggers).

    python tools/gen_docs.py [SRC_DIR] [DOCS_DIR]

Writes docs/TRIGGER_INDEX.md (every trigger: module, events, starting state, which other modules
turn it on/off or run it), docs/GLOBALS.md (every global: declared where, used by) and
docs/DEAD_CODE.md (functions nothing refers to).
"""
import collections, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from jtok import strip_comments

ROOT = os.path.dirname(HERE)

def load(src):
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    mods = collections.OrderedDict()
    for e in entries:
        if e.get('library'):
            p = os.path.join(src, 'triggers', e['folder'], e['name'] + '.j')
            mods[e['name']] = dict(folder=e['folder'], text=open(p, encoding='utf-8').read().replace('\r\n', '\n'))
    header = open(os.path.join(src, 'map-header.j'), encoding='utf-8').read().replace('\r\n', '\n')
    return mods, header

FUNC = re.compile(r'^\s*(?:constant\s+)?function\s+(\w+)\s+takes.*?^\s*endfunction', re.M | re.S)

def split_args(s):
    depth, cur, out = 0, '', []
    for ch in s:
        depth += (ch == '(') - (ch == ')')
        if ch == ',' and depth == 0:
            out.append(cur.strip()); cur = ''
        else:
            cur += ch
    out.append(cur.strip())
    return out

EVENT_WORDS = {
    'SPELL_EFFECT': 'a unit uses an ability', 'SPELL_CAST': 'a unit begins casting', 'SPELL_CHANNEL': 'a unit starts channeling',
    'SPELL_ENDCAST': 'a unit stops casting', 'SPELL_FINISH': 'a unit finishes casting', 'DEATH': 'a unit dies',
    'ATTACKED': 'a unit is attacked', 'DAMAGED': 'the unit takes damage', 'PICKUP_ITEM': 'a unit picks up an item',
    'DROP_ITEM': 'a unit drops an item', 'USE_ITEM': 'a unit uses an item', 'SELL': 'a unit is sold/hired',
    'SELL_ITEM': 'an item is sold', 'PAWN_ITEM': 'an item is pawned', 'LEVEL': 'a hero gains a level',
    'SKILL': 'a hero learns a skill', 'ISSUED_ORDER': 'a unit is ordered (no target)', 'ISSUED_POINT_ORDER': 'a unit is ordered to a point',
    'ISSUED_TARGET_ORDER': 'a unit is ordered to a target', 'CHANGE_OWNER': 'a unit changes owner', 'SUMMON': 'a unit is summoned',
    'RESEARCH_START': 'research starts', 'RESEARCH_FINISH': 'research finishes', 'LOADED': 'a unit is loaded into a transport',
}

def describe_event(nat, args):
    a = split_args(args)
    ev = re.findall(r'EVENT_\w+', args)
    if ev:
        key = re.sub(r'^EVENT_(PLAYER_UNIT_|UNIT_|PLAYER_HERO_|HERO_|PLAYER_)', '', ev[0])
        text = EVENT_WORDS.get(key, key.lower().replace('_', ' '))
        if nat == 'TriggerRegisterUnitEvent':
            text += ' (%s)' % a[1]
        elif nat in ('TriggerRegisterPlayerUnitEvent', 'TriggerRegisterPlayerUnitEventSimple'):
            text += ' (player %s)' % a[1]
        return text
    if nat == 'TriggerRegisterTimerEventPeriodic':
        return 'every %ss' % a[1]
    if nat == 'TriggerRegisterTimerEventSingle':
        return 'once, %ss after start' % a[1]
    if nat == 'TriggerRegisterTimerEvent':
        return ('every %ss' if a[2] == 'true' else 'once, %ss after start') % a[1]
    if nat == 'TriggerRegisterTimerExpireEventBJ':
        return 'timer %s expires' % a[1]
    if nat == 'TriggerRegisterEnterRectSimple':
        return 'a unit enters %s' % a[1]
    if nat == 'TriggerRegisterLeaveRectSimple':
        return 'a unit leaves %s' % a[1]
    if nat == 'TriggerRegisterUnitInRangeSimple':
        return 'a unit comes within %s of %s' % (a[1], a[2])
    if nat == 'TriggerRegisterPlayerChatEvent':
        return 'chat %s' % a[2]
    if nat == 'TriggerRegisterPlayerSelectionEventBJ':
        return 'a player selects a unit'
    if nat == 'TriggerRegisterDeathEvent':
        return '%s dies' % a[1]
    if nat == 'TriggerRegisterUnitLifeEvent':
        return '%s life %s %s' % (a[1], a[2], a[3])
    if nat in ('TriggerRegisterDialogEventBJ', 'TriggerRegisterDialogEvent', 'TriggerRegisterDialogButtonEvent'):
        return 'dialog %s clicked' % a[1]
    if nat == 'TriggerRegisterPlayerEventLeave':
        return 'a player leaves'
    if nat == 'TriggerRegisterGameStateEventTimeOfDay':
        return 'time of day %s %s' % (a[1], a[2])
    return nat.replace('TriggerRegister', '').replace('BJ', '') + '(' + ', '.join(a[1:]) + ')'

def trigger_info(mods):
    """Per trigger: module, events (deduplicated), starts_off, links from other modules."""
    info = collections.OrderedDict()
    for n, m in mods.items():
        for fm in FUNC.finditer(m['text']):
            if not fm.group(1).startswith('Register_'):
                continue
            trig = fm.group(1)[len('Register_'):]
            body = strip_comments(fm.group(0))
            evs = []
            for nat, args in re.findall(r'call\s+(TriggerRegister\w+)\s*\((.*)\)\s*$', body, re.M):
                d = describe_event(nat, args)
                if d not in evs:
                    evs.append(d)
            info[trig] = dict(module=n, folder=m['folder'], events=evs,
                              starts_off=bool(re.search(r'DisableTrigger\(gg_trg_%s\)' % re.escape(trig), body)),
                              links=collections.defaultdict(set))
    ops = [('enabled by', r'EnableTrigger'), ('disabled by', r'DisableTrigger'), ('run by', r'(?:Conditional)?TriggerExecute|TriggerEvaluate'),
           ('destroyed by', r'DestroyTrigger')]
    for n, m in mods.items():
        code = strip_comments(m['text'])
        code = re.sub(r'^\s*function Register_\w+ takes.*?^\s*endfunction', '', code, flags=re.M | re.S)
        code = re.sub(r'^\s*globals\s*\n.*?^\s*endglobals', '', code, flags=re.M | re.S)
        for trig in set(re.findall(r'\bgg_trg_(\w+)', code)):
            if trig not in info:
                continue
            found = False
            for label, pat in ops:
                if re.search(r'\b(?:%s)\s*\(\s*gg_trg_%s\b' % (pat, re.escape(trig)), code):
                    info[trig]['links'][label].add(n); found = True
            if not found:
                info[trig]['links']['used by'].add(n)
    return info

def link_text(i, limit=3):
    parts = []
    if i['starts_off']:
        parts.append('starts off')
    for label in ('enabled by', 'disabled by', 'run by', 'destroyed by', 'used by'):
        ms = sorted(i['links'].get(label, ()), key=lambda x: (x != i['module'], x))
        if ms:
            parts.append('%s %s' % (label, ', '.join(ms[:limit]) + (' +%d more' % (len(ms) - limit) if len(ms) > limit else '')))
    return '; '.join(parts)

def write_trigger_index(mods, docs):
    info = trigger_info(mods)
    by = collections.OrderedDict()
    for t, i in info.items():
        by.setdefault(i['folder'], collections.OrderedDict()).setdefault(i['module'], []).append((t, i))
    out = ['# Trigger index', '',
           'Generated by `tools/gen_docs.py`. Every trigger created at startup, grouped by folder and module.',
           'To find one in World Editor, open the module and search for `Register_<Trigger>`.', '']
    for folder in sorted(by):
        out += ['## ' + folder, '']
        for mod, ts in by[folder].items():
            out += ['### ' + mod, '', '| Trigger | Fires when | Notes |', '|---|---|---|']
            for t, i in ts:
                out.append('| `%s` | %s | %s |' % (t, '; '.join(i['events']) or '(no event: run by other triggers)', link_text(i, 6)))
            out.append('')
    open(os.path.join(docs, 'TRIGGER_INDEX.md'), 'w', encoding='utf-8').write('\n'.join(out))
    return info

def write_globals(mods, header, docs):
    REF = re.compile(r'\b(udg_\w+|gg_\w+)\b')
    decl = {}
    def scan(text, where):
        for gm in re.finditer(r'^\s*globals\s*\n(.*?)^\s*endglobals', text, re.M | re.S):
            for l in gm.group(1).split('\n'):
                c = strip_comments(l).strip()
                mm = re.match(r'^(constant\s+)?(\w+)\s+(array\s+)?(\w+)', c)
                if mm:
                    decl[mm.group(4)] = (mm.group(2) + (' array' if mm.group(3) else ''), where)
    scan(header, 'map header')
    vpath = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'src', 'variables.json')
    if os.path.exists(vpath):
        for v in json.load(open(vpath, encoding='utf-8')):
            decl[v['name']] = (v['type'], 'Variable Editor')
    for n, m in mods.items():
        scan(m['text'], n)
    users = collections.defaultdict(set)
    for n, m in mods.items():
        for v in set(REF.findall(strip_comments(m['text']))):
            if v in decl:
                users[v].add(n)
    out = ['# Global variables', '', 'Generated by `tools/gen_docs.py`. "Declared in" is the module (World Editor trigger) whose',
           '`globals` block declares the variable, or the map header (Trigger Editor > the map entry at the top).', '',
           '| Variable | Type | Declared in | Used by |', '|---|---|---|---|']
    for v in sorted(decl, key=str.lower):
        us = sorted(users[v])
        out.append('| `%s` | %s | %s | %s |' % (v, decl[v][0], decl[v][1], ', '.join(us) if len(us) <= 12 else '%d modules: %s, ...' % (len(us), ', '.join(us[:12]))))
    open(os.path.join(docs, 'GLOBALS.md'), 'w', encoding='utf-8').write('\n'.join(out) + '\n')

def write_dead_code(mods, docs):
    defs = collections.OrderedDict()
    alltext = ''
    for n, m in mods.items():
        code = strip_comments(m['text'])
        alltext += code + '\n'
        for f in re.findall(r'^\s*(?:constant\s+)?function\s+(\w+)\s+takes', code, re.M):
            defs[f] = n
    names = collections.Counter(re.findall(r'\b\w+\b', alltext))
    strings = set(re.findall(r'"(\w+)"', alltext))
    dyn = re.findall(r'ExecuteFunc\s*\(\s*(?!")', alltext)
    dead = [(f, n) for f, n in defs.items()
            if names[f] <= 1 and f not in strings and not f.startswith('InitTrig_') and f not in ('main_old', 'config_old')]
    out = ['# Unreferenced functions', '', 'Generated by `tools/gen_docs.py`. These functions are defined but nothing in the map',
           'calls them, passes them as `function X`, or names them in a string (ExecuteFunc).',
           'They are candidates for removal: delete one, save in World Editor, and if the map still compiles',
           'and plays, it was dead code.' + (' NOTE: %d ExecuteFunc call(s) use a computed name, so check those first.' % len(dyn) if dyn else ''), '',
           '%d functions:' % len(dead), '', '| Function | Module |', '|---|---|']
    out += ['| `%s` | %s |' % d for d in dead]
    open(os.path.join(docs, 'DEAD_CODE.md'), 'w', encoding='utf-8').write('\n'.join(out) + '\n')
    return dead

if __name__ == '__main__':
    src = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'src')
    docs = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'docs')
    mods, header = load(src)
    info = write_trigger_index(mods, docs)
    write_globals(mods, header, docs)
    dead = write_dead_code(mods, docs)
    print('triggers: %d, unreferenced functions: %d' % (len(info), len(dead)))

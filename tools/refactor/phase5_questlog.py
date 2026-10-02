"""Phase 5: remove the hidden build step. Kept as a record of exactly what changed.

    python tools/refactor/phase5_questlog.py SRC_DIR BASE_MAP.w3x BASE_RUNTIME.j OUT_MAP.w3x OUT_RUNTIME.j MAP_WITH_BASE_RUNTIME.w3x

(BASE_MAP is the latest World Editor save; the last argument supplies the string table the base runtime was built with.)

Why: Warcraft's native save/load crashes when the script holds a very long string. The quest
log (F9) help entries were long strings, so every editor save needed Build Play Copy to move
them into the map's string table (war3map.wts) afterwards.

Fix: the 18 help entries become "Create Quest" actions in a new GUI trigger, QuestLog_Entries
(folder 02 Map setup). World Editor stores GUI text in the string table itself, so an editor
save is directly playable, and the help text is now edited in a normal GUI dialog.
Init_QuestLog keeps creating the Difficulty entry and then runs QuestLog_Entries, so the quest log
order is unchanged. The six ModuleLongText_* helpers are removed.

Also checks that the new quest log (types, titles, texts, icons, order) is identical to the old one.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from mpq import MPQ, replace_files
from wct import read_wct, write_wct, raw_of
from wtg import read_wtg, write_wtg, string_param, preset_param, action, GUI

def lf(s): return s.replace('\r\n', '\n')
def crlf(s): return lf(s).replace('\n', '\r\n')
LIT = r'"(?:\\.|[^"\\])*"'
ESC = {'r': '\r', 'n': '\n', 't': '\t', '\\': '\\', '"': '"'}

def unescape(lit):
    lit = lit.strip()
    parts = re.findall(LIT, lit)
    assert re.fullmatch(r'%s(?:\s*\+\s*%s)*' % (LIT, LIT), lit), lit[:80]
    return ''.join(re.sub(r'\\(.)', lambda m: ESC[m.group(1)], p[1:-1]) for p in parts)
CAT = r'%s(?:\s*\+\s*%s)*' % (LIT, LIT)

def escape(text):
    return '"' + text.replace('\\', '\\\\').replace('"', '\\"').replace('\r', '\\r').replace('\n', '\\n').replace('\t', '\\t') + '"'

def fspan(text, name):
    m = re.search(r'^(?:constant\s+)?function\s+%s\s+takes.*?^endfunction[^\n]*\n?' % re.escape(name), text, re.M | re.S)
    assert m, name
    return m

def wts_entries(wts):
    out = {}
    for m in re.finditer(r'STRING (\d+)\r?\n(?://[^\n]*\n)?\{\r?\n(.*?)\r?\n\}', wts, re.S):
        out[int(m.group(1))] = m.group(2).replace('\r\n', '\n')
    return out

def quest_log(runtime, wts):
    """Every CreateQuestBJ the quest-log trigger performs: (type, title, text, icon)."""
    funcs = {m.group(1): m.group(0) for m in re.finditer(r'^function (\w+) takes.*?^endfunction', runtime, re.M | re.S)}
    strings = wts_entries(wts)
    def value(expr):
        expr = expr.strip()
        m = re.match(r'^(ModuleLongText_\d+)\(\)$', expr)
        if m:
            body = funcs[m.group(1)]
            r = re.search(r'return\s+(%s)' % LIT, body)
            if r and r.group(1).startswith('"TRIGSTR_'):
                return value(r.group(1))
            return ''.join(unescape(x) for x in re.findall(r'set text\s*=\s*text\s*\+\s*(%s)' % LIT, body))
        s = unescape(expr)
        t = re.match(r'^TRIGSTR_(\d+)$', s)
        return strings[int(t.group(1))].replace('\n', '\r\n') if t else s
    out = []
    def walk(fname):
        for line in funcs[fname].split('\n'):
            m = re.search(r'CreateQuestBJ\s*\(\s*(\w+)\s*,\s*(%s)\s*,\s*(%s|ModuleLongText_\d+\(\))\s*,\s*(%s)\s*\)' % (CAT, CAT, LIT), line)
            if m:
                out.append((m.group(1), value(m.group(2)), value(m.group(3)), unescape(m.group(4))))
            e = re.search(r'call\s+TriggerExecute\s*\(\s*gg_trg_(\w+)\s*\)', line)
            if e:
                walk('Trig_%s_Actions' % e.group(1))
    walk('Trig_Init_QuestLog_Actions')
    return out

def main(src, base_map, base_runtime, out_map, out_runtime, before_map):
    base = MPQ(base_map)
    entries = json.load(open(os.path.join(src, 'trigger-list.json'), encoding='utf-8'))
    init_entry = next(e for e in entries if e['name'] == 'Init')
    init_path = os.path.join(src, 'triggers', init_entry['folder'], 'Init.j')
    init = lf(open(init_path, encoding='utf-8', newline='').read())
    raw_rt = open(base_runtime, 'rb').read()
    rt = lf(raw_rt.decode('utf-8'))
    wts_raw = base.read('war3map.wts')
    bom = wts_raw.startswith(b'\xef\xbb\xbf')
    wts = wts_raw.decode('utf-8-sig')
    before = quest_log(rt, MPQ(before_map).read('war3map.wts').decode('utf-8-sig'))

    # ---- read the help entries from the source ----------------------------------------
    qm = fspan(init, 'Trig_Init_QuestLog_Actions')
    lines = qm.group(0).split('\n')
    calls = [l for l in lines if 'call CreateQuestBJ(' in l]
    src_funcs = {m.group(1): m.group(0) for m in re.finditer(r'^function (\w+) takes.*?^endfunction', init, re.M | re.S)}
    def src_value(expr):
        m = re.match(r'^(ModuleLongText_\d+)\(\)$', expr.strip())
        if m:
            return ''.join(unescape(x) for x in re.findall(r'set text\s*=\s*text\s*\+\s*(%s)' % LIT, src_funcs[m.group(1)]))
        return unescape(expr.strip())
    quests = []
    for l in calls:
        m = re.search(r'CreateQuestBJ\((\w+),(%s),(%s|ModuleLongText_\d+\(\)),(%s)\)' % (CAT, CAT, LIT), l)
        assert m and m.group(1) == 'bj_QUESTTYPE_OPT_DISCOVERED', l
        quests.append((src_value(m.group(2)), src_value(m.group(3)), unescape(m.group(4))))
    assert len(quests) == 18, len(quests)

    # ---- string table entries ----------------------------------------------------------
    ids = [int(x) for x in re.findall(r'^STRING (\d+)', wts, re.M)]
    nxt = max(ids) + 1
    if 'TRIGSTR_' in rt:   # do not reuse ids the old runtime still mentions
        nxt = max([nxt] + [int(x) + 1 for x in re.findall(r'TRIGSTR_(\d+)', rt)])
    add, refs = [], []
    for title, text, icon in quests:
        pair = []
        for s in (title, text):
            assert not re.search(r'(?m)^\}', s.replace('\r\n', '\n')), 'text contains a WTS delimiter'
            add.append('STRING %d\r\n{\r\n%s\r\n}\r\n\r\n' % (nxt, s.replace('\r\n', '\n').replace('\n', '\r\n')))
            pair.append('TRIGSTR_%03d' % nxt)
            nxt += 1
        refs.append(pair)
    if not wts.endswith('\r\n\r\n'):
        wts = wts.rstrip('\r\n') + '\r\n\r\n'
    new_wts = ('\ufeff' if bom else '') + wts + ''.join(add)

    # ---- GUI trigger in the trigger tree --------------------------------------------------
    t = read_wtg(base.read('war3map.wtg'))
    gui_items = [i for i in t['items'] if i['kind'] in (8, 16, 32)]
    init_item = next(i for i in t['items'] if i['kind'] == GUI and i['name'] == 'Init')
    new_id = max(i['id'] for i in gui_items) + 1
    assert all(i['id'] != new_id for i in t['items'])
    desc = ('Quest log (F9) help entries. Edit their text here. They are created at startup by Init_QuestLog '
            '(module Init), which runs this trigger after the Difficulty entry.\r\n'
            'Keep long text in GUI actions like these: World Editor stores it in the map\'s string table, '
            'which Warcraft\'s native save/load needs (very long strings typed in custom script crash loading saved games).')
    item = dict(kind=GUI, name='QuestLog_Entries', desc=desc, is_comment=0, id=new_id, enabled=1, custom=0,
                initially_off=0, run_on_init=0, parent=init_item['parent'],
                functions=[action('CreateQuestBJ', [preset_param('QuestTypeOptDiscovered'), string_param(a), string_param(b), string_param(icon)])
                           for (a, b), (_, _, icon) in zip(refs, quests)])
    pos = t['items'].index(init_item) + 1
    t['items'].insert(pos, item)
    t['counts'][GUI] += 1
    new_wtg = write_wtg(t)
    wct_index = [i for i in t['items'] if i['kind'] in (8, 16, 32)].index(item)

    # ---- source: Init_QuestLog and ModuleLongText helpers ----------------------------------
    first_help = next(i for i, l in enumerate(lines) if 'call CreateQuestBJ(' in l)
    last_help = max(i for i, l in enumerate(lines) if 'call CreateQuestBJ(' in l)
    new_lines = lines[:first_help] + [
        '    // The help entries are the "Create Quest" actions of the GUI trigger QuestLog_Entries',
        '    // (folder 02 Map setup). Edit their text there: World Editor keeps GUI text in the map\'s',
        '    // string table, which native save/load needs for long text.',
        '    call TriggerExecute(gg_trg_QuestLog_Entries)'] + lines[last_help + 1:]
    new_qtext = '\n'.join(new_lines)
    init = init[:qm.start()] + new_qtext + init[qm.end():]
    for n in sorted(re.findall(r'^function (ModuleLongText_\d+) takes', init, re.M)):
        m = fspan(init, n)
        init = init[:m.start()].rstrip('\n') + '\n\n' + init[m.end():].lstrip('\n')
    open(init_path, 'w', encoding='utf-8', newline='').write(crlf(init))
    # trigger list + editor source
    w = read_wct(base.read('war3map.wct'))
    entries.insert(wct_index, dict(index=wct_index, name='QuestLog_Entries', folder=init_entry['folder'], library=None,
                                   note='GUI trigger: quest log (F9) help texts as "Create Quest" actions. Edit the text in World Editor.'))
    for i, e in enumerate(entries):
        e['index'] = i
    json.dump(entries, open(os.path.join(src, 'trigger-list.json'), 'w', encoding='utf-8'), indent=1)
    import build_map
    w_entries = list(w['entries'])
    w_entries.insert(wct_index, b'')
    w['entries'] = w_entries
    tmp_wct = write_wct(w)
    new_wct = build_map.build_wct(tmp_wct, src)

    # ---- runtime: same as World Editor would generate -------------------------------------
    m = fspan(rt, 'Trig_Init_QuestLog_Actions')
    rt = rt[:m.start()] + new_qtext.rstrip('\n') + '\n' + rt[m.end():]
    for n in sorted(set(re.findall(r'^function (ModuleLongText_\d+) takes', rt, re.M))):
        m = fspan(rt, n)
        rt = rt[:m.start()] + rt[m.end():]
    g = re.search(r'^trigger gg_trg_Init= null\n', rt, re.M)
    rt = rt[:g.end()] + 'trigger gg_trg_QuestLog_Entries= null\n' + rt[g.end():]
    body = ''.join('    call CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED, "%s", "%s", %s)\n' % (a, b, escape(icon))
                   for (a, b), (_, _, icon) in zip(refs, quests))
    gen = ('//===========================================================================\n'
           '// Trigger: QuestLog_Entries\n'
           '//===========================================================================\n'
           'function Trig_QuestLog_Entries_Actions takes nothing returns nothing\n' + body + 'endfunction\n\n'
           '//===========================================================================\n'
           'function InitTrig_QuestLog_Entries takes nothing returns nothing\n'
           '    set gg_trg_QuestLog_Entries=CreateTrigger()\n'
           '    call TriggerAddAction(gg_trg_QuestLog_Entries, function Trig_QuestLog_Entries_Actions)\n'
           'endfunction\n\n')
    k = re.search(r'^//={10,}\n// Trigger: MainDeprotected\n', rt, re.M)
    k = k.start() if k else rt.index('function Trig_MainDeprotected_Actions')
    rt = rt[:k] + gen + rt[k:]
    c = re.search(r'^    call InitTrig_Init\(\)\n', rt, re.M)
    rt = rt[:c.end()] + '    call InitTrig_QuestLog_Entries()\n' + rt[c.end():]
    open(out_runtime, 'wb').write((rt.replace('\n', '\r\n') if b'\r\n' in raw_rt else rt).encode('utf-8'))

    replace_files(base_map, out_map, {'war3map.wtg': new_wtg, 'war3map.wct': new_wct, 'war3map.j': open(out_runtime, 'rb').read(),
                                       'war3map.wts': new_wts.encode('utf-8')})
    after = quest_log(rt, new_wts.lstrip('\ufeff'))
    assert len(before) == 19 and before == after, 'quest log changed!'
    assert read_wtg(MPQ(out_map).read('war3map.wtg')) == t
    print(json.dumps(dict(gui_trigger='QuestLog_Entries', trigger_id=new_id, wct_index=wct_index, quests=len(quests),
                          strings_added=len(add), first_string=refs[0][0], quest_log_identical=True), indent=1))

if __name__ == '__main__':
    main(*sys.argv[1:7])

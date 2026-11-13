"""Restore original voiced-speaker routing without reverting quest logic."""
from build_f1030_inventory_rollback import *
from test_map_identity import info_labels,without_literals

LIBS=('TKalmSiege1','TKalmSiege2','TKalmSiege3','TBossGilgamesh')
REFERENCE=ROOT/'release/development/QuickUI30/FFERPG-QuickUI30-Forsaken.w3x'

def dialogue_map(old,current):
    mapping={};counts={}
    for lib in LIBS:
        a=[x.strip() for x in old.modules[lib].splitlines() if 'call Text_' in x]
        b=[x.strip() for x in current.modules[lib].splitlines() if 'call Text_' in x]
        assert len(a)==len(b),(lib,len(a),len(b))
        counts[lib]=0
        for original,caption in zip(a,b):
            match=re.fullmatch(r'call Text_Say\((.+),("(?:\\.|[^"\\])*"),(true|false)\)',original)
            assert match,original
            speaker,message,forced=match.groups()
            assert message in caption and caption.endswith(','+forced+')'),(original,caption)
            # Retain genuine narrator-only messages; restore actual speakers.
            if speaker=='null':continue
            assert 'Text_Caption' in caption
            assert caption not in mapping or mapping[caption]==original
            mapping[caption]=original;counts[lib]+=1
    assert sum(counts.values())==90,counts
    return mapping,counts

def build(base,out,label,oldshort,short):
    assert not out.exists()
    v=view(str(base));ref=view(str(REFERENCE));mapping,counts=dialogue_map(ref,v)
    def patch(s):
        for a,b in mapping.items():s=s.replace(a,b)
        return s
    oldlabel=v.strings[38788]
    def labels(s):return s.replace(oldlabel,label).replace(oldshort+' F/G:',short+' F/G:')
    modules={lib:labels(patch(v.modules[lib])) for lib in LIBS}
    rt=labels(patch(v.runtime))
    before,after=functions(v.runtime),functions(rt)
    changed=[n for n in before if tokens(labels(before[n]))!=tokens(after[n])]
    assert changed and all(n.startswith(('Trig_KalmSiege1_','Trig_KalmSiege2_','Trig_KalmSiege3_','Trig_Boss_Gilgamesh_')) for n in changed),changed
    # Removing just dialogue calls must leave all quest and summon logic exact.
    strip=lambda s:re.sub(r'call Text_\w+\([^\n]*\)','',s)
    for n in changed:assert tokens(strip(labels(before[n])))==tokens(strip(after[n])),n
    for i,raw in enumerate(v.wct['entries']):
        old=text_of(raw).replace('\r\n','\n');m=re.match(r'\s*library (\w+)\b',old)
        new=modules[m[1]] if m and m[1] in modules else labels(old)
        if new!=old:v.wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    if v.wct.get('header'):
        old=text_of(v.wct['header']).replace('\r\n','\n');new=labels(old)
        if new!=old:v.wct['header']=raw_of(new)
    strings={k:labels(s) for k,s in v.strings.items()};strings[38788]=label;strings[4]=label
    assert strings[38790]==v.strings[38790] and strings[5]==v.strings[5]
    files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(v.archive.read('war3map.w3i'),label)}
    out.parent.mkdir(parents=True,exist_ok=True)
    tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in v.archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(n)==files.get(n,v.archive.read(n)),n
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),reference=str(REFERENCE),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),restored_speaker_calls=counts,changed_functions=changed,scope='Original speaker calls only. All non-dialogue logic, shared dialogue/cinematic/UI helpers and unrelated archive payloads retained.',acceptance='h UI06 multiplayer Kalm repeated tests owner-approved; restored portraits not yet tested.'),indent=2))
    print(out,counts,flush=True)

if __name__=='__main__':
    build(ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h.w3x',ROOT/'release/development/HDialogue01/FFERPG-0.9.7.5h-Dialogue01.w3x','FFERPG 0.9.7.5h Dialogue01','0.9.7.5h','h Dialogue01')
    build(ROOT/'release/development/V34/FFERPG-V34.w3x',ROOT/'release/development/V35/FFERPG-V35.w3x','FFERPG V35','V34','V35')

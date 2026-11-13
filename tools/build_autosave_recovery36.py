from build_f1030_inventory_rollback import *
from test_map_identity import info_labels
from autosave_recovery36 import refresh

def build(base,out,label,oldshort,short):
    assert not out.exists()
    v=view(str(base));oldlabel=v.strings[38788]
    def labels(s):return s.replace(oldlabel,label).replace(oldshort+' F/G:',short+' F/G:')
    modules={lib:labels(refresh(v.modules[lib])) for lib in ['TForsakenFreshLoad','TForsakenSaveCapture']}
    original='\n'.join(v.modules[lib] for lib in modules)
    source='\n'.join(modules.values())
    before,after=functions(original),functions(source)
    changed={n for n in before if tokens(labels(before[n]))!=tokens(after[n])}
    assert changed=={'C20_ProfilePause','C20_ProfileResume','C20_BeginAutosave','Restore_AutosaveTick','FRC_Timeout','FFL_Tick'},changed
    rt=labels(v.runtime)
    for n in changed:
        assert tokens(before[n])==tokens(functions(v.runtime)[n]),('Runtime optimization differs',n)
        rt=put(rt,n,after[n])
    rt=put(rt,'FFL_Tick',functions(rt)['FFL_Tick']+'\n'+after['C36_ResumeProfilePoll'])
    for i,raw in enumerate(v.wct['entries']):
        old=text_of(raw).replace('\r\n','\n')
        match=re.match(r'\s*library (\w+)\b',old)
        new=modules[match[1]] if match and match[1] in modules else labels(old)
        if new!=old:v.wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    if v.wct.get('header'):
        old=text_of(v.wct['header']).replace('\r\n','\n');new=labels(old)
        if old!=new:v.wct['header']=raw_of(new)
    strings={k:labels(s) for k,s in v.strings.items()};strings[38788]=label;strings[4]=label
    assert strings[38790]==v.strings[38790] and strings[5]==v.strings[5]
    files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(v.archive.read('war3map.w3i'),label)}
    out.parent.mkdir(parents=True,exist_ok=True)
    tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in v.archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(n)==files.get(n,v.archive.read(n)),n
    a,b=functions(v.runtime),functions(rt)
    for n in a:
        if n not in changed:assert tokens(labels(a[n]))==tokens(b[n]),n
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=sorted(changed),scope='Existing shared scheduler completes finished captures and expires stalled soft autosaves. Existing profile timers explicitly rearmed after scenes. No new timers/globals/codec/UI/inventory changes.',acceptance='Native/multiplayer autosave recovery pending'),indent=2))
    print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h.w3x',ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h-Save01.w3x','FFERPG 0.9.7.5h Save01','0.9.7.5h','h Save01')
    build(ROOT/'release/development/V35/FFERPG-V35.w3x',ROOT/'release/development/V36/FFERPG-V36.w3x','FFERPG V36','V35','V36')

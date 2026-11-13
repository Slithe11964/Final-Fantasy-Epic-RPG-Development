"""Recovery17/V28: placement/layer only, same casting and scene restoration."""
from build_f1030_inventory_rollback import *
from gear_right28 import refresh
from test_map_identity import script_labels,without_literals,info_labels

def build(base,out,label,short,prior_short):
    assert not out.exists();v=view(str(base));oldlabel=v.strings[38788]
    def labels(s):
        return script_labels(s.replace(oldlabel,label).replace(prior_short+' F/G:',short+' F/G:'),label,short)
    source=labels(refresh(v.modules['TEquip']));before,after=functions(v.modules['TEquip']),functions(source)
    changed={n for n in before if without_literals(before[n])!=without_literals(after[n])}
    assert changed=={'QuickGear_Init','QuickGear_Layout'},changed
    rt=labels(v.runtime)
    for n in changed:rt=put(rt,n,after[n])
    for i,raw in enumerate(v.wct['entries']):
        old=text_of(raw).replace('\r\n','\n')
        new=source if re.match(r'\s*library TEquip\b',old) else labels(old)
        if new!=old:v.wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    if v.wct.get('header'):
        old=text_of(v.wct['header']).replace('\r\n','\n');new=labels(old)
        if old!=new:v.wct['header']=raw_of(new)
    strings={k:labels(value) for k,value in v.strings.items()}
    purpose='F/G restored to the right of the spell grid; native portrait-layer display test.'
    strings[38788]=label
    files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),
       'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(v.archive.read('war3map.w3i'),label,purpose)}
    out.parent.mkdir(parents=True,exist_ok=True)
    tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    result=MPQ(str(out))
    for n in v.archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:
            assert result.read(n)==files.get(n,v.archive.read(n)),n
    bf,af=functions(v.runtime),functions(rt);assert set(bf)==set(af)
    assert {n for n in bf if without_literals(bf[n])!=without_literals(af[n])}==changed
    for n in bf:
        if n not in changed:assert tokens(labels(bf[n]))==tokens(af[n]),n
    original=view(str(ROOT/'release/development/GRecovery14/FFERPG-0.9.7.5g-Recovery14.w3x'))
    assert tokens(af['QuickGear_Layout'])==tokens(functions(original.runtime)['QuickGear_Layout'])
    assert 'call QuickGear_Layout()' in af['C20_UIResume']
    assert 'ConsoleUIBackdrop' not in af['QuickGear_Init']
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),display_identity=label,changed_functions=sorted(changed),scope='Original right-of-command geometry; regular dock parent changed to existing native portrait parent. Scene-resume layout and all other behavior retained; display labels updated.',status='Native position/layer/cooldown/post-scene/multiplayer verification pending'),indent=2))
    print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/development/GRecovery16/FFERPG-0.9.7.5g-Recovery16.w3x',ROOT/'release/development/GRecovery17/FFERPG-0.9.7.5g-Recovery17.w3x','FFERPG 0.9.7.5g Recovery17','Recovery17','Recovery16')
    build(ROOT/'release/development/V27/FFERPG-V27.w3x',ROOT/'release/development/V28/FFERPG-V28.w3x','FFERPG V28','V28','V27')

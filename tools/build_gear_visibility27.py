"""Build distinct production/development display candidates with real labels."""
from build_f1030_inventory_rollback import *
from gear_visibility27 import refresh
from test_map_identity import script_labels,without_literals,info_labels

def build(base,out,label,short):
    assert not out.exists()
    v=view(str(base));oldlabel=v.strings[38788]
    prior_short='Recovery15' if 'Recovery15' in base.name else 'V26'
    def labels(s):
        return script_labels(s.replace(oldlabel,label).replace(prior_short+' F/G:',short+' F/G:'),label,short)
    source=labels(refresh(v.modules['TEquip']))
    before,after=functions(v.modules['TEquip']),functions(source)
    changed={n for n in before if without_literals(before[n])!=without_literals(after[n])}
    assert changed=={'QuickGear_Init','QuickGear_Layout','C20_UIResume'},changed
    rt=labels(v.runtime)
    for n in changed:rt=put(rt,n,after[n])
    for i,raw in enumerate(v.wct['entries']):
        old=text_of(raw).replace('\r\n','\n')
        if re.match(r'\s*library TEquip\b',old):new=source
        else:new=labels(old)
        if new!=old:v.wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    if v.wct.get('header'):
        old=text_of(v.wct['header']).replace('\r\n','\n');new=labels(old)
        if old!=new:v.wct['header']=raw_of(new)
    strings={k:labels(value) for k,value in v.strings.items()}
    purpose='Gear controls above the command grid; visibility after cutscenes test.'
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
    # All controls/model/casting/poll paths are exact; only parent, placement,
    # and a UI-only resume layout call differ, plus version label strings.
    for n in ['QuickGear_Poll','QuickGear_Draw','QuickGear_DrawWheel','QuickGear_Request','QuickGear_Input','QuickGear_Mouse','QuickGear_Receive','Cine_Enter','Cine_Exit','C20_HideUI','C20_UIPause']:
        assert tokens(labels(bf[n]))==tokens(af[n]),n
    assert 'ConsoleUIBackdrop' not in af['QuickGear_Init']
    assert '.748,.265' in af['QuickGear_Layout'] and '.748+.040' not in rt
    assert .748+.040<=.8 and .265-.086>.176
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),display_identity=label,changed_functions=sorted(changed),scope='Gear parent, safe absolute placement and UI-only resume layout; display labels updated. All other code and resources exact.',status='Native button/cooldown visibility and multiplayer acceptance pending'),indent=2))
    print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/development/GRecovery15/FFERPG-0.9.7.5g-Recovery15.w3x',ROOT/'release/development/GRecovery16/FFERPG-0.9.7.5g-Recovery16.w3x','FFERPG 0.9.7.5g Recovery16','Recovery16')
    build(ROOT/'release/development/V26/FFERPG-V26.w3x',ROOT/'release/development/V27/FFERPG-V27.w3x','FFERPG V27','V27')

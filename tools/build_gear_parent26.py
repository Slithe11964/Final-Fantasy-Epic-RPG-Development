"""Single-function parent correction; preserve the limited-passing Recovery14."""
from build_f1030_inventory_rollback import *
from gear_parent26 import refresh

def build(base,out,label):
    assert not out.exists()
    v=view(str(base));source=refresh(v.modules['TEquip'])
    before,after=functions(v.modules['TEquip']),functions(source)
    assert {n for n in before if tokens(before[n])!=tokens(after[n])}=={'QuickGear_Init'}
    rt=put(v.runtime,'QuickGear_Init',after['QuickGear_Init'])
    for i,raw in enumerate(v.wct['entries']):
        if re.match(r'\s*library TEquip\b',text_of(raw)):
            v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
    files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
    out.parent.mkdir(parents=True,exist_ok=True)
    tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    result=MPQ(str(out))
    for n in v.archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:
            assert result.read(n)==files.get(n,v.archive.read(n)),n
    bf,af=functions(v.runtime),functions(rt)
    assert set(bf)==set(af)
    assert {n for n in bf if tokens(bf[n])!=tokens(af[n])}=={'QuickGear_Init'}
    assert tokens(before['QuickGear_Init'].replace('"GearDock25",origin,','"GearDock25",BlzGetFrameByName("ConsoleUIBackdrop",0),',1))==tokens(after['QuickGear_Init'])
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=['QuickGear_Init'],change='Regular F/G root parent GAME_UI -> native ConsoleUIBackdrop; exactly one argument expression changes',status='Native visibility/cooldown and multiplayer acceptance pending; Recovery14 two cutscene pass had invisible buttons'),indent=2))
    print(out)

if __name__=='__main__':
    build(ROOT/'release/development/GRecovery14/FFERPG-0.9.7.5g-Recovery14.w3x',ROOT/'release/development/GRecovery15/FFERPG-0.9.7.5g-Recovery15.w3x','FFERPG 0.9.7.5g Recovery15 - visible gear dock')
    build(ROOT/'release/development/V25/FFERPG-V25.w3x',ROOT/'release/development/V26/FFERPG-V26.w3x','FFERPG V26 - visible gear dock')

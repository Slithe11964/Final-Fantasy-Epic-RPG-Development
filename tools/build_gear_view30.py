from build_f1030_inventory_rollback import *
from gear_view30 import refresh
from test_map_identity import without_literals,info_labels

def build(base,out,label,oldshort,short):
    assert not out.exists();v=view(str(base));oldlabel=v.strings[38788]
    def labels(s):return s.replace(oldlabel,label).replace(oldshort+' F/G:',short+' F/G:')
    source=labels(refresh(v.modules['TEquip']));old,new=functions(v.modules['TEquip']),functions(source)
    assert {n for n in old if without_literals(old[n])!=without_literals(new[n])}=={'QuickGear_Diagnostic'}
    rt=put(labels(v.runtime),'QuickGear_Diagnostic',new['QuickGear_Diagnostic'])
    for i,raw in enumerate(v.wct['entries']):
        prior=text_of(raw).replace('\r\n','\n');updated=source if re.match(r'\s*library TEquip\b',prior) else labels(prior)
        if updated!=prior:v.wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
    if v.wct.get('header'):
        prior=text_of(v.wct['header']).replace('\r\n','\n');updated=labels(prior)
        if updated!=prior:v.wct['header']=raw_of(updated)
    strings={k:labels(value) for k,value in v.strings.items()};strings[38788]=label;strings[4]=label
    files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(v.archive.read('war3map.w3i'),label)}
    out.parent.mkdir(parents=True,exist_ok=True);tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in v.archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(n)==files.get(n,v.archive.read(n)),n
    bf,af=functions(v.runtime),functions(rt);assert set(bf)==set(af)
    for n in bf:
        if n!='QuickGear_Diagnostic':assert tokens(labels(bf[n]))==tokens(af[n]),n
    assert strings[38790]==v.strings[38790] and strings[5]==v.strings[5]
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),display_identity=label,changed_functions=['QuickGear_Diagnostic'],scope='Compact cached frame summary printed last; renderer/casting/inventory/saves/timers unchanged; author description preserved',status='Diagnostic only; invisible buttons still unresolved'),indent=2));print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/development/H20261110UI01/FFERPG-0.9.7.5h-UI01.w3x',ROOT/'release/development/H20261110UI02/FFERPG-0.9.7.5h-UI02.w3x','FFERPG 0.9.7.5h UI02','h UI01','h UI02')
    build(ROOT/'release/development/V29/FFERPG-V29.w3x',ROOT/'release/development/V30/FFERPG-V30.w3x','FFERPG V30','V29','V30')

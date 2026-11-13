"""Add only on-demand parent visibility to h and current development."""
from build_f1030_inventory_rollback import *
from gear_view29 import refresh
from test_map_identity import without_literals,info_labels

def build(base,out,label,prior_short,short):
    assert not out.exists();v=view(str(base));oldlabel=v.strings[38788]
    def labels(s):return s.replace(oldlabel,label).replace(prior_short+' F/G:',short+' F/G:')
    source=labels(refresh(v.modules['TEquip']));before,after=functions(v.modules['TEquip']),functions(source)
    changed={n for n in before if without_literals(before[n])!=without_literals(after[n])}
    assert changed=={'QuickGear_Init','QuickGear_Diagnostic','QuickGear_Reset'},changed
    rt=labels(v.runtime)
    for n in changed:rt=put(rt,n,after[n])
    dg,og=decls(source),decls(v.modules['TEquip']);add=[dg[n] for n in dg if n not in og]
    assert len(add)==3
    rt=rt.replace('endglobals','\n'.join(add)+'\nendglobals',1)
    for i,raw in enumerate(v.wct['entries']):
        old=text_of(raw).replace('\r\n','\n');new=source if re.match(r'\s*library TEquip\b',old) else labels(old)
        if old!=new:v.wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    if v.wct.get('header'):
        old=text_of(v.wct['header']).replace('\r\n','\n');new=labels(old)
        if old!=new:v.wct['header']=raw_of(new)
    strings={k:labels(value) for k,value in v.strings.items()};strings[38788]=label;strings[4]=label
    files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(v.archive.read('war3map.w3i'),label)}
    out.parent.mkdir(parents=True,exist_ok=True)
    temp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(temp),files);compact(str(temp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in v.archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(n)==files.get(n,v.archive.read(n)),n
    bf,af=functions(v.runtime),functions(rt);assert set(bf)==set(af)
    for n in bf:
        if n not in changed:assert tokens(labels(bf[n]))==tokens(af[n]),n
    assert strings[38790]==v.strings[38790] and strings[5]==v.strings[5]
    out.with_suffix('.j').write_text(rt)
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),display_identity=label,changed_functions=sorted(changed),scope='On-demand existing -gearcheck readout only; cache at most eight existing frame ancestors during shared startup. Renderer/input/casting/inventory/timers/scenes unchanged.',status='Diagnostic only; h invisible-button defect remains unresolved'),indent=2));print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h.w3x',ROOT/'release/development/H20261110UI01/FFERPG-0.9.7.5h-UI01.w3x','FFERPG 0.9.7.5h UI01','0.9.7.5h','h UI01')
    build(ROOT/'release/development/V28/FFERPG-V28.w3x',ROOT/'release/development/V29/FFERPG-V29.w3x','FFERPG V29','V28','V29')

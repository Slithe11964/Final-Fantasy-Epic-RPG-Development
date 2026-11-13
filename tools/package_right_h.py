"""Requested h promotion with display-only labels and preserved prior releases."""
from pathlib import Path
import hashlib,json
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write
from wct import read_wct,text_of,raw_of,write_wct
from add_header import read_header,build_header
from test_map_identity import script_labels,without_literals,info_labels
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'release/development/VersionHRightDock20261110'

def package(base,name,label,short,prior_short,purpose):
    out=OUT/name;assert not out.exists()
    m=MPQ(str(base));strings=wts_read(m.read('war3map.wts'));oldlabel=strings[38788]
    def labels(s):
        return script_labels(s.replace(oldlabel,label).replace(prior_short+' F/G:',short+' F/G:'),label,short)
    original=m.read('war3map.j').decode().replace('\r\n','\n');source=labels(original)
    assert without_literals(original)==without_literals(source)
    wct=read_wct(m.read('war3map.wct'))
    if wct.get('header'):
        old=text_of(wct['header']).replace('\r\n','\n');new=labels(old)
        assert without_literals(old)==without_literals(new)
        if old!=new:wct['header']=raw_of(new)
    for i,raw in enumerate(wct['entries']):
        old=text_of(raw).replace('\r\n','\n');new=labels(old)
        assert without_literals(old)==without_literals(new)
        if old!=new:wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    strings={k:labels(v) for k,v in strings.items()};strings[38788]=label
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(m.read('war3map.w3i'),label,purpose)}
    out.parent.mkdir(parents=True,exist_ok=True)
    tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in m.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(n)==files.get(n,m.read(n)),n
    assert read_header(str(out))[0]==wts_read(checked.read('war3map.wts'))[38788]==label
    out.with_suffix('.j').write_text(source)
    rec=dict(base=str(base),output=str(out),label=label,sha256=hashlib.sha256(out.read_bytes()).hexdigest(),scope='Label-only promotion; all non-string script tokens and unrelated archive payloads exact',native_acceptance='Right-side layering and post-scene behavior unverified; user requested h version')
    out.with_suffix('.json').write_text(json.dumps(rec,indent=2));print(out,flush=True)
    return rec

if __name__=='__main__':
    assert not OUT.exists()
    rows=[package(ROOT/'release/development/GRecovery17/FFERPG-0.9.7.5g-Recovery17.w3x','FFERPG-0.9.7.5h.w3x','FFERPG 0.9.7.5h','0.9.7.5h','Recovery17','Gear controls restored to the right of the spell grid.'),
      package(ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-1.29.2-Recovery12.w3x','FFERPG-0.9.7.5h-1.29.2.w3x','FFERPG 0.9.7.5h 1.29.2','0.9.7.5h 1.29.2','Recovery12','Warcraft 1.29.2 build. Existing compatible inventory; modern frame-only changes do not apply.'),
      package(ROOT/'release/development/V28/FFERPG-V28.w3x','FFERPG-V28.w3x','FFERPG V28','V28','V28','')]
    (OUT/'manifest.json').write_text(json.dumps(rows,indent=2))

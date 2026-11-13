"""Restore author text and compact identities; no non-string code changes."""
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor,as_completed
import hashlib,json
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write,R
from wct import read_wct,text_of,raw_of,write_wct
from add_header import read_header,build_header
from test_map_identity import without_literals
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'release/development/DescriptionRestore20261110'
REF=ROOT/'release/0.9.7.5f/2026-10-30/FFERPG-0.9.7.5f.w3x'
SPECS=[('release/0.9.7.5h/FFERPG-0.9.7.5h.w3x','FFERPG 0.9.7.5h'),
 ('release/0.9.7.5h/FFERPG-0.9.7.5h-1.29.2.w3x','FFERPG 0.9.7.5h 1.29.2')]
SPECS += [('release/development/GRecovery'+str(n)+'/FFERPG-0.9.7.5g-Recovery'+str(n)+'.w3x','FFERPG 0.9.7.5g Recovery'+str(n)) for n in range(14,18)]
SPECS += [('release/development/V'+str(n)+'/FFERPG-V'+str(n)+'.w3x','FFERPG V'+str(n)) for n in range(25,29)]
SPECS += [
 ('release/development/GRecovery14/FFERPG-0.9.7.5g-NoFG-Test.w3x','FFERPG NoFG Test'),
 ('release/development/InventoryMultiplayerCheck03/FFERPG-Inventory-Multiplayer-Check-03.w3x','FFERPG Native Check03'),
 ('release/development/InventoryPanel04/FFERPG-Independent-Backpack-04.w3x','FFERPG Backpack04'),
 ('release/development/CreatureReview03s/FFERPG-Creature-Review-03s.w3x','FFERPG Creature Review03s')]

def info(data,label):
    r=R(data);v=r.i();assert v in (25,28,31,39),v
    r.raw(8)
    if v>=28:r.raw(16)
    start=r.o;names=[r.z() for _ in range(4)];end=r.o
    names[0]=b'TRIGSTR_38788';names[2]=b'TRIGSTR_38790'
    r.raw(65)
    if v>=39:r.raw(4)
    ls=r.o;loading=[r.z() for _ in range(4)];le=r.o
    loading[2]=label.encode();loading[3]=b''
    return data[:start]+b''.join(s+b'\0' for s in names)+data[end:ls]+b''.join(s+b'\0' for s in loading)+data[le:]

def build_one(spec):
    rel,label=spec;base=ROOT/rel;out=OUT/base.name;assert base.exists() and not out.exists()
    m=MPQ(str(base));strings=wts_read(m.read('war3map.wts'));oldlabel=strings[38788]
    reference=wts_read(MPQ(str(REF)).read('war3map.wts'))
    def labels(s):return s.replace(oldlabel,label).replace(label+' - two-player test',label)
    old=m.read('war3map.j').decode().replace('\r\n','\n');source=labels(old)
    assert without_literals(old)==without_literals(source)
    wct=read_wct(m.read('war3map.wct'))
    if wct.get('header'):
        old=text_of(wct['header']).replace('\r\n','\n');new=labels(old)
        assert without_literals(old)==without_literals(new)
        if new!=old:wct['header']=raw_of(new)
    for i,raw in enumerate(wct['entries']):
        old=text_of(raw).replace('\r\n','\n');new=labels(old)
        assert without_literals(old)==without_literals(new)
        if new!=old:wct['entries'][i]=raw_of(new.replace('\n','\r\n'))
    strings={k:labels(value) for k,value in strings.items()}
    strings[38788]=label;strings[38790]=reference[38790]
    strings[4]=label
    # Preserve the original authored loading text/credits/Discord link too.
    strings[5]=reference[5]
    files={'war3map.j':source.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),
      'war3map.wts':wts_write(strings),'war3map.w3i':info(m.read('war3map.w3i'),label)}
    temp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(temp),files);compact(str(temp),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    final=MPQ(str(out))
    for n in m.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(n)==files.get(n,m.read(n)),n
    actual=wts_read(final.read('war3map.wts'));assert actual[38790]==reference[38790] and actual[5]==reference[5]
    assert read_header(str(out))[0]==actual[38788]==label
    out.with_suffix('.j').write_text(source)
    return dict(base=str(base),output=str(out),label=label,before_sha256=hashlib.sha256(base.read_bytes()).hexdigest(),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),scope='Author description/loading text restored exactly from dated f; compact identities only; all non-string code and unrelated archive bytes unchanged')

if __name__=='__main__':
    assert not OUT.exists();OUT.mkdir()
    records=[]
    with ProcessPoolExecutor(max_workers=3) as pool:
        for f in as_completed([pool.submit(build_one,s) for s in SPECS]):
            rec=f.result();records.append(rec);print(rec['label'],flush=True)
            (OUT/'manifest.json').write_text(json.dumps(records,indent=2))
    assert len(records)==len(SPECS)

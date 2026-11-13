from pathlib import Path
import json,hashlib
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from house79 import abilities,units
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label):
    assert not out.exists()
    m=MPQ(str(base));files={}
    for n in ['war3map.w3a','war3map.w3u','war3mapSkin.w3u']:
        try:old=m.read(n)
        except (KeyError,FileNotFoundError):continue
        if not old:continue
        new=abilities(old) if n.endswith('.w3a') else units(old)
        if old!=new:files[n]=new
    assert 'war3map.w3a' in files
    w=wts_read(m.read('war3map.wts'));w[38788]=label;files['war3map.wts']=wts_write(w)
    out.parent.mkdir(parents=True,exist_ok=True);tmp=out.with_suffix('.unpacked.w3x')
    write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
    _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for n in m.read('(listfile)').decode().splitlines():
        if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert checked.read(n)==files.get(n,m.read(n)),n
    out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_resources=list(files),runtime='byte-identical',recovery='House-only clones hH79/hM79: 5% maximum HP/MP per second. Both house forms updated; Fountain of Restoration original abilities unchanged. Existing 350 range/targets preserved; no new timer.'),indent=2))
    print(out)

if __name__=='__main__':
    build(ROOT/'release/development/VersionFHotfix08/FFERPG-0.9.7.5f-Hotfix08.w3x',ROOT/'release/development/VersionFHotfix09/FFERPG-0.9.7.5f-Hotfix09.w3x','FFERPG 0.9.7.5f Hotfix09')
    build(ROOT/'release/development/QuickUI77/FFERPG-QuickUI77.w3x',ROOT/'release/development/QuickUI78/FFERPG-QuickUI78.w3x','FFERPG QuickUI78 (Dragoon)')
    build(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-1.29.2.w3x',ROOT/'release/development/VersionFHotfix09/FFERPG-0.9.7.5f-Hotfix09-1.29.2.w3x','FFERPG 0.9.7.5f Hotfix09 1.29.2')

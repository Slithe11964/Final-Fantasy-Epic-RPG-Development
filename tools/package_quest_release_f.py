"""Label-only promotion of checked quest-fix maps; preserve earlier f artifacts."""
import hashlib,json
from pathlib import Path
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]

def promote(base,out,label):
    assert not out.exists(),'Preserve earlier releases.'
    out.parent.mkdir(parents=True,exist_ok=True)
    archive=MPQ(str(base));strings=wts_read(archive.read('war3map.wts'));strings[38788]=label
    files={'war3map.wts':wts_write(strings)}
    private=out.with_suffix('.unpacked.w3x');assert not private.exists()
    write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    packed=MPQ(str(out));assert packed.read('war3map.wts')==files['war3map.wts']
    for n in archive.read('(listfile)').decode().splitlines():
        if n.lower() not in ('war3map.wts','(listfile)','(attributes)','(signature)'):
            assert packed.read(n)==archive.read(n),n
    r=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),
        scripts_editor_objects_assets='byte-identical to checked Hotfix05',archive_readback='PASS',
        changes='All quest notification spacers removed; null messages skipped; Seeker leaders no longer granted A102.',
        save_format='unchanged',development='Dragoon/new Thief excluded; UI74 stored separately.',
        desync_status='Native build inherits Hotfix04 cast-boundary candidate; multiplayer desync resolution remains unconfirmed.')
    out.with_suffix('.json').write_text(json.dumps(r,indent=2));print(out,flush=True)

if __name__=='__main__':
    folder=ROOT/'release/0.9.7.5f/2026-10-30'
    promote(ROOT/'release/development/VersionFHotfix05/FFERPG-0.9.7.5f-Hotfix05.w3x',folder/'FFERPG-0.9.7.5f.w3x','FFERPG 0.9.7.5f')
    promote(ROOT/'release/development/VersionFHotfix05/FFERPG-0.9.7.5f-Hotfix05-1.29.2.w3x',folder/'FFERPG-0.9.7.5f-1.29.2.w3x','FFERPG 0.9.7.5f 1.29.2')

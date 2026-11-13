"""Promote the accepted Hotfix03 unchanged, apart from public release labels."""
import hashlib,json
from pathlib import Path
from mpq import MPQ,write_files,compact
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]

def build():
    base=ROOT/'release/development/VersionFHotfix03/FFERPG-0.9.7.5f-Hotfix03.w3x'
    out=ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x'
    assert not out.exists(),'Preserve previous release files.'
    archive=MPQ(str(base));strings=wts_read(archive.read('war3map.wts'))
    strings[38788]='FFERPG 0.9.7.5f'
    files={'war3map.wts':wts_write(strings)}
    private=out.with_suffix('.unpacked.w3x')
    assert not private.exists()
    write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes()
    out.write_bytes(build_header('FFERPG 0.9.7.5f',flags,players)+data[data.index(b'MPQ\x1a'):])
    final=MPQ(str(out));assert final.read('war3map.wts')==files['war3map.wts']
    for name in archive.read('(listfile)').decode().splitlines():
        if name.lower() not in ('war3map.wts','(listfile)','(attributes)','(signature)'):
            assert final.read(name)==archive.read(name),name
    assert final.read('war3map.j')==archive.read('war3map.j')
    assert final.read('war3map.wct')==archive.read('war3map.wct')
    report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),
        promotion='Owner reports Hotfix03 works; public title changed to 0.9.7.5f.',
        gameplay_and_editor='byte-identical to tested Hotfix03',
        assets_and_objects='byte-identical',changed_resources=['war3map.wts','outer map title'],
        classic='Existing 0.9.7.5f-1.29.2 build retained unchanged; native UI changes are not applicable.',
        development='Dragoon/revised Thief remain in UI72, excluded from this release.',
        archive_readback='PASS',save_format='unchanged')
    out.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(json.dumps(report,indent=2))

if __name__=='__main__':build()

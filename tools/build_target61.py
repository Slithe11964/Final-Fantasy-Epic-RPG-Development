"""Package a narrowly scoped portrait-free scene candidate on both current maps."""
import hashlib,json,re,subprocess
from pathlib import Path
from editor_pair import View,runtime_for
from jtok import functions,tokens
from wct import raw_of,text_of,write_wct
from downgrade import wts_read,wts_write
from order_libraries import order
from add_header import read_header,build_header
from mpq import MPQ,write_files,compact
from target_recovery61 import refresh
ROOT=Path(__file__).resolve().parents[1]


def build(base,out,label):
    assert not out.exists(),'Preserve all previous maps.'
    view=View(base);modules={lib:refresh(s) for lib,s in view.modules.items()}
    allowed={'TEquip'}
    changed={lib for lib in modules if modules[lib]!=view.modules[lib]}
    assert changed==allowed,changed
    runtime,_=order(runtime_for(view,view,view,modules))
    wct=view.wct
    for i,raw in enumerate(wct['entries']):
        match=re.match(r'\s*library (\w+)\b',text_of(raw))
        if match and match[1] in changed:wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
    strings=wts_read(view.archive.read('war3map.wts'));strings[38788]=label
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
    # Export the existing native target cell, preserving its alpha/shape, for
    # the normal BACKDROP route that already displayed correctly in UI58.
    from PIL import Image
    import io,struct
    cursor=Image.open(ROOT/'tools/build-inputs/native-ui/humancursor.dds').convert('RGBA').crop((32,96,64,128))
    assert cursor.getchannel('A').getbbox() is not None
    blob=io.BytesIO();cursor.save(blob,format='TGA');files['GearTarget61.tga']=blob.getvalue()
    files['GearError61.fdf']=(ROOT/'experiments/Forsaken/GearError61.fdf').read_bytes()
    files['GearError61.toc']=b'GearError61.fdf\r\n'
    imp=view.archive.read('war3map.imp');version,count=struct.unpack_from('<II',imp)
    extra=['GearTarget61.tga','GearError61.fdf','GearError61.toc']
    assert not any(s.encode()+b'\0' in imp for s in extra)
    files['war3map.imp']=struct.pack('<II',version,count+len(extra))+imp[8:]+b''.join(bytes([13])+s.encode()+b'\0' for s in extra)
    out.parent.mkdir(parents=True,exist_ok=True)
    script=out.with_suffix('.j');script.write_text(runtime)
    r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(script)],capture_output=True,text=True)
    print(r.stdout[-1200:],r.stderr);assert r.returncode==0
    private=out.with_suffix('.unpacked.w3x');write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes()
    out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    archive=MPQ(str(out))
    for name,data in files.items():assert archive.read(name)==data,name
    for name in view.archive.read('(listfile)').decode().splitlines():
        if name not in files and name.lower() not in ('(listfile)','(attributes)','(signature)'):
            assert archive.read(name)==view.archive.read(name),name
    before,after=functions(view.runtime),functions(runtime)
    report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),
        changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),
        new_functions=sorted(after.keys()-before.keys()),removed_functions=sorted(before.keys()-after.keys()),
        compile='PASS',archive_readback='PASS',unrelated_resources='byte-identical',
        acceptance='Candidate: proven BACKDROP route with native target bitmap; yellow UI warning; passive tooltip preview detection. Native tooltip readback and cursor/error appearance require client acceptance. Desktop computer-use initialization failed; no live game validation.')
    assert not report['removed_functions']
    out.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(out)


if __name__=='__main__':
    build(ROOT/'release/development/VersionEHotfix08/FFERPG-0.9.7.5e-Hotfix08-Forsaken.w3x',
        ROOT/'release/development/VersionEHotfix09/FFERPG-0.9.7.5e-Hotfix09-Forsaken.w3x','FFERPG 0.9.7.5e Hotfix09')
    build(ROOT/'release/development/QuickUI60/FFERPG-QuickUI60-Forsaken.w3x',
        ROOT/'release/development/QuickUI61/FFERPG-QuickUI61-Forsaken.w3x','FFERPG QuickUI61 (Dragoon)')

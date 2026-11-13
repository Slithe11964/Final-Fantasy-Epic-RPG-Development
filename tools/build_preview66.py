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
from preview66 import refresh
ROOT=Path(__file__).resolve().parents[1]


def build(base,out,label):
    assert not out.exists(),'Preserve all previous maps.'
    view=View(base);modules={lib:refresh(s) for lib,s in view.modules.items()}
    allowed={'TEquip','TDamage'} if 'function DG_UIUpdate ' in view.modules.get('TDamage','') else {'TEquip'}
    changed={lib for lib in modules if modules[lib]!=view.modules[lib]}
    assert changed==allowed,changed
    runtime,_=order(runtime_for(view,view,view,modules))
    # Prior packaging accumulated huge runs of blank lines. pjass's newline
    # grammar can exhaust its parser stack on these; whitespace is not code.
    runtime=re.sub(r'\n{3,}','\n\n',runtime)
    wct=view.wct
    for i,raw in enumerate(wct['entries']):
        match=re.match(r'\s*library (\w+)\b',text_of(raw))
        if match and match[1] in changed:wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
    strings=wts_read(view.archive.read('war3map.wts'));strings[38788]=label
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
    import struct
    files['GearError66.fdf']=(ROOT/'experiments/Forsaken/GearError66.fdf').read_bytes()
    files['GearError66.toc']=b'GearError66.fdf\r\n'
    imp=view.archive.read('war3map.imp');version,count=struct.unpack_from('<II',imp)
    files['war3map.imp']=struct.pack('<II',version,count+2)+imp[8:]+b'\x0dGearError66.fdf\0\x0dGearError66.toc\0'
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
        acceptance='Candidate: owned pre-click bag probes and warning style; cursor art/casting/icons/objects preserved. Probe geometry/click-through and multi-client runtime validation still required. No crash-free guarantee.')
    report['acceptance']='Candidate: event plus polled native bag observation; stale world-coordinate cancellation guard, duplicate old renderer retired, three ice paths with 96-unit glyphs, native-comparison warning. Client appearance/bag reliability still unverified. Confirmed chat recovery and actual spell damage unchanged.'
    assert not report['removed_functions']
    out.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(out)


if __name__=='__main__':
    build(ROOT/'release/development/VersionEHotfix13/FFERPG-0.9.7.5e-Hotfix13-Forsaken.w3x',
        ROOT/'release/development/VersionEHotfix14/FFERPG-0.9.7.5e-Hotfix14-Forsaken.w3x','FFERPG 0.9.7.5e Hotfix14')
    build(ROOT/'release/development/QuickUI65/FFERPG-QuickUI65-Forsaken.w3x',
        ROOT/'release/development/QuickUI66/FFERPG-QuickUI66-Forsaken.w3x','FFERPG QuickUI66 (Dragoon)')

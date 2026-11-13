"""Patch only F/G icon rendering on the user-confirmed UI53 map."""
from pathlib import Path
import hashlib,json,re,subprocess
from editor_pair import View,runtime_for
from damage_tooltips import merged
from jtok import functions,tokens
from wct import raw_of,text_of,write_wct
from mpq import MPQ,write_files,compact
from downgrade import wts_write
from order_libraries import order
from add_header import read_header,build_header
from gear_icons54 import refresh

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI53/FFERPG-QuickUI53-Forsaken.w3x'
OUT=ROOT/'release/development/QuickUI54/FFERPG-QuickUI54-Forsaken.w3x'
ALLOWED={'QuickGear_Draw','QuickGear_Poll','QuickGear_Init'}
STAGE='QuickUI54'


def build():
    assert not OUT.exists(),'Preserve all previous builds.'
    view=View(BASE)
    items=merged(view.object_bytes('war3map.w3t'),view.object_bytes('war3mapSkin.w3t'),'w3t')
    modules=dict(view.modules)
    modules['TEquip']=refresh(modules['TEquip'],items)
    runtime,_=order(runtime_for(view,view,view,modules))
    before,after=functions(view.runtime),functions(runtime)
    changed={n for n in before if tokens(before[n])!=tokens(after[n])}
    assert changed==ALLOWED,changed
    assert all(n.startswith('QuickGear_') for n in after.keys()-before.keys())
    wct=view.wct
    for i,raw in enumerate(wct['entries']):
        if re.match(r'\s*library TEquip\b',text_of(raw)):
            wct['entries'][i]=raw_of(modules['TEquip'].replace('\n','\r\n'))
    strings=dict(view.strings);strings[38788]='FFERPG '+STAGE+' (Dragoon)'
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
    OUT.parent.mkdir(parents=True,exist_ok=True)
    script=OUT.parent/'runtime.j';script.write_text(runtime)
    (OUT.parent/'TEquip.j').write_text(modules['TEquip'])
    result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(script)],capture_output=True,text=True)
    print(result.stdout[-1200:],result.stderr);assert result.returncode==0
    private=OUT.with_suffix('.unpacked.w3x')
    write_files(str(BASE),str(private),files);compact(str(private),str(OUT))
    _,flags,players=read_header(str(BASE));data=OUT.read_bytes()
    OUT.write_bytes(build_header('FFERPG '+STAGE+' (Dragoon)',flags,players)+data[data.index(b'MPQ\x1a'):])
    checked=MPQ(str(OUT))
    for name,data in files.items():assert checked.read(name)==data,name
    for name in view.archive.read('(listfile)').decode().splitlines():
        if name in files or name.lower() in ('(listfile)','(attributes)','(signature)'):continue
        assert checked.read(name)==view.archive.read(name),name
    report=dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),
        changed_existing_functions=sorted(changed),new_functions=sorted(after.keys()-before.keys()),
        unchanged='Every other existing function; all gameplay/object/assets; UI53 input, casting, load behavior, cooldown and preview code.',
        compile='PASS',archive_readback='PASS',acceptance='Icon refresh requires client testing; UI53 F/G casting is user-confirmed.')
    OUT.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(json.dumps(report,indent=2))


if __name__=='__main__':build()

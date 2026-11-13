"""Native item-click targeting and standalone wave runes on both retained branches."""
from pathlib import Path
import json,hashlib,re,struct,subprocess
from editor_pair import View,runtime_for
from jtok import functions,tokens
from mpq import MPQ,write_files,compact
from wct import raw_of,text_of,write_wct
from downgrade import wts_read,wts_write
from order_libraries import order
from add_header import read_header,build_header
from native_gear57 import refresh

ROOT=Path(__file__).resolve().parents[1]


def build(base,out,label,native=True):
    assert not out.exists(),'Preserve previous maps.'
    archive=MPQ(str(base));old=archive.read('war3map.j').decode().replace('\r\n','\n')
    strings=wts_read(archive.read('war3map.wts'));strings[38788]=label
    files={'war3map.wts':wts_write(strings)}
    updated=old
    if native:
        view=View(base);modules={lib:refresh(s) for lib,s in view.modules.items()}
        updated,_=order(runtime_for(view,view,view,modules))
        before,after=functions(old),functions(updated)
        changed={n for n in before if n in after and tokens(before[n])!=tokens(after[n])}
        assert before.keys()-after.keys()<={'QuickGear_BindWeaponCast'}
        allowed=set(functions(view.modules['TEquip']))|{'Wave_Init'}
        assert not changed-allowed,changed-allowed
        wct=view.wct
        for i,raw in enumerate(wct['entries']):
            match=re.match(r'\s*library (\w+)\b',text_of(raw))
            if match and modules[match[1]]!=view.modules[match[1]]:
                wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
        files.update({'war3map.j':updated.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)})
        imp=archive.read('war3map.imp');version,count=struct.unpack_from('<II',imp)
        name='GearWaveRune.tga';assert name.encode()+b'\0' not in imp
        rune=MPQ(str(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x')).read('DragoonRune.tga')
        assert rune
        files[name]=rune
        files['war3map.imp']=struct.pack('<II',version,count+1)+imp[8:]+bytes([13])+name.encode()+b'\0'
    out.parent.mkdir(parents=True,exist_ok=True)
    script=out.with_suffix('.j');script.write_text(updated)
    common=ROOT/('tools/build-inputs/bag-quick-future-common.j' if native else 'tools/versions/1.29.2/common.j')
    blizzard=ROOT/('tools/bin/blizzard.j' if native else 'tools/versions/1.29.2/blizzard.j')
    result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(blizzard),str(script)],capture_output=True,text=True)
    print(result.stdout[-1700:],result.stderr);assert result.returncode==0
    private=out.with_suffix('.unpacked.w3x');write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes()
    out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for name,data in files.items():assert checked.read(name)==data,name
    for name in archive.read('(listfile)').decode().splitlines():
        if name not in files and name.lower() not in ('(listfile)','(attributes)','(signature)'):
            assert checked.read(name)==archive.read(name),name
    a,b=functions(old),functions(updated)
    report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),
        native=native,compile='PASS',archive_readback='PASS',unrelated_resources='byte-identical',
        changed_existing_functions=sorted(n for n in a if n in b and tokens(a[n])!=tokens(b[n])),
        removed_functions=sorted(a.keys()-b.keys()),new_functions=sorted(b.keys()-a.keys()),
        acceptance='Real native equipment click/cursor/first-bind and command-preview events require client/multiplayer acceptance. Classic gameplay is unchanged.')
    out.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(json.dumps({k:v for k,v in report.items() if k not in ('changed_existing_functions','removed_functions','new_functions')},indent=2))


if __name__=='__main__':
    for profile,native in [('Forsaken',True),('1.29.2',False)]:
        build(ROOT/f'release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-{profile}.w3x',
            ROOT/f'release/development/VersionEHotfix05/FFERPG-0.9.7.5e-Hotfix05-{profile}.w3x',
            'FFERPG 0.9.7.5e Hotfix05',native)
    build(ROOT/'release/development/QuickUI56/FFERPG-QuickUI56-Forsaken.w3x',
        ROOT/'release/development/QuickUI57/FFERPG-QuickUI57-Forsaken.w3x','FFERPG QuickUI57 (Dragoon)')

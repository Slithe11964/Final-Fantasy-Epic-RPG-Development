"""Build the retained release pair and UI56 with shared job/UI recovery fixes."""
from pathlib import Path
import hashlib,json,re,subprocess
from editor_pair import View,runtime_for
from mpq import MPQ,write_files,compact
from wct import read_wct,write_wct,text_of,raw_of
from downgrade import wts_read,wts_write
from order_libraries import order
from add_header import read_header,build_header
from damage_tooltips import merged
from jtok import functions,tokens
import session_hotfix56 as fixes
import gear_recovery53,gear_icons54,gear_icons55,gear_target56

ROOT=Path(__file__).resolve().parents[1]


def patch(source,native):
    return fixes.travel_patch(fixes.job_patch(source)) if native else fixes.job_patch(source)


def build(base,out,label,*,native,release_line=False):
    assert not out.exists(),'Preserve previous maps.'
    archive=MPQ(str(base));old=archive.read('war3map.j').decode().replace('\r\n','\n')
    if native:
        view=View(base);modules={lib:patch(s,True) for lib,s in view.modules.items()}
        if release_line:
            items=merged(view.object_bytes('war3map.w3t'),view.object_bytes('war3mapSkin.w3t'),'w3t')
            modules={lib:gear_recovery53.refresh(s) for lib,s in modules.items()}
            modules={lib:gear_icons54.refresh(s,items) for lib,s in modules.items()}
            modules={lib:gear_icons55.refresh(s) for lib,s in modules.items()}
            modules['TEquip']=modules['TEquip'].replace('UI55 F/G:','Hotfix04 F/G:')
        modules={lib:gear_target56.refresh(s) for lib,s in modules.items()}
        runtime=runtime_for(view,view,view,modules)
        wct=view.wct
        for i,raw in enumerate(wct['entries']):
            match=re.match(r'\s*library (\w+)\b',text_of(raw))
            if match and modules[match[1]]!=view.modules[match[1]]:
                wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
    else:
        runtime=patch(old,False);wct=read_wct(archive.read('war3map.wct'))
        for i,raw in enumerate(wct['entries']):
            s=text_of(raw).replace('\r\n','\n');updated=patch(s,False)
            if updated!=s:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
    runtime,_=order(runtime)
    strings=wts_read(archive.read('war3map.wts'));strings[38788]=label
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
    if native:
        for name in ('war3map.w3a','war3mapSkin.w3a'):
            if archive.read(name):files[name]=fixes.objects(archive.read(name))
    out.parent.mkdir(parents=True,exist_ok=True)
    script=out.with_suffix('.j');script.write_text(runtime)
    common=ROOT/('tools/build-inputs/bag-quick-future-common.j' if native else 'tools/versions/1.29.2/common.j')
    blizzard=ROOT/('tools/bin/blizzard.j' if native else 'tools/versions/1.29.2/blizzard.j')
    result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(blizzard),str(script)],capture_output=True,text=True)
    print(result.stdout[-1800:],result.stderr);assert result.returncode==0
    private=out.with_suffix('.unpacked.w3x');write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes()
    out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    checked=MPQ(str(out))
    for name,data in files.items():assert checked.read(name)==data,name
    for name in archive.read('(listfile)').decode().splitlines():
        if name not in files and name.lower() not in ('(listfile)','(attributes)','(signature)'):
            assert checked.read(name)==archive.read(name),name
    a,b=functions(old),functions(runtime)
    report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),
        native=native,changed_existing_functions=sorted(n for n in a if tokens(a[n])!=tokens(b[n])),
        new_functions=sorted(b.keys()-a.keys()),compile='PASS',archive_readback='PASS',
        unrelated_resources='byte-identical',acceptance='Job/Gaya, silence inventory UI and Warcraft checkpoint reload need client/multiplayer testing.')
    out.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(json.dumps({k:v for k,v in report.items() if k not in ('new_functions','changed_existing_functions')},indent=2))


if __name__=='__main__':
    for profile,native in [('Forsaken',True),('1.29.2',False)]:
        build(ROOT/f'release/development/VersionEHotfix03/FFERPG-0.9.7.5e-Hotfix03-{profile}.w3x',
            ROOT/f'release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-{profile}.w3x',
            'FFERPG 0.9.7.5e Hotfix04',native=native,release_line=native)
    build(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x',
        ROOT/'release/development/QuickUI56/FFERPG-QuickUI56-Forsaken.w3x',
        'FFERPG QuickUI56 (Dragoon)',native=True)

"""Package quest text/Seeker fixes for current, development and classic maps."""
import re,json,hashlib,subprocess
from pathlib import Path
from mpq import MPQ,write_files,compact
from wct import read_wct,write_wct,text_of,raw_of
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from order_libraries import order
from jtok import functions,tokens
from quests74 import refresh
ROOT=Path(__file__).resolve().parents[1]

def build(base,out,label,classic=False):
    assert not out.exists(),'Preserve every previous map.'
    archive=MPQ(str(base));old=archive.read('war3map.j').decode().replace('\r\n','\n')
    runtime=refresh(old);runtime,_=order(runtime);runtime=re.sub(r'\n{3,}','\n\n',runtime)
    wct=read_wct(archive.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n')))
    for i,raw in enumerate(wct['entries']):
        source=text_of(raw).replace('\r\n','\n');updated=refresh(source)
        if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
    strings=wts_read(archive.read('war3map.wts'));strings[38788]=label
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
    out.parent.mkdir(parents=True,exist_ok=True);script=out.with_suffix('.j');script.write_text(runtime)
    common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j')
    blizzard=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
    result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(blizzard),str(script)],capture_output=True,text=True)
    print(result.stdout[-700:],result.stderr,flush=True);assert result.returncode==0
    private=out.with_suffix('.unpacked.w3x');write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    packed=MPQ(str(out))
    for n,data in files.items():assert packed.read(n)==data,n
    for n in archive.read('(listfile)').decode().splitlines():
        if n not in files and n.lower() not in ('(listfile)','(attributes)','(signature)'):assert packed.read(n)==archive.read(n),n
    a,b=functions(old),functions(runtime)
    for n,body in a.items():
        expected=body.replace('QuestMessageBJ(','QuestText_Message(')
        if n=='QuestSeekDestroy_Started':expected=re.sub(r"(?m)^\s*call UnitAddAbilityBJ\('A102',GetLastCreatedUnit\(\)\)[^\n]*\n",'\n',expected)
        assert tokens(expected)==tokens(b[n]),n
    report=dict(base=str(base),output=str(out),classic=classic,sha256=hashlib.sha256(out.read_bytes()).hexdigest(),
        changed_functions=sorted(n for n in a if tokens(a[n])!=tokens(b[n])),new_functions=sorted(b.keys()-a.keys()),
        notification_sites=old.count('QuestMessageBJ('),compile='PASS',archive_readback='PASS',unrelated_resources='byte-identical',
        acceptance='Quest notifications omit blank spacers and null messages; all valid sound/text behavior retained. Three Seekers no longer granted A102. Native/multiplayer confirmation pending; desync candidate inherited unchanged.')
    out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/development/VersionFHotfix04/FFERPG-0.9.7.5f-Hotfix04.w3x',ROOT/'release/development/VersionFHotfix05/FFERPG-0.9.7.5f-Hotfix05.w3x','FFERPG 0.9.7.5f Hotfix05')
    build(ROOT/'release/development/QuickUI73/FFERPG-QuickUI73.w3x',ROOT/'release/development/QuickUI74/FFERPG-QuickUI74.w3x','FFERPG QuickUI74 (Dragoon)')
    build(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-1.29.2.w3x',ROOT/'release/development/VersionFHotfix05/FFERPG-0.9.7.5f-Hotfix05-1.29.2.w3x','FFERPG 0.9.7.5f Hotfix05 1.29.2',True)

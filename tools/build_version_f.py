"""Publish the retained release line with stable Legendary stat ownership."""
import re,json,hashlib,subprocess
from pathlib import Path
from mpq import MPQ,write_files,compact
from wct import read_wct,write_wct,text_of,raw_of
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from order_libraries import order
from jtok import functions,tokens
import legendary_stats_fix,scene_safety59
ROOT=Path(__file__).resolve().parents[1]

def label_text(s):
    s=s.replace('0.9.7.5e','0.9.7.5f')
    s=re.sub(r'0\.9\.7\.5f Hotfix\d+','0.9.7.5f',s)
    return s.replace('Hotfix16 F/G:','0.9.7.5f F/G:')

def build(base,out,*,classic=False,development=False):
    assert not out.exists(),'Never overwrite a map/release.'
    archive=MPQ(str(base));old=archive.read('war3map.j').decode().replace('\r\n','\n')
    def patch(s):
        s=legendary_stats_fix.refresh(s)
        if classic:s=scene_safety59.refresh(s)
        if not development:s=label_text(s)
        return s
    runtime=patch(old);runtime,_=order(runtime);runtime=re.sub(r'\n{3,}','\n\n',runtime)
    wct=read_wct(archive.read('war3map.wct'));wct['header']=raw_of(patch(text_of(wct['header']).replace('\r\n','\n')))
    for i,raw in enumerate(wct['entries']):
        s=text_of(raw).replace('\r\n','\n');updated=patch(s)
        if updated!=s:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
    profile='1.29.2' if classic else 'Forsaken'
    label='FFERPG QuickUI69 (Dragoon)' if development else 'FFERPG 0.9.7.5f ('+profile+')'
    strings=wts_read(archive.read('war3map.wts'))
    if not development:strings={k:label_text(v) for k,v in strings.items()}
    strings[38788]=label
    files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
    if not development:
        info=archive.read('war3map.w3i');updated=info.replace(b'0.9.7.5e',b'0.9.7.5f')
        if updated!=info:files['war3map.w3i']=updated
    out.parent.mkdir(parents=True,exist_ok=True)
    script=out.with_suffix('.j');script.write_text(runtime)
    common='tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j'
    blizzard='tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j'
    r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/common),str(ROOT/blizzard),str(script)],capture_output=True,text=True)
    print(r.stdout[-1000:],r.stderr,flush=True);assert r.returncode==0
    private=out.with_suffix('.unpacked.w3x');write_files(str(base),str(private),files);compact(str(private),str(out))
    _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
    packed=MPQ(str(out))
    for name,data in files.items():assert packed.read(name)==data,name
    for name in archive.read('(listfile)').decode().splitlines():
        if name not in files and name.lower() not in ['(attributes)','(signature)','(listfile)']:
            assert packed.read(name)==archive.read(name),name
    before,after=functions(old),functions(runtime)
    diff=sorted(n for n in before if tokens(before[n])!=tokens(after[n]))
    if not classic:
        # Label strings may change, but no unrelated implementation may change.
        assert all(tokens(label_text(before[n]) if not development else before[n])==tokens(after[n])
                   for n in before if n!='Trig_Job_Change_Actions')
    report=dict(base=str(base),output=str(out),profile=profile,development=development,
        sha256=hashlib.sha256(out.read_bytes()).hexdigest(),compile='PASS',archive_readback='PASS',
        unrelated_resources='byte-identical',changed_functions=diff,
        gameplay='Legendary +10 remains on cached hero; no duplicate activation grant. Other choice apply/remove logic preserved.',
        classic_scene_parity=classic,save_format='unchanged',client_acceptance='stat/job/load in-game confirmation pending')
    out.with_suffix('.json').write_text(json.dumps(report,indent=2))
    print(out,flush=True)

if __name__=='__main__':
    build(ROOT/'release/development/VersionEHotfix16/FFERPG-0.9.7.5e-Hotfix16-Forsaken.w3x',
        ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-Forsaken.w3x')
    build(ROOT/'release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-1.29.2.w3x',
        ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-1.29.2.w3x',classic=True)
    build(ROOT/'release/development/QuickUI68/FFERPG-QuickUI68-Forsaken.w3x',
        ROOT/'release/development/QuickUI69/FFERPG-QuickUI69-Forsaken.w3x',development=True)

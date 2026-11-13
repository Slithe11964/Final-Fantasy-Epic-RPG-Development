"""Restore verified working g's load lifecycle, keep requested recovery features."""
from build_forest86 import *
from wct import read_wct
from confirmed_g_load_recovery04 import refresh,REF,CORE
EXPECTED=set(CORE)|{'FFL_BeginAutosave','FFL_TryAutosave','FFL_QueueAutosave','Save_InitCommands','FFL_AutoStart','FFL_AutoSchedule'}

def build(base,out,label,classic=False):
 assert not out.exists()
 m=MPQ(str(base));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old,classic)
 a,b=functions(old),functions(runtime);assert a.keys()==b.keys();assert {n for n in a if tokens(a[n])!=tokens(b[n])}==EXPECTED
 reference=functions(MPQ(str(REF/('FFERPG-0.9.7.5g'+('-1.29.2' if classic else '')+'.w3x'))).read('war3map.j').decode())
 for n in reference:
  if n.startswith(('FRC_','FSC_','FST_','FFP_','Load_','Trig_Cmd_Load_Code_')) or (n.startswith('FFL_') and n!='FFL_Autosave') or n=='InitTrig_ForsakenFreshLoad':assert tokens(reference[n])==tokens(b[n]),n
 assert 'FFL_AutoInFlight' not in runtime
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n'),classic))
 for i,raw in enumerate(wct['entries']):
  source=text_of(raw).replace('\r\n','\n');updated=refresh(source,classic)
  if updated!=source:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1600:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for name in m.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(name)==files.get(name,m.read(name)),name
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),confirmed_reference=str(REF),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=sorted(EXPECTED),restored_core=CORE,acceptance='Owner confirmed TEST/TESTER/g SHA9ca785... works. Previous rollback used a newer g containing untested autosave load changes. This restores manual/load pipeline exact; actual desync root cause and this combination require native confirmation.',archive_readback='Only JASS/editor scripts changed; all other accepted UI, quests, objects and effects retained.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/GRecovery03/FFERPG-0.9.7.5g-Recovery03.w3x',ROOT/'release/development/GRecovery04/FFERPG-0.9.7.5g-Recovery04.w3x','FFERPG 0.9.7.5g Recovery04')
 build(ROOT/'release/development/GRecovery03/FFERPG-0.9.7.5g-1.29.2-Recovery03.w3x',ROOT/'release/development/GRecovery04/FFERPG-0.9.7.5g-1.29.2-Recovery04.w3x','FFERPG 0.9.7.5g Recovery04 1.29.2',True)
 build(ROOT/'release/development/V14/FFERPG-V14.w3x',ROOT/'release/development/V15/FFERPG-V15.w3x','FFERPG V15')

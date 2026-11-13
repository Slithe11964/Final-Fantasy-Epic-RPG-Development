"""Package the retained Version D Hotfix07 pair as 0.9.7.5e; labels only."""
from pathlib import Path
import sys,re,json,hashlib,subprocess,shutil
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from wct import read_wct,write_wct,raw_of,text_of
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]
VERSION='0.9.7.5e'
def rename(s):return s.replace('0.9.7.5d',VERSION)
def build():
 dest=ROOT/'release'/VERSION
 assert not dest.exists(),'Never overwrite a release'
 scratch=ROOT/'build/VersionE';scratch.mkdir(exist_ok=True)
 report=dict(version=VERSION,source='VersionDHotfix07 pair; latest bugfixes on retained Version D',changes='Version labels only relative to Hotfix07. No Dragoon or 1000 Cuts test content.',outputs={},checks={},gameplay='No new in-game acceptance claimed. Kalm crash cause/workaround remains unconfirmed.')
 for profile in ['Forsaken','1.29.2']:
  source=ROOT/f'release/development/VersionDHotfix07/FFERPG-0.9.7.5d-Hotfix07-{profile}.w3x';out=scratch/f'FFERPG-{VERSION}-{profile}.w3x'
  assert not out.exists(),out
  a=MPQ(str(source));wct=read_wct(a.read('war3map.wct'))
  wct['header']=raw_of(rename(text_of(wct['header'])));wct['entries']=[raw_of(rename(text_of(e))) for e in wct['entries']]
  files={'war3map.j':rename(a.read('war3map.j').decode()).encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write({k:rename(v) for k,v in wts_read(a.read('war3map.wts')).items()})}
  info=a.read('war3map.w3i');edited=info.replace(b'0.9.7.5d',VERSION.encode())
  if edited!=info:files['war3map.w3i']=edited
  tmp=out.with_suffix('.unpacked.w3x');write_files(str(source),str(tmp),files);compact(str(tmp),str(out));tmp.unlink()
  _,flags,players=read_header(str(source));data=out.read_bytes();out.write_bytes(build_header(f'FFERPG-{VERSION} ({profile})',flags,players)+data[data.index(b'MPQ\x1a'):])
  packed=MPQ(str(out))
  for n,v in files.items():assert packed.read(n)==v,n
  for n in a.read('(listfile)').decode().splitlines():
   if n not in files and n.lower() not in ['(attributes)','(signature)','(listfile)']:assert packed.read(n)==a.read(n),n
  common='tools/versions/1.29.2/common.j' if profile=='1.29.2' else 'tools/build-inputs/bag-quick-future-common.j';blizzard='tools/versions/1.29.2/blizzard.j' if profile=='1.29.2' else 'tools/bin/blizzard.j'
  checks={}
  for name,args in [('check_map',[str(out),'--common',common,'--blizzard',blizzard,'--baseline',str(source)]),('check_save_compat',['--map',str(out)])]:
   r=subprocess.run([sys.executable,'tools/'+name+'.py']+args,cwd=ROOT,capture_output=True,text=True)
   (scratch/f'{profile}-{name}.txt').write_text(r.stdout+r.stderr);print(profile,name,r.returncode,r.stdout[-350:],flush=True);assert r.returncode==0
   checks[name]='PASS'
  report['checks'][profile]=checks
  report['outputs'][profile]=dict(file=out.name,bytes=out.stat().st_size,sha256=hashlib.sha256(out.read_bytes()).hexdigest(),source=str(source.relative_to(ROOT)),source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),map_list_name=read_header(str(out))[0])
 dest.mkdir()
 for profile,row in report['outputs'].items():
  shutil.copy2(scratch/row['file'],dest/row['file']);assert hashlib.sha256((dest/row['file']).read_bytes()).hexdigest()==row['sha256']
  for name in ['check_map','check_save_compat']:shutil.copy2(scratch/f'{profile}-{name}.txt',dest/f'{profile}-{name}.txt')
 (dest/'release-report.json').write_text(json.dumps(report,indent=2)+'\n')
 (dest/'RELEASE_NOTES.md').write_text('''# FF Epic RPG 0.9.7.5e

Bugfix release from 0.9.7.5d Hotfix07, with updated version labels. Includes initial-load hero growth/Chronicle refresh, Barrel Collector rename and inventory coverage, Divine Shield native miss/slow correction, teleporter Escape, house-anchored armory browsing, and all-three-Kalm wave-counter hardening/portrait-free dialogue workaround. Save format unchanged. The Kalm crash cause remains unconfirmed; real-client multiplayer acceptance is still needed. Dragoon and 1000 Cuts test content are not included.

Both playable/editor scripts, startup consistency and baseline sequence, globals, text safety and save compatibility passed. See release-report.json and included check logs. Original 0.9.7.5d remains preserved.
''')
 print('RELEASE READY',dest,flush=True)
if __name__=='__main__':build()

"""Production g: hide carried Maiden's Eye sight without changing its gameplay."""
from build_forest86 import *
import maidens_eye
from types import SimpleNamespace
DIR=ROOT/'release/development/VersionGHotfix03'
def build(classic=False):
 name='FFERPG-0.9.7.5g'+('-1.29.2' if classic else '')
 base=ROOT/'release/0.9.7.5g'/(name+'.w3x');out=DIR/(name+'-Hotfix03.w3x')
 assert not out.exists();m=MPQ(str(base));files={}
 files['war3map.w3a']=maidens_eye.objects(m.read('war3map.w3a'))
 skin=m.read('war3mapSkin.w3a')
 if skin:
  t=read_objects(skin,'w3a');changed=False
  for o in t['original']+t['custom']:
   if (o['id'] or o['base'])=='aMEy':
    setf(o,'abpx',0,0);setf(o,'abpy',-11,0);changed=True
  if changed:files['war3mapSkin.w3a']=write_objects(t,t['version'],'w3a')
 DIR.mkdir(parents=True,exist_ok=True);tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 new=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(file)==files.get(file,m.read(file)),file
 before=all_objects(SimpleNamespace(archive=m),'w3a');after=all_objects(SimpleNamespace(archive=new),'w3a');assert before.keys()==after.keys()
 for raw in before:
  if raw!='aMEy':assert before[raw]==after[raw],raw
 f=fields(after['aMEy']);old=fields(before['aMEy'])
 assert f['abpx',0]==0 and f['abpy',0]==-11
 assert {k:v for k,v in f.items() if k[0] not in ['abpx','abpy']}=={k:v for k,v in old.items() if k[0] not in ['abpx','abpy']}
 assert after['aMEy']['base']=='Atru'
 out.with_suffix('.j').write_bytes(new.read('war3map.j'))
 report=dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),change='aMEy command button hidden at (0,-11). True Sight inheritance, radius, item data, scripts, save and gameplay unchanged.',archive_readback='PASS',object_isolation='PASS',live_test='pending')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(out)
if __name__=='__main__':build();build(True)

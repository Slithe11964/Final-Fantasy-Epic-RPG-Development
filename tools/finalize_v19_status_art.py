"""Use a verified native icon and explicit air/ground self-target aura flags."""
from build_f1030_inventory_rollback import *
paths=[ROOT/'release/development/V19/FFERPG-V19.w3x',ROOT/'release/development/GRecovery08/FFERPG-0.9.7.5g-Recovery08.w3x',ROOT/'release/development/GRecovery08/FFERPG-0.9.7.5g-1.29.2-Recovery08.w3x',ROOT/'release/development/CreatureReview03q/FFERPG-Creature-Review-03q.w3x']
for path in paths:
 m=MPQ(str(path));files={}
 for ext in ['w3a','w3h']:
  data=m.read('war3map.'+ext);t=read_objects(data,ext)
  for o in t['original']+t['custom']:
   raw=o['id'] or o['base']
   if raw=='aE19' or (raw.startswith('bE') and raw[2:].isdigit() and 1<=int(raw[2:])<=10):
    for st in o['sets']:
     for mod in st['mods']:
      if isinstance(mod['value'],str):
       mod['value']=mod['value'].replace('BTNExperience.blp','BTNTomeOfRetraining.blp')
       if raw=='aE19' and mod['field']=='atar':mod['value']='air,ground,self'
  files['war3map.'+ext]=write_objects(t,t['version'],ext)
 history=path.parent/'history-before-status-art-verification';history.mkdir(exist_ok=True)
 old=history/path.name;assert not old.exists();path.rename(old)
 temp=path.with_suffix('.status-unpacked.w3x');write_files(str(old),str(temp),files);compact(str(temp),str(path))
 # MPQ writer preserves the map prefix; retain the existing display header.
 original=old.read_bytes();d=path.read_bytes();path.write_bytes(original[:original.index(b'MPQ\x1a')]+d[d.index(b'MPQ\x1a'):])
 final=MPQ(str(path))
 for n in m.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(n)==files.get(n,m.read(n)),n
 manifest=path.with_suffix('.json') if path.with_suffix('.json').exists() else path.parent/'checks.json'
 report=json.loads(manifest.read_text());report['sha256']=hashlib.sha256(path.read_bytes()).hexdigest();report['status_art']='Verified native Tome of Retraining icon; explicit air,ground,self aura targets; scripts and all other resources unchanged.';manifest.write_text(json.dumps(report,indent=2));print(path.name,report['sha256'])

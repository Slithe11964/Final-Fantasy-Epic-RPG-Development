"""Scope and native object readback for the combined V19 session."""
from build_f1030_inventory_rollback import *
from priest_master import fields
reports=[]
for folder,name,bfolder,bname in [('V19','FFERPG-V19','V18','FFERPG-V18'),('GRecovery08','FFERPG-0.9.7.5g-Recovery08','GRecovery07','FFERPG-0.9.7.5g-Recovery07'),('GRecovery08','FFERPG-0.9.7.5g-1.29.2-Recovery08','GRecovery07','FFERPG-0.9.7.5g-1.29.2-Recovery07')]:
 a=view(str(ROOT/f'release/development/{bfolder}/{bname}.w3x'));b=view(str(ROOT/f'release/development/{folder}/{name}.w3x'))
 for lib in a.modules:
  if lib.startswith('TForsaken') or lib in ['TSave','TLoad','TAutosave','TCine','TFirefly','TJob','TShrine']:
   assert tokens(a.modules[lib])==tokens(b.modules[lib]),lib
 fs=functions(b.runtime)
 if 'Forsaken_BackpackVisible' in fs:
  assert 'Forsaken_HideInventory()' not in fs['Forsaken_BackpackVisible']
  assert 'ForsakenNativeFrame' not in fs['Forsaken_HideInventory']
  assert 'Preview75Caster' in fs['Wave65_Draw']
  assert 'Player_GetHero(GetLocalPlayer())' in fs['Wave65_Draw']
 assert 'GetLocalPlayer' not in fs['NG19_Factor']+fs['NG19_Buff']+fs['NG19_SyncBuffs']
 aa,bb=all_objects(a,'w3a'),all_objects(b,'w3a')
 changed={r for r in aa if aa[r]!=bb[r]}
 expected={'A02F'}|({'zDY9','zSY9','zEN9','zEG9','zIF9','zRT9','zAW9'} if folder=='V19' else set())
 assert changed==expected,(folder,changed)
 assert set(bb)-set(aa)=={'aE19'}
 o=bb['A02F']
 for m in [m for st in o['sets'] for m in st['mods'] if m['field']=='Ihid']:
  assert m['data']==4
  assert m['value']==(1 if m['level']==1 else 0)
 ng=fields(bb['aE19']);assert ng['atar',9]=='air,ground,self' and ng['abuf',9]=='bE09'
 assert 'BTNTomeOfRetraining' in ng['aart',0]
 buffs=all_objects(b,'w3h');assert '+90%' in fields(buffs['bE09'])['ftip',None]
 assert 'NG19_' not in b.modules['TFirefly']
 assert 'Inventory94' not in b.runtime and 'FFL94' not in b.runtime and 'Idle76_' not in b.runtime
 reports.append(dict(map=name,save_load_autosave_format='unchanged',native_mastery_object='Data D pointer 4, visible at ranks 5-9',ng9_status='bE09 +90%',preview='hero/Gaya visual handlers only' if 'Preview75_Selected' in fs else 'classic native UI unchanged',scope='PASS'))
(ROOT/'release/development/V19/source-verification.json').write_text(json.dumps(reports,indent=2))
print('PASS profile/source scope and native Mastery/NG+ object readback')

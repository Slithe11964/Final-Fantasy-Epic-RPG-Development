"""Record gameplay scope, tooltip, pool and production parity checks."""
from build_f1030_inventory_rollback import *
from priest_master import fields
from build_removals91 import pool_blocks
reports=[]
for folder,name,basefolder,basename in [('V18','FFERPG-V18','V17','FFERPG-V17'),('GRecovery07','FFERPG-0.9.7.5g-Recovery07','GRecovery06','FFERPG-0.9.7.5g-Recovery06'),('GRecovery07','FFERPG-0.9.7.5g-1.29.2-Recovery07','GRecovery06','FFERPG-0.9.7.5g-1.29.2-Recovery06')]:
 a=view(str(ROOT/f'release/development/{basefolder}/{basename}.w3x'));b=view(str(ROOT/f'release/development/{folder}/{name}.w3x'))
 af,bf=functions(a.runtime),functions(b.runtime)
 changed={n for n in af if n in bf and tokens(af[n])!=tokens(bf[n])}
 for lib in a.modules:
  if lib.startswith('TForsaken') or lib in ['TSave','TLoad','TAutosave','TCine','TTravel'] or 'Arena' in lib:
   assert tokens(a.modules[lib])==tokens(b.modules[lib]),lib
 if folder=='GRecovery07':assert changed<= {'Forsaken_ElementAbilityLevel'},changed
 else:
  assert changed=={'Forest86_Init','Forest86_Pool','Forest86_Tick','Forsaken_ElementAbilityLevel','H90_Whirl','Trig_Spawn_Pools_Init_Actions','Trig_Spell_LiquidSteel_Actions'},changed
  assert 'D7Badge' not in b.runtime and 'D7_Badge' not in b.runtime
  aa,bb=all_objects(a,'w3a'),all_objects(b,'w3a')
  assert {r for r in aa if aa[r]!=bb[r]}=={'hWW0','hAA0'}
  assert '300 physical damage per second' in fields(bb['hWW0'])['aub1',1]
  assert '120 wind-elemental physical damage per bounce' in fields(bb['hAA0'])['aub1',1]
  blocks=list(pool_blocks(bf['Trig_Spawn_Pools_Init_Actions']))
  assert all("'nspb'" not in m[0] for m,d,z in blocks if z==1)
  assert sum("'nspb'" in m[0] for m,d,z in blocks if z==5)==2
 reports.append(dict(map=name,inventory_autosave_load_cinematics_arenas='unchanged',changed_functions=sorted(changed),mastery_save_format='Unchanged; records tier and loads default +10 stats, not shrine selection.'))
(ROOT/'release/development/V18/source-verification.json').write_text(json.dumps(reports,indent=2))
print('PASS all three source scope, tooltip and spawn-pool checks')

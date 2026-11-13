"""Verify rollback intent and unchanged profile/object/runtime boundaries."""
from build_f1030_inventory_rollback import *
paths=[ROOT/'release/development/V23/FFERPG-V23.w3x',ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x',ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-1.29.2-Recovery12.w3x']
rows=[]
for path in paths:
 meta=json.loads(path.with_suffix('.json').read_text());a=view(meta['base']);b=view(str(path));af=functions(a.runtime);bf=functions(b.runtime)
 assert 'Bag22' not in b.runtime
 for lib in a.modules:
  if lib.startswith('TForsaken') and lib!='TForsakenUIRecovery':assert tokens(a.modules[lib])==tokens(b.modules[lib]),lib
 for n in af:
  if n.startswith(('FRC_','FSC_','FST_','FFL_','FFP_','FFN_')):assert tokens(af[n])==tokens(bf[n]),n
 if '1.29.2' not in path.name:
  for n in ['QuickGear_Init','QuickGear_DrawWheel','QuickGear_PaintIcon','QuickGear_Receive','Forsaken_BackpackVisible','Forsaken_PollPanels','Forsaken_CloseBackpack','Forsaken_RequestBackpackToggle','Forsaken_CarryOrder','Forsaken_OnEquip']:
   assert tokens(af[n])==tokens(bf[n]),n
  assert 'BlzFrameSetVisible(QuickGearNativeWheel[i],false)' in bf['C20_HideUI']
  assert 'BlzFrameSetEnable(QuickGearButton[i],false)' in bf['C23_PauseControls']
 assert af['Chronicles_Init'].count('CreateTimer()')==bf['Chronicles_Init'].count('CreateTimer()')
 assert [n for n,s in bf.items() if 'ShowInterface(false' in s]==['Cine_Enter']
 changed={n for n in af if tokens(af[n])!=tokens(bf[n])};assert changed==set(meta['changed_functions'])
 for name in a.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)','war3map.j','war3map.wct']:assert a.archive.read(name)==b.archive.read(name),name
 rows.append(dict(map=path.name,base=meta['base'],sha256=hashlib.sha256(path.read_bytes()).hexdigest(),scope='PASS',rollback='Recovery11 pane restoration/renderer changes absent',profile_and_inventory_gameplay='unchanged',native_cross_player_closure='UNRESOLVED',cutscene_live_test='pending'))
(ROOT/'release/development/V23/source-verification.json').write_text(json.dumps(rows,indent=2));print('PASS rollback baseline, renderer, profile, inventory gameplay, common cinematic entry and archive isolation')

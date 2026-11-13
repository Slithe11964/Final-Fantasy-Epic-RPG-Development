"""Record exact V19 preservation and cinematic/capture/cast invariants."""
from build_f1030_inventory_rollback import *
from priest_master import fields
reports=[]
for folder,name,bfolder,bname in [('V20','FFERPG-V20','V19','FFERPG-V19'),('GRecovery09','FFERPG-0.9.7.5g-Recovery09','GRecovery08','FFERPG-0.9.7.5g-Recovery08'),('GRecovery09','FFERPG-0.9.7.5g-1.29.2-Recovery09','GRecovery08','FFERPG-0.9.7.5g-1.29.2-Recovery08')]:
 path=ROOT/f'release/development/{folder}/{name}.w3x'
 a=view(str(ROOT/f'release/development/{bfolder}/{bname}.w3x'));b=view(str(path))
 af,bf=functions(a.runtime),functions(b.runtime)
 for lib in a.modules:
  if lib in ['TExp','TReward','TArenaRewards','TFirefly','TJob','TShrine','TTravel'] or ('Arena' in lib):assert tokens(a.modules[lib])==tokens(b.modules[lib]),lib
 for n,body in af.items():
  if n.startswith(('FSC_','FSS_','FSR_','FST_','FFP_','FFN_')) or n in ['FRC_StartNow','FRC_Start','FRC_Step','FFL_Apply','FFL_Commit','FFL_BeginSave']:
   assert tokens(body)==tokens(bf[n]),n
 assert 'FRC_StartNow' not in bf['C20_BeginAutosave']
 assert 'TimerStart(FRC_Timer[pid],.1,true,function FRC_Tick)' in bf['C20_BeginAutosave']
 assert 'C20_BeginAutosave(pid)' in bf['Restore_AutosaveTick']
 enter=bf['Cine_Enter']
 for hook in ['C20_ProfilePause','C20_CooldownPause']+(['C20_UIPause'] if 'C20_UIPause' in bf else []):assert enter.index(hook)<enter.index('call GroupEnumUnitsInRect')
 assert 'ForceUICancel' not in enter
 assert 'C20_ProfileResume' in bf['Cine_Exit']
 if 'C20_UIPause' in bf:
  for getter in ['BlzGetFrameByName','BlzGetOriginFrame','BlzGetUnitAbility','BlzUnitItemIn','GetItemTypeId','CreateTimer','CreateGroup','CreateUnit','CreateImage']:
   assert getter not in bf['C20_HideUI'],getter
  assert 'call DisableTrigger(gg_trg_Forsaken_Equipment)' in bf['C20_UIPause']
  assert bf['QuickGear_Receive'].index('if udg_InCinematicMode')<bf['QuickGear_Receive'].index('set carried=QuickGear_Item')
  assert 'call Forsaken_CarryOrder(holder)' in bf['Forsaken_OnEquip']
  assert 'now>=ForsakenInventoryBindUntil then\n        set visible=false' not in bf['Forsaken_BackpackVisible']
 assert a.archive.read('war3map.w3u')==b.archive.read('war3map.w3u')
 aa,bb=all_objects(a,'w3a'),all_objects(b,'w3a')
 changed={r for r in aa if aa[r]!=bb[r]}
 assert changed==({'zCI9'} if folder=='V20' else set()),changed
 assert aa['A02F']==bb['A02F'] and aa['aE19']==bb['aE19']
 if folder=='V20':
  assert fields(bb['zCI9'])['aite',0]==1
  assert 'UnitUseItemTarget(dummy,wand,target)' in bf['C20_ShadowCopy']
  assert 'GetUnitTypeId(child)!=GetUnitTypeId(LoadUnitHandle' in bf['F99_Summoned']
  assert set(all_objects(b,'w3t'))-set(all_objects(a,'w3t'))=={'iC20'}
  assert fields(all_objects(b,'w3t')['iC20'])['iper',None]==0
 report=json.loads(path.with_suffix('.json').read_text())
 report['changed_modules']=sorted(k for k in a.modules if tokens(a.modules[k])!=tokens(b.modules[k]))
 report['changed_functions']=sorted(n for n in af if n in bf and tokens(af[n])!=tokens(bf[n]))
 report['new_functions']=sorted(bf.keys()-af.keys())
 path.with_suffix('.json').write_text(json.dumps(report,indent=2))
 reports.append(dict(map=name,sha256=hashlib.sha256(path.read_bytes()).hexdigest(),V19_XP_mastery_balance_arenas='preserved',save_format_and_manual_capture_codec='unchanged',global_cinematic_handoff='before selection/unit pause',autosave='staged 10Hz, one active capture; retries only after shared capture validation fails',scope='PASS'))
(ROOT/'release/development/V20/source-verification.json').write_text(json.dumps(reports,indent=2))
print('PASS V19 preservation, profile format/manual capture, native proxy and cinematic source invariants')

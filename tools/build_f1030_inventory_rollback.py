"""Restore dated f inventory/load systems, retaining unrelated development content."""
from build_forest86 import *
from editor_pair import View,runtime_for,decls,put_globals
from editor_layout import trigger_items
from wtg import read_wtg
from wct import read_wct
from downgrade import wts_read
from functools import lru_cache
FOLDER=ROOT/'release/0.9.7.5f/2026-10-30'
FULL=['TUnit','TEquip','TItemCooldown','TSave','TLoad','TAutosave','TGame']
READOUTS=['Forsaken_Stat_GetAccuracy','Forsaken_Stat_GetEvasion','Forsaken_Stat_GetElementBonus','Forsaken_Stat_GetElementResist','Forsaken_StatOutgoing','Forsaken_StatHealingReceived','Forsaken_RenderGearDamage']
GUARDS={'TTalents':['Talent_ShieldDisplayTick'],'TPassive':['Trig_Passive_Bonus_Sync_Actions'],'TStatus':['Trig_Status_AutoCleanse_Actions'],'TTitles':['Chronicles_Tick'],'TCine':['Cine_Enter','Cine_Exit']}

@lru_cache(maxsize=6)
def view(path):
 path=Path(path);m=MPQ(str(path));wct=read_wct(m.read('war3map.wct'))
 if wct['format']=='reforged':return View(path)
 v=object.__new__(View);v.path=path;v.archive=m;v.wct=wct;v.tree=read_wtg(m.read('war3map.wtg'));v.modules={};v.entries={};v.objects={};v.strings=wts_read(m.read('war3map.wts'));v.runtime=m.read('war3map.j').decode().replace('\r\n','\n')
 for item,raw in zip(trigger_items(v.tree),wct['entries']):
  s=text_of(raw).replace('\r\n','\n');match=re.match(r'\s*library\s+(\w+)',s)
  if match:v.modules[match[1]]=s;v.entries[match[1]]=item
 return v

def equip_dev(base,current):
 # Control flow / inventory bindings are the contemporaneous development UI74,
 # not post-f UI75+ or the production Lancer-specific presentation.
 source=base;old,new=functions(base),functions(current)
 source=source.replace(source.splitlines()[0],current.splitlines()[0],1)
 for n in READOUTS:source=put(source,n,new[n])
 # Retain authored spear proficiency mana and the Icy Realm healing debuff.
 n='Forsaken_ReadRegeneration';b=old[n]
 b=b.replace('    set ForsakenHPFlat=0.','    if I2_Active(hero,40) then\n        set hp=hp+LoadReal(I2Data,GetHandleId(hero),41)\n    endif\n    set ForsakenHPFlat=0.',1)
 b=b.replace('    set ForsakenMPRegen=mp*(1.+ForsakenMPPercent)+mpAura','    if I2_Active(hero,40) then\n        set ForsakenHPRegen=ForsakenHPRegen*.5\n    endif\n    set ForsakenMPRegen=mp*(1.+ForsakenMPPercent+.05*I2R(Prof_GetLevel(hero,\'R009\')))+mpAura',1)
 source=put(source,n,b)
 # Existing shared proficiency update only; no inventory snapshot/read caching.
 n='Forsaken_PrepareInventories';b=old[n];assert '        call Inventory71_Reconcile(hero,i)' in b
 b=b.replace('        call Inventory71_Reconcile(hero,i)','        call Inventory71_Reconcile(hero,i)\n        call Spear80_SyncMana(hero)',1)
 source=put(source,n,b);anchor='function Forsaken_PrepareInventories takes';source=source.replace(anchor,new['Spear80_SyncMana']+'\n\n'+anchor,1)
 return source

def build(base,out,label,classic=False,dev=False):
 assert not out.exists()
 v=view(str(base));reference=view(str(FOLDER/('FFERPG-0.9.7.5f'+('-1.29.2' if classic else '')+'.w3x')))
 invref=view(str(ROOT/'release/development/QuickUI74/FFERPG-QuickUI74.w3x')) if dev else reference
 modules=dict(v.modules);restored=[]
 for lib in FULL:
  if lib in reference.modules and lib in modules:
   modules[lib]=invref.modules[lib] if dev and lib in ['TUnit','TEquip'] else reference.modules[lib];restored.append(lib)
 # All profile, transport, validation, commit/rollback and native-game UI recovery.
 for lib in reference.modules:
  if lib.startswith('TForsaken') and lib in modules:modules[lib]=reference.modules[lib];restored.append(lib)
 for lib,names in GUARDS.items():
  if lib not in modules:continue
  current=modules[lib];f=functions(reference.modules[lib])
  for name in names:current=put(current,name,f[name])
  modules[lib]=current
 if dev:
  modules['TEquip']=equip_dev(invref.modules['TEquip'],v.modules['TEquip'])
  modules['TProf']=modules['TProf'].replace('Inventory94_EquipmentType(','BlzGetItemEquipmentType(')
  b=functions(modules['TMonsterData'])['D7_BadgeDraw'];assert ' or Inventory94Paused' in b
  modules['TMonsterData']=put(modules['TMonsterData'],'D7_BadgeDraw',b.replace(' or Inventory94Paused','',1))
 rt=runtime_for(v,v,v,modules);rt,_=order(rt)
 # No post-reference inventory guards, ability catalogue, idle scans, snapshots,
 # six-slot polling additions or alternate autosave worker may survive.
 for token in ['Inventory94','FFL94','Inventory05','Load04_','FFL_AutoTimer','FFL_AutoRetry','FFL_AutoPending','FFL_AutoOptOut','FFL_AutoInFlight','FFL_AutoRepeating','Idle76_','Preview75']:
  assert token not in rt,token
 for i,raw in enumerate(v.wct['entries']):
  s=text_of(raw).replace('\r\n','\n');match=re.match(r'\s*library (\w+)',s)
  if match and match[1] in modules and modules[match[1]]!=s:v.wct['entries'][i]=raw_of(modules[match[1]].replace('\n','\r\n'))
 files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(rt)
 common=ROOT/('tools/versions/1.29.2/common.j' if classic else 'tools/build-inputs/bag-quick-future-common.j');bliz=ROOT/('tools/versions/1.29.2/blizzard.j' if classic else 'tools/bin/blizzard.j')
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(common),str(bliz),str(out.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-3500:],r.stderr);assert r.returncode==0
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out));_,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 final=MPQ(str(out))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(name)==files.get(name,v.archive.read(name)),name
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),reference=str(reference.path),reference_sha256=hashlib.sha256(reference.path.read_bytes()).hexdigest(),inventory_dev_reference=str(invref.path),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),restored_libraries=sorted(set(restored)),removed='All post-f Inventory94/FFL94/static ability catalogue/idle/six-slot preview additions/autosave queue and load guard changes.',retained='All non-inventory quest/content/object/asset changes. Development job/monster readouts and spear proficiency formulas explicitly retained.',acceptance='Requested dated f rollback; reference and output multiplayer stability not confirmed.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/GRecovery04/FFERPG-0.9.7.5g-Recovery04.w3x',ROOT/'release/development/GRecovery05/FFERPG-0.9.7.5g-Recovery05.w3x','FFERPG 0.9.7.5g Recovery05')
 build(ROOT/'release/development/GRecovery04/FFERPG-0.9.7.5g-1.29.2-Recovery04.w3x',ROOT/'release/development/GRecovery05/FFERPG-0.9.7.5g-1.29.2-Recovery05.w3x','FFERPG 0.9.7.5g Recovery05 1.29.2',True)
 build(ROOT/'release/development/V15/FFERPG-V15.w3x',ROOT/'release/development/V16/FFERPG-V16.w3x','FFERPG V16',dev=True)

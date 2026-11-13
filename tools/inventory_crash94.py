"""Bounded object-data item abilities and quiescent gear UI at scene boundaries."""
import re,copy,json
from pathlib import Path
from jtok import functions
from performance_runtime import put
from build_forest86 import all_objects
from asset_gallery_catalogue import slk
from priest_master import fields
from downgrade import wts_read
ROOT=Path(__file__).resolve().parents[1]

def catalog(view):
 stock={r['itemID']:r for r in slk((ROOT/'tools/build-inputs/itemdata-crash94.slk').read_bytes())}
 result={raw:[a for a in row.get('abilList','').split(',') if len(a)==4] for raw,row in stock.items()}
 for raw,obj in all_objects(view,'w3t').items():
  value=fields(obj).get(('iabi',None),stock.get(obj['base'],{}).get('abilList',''))
  result[raw]=[a.strip() for a in str(value).split(',') if len(a.strip())==4]
 assert all(len(ids)<=32 for ids in result.values())
 return result

def presentations(view):
 def profile(path):
  result={};section=None
  for line in path.read_text(encoding='utf-8-sig',errors='replace').splitlines():
   line=line.strip()
   if line.startswith('[') and line.endswith(']'):section=line[1:-1];result.setdefault(section,{})
   elif section and '=' in line and not line.startswith('//'):
    key,value=line.split('=',1);result[section][key.lower()]=value.strip().strip('"')
  return result
 art=profile(ROOT/'tools/tests/fixtures/historical-build/itemfunc-crash94.txt');text=profile(ROOT/'tools/tests/fixtures/historical-build/itemstrings-crash94.txt');w=wts_read(view.archive.read('war3map.wts'))
 icons={r:d.get('art','') for r,d in art.items()};tips={r:d.get('ubertip','') for r,d in text.items()}
 def resolve(s):return w.get(int(s[8:]),s) if isinstance(s,str) and s.startswith('TRIGSTR_') else s
 for raw,o in all_objects(view,'w3t').items():
  f=fields(o);icons[raw]=str(resolve(f.get(('iico',None),art.get(o['base'],{}).get('art',''))));tips[raw]=str(resolve(f.get(('utub',None),text.get(o['base'],{}).get('ubertip',''))))
 return icons,tips

def insert_guard(body,guard):
 lines=body.splitlines();i=next(i for i,l in enumerate(lines) if l.lstrip().startswith('function '))+1
 while i<len(lines) and (not lines[i].strip() or lines[i].lstrip().startswith(('local ','//'))):i+=1
 return '\n'.join(lines[:i]+guard.splitlines()+lines[i:])

UNIT_HELPERS='''function Inventory94_EquipmentType takes item carried returns equipmentType
 if carried==null or GetItemTypeId(carried)==0 then
 return EQUIPMENT_TYPE_NONE
 endif
 return BlzGetItemEquipmentType(carried)
endfunction
function Inventory94_Count takes item carried returns integer
 if carried==null or GetItemTypeId(carried)==0 then
 return 0
 endif
 return LoadInteger(Inventory94Data,GetItemTypeId(carried),0)
endfunction
function Inventory94_Ability takes item carried,integer index returns integer
 if index<0 or index>=Inventory94_Count(carried) then
 return 0
 endif
 return LoadInteger(Inventory94Data,GetItemTypeId(carried),index+1)
endfunction
function Inventory94_HasAbility takes item carried,integer raw returns boolean
 if carried==null or GetItemTypeId(carried)==0 or not LoadBoolean(Inventory94Data,GetItemTypeId(carried),raw) then
 return false
 endif
 return not (LoadBoolean(ForsakenBagAbilities,GetHandleId(carried),-1) and LoadBoolean(ForsakenBagPassiveTypes,0,raw))
endfunction
function Inventory94_Icon takes item carried returns string
 local string path=""
 if carried!=null and GetItemTypeId(carried)!=0 then
 set path=LoadStr(Inventory94Data,GetItemTypeId(carried),-10)
 endif
 if path==null or path=="" then
 return "ReplaceableTextures\\\\CommandButtons\\\\BTNSelectHeroOn.blp"
 endif
 return path
endfunction
function Inventory94_Tooltip takes item carried returns string
 local string text=""
 if carried!=null and GetItemTypeId(carried)!=0 then
 set text=LoadStr(Inventory94Data,GetItemTypeId(carried),-11)
 endif
 if text==null then
 return ""
 endif
 return text
endfunction
'''

UI_HELPERS='''function Inventory94_Blocked takes nothing returns boolean
 local integer pid=GetPlayerId(GetLocalPlayer())
 if Inventory94Paused or InventoryCinematicActive or udg_InCinematicMode then
 return true
 endif
 return TimerGetElapsed(NativeCDClock)<Inventory94ResumeUntil or (pid<8 and TimerGetElapsed(NativeCDClock)<Inventory94Until[pid])
endfunction
function Inventory94_ClearLocal takes nothing returns nothing
 local integer slot=0
 set QuickGearPending=-1
 set QuickGearPendingHero=0
 set QuickGearPendingItem=0
 set QuickGearPendingMark=0
 set QuickGearHeld[0]=false
 set QuickGearHeld[1]=false
 set GearInputTarget=false
 set GearInputHoverSlot=0
 set GearInputLeft=false
 set QuickGearMouseKnown=false
 set BagMoving64=false
 set BagLeft64=false
 set BagRight64=false
 set BagHoverSlot64=-1
 set BagSourceSlot66=-1
 set BagCarried66=null
 set Preview75Caster=null
 set UI73ClearRequested=false
 set UI73AimRevision=UI73AimRevision+1
 call QuickGear_ClearPreview()
 call Wave65_Clear()
 set GearCursorErrorUntil60=0.
 if GearCursorError60!=null then
 call BlzFrameSetVisible(GearCursorError60,false)
 endif
 if QuickGearRoot!=null then
 call BlzFrameSetVisible(QuickGearRoot,false)
 endif
 set QuickGearShown=false
 set QuickGearReady=false
 set ForsakenPanelOpen=false
 set ForsakenInspectTarget=null
 if ForsakenTalentRoot!=null then
 call BlzFrameSetVisible(ForsakenTalentRoot,false)
 endif
 if ForsakenTalentToggle!=null then
 call BlzFrameSetVisible(ForsakenTalentToggle,false)
 endif
 if ForsakenInspectRoot!=null then
 call BlzFrameSetVisible(ForsakenInspectRoot,false)
 endif
 if ForsakenInspectButton!=null then
 call BlzFrameSetVisible(ForsakenInspectButton,false)
 endif
 if ForsakenBackpackClose!=null then
 call BlzFrameSetVisible(ForsakenBackpackClose,false)
 endif
 if ForsakenLinkedBagClose!=null then
 call BlzFrameSetVisible(ForsakenLinkedBagClose,false)
 endif
 if CarryUIRoot!=null then
 call BlzFrameSetVisible(CarryUIRoot,false)
 endif
 if ForsakenHolyBoltsAttached and ForsakenAttackCommand!=null then
 call BlzFrameSetTooltip(ForsakenAttackCommand,null)
 set ForsakenHolyBoltsAttached=false
 endif
endfunction
function Inventory94_Changed takes unit holder returns nothing
 local integer pid
 if holder==null or GetUnitTypeId(holder)==0 then
 return
 endif
 set pid=GetPlayerId(GetOwningPlayer(holder))
 if pid>=8 then
 return
 endif
 set Inventory94Until[pid]=TimerGetElapsed(NativeCDClock)+.2
 if GetLocalPlayer()==GetOwningPlayer(holder) then
 call Inventory94_ClearLocal()
 endif
endfunction
function Inventory94_CineEnter takes nothing returns nothing
 call Inventory94_ClearLocal()
 call ForceUICancel()
endfunction
function Inventory94_CineExit takes nothing returns nothing
 local integer pid=GetPlayerId(GetLocalPlayer())
 local integer key
 local integer slot=0
 if pid<8 then
 set Inventory94ResumeUntil=TimerGetElapsed(NativeCDClock)+.2
 loop
 exitwhen slot>=2
 if slot==0 then
 set key=QuickGearWeaponKey[pid]
 else
 set key=QuickGearOffhandKey[pid]
 endif
 set GearRawDown64[slot]=BlzIsKeyPressed(ConvertOsKeyType(key))
 set slot=slot+1
 endloop
 endif
 set QuickGearReady=false
 set QuickGearSeenRevision=-1
endfunction
'''

def refresh(source,items,icons=None,tips=None):
 icons=icons or {};tips=tips or {}
 fs=functions(source)
 # No engine equipment-type query may receive null or a retired item handle.
 source=source.replace('BlzGetItemEquipmentType(','Inventory94_EquipmentType(').replace('BlzGetItemIconPath(','Inventory94_Icon(').replace('BlzGetItemExtendedTooltip(','Inventory94_Tooltip(')
 fs=functions(source)
 for n,b in fs.items():
  new=b
  if n in ['Forsaken_ActiveGear','QuickGear_Item','Idle76_Item']:
   parameter='holder' if n=='Forsaken_ActiveGear' else 'hero'
   new=insert_guard(new,'    if '+parameter+'==null or GetUnitTypeId('+parameter+')==0 then\n        return null\n    endif')
  if n=='Forsaken_SuspendStoredItem':
   new=new.replace('if carried==null or LoadBoolean','if carried==null or GetItemTypeId(carried)==0 or LoadBoolean',1)
   new=new.replace('        set itemAbility=BlzGetItemAbilityByIndex(carried,index)\n        exitwhen itemAbility==null\n        set raw=BlzGetAbilityId(itemAbility)','        exitwhen index>=Inventory94_Count(carried)\n        set raw=Inventory94_Ability(carried,index)',1)
   new=new.replace('    call SaveInteger(ForsakenBagAbilities,key,0,count)','    call SaveInteger(ForsakenBagAbilities,key,-2,GetItemTypeId(carried))\n    call SaveInteger(ForsakenBagAbilities,key,0,count)',1)
  if n=='Forsaken_RestoreStoredItem':
   new=new.replace('if carried==null or not LoadBoolean','if carried==null or GetItemTypeId(carried)==0 or not LoadBoolean',1)
   new=new.replace('    loop','    if HaveSavedInteger(ForsakenBagAbilities,key,-2) and LoadInteger(ForsakenBagAbilities,key,-2)!=GetItemTypeId(carried) then\n        call FlushChildHashtable(ForsakenBagAbilities,key)\n        return\n    endif\n    loop',1)
  if n=='Forsaken_SyncStoredEffects':new=insert_guard(new,'    if holder==null or GetUnitTypeId(holder)==0 then\n        return\n    endif')
  if n in ['Forsaken_ActiveAbilityLevel','Forsaken_ElementAbilityLevel','Forsaken_StatAbilityLevelUncached']:
   itemname='gear' if n!='Forsaken_ActiveAbilityLevel' else 'carried';var='level' if n=='Forsaken_StatAbilityLevelUncached' else 'rank'
   pattern=r'(?m)^([ \t]*)set index=0\n\s*loop\n\s*exitwhen '+itemname+r'==null\n\s*set itemAbility=BlzGetItemAbilityByIndex\('+itemname+r',index\)\n\s*exitwhen itemAbility==null\n\s*if BlzGetAbilityId\(itemAbility\)==raw then\n\s*set '+var+r'=1\n\s*endif\n\s*set index=index\+1\n\s*endloop'
   new,count=re.subn(pattern,lambda m:m[1]+'if Inventory94_HasAbility('+itemname+',raw) then\n'+m[1]+'    set '+var+'=1\n'+m[1]+'endif',new);assert count==1,n
   holder='hero' if n=='Forsaken_StatAbilityLevelUncached' else 'holder';new=insert_guard(new,'    if '+holder+'==null or GetUnitTypeId('+holder+')==0 then\n        return 0\n    endif')
  if n=='Forsaken_ReadRegeneration':
   new=new.replace('                    set regenAbility=BlzGetItemAbilityByIndex(carried,index)\n                    exitwhen regenAbility==null\n                    call SaveBoolean(ForsakenRegenScratch,3,BlzGetAbilityId(regenAbility),true)\n                    call Forsaken_RegenAbility(regenAbility,0)','                    exitwhen index>=Inventory94_Count(carried)\n                    set regenRaw=Inventory94_Ability(carried,index)\n                    if Inventory94_HasAbility(carried,regenRaw) then\n                        call SaveBoolean(ForsakenRegenScratch,3,regenRaw,true)\n                        call Forsaken_RegenEffect(regenRaw,0,null)\n                    endif',1)
  if n=='NativeCD_CategoryHolder':
   new=new.replace('if holder==null then','if holder==null or GetUnitTypeId(holder)==0 then',1)
   new=new.replace('            exitwhen carried==null\n            set entry=BlzGetItemAbilityByIndex(carried,index)\n            exitwhen entry==null\n            set raw=BlzGetAbilityId(entry)\n            if NativeCD_Pool(raw)==pool then','            exitwhen index>=Inventory94_Count(carried)\n            set raw=Inventory94_Ability(carried,index)\n            if NativeCD_Pool(raw)==pool and Inventory94_HasAbility(carried,raw) then\n                set entry=BlzGetItemAbility(carried,raw)\n                if entry!=null then',1)
   new=new.replace('            set index=index+1','                endif\n            set index=index+1',1)
  if n=='FFL_StripStorage':
   new=new.replace('        set entry=BlzGetItemAbilityByIndex(carried,i)\n        exitwhen (entry == null)','        exitwhen i>=Inventory94_Count(carried)',1).replace('        set raw=BlzGetAbilityId(entry)','        set raw=Inventory94_Ability(carried,i)',1)
   new=new.replace('        call SaveInteger(ForsakenBagAbilities,key,0,count)','        call SaveInteger(ForsakenBagAbilities,key,-2,GetItemTypeId(carried))\n        call SaveInteger(ForsakenBagAbilities,key,0,count)',1)
  if n=='FFL_Place':
   new=new.replace('    local integer raw','    local integer abilityIndex=0\n    local integer raw',1).replace('                set entry=BlzGetItemAbilityByIndex(spacer,0)\n                exitwhen (entry == null)\n                set raw=BlzGetAbilityId(entry)','                exitwhen abilityIndex>=Inventory94_Count(spacer)\n                set raw=Inventory94_Ability(spacer,abilityIndex)\n                set abilityIndex=abilityIndex+1',1)
  if n=='Cine_Enter':
   new=new.replace('    set udg_InCinematicMode=true\n    set InventoryCinematicActive=true\n','',1)
   marker='    call DisableTrigger(GetTriggeringTrigger())';new=new.replace(marker,'    set udg_InCinematicMode=true\n    set InventoryCinematicActive=true\n    set Inventory94Paused=true\n    call ExecuteFunc("Inventory94_CineEnter")\n    call ExecuteFunc("FFL94_CineEnter")\n'+marker,1)
  if n=='Cine_Exit':new=new.replace('    set InventoryCinematicActive=false','    set InventoryCinematicActive=false\n    set Inventory94Paused=false\n    call ExecuteFunc("Inventory94_CineExit")\n    call ExecuteFunc("FFL94_CineExit")\n    call ExecuteFunc("Forsaken_PrepareInventories")\n    call ExecuteFunc("Chronicles_Tick")\n    call StartTimerBJ(udg_StatsRefreshTimer,false,.01)\n    call StartTimerBJ(udg_HeroRefreshTimer,false,.01)',1)
  if n=='QuickGear_Receive':
   for decl in ['carried=QuickGear_Item(hero,slot)','raw=GetItemTypeId(carried)','cast=LoadInteger(QuickGearData,0,raw)','mode=LoadInteger(QuickGearData,1,raw)']:new=new.replace(decl,decl.split('=')[0]+('=null' if decl.startswith('carried') else '=0'),1)
   new=insert_guard(new,'    if Inventory94Paused or InventoryCinematicActive or udg_InCinematicMode then\n        set hero=null\n        set owner=null\n        return\n    endif\n    set carried=QuickGear_Item(hero,slot)\n    set raw=GetItemTypeId(carried)\n    set cast=LoadInteger(QuickGearData,0,raw)\n    set mode=LoadInteger(QuickGearData,1,raw)')
  if n=='Forsaken_PollPanels':
   new=new.replace('local framehandle nativePanel=Forsaken_FindFrame("SimpleEquipmentPanel")','local framehandle nativePanel=null').replace('local boolean visible=Forsaken_BackpackVisible(nativePanel)','local boolean visible=false').replace('local framehandle anchor=Forsaken_FindFrame("EquipmentPanelBackdrop")','local framehandle anchor=null')
   new=insert_guard(new,'    if Inventory94_Blocked() then\n        set hero=null\n        set viewer=null\n        return\n    endif\n    set nativePanel=Forsaken_FindFrame("SimpleEquipmentPanel")\n    set visible=Forsaken_BackpackVisible(nativePanel)\n    set anchor=Forsaken_FindFrame("EquipmentPanelBackdrop")')
  if n in ['UI72_Tick','QuickGear_Poll','QuickGear_WheelTick','GearInput_Poll','GearRaw_Poll64','GearInput_Hover','QuickGear_Click','QuickGear_Input','QuickGear_Mouse','QuickGear_Request','BagScreen_Click66','BagScreen_Update66','BagScreen_Poll66','BagScreen_Poll65','BagHover_Poll64','BagCast_Poll63','Forsaken_DrawPanels','Forsaken_RenderInspection','Forsaken_RenderNPC','Forsaken_PanelAccess','CarryUI_Draw','GearCursor_Draw60']:
   new=insert_guard(new,'    if Inventory94_Blocked() then\n        return\n    endif')
  if n in ['Forsaken_UpdatePanels','Inventory71_Reconcile','Idle76_Capture','Chronicles_Tick','Trig_Passive_Bonus_Sync_Actions','Trig_Status_AutoCleanse_Actions','Talent_ShieldDisplayTick','FFL_Tick']:
   # Shared maintenance must never depend on a client's UI/quiet-window state.
   new=insert_guard(new,'    if Inventory94Paused or InventoryCinematicActive or udg_InCinematicMode then\n        return\n    endif')
  if n=='QuickGear_Poll':new=new.replace('or hero==null then','or hero==null or GetUnitTypeId(hero)==0 then',1)
  if n=='Forsaken_OnEquip':
   new=insert_guard(new,'    if Inventory94Paused then\n        set holder=null\n        return\n    endif')
   new=new.replace('    if GetTriggerEventId()==EVENT_PLAYER_UNIT_DROP_ITEM','    call Inventory94_Changed(holder)\n    if GetTriggerEventId()==EVENT_PLAYER_UNIT_DROP_ITEM',1)
   new=new.replace('        call Forsaken_SyncStoredEffects(holder)\n        call Forsaken_QueueBagRebind(holder)','        call Forsaken_QueueBagRebind(holder)',1)
  if n=='Forsaken_PrepareInventories':
   new=insert_guard(new,'    if Inventory94Paused then\n        return\n    endif')
   new=new.replace('        call TriggerClearActions(udg_NewGamePlusTrig)\n        call TriggerAddAction(udg_NewGamePlusTrig,function Forsaken_SaveUnavailable)\n','',1)
  if n=='Forsaken_CarryDrop':new=new.replace('if gear!=null and GetItemTypeId(gear)!=0 then','if not Inventory94Paused and gear!=null and GetItemTypeId(gear)!=0 then',1)
  if n=='Trig_Title_UnlockEffects_Actions':
   new,count=re.subn(r'(    if\(Trig_Title_UnlockEffects_IsTitle_LucifersGeneral\(\)\)then\n).*?(        return\n    endif)',r'\1\2',new,flags=re.S);assert count==1
  if n=='Trig_Titles_Init_Actions':new=new.replace('All your base stats increase by 10! Additionally, you may now enter New Game Minus mode!','All your base stats increase by 10!')
  if n=='Inventory71_Reconcile':new=new.replace('        call Forsaken_EnableHero(hero)','        call Inventory94_Changed(hero)\n        call Forsaken_EnableHero(hero)',1)
  if n in ['Forsaken_PrepareQuickGear','Forsaken_PrepareWeaponHand','Forsaken_CarryReplacement','Integrity_CarryIntoSlot']:
   new=new.replace('call UnitAddItem(holder,replacement)','call Forsaken_SuspendStoredItem(replacement)\n            call UnitAddItem(holder,replacement)')
  if n=='Forsaken_RebindBag':
   new=new.replace('            call Forsaken_SuspendStoredItem(carried)\n            call UnitRemoveItem(holder,carried)','            call UnitRemoveItem(holder,carried)\n            call Forsaken_SuspendStoredItem(carried)',1)
   new=new.replace('if holder==null or GetUnitTypeId(holder)==0','if Inventory94Paused or holder==null or GetUnitTypeId(holder)==0',1)
  if n=='QuickGear_PaintIcon':new=new.replace('if carried!=null and QuickGearIcon[slot]!=null then','if carried!=null and GetItemTypeId(carried)!=0 and QuickGearIcon[slot]!=null then',1).replace('set path=BlzGetItemIconPath(carried)','set path="ReplaceableTextures\\\\CommandButtons\\\\BTNSelectHeroOn.blp"',1)
  if n=='QuickGear_InitIconPaths':
   known=set(re.findall(r"SaveStr\(QuickGearIconPaths,0,'(.{4})'",source));required=set(re.findall(r"SaveInteger\(QuickGearData,0,'(.{4})'",source))
   for raw in sorted(required-known):
    path=icons.get(raw,'');assert path,('missing static gear icon',raw)
    escaped=path.replace('\\','\\\\').replace('"','\\"');new=new.replace('endfunction',f'    call SaveStr(QuickGearIconPaths,0,\'{raw}\',"{escaped}")\nendfunction',1)
  if n=='Register_Forsaken_Equipment':new=insert_guard(new,'    call Inventory94_Init()')
  if new!=b:source=put(source,n,new)
 if 'Forsaken_SuspendStoredItem' in fs:
  source=source.replace('endglobals','    hashtable Inventory94Data=null\n    boolean Inventory94Paused=false\n    real array Inventory94Until\nendglobals',1)
  lines=[]
  for raw,ids in sorted(items.items()):
   lines.append(f" call SaveInteger(Inventory94Data,'{raw}',0,{len(ids)})")
   for index,abi in enumerate(ids,1):lines += [f" call SaveInteger(Inventory94Data,'{raw}',{index},'{abi}')",f" call SaveBoolean(Inventory94Data,'{raw}','{abi}',true)"]
   for child,value in [(-10,icons.get(raw,'')),(-11,tips.get(raw,''))]:
    if not value:continue
    # Literal strings stay below JASS's string-token limit; concatenate long
    # descriptions in the catalogue, never through a live item pointer.
    parts=[];part=''
    for char in value.replace('\r','').replace('\n','|n'):
     if len((part+char).encode('utf-8'))>400:parts.append(part);part=''
     part+=char
    if part:parts.append(part)
    for index,part in enumerate(parts):
     escaped=part.replace('\\','\\\\').replace('"','\\"')
     expr=f'"{escaped}"' if index==0 else f'LoadStr(Inventory94Data,\'{raw}\',{child})+"{escaped}"'
     lines.append(f" call SaveStr(Inventory94Data,'{raw}',{child},{expr})")
  chunks=[lines[i:i+160] for i in range(0,len(lines),160)]
  init='\n'.join('function Inventory94_Data'+str(i)+' takes nothing returns nothing\n'+'\n'.join(chunk)+'\nendfunction' for i,chunk in enumerate(chunks))
  init+='\nfunction Inventory94_Init takes nothing returns nothing\n if Inventory94Data!=null then\n return\n endif\n set Inventory94Data=InitHashtable()\n'+'\n'.join(f' call ExecuteFunc("Inventory94_Data{i}")' for i in range(len(chunks)))+'\nendfunction\n'
  source=source.replace('endglobals','endglobals\n'+UNIT_HELPERS+init,1)
 if 'QuickGear_Poll' in fs:
  source=source.replace('endglobals','    real Inventory94ResumeUntil=0.\nendglobals',1)
  helpers=UI_HELPERS
  if not re.search(r'\bunit Preview75Caster\b',source):helpers=helpers.replace(' set Preview75Caster=null\n','')
  source=source.replace('function Forsaken_PollPanels takes',helpers+'\nfunction Forsaken_PollPanels takes',1)
  # Callers precede the UI helper definitions in this long equipment module.
  # Move the pure guard ahead of all UI/input helpers; named hooks stay below.
  guard=functions(UI_HELPERS)['Inventory94_Blocked'];source=source.replace(guard,'',1);source=source.replace('endglobals','endglobals\n'+guard,1)
  # Changed is called from late inventory code; Cine hooks invoke by name.
 if 'FFL_Tick' in fs:
  source=source.replace('endglobals','    real FFL94PausedAt=-1.\nendglobals',1)
  source=source.replace('function FFL_Tick takes','''function FFL94_CineEnter takes nothing returns nothing
 set FFL94PausedAt=TimerGetElapsed(FST_Clock)
endfunction
function FFL94_CineExit takes nothing returns nothing
 local integer pid=0
 local real duration=TimerGetElapsed(FST_Clock)-FFL94PausedAt
 if FFL94PausedAt<0. then
 return
 endif
 loop
 exitwhen pid>=8
 if FFL_Phase[pid]!=0 then
 set FFL_Started[pid]=FFL_Started[pid]+duration
 endif
 set pid=pid+1
 endloop
 set FFL94PausedAt=-1.
endfunction
function FFL_Tick takes''',1)
 assert 'BlzGetItemAbilityByIndex' not in source, [n for n,b in functions(source).items() if 'BlzGetItemAbilityByIndex' in b]
 return source

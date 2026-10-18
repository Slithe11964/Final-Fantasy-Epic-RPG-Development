"""Shared inventory interactions and strict native equipped/carry boundaries."""
import copy,json,re
from pathlib import Path
from damage_tooltips import merged
from priest_master import fields,at,setf
from objdata import read_objects,write_objects
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
ROOT=Path(__file__).resolve().parents[1]
HERE=ROOT/'experiments/Forsaken'


def catalogue(view):
    items=merged(view.object_bytes('war3map.w3t'),view.object_bytes('war3mapSkin.w3t'),'w3t')
    abilities=merged(view.object_bytes('war3map.w3a'),view.object_bytes('war3mapSkin.w3a'),'w3a')
    mapping=json.loads((ROOT/'release/Forsaken/gear-slots-BS.json').read_text())
    hints=json.loads((ROOT/'src/armory-hints.json').read_text())
    storable={int(i):e['item'] for i,e in hints.items()}
    gear={r for r,m in mapping.items() if m.get('slot')!='Inventory'}|{'I0BQ'}
    bases=json.loads((HERE/'ability-base-codes.json').read_text())
    passive_codes={'AEev','AHab','AIab','AIas','AIat','AIde','AIml','AImm','AIms','AIrm','AOac','AOae','AOcr','AUau','AUav','Aasl','Atru','Arel','AIi1'}
    passive={r for r,b in bases.items() if b in passive_codes}
    for r,o in abilities.items():
        if fields(o).get(('acod',0),bases.get(o['base'],o['base'])) in passive_codes:passive.add(r)
    pool={};item_pool={};gear_abilities=set()
    consumable_src=next((ROOT/'src/triggers').rglob('Item_Cooldown.j')).read_text()
    known=set(re.findall(r"(?:\bid|GetSpellAbilityId\(\))\s*==\s*'(....)'",consumable_src))
    pool.update({raw:2 for raw in known})
    for r,o in items.items():
        f=fields(o);actives=[]
        for raw in str(f.get(('iabi',None),'')).split(','):
            if not raw:continue
            if r in gear:gear_abilities.add(raw)
            if raw in abilities and raw not in passive:
                actives.append(raw)
        p=1 if r in gear or 'Materia' in str(f.get(('unam',None),'')) else 0
        # Foods and drinks have explicit shared-consumable IDs even when the editor
        # drops the inherited item class field.
        if any(x in known for x in actives):p=2
        for raw in actives:
            if p:pool[raw]=p
        if p:item_pool[r]=p
        for alias in [mapping.get(r,{}).get('variant'),mapping.get(r,{}).get('offhand')]:
            if alias and p:item_pool[alias]=p
    quick={r:'q'+m['variant'][1:] for r,m in mapping.items() if m.get('variant')}
    for raw in quick.values():
        if raw in items:raise ValueError('reserved quick gear ID already used: '+raw)
    for original,raw in quick.items():
        if original in item_pool:item_pool[raw]=item_pool[original]
    return dict(quick=quick,items=items,abilities=abilities,mapping=mapping,storable=storable,gear=gear,
                passive=passive,pool=pool,item_pool=item_pool,gear_abilities=gear_abilities)


def object_items(data,config,*,native=False):
    if not data:return data
    table=read_objects(data,'w3t')
    for o in table['custom']:
        if o['id']=='I0BQ' and native:
            for key,value in [('iequ','Primary'),('icla','Equipment')]:
                for st in o['sets']:
                    st['mods'][:]=[m for m in st['mods'] if m['field']!=key]
                    st['mods'].append(dict(field=key,type=3,level=None,data=None,value=value,end=0))
        if o['id']=='I045':
            for st in o['sets']:
                for m in st['mods']:
                    if m['field']=='utub' and 'breed' not in m['value'].lower():m['value']+='|nUse on your own chocobo near a partner to breed a basic chocobo.'
    if native:
        # Equipment classification blocks native drag before an item-order event
        # reaches JASS. Retain its equipment slot metadata for UnitEquipItem,
        # but permit the item to enter normal inventory as ordinary cargo.
        variants={m.get('variant') for m in config['mapping'].values()}|{m.get('offhand') for m in config['mapping'].values()}
        for o in table['custom']:
            if o['id'] in variants:
                for st in o['sets']:
                    st['mods'][:]=[m for m in st['mods'] if m['field']!='icla']
                    st['mods'].append(dict(field='icla',type=3,level=None,data=None,value='Permanent',end=0))
        ids={o['id'] for o in table['custom']}
        for original,raw in config['quick'].items():
            if raw in ids:continue
            clone=copy.deepcopy(config['items'][original]);clone['id']=raw
            for st in clone['sets']:
                st['mods'][:]=[m for m in st['mods'] if m['field'] not in {'icla','iequ'}]
                for key,value in [('icla','Permanent'),('iequ','')]:
                    st['mods'].append(dict(field=key,type=3,level=None,data=None,value=value,end=0))
            table['custom'].append(clone)
    return write_objects(table,table['version'],'w3t')


def add_helpers(source,globals_,fragment):
    if globals_ not in source:source=source.replace('endglobals',globals_+'\nendglobals',1)
    at_=re.search(r'^function ',source,re.M).start()
    for name,body in functions(fragment).items():
        if name in functions(source):source=put(source,name,body)
        else:
            at_=re.search(r'^function (?!NativeCD_|Rain_)',source,re.M).start()
            source=source[:at_]+body+'\n\n'+source[at_:]
    return source


def refresh(source,config,*,native=False):
    fs=functions(source)
    if 'FRC_FreeVariant' in fs:
        body='function FRC_FreeVariant takes unit hero returns integer\n    local integer raw=GetUnitTypeId(hero)\n    if hero==null then\n        return 0\n'
        for i,raw in enumerate(['H02L','H02M','H02N','H02O','H02P','H02Q'],1):body+=f"    elseif raw=='{raw}' then\n        return {i}\n"
        body+='    endif\n    return -1\nendfunction'
        source=put(source,'FRC_FreeVariant',body)
        body=functions(source)['FRC_Selected']
        body=re.sub(r'if .*FRC_Hero\[pid\]\s*==\s*udg_FreelancerHero.*? then', 'if FRC_FreeVariant(FRC_Hero[pid])>0 then',body)
        source=put(source,'FRC_Selected',body)
        body=functions(source)['FRC_Section']
        if 'set free=FRC_Hero[pid]' not in body:
            body=re.sub(r'(^    if[ (]*sid\s*==\s*2[ )]* then)',r'    if FRC_FreeVariant(FRC_Hero[pid])>0 then\n        set free=FRC_Hero[pid]\n    endif\n\1',body,count=1,flags=re.M)
        source=put(source,'FRC_Section',body)
    if 'FSC_Core2Maximum' in fs:
        body='''function FSC_Core2Maximum takes integer identity returns integer
    if identity==4 then
        return 999
    elseif identity==7 then
        return 2147483647
    elseif identity==14 then
        return 6
    elseif identity==12 then
        return 3
    elseif identity==13 then
        return 22
    elseif identity==15 then
        return 1
    endif
    return FSC_CoreMaximum(identity)
endfunction'''
        from save_strings import lower_module
        source=put(source,'FSC_Core2Maximum',lower_module(body,helpers=False,refresh=False).strip())
    if 'FFN_Allocate' in fs:
        body=fs['FFN_Allocate']
        if "freeRaw='H02O'" not in body:
            body=re.sub(r"(    elseif[ (]*variant\s*==\s*3[ )]* then\n        set freeRaw='H02N')",r"\1\n    elseif variant==4 then\n        set freeRaw='H02O'\n    elseif variant==5 then\n        set freeRaw='H02P'\n    elseif variant==6 then\n        set freeRaw='H02Q'",body)
        source=put(source,'FFN_Allocate',body)
    if 'FFL_PrepareHero' in fs:
        body=fs['FFL_PrepareHero']
        body=body.replace('local integer variant=FFL_Val(pid,4,14)','local integer variant=ModuloInteger(FFL_Val(pid,4,14)-1,3)+1')
        source=put(source,'FFL_PrepareHero',body)
    if 'Trig_Armory_Store_Item_Conditions' in fs:
        helper='''function Armory_CanStore takes integer raw returns boolean
    local integer index=LoadInteger(udg_ItemSaveID,0,raw)
    return index>0 and LoadBoolean(udg_ItemSaveID,26,index)
endfunction'''
        if 'Armory_CanStore' not in fs:source=source.replace('function Trig_Armory_Store_Item_Conditions',helper+'\n\nfunction Trig_Armory_Store_Item_Conditions',1)
        body=functions(source)['Trig_Armory_Store_Item_Conditions']
        if 'Armory_CanStore' not in body:body=body.replace('    return(','    return Armory_CanStore(GetItemTypeId(GetManipulatedItem())) and (',1)
        source=put(source,'Trig_Armory_Store_Item_Conditions',body)
        body=functions(source)['Trig_Armory_Item_Hash_Actions']
        if 'Armory_Allowed0' not in body:
            lines=['    call SaveBoolean(udg_ItemSaveID,26,'+str(i)+',true)' for i in sorted(config['storable'])]
            # Bounded helper initialization avoids growing the existing registry loop.
            parts=[]
            for start in range(0,len(lines),100):parts.append('function Armory_Allowed'+str(start)+' takes nothing returns nothing\n'+'\n'.join(lines[start:start+100])+'\nendfunction')
            if 'function Armory_Allowed0' not in source:source=source.replace('function Trig_Armory_Item_Hash_Actions','\n\n'.join(parts)+'\n\nfunction Trig_Armory_Item_Hash_Actions',1)
            body=body.replace('endfunction','\n'.join('    call ExecuteFunc("Armory_Allowed'+str(i)+'")' for i in range(0,len(lines),100))+'\nendfunction')
            source=put(source,'Trig_Armory_Item_Hash_Actions',body)
        body=functions(source)['Trig_Armory_Store_Item_Actions']
        if 'if not Armory_CanStore' not in body:body=body.replace('    set udg_ItemIndex=', '    if not Armory_CanStore(GetItemTypeId(GetManipulatedItem())) then\n        return\n    endif\n    set udg_ItemIndex=',1)
        source=put(source,'Trig_Armory_Store_Item_Actions',body)
    if 'Trig_Chocobo_Tame_Breed_IsNotPramNutAgain' in fs:
        source=put(source,'Trig_Chocobo_Tame_Breed_IsNotPramNutAgain','function Trig_Chocobo_Tame_Breed_IsNotPramNutAgain takes nothing returns boolean\n    return true\nendfunction')
        body=functions(source)['Trig_Chocobo_Tame_Breed_Actions']
        body=body.replace('                        if(Trig_Chocobo_Tame_Breed_IsLuchilNutAgain())then','                        set udg_ChocoboAbilityIndex=0\n                        if(Trig_Chocobo_Tame_Breed_IsLuchilNutAgain())then') if 'set udg_ChocoboAbilityIndex=0' not in body else body
        source=put(source,'Trig_Chocobo_Tame_Breed_Actions',body)
        for name in ['Trig_Chocobo_Tame_Limit_Conditions','Trig_Chocobo_Tame_Breed_Conditions']:
            source=put(source,name,'function '+name+" takes nothing returns boolean\n    return GetSpellAbilityId()=='A0A8' or GetSpellAbilityId()=='A0CT' or GetSpellAbilityId()=='A0CU' or GetSpellAbilityId()=='A0CV'\nendfunction")
    if 'GearSlots_Init' in fs and "SaveInteger(GearSlotTable,1,'I0BQ'" not in source:
        body=functions(source)['GearSlots_Init'];bonuses=[r for r in str(fields(config['items']['I0BQ']).get(('iabi',None),'')).split(',') if r in config['passive']]
        extra="    call SaveInteger(GearSlotTable,1,'I0BQ',GEAR_PRIMARY)\n    call SaveInteger(GearSlotTable,2,'I0BQ',"+str(len(bonuses))+')\n'
        extra+=''.join(f"    call SaveInteger(GearSlotTable,{10+i},'I0BQ','{r}')\n" for i,r in enumerate(bonuses))
        source=put(source,'GearSlots_Init',body.replace('endfunction',extra+'endfunction'))
    if 'Trig_Myriad_Arrows_Actions' in fs:
        init='function Rain_Data takes nothing returns nothing\n'
        for rank in range(1,7):init+=f"    call SaveInteger(RainData,'A0R0',{rank},{int(at(fields(config['abilities']['A0X4']),'Hbz1',rank,20))})\n"
        for rank in range(1,21):init+=f"    call SaveInteger(RainData,'A0QM',{rank},{int(at(fields(config['abilities']['A0X3']),'Hbz1',rank,rank*2))})\n"
        init+='endfunction\n'
        source=add_helpers(source,'    hashtable RainData=InitHashtable()',init+(HERE/'ScriptedRain.j').read_text())
        body=functions(source)['Register_Myriad_Arrows']
        if 'call Rain_Data()' not in body:body=body.replace('    set gg_trg_Myriad_Arrows=', '    call Rain_Data()\n    set gg_trg_Myriad_Arrows=',1)
        source=put(source,'Register_Myriad_Arrows',body)
    for name in ['Trig_Myriad_Arrows_Actions','Trig_Meteor_Cast_Actions','Trig_Spell_Meteor_Wide_Actions']:
        if name in fs:
            if name!='Trig_Myriad_Arrows_Actions':source=dependency(source,'TMyriad')
            body='function '+name+''' takes nothing returns nothing
    local unit caster=GetTriggerUnit()
    local integer raw=GetSpellAbilityId()
    call Rain_Start(caster,raw,IMaxBJ(1,GetUnitAbilityLevel(caster,raw)),BlzGetAbilityManaCost(raw,Abil_GetLevel(caster,raw)),GetSpellTargetX(),GetSpellTargetY())
    set caster=null
endfunction'''
            source=put(source,name,body)
    if 'Trig_Fishing_Unlock_Conditions' in fs:
        source=dependency(source,'TItemStack')
        if 'boolean FishingUnlocked=false' not in source:source=source.replace('endglobals','    boolean FishingUnlocked=false\nendglobals',1)
        fragment=(HERE/'FishingInventory.j').read_text()
        for name,body in functions(fragment).items():
            if name in functions(source):source=put(source,name,body)
            else:
                anchor='function Trig_Fishing_Unlock_Conditions' if name!='Fishing_UnlockOnce' else 'function Trig_Fishing_Unlock_Actions'
                source=source.replace(anchor,body+'\n\n'+anchor,1)
        source=put(source,'Trig_Fishing_Unlock_Conditions','function Trig_Fishing_Unlock_Conditions takes nothing returns boolean\n    return Fishing_HasAnyRod()\nendfunction')
        source=put(source,'Trig_Fishing_Unlock_Actions','function Trig_Fishing_Unlock_Actions takes nothing returns nothing\n    call Fishing_UnlockOnce()\nendfunction')
        body=functions(source)['Register_Fishing_Unlock']
        if 'TriggerRegisterTimerEvent(' not in body:body=body.replace('    call TriggerAddCondition','    call TriggerRegisterTimerEvent(gg_trg_Fishing_Unlock,1.,true)\n    call TriggerAddCondition',1)
        source=put(source,'Register_Fishing_Unlock',body)
    if 'Trig_Fishing_Input_Actions' in fs:
        body=functions(source)['Trig_Fishing_Input_Actions']
        old='        call RemoveItem(udg_GatherItem[udg_TempInteger])\n        call ConditionalTriggerExecute(gg_trg_Fishing_End)'
        if 'Wait for the ! bite indicator' not in body:
            body=body.replace(old,'        call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,3,"Wait for the ! bite indicator, then pull toward shore.")\n        return',1)
        source=put(source,'Trig_Fishing_Input_Actions',body)
        body=functions(source)['Trig_Fishing_Tick_Actions']
        if 'Wait for the ! bite indicator' not in body:
            body=body.replace('        set udg_GatherState[udg_TempInteger]=2','        set udg_GatherState[udg_TempInteger]=2\n        call DisplayTimedTextToPlayer(ConvertedPlayer(udg_TempInteger),0,0,6,"Wait for the ! bite indicator, then pull toward shore.")',1)
        source=put(source,'Trig_Fishing_Tick_Actions',body)
    if 'Trig_Fishing_Cast_Conditions' in fs:
        source=dependency(source,'TItemStack')
        helper="""function Fishing_WornCast takes unit hero,integer raw returns boolean
    if raw=='A0VB' then
        return Carry_Worn(hero,'I0EY')
    elseif raw=='A0VT' then
        return Carry_Worn(hero,'I0EZ')
    elseif raw=='A0VU' then
        return Carry_Worn(hero,'I0GB')
    elseif raw=='A0VV' then
        return Carry_Worn(hero,'I0GC')
    endif
    return false
endfunction"""
        if 'Fishing_WornCast' not in functions(source):source=source.replace('function Trig_Fishing_Cast_Conditions',helper+'\n\nfunction Trig_Fishing_Cast_Conditions',1)
        body=functions(source)['Trig_Fishing_Cast_Conditions']
        if 'Fishing_WornCast' not in body:body=body.replace('    return(', '    return Fishing_WornCast(GetTriggerUnit(),GetSpellAbilityId()) and (',1)
        source=put(source,'Trig_Fishing_Cast_Conditions',body)
    if native and 'Trig_Armory_Select_Actions' in functions(source):
        source=dependency(source,'TEquip')
        body=functions(source)['Trig_Armory_Select_Actions']
        if 'Forsaken_RequestInventoryRefresh' not in body:
            body=body.replace('                    call Collection_ForceRemovePlayerSimple','                    call Forsaken_RequestInventoryRefresh(Player_GetHero(GetOwningPlayer(GetTriggerUnit())))\n                    call Collection_ForceRemovePlayerSimple',1)
        source=put(source,'Trig_Armory_Select_Actions',body)
    if native:source=native_refresh(source,config)
    return source


def native_refresh(source,c):
    fs=functions(source)
    if 'FRC_Init' in fs:
        body=fs['FRC_Init']
        for original,raw in c['quick'].items():
            found=re.search(r"SaveInteger\(FRC_Map,0,'"+original+r"',([0-9]+)\)",body)
            if found and "'"+raw+"'" not in body:body=body.replace('endfunction',f"    call SaveInteger(FRC_Map,0,'{raw}',{found[1]})\nendfunction")
        source=put(source,'FRC_Init',body)
    if 'FFP_Init' in fs:
        body=fs['FFP_Init']
        for original,raw in c['quick'].items():
            # Native load bindings already use the equipment variant, while
            # editor bindings use the canonical ID. Both must restore a
            # carry-only copy in the hero's six quick slots.
            for candidate in [original,c['mapping'][original]['variant']]:
                body=re.sub(r"(SaveInteger\(FFP_Bindings,1,[0-9]+,)'"+candidate+r"'\)",lambda m:m[1]+"'"+raw+"')",body)
        source=put(source,'FFP_Init',body)
    if 'Forsaken_SyncStoredEffects' in fs:
        body=fs['Forsaken_SyncStoredEffects']
        body=body if 'Forsaken_SuspendStoredItem(UnitItemInSlot(holder,slot))' in body else body.replace('        call Forsaken_RestoreStoredItem(UnitItemInSlot(holder,slot))','        if LoadBoolean(ForsakenElementSources,2,GetItemTypeId(UnitItemInSlot(holder,slot))) then\n            call Forsaken_SuspendStoredItem(UnitItemInSlot(holder,slot))\n        else\n            call Forsaken_RestoreStoredItem(UnitItemInSlot(holder,slot))\n        endif')
        source=put(source,'Forsaken_SyncStoredEffects',body)
    if 'Forsaken_CarryOrder' in fs:
        globals_,fragment=(HERE/'CarryTransferUI.j').read_text().split('// FUNCTIONS\n',1)
        for line in globals_.splitlines():
            name=line.strip().split('=')[0].split()[-1]
            if not re.search(r'^\s*\w+ (?:array )?'+name+r'\b',source,re.M):source=source.replace('endglobals',line+'\nendglobals',1)
        for name,body in functions(fragment).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function Forsaken_CarryReplacement takes',body+'\n\nfunction Forsaken_CarryReplacement takes',1)
        body=functions(source)['Register_Forsaken_PanelAccess']
        if 'CarryUI_Init()' not in body:body=body.replace('    call Forsaken_RegisterBackpackActivity()','    call Forsaken_RegisterBackpackActivity()\n    call CarryUI_Init()',1)
        source=put(source,'Register_Forsaken_PanelAccess',body)
        body=functions(source)['Forsaken_PollPanels']
        if 'CarryUI_ShowAccess' not in body:body=body.replace('    set ForsakenBackpackWasVisible=visible','    call CarryUI_ShowAccess(visible and ForsakenInspectTarget==null,anchor)\n    set ForsakenBackpackWasVisible=visible',1)
        source=put(source,'Forsaken_PollPanels',body)
    if 'Forsaken_CarryOrder' in fs:
        body=fs['Forsaken_CarryOrder']
        if 'order>=852002' not in body:body=body.replace('    if order==852001',
            '    if order>=852002 and order<=852007 and holder==Player_GetHero(GetOwningPlayer(holder)) and gear!=null and LoadInteger(ForsakenGearTypes,4,GetItemTypeId(gear))!=0 then\n        set replacement=Forsaken_CarryReplacement(holder,gear,order-852002)\n    elseif order==852001',1)
        source=put(source,'Forsaken_CarryOrder',body)
        body=fs['Forsaken_PrepareQuickGear']
        if 'slot<6 and LoadBoolean(ForsakenGearTypes,51' not in body:
            body=body.replace('if original!=null and variant!=0 and not LoadBoolean', 'if original!=null and variant!=0 and not (slot<6 and LoadBoolean(ForsakenGearTypes,51,GetHandleId(original))) and not LoadBoolean',1)
        source=put(source,'Forsaken_PrepareQuickGear',body)
        body=fs['Forsaken_CarryReplacement']
        helper=functions((HERE/'CarryQuickSlot.j').read_text())['Integrity_CarryIntoSlot']
        if 'Integrity_CarryIntoSlot' in functions(source):source=put(source,'Integrity_CarryIntoSlot',helper.strip())
        else:source=source.replace('function Forsaken_CarryReplacement takes',helper+'\nfunction Forsaken_CarryReplacement takes',1)
        if 'return Integrity_CarryIntoSlot' not in body:
            body=body.replace('    set ForsakenConvertingGear=true','    if quickSlot>=0 then\n        return Integrity_CarryIntoSlot(holder,original,quickSlot,raw)\n    endif\n    set ForsakenConvertingGear=true',1)
        if 'ForsakenGearTypes,67,raw' not in body:
            body=body.replace('    set ForsakenConvertingGear=true','    if quickSlot>=0 and LoadInteger(ForsakenGearTypes,67,raw)!=0 then\n        set raw=LoadInteger(ForsakenGearTypes,67,raw)\n    endif\n    set ForsakenConvertingGear=true',1)
        if 'call Forsaken_SyncStoredEffects(holder)' not in body:
            body=body.replace('    set ForsakenConvertingGear=false\n    return replacement','    if holder==Player_GetHero(GetOwningPlayer(holder)) then\n        call Forsaken_SyncStoredEffects(holder)\n    endif\n    set ForsakenConvertingGear=false\n    return replacement')
        source=put(source,'Forsaken_CarryReplacement',body)
    if 'Forsaken_StoreHeroGear' in fs:
        source=put(source,'Forsaken_StoreHeroGear','function Forsaken_StoreHeroGear takes unit holder returns nothing\n    // Quick slots may carry gear; Forsaken_SyncStoredEffects suspends its passives.\nendfunction')
        body=fs['Trig_Equip_Restrictions_GaiaLevelTooLow']
        if 'LoadBoolean(ForsakenElementSources,2,' not in body:
            body=body.replace('    return(',"    return(GetItemEquipmentType(Forsaken_EventItem())!=EQUIPMENT_TYPE_NONE or LoadBoolean(ForsakenElementSources,2,GetItemTypeId(Forsaken_EventItem())))and(",1)
        source=put(source,'Trig_Equip_Restrictions_GaiaLevelTooLow',body)
        body=functions(source)['Register_Forsaken_Equipment']
        if 'function Integrity_GearData' not in source:
            lines=["    call SaveBoolean(ForsakenElementSources,2,'I0BQ',true)","    call SaveInteger(ForsakenElementSources,3,'I0BQ',1)"]
            for original,raw in sorted(c['quick'].items()):
                variant=c['mapping'][original]['variant']
                lines.extend([f"    call SaveInteger(ForsakenGearTypes,67,'{original}','{raw}')",
                    f"    call SaveInteger(ForsakenGearTypes,0,'{raw}','{variant}')",
                    f"    call SaveInteger(ForsakenGearTypes,4,'{raw}','{original}')",
                    f"    call SaveBoolean(ForsakenElementSources,2,'{raw}',true)",
                    f"    call SaveInteger(ForsakenElementSources,3,'{raw}',1)"])
            for raw in sorted(c['gear_abilities']):lines.append("    call SaveBoolean(ForsakenElementSources,0,'"+raw+"',true)")
            for raw in str(fields(c['items']['I0BQ']).get(('iabi',None),'')).split(','):
                if raw in c['passive']:lines.append("    call SaveBoolean(ForsakenBagPassiveTypes,0,'"+raw+"',true)")
            # Run after the existing tables are initialized.
            source=source.replace('function Register_Forsaken_Equipment takes','function Integrity_GearData takes nothing returns nothing\n'+'\n'.join(lines)+'\nendfunction\n\nfunction Register_Forsaken_Equipment takes',1)
            body=body.replace('endfunction','    call ExecuteFunc("Integrity_GearData")\nendfunction')
            source=put(source,'Register_Forsaken_Equipment',body)
        source=dependency(source,'TCloak')
        body=functions(source)['Forsaken_OnEquip']
        if 'call Integrity_RefreshWorn' not in body:
            body=body.replace('    call Forsaken_CarryEvent(holder)','    call Forsaken_CarryEvent(holder)\n    call Integrity_RefreshWorn(holder)',1)
        source=put(source,'Forsaken_OnEquip',body)
        body=functions(source)['Forsaken_EnableHero']
        if 'call Integrity_RefreshWorn(holder)' not in body:body=body.replace('    call Forsaken_UpdatePanels(holder)','    call Integrity_RefreshWorn(holder)\n    call Forsaken_UpdatePanels(holder)',1)
        # The helper must precede EnableHero as well as the item-event callback.
        source=put(source,'Forsaken_EnableHero',body)
        body=functions(source)['Forsaken_EnableHero']
        if 'call Integrity_MarkQuick(holder)' not in body:body=body.replace('    call Forsaken_PrepareQuickGear(holder)','    call Integrity_MarkQuick(holder)\n    call Forsaken_PrepareQuickGear(holder)',1)
        source=put(source,'Forsaken_EnableHero',body)
        mark='''function Integrity_MarkQuick takes unit hero returns nothing
    local integer i=0
    local item carried
    loop
        exitwhen i>=6
        set carried=UnitItemInSlot(hero,i)
        if LoadInteger(ForsakenGearTypes,0,GetItemTypeId(carried))!=0 then
            call SaveBoolean(ForsakenGearTypes,51,GetHandleId(carried),true)
        endif
        set i=i+1
    endloop
    set carried=null
endfunction'''
        if 'Integrity_MarkQuick' not in fs:source=source.replace('function Forsaken_EnableHero takes',mark+'\n\nfunction Forsaken_EnableHero takes',1)
        helper='''function Integrity_RefreshWorn takes unit hero returns nothing
    local integer i=0
    local integer raw
    local integer signature=0
    if hero!=Player_GetHero(GetOwningPlayer(hero)) then
        return
    endif
    loop
        exitwhen i>=4
        if i==0 then
            set raw='A0VB'
        elseif i==1 then
            set raw='A0VT'
        elseif i==2 then
            set raw='A0VU'
        else
            set raw='A0VV'
        endif
        if Forsaken_ElementAbilityLevel(hero,raw)>0 then
            if GetUnitAbilityLevel(hero,raw)==0 then
                call UnitAddAbility(hero,raw)
            endif
        else
            call UnitRemoveAbility(hero,raw)
        endif
        set i=i+1
    endloop
    if Forsaken_ElementAbilityLevel(hero,'A0Z6')>0 then
        set signature=signature+1
    endif
    if Forsaken_ElementAbilityLevel(hero,'A0ZS')>0 then
        set signature=signature+2
    endif
    if Forsaken_ElementAbilityLevel(hero,'A12A')>0 then
        set signature=signature+4
    endif
    if LoadInteger(ForsakenGearTypes,66,GetHandleId(hero))!=signature then
        call SaveInteger(ForsakenGearTypes,66,GetHandleId(hero),signature)
        call EnableTrigger(gg_trg_Cloak_UpdateStats)
        call StartTimerBJ(udg_JobChangeTimer,false,.01)
    endif
endfunction'''
        if 'Integrity_RefreshWorn' not in fs:source=source.replace('function Forsaken_EnableHero takes',helper+'\n\nfunction Forsaken_EnableHero takes',1)
    if 'Forsaken_ReadRegeneration' in fs:
        body=functions(source)['Forsaken_ReadRegeneration']
        body=re.sub(r'        if slot<6 then\n            set carried=UnitItemInSlot\(hero,slot\)\n        else\n            set carried=UnitItemInEquipmentSlot\(hero,ConvertLoadoutSlot\(slot-6\)\)\n        endif',
                    '        set carried=Forsaken_ActiveGear(hero,slot)',body)
        source=put(source,'Forsaken_ReadRegeneration',body)
    if 'Trig_Cloak_UpdateStats_Cond_HasProminentCloak' in fs:
        source=dependency(source,'TUnit')
        for name in ['Trig_Cloak_UpdateStats_Cond_HasProminentCloak','Trig_Cloak_UpdateStats_Cond_HasHunterCloak','Trig_Cloak_UpdateStats_Cond_HasChampionBelt']:
            body=functions(source)[name]
            body=re.sub(r"GetUnitAbilityLevelSwapped\('(....)',(Player_GetHero\(GetEnumPlayer\(\)\))\)",r"Forsaken_ElementAbilityLevel(\2,'\1')",body)
            source=put(source,name,body)
    if 'Abil_GetLevel' in fs:
        source=dependency(source,'TPlayerHero')
        if 'hashtable SharedItemCDTypes=' not in source:source=source.replace('endglobals','    hashtable SharedItemCDTypes=InitHashtable()\nendglobals',1)
        helper=(HERE/'SharedItemDuration.j').read_text()
        for name in functions(helper):
            source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        source=source.replace('function InitTrig_Abil takes',helper.strip()+'\n\nfunction InitTrig_Abil takes',1)
    if 'Trig_Cooldown_Scaling_Actions' in fs:
        source=dependency(source,'TAbil')
        body=functions(source)['Trig_Cooldown_Scaling_Actions']
        body=body.replace('set l_tempReal=SharedItemCD_Duration(GetTriggerUnit(),GetSpellAbilityId())','set l_tempReal=NativeCD_DurationForCast(GetTriggerUnit(),GetSpellAbilityId())')
        if 'NativeCD_DurationForCast' not in body:
            body=body.replace('    set l_tempReal=1000.',"""    if SharedItemCD_IsItem(GetSpellAbilityId()) then
        set l_tempReal=NativeCD_DurationForCast(GetTriggerUnit(),GetSpellAbilityId())
        call BlzSetAbilityRealLevelField(GetSpellAbility(),ABILITY_RLF_COOLDOWN,Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()),l_tempReal)
        call BlzSetUnitAbilityCooldown(GetTriggerUnit(),GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()),l_tempReal)
        return
    endif
    set l_tempReal=1000.""",1)
        source=put(source,'Trig_Cooldown_Scaling_Actions',body)
    if 'Register_Item_Cooldown_Start' in fs:
        fragment='function NativeCD_Data takes nothing returns nothing\n'
        for raw,pool in sorted(c['pool'].items()):fragment+=f"    call SaveInteger(NativeCDData,0,'{raw}',{pool})\n    call SaveBoolean(SharedItemCDTypes,0,'{raw}',true)\n"
        for raw,pool in sorted(c['item_pool'].items()):fragment+=f"    call SaveInteger(NativeCDData,1,'{raw}',{pool})\n"
        fragment+='endfunction\n'+(HERE/'SharedItemCooldown.j').read_text()
        source=add_helpers(source,'    hashtable NativeCDData=InitHashtable()\n    timer NativeCDClock=CreateTimer()',fragment)
        for name in functions(fragment):source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        position=re.search(r'^function ',source,re.M).start()
        source=source[:position]+'\n\n'.join(body.strip() for body in functions(fragment).values())+'\n\n'+source[position:]
        source=re.sub(r'\n{3,}','\n\n',source)
        body=functions(source)['Register_Item_Cooldown_Start']
        if 'call NativeCD_Init()' not in body:body=body.replace('endfunction','    call NativeCD_Init()\nendfunction')
        source=put(source,'Register_Item_Cooldown_Start',body)
    elif 'Abil_GetLevel' not in fs and re.search(r"'(?:"+'|'.join(c['pool'])+r")'",source):
        # Only spell-effect event registrations are gated; attacks, item pickup,
        # NPC casts and unrelated hero skills continue through unchanged.
        effect_vars=set(re.findall(r'TriggerRegister(?:AnyUnitEventBJ|PlayerUnitEventSimple|PlayerUnitEvent)\((\w+),[^\n]*EVENT_PLAYER_UNIT_SPELL_EFFECT',source))
        if effect_vars:
            source=dependency(source,'TItemCooldown')
            for var in effect_vars:
                marker='    call TriggerAddCondition('+var+',Condition(function NativeCD_Allowed))'
                if marker not in source:
                    source=re.sub(r'(^    call TriggerAddAction\('+var+r',)',marker+'\n'+r'\1',source,count=1,flags=re.M)
    if 'Forsaken_CarryOrder' in fs:
        # JASS requires callees and callback functions before their callers.
        # HoldsItem is a native-only scan; place it and the new helpers before
        # the existing poll/registration functions without moving game logic.
        group=['Forsaken_HoldsItem','Integrity_CarryIntoSlot']+list(functions((HERE/'CarryTransferUI.j').read_text().split('// FUNCTIONS\n',1)[1]))
        blocks=[]
        for name in group:
            blocks.append(functions(source)[name].strip())
            source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        source=source.replace('function Forsaken_PollPanels takes','\n\n'.join(blocks)+'\n\nfunction Forsaken_PollPanels takes',1)
        source=re.sub(r'\n{3,}','\n\n',source)
    return source

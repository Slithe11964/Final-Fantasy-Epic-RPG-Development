"""Shared inventory interactions and strict native equipped/carry boundaries."""
import json,re
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
    return dict(items=items,abilities=abilities,mapping=mapping,storable=storable,gear=gear,
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
    if native:source=native_refresh(source,config)
    return source


def native_refresh(source,c):
    fs=functions(source)
    if 'Forsaken_SyncStoredEffects' in fs:
        body=fs['Forsaken_SyncStoredEffects']
        body=body if 'Forsaken_SuspendStoredItem(UnitItemInSlot(holder,slot))' in body else body.replace('        call Forsaken_RestoreStoredItem(UnitItemInSlot(holder,slot))','        if LoadBoolean(ForsakenElementSources,2,GetItemTypeId(UnitItemInSlot(holder,slot))) then\n            call Forsaken_SuspendStoredItem(UnitItemInSlot(holder,slot))\n        else\n            call Forsaken_RestoreStoredItem(UnitItemInSlot(holder,slot))\n        endif')
        source=put(source,'Forsaken_SyncStoredEffects',body)
    if 'Forsaken_StoreHeroGear' in fs:
        source=put(source,'Forsaken_StoreHeroGear','function Forsaken_StoreHeroGear takes unit holder returns nothing\n    // Quick slots may carry gear; Forsaken_SyncStoredEffects suspends its passives.\nendfunction')
        body=fs['Trig_Equip_Restrictions_GaiaLevelTooLow']
        if 'LoadBoolean(ForsakenElementSources,2,' not in body:
            body=body.replace('    return(',"    return(GetItemEquipmentType(Forsaken_EventItem())!=EQUIPMENT_TYPE_NONE or LoadBoolean(ForsakenElementSources,2,GetItemTypeId(Forsaken_EventItem())))and(",1)
        source=put(source,'Trig_Equip_Restrictions_GaiaLevelTooLow',body)
        body=functions(source)['Register_Forsaken_Equipment']
        if 'function Integrity_GearData' not in source:
            lines=["    call SaveBoolean(ForsakenElementSources,2,'I0BQ',true)","    call SaveInteger(ForsakenElementSources,3,'I0BQ',1)"]
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
    if 'Register_Item_Cooldown_Start' in fs:
        fragment='function NativeCD_Data takes nothing returns nothing\n'
        for raw,pool in sorted(c['pool'].items()):fragment+=f"    call SaveInteger(NativeCDData,0,'{raw}',{pool})\n"
        for raw,pool in sorted(c['item_pool'].items()):fragment+=f"    call SaveInteger(NativeCDData,1,'{raw}',{pool})\n"
        fragment+='endfunction\n'+(HERE/'SharedItemCooldown.j').read_text()
        source=add_helpers(source,'    hashtable NativeCDData=InitHashtable()\n    timer NativeCDClock=CreateTimer()',fragment)
        body=functions(source)['Register_Item_Cooldown_Start']
        if 'call NativeCD_Init()' not in body:body=body.replace('endfunction','    call NativeCD_Init()\nendfunction')
        source=put(source,'Register_Item_Cooldown_Start',body)
    elif re.search(r"'(?:"+'|'.join(c['pool'])+r")'",source):
        # Only spell-effect event registrations are gated; attacks, item pickup,
        # NPC casts and unrelated hero skills continue through unchanged.
        effect_vars=set(re.findall(r'TriggerRegister(?:AnyUnitEventBJ|PlayerUnitEventSimple|PlayerUnitEvent)\((\w+),[^\n]*EVENT_PLAYER_UNIT_SPELL_EFFECT',source))
        if effect_vars:
            source=dependency(source,'TItemCooldown')
            for var in effect_vars:
                marker='    call TriggerAddCondition('+var+',Condition(function NativeCD_Allowed))'
                if marker not in source:
                    source=re.sub(r'(^    call TriggerAddAction\('+var+r',)',marker+'\n'+r'\1',source,count=1,flags=re.M)
    return source

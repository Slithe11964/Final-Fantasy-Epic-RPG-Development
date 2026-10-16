"""Reviewed quest/travel/item fixes shared by editor-master output profiles."""
import json,re
from pathlib import Path
from jtok import functions
from performance_runtime import put,replace_once
ROOT=Path(__file__).resolve().parents[1]
HERE=ROOT/'experiments/Forsaken'


def dependency(source,name):
    header=source.splitlines()[0]
    if not re.search(r'\b'+name+r'\b',header):
        source=source.replace(header,header+(', ' if ' requires ' in header else ' requires ')+name,1)
    return source


def refresh(source,*,native=False):
    fs=functions(source)
    if 'Trig_Item_Stack_Pickup_Actions' in fs:
        source=dependency(dependency(dependency(source,'TPlayerHero'),'optional TBackpack'),'optional TEquip')
        # Optional dependency names include their keyword; avoid duplicate insertion.
        source=source.replace('optional optional ','optional ')
        if 'function Carry_Type takes' not in source:
            source=source.replace('endglobals','    item ItemStackGatherItem=null\n    integer ItemStackGatherOwner=0\nendglobals',1)
            at=re.search(r'^function ',source,re.M).start()
            source=source[:at]+(HERE/'CarrySupport.j').read_text()+'\n'+source[at:]
        source=put(source,'Trig_Item_Stack_Pickup_Conditions',"""function Trig_Item_Stack_Pickup_Conditions takes nothing returns boolean
    return ItemStack_Eligible(GetManipulatedItem()) and IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers) and Trig_Item_Stack_Pickup_PickedIsMine()
endfunction""")
        source=put(source,'Trig_Item_Stack_Pickup_Actions',"""function Trig_Item_Stack_Pickup_Actions takes nothing returns nothing
    call ItemStack_MergeUnit(GetTriggerUnit(),GetManipulatedItem())
endfunction""")
    if 'Trig_Gaya_GatherItems_CollectItemToHouse' in fs:
        source=dependency(source,'TItemStack')
        body=functions(source)['Trig_Gaya_GatherItems_Actions']
        if 'ItemStack_ConsolidateUnit' not in body:
            body=body.replace('    call Trig_Gaya_GatherItems_GatherItemsAround(', '    call ItemStack_ConsolidateUnit(Player_GetHero(GetOwningPlayer(GetTriggerUnit())))\n    call ItemStack_ConsolidateUnit(udg_SpiritOfGaya[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1])\n    call ItemStack_ConsolidateUnit(udg_PlayerHouse[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1])\n    call Trig_Gaya_GatherItems_GatherItemsAround(',1)
            source=put(source,'Trig_Gaya_GatherItems_Actions',body)
        source=put(source,'Trig_Gaya_GatherItems_CollectItemToHouse',"""function Trig_Gaya_GatherItems_CollectItemToHouse takes nothing returns nothing
    local integer i=GetPlayerId(GetTriggerPlayer())+1
    local item picked=GetEnumItem()
    if not IsItemVisible(picked) or IsItemOwned(picked) or IsItemPowerup(picked) or (GetItemUserData(picked)>0 and GetItemUserData(picked)!=i) then
        set picked=null
        return
    endif
    if ItemStack_Eligible(picked) then
        call ItemStack_MergeUnit(udg_PlayerHouse[i],picked)
        if GetItemTypeId(picked)!=0 then
            call ItemStack_MergeGround(picked,udg_PlayerStartRect[i],i)
        endif
    endif
    if GetItemTypeId(picked)!=0 then
        call SetItemPosition(picked,GetRandomReal(GetRectMinX(udg_PlayerStartRect[i]),GetRectMaxX(udg_PlayerStartRect[i])),GetRandomReal(GetRectMinY(udg_PlayerStartRect[i]),GetRectMaxY(udg_PlayerStartRect[i])))
        call UnitAddItem(udg_PlayerHouse[i],picked)
    endif
    set picked=null
endfunction""")
        body=functions(source)['Trig_Gaya_GatherItems_GatherItemsAround']
        body=body.replace('    call EnumItemsInRect(Rect(ux-l_radius,uy-l_radius,ux+l_radius,uy+l_radius),null,function Trig_Gaya_GatherItems_CollectItemToHouse)',
            '    local rect area=Rect(ux-l_radius,uy-l_radius,ux+l_radius,uy+l_radius)\n    call EnumItemsInRect(area,null,function Trig_Gaya_GatherItems_CollectItemToHouse)\n    call RemoveRect(area)\n    set area=null')
        source=put(source,'Trig_Gaya_GatherItems_GatherItemsAround',body)
    if 'QuestEidolonChallenge_Define' in fs:
        body=functions(source)['QuestEidolonChallenge_Define']
        body=body.replace('call Quest_Talk(q,gg_unit_Ocb2_0147,"")','call Quest_Return(q,gg_unit_Ocb2_0147,"")')
        source=put(source,'QuestEidolonChallenge_Define',body)
    if 'Trig_HeroMedicine_Refill_Cond_HasMedicine' in fs:
        source=dependency(source,'TItemStack')
        source=put(source,'Trig_HeroMedicine_Refill_Cond_HasMedicine',"""function Trig_HeroMedicine_Refill_Cond_HasMedicine takes nothing returns boolean
    return Carry_Worn(Player_GetHero(GetEnumPlayer()),'I0A7')
endfunction""")
        source=put(source,'Trig_HeroMedicine_Refill_Actions',"""function Trig_HeroMedicine_Refill_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_HeroMedicine_Refill_GiveDrinkToPlayer)
endfunction""")
        for name in ['Register_HeroMedicine_Refill','Register_HeroMedicine_Pickup']:
            body=functions(source)[name]
            body=re.sub(r'^    call DisableTrigger\([^\n]*\)\n','',body,flags=re.M)
            source=put(source,name,body)
    if 'Travel_InitDestinations' in fs:
        template=(HERE/'TravelPages.j').read_text()
        if 'dialog array TravelDialog' not in source:
            block=re.search(r'^globals\n(.*?)^endglobals',template,re.M|re.S)
            source=source.replace('endglobals',block[1]+'endglobals',1)
            at=source.index('function Trig_Travel_Dialog_Click_Actions')
            helpers='\n\n'.join(b for n,b in functions(template).items() if n.startswith(('Travel_Hide','Travel_Show','Travel_Refresh')))
            source=source[:at]+helpers+'\n\n'+source[at:]
        for name in ['Trig_Travel_Dialog_Click_Actions','Register_Travel_Dialog_Click']:
            source=put(source,name,functions(template)[name])
    if 'Warp_OnEnterPoint' in fs:
        source=put(source,'Warp_HideDialog',"""function Warp_HideDialog takes nothing returns nothing
    call Travel_Hide(GetEnumPlayer())
endfunction""")
        body=functions(source)['Warp_OnEnterPoint'].replace('call DialogDisplay(GetOwningPlayer(triggeringUnit),udg_WarpDialog,true)','call Travel_Show(GetOwningPlayer(triggeringUnit),0)')
        source=put(source,'Warp_OnEnterPoint',body)
    if 'Trig_Quest_52_Scorching_TravelDialog_Rebuild' in fs:
        source=dependency(source,'TTravel')
        source=put(source,'Trig_Quest_52_Scorching_TravelDialog_Rebuild',"""function Trig_Quest_52_Scorching_TravelDialog_Rebuild takes nothing returns nothing
    call Travel_Refresh()
endfunction""")
    # Classic already uses Gear_Carried across its quests. Adapt native quick-only lookups.
    entries=json.loads((ROOT/'src/trigger-list.json').read_text(encoding='utf-8'))
    questlibs={e.get('library') for e in entries if e['folder']=='06 Quests and story'}
    lib=re.match(r'library (\w+)',source)[1]
    if lib in questlibs:
        previous=source
        source=re.sub(r'\bUnitHasItemOfTypeBJ\(', 'Carry_Has(',source)
        source=re.sub(r'\bGetItemOfTypeFromUnitBJ\(', 'Carry_Find(',source)
        if source!=previous:source=dependency(source,'TItemStack')
    if 'Register_Forsaken_Equipment' in fs:
        # These equipment markers must not trust a stale unit-ability cache.
        body=functions(source)['Register_Forsaken_Equipment']
        if "SaveBoolean(ForsakenElementSources,0,'A1C3',true)" not in body:
            anchor='    set ForsakenElementSources=InitHashtable()'
            extra='\n'.join("    call SaveBoolean(ForsakenElementSources,0,'%s',true)"%raw for raw in ['A1C3','A0OT','A0A3','A0FF'])
            body=body.replace(anchor,anchor+'\n'+extra,1)
            source=put(source,'Register_Forsaken_Equipment',body)
    if 'Forsaken_EnableHero' in fs:
        body=functions(source)['Forsaken_EnableHero']
        if "call UnitRemoveAbility(holder,'A0OT')" not in body:
            body=body.replace('    call Forsaken_UpdatePanels(holder)',"    if Forsaken_ElementAbilityLevel(holder,'A0OT')==0 then\n        call UnitRemoveAbility(holder,'A0OT')\n        call UnitRemoveAbility(holder,'B08K')\n    endif\n    if Forsaken_ElementAbilityLevel(holder,'A0A3')==0 then\n        call UnitRemoveAbility(holder,'A0A3')\n    endif\n    if Forsaken_ElementAbilityLevel(holder,'A1C3')==0 then\n        call UnitRemoveAbility(holder,'A1C3')\n    endif\n    call Forsaken_UpdatePanels(holder)")
            source=put(source,'Forsaken_EnableHero',body)
    if native and lib=='TCooldown':
        # Native has no Backpack dependency. Keep NPC innate abilities in the strict adapter.
        if 'TBackpack' not in source.splitlines()[0]:
            source=dependency(source,'TEquip')
            source=source.replace("GetUnitAbilityLevelSwapped('A1C3',GetTriggerUnit())","Forsaken_ElementAbilityLevel(GetTriggerUnit(),'A1C3')")
    return source

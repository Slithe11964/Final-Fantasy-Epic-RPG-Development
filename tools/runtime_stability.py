"""Armory awards/visits, current-cast cooldowns, and bounded import recovery."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
from priest_ultimate import declarations
HERE=Path(__file__).resolve().parents[1]/'experiments/Forsaken'


def refresh(source,*,native=False):
    fs=functions(source)
    if 'Armory_ShowCategory' in fs:
        source=declarations(source,['integer array ArmoryViewOwner'])
        helper=(HERE/'ArmoryVisits.j').read_text()
        for name,body in functions(helper).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function InitTrig_Armory takes',body+'\n\nfunction InitTrig_Armory takes',1)
        completion=functions(source)['Armory_CheckCompletion'].strip()
        source=re.sub(r'^function Armory_CheckCompletion takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
        source=source.replace('function Armory_ShowCategory takes',completion+'\n\nfunction Armory_ShowCategory takes',1)
        name='Armory_ShowCategory';body=functions(source)[name]
        if 'set p=Player(ArmoryViewOwner' not in body:
            body=body.replace('    call Armory_IndexPages()', '    if ArmoryViewOwner[playerIndex]>0 then\n        set p=Player(ArmoryViewOwner[playerIndex]-1)\n    endif\n    call Armory_IndexPages()',1)
        source=put(source,name,body)
        name='Trig_Armory_Open_Actions';body=functions(source)[name]
        if 'set ArmoryViewOwner' not in body:
            body=body.replace('    if(Trig_', '    set ArmoryViewOwner[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1]=0\n    if(Trig_',1)
            body=body.replace('    call SelectUnitForPlayerSingle(', '    call Armory_ShowCategory(udg_ArmoryUnit[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1],0)\n    call SelectUnitForPlayerSingle(',1)
        source=put(source,name,body)
        name='Trig_Armory_Select_Actions';body=functions(source)[name]
        if 'armory is read only' not in body:
            anchor='    if(Trig_Armory_Select_NotYourArmory())then'
            body=body.replace(anchor,"""    if ArmoryViewOwner[playerIndex]>0 and ArmoryViewOwner[playerIndex]!=playerIndex and itemIndex>0 and ArmoryMissingUnit[itemIndex]!=0 then
        call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,12,GetObjectName(udg_ItemIdTable[itemIndex])+": "+ArmoryHint[itemIndex]+"|nThis armory is read only.")
        call Armory_ShowCategory(GetTriggerUnit(),ArmoryCategory[playerIndex])
        return
    endif
"""+anchor,1)
        source=put(source,name,body)
        source=put(source,'Trig_Armory_Store_Item_MissingEntry',"""function Trig_Armory_Store_Item_MissingEntry takes nothing returns boolean
    return ArmoryMissingUnit[udg_ItemIndex]!=0 and not IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[udg_ItemIndex])
endfunction""")
        name='Trig_Armory_Store_Item_Actions';body=functions(source)[name]
        if 'call Armory_CheckCompletion' not in body:body=body.replace('endfunction','    call Armory_CheckCompletion(GetOwningPlayer(GetTriggerUnit()))\nendfunction')
        source=put(source,name,body)
        name='RegisterTriggers_Armory_Part2';body=functions(source)[name]
        if 'call Armory_RegisterVisits()' not in body:body=body.replace('endfunction','    call Armory_RegisterVisits()\nendfunction')
        source=put(source,name,body)
    if 'Trig_Title_ArmsCollection_Actions' in fs:
        source=dependency(source,'TArmory')
        body=functions(source)['Trig_Title_ArmsCollection_Actions']
        # Completion is an earned title, never reconstructed by adding/removing it.
        body=re.sub(r'                        call (?:Collection_)?ForceAddPlayerSimple\(udg_TempPlayer,udg_TitleForce\[56\]\)\n                        set udg_TempInteger=1\n                        loop.*?                        endloop\n','',body,flags=re.S)
        if 'call Armory_CheckCompletion' not in body:body=body.replace('endfunction','    call Armory_CheckCompletion(udg_TempPlayer)\nendfunction')
        source=put(source,'Trig_Title_ArmsCollection_Actions',body)
    if 'Trig_Cooldown_Scaling_Actions' in fs:
        helper="""function Cooldown_ApplyCurrent takes unit caster,integer raw,integer level,real duration returns nothing
    call BlzSetUnitAbilityCooldown(caster,raw,level,duration)
    // Setting the object duration alone leaves the first running cooldown unchanged.
    call BlzStartUnitAbilityCooldown(caster,raw,RMaxBJ(0.,duration))
endfunction"""
        if not native:
            helper=helper.replace('    call BlzStartUnitAbilityCooldown(caster,raw,RMaxBJ(0.,duration))\n','')
        if 'Cooldown_ApplyCurrent' in functions(source):source=put(source,'Cooldown_ApplyCurrent',helper)
        else:source=source.replace('function Cooldown_Base takes',helper+'\n\nfunction Cooldown_Base takes',1)
        if not native:
            name='Register_Cooldown_Scaling';body=functions(source)[name]
            event='    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cooldown_Scaling,EVENT_PLAYER_UNIT_SPELL_CAST)'
            if event not in body:body=body.replace('    call TriggerAddCondition(',event+'\n    call TriggerAddCondition(',1)
            source=put(source,name,body)
        body=functions(source)['Trig_Cooldown_Scaling_Actions'].replace('call BlzSetUnitAbilityCooldown(', 'call Cooldown_ApplyCurrent(')
        source=put(source,'Trig_Cooldown_Scaling_Actions',body)
        from first_cast_cooldown import refresh as first_cast_refresh
        source=first_cast_refresh(source,native=native)
    if 'Trig_OmegaWeapon_SpellRotation_Actions' in fs:
        name='Trig_OmegaWeapon_SpellRotation_Actions';body=functions(source)[name]
        guard='    if GetWidgetLife(gg_unit_N022_0125)<=.405 then\n        return\n    endif\n'
        if guard not in body:
            body=body.replace('    set l_tempPoint=GetUnitLoc(gg_unit_N022_0125)',guard+'    set l_tempPoint=GetUnitLoc(gg_unit_N022_0125)')
        source=put(source,name,body)
    if 'QuestOmegaWeapon_Slain' in fs:
        name='QuestOmegaWeapon_Slain';body=functions(source)[name]
        if 'call DisableTrigger(gg_trg_OmegaWeapon_SpellRotation)' not in body:body=body.replace('    if(', '    call DisableTrigger(gg_trg_OmegaWeapon_SpellRotation)\n    if(',1)
        source=put(source,name,body)
    if 'FFN_CreateUnit' in fs:
        name='FFN_CreateUnit';body=functions(source)[name]
        if 'call ShowUnit(created,false)' not in body:body=body.replace('    set FFN_UnitRaw[index]=raw','    set FFN_UnitRaw[index]=raw\n    call ShowUnit(created,false)',1)
        source=put(source,name,body)
    if 'FFN_Cleanup' in fs:
        name='FFN_Cleanup';body=functions(source)[name]
        if 'call ShowUnit(candidate,false)' not in body:
            body=body.replace('        if (candidate != null) then','        if (candidate != null) then\n            // Quarantine only tracked failed-import units, including cleanup retries.\n            call ShowUnit(candidate,false)',1)
        source=put(source,name,body)
    if 'FFL_Apply' in fs:
        source=dependency(source,'TArmory')
        name='FFL_Apply';body=functions(source)[name]
        if 'set FFL_Phase[pid]=6' not in body:body=body.replace('    call FFL_Snapshot(pid)','    set FFL_Phase[pid]=6\n    set FFL_Started[pid]=TimerGetElapsed(FST_Clock)\n    call FFL_Snapshot(pid)',1)
        source=put(source,name,body)
        name='FFL_Tick';body=functions(source)[name]
        if 'FFL_Phase[pid] == 6' not in body:
            line=next(line for line in body.splitlines() if 'FFL_Phase[pid]' in line and '60.' in line)
            body=body.replace(line,"""        if (((FFL_Phase[pid] == 6) or (FFL_Phase[pid] == 3)) and ((TimerGetElapsed(FST_Clock)-FFL_Started[pid])>60.)) then
            call FFL_LoadTimeout(pid)
"""+line.replace('        if','        elseif',1),1)
        source=put(source,name,body)
        name='FFL_Chat';body=functions(source)[name]
        body=body.replace('if (FFL_Phase[pid] == 4) then','if FFL_Phase[pid]==4 or FFL_Phase[pid]==5 or FFN_State[pid]!=0 or FFL_SnapshotTaken[pid] then')
        # Stop an outstanding readback before restoring its snapshot.
        body=body.replace('            call FFL_Fail(pid,"cleanup requested")','            if FRC_Phase[pid]!=0 then\n                call FRC_Stop(pid,"cleanup requested")\n            endif\n            call FFL_Fail(pid,"cleanup requested")') if 'call FRC_Stop(pid,"cleanup requested")' not in body else body
        source=put(source,name,body)
        name='FFL_Commit';body=functions(source)[name]
        if 'call ShowUnit(FFN_Unit[pid*3],true)' not in body:body=body.replace('    call SelectUnitForPlayerSingle(', '    call ShowUnit(FFN_Unit[pid*3],true)\n    call ShowUnit(FFN_Unit[pid*3+1],true)\n    call SelectUnitForPlayerSingle(',1)
        if 'call Armory_CheckCompletion' not in body:body=body.replace('    call FFL_RestoreUnlocks(pid)','    call FFL_RestoreUnlocks(pid)\n    call Armory_CheckCompletion(Player(pid))',1)
        source=put(source,name,body)
    return source

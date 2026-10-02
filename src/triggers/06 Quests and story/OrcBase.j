library TOrcBase
function Trig_OrcBase_GateGuard_Death_TalkTriggerActive takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Quest_CorruptedOrcs_Start))
endfunction

function Trig_OrcBase_GateGuard_Death_QuestNotDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[$D])==false) // $D = 13
endfunction

function Trig_OrcBase_GateGuard_Death_UnfreezeBaseUnit takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call UnitRemoveAbilityBJ('A0VJ',GetEnumUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
endfunction

function Trig_OrcBase_GateGuard_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_OrcBase_GateGuard_Death_QuestNotDiscovered())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Corrupted Orcs|r")
        set udg_MainQuest[$D]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"Corrupted Orcs"),"You found a base full of corrupted orcs. Clear it all out!","ReplaceableTextures\\CommandButtons\\BTNChaosGrom.blp") // $D = 13
        call GroupAddUnitSimple(gg_unit_nbfl_0170,udg_BossUnits)
        if(Trig_OrcBase_GateGuard_Death_TalkTriggerActive())then
            call DisableTrigger(gg_trg_Quest_CorruptedOrcs_Start)
            call DestroyTrigger(gg_trg_Quest_CorruptedOrcs_Start)
            call DestroyEffectBJ(udg_SpecialEffect[30])
        endif
    endif
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_DTg8_0028)
    call ForGroupBJ(udg_RedBeastGroup,function Trig_OrcBase_GateGuard_Death_UnfreezeBaseUnit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_OrcBase_Units_Cleared_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_RedBeastGroup))
endfunction

function Trig_OrcBase_Units_Cleared_BaseCleared takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_RedBeastGroup))
endfunction

function Trig_OrcBase_Units_Cleared_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_RedBeastGroup)
    if(Trig_OrcBase_Units_Cleared_BaseCleared())then
        call DisableTrigger(GetTriggeringTrigger())
        set udg_SiegeSouthUnitType[1]='nggr' // 'nggr': object name not found in map data
        set udg_SiegeSouthUnitType[3]='nwrg' // 'nwrg': object name not found in map data
        set udg_SiegeSouthUnitType[5]='n01A' // 'n01A': unit "Infernal Knight"
        set udg_SiegeSouthUnitType[7]='n01B' // 'n01B': unit "Infernal Templar"
        call SetUnitInvulnerable(gg_unit_nbfl_0170,false)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Destroy the Fountain of Blood.")
        call QuestSetDescriptionBJ(udg_MainQuest[$D],"Destroy the Fountain of Blood in the Corrupted Orcs base.") // $D = 13
        call EnableTrigger(gg_trg_Shemhazai_Appears)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_OrcBase takes nothing returns nothing
endfunction
function RegisterR11_OrcBase_GateGuard_Death takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_OrcBase_GateGuard_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_OrcBase_GateGuard_Death,gg_unit_ncpn_0025,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_OrcBase_GateGuard_Death,function Trig_OrcBase_GateGuard_Death_Actions)
endfunction
function RegisterR11_OrcBase_Units_Cleared takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_OrcBase_Units_Cleared=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_OrcBase_Units_Cleared,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerRegisterAnyUnitEventBJ(gg_trg_OrcBase_Units_Cleared,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_OrcBase_Units_Cleared,Condition(function Trig_OrcBase_Units_Cleared_Conditions))
    call TriggerAddAction(gg_trg_OrcBase_Units_Cleared,function Trig_OrcBase_Units_Cleared_Actions)
endfunction




endlibrary

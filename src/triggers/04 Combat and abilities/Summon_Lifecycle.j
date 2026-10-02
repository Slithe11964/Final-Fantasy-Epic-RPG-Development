library TSummonLifecycle
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Summon_Detect=null
    trigger gg_trg_Summon_Death_Cleanup=null
endglobals

function Trig_Summon_Detect_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A009',GetTriggerUnit())>0)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'A009': ability "Summon Auto-Powerup"
endfunction

function Trig_Summon_Detect_Actions takes nothing returns nothing
    set udg_TempUnit2=GetTriggerUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
endfunction

function Trig_Summon_Death_Cleanup_Conditions takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_SUMMONED))!=null
endfunction

function Trig_Summon_Death_Cleanup_DeadIsSummon1 takes nothing returns boolean
    return(GetTriggerUnit()==udg_GolemSummon)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsSummon2 takes nothing returns boolean
    return(GetTriggerUnit()==udg_Eidolon1)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsSummon3 takes nothing returns boolean
    return(GetTriggerUnit()==udg_Eidolon2)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsSummon4 takes nothing returns boolean
    return(GetTriggerUnit()==udg_Eidolon3)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsSummon5 takes nothing returns boolean
    return(GetTriggerUnit()==udg_BahamutSummon)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsNeoBahamut takes nothing returns boolean
    return(GetTriggerUnit()==udg_NeoBahamutSummon)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsBahamutZero takes nothing returns boolean
    return(GetTriggerUnit()==udg_BahamutZeroSummon)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsMapUnit takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n08D_0001)
endfunction

function Trig_Summon_Death_Cleanup_DeadIsDragonAlly takes nothing returns boolean
    return(GetTriggerUnit()==udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_Summon_Death_Cleanup_DeadIsInvitedUnit takes nothing returns boolean
    return(GetTriggerUnit()==udg_SummonUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_Summon_Death_Cleanup_HasPoofDeath takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A14I',GetTriggerUnit())>0) // 'A14I': ability "Summon Poof Death"
endfunction

function Trig_Summon_Death_Cleanup_Actions takes nothing returns nothing
    if(Trig_Summon_Death_Cleanup_DeadIsSummon1())then
        set udg_GolemSummon=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsSummon2())then
        set udg_Eidolon1=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsSummon3())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ImmolationAuraGroup)
        set udg_Eidolon2=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsSummon4())then
        set udg_Eidolon3=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsSummon5())then
        set udg_BahamutSummon=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsNeoBahamut())then
        set udg_NeoBahamutSummon=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsBahamutZero())then
        set udg_BahamutZeroSummon=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsMapUnit())then
        set gg_unit_n08D_0001=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsDragonAlly())then
        set udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
    endif
    if(Trig_Summon_Death_Cleanup_DeadIsInvitedUnit())then
        set udg_SummonUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
    endif
    if(Trig_Summon_Death_Cleanup_HasPoofDeath())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(GetTriggerUnit())
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Summon_Lifecycle takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Summon_Part1, RegisterTriggers_Summon_Part3 (module Summon),
// which keeps the original registration order.

function Register_Summon_Detect takes nothing returns nothing
    set gg_trg_Summon_Detect=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Summon_Detect,GetPlayableMapRect())
    call TriggerAddCondition(gg_trg_Summon_Detect,Condition(function Trig_Summon_Detect_Conditions))
    call TriggerAddAction(gg_trg_Summon_Detect,function Trig_Summon_Detect_Actions)
endfunction

function Register_Summon_Death_Cleanup takes nothing returns nothing
    set gg_trg_Summon_Death_Cleanup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Summon_Death_Cleanup,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Summon_Death_Cleanup,Condition(function Trig_Summon_Death_Cleanup_Conditions))
    call TriggerAddAction(gg_trg_Summon_Death_Cleanup,function Trig_Summon_Death_Cleanup_Actions)
endfunction

endlibrary

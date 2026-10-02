library TMomentum requires TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Momentum_Cast=null
    trigger gg_trg_Momentum_Apply=null
    trigger gg_trg_Momentum_Decay=null
endglobals

function Trig_Momentum_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A197') // 'A197': ability "Momentum"
endfunction

function Trig_Momentum_Cast_NoMomentumStacks takes nothing returns boolean
    return(udg_MomentumCharges[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]<=0)
endfunction

function Trig_Momentum_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h02S',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h02S': unit "Simple Casting Dummy"
    call RemoveLocation(udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0H0',GetLastCreatedUnit()) // 'A0H0': ability "Momentum"
    if(Trig_Momentum_Cast_NoMomentumStacks())then
        call SetUnitAbilityLevelSwapped('A0H0',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A0H0': ability "Momentum"
    else
        // (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) minus (1).
        call SetUnitAbilityLevelSwapped('A0H0',GetLastCreatedUnit(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1)) // 'A0H0': ability "Momentum"
    endif
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"bloodlust",GetTriggerUnit())
endfunction

function Trig_Momentum_Apply_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0H0') // 'A0H0': ability "Momentum"
endfunction

function Trig_Momentum_Apply_Actions takes nothing returns nothing
    call UnitRemoveBuffBJ('B07W',GetSpellTargetUnit()) // 'B07W': buff tooltip "Momentum"
    call UnitRemoveBuffBJ('B07V',GetSpellTargetUnit()) // 'B07V': buff tooltip "Momentum"
    // (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) plus (1).
    call SetUnitAbilityLevelSwapped('A197',GetSpellTargetUnit(),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())+1)) // 'A197': ability "Momentum"
    // ((GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) plus (1)) times (10).
    set udg_MomentumCharges[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=((GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())+1)*$A) // $A = 10
    call StartTimerBJ(udg_MomentumTimer,false,.01)
    call EnableTrigger(gg_trg_Momentum_Decay)
endfunction

function Trig_Momentum_Decay_HasFrenzy takes nothing returns boolean
    return(UnitHasBuffBJ(Player_GetHero(GetEnumPlayer()),'B07V')) // 'B07V': buff tooltip "Momentum"
endfunction

function Trig_Momentum_Decay_AboveBaseLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A197',Player_GetHero(GetEnumPlayer()))>1) // 'A197': ability "Momentum"
endfunction

function Trig_Momentum_Decay_DecayPlayer takes nothing returns nothing
    if(Trig_Momentum_Decay_AboveBaseLevel())then
        if(Trig_Momentum_Decay_HasFrenzy())then
            set udg_TempBoolean=true
        else
            call SetUnitAbilityLevelSwapped('A197',Player_GetHero(GetEnumPlayer()),1) // 'A197': ability "Momentum"
            set udg_MomentumCharges[GetConvertedPlayerId(GetEnumPlayer())]=0
        endif
    endif
endfunction

function Trig_Momentum_Decay_AnyStillActive takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Momentum_Decay_Actions takes nothing returns nothing
    set udg_TempBoolean=false
    call ForForce(udg_PlayingPlayers,function Trig_Momentum_Decay_DecayPlayer)
    if(Trig_Momentum_Decay_AnyStillActive())then
        call StartTimerBJ(udg_MomentumTimer,false,.5)
    else
        call DisableTrigger(GetTriggeringTrigger())
    endif
endfunction

// World Editor calls InitTrig_Momentum automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Momentum (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Momentum takes nothing returns nothing
endfunction

function Register_Momentum_Cast takes nothing returns nothing
    set gg_trg_Momentum_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Momentum_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Momentum_Cast,Condition(function Trig_Momentum_Cast_Conditions))
    call TriggerAddAction(gg_trg_Momentum_Cast,function Trig_Momentum_Cast_Actions)
endfunction

function Register_Momentum_Apply takes nothing returns nothing
    set gg_trg_Momentum_Apply=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Momentum_Apply,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Momentum_Apply,Condition(function Trig_Momentum_Apply_Conditions))
    call TriggerAddAction(gg_trg_Momentum_Apply,function Trig_Momentum_Apply_Actions)
endfunction

function Register_Momentum_Decay takes nothing returns nothing
    set gg_trg_Momentum_Decay=CreateTrigger()
    call DisableTrigger(gg_trg_Momentum_Decay)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Momentum_Decay,udg_MomentumTimer)
    call TriggerAddAction(gg_trg_Momentum_Decay,function Trig_Momentum_Decay_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Momentum takes nothing returns nothing
    call Register_Momentum_Cast()
    call Register_Momentum_Apply()
    call Register_Momentum_Decay() // starts off; enabled by Momentum
endfunction

endlibrary

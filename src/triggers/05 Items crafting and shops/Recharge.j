library TRecharge requires TPlayerPart01, TText
function Trig_Recharge_OnKill_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A12S',GetKillingUnitBJ())>0)and(IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetKillingUnitBJ()))) // 'A12S': ability "Recharge"
endfunction

function Trig_Recharge_OnKill_Cond_RechargeBoosted takes nothing returns boolean
    return(TimerGetRemaining(udg_RangedShotTimer[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])>.0)and(GetKillingUnitBJ()==Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())))
endfunction

function Trig_Recharge_OnKill_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetKillingUnitBJ(),"Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_Recharge_OnKill_Cond_RechargeBoosted())then
        // (current mana of the killing unit) plus (200).
        call SetUnitManaBJ(GetKillingUnitBJ(),(GetUnitStateSwap(UNIT_STATE_MANA,GetKillingUnitBJ())+200.))
        call Text_FloatingDamage(GetKillingUnit(),true,0,200.,true,0)
    else
        // (current mana of the killing unit) plus (100).
        call SetUnitManaBJ(GetKillingUnitBJ(),(GetUnitStateSwap(UNIT_STATE_MANA,GetKillingUnitBJ())+100.))
        call Text_FloatingDamage(GetKillingUnit(),true,0,100.,true,0)
    endif
endfunction

// World Editor calls InitTrig_Recharge automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Recharge (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Recharge takes nothing returns nothing
endfunction

function Register_Recharge_OnKill takes nothing returns nothing
    set gg_trg_Recharge_OnKill=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Recharge_OnKill,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Recharge_OnKill,Condition(function Trig_Recharge_OnKill_Conditions))
    call TriggerAddAction(gg_trg_Recharge_OnKill,function Trig_Recharge_OnKill_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Recharge takes nothing returns nothing
    call Register_Recharge_OnKill()
endfunction

endlibrary

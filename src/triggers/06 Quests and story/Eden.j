library TEden requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Eden_Setup=null
    trigger gg_trg_Eden_Summon=null
    trigger gg_trg_Eden_Despawn=null
endglobals

function Trig_Eden_Setup_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(gg_unit_N02I_0074,'d',40.,'d',15.)
    call ShowUnitHide(gg_unit_N02I_0074)
    call PauseUnitBJ(true,gg_unit_N02I_0074)
    call SetUnitInvulnerable(gg_unit_N02I_0074,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Eden_Summon_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0IK')and(udg_InCinematicMode==false) // 'A0IK': ability "Summon Eden"
endfunction

function Trig_Eden_Summon_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call EnableTrigger(gg_trg_Eden_Despawn)
    call GroupAddUnitSimple(gg_unit_N02I_0074,udg_BossGroup)
    call EnableTrigger(gg_trg_Quest_StrongestEidolon_Complete)
    call UnitRemoveAbilityBJ('A0CE',gg_unit_h00Z_0130) // 'A0CE': ability "Eden"
    set l_tempPoint=GetRectCenter(gg_rct_182)
    call SetUnitFacingToFaceLocTimed(gg_unit_u007_0128,l_tempPoint,.2)
    call RemoveLocation(l_tempPoint)
    call ConditionalTriggerExecute(gg_trg_Npc_Priscilla_SummonEden)
    call StartTimerBJ(udg_EdenTimer,false,300.)
    set udg_EdenTimerDialog=CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"Eden disappears in")
    call TimerDialogSetTitleColorBJ(udg_EdenTimerDialog,'d',10.,10.,0)
    call TimerDialogDisplayBJ(true,udg_EdenTimerDialog)
    call Wait_Polled(.5)
    call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u007_0128,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=GetRectCenter(gg_rct_182)
    call SetUnitPositionLocFacingBJ(gg_unit_N02I_0074,l_tempPoint,315.)
    call SetUnitLifePercentBJ(gg_unit_N02I_0074,'d')
    call PauseUnitBJ(false,gg_unit_N02I_0074)
    call SetUnitInvulnerable(gg_unit_N02I_0074,false)
    call ShowUnitShow(gg_unit_N02I_0074)
    call RemoveLocation(l_tempPoint)
    call StartTimerBJ(udg_ShiftElementsTimer,false,.01)
    set l_tempPoint=null
endfunction

function Trig_Eden_Despawn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyTimerDialogBJ(udg_EdenTimerDialog)
    call GroupRemoveUnitSimple(gg_unit_N02I_0074,udg_BossGroup)
    call ShowUnitHide(gg_unit_N02I_0074)
    call SetUnitLifePercentBJ(gg_unit_N02I_0074,'d')
    call PauseUnitBJ(true,gg_unit_N02I_0074)
    call SetUnitInvulnerable(gg_unit_N02I_0074,true)
    call UnitRemoveBuffsExBJ(bj_BUFF_POLARITY_EITHER,bj_BUFF_RESIST_EITHER,gg_unit_N02I_0074,false,false)
    call UnitResetCooldown(gg_unit_u007_0128)
    call EnableTrigger(gg_trg_Eden_Summon)
    call DisableTrigger(gg_trg_Quest_StrongestEidolon_Complete)
endfunction

// World Editor calls InitTrig_Eden automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Eden (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Eden takes nothing returns nothing
endfunction

function Register_Eden_Setup takes nothing returns nothing
    set gg_trg_Eden_Setup=CreateTrigger()
    call TriggerAddAction(gg_trg_Eden_Setup,function Trig_Eden_Setup_Actions)
endfunction

function Register_Eden_Summon takes nothing returns nothing
    set gg_trg_Eden_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Eden_Summon)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Eden_Summon,Player(8),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Eden_Summon,Condition(function Trig_Eden_Summon_Conditions))
    call TriggerAddAction(gg_trg_Eden_Summon,function Trig_Eden_Summon_Actions)
endfunction

function Register_Eden_Despawn takes nothing returns nothing
    set gg_trg_Eden_Despawn=CreateTrigger()
    call DisableTrigger(gg_trg_Eden_Despawn)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Eden_Despawn,udg_EdenTimer)
    call TriggerAddAction(gg_trg_Eden_Despawn,function Trig_Eden_Despawn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Eden takes nothing returns nothing
    call Register_Eden_Setup() // run by MapBootstrap
    call Register_Eden_Summon() // starts off; enabled by Eden, Quest_StrongestEidolon
    call Register_Eden_Despawn() // starts off; enabled by Eden; disabled by Quest_StrongestEidolon
endfunction

endlibrary

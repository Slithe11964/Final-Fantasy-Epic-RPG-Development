library TDarkQuezacotl requires TCam, TCine, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DarkQuezacotl_Appear=null
    trigger gg_trg_DarkQuezacotl_Death=null
endglobals

function Trig_DarkQuezacotl_Appear_InQuezacotlRect takes nothing returns boolean
    return(RectContainsUnit(gg_rct_124,GetTriggerUnit()))or(RectContainsUnit(gg_rct_124,GetSpellTargetUnit()))
endfunction

function Trig_DarkQuezacotl_Appear_IsThunderSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A00O')or(GetSpellAbilityId()=='A0QF')or(GetSpellAbilityId()=='A13K')or(GetSpellAbilityId()=='A0SB')or(GetSpellAbilityId()=='A07O')or(GetSpellAbilityId()=='A0UZ')or(GetSpellAbilityId()=='A19R') // 'A00O': ability "Bolt"; 'A0QF': ability "Thundaga"; 'A13K': ability "Shock"; 'A0SB': ability "Enthunder"; 'A07O': ability "Bolt"; 'A0UZ': ability "Thundaga"; 'A19R': ability "Bolt"
endfunction

function Trig_DarkQuezacotl_Appear_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(Trig_DarkQuezacotl_Appear_InQuezacotlRect())and(Trig_DarkQuezacotl_Appear_IsThunderSpell())
endfunction

function Trig_DarkQuezacotl_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkQuezacotl_Appear_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(gg_unit_H01N_0035)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    if(Trig_DarkQuezacotl_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H01N_0035,0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_H01N_0035)
        call Text_Say(null,"|cff00ddddDark Quezacotl has appeared!|r",true)
        call Cine_ExitAction()
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_H01N_0035)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff00ddddDark Quezacotl has appeared!|r")
    endif
    call SetUnitInvulnerable(gg_unit_H01N_0035,false)
    call PauseUnitBJ(false,gg_unit_H01N_0035)
    call GroupAddUnitSimple(gg_unit_H01N_0035,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_H01N_0035,udg_BossUnits)
    call EnableTrigger(gg_trg_DarkQuezacotl_Death)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_DarkQuezacotl_Death_DarkPhoenixDead takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H021_0034,udg_DarkEidolonGroup)==false)
endfunction

function Trig_DarkQuezacotl_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DarkQuezacotl_Death_DarkPhoenixDead())then
        call RemoveItemFromStockBJ('I07T',gg_unit_n02Y_0052) // 'I07T': item "Information: Dark Quezacotl/Phoenix"
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DarkQuezacotl automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DarkQuezacotl (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DarkQuezacotl takes nothing returns nothing
endfunction

function Register_DarkQuezacotl_Appear takes nothing returns nothing
    set gg_trg_DarkQuezacotl_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_DarkQuezacotl_Appear)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_DarkQuezacotl_Appear,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_DarkQuezacotl_Appear,Condition(function Trig_DarkQuezacotl_Appear_Conditions))
    call TriggerAddAction(gg_trg_DarkQuezacotl_Appear,function Trig_DarkQuezacotl_Appear_Actions)
endfunction

function Register_DarkQuezacotl_Death takes nothing returns nothing
    set gg_trg_DarkQuezacotl_Death=CreateTrigger()
    call DisableTrigger(gg_trg_DarkQuezacotl_Death)
    call TriggerRegisterUnitEvent(gg_trg_DarkQuezacotl_Death,gg_unit_H01N_0035,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_DarkQuezacotl_Death,function Trig_DarkQuezacotl_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_DarkQuezacotl takes nothing returns nothing
    call Register_DarkQuezacotl_Appear() // starts off; enabled by DarkEidolons
    call Register_DarkQuezacotl_Death() // starts off; enabled by DarkQuezacotl
endfunction

endlibrary

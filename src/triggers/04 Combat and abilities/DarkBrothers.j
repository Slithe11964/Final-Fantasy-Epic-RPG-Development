library TDarkBrothers requires TCam, TCine, TText, TWait
function Trig_DarkBrothers_Appear_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DarkBrothers_Appear_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DarkBrothers_Appear_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(gg_unit_O00B_0032)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(gg_unit_O00A_0033)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    if(Trig_DarkBrothers_Appear_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_O00B_0032,0)
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_O00B_0032)
        call ShowUnitShow(gg_unit_O00A_0033)
        call Text_Say(null,"|cff383838Dark Brothers have appeared!|r",true)
        call Cine_ExitAction()
    else
        call Wait_Polled(.5)
        call ShowUnitShow(gg_unit_O00B_0032)
        call ShowUnitShow(gg_unit_O00A_0033)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff383838Dark Brothers have appeared!|r")
    endif
    call SetUnitInvulnerable(gg_unit_O00B_0032,false)
    call SetUnitInvulnerable(gg_unit_O00A_0033,false)
    call PauseUnitBJ(false,gg_unit_O00B_0032)
    call PauseUnitBJ(false,gg_unit_O00A_0033)
    call GroupAddUnitSimple(gg_unit_O00B_0032,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_O00A_0033,udg_BossGroup)
    call GroupAddUnitSimple(gg_unit_O00B_0032,udg_BossUnits)
    call GroupAddUnitSimple(gg_unit_O00A_0033,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_DarkBrothers takes nothing returns nothing
endfunction

function RegisterR11_DarkBrothers_Appear takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_DarkBrothers_Appear=CreateTrigger()

call DisableTrigger(gg_trg_DarkBrothers_Appear)

call TriggerRegisterEnterRectSimple(gg_trg_DarkBrothers_Appear,gg_rct_117)

call TriggerAddCondition(gg_trg_DarkBrothers_Appear,Condition(function Trig_DarkBrothers_Appear_Conditions))

call TriggerAddAction(gg_trg_DarkBrothers_Appear,function Trig_DarkBrothers_Appear_Actions)

endfunction




endlibrary

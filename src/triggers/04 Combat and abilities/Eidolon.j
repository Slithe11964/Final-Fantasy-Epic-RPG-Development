library TEidolon requires TLoc, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Eidolon_Found_Reveal=null
    trigger gg_trg_Eidolon_Leviathan_Ambush=null
endglobals

function Trig_Eidolon_Found_Reveal_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_BossUnits)==false)and(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Eidolon_Found_Reveal_Cond_IsWindLordA takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01J_0069)
endfunction

function Trig_Eidolon_Found_Reveal_Enum_ClearRubble takes nothing returns nothing
    call KillDestructable(GetEnumDestructable())
endfunction

function Trig_Eidolon_Found_Reveal_Cond_IsTitan takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01I_0070)
endfunction

function Trig_Eidolon_Found_Reveal_Actions takes nothing returns nothing
    call DisplayTextToForce(GetPlayersAll(),("You've found |cffffcc00"+(GetHeroProperName(GetTriggerUnit())+"|r!")))
    call GroupAddUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_Eidolon_Found_Reveal_Cond_IsTitan())then
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_RetreatPoint=GetRectCenter(gg_rct_642)
        call AddSpecialEffectLocBJ(udg_RetreatPoint,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=6
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // (loop counter A treated as a decimal-capable number) times (60).
            set udg_TempPoint5=Loc_PolarOffset(udg_TempPoint,275.,(I2R(GetForLoopIndexA())*60.))
            call AddSpecialEffectLocBJ(udg_TempPoint5,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_RetreatPoint)
        call EnumDestructablesInRectAll(gg_rct_642,function Trig_Eidolon_Found_Reveal_Enum_ClearRubble)
    else
        set udg_RetreatPoint=GetUnitLoc(GetTriggerUnit())
        if(Trig_Eidolon_Found_Reveal_Cond_IsWindLordA())then
            call IssuePointOrderLocBJ(gg_unit_H01K_0068,"attack",udg_RetreatPoint)
        else
            call IssuePointOrderLocBJ(gg_unit_H01J_0069,"attack",udg_RetreatPoint)
        endif
        call RemoveLocation(udg_RetreatPoint)
    endif
endfunction

function Trig_Eidolon_Leviathan_Ambush_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Eidolon_Leviathan_Ambush_Cond_TargetIsShip takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='nbot') // 'nbot': object name not found in map data
endfunction

function Trig_Eidolon_Leviathan_Ambush_Cond_LeviathanEngaged takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_H01L_0067,udg_BossUnits))
endfunction

function Trig_Eidolon_Leviathan_Ambush_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"You've found |cffffcc00Leviathan|r!")
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetUnitPositionLocFacingLocBJ(gg_unit_H01L_0067,l_tempPoint,l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call ShowUnitShow(gg_unit_H01L_0067)
    call GroupAddUnitSimple(gg_unit_H01L_0067,udg_BossUnits)
    call PauseUnitBJ(false,gg_unit_H01L_0067)
    call SetUnitInvulnerable(gg_unit_H01L_0067,false)
    call IssueTargetOrderBJ(gg_unit_H01L_0067,"attack",GetTriggerUnit())
    if(Trig_Eidolon_Leviathan_Ambush_Cond_TargetIsShip())then
        set udg_DmgFlagPure=true
        // (current health of the triggering unit) times ((a random decimal number between 15 and 16) divided by (18)).
        call UnitDamageTargetBJ(gg_unit_H01L_0067,GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())*(GetRandomReal(15.,16.)/ 18.)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
    endif
    call Wait_Polled(5.)
    if(Trig_Eidolon_Leviathan_Ambush_Cond_LeviathanEngaged())then
        set l_tempPoint=GetRectCenter(gg_rct_229)
        call IssuePointOrderLocBJ(gg_unit_H01L_0067,"attack",l_tempPoint)
        call RemoveLocation(l_tempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Eidolon automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Eidolon (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Eidolon takes nothing returns nothing
endfunction

function Register_Eidolon_Found_Reveal takes nothing returns nothing
    set gg_trg_Eidolon_Found_Reveal=CreateTrigger()
    call DisableTrigger(gg_trg_Eidolon_Found_Reveal)
    call TriggerRegisterUnitEvent(gg_trg_Eidolon_Found_Reveal,gg_unit_H01I_0070,EVENT_UNIT_DAMAGED)
    call TriggerRegisterUnitEvent(gg_trg_Eidolon_Found_Reveal,gg_unit_H01K_0068,EVENT_UNIT_DAMAGED)
    call TriggerRegisterUnitEvent(gg_trg_Eidolon_Found_Reveal,gg_unit_H01J_0069,EVENT_UNIT_DAMAGED)
    call TriggerAddCondition(gg_trg_Eidolon_Found_Reveal,Condition(function Trig_Eidolon_Found_Reveal_Conditions))
    call TriggerAddAction(gg_trg_Eidolon_Found_Reveal,function Trig_Eidolon_Found_Reveal_Actions)
endfunction

function Register_Eidolon_Leviathan_Ambush takes nothing returns nothing
    set gg_trg_Eidolon_Leviathan_Ambush=CreateTrigger()
    call DisableTrigger(gg_trg_Eidolon_Leviathan_Ambush)
    call TriggerRegisterEnterRectSimple(gg_trg_Eidolon_Leviathan_Ambush,gg_rct_231)
    call TriggerAddCondition(gg_trg_Eidolon_Leviathan_Ambush,Condition(function Trig_Eidolon_Leviathan_Ambush_Conditions))
    call TriggerAddAction(gg_trg_Eidolon_Leviathan_Ambush,function Trig_Eidolon_Leviathan_Ambush_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Eidolon takes nothing returns nothing
    call Register_Eidolon_Found_Reveal() // starts off; enabled by Quest_EidolonChallenge; disabled by Quest_EidolonChallenge; destroyed by Quest_EidolonChallenge
    call Register_Eidolon_Leviathan_Ambush() // starts off; enabled by Quest_EidolonChallenge
endfunction

endlibrary

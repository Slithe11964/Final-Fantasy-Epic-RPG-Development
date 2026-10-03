library TChocoboWildBehavior requires TGroup, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chocobo_Wild_Death=null
    trigger gg_trg_Chocobo_Wild_Retaliate=null
    trigger gg_trg_Chocobo_Wild_AI=null
endglobals

function Trig_Chocobo_Wild_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_TownNpcUnits))
endfunction

function Trig_Chocobo_Wild_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_TownNpcUnits)
endfunction

function Trig_Chocobo_Wild_Retaliate_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_TownNpcUnits))
endfunction

function Trig_Chocobo_Wild_Retaliate_Actions takes nothing returns nothing
    local location l_tempPoint
    call SetUnitOwner(GetTriggerUnit(),Player($B),true) // $B = 11
    call Unit_ScaleToLevel60(GetTriggerUnit())
    call UnitRemoveAbilityBJ('Awan',GetTriggerUnit()) // 'Awan': object name not found in map data
    call UnitRemoveAbilityBJ('Abun',GetTriggerUnit()) // 'Abun': object name not found in map data
    call UnitRemoveAbilityBJ('A0A4',GetTriggerUnit()) // 'A0A4': ability "Chocobo Sprint"
    call UnitAddAbilityBJ('A0AC',GetTriggerUnit()) // 'A0AC': ability "Choco-Meteo"
    call UnitAddAbilityBJ('A0MV',GetTriggerUnit()) // 'A0MV': ability "Plentiful"
    set l_tempPoint=GetUnitLoc(GetAttacker())
    call IssuePointOrderLocBJ(GetTriggerUnit(),"rainoffire",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    call CreateTextTagUnitBJ("WARK!!!",GetTriggerUnit(),0,11.,'d',.0,.0,0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),3.5)
    set l_tempPoint=null
endfunction

function Trig_Chocobo_Wild_AI_Filter_IsHostileOwned takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player($B)) // $B = 11
endfunction

function Trig_Chocobo_Wild_AI_RollArmorFirst takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Chocobo_Wild_AI_HasNearbyAllies takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Chocobo_Wild_AI_IsWildChocobo takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player(8))
endfunction

function Trig_Chocobo_Wild_AI_Filter_IsHostileEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),Player($B))) // $B = 11
endfunction

function Trig_Chocobo_Wild_AI_Filter_NotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Chocobo_Wild_AI_Filter_AttackTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Chocobo_Wild_AI_Filter_IsHostileEnemy(),Trig_Chocobo_Wild_AI_Filter_NotInvulnerable())
endfunction

function Trig_Chocobo_Wild_AI_Filter_IsHostileOwnedAgain takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player($B)) // $B = 11
endfunction

function Trig_Chocobo_Wild_AI_RollArmorFirstAgain takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Chocobo_Wild_AI_HasNearbyAlliesAgain takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Chocobo_Wild_AI_LacksShellBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B005')==false) // 'B005': buff "Shell"
endfunction

function Trig_Chocobo_Wild_AI_LacksProtectBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B007')==false) // 'B007': buff "Protect"
endfunction

function Trig_Chocobo_Wild_AI_HasNearbyEnemies takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup)==false)
endfunction

function Trig_Chocobo_Wild_AI_IsHostileChocobo takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player($B)) // $B = 11
endfunction

function Trig_Chocobo_Wild_AI_RunChocoboAI takes nothing returns nothing
    if(Trig_Chocobo_Wild_AI_IsHostileChocobo())then
        call IssueImmediateOrderBJ(GetEnumUnit(),"stop")
        set udg_TempPoint=GetUnitLoc(GetEnumUnit())
        set udg_TempGroup=Group_UnitsInRangeOfLoc(512.,udg_TempPoint,Condition(function Trig_Chocobo_Wild_AI_Filter_AttackTarget))
        call RemoveLocation(udg_TempPoint)
        if(Trig_Chocobo_Wild_AI_HasNearbyEnemies())then
            set udg_TempPoint=GetUnitLoc(GroupPickRandomUnit(udg_TempGroup))
            call DestroyGroup(udg_TempGroup)
            call IssuePointOrderLocBJ(GetEnumUnit(),"rainoffire",udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
        else
            call DestroyGroup(udg_TempGroup)
            if(Trig_Chocobo_Wild_AI_LacksProtectBuff())then
                call IssueTargetOrderBJ(GetEnumUnit(),"frostarmor",GetEnumUnit())
            else
                if(Trig_Chocobo_Wild_AI_LacksShellBuff())then
                    call IssueTargetOrderBJ(GetEnumUnit(),"drunkenhaze",GetEnumUnit())
                else
                    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
                    set udg_TempGroup=Group_UnitsInRangeOfLoc(1024.,udg_TempPoint,Condition(function Trig_Chocobo_Wild_AI_Filter_IsHostileOwnedAgain))
                    call RemoveLocation(udg_TempPoint)
                    if(Trig_Chocobo_Wild_AI_HasNearbyAlliesAgain())then
                        if(Trig_Chocobo_Wild_AI_RollArmorFirstAgain())then
                            call IssueTargetOrderBJ(GetEnumUnit(),"frostarmor",GroupPickRandomUnit(udg_TempGroup))
                            call IssueTargetOrderBJ(GetEnumUnit(),"drunkenhaze",GroupPickRandomUnit(udg_TempGroup))
                        else
                            call IssueTargetOrderBJ(GetEnumUnit(),"drunkenhaze",GroupPickRandomUnit(udg_TempGroup))
                            call IssueTargetOrderBJ(GetEnumUnit(),"frostarmor",GroupPickRandomUnit(udg_TempGroup))
                        endif
                    endif
                    call DestroyGroup(udg_TempGroup)
                endif
            endif
        endif
    else
        if(Trig_Chocobo_Wild_AI_IsWildChocobo())then
            set udg_TempPoint=GetUnitLoc(GetEnumUnit())
            set udg_TempGroup=Group_UnitsInRangeOfLoc(1024.,udg_TempPoint,Condition(function Trig_Chocobo_Wild_AI_Filter_IsHostileOwned))
            call RemoveLocation(udg_TempPoint)
            if(Trig_Chocobo_Wild_AI_HasNearbyAllies())then
                if(Trig_Chocobo_Wild_AI_RollArmorFirst())then
                    call IssueTargetOrderBJ(GetEnumUnit(),"frostarmor",GroupPickRandomUnit(udg_TempGroup))
                    call IssueTargetOrderBJ(GetEnumUnit(),"drunkenhaze",GroupPickRandomUnit(udg_TempGroup))
                else
                    call IssueTargetOrderBJ(GetEnumUnit(),"drunkenhaze",GroupPickRandomUnit(udg_TempGroup))
                    call IssueTargetOrderBJ(GetEnumUnit(),"frostarmor",GroupPickRandomUnit(udg_TempGroup))
                endif
            endif
            call DestroyGroup(udg_TempGroup)
        endif
    endif
endfunction

function Trig_Chocobo_Wild_AI_Actions takes nothing returns nothing
    call ForGroupBJ(udg_TownNpcUnits,function Trig_Chocobo_Wild_AI_RunChocoboAI)
endfunction

function InitTrig_Chocobo_WildBehavior takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Chocobo_Part1 (module Chocobo),
// which keeps the original registration order.

function Register_Chocobo_Wild_Death takes nothing returns nothing
    set gg_trg_Chocobo_Wild_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Wild_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Chocobo_Wild_Death,Condition(function Trig_Chocobo_Wild_Death_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Wild_Death,function Trig_Chocobo_Wild_Death_Actions)
endfunction

function Register_Chocobo_Wild_Retaliate takes nothing returns nothing
    set gg_trg_Chocobo_Wild_Retaliate=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Chocobo_Wild_Retaliate,Player(8),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Chocobo_Wild_Retaliate,Condition(function Trig_Chocobo_Wild_Retaliate_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Wild_Retaliate,function Trig_Chocobo_Wild_Retaliate_Actions)
endfunction

function Register_Chocobo_Wild_AI takes nothing returns nothing
    set gg_trg_Chocobo_Wild_AI=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Chocobo_Wild_AI,5.)
    call TriggerAddAction(gg_trg_Chocobo_Wild_AI,function Trig_Chocobo_Wild_AI_Actions)
endfunction

endlibrary

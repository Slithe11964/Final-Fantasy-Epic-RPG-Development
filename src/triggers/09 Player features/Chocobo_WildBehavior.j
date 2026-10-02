library TChocoboWildBehavior requires TGroup, TUnit
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
    call SetUnitOwner(GetTriggerUnit(),Player($B),true) // $B = 11
    call Unit_ScaleToLevel60(GetTriggerUnit())
    call UnitRemoveAbilityBJ('Awan',GetTriggerUnit()) // 'Awan': object name not found in map data
    call UnitRemoveAbilityBJ('Abun',GetTriggerUnit()) // 'Abun': object name not found in map data
    call UnitRemoveAbilityBJ('A0A4',GetTriggerUnit()) // 'A0A4': ability "Chocobo Sprint"
    call UnitAddAbilityBJ('A0AC',GetTriggerUnit()) // 'A0AC': ability "Choco-Meteo"
    call UnitAddAbilityBJ('A0MV',GetTriggerUnit()) // 'A0MV': ability "Plentiful"
    set udg_TempPoint=GetUnitLoc(GetAttacker())
    call IssuePointOrderLocBJ(GetTriggerUnit(),"rainoffire",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call CreateTextTagUnitBJ("WARK!!!",GetTriggerUnit(),0,11.,'d',.0,.0,0)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),3.5)
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

endlibrary

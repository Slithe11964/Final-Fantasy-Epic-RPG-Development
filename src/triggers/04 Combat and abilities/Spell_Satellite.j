library TSpellSatellite requires TLoc, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Spell_Satellite_Beam=null
    trigger gg_trg_Spell_Satellite_Beam_InGroup=null
    trigger gg_trg_Spell_Satellite_Beam_Death=null
endglobals

function Trig_Spell_Satellite_Beam_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A173')and(IsUnitInGroup(GetTriggerUnit(),udg_CupArenaUnits)==false) // 'A173': ability "Satellite Beam"
endfunction

function Trig_Spell_Satellite_Beam_IsCasterHeroAhead takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_IsCasterHeroRand1 takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_IsCasterHeroRand2 takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_IsCasterHeroOnPlayer takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_BeamAtPlayerHero takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroOnPlayer())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set l_tempPoint=null
endfunction

function Trig_Spell_Satellite_Beam_Actions takes nothing returns nothing
    local integer l_tempInteger
    local location l_tempPoint2
    local real l_tempReal
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(udg_ShinryuUnit)
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,256,GetUnitFacing(udg_ShinryuUnit))
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint2)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroAhead())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set l_tempPoint2=GetRectCenter(gg_rct_496)
    set l_tempPoint=GetRandomLocInRect(gg_rct_496)
    set l_tempReal=AngleBetweenPoints(l_tempPoint,l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,500.,l_tempReal)
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint2)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroRand1())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set l_tempPoint2=GetRectCenter(gg_rct_496)
    set l_tempPoint=GetRandomLocInRect(gg_rct_496)
    set l_tempReal=AngleBetweenPoints(l_tempPoint,l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,500.,l_tempReal)
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint2)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroRand2())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call ForForce(udg_DuelArenaPlayers,function Trig_Spell_Satellite_Beam_BeamAtPlayerHero)
    set l_tempInteger=(CountPlayersInForceBJ(udg_DuelArenaPlayers)+3)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=l_tempInteger
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set l_tempPoint2=Loc_PolarOffset(l_tempPoint,90.,(I2R(GetForLoopIndexA())*(360./ I2R(l_tempInteger))))
        call AddSpecialEffectLocBJ(l_tempPoint2,"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(l_tempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint)
    set l_tempPoint2=null
    set l_tempPoint=null
endfunction

function Trig_Spell_Satellite_Beam_InGroup_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A173')and(IsUnitInGroup(GetTriggerUnit(),udg_CupArenaUnits)) // 'A173': ability "Satellite Beam"
endfunction

function Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroRand1 takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroRand2 takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroOnPlayer takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Satellite_Beam_InGroup_BeamAtPlayerHero takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint)
    if(Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroOnPlayer())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set l_tempPoint=null
endfunction

function Trig_Spell_Satellite_Beam_InGroup_Actions takes nothing returns nothing
    local integer l_tempInteger
    local location l_tempPoint2
    local real l_tempReal
    local location l_tempPoint
    set l_tempPoint2=GetRectCenter(gg_rct_499)
    set l_tempPoint=GetRandomLocInRect(gg_rct_499)
    set l_tempReal=AngleBetweenPoints(l_tempPoint,l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,350.,l_tempReal)
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint2)
    if(Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroRand1())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set l_tempPoint2=GetRectCenter(gg_rct_499)
    set l_tempPoint=GetRandomLocInRect(gg_rct_499)
    set l_tempReal=AngleBetweenPoints(l_tempPoint,l_tempPoint2)
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,350.,l_tempReal)
    call RemoveLocation(l_tempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),l_tempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(l_tempPoint2)
    if(Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroRand2())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call ForForce(udg_CupArenaPlayers,function Trig_Spell_Satellite_Beam_InGroup_BeamAtPlayerHero)
    set l_tempInteger=(CountPlayersInForceBJ(udg_CupArenaPlayers)+2)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=l_tempInteger
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set l_tempPoint2=Loc_PolarOffset(l_tempPoint,90.,(I2R(GetForLoopIndexA())*(360./ I2R(l_tempInteger))))
        call AddSpecialEffectLocBJ(l_tempPoint2,"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(l_tempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint)
    set l_tempPoint2=null
    set l_tempPoint=null
endfunction

function Trig_Spell_Satellite_Beam_Death_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='u01R') // 'u01R': unit "Satellite Beam"
endfunction

function Trig_Spell_Satellite_Beam_Death_IsBeamFromDefender takes nothing returns boolean
    return(GetOwningPlayer(udg_WarmechUnit)!=Player($B))and(IsUnitInGroup(GetTriggerUnit(),udg_ArenaSummonGroup)==false) // $B = 11
endfunction

function Trig_Spell_Satellite_Beam_Death_Actions takes nothing returns nothing
    if(Trig_Spell_Satellite_Beam_Death_IsBeamFromDefender())then
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_DeathExplodeGroup)
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\TinkerRocket\\TinkerRocketMissile.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),3.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(GetTriggerUnit())
    endif
endfunction

function InitTrig_Spell_Satellite takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Satellite_Beam takes nothing returns nothing
    set gg_trg_Spell_Satellite_Beam=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Satellite_Beam,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Satellite_Beam,Condition(function Trig_Spell_Satellite_Beam_Conditions))
    call TriggerAddAction(gg_trg_Spell_Satellite_Beam,function Trig_Spell_Satellite_Beam_Actions)
endfunction

function Register_Spell_Satellite_Beam_InGroup takes nothing returns nothing
    set gg_trg_Spell_Satellite_Beam_InGroup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Satellite_Beam_InGroup,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Satellite_Beam_InGroup,Condition(function Trig_Spell_Satellite_Beam_InGroup_Conditions))
    call TriggerAddAction(gg_trg_Spell_Satellite_Beam_InGroup,function Trig_Spell_Satellite_Beam_InGroup_Actions)
endfunction

function Register_Spell_Satellite_Beam_Death takes nothing returns nothing
    set gg_trg_Spell_Satellite_Beam_Death=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Satellite_Beam_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Spell_Satellite_Beam_Death,Condition(function Trig_Spell_Satellite_Beam_Death_Conditions))
    call TriggerAddAction(gg_trg_Spell_Satellite_Beam_Death,function Trig_Spell_Satellite_Beam_Death_Actions)
endfunction

endlibrary

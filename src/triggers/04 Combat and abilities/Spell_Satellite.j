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
    set udg_TempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroOnPlayer())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Spell_Satellite_Beam_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(udg_ShinryuUnit)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,GetUnitFacing(udg_ShinryuUnit))
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroAhead())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempPoint2=GetRectCenter(gg_rct_496)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_496)
    set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,500.,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroRand1())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempPoint2=GetRectCenter(gg_rct_496)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_496)
    set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,500.,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_Spell_Satellite_Beam_IsCasterHeroRand2())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call ForForce(udg_DuelArenaPlayers,function Trig_Spell_Satellite_Beam_BeamAtPlayerHero)
    // (CountPlayersInForceBJ(udg_DuelArenaPlayers)) plus (3).
    set udg_TempInteger=(CountPlayersInForceBJ(udg_DuelArenaPlayers)+3)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_TempInteger
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Result 1: loop counter A treated as a decimal-capable number.
        // Result 2: udg_TempInteger treated as a decimal-capable number.
        // Result 3: (360) divided by (result 2).
        // Result 4: (result 1) times (result 3).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,90.,(I2R(GetForLoopIndexA())*(360./ I2R(udg_TempInteger))))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
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
    set udg_TempPoint=GetUnitLoc(Player_GetHero(GetEnumPlayer()))
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroOnPlayer())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
endfunction

function Trig_Spell_Satellite_Beam_InGroup_Actions takes nothing returns nothing
    set udg_TempPoint2=GetRectCenter(gg_rct_499)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_499)
    set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,350.,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroRand1())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    set udg_TempPoint2=GetRectCenter(gg_rct_499)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_499)
    set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,350.,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call CreateNUnitsAtLoc(1,'u01R',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u01R': unit "Satellite Beam"
    call RemoveLocation(udg_TempPoint2)
    if(Trig_Spell_Satellite_Beam_InGroup_IsCasterHeroRand2())then
        call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
    else
        call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
    endif
    call UnitApplyTimedLifeBJ(3.5,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call ForForce(udg_CupArenaPlayers,function Trig_Spell_Satellite_Beam_InGroup_BeamAtPlayerHero)
    // (CountPlayersInForceBJ(udg_CupArenaPlayers)) plus (2).
    set udg_TempInteger=(CountPlayersInForceBJ(udg_CupArenaPlayers)+2)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_TempInteger
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Result 1: loop counter A treated as a decimal-capable number.
        // Result 2: udg_TempInteger treated as a decimal-capable number.
        // Result 3: (360) divided by (result 2).
        // Result 4: (result 1) times (result 3).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,90.,(I2R(GetForLoopIndexA())*(360./ I2R(udg_TempInteger))))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\Flare\\FlareCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
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

library TAnimal
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Animal_Companion=null
endglobals

function Trig_Animal_Companion_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A14H') // 'A14H': ability "Animal Companion"
endfunction

function Trig_Animal_Companion_HasCompanion takes nothing returns boolean
    return(udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]!=null)
endfunction

function Trig_Animal_Companion_Actions takes nothing returns nothing
    local location l_tempPoint
    if(Trig_Animal_Companion_HasCompanion())then
        call UnitApplyTimedLifeBJ(40.,'BTLF',udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) // 'BTLF': object name not found in map data
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,udg_AnimalCompanionUnit[GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())],GetOwningPlayer(GetTriggerUnit()),l_tempPoint,GetUnitFacing(GetTriggerUnit()))
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set udg_PetUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
    call UnitAddAbilityBJ('A14I',GetLastCreatedUnit()) // 'A14I': ability "Summon Poof Death"
    set udg_TempUnit2=GetLastCreatedUnit()
    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Animal automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Animal (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Animal takes nothing returns nothing
endfunction

function Register_Animal_Companion takes nothing returns nothing
    set gg_trg_Animal_Companion=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Animal_Companion,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Animal_Companion,Condition(function Trig_Animal_Companion_Conditions))
    call TriggerAddAction(gg_trg_Animal_Companion,function Trig_Animal_Companion_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Animal takes nothing returns nothing
    call Register_Animal_Companion()
endfunction

endlibrary

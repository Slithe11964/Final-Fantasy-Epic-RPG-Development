library TChainsaw requires TAbil, TProf
function Trig_Chainsaw_Saw_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A19A') // 'A19A': ability "Saw"
endfunction

function Trig_Chainsaw_Saw_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Chainsaw_Saw_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Chainsaw_Saw_IsHero())then
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*2))
        // (udg_TempInteger) plus ((Agility of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*2))
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R000'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A199',GetLastCreatedUnit()) // 'A199': ability "Saw"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Chainsaw automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Chainsaw (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Chainsaw takes nothing returns nothing
endfunction

function Register_Chainsaw_Saw takes nothing returns nothing
    set gg_trg_Chainsaw_Saw=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chainsaw_Saw,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chainsaw_Saw,Condition(function Trig_Chainsaw_Saw_Conditions))
    call TriggerAddAction(gg_trg_Chainsaw_Saw,function Trig_Chainsaw_Saw_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Chainsaw takes nothing returns nothing
    call Register_Chainsaw_Saw()
endfunction

endlibrary

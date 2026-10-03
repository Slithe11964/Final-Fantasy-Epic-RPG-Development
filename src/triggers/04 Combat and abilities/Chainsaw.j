library TChainsaw requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chainsaw_Saw=null
endglobals

function Trig_Chainsaw_Saw_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A19A') // 'A19A': ability "Saw"
endfunction

function Trig_Chainsaw_Saw_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Chainsaw_Saw_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Chainsaw_Saw_IsHero())then
        // (l_tempInteger) plus ((Strength of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*2))
        // (l_tempInteger) plus ((Agility of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*2))
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R000'))).
    set l_tempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A199',GetLastCreatedUnit()) // 'A199': ability "Saw"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
    set l_tempPoint=null
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

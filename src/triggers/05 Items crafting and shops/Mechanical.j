library TMechanical requires TAbil, TProf
function Trig_Mechanical_Drill_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1D9') // 'A1D9': ability "Drill"
endfunction

function Trig_Mechanical_Drill_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Mechanical_Drill_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Mechanical_Drill_IsHero())then
        // (udg_TempInteger) plus (Strength of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Agility of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true))
        // (udg_TempInteger) plus (Intelligence of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R000'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R000')) // $A = 10; 'R000': upgrade "Tools"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(1,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(3.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A1DA',GetLastCreatedUnit()) // 'A1DA': ability "Drill"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"acidbomb",GetSpellTargetUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Mechanical takes nothing returns nothing
endfunction

function RegisterR11_Mechanical_Drill takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Mechanical_Drill=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Mechanical_Drill,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Mechanical_Drill,Condition(function Trig_Mechanical_Drill_Conditions))

call TriggerAddAction(gg_trg_Mechanical_Drill,function Trig_Mechanical_Drill_Actions)

endfunction




endlibrary

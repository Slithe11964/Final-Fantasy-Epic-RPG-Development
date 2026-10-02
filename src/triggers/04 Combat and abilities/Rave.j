library TRave requires TAbil, TUnit
function Trig_Rave_Kick_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QO') // 'A0QO': ability "Rave Kick"
endfunction

function Trig_Rave_Kick_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Rave_Kick_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Rave_Kick_TargetNotDisabled takes nothing returns boolean
    return(UnitHasBuffBJ(GetSpellTargetUnit(),'B08E')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'B03R')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'B08I')==false)and(UnitHasBuffBJ(GetSpellTargetUnit(),'BPSE')==false) // 'B08E': buff tooltip "Daze"; 'B03R': buff tooltip "Stunned"; 'B08I': buff tooltip "Stunned"; 'BPSE': buff tooltip "Stunned"
endfunction

function Trig_Rave_Kick_IsCritical takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Rave_Kick_HasHighProficiency takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A136',GetTriggerUnit())>0) // 'A136': ability "High Proficiency"
endfunction

function Trig_Rave_Kick_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Rave_Kick_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Rave_Kick_IsHero())then
        // (udg_TempInteger) plus ((Strength of the triggering unit) times (10)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*$A)) // $A = 10
    endif
    set udg_TempBoolean=Unit_HasNoEquipment(GetTriggerUnit())
    if(Trig_Rave_Kick_IsCritical())then
        if(Trig_Rave_Kick_TargetNotDisabled())then
            // (udg_TempInteger) times (2).
            set udg_TempInteger=(udg_TempInteger*2)
        else
            // (udg_TempInteger) times (3).
            set udg_TempInteger=(udg_TempInteger*3)
        endif
    endif
    if(Trig_Rave_Kick_HasHighProficiency())then
        // ((udg_TempInteger) times (5)) divided by (3); drop the remainder.
        set udg_TempInteger=((udg_TempInteger*5)/ 3)
    endif
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(udg_TempInteger),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M5',GetLastCreatedUnit()) // 'A0M5': ability "Earth-elemental Damage"
    call UnitAddAbilityBJ('A0QP',GetLastCreatedUnit()) // 'A0QP': ability "Rave Kick"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"shockwave",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Rave takes nothing returns nothing
endfunction

function RegisterR11_Rave_Kick takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Rave_Kick=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Rave_Kick,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Rave_Kick,Condition(function Trig_Rave_Kick_Conditions))

call TriggerAddAction(gg_trg_Rave_Kick,function Trig_Rave_Kick_Actions)

endfunction




endlibrary

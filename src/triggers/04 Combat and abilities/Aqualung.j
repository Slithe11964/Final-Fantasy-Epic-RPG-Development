library TAqualung requires TAbil, TProf
function Trig_Aqualung_Cast_IsAqualungAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AB')or(GetSpellAbilityId()=='A0SN')or(GetSpellAbilityId()=='A0WB') // 'A1AB': ability "Aqualung"; 'A0SN': ability "Aqualung"; 'A0WB': ability "Aqualung"
endfunction

function Trig_Aqualung_Cast_Conditions takes nothing returns boolean
    return(Trig_Aqualung_Cast_IsAqualungAbility())
endfunction

function Trig_Aqualung_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Aqualung_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Aqualung_Cast_Actions takes nothing returns nothing
    if(Trig_Aqualung_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId())))
    if(Trig_Aqualung_Cast_IsCasterHero())then
        // (udg_TempInteger) plus (Intelligence of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M4',GetLastCreatedUnit()) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0C5',GetLastCreatedUnit()) // 'A0C5': ability "Aqualung"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Aqualung takes nothing returns nothing
endfunction
function RegisterR11_Aqualung_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Aqualung_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Aqualung_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Aqualung_Cast,Condition(function Trig_Aqualung_Cast_Conditions))
    call TriggerAddAction(gg_trg_Aqualung_Cast,function Trig_Aqualung_Cast_Actions)
endfunction




endlibrary

library TGust requires TAbil, TProf
function Trig_Gust_Cast_IsGustAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AD')or(GetSpellAbilityId()=='A044')or(GetSpellAbilityId()=='A1FG') // 'A1AD': ability "Gust"; 'A044': ability "Gust"; 'A1FG': ability "Gust"
endfunction

function Trig_Gust_Cast_Conditions takes nothing returns boolean
    return(Trig_Gust_Cast_IsGustAbility())
endfunction

function Trig_Gust_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Gust_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Gust_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Gust_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (6).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*6)
    if(Trig_Gust_Cast_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (5)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*5))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M6',GetLastCreatedUnit()) // 'A0M6': ability "Wind-elemental Damage"
    call UnitAddAbilityBJ('A1AC',GetLastCreatedUnit()) // 'A1AC': ability "Gust"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"firebolt",GetSpellTargetUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Gust takes nothing returns nothing
endfunction
function RegisterR11_Gust_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Gust_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gust_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Gust_Cast,Condition(function Trig_Gust_Cast_Conditions))
    call TriggerAddAction(gg_trg_Gust_Cast,function Trig_Gust_Cast_Actions)
endfunction




endlibrary

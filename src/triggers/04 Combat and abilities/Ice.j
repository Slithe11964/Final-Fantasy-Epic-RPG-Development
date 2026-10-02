library TIce requires TAbil, TProf
function Trig_Ice_Cast_IsIce takes nothing returns boolean
    return(GetSpellAbilityId()=='A0Q7')or(GetSpellAbilityId()=='A0Q9')or(GetSpellAbilityId()=='A19Q')or(GetSpellAbilityId()=='A0JD')or(GetSpellAbilityId()=='A0U8')or(GetSpellAbilityId()=='A142')or(GetSpellAbilityId()=='A0IO')or(GetSpellAbilityId()=='A0UT')or(GetSpellAbilityId()=='A0BG') // 'A0Q7': ability "Ice"; 'A0Q9': ability "Ice"; 'A19Q': ability "Ice"; 'A0JD': ability "Elementa"; 'A0U8': ability "Elementa"; 'A142': ability "Elementa"; 'A0IO': ability "Ice"; 'A0UT': ability "Ice"; 'A0BG': ability "Ice"
endfunction

function Trig_Ice_Cast_Conditions takes nothing returns boolean
    return(Trig_Ice_Cast_IsIce())
endfunction

function Trig_Ice_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Ice_Cast_IsElementa takes nothing returns boolean
    return(GetSpellAbilityId()=='A0JD')or(GetSpellAbilityId()=='A0U8') // 'A0JD': ability "Elementa"; 'A0U8': ability "Elementa"
endfunction

function Trig_Ice_Cast_IsElementaCast takes nothing returns boolean
    return(Trig_Ice_Cast_IsElementa())
endfunction

function Trig_Ice_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Ice_Cast_Actions takes nothing returns nothing
    if(Trig_Ice_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (3).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Ice_Cast_IsElementaCast())then
        // (udg_TempInteger) divided by (2); drop the remainder.
        set udg_TempInteger=(udg_TempInteger/ 2)
    endif
    if(Trig_Ice_Cast_IsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (4)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*4))
    endif
    set udg_TempReal=Prof_RodPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M2',GetLastCreatedUnit()) // 'A0M2': ability "Ice-elemental Damage"
    call UnitAddAbilityBJ('A0Q8',GetLastCreatedUnit()) // 'A0Q8': ability "Ice"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostnova",GetSpellTargetUnit())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ice takes nothing returns nothing
endfunction
function RegisterR11_Ice_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ice_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ice_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ice_Cast,Condition(function Trig_Ice_Cast_Conditions))
    call TriggerAddAction(gg_trg_Ice_Cast,function Trig_Ice_Cast_Actions)
endfunction




endlibrary

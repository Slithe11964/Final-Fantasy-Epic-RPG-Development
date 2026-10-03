library TIce requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Ice_Cast=null
endglobals

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
    local integer l_tempHandleId
    local integer l_tempInteger
    local real l_tempReal
    if(Trig_Ice_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*3)
    if(Trig_Ice_Cast_IsElementaCast())then
        set l_tempInteger=(l_tempInteger/ 2)
    endif
    if(Trig_Ice_Cast_IsHero())then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*4))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M2',GetLastCreatedUnit()) // 'A0M2': ability "Ice-elemental Damage"
    call UnitAddAbilityBJ('A0Q8',GetLastCreatedUnit()) // 'A0Q8': ability "Ice"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"frostnova",GetSpellTargetUnit())
endfunction

// World Editor calls InitTrig_Ice automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Ice (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Ice takes nothing returns nothing
endfunction

function Register_Ice_Cast takes nothing returns nothing
    set gg_trg_Ice_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Ice_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Ice_Cast,Condition(function Trig_Ice_Cast_Conditions))
    call TriggerAddAction(gg_trg_Ice_Cast,function Trig_Ice_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Ice takes nothing returns nothing
    call Register_Ice_Cast()
endfunction

endlibrary

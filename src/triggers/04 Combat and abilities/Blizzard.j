library TBlizzard requires TAbil, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Blizzard_Cast=null
endglobals

function Trig_Blizzard_Cast_IsBlizzardAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A1AF')or(GetSpellAbilityId()=='A1AU') // 'A1AF': ability "Blizzard"; 'A1AU': ability "Blizzard"
endfunction

function Trig_Blizzard_Cast_Conditions takes nothing returns boolean
    return(Trig_Blizzard_Cast_IsBlizzardAbility())
endfunction

function Trig_Blizzard_Cast_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Blizzard_Cast_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Blizzard_Cast_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local real l_tempReal
    if(Trig_Blizzard_Cast_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // Start the base amount at 2 times the spell's mana cost.
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Blizzard_Cast_IsCasterHero())then
        // For a hero, add 2 times Intelligence to that base.
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    set l_tempReal=Prof_RodPower(GetTriggerUnit())
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(10.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M2',GetLastCreatedUnit()) // 'A0M2': ability "Ice-elemental Damage"
    call UnitAddAbilityBJ('A1AE',GetLastCreatedUnit()) // 'A1AE': editor label "Blizzard"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// World Editor calls InitTrig_Blizzard automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Blizzard (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Blizzard takes nothing returns nothing
endfunction

function Register_Blizzard_Cast takes nothing returns nothing
    set gg_trg_Blizzard_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Blizzard_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Blizzard_Cast,Condition(function Trig_Blizzard_Cast_Conditions))
    call TriggerAddAction(gg_trg_Blizzard_Cast,function Trig_Blizzard_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Blizzard takes nothing returns nothing
    call Register_Blizzard_Cast()
endfunction

endlibrary

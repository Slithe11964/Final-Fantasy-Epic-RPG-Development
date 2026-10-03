library TBahamut requires TAbil, TLoc, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Bahamut_MegaFlare=null
endglobals

function Trig_Bahamut_MegaFlare_IsCastAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A13M')or(GetSpellAbilityId()=='A13X')or(GetSpellAbilityId()=='A13Y') // 'A13M': ability "!Mega Flare"; 'A13X': ability "!Giga Flare"; 'A13Y': ability "!Tera Flare"
endfunction

function Trig_Bahamut_MegaFlare_Conditions takes nothing returns boolean
    return(Trig_Bahamut_MegaFlare_IsCastAbility())
endfunction

function Trig_Bahamut_MegaFlare_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Bahamut_MegaFlare_UsesFirstWeapon takes nothing returns boolean
    return(udg_AbilityLevelShift)
endfunction

function Trig_Bahamut_MegaFlare_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Bahamut_MegaFlare_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local real l_tempReal
    if(Trig_Bahamut_MegaFlare_HasNoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=16
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,160.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,320.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Bahamut_MegaFlare_CasterIsHero())then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*5))
    else
        if(Trig_Bahamut_MegaFlare_UsesFirstWeapon())then
            set l_tempInteger=(l_tempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),0)*4))
        else
            set l_tempInteger=(l_tempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),1)*4))
        endif
    endif
    set l_tempReal=Prof_InnerManaPower(GetTriggerUnit())
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13N',GetLastCreatedUnit()) // 'A13N': ability "Bahamut Flare"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"stomp")
endfunction

// World Editor calls InitTrig_Bahamut automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Bahamut (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Bahamut takes nothing returns nothing
endfunction

function Register_Bahamut_MegaFlare takes nothing returns nothing
    set gg_trg_Bahamut_MegaFlare=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bahamut_MegaFlare,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Bahamut_MegaFlare,Condition(function Trig_Bahamut_MegaFlare_Conditions))
    call TriggerAddAction(gg_trg_Bahamut_MegaFlare,function Trig_Bahamut_MegaFlare_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Bahamut takes nothing returns nothing
    call Register_Bahamut_MegaFlare()
endfunction

endlibrary

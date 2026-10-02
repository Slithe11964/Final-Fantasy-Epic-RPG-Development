library TBahamut requires TAbil, TLoc, TProf
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
        // (22.5) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,160.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),2.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        // (22.5) times (loop counter A treated as a decimal-capable number).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,320.,(22.5*I2R(GetForLoopIndexA())))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call RemoveLocation(udg_TempPoint2)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (4).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*4)
    if(Trig_Bahamut_MegaFlare_CasterIsHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) times (5)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*5))
    else
        if(Trig_Bahamut_MegaFlare_UsesFirstWeapon())then
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 0)) times (4)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),0)*4))
        else
            // (udg_TempInteger) plus ((BlzGetUnitBaseDamage(the triggering unit, 1)) times (4)).
            set udg_TempInteger=(udg_TempInteger+(BlzGetUnitBaseDamage(GetTriggerUnit(),1)*4))
        endif
    endif
    set udg_TempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A13N',GetLastCreatedUnit()) // 'A13N': ability "Bahamut Flare"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"stomp")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Bahamut takes nothing returns nothing
endfunction
function RegisterR11_Bahamut_MegaFlare takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Bahamut_MegaFlare=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bahamut_MegaFlare,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Bahamut_MegaFlare,Condition(function Trig_Bahamut_MegaFlare_Conditions))
    call TriggerAddAction(gg_trg_Bahamut_MegaFlare,function Trig_Bahamut_MegaFlare_Actions)
endfunction




endlibrary

library THolySwordsman requires TAbil, TGroup, TProf
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HolySwordsman_Eclipse=null
    trigger gg_trg_HolySwordsman_Finisher=null
endglobals

function Trig_HolySwordsman_Eclipse_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QJ') // 'A0QJ': ability "Eclipse"
endfunction

function Trig_HolySwordsman_Eclipse_HasNoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_HolySwordsman_Eclipse_CasterIsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_HolySwordsman_Eclipse_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    if(Trig_HolySwordsman_Eclipse_HasNoTargetUnit())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),l_tempPoint,0)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_HolySwordsman_Eclipse_CasterIsHero())then
        // (l_tempInteger) plus ((Strength of the triggering unit) times (5)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*5))
        // (l_tempInteger) plus ((Intelligence of the triggering unit) times (2)).
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)*2))
    endif
    // (0.1) times ((10) plus (Prof_GetHybridLevel(the triggering unit))).
    set l_tempReal=.1*($A+Prof_GetHybridLevel(GetTriggerUnit())) // $A = 10
    // (l_tempInteger treated as a decimal-capable number) times (l_tempReal).
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(7,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M2',GetLastCreatedUnit()) // 'A0M2': ability "Ice-elemental Damage"
    call UnitAddAbilityBJ('A04N',GetLastCreatedUnit()) // 'A04N': ability "Eclipse"
    call SetUnitAbilityLevelSwapped('A04N',GetLastCreatedUnit(),GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())) // 'A04N': ability "Eclipse"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"impale",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_HolySwordsman_Finisher_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0HN') // 'A0HN': ability "Finisher"
endfunction

function Trig_HolySwordsman_Finisher_HasEnduranceAura takes nothing returns boolean
    return(UnitHasBuffBJ(GetTriggerUnit(),'B018')) // 'B018': buff tooltip "Holy Power"
endfunction

function Trig_HolySwordsman_Finisher_NoElementRecorded takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0PO',GetTriggerUnit())==1) // 'A0PO': ability "Latest Used Element"
endfunction

function Trig_HolySwordsman_Finisher_RollHolyStrike takes nothing returns boolean
    return(udg_TempInteger<=24)
endfunction

function Trig_HolySwordsman_Finisher_FilterIsEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_HolySwordsman_Finisher_FilterIsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_HolySwordsman_Finisher_FilterAliveEnemy takes nothing returns boolean
    return GetBooleanAnd(Trig_HolySwordsman_Finisher_FilterIsEnemy(),Trig_HolySwordsman_Finisher_FilterIsAlive())
endfunction

function Trig_HolySwordsman_Finisher_FilterNotInvulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_HolySwordsman_Finisher_FilterNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_HolySwordsman_Finisher_FilterTargetable takes nothing returns boolean
    return GetBooleanAnd(Trig_HolySwordsman_Finisher_FilterNotInvulnerable(),Trig_HolySwordsman_Finisher_FilterNotStructure())
endfunction

function Trig_HolySwordsman_Finisher_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_HolySwordsman_Finisher_FilterAliveEnemy(),Trig_HolySwordsman_Finisher_FilterTargetable())
endfunction

function Trig_HolySwordsman_Finisher_DamageEnum takes nothing returns nothing
    set udg_IsPhysicalAttack=true
    // Udg_TempInteger treated as a decimal-capable number.
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),I2R(udg_TempInteger),true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_HEAVY_SLICE)
endfunction

function Trig_HolySwordsman_Finisher_RollMightySwipe takes nothing returns boolean
    return(udg_TempInteger<=18)
endfunction

function Trig_HolySwordsman_Finisher_RollFailed takes nothing returns boolean
    return(udg_TempInteger<=$A) // $A = 10
endfunction

function Trig_HolySwordsman_Finisher_Actions takes nothing returns nothing
    if(Trig_HolySwordsman_Finisher_HasEnduranceAura())then
        set udg_TempInteger=20
    else
        // Result 1: (GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)) plus (25).
        // Result 2: a random whole number from GetUnitAbilityLevelSwapped(GetSpellAbilityId(), the triggering unit)
        // through result 1.
        set udg_TempInteger=GetRandomInt(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit()),(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())+25))
    endif
    if(Trig_HolySwordsman_Finisher_RollFailed())then
        call CreateTextTagUnitBJ("Failed...",GetTriggerUnit(),0,$A,'d','d','d',0) // $A = 10
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
    else
        if(Trig_HolySwordsman_Finisher_RollMightySwipe())then
            call CreateTextTagUnitBJ("Mighty Swipe",GetTriggerUnit(),0,$A,'d','d','d',0) // $A = 10
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
            call SetUnitAnimation(GetTriggerUnit(),"attack")
            call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Units\\NightElf\\Wisp\\WispExplode.mdl")
            call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),0,0,$FF) // $FF = 255
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
            set udg_TempGroup=Group_UnitsInRangeOfLoc(300.,udg_TempPoint,Condition(function Trig_HolySwordsman_Finisher_FilterTarget))
            call RemoveLocation(udg_TempPoint)
            // ((Strength of the triggering unit) times (3)) plus (200).
            set udg_TempInteger=((GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*3)+$C8) // $C8 = 200
            // (udg_TempInteger) times ((10) plus (Prof_GetHybridLevel(the triggering unit))).
            set udg_TempInteger=udg_TempInteger*($A+Prof_GetHybridLevel(GetTriggerUnit())) // $A = 10
            call ForGroupBJ(udg_TempGroup,function Trig_HolySwordsman_Finisher_DamageEnum)
            call DestroyGroup(udg_TempGroup)
        else
            if(Trig_HolySwordsman_Finisher_RollHolyStrike())then
                call CreateTextTagUnitBJ("Holy Strike",GetTriggerUnit(),0,$A,'d','d','d',0) // $A = 10
                call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
                call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
                call SetUnitAnimation(GetTriggerUnit(),"attack")
                call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                // ((Strength of the triggering unit) times (2)) plus (50).
                set udg_TempInteger=((GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),true)*2)+50)
                // (udg_TempInteger) times ((10) plus (Prof_GetHybridLevel(the triggering unit))).
                set udg_TempInteger=udg_TempInteger*($A+Prof_GetHybridLevel(GetTriggerUnit())) // $A = 10
                set udg_IsPhysicalAttack=true
                set udg_IgnoresReduction=true
                // Udg_TempInteger treated as a decimal-capable number.
                call UnitDamageTarget(GetTriggerUnit(),GetSpellTargetUnit(),I2R(udg_TempInteger),true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_HEAVY_SLICE)
            else
                if(Trig_HolySwordsman_Finisher_NoElementRecorded())then
                    call CreateTextTagUnitBJ("Failed...",GetTriggerUnit(),0,$A,'d','d','d',0) // $A = 10
                    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
                    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
                else
                    call CreateTextTagUnitBJ("Elemental Quartet",GetTriggerUnit(),0,$A,'d','d','d',0) // $A = 10
                    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
                    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),2.)
                    call SetUnitAnimation(GetTriggerUnit(),"attack")
                    set udg_DmgFlagPure=true
                    // (GetUnitAbilityLevelSwapped('A0PO', the triggering unit)) minus (1).
                    set udg_DamageElement=(GetUnitAbilityLevelSwapped('A0PO',GetTriggerUnit())-1) // 'A0PO': ability "Latest Used Element"
                    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),udg_EffectModelPath[udg_DamageElement])
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    call UnitDamageTarget(GetTriggerUnit(),GetSpellTargetUnit(),9999.,true,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_METAL_HEAVY_SLICE)
                endif
            endif
        endif
    endif
endfunction

// World Editor calls InitTrig_HolySwordsman automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HolySwordsman (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HolySwordsman takes nothing returns nothing
endfunction

function Register_HolySwordsman_Eclipse takes nothing returns nothing
    set gg_trg_HolySwordsman_Eclipse=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HolySwordsman_Eclipse,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_HolySwordsman_Eclipse,Condition(function Trig_HolySwordsman_Eclipse_Conditions))
    call TriggerAddAction(gg_trg_HolySwordsman_Eclipse,function Trig_HolySwordsman_Eclipse_Actions)
endfunction

function Register_HolySwordsman_Finisher takes nothing returns nothing
    set gg_trg_HolySwordsman_Finisher=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HolySwordsman_Finisher,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_HolySwordsman_Finisher,Condition(function Trig_HolySwordsman_Finisher_Conditions))
    call TriggerAddAction(gg_trg_HolySwordsman_Finisher,function Trig_HolySwordsman_Finisher_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HolySwordsman takes nothing returns nothing
    call Register_HolySwordsman_Eclipse()
    call Register_HolySwordsman_Finisher() // used by Unused
endfunction

endlibrary

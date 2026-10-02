library TSpellDemi requires TAbil, TProf
function Trig_Spell_Demi_IsDemiSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A0BV')or(GetSpellAbilityId()=='A0BT')or(GetSpellAbilityId()=='A0BU')or(GetSpellAbilityId()=='A1C4') // 'A0BV': ability "Demi"; 'A0BT': ability "Demira"; 'A0BU': ability "Demiga"; 'A1C4': ability "Demi"
endfunction

function Trig_Spell_Demi_Conditions takes nothing returns boolean
    return(Trig_Spell_Demi_IsDemiSpell())
endfunction

function Trig_Spell_Demi_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Demi_IsTargetHero takes nothing returns boolean
    return(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Demi_IsTargetPlainUnit takes nothing returns boolean
    return((IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_RESISTANT)==false)and(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO)==false))!=null
endfunction

function Trig_Spell_Demi_HasOversoul takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A134',GetSpellTargetUnit())>0) // 'A134': ability "Oversoul"
endfunction

function Trig_Spell_Demi_IsOverCap takes nothing returns boolean
    return(udg_TempInteger>$3E8) // $3E8 = 1000
endfunction

function Trig_Spell_Demi_IsDamagePositive takes nothing returns boolean
    return(udg_TempInteger>0)
endfunction

function Trig_Spell_Demi_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetSpellTargetUnit(),"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // Result 1: (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit,
    // GetSpellAbilityId()))) divided by (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))/ 2)
    if(Trig_Spell_Demi_IsCasterHero())then
        // (udg_TempInteger) plus ((Intelligence of the triggering unit) divided by (4); drop the remainder).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 4))
    endif
    if(Trig_Spell_Demi_IsTargetHero())then
        // (udg_TempInteger) minus ((Intelligence of the spell target) divided by (8); drop the remainder).
        set udg_TempInteger=(udg_TempInteger-(GetHeroStatBJ(bj_HEROSTAT_INT,GetSpellTargetUnit(),true)/ 8))
    else
        // (udg_TempInteger) minus (unit level of the spell target).
        set udg_TempInteger=(udg_TempInteger-GetUnitLevel(GetSpellTargetUnit()))
    endif
    // Result 1: (maximum mana of the spell target) times (0.1).
    // Result 2: the square root of (result 1).
    // Result 3: (result 2) with its decimal part removed.
    // Result 4: (udg_TempInteger) minus (result 3).
    set udg_TempInteger=(udg_TempInteger-R2I(SquareRoot((GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetSpellTargetUnit())*.1))))
    if(Trig_Spell_Demi_IsDamagePositive())then
        set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
        // ((udg_TempInteger treated as a decimal-capable number) times (udg_TempReal)) with its decimal part removed.
        set udg_TempInteger=R2I((I2R(udg_TempInteger)*udg_TempReal))
        if(Trig_Spell_Demi_HasOversoul())then
            // (udg_TempInteger) divided by (2); drop the remainder.
            set udg_TempInteger=(udg_TempInteger/ 2)
        else
            if(Trig_Spell_Demi_IsTargetPlainUnit())then
                // (udg_TempInteger) times (2).
                set udg_TempInteger=(udg_TempInteger*2)
            endif
        endif
        if(Trig_Spell_Demi_IsOverCap())then
            set udg_TempInteger=$3E8 // $3E8 = 1000
        endif
        call UnitRemoveBuffBJ('B03A',GetSpellTargetUnit()) // 'B03A': buff tooltip "Sleep"
        call UnitRemoveBuffBJ('B03B',GetSpellTargetUnit()) // 'B03B': buff "Sleep (Pause)"
        call UnitRemoveBuffBJ('B03C',GetSpellTargetUnit()) // 'B03C': buff "Sleep (Stunned)"
        set udg_DmgFlagPure=true
        // Result 1: udg_TempInteger treated as a decimal-capable number.
        // Result 2: (result 1) divided by (1000).
        // Result 3: (result 2) times (current health of the spell target).
        // Result 4: (result 3) minus (1).
        call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),(((I2R(udg_TempInteger)/ 1000.)*GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit()))-1.),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL)
    endif
endfunction

function InitTrig_Spell_Demi takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Demi takes nothing returns nothing
    set gg_trg_Spell_Demi=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Demi,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Demi,Condition(function Trig_Spell_Demi_Conditions))
    call TriggerAddAction(gg_trg_Spell_Demi,function Trig_Spell_Demi_Actions)
endfunction

endlibrary

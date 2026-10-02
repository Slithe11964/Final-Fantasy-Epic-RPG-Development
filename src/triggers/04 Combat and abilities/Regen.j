library TRegen requires TProf
function Trig_Regen_Cast_IsRegen takes nothing returns boolean
    return(GetSpellAbilityId()=='A00L')or(GetSpellAbilityId()=='A0B6')or(GetSpellAbilityId()=='A1F4')or(GetSpellAbilityId()=='A0FW') // 'A00L': ability "Regen"; 'A0B6': ability "Regen"; 'A1F4': ability "Regen"; 'A0FW': ability "Regen"
endfunction

function Trig_Regen_Cast_Conditions takes nothing returns boolean
    return(Trig_Regen_Cast_IsRegen())
endfunction

function Trig_Regen_Cast_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Regen_Cast_Actions takes nothing returns nothing
    set udg_TempInteger=25
    if(Trig_Regen_Cast_IsHero())then
        // Add 1 point for each complete group of 3 Intelligence; leftover points do not count.
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true)/ 3))
    else
        // (udg_TempInteger) plus (unit level of the triggering unit).
        set udg_TempInteger=(udg_TempInteger+GetUnitLevel(GetTriggerUnit()))
    endif
    set udg_TempReal=Prof_StaffPower(GetTriggerUnit())
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,GetHandleIdBJ(GetSpellTargetUnit()),udg_HealOverTimeHash)
    call GroupAddUnitSimple(GetSpellTargetUnit(),udg_RegenGroup)
endfunction

function Trig_Regen_Periodic_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)and(IsUnitGroupEmptyBJ(udg_RegenGroup)==false)
endfunction

function Trig_Regen_Periodic_IsEnumHero takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Regen_Periodic_IsHostileOwned takes nothing returns boolean
    return(GetOwningPlayer(GetEnumUnit())==Player($B)) // $B = 11
endfunction

function Trig_Regen_Periodic_HasNegateHeals takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())>0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Regen_Periodic_HasRegenBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B006')) // 'B006': buff "Regen"
endfunction

function Trig_Regen_Periodic_LacksClarityBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B01A')==false) // 'B01A': buff tooltip "Mana Spring"
endfunction

function Trig_Regen_Periodic_HasStoredRegen takes nothing returns boolean
    return(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)>.0)
endfunction

function Trig_Regen_Periodic_HasRegenAmount takes nothing returns boolean
    return(udg_TempReal>.0)
endfunction

function Trig_Regen_Periodic_LacksNegateHeals takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0Z8',GetEnumUnit())<=0) // 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Regen_Periodic_IsAlreadyQueued takes nothing returns boolean
    return(IsUnitInGroup(GetEnumUnit(),udg_PendingEffectGroup))
endfunction

function Trig_Regen_Periodic_HasClarityBuff takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B01A')) // 'B01A': buff tooltip "Mana Spring"
endfunction

function Trig_Regen_Periodic_IsNotPaused takes nothing returns boolean
    return(IsUnitPausedBJ(GetEnumUnit())==false)
endfunction

function Trig_Regen_Periodic_RegenUnit takes nothing returns nothing
    if(Trig_Regen_Periodic_IsNotPaused())then
        set udg_TempReal=.0
        if(Trig_Regen_Periodic_HasRegenBuff())then
            if(Trig_Regen_Periodic_HasNegateHeals())then
                call AddSpecialEffectTargetUnitBJ("overhead",GetEnumUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call UnitRemoveBuffBJ('B006',GetEnumUnit()) // 'B006': buff "Regen"
            else
                // (udg_TempReal) plus (LoadRealBJ(1, GetHandleIdBJ(the unit being visited), udg_HealOverTimeHash)).
                set udg_TempReal=(udg_TempReal+LoadRealBJ(1,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash))
                if(Trig_Regen_Periodic_IsEnumHero())then
                    // Heroes add one quarter of their Strength to this regeneration amount.
                    set udg_TempReal=(udg_TempReal+(I2R(GetHeroStatBJ(bj_HEROSTAT_STR,GetEnumUnit(),true))*.25))
                else
                    // Non-heroes add 2 points per unit level instead.
                    set udg_TempReal=(udg_TempReal+(I2R(GetUnitLevel(GetEnumUnit()))*2.))
                endif
                if(Trig_Regen_Periodic_IsHostileOwned())then
                    // For this hostile-owned unit, increase the current amount by 80%: 10 becomes 18.
                    set udg_TempReal=(udg_TempReal*1.8)
                endif
            endif
        endif
        if(Trig_Regen_Periodic_LacksNegateHeals())then
            if(Trig_Regen_Periodic_HasStoredRegen())then
                // ((udg_TempReal) plus (1)) plus (LoadRealBJ(2, GetHandleIdBJ(the unit being visited), udg_HealOverTimeHash)).
                set udg_TempReal=((udg_TempReal+1)+LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash))
                if(Trig_Regen_Periodic_LacksClarityBuff())then
                    set udg_DmgFlagManaDamage=true
                    set udg_IsPureDamage=true
                    set udg_DmgFlagPure=true
                    // Result 1: a random decimal number between 15 and 16.
                    // Result 2: (result 1) divided by (64).
                    // Result 3: (LoadRealBJ(2, GetHandleIdBJ(the unit being visited), udg_HealOverTimeHash)) times (result 2).
                    call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)*(GetRandomReal(15.,16.)/ 64.)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                endif
            endif
            if(Trig_Regen_Periodic_HasRegenAmount())then
                set udg_IsPureDamage=true
                set udg_DmgFlagPure=true
                // (udg_TempReal) times ((a random decimal number between 15 and 16) divided by (16)).
                call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),(udg_TempReal*(GetRandomReal(15.,16.)/ 16.)),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            else
                call GroupAddUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
            endif
        else
            call GroupAddUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
        endif
        if(Trig_Regen_Periodic_HasClarityBuff())then
            set udg_IsPureDamage=true
            set udg_DmgFlagPure=true
            set udg_DmgFlagManaDamage=true
            if(Trig_Regen_Periodic_IsAlreadyQueued())then
                // (maximum mana of the unit being visited) times (0.1).
                call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetEnumUnit())*.1),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
                call GroupRemoveUnitSimple(GetEnumUnit(),udg_PendingEffectGroup)
            else
                // Result 1: (maximum mana of the unit being visited) times (0.1).
                // Result 2: (LoadRealBJ(2, GetHandleIdBJ(the unit being visited), udg_HealOverTimeHash)) plus (1).
                // Result 3: a random decimal number between 15 and 16.
                // Result 4: (result 3) divided by (64).
                // Result 5: (result 2) times (result 4).
                // Result 6: (result 1) plus (result 5).
                call UnitDamageTargetBJ(GetEnumUnit(),GetEnumUnit(),((GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetEnumUnit())*.1)+((LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)+1)*(GetRandomReal(15.,16.)/ 64.))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL)
            endif
        endif
        call SaveRealBJ(-1.,2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)
    endif
endfunction

function Trig_Regen_Periodic_Actions takes nothing returns nothing
    call GroupClear(udg_PendingEffectGroup)
    call ForGroupBJ(udg_RegenGroup,function Trig_Regen_Periodic_RegenUnit)
    call GroupRemoveGroup(udg_PendingEffectGroup,udg_RegenGroup)
    call GroupClear(udg_PendingEffectGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Regen takes nothing returns nothing
endfunction
function RegisterR11_Regen_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Regen_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Regen_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Regen_Cast,Condition(function Trig_Regen_Cast_Conditions))
    call TriggerAddAction(gg_trg_Regen_Cast,function Trig_Regen_Cast_Actions)
endfunction
function RegisterR11_Regen_Periodic takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Regen_Periodic=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Regen_Periodic,1.)
    call TriggerAddCondition(gg_trg_Regen_Periodic,Condition(function Trig_Regen_Periodic_Conditions))
    call TriggerAddAction(gg_trg_Regen_Periodic,function Trig_Regen_Periodic_Actions)
endfunction




endlibrary

library TChocoboUpgrades requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chocobo_Gysahl_Upgrade=null
    trigger gg_trg_Chocobo_Mimett_Upgrade=null
    trigger gg_trg_Chocobo_Silkis_Upgrade=null
    trigger gg_trg_Chocobo_Defend_Upgrade=null
endglobals

function Trig_Chocobo_Gysahl_Upgrade_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A15X')and(GetUnitName(GetSpellTargetUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==GetOwningPlayer(GetSpellTargetUnit())) // 'A15X': ability "Gysahl Greens"
endfunction

function Trig_Chocobo_Gysahl_Upgrade_HasAbilityAtIndex takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())>=1)
endfunction

function Trig_Chocobo_Gysahl_Upgrade_IsBaseChocoboType takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n02J')or(GetUnitTypeId(GetSpellTargetUnit())=='n02S')or(GetUnitTypeId(GetSpellTargetUnit())=='n02T')or(GetUnitTypeId(GetSpellTargetUnit())=='n02U')or(GetUnitTypeId(GetSpellTargetUnit())=='n035') // 'n02J': unit "Chocobo"; 'n02S': unit "Chocobo"; 'n02T': unit "Chocobo"; 'n02U': unit "Chocobo"; 'n035': unit "Chocobo"
endfunction

function Trig_Chocobo_Gysahl_Upgrade_HasAbility takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>0)
endfunction

function Trig_Chocobo_Gysahl_Upgrade_AbilityNotQuickJoin takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=3)
endfunction

function Trig_Chocobo_Gysahl_Upgrade_AbilityNotSprint takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=5)
endfunction

function Trig_Chocobo_Gysahl_Upgrade_AbilityNotAttack takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=$F) // $F = 15
endfunction

function Trig_Chocobo_Gysahl_Upgrade_IsUpgradeable takes nothing returns boolean
    return(Trig_Chocobo_Gysahl_Upgrade_IsBaseChocoboType())
endfunction

function Trig_Chocobo_Gysahl_Upgrade_Actions takes nothing returns nothing
    set udg_ChocoboGreensFed=true
    set udg_ChocoboAbilityIndex=0
    set bj_forLoopBIndex=3
    set bj_forLoopBIndexEnd=$F // $F = 15
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        if(Trig_Chocobo_Gysahl_Upgrade_HasAbilityAtIndex())then
            set udg_ChocoboAbilityIndex=GetForLoopIndexB()
        endif
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    if(Trig_Chocobo_Gysahl_Upgrade_IsUpgradeable())then
        call UnitRemoveAbilityBJ('S005',GetSpellTargetUnit()) // 'S005': ability "Chocobo Ride"
        call ReplaceUnitBJ(GetSpellTargetUnit(),'n036',bj_UNIT_STATE_METHOD_RELATIVE) // 'n036': unit "Chocobo"
        if(Trig_Chocobo_Gysahl_Upgrade_HasAbility())then
            call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ())
        endif
        if(Trig_Chocobo_Gysahl_Upgrade_AbilityNotQuickJoin())then
            call UnitAddAbilityBJ('A04F',GetLastReplacedUnitBJ()) // 'A04F': ability "Join Fast"
        endif
        if(Trig_Chocobo_Gysahl_Upgrade_AbilityNotSprint())then
            call UnitAddAbilityBJ('A0A4',GetLastReplacedUnitBJ()) // 'A0A4': ability "Chocobo Sprint"
        endif
        if(Trig_Chocobo_Gysahl_Upgrade_AbilityNotAttack())then
            call UnitAddAbilityBJ('Abun',GetLastReplacedUnitBJ()) // 'Abun': object name not found in map data
        endif
        call UnitAddAbilityBJ('S005',GetLastReplacedUnitBJ()) // 'S005': ability "Chocobo Ride"
        call UnitAddAbilityBJ('S006',GetLastReplacedUnitBJ()) // 'S006': ability "Start Chocobo Riding"
        call UnitAddAbilityBJ('S007',GetLastReplacedUnitBJ()) // 'S007': ability "Stop Chocobo Ride"
        call AddSpecialEffectTargetUnitBJ("origin",GetLastReplacedUnitBJ(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

function Trig_Chocobo_Mimett_Upgrade_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A15Y')and(GetUnitName(GetSpellTargetUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==GetOwningPlayer(GetSpellTargetUnit())) // 'A15Y': ability "Mimett Greens"
endfunction

function Trig_Chocobo_Mimett_Upgrade_HasAbilityAtIndex takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())>=1)
endfunction

function Trig_Chocobo_Mimett_Upgrade_IsUpgradeableType takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n02J')or(GetUnitTypeId(GetSpellTargetUnit())=='n02S')or(GetUnitTypeId(GetSpellTargetUnit())=='n02T')or(GetUnitTypeId(GetSpellTargetUnit())=='n02U')or(GetUnitTypeId(GetSpellTargetUnit())=='n035')or(GetUnitTypeId(GetSpellTargetUnit())=='n036') // 'n02J': unit "Chocobo"; 'n02S': unit "Chocobo"; 'n02T': unit "Chocobo"; 'n02U': unit "Chocobo"; 'n035': unit "Chocobo"; 'n036': unit "Chocobo"
endfunction

function Trig_Chocobo_Mimett_Upgrade_HasAbility takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>0)
endfunction

function Trig_Chocobo_Mimett_Upgrade_HasAbilityAgain takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>0)
endfunction

function Trig_Chocobo_Mimett_Upgrade_IsStage1Chocobo takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n036') // 'n036': unit "Chocobo"
endfunction

function Trig_Chocobo_Mimett_Upgrade_AbilityNotQuickJoin takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=3)
endfunction

function Trig_Chocobo_Mimett_Upgrade_AbilityNotSprint takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=5)
endfunction

function Trig_Chocobo_Mimett_Upgrade_AbilityNotAttack takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=$F) // $F = 15
endfunction

function Trig_Chocobo_Mimett_Upgrade_IsUpgradeable takes nothing returns boolean
    return(Trig_Chocobo_Mimett_Upgrade_IsUpgradeableType())
endfunction

function Trig_Chocobo_Mimett_Upgrade_Actions takes nothing returns nothing
    set udg_ChocoboAbilityIndex=0
    set bj_forLoopBIndex=3
    set bj_forLoopBIndexEnd=$F // $F = 15
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        if(Trig_Chocobo_Mimett_Upgrade_HasAbilityAtIndex())then
            set udg_ChocoboAbilityIndex=GetForLoopIndexB()
        endif
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    if(Trig_Chocobo_Mimett_Upgrade_IsUpgradeable())then
        call UnitRemoveAbilityBJ('S005',GetSpellTargetUnit()) // 'S005': ability "Chocobo Ride"
        if(Trig_Chocobo_Mimett_Upgrade_IsStage1Chocobo())then
            call ReplaceUnitBJ(GetSpellTargetUnit(),'n037',bj_UNIT_STATE_METHOD_RELATIVE) // 'n037': unit "Chocobo"
            if(Trig_Chocobo_Mimett_Upgrade_HasAbility())then
                call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ())
                call SetUnitAbilityLevelSwapped(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ(),6)
                call UnitAddAbilityBJ('A0K8',GetLastReplacedUnitBJ()) // 'A0K8': ability "Chocobo Tech Copy"
            endif
        else
            call ReplaceUnitBJ(GetSpellTargetUnit(),'n036',bj_UNIT_STATE_METHOD_RELATIVE) // 'n036': unit "Chocobo"
            if(Trig_Chocobo_Mimett_Upgrade_HasAbilityAgain())then
                call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ())
            endif
        endif
        if(Trig_Chocobo_Mimett_Upgrade_AbilityNotQuickJoin())then
            call UnitAddAbilityBJ('A04F',GetLastReplacedUnitBJ()) // 'A04F': ability "Join Fast"
        endif
        if(Trig_Chocobo_Mimett_Upgrade_AbilityNotSprint())then
            call UnitAddAbilityBJ('A0A4',GetLastReplacedUnitBJ()) // 'A0A4': ability "Chocobo Sprint"
        endif
        if(Trig_Chocobo_Mimett_Upgrade_AbilityNotAttack())then
            call UnitAddAbilityBJ('Abun',GetLastReplacedUnitBJ()) // 'Abun': object name not found in map data
        endif
        call UnitAddAbilityBJ('S005',GetLastReplacedUnitBJ()) // 'S005': ability "Chocobo Ride"
        call UnitAddAbilityBJ('S006',GetLastReplacedUnitBJ()) // 'S006': ability "Start Chocobo Riding"
        call UnitAddAbilityBJ('S007',GetLastReplacedUnitBJ()) // 'S007': ability "Stop Chocobo Ride"
        call AddSpecialEffectTargetUnitBJ("origin",GetLastReplacedUnitBJ(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

function Trig_Chocobo_Silkis_Upgrade_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A15Z')and(GetUnitName(GetSpellTargetUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==GetOwningPlayer(GetSpellTargetUnit())) // 'A15Z': ability "Silkis Greens"
endfunction

function Trig_Chocobo_Silkis_Upgrade_HasAbilityAtIndex takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())>=1)
endfunction

function Trig_Chocobo_Silkis_Upgrade_IsUpgradeableType takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n02J')or(GetUnitTypeId(GetSpellTargetUnit())=='n02S')or(GetUnitTypeId(GetSpellTargetUnit())=='n02T')or(GetUnitTypeId(GetSpellTargetUnit())=='n02U')or(GetUnitTypeId(GetSpellTargetUnit())=='n035')or(GetUnitTypeId(GetSpellTargetUnit())=='n036')or(GetUnitTypeId(GetSpellTargetUnit())=='n037') // 'n02J': unit "Chocobo"; 'n02S': unit "Chocobo"; 'n02T': unit "Chocobo"; 'n02U': unit "Chocobo"; 'n035': unit "Chocobo"; 'n036': unit "Chocobo"; 'n037': unit "Chocobo"
endfunction

function Trig_Chocobo_Silkis_Upgrade_HasAbility takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>0)
endfunction

function Trig_Chocobo_Silkis_Upgrade_HasAbilityAgain takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>0)
endfunction

function Trig_Chocobo_Silkis_Upgrade_HasAbilityThird takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>0)
endfunction

function Trig_Chocobo_Silkis_Upgrade_IsStage1Chocobo takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n036') // 'n036': unit "Chocobo"
endfunction

function Trig_Chocobo_Silkis_Upgrade_IsStage2Chocobo takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n037') // 'n037': unit "Chocobo"
endfunction

function Trig_Chocobo_Silkis_Upgrade_AbilityNotQuickJoin takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=3)
endfunction

function Trig_Chocobo_Silkis_Upgrade_AbilityNotSprint takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=5)
endfunction

function Trig_Chocobo_Silkis_Upgrade_AbilityNotAttack takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=$F) // $F = 15
endfunction

function Trig_Chocobo_Silkis_Upgrade_IsUpgradeable takes nothing returns boolean
    return(Trig_Chocobo_Silkis_Upgrade_IsUpgradeableType())
endfunction

function Trig_Chocobo_Silkis_Upgrade_Actions takes nothing returns nothing
    set udg_ChocoboAbilityIndex=0
    set bj_forLoopBIndex=3
    set bj_forLoopBIndexEnd=$F // $F = 15
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        if(Trig_Chocobo_Silkis_Upgrade_HasAbilityAtIndex())then
            set udg_ChocoboAbilityIndex=GetForLoopIndexB()
        endif
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    if(Trig_Chocobo_Silkis_Upgrade_IsUpgradeable())then
        call UnitRemoveAbilityBJ('S005',GetSpellTargetUnit()) // 'S005': ability "Chocobo Ride"
        if(Trig_Chocobo_Silkis_Upgrade_IsStage2Chocobo())then
            call ReplaceUnitBJ(GetSpellTargetUnit(),'n038',bj_UNIT_STATE_METHOD_RELATIVE) // 'n038': unit "Chocobo"
            if(Trig_Chocobo_Silkis_Upgrade_HasAbility())then
                call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ())
                call SetUnitAbilityLevelSwapped(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ(),$B) // $B = 11
                call UnitAddAbilityBJ('A0K8',GetLastReplacedUnitBJ()) // 'A0K8': ability "Chocobo Tech Copy"
            endif
        else
            if(Trig_Chocobo_Silkis_Upgrade_IsStage1Chocobo())then
                call ReplaceUnitBJ(GetSpellTargetUnit(),'n037',bj_UNIT_STATE_METHOD_RELATIVE) // 'n037': unit "Chocobo"
                if(Trig_Chocobo_Silkis_Upgrade_HasAbilityAgain())then
                    call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ())
                    call SetUnitAbilityLevelSwapped(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ(),6)
                    call UnitAddAbilityBJ('A0K8',GetLastReplacedUnitBJ()) // 'A0K8': ability "Chocobo Tech Copy"
                endif
            else
                call ReplaceUnitBJ(GetSpellTargetUnit(),'n036',bj_UNIT_STATE_METHOD_RELATIVE) // 'n036': unit "Chocobo"
                if(Trig_Chocobo_Silkis_Upgrade_HasAbilityThird())then
                    call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastReplacedUnitBJ())
                endif
            endif
        endif
        if(Trig_Chocobo_Silkis_Upgrade_AbilityNotQuickJoin())then
            call UnitAddAbilityBJ('A04F',GetLastReplacedUnitBJ()) // 'A04F': ability "Join Fast"
        endif
        if(Trig_Chocobo_Silkis_Upgrade_AbilityNotSprint())then
            call UnitAddAbilityBJ('A0A4',GetLastReplacedUnitBJ()) // 'A0A4': ability "Chocobo Sprint"
        endif
        if(Trig_Chocobo_Silkis_Upgrade_AbilityNotAttack())then
            call UnitAddAbilityBJ('Abun',GetLastReplacedUnitBJ()) // 'Abun': object name not found in map data
        endif
        call UnitAddAbilityBJ('S005',GetLastReplacedUnitBJ()) // 'S005': ability "Chocobo Ride"
        call UnitAddAbilityBJ('S006',GetLastReplacedUnitBJ()) // 'S006': ability "Start Chocobo Riding"
        call UnitAddAbilityBJ('S007',GetLastReplacedUnitBJ()) // 'S007': ability "Stop Chocobo Ride"
        call AddSpecialEffectTargetUnitBJ("origin",GetLastReplacedUnitBJ(),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

function Trig_Chocobo_Defend_Upgrade_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I04O') // 'I04O': item "Chocobo Defending"
endfunction

function Trig_Chocobo_Defend_Upgrade_IsDefendMaxed takes nothing returns boolean
    return(GetPlayerTechCountSimple('R00P',GetOwningPlayer(GetTriggerUnit()))>=5) // 'R00P': upgrade "Defend Chocobos"
endfunction

function Trig_Chocobo_Defend_Upgrade_Actions takes nothing returns nothing
    if(Trig_Chocobo_Defend_Upgrade_IsDefendMaxed())then
        call AdjustPlayerStateBJ($2710,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD) // $2710 = 10000
        call AdjustPlayerStateBJ(1,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_LUMBER)
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"Chocobo Defending is already maxed out!")
        call DestroyForce(udg_TempForce)
    else
        // (GetPlayerTechCountSimple('R00P', GetOwningPlayer(the triggering unit))) plus (1).
        call SetPlayerTechResearchedSwap('R00P',(GetPlayerTechCountSimple('R00P',GetOwningPlayer(GetTriggerUnit()))+1),GetOwningPlayer(GetTriggerUnit())) // 'R00P': upgrade "Defend Chocobos"
    endif
endfunction

function InitTrig_Chocobo_Upgrades takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Chocobo_Part1 (module Chocobo),
// which keeps the original registration order.

function Register_Chocobo_Gysahl_Upgrade takes nothing returns nothing
    set gg_trg_Chocobo_Gysahl_Upgrade=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Gysahl_Upgrade,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chocobo_Gysahl_Upgrade,Condition(function Trig_Chocobo_Gysahl_Upgrade_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Gysahl_Upgrade,function Trig_Chocobo_Gysahl_Upgrade_Actions)
endfunction

function Register_Chocobo_Mimett_Upgrade takes nothing returns nothing
    set gg_trg_Chocobo_Mimett_Upgrade=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Mimett_Upgrade,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chocobo_Mimett_Upgrade,Condition(function Trig_Chocobo_Mimett_Upgrade_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Mimett_Upgrade,function Trig_Chocobo_Mimett_Upgrade_Actions)
endfunction

function Register_Chocobo_Silkis_Upgrade takes nothing returns nothing
    set gg_trg_Chocobo_Silkis_Upgrade=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Silkis_Upgrade,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chocobo_Silkis_Upgrade,Condition(function Trig_Chocobo_Silkis_Upgrade_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Silkis_Upgrade,function Trig_Chocobo_Silkis_Upgrade_Actions)
endfunction

function Register_Chocobo_Defend_Upgrade takes nothing returns nothing
    set gg_trg_Chocobo_Defend_Upgrade=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Defend_Upgrade,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Chocobo_Defend_Upgrade,Condition(function Trig_Chocobo_Defend_Upgrade_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Defend_Upgrade,function Trig_Chocobo_Defend_Upgrade_Actions)
endfunction

endlibrary

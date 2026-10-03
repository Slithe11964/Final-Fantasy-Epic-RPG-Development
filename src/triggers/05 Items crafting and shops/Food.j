library TFood
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Food_Effects=null
    // Variables only this module uses.
    real udg_FoodHealAmount=0
    integer udg_FoodBuffAbility=0
    string udg_FoodEffectString=""
endglobals

function Trig_Food_Effects_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A164')or(GetSpellAbilityId()=='A165')or(GetSpellAbilityId()=='A166')or(GetSpellAbilityId()=='A167')or(GetSpellAbilityId()=='A168')or(GetSpellAbilityId()=='A169')or(GetSpellAbilityId()=='A16A')or(GetSpellAbilityId()=='A16B')or(GetSpellAbilityId()=='A16C')or(GetSpellAbilityId()=='A16D')or(GetSpellAbilityId()=='A09L') // 'A164': ability "Wild Bowl"; 'A165': ability "Triton Pot"; 'A166': ability "Tropical Dish"; 'A167': ability "Fish Soup"; 'A168': ability "Energy Brew"; 'A169': ability "Swift Drink"; 'A16A': ability "Spiced Salad"; 'A16B': ability "Nebra Bread"; 'A16C': ability "First Class Meat Plate"; 'A16D': ability "Adamant Stew"; 'A09L': ability "!Megalixir"
endfunction

function Trig_Food_Effects_ApplyFoodBuff takes nothing returns nothing
    local unit d=CreateUnit(GetOwningPlayer(GetEnumUnit()),'h02S',GetUnitX(GetEnumUnit()),GetUnitY(GetEnumUnit()),.0) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnit(d,false)
    call UnitApplyTimedLife(d,'BTLF',1.4) // 'BTLF': object name not found in map data
    call UnitAddAbility(d,udg_FoodBuffAbility)
    call IssueTargetOrder(d,udg_FoodEffectString,GetEnumUnit())
    set d=null
endfunction

function Trig_Food_Effects_CleanseEnum takes nothing returns nothing
    set udg_DispelTarget=GetEnumUnit()
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
endfunction

function Trig_Food_Effects_RemoveFoodBuffs takes nothing returns nothing
    call UnitRemoveAbility(GetEnumUnit(),'B07F') // 'B07F': buff "Haste"
    call UnitRemoveAbility(GetEnumUnit(),'B07G') // 'B07G': buff "Protect"
    call UnitRemoveAbility(GetEnumUnit(),'B07H') // 'B07H': buff "Shell"
    call UnitRemoveAbility(GetEnumUnit(),'B07I') // 'B07I': buff "Bravery"
    call UnitRemoveAbility(GetEnumUnit(),'B07J') // 'B07J': buff "Faith"
endfunction

function Trig_Food_Effects_RestoreMana takes nothing returns nothing
    if(GetUnitAbilityLevel(GetEnumUnit(),'A0Z8')<=0)then // 'A0Z8': ability "Negate Collateral Heals"
        set udg_IsPureDamage=true
        set udg_DmgFlagPure=true
        set udg_DmgFlagManaDamage=true
        call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),udg_FoodHealAmount,true,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
    endif
endfunction

function Trig_Food_Effects_RestoreLife takes nothing returns nothing
    if(GetUnitAbilityLevel(GetEnumUnit(),'A0Z8')>0)then // 'A0Z8': ability "Negate Collateral Heals"
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl",GetEnumUnit(),"overhead"))
    else
        call DestroyEffect(AddSpecialEffectTarget(udg_FoodEffectString,GetEnumUnit(),"origin"))
        set udg_IsPureDamage=true
        set udg_DmgFlagPure=true
        call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),udg_FoodHealAmount,true,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
    endif
endfunction

function Trig_Food_Effects_FilterValidTarget takes nothing returns boolean
    return(GetWidgetLife(GetFilterUnit())>.405 and GetUnitAbilityLevel(GetFilterUnit(),'Avul')<=0 and not IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)and(not IsUnitType(GetFilterUnit(),UNIT_TYPE_UNDEAD)or GetUnitAbilityLevel(GetFilterUnit(),'A0Z8')>0)and(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers)==IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers)))!=null // 'Avul': standard ability reference "Invulnerable"; 'A0Z8': ability "Negate Collateral Heals"
endfunction

function Trig_Food_Effects_Actions takes nothing returns nothing
    local integer l_spellId=GetSpellAbilityId()
    local unit triggeringUnit=GetTriggerUnit()
    local group g=CreateGroup()
    local boolean l_bravery=(l_spellId=='A164' or l_spellId=='A16A' or l_spellId=='A16C') // 'A164': ability "Wild Bowl"; 'A16A': ability "Spiced Salad"; 'A16C': ability "First Class Meat Plate"
    local boolean l_faith=(l_spellId=='A165' or l_spellId=='A16B' or l_spellId=='A16C') // 'A165': ability "Triton Pot"; 'A16B': ability "Nebra Bread"; 'A16C': ability "First Class Meat Plate"
    local boolean l_haste=(l_spellId=='A169') // 'A169': ability "Swift Drink"
    local boolean l_protect=(l_spellId=='A166' or l_spellId=='A16A' or l_spellId=='A16D') // 'A166': ability "Tropical Dish"; 'A16A': ability "Spiced Salad"; 'A16D': ability "Adamant Stew"
    local boolean l_shell=(l_spellId=='A167' or l_spellId=='A16B' or l_spellId=='A16D') // 'A167': ability "Fish Soup"; 'A16B': ability "Nebra Bread"; 'A16D': ability "Adamant Stew"
    local boolean l_noBuffs=(l_spellId=='A168' or l_spellId=='A09L') // 'A168': ability "Energy Brew"; 'A09L': ability "!Megalixir"
    local boolean l_pharma=GetUnitAbilityLevel(triggeringUnit,'A0HL')>0 // 'A0HL': ability "Pharmacology"
    local real l_heal=.0
    local real currentMana=.0
    call GroupEnumUnitsInRange(g,GetUnitX(triggeringUnit),GetUnitY(triggeringUnit),800.,Condition(function Trig_Food_Effects_FilterValidTarget))
    set udg_FoodEffectString="Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl"
    if(l_spellId=='A164')then // 'A164': ability "Wild Bowl"
        set l_heal=4500.
    elseif(l_spellId=='A165')then // 'A165': ability "Triton Pot"
        set l_heal=3500.
        set currentMana=2000.
    elseif(l_spellId=='A166')then // 'A166': ability "Tropical Dish"
        set l_heal=7500.
    elseif(l_spellId=='A167')then // 'A167': ability "Fish Soup"
        set l_heal=5000.
        set currentMana=1000.
    elseif(l_spellId=='A168')then // 'A168': ability "Energy Brew"
        set l_heal=6500.
        set currentMana=1500.
        call UnitAddItem(triggeringUnit,CreateItem('rspl',GetUnitX(triggeringUnit),GetUnitY(triggeringUnit))) // 'rspl': item "Growth"
    elseif(l_spellId=='A169')then // 'A169': ability "Swift Drink"
        set l_heal=4500.
        set currentMana=2500.
    elseif(l_spellId=='A16A')then // 'A16A': ability "Spiced Salad"
        set l_heal=8000.
    elseif(l_spellId=='A16B')then // 'A16B': ability "Nebra Bread"
        set l_heal=6000.
        set currentMana=4500.
    elseif(l_spellId=='A16C')then // 'A16C': ability "First Class Meat Plate"
        set l_heal=9000.
        set currentMana=3000.
    elseif(l_spellId=='A16D')then // 'A16D': ability "Adamant Stew"
        set l_heal=12000.
    elseif(l_spellId=='A09L')then // 'A09L': ability "!Megalixir"
        set l_heal=6666666.
        set currentMana=6666666.
        set udg_FoodEffectString="Abilities\\Spells\\Other\\Awaken\\Awaken.mdl"
    endif
    if(l_pharma)then
        // Multiply the current healing by 1.5: 100 becomes 150, before any later adjustments.
        set l_heal=l_heal*1.5
        set currentMana=currentMana*1.5
        call ForGroup(g,function Trig_Food_Effects_CleanseEnum)
    endif
    if(currentMana>.0)then
        set udg_FoodHealAmount=currentMana
        call ForGroup(g,function Trig_Food_Effects_RestoreMana)
    endif
    if(l_heal>.0)then
        set udg_FoodHealAmount=l_heal
        call ForGroup(g,function Trig_Food_Effects_RestoreLife)
    endif
    call GroupClear(g)
    call GroupEnumUnitsInRange(g,GetUnitX(triggeringUnit),GetUnitY(triggeringUnit),800.,Condition(function Trig_Food_Effects_FilterValidTarget))
    if(not l_noBuffs)then
        call ForGroup(g,function Trig_Food_Effects_RemoveFoodBuffs)
        if l_bravery then
            set udg_FoodEffectString="innerfire"
            if l_pharma then
                set udg_FoodBuffAbility='A17I' // 'A17I': ability "Bravery"
            else
                set udg_FoodBuffAbility='A17H' // 'A17H': ability "Bravery"
            endif
            call ForGroup(g,function Trig_Food_Effects_ApplyFoodBuff)
        endif
        if l_faith then
            set udg_FoodEffectString="unholyfrenzy"
            if l_pharma then
                set udg_FoodBuffAbility='A17G' // 'A17G': ability "Faith"
            else
                set udg_FoodBuffAbility='A17F' // 'A17F': ability "Faith"
            endif
            call ForGroup(g,function Trig_Food_Effects_ApplyFoodBuff)
        endif
        if l_haste then
            set udg_FoodEffectString="bloodlust"
            if l_pharma then
                set udg_FoodBuffAbility='A17M' // 'A17M': ability "Haste"
            else
                set udg_FoodBuffAbility='A17L' // 'A17L': ability "Haste"
            endif
            call ForGroup(g,function Trig_Food_Effects_ApplyFoodBuff)
        endif
        if l_protect then
            set udg_FoodEffectString="frostarmor"
            if l_pharma then
                set udg_FoodBuffAbility='A17K' // 'A17K': ability "Protect"
            else
                set udg_FoodBuffAbility='A17J' // 'A17J': ability "Protect"
            endif
            call ForGroup(g,function Trig_Food_Effects_ApplyFoodBuff)
        endif
        if l_shell then
            set udg_FoodEffectString="drunkenhaze"
            if l_pharma then
                set udg_FoodBuffAbility='A17O' // 'A17O': ability "Shell"
            else
                set udg_FoodBuffAbility='A17N' // 'A17N': ability "Shell"
            endif
            call ForGroup(g,function Trig_Food_Effects_ApplyFoodBuff)
        endif
    endif
    set udg_FoodHealAmount=.0
    set udg_FoodBuffAbility=0
    set udg_FoodEffectString=null
    call DestroyGroup(g)
    set triggeringUnit=null
    set g=null
endfunction

// World Editor calls InitTrig_Food automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Food (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Food takes nothing returns nothing
endfunction

function Register_Food_Effects takes nothing returns nothing
    set gg_trg_Food_Effects=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Food_Effects,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Food_Effects,Condition(function Trig_Food_Effects_Conditions))
    call TriggerAddAction(gg_trg_Food_Effects,function Trig_Food_Effects_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Food takes nothing returns nothing
    call Register_Food_Effects()
endfunction

endlibrary

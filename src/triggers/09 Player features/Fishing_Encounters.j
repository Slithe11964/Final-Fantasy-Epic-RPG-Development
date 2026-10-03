library TFishingEncounters requires TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Fishing_Monster_Spawn=null
endglobals

function Trig_Fishing_Monster_Spawn_IsMonsterCatch takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0FJ')or(GetItemTypeId(GetManipulatedItem())=='I0GL')or(GetItemTypeId(GetManipulatedItem())=='I0GN')or(GetItemTypeId(GetManipulatedItem())=='I0GO')or(GetItemTypeId(GetManipulatedItem())=='I0GM')or(GetItemTypeId(GetManipulatedItem())=='I0GP')or(GetItemTypeId(GetManipulatedItem())=='I0GQ') // 'I0FJ': item "Angry Tritons"; 'I0GL': item "Sneaky Tritons"; 'I0GN': item "Water Flans"; 'I0GO': item "Big Pudding"; 'I0GM': item "Poisonous Fiends"; 'I0GP': item "Black Flan"; 'I0GQ': item "a Huge Turtle"
endfunction

function Trig_Fishing_Monster_Spawn_Conditions takes nothing returns boolean
    return(Trig_Fishing_Monster_Spawn_IsMonsterCatch())
endfunction

function Trig_Fishing_Monster_Spawn_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    local real l_tempReal
    // (facing in degrees of the triggering unit) plus (180).
    set l_tempReal=(GetUnitFacing(GetTriggerUnit())+180.)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set l_tempPoint2=Loc_PolarOffset(l_tempPoint,256,l_tempReal)
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectLocBJ(l_tempPoint2,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // (GetItemLifeBJ(the item being used or moved)) with its decimal part removed.
    call CreateNUnitsAtLocFacingLocBJ(R2I(GetItemLifeBJ(GetManipulatedItem())),udg_FishMonster[GetItemLevel(GetManipulatedItem())],Player($B),l_tempPoint2,l_tempPoint) // $B = 11
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

function InitTrig_Fishing_Encounters takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Fishing_Part2 (module Fishing),
// which keeps the original registration order.

function Register_Fishing_Monster_Spawn takes nothing returns nothing
    set gg_trg_Fishing_Monster_Spawn=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Fishing_Monster_Spawn,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Fishing_Monster_Spawn,Condition(function Trig_Fishing_Monster_Spawn_Conditions))
    call TriggerAddAction(gg_trg_Fishing_Monster_Spawn,function Trig_Fishing_Monster_Spawn_Actions)
endfunction

endlibrary

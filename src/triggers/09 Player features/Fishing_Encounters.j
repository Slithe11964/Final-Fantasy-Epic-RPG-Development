library TFishingEncounters requires TLoc
function Trig_Fishing_Monster_Spawn_IsMonsterCatch takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0FJ')or(GetItemTypeId(GetManipulatedItem())=='I0GL')or(GetItemTypeId(GetManipulatedItem())=='I0GN')or(GetItemTypeId(GetManipulatedItem())=='I0GO')or(GetItemTypeId(GetManipulatedItem())=='I0GM')or(GetItemTypeId(GetManipulatedItem())=='I0GP')or(GetItemTypeId(GetManipulatedItem())=='I0GQ') // 'I0FJ': item "Angry Tritons"; 'I0GL': item "Sneaky Tritons"; 'I0GN': item "Water Flans"; 'I0GO': item "Big Pudding"; 'I0GM': item "Poisonous Fiends"; 'I0GP': item "Black Flan"; 'I0GQ': item "a Huge Turtle"
endfunction

function Trig_Fishing_Monster_Spawn_Conditions takes nothing returns boolean
    return(Trig_Fishing_Monster_Spawn_IsMonsterCatch())
endfunction

function Trig_Fishing_Monster_Spawn_Actions takes nothing returns nothing
    // (facing in degrees of the triggering unit) plus (180).
    set udg_TempReal=(GetUnitFacing(GetTriggerUnit())+180.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,udg_TempReal)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    // (GetItemLifeBJ(the item being used or moved)) with its decimal part removed.
    call CreateNUnitsAtLocFacingLocBJ(R2I(GetItemLifeBJ(GetManipulatedItem())),udg_FishMonster[GetItemLevel(GetManipulatedItem())],Player($B),udg_TempPoint2,udg_TempPoint) // $B = 11
    call RemoveLocation(udg_TempPoint2)
endfunction

function InitTrig_Fishing_Encounters takes nothing returns nothing
endfunction

endlibrary

library TRevive requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Revive_Item_Cleanup=null
endglobals

function Trig_Revive_Item_Cleanup_ShieldReqUnmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetEnumUnit(),'I065'))and(BlzGetUnitMaxHP(GetEnumUnit())<$2710) // 'I065': item "Ensanguined Shield"; $2710 = 10000
endfunction

function Trig_Revive_Item_Cleanup_SkullReqUnmet takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetEnumUnit(),'I0GD'))and(BlzGetUnitMaxHP(GetEnumUnit())<$3E8) // 'I0GD': item "Death Skull X"; $3E8 = 1000
endfunction

function Trig_Revive_Item_Cleanup_MaxHPOutOfRange takes nothing returns boolean
    return(BlzGetUnitMaxHP(GetEnumUnit())<$F)or(BlzGetUnitMaxHP(GetEnumUnit())>$A2C2A) // $F = 15; $A2C2A = 666666
endfunction

function Trig_Revive_Item_Cleanup_HasNecklace takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetEnumUnit(),'I04L')) // 'I04L': item "Necklace of the Necromancer"
endfunction

function Trig_Revive_Item_Cleanup_HasJackboots takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetEnumUnit(),'I0FD')) // 'I0FD': item "Jackboots"
endfunction

function Trig_Revive_Item_Cleanup_MaxHPInvalid takes nothing returns boolean
    return(Trig_Revive_Item_Cleanup_MaxHPOutOfRange())
endfunction

function Trig_Revive_Item_Cleanup_DropIllegalItems takes nothing returns nothing
    if(Trig_Revive_Item_Cleanup_ShieldReqUnmet())then
        call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(GetEnumUnit(),'I065'),GetEnumUnit()) // 'I065': item "Ensanguined Shield"
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetEnumUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"The Ensanguined Shield has been dropped from your inventory.")
        call DestroyForce(udg_TempForce)
    endif
    if(Trig_Revive_Item_Cleanup_SkullReqUnmet())then
        call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(GetEnumUnit(),'I0GD'),GetEnumUnit()) // 'I0GD': item "Death Skull X"
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetEnumUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"The Death Skull X has been dropped from your inventory.")
        call DestroyForce(udg_TempForce)
    endif
    if(Trig_Revive_Item_Cleanup_MaxHPInvalid())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetEnumUnit()))
        if(Trig_Revive_Item_Cleanup_HasNecklace())then
            call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(GetEnumUnit(),'I04L'),GetEnumUnit()) // 'I04L': item "Necklace of the Necromancer"
            call DisplayTimedTextToForce(udg_TempForce,10.,"The Necklace of the Necromancer has been dropped from your inventory.")
        endif
        if(Trig_Revive_Item_Cleanup_HasJackboots())then
            call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(GetEnumUnit(),'I0FD'),GetEnumUnit()) // 'I0FD': item "Jackboots"
            call DisplayTimedTextToForce(udg_TempForce,10.,"The Jackboots have been dropped from your inventory.")
        endif
        call DestroyForce(udg_TempForce)
    endif
endfunction

function Trig_Revive_Item_Cleanup_Actions takes nothing returns nothing
    call ForGroupBJ(udg_RevivedHeroes,function Trig_Revive_Item_Cleanup_DropIllegalItems)
    call GroupClear(udg_RevivedHeroes)
endfunction

// World Editor calls InitTrig_Revive automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Revive (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Revive takes nothing returns nothing
endfunction

function Register_Revive_Item_Cleanup takes nothing returns nothing
    set gg_trg_Revive_Item_Cleanup=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Revive_Item_Cleanup,udg_ReviveCleanupTimer)
    call TriggerAddAction(gg_trg_Revive_Item_Cleanup,function Trig_Revive_Item_Cleanup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Revive takes nothing returns nothing
    call Register_Revive_Item_Cleanup()
endfunction

endlibrary

library TDead requires TForce, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Dead_Hero_Item_Drop=null
endglobals

function Trig_Dead_Hero_Item_Drop_CarriesNecklace takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(GetEnumPlayer()),'I04L')) // 'I04L': item "Necklace of the Necromancer"
endfunction

function Trig_Dead_Hero_Item_Drop_CarriesJackboots takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(GetEnumPlayer()),'I0FD')) // 'I0FD': item "Jackboots"
endfunction

function Trig_Dead_Hero_Item_Drop_CarriesDeathSkull takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(Player_GetHero(GetEnumPlayer()),'I0GD')) // 'I0GD': item "Death Skull X"
endfunction

function Trig_Dead_Hero_Item_Drop_HeroIsDead takes nothing returns boolean
    return(R2I(GetUnitStateSwap(UNIT_STATE_LIFE,Player_GetHero(GetEnumPlayer())))<=0)
endfunction

function Trig_Dead_Hero_Item_Drop_DropItemsOnDeath takes nothing returns nothing
    if(Trig_Dead_Hero_Item_Drop_HeroIsDead())then
        if(Trig_Dead_Hero_Item_Drop_CarriesNecklace())then
            call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(Player_GetHero(GetEnumPlayer()),'I04L'),Player_GetHero(GetEnumPlayer())) // 'I04L': item "Necklace of the Necromancer"
            set udg_TempPoint=GetRectCenter(gg_rct_571)
            call SetItemPositionLoc(GetLastRemovedItem(),udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
            call DisplayTimedTextToForce(udg_TempForce,10.,"The Necklace of the Necromancer has been dropped from your inventory.")
            call DestroyForce(udg_TempForce)
        endif
        if(Trig_Dead_Hero_Item_Drop_CarriesJackboots())then
            call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(Player_GetHero(GetEnumPlayer()),'I0FD'),Player_GetHero(GetEnumPlayer())) // 'I0FD': item "Jackboots"
            set udg_TempPoint=GetRectCenter(gg_rct_571)
            call SetItemPositionLoc(GetLastRemovedItem(),udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
            call DisplayTimedTextToForce(udg_TempForce,10.,"The Jackboots have been dropped from your inventory.")
            call DestroyForce(udg_TempForce)
        endif
        if(Trig_Dead_Hero_Item_Drop_CarriesDeathSkull())then
            call UnitRemoveItemSwapped(GetItemOfTypeFromUnitBJ(Player_GetHero(GetEnumPlayer()),'I0GD'),Player_GetHero(GetEnumPlayer())) // 'I0GD': item "Death Skull X"
            set udg_TempPoint=GetRectCenter(gg_rct_571)
            call SetItemPositionLoc(GetLastRemovedItem(),udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
            call DisplayTimedTextToForce(udg_TempForce,10.,"The Death Skull X has been dropped from your inventory.")
            call DestroyForce(udg_TempForce)
        endif
        call SetUnitLifeBJ(Player_GetHero(GetEnumPlayer()),1.)
        call KillUnit(Player_GetHero(GetEnumPlayer()))
    endif
endfunction

function Trig_Dead_Hero_Item_Drop_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Dead_Hero_Item_Drop_DropItemsOnDeath)
endfunction

// World Editor calls InitTrig_Dead automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Dead (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Dead takes nothing returns nothing
endfunction

function Register_Dead_Hero_Item_Drop takes nothing returns nothing
    set gg_trg_Dead_Hero_Item_Drop=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Dead_Hero_Item_Drop,6.)
    call TriggerAddAction(gg_trg_Dead_Hero_Item_Drop,function Trig_Dead_Hero_Item_Drop_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Dead takes nothing returns nothing
    call Register_Dead_Hero_Item_Drop()
endfunction

endlibrary

library TCelestium requires TForce
function Trig_Celestium_Trade_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0B6') // 'I0B6': item "Celestial Psypher (Celestium Trade)"
endfunction

function Trig_Celestium_Trade_Cond_StackOverThree takes nothing returns boolean
    return(GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()))>=4)
endfunction

function Trig_Celestium_Trade_Cond_IsOwnCelestiumStack takes nothing returns boolean
    return(udg_TempBoolean==false)and(GetItemTypeId(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()))=='I0LL')and(GetItemUserData(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()))==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))and(GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()))>=3) // 'I0LL': item "Celestium"
endfunction

function Trig_Celestium_Trade_Cond_TradeFailed takes nothing returns boolean
    return(udg_TempBoolean==false)
endfunction

function Trig_Celestium_Trade_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
    set udg_TempBoolean=false
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Celestium_Trade_Cond_IsOwnCelestiumStack())then
            set udg_TempBoolean=true
            if(Trig_Celestium_Trade_Cond_StackOverThree())then
                // (item charges of UnitItemInSlotBJ(the triggering unit, loop counter A)) minus (3).
                call SetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()),(GetItemCharges(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()))-3))
            else
                call RemoveItem(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()))
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Celestium_Trade_Cond_TradeFailed())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,15.,"You must have 3 pieces of Celestium stacked in your inventory to make this trade.")
        call DestroyForce(udg_TempForce)
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I0A8',udg_TempPoint) // 'I0A8': item "Celestial Psypher"
        call RemoveLocation(udg_TempPoint)
        call SetItemUserData(GetLastCreatedItem(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
        call UnitAddItemSwapped(GetLastCreatedItem(),GetTriggerUnit())
    endif
endfunction

// World Editor calls InitTrig_Celestium automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Celestium (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Celestium takes nothing returns nothing
endfunction

function Register_Celestium_Trade takes nothing returns nothing
    set gg_trg_Celestium_Trade=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Celestium_Trade,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Celestium_Trade,Condition(function Trig_Celestium_Trade_Conditions))
    call TriggerAddAction(gg_trg_Celestium_Trade,function Trig_Celestium_Trade_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Celestium takes nothing returns nothing
    call Register_Celestium_Trade()
endfunction

endlibrary

library THeroMedicine requires TMedicine, TPlayerPart01
function Trig_HeroMedicine_Refill_Cond_CooldownReady takes nothing returns boolean
    return(TimerGetRemaining(udg_SpellCooldownTimer[GetConvertedPlayerId(GetEnumPlayer())])<=.01)
endfunction

function Trig_HeroMedicine_Refill_Cond_HasMedicine takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0FF',Player_GetHero(GetEnumPlayer()))>0) // 'A0FF': ability "Hidden Hero Medicine"
endfunction

function Trig_HeroMedicine_Refill_GiveDrinkToPlayer takes nothing returns nothing
    if(Trig_HeroMedicine_Refill_Cond_HasMedicine())then
        set udg_TempBoolean=true
        if(Trig_HeroMedicine_Refill_Cond_CooldownReady())then
            call UnitAddItemByIdSwapped('I0BV',udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())]) // 'I0BV': item "Hero Drink (HHM)"
        endif
    endif
endfunction

function Trig_HeroMedicine_Refill_Cond_NoneWithMedicine takes nothing returns boolean
    return(udg_TempBoolean==false)
endfunction

function Trig_HeroMedicine_Refill_Actions takes nothing returns nothing
    set udg_TempBoolean=false
    call ForForce(udg_PlayingPlayers,function Trig_HeroMedicine_Refill_GiveDrinkToPlayer)
    if(Trig_HeroMedicine_Refill_Cond_NoneWithMedicine())then
        call DisableTrigger(GetTriggeringTrigger())
        call DisableTrigger(gg_trg_HeroMedicine_Pickup)
        call EnableTrigger(gg_trg_Hero_Medicine_Pickup)
    endif
endfunction

function Trig_HeroMedicine_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0BV') // 'I0BV': item "Hero Drink (HHM)"
endfunction

function Trig_HeroMedicine_Pickup_Actions takes nothing returns nothing
    call Medicine_ApplyTimed(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),false)
endfunction

// World Editor calls InitTrig_HeroMedicine automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HeroMedicine (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HeroMedicine takes nothing returns nothing
endfunction

function Register_HeroMedicine_Refill takes nothing returns nothing
    set gg_trg_HeroMedicine_Refill=CreateTrigger()
    call DisableTrigger(gg_trg_HeroMedicine_Refill)
    call TriggerRegisterTimerEventPeriodic(gg_trg_HeroMedicine_Refill,6.)
    call TriggerAddAction(gg_trg_HeroMedicine_Refill,function Trig_HeroMedicine_Refill_Actions)
endfunction

function Register_HeroMedicine_Pickup takes nothing returns nothing
    set gg_trg_HeroMedicine_Pickup=CreateTrigger()
    call DisableTrigger(gg_trg_HeroMedicine_Pickup)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_HeroMedicine_Pickup,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_HeroMedicine_Pickup,Condition(function Trig_HeroMedicine_Pickup_Conditions))
    call TriggerAddAction(gg_trg_HeroMedicine_Pickup,function Trig_HeroMedicine_Pickup_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HeroMedicine takes nothing returns nothing
    call Register_HeroMedicine_Refill()
    call Register_HeroMedicine_Pickup()
endfunction

endlibrary

library TBuy requires TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Buy_Kesha_Brew=null
endglobals

function Trig_Buy_Kesha_Brew_NeedsRestore takes nothing returns boolean
    return(GetUnitLifePercent(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))<100.)or(GetUnitManaPercent(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))<100.)
endfunction

function Trig_Buy_Kesha_Brew_Conditions takes nothing returns boolean
    return((GetItemTypeId(GetSoldItem())=='I020')and(IsPlayerInForce(GetOwningPlayer(GetBuyingUnit()),udg_PlayingPlayers))and(GetPlayerState(GetOwningPlayer(GetBuyingUnit()),PLAYER_STATE_RESOURCE_GOLD)>=(GetHeroLevel(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))*3))and(Trig_Buy_Kesha_Brew_NeedsRestore())and(IsUnitType(GetBuyingUnit(),UNIT_TYPE_HERO)))!=null // 'I020': item "Kesha's Special Brew"
endfunction

function Trig_Buy_Kesha_Brew_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetOwningPlayer(GetBuyingUnit())),"Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_DispelTarget=Player_GetHero(GetOwningPlayer(GetBuyingUnit()))
    call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
    call SetUnitLifePercentBJ(Player_GetHero(GetOwningPlayer(GetBuyingUnit())),'d')
    call SetUnitManaPercentBJ(Player_GetHero(GetOwningPlayer(GetBuyingUnit())),'d')
    call SetUnitManaBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))],990000.)
    call AdjustPlayerStateBJ((-3*GetHeroLevel(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))),GetOwningPlayer(GetBuyingUnit()),PLAYER_STATE_RESOURCE_GOLD)
endfunction

// World Editor calls InitTrig_Buy automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Buy (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Buy takes nothing returns nothing
endfunction

function Register_Buy_Kesha_Brew takes nothing returns nothing
    set gg_trg_Buy_Kesha_Brew=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Buy_Kesha_Brew,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Buy_Kesha_Brew,Condition(function Trig_Buy_Kesha_Brew_Conditions))
    call TriggerAddAction(gg_trg_Buy_Kesha_Brew,function Trig_Buy_Kesha_Brew_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Buy takes nothing returns nothing
    call Register_Buy_Kesha_Brew()
endfunction

endlibrary

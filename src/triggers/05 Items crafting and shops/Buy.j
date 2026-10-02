library TBuy requires TPlayerPart01
function Trig_Buy_Kesha_Brew_NeedsRestore takes nothing returns boolean
    // Calculation 1:
    // Result 1: current health divided by maximum health for Player_GetHero(GetOwningPlayer(GetBuyingUnit())),
    // times 100 (or 0 if the unit is missing or its maximum is 0).
    // Calculation 2:
    // Result 1: current mana divided by maximum mana for Player_GetHero(GetOwningPlayer(GetBuyingUnit())), times
    // 100 (or 0 if the unit is missing or its maximum is 0).
    return(GetUnitLifePercent(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))<100.)or(GetUnitManaPercent(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))<100.)
endfunction

function Trig_Buy_Kesha_Brew_Conditions takes nothing returns boolean
    // (hero level of Player_GetHero(GetOwningPlayer(GetBuyingUnit()))) times (3).
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
    // (-3) times (hero level of Player_GetHero(GetOwningPlayer(GetBuyingUnit()))).
    call AdjustPlayerStateBJ((-3*GetHeroLevel(Player_GetHero(GetOwningPlayer(GetBuyingUnit())))),GetOwningPlayer(GetBuyingUnit()),PLAYER_STATE_RESOURCE_GOLD)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Buy takes nothing returns nothing
endfunction
function RegisterR11_Buy_Kesha_Brew takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Buy_Kesha_Brew=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Buy_Kesha_Brew,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Buy_Kesha_Brew,Condition(function Trig_Buy_Kesha_Brew_Conditions))
    call TriggerAddAction(gg_trg_Buy_Kesha_Brew,function Trig_Buy_Kesha_Brew_Actions)
endfunction




endlibrary

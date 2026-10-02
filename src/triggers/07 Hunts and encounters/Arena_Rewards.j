library TArenaRewards requires TForce, TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_BuyPrize=null
    trigger gg_trg_Arena_ExchangeBP=null
    trigger gg_trg_Arena_RefreshBPTags=null
endglobals

function Trig_Arena_BuyPrize_IsOutfitter takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_e01A_0252)or(GetTriggerUnit()==gg_unit_e01B_0028)or(GetTriggerUnit()==gg_unit_e01C_0027)or(GetTriggerUnit()==gg_unit_e01D_0026)
endfunction

function Trig_Arena_BuyPrize_Conditions takes nothing returns boolean
    return(Trig_Arena_BuyPrize_IsOutfitter())
endfunction

function Trig_Arena_BuyPrize_HasNoItemLevel takes nothing returns boolean
    return(udg_BattlePoints[0]==0)
endfunction

function Trig_Arena_BuyPrize_CannotAfford takes nothing returns boolean
    // (GetItemLifeBJ(GetSoldItem())) with its decimal part removed.
    return(udg_BattlePoints[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))]<R2I(GetItemLifeBJ(GetSoldItem())))
endfunction

function Trig_Arena_BuyPrize_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetBuyingUnit()))
    if(Trig_Arena_BuyPrize_CannotAfford())then
        call RemoveItem(GetSoldItem())
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cff00ff00Arena:|r You do not have enough BP to purchase this prize!")
    else
        // Result 1: (GetItemLifeBJ(GetSoldItem())) with its decimal part removed.
        // Result 2: (udg_BattlePoints at position GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))) minus
        // (result 1).
        set udg_BattlePoints[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))]=(udg_BattlePoints[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))]-R2I(GetItemLifeBJ(GetSoldItem())))
        call DestroyTextTagBJ(udg_ArenaBpTag[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))])
        set udg_ArenaBpTag[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))]=CreateTextTagUnitBJ(("Current BP: |cffffcc00"+(I2S(udg_BattlePoints[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))])+"|r")),gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
        set udg_BattlePoints[0]=GetItemLevel(GetSoldItem())
        call RemoveItem(GetSoldItem())
        if(Trig_Arena_BuyPrize_HasNoItemLevel())then
            call UnitAddItemByIdSwapped('I07F',GetBuyingUnit()) // 'I07F': item "Luchil Nut"
        else
            call UnitAddItemByIdSwapped(udg_ItemIdTable[udg_BattlePoints[0]],GetBuyingUnit())
        endif
    endif
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Arena_ExchangeBP_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_h02I_0167)
endfunction

function Trig_Arena_ExchangeBP_IsExchangeExp takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0K0') // 'n0K0': unit "Arena BP to EXP"
endfunction

function Trig_Arena_ExchangeBP_IsExchangeGold takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0JZ') // 'n0JZ': unit "Arena BP to Gold"
endfunction

function Trig_Arena_ExchangeBP_BelowTwoShards takes nothing returns boolean
    return(udg_BattlePoints[udg_TempInteger]<$2710) // $2710 = 10000
endfunction

function Trig_Arena_ExchangeBP_BelowOneShard takes nothing returns boolean
    return(udg_BattlePoints[udg_TempInteger]<5000)
endfunction

function Trig_Arena_ExchangeBP_IsExchangeShards takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0K1') // 'n0K1': unit "Arena BP to Shards"
endfunction

function Trig_Arena_ExchangeBP_HasNoBP takes nothing returns boolean
    return(udg_BattlePoints[udg_TempInteger]<=0)
endfunction

function Trig_Arena_ExchangeBP_IsShowBP takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0D2') // 'n0D2': unit "Arena Show BP"
endfunction

function Trig_Arena_ExchangeBP_Actions takes nothing returns nothing
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
    set udg_TempInteger=GetConvertedPlayerId(GetOwningPlayer(GetSoldUnit()))
    if(Trig_Arena_ExchangeBP_IsShowBP())then
        call DisplayTimedTextToForce(udg_TempForce,10.,(("|cff00ff00Arena:|r You currently have "+I2S(udg_BattlePoints[udg_TempInteger]))+" Battle Points."))
    else
        if(Trig_Arena_ExchangeBP_HasNoBP())then
            call DisplayTimedTextToForce(udg_TempForce,10.,"|cff00ff00Arena:|r You do not have enough BP!")
        else
            if(Trig_Arena_ExchangeBP_IsExchangeShards())then
                if(Trig_Arena_ExchangeBP_BelowOneShard())then
                    call DisplayTimedTextToForce(udg_TempForce,10.,"|cff00ff00Arena:|r You do not have enough BP!")
                else
                    if(Trig_Arena_ExchangeBP_BelowTwoShards())then
                        call AdjustPlayerStateBJ(1,GetOwningPlayer(GetSoldUnit()),PLAYER_STATE_RESOURCE_LUMBER)
                        call DisplayTimedTextToForce(udg_TempForce,10.,"|cff00ff00Arena:|r You gain 1 Crystal Shard.")
                    else
                        // (udg_BattlePoints at position udg_TempInteger) divided by (5000); drop the remainder.
                        call AdjustPlayerStateBJ((udg_BattlePoints[udg_TempInteger]/ 5000),GetOwningPlayer(GetSoldUnit()),PLAYER_STATE_RESOURCE_LUMBER)
                        // (udg_BattlePoints at position udg_TempInteger) divided by (5000); drop the remainder.
                        call DisplayTimedTextToForce(udg_TempForce,10.,(("|cff00ff00Arena:|r You gain "+I2S((udg_BattlePoints[udg_TempInteger]/ 5000)))+" Crystal Shards."))
                    endif
                    // The remainder after dividing (udg_BattlePoints at position udg_TempInteger) by (5000).
                    set udg_BattlePoints[udg_TempInteger]=ModuloInteger(udg_BattlePoints[udg_TempInteger],5000)
                endif
            else
                if(Trig_Arena_ExchangeBP_IsExchangeGold())then
                    call AdjustPlayerStateBJ(udg_BattlePoints[udg_TempInteger],GetOwningPlayer(GetSoldUnit()),PLAYER_STATE_RESOURCE_GOLD)
                    call DisplayTimedTextToForce(udg_TempForce,10.,(("|cff00ff00Arena:|r You gain "+I2S(udg_BattlePoints[udg_TempInteger]))+" Gold."))
                    call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(GetOwningPlayer(GetSoldUnit())),"Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                else
                    if(Trig_Arena_ExchangeBP_IsExchangeExp())then
                        // Result 1: udg_BattlePoints at position udg_TempInteger treated as a decimal-capable number.
                        // Result 2: (result 1) times (udg_SecondaryXPRate).
                        // Result 3: (result 2) with its decimal part removed.
                        call AddHeroXPSwapped(R2I((I2R(udg_BattlePoints[udg_TempInteger])*udg_SecondaryXPRate)),udg_SpiritOfGaya[udg_TempInteger],true)
                        call AddHeroXPSwapped(udg_BattlePoints[udg_TempInteger],Player_GetHero(GetOwningPlayer(GetSoldUnit())),true)
                        call DisplayTimedTextToForce(udg_TempForce,10.,(("|cff00ff00Arena:|r You gain "+I2S(udg_BattlePoints[udg_TempInteger]))+" EXP."))
                    endif
                endif
                set udg_BattlePoints[udg_TempInteger]=0
            endif
        endif
        call DestroyTextTagBJ(udg_ArenaBpTag[udg_TempInteger])
        set udg_ArenaBpTag[udg_TempInteger]=CreateTextTagUnitBJ(("Current BP: |cffffcc00"+(I2S(udg_BattlePoints[udg_TempInteger])+"|r")),gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
    endif
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Arena_RefreshBPTags_ShowBPTag takes nothing returns nothing
    call DestroyTextTagBJ(udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())])
    set udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())]=CreateTextTagUnitBJ(("Current BP: |cffffcc00"+(I2S(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())])+"|r")),gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_TempForce)
    call DestroyForce(udg_TempForce)
endfunction

function Trig_Arena_RefreshBPTags_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Arena_RefreshBPTags_ShowBPTag)
endfunction

function InitTrig_Arena_Rewards takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2, RegisterTriggers_Arena_Part3 (module Arena),
// which keeps the original registration order.

function Register_Arena_BuyPrize takes nothing returns nothing
    set gg_trg_Arena_BuyPrize=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_BuyPrize,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Arena_BuyPrize,Condition(function Trig_Arena_BuyPrize_Conditions))
    call TriggerAddAction(gg_trg_Arena_BuyPrize,function Trig_Arena_BuyPrize_Actions)
endfunction

function Register_Arena_ExchangeBP takes nothing returns nothing
    set gg_trg_Arena_ExchangeBP=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_ExchangeBP,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Arena_ExchangeBP,Condition(function Trig_Arena_ExchangeBP_Conditions))
    call TriggerAddAction(gg_trg_Arena_ExchangeBP,function Trig_Arena_ExchangeBP_Actions)
endfunction

function Register_Arena_RefreshBPTags takes nothing returns nothing
    set gg_trg_Arena_RefreshBPTags=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_RefreshBPTags)
    call TriggerAddAction(gg_trg_Arena_RefreshBPTags,function Trig_Arena_RefreshBPTags_Actions)
endfunction

endlibrary

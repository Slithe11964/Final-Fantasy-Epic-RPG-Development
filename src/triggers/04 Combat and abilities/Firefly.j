library TFirefly requires TForce, TPlayerPart01
function Trig_Firefly_Drops_Cond_DropDue takes nothing returns boolean
    // Calculation 1:
    // The remainder after dividing (udg_FireflyDestCount) by (2).
    // Calculation 2:
    // (9) minus ((udg_FireflyDestCount) divided by (2); drop the remainder).
    return(ModuloInteger(udg_FireflyDestCount,2)==0)and(CountPlayersInForceBJ(udg_PlayingPlayers)>=(9-(udg_FireflyDestCount/ 2)))
endfunction

function Trig_Firefly_Drops_Cond_LastFirefly takes nothing returns boolean
    return(udg_FireflyDestCount>=16)
endfunction

function Trig_Firefly_Drops_Actions takes nothing returns nothing
    set udg_FireflyDestCount=(udg_FireflyDestCount+1)
    set udg_MonographDropped=true
    if(Trig_Firefly_Drops_Cond_LastFirefly())then
        call DisableTrigger(GetTriggeringTrigger())
        set udg_TempPoint=GetDestructableLoc(GetDyingDestructable())
        call CreateItemLoc('I0KA',udg_TempPoint) // 'I0KA': item "Firefly"
        call RemoveLocation(udg_TempPoint)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        if(Trig_Firefly_Drops_Cond_DropDue())then
            set udg_TempPoint=GetDestructableLoc(GetDyingDestructable())
            call CreateItemLoc('I0KA',udg_TempPoint) // 'I0KA': item "Firefly"
            call RemoveLocation(udg_TempPoint)
        endif
    endif
endfunction

function Trig_Firefly_Redeem_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A01S') // 'A01S': ability "Firefly Redeem"
endfunction

function Trig_Firefly_Redeem_Cond_HasStoredExp takes nothing returns boolean
    return(udg_BankedXP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>.0)
endfunction

function Trig_Firefly_Redeem_Cond_RedeemConfirmed takes nothing returns boolean
    return(TimerGetRemaining(udg_ExpBankTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])>.0)
endfunction

function Trig_Firefly_Redeem_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Firefly_Redeem_Cond_RedeemConfirmed())then
        // (udg_BankedXP at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit))) with its decimal part
        // removed.
        call DisplayTimedTextToForce(udg_TempForce,10.,("|cffffcc00You get "+(I2S(R2I(udg_BankedXP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))+" exp.|r")))
        call DestroyForce(udg_TempForce)
        // Result 1: (udg_BankedXP at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit))) times
        // (udg_SecondaryXPRate).
        // Result 2: (result 1) with its decimal part removed.
        call AddHeroXPSwapped(R2I((udg_BankedXP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*udg_SecondaryXPRate)),udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
        // (udg_BankedXP at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit))) with its decimal part
        // removed.
        call AddHeroXPSwapped(R2I(udg_BankedXP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),Player_GetHero(GetOwningPlayer(GetTriggerUnit())),true)
        set udg_BankedXP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=.0
        call StartTimerBJ(udg_ExpBankTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,.01)
    else
        if(Trig_Firefly_Redeem_Cond_HasStoredExp())then
            // (udg_BankedXP at position GetConvertedPlayerId(GetOwningPlayer(the triggering unit))) with its decimal part
            // removed.
            call DisplayTimedTextToForce(udg_TempForce,5.,("You can redeem "+(I2S(R2I(udg_BankedXP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))+" exp from the Firefly onto your current hero. Use it again to proceed.")))
            call StartTimerBJ(udg_ExpBankTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,6.)
        else
            call DisplayTimedTextToForce(udg_TempForce,5.,"The Firefly currently holds no exp to redeem.")
        endif
        call DestroyForce(udg_TempForce)
    endif
endfunction

// World Editor calls InitTrig_Firefly automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Firefly (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Firefly takes nothing returns nothing
endfunction

function Register_Firefly_Drops takes nothing returns nothing
    set gg_trg_Firefly_Drops=CreateTrigger()
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbx_0008)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbx_0017)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0002)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0003)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbx_0004)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbs_0060)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0062)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0061)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbs_0006)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbs_0063)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0064)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0065)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbr_0009)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTbx_0015)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0066)
    call TriggerRegisterDeathEvent(gg_trg_Firefly_Drops,gg_dest_LTcr_0067)
    call TriggerAddAction(gg_trg_Firefly_Drops,function Trig_Firefly_Drops_Actions)
endfunction

function Register_Firefly_Redeem takes nothing returns nothing
    set gg_trg_Firefly_Redeem=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Firefly_Redeem,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Firefly_Redeem,Condition(function Trig_Firefly_Redeem_Conditions))
    call TriggerAddAction(gg_trg_Firefly_Redeem,function Trig_Firefly_Redeem_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Firefly takes nothing returns nothing
    call Register_Firefly_Drops()
    call Register_Firefly_Redeem()
endfunction

endlibrary

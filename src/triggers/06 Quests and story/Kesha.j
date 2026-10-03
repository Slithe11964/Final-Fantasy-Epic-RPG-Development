library TKesha requires TCam, TCine, TForce, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Kesha_Stones_Spawn=null
    trigger gg_trg_Kesha_Return_Stones=null
    trigger gg_trg_Kesha_Subscription_Toggle=null
    // Variables only this module uses.
    integer udg_ExoticStonesReturned=0
    unit udg_KeshaShop=null
endglobals

function Trig_Kesha_Stones_Spawn_Cond_SubscriptionDisabled takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_Kesha_Stones_Spawn_Actions takes nothing returns nothing
    local location l_tempPoint
    set udg_KeshaShop=ReplaceUnitBJ(gg_unit_n01C_0193,'n02W',bj_UNIT_STATE_METHOD_RELATIVE) // 'n02W': unit "Kesha's Place"
    call DisableTrigger(gg_trg_Npc_Talk_Kesha)
    call DestroyEffectBJ(udg_QuestMarkerEffect[$D]) // $D = 13
    set l_tempPoint=GetRectCenter(gg_rct_559)
    call CreateItemLoc('I03Y',l_tempPoint) // 'I03Y': item "Exotic Stone"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set l_tempPoint=GetRectCenter(gg_rct_560)
    call CreateItemLoc('I03Y',l_tempPoint) // 'I03Y': item "Exotic Stone"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set l_tempPoint=GetRectCenter(gg_rct_561)
    call CreateItemLoc('I03Y',l_tempPoint) // 'I03Y': item "Exotic Stone"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set l_tempPoint=GetRectCenter(gg_rct_562)
    call CreateItemLoc('I03Y',l_tempPoint) // 'I03Y': item "Exotic Stone"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set l_tempPoint=GetRectCenter(gg_rct_563)
    call CreateItemLoc('I03Y',l_tempPoint) // 'I03Y': item "Exotic Stone"
    call RemoveLocation(l_tempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Kesha_Return_Stones)
    if(Trig_Kesha_Stones_Spawn_Cond_SubscriptionDisabled())then
        call DisableTrigger(gg_trg_Kesha_Subscription_Toggle)
        call DestroyTrigger(gg_trg_Kesha_Subscription_Toggle)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Kesha_Return_Stones_Conditions takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I03Y'))and(udg_InCinematicMode==false) // 'I03Y': item "Exotic Stone"
endfunction

function Trig_Kesha_Return_Stones_Cond_StoneNoCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Y'))==0) // 'I03Y': item "Exotic Stone"
endfunction

function Trig_Kesha_Return_Stones_Cond_MoreStonesCarried takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I03Y'))and(udg_ExoticStonesReturned<5) // 'I03Y': item "Exotic Stone"
endfunction

function Trig_Kesha_Return_Stones_Cond_SubEnabled_Gold takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Kesha_Return_Stones_Cond_SubEnabled_Cine takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Kesha_Return_Stones_Cond_KeshaCineOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Kesha_Return_Stones_Cond_SubEnabled_Stock takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Kesha_Return_Stones_Cond_AllStonesReturned takes nothing returns boolean
    return(udg_ExoticStonesReturned==5)
endfunction

function Trig_Kesha_Return_Stones_Actions takes nothing returns nothing
    if(Trig_Kesha_Return_Stones_Cond_StoneNoCharges())then
        set udg_ExoticStonesReturned=(udg_ExoticStonesReturned+1)
    else
        // (udg_ExoticStonesReturned) plus (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I03Y')).
        set udg_ExoticStonesReturned=(udg_ExoticStonesReturned+GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Y'))) // 'I03Y': item "Exotic Stone"
    endif
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Y')) // 'I03Y': item "Exotic Stone"
    if(Trig_Kesha_Return_Stones_Cond_MoreStonesCarried())then
        call TriggerExecute(GetTriggeringTrigger())
        return
    endif
    if(Trig_Kesha_Return_Stones_Cond_AllStonesReturned())then
        call DisableTrigger(GetTriggeringTrigger())
        if(Trig_Kesha_Return_Stones_Cond_KeshaCineOn())then
            call Cine_Enter()
            call Cam_PanToUnit(gg_unit_Nsjs_0194,0)
            call Text_Say(gg_unit_Nsjs_0194,"Excellent! Now I have all Exotic Stones back and can create my special brew again. Take this as reward.",false)
            if(Trig_Kesha_Return_Stones_Cond_SubEnabled_Cine())then
                call Reward_Give(500,0,gg_unit_Nsjs_0194)
                call Text_Say(gg_unit_Nsjs_0194,"|n|cffffcc00The adventurers can now subscribe to Kesha.|r",true)
            else
                call Reward_Give($7D0,0,gg_unit_Nsjs_0194) // $7D0 = 2000
            endif
            call Cine_ExitAction()
        else
            if(Trig_Kesha_Return_Stones_Cond_SubEnabled_Gold())then
                call Reward_Give(500,0,gg_unit_Nsjs_0194)
                call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00The adventurers can now subscribe to Kesha.|r")
            else
                call Reward_Give($7D0,0,gg_unit_Nsjs_0194) // $7D0 = 2000
            endif
        endif
        call ReplaceUnitBJ(udg_KeshaShop,'n01C',bj_UNIT_STATE_METHOD_RELATIVE) // 'n01C': unit "Kesha's Place"
        if(Trig_Kesha_Return_Stones_Cond_SubEnabled_Stock())then
            call AddItemToStockBJ('I0A5',GetLastReplacedUnitBJ(),1,1) // 'I0A5': item "Kesha Subscription"
        endif
        set udg_NewsText[3]=udg_NewsText[2]
        set udg_NewsText[2]=udg_NewsText[1]
        set udg_NewsText[6]=udg_NewsText[5]
        set udg_NewsText[5]=udg_NewsText[4]
        set udg_NewsText[1]="|cffffcc00Exotic Stones Returned|r"
        set udg_NewsText[4]="The adventurers have returned all Exotic Stones Kesha had lost because of a thief. Now, he can create his special brew again!"
        call DestroyTrigger(GetTriggeringTrigger())
    else
        call CreateTextTagUnitBJ("|cffffcc00Kesha|r: Thanks for bringing me Exotic Stone! But there are more left.",gg_unit_Nsjs_0194,0,$A,'d','d','d',0) // $A = 10
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),10.)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),8.5)
    endif
endfunction

function Trig_Kesha_Subscription_Toggle_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0A5')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'I0A5': item "Kesha Subscription"
endfunction

function Trig_Kesha_Subscription_Toggle_Cond_IsSubscribed takes nothing returns boolean
    return(udg_AutoBrewEnabled[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_Kesha_Subscription_Toggle_Cond_NotArmsCompletionist takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[56])==false)
endfunction

function Trig_Kesha_Subscription_Toggle_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Kesha_Subscription_Toggle_Cond_NotArmsCompletionist())then
        if(Trig_Kesha_Subscription_Toggle_Cond_IsSubscribed())then
            set udg_AutoBrewEnabled[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
            call DisplayTimedTextToForce(l_tempForce,8.,"Your subscription to Kesha has been cancelled.")
        else
            set udg_AutoBrewEnabled[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
            call DisplayTimedTextToForce(l_tempForce,8.,"You are now subscribed to Kesha. Upon death you will automatically buy a Kesha's Special Brew.")
        endif
    else
        call DisplayTimedTextToForce(l_tempForce,8.,"You cannot subscribe to Kesha as an Arms Completionist.")
    endif
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_Kesha automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Kesha (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Kesha takes nothing returns nothing
endfunction

function Register_Kesha_Stones_Spawn takes nothing returns nothing
    set gg_trg_Kesha_Stones_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Kesha_Stones_Spawn)
    call TriggerAddAction(gg_trg_Kesha_Stones_Spawn,function Trig_Kesha_Stones_Spawn_Actions)
endfunction

function Register_Kesha_Return_Stones takes nothing returns nothing
    set gg_trg_Kesha_Return_Stones=CreateTrigger()
    call DisableTrigger(gg_trg_Kesha_Return_Stones)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Kesha_Return_Stones,250.,gg_unit_Nsjs_0194)
    call TriggerAddCondition(gg_trg_Kesha_Return_Stones,Condition(function Trig_Kesha_Return_Stones_Conditions))
    call TriggerAddAction(gg_trg_Kesha_Return_Stones,function Trig_Kesha_Return_Stones_Actions)
endfunction

function Register_Kesha_Subscription_Toggle takes nothing returns nothing
    set gg_trg_Kesha_Subscription_Toggle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Kesha_Subscription_Toggle,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Kesha_Subscription_Toggle,Condition(function Trig_Kesha_Subscription_Toggle_Conditions))
    call TriggerAddAction(gg_trg_Kesha_Subscription_Toggle,function Trig_Kesha_Subscription_Toggle_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Kesha takes nothing returns nothing
    call Register_Kesha_Stones_Spawn() // starts off; run by News
    call Register_Kesha_Return_Stones() // starts off; enabled by Kesha
    call Register_Kesha_Subscription_Toggle() // disabled by Kesha; destroyed by Kesha
endfunction

endlibrary

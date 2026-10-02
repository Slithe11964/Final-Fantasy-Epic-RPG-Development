library TClaim requires TForce, TPlayerPart01
function Trig_Claim_Command_Conditions takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)>1)
endfunction

function Trig_Claim_Command_Cond_HeroHoldsMyItem takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(Player_GetHero(GetEnumPlayer()),udg_SlotIndex))==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Claim_Command_Cond_GayaHoldsMyItem takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],udg_SlotIndex))==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Claim_Command_Cond_HouseHoldsMyItem takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_PlayerHouse[GetConvertedPlayerId(GetEnumPlayer())],udg_SlotIndex))==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Claim_Command_Cond_NotTheClaimer takes nothing returns boolean
    return(GetEnumPlayer()!=GetTriggerPlayer())
endfunction

function Trig_Claim_Command_ClaimItemsFromPlayer takes nothing returns nothing
    if(Trig_Claim_Command_Cond_NotTheClaimer())then
        set udg_SlotIndex=1
        loop
            exitwhen udg_SlotIndex>6
            if(Trig_Claim_Command_Cond_HeroHoldsMyItem())then
                call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,Player_GetHero(GetEnumPlayer()))
                set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
                call DisplayTextToForce(udg_TempForce,(("Item "+GetItemName(GetLastRemovedItem()))+" has been claimed and transported to your House."))
                call DestroyForce(udg_TempForce)
                set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
                call DisplayTextToForce(udg_TempForce,(("An item you were carrying "+GetItemName(GetLastRemovedItem()))+(" was claimed by its owner "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+"!"))))
                call DestroyForce(udg_TempForce)
                set udg_TempPoint=GetRandomLocInRect(udg_PlayerStartRect[GetConvertedPlayerId(GetTriggerPlayer())])
                call SetItemPositionLoc(GetLastRemovedItem(),udg_TempPoint)
                call RemoveLocation(udg_TempPoint)
                call UnitAddItemSwapped(GetLastRemovedItem(),udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())])
            endif
            if(Trig_Claim_Command_Cond_GayaHoldsMyItem())then
                call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])
                set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
                call DisplayTextToForce(udg_TempForce,(("Item "+GetItemName(GetLastRemovedItem()))+" has been claimed and transported to your House."))
                call DestroyForce(udg_TempForce)
                set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
                call DisplayTextToForce(udg_TempForce,(("An item you were carrying "+GetItemName(GetLastRemovedItem()))+(" was claimed by its owner "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+"!"))))
                call DestroyForce(udg_TempForce)
                set udg_TempPoint=GetRandomLocInRect(udg_PlayerStartRect[GetConvertedPlayerId(GetTriggerPlayer())])
                call SetItemPositionLoc(GetLastRemovedItem(),udg_TempPoint)
                call RemoveLocation(udg_TempPoint)
                call UnitAddItemSwapped(GetLastRemovedItem(),udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())])
            endif
            if(Trig_Claim_Command_Cond_HouseHoldsMyItem())then
                call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,udg_PlayerHouse[GetConvertedPlayerId(GetEnumPlayer())])
                set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
                call DisplayTextToForce(udg_TempForce,(("Item "+GetItemName(GetLastRemovedItem()))+" has been claimed and transported to your House."))
                call DestroyForce(udg_TempForce)
                set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
                call DisplayTextToForce(udg_TempForce,(("An item you were carrying "+GetItemName(GetLastRemovedItem()))+(" was claimed by its owner "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+"!"))))
                call DestroyForce(udg_TempForce)
                set udg_TempPoint=GetRandomLocInRect(udg_PlayerStartRect[GetConvertedPlayerId(GetTriggerPlayer())])
                call SetItemPositionLoc(GetLastRemovedItem(),udg_TempPoint)
                call RemoveLocation(udg_TempPoint)
                call UnitAddItemSwapped(GetLastRemovedItem(),udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())])
            endif
            set udg_SlotIndex=udg_SlotIndex+1
        endloop
    endif
endfunction

function Trig_Claim_Command_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Claim_Command_ClaimItemsFromPlayer)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Claim takes nothing returns nothing
endfunction

function RegisterR11_Claim_Command takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Claim_Command=CreateTrigger()

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(0),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(1),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(2),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(3),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(4),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(5),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(6),"-claim",true)

call TriggerRegisterPlayerChatEvent(gg_trg_Claim_Command,Player(7),"-claim",true)

call TriggerAddCondition(gg_trg_Claim_Command,Condition(function Trig_Claim_Command_Conditions))

call TriggerAddAction(gg_trg_Claim_Command,function Trig_Claim_Command_Actions)

endfunction




endlibrary

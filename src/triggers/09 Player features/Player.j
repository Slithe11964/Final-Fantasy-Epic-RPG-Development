library TPlayer requires TDifficulty, TForce, TGroup, TJob, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Player_Init=null
    trigger gg_trg_Player_Leaves_Game=null
endglobals

function Trig_Player_Init_StripTag takes string l_name returns string
    local integer i=0
    local integer l_len=StringLength(l_name)
    local string l_ch=""
    local string l_out=""
    loop
        set l_ch=SubString(l_name,i,i+1)
        if(l_ch=="#")then
            return l_out
        else
            set l_out=l_out+l_ch
        endif
        set i=i+1
        exitwhen i>=l_len
    endloop
    return l_out
endfunction

function Trig_Player_Init_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Player_Init_SetupPlayer takes nothing returns nothing
    local group l_tempGroup
    local location l_tempPoint
    set l_tempGroup=Group_UnitsOfPlayerAndType(GetEnumPlayer(),'h006') // 'h006': unit "House"
    set udg_PlayerHouse[GetConvertedPlayerId(GetEnumPlayer())]=GroupPickRandomUnit(l_tempGroup)
    call DestroyGroup(l_tempGroup)
    set udg_PlayerName[GetPlayerId(GetEnumPlayer())+1]=Trig_Player_Init_StripTag(GetPlayerName(GetEnumPlayer()))
    if(Trig_Player_Init_CoinFlip())then
        set udg_PlayerHero[GetPlayerId(GetEnumPlayer())+1]=Job_GetHero(GetEnumPlayer(),'H000') // 'H000': unit "Squire"
    else
        set udg_PlayerHero[GetPlayerId(GetEnumPlayer())+1]=Job_GetHero(GetEnumPlayer(),'H002') // 'H002': unit "Chemist"
    endif
    call SetUnitInvulnerable(Player_GetHero(GetEnumPlayer()),true)
    call SetUnitPathing(Player_GetHero(GetEnumPlayer()),true)
    set l_tempPoint=GetRectCenter(udg_PlayerStartRect[GetConvertedPlayerId(GetEnumPlayer())])
    call SetUnitPositionLoc(Player_GetHero(GetEnumPlayer()),l_tempPoint)
    call PanCameraToTimedLocForPlayer(GetEnumPlayer(),l_tempPoint,0)
    call RemoveLocation(l_tempPoint)
    call UnitShareVisionBJ(true,Player_GetHero(GetEnumPlayer()),Player(9))
    set l_tempGroup=null
    set l_tempPoint=null
endfunction

function Trig_Player_Init_ShareHouseVision takes nothing returns nothing
    call UnitShareVisionBJ(true,udg_PlayerHouse[GetForLoopIndexA()],GetEnumPlayer())
endfunction

function Trig_Player_Init_IsSlotEmpty takes nothing returns boolean
    return(IsPlayerInForce(ConvertedPlayer(GetForLoopIndexA()),udg_PlayingPlayers)==false)
endfunction

function Trig_Player_Init_Actions takes nothing returns nothing
    set udg_PlayerStartRect[1]=gg_rct_355
    set udg_PlayerStartRect[2]=gg_rct_356
    set udg_PlayerStartRect[3]=gg_rct_357
    set udg_PlayerStartRect[4]=gg_rct_358
    set udg_PlayerStartRect[5]=gg_rct_359
    set udg_PlayerStartRect[6]=gg_rct_360
    set udg_PlayerStartRect[7]=gg_rct_361
    set udg_PlayerStartRect[8]=gg_rct_362
    call ForForce(udg_PlayingPlayers,function Trig_Player_Init_SetupPlayer)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Player_Init_IsSlotEmpty())then
            set udg_TempGroup=Group_UnitsOfPlayerAndType(ConvertedPlayer(GetForLoopIndexA()),'h006') // 'h006': unit "House"
            set udg_PlayerHouse[GetForLoopIndexA()]=GroupPickRandomUnit(udg_TempGroup)
            call DestroyGroup(udg_TempGroup)
            call UnitRemoveAbilityBJ('AInv',udg_PlayerHouse[GetForLoopIndexA()]) // 'AInv': standard ability reference "Inventory"
            call SetUnitOwner(udg_PlayerHouse[GetForLoopIndexA()],Player(9),true)
            call ForForce(udg_PlayingPlayers,function Trig_Player_Init_ShareHouseVision)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call StartTimerBJ(udg_SpiritSpawnTimer,false,1.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Player_Leaves_Game_HasHero takes nothing returns boolean
    return(Player_GetHero(GetTriggerPlayer())!=null)
endfunction

function Trig_Player_Leaves_Game_HeroSlotItemIsLeavers takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(Player_GetHero(GetEnumPlayer()),udg_SlotIndex))==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Player_Leaves_Game_AltSlotItemIsLeavers takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())],udg_SlotIndex))==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Player_Leaves_Game_HouseSlotItemIsLeavers takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_PlayerHouse[GetConvertedPlayerId(GetEnumPlayer())],udg_SlotIndex))==GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Player_Leaves_Game_IsOtherPlayer takes nothing returns boolean
    return(GetEnumPlayer()!=GetTriggerPlayer())
endfunction

function Trig_Player_Leaves_Game_RemoveLeaverItems takes nothing returns nothing
    if(Trig_Player_Leaves_Game_IsOtherPlayer())then
        set udg_SlotIndex=1
        loop
            exitwhen udg_SlotIndex>6
            if(Trig_Player_Leaves_Game_HeroSlotItemIsLeavers())then
                call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,Player_GetHero(GetEnumPlayer()))
                set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
                call DisplayTextToForce(udg_TempForce,(("An item you were carrying "+GetItemName(GetLastRemovedItem()))+" was removed since its owner left the game."))
                call DestroyForce(udg_TempForce)
                call RemoveItem(GetLastRemovedItem())
            endif
            if(Trig_Player_Leaves_Game_AltSlotItemIsLeavers())then
                call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())])
                set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
                call DisplayTextToForce(udg_TempForce,(("An item you were carrying "+GetItemName(GetLastRemovedItem()))+" was removed since its owner left the game."))
                call DestroyForce(udg_TempForce)
                call RemoveItem(GetLastRemovedItem())
            endif
            if(Trig_Player_Leaves_Game_HouseSlotItemIsLeavers())then
                call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,udg_PlayerHouse[GetConvertedPlayerId(GetEnumPlayer())])
                set udg_TempForce=Force_OfPlayer(GetEnumPlayer())
                call DisplayTextToForce(udg_TempForce,(("An item you were carrying "+GetItemName(GetLastRemovedItem()))+" was removed since its owner left the game."))
                call DestroyForce(udg_TempForce)
                call RemoveItem(GetLastRemovedItem())
            endif
            set udg_SlotIndex=udg_SlotIndex+1
        endloop
    endif
endfunction

function Trig_Player_Leaves_Game_HeroSlotItemNotLeavers takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(Player_GetHero(GetTriggerPlayer()),udg_SlotIndex))!=GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Player_Leaves_Game_AltSlotItemNotLeavers takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetTriggerPlayer())],udg_SlotIndex))!=GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Player_Leaves_Game_HouseSlotItemNotLeavers takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())],udg_SlotIndex))!=GetConvertedPlayerId(GetTriggerPlayer()))
endfunction

function Trig_Player_Leaves_Game_RemoveSummonedUnit takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Player_Leaves_Game_ShareHouseVision takes nothing returns nothing
    call UnitShareVisionBJ(true,udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())],GetEnumPlayer())
endfunction

function Trig_Player_Leaves_Game_HasPendingEvent takes nothing returns boolean
    return(udg_PendingEventCount>0)
endfunction

function Trig_Player_Leaves_Game_Actions takes nothing returns nothing
    call DisplayTextToForce(GetPlayersAll(),(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+" has left the game."))
    call SetPlayerName(GetTriggerPlayer(),("Left game ("+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+")")))
    if(Trig_Player_Leaves_Game_HasHero())then
        set udg_TempPoint=GetUnitLoc(Player_GetHero(GetTriggerPlayer()))
        call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,10.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',50.,75.)
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=GetRectCenter(udg_PlayerStartRect[GetConvertedPlayerId(GetTriggerPlayer())])
        call SetUnitPositionLoc(Player_GetHero(GetTriggerPlayer()),udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
    endif
    call ForForce(udg_PlayingPlayers,function Trig_Player_Leaves_Game_RemoveLeaverItems)
    set udg_SlotIndex=1
    loop
        exitwhen udg_SlotIndex>6
        if(Trig_Player_Leaves_Game_HeroSlotItemNotLeavers())then
            call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,Player_GetHero(GetTriggerPlayer()))
        endif
        if(Trig_Player_Leaves_Game_AltSlotItemNotLeavers())then
            call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,udg_SpiritOfGaya[GetConvertedPlayerId(GetTriggerPlayer())])
        endif
        if(Trig_Player_Leaves_Game_HouseSlotItemNotLeavers())then
            call UnitRemoveItemFromSlotSwapped(udg_SlotIndex,udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())])
        endif
        set udg_SlotIndex=udg_SlotIndex+1
    endloop
    call UnitRemoveAbilityBJ('AInv',udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())]) // 'AInv': standard ability reference "Inventory"
    call SetUnitOwner(udg_PlayerHouse[GetConvertedPlayerId(GetTriggerPlayer())],Player(9),true)
    call ForGroupBJ(Group_AllUnitsOfPlayer(GetTriggerPlayer()),function Trig_Player_Leaves_Game_RemoveSummonedUnit)
    call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_PlayingPlayers)
    call ForceRemovePlayerSimple(GetTriggerPlayer(),udg_ActivePlayers)
    call Difficulty_SumHandicap(udg_PlayingPlayers)
    call SetPlayerHandicapBJ(Player($B),udg_EnemyHandicap) // $B = 11
    call ForForce(udg_PlayingPlayers,function Trig_Player_Leaves_Game_ShareHouseVision)
    if(Trig_Player_Leaves_Game_HasPendingEvent())then
        call TriggerExecute(gg_trg_Multiboard_Create)
    endif
endfunction

// World Editor calls InitTrig_Player automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Player_Part1 / RegisterTriggers_Player_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Player takes nothing returns nothing
endfunction

function Register_Player_Init takes nothing returns nothing
    set gg_trg_Player_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Player_Init,function Trig_Player_Init_Actions)
endfunction

function Register_Player_Leaves_Game takes nothing returns nothing
    set gg_trg_Player_Leaves_Game=CreateTrigger()
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(0))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(1))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(2))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(3))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(4))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(5))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(6))
    call TriggerRegisterPlayerEventLeave(gg_trg_Player_Leaves_Game,Player(7))
    call TriggerAddAction(gg_trg_Player_Leaves_Game,function Trig_Player_Leaves_Game_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Player_Part1 takes nothing returns nothing
    call Register_Player_Init() // run by Init
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Player_Part2 takes nothing returns nothing
    call Register_Player_Leaves_Game()
endfunction

endlibrary

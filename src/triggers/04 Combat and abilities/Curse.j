library TCurse requires TCraft, TPlayerPart01
globals
    // Variables only this module uses (MapBootstrap sets some starting values).
    trigger udg_CurseItemTrigger=null
endglobals

function Curse_CondIsCurseItem takes nothing returns boolean
    return SubString(GetItemName(GetManipulatedItem()),0,7)=="Curse: "
endfunction

function Curse_UseItem takes nothing returns nothing
    local unit u=GetManipulatingUnit()
    local item i=GetManipulatedItem()
    local string l_itemName=GetItemName(i)
    local string l_curseName=SubString(l_itemName,7,StringLength(l_itemName))
    if not IsUnitInRangeXY(Player_GetHero(GetOwningPlayer(u)),GetRectCenterX(gg_rct_227),GetRectCenterY(gg_rct_227),300)then
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,8,"|cFFFF0000You have to go to Lady Curse to curse an item!|r")
        return
    endif
    if Trig_Craft_Recipe_MakeRecipe(l_curseName,u)then
        call RemoveItem(i)
        call DisplayTimedTextToPlayer(GetOwningPlayer(u),0,0,$F,"You cursed "+l_curseName+"!") // $F = 15
    endif
    set u=null
    set i=null
    set l_itemName=null
    set l_curseName=null
endfunction

function Curse_Init takes nothing returns nothing
    local integer i=0
    set udg_CurseItemTrigger=CreateTrigger()
    loop
        call TriggerRegisterPlayerUnitEvent(udg_CurseItemTrigger,Player(i),EVENT_PLAYER_UNIT_USE_ITEM,null)
        exitwhen i==7
        set i=i+1
    endloop
    call TriggerAddCondition(udg_CurseItemTrigger,Condition(function Curse_CondIsCurseItem))
    call TriggerAddAction(udg_CurseItemTrigger,function Curse_UseItem)
endfunction

function InitTrig_Curse takes nothing returns nothing
endfunction

endlibrary

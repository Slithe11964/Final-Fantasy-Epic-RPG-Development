// Shared gameplay only: each visitor uses their own shop and navigation state.
function Armory_CheckCompletion takes player owner returns nothing
    local integer i=1
    local integer total=0
    local integer collected=0
    local player previous=udg_TempPlayer
    local integer previousTitle=udg_TempInteger
    if IsPlayerInForce(owner,udg_TitleForce[56]) or not IsPlayerInForce(owner,udg_TitleForce[35]) then
        set previous=null
        return
    endif
    loop
        exitwhen i>udg_SaveFlagCount
        if ArmoryMissingUnit[i]!=0 then
            set total=total+1
            if IsPlayerInForce(owner,udg_SaveFlagForce[i]) then
                set collected=collected+1
            endif
        endif
        set i=i+1
    endloop
    if total==280 and collected==280 then
        set udg_TempPlayer=owner
        set udg_TempInteger=56
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
    set udg_TempPlayer=previous
    set udg_TempInteger=previousTitle
    set previous=null
endfunction

function Armory_VisitHouse takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit house=GetTriggerUnit()
    local integer visitor=GetPlayerId(viewer)+1
    local integer owner=GetPlayerId(GetOwningPlayer(house))+1
    local unit hero=Player_GetHero(viewer)
    local unit shop
    if visitor<1 or visitor>8 or owner<1 or owner>8 or visitor==owner or house!=udg_PlayerHouse[owner] or hero==null or not IsPlayerInForce(Player(owner-1),udg_TitleForce[35]) then
        set viewer=null
        set house=null
        set hero=null
        return
    endif
    set shop=udg_ArmoryUnit[visitor]
    if shop==null then
        set shop=CreateUnit(viewer,'e01G',GetUnitX(house),GetUnitY(house),270.)
        set udg_ArmoryUnit[visitor]=shop
        call Collection_ForceAddPlayerSimple(viewer,udg_SaveFlagForce[0])
    endif
    call SetUnitPosition(shop,GetUnitX(house),GetUnitY(house))
    set ArmoryViewOwner[visitor]=owner
    call SetUnitVertexColor(shop,255,255,255,0)
    call ShowUnit(shop,true)
    call Armory_ShowCategory(shop,0)
    call SelectUnitForPlayerSingle(shop,viewer)
    call DisplayTimedTextToPlayer(viewer,0,0,8,"Viewing "+GetPlayerName(Player(owner-1))+"'s armory (read only).")
    set shop=null
    set hero=null
    set house=null
    set viewer=null
endfunction

function Armory_RegisterVisits takes nothing returns nothing
    local trigger selection=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(selection,EVENT_PLAYER_UNIT_SELECTED)
    call TriggerAddAction(selection,function Armory_VisitHouse)
    set selection=null
endfunction

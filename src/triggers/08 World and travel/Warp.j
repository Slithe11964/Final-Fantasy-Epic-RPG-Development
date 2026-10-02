library TWarp requires TPlayerHero, TQuestScorchingTravel, TTravel
function Warp_CondIsHero takes nothing returns boolean
    return GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit()))
endfunction

function Warp_HideDialog takes nothing returns nothing
    call DialogDisplay(GetEnumPlayer(),udg_WarpDialog,false)
endfunction

function Warp_OnEnterPoint takes nothing returns nothing
    local integer i=1
    local integer j=0
    local unit triggeringUnit=GetTriggerUnit()
    loop
        exitwhen i>udg_TravelCount
        if IsUnitInRegion(udg_TravelRegion[i],triggeringUnit)then
            if udg_WarpUnlocked[i]==false then
                set udg_WarpUnlocked[i]=true
                call ForForce(udg_PlayingPlayers,function Warp_HideDialog)
                set udg_WarpEffect[i]=AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl",udg_TravelX[i],udg_TravelY[i])
                call Trig_Quest_52_Scorching_TravelDialog_Rebuild()
            endif
            call DialogDisplay(GetOwningPlayer(triggeringUnit),udg_WarpDialog,true)
            call IssueImmediateOrderById(triggeringUnit,$D0019) // $D0019 = 851993
            set triggeringUnit=null
            return
        endif
        set i=i+1
    endloop
    set triggeringUnit=null
endfunction

function Warp_Init takes nothing returns nothing
    local integer i=1
    set udg_WarpEnterTrigger=CreateTrigger()
    call Travel_InitDestinations()
    loop
        exitwhen i>udg_TravelCount
        call TriggerRegisterEnterRegion(udg_WarpEnterTrigger,udg_TravelRegion[i],null)
        set i=i+1
    endloop
    call TriggerAddCondition(udg_WarpEnterTrigger,Condition(function Warp_CondIsHero))
    call TriggerAddAction(udg_WarpEnterTrigger,function Warp_OnEnterPoint)
endfunction

function InitTrig_Warp takes nothing returns nothing
endfunction

endlibrary

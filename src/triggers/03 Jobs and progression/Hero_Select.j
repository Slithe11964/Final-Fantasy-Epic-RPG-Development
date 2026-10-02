library THeroSelect requires TPlayerPart01
function Trig_Hero_Select_Redirect_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==Player_GetHero(GetTriggerPlayer()))and(udg_GatherState[GetConvertedPlayerId(GetTriggerPlayer())]>=2)
endfunction

function Trig_Hero_Select_Redirect_Actions takes nothing returns nothing
    call SelectUnitForPlayerSingle(udg_FishingControls[GetConvertedPlayerId(GetTriggerPlayer())],GetTriggerPlayer())
endfunction

function InitTrig_Hero_Select takes nothing returns nothing
endfunction

endlibrary

library TTransport
function Trig_Transport_HeroLoaded_Conditions takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Transport_HeroLoaded_Actions takes nothing returns nothing
    set udg_PlayerTransport[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetTransportUnitBJ()
    set udg_TempPoint=GetRectCenter(udg_PlayerStartRect[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Transport takes nothing returns nothing
endfunction

function RegisterR11_Transport_HeroLoaded takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Transport_HeroLoaded=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Transport_HeroLoaded,EVENT_PLAYER_UNIT_LOADED)

call TriggerAddCondition(gg_trg_Transport_HeroLoaded,Condition(function Trig_Transport_HeroLoaded_Conditions))

call TriggerAddAction(gg_trg_Transport_HeroLoaded,function Trig_Transport_HeroLoaded_Actions)

endfunction




endlibrary

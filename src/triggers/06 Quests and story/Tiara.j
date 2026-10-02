library TTiara
function Trig_Tiara_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[22]!=null)
endfunction

function Trig_Tiara_Ping_Cond_TiaraCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[22]))
endfunction

function Trig_Tiara_Ping_Actions takes nothing returns nothing
    if(Trig_Tiara_Ping_Cond_TiaraCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_u007_0128)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[22])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Tiara takes nothing returns nothing
endfunction

function RegisterR11_Tiara_Ping takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Tiara_Ping=CreateTrigger()

call DisableTrigger(gg_trg_Tiara_Ping)

call TriggerRegisterTimerEventPeriodic(gg_trg_Tiara_Ping,15.)

call TriggerAddCondition(gg_trg_Tiara_Ping,Condition(function Trig_Tiara_Ping_Conditions))

call TriggerAddAction(gg_trg_Tiara_Ping,function Trig_Tiara_Ping_Actions)

endfunction




endlibrary

library TExdeath
function Trig_Exdeath_Drop_Scroll_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0EV',udg_TempPoint) // 'I0EV': item "Spirit Scroll"
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Exdeath takes nothing returns nothing
endfunction

function RegisterR11_Exdeath_Drop_Scroll takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Exdeath_Drop_Scroll=CreateTrigger()

call TriggerAddAction(gg_trg_Exdeath_Drop_Scroll,function Trig_Exdeath_Drop_Scroll_Actions)

endfunction




endlibrary

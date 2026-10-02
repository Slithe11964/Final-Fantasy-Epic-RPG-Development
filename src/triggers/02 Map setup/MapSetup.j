library TMapSetup requires TCine
function DisableCinematicWithDestroy takes nothing returns nothing
    call Cine_Exit()
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function SLclearArray takes nothing returns nothing
    local integer i=0
    loop
        exitwhen i>udg_SaveLoadBufferMax
        set udg_SaveLoadBuffer[i]=0
        set i=i+1
    endloop
endfunction

// Owned setup helpers; bootstrap controls their original execution order.
function InitTrig_MapSetup takes nothing returns nothing
endfunction

endlibrary

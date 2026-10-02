library TGayaAppearance
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gaya_SetTint=null
endglobals

function Trig_Gaya_SetTint_Actions takes nothing returns nothing
    local integer i=1
    loop
        call SetUnitVertexColor(udg_SpiritOfGaya[i],$F2,$D8,$E5,$7F) // $F2 = 242; $D8 = 216; $E5 = 229; $7F = 127
        exitwhen i>8
        set i=i+1
    endloop
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Gaya_Appearance takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Gaya (module Gaya),
// which keeps the original registration order.

function Register_Gaya_SetTint takes nothing returns nothing
    set gg_trg_Gaya_SetTint=CreateTrigger()
    call TriggerRegisterTimerEvent(gg_trg_Gaya_SetTint,5,false)
    call TriggerAddAction(gg_trg_Gaya_SetTint,function Trig_Gaya_SetTint_Actions)
endfunction

endlibrary

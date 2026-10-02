library TGayaAppearance
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

endlibrary

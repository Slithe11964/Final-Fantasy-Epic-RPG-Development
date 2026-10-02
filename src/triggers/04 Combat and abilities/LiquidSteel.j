library TLiquidSteel
function LiquidSteel_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_LiquidSteelActiveCount=udg_LiquidSteelActiveCount-1
    set udg_LiquidSteelList[udg_LiquidSteelIndex[l_idx]]=udg_LiquidSteelList[udg_LiquidSteelActiveCount]
    set udg_LiquidSteelIndex[udg_LiquidSteelList[udg_LiquidSteelIndex[l_idx]]]=udg_LiquidSteelIndex[l_idx]
    call DestroyEffect(udg_LiquidSteelEffect[l_idx])
    call RemoveUnit(gg_unit_h020_0272[l_idx])
    return true
endfunction

function InitTrig_LiquidSteel takes nothing returns nothing
endfunction

endlibrary

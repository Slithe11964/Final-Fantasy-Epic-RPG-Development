library TClione
function Clione_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_ClioneActiveCount=udg_ClioneActiveCount-1
    set udg_ClioneList[udg_ClioneIndex[l_idx]]=udg_ClioneList[udg_ClioneActiveCount]
    set udg_ClioneIndex[udg_ClioneList[udg_ClioneIndex[l_idx]]]=udg_ClioneIndex[l_idx]
    if udg_InCinematicMode==false then
    endif
    return true
endfunction

function InitTrig_Clione takes nothing returns nothing
endfunction

endlibrary

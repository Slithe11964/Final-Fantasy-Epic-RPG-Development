library TRapidFire
function RapidFire_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_RapidFireActiveCount=udg_RapidFireActiveCount-1
    set udg_RapidFireList[udg_RapidFireIndex[l_idx]]=udg_RapidFireList[udg_RapidFireActiveCount]
    set udg_RapidFireIndex[udg_RapidFireList[udg_RapidFireIndex[l_idx]]]=udg_RapidFireIndex[l_idx]
    call ResetUnitAnimation(udg_RapidFireShooter[l_idx])
    return true
endfunction

function InitTrig_RapidFire takes nothing returns nothing
endfunction

endlibrary

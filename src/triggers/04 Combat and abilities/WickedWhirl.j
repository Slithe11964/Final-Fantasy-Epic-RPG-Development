library TWickedWhirl
function WickedWhirl_Damage takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local unit u
    loop
        set u=FirstOfGroup(udg_WickedWhirlGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_WickedWhirlGroup,u)
        set udg_DamageElement=1
        call UnitDamageTarget(udg_WickedWhirlCaster[l_idx],u,7500.,true,true,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_UNIVERSAL,null)
    endloop
    return true
endfunction

function WickedWhirl_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_WickedWhirlActiveCount=udg_WickedWhirlActiveCount-1
    set udg_WickedWhirlList[udg_WickedWhirlIndex[l_idx]]=udg_WickedWhirlList[udg_WickedWhirlActiveCount]
    set udg_WickedWhirlIndex[udg_WickedWhirlList[udg_WickedWhirlIndex[l_idx]]]=udg_WickedWhirlIndex[l_idx]
    call DestroyEffect(udg_WickedWhirlEffect[l_idx])
    call RemoveUnit(gg_unit_h020_0273[l_idx])
    call ShowUnit(udg_WickedWhirlCaster[l_idx],true)
    call SetUnitInvulnerable(udg_WickedWhirlCaster[l_idx],false)
    return true
endfunction

function InitTrig_WickedWhirl takes nothing returns nothing
endfunction

endlibrary

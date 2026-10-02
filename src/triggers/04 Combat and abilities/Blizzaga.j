library TBlizzaga
function Blizzaga_Damage takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local real damageAmount=udg_ArgReal
    local unit u
    loop
        set u=FirstOfGroup(udg_BlizzagaGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_BlizzagaGroup,u)
        if IsUnitEnemy(u,udg_BlizzagaOwner[l_idx])then
            set udg_DamageElement=2
            call UnitDamageTarget(udg_BlizzagaCaster[l_idx],u,damageAmount,true,false,ATTACK_TYPE_NORMAL,DAMAGE_TYPE_MAGIC,null)
        endif
    endloop
    return true
endfunction

function Blizzaga_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_BlizzagaActiveCount=udg_BlizzagaActiveCount-1
    set udg_BlizzagaList[udg_BlizzagaIndex[l_idx]]=udg_BlizzagaList[udg_BlizzagaActiveCount]
    set udg_BlizzagaIndex[udg_BlizzagaList[udg_BlizzagaIndex[l_idx]]]=udg_BlizzagaIndex[l_idx]
    return true
endfunction

function InitTrig_Blizzaga takes nothing returns nothing
endfunction

endlibrary

library TShuriken
function Shuriken_Damage takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local unit u
    loop
        set u=FirstOfGroup(udg_ShurikenEnumGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_ShurikenEnumGroup,u)
        if not IsUnitInGroup(u,udg_ShurikenHitGroupA[l_idx])and not IsUnitInGroup(u,udg_ShurikenHitGroupB[l_idx])then
            if IsUnitEnemy(u,udg_ShurikenOwner[l_idx])then
                set udg_IsPhysicalAttack=true
                call UnitDamageTarget(udg_ShurikenCaster[l_idx],u,udg_ShurikenDamage[l_idx],true,true,ATTACK_TYPE_PIERCE,DAMAGE_TYPE_NORMAL,null)
                call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl",udg_ShurikenX[l_idx],udg_ShurikenY[l_idx]))
            endif
            // The vertical direction share for angle (udg_ShurikenAngle at position l_idx) in radians.
            if(Sin(udg_ShurikenAngle[l_idx])<0)then
                call GroupAddUnit(udg_ShurikenHitGroupA[l_idx],u)
            else
                call GroupAddUnit(udg_ShurikenHitGroupB[l_idx],u)
            endif
        endif
    endloop
    return true
endfunction

function Shuriken_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_ShurikenActiveCount=udg_ShurikenActiveCount-1
    set udg_ShurikenList[udg_ShurikenIndex[l_idx]]=udg_ShurikenList[udg_ShurikenActiveCount]
    set udg_ShurikenIndex[udg_ShurikenList[udg_ShurikenIndex[l_idx]]]=udg_ShurikenIndex[l_idx]
    call GroupClear(udg_ShurikenHitGroupA[l_idx])
    call DestroyGroup(udg_ShurikenHitGroupA[l_idx])
    call GroupClear(udg_ShurikenHitGroupB[l_idx])
    call DestroyGroup(udg_ShurikenHitGroupB[l_idx])
    call DestroyEffect(udg_ShurikenEffect[l_idx])
    call RemoveUnit(gg_unit_h020_0271[l_idx])
    return true
endfunction

function InitTrig_Shuriken takes nothing returns nothing
endfunction

endlibrary

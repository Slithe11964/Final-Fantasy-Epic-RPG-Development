library TTatsumaki requires TPath, TWave
function Tatsumaki_Pull takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local unit u
    local real cx=GetUnitX(udg_TatsumakiCaster[l_idx])
    local real cy=GetUnitY(udg_TatsumakiCaster[l_idx])
    local real ux
    local real uy
    local real dx
    local real dy
    local real distance
    local real l_step
    local real l_ang
    local real tx
    local real ty
    call GroupEnumUnitsInRange(udg_TatsumakiGroup,cx,cy,540.,udg_TatsumakiFilter)
    loop
        set u=FirstOfGroup(udg_TatsumakiGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_TatsumakiGroup,u)
        if IsUnitEnemy(u,udg_TatsumakiOwner[l_idx])then
            set ux=GetUnitX(u)
            set uy=GetUnitY(u)
            // (ux) minus (cx).
            set dx=ux-cx
            // (uy) minus (cy).
            set dy=uy-cy
            // The square root of ((the square of (dx)) plus (the square of (dy))).
            set distance=SquareRoot(dx*dx+dy*dy)
            // (distance) minus (25).
            if(distance-25.<60.)then
                // (distance) minus (60).
                set l_step=distance-60.
            else
                set l_step=25.
            endif
            if(GetUnitDefaultMoveSpeed(u)>0)then
                // The angle in radians from the y gap (dy) and x gap (dx).
                set l_ang=Atan2(dy,dx)
                // (ux) minus ((l_step) times (the horizontal direction share for angle (l_ang) in radians)).
                set tx=ux-l_step*Cos(l_ang)
                // (uy) minus ((l_step) times (the vertical direction share for angle (l_ang) in radians)).
                set ty=uy-l_step*Sin(l_ang)
                if Path_IsWalkable(tx,ty,10.)then
                    call SetUnitX(u,tx)
                    call SetUnitY(u,ty)
                endif
            endif
            if(udg_TatsumakiHitTick[l_idx]and distance<80.)then
                set udg_IsPhysicalAttack=true
                set udg_DamageElement=6
                call UnitDamageTarget(udg_TatsumakiCaster[l_idx],u,udg_TatsumakiTickDamage[l_idx],true,true,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_LIGHT_SLICE)
            endif
        endif
    endloop
    return true
endfunction

function Tatsumaki_Stomp takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    local unit u
    local real cx=GetUnitX(udg_TatsumakiCaster[l_idx])
    local real cy=GetUnitY(udg_TatsumakiCaster[l_idx])
    local real ux
    local real uy
    local real dx
    local real dy
    local real l_ang
    local real speed
    local real tx
    local real ty
    call GroupEnumUnitsInRange(udg_TatsumakiGroup,cx,cy,100.,udg_TatsumakiFilter)
    loop
        set u=FirstOfGroup(udg_TatsumakiGroup)
        exitwhen u==null
        call GroupRemoveUnit(udg_TatsumakiGroup,u)
        if IsUnitEnemy(u,udg_TatsumakiOwner[l_idx])then
            if(GetUnitDefaultMoveSpeed(u)>0)then
                set ux=GetUnitX(u)
                set uy=GetUnitY(u)
                // (ux) minus (cx).
                set dx=ux-cx
                // (uy) minus (cy).
                set dy=uy-cy
                // The angle in radians from the y gap (dy) and x gap (dx).
                set l_ang=Atan2(dy,dx)
                // (ux) plus ((100) times (the horizontal direction share for angle (l_ang) in radians)).
                set tx=ux+100.*Cos(l_ang)
                // (uy) plus ((100) times (the vertical direction share for angle (l_ang) in radians)).
                set ty=uy+100.*Sin(l_ang)
                call SetUnitX(u,tx)
                call SetUnitY(u,ty)
                call Trig_Wave_Fist_Knockback(udg_TatsumakiCaster[l_idx],u,.16,.15,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",true,.0)
            endif
            set udg_IsPhysicalAttack=true
            set udg_DamageElement=6
            call UnitDamageTarget(udg_TatsumakiCaster[l_idx],u,udg_TatsumakiStompDamage[l_idx],true,true,ATTACK_TYPE_MELEE,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_HEAVY_SLICE)
        endif
    endloop
    return true
endfunction

function Tatsumaki_Remove takes nothing returns boolean
    local integer l_idx=udg_ArgIndex
    set udg_TatsumakiActiveCount=udg_TatsumakiActiveCount-1
    set udg_TatsumakiList[udg_TatsumakiIndex[l_idx]]=udg_TatsumakiList[udg_TatsumakiActiveCount]
    set udg_TatsumakiIndex[udg_TatsumakiList[udg_TatsumakiIndex[l_idx]]]=udg_TatsumakiIndex[l_idx]
    return true
endfunction

function InitTrig_Tatsumaki takes nothing returns nothing
endfunction

endlibrary

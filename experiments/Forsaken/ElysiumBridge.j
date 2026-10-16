// Recreate the crossing only after Andre unlocks Elysium. The original bridge
// stops on the unwalkable western cliff cells; extend its ends onto both banks.
function Andre_OpenBridge takes nothing returns nothing
    local real x=-640.
    local real y
    if gg_dest_DTsb_0068==null then
        set gg_dest_DTsb_0068=CreateDestructableZ('DTsb',0.,-9632.,-128.,90.,1.125,0)
    endif
    call ShowDestructable(gg_dest_DTsb_0068,true)
    call SetDestructableInvulnerable(gg_dest_DTsb_0068,true)
    call SetDestructableAnimation(gg_dest_DTsb_0068,"stand")
    loop
        exitwhen x>640.
        set y=-9728.
        loop
            exitwhen y> -9536.
            call SetTerrainPathable(x,y,PATHING_TYPE_WALKABILITY,true)
            set y=y+32.
        endloop
        set x=x+32.
    endloop
endfunction

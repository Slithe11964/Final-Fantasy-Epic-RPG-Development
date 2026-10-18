// Shared gameplay only: discover loaded/bagged/equipped rods, including aliases.
function Fishing_Rod takes integer raw returns boolean
    return raw=='I0EY' or raw=='I0EZ' or raw=='I0GB' or raw=='I0GC'
endfunction

function Fishing_CarryRod takes unit holder returns boolean
    local integer i=0
    if holder==null then
        return false
    endif
    loop
        exitwhen i>=Carry_Size(holder)
        if Fishing_Rod(Carry_Type(Carry_At(holder,i))) then
            return true
        endif
        set i=i+1
    endloop
    return false
endfunction

function Fishing_HasAnyRod takes nothing returns boolean
    local integer i=0
    if udg_FishingSpots==null or FishingUnlocked then
        return false
    endif
    loop
        exitwhen i>=8
        if Fishing_CarryRod(Player_GetHero(Player(i))) or Fishing_CarryRod(udg_SpiritOfGaya[i+1]) then
            return true
        endif
        set i=i+1
    endloop
    return false
endfunction

function Fishing_UnlockOnce takes nothing returns nothing
    if FishingUnlocked or udg_FishingSpots==null then
        return
    endif
    set FishingUnlocked=true
    call ForGroupBJ(udg_FishingSpots,function Trig_Fishing_Unlock_ShowFishingSpot)
    call AddItemToStockBJ('I0HB',gg_unit_n02Y_0052,1,1)
    call EnableTrigger(gg_trg_Fishing_Cast)
    call DisableTrigger(gg_trg_Fishing_Unlock)
endfunction

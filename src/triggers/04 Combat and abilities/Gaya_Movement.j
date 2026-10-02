library TGayaMovement requires TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gaya_Follow=null
    trigger gg_trg_Gaya_HousePortal=null
endglobals

// ---- Gaya ----
function Trig_Gaya_Follow_MoveGayaToHero takes nothing returns nothing
    // Starting value for i:
    // (GetPlayerId(the player being visited)) plus (1).
    local integer i=GetPlayerId(GetEnumPlayer())+1
    local real hx
    local real hy
    local real gx
    local real gy
    local real l_adx
    local real l_ady
    local unit l_hero=Player_GetHero(GetEnumPlayer())
    local unit l_gaya=udg_SpiritOfGaya[i]
    if udg_PlayerTransport[i]!=null and IsUnitLoaded(l_hero)then
        set l_hero=udg_PlayerTransport[i]
    else
        if udg_PlayerTransport[i]!=null then
            set udg_PlayerTransport[i]=null
        endif
    endif
    set hx=GetUnitX(l_hero)
    set hy=GetUnitY(l_hero)
    set gx=GetUnitX(l_gaya)
    set gy=GetUnitY(l_gaya)
    // (gx) minus (hx).
    if gx-hx>=0 then
        // (gx) minus (hx).
        set l_adx=gx-hx
    else
        // (hx) minus (gx).
        set l_adx=hx-gx
    endif
    // (gy) minus (hy).
    if gy-hy>=0 then
        // (gy) minus (hy).
        set l_ady=gy-hy
    else
        // (hy) minus (gy).
        set l_ady=hy-gy
    endif
    if l_adx>=384 or l_ady>=384 then
        call SetUnitX(l_gaya,hx)
        call SetUnitY(l_gaya,hy)
        call IssueTargetOrderById(l_gaya,$D0003,l_hero) // $D0003 = 851971
    endif
    set l_hero=null
    set l_gaya=null
endfunction

function Trig_Gaya_Follow_Actions takes nothing returns nothing
    call ForForce(udg_PlayingPlayers,function Trig_Gaya_Follow_MoveGayaToHero)
endfunction

function Trig_Gaya_HousePortal_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0P3')and(GetTriggerUnit()==udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) // 'A0P3': ability "House Portal"
endfunction

function Trig_Gaya_HousePortal_Actions takes nothing returns nothing
    set udg_TempInteger=GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
    // (udg_TempInteger) minus (1).
    call SetUnitX(udg_SpiritOfGaya[udg_TempInteger],GetUnitX(Player_GetHero(Player(udg_TempInteger-1))))
    // (udg_TempInteger) minus (1).
    call SetUnitY(udg_SpiritOfGaya[udg_TempInteger],GetUnitY(Player_GetHero(Player(udg_TempInteger-1))))
    call IssueImmediateOrderBJ(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"holdposition")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Gaya_Movement takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Gaya (module Gaya),
// which keeps the original registration order.

function Register_Gaya_Follow takes nothing returns nothing
    set gg_trg_Gaya_Follow=CreateTrigger()
    call DisableTrigger(gg_trg_Gaya_Follow)
    call TriggerRegisterTimerEvent(gg_trg_Gaya_Follow,1.,true)
    call TriggerAddAction(gg_trg_Gaya_Follow,function Trig_Gaya_Follow_Actions)
endfunction

function Register_Gaya_HousePortal takes nothing returns nothing
    set gg_trg_Gaya_HousePortal=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_HousePortal,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Gaya_HousePortal,Condition(function Trig_Gaya_HousePortal_Conditions))
    call TriggerAddAction(gg_trg_Gaya_HousePortal,function Trig_Gaya_HousePortal_Actions)
endfunction

endlibrary

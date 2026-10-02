library TIceCache
function Trig_IceCache_Open_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_IceCache_Open_Cond_SpearStillAvailable takes nothing returns boolean
    return(udg_MonographDropped==false)
endfunction

function Trig_IceCache_Open_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetDestructableInvulnerableBJ(gg_dest_LTbx_0038,false)
    set udg_TempPoint=GetDestructableLoc(gg_dest_LTbx_0038)
    call CreateItemLoc('I06X',udg_TempPoint) // 'I06X': item "Unique Ice Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I021',udg_TempPoint) // 'I021': item "1500 Gold Coins"
    if(Trig_IceCache_Open_Cond_SpearStillAvailable())then
        call CreateItemLoc('I07Z',udg_TempPoint) // 'I07Z': item "Zodiac Spear"
    endif
    call RemoveLocation(udg_TempPoint)
    call KillDestructable(gg_dest_LTbx_0038)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_IceCache_SpearClaimed_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_MonographDropped=true
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_IceCache automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_IceCache (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_IceCache takes nothing returns nothing
endfunction

function Register_IceCache_Open takes nothing returns nothing
    set gg_trg_IceCache_Open=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_IceCache_Open,gg_rct_474)
    call TriggerAddCondition(gg_trg_IceCache_Open,Condition(function Trig_IceCache_Open_Conditions))
    call TriggerAddAction(gg_trg_IceCache_Open,function Trig_IceCache_Open_Actions)
endfunction

function Register_IceCache_SpearClaimed takes nothing returns nothing
    set gg_trg_IceCache_SpearClaimed=CreateTrigger()
    call TriggerRegisterDeathEvent(gg_trg_IceCache_SpearClaimed,gg_dest_LTbs_0046)
    call TriggerRegisterDeathEvent(gg_trg_IceCache_SpearClaimed,gg_dest_LTba_0044)
    call TriggerRegisterDeathEvent(gg_trg_IceCache_SpearClaimed,gg_dest_LTba_0045)
    call TriggerRegisterDeathEvent(gg_trg_IceCache_SpearClaimed,gg_dest_LTcr_0027)
    call TriggerRegisterDeathEvent(gg_trg_IceCache_SpearClaimed,gg_dest_LTbs_0023)
    call TriggerAddAction(gg_trg_IceCache_SpearClaimed,function Trig_IceCache_SpearClaimed_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_IceCache takes nothing returns nothing
    call Register_IceCache_Open()
    call Register_IceCache_SpearClaimed()
endfunction

endlibrary

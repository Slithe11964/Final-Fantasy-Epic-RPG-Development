library TMagicVault
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MagicVault_Dim=null
    trigger gg_trg_MagicVault_Death=null
endglobals

function Trig_MagicVault_Dim_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(gg_unit_n03M_0166,'d','d','d',100.)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MagicVault_Death_Cond_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_MagicVault_Death_Cond_SeitengratAvailable takes nothing returns boolean
    return(udg_HardcoreOff==false)
endfunction

function Trig_MagicVault_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call ReplaceUnitBJ(GetTriggerUnit(),'nmgv',bj_UNIT_STATE_METHOD_RELATIVE) // 'nmgv': editor label "Magic Vault"
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_MagicVault_Death_Cond_SeitengratAvailable())then
        call CreateItemLoc('I0IO',udg_TempPoint) // 'I0IO': item "Seitengrat"
    else
        if(Trig_MagicVault_Death_Cond_CoinFlip())then
            call CreateItemLoc('I004',udg_TempPoint) // 'I004': item "100 Gold Coins"
        else
            call CreateItemLoc('phea',udg_TempPoint) // 'phea': item "Potion"
        endif
    endif
    call RemoveLocation(udg_TempPoint)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_MagicVault automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MagicVault (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MagicVault takes nothing returns nothing
endfunction

function Register_MagicVault_Dim takes nothing returns nothing
    set gg_trg_MagicVault_Dim=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_MagicVault_Dim,2.)
    call TriggerAddAction(gg_trg_MagicVault_Dim,function Trig_MagicVault_Dim_Actions)
endfunction

function Register_MagicVault_Death takes nothing returns nothing
    set gg_trg_MagicVault_Death=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MagicVault_Death,gg_unit_n03M_0166,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_MagicVault_Death,function Trig_MagicVault_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MagicVault takes nothing returns nothing
    call Register_MagicVault_Dim()
    call Register_MagicVault_Death()
endfunction

endlibrary

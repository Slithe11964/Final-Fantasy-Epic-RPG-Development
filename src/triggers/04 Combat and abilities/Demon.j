library TDemon
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Demon_Drop_Magatama=null
    // Variables only this module uses.
    integer udg_DemonKillCount=0
endglobals

function Trig_Demon_Drop_Magatama_IsEvenKill takes nothing returns boolean
    // The remainder after dividing (udg_DemonKillCount) by (2).
    return(ModuloInteger(udg_DemonKillCount,2)==0)
endfunction

function Trig_Demon_Drop_Magatama_KillsBelowFive takes nothing returns boolean
    return(udg_DemonKillCount<5)
endfunction

function Trig_Demon_Drop_Magatama_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Demon_Drop_Magatama_KillsBelowFive())then
        set udg_DemonKillCount=(udg_DemonKillCount+1)
        if(Trig_Demon_Drop_Magatama_IsEvenKill())then
            call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
        endif
        call RemoveLocation(udg_TempPoint)
    else
        call DisableTrigger(GetTriggeringTrigger())
        call CreateItemLoc('I0F0',udg_TempPoint) // 'I0F0': item "Magatama"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        call RemoveLocation(udg_TempPoint)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// World Editor calls InitTrig_Demon automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Demon (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Demon takes nothing returns nothing
endfunction

function Register_Demon_Drop_Magatama takes nothing returns nothing
    set gg_trg_Demon_Drop_Magatama=CreateTrigger()
    call TriggerAddAction(gg_trg_Demon_Drop_Magatama,function Trig_Demon_Drop_Magatama_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Demon takes nothing returns nothing
    call Register_Demon_Drop_Magatama() // used by Hunt_Encounters
endfunction

endlibrary

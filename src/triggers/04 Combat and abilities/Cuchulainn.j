library TCuchulainn
function Trig_Cuchulainn_Soul_Death_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Cuchulainn_Soul_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0JV',udg_TempPoint) // 'I0JV': item "Curse: Poison Wand"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Cuchulainn_Soul_Death_CoinFlip())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    set udg_ShemhazaiPhase=4
    call SetUnitInvulnerable(gg_unit_U00I_0210,false)
    call UnitRemoveAbilityBJ('Abun',gg_unit_U00I_0210) // 'Abun': object name not found in map data
    call UnitAddAbilityBJ('A12F',gg_unit_U00I_0210) // 'A12F': ability "Soul Split"
    call EnableTrigger(gg_trg_Boss_Shemhazai_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Cuchulainn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cuchulainn (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cuchulainn takes nothing returns nothing
endfunction

function Register_Cuchulainn_Soul_Death takes nothing returns nothing
    set gg_trg_Cuchulainn_Soul_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Cuchulainn_Soul_Death)
    call TriggerRegisterUnitEvent(gg_trg_Cuchulainn_Soul_Death,gg_unit_U019_0253,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Cuchulainn_Soul_Death,function Trig_Cuchulainn_Soul_Death_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Cuchulainn takes nothing returns nothing
    call Register_Cuchulainn_Soul_Death()
endfunction

endlibrary

library TUrn
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Urn_Guardians_Count=null
    // Variables only this module uses.
    integer udg_GuardiansKilled=0
endglobals

function Trig_Urn_Guardians_Count_Enum_RemoveDestructable takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Urn_Guardians_Count_Cond_AllGuardiansDead takes nothing returns boolean
    return(udg_GuardiansKilled>=4)
endfunction

function Trig_Urn_Guardians_Count_Actions takes nothing returns nothing
    set udg_GuardiansKilled=(udg_GuardiansKilled+1)
    if(Trig_Urn_Guardians_Count_Cond_AllGuardiansDead())then
        call DisableTrigger(GetTriggeringTrigger())
        set udg_TempPoint3=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I01Z',udg_TempPoint3) // 'I01Z': item "Crystal Shard"
        call RemoveLocation(udg_TempPoint3)
        call SetUnitVertexColorBJ(gg_unit_nmgv_0065,'d','d','d',0)
        call SetUnitInvulnerable(gg_unit_nmgv_0065,false)
        call EnumDestructablesInRectAll(gg_rct_552,function Trig_Urn_Guardians_Count_Enum_RemoveDestructable)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        call SetUnitVertexColorBJ(gg_unit_nmgv_0065,(25.*I2R(udg_GuardiansKilled)),(25.*I2R(udg_GuardiansKilled)),(25.*I2R(udg_GuardiansKilled)),0)
    endif
endfunction

// World Editor calls InitTrig_Urn automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Urn (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Urn takes nothing returns nothing
endfunction

function Register_Urn_Guardians_Count takes nothing returns nothing
    set gg_trg_Urn_Guardians_Count=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Urn_Guardians_Count,gg_unit_n014_0174,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Urn_Guardians_Count,gg_unit_U006_0077,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Urn_Guardians_Count,gg_unit_H00W_0079,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Urn_Guardians_Count,gg_unit_U00J_0209,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Urn_Guardians_Count,function Trig_Urn_Guardians_Count_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Urn takes nothing returns nothing
    call Register_Urn_Guardians_Count()
endfunction

endlibrary

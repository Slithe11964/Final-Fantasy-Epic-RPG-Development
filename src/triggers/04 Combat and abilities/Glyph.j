library TGlyph
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Glyph_Area_Enter=null
endglobals

function Trig_Glyph_Area_Enter_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(GetTriggerUnit())==false)
endfunction

function Trig_Glyph_Area_Enter_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ShadowForcedSpawn=49
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call CreateFogModifierRectBJ(true,Player($B),FOG_OF_WAR_VISIBLE,gg_rct_496) // $B = 11
    call EnableTrigger(gg_trg_Summon_Item_Dropped)
    call EnableTrigger(gg_trg_Arena_Enter_Eject)
    call EnableTrigger(gg_trg_Arena_Leave_Player)
    call EnableTrigger(gg_trg_Arena_Abandoned_Reset)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Glyph automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Glyph (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Glyph takes nothing returns nothing
endfunction

function Register_Glyph_Area_Enter takes nothing returns nothing
    set gg_trg_Glyph_Area_Enter=CreateTrigger()
    call DisableTrigger(gg_trg_Glyph_Area_Enter)
    call TriggerRegisterEnterRectSimple(gg_trg_Glyph_Area_Enter,gg_rct_496)
    call TriggerAddCondition(gg_trg_Glyph_Area_Enter,Condition(function Trig_Glyph_Area_Enter_Conditions))
    call TriggerAddAction(gg_trg_Glyph_Area_Enter,function Trig_Glyph_Area_Enter_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Glyph takes nothing returns nothing
    call Register_Glyph_Area_Enter() // starts off; enabled by RingOfDarkness
endfunction

endlibrary

library TWorld
function Trig_World_AfterDemonAppears_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_TrueIceAge_GateUnlock)
    call DisableTrigger(gg_trg_TrueIceAge_Summon)
    call UnitRemoveAbilityBJ('A11Z',gg_unit_ndmg_0124) // 'A11Z': ability "Activate Demon Gate"
    call UnitRemoveAbilityBJ('Ane2',gg_unit_ndmg_0124) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0BU',gg_unit_n009_0051,1,1) // 'n0BU': unit "Hunt: Marilith"
    set udg_HuntStock[1]=(udg_HuntStock[1]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call ShowUnitShow(gg_unit_E002_0075)
    call EnableTrigger(gg_trg_Boss_Hashmalum_Intro)
    call SetUnitAnimation(gg_unit_E002_0075,"stand ready alternate")
    set udg_HashmalumStage=1
    call DestroyTrigger(gg_trg_Cine_StoneBreaks_Alt)
    call EnableTrigger(gg_trg_Ambush_Skeletons_1)
    call EnableTrigger(gg_trg_Ambush_Skeletons_2)
    call EnableTrigger(gg_trg_Ambush_Skeletons_3)
    call EnableTrigger(gg_trg_Ambush_Skeletons_4)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_World automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_World (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_World takes nothing returns nothing
endfunction

function Register_World_AfterDemonAppears takes nothing returns nothing
    set gg_trg_World_AfterDemonAppears=CreateTrigger()
    call DisableTrigger(gg_trg_World_AfterDemonAppears)
    call TriggerAddAction(gg_trg_World_AfterDemonAppears,function Trig_World_AfterDemonAppears_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_World takes nothing returns nothing
    call Register_World_AfterDemonAppears()
endfunction

endlibrary

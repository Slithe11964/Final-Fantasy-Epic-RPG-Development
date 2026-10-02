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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_World takes nothing returns nothing
endfunction
function RegisterR11_World_AfterDemonAppears takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_World_AfterDemonAppears=CreateTrigger()
    call DisableTrigger(gg_trg_World_AfterDemonAppears)
    call TriggerAddAction(gg_trg_World_AfterDemonAppears,function Trig_World_AfterDemonAppears_Actions)
endfunction




endlibrary

library TAmbush requires TUnit
function Trig_Ambush_Skeletons_1_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false) // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Ambush_Skeletons_1_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_RetreatPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetRectCenter(gg_rct_681)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=7
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // ((loop counter A) minus (4) treated as a decimal-capable number) times (108).
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,(I2R((GetForLoopIndexA()-4))*108.),.0)
        call CreateNUnitsAtLocFacingLocBJ(1,'u00P',Player($B),udg_TempPoint,udg_RetreatPoint) // 'u00P': unit "Skeleton Champion"; $B = 11
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_RetreatPoint)
endfunction

function Trig_Ambush_Skeletons_2_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false) // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Ambush_Skeletons_2_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_RetreatPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetRectCenter(gg_rct_683)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=7
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // ((loop counter A) minus (4) treated as a decimal-capable number) times (108).
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,(I2R((GetForLoopIndexA()-4))*108.),.0)
        call CreateNUnitsAtLocFacingLocBJ(1,'u00P',Player($B),udg_TempPoint,udg_RetreatPoint) // 'u00P': unit "Skeleton Champion"; $B = 11
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_RetreatPoint)
endfunction

function Trig_Ambush_Skeletons_3_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false) // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Ambush_Skeletons_3_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_RetreatPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetRectCenter(gg_rct_680)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=7
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // ((loop counter A) minus (4) treated as a decimal-capable number) times (108).
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,0,(I2R((GetForLoopIndexA()-4))*108.))
        call CreateNUnitsAtLocFacingLocBJ(1,'u00P',Player($B),udg_TempPoint,udg_RetreatPoint) // 'u00P': unit "Skeleton Champion"; $B = 11
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_RetreatPoint)
endfunction

function Trig_Ambush_Skeletons_4_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false) // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Ambush_Skeletons_4_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_RetreatPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=GetRectCenter(gg_rct_682)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=7
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // ((loop counter A) minus (4) treated as a decimal-capable number) times (108).
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,0,(I2R((GetForLoopIndexA()-4))*108.))
        call CreateNUnitsAtLocFacingLocBJ(1,'u00P',Player($B),udg_TempPoint,udg_RetreatPoint) // 'u00P': unit "Skeleton Champion"; $B = 11
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint2)
    call RemoveLocation(udg_RetreatPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Ambush takes nothing returns nothing
endfunction
function RegisterR11_Ambush_Skeletons_1 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ambush_Skeletons_1=CreateTrigger()
    call DisableTrigger(gg_trg_Ambush_Skeletons_1)
    call TriggerRegisterEnterRectSimple(gg_trg_Ambush_Skeletons_1,gg_rct_681)
    call TriggerAddCondition(gg_trg_Ambush_Skeletons_1,Condition(function Trig_Ambush_Skeletons_1_Conditions))
    call TriggerAddAction(gg_trg_Ambush_Skeletons_1,function Trig_Ambush_Skeletons_1_Actions)
endfunction
function RegisterR11_Ambush_Skeletons_2 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ambush_Skeletons_2=CreateTrigger()
    call DisableTrigger(gg_trg_Ambush_Skeletons_2)
    call TriggerRegisterEnterRectSimple(gg_trg_Ambush_Skeletons_2,gg_rct_683)
    call TriggerAddCondition(gg_trg_Ambush_Skeletons_2,Condition(function Trig_Ambush_Skeletons_2_Conditions))
    call TriggerAddAction(gg_trg_Ambush_Skeletons_2,function Trig_Ambush_Skeletons_2_Actions)
endfunction
function RegisterR11_Ambush_Skeletons_3 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ambush_Skeletons_3=CreateTrigger()
    call DisableTrigger(gg_trg_Ambush_Skeletons_3)
    call TriggerRegisterEnterRectSimple(gg_trg_Ambush_Skeletons_3,gg_rct_680)
    call TriggerAddCondition(gg_trg_Ambush_Skeletons_3,Condition(function Trig_Ambush_Skeletons_3_Conditions))
    call TriggerAddAction(gg_trg_Ambush_Skeletons_3,function Trig_Ambush_Skeletons_3_Actions)
endfunction
function RegisterR11_Ambush_Skeletons_4 takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Ambush_Skeletons_4=CreateTrigger()
    call DisableTrigger(gg_trg_Ambush_Skeletons_4)
    call TriggerRegisterEnterRectSimple(gg_trg_Ambush_Skeletons_4,gg_rct_682)
    call TriggerAddCondition(gg_trg_Ambush_Skeletons_4,Condition(function Trig_Ambush_Skeletons_4_Conditions))
    call TriggerAddAction(gg_trg_Ambush_Skeletons_4,function Trig_Ambush_Skeletons_4_Actions)
endfunction




endlibrary

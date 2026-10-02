library TInfernalMountain requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_InfernalMountain_Hide=null
endglobals

function Trig_InfernalMountain_Hide_HideTower takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
endfunction

function Trig_InfernalMountain_Hide_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00Q_0023)
    call SetUnitInvulnerable(gg_unit_U00Q_0023,true)
    call PauseUnitBJ(true,gg_unit_U00Q_0023)
    set udg_HellSpawnsActive=false
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_592) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_593) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_594) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_595) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_596) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_597) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_622) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_623) // 'YOtf': object name not found in map data
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($B),'u009') // $B = 11; 'u009': unit "Infernal Tower"
    call ForGroupBJ(udg_TempGroup,function Trig_InfernalMountain_Hide_HideTower)
    call DestroyGroup(udg_TempGroup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_InfernalMountain automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_InfernalMountain (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_InfernalMountain takes nothing returns nothing
endfunction

function Register_InfernalMountain_Hide takes nothing returns nothing
    set gg_trg_InfernalMountain_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_InfernalMountain_Hide,function Trig_InfernalMountain_Hide_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_InfernalMountain takes nothing returns nothing
    call Register_InfernalMountain_Hide() // run by MapBootstrap
endfunction

endlibrary

library TInfernalMountain requires TGroup
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

// Registration ownership; called at the original bootstrap positions.
function InitTrig_InfernalMountain takes nothing returns nothing
endfunction

function RegisterR11_InfernalMountain_Hide takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_InfernalMountain_Hide=CreateTrigger()

call TriggerAddAction(gg_trg_InfernalMountain_Hide,function Trig_InfernalMountain_Hide_Actions)

endfunction




endlibrary

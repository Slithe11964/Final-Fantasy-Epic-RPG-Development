library TQuestScorchingTravel requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_52_Scorching=null
endglobals

function Trig_Quest_52_Scorching_TravelDialog_Rebuild takes nothing returns nothing
    local integer i=0
    call DialogClear(udg_WarpDialog)
    call DialogSetMessage(udg_WarpDialog,"Choose destination:")
    loop
        exitwhen i>udg_TravelCount
        if udg_WarpUnlocked[i] then
            set udg_TravelButton[i]=null
            set udg_TravelButton[i]=DialogAddButton(udg_WarpDialog,udg_TravelName[i],udg_TravelHotkey[i])
        endif
        set i=i+1
    endloop
endfunction

function Trig_Quest_52_Scorching_TravelDialog_Disable takes nothing returns nothing
    if udg_WarpUnlocked[udg_TravelPointIndex]then
        call DestroyEffect(udg_WarpEffect[udg_TravelPointIndex])
        set udg_WarpUnlocked[udg_TravelPointIndex]=false
        call Trig_Quest_52_Scorching_TravelDialog_Rebuild()
    endif
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker1 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='ITx1')or(GetDestructableTypeId(GetEnumDestructable())=='ITx3')or(GetDestructableTypeId(GetEnumDestructable())=='ITx2')or(GetDestructableTypeId(GetEnumDestructable())=='ITx4')or(GetDestructableTypeId(GetEnumDestructable())=='ITcr') // 'ITx1': object name not found in map data; 'ITx3': object name not found in map data; 'ITx2': object name not found in map data; 'ITx4': object name not found in map data; 'ITcr': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker1Wrap takes nothing returns boolean
    return(Trig_Quest_52_Scorching_Cond_IsIceBlocker1())
endfunction

function Trig_Quest_52_Scorching_Cond_NotTreeWall1 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())!='ITtw') // 'ITtw': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_HideOrKillDest1 takes nothing returns nothing
    if(Trig_Quest_52_Scorching_Cond_NotTreeWall1())then
        if(Trig_Quest_52_Scorching_Cond_IsIceBlocker1Wrap())then
            call KillDestructable(GetEnumDestructable())
        else
            set udg_HiddenDestCount=(udg_HiddenDestCount+1)
            set udg_HiddenDest[udg_HiddenDestCount]=GetEnumDestructable()
            call ShowDestructableBJ(false,GetEnumDestructable())
        endif
    endif
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker2 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='ITx1')or(GetDestructableTypeId(GetEnumDestructable())=='ITx3')or(GetDestructableTypeId(GetEnumDestructable())=='ITx2')or(GetDestructableTypeId(GetEnumDestructable())=='ITx4')or(GetDestructableTypeId(GetEnumDestructable())=='ITcr') // 'ITx1': object name not found in map data; 'ITx3': object name not found in map data; 'ITx2': object name not found in map data; 'ITx4': object name not found in map data; 'ITcr': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker2Wrap takes nothing returns boolean
    return(Trig_Quest_52_Scorching_Cond_IsIceBlocker2())
endfunction

function Trig_Quest_52_Scorching_Cond_NotTreeWall2 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())!='ITtw') // 'ITtw': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_HideOrKillDest2 takes nothing returns nothing
    if(Trig_Quest_52_Scorching_Cond_NotTreeWall2())then
        if(Trig_Quest_52_Scorching_Cond_IsIceBlocker2Wrap())then
            call KillDestructable(GetEnumDestructable())
        else
            set udg_HiddenDestCount=(udg_HiddenDestCount+1)
            set udg_HiddenDest[udg_HiddenDestCount]=GetEnumDestructable()
            call ShowDestructableBJ(false,GetEnumDestructable())
        endif
    endif
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker3 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='ITx1')or(GetDestructableTypeId(GetEnumDestructable())=='ITx3')or(GetDestructableTypeId(GetEnumDestructable())=='ITx2')or(GetDestructableTypeId(GetEnumDestructable())=='ITx4')or(GetDestructableTypeId(GetEnumDestructable())=='ITcr') // 'ITx1': object name not found in map data; 'ITx3': object name not found in map data; 'ITx2': object name not found in map data; 'ITx4': object name not found in map data; 'ITcr': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker3Wrap takes nothing returns boolean
    return(Trig_Quest_52_Scorching_Cond_IsIceBlocker3())
endfunction

function Trig_Quest_52_Scorching_Cond_NotTreeWall3 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())!='ITtw') // 'ITtw': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_HideOrKillDest3 takes nothing returns nothing
    if(Trig_Quest_52_Scorching_Cond_NotTreeWall3())then
        if(Trig_Quest_52_Scorching_Cond_IsIceBlocker3Wrap())then
            call KillDestructable(GetEnumDestructable())
        else
            set udg_HiddenDestCount=(udg_HiddenDestCount+1)
            set udg_HiddenDest[udg_HiddenDestCount]=GetEnumDestructable()
            call ShowDestructableBJ(false,GetEnumDestructable())
        endif
    endif
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker4 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='ITx1')or(GetDestructableTypeId(GetEnumDestructable())=='ITx3')or(GetDestructableTypeId(GetEnumDestructable())=='ITx2')or(GetDestructableTypeId(GetEnumDestructable())=='ITx4')or(GetDestructableTypeId(GetEnumDestructable())=='ITcr') // 'ITx1': object name not found in map data; 'ITx3': object name not found in map data; 'ITx2': object name not found in map data; 'ITx4': object name not found in map data; 'ITcr': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_Cond_IsIceBlocker4Wrap takes nothing returns boolean
    return(Trig_Quest_52_Scorching_Cond_IsIceBlocker4())
endfunction

function Trig_Quest_52_Scorching_Cond_NotTreeWall4 takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())!='ITtw') // 'ITtw': object name not found in map data
endfunction

function Trig_Quest_52_Scorching_HideOrKillDest4 takes nothing returns nothing
    if(Trig_Quest_52_Scorching_Cond_NotTreeWall4())then
        if(Trig_Quest_52_Scorching_Cond_IsIceBlocker4Wrap())then
            call KillDestructable(GetEnumDestructable())
        else
            set udg_HiddenDestCount=(udg_HiddenDestCount+1)
            set udg_HiddenDest[udg_HiddenDestCount]=GetEnumDestructable()
            call ShowDestructableBJ(false,GetEnumDestructable())
        endif
    endif
endfunction

function Trig_Quest_52_Scorching_Cond_UnitAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Quest_52_Scorching_Cond_IsIcyRealmUnit takes nothing returns boolean
    return(GetUnitUserData(GetFilterUnit())==8)
endfunction

function Trig_Quest_52_Scorching_Filter_IcyRealmUnit takes nothing returns boolean
    return GetBooleanAnd(Trig_Quest_52_Scorching_Cond_UnitAlive(),Trig_Quest_52_Scorching_Cond_IsIcyRealmUnit())
endfunction

function Trig_Quest_52_Scorching_KillEnumUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Quest_52_Scorching_Cond_ZoneBossSpawned takes nothing returns boolean
    return(IsUnitInGroup(udg_ZoneBoss[8],udg_QuestNpcUnits))
endfunction

function Trig_Quest_52_Scorching_ShowTower takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Quest_52_Scorching_Actions takes nothing returns nothing
    set udg_HellSpawnsActive=true
    call SetBlightRectBJ(true,Player($B),gg_rct_592) // $B = 11
    call SetBlightRectBJ(true,Player($B),gg_rct_593) // $B = 11
    call SetBlightRectBJ(true,Player($B),gg_rct_594) // $B = 11
    call SetBlightRectBJ(true,Player($B),gg_rct_595) // $B = 11
    call SetBlightRectBJ(true,Player($B),gg_rct_596) // $B = 11
    call SetBlightRectBJ(true,Player($B),gg_rct_597) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_598)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_599)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_600)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_601)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_602)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_603)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_604)
    call SetBlightRadiusLocBJ(true,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call EnableWeatherEffect(udg_SnowEffect[GetForLoopIndexA()],false)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_HiddenDestCount=0
    call EnumDestructablesInRectAll(gg_rct_592,function Trig_Quest_52_Scorching_HideOrKillDest1)
    call EnumDestructablesInRectAll(gg_rct_593,function Trig_Quest_52_Scorching_HideOrKillDest2)
    call EnumDestructablesInRectAll(gg_rct_596,function Trig_Quest_52_Scorching_HideOrKillDest3)
    call EnumDestructablesInRectAll(gg_rct_597,function Trig_Quest_52_Scorching_HideOrKillDest4)
    call SetDoodadAnimationRectBJ("hide",'IRrs',GetPlayableMapRect()) // 'IRrs': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'IOsm',GetPlayableMapRect()) // 'IOsm': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'IRic',GetPlayableMapRect()) // 'IRic': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'NRic',GetPlayableMapRect()) // 'NRic': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'NRfs',GetPlayableMapRect()) // 'NRfs': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'NRrk',GetPlayableMapRect()) // 'NRrk': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'NRwr',GetPlayableMapRect()) // 'NRwr': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'IRcy',GetPlayableMapRect()) // 'IRcy': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'IRgc',GetPlayableMapRect()) // 'IRgc': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_592) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_593) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_594) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_595) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_596) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_597) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_622) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'YOtf',gg_rct_623) // 'YOtf': object name not found in map data
    set udg_TempGroup=Group_UnitsOfPlayer(Player($B),Condition(function Trig_Quest_52_Scorching_Filter_IcyRealmUnit)) // $B = 11
    call ForGroupBJ(udg_TempGroup,function Trig_Quest_52_Scorching_KillEnumUnit)
    call DestroyGroup(udg_TempGroup)
    set udg_ZoneEssenceItem[8]='I0BY' // 'I0BY': item "Hell Gate's Flame"
    set udg_ElementRecord[1]=0
    set udg_AreaSpawnUnitA[8]='n0CL' // 'n0CL': unit "Puroboros"
    set udg_AreaSpawnUnitB[8]='n0CL' // 'n0CL': unit "Puroboros"
    set udg_ZoneColor[8]=PLAYER_COLOR_RED
    if(Trig_Quest_52_Scorching_Cond_ZoneBossSpawned())then
        call KillUnit(udg_ZoneBoss[8])
    endif
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($B),'u009') // $B = 11; 'u009': unit "Infernal Tower"
    call ForGroupBJ(udg_TempGroup,function Trig_Quest_52_Scorching_ShowTower)
    call DestroyGroup(udg_TempGroup)
    call Trig_Quest_52_Scorching_TravelDialog_Disable()
    set udg_TravelName[udg_TravelPointIndex]="|cFFFFFFFFI|rnfernal Mountain"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_ScorchingTravel takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part16 (module Quest),
// which keeps the original registration order.

function Register_Quest_52_Scorching takes nothing returns nothing
    set gg_trg_Quest_52_Scorching=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_52_Scorching)
    call TriggerAddAction(gg_trg_Quest_52_Scorching,function Trig_Quest_52_Scorching_Actions)
endfunction

endlibrary

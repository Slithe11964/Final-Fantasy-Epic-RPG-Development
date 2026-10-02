library TIcyRealm requires TGroup, TQuestScorchingTravel
function Trig_IcyRealm_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_E002_0075)
    call PauseUnitBJ(true,gg_unit_E002_0075)
    call SetUnitInvulnerable(gg_unit_E002_0075,true)
    call UnitAddAbilityBJ('A0VJ',gg_unit_E002_0075) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(true,gg_unit_U00L_0207)
    call SetUnitInvulnerable(gg_unit_U00L_0207,true)
    call UnitAddAbilityBJ('A0VJ',gg_unit_U00L_0207) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(true,gg_unit_U00M_0206)
    call SetUnitInvulnerable(gg_unit_U00M_0206,true)
    call UnitAddAbilityBJ('A0VJ',gg_unit_U00M_0206) // 'A0VJ': ability "Unaffected by Cinematics"
    set udg_TalonGone=true
    set udg_MateusDefeated=false
    set udg_HardMode=false
    set udg_HashmalumEncountered=false
    set udg_HashmalumStage=0
    set udg_ZodiacQuestStage=0
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_IcyRealm_GateOpened_Setup_Enum_ClearRubble_A takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_IcyRealm_GateOpened_Setup_Enum_ClearRubble_B takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_IcyRealm_GateOpened_Setup_Actions takes nothing returns nothing
    call EnumDestructablesInRectAll(gg_rct_493,function Trig_IcyRealm_GateOpened_Setup_Enum_ClearRubble_A)
    call EnumDestructablesInRectAll(gg_rct_665,function Trig_IcyRealm_GateOpened_Setup_Enum_ClearRubble_B)
    set udg_ZodiacQuestStage=7
    // A random whole number from 1 through LoadIntegerBJ(8, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(8,2,udg_SpawnDataHashRef)),8,udg_SpawnRectHashRef))
    call CreateNUnitsAtLoc(1,'n02U',Player(8),udg_TempPoint,GetRandomDirectionDeg()) // 'n02U': unit "Chocobo"
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TownNpcUnits)
    call ConditionalTriggerExecute(gg_trg_Ward_ShowTalkIcon)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_IcyRealm_Restore_IsFilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_IcyRealm_Restore_IsFilterInZone takes nothing returns boolean
    return(GetUnitUserData(GetFilterUnit())==8)
endfunction

function Trig_IcyRealm_Restore_IsAliveInZone takes nothing returns boolean
    return GetBooleanAnd(Trig_IcyRealm_Restore_IsFilterAlive(),Trig_IcyRealm_Restore_IsFilterInZone())
endfunction

function Trig_IcyRealm_Restore_KillEnumUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_IcyRealm_Restore_IsZoneUnitInGroup takes nothing returns boolean
    return(IsUnitInGroup(udg_ZoneBoss[8],udg_QuestNpcUnits))
endfunction

function Trig_IcyRealm_Restore_KillAndRemoveEnumUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_IcyRealm_Restore_Actions takes nothing returns nothing
    set udg_HellSpawnsActive=false
    call SetBlightRectBJ(false,Player($B),gg_rct_592) // $B = 11
    call SetBlightRectBJ(false,Player($B),gg_rct_593) // $B = 11
    call SetBlightRectBJ(false,Player($B),gg_rct_594) // $B = 11
    call SetBlightRectBJ(false,Player($B),gg_rct_595) // $B = 11
    call SetBlightRectBJ(false,Player($B),gg_rct_596) // $B = 11
    call SetBlightRectBJ(false,Player($B),gg_rct_597) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_598)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_599)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_600)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_601)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_602)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_603)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_604)
    call SetBlightRadiusLocBJ(false,Player($B),udg_TempPoint,512) // $B = 11
    call RemoveLocation(udg_TempPoint)
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=5
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call EnableWeatherEffect(udg_SnowEffect[GetForLoopIndexA()],true)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_HiddenDestCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call ShowDestructableBJ(true,udg_HiddenDest[GetForLoopIndexA()])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call SetDoodadAnimationRectBJ("show",'IRrs',GetPlayableMapRect()) // 'IRrs': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'IOsm',GetPlayableMapRect()) // 'IOsm': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'IRic',GetPlayableMapRect()) // 'IRic': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'NRic',GetPlayableMapRect()) // 'NRic': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'NRfs',GetPlayableMapRect()) // 'NRfs': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'NRrk',GetPlayableMapRect()) // 'NRrk': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'NRwr',GetPlayableMapRect()) // 'NRwr': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'IRcy',GetPlayableMapRect()) // 'IRcy': object name not found in map data
    call SetDoodadAnimationRectBJ("show",'IRgc',GetPlayableMapRect()) // 'IRgc': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_592) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_593) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_594) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_595) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_596) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_597) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_622) // 'YOtf': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'YOtf',gg_rct_623) // 'YOtf': object name not found in map data
    set udg_TempGroup=Group_UnitsOfPlayer(Player($B),Condition(function Trig_IcyRealm_Restore_IsAliveInZone)) // $B = 11
    call ForGroupBJ(udg_TempGroup,function Trig_IcyRealm_Restore_KillEnumUnit)
    call DestroyGroup(udg_TempGroup)
    set udg_ZoneEssenceItem[8]='I06X' // 'I06X': item "Unique Ice Shard"
    set udg_ElementRecord[1]=8
    set udg_AreaSpawnUnitA[8]='n08H' // 'n08H': unit "Ice Elemental"
    set udg_AreaSpawnUnitB[8]='n0AG' // 'n0AG': unit "Leshach Entite"
    set udg_ZoneColor[8]=PLAYER_COLOR_LIGHT_BLUE
    if(Trig_IcyRealm_Restore_IsZoneUnitInGroup())then
        call KillUnit(udg_ZoneBoss[8])
    endif
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player($B),'u009') // $B = 11; 'u009': unit "Infernal Tower"
    call ForGroupBJ(udg_TempGroup,function Trig_IcyRealm_Restore_KillAndRemoveEnumUnit)
    call DestroyGroup(udg_TempGroup)
    call Trig_Quest_52_Scorching_TravelDialog_Disable()
    set udg_TravelName[udg_TravelPointIndex]="|cFFFFFFFFI|rcy Realm"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_IcyRealm takes nothing returns nothing
endfunction

function RegisterR11_IcyRealm_Init takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_IcyRealm_Init=CreateTrigger()

call TriggerAddAction(gg_trg_IcyRealm_Init,function Trig_IcyRealm_Init_Actions)

endfunction




function RegisterR11_IcyRealm_GateOpened_Setup takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_IcyRealm_GateOpened_Setup=CreateTrigger()

call DisableTrigger(gg_trg_IcyRealm_GateOpened_Setup)

call TriggerAddAction(gg_trg_IcyRealm_GateOpened_Setup,function Trig_IcyRealm_GateOpened_Setup_Actions)

endfunction




function RegisterR11_IcyRealm_Restore takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_IcyRealm_Restore=CreateTrigger()

call DisableTrigger(gg_trg_IcyRealm_Restore)

call TriggerAddAction(gg_trg_IcyRealm_Restore,function Trig_IcyRealm_Restore_Actions)

endfunction




endlibrary

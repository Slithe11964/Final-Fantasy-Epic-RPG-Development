library TArena requires TArenaAccess, TArenaBattleResults, TArenaBattleSetup, TArenaBoundaries, TArenaConfiguration, TArenaConquest, TArenaCups, TArenaDuel, TArenaIntroduction, TArenaPresentation, TArenaRewards, TArenaRounds, TArenaSpawning, TArenaTeamData, TArenaTeamSelection
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Leash=null
    trigger gg_trg_Arena_FreezeNpcs=null
    trigger gg_trg_Arena_Unlock=null
    trigger gg_trg_Arena_LeoIntro=null
    trigger gg_trg_Arena_InitData=null
    trigger gg_trg_Arena_TeamData1=null
    trigger gg_trg_Arena_TeamData2=null
    trigger gg_trg_Arena_Team_Data_A=null
    trigger gg_trg_Arena_Team_Data_B=null
    trigger gg_trg_Arena_Unit_Data=null
    trigger gg_trg_Arena_Lock_Controls=null
    trigger gg_trg_Arena_Enter_Region=null
    trigger gg_trg_Arena_Start_Cup=null
    trigger gg_trg_Arena_Pick_Team=null
    trigger gg_trg_Arena_Round_Start=null
    trigger gg_trg_Arena_Spawn_Team=null
    trigger gg_trg_Arena_Round_End=null
    trigger gg_trg_Arena_Cup_Won=null
    trigger gg_trg_Arena_UnlockCups=null
    trigger gg_trg_Arena_SyncTeams=null
    trigger gg_trg_Arena_StartBattle=null
    trigger gg_trg_Arena_FoeDeath=null
    trigger gg_trg_Arena_PlayerLeft=null
    trigger gg_trg_Arena_BattleLost=null
    trigger gg_trg_Arena_BuyPrize=null
    trigger gg_trg_Arena_OutOfBounds=null
    trigger gg_trg_Arena_GateWrongSide=null
    trigger gg_trg_Arena_GateOpen=null
    trigger gg_trg_Arena_ToggleShowcase=null
    trigger gg_trg_Arena_ToggleCupMode=null
    trigger gg_trg_Arena_ExchangeBP=null
    trigger gg_trg_Arena_RefreshBPTags=null
    trigger gg_trg_Arena_Enter_Eject=null
    trigger gg_trg_Arena_Leave_Player=null
    trigger gg_trg_Arena_Abandoned_Reset=null
    trigger gg_trg_Arena_Duel_AI=null
    trigger gg_trg_Arena_Omega_Absorbs=null
    trigger gg_trg_Arena_Shinryu_Absorbs=null
    trigger gg_trg_Arena_Duel_Ascend=null
    trigger gg_trg_Arena_Duel_Victory=null
    trigger gg_trg_Arena_Duel_Cleanup=null
endglobals

function InitTrig_Arena takes nothing returns nothing
endfunction

function Register_Arena_Lock_Controls takes nothing returns nothing
    set gg_trg_Arena_Lock_Controls=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Lock_Controls)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Arena_Lock_Controls,udg_ArenaLockTimer)
    call TriggerAddAction(gg_trg_Arena_Lock_Controls,function Trig_Arena_Lock_Controls_Actions)
endfunction

function Register_Arena_Enter_Region takes nothing returns nothing
    set gg_trg_Arena_Enter_Region=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Enter_Region)
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_Enter_Region,gg_rct_373)
    call TriggerAddAction(gg_trg_Arena_Enter_Region,function Trig_Arena_Enter_Region_Actions)
endfunction

function Register_Arena_PlayerLeft takes nothing returns nothing
    set gg_trg_Arena_PlayerLeft=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_PlayerLeft)
    call TriggerRegisterLeaveRectSimple(gg_trg_Arena_PlayerLeft,gg_rct_373)
    call TriggerAddCondition(gg_trg_Arena_PlayerLeft,Condition(function Trig_Arena_PlayerLeft_Conditions))
    call TriggerAddAction(gg_trg_Arena_PlayerLeft,function Trig_Arena_PlayerLeft_Actions)
endfunction

function Register_Arena_GateWrongSide takes nothing returns nothing
    set gg_trg_Arena_GateWrongSide=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_GateWrongSide,gg_rct_485)
    call TriggerAddCondition(gg_trg_Arena_GateWrongSide,Condition(function Trig_Arena_GateWrongSide_Conditions))
    call TriggerAddAction(gg_trg_Arena_GateWrongSide,function Trig_Arena_GateWrongSide_Actions)
endfunction

function Register_Arena_GateOpen takes nothing returns nothing
    set gg_trg_Arena_GateOpen=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_GateOpen)
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_GateOpen,gg_rct_043)
    call TriggerAddCondition(gg_trg_Arena_GateOpen,Condition(function Trig_Arena_GateOpen_Conditions))
    call TriggerAddAction(gg_trg_Arena_GateOpen,function Trig_Arena_GateOpen_Actions)
endfunction

function Register_Arena_Enter_Eject takes nothing returns nothing
    set gg_trg_Arena_Enter_Eject=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Enter_Eject)
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_Enter_Eject,gg_rct_496)
    call TriggerAddCondition(gg_trg_Arena_Enter_Eject,Condition(function Trig_Arena_Enter_Eject_Conditions))
    call TriggerAddAction(gg_trg_Arena_Enter_Eject,function Trig_Arena_Enter_Eject_Actions)
endfunction

function Register_Arena_Leave_Player takes nothing returns nothing
    set gg_trg_Arena_Leave_Player=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Leave_Player)
    call TriggerRegisterLeaveRectSimple(gg_trg_Arena_Leave_Player,gg_rct_496)
    call TriggerAddCondition(gg_trg_Arena_Leave_Player,Condition(function Trig_Arena_Leave_Player_Conditions))
    call TriggerAddAction(gg_trg_Arena_Leave_Player,function Trig_Arena_Leave_Player_Actions)
endfunction

function Register_Arena_FoeDeath takes nothing returns nothing
    set gg_trg_Arena_FoeDeath=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_FoeDeath)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_FoeDeath,EVENT_PLAYER_UNIT_DEATH)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_FoeDeath,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_Arena_FoeDeath,Condition(function Trig_Arena_FoeDeath_Conditions))
    call TriggerAddAction(gg_trg_Arena_FoeDeath,function Trig_Arena_FoeDeath_Actions)
endfunction

function Register_Arena_BattleLost takes nothing returns nothing
    set gg_trg_Arena_BattleLost=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_BattleLost)
    call TriggerAddCondition(gg_trg_Arena_BattleLost,Condition(function Trig_Arena_BattleLost_Conditions))
    call TriggerAddAction(gg_trg_Arena_BattleLost,function Trig_Arena_BattleLost_Actions)
endfunction

function Register_Arena_Abandoned_Reset takes nothing returns nothing
    set gg_trg_Arena_Abandoned_Reset=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Abandoned_Reset)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Arena_Abandoned_Reset,udg_ArenaCheckTimer)
    call TriggerAddCondition(gg_trg_Arena_Abandoned_Reset,Condition(function Trig_Arena_Abandoned_Reset_Conditions))
    call TriggerAddAction(gg_trg_Arena_Abandoned_Reset,function Trig_Arena_Abandoned_Reset_Actions)
endfunction

function Register_Arena_Start_Cup takes nothing returns nothing
    set gg_trg_Arena_Start_Cup=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Start_Cup,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Arena_Start_Cup,Condition(function Trig_Arena_Start_Cup_Conditions))
    call TriggerAddAction(gg_trg_Arena_Start_Cup,function Trig_Arena_Start_Cup_Actions)
endfunction

function Register_Arena_StartBattle takes nothing returns nothing
    set gg_trg_Arena_StartBattle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_StartBattle,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Arena_StartBattle,Condition(function Trig_Arena_StartBattle_Conditions))
    call TriggerAddAction(gg_trg_Arena_StartBattle,function Trig_Arena_StartBattle_Actions)
endfunction

function Register_Arena_Leash takes nothing returns nothing
    set gg_trg_Arena_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_Leash,gg_rct_371)
    call TriggerAddCondition(gg_trg_Arena_Leash,Condition(function Trig_Arena_Leash_Conditions))
    call TriggerAddAction(gg_trg_Arena_Leash,function Trig_Arena_Leash_Actions)
endfunction

function Register_Arena_OutOfBounds takes nothing returns nothing
    set gg_trg_Arena_OutOfBounds=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_OutOfBounds)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Arena_OutOfBounds,1.5)
    call TriggerAddCondition(gg_trg_Arena_OutOfBounds,Condition(function Trig_Arena_OutOfBounds_Conditions))
    call TriggerAddAction(gg_trg_Arena_OutOfBounds,function Trig_Arena_OutOfBounds_Actions)
endfunction

function Register_Arena_ToggleCupMode takes nothing returns nothing
    set gg_trg_Arena_ToggleCupMode=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_ToggleCupMode,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arena_ToggleCupMode,Condition(function Trig_Arena_ToggleCupMode_Conditions))
    call TriggerAddAction(gg_trg_Arena_ToggleCupMode,function Trig_Arena_ToggleCupMode_Actions)
endfunction

function Register_Arena_Conquest takes nothing returns nothing
    set gg_trg_Arena_Conquest=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Conquest,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arena_Conquest,Condition(function Trig_Arena_Conquest_Conditions))
    call TriggerAddAction(gg_trg_Arena_Conquest,function Trig_Arena_Conquest_Actions)
endfunction

function Register_Arena_Unlock takes nothing returns nothing
    set gg_trg_Arena_Unlock=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Unlock)
    call TriggerAddAction(gg_trg_Arena_Unlock,function Trig_Arena_Unlock_Actions)
endfunction

function Register_Arena_Cup_Won takes nothing returns nothing
    set gg_trg_Arena_Cup_Won=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Cup_Won)
    call TriggerAddAction(gg_trg_Arena_Cup_Won,function Trig_Arena_Cup_Won_Actions)
endfunction

function Register_Arena_UnlockCups takes nothing returns nothing
    set gg_trg_Arena_UnlockCups=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_UnlockCups)
    call TriggerAddCondition(gg_trg_Arena_UnlockCups,Condition(function Trig_Arena_UnlockCups_Conditions))
    call TriggerAddAction(gg_trg_Arena_UnlockCups,function Trig_Arena_UnlockCups_Actions)
endfunction

function Register_Arena_Omega_Absorbs takes nothing returns nothing
    set gg_trg_Arena_Omega_Absorbs=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Omega_Absorbs)
    call TriggerAddCondition(gg_trg_Arena_Omega_Absorbs,Condition(function Trig_Arena_Omega_Absorbs_Conditions))
    call TriggerAddAction(gg_trg_Arena_Omega_Absorbs,function Trig_Arena_Omega_Absorbs_Actions)
endfunction

function Register_Arena_Shinryu_Absorbs takes nothing returns nothing
    set gg_trg_Arena_Shinryu_Absorbs=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Shinryu_Absorbs)
    call TriggerAddCondition(gg_trg_Arena_Shinryu_Absorbs,Condition(function Trig_Arena_Shinryu_Absorbs_Conditions))
    call TriggerAddAction(gg_trg_Arena_Shinryu_Absorbs,function Trig_Arena_Shinryu_Absorbs_Actions)
endfunction

function Register_Arena_Duel_AI takes nothing returns nothing
    set gg_trg_Arena_Duel_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Duel_AI)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Arena_Duel_AI,udg_DragonBattleTimer)
    call TriggerAddAction(gg_trg_Arena_Duel_AI,function Trig_Arena_Duel_AI_Actions)
endfunction

function Register_Arena_Duel_Ascend takes nothing returns nothing
    set gg_trg_Arena_Duel_Ascend=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Duel_Ascend,EVENT_PLAYER_UNIT_SPELL_FINISH)
    call TriggerAddCondition(gg_trg_Arena_Duel_Ascend,Condition(function Trig_Arena_Duel_Ascend_Conditions))
    call TriggerAddAction(gg_trg_Arena_Duel_Ascend,function Trig_Arena_Duel_Ascend_Actions)
endfunction

function Register_Arena_Duel_Victory takes nothing returns nothing
    set gg_trg_Arena_Duel_Victory=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Duel_Victory)
    call TriggerAddCondition(gg_trg_Arena_Duel_Victory,Condition(function Trig_Arena_Duel_Victory_Conditions))
    call TriggerAddAction(gg_trg_Arena_Duel_Victory,function Trig_Arena_Duel_Victory_Actions)
endfunction

function Register_Arena_Duel_Cleanup takes nothing returns nothing
    set gg_trg_Arena_Duel_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Duel_Cleanup)
    call TriggerAddAction(gg_trg_Arena_Duel_Cleanup,function Trig_Arena_Duel_Cleanup_Actions)
endfunction

function Register_Arena_LeoIntro takes nothing returns nothing
    set gg_trg_Arena_LeoIntro=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Arena_LeoIntro,Player(7),true)
    call TriggerAddCondition(gg_trg_Arena_LeoIntro,Condition(function Trig_Arena_LeoIntro_Conditions))
    call TriggerAddAction(gg_trg_Arena_LeoIntro,function Trig_Arena_LeoIntro_Actions)
endfunction

function Register_Arena_FreezeNpcs takes nothing returns nothing
    set gg_trg_Arena_FreezeNpcs=CreateTrigger()
    call TriggerAddAction(gg_trg_Arena_FreezeNpcs,function Trig_Arena_FreezeNpcs_Actions)
endfunction

function Register_Arena_ToggleShowcase takes nothing returns nothing
    set gg_trg_Arena_ToggleShowcase=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_ToggleShowcase,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arena_ToggleShowcase,Condition(function Trig_Arena_ToggleShowcase_Conditions))
    call TriggerAddAction(gg_trg_Arena_ToggleShowcase,function Trig_Arena_ToggleShowcase_Actions)
endfunction

function Register_Arena_BuyPrize takes nothing returns nothing
    set gg_trg_Arena_BuyPrize=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_BuyPrize,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Arena_BuyPrize,Condition(function Trig_Arena_BuyPrize_Conditions))
    call TriggerAddAction(gg_trg_Arena_BuyPrize,function Trig_Arena_BuyPrize_Actions)
endfunction

function Register_Arena_ExchangeBP takes nothing returns nothing
    set gg_trg_Arena_ExchangeBP=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_ExchangeBP,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Arena_ExchangeBP,Condition(function Trig_Arena_ExchangeBP_Conditions))
    call TriggerAddAction(gg_trg_Arena_ExchangeBP,function Trig_Arena_ExchangeBP_Actions)
endfunction

function Register_Arena_RefreshBPTags takes nothing returns nothing
    set gg_trg_Arena_RefreshBPTags=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_RefreshBPTags)
    call TriggerAddAction(gg_trg_Arena_RefreshBPTags,function Trig_Arena_RefreshBPTags_Actions)
endfunction

function Register_Arena_Round_Start takes nothing returns nothing
    set gg_trg_Arena_Round_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Round_Start)
    call TriggerAddAction(gg_trg_Arena_Round_Start,function Trig_Arena_Round_Start_Actions)
endfunction

function Register_Arena_Round_End takes nothing returns nothing
    set gg_trg_Arena_Round_End=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Round_End)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Round_End,EVENT_PLAYER_UNIT_DEATH)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Round_End,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_Arena_Round_End,Condition(function Trig_Arena_Round_End_Conditions))
    call TriggerAddAction(gg_trg_Arena_Round_End,function Trig_Arena_Round_End_Actions)
endfunction

function Register_Arena_Unit_Data takes nothing returns nothing
    set gg_trg_Arena_Unit_Data=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_Unit_Data,4.)
    call TriggerAddAction(gg_trg_Arena_Unit_Data,function Trig_Arena_Unit_Data_Actions)
endfunction

function Register_Arena_Spawn_Team takes nothing returns nothing
    set gg_trg_Arena_Spawn_Team=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Arena_Spawn_Team,udg_ArenaSpawnTimer)
    call TriggerAddAction(gg_trg_Arena_Spawn_Team,function Trig_Arena_Spawn_Team_Actions)
endfunction

function Register_Arena_InitData takes nothing returns nothing
    set gg_trg_Arena_InitData=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_InitData,4.)
    call TriggerAddAction(gg_trg_Arena_InitData,function Trig_Arena_InitData_Actions)
endfunction

function Register_Arena_TeamData1 takes nothing returns nothing
    set gg_trg_Arena_TeamData1=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_TeamData1,4.)
    call TriggerAddAction(gg_trg_Arena_TeamData1,function Trig_Arena_TeamData1_Actions)
endfunction

function Register_Arena_TeamData2 takes nothing returns nothing
    set gg_trg_Arena_TeamData2=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_TeamData2,4.)
    call TriggerAddAction(gg_trg_Arena_TeamData2,function Trig_Arena_TeamData2_Actions)
endfunction

function Register_Arena_Team_Data_A takes nothing returns nothing
    set gg_trg_Arena_Team_Data_A=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_Team_Data_A,4.)
    call TriggerAddAction(gg_trg_Arena_Team_Data_A,function Trig_Arena_Team_Data_A_Actions)
endfunction

function Register_Arena_Team_Data_B takes nothing returns nothing
    set gg_trg_Arena_Team_Data_B=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_Team_Data_B,4.)
    call TriggerAddAction(gg_trg_Arena_Team_Data_B,function Trig_Arena_Team_Data_B_Actions)
endfunction

function Register_Arena_Pick_Team takes nothing returns nothing
    set gg_trg_Arena_Pick_Team=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Pick_Team)
    call TriggerAddAction(gg_trg_Arena_Pick_Team,function Trig_Arena_Pick_Team_Actions)
endfunction

function Register_Arena_SyncTeams takes nothing returns nothing
    set gg_trg_Arena_SyncTeams=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_SyncTeams)
    call TriggerAddAction(gg_trg_Arena_SyncTeams,function Trig_Arena_SyncTeams_Actions)
endfunction

// Creates part 1 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Arena_Part1 takes nothing returns nothing
    call Register_Arena_Leash()
endfunction

// Creates part 2 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Arena_Part2 takes nothing returns nothing
    call Register_Arena_FreezeNpcs()
    call Register_Arena_Unlock()
    call Register_Arena_LeoIntro()
    call Register_Arena_InitData()
    call Register_Arena_TeamData1()
    call Register_Arena_TeamData2()
    call Register_Arena_Team_Data_A()
    call Register_Arena_Team_Data_B()
    call Register_Arena_Unit_Data()
    call Register_Arena_Lock_Controls()
    call Register_Arena_Enter_Region()
    call Register_Arena_Start_Cup()
    call Register_Arena_Pick_Team()
    call Register_Arena_Round_Start()
    call Register_Arena_Spawn_Team()
    call Register_Arena_Round_End()
    call Register_Arena_Cup_Won()
    call Register_Arena_UnlockCups()
    call Register_Arena_SyncTeams()
    call Register_Arena_StartBattle()
    call Register_Arena_FoeDeath()
    call Register_Arena_PlayerLeft()
    call Register_Arena_BattleLost()
    call Register_Arena_BuyPrize()
    call Register_Arena_OutOfBounds()
    call Register_Arena_GateWrongSide()
    call Register_Arena_GateOpen()
endfunction

// Creates part 3 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Arena_Part3 takes nothing returns nothing
    call Register_Arena_ToggleShowcase()
    call Register_Arena_ToggleCupMode()
    call Register_Arena_ExchangeBP()
    call Register_Arena_Conquest()
    call Register_Arena_RefreshBPTags()
endfunction

// Creates part 4 of 4 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Arena_Part4 takes nothing returns nothing
    call Register_Arena_Enter_Eject()
    call Register_Arena_Leave_Player()
    call Register_Arena_Abandoned_Reset()
    call Register_Arena_Duel_AI()
    call Register_Arena_Omega_Absorbs()
    call Register_Arena_Shinryu_Absorbs()
    call Register_Arena_Duel_Ascend()
    call Register_Arena_Duel_Victory()
    call Register_Arena_Duel_Cleanup()
endfunction

endlibrary

library TBossShinryu requires TCam, TCine, TDifficulty, TMusic, TPlayerPart01, TText, TWait
function Trig_Boss_Shinryu_Warmech_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[7]==false)
endfunction

function Trig_Boss_Shinryu_Warmech_Summon_FirstEncounterDialog takes nothing returns boolean
    return(udg_RingHintUsed[7]==false)
endfunction

function Trig_Boss_Shinryu_Warmech_Summon_CoinFlip takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Boss_Shinryu_Warmech_Summon_Actions takes nothing returns nothing
    set udg_BossCleanupTrigger=gg_trg_Arena_Duel_Cleanup
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    call Wait_Polled(1.)
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    // (udg_EnemyHandicap) divided by (GetPlayerHandicapBJ(Player(11))).
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_633)
    call CreateNUnitsAtLoc(1,'U01N',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'U01N': unit "Zombie Dragon"; $B = 11
    set udg_ShinryuUnit=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call AddSpecialEffectTargetUnitBJ("origin",udg_ShinryuUnit,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_ShinryuUnit,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetHeroLevelBJ(udg_ShinryuUnit,99,false)
    call SetUnitInvulnerable(udg_ShinryuUnit,true)
    call PauseUnitBJ(true,udg_ShinryuUnit)
    call Cam_PanToUnit(udg_ShinryuUnit,.2)
    call Wait_Polled(1.5)
    if(Trig_Boss_Shinryu_Warmech_Summon_FirstEncounter())then
        call Text_Transmission(udg_ShinryuUnit,"Shinryu Altana"," "," ",null,6.,true)
        set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_DuelArenaPlayers))
        call Text_Say(udg_CinematicActor,"So this is the true form of the God Dragon is it... it seems immensely powerful.",true)
    endif
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    // (udg_EnemyHandicap) divided by (GetPlayerHandicapBJ(Player(11))).
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_639)
    call CreateNUnitsAtLoc(1,'E01J',Player($B),udg_TempPoint,270.) // 'E01J': unit "Warmech"; $B = 11
    set udg_WarmechUnit=GetLastCreatedUnit()
    call RemoveLocation(udg_TempPoint)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call AddSpecialEffectTargetUnitBJ("origin",udg_WarmechUnit,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_WarmechUnit,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call SetHeroLevelBJ(udg_WarmechUnit,99,false)
    call SetUnitInvulnerable(udg_WarmechUnit,true)
    call PauseUnitBJ(true,udg_WarmechUnit)
    call Cam_PanToUnit(udg_WarmechUnit,.2)
    call Wait_Polled(1.)
    call SetUnitFacingTimed(udg_ShinryuUnit,.0,.5)
    call SetUnitFacingTimed(udg_WarmechUnit,180.,.5)
    call Wait_Polled(.5)
    if(Trig_Boss_Shinryu_Warmech_Summon_FirstEncounterDialog())then
        set udg_RingHintUsed[7]=true
        call Text_Say(udg_WarmechUnit,"PRIMARY TARGET LOCATED. [ACTIVATING COMBAT MODE.]",true)
        call Text_Say(udg_CinematicActor,"Uh... I get the feeling we're not supposed to be here. Are they going to fight each other?",true)
        call Text_Say(udg_CinematicActor,"Hmm, if they do, we might be able to strike when they wear each other down.",true)
        call Text_Say(udg_CinematicActor,"Let's not get too caught up in their battle meanwhile.",true)
    endif
    call AddSpecialEffectTargetUnitBJ("origin",udg_WarmechUnit,"Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_ShinryuUnit,"Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(1.)
    call SetUnitInvulnerable(udg_ShinryuUnit,false)
    call PauseUnitBJ(false,udg_ShinryuUnit)
    call SetUnitInvulnerable(udg_WarmechUnit,false)
    call PauseUnitBJ(false,udg_WarmechUnit)
    call UnitAddAbilityBJ('A0T9',udg_WarmechUnit) // 'A0T9': ability "Last Stand"
    call UnitAddAbilityBJ('A0T9',udg_ShinryuUnit) // 'A0T9': ability "Last Stand"
    call Music_SetTrack(55)
    call GroupAddUnitSimple(udg_WarmechUnit,udg_BossGroup)
    call GroupAddUnitSimple(udg_ShinryuUnit,udg_BossGroup)
    if(Trig_Boss_Shinryu_Warmech_Summon_CoinFlip())then
        set udg_DragonBattlePhase=0
    else
        set udg_DragonBattlePhase=20
    endif
    call StartTimerBJ(udg_DragonBattleTimer,false,.01)
    call EnableTrigger(gg_trg_Arena_Duel_AI)
    call TriggerRegisterUnitEvent(gg_trg_Arena_Omega_Absorbs,udg_ShinryuUnit,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Arena_Shinryu_Absorbs,udg_WarmechUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Arena_Omega_Absorbs)
    call EnableTrigger(gg_trg_Arena_Shinryu_Absorbs)
    call Cine_Exit()
endfunction

function InitTrig_Boss_Shinryu takes nothing returns nothing
endfunction

endlibrary

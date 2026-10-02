library TBossDemiFiend requires TCam, TCine, TDifficulty, TGroup, TJob, TLoc, TMusic, TPlayerPart01, TText, TWait
globals
    // Variables only this module uses.
    unit udg_DemiFiendUnit=null
    unit udg_DemiFiendDemon1=null
    unit udg_DemiFiendDemon2=null
    integer udg_DemiFiendDemonIndex=0
    boolean udg_DemiFiendHealed=false
endglobals

function Trig_Boss_DemiFiend_Summon_FilterPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_Boss_DemiFiend_Summon_AddSleepEffect takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("overhead",GetEnumUnit(),"Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
endfunction

function Trig_Boss_DemiFiend_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[5]==false)
endfunction

function Trig_Boss_DemiFiend_Summon_FirstEncounterDialog takes nothing returns boolean
    return(udg_RingHintUsed[5]==false)
endfunction

function Trig_Boss_DemiFiend_Summon_Actions takes nothing returns nothing
    set udg_BossCleanupTrigger=gg_trg_Boss_DemiFiend_Cleanup
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    call Wait_Polled(1.)
    set udg_TempGroup=Group_UnitsInRect(gg_rct_496,Condition(function Trig_Boss_DemiFiend_Summon_FilterPlayerUnit))
    call ForGroupBJ(udg_TempGroup,function Trig_Boss_DemiFiend_Summon_AddSleepEffect)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    call Wait_Polled(2)
    if(Trig_Boss_DemiFiend_Summon_FirstEncounter())then
        call Text_Say(null,"You feel faint...",true)
    endif
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    // (udg_EnemyHandicap) divided by (GetPlayerHandicapBJ(Player(11))).
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_632)
    call CreateNUnitsAtLoc(1,'E00Z',Player($B),udg_TempPoint,270.) // 'E00Z': unit "Demi Fiend"; $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_DemiFiendUnit=GetLastCreatedUnit()
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call SetHeroLevelBJ(udg_DemiFiendUnit,99,false)
    call SetUnitLifePercentBJ(udg_DemiFiendUnit,'d')
    call SetUnitManaPercentBJ(udg_DemiFiendUnit,'d')
    call SetUnitInvulnerable(udg_DemiFiendUnit,true)
    call PauseUnitBJ(true,udg_DemiFiendUnit)
    call SetUnitAnimation(udg_DemiFiendUnit,"birth")
    call QueueUnitAnimationBJ(udg_DemiFiendUnit,"stand")
    call CinematicFilterGenericBJ(1.,BLEND_MODE_BLEND,"ReplaceableTextures\\CameraMasks\\White_mask.blp",.0,.0,.0,.0,0,0,0,50.)
    call Wait_Polled(2.)
    call SetUnitFacingTimed(udg_DemiFiendUnit,90.,1.)
    if(Trig_Boss_DemiFiend_Summon_FirstEncounterDialog())then
        set udg_RingHintUsed[5]=true
        call Text_Say(null,"You feel the presence of a truly terrifying being...",true)
    else
        call Wait_Polled(1.5)
    endif
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,.0,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
    set udg_TempPoint=GetUnitLoc(udg_DemiFiendUnit)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,196.,-32.)
    call CreateNUnitsAtLoc(1,'n0A5',Player($B),udg_TempPoint2,90.) // 'n0A5': unit "Cu Chulainn"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    set udg_DemiFiendDemon1=GetLastCreatedUnit()
    call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),5120.)
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-196.,-32.)
    call CreateNUnitsAtLoc(1,'n0A4',Player($B),udg_TempPoint2,90.) // 'n0A4': unit "Girimehkala"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    set udg_DemiFiendDemon2=GetLastCreatedUnit()
    call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),5120.)
    call RemoveLocation(udg_TempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_GayaRageLoc=GetUnitLoc(GetTriggerUnit())
    set udg_DemiFiendDemonIndex=3
    set udg_DemiFiendHealed=false
    call StartTimerBJ(udg_DemiFiendDemon1Timer,false,120.)
    call StartTimerBJ(udg_DemiFiendDemon2Timer,false,120.)
    call SetUnitInvulnerable(udg_DemiFiendUnit,false)
    call PauseUnitBJ(false,udg_DemiFiendUnit)
    call Music_SetTrack(28)
    call GroupAddUnitSimple(udg_DemiFiendUnit,udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Boss_DemiFiend_Mediarahan,udg_DemiFiendUnit,EVENT_UNIT_DAMAGED)
    call TriggerRegisterUnitEvent(gg_trg_Boss_DemiFiend_Death,udg_DemiFiendUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Spell_GayaRage_Start)
    call EnableTrigger(gg_trg_Boss_DemiFiend_Demon1_Death)
    call EnableTrigger(gg_trg_Boss_DemiFiend_Demon1_Spawn)
    call EnableTrigger(gg_trg_Boss_DemiFiend_Demon2_Death)
    call EnableTrigger(gg_trg_Boss_DemiFiend_Demon2_Spawn)
    call EnableTrigger(gg_trg_Boss_DemiFiend_Mediarahan)
    call EnableTrigger(gg_trg_Boss_DemiFiend_Death)
    call Cine_Exit()
endfunction

function Trig_Boss_DemiFiend_Demon1_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_DemiFiendDemon1)
endfunction

function Trig_Boss_DemiFiend_Demon1_Death_Actions takes nothing returns nothing
    set udg_DemiFiendDemon1=null
    call StartTimerBJ(udg_DemiFiendDemon1Timer,false,5.)
endfunction

function Trig_Boss_DemiFiend_Demon2_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_DemiFiendDemon2)
endfunction

function Trig_Boss_DemiFiend_Demon2_Death_Actions takes nothing returns nothing
    set udg_DemiFiendDemon2=null
    call StartTimerBJ(udg_DemiFiendDemon2Timer,false,5.)
endfunction

function Trig_Boss_DemiFiend_Demon1_Spawn_Demon2Alive takes nothing returns boolean
    return(udg_DemiFiendDemon2!=null)
endfunction

function Trig_Boss_DemiFiend_Demon1_Spawn_CollectHero takes nothing returns nothing
    call GroupAddUnitSimple(Player_GetHero(GetEnumPlayer()),udg_TempGroup)
endfunction

function Trig_Boss_DemiFiend_Demon1_Spawn_IsSleepTurn takes nothing returns boolean
    // The remainder after dividing (udg_DemiFiendDemonIndex) by (3).
    return(ModuloInteger(udg_DemiFiendDemonIndex,3)==0)
endfunction

function Trig_Boss_DemiFiend_Demon1_Spawn_Demon1Dead takes nothing returns boolean
    return(udg_DemiFiendDemon1==null)
endfunction

function Trig_Boss_DemiFiend_Demon1_Spawn_Actions takes nothing returns nothing
    if(Trig_Boss_DemiFiend_Demon1_Spawn_Demon1Dead())then
        set udg_TempPoint=GetUnitLoc(udg_DemiFiendUnit)
        // (facing in degrees of udg_DemiFiendUnit) plus (135).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(GetUnitFacing(udg_DemiFiendUnit)+135.))
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,udg_GlyphDemonType[udg_DemiFiendDemonIndex],Player($B),udg_TempPoint2,GetUnitFacing(udg_DemiFiendUnit)) // $B = 11
        call RemoveLocation(udg_TempPoint2)
        set udg_DemiFiendDemon1=GetLastCreatedUnit()
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),5120.)
        call SetUnitManaPercentBJ(udg_DemiFiendDemon1,'d')
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Boss_DemiFiend_Demon1_Spawn_IsSleepTurn())then
            call UnitAddAbilityBJ('A16M',udg_DemiFiendDemon1) // 'A16M': ability "Dormina"
            set udg_TempGroup=CreateGroup()
            call ForForce(udg_DuelArenaPlayers,function Trig_Boss_DemiFiend_Demon1_Spawn_CollectHero)
            call IssueTargetOrderBJ(udg_DemiFiendDemon1,"sleep",GroupPickRandomUnit(udg_TempGroup))
            call DestroyGroup(udg_TempGroup)
            call IssueImmediateOrderBJ(udg_DemiFiendUnit,"channel")
        endif
        // (the remainder after dividing (udg_DemiFiendDemonIndex) by (6)) plus (1).
        set udg_DemiFiendDemonIndex=(ModuloInteger(udg_DemiFiendDemonIndex,6)+1)
        call StartTimerBJ(udg_DemiFiendDemon1Timer,false,120.)
    else
        set udg_TempPoint=GetUnitLoc(udg_DemiFiendDemon1)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateTextTagLocBJ("|cffffcc00RECARMDRA",udg_TempPoint,0,13.,'d','d','d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
        call KillUnit(udg_DemiFiendDemon1)
        set udg_DispelTarget=udg_DemiFiendUnit
        call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
        set udg_DemiFiendHealed=false
        call SetUnitLifePercentBJ(udg_DemiFiendUnit,'d')
        call SetUnitManaPercentBJ(udg_DemiFiendUnit,'d')
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendUnit,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Boss_DemiFiend_Demon1_Spawn_Demon2Alive())then
            call SetUnitLifePercentBJ(udg_DemiFiendDemon2,'d')
            call SetUnitManaPercentBJ(udg_DemiFiendDemon2,'d')
            call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
endfunction

function Trig_Boss_DemiFiend_Demon2_Spawn_Demon1Alive takes nothing returns boolean
    return(udg_DemiFiendDemon1!=null)
endfunction

function Trig_Boss_DemiFiend_Demon2_Spawn_CollectHero takes nothing returns nothing
    call GroupAddUnitSimple(Player_GetHero(GetEnumPlayer()),udg_TempGroup)
endfunction

function Trig_Boss_DemiFiend_Demon2_Spawn_IsSleepTurn takes nothing returns boolean
    // The remainder after dividing (udg_DemiFiendDemonIndex) by (3).
    return(ModuloInteger(udg_DemiFiendDemonIndex,3)==0)
endfunction

function Trig_Boss_DemiFiend_Demon2_Spawn_Demon2Dead takes nothing returns boolean
    return(udg_DemiFiendDemon2==null)
endfunction

function Trig_Boss_DemiFiend_Demon2_Spawn_Actions takes nothing returns nothing
    if(Trig_Boss_DemiFiend_Demon2_Spawn_Demon2Dead())then
        set udg_TempPoint=GetUnitLoc(udg_DemiFiendUnit)
        // (facing in degrees of udg_DemiFiendUnit) plus (225).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(GetUnitFacing(udg_DemiFiendUnit)+225.))
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,udg_GlyphDemonType[udg_DemiFiendDemonIndex],Player($B),udg_TempPoint2,GetUnitFacing(udg_DemiFiendUnit)) // $B = 11
        call RemoveLocation(udg_TempPoint2)
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),5120.)
        set udg_DemiFiendDemon2=GetLastCreatedUnit()
        call SetUnitManaPercentBJ(udg_DemiFiendDemon2,'d')
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Boss_DemiFiend_Demon2_Spawn_IsSleepTurn())then
            call UnitAddAbilityBJ('A16M',udg_DemiFiendDemon2) // 'A16M': ability "Dormina"
            set udg_TempGroup=CreateGroup()
            call ForForce(udg_DuelArenaPlayers,function Trig_Boss_DemiFiend_Demon2_Spawn_CollectHero)
            call IssueTargetOrderBJ(udg_DemiFiendDemon2,"sleep",GroupPickRandomUnit(udg_TempGroup))
            call DestroyGroup(udg_TempGroup)
            call IssueImmediateOrderBJ(udg_DemiFiendUnit,"channel")
        endif
        // (the remainder after dividing (udg_DemiFiendDemonIndex) by (6)) plus (1).
        set udg_DemiFiendDemonIndex=(ModuloInteger(udg_DemiFiendDemonIndex,6)+1)
        call StartTimerBJ(udg_DemiFiendDemon2Timer,false,120.)
    else
        set udg_TempPoint=GetUnitLoc(udg_DemiFiendDemon2)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateTextTagLocBJ("|cffffcc00RECARMDRA",udg_TempPoint,0,13.,'d','d','d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
        call KillUnit(udg_DemiFiendDemon2)
        set udg_DispelTarget=udg_DemiFiendUnit
        call ConditionalTriggerExecute(gg_trg_Remove_Debuffs)
        set udg_DemiFiendHealed=false
        call SetUnitLifePercentBJ(udg_DemiFiendUnit,'d')
        call SetUnitManaPercentBJ(udg_DemiFiendUnit,'d')
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendUnit,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Boss_DemiFiend_Demon2_Spawn_Demon1Alive())then
            call SetUnitLifePercentBJ(udg_DemiFiendDemon1,'d')
            call SetUnitManaPercentBJ(udg_DemiFiendDemon1,'d')
            call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
endfunction

function Trig_Boss_DemiFiend_Mediarahan_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_DemiFiendUnit)
endfunction

function Trig_Boss_DemiFiend_Mediarahan_Demon1Alive takes nothing returns boolean
    return(udg_DemiFiendDemon1!=null)
endfunction

function Trig_Boss_DemiFiend_Mediarahan_Demon1AliveTag takes nothing returns boolean
    return(udg_DemiFiendDemon1!=null)
endfunction

function Trig_Boss_DemiFiend_Mediarahan_Demon2Alive takes nothing returns boolean
    return(udg_DemiFiendDemon2!=null)
endfunction

function Trig_Boss_DemiFiend_Mediarahan_ShouldHeal takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(udg_DemiFiendHealed==false)and(GetUnitLifePercent(GetTriggerUnit())<50.)
endfunction

function Trig_Boss_DemiFiend_Mediarahan_Actions takes nothing returns nothing
    if(Trig_Boss_DemiFiend_Mediarahan_ShouldHeal())then
        set udg_DemiFiendHealed=true
        call SetUnitLifePercentBJ(udg_DemiFiendUnit,'d')
        call SetUnitManaPercentBJ(udg_DemiFiendUnit,'d')
        call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendUnit,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        if(Trig_Boss_DemiFiend_Mediarahan_Demon1Alive())then
            call SetUnitLifePercentBJ(udg_DemiFiendDemon1,'d')
            call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon1,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
        if(Trig_Boss_DemiFiend_Mediarahan_Demon2Alive())then
            call SetUnitLifePercentBJ(udg_DemiFiendDemon2,'d')
            call AddSpecialEffectTargetUnitBJ("origin",udg_DemiFiendDemon2,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set udg_TempPoint=GetUnitLoc(udg_DemiFiendDemon2)
        else
            if(Trig_Boss_DemiFiend_Mediarahan_Demon1AliveTag())then
                set udg_TempPoint=GetUnitLoc(udg_DemiFiendDemon1)
            else
                set udg_TempPoint=GetUnitLoc(udg_DemiFiendUnit)
            endif
        endif
        call CreateTextTagLocBJ("|cffffcc00MEDIARAHAN",udg_TempPoint,0,13.,'d','d','d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    endif
endfunction

function Trig_Boss_DemiFiend_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_DemiFiendUnit)
endfunction

function Trig_Boss_DemiFiend_Death_ShouldRecordKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_DemiFiend_Death_CanMasterJob takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_SummonerPlayer))==3)and(IsPlayerInForce(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Boss_DemiFiend_Death_SummonerIsPlayer takes nothing returns boolean
    return(udg_SummonerPlayer!=Player($B)) // $B = 11
endfunction

function Trig_Boss_DemiFiend_Death_SoloGame takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==1)
endfunction

function Trig_Boss_DemiFiend_Death_NeedsQuest20 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[20])==false)
endfunction

function Trig_Boss_DemiFiend_Death_GrantQuest20 takes nothing returns nothing
    if(Trig_Boss_DemiFiend_Death_NeedsQuest20())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=20
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Boss_DemiFiend_Death_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_DemiFiend_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_DemiFiend_Death_ShouldRecordKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(28)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon1_Death)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon1_Spawn)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon2_Death)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon2_Spawn)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Mediarahan)
    call RemoveLocation(udg_GayaRageLoc)
    call KillUnit(udg_DemiFiendDemon1)
    set udg_DemiFiendDemon1=null
    call KillUnit(udg_DemiFiendDemon2)
    set udg_DemiFiendDemon2=null
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    if(Trig_Boss_DemiFiend_Death_SummonerIsPlayer())then
        set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_SummonerPlayer))
        if(Trig_Boss_DemiFiend_Death_CanMasterJob())then
            call ForceAddPlayerSimple(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])
            call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_SummonerPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Boss_DemiFiend_Death_SoloGame())then
        call CreateItemLoc('I0G5',udg_TempPoint) // 'I0G5': item "Masakados"
    else
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=CountPlayersInForceBJ(udg_PlayingPlayers)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // Result 1: loop counter A treated as a decimal-capable number.
            // Result 2: (360) times (result 1).
            // Result 3: CountPlayersInForceBJ(udg_PlayingPlayers) treated as a decimal-capable number.
            // Result 4: (result 2) divided by (result 3).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,((360.*I2R(GetForLoopIndexA()))/ I2R(CountPlayersInForceBJ(udg_PlayingPlayers))))
            call CreateItemLoc('I0G5',udg_TempPoint2) // 'I0G5': item "Masakados"
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    call RemoveLocation(udg_TempPoint)
    call ForForce(udg_PlayingPlayers,function Trig_Boss_DemiFiend_Death_GrantQuest20)
    if(Trig_Boss_DemiFiend_Death_IsWaygateOpen())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call RemoveItem(udg_SummonItem)
    set udg_RingHintsReady=true
    call UnitRemoveAbilityBJ('A0U9',gg_unit_n03T_0008) // 'A0U9': ability "Magatama Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_DemiFiend_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon1_Death)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon1_Spawn)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon2_Death)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Demon2_Spawn)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Mediarahan)
    call DisableTrigger(gg_trg_Boss_DemiFiend_Death)
    call GroupRemoveUnitSimple(udg_DemiFiendUnit,udg_BossGroup)
    call Music_ClearTrack(28)
    call KillUnit(udg_DemiFiendUnit)
    call RemoveUnit(udg_DemiFiendUnit)
    call KillUnit(udg_DemiFiendDemon1)
    call RemoveUnit(udg_DemiFiendDemon1)
    set udg_DemiFiendDemon1=null
    call KillUnit(udg_DemiFiendDemon2)
    call RemoveUnit(udg_DemiFiendDemon2)
    set udg_DemiFiendDemon2=null
endfunction

function InitTrig_Boss_DemiFiend takes nothing returns nothing
endfunction

endlibrary

library TBossPenance requires TCam, TCine, TDifficulty, TGroup, TJob, TLoc, TMusic, TPlayerPart01, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Penance_Summon=null
    trigger gg_trg_Boss_Penance_Judgment_Loop=null
    trigger gg_trg_Boss_Penance_JudgmentDay_Cast=null
    trigger gg_trg_Boss_Penance_JudgmentDay_Damage=null
    trigger gg_trg_Boss_Penance_Arm_Death=null
    trigger gg_trg_Boss_Penance_Death=null
    trigger gg_trg_Boss_Penance_Cleanup=null
    // Variables only this module uses.
    unit udg_PenanceUnit=null
endglobals

function Trig_Boss_Penance_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[1]==false)
endfunction

function Trig_Boss_Penance_Summon_UnpauseArm takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Boss_Penance_Summon_Actions takes nothing returns nothing
    set udg_BossCleanupTrigger=gg_trg_Boss_Penance_Cleanup
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    if(Trig_Boss_Penance_Summon_FirstEncounter())then
        set udg_RingHintUsed[1]=true
        set udg_TempPoint=GetRectCenter(gg_rct_472)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetRectCenter(gg_rct_472)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_472)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    call Difficulty_SumHandicap(udg_DuelArenaPlayers)
    // (udg_EnemyHandicap) divided by (GetPlayerHandicapBJ(Player(11))).
    set udg_EnemyHandicap=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set udg_TempPoint=GetRectCenter(gg_rct_633)
    call CreateNUnitsAtLoc(1,'N03K',Player($B),udg_TempPoint,.0) // 'N03K': unit "The Judge"; $B = 11
    set udg_PenanceUnit=GetLastCreatedUnit()
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call SetUnitInvulnerable(udg_PenanceUnit,true)
    call PauseUnitBJ(true,udg_PenanceUnit)
    call SetHeroLevelBJ(udg_PenanceUnit,97,false)
    call UnitAddItemByIdSwapped('I0H3',udg_PenanceUnit) // 'I0H3': item "Left Arm"
    call UnitAddItemByIdSwapped('I0H4',udg_PenanceUnit) // 'I0H4': item "Right Arm"
    call Cam_PanToUnit(udg_PenanceUnit,0)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AItb\\AItbTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,256.,128.)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'n08E',Player($B),udg_TempPoint2,.0) // 'n08E': unit "Penance's Left Arm"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_PenanceArms)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,256.,-128.)
    call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'n08B',Player($B),udg_TempPoint2,.0) // 'n08B': unit "Penance's Right Arm"; $B = 11
    call RemoveLocation(udg_TempPoint2)
    call PauseUnitBJ(true,GetLastCreatedUnit())
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_PenanceArms)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
    // ((maximum health of GetLastCreatedUnit()) times (udg_EnemyHandicap)) with its decimal part removed.
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_EnemyHandicap)))
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(2.)
    set udg_PenanceArmsActive=true
    call SetUnitInvulnerable(udg_PenanceUnit,false)
    call PauseUnitBJ(false,udg_PenanceUnit)
    call Music_SetTrack(24)
    call GroupAddUnitSimple(udg_PenanceUnit,udg_BossGroup)
    call ForGroupBJ(udg_PenanceArms,function Trig_Boss_Penance_Summon_UnpauseArm)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Penance_Death,udg_PenanceUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_Penance_Death)
    call Cine_Exit()
endfunction

function Trig_Boss_Penance_Judgment_Loop_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PenanceUnits)==false)
endfunction

function Trig_Boss_Penance_Judgment_Loop_FilterLeftArm takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RP',GetFilterUnit())>0) // 'A0RP': ability "Shielding Arm"
endfunction

function Trig_Boss_Penance_Judgment_Loop_FilterRightArm takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XP',GetFilterUnit())>0) // 'A0XP': ability "Shielding Arm"
endfunction

function Trig_Boss_Penance_Judgment_Loop_FilterAnyArm takes nothing returns boolean
    return GetBooleanOr(Trig_Boss_Penance_Judgment_Loop_FilterLeftArm(),Trig_Boss_Penance_Judgment_Loop_FilterRightArm())
endfunction

function Trig_Boss_Penance_Judgment_Loop_IsChanneling takes nothing returns boolean
    return(GetUnitCurrentOrder(GetEnumUnit())==$D0278) // $D0278 = 852600
endfunction

function Trig_Boss_Penance_Judgment_Loop_BothArmsAlive takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)>=2)
endfunction

function Trig_Boss_Penance_Judgment_Loop_CheckArmsAndChannel takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(2500.,udg_TempPoint,Condition(function Trig_Boss_Penance_Judgment_Loop_FilterAnyArm))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Penance_Judgment_Loop_BothArmsAlive())then
        call DestroyGroup(udg_TempGroup)
        call IssueImmediateOrderBJ(GetEnumUnit(),"channel")
    else
        call DestroyGroup(udg_TempGroup)
        if(Trig_Boss_Penance_Judgment_Loop_IsChanneling())then
            call UnitRemoveAbilityBJ('A11W',GetTriggerUnit()) // 'A11W': ability "Judgment Day"
            call Wait_Polled(10.)
            call UnitAddAbilityBJ('A11W',GetTriggerUnit()) // 'A11W': ability "Judgment Day"
        endif
    endif
endfunction

function Trig_Boss_Penance_Judgment_Loop_Actions takes nothing returns nothing
    call ForGroupBJ(udg_PenanceUnits,function Trig_Boss_Penance_Judgment_Loop_CheckArmsAndChannel)
endfunction

function Trig_Boss_Penance_JudgmentDay_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A11W') // 'A11W': ability "Judgment Day"
endfunction

function Trig_Boss_Penance_JudgmentDay_Cast_FilterLeftArm takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RP',GetFilterUnit())>0) // 'A0RP': ability "Shielding Arm"
endfunction

function Trig_Boss_Penance_JudgmentDay_Cast_FilterRightArm takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0XP',GetFilterUnit())>0) // 'A0XP': ability "Shielding Arm"
endfunction

function Trig_Boss_Penance_JudgmentDay_Cast_FilterAnyArm takes nothing returns boolean
    return GetBooleanOr(Trig_Boss_Penance_JudgmentDay_Cast_FilterLeftArm(),Trig_Boss_Penance_JudgmentDay_Cast_FilterRightArm())
endfunction

function Trig_Boss_Penance_JudgmentDay_Cast_ArmsMissing takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)<2)
endfunction

function Trig_Boss_Penance_JudgmentDay_Cast_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(2500.,udg_TempPoint,Condition(function Trig_Boss_Penance_JudgmentDay_Cast_FilterAnyArm))
    if(Trig_Boss_Penance_JudgmentDay_Cast_ArmsMissing())then
        call RemoveLocation(udg_TempPoint)
        call DestroyGroup(udg_TempGroup)
        call UnitRemoveAbilityBJ('A11W',GetTriggerUnit()) // 'A11W': ability "Judgment Day"
        call Wait_Polled(10.)
        call UnitAddAbilityBJ('A11W',GetTriggerUnit()) // 'A11W': ability "Judgment Day"
    else
        call DestroyGroup(udg_TempGroup)
        call CreateTextTagLocBJ("|cffffcc00JUDGMENT DAY",udg_TempPoint,0,13.,'d','d','d',0)
        call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
        call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=6
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            // ((loop counter A treated as a decimal-capable number) times (60)) minus (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,325.,((I2R(GetForLoopIndexA())*60.)-30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            // (loop counter A treated as a decimal-capable number) times (60).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,650.,(I2R(GetForLoopIndexA())*60.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            // ((loop counter A treated as a decimal-capable number) times (60)) minus (30).
            set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,975.,((I2R(GetForLoopIndexA())*60.)-30.))
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
            call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
    endif
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A11W') // 'A11W': ability "Judgment Day"
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveRect takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterEnemyRect takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveEnemyRect takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveRect(),Trig_Boss_Penance_JudgmentDay_Damage_FilterEnemyRect())
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterVulnerableRect takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterTargetRect takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveEnemyRect(),Trig_Boss_Penance_JudgmentDay_Damage_FilterVulnerableRect())
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveArea takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterEnemyArea takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveEnemyArea takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveArea(),Trig_Boss_Penance_JudgmentDay_Damage_FilterEnemyArea())
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterVulnerableArea takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_FilterTargetArea takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_Penance_JudgmentDay_Damage_FilterAliveEnemyArea(),Trig_Boss_Penance_JudgmentDay_Damage_FilterVulnerableArea())
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_CasterInArena takes nothing returns boolean
    return(RectContainsLoc(gg_rct_496,udg_TempPoint))
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_DamageTarget takes nothing returns nothing
    call UnitRemoveBuffBJ('B063',GetEnumUnit()) // 'B063': buff "Cover"
    // (a random decimal number between 15 and 16) divided by (16).
    set udg_TempReal=(GetRandomReal(15.,16.)/ 16.)
    set udg_DmgFlagPure=true
    set udg_IgnoresReduction=true
    set udg_DmgFlagUnavoidable=-1
    // (99999.9) times (udg_TempReal).
    call UnitDamageTarget(GetTriggerUnit(),GetEnumUnit(),99999.9*udg_TempReal,true,true,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,null)
endfunction

function Trig_Boss_Penance_JudgmentDay_Damage_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,325.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // ((loop counter A treated as a decimal-capable number) times (60)) minus (30).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,650.,((I2R(GetForLoopIndexA())*60.)-30.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,975.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),4.)
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    if(Trig_Boss_Penance_JudgmentDay_Damage_CasterInArena())then
        set udg_TempGroup=Group_UnitsInRect(gg_rct_496,Condition(function Trig_Boss_Penance_JudgmentDay_Damage_FilterTargetRect))
    else
        set udg_TempGroup=Group_UnitsInRangeOfLoc(1332.,udg_TempPoint,Condition(function Trig_Boss_Penance_JudgmentDay_Damage_FilterTargetArea))
    endif
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_TempGroup,function Trig_Boss_Penance_JudgmentDay_Damage_DamageTarget)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Boss_Penance_Arm_Death_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_PenanceUnits))
endfunction

function Trig_Boss_Penance_Arm_Death_NoArmsLeft takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_PenanceUnits))
endfunction

function Trig_Boss_Penance_Arm_Death_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_PenanceUnits)
    if(Trig_Boss_Penance_Arm_Death_NoArmsLeft())then
        call DisableTrigger(gg_trg_Boss_Penance_Judgment_Loop)
        call DisableTrigger(gg_trg_Boss_Penance_Arm_Death)
    endif
endfunction

function Trig_Boss_Penance_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_PenanceUnit)
endfunction

function Trig_Boss_Penance_Death_ShouldRecordKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Penance_Death_KillArm takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call GroupRemoveUnitSimple(GetEnumUnit(),udg_BossGroup)
    call UnitRemoveAbilityBJ('A0ZR',GetEnumUnit()) // 'A0ZR': ability "Immortal"
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Boss_Penance_Death_CanMasterJob takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_SummonerPlayer))==3)and(IsPlayerInForce(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Boss_Penance_Death_SummonerIsPlayer takes nothing returns boolean
    return(udg_SummonerPlayer!=Player($B)) // $B = 11
endfunction

function Trig_Boss_Penance_Death_EligibleForQuest33 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[33])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[32]))
endfunction

function Trig_Boss_Penance_Death_GrantQuest33 takes nothing returns nothing
    if(Trig_Boss_Penance_Death_EligibleForQuest33())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=33
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Boss_Penance_Death_EligibleForQuest49 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[49])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[33]))
endfunction

function Trig_Boss_Penance_Death_GrantQuest49 takes nothing returns nothing
    if(Trig_Boss_Penance_Death_EligibleForQuest49())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=49
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Boss_Penance_Death_GrantsExtraQuest takes nothing returns boolean
    return(udg_PenanceArmsActive)
endfunction

function Trig_Boss_Penance_Death_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_Penance_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Penance_Death_ShouldRecordKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Music_ClearTrack(24)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateItemLoc('I0E5',udg_TempPoint) // 'I0E5': item "Maximillian"
    call RemoveLocation(udg_TempPoint)
    call ForGroupBJ(udg_PenanceArms,function Trig_Boss_Penance_Death_KillArm)
    call DestroyGroup(udg_PenanceArms)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    if(Trig_Boss_Penance_Death_SummonerIsPlayer())then
        set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_SummonerPlayer))
        if(Trig_Boss_Penance_Death_CanMasterJob())then
            call ForceAddPlayerSimple(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])
            call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_SummonerPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]='x'
    call ForceAddPlayerSimple(Player($A),udg_TitleForce[33]) // $A = 10
    call ForForce(udg_PlayingPlayers,function Trig_Boss_Penance_Death_GrantQuest33)
    if(Trig_Boss_Penance_Death_GrantsExtraQuest())then
        call ForceAddPlayerSimple(Player($A),udg_TitleForce[49]) // $A = 10
        call ForForce(udg_PlayingPlayers,function Trig_Boss_Penance_Death_GrantQuest49)
    endif
    if(Trig_Boss_Penance_Death_IsWaygateOpen())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call RemoveItem(udg_SummonItem)
    set udg_RingHintsReady=true
    call UnitRemoveAbilityBJ('A0HI',gg_unit_n03T_0008) // 'A0HI': ability "Perfect MoD Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Penance_Cleanup_RemoveArm takes nothing returns nothing
    call GroupRemoveUnitSimple(GetEnumUnit(),udg_BossGroup)
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Boss_Penance_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_Penance_Death)
    call GroupRemoveUnitSimple(udg_PenanceUnit,udg_BossGroup)
    call KillUnit(udg_PenanceUnit)
    call RemoveUnit(udg_PenanceUnit)
    call Music_ClearTrack(24)
    call ForGroupBJ(udg_PenanceArms,function Trig_Boss_Penance_Cleanup_RemoveArm)
endfunction

function InitTrig_Boss_Penance takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part11, RegisterTriggers_Boss_Part12 (module Boss),
// which keeps the original registration order.

function Register_Boss_Penance_Summon takes nothing returns nothing
    set gg_trg_Boss_Penance_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Summon)
    call TriggerAddAction(gg_trg_Boss_Penance_Summon,function Trig_Boss_Penance_Summon_Actions)
endfunction

function Register_Boss_Penance_Judgment_Loop takes nothing returns nothing
    set gg_trg_Boss_Penance_Judgment_Loop=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Judgment_Loop)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Boss_Penance_Judgment_Loop,2)
    call TriggerAddCondition(gg_trg_Boss_Penance_Judgment_Loop,Condition(function Trig_Boss_Penance_Judgment_Loop_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_Judgment_Loop,function Trig_Boss_Penance_Judgment_Loop_Actions)
endfunction

function Register_Boss_Penance_JudgmentDay_Cast takes nothing returns nothing
    set gg_trg_Boss_Penance_JudgmentDay_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Penance_JudgmentDay_Cast,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Boss_Penance_JudgmentDay_Cast,Condition(function Trig_Boss_Penance_JudgmentDay_Cast_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_JudgmentDay_Cast,function Trig_Boss_Penance_JudgmentDay_Cast_Actions)
endfunction

function Register_Boss_Penance_JudgmentDay_Damage takes nothing returns nothing
    set gg_trg_Boss_Penance_JudgmentDay_Damage=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Penance_JudgmentDay_Damage,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Boss_Penance_JudgmentDay_Damage,Condition(function Trig_Boss_Penance_JudgmentDay_Damage_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_JudgmentDay_Damage,function Trig_Boss_Penance_JudgmentDay_Damage_Actions)
endfunction

function Register_Boss_Penance_Arm_Death takes nothing returns nothing
    set gg_trg_Boss_Penance_Arm_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Arm_Death)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Boss_Penance_Arm_Death,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Penance_Arm_Death,Condition(function Trig_Boss_Penance_Arm_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_Arm_Death,function Trig_Boss_Penance_Arm_Death_Actions)
endfunction

function Register_Boss_Penance_Death takes nothing returns nothing
    set gg_trg_Boss_Penance_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Death)
    call TriggerAddCondition(gg_trg_Boss_Penance_Death,Condition(function Trig_Boss_Penance_Death_Conditions))
    call TriggerAddAction(gg_trg_Boss_Penance_Death,function Trig_Boss_Penance_Death_Actions)
endfunction

function Register_Boss_Penance_Cleanup takes nothing returns nothing
    set gg_trg_Boss_Penance_Cleanup=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Penance_Cleanup)
    call TriggerAddAction(gg_trg_Boss_Penance_Cleanup,function Trig_Boss_Penance_Cleanup_Actions)
endfunction

endlibrary

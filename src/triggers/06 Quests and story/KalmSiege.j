library TKalmSiege requires TGroup, TLoc, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_KalmSiege_AITick=null
    trigger gg_trg_KalmSiege_LeaderRetreat=null
    trigger gg_trg_KalmSiege_FailRespawn=null
    trigger gg_trg_KalmSiege_DemonRecover=null
    trigger gg_trg_KalmSiege_Init=null
endglobals

function Trig_KalmSiege_AITick_AttackMoveNorth takes nothing returns nothing
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
endfunction

function Trig_KalmSiege_AITick_AttackMoveSouth takes nothing returns nothing
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
endfunction

function Trig_KalmSiege_AITick_AttackRandomTownUnit takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GroupPickRandomUnit(udg_TownTargetGroup))
    call IssuePointOrderLocBJ(GetEnumUnit(),"attack",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_KalmSiege_AITick_TownWiped takes nothing returns boolean
    return(IsUnitGroupDeadBJ(udg_TownTargetGroup))
endfunction

function Trig_KalmSiege_AITick_TownHasUnits takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TownTargetGroup)==false)
endfunction

function Trig_KalmSiege_AITick_IsUnitMoving takes nothing returns boolean
    return(GetUnitCurrentOrder(GetEnumUnit())==$D0012) // $D0012 = 851986
endfunction

function Trig_KalmSiege_AITick_StopMovingUnit takes nothing returns nothing
    if(Trig_KalmSiege_AITick_IsUnitMoving())then
        call IssueImmediateOrderBJ(GetEnumUnit(),"stop")
    endif
endfunction

function Trig_KalmSiege_AITick_ShouldRejuvLeader takes nothing returns boolean
    return(GetUnitLifePercent(udg_RangerHero)>=70.)and(UnitHasBuffBJ(udg_RangerHero,'B006')==false) // 'B006': buff "Regen"
endfunction

function Trig_KalmSiege_AITick_LeaderLacksShell takes nothing returns boolean
    return(UnitHasBuffBJ(udg_RangerHero,'B005')==false) // 'B005': buff "Shell"
endfunction

function Trig_KalmSiege_AITick_LeaderLacksProtect takes nothing returns boolean
    return(UnitHasBuffBJ(udg_RangerHero,'B007')==false) // 'B007': buff "Protect"
endfunction

function Trig_KalmSiege_AITick_LeaderHurt takes nothing returns boolean
    return(GetUnitLifePercent(udg_RangerHero)<99.)
endfunction

function Trig_KalmSiege_AITick_ShouldRejuvHealer takes nothing returns boolean
    return(GetUnitLifePercent(udg_ClericAlly)>=70.)and(UnitHasBuffBJ(udg_ClericAlly,'B006')==false) // 'B006': buff "Regen"
endfunction

function Trig_KalmSiege_AITick_HealerHurt takes nothing returns boolean
    return(GetUnitLifePercent(udg_ClericAlly)<99.)
endfunction

function Trig_KalmSiege_AITick_ShouldRejuvLeaderAlt takes nothing returns boolean
    return(GetUnitLifePercent(udg_RangerHero)>=70.)and(UnitHasBuffBJ(udg_RangerHero,'B006')==false) // 'B006': buff "Regen"
endfunction

function Trig_KalmSiege_AITick_ShouldRejuvHealerAlt takes nothing returns boolean
    return(GetUnitLifePercent(udg_ClericAlly)>=70.)and(UnitHasBuffBJ(udg_ClericAlly,'B006')==false) // 'B006': buff "Regen"
endfunction

function Trig_KalmSiege_AITick_HealerHurtAlt takes nothing returns boolean
    return(GetUnitLifePercent(udg_ClericAlly)<99.)
endfunction

function Trig_KalmSiege_AITick_LeaderLacksShellAlt takes nothing returns boolean
    return(UnitHasBuffBJ(udg_RangerHero,'B005')==false) // 'B005': buff "Shell"
endfunction

function Trig_KalmSiege_AITick_LeaderLacksProtectAlt takes nothing returns boolean
    return(UnitHasBuffBJ(udg_RangerHero,'B007')==false) // 'B007': buff "Protect"
endfunction

function Trig_KalmSiege_AITick_LeaderHurtAlt takes nothing returns boolean
    return(GetUnitLifePercent(udg_RangerHero)<99.)
endfunction

function Trig_KalmSiege_AITick_IsBackupHealerUp takes nothing returns boolean
    return(IsUnitInGroup(udg_ClericAlly,udg_InactiveUnits)==false)
endfunction

function Trig_KalmSiege_AITick_IsPrimaryHealerDown takes nothing returns boolean
    return(IsUnitInGroup(udg_HighPriestAlly,udg_InactiveUnits))
endfunction

function Trig_KalmSiege_AITick_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(udg_RangerHero)
    call ForGroupBJ(udg_SpecialUnits,function Trig_KalmSiege_AITick_AttackMoveNorth)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(udg_EngineerHero)
    call ForGroupBJ(udg_SummonedUnits,function Trig_KalmSiege_AITick_AttackMoveSouth)
    call RemoveLocation(udg_TempPoint)
    if(Trig_KalmSiege_AITick_TownHasUnits())then
        if(Trig_KalmSiege_AITick_TownWiped())then
            call DisableTrigger(GetTriggeringTrigger())
        else
            set udg_TempPoint=GetRectCenter(gg_rct_413)
            call IssuePointOrderLocBJ(gg_unit_U00E_0222,"attack",udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            call ForGroupBJ(udg_EscortUnits,function Trig_KalmSiege_AITick_AttackRandomTownUnit)
        endif
    endif
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege_AITick_StopMovingUnit)
    if(Trig_KalmSiege_AITick_IsPrimaryHealerDown())then
        if(Trig_KalmSiege_AITick_IsBackupHealerUp())then
            if(Trig_KalmSiege_AITick_LeaderHurtAlt())then
                if(Trig_KalmSiege_AITick_ShouldRejuvLeaderAlt())then
                    call IssueTargetOrderBJ(udg_ClericAlly,"rejuvination",udg_RangerHero)
                else
                    call IssueTargetOrderBJ(udg_ClericAlly,"holybolt",udg_RangerHero)
                endif
            else
                if(Trig_KalmSiege_AITick_LeaderLacksProtectAlt())then
                    call IssueTargetOrderBJ(udg_ClericAlly,"frostarmor",udg_RangerHero)
                else
                    if(Trig_KalmSiege_AITick_LeaderLacksShellAlt())then
                        call IssueTargetOrderBJ(udg_ClericAlly,"antimagicshell",udg_RangerHero)
                    else
                        if(Trig_KalmSiege_AITick_HealerHurtAlt())then
                            if(Trig_KalmSiege_AITick_ShouldRejuvHealerAlt())then
                                call IssueTargetOrderBJ(udg_ClericAlly,"rejuvination",udg_ClericAlly)
                            else
                                call IssueTargetOrderBJ(udg_ClericAlly,"holybolt",udg_ClericAlly)
                            endif
                        endif
                    endif
                endif
            endif
        endif
    else
        if(Trig_KalmSiege_AITick_LeaderHurt())then
            if(Trig_KalmSiege_AITick_ShouldRejuvLeader())then
                call IssueTargetOrderBJ(udg_HighPriestAlly,"rejuvination",udg_RangerHero)
            else
                call IssueTargetOrderBJ(udg_HighPriestAlly,"holybolt",udg_RangerHero)
            endif
        else
            if(Trig_KalmSiege_AITick_LeaderLacksProtect())then
                call IssueTargetOrderBJ(udg_HighPriestAlly,"frostarmor",udg_RangerHero)
            else
                if(Trig_KalmSiege_AITick_LeaderLacksShell())then
                    call IssueTargetOrderBJ(udg_HighPriestAlly,"antimagicshell",udg_RangerHero)
                endif
            endif
        endif
        if(Trig_KalmSiege_AITick_HealerHurt())then
            if(Trig_KalmSiege_AITick_ShouldRejuvHealer())then
                call IssueTargetOrderBJ(udg_ClericAlly,"rejuvination",udg_ClericAlly)
            else
                call IssueTargetOrderBJ(udg_ClericAlly,"holybolt",udg_ClericAlly)
            endif
        endif
    endif
endfunction

function Trig_KalmSiege_LeaderRetreat_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_AllyRangerGroup))
endfunction

function Trig_KalmSiege_LeaderRetreat_IsPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_ActivePlayers))
endfunction

function Trig_KalmSiege_LeaderRetreat_IsHeroUnit takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_KalmSiege_LeaderRetreat_IsPlayerHero takes nothing returns boolean
    return GetBooleanAnd(Trig_KalmSiege_LeaderRetreat_IsPlayerUnit(),Trig_KalmSiege_LeaderRetreat_IsHeroUnit())
endfunction

function Trig_KalmSiege_LeaderRetreat_NoHeroesNearby takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_KalmSiege_LeaderRetreat_IsEnemyHeroAttacker takes nothing returns boolean
    return((IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(GetOwningPlayer(GetAttacker())==Player($B)))!=null // $B = 11
endfunction

function Trig_KalmSiege_LeaderRetreat_ShouldCastCover takes nothing returns boolean
    return(IsUnitInGroup(udg_BladeKnightAlly,udg_InactiveUnits)==false)and(UnitHasBuffBJ(udg_RangerHero,'B063')==false)and(GetUnitCurrentOrder(udg_BladeKnightAlly)!=$D0269) // 'B063': buff "Cover"; $D0269 = 852585
endfunction

function Trig_KalmSiege_LeaderRetreat_IsLeaderAttacked takes nothing returns boolean
    return(GetTriggerUnit()==udg_RangerHero)
endfunction

function Trig_KalmSiege_LeaderRetreat_IsGuardTooFar takes nothing returns boolean
    return(GetUnitCurrentOrder(GetEnumUnit())!=$D0012)and(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>udg_TempReal) // $D0012 = 851986
endfunction

function Trig_KalmSiege_LeaderRetreat_PullGuardTowardLeader takes nothing returns nothing
    set udg_TempPoint2=GetUnitLoc(GetEnumUnit())
    if(Trig_KalmSiege_LeaderRetreat_IsGuardTooFar())then
        set udg_RetreatPoint=Loc_PolarOffset(udg_TempPoint,(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)/ 2.),AngleBetweenPoints(udg_TempPoint,udg_TempPoint2))
        call RemoveLocation(udg_TempPoint2)
        call IssuePointOrderLocBJ(GetEnumUnit(),"move",udg_RetreatPoint)
        call RemoveLocation(udg_RetreatPoint)
    else
        call RemoveLocation(udg_TempPoint2)
    endif
endfunction

function Trig_KalmSiege_LeaderRetreat_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_KalmSiege_LeaderRetreat_IsLeaderAttacked())then
        if(Trig_KalmSiege_LeaderRetreat_IsEnemyHeroAttacker())then
            set udg_TempPoint2=GetUnitLoc(GetAttacker())
            set udg_TempGroup=Group_UnitsInRangeOfLoc(850.,udg_TempPoint2,Condition(function Trig_KalmSiege_LeaderRetreat_IsPlayerHero))
            if(Trig_KalmSiege_LeaderRetreat_NoHeroesNearby())then
                call DestroyGroup(udg_TempGroup)
                call RemoveLocation(udg_TempPoint2)
            else
                call DestroyGroup(udg_TempGroup)
                set udg_RetreatPoint=Loc_PolarOffset(udg_TempPoint,192.,AngleBetweenPoints(udg_TempPoint2,udg_TempPoint))
                call RemoveLocation(udg_TempPoint2)
                call IssuePointOrderLocBJ(GetTriggerUnit(),"move",udg_RetreatPoint)
                call RemoveLocation(udg_RetreatPoint)
            endif
        endif
        set udg_TempReal=600.
        if(Trig_KalmSiege_LeaderRetreat_ShouldCastCover())then
            call IssueTargetOrderBJ(udg_BladeKnightAlly,"drunkenhaze",udg_RangerHero)
        endif
    else
        set udg_TempReal=1000.
    endif
    call ForGroupBJ(udg_AllyBrothersGroup,function Trig_KalmSiege_LeaderRetreat_PullGuardTowardLeader)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_KalmSiege_FailRespawn_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_EscortUnits))
endfunction

function Trig_KalmSiege_FailRespawn_UseAltSpawnRegion takes nothing returns boolean
    // The remainder after dividing (udg_RaidPowerLevel) by (2).
    return(IsQuestCompleted(udg_MainQuest[9]))and(ModuloInteger(udg_RaidPowerLevel,2)==0)
endfunction

function Trig_KalmSiege_FailRespawn_Actions takes nothing returns nothing
    local location l_tempPoint2
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_EscortUnits)
    call Wait_Polled(1.)
    set udg_RaidPowerLevel=(udg_RaidPowerLevel+1)
    if(Trig_KalmSiege_FailRespawn_UseAltSpawnRegion())then
        // The remainder after dividing (udg_RaidPowerLevel) by (LoadIntegerBJ(1, 2, udg_SpawnDataHashRef)).
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(ModuloInteger(udg_RaidPowerLevel,LoadIntegerBJ(1,2,udg_SpawnDataHashRef)),1,udg_SpawnRectHashRef))
    else
        // The remainder after dividing (udg_RaidPowerLevel) by (LoadIntegerBJ(4, 2, udg_SpawnDataHashRef)).
        set udg_TempPoint=GetRectCenter(LoadRectHandleBJ(ModuloInteger(udg_RaidPowerLevel,LoadIntegerBJ(4,2,udg_SpawnDataHashRef)),4,udg_SpawnRectHashRef))
    endif
    set l_tempPoint2=GetRectCenter(gg_rct_588)
    call CreateNUnitsAtLocFacingLocBJ(1,GetUnitTypeId(GetTriggerUnit()),Player($B),udg_TempPoint,l_tempPoint2) // $B = 11
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_EscortUnits)
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*udg_RaidPowerLevel)/ 4),(1-1))
    call BlzSetUnitBaseDamage(GetLastCreatedUnit(),((BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*udg_RaidPowerLevel)/ 4),1)
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),((BlzGetUnitMaxHP(GetLastCreatedUnit())*udg_RaidPowerLevel)/ 4))
    call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
    call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),800.)
    call SetUnitMoveSpeed(GetLastCreatedUnit(),420.)
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"attack",l_tempPoint2)
    call UnitAddAbilityBJ('ACrk',GetLastCreatedUnit()) // 'ACrk': object name not found in map data
    call UnitAddAbilityBJ('A12U',GetLastCreatedUnit()) // 'A12U': ability "Attack Speed +80%"
    call RemoveLocation(l_tempPoint2)
    set l_tempPoint2=null
endfunction

function Trig_KalmSiege_DemonRecover_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_298)
    call SetUnitPositionLoc(GetTriggerUnit(),l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_413)
    call IssuePointOrderLocBJ(GetTriggerUnit(),"attack",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    // The smaller of (999) and ((Strength of the triggering unit) plus (100)).
    call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_SET,IMinBJ(999,(GetHeroStatBJ(bj_HEROSTAT_STR,GetTriggerUnit(),false)+'d')))
    // The smaller of (999) and ((Agility of the triggering unit) plus (100)).
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_SET,IMinBJ(999,(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),false)+'d')))
    // The smaller of (999) and ((Intelligence of the triggering unit) plus (100)).
    call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_SET,IMinBJ(999,(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),false)+'d')))
    call SetUnitLifePercentBJ(GetTriggerUnit(),'d')
    call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
    set l_tempPoint=null
endfunction

function Trig_KalmSiege_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00E_0222)
    call PauseUnitBJ(true,gg_unit_U00E_0222)
    call SetUnitInvulnerable(gg_unit_U00E_0222,true)
    call IssueImmediateOrderBJ(gg_unit_Hvwd_0098,"holdposition")
    call UnitRemoveAbilityBJ('A00B',gg_unit_Hvwd_0098) // 'A00B': ability "Trueshot Aura"
    call UnitRemoveAbilityBJ('A00P',gg_unit_U00E_0222) // 'A00P': ability "Summon Shambling Corpses"
    call GroupAddUnitSimple(gg_unit_Hvwd_0098,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_Hdgo_0097,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_Hjai_0093,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_H00T_0185,udg_RecruitedAllies)
    call GroupAddUnitSimple(gg_unit_h007_0089,udg_RecruitedAllies)
    call GroupAddGroup(udg_KalmGuards,udg_RecruitedAllies)
    set udg_SiegeNorthUnitType[0]='nogl' // 'nogl': object name not found in map data
    set udg_SiegeNorthUnitType[1]='nwzd' // 'nwzd': object name not found in map data
    set udg_SiegeNorthUnitType[2]='nbld' // 'nbld': object name not found in map data
    set udg_SiegeNorthUnitType[3]='nkog' // 'nkog': object name not found in map data
    set udg_SiegeNorthUnitType[4]='nkol' // 'nkol': object name not found in map data
    set udg_SiegeNorthUnitType[5]='nhdc' // 'nhdc': object name not found in map data
    set udg_SiegeNorthUnitType[6]='nass' // 'nass': object name not found in map data
    set udg_SiegeNorthUnitType[7]='nomg' // 'nomg': object name not found in map data
    set udg_SiegeNorthUnitType[8]='ngns' // 'ngns': object name not found in map data
    set udg_SiegeNorthUnitType[9]='ngnw' // 'ngnw': object name not found in map data
    set udg_SiegeSouthUnitType[0]='nftb' // 'nftb': unit "Forest Goblin Berserker"
    set udg_SiegeSouthUnitType[1]='nchw' // 'nchw': unit "Corrupted Orc Warlock"
    set udg_SiegeSouthUnitType[2]='nfsh' // 'nfsh': unit "Forest Goblin Great Shaman"
    set udg_SiegeSouthUnitType[3]='nchg' // 'nchg': unit "Corrupted Orc Savage"
    set udg_SiegeSouthUnitType[4]='nwlt' // 'nwlt': unit "Forest Wolf"
    set udg_SiegeSouthUnitType[5]='nchr' // 'nchr': unit "Corrupted Orc Wolf Rider"
    set udg_SiegeSouthUnitType[6]='nmrl' // 'nmrl': unit "Forest Triton"
    set udg_SiegeSouthUnitType[7]='nckb' // 'nckb': unit "Corrupted Orc Kodo Rider"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_KalmSiege automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_KalmSiege (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_KalmSiege takes nothing returns nothing
endfunction

function Register_KalmSiege_AITick takes nothing returns nothing
    set gg_trg_KalmSiege_AITick=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege_AITick)
    call TriggerRegisterTimerEventPeriodic(gg_trg_KalmSiege_AITick,5.)
    call TriggerAddAction(gg_trg_KalmSiege_AITick,function Trig_KalmSiege_AITick_Actions)
endfunction

function Register_KalmSiege_LeaderRetreat takes nothing returns nothing
    set gg_trg_KalmSiege_LeaderRetreat=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege_LeaderRetreat)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege_LeaderRetreat,Player(9),EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_KalmSiege_LeaderRetreat,Condition(function Trig_KalmSiege_LeaderRetreat_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege_LeaderRetreat,function Trig_KalmSiege_LeaderRetreat_Actions)
endfunction

function Register_KalmSiege_FailRespawn takes nothing returns nothing
    set gg_trg_KalmSiege_FailRespawn=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege_FailRespawn)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_KalmSiege_FailRespawn,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_KalmSiege_FailRespawn,Condition(function Trig_KalmSiege_FailRespawn_Conditions))
    call TriggerAddAction(gg_trg_KalmSiege_FailRespawn,function Trig_KalmSiege_FailRespawn_Actions)
endfunction

function Register_KalmSiege_DemonRecover takes nothing returns nothing
    set gg_trg_KalmSiege_DemonRecover=CreateTrigger()
    call DisableTrigger(gg_trg_KalmSiege_DemonRecover)
    call TriggerRegisterUnitLifeEvent(gg_trg_KalmSiege_DemonRecover,gg_unit_U00E_0222,LESS_THAN,100.)
    call TriggerAddAction(gg_trg_KalmSiege_DemonRecover,function Trig_KalmSiege_DemonRecover_Actions)
endfunction

function Register_KalmSiege_Init takes nothing returns nothing
    set gg_trg_KalmSiege_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_KalmSiege_Init,function Trig_KalmSiege_Init_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_KalmSiege takes nothing returns nothing
    call Register_KalmSiege_AITick() // starts off; enabled by KalmSiege1, KalmSiege2, KalmSiege3; disabled by KalmSiege1, KalmSiege2, KalmSiege3
    call Register_KalmSiege_LeaderRetreat() // starts off; enabled by KalmSiege1, KalmSiege2, KalmSiege3; disabled by KalmSiege1, KalmSiege2, KalmSiege3
    call Register_KalmSiege_FailRespawn() // starts off; enabled by KalmSiege1, KalmSiege2, KalmSiege3
    call Register_KalmSiege_DemonRecover() // starts off; enabled by KalmSiege1, KalmSiege2, KalmSiege3
    call Register_KalmSiege_Init() // run by MapBootstrap
endfunction

endlibrary

library TBossDarkFact requires TCam, TCine, TGroup, TMusic, TText, TWait
function Trig_Boss_DarkFact_Summon_FirstEncounter takes nothing returns boolean
    return(udg_RingHintUsed[6]==false)
endfunction

function Trig_Boss_DarkFact_Summon_FirstEncounterDialog takes nothing returns boolean
    return(udg_RingHintUsed[6]==false)
endfunction

function Trig_Boss_DarkFact_Summon_Actions takes nothing returns nothing
    set udg_BossCleanupTrigger=gg_trg_Boss_DarkFact_Cleanup
    call Cine_Enter()
    call Cam_PanToUnit(gg_unit_n03T_0008,0)
    set udg_TempPoint=GetRectCenter(gg_rct_473)
    call CreateNUnitsAtLoc(1,'u017',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u017': unit "Haunted Spirit"
    set udg_CinematicActor=GetLastCreatedUnit()
    call ShowUnitHide(udg_CinematicActor)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(.5)
    call ShowUnitShow(udg_CinematicActor)
    call Wait_Polled(1.5)
    if(Trig_Boss_DarkFact_Summon_FirstEncounter())then
        call SetUnitAnimationWithRarity(udg_CinematicActor,"spell",RARITY_FREQUENT)
        call AddSpecialEffectTargetUnitBJ("chest",udg_CinematicActor,"Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("chest",udg_CinematicActor,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(.5)
        call AddSpecialEffectTargetUnitBJ("chest",udg_CinematicActor,"Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("chest",udg_CinematicActor,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(.5)
        call AddSpecialEffectTargetUnitBJ("chest",udg_CinematicActor,"Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("chest",udg_CinematicActor,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(.5)
    endif
    call KillUnit(udg_CinematicActor)
    set udg_TempPoint=GetRectCenter(gg_rct_473)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateNUnitsAtLoc(1,'U015',Player($B),udg_TempPoint,270.) // 'U015': unit "Mage of Malice"; $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_DarkFactUnit=GetLastCreatedUnit()
    call SetHeroLevelBJ(udg_DarkFactUnit,88,false)
    call UnitAddItemByIdSwapped('I0GA',udg_DarkFactUnit) // 'I0GA': item "Final Wand"
    call UnitAddItemByIdSwapped('I0HZ',udg_DarkFactUnit) // 'I0HZ': item "Tome of Time"
    call UnitAddItemByIdSwapped('I069',udg_DarkFactUnit) // 'I069': item "Circlet"
    call UnitAddItemByIdSwapped('I07X',udg_DarkFactUnit) // 'I07X': item "Robe of Lords"
    call UnitAddItemByIdSwapped('I037',udg_DarkFactUnit) // 'I037': item "Magic Gloves"
    call UnitAddItemByIdSwapped('I02X',udg_DarkFactUnit) // 'I02X': item "Greater Nectar"
    call SetUnitLifePercentBJ(udg_DarkFactUnit,'d')
    call SetUnitManaPercentBJ(udg_DarkFactUnit,'d')
    call SetUnitInvulnerable(udg_DarkFactUnit,true)
    call PauseUnitBJ(true,udg_DarkFactUnit)
    call Wait_Polled(2.)
    if(Trig_Boss_DarkFact_Summon_FirstEncounterDialog())then
        set udg_RingHintUsed[6]=true
        call Text_Say(udg_DarkFactUnit,"Released at last...",true)
        call Text_Say(udg_DarkFactUnit,"Hmph, what heroes you are, releasing me just to strike me down.",true)
        call Text_Say(udg_DarkFactUnit,"I won't have it. I shall take my vengeance.",true)
    endif
    call SetUnitInvulnerable(udg_DarkFactUnit,false)
    call PauseUnitBJ(false,udg_DarkFactUnit)
    call Music_SetTrack(29)
    call GroupAddUnitSimple(udg_DarkFactUnit,udg_BossGroup)
    call TriggerRegisterUnitEvent(gg_trg_Boss_DarkFact_Death,udg_DarkFactUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_DarkFact_Death)
    call EnableTrigger(gg_trg_Boss_DarkFact_FactStrike)
    call Cine_Exit()
endfunction

function Trig_Boss_DarkFact_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_DarkFactUnit)
endfunction

function Trig_Boss_DarkFact_Death_ShouldRecordKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_DarkFact_Death_KillMinion takes nothing returns nothing
    set udg_TempHandleId=GetHandleIdBJ(GetEnumUnit())
    call SaveRealBJ(.01,1,udg_TempHandleId,udg_ProxyDamageHash)
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Boss_DarkFact_Death_IsWaygateOpen takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Boss_DarkFact_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_DarkFact_Death_ShouldRecordKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call DisableTrigger(gg_trg_Boss_DarkFact_FactStrike)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0GA',udg_TempPoint) // 'I0GA': item "Final Wand"
    call RemoveLocation(udg_TempPoint)
    call Music_ClearTrack(29)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call ForGroupBJ(udg_DarkFactMinions,function Trig_Boss_DarkFact_Death_KillMinion)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    if(Trig_Boss_DarkFact_Death_IsWaygateOpen())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call RemoveItem(udg_SummonItem)
    set udg_RingHintsReady=true
    call AddUnitToStockBJ('n0BD',gg_unit_e014_0149,1,1) // 'n0BD': unit "Hunt: Mephorash"
    call AddUnitToStockBJ('n0L5',gg_unit_nsw2_0056,1,1) // 'n0L5': unit "Hunt: Darm"
    set udg_HuntStock[6]=(udg_HuntStock[6]+1)
    set udg_HuntStock[$A]=(udg_HuntStock[$A]+1) // $A = 10
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call UnitRemoveAbilityBJ('A10W',gg_unit_n03T_0008) // 'A10W': ability "Spirit Pendant Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_DarkFact_FactStrike_Conditions takes nothing returns boolean
    return((RectContainsUnit(gg_rct_496,GetTriggerUnit()))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Boss_DarkFact_FactStrike_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',Player($B),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"; $B = 11
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(udg_DarkFactUnit,0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(14000.,1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_DarkFactMinions)
    call UnitApplyTimedLifeBJ(100.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M5',GetLastCreatedUnit()) // 'A0M5': ability "Earth-elemental Damage"
    call UnitAddAbilityBJ('A10Q',GetLastCreatedUnit()) // 'A10Q': ability "Fact Strike"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"flamestrike",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Boss_DarkFact_PingPong_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A10L') // 'A10L': ability "!Ping Pong"
endfunction

function Trig_Boss_DarkFact_PingPong_FilterHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_DarkFact_PingPong_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_DarkFact_PingPong_FilterVulnerableHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_PingPong_FilterHero(),Trig_Boss_DarkFact_PingPong_FilterVulnerable())
endfunction

function Trig_Boss_DarkFact_PingPong_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Boss_DarkFact_PingPong_FilterAliveHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_PingPong_FilterVulnerableHero(),Trig_Boss_DarkFact_PingPong_FilterAlive())
endfunction

function Trig_Boss_DarkFact_PingPong_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Boss_DarkFact_PingPong_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_PingPong_FilterAliveHero(),Trig_Boss_DarkFact_PingPong_FilterEnemy())
endfunction

function Trig_Boss_DarkFact_PingPong_NoTargets takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Boss_DarkFact_PingPong_Below50Percent takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<50.)
endfunction

function Trig_Boss_DarkFact_PingPong_Below75Percent takes nothing returns boolean
    // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
    // missing or its maximum is 0).
    return(GetUnitLifePercent(GetTriggerUnit())<75.)
endfunction

function Trig_Boss_DarkFact_PingPong_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(1920.,udg_TempPoint,Condition(function Trig_Boss_DarkFact_PingPong_FilterTarget))
    if(Trig_Boss_DarkFact_PingPong_NoTargets())then
        call RemoveLocation(udg_TempPoint)
        call DestroyGroup(udg_TempGroup)
        return
    endif
    if(Trig_Boss_DarkFact_PingPong_Below75Percent())then
        if(Trig_Boss_DarkFact_PingPong_Below50Percent())then
            set udg_TempInteger=1
        else
            set udg_TempInteger=2
        endif
    else
        set udg_TempInteger=3
    endif
    // (((CountUnitsInGroup(udg_TempGroup)) minus (1)) divided by (udg_TempInteger); drop the remainder) plus (1).
    set udg_TempInteger=(((CountUnitsInGroup(udg_TempGroup)-1)/ udg_TempInteger)+1)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_TempInteger
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempUnit2=GroupPickRandomUnit(udg_TempGroup)
        call GroupRemoveUnitSimple(udg_TempUnit2,udg_TempGroup)
        set udg_TempPoint2=GetUnitLoc(udg_TempUnit2)
        call CreateNUnitsAtLocFacingLocBJ(1,'u014',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint2) // 'u014': unit "Galbalan Orb"
        call RemoveLocation(udg_TempPoint2)
        call UnitApplyTimedLifeBJ(30.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_CYAN)
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"attack",udg_TempUnit2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_DarkFactMinions)
        call TriggerRegisterUnitEvent(gg_trg_Boss_DarkFact_Orb_Bounce,GetLastCreatedUnit(),EVENT_UNIT_DAMAGED)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call DestroyGroup(udg_TempGroup)
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='u014')and(GetOwningPlayer(GetTriggerUnit())==Player($B)) // 'u014': unit "Galbalan Orb"; $B = 11
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterVulnerableHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_Orb_Bounce_FilterHero(),Trig_Boss_DarkFact_Orb_Bounce_FilterVulnerable())
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterAliveHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_Orb_Bounce_FilterVulnerableHero(),Trig_Boss_DarkFact_Orb_Bounce_FilterAlive())
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterEnemyOwner takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player($B)) // $B = 11
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_Orb_Bounce_FilterAliveHero(),Trig_Boss_DarkFact_Orb_Bounce_FilterEnemyOwner())
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_NoTargets takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Boss_DarkFact_Orb_Bounce_Actions takes nothing returns nothing
    call BlzSetEventDamage(.0)
    call SetUnitOwner(GetTriggerUnit(),Player(9),false)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempGroup=Group_UnitsInRangeOfLoc(2000.,udg_TempPoint,Condition(function Trig_Boss_DarkFact_Orb_Bounce_FilterTarget))
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_DarkFact_Orb_Bounce_NoTargets())then
        call DestroyGroup(udg_TempGroup)
        call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
        call UnitRemoveAbilityBJ('A0FQ',GetTriggerUnit()) // 'A0FQ': ability "Explode Upon Death"
        call UnitRemoveAbilityBJ('A0ZR',GetTriggerUnit()) // 'A0ZR': ability "Immortal"
        call KillUnit(GetTriggerUnit())
    else
        call IssueTargetOrderBJ(GetTriggerUnit(),"attack",GroupPickRandomUnit(udg_TempGroup))
        call UnitRemoveBuffsExBJ(bj_BUFF_POLARITY_EITHER,bj_BUFF_RESIST_EITHER,GetTriggerUnit(),false,true)
        // (GetUnitMoveSpeed(the triggering unit)) plus (40).
        call SetUnitMoveSpeed(GetTriggerUnit(),(GetUnitMoveSpeed(GetTriggerUnit())+40.))
        call SetUnitAbilityLevelSwapped('A10M',GetTriggerUnit(),1) // 'A10M': ability "Galbalan Orb"
        call SetUnitInvulnerable(GetTriggerUnit(),true)
        call DestroyGroup(udg_TempGroup)
        call AddSpecialEffectTargetUnitBJ("chest",GetTriggerUnit(),"Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
    endif
endfunction

function Trig_Boss_DarkFact_Orb_Attack_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetAttacker())=='u014') // 'u014': unit "Galbalan Orb"
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',GetFilterUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterVulnerableHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_Orb_Attack_FilterHero(),Trig_Boss_DarkFact_Orb_Attack_FilterVulnerable())
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterAliveHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_Orb_Attack_FilterVulnerableHero(),Trig_Boss_DarkFact_Orb_Attack_FilterAlive())
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterEnemy takes nothing returns boolean
    return(IsUnitEnemy(GetFilterUnit(),Player($B))) // $B = 11
endfunction

function Trig_Boss_DarkFact_Orb_Attack_FilterTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Boss_DarkFact_Orb_Attack_FilterAliveHero(),Trig_Boss_DarkFact_Orb_Attack_FilterEnemy())
endfunction

function Trig_Boss_DarkFact_Orb_Attack_NoTargets takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Boss_DarkFact_Orb_Attack_OrbCanSpeedUp takes nothing returns boolean
    return(GetUnitMoveSpeed(GetAttacker())<450.)
endfunction

function Trig_Boss_DarkFact_Orb_Attack_OrbIsSpent takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A10M',GetAttacker())==2) // 'A10M': ability "Galbalan Orb"
endfunction

function Trig_Boss_DarkFact_Orb_Attack_TargetIsBossSide takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Boss_DarkFact_Orb_Attack_Actions takes nothing returns nothing
    if(Trig_Boss_DarkFact_Orb_Attack_TargetIsBossSide())then
        if(Trig_Boss_DarkFact_Orb_Attack_OrbCanSpeedUp())then
            set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
            set udg_TempGroup=Group_UnitsInRangeOfLoc(1500.,udg_TempPoint,Condition(function Trig_Boss_DarkFact_Orb_Attack_FilterTarget))
            call RemoveLocation(udg_TempPoint)
            if(Trig_Boss_DarkFact_Orb_Attack_NoTargets())then
                call DestroyGroup(udg_TempGroup)
                call GroupRemoveUnitSimple(GetAttacker(),udg_BossGroup)
                call UnitRemoveAbilityBJ('A0FQ',GetAttacker()) // 'A0FQ': ability "Explode Upon Death"
                call UnitRemoveAbilityBJ('A0ZR',GetAttacker()) // 'A0ZR': ability "Immortal"
                call KillUnit(GetAttacker())
            else
                call SetUnitOwner(GetAttacker(),Player($B),false) // $B = 11
                call UnitRemoveBuffsExBJ(bj_BUFF_POLARITY_EITHER,bj_BUFF_RESIST_EITHER,GetAttacker(),false,true)
                // (GetUnitMoveSpeed(GetAttacker())) plus (40).
                call SetUnitMoveSpeed(GetAttacker(),(GetUnitMoveSpeed(GetAttacker())+40.))
                call SetUnitInvulnerable(GetAttacker(),false)
                call IssueTargetOrderBJ(GetAttacker(),"attack",GroupPickRandomUnit(udg_TempGroup))
                call DestroyGroup(udg_TempGroup)
                call AddSpecialEffectTargetUnitBJ("chest",GetAttacker(),"Abilities\\Spells\\Items\\SpellShieldAmulet\\SpellShieldCaster.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
            endif
        else
            call GroupRemoveUnitSimple(GetAttacker(),udg_BossGroup)
            // ((maximum health of GetAttacker()) divided by (udg_DifficultyScale)) with its decimal part removed.
            call BlzSetUnitMaxHP(GetAttacker(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())/ udg_DifficultyScale)))
            call UnitRemoveAbilityBJ('A0ZR',GetAttacker()) // 'A0ZR': ability "Immortal"
            call KillUnit(GetAttacker())
        endif
    else
        if(Trig_Boss_DarkFact_Orb_Attack_OrbIsSpent())then
            call GroupRemoveUnitSimple(GetAttacker(),udg_BossGroup)
            call BlzSetUnitName(GetAttacker(),"Dark Fact")
            call UnitRemoveAbilityBJ('A0ZR',GetAttacker()) // 'A0ZR': ability "Immortal"
            call KillUnit(GetAttacker())
        else
            call SetUnitAbilityLevelSwapped('A10M',GetAttacker(),2) // 'A10M': ability "Galbalan Orb"
            call Wait_Polled(1.)
            call SetUnitAbilityLevelSwapped('A10M',GetAttacker(),1) // 'A10M': ability "Galbalan Orb"
        endif
    endif
endfunction

function Trig_Boss_DarkFact_Cleanup_KillMinion takes nothing returns nothing
    set udg_TempHandleId=GetHandleIdBJ(GetEnumUnit())
    call SaveRealBJ(.01,1,udg_TempHandleId,udg_ProxyDamageHash)
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Boss_DarkFact_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Boss_DarkFact_FactStrike)
    call DisableTrigger(gg_trg_Boss_DarkFact_Death)
    call GroupRemoveUnitSimple(udg_DarkFactUnit,udg_BossGroup)
    call ForGroupBJ(udg_DarkFactMinions,function Trig_Boss_DarkFact_Cleanup_KillMinion)
    call KillUnit(udg_DarkFactUnit)
    call RemoveUnit(udg_DarkFactUnit)
    call Music_ClearTrack(29)
endfunction

function InitTrig_Boss_DarkFact takes nothing returns nothing
endfunction

endlibrary

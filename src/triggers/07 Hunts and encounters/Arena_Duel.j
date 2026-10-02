library TArenaDuel requires TBattleLog, TJob, TLoc, TMusic, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Duel_AI=null
    trigger gg_trg_Arena_Duel_Ascend=null
    trigger gg_trg_Arena_Duel_Victory=null
    trigger gg_trg_Arena_Duel_Cleanup=null
endglobals

function Trig_Arena_Duel_AI_IsSecondHalfStart takes nothing returns boolean
    return(udg_DragonBattlePhase==21)
endfunction

function Trig_Arena_Duel_AI_IsTargetNearSecond takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<400.)
endfunction

function Trig_Arena_Duel_AI_IsCoinFlipSecond takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Arena_Duel_AI_IsChaseTickSecond takes nothing returns boolean
    // The remainder after dividing (udg_DragonBattlePhase) by (3).
    return(ModuloInteger(udg_DragonBattlePhase,3)==2)
endfunction

function Trig_Arena_Duel_AI_IsFirstHalfStart takes nothing returns boolean
    return(udg_DragonBattlePhase==1)
endfunction

function Trig_Arena_Duel_AI_IsTargetNearFirst takes nothing returns boolean
    // The straight-line distance between udg_TempPoint and udg_TempPoint2.
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<400.)
endfunction

function Trig_Arena_Duel_AI_IsCoinFlipFirst takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Arena_Duel_AI_IsChaseTickFirst takes nothing returns boolean
    // The remainder after dividing (udg_DragonBattlePhase) by (3).
    return(ModuloInteger(udg_DragonBattlePhase,3)==2)
endfunction

function Trig_Arena_Duel_AI_IsFirstHalf takes nothing returns boolean
    return(udg_DragonBattlePhase<=20)
endfunction

function Trig_Arena_Duel_AI_Actions takes nothing returns nothing
    call StartTimerBJ(udg_DragonBattleTimer,false,1.5)
    // (the remainder after dividing (udg_DragonBattlePhase) by (40)) plus (1).
    set udg_DragonBattlePhase=(ModuloInteger(udg_DragonBattlePhase,40)+1)
    if(Trig_Arena_Duel_AI_IsFirstHalf())then
        if(Trig_Arena_Duel_AI_IsFirstHalfStart())then
            call SetUnitOwner(udg_ShinryuUnit,Player($B),false) // $B = 11
            call SetUnitOwner(udg_WarmechUnit,Player(9),false)
            set udg_TempPoint=GetUnitLoc(udg_ShinryuUnit)
            call CreateTextTagLocBJ("|cffffcc00OFFENSE",udg_TempPoint,0,13.,'d','d','d',0)
            call RemoveLocation(udg_TempPoint)
            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
            call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
            call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
            call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
            set udg_TempPoint=GetUnitLoc(udg_WarmechUnit)
            call CreateTextTagLocBJ("|cffffcc00DEFENSE",udg_TempPoint,0,13.,'d','d','d',0)
            call RemoveLocation(udg_TempPoint)
            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
            call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
            call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
            call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
        endif
        call IssueTargetOrderBJ(udg_ShinryuUnit,"attack",udg_WarmechUnit)
        if(Trig_Arena_Duel_AI_IsChaseTickFirst())then
            set udg_TempPoint=GetUnitLoc(udg_ShinryuUnit)
            set udg_TempPoint2=GetUnitLoc(udg_WarmechUnit)
            set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
            call RemoveLocation(udg_TempPoint)
            call RemoveLocation(udg_TempPoint2)
            // ((udg_TempReal) with its decimal part removed) divided by (90).
            set udg_TempPoint=GetRectCenter(udg_GlyphRect[(R2I(udg_TempReal)/ 90)])
        else
            if(Trig_Arena_Duel_AI_IsCoinFlipFirst())then
                set udg_TempPoint=GetUnitLoc(udg_WarmechUnit)
                set udg_TempPoint2=GetUnitLoc(Player_GetHero(ForcePickRandomPlayer(udg_DuelArenaPlayers)))
                if(Trig_Arena_Duel_AI_IsTargetNearFirst())then
                    call RemoveLocation(udg_TempPoint)
                    // The remainder after dividing (udg_DragonBattlePhase) by (4).
                    set udg_TempPoint=GetRectCenter(udg_GlyphRect[ModuloInteger(udg_DragonBattlePhase,4)])
                else
                    call RemoveLocation(udg_TempPoint)
                    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,GetRandomDirectionDeg())
                endif
                call RemoveLocation(udg_TempPoint2)
            else
                // The remainder after dividing ((udg_DragonBattlePhase) divided by (3); drop the remainder) by (4).
                set udg_TempPoint=GetRectCenter(udg_GlyphRect[ModuloInteger((udg_DragonBattlePhase/ 3),4)])
            endif
        endif
        call IssuePointOrderLocBJ(udg_WarmechUnit,"move",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
    else
        if(Trig_Arena_Duel_AI_IsSecondHalfStart())then
            call SetUnitOwner(udg_WarmechUnit,Player($B),false) // $B = 11
            call SetUnitOwner(udg_ShinryuUnit,Player(9),false)
            set udg_TempPoint=GetUnitLoc(udg_WarmechUnit)
            call CreateTextTagLocBJ("|cffffcc00OFFENSE",udg_TempPoint,0,13.,'d','d','d',0)
            call RemoveLocation(udg_TempPoint)
            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
            call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
            call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
            call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
            set udg_TempPoint=GetUnitLoc(udg_ShinryuUnit)
            call CreateTextTagLocBJ("|cffffcc00DEFENSE",udg_TempPoint,0,13.,'d','d','d',0)
            call RemoveLocation(udg_TempPoint)
            call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
            call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
            call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
            call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
        endif
        call IssueTargetOrderBJ(udg_WarmechUnit,"attack",udg_ShinryuUnit)
        if(Trig_Arena_Duel_AI_IsChaseTickSecond())then
            set udg_TempPoint=GetUnitLoc(udg_WarmechUnit)
            set udg_TempPoint2=GetUnitLoc(udg_ShinryuUnit)
            set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
            call RemoveLocation(udg_TempPoint)
            call RemoveLocation(udg_TempPoint2)
            // ((udg_TempReal) with its decimal part removed) divided by (90).
            set udg_TempPoint=GetRectCenter(udg_GlyphRect[(R2I(udg_TempReal)/ 90)])
        else
            if(Trig_Arena_Duel_AI_IsCoinFlipSecond())then
                set udg_TempPoint=GetUnitLoc(udg_ShinryuUnit)
                set udg_TempPoint2=GetUnitLoc(Player_GetHero(ForcePickRandomPlayer(udg_DuelArenaPlayers)))
                if(Trig_Arena_Duel_AI_IsTargetNearSecond())then
                    call RemoveLocation(udg_TempPoint)
                    // The remainder after dividing (udg_DragonBattlePhase) by (4).
                    set udg_TempPoint=GetRectCenter(udg_GlyphRect[ModuloInteger(udg_DragonBattlePhase,4)])
                else
                    call RemoveLocation(udg_TempPoint)
                    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,GetRandomDirectionDeg())
                endif
                call RemoveLocation(udg_TempPoint2)
            else
                // The remainder after dividing ((udg_DragonBattlePhase) divided by (3); drop the remainder) by (4).
                set udg_TempPoint=GetRectCenter(udg_GlyphRect[ModuloInteger((udg_DragonBattlePhase/ 3),4)])
            endif
        endif
        call IssuePointOrderLocBJ(udg_ShinryuUnit,"move",udg_TempPoint)
    endif
endfunction

function Trig_Arena_Duel_Ascend_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A01C') // 'A01C': ability "!Absorb Enemy"
endfunction

function Trig_Arena_Duel_Ascend_IsOmega takes nothing returns boolean
    return(GetTriggerUnit()==udg_WarmechUnit)
endfunction

function Trig_Arena_Duel_Ascend_IsShinryu takes nothing returns boolean
    return(GetTriggerUnit()==udg_ShinryuUnit)
endfunction

function Trig_Arena_Duel_Ascend_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(GetTriggerUnit(),'d',90.,10.,0)
    call SetUnitLifePercentBJ(GetTriggerUnit(),'d')
    call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
    call UnitAddAbilityBJ('A0PD',GetTriggerUnit()) // 'A0PD': ability "Invulnerability"
    call UnitRemoveAbilityBJ('A01C',GetTriggerUnit()) // 'A01C': ability "!Absorb Enemy"
    call UnitAddAbilityBJ('A0P9',GetTriggerUnit()) // 'A0P9': ability "Focus"
    call UnitAddAbilityBJ('A0RF',GetTriggerUnit()) // 'A0RF': ability "Serenity"
    call UnitAddAbilityBJ('A127',GetTriggerUnit()) // 'A127': ability "Null Evasion"
    call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_SET,9999)
    call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_SET,9999)
    call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_SET,9999)
    call BattleLog_ShowUnit("ascends to godhood.",GetTriggerUnit())
    if(Trig_Arena_Duel_Ascend_IsShinryu())then
        call BlzSetHeroProperName(GetTriggerUnit(),"Shinryu Omega")
    else
        if(Trig_Arena_Duel_Ascend_IsOmega())then
            call BlzSetHeroProperName(GetTriggerUnit(),"Omega Mk VIII")
        endif
    endif
endfunction

function Trig_Arena_Duel_Victory_IsDuelist takes nothing returns boolean
    return(GetTriggerUnit()==udg_WarmechUnit)or(GetTriggerUnit()==udg_ShinryuUnit)
endfunction

function Trig_Arena_Duel_Victory_Conditions takes nothing returns boolean
    return(Trig_Arena_Duel_Victory_IsDuelist())
endfunction

function Trig_Arena_Duel_Victory_IsKillTrackerOn takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Arena_Duel_Victory_IsShinryu takes nothing returns boolean
    return(GetTriggerUnit()==udg_ShinryuUnit)
endfunction

function Trig_Arena_Duel_Victory_IsOmega takes nothing returns boolean
    return(GetTriggerUnit()==udg_WarmechUnit)
endfunction

function Trig_Arena_Duel_Victory_CanMasterJob takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_SummonerPlayer))==3)and(IsPlayerInForce(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Arena_Duel_Victory_IsPlayerKiller takes nothing returns boolean
    return(udg_SummonerPlayer!=Player($B)) // $B = 11
endfunction

function Trig_Arena_Duel_Victory_IsWaygateUnlocked takes nothing returns boolean
    return(udg_HolyAnkhUsed)
endfunction

function Trig_Arena_Duel_Victory_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Arena_Duel_Victory_IsKillTrackerOn())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Arena_Duel_Victory_IsOmega())then
        call CreateItemLoc('I0C6',udg_TempPoint) // 'I0C6': item "Edgar's Drill"
    else
        if(Trig_Arena_Duel_Victory_IsShinryu())then
            call CreateItemLoc('I0C7',udg_TempPoint) // 'I0C7': item "Ryuujin no Ken"
        endif
    endif
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call RemoveLocation(udg_TempPoint)
    call AddUnitToStockBJ('n0LV',udg_ArenaOrganizer[5],1,1) // 'n0LV': unit "Arena: Phantasm Dragon Battle"
    call AddUnitToStockBJ('n0LW',udg_ArenaOrganizer[5],1,1) // 'n0LW': unit "Arena: Phantasm Mech Battle"
    call Music_ClearTrack(55)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call PlayThematicMusicBJ("war3mapImported\\FFX-Victory.mp3")
    if(Trig_Arena_Duel_Victory_IsPlayerKiller())then
        set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_SummonerPlayer))
        if(Trig_Arena_Duel_Victory_CanMasterJob())then
            call ForceAddPlayerSimple(udg_SummonerPlayer,udg_QuestForce[udg_TempInteger])
            call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_SummonerPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    if(Trig_Arena_Duel_Victory_IsWaygateUnlocked())then
        call WaygateActivateBJ(true,gg_unit_n0AP_0240)
        set udg_SpecialEffect[78]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0AP_0240,"Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl")
    endif
    call RemoveItem(udg_SummonItem)
    set udg_RingHintsReady=true
    call UnitRemoveAbilityBJ('A01G',gg_unit_n03T_0008) // 'A01G': ability "Dragon Soul Hint"
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_Duel_Cleanup_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Arena_Duel_AI)
    call PauseTimerBJ(true,udg_DragonBattleTimer)
    call DisableTrigger(gg_trg_Arena_Omega_Absorbs)
    call DisableTrigger(gg_trg_Arena_Shinryu_Absorbs)
    call DisableTrigger(gg_trg_Arena_Duel_Victory)
    call GroupRemoveUnitSimple(udg_WarmechUnit,udg_BossGroup)
    call GroupRemoveUnitSimple(udg_ShinryuUnit,udg_BossGroup)
    call KillUnit(udg_WarmechUnit)
    call RemoveUnit(udg_WarmechUnit)
    call KillUnit(udg_ShinryuUnit)
    call RemoveUnit(udg_ShinryuUnit)
    call Music_ClearTrack(55)
endfunction

function InitTrig_Arena_Duel takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part4 (module Arena),
// which keeps the original registration order.

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

endlibrary

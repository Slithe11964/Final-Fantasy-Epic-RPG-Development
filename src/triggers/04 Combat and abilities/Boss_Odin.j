library TBossOdin requires TCam, TCine, TLoc, TMusic, TPlayerHero, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Odin_Intro=null
    trigger gg_trg_Boss_Odin_Escort_AI=null
    trigger gg_trg_Boss_Odin_Death=null
endglobals

function Trig_Boss_Odin_Intro_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H01M_0071,true,true,true))
endfunction

function Trig_Boss_Odin_Intro_Cond_IsRockChunk takes nothing returns boolean
    return(GetDestructableTypeId(GetEnumDestructable())=='LTrc') // 'LTrc': object name not found in map data
endfunction

function Trig_Boss_Odin_Intro_Enum_ClearRocks takes nothing returns nothing
    if(Trig_Boss_Odin_Intro_Cond_IsRockChunk())then
        call KillDestructable(GetEnumDestructable())
    endif
endfunction

function Trig_Boss_Odin_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[90])
    set udg_JudgePlayer=GetTriggerPlayer()
    call Cine_Enter()
    call Cam_PanToUnit(GetTriggerUnit(),0)
    call Text_Say(gg_unit_H01M_0071,"|cffff0000So you are the ones who need to be taught a lesson in humility. I am Odin, the Northern God.|r",true)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"I fear no gods. I wonder how long your impenetrable armor will last against our assault.",true)
    call Text_Say(gg_unit_H01M_0071,"|cffff0000If you truly manage to down us, then I accept it. That it is not our place to judge those of this world. But if you fall here, then you will be just another would-be hero consumed by hubris, like so many before you.|r",true)
    call Text_Say(gg_unit_H01M_0071,"|cffff0000Now, let the battle commence!|r",true)
    call Cine_ExitAction()
    call ExecuteFunc("Judgment_OdinChallenged") // the quest log: "Defeat Odin."
    call EnumDestructablesInRectAll(gg_rct_712,function Trig_Boss_Odin_Intro_Enum_ClearRocks)
    call SetUnitOwner(gg_unit_H01M_0071,Player($B),false) // $B = 11
    call SetUnitOwner(gg_unit_N0N0_0267,Player($B),false) // $B = 11
    call SetUnitOwner(gg_unit_E01O_0268,Player($B),false) // $B = 11
    call PauseUnitBJ(false,gg_unit_H01M_0071)
    call PauseUnitBJ(false,gg_unit_N0N0_0267)
    call PauseUnitBJ(false,gg_unit_E01O_0268)
    call SetUnitInvulnerable(gg_unit_H01M_0071,false)
    call SetUnitInvulnerable(gg_unit_N0N0_0267,false)
    call SetUnitInvulnerable(gg_unit_E01O_0268,false)
    call GroupAddUnitSimple(gg_unit_H01M_0071,udg_BossGroup)
    call CreateFogModifierRectBJ(true,Player($B),FOG_OF_WAR_VISIBLE,gg_rct_709) // $B = 11
    call EnableTrigger(gg_trg_Boss_Odin_Death)
    call EnableTrigger(gg_trg_Boss_Odin_Escort_AI)
    call EnableTrigger(gg_trg_Odin_Escort_Teleport)
    call EnableTrigger(gg_trg_Odin_Leash_Arena)
    call Music_SetTrack(56)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Odin_Escort_AI_Cond_QueenFarFromOdin takes nothing returns boolean
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>1600.)
endfunction

function Trig_Boss_Odin_Escort_AI_Cond_QueenVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',gg_unit_E01O_0268)<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_Odin_Escort_AI_Cond_QueenNeedsCover takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',gg_unit_E01O_0268)<=0)and(UnitHasBuffBJ(gg_unit_E01O_0268,'B063')==false) // 'Avul': standard ability reference "Invulnerable"; 'B063': buff "Cover"
endfunction

function Trig_Boss_Odin_Escort_AI_Cond_OdinNeedsCover takes nothing returns boolean
    return(UnitHasBuffBJ(gg_unit_H01M_0071,'B063')==false) // 'B063': buff "Cover"
endfunction

function Trig_Boss_Odin_Escort_AI_Cond_KnightFarFromOdin takes nothing returns boolean
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)>1600.)
endfunction

function Trig_Boss_Odin_Escort_AI_Cond_KnightVulnerable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Avul',gg_unit_N0N0_0267)<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Boss_Odin_Escort_AI_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(gg_unit_H01M_0071)
    if(Trig_Boss_Odin_Escort_AI_Cond_QueenVulnerable())then
        set udg_TempPoint2=GetUnitLoc(gg_unit_E01O_0268)
        if(Trig_Boss_Odin_Escort_AI_Cond_QueenFarFromOdin())then
            call IssueImmediateOrderBJ(gg_unit_E01O_0268,"channel")
        endif
        call RemoveLocation(udg_TempPoint2)
    endif
    if(Trig_Boss_Odin_Escort_AI_Cond_KnightVulnerable())then
        set udg_TempPoint2=GetUnitLoc(gg_unit_N0N0_0267)
        if(Trig_Boss_Odin_Escort_AI_Cond_KnightFarFromOdin())then
            call IssueImmediateOrderBJ(gg_unit_N0N0_0267,"channel")
        else
            if(Trig_Boss_Odin_Escort_AI_Cond_OdinNeedsCover())then
                call IssueTargetOrderBJ(gg_unit_N0N0_0267,"cripple",gg_unit_H01M_0071)
            else
                if(Trig_Boss_Odin_Escort_AI_Cond_QueenNeedsCover())then
                    call IssueTargetOrderBJ(gg_unit_N0N0_0267,"cripple",gg_unit_E01O_0268)
                endif
            endif
        endif
        call RemoveLocation(udg_TempPoint2)
    endif
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Boss_Odin_Death_Cond_TrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Odin_Death_Cond_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Odin_Death_Cond_SinglePlayer takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_PlayingPlayers)==1)
endfunction

function Trig_Boss_Odin_Death_Enum_GiveCrystalShards takes nothing returns nothing
    call AdjustPlayerStateBJ(8,GetEnumPlayer(),PLAYER_STATE_RESOURCE_LUMBER)
endfunction

function Trig_Boss_Odin_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Boss_Odin_Escort_AI)
    call DisableTrigger(gg_trg_Odin_Escort_Teleport)
    call DisableTrigger(gg_trg_Odin_Leash_Arena)
    call DestroyTrigger(gg_trg_Boss_Odin_Escort_AI)
    call DestroyTrigger(gg_trg_Odin_Escort_Teleport)
    call DestroyTrigger(gg_trg_Odin_Leash_Arena)
    call Music_ClearTrack(56)
    if(Trig_Boss_Odin_Death_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_H01M_0071,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_H01M_0071,udg_BossUnits)
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_E01O_0268) // 'A0ZR': ability "Immortal"
    call UnitRemoveAbilityBJ('A0ZR',gg_unit_N0N0_0267) // 'A0ZR': ability "Immortal"
    call KillUnit(gg_unit_E01O_0268)
    call KillUnit(gg_unit_N0N0_0267)
    if(Trig_Boss_Odin_Death_Cond_KilledByPlayer())then
        set udg_JudgePlayer=GetOwningPlayer(GetKillingUnitBJ())
    endif
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_H01M_0071,l_tempPoint,false)
    call RemoveLocation(l_tempPoint)
    call Cine_Enter()
    call SetUnitAnimation(gg_unit_H01M_0071,"death")
    call Cam_PanToUnit(gg_unit_H01M_0071,0)
    call Text_Say(null,"|n|cffff0000All players get 80000 gold and 8 crystal shards.|r",true)
    call Text_Say(gg_unit_H01M_0071,"|cffff0000So your strength is true after all. I am most impressed.|r",true)
    call Text_Say(gg_unit_H01M_0071,"|cffff0000As I'm certain you know, however, Arcanium armor is truly impenetrable. You cannot truly defeat me.|r",true)
    call Text_Say(Player_GetHero(udg_JudgePlayer),"I know. So will you leave this world and Arcanium to us now?",true)
    call SetUnitAnimation(gg_unit_H01M_0071,"stand")
    call Text_Say(gg_unit_H01M_0071,"|cffff0000In deference to your power, I will stay away from this world. But I cannot allow Arcanium in the hands of mortals again. It could so easily be stolen, and you have shown that you do not need it either.|r",true)
    call Text_Say(gg_unit_H01M_0071,"|cffff0000I shall leave you with a parting gift in honor of our battle. I bid you adieu, and good luck on your journeys.|r",true)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call Wait_Polled(.5)
    call Cine_ExitAction()
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call RemoveUnit(GetTriggerUnit())
    call CreateItemLoc('I03P',l_tempPoint) // 'I03P': item "Megalixir"
    call SetItemCharges(GetLastCreatedItem(),20)
    if(Trig_Boss_Odin_Death_Cond_SinglePlayer())then
        call CreateItemLoc('I04A',l_tempPoint) // 'I04A': item "Sleipnir"
    else
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=CountPlayersInForceBJ(udg_PlayingPlayers)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,128.,((360.*I2R(GetForLoopIndexA()))/ I2R(CountPlayersInForceBJ(udg_PlayingPlayers))))
            call CreateItemLoc('I04A',udg_TempPoint2) // 'I04A': item "Sleipnir"
            call RemoveLocation(udg_TempPoint2)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    call RemoveLocation(l_tempPoint)
    call ForForce(udg_PlayingPlayers,function Trig_Boss_Odin_Death_Enum_GiveCrystalShards)
    call ExecuteFunc("Judgment_OdinDefeated") // 80000 gold; the quest "The Northern God" is completed
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    set udg_ArenaBonusBattle[0]=(udg_ArenaBonusBattle[0]+1)
    set udg_ArenaBonusBattle[udg_ArenaBonusBattle[0]]='y'
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Boss_Odin takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part10 (module Boss),
// which keeps the original registration order.

function Register_Boss_Odin_Intro takes nothing returns nothing
    set gg_trg_Boss_Odin_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Odin_Intro)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Boss_Odin_Intro,Player(7),true)
    call TriggerAddCondition(gg_trg_Boss_Odin_Intro,Condition(function Trig_Boss_Odin_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Odin_Intro,function Trig_Boss_Odin_Intro_Actions)
endfunction

function Register_Boss_Odin_Escort_AI takes nothing returns nothing
    set gg_trg_Boss_Odin_Escort_AI=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Odin_Escort_AI)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Boss_Odin_Escort_AI,10.)
    call TriggerAddAction(gg_trg_Boss_Odin_Escort_AI,function Trig_Boss_Odin_Escort_AI_Actions)
endfunction

function Register_Boss_Odin_Death takes nothing returns nothing
    set gg_trg_Boss_Odin_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Odin_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Odin_Death,gg_unit_H01M_0071,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Odin_Death,function Trig_Boss_Odin_Death_Actions)
endfunction

endlibrary

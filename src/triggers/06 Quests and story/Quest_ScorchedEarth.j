library TQuestScorchedEarth requires TQuestEngine, TCam, TCine, TMusic, TPlayerHero, TReward, TText, TWait
// Side quest "Scorched Earth", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// McBurn has turned the Icy Realm into an infernal hell; the party climbs the mountain and defeats him.
// All steps are custom and stay in cinematic triggers: ScorchedEarth runs gg_trg_Quest_ScorchedEarth_Start
// and removes the barrier (step 2), McBurn reveals his true form (step 3), and gg_trg_Quest_ScorchedEarth_End
// finishes the quest. Its name is red in the quest log. Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_ScorchedEarth_Start=null
    trigger gg_trg_Quest_ScorchedEarth_End=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_SCORCHED_EARTH=0
endglobals

function QuestScorchedEarth_Define takes nothing returns nothing
    local integer q=Quest_Define("Scorched Earth",QUEST_SIDE,52,"ReplaceableTextures\\CommandButtons\\BTNDoomGuard.blp")
    set QUEST_SCORCHED_EARTH=q
    call Quest_Color(q,udg_QuestTitleRed)
    call Quest_NotStory(q)
    // 1. A hero enters the burning Icy Realm (gg_trg_Quest_ScorchedEarth_Start)
    call Quest_Custom(q,"The icy realm has turned into an infernal hell! Climb to the top of the (former) Snowy Mountain to see if you can find the cause.")
    // 2. Erase the barrier with a Hell Gate's Flame (ScorchedEarth module, gg_trg_ScorchedEarth_Barrier)
    call Quest_Custom(q,"Approach the Infernal Mountain's top to confront the entity who caused this inferno.")
    call Quest_Message(q,"Approach the mountain's top.")
    // 3. Reach the top: McBurn reveals his true form (McBurn module, gg_trg_McBurn_TrueForm_Reveal)
    call Quest_Custom(q,"Defeat McBurn, the Otherworldly King.")
    call Quest_Message(q,"Defeat McBurn.")
    // 4. McBurn falls (gg_trg_Quest_ScorchedEarth_End)
    call Quest_Custom(q,"")
endfunction

function Trig_Quest_ScorchedEarth_Start_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

// Step 1: a hero entered the burning Icy Realm (run by ScorchedEarth).
function Trig_Quest_ScorchedEarth_Start_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_ScorchedEarth_EnterRegion)
    call DisableTrigger(gg_trg_ScorchedEarth_TowerAttack)
    call DestroyTrigger(gg_trg_ScorchedEarth_EnterRegion)
    call DestroyTrigger(gg_trg_ScorchedEarth_TowerAttack)
    call EnableTrigger(gg_trg_ScorchedEarth_HeatFade)
    call Cine_Enter()
    call Wait_Polled(1.)
    call Text_Say(udg_CinematicActor,"What the hell happened here!?",true)
    if QUEST_SCORCHED_EARTH==0 then
        call QuestScorchedEarth_Define()
    endif
    call Quest_Start(QUEST_SCORCHED_EARTH,GetOwningPlayer(udg_CinematicActor),udg_CinematicActor)
    call EnableTrigger(gg_trg_ScorchedEarth_Barrier)
    call Music_SetZoneTrack(34)
    call Cine_ExitAction()
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_TrackBossKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Quest_ScorchedEarth_End_GiveCrystalShards takes nothing returns nothing
    call AdjustPlayerStateBJ(6,GetEnumPlayer(),PLAYER_STATE_RESOURCE_LUMBER)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_NotRewarded takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[29])==false)
endfunction

function Trig_Quest_ScorchedEarth_End_Reward_EachPlayer takes nothing returns nothing
    if(Trig_Quest_ScorchedEarth_End_Cond_NotRewarded())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=29
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_BoardEmpty takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_NoHuntActive takes nothing returns boolean
    return(udg_OkuuStage==0)
endfunction

function Trig_Quest_ScorchedEarth_End_Cond_HuntCountLow takes nothing returns boolean
    return(udg_OkuuStage<2)
endfunction

// Step 4: McBurn falls, admits defeat and leaves; the Icy Realm is restored.
function Trig_Quest_ScorchedEarth_End_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_U00Q_0023,udg_BossGroup)
    call GroupRemoveUnitSimple(gg_unit_U00Q_0023,udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_U00Q_0023,l_tempPoint,false)
    call RemoveLocation(l_tempPoint)
    call DisableTrigger(gg_trg_McBurn_Arena_Return)
    call DestroyTrigger(gg_trg_McBurn_Arena_Return)
    call Cine_Enter()
    if(Trig_Quest_ScorchedEarth_End_Cond_TrackBossKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call Cam_PanToUnit(gg_unit_U00Q_0023,.0)
    call Wait_Polled(2)
    call Text_Say(gg_unit_U00Q_0023,"Hahaha... I am most impressed. I really am.",true)
    call Text_Say(gg_unit_U00Q_0023,"I admit defeat. You've fought incredibly.",true)
    if(Trig_Quest_ScorchedEarth_End_Cond_KilledByPlayer())then
        set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
    else
        set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
    endif
    call Text_Say(Player_GetHero(udg_TempPlayer),"*pant* *pant*",true)
    call Text_Say(gg_unit_U00Q_0023,"Haha, my bad. I'll leave your world alone. Here, you can have this.",true)
    call Text_Say(null,"|n|cffffcc00All players get 66666 gold and 6 crystal shards.|r",true)
    call Reward_Give(66666,0,null)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_ScorchedEarth_End_GiveCrystalShards)
    call Text_Say(gg_unit_U00Q_0023,"See ya.",true)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
    call BlzSetSpecialEffectScale(GetLastCreatedEffectBJ(),7.)
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call CreateItemLoc('I0HU',l_tempPoint) // 'I0HU': item "Angbar"
    call RemoveLocation(l_tempPoint)
    call RemoveUnit(gg_unit_U00Q_0023)
    call Wait_Polled(2.)
    call ConditionalTriggerExecute(gg_trg_IcyRealm_Restore)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
    call Wait_Polled(2.)
    call Text_Say(Player_GetHero(udg_TempPlayer),"*pant* *pant* He's gone...",true)
    call Text_Say(Player_GetHero(udg_TempPlayer),"What a completely insane demon...",true)
    call Text_Say(Player_GetHero(udg_TempPlayer),"Hahaha... but what a fight that was.",true)
    call Cine_ExitAction()
    call Quest_StepDone(QUEST_SCORCHED_EARTH,null,null)
    call Music_ClearTrack(35)
    call Music_SetZoneTrack($C) // $C = 12
    call ConditionalTriggerExecute(gg_trg_Promotion_Award_Random)
    call ForForce(udg_PlayingPlayers,function Trig_Quest_ScorchedEarth_End_Reward_EachPlayer)
    if(Trig_Quest_ScorchedEarth_End_Cond_HuntCountLow())then
        if(Trig_Quest_ScorchedEarth_End_Cond_NoHuntActive())then
            call RemoveUnitFromStockBJ('n0NF',gg_unit_nsw2_0056) // 'n0NF': unit "Hunt: Okuu"
            set udg_HuntStock[$A]=(udg_HuntStock[$A]-1) // $A = 10
            call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
        else
            call GroupRemoveUnitSimple(udg_HuntTarget[28],udg_HuntMonsters)
            call GroupRemoveUnitSimple(udg_HuntTarget[28],udg_BossGroup)
            call DisableTrigger(gg_trg_Okuu_Death)
            call DestroyTrigger(gg_trg_Okuu_Death)
            call LeaderboardRemovePlayerItemBJ(ConvertedPlayer(28),udg_HuntLeaderboard)
            call SaveIntegerBJ(0,8,28,udg_HuntData)
            set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
            if(Trig_Quest_ScorchedEarth_End_Cond_BoardEmpty())then
                call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
            endif
            call ForceAddPlayerSimple(ConvertedPlayer(28),udg_HuntSlots)
            call RemoveUnit(udg_HuntTarget[28])
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_ScorchedEarth takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part16 (module Quest),
// which keeps the original registration order.

function Register_Quest_ScorchedEarth_Start takes nothing returns nothing
    set gg_trg_Quest_ScorchedEarth_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ScorchedEarth_Start)
    call TriggerAddCondition(gg_trg_Quest_ScorchedEarth_Start,Condition(function Trig_Quest_ScorchedEarth_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_ScorchedEarth_Start,function Trig_Quest_ScorchedEarth_Start_Actions)
endfunction

function Register_Quest_ScorchedEarth_End takes nothing returns nothing
    set gg_trg_Quest_ScorchedEarth_End=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_ScorchedEarth_End)
    call TriggerRegisterUnitEvent(gg_trg_Quest_ScorchedEarth_End,gg_unit_U00Q_0023,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_ScorchedEarth_End,function Trig_Quest_ScorchedEarth_End_Actions)
endfunction

endlibrary

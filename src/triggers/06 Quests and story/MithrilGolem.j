library TMithrilGolem requires TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_MithrilGolem_Prepare=null
    trigger gg_trg_MithrilGolem_Start=null
    trigger gg_trg_MithrilGolem_Death=null
    trigger gg_trg_MithrilGolem_Activate=null
    // Variables only this module uses.
    real udg_AlmaSavedFacing=0
endglobals

function Trig_MithrilGolem_Prepare_Cond_PrereqQuestNotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[9])==false)
endfunction

function Trig_MithrilGolem_Prepare_Actions takes nothing returns nothing
    local location l_tempPoint
    local location l_tempPoint2
    if(Trig_MithrilGolem_Prepare_Cond_PrereqQuestNotDone())then
        call StartTimerBJ(udg_SharedDelayTimer1,false,30)
        set l_tempPoint=null
        set l_tempPoint2=null
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call Wait_Polled(10.)
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAlma has something to tell you !!!|r")
    call PlaySoundBJ(gg_snd_JainaWhat)
    set udg_SpecialEffect[22]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hjai_0093,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_MithrilGolem_Start)
    set l_tempPoint=GetRectCenter(gg_rct_237)
    set l_tempPoint2=GetUnitLoc(gg_unit_Hjai_0093)
    call CreateNUnitsAtLocFacingLocBJ(1,'n015',Player(9),l_tempPoint,l_tempPoint2) // 'n015': unit "Mithril Golem"
    call RemoveLocation(l_tempPoint)
    call RemoveLocation(l_tempPoint2)
    // (maximum health of GetLastCreatedUnit()) divided by (3).
    call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 3))
    // (BlzGetUnitArmor(GetLastCreatedUnit())) divided by (3).
    call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())/ 3.))
    set udg_GolemUnit[4]=GetLastCreatedUnit()
    call UnitAddAbilityBJ('Abun',udg_GolemUnit[4]) // 'Abun': object name not found in map data
    call SetUnitTimeScalePercent(udg_GolemUnit[4],.0)
    call SetUnitInvulnerable(udg_GolemUnit[4],true)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
    set l_tempPoint2=null
endfunction

function Trig_MithrilGolem_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hjai_0093,true,true,true))
endfunction

function Trig_MithrilGolem_Start_ApplyQuestCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_004,GetEnumPlayer(),1.)
endfunction

function Trig_MithrilGolem_Start_Cond_ShowBriefing takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MithrilGolem_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[22])
    if(Trig_MithrilGolem_Start_Cond_ShowBriefing())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MithrilGolem_Start_ApplyQuestCam)
        call Text_Say(gg_unit_Hjai_0093,"It looks like I might need your help again. While studying manuscripts related to Fire Golem I found a very interesting document.",false)
        call Text_Say(gg_unit_Hjai_0093,"It contains information on how to create powerful Mithril Golems. Such Golems are hard to produce but they are excellent warriors. And we might soon need strong defenders if more monsters assault Kalm.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And how can we help you?",false)
        call Text_Say(gg_unit_Hjai_0093,"As you can see, I already constructed Mithril Golem using instructions in the document. But I lack one important component required for animation of the golem - it's heart.",false)
        call Text_Say(gg_unit_Hjai_0093,"All Golems carry such devices that are usually called hearts. They are the source of Golem's \"life\". Golem hearts are usually destroyed together with Golems but hearts of stronger Golems, such as Fire or Mithril, had to be preserved because their creation was very complex.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Let me guess - you want us to bring you Mithril Golem's Heart? And the only way to get it is to smash a Mithril Golem. Am I right?",false)
        call Text_Say(gg_unit_Hjai_0093,"Yes, you are. But the problem is that I have no idea where Mithril Golems can be found.",false)
        call Text_Say(gg_unit_Hjai_0093,"It seems all Mithril Golems were wiped out a few generations ago, so you won't just find them roaming around.",false)
        call Text_Transmission(gg_unit_Hjai_0093,"Alma","It seems all Mithril Golems were wiped out a few generations ago, so you won't just find them roaming around.\r\nHowever, our ancestors were good thinkers. They locked away one survivor of their species in case there was a need for one.","It seems all Mithril Golems were wiped out a few generations ago, so you won't just find them roaming around.",null,0,false)
        call Text_Say(gg_unit_Hjai_0093,"An ancient scroll I found speaks of this survivor's existence. However, there is only one hint to its location, and I can't understand what it means.",false)
        call Text_Say(gg_unit_Hjai_0093,"It reads: \"One of those who are neither alive nor undead carry the key to the prison of the mightiest of them that is on the land surrounded by water in the center of the world.\"",false)
        call Text_Say(gg_unit_Hjai_0093,"I hope you can make more sense of this hint than I can. If you can find Mithril Golem and bring me its Heart, I will reward you with the rarest treasure I have.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It is a strange hint indeed, but don't worry - I am sure we will eventually encounter this Mithril Golem.",false)
        call Text_Say(gg_unit_Hjai_0093,"And I hope you survive this encounter. Good luck to you!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Mithril Golem's Heart|r")
    set udg_SideQuest[16]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Mithril Golem's Heart"),"Alma, Cleric from Kalm, asked you to find Mithril Golem, destroy it, take Golem's heart and bring it to her. She has promised to give you her rarest treasure as a reward.\r\nShe has given you a strange hint: \"One of those who are neither alive nor undead carry the key to the prison of the mightiest of them that is on the land surrounded by water in the center of the world.\"","ReplaceableTextures\\CommandButtons\\BTNHeartOfAszune.blp")
    set udg_SpecialEffect[24]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hjai_0093,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_StrangeKey_Drop)
    call AddItemToStockBJ('I05C',gg_unit_n02Y_0052,1,1) // 'I05C': item "Information: Mithril Golem"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MithrilGolem_Death_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[2]=CreateItemLoc('I022',l_tempPoint) // 'I022': item "Mithril Golem's Heart"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveLocation(l_tempPoint)
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    call EnableTrigger(gg_trg_GolemHeart_Ping)
    call EnableTrigger(gg_trg_GolemHeart_Pickup)
    call SaveIntegerBJ(1,2,'h',udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_MithrilGolem_Activate_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I022'))and(IsUnitHiddenBJ(gg_unit_Hjai_0093)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I022': item "Mithril Golem's Heart"
endfunction

function Trig_MithrilGolem_Activate_ApplyRitualCam takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_004,GetEnumPlayer(),1.)
endfunction

function Trig_MithrilGolem_Activate_ResetCam takes nothing returns nothing
    call ResetToGameCameraForPlayer(GetEnumPlayer(),0)
endfunction

function Trig_MithrilGolem_Activate_Cond_ShowActivation takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_MithrilGolem_Activate_GiveAeroMateria takes nothing returns nothing
    call UnitAddItemByIdSwapped('I07N',Player_GetHero(GetEnumPlayer())) // 'I07N': item "Aero Materia"
endfunction

function Trig_MithrilGolem_Activate_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_GolemHeart_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022')) // 'I022': item "Mithril Golem's Heart"
    call DestroyEffectBJ(udg_SpecialEffect[24])
    if(Trig_MithrilGolem_Activate_Cond_ShowActivation())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_MithrilGolem_Activate_ApplyRitualCam)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hello Alma. We found one intact Mithril Golem, defeated it, took it's heart and brought it to you.",false)
        call Text_Say(gg_unit_Hjai_0093,"That's great. I hope it will work with the Golem I constructed!",false)
        call ForForce(udg_PlayingPlayers,function Trig_MithrilGolem_Activate_ResetCam)
        call Cam_PanToUnit(gg_unit_Hjai_0093,0)
        call Text_Say(gg_unit_Hjai_0093,"I shall now try to activate the heart.",false)
        set udg_AlmaSavedFacing=GetUnitFacing(gg_unit_Hjai_0093)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Hjai_0093,udg_GolemUnit[4],0)
        set udg_TempUnit=udg_GolemUnit[4]
        call SetUnitAnimation(gg_unit_Hjai_0093,"victory")
        set udg_TempPoint=GetUnitLoc(udg_TempUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(2)
        set udg_TempPoint=GetUnitLoc(udg_TempUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.5)
        set udg_TempPoint=GetUnitLoc(udg_TempUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.25)
        set udg_TempPoint=GetUnitLoc(udg_TempUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(udg_TempUnit)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        call SetUnitTimeScalePercent(udg_GolemUnit[4],100.)
        call ResetUnitAnimation(gg_unit_Hjai_0093)
        call Text_Say(gg_unit_Hjai_0093,"It seems to work.",false)
        call Text_Say(gg_unit_Hjai_0093,"Golem, report status.",false)
        call Text_Say(udg_GolemUnit[4],"Mechanisms Check . . . Complete.",false)
        call Text_Transmission(udg_GolemUnit[4],"Mithril Golem","Mechanisms Check . . . Complete.\r\nIntegrity Check . . . Complete.","Mechanisms Check . . . Complete.",null,0,false)
        call Text_Transmission(udg_GolemUnit[4],"Mithril Golem","Mechanisms Check . . . Complete.\r\nIntegrity Check . . . Complete.\r\nData Check . . . Complete","Mechanisms Check . . . Complete.\r\nIntegrity Check . . . Complete.",null,0,false)
        call Text_Transmission(udg_GolemUnit[4],"Mithril Golem","Mechanisms Check . . . Complete.\r\nIntegrity Check . . . Complete.\r\nData Check . . . Complete\r\nStatus: Operational","Mechanisms Check . . . Complete.\r\nIntegrity Check . . . Complete.\r\nData Check . . . Complete",null,0,false)
        call Text_Say(udg_GolemUnit[4],"Ready to serve.",false)
        call Text_Say(gg_unit_Hjai_0093,"It really works !!!",false)
        call Text_Say(gg_unit_Hjai_0093,"Golem, wait for further orders.",false)
        call Text_Say(udg_GolemUnit[4],"Order registered. Will standby for further instructions.",false)
        call SetUnitFacingTimed(gg_unit_Hjai_0093,udg_AlmaSavedFacing,0)
        call Text_Say(gg_unit_Hjai_0093,"Thank you very much. We now have a powerful ally on our side and have far better chances of surviving an attack if it does happen.",false)
        call Text_Say(gg_unit_Hjai_0093,"To show you my gratitude I will give you a rare treasure. I hope you use it well...",false)
        call Reward_Give(5000,5000,gg_unit_Hjai_0093)
        call Text_Say(gg_unit_Hjai_0093,"|n|cffffcc00All players get a piece of Aero Materia.|r",true)
        call Cine_ExitAction()
    else
        call SetUnitTimeScalePercent(udg_GolemUnit[4],100.)
        call Reward_Give(5000,5000,gg_unit_Hjai_0093)
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00All players get a piece of Aero Materia.|r")
    endif
    call ForForce(udg_PlayingPlayers,function Trig_MithrilGolem_Activate_GiveAeroMateria)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Mithril Golem's Heart|r")
    call QuestSetCompletedBJ(udg_SideQuest[16],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,'|',udg_GameStateHash)
    call GroupAddUnitSimple(udg_GolemUnit[4],udg_RecruitedAllies)
    call AddUnitToStockBJ('n0BB',gg_unit_h02Z_0230,1,1) // 'n0BB': unit "Hunt: Adamantoise"
    set udg_HuntStock[3]=(udg_HuntStock[3]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_MithrilGolem automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_MithrilGolem (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_MithrilGolem takes nothing returns nothing
endfunction

function Register_MithrilGolem_Prepare takes nothing returns nothing
    set gg_trg_MithrilGolem_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_MithrilGolem_Prepare)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_MithrilGolem_Prepare,udg_SharedDelayTimer1)
    call TriggerAddAction(gg_trg_MithrilGolem_Prepare,function Trig_MithrilGolem_Prepare_Actions)
endfunction

function Register_MithrilGolem_Start takes nothing returns nothing
    set gg_trg_MithrilGolem_Start=CreateTrigger()
    call DisableTrigger(gg_trg_MithrilGolem_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_MithrilGolem_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_MithrilGolem_Start,Condition(function Trig_MithrilGolem_Start_Conditions))
    call TriggerAddAction(gg_trg_MithrilGolem_Start,function Trig_MithrilGolem_Start_Actions)
endfunction

function Register_MithrilGolem_Death takes nothing returns nothing
    set gg_trg_MithrilGolem_Death=CreateTrigger()
    call DisableTrigger(gg_trg_MithrilGolem_Death)
    call TriggerAddAction(gg_trg_MithrilGolem_Death,function Trig_MithrilGolem_Death_Actions)
endfunction

function Register_MithrilGolem_Activate takes nothing returns nothing
    set gg_trg_MithrilGolem_Activate=CreateTrigger()
    call DisableTrigger(gg_trg_MithrilGolem_Activate)
    call TriggerRegisterUnitInRangeSimple(gg_trg_MithrilGolem_Activate,450.,gg_unit_Hjai_0093)
    call TriggerAddCondition(gg_trg_MithrilGolem_Activate,Condition(function Trig_MithrilGolem_Activate_Conditions))
    call TriggerAddAction(gg_trg_MithrilGolem_Activate,function Trig_MithrilGolem_Activate_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_MithrilGolem takes nothing returns nothing
    call Register_MithrilGolem_Prepare() // starts off; enabled by Quest_FireGolem
    call Register_MithrilGolem_Start() // starts off; enabled by MithrilGolem
    call Register_MithrilGolem_Death() // starts off; enabled by StrangeCage
    call Register_MithrilGolem_Activate() // starts off; enabled by GolemHeart
endfunction

endlibrary

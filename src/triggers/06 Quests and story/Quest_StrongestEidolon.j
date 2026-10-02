library TQuestStrongestEidolon requires TCam, TCine, TPlayerHero, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_StrongestEidolon_Start=null
    trigger gg_trg_Quest_StrongestEidolon_Complete=null
endglobals

function Trig_Quest_StrongestEidolon_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_u007_0128,true,true,true))
endfunction

function Trig_Quest_StrongestEidolon_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_StrongestEidolon_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[51])
    if(Trig_Quest_StrongestEidolon_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_u007_0128,"Wow! It seems like you're the strongest person in Gaya!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Am I?",false)
        call Text_Say(gg_unit_u007_0128,"Yes. You have defeated the grand undefeated legend of Gaya: Ultima Weapon!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wasn't there anything stronger?",false)
        call Text_Say(gg_unit_u007_0128,"Even if there was, you're still the strongest; nobody else has ever managed to defeat it before. And thanks to you I've caught some of Ultima Weapon's spreading energy using the Tiara of the Deep.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Huh? What do you mean?",false)
        call Text_Say(gg_unit_u007_0128,"The Tiara of the Deep - or Tiara of the Holy Garden, as it was called before Vodyan stole it - is capable of catching energy from decaying fiends.",false)
        call Text_Say(gg_unit_u007_0128,"When you defeated Ultima Weapon, I immediatly used it and caught a lot of energy with it.",false)
        call Text_Say(gg_unit_u007_0128,"The Eidolon which I can now summon will be far stronger than Ultima Weapon! After all, it has a large portion of Ultima Weapon's energy.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. So can we fight your Eidolon?",false)
        call Text_Say(gg_unit_u007_0128,"When you're ready. But please remember, I can not reward you. This is simply to test your strength.",false)
        call Text_Say(gg_unit_u007_0128,"But be warned, my power is limited. The Eidolon only stays in Gaya for five minutes after I summon it, so you better hurry up.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Tell me, what is the name of your incredibly strong Eidolon?",false)
        call Text_Say(gg_unit_u007_0128,"People call it |cffffcc00Eden|r. The Tiara of the Holy Garden was designed for the very purpose of gathering enough energy to summon this very Eidolon.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00The Strongest Eidolon|r")
    set udg_SideQuest[33]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"The Strongest Eidolon"),"Summoner Priscilla has given you the possibility of fighting the Strongest Eidolon. Defeat it!","ReplaceableTextures\\CommandButtons\\BTNChimaera.blp")
    set udg_SpecialEffect[51]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u007_0128,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Eden_Summon)
    call UnitAddAbilityBJ('Ane2',gg_unit_u007_0128) // 'Ane2': object name not found in map data
    call UnitAddAbilityBJ('A0IK',gg_unit_u007_0128) // 'A0IK': ability "Summon Eden"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_StrongestEidolon_Complete_Cond_TrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_StrongestEidolon_Complete_Cond_TowerOwned takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_h00Z_0130)==Player($A)) // $A = 10
endfunction

function Trig_Quest_StrongestEidolon_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_StrongestEidolon_Complete_Cond_DarkEdenPending takes nothing returns boolean
    return(udg_QuestFlag[4])
endfunction

function Trig_Quest_StrongestEidolon_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_StrongestEidolon_Complete_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call DestroyEffectBJ(udg_SpecialEffect[51])
    call GroupRemoveUnitSimple(gg_unit_N02I_0074,udg_BossGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0L0',udg_TempPoint) // 'I0L0': item "Aeon Scepter"
    call RemoveLocation(udg_TempPoint)
    call UnitRemoveAbilityBJ('A0IK',gg_unit_u007_0128) // 'A0IK': ability "Summon Eden"
    call UnitRemoveAbilityBJ('Ane2',gg_unit_u007_0128) // 'Ane2': object name not found in map data
    call DisableTrigger(gg_trg_Eden_Despawn)
    call PauseTimerBJ(true,udg_EdenTimer)
    call DestroyTimerDialogBJ(udg_EdenTimerDialog)
    call UnitAddAbilityBJ('A0CE',gg_unit_h00Z_0130) // 'A0CE': ability "Eden"
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    if(Trig_Quest_StrongestEidolon_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_u007_0128,0)
        call Text_Say(gg_unit_u007_0128,"I can't believe it! You really defeated him!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"He was not easy to defeat, but it was a very good fight.",false)
        call Text_Say(gg_unit_u007_0128,"I am very impressed. You have proven you're worthy of the title of 'Strongest in Gaya'!",false)
        if(Trig_Quest_StrongestEidolon_Complete_Cond_TowerOwned())then
            call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"I've got a question. Now that we've defeated Eden, can we summon him at Tower of Summoning?",false)
            call Text_Say(gg_unit_u007_0128,"Yes. But keep in mind that we can't both summon Eden at the same time.",false)
            call Text_Say(gg_unit_u007_0128,"And since you don't have the Tiara of the Holy Garden to power Eden up, yours will not be as strong as mine.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetKillingUnitBJ())),"Alright, thanks anyways.",false)
        endif
        call Reward_Give(0,$2710,gg_unit_u007_0128) // $2710 = 10000
        call Cine_ExitAction()
    else
        call Reward_Give(0,$2710,gg_unit_u007_0128) // $2710 = 10000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00The Strongest Eidolon|r")
    call QuestSetCompletedBJ(udg_SideQuest[33],true)
    call QuestSetDescriptionBJ(udg_SideQuest[33],"You defeated Eden! Congrats!!\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nSomeone might be impressed by that...")
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,'p',udg_GameStateHash)
    if(Trig_Quest_StrongestEidolon_Complete_Cond_DarkEdenPending())then
        call AddItemToStockBJ('I07U',gg_unit_n02Y_0052,1,1) // 'I07U': item "Information: Dark Eden"
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_StrongestEidolon takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part12 (module Quest),
// which keeps the original registration order.

function Register_Quest_StrongestEidolon_Start takes nothing returns nothing
    set gg_trg_Quest_StrongestEidolon_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_StrongestEidolon_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_StrongestEidolon_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_StrongestEidolon_Start,Condition(function Trig_Quest_StrongestEidolon_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_StrongestEidolon_Start,function Trig_Quest_StrongestEidolon_Start_Actions)
endfunction

function Register_Quest_StrongestEidolon_Complete takes nothing returns nothing
    set gg_trg_Quest_StrongestEidolon_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_StrongestEidolon_Complete)
    call TriggerRegisterUnitEvent(gg_trg_Quest_StrongestEidolon_Complete,gg_unit_N02I_0074,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_StrongestEidolon_Complete,function Trig_Quest_StrongestEidolon_Complete_Actions)
endfunction

endlibrary

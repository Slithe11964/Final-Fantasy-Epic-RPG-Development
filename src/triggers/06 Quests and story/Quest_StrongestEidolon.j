library TQuestStrongestEidolon requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText
// Side quest "The Strongest Eidolon", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Summoner Priscilla offers a fight against Eden. Steps: talk to Priscilla (data), defeat Eden (Eden
// appears when Priscilla casts Summon Eden, module Eden; this module's Complete trigger plays the
// ending and calls Quest_StepDone). Made available by Priscilla (QuestStrongestEidolon_Available).
// It does not count toward the story progress.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_StrongestEidolon_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_STRONGEST_EIDOLON=0
endglobals

// Step 1 done (the party talked to Priscilla): she can now summon Eden.
function QuestStrongestEidolon_Started takes nothing returns nothing
    call EnableTrigger(gg_trg_Eden_Summon)
    call UnitAddAbilityBJ('Ane2',gg_unit_u007_0128) // 'Ane2': object name not found in map data
    call UnitAddAbilityBJ('A0IK',gg_unit_u007_0128) // 'A0IK': ability "Summon Eden"
endfunction

function QuestStrongestEidolon_Define takes nothing returns nothing
    local integer q=Quest_Define("The Strongest Eidolon",QUEST_SIDE,33,"ReplaceableTextures\\CommandButtons\\BTNChimaera.blp")
    set QUEST_STRONGEST_EIDOLON=q
    call Quest_NotStory(q)
    // 1. Talk to Priscilla
    call Quest_Talk(q,gg_unit_u007_0128,"Summoner Priscilla has given you the possibility of fighting the Strongest Eidolon. Defeat it!")
    call Quest_Say(q,gg_unit_u007_0128,"Wow! It seems like you're the strongest person in Gaya!")
    call Quest_Say(q,null,"Am I?")
    call Quest_Say(q,gg_unit_u007_0128,"Yes. You have defeated the grand undefeated legend of Gaya: Ultima Weapon!")
    call Quest_Say(q,null,"Wasn't there anything stronger?")
    call Quest_Say(q,gg_unit_u007_0128,"Even if there was, you're still the strongest; nobody else has ever managed to defeat it before. And thanks to you I've caught some of Ultima Weapon's spreading energy using the Tiara of the Deep.")
    call Quest_Say(q,null,"Huh? What do you mean?")
    call Quest_Say(q,gg_unit_u007_0128,"The Tiara of the Deep - or Tiara of the Holy Garden, as it was called before Vodyan stole it - is capable of catching energy from decaying fiends.")
    call Quest_Say(q,gg_unit_u007_0128,"When you defeated Ultima Weapon, I immediatly used it and caught a lot of energy with it.")
    call Quest_Say(q,gg_unit_u007_0128,"The Eidolon which I can now summon will be far stronger than Ultima Weapon! After all, it has a large portion of Ultima Weapon's energy.")
    call Quest_Say(q,null,"I see. So can we fight your Eidolon?")
    call Quest_Say(q,gg_unit_u007_0128,"When you're ready. But please remember, I can not reward you. This is simply to test your strength.")
    call Quest_Say(q,gg_unit_u007_0128,"But be warned, my power is limited. The Eidolon only stays in Gaya for five minutes after I summon it, so you better hurry up.")
    call Quest_Say(q,null,"Tell me, what is the name of your incredibly strong Eidolon?")
    call Quest_Say(q,gg_unit_u007_0128,"People call it |cffffcc00Eden|r. The Tiara of the Holy Garden was designed for the very purpose of gathering enough energy to summon this very Eidolon.")
    call Quest_OnDone(q,"QuestStrongestEidolon_Started")
    // 2. Defeat Eden: gg_trg_Quest_StrongestEidolon_Complete calls Quest_StepDone
    call Quest_Custom(q,"")
endfunction

// Called by Priscilla when the quest becomes available.
function QuestStrongestEidolon_Available takes nothing returns nothing
    if QUEST_STRONGEST_EIDOLON==0 then
        call QuestStrongestEidolon_Define()
    endif
    call Quest_MakeAvailable(QUEST_STRONGEST_EIDOLON)
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
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_StrongestEidolon_Complete_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call GroupRemoveUnitSimple(gg_unit_N02I_0074,udg_BossGroup)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0L0',l_tempPoint) // 'I0L0': item "Aeon Scepter"
    call RemoveLocation(l_tempPoint)
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
    call Quest_StepDone(QUEST_STRONGEST_EIDOLON,GetOwningPlayer(GetKillingUnitBJ()),GetKillingUnitBJ())
    call QuestSetDescriptionBJ(Quest_LogEntry(QUEST_STRONGEST_EIDOLON),"You defeated Eden! Congrats!!\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\nSomeone might be impressed by that...")
    call SaveIntegerBJ(1,2,'p',udg_GameStateHash)
    if(Trig_Quest_StrongestEidolon_Complete_Cond_DarkEdenPending())then
        call AddItemToStockBJ('I07U',gg_unit_n02Y_0052,1,1) // 'I07U': item "Information: Dark Eden"
    endif
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function InitTrig_Quest_StrongestEidolon takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part12 (module Quest),
// which keeps the original registration order.

function Register_Quest_StrongestEidolon_Complete takes nothing returns nothing
    set gg_trg_Quest_StrongestEidolon_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_StrongestEidolon_Complete)
    call TriggerRegisterUnitEvent(gg_trg_Quest_StrongestEidolon_Complete,gg_unit_N02I_0074,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_StrongestEidolon_Complete,function Trig_Quest_StrongestEidolon_Complete_Actions)
endfunction

endlibrary

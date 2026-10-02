library TBernkastel requires TCam, TCine, TMusic, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Bernkastel_State_Reset=null
    trigger gg_trg_Bernkastel_Try_Spawn=null
    trigger gg_trg_Bernkastel_First_Talk=null
    trigger gg_trg_Bernkastel_Second_Talk=null
    trigger gg_trg_Bernkastel_Hint_Talk=null
    trigger gg_trg_Bernkastel_Final_Talk=null
    trigger gg_trg_Bernkastel_Despawn=null
endglobals

function Trig_Bernkastel_State_Reset_Actions takes nothing returns nothing
    set udg_MiracleStage[0]=-1
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Bernkastel_Try_Spawn_Enum_SumLuck takes nothing returns nothing
    // (udg_TempInteger) plus (udg_MetaFragments at position GetConvertedPlayerId(the player being visited)).
    set udg_TempInteger=(udg_TempInteger+udg_MetaFragments[GetConvertedPlayerId(GetEnumPlayer())])
    // Result 1: the larger of (udg_MiracleStage at position 0) and (udg_MiracleStage at position
    // GetConvertedPlayerId(the player being visited)).
    set udg_MiracleStage[0]=IMaxBJ(udg_MiracleStage[0],udg_MiracleStage[GetConvertedPlayerId(GetEnumPlayer())])
endfunction

function Trig_Bernkastel_Try_Spawn_Cond_FirstVisitRoll takes nothing returns boolean
    // A random whole number from 1 through 50.
    return(GetRandomInt(1,50)<=udg_TempInteger)
endfunction

function Trig_Bernkastel_Try_Spawn_Cond_ThirdVisitRoll takes nothing returns boolean
    // A random whole number from 1 through 20.
    return(udg_MiracleStage[0]==3)and(GetRandomInt(1,20)<=udg_TempInteger)
endfunction

function Trig_Bernkastel_Try_Spawn_Cond_SecondVisitDue takes nothing returns boolean
    return(udg_MiracleStage[0]==2)
endfunction

function Trig_Bernkastel_Try_Spawn_Cond_NeverMet takes nothing returns boolean
    return(udg_MiracleStage[0]==0)
endfunction

function Trig_Bernkastel_Try_Spawn_Actions takes nothing returns nothing
    set udg_MiracleStage[0]=0
    set udg_TempInteger=2
    call ForForce(udg_PlayingPlayers,function Trig_Bernkastel_Try_Spawn_Enum_SumLuck)
    if(Trig_Bernkastel_Try_Spawn_Cond_NeverMet())then
        if(Trig_Bernkastel_Try_Spawn_Cond_FirstVisitRoll())then
            set udg_TempPoint=GetRectCenter(gg_rct_572)
            call CreateNUnitsAtLoc(1,'e00Y',Player(8),udg_TempPoint,135.) // 'e00Y': unit "Mysterious Blue Girl"
            call RemoveLocation(udg_TempPoint)
            set udg_BlueGirl=GetLastCreatedUnit()
            call SetUnitColor(udg_BlueGirl,PLAYER_COLOR_BLUE)
            call SetUnitVertexColorBJ(udg_BlueGirl,.0,.0,'d',75.)
            call StartTimerBJ(udg_BlueGirlTimer,false,300.)
            call EnableTrigger(gg_trg_Bernkastel_First_Talk)
        endif
    else
        if(Trig_Bernkastel_Try_Spawn_Cond_SecondVisitDue())then
            set udg_MiracleStage[0]=1
            set udg_TempPoint=GetRectCenter(gg_rct_572)
            call CreateNUnitsAtLoc(1,'e00Y',Player(8),udg_TempPoint,135.) // 'e00Y': unit "Mysterious Blue Girl"
            call RemoveLocation(udg_TempPoint)
            set udg_BlueGirl=GetLastCreatedUnit()
            call SetUnitColor(udg_BlueGirl,PLAYER_COLOR_BLUE)
            call StartTimerBJ(udg_BlueGirlTimer,false,300.)
            call EnableTrigger(gg_trg_Bernkastel_Second_Talk)
        else
            if(Trig_Bernkastel_Try_Spawn_Cond_ThirdVisitRoll())then
                set udg_TempPoint=GetRectCenter(gg_rct_572)
                call CreateNUnitsAtLoc(1,'e00Y',Player(8),udg_TempPoint,135.) // 'e00Y': unit "Mysterious Blue Girl"
                call RemoveLocation(udg_TempPoint)
                set udg_BlueGirl=GetLastCreatedUnit()
                call SetUnitColor(udg_BlueGirl,PLAYER_COLOR_BLUE)
                call StartTimerBJ(udg_BlueGirlTimer,false,300.)
                call EnableTrigger(gg_trg_Bernkastel_Hint_Talk)
            endif
            set udg_MiracleStage[0]=-1
        endif
    endif
endfunction

function Trig_Bernkastel_First_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_BlueGirl,true,true,false))
endfunction

function Trig_Bernkastel_First_Talk_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Bernkastel_Despawn)
    call DestroyTrigger(gg_trg_Bernkastel_Despawn)
    call PauseTimerBJ(true,udg_BlueGirlTimer)
    call SetUnitVertexColorBJ(udg_BlueGirl,.0,.0,'d',.0)
    call Cine_Enter()
    call Cam_PanToUnit(udg_BlueGirl,0)
    call Text_Say(udg_BlueGirl,"Hmm, this is peculiar.",false)
    call Text_Say(udg_BlueGirl,"According to my calculations, the probability that you'd ever encounter and talk to me is close to zero.",false)
    call Text_Say(udg_BlueGirl,"... very interesting indeed.",false)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Um, excuse me little girl, what are you plattering on about?",false)
    call Text_Say(udg_BlueGirl,"Let's put this to the test.",false)
    call Text_Say(udg_BlueGirl,"If this is just a coincidence... it's not worth my time. But if this is actually something more interesting...",false)
    call Text_Say(udg_BlueGirl,"If by some miracle... there's another witch still toying with this world...",false)
    call Text_Say(udg_BlueGirl,"... then come meet me here again. Same place, same time.",false)
    call SetUnitVertexColorBJ(udg_BlueGirl,.0,.0,'d',25.)
    call Text_Say(udg_BlueGirl,"Don't keep me waiting. I'm not known for my patience.",false)
    call SetUnitVertexColorBJ(udg_BlueGirl,.0,.0,'d',50.)
    call Text_Say(udg_BlueGirl,"But if you do come... then I will be convinced this is worth my time.",false)
    call SetUnitVertexColorBJ(udg_BlueGirl,.0,.0,'d',75.)
    call Text_Say(udg_BlueGirl,"If not... goodbye. We won't meet again.",false)
    call RemoveUnit(udg_BlueGirl)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"She's gone...",false)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"What... was that girl talking about?",false)
    set udg_MiracleStage[0]=2
    call Cine_ExitAction()
endfunction

function Trig_Bernkastel_Second_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_BlueGirl,true,true,false))
endfunction

function Trig_Bernkastel_Second_Talk_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Bernkastel_Despawn)
    call DestroyTrigger(gg_trg_Bernkastel_Despawn)
    call PauseTimerBJ(true,udg_BlueGirlTimer)
    call Cine_Enter()
    call Cam_PanToUnit(udg_BlueGirl,0)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello there.",false)
    call Text_Say(udg_BlueGirl,"You really did come again.",false)
    call Text_Say(udg_BlueGirl,"I suppose I should introduce myself then, from one witch to another.",false)
    call Music_SetTrack(53)
    call Text_Say(udg_BlueGirl,"My name is Bernkastel, I am known as the Witch of Miracles.",false)
    call BlzSetUnitName(udg_BlueGirl,"Bernkastel")
    call Text_Say(Player_GetHero(GetTriggerPlayer()),("My name is "+((GetPlayerName(GetTriggerPlayer())+", and I must apologize, I am not a witch but a ")+(GetUnitName(Player_GetHero(GetTriggerPlayer()))+". Pleased to meet you, Lady Witch of Miracles."))),false)
    call Text_Say(udg_BlueGirl,"Hmm, it would seem this world does not allow you to communicate with me directly. Only this doll speaks.",false)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Doll?",false)
    call Text_Say(udg_BlueGirl,"Be quiet for a second, doll. I'm not talking to you.",false)
    call Text_Say(udg_BlueGirl,"Well this seems rather unfortunate. I'm going to do you a favor and give you a gift since you went ahead and showed me you're there.",false)
    call Text_Say(udg_BlueGirl,"Since I know you're there now, maybe I'll come check up on you some other time. For now, have this.",false)
    call RemoveUnit(udg_BlueGirl)
    set udg_TempPoint=GetRectCenter(gg_rct_572)
    call CreateItemLoc('I0G4',udg_TempPoint) // 'I0G4': item "Miracle Piece"
    call RemoveLocation(udg_TempPoint)
    set udg_MiracleStage[0]=3
    call Cine_ExitAction()
endfunction

function Trig_Bernkastel_Hint_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_BlueGirl,true,true,false))
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_IsHardMode takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_CheaterForce))
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_HasResets takes nothing returns boolean
    return(udg_NewGamePlusLevel[GetConvertedPlayerId(GetTriggerPlayer())]>0)
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_InfernoHintReady takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[29]))and(IsPlayerInForce(GetTriggerPlayer(),udg_SaveFlagForce[351])==false)and(UnitHasItemOfTypeBJ(Player_GetHero(GetTriggerPlayer()),'I0GF')==false)and(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetTriggerPlayer())],'I0GF')==false) // 'I0GF': item "Yatagarasu"
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_CursedBladeHintReady takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_SaveFlagForce[345])==false)and(UnitHasItemOfTypeBJ(Player_GetHero(GetTriggerPlayer()),'I03O')==false)and(UnitHasItemOfTypeBJ(udg_SpiritOfGaya[GetConvertedPlayerId(GetTriggerPlayer())],'I03O')==false) // 'I03O': item "Wyrmhero Blade"
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_JudgeHintReady takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[49])==false)
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_BeastHintReady takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[53])==false)
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_DemonHintReady takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[17])==false)
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_StorylineUnfinished takes nothing returns boolean
    return(IsPlayerInForce(GetTriggerPlayer(),udg_TitleForce[16])==false)
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_GiftRoll takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(udg_CinematicsDisabled==false)and(GetRandomInt(1,2)==1)
endfunction

function Trig_Bernkastel_Hint_Talk_Cond_NotTheChosenPlayer takes nothing returns boolean
    return(udg_MiracleStage[GetConvertedPlayerId(GetTriggerPlayer())]!=3)
endfunction

function Trig_Bernkastel_Hint_Talk_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Bernkastel_Despawn)
    call DestroyTrigger(gg_trg_Bernkastel_Despawn)
    call PauseTimerBJ(true,udg_BlueGirlTimer)
    call Music_SetTrack(53)
    call Cine_Enter()
    call Cam_PanToUnit(udg_BlueGirl,0)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hello there.",false)
    if(Trig_Bernkastel_Hint_Talk_Cond_NotTheChosenPlayer())then
        call Text_Say(udg_BlueGirl,"Sorry, you're not the one I came to see. I'm not interested in you.",false)
        call Text_Say(udg_BlueGirl,"Well maybe some other time.",false)
        call RemoveUnit(udg_BlueGirl)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"...",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"... what?",false)
    else
        call BlzSetUnitName(udg_BlueGirl,"Bernkastel")
        call Text_Say(udg_BlueGirl,"Hello again. I was just curious to check up on you, to see how you've been doing.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'm not sure we've met before?",false)
        call Text_Say(udg_BlueGirl,"Let's see how you're progressing... hmm...",false)
        if(Trig_Bernkastel_Hint_Talk_Cond_StorylineUnfinished())then
            call Text_Say(udg_BlueGirl,"Oh you haven't done the main storyline yet even?",false)
            if(Trig_Bernkastel_Hint_Talk_Cond_HasResets())then
                call Text_Say(udg_BlueGirl,"I guess you reset all your progress back to start. Well that's fine if you feel like it.",false)
                call Text_Say(udg_BlueGirl,"It's useless to try and pursue any goals before maxing out the resets anyways. Just wasted time.",false)
            else
                if(Trig_Bernkastel_Hint_Talk_Cond_IsHardMode())then
                    call Text_Say(udg_BlueGirl,"Oh I see you're trying your hand at the most challenging mode of the game.",false)
                    call Text_Say(udg_BlueGirl,"If that's what you enjoy, I won't stop you. Seems like a waste of time to me, but whatever you like consuming.",false)
                else
                    call Text_Say(udg_BlueGirl,"Well we'll speak again when you're further in, then.",false)
                endif
            endif
        else
            if(Trig_Bernkastel_Hint_Talk_Cond_DemonHintReady())then
                call Text_Say(udg_BlueGirl,"Right, you know how the final storyline boss grows weaker the more of his demons you defeat?",false)
                call Text_Say(udg_BlueGirl,"Well, it kinda makes you wonder if there's something hidden if you kill absolutely none of them, doesn't it?",false)
                call Text_Say(udg_BlueGirl,"Of course that means it's up to you to summon him yourself, but you know where to do that, right?",false)
                call Text_Say(udg_BlueGirl,"Getting there is half the battle of course. So I'll just give you one tip: The key is the key.",false)
            else
                if(Trig_Bernkastel_Hint_Talk_Cond_BeastHintReady())then
                    call Text_Say(udg_BlueGirl,"There's a certain beast that is supposedly impossible to fell with normal weaponry.",false)
                    call Text_Say(udg_BlueGirl,"Truly its defenses are great. But are they truly impenetrable? I wonder.",false)
                else
                    if(Trig_Bernkastel_Hint_Talk_Cond_JudgeHintReady())then
                        call Text_Say(udg_BlueGirl,"You know the Judge is truly well-protected by his arms. Taking them out is key to felling him at last.",false)
                        call Text_Say(udg_BlueGirl,"It would take a true madman to try and defeat him without ever destroying the arms, wouldn't it?",false)
                    else
                        if(Trig_Bernkastel_Hint_Talk_Cond_CursedBladeHintReady())then
                            call Text_Say(udg_BlueGirl,"There's a particularly deviously hidden weapon in this world. A Cursed Dragon Blade.",false)
                            call Text_Say(udg_BlueGirl,"Perhaps you should seek out a gift from a sword collector.",false)
                            call Text_Say(udg_BlueGirl,"Ah but perhaps the original is needed as well?",false)
                        else
                            if(Trig_Bernkastel_Hint_Talk_Cond_InfernoHintReady())then
                                call Text_Say(udg_BlueGirl,"Oh I see you have experienced the Inferno event. It is a rare occurrence happening only once in a great number of fragments.",false)
                                call Text_Say(udg_BlueGirl,"But did you realize the cause of that inferno is not the only intriguing opponent to be found there?",false)
                            else
                                call Text_Say(udg_BlueGirl,"Well you seem to be doing pretty well for yourself.",false)
                                call Text_Say(udg_BlueGirl,"Perhaps someday you'll find the other witch. The one that keeps this loop going.",false)
                            endif
                        endif
                    endif
                endif
            endif
        endif
        call Text_Say(udg_BlueGirl,"See you around.",false)
        if(Trig_Bernkastel_Hint_Talk_Cond_GiftRoll())then
            call Text_Say(udg_BlueGirl,"Oh, and here's another one of these if you can still use it, why not.",false)
            set udg_TempPoint=GetRectCenter(gg_rct_572)
            call CreateItemLoc('I0G4',udg_TempPoint) // 'I0G4': item "Miracle Piece"
            call RemoveLocation(udg_TempPoint)
        endif
        call RemoveUnit(udg_BlueGirl)
    endif
    call Cine_ExitAction()
endfunction

function Trig_Bernkastel_Final_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_BlueGirl,true,true,false))
endfunction

function Trig_Bernkastel_Final_Talk_Actions takes nothing returns nothing
    call SetUnitVertexColorBJ(udg_BlueGirl,.0,.0,'d',.0)
    call Cine_Enter()
    call Cam_PanToUnit(udg_BlueGirl,0)
    call Text_Say(udg_BlueGirl,"I must say, the world progressing to this point is a rather rare occurrence.",true)
    call Text_Say(udg_BlueGirl,"Usually if this happens, the other witch resets time back to before any of this can happen.",true)
    call Text_Say(udg_BlueGirl,"I see, so the serpent is doing this without her knowledge. Cheeky man.",true)
    call Text_Say(udg_BlueGirl,"Anyways, this isn't a miracle. You ending up here was most certainly by design. So this world isn't worth my time. See you some other time.",true)
    call ShowUnitHide(udg_BlueGirl)
    call Text_Say(Player_GetHero(GetTriggerPlayer()),"... Who the hell was that?",true)
    call Cine_ExitAction()
endfunction

function Trig_Bernkastel_Despawn_Cond_WasSecondVisit takes nothing returns boolean
    return(udg_MiracleStage[0]==2)
endfunction

function Trig_Bernkastel_Despawn_Actions takes nothing returns nothing
    call DisableTrigger(gg_trg_Bernkastel_First_Talk)
    call DestroyTrigger(gg_trg_Bernkastel_First_Talk)
    call DisableTrigger(gg_trg_Bernkastel_Second_Talk)
    call DestroyTrigger(gg_trg_Bernkastel_Second_Talk)
    call RemoveUnit(udg_BlueGirl)
    if(Trig_Bernkastel_Despawn_Cond_WasSecondVisit())then
        set udg_MiracleStage[0]=1
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Bernkastel automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Bernkastel (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Bernkastel takes nothing returns nothing
endfunction

function Register_Bernkastel_State_Reset takes nothing returns nothing
    set gg_trg_Bernkastel_State_Reset=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Bernkastel_State_Reset,1.)
    call TriggerAddAction(gg_trg_Bernkastel_State_Reset,function Trig_Bernkastel_State_Reset_Actions)
endfunction

function Register_Bernkastel_Try_Spawn takes nothing returns nothing
    set gg_trg_Bernkastel_Try_Spawn=CreateTrigger()
    call DisableTrigger(gg_trg_Bernkastel_Try_Spawn)
    call TriggerAddAction(gg_trg_Bernkastel_Try_Spawn,function Trig_Bernkastel_Try_Spawn_Actions)
endfunction

function Register_Bernkastel_First_Talk takes nothing returns nothing
    set gg_trg_Bernkastel_First_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Bernkastel_First_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_First_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Bernkastel_First_Talk,Condition(function Trig_Bernkastel_First_Talk_Conditions))
    call TriggerAddAction(gg_trg_Bernkastel_First_Talk,function Trig_Bernkastel_First_Talk_Actions)
endfunction

function Register_Bernkastel_Second_Talk takes nothing returns nothing
    set gg_trg_Bernkastel_Second_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Bernkastel_Second_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Second_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Bernkastel_Second_Talk,Condition(function Trig_Bernkastel_Second_Talk_Conditions))
    call TriggerAddAction(gg_trg_Bernkastel_Second_Talk,function Trig_Bernkastel_Second_Talk_Actions)
endfunction

function Register_Bernkastel_Hint_Talk takes nothing returns nothing
    set gg_trg_Bernkastel_Hint_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Bernkastel_Hint_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Hint_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Bernkastel_Hint_Talk,Condition(function Trig_Bernkastel_Hint_Talk_Conditions))
    call TriggerAddAction(gg_trg_Bernkastel_Hint_Talk,function Trig_Bernkastel_Hint_Talk_Actions)
endfunction

function Register_Bernkastel_Final_Talk takes nothing returns nothing
    set gg_trg_Bernkastel_Final_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Bernkastel_Final_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Bernkastel_Final_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Bernkastel_Final_Talk,Condition(function Trig_Bernkastel_Final_Talk_Conditions))
    call TriggerAddAction(gg_trg_Bernkastel_Final_Talk,function Trig_Bernkastel_Final_Talk_Actions)
endfunction

function Register_Bernkastel_Despawn takes nothing returns nothing
    set gg_trg_Bernkastel_Despawn=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Bernkastel_Despawn,udg_BlueGirlTimer)
    call TriggerAddAction(gg_trg_Bernkastel_Despawn,function Trig_Bernkastel_Despawn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Bernkastel takes nothing returns nothing
    call Register_Bernkastel_State_Reset()
    call Register_Bernkastel_Try_Spawn() // starts off; run by Load
    call Register_Bernkastel_First_Talk() // starts off; enabled by Bernkastel; disabled by Bernkastel; destroyed by Bernkastel
    call Register_Bernkastel_Second_Talk() // starts off; enabled by Bernkastel; disabled by Bernkastel; destroyed by Bernkastel
    call Register_Bernkastel_Hint_Talk() // starts off; enabled by Bernkastel
    call Register_Bernkastel_Final_Talk() // starts off; enabled by Ending
    call Register_Bernkastel_Despawn() // disabled by Bernkastel; destroyed by Bernkastel
endfunction

endlibrary

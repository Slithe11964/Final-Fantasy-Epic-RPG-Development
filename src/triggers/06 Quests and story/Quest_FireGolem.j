library TQuestFireGolem requires TCam, TCine, TForce, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_FireGolem_Init=null
    trigger gg_trg_Quest_FireGolem_Alert=null
    trigger gg_trg_Quest_FireGolem_Start=null
    trigger gg_trg_Quest_FireGolem_HeartDropped=null
    trigger gg_trg_Quest_FireGolem_Ping=null
    trigger gg_trg_Quest_FireGolem_HeartTaken=null
    trigger gg_trg_Quest_FireGolem_Complete=null
endglobals

function Trig_Quest_FireGolem_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n00F_0139)
    call PauseUnitBJ(true,gg_unit_n00F_0139)
    call SetUnitInvulnerable(gg_unit_n00F_0139,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FireGolem_Alert_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"|cff00ffffAlma has something to tell you !!!|r")
    call PlaySoundBJ(gg_snd_JainaWhat)
    set udg_SpecialEffect[22]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hjai_0093,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_FireGolem_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FireGolem_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hjai_0093,true,true,true))
endfunction

function Trig_Quest_FireGolem_Start_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_004,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_FireGolem_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FireGolem_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[22])
    if(Trig_Quest_FireGolem_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_FireGolem_Start_Enum_ApplyCamera)
        call Text_Say(gg_unit_Hjai_0093,"Hello again. It seems I might need your help once again.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'll be glad to help you.",false)
        call Text_Say(gg_unit_Hjai_0093,"There's no way to hatch the Phoenix Egg except by applying tremendous heat to it. We tried our most powerful Fire spells but egg only became a little warmer.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And did you try casting Firaja? That's the most powerful fire-based spell out there.",false)
        call Text_Say(gg_unit_Hjai_0093,"Yes, but, as I said, it was no effect.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So is there any other way to get the \"tremendous heat\"? Maybe there's some volcano nearby?",false)
        call Text_Say(gg_unit_Hjai_0093,"Not that I know of. But there is a way to solve this problem.",false)
        call Text_Say(gg_unit_Hjai_0093,"In ancient times there were mighty Fire Golems created by powerful Wizards. Some years ago one of Golems awakened from its slumber and attacked this town. Many brave Elven warriors and wizards died fighting the Fire Golem but eventually they defeated it.",false)
        call Text_Say(gg_unit_Hjai_0093,"When the Golem stopped functioning it crumbled to dust and only its \"heart\" remained. I think that this was the core that fueled the golem and gave it Fire powers. The \"heart\" was said to be incredibly hot.",false)
        call Text_Say(gg_unit_Hjai_0093,"Some time ago Elven scouts noticed a giant burning construct walking the mountains near Kalm. I think this is one of those legendary Fire Golems.",false)
        call Text_Say(gg_unit_Hjai_0093,"I think if we can get its heart then we might be able to apply its Fire power to the egg and hatch it.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"First we'll have to destroy the Golem. And where can it be found?",false)
        call Text_Say(gg_unit_Hjai_0093,"It was seen in the north-west of Kalm.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"By the way if this heart is so incredibly hot, how will I bring it here? Won't I be scorched?",false)
        call Text_Say(gg_unit_Hjai_0093,"Here's the device that will supress the heat of the heart for some time. Use it after you have destroyed the Fire Golem.\r\n|cffffcc00Alma gives you some weird device.|r",false)
        call Text_Say(gg_unit_Hjai_0093,"Good luck !",false)
        call Cine_ExitAction()
    endif
    call ShowUnitShow(gg_unit_n00F_0139)
    call PauseUnitBJ(false,gg_unit_n00F_0139)
    call SetUnitInvulnerable(gg_unit_n00F_0139,false)
    call GroupAddUnitSimple(gg_unit_n00F_0139,udg_ImmolationAuraGroup)
    call GroupAddUnitSimple(gg_unit_n00F_0139,udg_BossUnits)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Fire Golem's Heart|r")
    set udg_SideQuest[7]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Fire Golem's Heart"),"Alma, Cleric from Kalm, asked you to bring her Fire Golem's Heart.","ReplaceableTextures\\CommandButtons\\BTNInfernal.blp")
    set udg_SpecialEffect[24]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hjai_0093,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_FireGolem_HeartDropped)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FireGolem_HeartDropped_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_QuestItem[2]=CreateItemLoc('jpnt',l_tempPoint) // 'jpnt': item "Fire Golem's Heart"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call CreateItemLoc('I01E',l_tempPoint) // 'I01E': item "Fire Wand"
    call RemoveLocation(l_tempPoint)
    call EnableTrigger(gg_trg_Quest_FireGolem_Ping)
    call EnableTrigger(gg_trg_Quest_FireGolem_HeartTaken)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Quest_FireGolem_Ping_Conditions takes nothing returns boolean
    return(udg_QuestItem[2]!=null)
endfunction

function Trig_Quest_FireGolem_Ping_Cond_HeartCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[2]))
endfunction

function Trig_Quest_FireGolem_Ping_Actions takes nothing returns nothing
    if(Trig_Quest_FireGolem_Ping_Cond_HeartCarried())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Hjai_0093)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[2])
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Quest_FireGolem_HeartTaken_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='jpnt') // 'jpnt': item "Fire Golem's Heart"
endfunction

function Trig_Quest_FireGolem_HeartTaken_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the Fire Golem's heart to Alma.")
    call QuestSetDescriptionBJ(udg_SideQuest[7],"Bring the Fire Golem's heart to Alma.")
    call EnableTrigger(gg_trg_Quest_FireGolem_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_FireGolem_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'jpnt'))and(IsUnitHiddenBJ(gg_unit_Hjai_0093)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'jpnt': item "Fire Golem's Heart"
endfunction

function Trig_Quest_FireGolem_Complete_Cond_TowerOwned_Text takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_h00Z_0130)==Player($A)) // $A = 10
endfunction

function Trig_Quest_FireGolem_Complete_Enum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_004,GetEnumPlayer(),1.)
endfunction

function Trig_Quest_FireGolem_Complete_Enum_ResetCamera takes nothing returns nothing
    call ResetToGameCameraForPlayer(GetEnumPlayer(),0)
endfunction

function Trig_Quest_FireGolem_Complete_Cond_TowerOwned_Dialog takes nothing returns boolean
    return(GetOwningPlayer(gg_unit_h00Z_0130)==Player($A)) // $A = 10
endfunction

function Trig_Quest_FireGolem_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_FireGolem_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Quest_FireGolem_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'jpnt')) // 'jpnt': item "Fire Golem's Heart"
    call DestroyEffectBJ(udg_SpecialEffect[24])
    if(Trig_Quest_FireGolem_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Quest_FireGolem_Complete_Enum_ApplyCamera)
        call Text_Say(gg_unit_Hjai_0093,"You're back. Were you able to acquire the Fire Golem's Heart?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That was hard, but we did it. Here's the heart.",false)
        call Text_Say(gg_unit_Hjai_0093,"Oh, that's great ! Thank you very much.",false)
        call ForForce(udg_PlayingPlayers,function Trig_Quest_FireGolem_Complete_Enum_ResetCamera)
        call Cam_PanToUnit(gg_unit_Hjai_0093,0)
        call Text_Say(gg_unit_Hjai_0093,"I shall now release the hidden heat of this heart so take care.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_Hjai_0093)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-300.,0)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'hpxe',Player(8),udg_TempPoint2,bj_UNIT_FACING) // 'hpxe': object name not found in map data
        set udg_CinematicActor=GetLastCreatedUnit()
        call SetUnitAnimation(gg_unit_Hjai_0093,"victory")
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(2)
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        set udg_SpecialEffect[24]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrike1.mdl")
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.5)
        call DestroyEffectBJ(udg_SpecialEffect[24])
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        set udg_SpecialEffect[24]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedTarget.mdl")
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.25)
        call DestroyEffectBJ(udg_SpecialEffect[24])
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set udg_CinematicActor=ReplaceUnitBJ(udg_CinematicActor,'hphx',bj_UNIT_STATE_METHOD_MAXIMUM) // 'hphx': editor label "Phoenix"
        call PauseUnitBJ(true,GetLastReplacedUnitBJ())
        call ResetUnitAnimation(gg_unit_Hjai_0093)
        call Text_Say(gg_unit_Hjai_0093,"Wow ! Cool ! Great ! Awesome ! I didn't expect that to happen so fast !",false)
        call Text_Transmission(udg_CinematicActor,"Phoenix","Thank you for giving me birth. If you are in danger and need help then you can summon me and I'll do my best to aid you.","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We will but for now you are free. Fly high in the clouds and wait for the time we need your asssistance.",false)
        set udg_TempPoint=GetUnitLoc(udg_CinematicActor)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call RemoveUnit(udg_CinematicActor)
        call Wait_Polled(2)
        call Text_Say(gg_unit_Hjai_0093,"I am happy we now have such powerful ally at our side. I didn't know Phoenix was an Eidolon. So, we need to use Tower of Summoning to call for her aid.",false)
        call Text_Say(gg_unit_Hjai_0093,"Thanks for all your help and here, have some gold. Good luck on your journeys !",false)
        call Reward_Give($9C4,$7D0,gg_unit_Hjai_0093) // $9C4 = 2500; $7D0 = 2000
        if(Trig_Quest_FireGolem_Complete_Cond_TowerOwned_Dialog())then
            call Text_Say(gg_unit_Hjai_0093,"|n|cffffcc00Phoenix is now available at Tower of Summoning.|r",true)
        endif
        call Cine_ExitAction()
    else
        call Reward_Give($9C4,$7D0,gg_unit_Hjai_0093) // $9C4 = 2500; $7D0 = 2000
        if(Trig_Quest_FireGolem_Complete_Cond_TowerOwned_Text())then
            call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Phoenix is now available at Tower of Summoning.|r")
        endif
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Fire Golem's Heart|r")
    call QuestSetCompletedBJ(udg_SideQuest[7],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call UnitAddAbilityBJ('A085',gg_unit_h00Z_0130) // 'A085': ability "Phoenix"
    call EnableTrigger(gg_trg_MithrilGolem_Prepare)
    call StartTimerBJ(udg_SharedDelayTimer1,false,300.)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_FireGolem takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part9 (module Quest),
// which keeps the original registration order.

function Register_Quest_FireGolem_Init takes nothing returns nothing
    set gg_trg_Quest_FireGolem_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Quest_FireGolem_Init,function Trig_Quest_FireGolem_Init_Actions)
endfunction

function Register_Quest_FireGolem_Alert takes nothing returns nothing
    set gg_trg_Quest_FireGolem_Alert=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FireGolem_Alert)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_FireGolem_Alert,udg_SharedDelayTimer1)
    call TriggerAddAction(gg_trg_Quest_FireGolem_Alert,function Trig_Quest_FireGolem_Alert_Actions)
endfunction

function Register_Quest_FireGolem_Start takes nothing returns nothing
    set gg_trg_Quest_FireGolem_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FireGolem_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_FireGolem_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_FireGolem_Start,Condition(function Trig_Quest_FireGolem_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_FireGolem_Start,function Trig_Quest_FireGolem_Start_Actions)
endfunction

function Register_Quest_FireGolem_HeartDropped takes nothing returns nothing
    set gg_trg_Quest_FireGolem_HeartDropped=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FireGolem_HeartDropped)
    call TriggerRegisterUnitEvent(gg_trg_Quest_FireGolem_HeartDropped,gg_unit_n00F_0139,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_FireGolem_HeartDropped,function Trig_Quest_FireGolem_HeartDropped_Actions)
endfunction

function Register_Quest_FireGolem_Ping takes nothing returns nothing
    set gg_trg_Quest_FireGolem_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FireGolem_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Quest_FireGolem_Ping,15.)
    call TriggerAddCondition(gg_trg_Quest_FireGolem_Ping,Condition(function Trig_Quest_FireGolem_Ping_Conditions))
    call TriggerAddAction(gg_trg_Quest_FireGolem_Ping,function Trig_Quest_FireGolem_Ping_Actions)
endfunction

function Register_Quest_FireGolem_HeartTaken takes nothing returns nothing
    set gg_trg_Quest_FireGolem_HeartTaken=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FireGolem_HeartTaken)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Quest_FireGolem_HeartTaken,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Quest_FireGolem_HeartTaken,Condition(function Trig_Quest_FireGolem_HeartTaken_Conditions))
    call TriggerAddAction(gg_trg_Quest_FireGolem_HeartTaken,function Trig_Quest_FireGolem_HeartTaken_Actions)
endfunction

function Register_Quest_FireGolem_Complete takes nothing returns nothing
    set gg_trg_Quest_FireGolem_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_FireGolem_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_FireGolem_Complete,450.,gg_unit_Hjai_0093)
    call TriggerAddCondition(gg_trg_Quest_FireGolem_Complete,Condition(function Trig_Quest_FireGolem_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_FireGolem_Complete,function Trig_Quest_FireGolem_Complete_Actions)
endfunction

endlibrary

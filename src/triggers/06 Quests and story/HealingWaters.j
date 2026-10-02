library THealingWaters requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_HealingWaters_HideFamily_Actions takes nothing returns nothing
    call SetUnitAnimation(gg_unit_nvlk_0184,"death")
    call ShowUnitHide(gg_unit_nvlk_0184)
    call ShowUnitHide(gg_unit_nvil_0186)
    call ShowUnitHide(gg_unit_nvlw_0183)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HealingWaters_Prepare_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_nvlk_0184)
    call ShowUnitShow(gg_unit_nvil_0186)
    call ShowUnitShow(gg_unit_nvlw_0183)
    set udg_SpecialEffect[35]=AddSpecialEffectTargetUnitBJ("origin",gg_unit_nvlk_0184,"Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl")
    call SetUnitVertexColorBJ(gg_unit_nvlk_0184,50.,'d',50.,0)
    set udg_SpecialEffect[34]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H00T_0185,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_HealingWaters_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HealingWaters_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_H00T_0185,true,true,true))
endfunction

function Trig_HealingWaters_Start_Cond_ShowIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HealingWaters_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[34])
    if(Trig_HealingWaters_Start_Cond_ShowIntro())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_H00T_0185,"Perhaps you are the one who can help us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"It depends on what should be done and how large the reward is.",false)
        call Text_Say(gg_unit_H00T_0185,"This poor child fell ill some days ago. Neither me nor Alma were able to cure him. Our spells only keep him from dying but they're unable to heal him completely.",false)
        call Text_Say(gg_unit_H00T_0185,"The only way to cure him is to use sacred water from the Fountain of Restoration. But the Fountain in Kalm dried up a long time ago.",false)
        call Text_Say(gg_unit_H00T_0185,"I need someone brave and strong enough to travel to the Night Elven town and fill the Vial with healing water of their Fountain of Restoration.",false)
        call Text_Say(gg_unit_H00T_0185,"And if you will be able to bring the Filled Vial to me I think I will be able to cure the boy. His parents offer to reward you greatly if by your efforts their son will be saved. What do you say?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I will do all I can though I can promise nothing.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Healing Waters|r")
    set udg_SideQuest[$F]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Healing Waters"),"Zalmo, High Priest from Kalm, asked you to fill the vial with the waters of Fountain of Restoration and bring it back to him to cure the ill boy.","ReplaceableTextures\\CommandButtons\\BTNFountainOfLife.blp") // $F = 15
    set udg_QuestItem[18]=UnitAddItemByIdSwapped('bzbe',Player_GetHero(GetTriggerPlayer())) // 'bzbe': editor label "Empty Vial"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_SpecialEffect[34]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nvil_0186,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_HealingWaters_PingVial)
    call EnableTrigger(gg_trg_HealingWaters_DefiledVial)
    call EnableTrigger(gg_trg_HealingWaters_Cure)
    call EnableTrigger(gg_trg_HealingWaters_CureBlood)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HealingWaters_PingVial_Conditions takes nothing returns boolean
    return(udg_QuestItem[18]!=null)
endfunction

function Trig_HealingWaters_PingVial_Cond_VialFilled takes nothing returns boolean
    return(GetItemTypeId(udg_QuestItem[18])!='bzbe') // 'bzbe': editor label "Empty Vial"
endfunction

function Trig_HealingWaters_PingVial_Cond_VialCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[18]))
endfunction

function Trig_HealingWaters_PingVial_Actions takes nothing returns nothing
    if(Trig_HealingWaters_PingVial_Cond_VialCarried())then
        if(Trig_HealingWaters_PingVial_Cond_VialFilled())then
            set udg_TempPoint=GetUnitLoc(gg_unit_H00T_0185)
            call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
            call RemoveLocation(udg_TempPoint)
        endif
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[18])
        call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
        call RemoveLocation(udg_TempPoint)
    endif
endfunction

function Trig_HealingWaters_DefiledVial_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0JL'))and(IsUnitHiddenBJ(gg_unit_H00T_0185)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0JL': item "Filled Vial"
endfunction

function Trig_HealingWaters_DefiledVial_Cond_ShowRejectTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HealingWaters_DefiledVial_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_HealingWaters_DefiledVial_Cond_ShowRejectTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H00T_0185,0)
        call Text_Say(gg_unit_H00T_0185,"Welcome back. Have you brought the vial filled with healing waters of Fountain of Restoration?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yes, I have it right here.",false)
        call Text_Say(gg_unit_H00T_0185,"That's great. Now if you please give it to me I shall...",false)
        call Text_Say(gg_unit_H00T_0185,"Wait that vial you're holding, that's not filled with restoring waters at all. What happened?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well it seems the Fountain of Restoration was defiled by evil influence. This is all that's left of it.",false)
        call Text_Say(gg_unit_H00T_0185,"That is harrowing news. But what were you trying to accomplish by bringing this foul liquid? Are you trying to get this child killed?",false)
        call Text_Say(gg_unit_H00T_0185,"Perhaps there is still a way to restore the fountain's healing powers. Empty this vial back out and make haste. Remember, this child's life is on the line.",false)
        call Cine_ExitAction()
    endif
    set udg_QuestItem[18]=UnitAddItemByIdSwapped('bzbe',GetTriggerUnit()) // 'bzbe': editor label "Empty Vial"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0JL')) // 'I0JL': item "Filled Vial"
    call UnitAddItemSwapped(udg_QuestItem[18],GetTriggerUnit())
endfunction

function Trig_HealingWaters_Cure_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'bzbf'))and(IsUnitHiddenBJ(gg_unit_H00T_0185)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'bzbf': item "Filled Vial"
endfunction

function Trig_HealingWaters_Cure_Cond_ShowCureScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HealingWaters_Cure_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_HealingWaters_PingVial)
    call DisableTrigger(gg_trg_HealingWaters_CureBlood)
    call DisableTrigger(gg_trg_HealingWaters_DefiledVial)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bzbf')) // 'bzbf': item "Filled Vial"
    call DestroyEffectBJ(udg_SpecialEffect[34])
    if(Trig_HealingWaters_Cure_Cond_ShowCureScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H00T_0185,0)
        call Text_Say(gg_unit_H00T_0185,"Welcome back. Have you brought the vial filled with healing waters of Fountain of Restoration?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yes, I have it right here.",false)
        call Text_Say(gg_unit_H00T_0185,"That's great. Now if you please give it to me I shall immediately start the conjuration process . . .",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_H00T_0185,gg_unit_nvlk_0184,.5)
        call SetUnitAnimation(gg_unit_H00T_0185,"spell")
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Heal\\HealTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call SetUnitAnimation(gg_unit_H00T_0185,"spell")
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ResetUnitAnimation(gg_unit_H00T_0185)
        call Wait_Polled(2)
        call DestroyEffectBJ(udg_SpecialEffect[35])
        call SetUnitVertexColorBJ(gg_unit_nvlk_0184,100.,'d',100.,0)
        call SetUnitAnimation(gg_unit_nvlk_0184,"stand")
        call SetUnitFacingToFaceUnitTimed(gg_unit_nvlk_0184,gg_unit_nvlw_0183,.5)
        call Text_Transmission(gg_unit_nvlk_0184,"Danny","Mommy?..","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvlw_0183,"Danny's Mother","Oh, Danny! You're okay! I am so happy !!!","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvil_0186,"Danny's Father","Danny, my son, I am so glad you are well.","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvlk_0184,"Danny","I feel much better now...","(null)",null,0,false)
        call Text_Say(gg_unit_H00T_0185,"He is still a bit weak but if you take good care of him he will soon recover completely.",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_H00T_0185,GetTriggerUnit(),.3)
        call Text_Transmission(gg_unit_nvil_0186,"Danny's Father","I am very grateful for what you've done. Please take this reward.","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvil_0186,"Danny's Father","|n|cffffcc00All players get 4000 gold and 500 exp.|r","(null)",null,0,true)
        call Reward_Give($FA0,500,null) // $FA0 = 4000
        call Cine_ExitAction()
    else
        call DestroyEffectBJ(udg_SpecialEffect[35])
        call SetUnitVertexColorBJ(gg_unit_nvlk_0184,100.,'d',100.,0)
        call SetUnitAnimation(gg_unit_nvlk_0184,"stand")
        call SetUnitFacingToFaceUnitTimed(gg_unit_nvlk_0184,gg_unit_nvlw_0183,.5)
        call Reward_Give($FA0,500,gg_unit_H00T_0185) // $FA0 = 4000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Healing Waters|r")
    call QuestSetCompletedBJ(udg_SideQuest[$F],true) // $F = 15
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HealingWaters_CureBlood_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0JM'))and(IsUnitHiddenBJ(gg_unit_H00T_0185)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0JM': item "Filled Vial"
endfunction

function Trig_HealingWaters_CureBlood_Cond_ShowBloodCureScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HealingWaters_CureBlood_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_HealingWaters_PingVial)
    call DisableTrigger(gg_trg_HealingWaters_Cure)
    call DisableTrigger(gg_trg_HealingWaters_DefiledVial)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0JM')) // 'I0JM': item "Filled Vial"
    call DestroyEffectBJ(udg_SpecialEffect[34])
    if(Trig_HealingWaters_CureBlood_Cond_ShowBloodCureScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_H00T_0185,0)
        call Text_Say(gg_unit_H00T_0185,"Welcome back. Have you brought the vial filled with healing waters of Fountain of Restoration?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yes, I have it right here.",false)
        call Text_Say(gg_unit_H00T_0185,"That's great. I don't remember the liquid being this red, but it is practically overflowing with restorative powers. Now if you please give it to me I shall immediately start the conjuration process . . .",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_H00T_0185,gg_unit_nvlk_0184,.5)
        call SetUnitAnimation(gg_unit_H00T_0185,"spell")
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,50.)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Heal\\HealTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call SetUnitAnimation(gg_unit_H00T_0185,"spell")
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        set udg_TempPoint=GetUnitLoc(gg_unit_nvlk_0184)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ResetUnitAnimation(gg_unit_H00T_0185)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",100.,0,0,50.)
        call Wait_Polled(2)
        call DestroyEffectBJ(udg_SpecialEffect[35])
        call SetUnitVertexColorBJ(gg_unit_nvlk_0184,100.,'d',100.,0)
        call SetUnitAnimation(gg_unit_nvlk_0184,"stand")
        call SetUnitFacingToFaceUnitTimed(gg_unit_nvlk_0184,gg_unit_nvlw_0183,.5)
        call Text_Transmission(gg_unit_nvlk_0184,"Danny","Mommy?..","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvlw_0183,"Danny's Mother","Oh, Danny! You're okay! I am so happy !!!","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvil_0186,"Danny's Father","Danny, my son, I am so glad you are well.","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvlk_0184,"Danny","I feel better than ever!","(null)",null,0,false)
        call Text_Say(gg_unit_H00T_0185,"This is incredible! Not only is he completely cured, he seems much healthier than ever before.",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_H00T_0185,GetTriggerUnit(),.3)
        call Text_Transmission(gg_unit_nvil_0186,"Danny's Father","You've really gone above and beyond for our son. Please take this reward.","(null)",null,0,false)
        call Text_Transmission(gg_unit_nvil_0186,"Danny's Father","|n|cffffcc00All players get 8000 gold and 4000 exp.|r","(null)",null,0,true)
        call Reward_Give(8000,$FA0,null) // $FA0 = 4000
        call Cine_ExitAction()
    else
        call DestroyEffectBJ(udg_SpecialEffect[35])
        call SetUnitVertexColorBJ(gg_unit_nvlk_0184,100.,'d',100.,0)
        call SetUnitAnimation(gg_unit_nvlk_0184,"stand")
        call SetUnitFacingToFaceUnitTimed(gg_unit_nvlk_0184,gg_unit_nvlw_0183,.5)
        call Reward_Give(8000,$FA0,gg_unit_H00T_0185) // $FA0 = 4000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Healing Waters|r")
    call QuestSetCompletedBJ(udg_SideQuest[$F],true) // $F = 15
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_HealingWaters takes nothing returns nothing
endfunction
function RegisterR11_HealingWaters_HideFamily takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_HideFamily=CreateTrigger()
    call TriggerAddAction(gg_trg_HealingWaters_HideFamily,function Trig_HealingWaters_HideFamily_Actions)
endfunction
function RegisterR11_HealingWaters_Prepare takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_HealingWaters_Prepare)
    call TriggerAddAction(gg_trg_HealingWaters_Prepare,function Trig_HealingWaters_Prepare_Actions)
endfunction
function RegisterR11_HealingWaters_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_Start=CreateTrigger()
    call DisableTrigger(gg_trg_HealingWaters_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HealingWaters_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_HealingWaters_Start,Condition(function Trig_HealingWaters_Start_Conditions))
    call TriggerAddAction(gg_trg_HealingWaters_Start,function Trig_HealingWaters_Start_Actions)
endfunction
function RegisterR11_HealingWaters_PingVial takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_PingVial=CreateTrigger()
    call DisableTrigger(gg_trg_HealingWaters_PingVial)
    call TriggerRegisterTimerEventPeriodic(gg_trg_HealingWaters_PingVial,15.)
    call TriggerAddCondition(gg_trg_HealingWaters_PingVial,Condition(function Trig_HealingWaters_PingVial_Conditions))
    call TriggerAddAction(gg_trg_HealingWaters_PingVial,function Trig_HealingWaters_PingVial_Actions)
endfunction
function RegisterR11_HealingWaters_DefiledVial takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_DefiledVial=CreateTrigger()
    call DisableTrigger(gg_trg_HealingWaters_DefiledVial)
    call TriggerRegisterUnitInRangeSimple(gg_trg_HealingWaters_DefiledVial,450.,gg_unit_H00T_0185)
    call TriggerAddCondition(gg_trg_HealingWaters_DefiledVial,Condition(function Trig_HealingWaters_DefiledVial_Conditions))
    call TriggerAddAction(gg_trg_HealingWaters_DefiledVial,function Trig_HealingWaters_DefiledVial_Actions)
endfunction
function RegisterR11_HealingWaters_Cure takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_Cure=CreateTrigger()
    call DisableTrigger(gg_trg_HealingWaters_Cure)
    call TriggerRegisterUnitInRangeSimple(gg_trg_HealingWaters_Cure,450.,gg_unit_H00T_0185)
    call TriggerAddCondition(gg_trg_HealingWaters_Cure,Condition(function Trig_HealingWaters_Cure_Conditions))
    call TriggerAddAction(gg_trg_HealingWaters_Cure,function Trig_HealingWaters_Cure_Actions)
endfunction
function RegisterR11_HealingWaters_CureBlood takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_HealingWaters_CureBlood=CreateTrigger()
    call DisableTrigger(gg_trg_HealingWaters_CureBlood)
    call TriggerRegisterUnitInRangeSimple(gg_trg_HealingWaters_CureBlood,450.,gg_unit_H00T_0185)
    call TriggerAddCondition(gg_trg_HealingWaters_CureBlood,Condition(function Trig_HealingWaters_CureBlood_Conditions))
    call TriggerAddAction(gg_trg_HealingWaters_CureBlood,function Trig_HealingWaters_CureBlood_Actions)
endfunction




endlibrary

library TDana requires TCam, TCine, TMusic, TPlayerPart01, TText, TUnit, TWait
function Trig_Dana_Prepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Dana_Talk1)
    set udg_DanaQuestStage=0
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Dana_Talk1_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0BN_0171,true,true,true))
endfunction

function Trig_Dana_Talk1_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Dana_Talk1_Quest20Completed takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[20]))
endfunction

function Trig_Dana_Talk1_VillageStage4 takes nothing returns boolean
    return(udg_ZodiacQuestStage==4)
endfunction

function Trig_Dana_Talk1_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[70])
    if(Trig_Dana_Talk1_CinematicsEnabled())then
        call PauseUnitBJ(true,gg_unit_n0BN_0171)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Huh...? Who are you?",false)
        call Text_Say(gg_unit_n0BN_0171,"So you can perceive us now. Greetings, adventurers, my name is Dana.",false)
        call Text_Say(gg_unit_n0BN_0171,"I understand that you are likely perplexed at seeing me. It is the Maiden's Eye you hold that allows you to perceive those of the Phantom Village.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Phantom Village...? Who are you people?",false)
        call Text_Say(gg_unit_n0BN_0171,"We have been hidden in the shades of these waters for a long time. As for why... I'd like it if you figured it out yourself. You possess the Maiden's Eye, so you can speak to anyone in our village.",false)
        call Text_Say(gg_unit_n0BN_0171,"They are not used to outsiders, so I will tell them that you are my rare guest. WIth my word they won't be distrusting of you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm... I see. But if you have been hidden for this long, why welcome us as guests?",false)
        call Text_Say(gg_unit_n0BN_0171,"I have my reasons. We will speak again about this later. For now, please do talk with others in this village.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_n0BN_0171)
    endif
    set udg_DanaQuestStage=1
    call ConditionalTriggerExecute(gg_trg_TargetPractice_Init)
    call ConditionalTriggerExecute(gg_trg_Olga_ShowTalkIcon)
    call ConditionalTriggerExecute(gg_trg_Sarai_ShowTalkIcon)
    call ConditionalTriggerExecute(gg_trg_Kiemarl_ShowTalkIcon)
    call EnableTrigger(gg_trg_Dana_Talk2_Enable)
    call Music_SetZoneTrack(20)
    set udg_QuestMarkerEffect[25]=AddSpecialEffectTargetUnitBJ("head",gg_unit_e019_0228,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Sigroon)
    if(Trig_Dana_Talk1_VillageStage4())then
        call Wait_Polled(2)
        set udg_DanaQuestStage=2
        set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call GroupAddUnitSimple(gg_unit_n0BN_0171,udg_QuestUnits)
        call EnableTrigger(gg_trg_Quest_ZodiacAge_GetPendant)
    else
        if(Trig_Dana_Talk1_Quest20Completed())then
            call Wait_Polled(2)
            set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
            call EnableTrigger(gg_trg_Epilogue_Dana)
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Dana_Talk2_Enable_Conditions takes nothing returns boolean
    return(udg_DanaQuestStage!=2)and(udg_PhantomVillagersMet>=2)
endfunction

function Trig_Dana_Talk2_Enable_Quest20NotFound takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Dana_Talk2_Enable_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Dana_Talk2_Enable_Quest20NotFound())then
        set udg_SpecialEffect[70]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0BN_0171,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_Illusions_Start)
        // Increase udg_DanaQuestStage by 3.
        set udg_DanaQuestStage=(udg_DanaQuestStage+3)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Dana_Receive_Eye_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n0BN_0171)
endfunction

function Trig_Dana_Receive_Eye_IsMaidensEye takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0HS') // 'I0HS': item "Maiden's Eye"
endfunction

function Trig_Dana_Receive_Eye_Actions takes nothing returns nothing
    if(Trig_Dana_Receive_Eye_IsMaidensEye())then
        call DisableTrigger(GetTriggeringTrigger())
        call RemoveItem(GetManipulatedItem())
        call SetUnitOwner(gg_unit_n0BN_0171,Player(8),false)
        call UnitRemoveAbilityBJ('Apiv',GetTriggerUnit()) // 'Apiv': object name not found in map data
        call UnitRemoveAbilityBJ('AInv',GetTriggerUnit()) // 'AInv': standard ability reference "Inventory"
        call SetUnitInvulnerable(GetTriggerUnit(),false)
        call EnableTrigger(gg_trg_Dana_Death)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-64.,0)
        call RemoveLocation(udg_TempPoint)
        call UnitRemoveItemSwapped(GetManipulatedItem(),gg_unit_n0BN_0171)
        call SetItemPositionLoc(GetManipulatedItem(),udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
    endif
endfunction

function Trig_Dana_Death_Quest14Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[$E])) // $E = 14
endfunction

function Trig_Dana_Death_Quest14NotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])==false) // $E = 14
endfunction

function Trig_Dana_Death_Quest55Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[55]))
endfunction

function Trig_Dana_Death_Quest55NotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[55])==false)
endfunction

function Trig_Dana_Death_Quest58Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[58]))
endfunction

function Trig_Dana_Death_Quest58NotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[58])==false)
endfunction

function Trig_Dana_Death_Quest59Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[59]))
endfunction

function Trig_Dana_Death_Quest59NotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[59])==false)
endfunction

function Trig_Dana_Death_StageFive takes nothing returns boolean
    return(udg_DanaQuestStage==5)
endfunction

function Trig_Dana_Death_ShakeCamera takes nothing returns nothing
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),15.)
endfunction

function Trig_Dana_Death_StopShake takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_Dana_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[70])
    if(Trig_Dana_Death_Quest14NotDone())then
        set udg_QuestsTotal=(udg_QuestsTotal-1)
        if(Trig_Dana_Death_Quest14Discovered())then
            call ConditionalTriggerExecute(gg_trg_TargetPractice_Fail)
        endif
    endif
    if(Trig_Dana_Death_Quest55NotDone())then
        set udg_QuestsTotal=(udg_QuestsTotal-1)
        if(Trig_Dana_Death_Quest55Discovered())then
            call ConditionalTriggerExecute(gg_trg_FlanHunt_Fail)
        endif
    endif
    if(Trig_Dana_Death_Quest58NotDone())then
        set udg_QuestsTotal=(udg_QuestsTotal-1)
        if(Trig_Dana_Death_Quest58Discovered())then
            call ConditionalTriggerExecute(gg_trg_Tentacles_Fail)
        else
            set udg_QuestsTotal=(udg_QuestsTotal-1)
        endif
    endif
    if(Trig_Dana_Death_Quest59NotDone())then
        set udg_QuestsTotal=(udg_QuestsTotal-1)
        if(Trig_Dana_Death_Quest59Discovered())then
            call ConditionalTriggerExecute(gg_trg_DragonEgg_Fail)
        endif
    endif
    call ShowUnitShow(gg_unit_U00N_0205)
    call PauseUnitBJ(false,gg_unit_U00N_0205)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call IssuePointOrderLocBJ(gg_unit_U00N_0205,"attack",udg_TempPoint)
    call GroupAddUnitSimple(gg_unit_U00N_0205,udg_BossUnits)
    if(Trig_Dana_Death_StageFive())then
        set udg_QuestItem[$E]=CreateItemLoc('I0I9',udg_TempPoint) // $E = 14; 'I0I9': item "Shimmering Pendant"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    endif
    call RemoveLocation(udg_TempPoint)
    call EnableTrigger(gg_trg_Famfrit_Encounter)
    call ForForce(GetPlayersAll(),function Trig_Dana_Death_ShakeCamera)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,100.,0)
    call Wait_Polled(2.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,100.,0)
    call Wait_Polled(2.)
    call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,2.,"ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp",.0,.0,100.,0)
    call ForForce(GetPlayersAll(),function Trig_Dana_Death_StopShake)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Dana takes nothing returns nothing
endfunction

function RegisterR11_Dana_Prepare takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Dana_Prepare=CreateTrigger()

call DisableTrigger(gg_trg_Dana_Prepare)

call TriggerAddAction(gg_trg_Dana_Prepare,function Trig_Dana_Prepare_Actions)

endfunction




function RegisterR11_Dana_Talk1 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Dana_Talk1=CreateTrigger()

call DisableTrigger(gg_trg_Dana_Talk1)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Dana_Talk1,Player(7),true)

call TriggerAddCondition(gg_trg_Dana_Talk1,Condition(function Trig_Dana_Talk1_Conditions))

call TriggerAddAction(gg_trg_Dana_Talk1,function Trig_Dana_Talk1_Actions)

endfunction




function RegisterR11_Dana_Talk2_Enable takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Dana_Talk2_Enable=CreateTrigger()

call DisableTrigger(gg_trg_Dana_Talk2_Enable)

call TriggerRegisterTimerEventPeriodic(gg_trg_Dana_Talk2_Enable,5.)

call TriggerAddCondition(gg_trg_Dana_Talk2_Enable,Condition(function Trig_Dana_Talk2_Enable_Conditions))

call TriggerAddAction(gg_trg_Dana_Talk2_Enable,function Trig_Dana_Talk2_Enable_Actions)

endfunction




function RegisterR11_Dana_Receive_Eye takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Dana_Receive_Eye=CreateTrigger()

call DisableTrigger(gg_trg_Dana_Receive_Eye)

call TriggerRegisterPlayerUnitEventSimple(gg_trg_Dana_Receive_Eye,Player(9),EVENT_PLAYER_UNIT_PICKUP_ITEM)

call TriggerAddCondition(gg_trg_Dana_Receive_Eye,Condition(function Trig_Dana_Receive_Eye_Conditions))

call TriggerAddAction(gg_trg_Dana_Receive_Eye,function Trig_Dana_Receive_Eye_Actions)

endfunction




function RegisterR11_Dana_Death takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Dana_Death=CreateTrigger()

call DisableTrigger(gg_trg_Dana_Death)

call TriggerRegisterUnitEvent(gg_trg_Dana_Death,gg_unit_n0BN_0171,EVENT_UNIT_DEATH)

call TriggerAddAction(gg_trg_Dana_Death,function Trig_Dana_Death_Actions)

endfunction




endlibrary

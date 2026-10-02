library THauntedTree requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HauntedTree_Init=null
    trigger gg_trg_HauntedTree_Prepare=null
    trigger gg_trg_HauntedTree_Start=null
    trigger gg_trg_HauntedTree_GhostRoam=null
    trigger gg_trg_HauntedTree_CaptureSpirit=null
    trigger gg_trg_HauntedTree_Complete=null
endglobals

function Trig_HauntedTree_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n02F_0108)
    call SetDestructableInvulnerableBJ(gg_dest_B002_0040,true)
    call SetDestructableInvulnerableBJ(gg_dest_B002_0026,true)
    call SetDestructableInvulnerableBJ(gg_dest_LTbx_0038,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HauntedTree_Prepare_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_n02F_0108)
    set udg_SpecialEffect[61]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n02F_0108,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_HauntedTree_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HauntedTree_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n02F_0108,true,true,true))
endfunction

function Trig_HauntedTree_Start_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HauntedTree_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[61])
    if(Trig_HauntedTree_Start_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n02F_0108,"Hello again. Thanks for saving me from those brutes.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good to see you're safe. Are you alright?",false)
        call Text_Say(gg_unit_n02F_0108,"I'm fine yeah. But it's so frustrating! We didn't use to be so divided in this realm. It all started going awry when the Holy Tree got haunted by some evil ghost.",false)
        call Text_Say(gg_unit_n02F_0108,"I'm talking about the tree in the northwest of this region. Even though this realm is pure ice, that one tree is unaffected and grows normally.",false)
        call Text_Say(gg_unit_n02F_0108,"But now there's a ghost haunting it! I don't know how this happened but ever since then everything's been strange. We of the Icy Realm isolated ourselves from the rest of the world and it's been all tense since.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A ghost is haunting a tree...? That sounds pretty absurd. But sounds like it's having some negative effects on this land.",false)
        call Text_Say(gg_unit_n02F_0108,"Please, I don't know how it's at all possible but if you can find a way to exorcise the spirit I'll give you a reward.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Haunted Tree|r")
    set udg_SideQuest[39]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Haunted Tree"),"Oaka IV asked you to inspect the non-snowy tree in the area and find a way to exorcise the spirit haunting it.","ReplaceableTextures\\WorldEditUI\\Doodad-Destructible.blp")
    set udg_SpecialEffect[61]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n02F_0108,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_HauntedTree_CaptureSpirit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HauntedTree_GhostRoam_Actions takes nothing returns nothing
    set udg_TempPoint=GetRandomLocInRect(gg_rct_366)
    call IssuePointOrderLocBJ(gg_unit_u017_0107,"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_HauntedTree_CaptureSpirit_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0I9'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0I9': item "Shimmering Pendant"
endfunction

function Trig_HauntedTree_CaptureSpirit_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_HauntedTree_GhostRoam)
    call DestroyTrigger(gg_trg_HauntedTree_GhostRoam)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0I9')) // 'I0I9': item "Shimmering Pendant"
    call UnitAddItemByIdSwapped('I08S',GetTriggerUnit()) // 'I08S': item "Spirit Pendant"
    call KillUnit(gg_unit_u017_0107)
    call AddSpecialEffectTargetUnitBJ("chest",GetTriggerUnit(),"Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call DisplayTimedTextToForce(GetPlayersAll(),30,(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" captured the spirit haunting the tree with the Shimmering Pendant."))
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Report back to Oaka IV.")
    call QuestSetDescriptionBJ(udg_SideQuest[39],"Report back to Oaka IV.")
    call GroupAddUnitSimple(gg_unit_n02F_0108,udg_BossUnits)
    call EnableTrigger(gg_trg_HauntedTree_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_HauntedTree_Complete_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_HauntedTree_Complete_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_HauntedTree_Complete_Cond_AnyTreeAlive takes nothing returns boolean
    return(IsDestructableAliveBJ(gg_dest_B002_0040))or(IsDestructableAliveBJ(gg_dest_B002_0026))
endfunction

function Trig_HauntedTree_Complete_Cond_NorthTreeAlive takes nothing returns boolean
    return(IsDestructableAliveBJ(gg_dest_B002_0040))
endfunction

function Trig_HauntedTree_Complete_Cond_SouthTreeAlive takes nothing returns boolean
    return(IsDestructableAliveBJ(gg_dest_B002_0026))
endfunction

function Trig_HauntedTree_Complete_Cond_CanCutTrees takes nothing returns boolean
    return(Trig_HauntedTree_Complete_Cond_AnyTreeAlive())
endfunction

function Trig_HauntedTree_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[61])
    call GroupRemoveUnitSimple(gg_unit_n02F_0108,udg_BossUnits)
    if(Trig_HauntedTree_Complete_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n02F_0108,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We've managed to exorcise the spirit from the tree. It should be back to how you like it now.",false)
        call Text_Say(gg_unit_n02F_0108,"Oh, thank you, you've really helped me.",false)
        call Text_Say(gg_unit_n02F_0108,"To show you my gratitude, I will cut down some trees in this area for you.",false)
        call Text_Say(gg_unit_n02F_0108,"Tell me whether you want the trees in the north or in the south cut for you.",false)
        call Reward_Give($BB8,$9C4,gg_unit_n02F_0108) // $BB8 = 3000; $9C4 = 2500
        call Cine_ExitAction()
    else
        call Reward_Give($BB8,$9C4,gg_unit_n02F_0108) // $BB8 = 3000; $9C4 = 2500
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Haunted Tree|r")
    call QuestSetCompletedBJ(udg_SideQuest[39],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    if(Trig_HauntedTree_Complete_Cond_CanCutTrees())then
        call UnitAddAbilityBJ('Aeth',gg_unit_n02F_0108) // 'Aeth': object name not found in map data
        call EnableTrigger(gg_trg_OakaIV_CutTrees)
        if(Trig_HauntedTree_Complete_Cond_NorthTreeAlive())then
            call UnitAddAbilityBJ('A0GE',gg_unit_n02F_0108) // 'A0GE': ability "Cut North"
        endif
        if(Trig_HauntedTree_Complete_Cond_SouthTreeAlive())then
            call UnitAddAbilityBJ('A0GF',gg_unit_n02F_0108) // 'A0GF': ability "Cut South"
        endif
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_HauntedTree automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_HauntedTree (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_HauntedTree takes nothing returns nothing
endfunction

function Register_HauntedTree_Init takes nothing returns nothing
    set gg_trg_HauntedTree_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_HauntedTree_Init,function Trig_HauntedTree_Init_Actions)
endfunction

function Register_HauntedTree_Prepare takes nothing returns nothing
    set gg_trg_HauntedTree_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_HauntedTree_Prepare)
    call TriggerAddAction(gg_trg_HauntedTree_Prepare,function Trig_HauntedTree_Prepare_Actions)
endfunction

function Register_HauntedTree_Start takes nothing returns nothing
    set gg_trg_HauntedTree_Start=CreateTrigger()
    call DisableTrigger(gg_trg_HauntedTree_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_HauntedTree_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_HauntedTree_Start,Condition(function Trig_HauntedTree_Start_Conditions))
    call TriggerAddAction(gg_trg_HauntedTree_Start,function Trig_HauntedTree_Start_Actions)
endfunction

function Register_HauntedTree_GhostRoam takes nothing returns nothing
    set gg_trg_HauntedTree_GhostRoam=CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_HauntedTree_GhostRoam,4.)
    call TriggerAddAction(gg_trg_HauntedTree_GhostRoam,function Trig_HauntedTree_GhostRoam_Actions)
endfunction

function Register_HauntedTree_CaptureSpirit takes nothing returns nothing
    set gg_trg_HauntedTree_CaptureSpirit=CreateTrigger()
    call DisableTrigger(gg_trg_HauntedTree_CaptureSpirit)
    call TriggerRegisterEnterRectSimple(gg_trg_HauntedTree_CaptureSpirit,gg_rct_366)
    call TriggerAddCondition(gg_trg_HauntedTree_CaptureSpirit,Condition(function Trig_HauntedTree_CaptureSpirit_Conditions))
    call TriggerAddAction(gg_trg_HauntedTree_CaptureSpirit,function Trig_HauntedTree_CaptureSpirit_Actions)
endfunction

function Register_HauntedTree_Complete takes nothing returns nothing
    set gg_trg_HauntedTree_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_HauntedTree_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_HauntedTree_Complete,450.,gg_unit_n02F_0108)
    call TriggerAddCondition(gg_trg_HauntedTree_Complete,Condition(function Trig_HauntedTree_Complete_Conditions))
    call TriggerAddAction(gg_trg_HauntedTree_Complete,function Trig_HauntedTree_Complete_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HauntedTree takes nothing returns nothing
    call Register_HauntedTree_Init()
    call Register_HauntedTree_Prepare()
    call Register_HauntedTree_Start()
    call Register_HauntedTree_GhostRoam()
    call Register_HauntedTree_CaptureSpirit()
    call Register_HauntedTree_Complete()
endfunction

endlibrary

library TDimensionalBoundary requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait, TZeromus
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DimensionalBoundary_Init=null
    trigger gg_trg_DimensionalBoundary_Start=null
    trigger gg_trg_DimensionalBoundary_OpenPortal=null
    trigger gg_trg_DimensionalBoundary_EmptyEnd=null
endglobals

function Trig_DimensionalBoundary_Init_Actions takes nothing returns nothing
    set udg_QuFrogLoc=GetUnitLoc(gg_unit_n03A_0136)
    set udg_QuFrogDrainCount=0
    set udg_ShinraFinaleArmed=false
    call ShowUnitHide(gg_unit_n03A_0136)
    call ShowUnitHide(gg_unit_n039_0083)
    call ShowUnitHide(gg_unit_n039_0095)
    call ShowUnitHide(gg_unit_n039_0175)
    call ShowUnitHide(gg_unit_n021_0126)
    call ShowUnitHide(gg_unit_n02H_0116)
    call ShowUnitHide(gg_unit_U00J_0209)
    call PauseUnitBJ(true,gg_unit_U00J_0209)
    call SetUnitInvulnerable(gg_unit_U00J_0209,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DimensionalBoundary_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n034_0109,true,true,true))
endfunction

function Trig_DimensionalBoundary_Start_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DimensionalBoundary_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[62])
    if(Trig_DimensionalBoundary_Start_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n034_0109,"Hello. Are you the adventurers I've heard so much about?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes. What do you need?",false)
        call Text_Say(gg_unit_n034_0109,"You've come from outside Gaya have you not? I've been fascinated with the outside of this world for a while now. And I think you more than anyone have a chance at helping me figure out a way to open up the world's boundaries.",false)
        call Text_Say(gg_unit_n034_0109,"Doing so would allow us to travel more freely between this world and others, and allow us to explore and get to know other worlds. Sounds good doesn't it?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're a highly curious child aren't you? But how are you planning on opening up the world's boundaries?",false)
        call Text_Say(gg_unit_n034_0109,"To be honest, I don't know. But I know where I can find out.",false)
        call Text_Say(gg_unit_n034_0109,"Somewhere on Gaya, there should be a sunken ship containing a book. The Guide Book, written by a pirate.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"A pirate!? How's a pirate's notes supposed to help?",false)
        call Text_Say(gg_unit_n034_0109,"The pirate in question was a highly curious fellow who sailed the seas in order to find out as much about the world as possible. He was in touch with the Seekers order and the Night Elves to the south as well. Unfortunately he and his records sank with his ship and he lost his life. But I know he was using a special waterproof book for his records.",false)
        call Text_Say(gg_unit_n034_0109,"If there's anyone who knows anything about the boundary in this world surely his records are the first place to look.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Fine. Do you know where his ship sank?",false)
        call Text_Say(gg_unit_n034_0109,"Unfortunately no. But how many sunken ships can there possibly be? Just be on the lookout for them and you'll find it soon I'm sure.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're a cheeky kid aren't you. I hope you don't expect us to do this for free.",false)
        call Text_Say(gg_unit_n034_0109,"Of course not.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then. We'll dig up that guide book for you.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Dimensional Boundary|r")
    set udg_SideQuest[40]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"Dimensional Boundary"),"Shinra, an Al Bhed child, has taken an interest in opening the world's boundaries. The first thing he needs for this purpose is the Guide Book. Search for it in sunken ships!","ReplaceableTextures\\CommandButtons\\BTNPortal.blp")
    call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    call RemoveItemFromStockBJ('I08Q',gg_unit_n02Y_0052) // 'I08Q': item "Information: Al Bhed Child"
    set udg_SpecialEffect[62]=GetLastCreatedEffectBJ()
    call EnableTrigger(gg_trg_GuideBook_Search1)
    call EnableTrigger(gg_trg_GuideBook_Search2)
    call EnableTrigger(gg_trg_GuideBook_Search3)
    call EnableTrigger(gg_trg_GuideBook_Search4)
    call EnableTrigger(gg_trg_GuideBook_Search5)
    call EnableTrigger(gg_trg_GuideBook_Search6)
    call EnableTrigger(gg_trg_GuideBook_TurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DimensionalBoundary_OpenPortal_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n034_0109,true,true,true))
endfunction

function Trig_DimensionalBoundary_OpenPortal_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DimensionalBoundary_OpenPortal_Cond_ZeromusAbsent takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_DimensionalBoundary_OpenPortal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[62])
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_DimensionalBoundary_OpenPortal_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n034_0109,"Alright, I'm starting.",false)
        call ShowUnitShow(gg_unit_n021_0126)
        call ShowUnitShow(gg_unit_n02H_0116)
        call SetUnitAnimation(gg_unit_n021_0126,"birth")
        call Wait_Polled(9.3)
        call ResetUnitAnimation(gg_unit_n021_0126)
        call Text_Say(gg_unit_n034_0109,"There we go. This portal should take you right to the world's border.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What awaits us there?",false)
        call Text_Say(gg_unit_n034_0109,"I don't know. Remember, the pirate never made it there either. Nobody's ever been there.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see... so this may be a dangerous place.",false)
        call Text_Say(gg_unit_n034_0109,"Well, what are you waiting for?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Cheeky kid. Fine, we'll investigate it.",false)
        call Cine_ExitAction()
    else
        call ShowUnitShow(gg_unit_n021_0126)
        call ShowUnitShow(gg_unit_n02H_0116)
    endif
    call WaygateActivateBJ(true,gg_unit_n021_0126)
    call WaygateActivateBJ(true,gg_unit_n02H_0116)
    call WaygateSetDestinationLocBJ(gg_unit_n021_0126,GetRectCenter(gg_rct_372))
    call WaygateSetDestinationLocBJ(gg_unit_n02H_0116,GetRectCenter(gg_rct_371))
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Venture forth through the portal to investigate.")
    call QuestSetDescriptionBJ(udg_SideQuest[40],"Venture forth through the portal to investigate.")
    if(Trig_DimensionalBoundary_OpenPortal_Cond_ZeromusAbsent())then
        call EnableTrigger(gg_trg_DimensionalBoundary_EmptyEnd)
    else
        set udg_TempPoint=GetRectCenter(gg_rct_458)
        set udg_SpecialEffect[62]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
        call RemoveLocation(udg_TempPoint)
        call GroupAddUnitSimple(gg_unit_U00J_0209,udg_BossUnits)
        call EnableTrigger(gg_trg_Zeromus_Encounter)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_DimensionalBoundary_EmptyEnd_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DimensionalBoundary_EmptyEnd_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DimensionalBoundary_EmptyEnd_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DimensionalBoundary_EmptyEnd_Cond_ShowDialogue())then
        set udg_TempPoint=GetRectCenter(gg_rct_459)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        call SetUnitPositionLocFacingLocBJ(gg_unit_n034_0109,udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"There's nothing in here.",false)
        call Text_Say(gg_unit_n034_0109,"Hmm, I really expected there to be something or someone here...",false)
        call Text_Say(gg_unit_n034_0109,"Well I suppose not everything has to be perfectly as expected. Even so we still opened up the Dimensional Boundary.",false)
        call Text_Say(gg_unit_n034_0109,"A job well done is a job well done. Here's your reward!",false)
        call Reward_Give(7500,7500,gg_unit_n034_0109)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's that I guess.",false)
        call Text_Say(gg_unit_n034_0109,"Well, I'll return to Kalm now.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(7500,7500,gg_unit_n034_0109)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Dimensional Boundary|r")
    call QuestSetCompletedBJ(udg_SideQuest[40],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_TempPoint=GetRectCenter(gg_rct_421)
    call SetUnitPositionLocFacingBJ(gg_unit_n034_0109,udg_TempPoint,90.)
    call RemoveLocation(udg_TempPoint)
    call Trig_Zeromus_Death_UpgradeSpawnPools()
    call ShowUnitShow(gg_unit_n0AX_0188)
    call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
    call ConditionalTriggerExecute(gg_trg_Frakir_NextMarker)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DimensionalBoundary automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DimensionalBoundary_Part1 / RegisterTriggers_DimensionalBoundary_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DimensionalBoundary takes nothing returns nothing
endfunction

function Register_DimensionalBoundary_Init takes nothing returns nothing
    set gg_trg_DimensionalBoundary_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_DimensionalBoundary_Init,function Trig_DimensionalBoundary_Init_Actions)
endfunction

function Register_DimensionalBoundary_Start takes nothing returns nothing
    set gg_trg_DimensionalBoundary_Start=CreateTrigger()
    call DisableTrigger(gg_trg_DimensionalBoundary_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_DimensionalBoundary_Start,Condition(function Trig_DimensionalBoundary_Start_Conditions))
    call TriggerAddAction(gg_trg_DimensionalBoundary_Start,function Trig_DimensionalBoundary_Start_Actions)
endfunction

function Register_DimensionalBoundary_OpenPortal takes nothing returns nothing
    set gg_trg_DimensionalBoundary_OpenPortal=CreateTrigger()
    call DisableTrigger(gg_trg_DimensionalBoundary_OpenPortal)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_DimensionalBoundary_OpenPortal,Player(7),true)
    call TriggerAddCondition(gg_trg_DimensionalBoundary_OpenPortal,Condition(function Trig_DimensionalBoundary_OpenPortal_Conditions))
    call TriggerAddAction(gg_trg_DimensionalBoundary_OpenPortal,function Trig_DimensionalBoundary_OpenPortal_Actions)
endfunction

function Register_DimensionalBoundary_EmptyEnd takes nothing returns nothing
    set gg_trg_DimensionalBoundary_EmptyEnd=CreateTrigger()
    call DisableTrigger(gg_trg_DimensionalBoundary_EmptyEnd)
    call TriggerRegisterEnterRectSimple(gg_trg_DimensionalBoundary_EmptyEnd,gg_rct_590)
    call TriggerAddCondition(gg_trg_DimensionalBoundary_EmptyEnd,Condition(function Trig_DimensionalBoundary_EmptyEnd_Conditions))
    call TriggerAddAction(gg_trg_DimensionalBoundary_EmptyEnd,function Trig_DimensionalBoundary_EmptyEnd_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_DimensionalBoundary_Part1 takes nothing returns nothing
    call Register_DimensionalBoundary_Init()
    call Register_DimensionalBoundary_Start()
    call Register_DimensionalBoundary_OpenPortal()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_DimensionalBoundary_Part2 takes nothing returns nothing
    call Register_DimensionalBoundary_EmptyEnd()
endfunction

endlibrary

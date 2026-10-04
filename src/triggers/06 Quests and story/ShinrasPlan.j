library TShinrasPlan requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
// Side quest "Shinra's Plan", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Shinra, an Al Bhed child, asks for Theurgic Water, a Unique Ice Shard and Aire Tam Enib Moc, then vanishes.
// All steps are custom and stay in this module's triggers (hand-ins within 250 of Shinra, a line that
// depends on Zeromus, Shinra vanishing mid-dialogue), so this module keeps its own markers.
// Made available when gg_trg_ShinrasPlan_Prepare runs (Talk, Zeromus, Epilogue, ...).
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_ShinrasPlan_Prepare=null
    trigger gg_trg_ShinrasPlan_Start=null
    trigger gg_trg_ShinrasPlan_WaterTurnIn=null
    trigger gg_trg_ShinrasPlan_ShardTurnIn=null
    trigger gg_trg_ShinrasPlan_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_SHINRAS_PLAN=0
endglobals

function ShinrasPlan_Define takes nothing returns nothing
    local integer q=Quest_Define("Shinra's Plan",QUEST_SIDE,42,"ReplaceableTextures\\CommandButtons\\BTNVillagerKid.blp")
    set QUEST_SHINRAS_PLAN=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Shinra (gg_trg_ShinrasPlan_Start)
    call Quest_Custom(q,"Shinra, an Al Bhed child from Spira, has asked you to find some |cffffcc00Theurgic Water|r. It is unknown what he needs it for.")
    // 2. Bring him Theurgic Water (gg_trg_ShinrasPlan_WaterTurnIn)
    call Quest_Custom(q,"Shinra, an Al Bhed child from Spira, has asked you to bring him a |cffffcc00Unique Ice Shard|r. It is unknown what he needs it for.")
    call Quest_Message(q,"Bring a Unique Ice Shard to Shinra.")
    // 3. Bring him a Unique Ice Shard (gg_trg_ShinrasPlan_ShardTurnIn)
    call Quest_Custom(q,"Shinra, an Al Bhed child from Spira, has asked you to bring him |cffffcc00Aire Tam Enib Moc|r. It is unknown what he needs it for.")
    call Quest_Message(q,"Bring an artifact called \"Aire Tam Enib Moc\" to Shinra.")
    // 4. Bring him Aire Tam Enib Moc (gg_trg_ShinrasPlan_Complete)
    call Quest_Custom(q,"")
endfunction

function Trig_ShinrasPlan_Prepare_Conditions takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[40]))and(IsQuestCompleted(udg_MainQuest[8]))
endfunction

// Shinra's Plan becomes available: the "!" over Shinra.
function Trig_ShinrasPlan_Prepare_Actions takes nothing returns nothing
    if QUEST_SHINRAS_PLAN==0 then
        call ShinrasPlan_Define()
    endif
    set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_ShinrasPlan_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ShinrasPlan_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n034_0109,true,true,true))
endfunction

function Trig_ShinrasPlan_Start_Cond_ZeromusAbsent takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_ShinrasPlan_Start_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero talks to Shinra.
function Trig_ShinrasPlan_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[62])
    if(Trig_ShinrasPlan_Start_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n034_0109,"Oh hey there.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hi, Shinra.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Say, are you sure we did the right thing the other day? We aren't going to be overrun by monsters now are we?",false)
        if(Trig_ShinrasPlan_Start_Cond_ZeromusAbsent())then
            call Text_Say(gg_unit_n034_0109,"Oh please. Those dimensional boundaries were a huge glaring security hole from the beginning, weren't they?",false)
        else
            call Text_Say(gg_unit_n034_0109,"Oh please. You beat that demon guarding the barrier didn't you? Doesn't that mean if you protect us, we'll have better protection than if that demon was still in charge?",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I suppose that's true.",false)
        call Text_Say(gg_unit_n034_0109,"On a different note, I have another favor to ask of you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What is it this time?",false)
        call Text_Say(gg_unit_n034_0109,"I wondered if you could, perchance, bring me some |cffffcc00Theurgic Water|r?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What do you need it for?",false)
        call Text_Say(gg_unit_n034_0109,"Nothing important, consider it a hobby of mine. I've got a good reward lined up for you if you help me though.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Deal.",false)
        call Cine_ExitAction()
    endif
    call Quest_Start(QUEST_SHINRAS_PLAN,GetTriggerPlayer(),GetTriggerUnit())
    set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_ShinrasPlan_WaterTurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ShinrasPlan_WaterTurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I06T'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I06T': item "Theurgic Water"
endfunction

function Trig_ShinrasPlan_WaterTurnIn_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06T'))>=2) // 'I06T': item "Theurgic Water"
endfunction

function Trig_ShinrasPlan_WaterTurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 2: a hero brings Theurgic Water.
function Trig_ShinrasPlan_WaterTurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ShinrasPlan_WaterTurnIn_Cond_ItemHasCharges())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06T'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06T'))-1)) // 'I06T': item "Theurgic Water"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06T')) // 'I06T': item "Theurgic Water"
    endif
    if(Trig_ShinrasPlan_WaterTurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[62])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(gg_unit_n034_0109,"Ah, I see you've brought me the Theurgic Water. Thanks a lot.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So, what do you need it for?",false)
        call Text_Say(gg_unit_n034_0109,"Now I'll need a |cffffcc00Unique Ice Shard|r. It is said to be one of the greatest miracles of Gaya.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Okay, I'll try to find one.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call Quest_StepDone(QUEST_SHINRAS_PLAN,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call EnableTrigger(gg_trg_ShinrasPlan_ShardTurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ShinrasPlan_ShardTurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I06X'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I06X': item "Unique Ice Shard"
endfunction

function Trig_ShinrasPlan_ShardTurnIn_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06X'))>=2) // 'I06X': item "Unique Ice Shard"
endfunction

function Trig_ShinrasPlan_ShardTurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 3: a hero brings a Unique Ice Shard.
function Trig_ShinrasPlan_ShardTurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ShinrasPlan_ShardTurnIn_Cond_ItemHasCharges())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06X'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06X'))-1)) // 'I06X': item "Unique Ice Shard"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06X')) // 'I06X': item "Unique Ice Shard"
    endif
    if(Trig_ShinrasPlan_ShardTurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[62])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(gg_unit_n034_0109,"Wow! You've really found a Unique Ice Shard!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Yeah, and it wasn't easy. What do you need this stuff for, by the way?",false)
        call Text_Say(gg_unit_n034_0109,"I thank you very much for your help. One more thing, though...",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"*sigh* What is it?",false)
        call Text_Say(gg_unit_n034_0109,"An artifact called |cffffcc00Aire Tam Enib Moc|r. I don't know where it can be found, though.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Okay..... but you better not have lied about this being the last item you need !",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call Quest_StepDone(QUEST_SHINRAS_PLAN,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call EnableTrigger(gg_trg_ShinrasPlan_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_ShinrasPlan_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I062'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I062': item "Aire Tam Enib Moc"
endfunction

function Trig_ShinrasPlan_Complete_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I062'))>=2) // 'I062': item "Aire Tam Enib Moc"
endfunction

function Trig_ShinrasPlan_Complete_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 4: a hero brings Aire Tam Enib Moc. Shinra rewards the party and teleports away.
function Trig_ShinrasPlan_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_ShinrasPlan_Complete_Cond_ItemHasCharges())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I062'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I062'))-1)) // 'I062': item "Aire Tam Enib Moc"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I062')) // 'I062': item "Aire Tam Enib Moc"
    endif
    call DestroyEffectBJ(udg_SpecialEffect[62])
    if(Trig_ShinrasPlan_Complete_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go. Your very own \"Aire Tam Enib Moc\".",false)
        call Text_Say(gg_unit_n034_0109,"I... I can't stress how thankful I am to you. I am in your debt.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Enough of that. So what do you need all this for, now?",false)
        call Text_Say(gg_unit_n034_0109,"Here, your well-deserved reward! May we meet again sometime.",false)
        call Reward_Give($4E20,$2710,gg_unit_n034_0109) // $4E20 = 20000; $2710 = 10000
        set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitHide(gg_unit_n034_0109)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well he sure avoided talking about why he needed all that stuff. Shinra... What are you planning?",false)
        call Cine_ExitAction()
    else
        call Reward_Give($4E20,$2710,gg_unit_n034_0109) // $4E20 = 20000; $2710 = 10000
        set udg_TempPoint=GetUnitLoc(gg_unit_n034_0109)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(gg_unit_n034_0109)
    endif
    call Quest_StepDone(QUEST_SHINRAS_PLAN,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Arm)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_ShinrasPlan automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_ShinrasPlan (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_ShinrasPlan takes nothing returns nothing
endfunction

function Register_ShinrasPlan_Prepare takes nothing returns nothing
    set gg_trg_ShinrasPlan_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_ShinrasPlan_Prepare)
    call TriggerAddCondition(gg_trg_ShinrasPlan_Prepare,Condition(function Trig_ShinrasPlan_Prepare_Conditions))
    call TriggerAddAction(gg_trg_ShinrasPlan_Prepare,function Trig_ShinrasPlan_Prepare_Actions)
endfunction

function Register_ShinrasPlan_Start takes nothing returns nothing
    set gg_trg_ShinrasPlan_Start=CreateTrigger()
    call DisableTrigger(gg_trg_ShinrasPlan_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_ShinrasPlan_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_ShinrasPlan_Start,Condition(function Trig_ShinrasPlan_Start_Conditions))
    call TriggerAddAction(gg_trg_ShinrasPlan_Start,function Trig_ShinrasPlan_Start_Actions)
endfunction

function Register_ShinrasPlan_WaterTurnIn takes nothing returns nothing
    set gg_trg_ShinrasPlan_WaterTurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_ShinrasPlan_WaterTurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_ShinrasPlan_WaterTurnIn,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_ShinrasPlan_WaterTurnIn,Condition(function Trig_ShinrasPlan_WaterTurnIn_Conditions))
    call TriggerAddAction(gg_trg_ShinrasPlan_WaterTurnIn,function Trig_ShinrasPlan_WaterTurnIn_Actions)
endfunction

function Register_ShinrasPlan_ShardTurnIn takes nothing returns nothing
    set gg_trg_ShinrasPlan_ShardTurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_ShinrasPlan_ShardTurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_ShinrasPlan_ShardTurnIn,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_ShinrasPlan_ShardTurnIn,Condition(function Trig_ShinrasPlan_ShardTurnIn_Conditions))
    call TriggerAddAction(gg_trg_ShinrasPlan_ShardTurnIn,function Trig_ShinrasPlan_ShardTurnIn_Actions)
endfunction

function Register_ShinrasPlan_Complete takes nothing returns nothing
    set gg_trg_ShinrasPlan_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_ShinrasPlan_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_ShinrasPlan_Complete,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_ShinrasPlan_Complete,Condition(function Trig_ShinrasPlan_Complete_Conditions))
    call TriggerAddAction(gg_trg_ShinrasPlan_Complete,function Trig_ShinrasPlan_Complete_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_ShinrasPlan takes nothing returns nothing
    call Register_ShinrasPlan_Prepare() // starts off; run by DimensionalBoundary, Epilogue, Quest_NightElves +4 more
    call Register_ShinrasPlan_Start() // starts off; enabled by ShinrasPlan
    call Register_ShinrasPlan_WaterTurnIn() // starts off; enabled by ShinrasPlan
    call Register_ShinrasPlan_ShardTurnIn() // starts off; enabled by ShinrasPlan
    call Register_ShinrasPlan_Complete() // starts off; enabled by ShinrasPlan
endfunction

endlibrary

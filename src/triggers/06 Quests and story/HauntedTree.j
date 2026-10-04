library THauntedTree requires TQuestEngine
// Side quest "Haunted Tree", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Oaka IV of the Icy Realm asks the party to exorcise the ghost haunting the Holy Tree; a hero carrying the
// Shimmering Pendant captures it. Made available by Valigarmanda, which runs gg_trg_HauntedTree_Prepare.
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_HauntedTree_Init=null
    trigger gg_trg_HauntedTree_Prepare=null
    trigger gg_trg_HauntedTree_GhostRoam=null
    trigger gg_trg_HauntedTree_CaptureSpirit=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_HAUNTED_TREE=0
endglobals

function Trig_HauntedTree_Init_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_n02F_0108)
    call SetDestructableInvulnerableBJ(gg_dest_B002_0040,true)
    call SetDestructableInvulnerableBJ(gg_dest_B002_0026,true)
    call SetDestructableInvulnerableBJ(gg_dest_LTbx_0038,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Step 1 done (the party talked to Oaka IV): a hero with the Shimmering Pendant can capture the ghost.
function HauntedTree_Started takes nothing returns nothing
    call EnableTrigger(gg_trg_HauntedTree_CaptureSpirit)
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

// Quest done: Oaka IV offers to cut down the trees in the north or the south, if any are left.
function HauntedTree_Done takes nothing returns nothing
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
endfunction

function HauntedTree_Define takes nothing returns nothing
    local integer q=Quest_Define("Haunted Tree",QUEST_SIDE,39,"ReplaceableTextures\\WorldEditUI\\Doodad-Destructible.blp")
    set QUEST_HAUNTED_TREE=q
    call Quest_NotStory(q)
    // 1. Talk to Oaka IV
    call Quest_Talk(q,gg_unit_n02F_0108,"Oaka IV asked you to inspect the non-snowy tree in the area and find a way to exorcise the spirit haunting it.")
    call Quest_Say(q,gg_unit_n02F_0108,"Hello again. Thanks for saving me from those brutes.")
    call Quest_Say(q,null,"Good to see you're safe. Are you alright?")
    call Quest_Say(q,gg_unit_n02F_0108,"I'm fine yeah. But it's so frustrating! We didn't use to be so divided in this realm. It all started going awry when the Holy Tree got haunted by some evil ghost.")
    call Quest_Say(q,gg_unit_n02F_0108,"I'm talking about the tree in the northwest of this region. Even though this realm is pure ice, that one tree is unaffected and grows normally.")
    call Quest_Say(q,gg_unit_n02F_0108,"But now there's a ghost haunting it! I don't know how this happened but ever since then everything's been strange. We of the Icy Realm isolated ourselves from the rest of the world and it's been all tense since.")
    call Quest_Say(q,null,"A ghost is haunting a tree...? That sounds pretty absurd. But sounds like it's having some negative effects on this land.")
    call Quest_Say(q,gg_unit_n02F_0108,"Please, I don't know how it's at all possible but if you can find a way to exorcise the spirit I'll give you a reward.")
    call Quest_OnDone(q,"HauntedTree_Started")
    // 2. Capture the ghost with the Shimmering Pendant (gg_trg_HauntedTree_CaptureSpirit)
    call Quest_Custom(q,"Report back to Oaka IV.")
    // 3. Report back to Oaka IV
    call Quest_Return(q,gg_unit_n02F_0108,"")
    call Quest_PingUnit(q)
    call Quest_Say(q,null,"We've managed to exorcise the spirit from the tree. It should be back to how you like it now.")
    call Quest_Say(q,gg_unit_n02F_0108,"Oh, thank you, you've really helped me.")
    call Quest_Say(q,gg_unit_n02F_0108,"To show you my gratitude, I will cut down some trees in this area for you.")
    call Quest_Say(q,gg_unit_n02F_0108,"Tell me whether you want the trees in the north or in the south cut for you.")
    call Quest_Reward(q,3000,2500)
    call Quest_OnDone(q,"HauntedTree_Done")
endfunction

// Oaka IV appears in the Icy Realm, and the quest can be accepted from him.
function Trig_HauntedTree_Prepare_Actions takes nothing returns nothing
    call ShowUnitShow(gg_unit_n02F_0108)
    if QUEST_HAUNTED_TREE==0 then
        call HauntedTree_Define()
    endif
    call Quest_MakeAvailable(QUEST_HAUNTED_TREE)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Every 4 seconds the ghost wanders around the tree.
function Trig_HauntedTree_GhostRoam_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetRandomLocInRect(gg_rct_366)
    call IssuePointOrderLocBJ(gg_unit_u017_0107,"move",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function Trig_HauntedTree_CaptureSpirit_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0I9'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0I9': item "Shimmering Pendant"
endfunction

// Step 2: a hero with the Shimmering Pendant reached the tree and captures the ghost in it.
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
    call Quest_StepDone(QUEST_HAUNTED_TREE,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
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

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_HauntedTree takes nothing returns nothing
    call Register_HauntedTree_Init() // run by MapBootstrap
    call Register_HauntedTree_Prepare() // starts off; run by Valigarmanda
    call Register_HauntedTree_GhostRoam() // disabled by HauntedTree; destroyed by HauntedTree
    call Register_HauntedTree_CaptureSpirit() // starts off; enabled by HauntedTree
endfunction

endlibrary

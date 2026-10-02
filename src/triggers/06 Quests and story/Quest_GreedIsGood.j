library TQuestGreedIsGood requires TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_GreedIsGood_Start=null
    trigger gg_trg_Quest_GreedIsGood_Complete=null
endglobals

function Trig_Quest_GreedIsGood_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n01S_0082,true,true,true))
endfunction

function Trig_Quest_GreedIsGood_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_GreedIsGood_Start_Enum_RevealGuard takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_Quest_GreedIsGood_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[45])
    if(Trig_Quest_GreedIsGood_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n01S_0082,"I am so glad to meet you! My name is Melaniya and I heard much about you. You are those famous adventurers.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And why are you so happy to see us?",false)
        call Text_Say(gg_unit_n01S_0082,"I want to offer you a deal. It just so happens that I know the location of a secret thieves' hideout. But it is guarded by thieves and fearsome jungle beasts. I will tell where to find this hideout, you'll go wipe out the guards and take the treasure but share it with me.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm.. sounds fishy. How do you know about this hideout if it's \"secret\".",false)
        call Text_Say(gg_unit_n01S_0082,"Well, umm, I was one of these thieves. But as soon as members of our band started to fall under someone's control I decided to leave.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Fall under someone's control? What do you mean?",false)
        call Text_Say(gg_unit_n01S_0082,"We all started to hear a voice in our heads. And that voice commanded us to submit to the will of .. what was his name?... Kashalut or Kashalom?... never mind... to the will of this sorcerer.",false)
        call Text_Say(gg_unit_n01S_0082,"I am a White Mage, my role in band was to heal injured thieves and their victims. I joined the band on that terms. I heal bandits but also their victims. I just wanted no one to die.",false)
        call Text_Say(gg_unit_n01S_0082,"Because of my magical knowledge I was able to resist the spell. Also, I am High Elf and we Elves have some innate resistance to most types of mind control. That's why I escaped. Now I am under Resist Domination Spell and will not submit to this sorceror's will.",false)
        call Text_Say(gg_unit_n01S_0082,"Of course I am no altruist and I had my share of the band's loot. I have enough gold with me, but I am an outlaw. If I go back to Kalm I'll be arrested and put into jail.",false)
        call Text_Say(gg_unit_n01S_0082,"So I need the Portal Stone that is kept in the secret hideout. Once I get my hands on it I'll be able to teleport away from this Plane. I always wanted to visit Aden...",false)
        call Text_Say(gg_unit_n01S_0082,"So please bring me the Portal Stone. Take the rest for yourself. Also know that without me you will never get into hideout - I enchanted it with an Invisibility Enchantment and only I know how to properly disenchant it. Well, do you agree?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ok. Tell us where this hideout is.",false)
        call Text_Say(gg_unit_n01S_0082,"It is to the northwest of the Farm that supplies Kalm with food. I'll mark its location on your map.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good. And remember -  if you are trying to lure us into a trap you will regret it when we have all your fellow thieves dead and come back for you.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Greed is Good|r")
    set udg_SideQuest[27]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffGreed is Good","Melaniya, former thief hiding in the Mountains, asked you to go to the secret thieves' hideout, kill guards and bring her Portal Stone.","ReplaceableTextures\\CommandButtons\\BTNSpellShieldAmulet.blp")
    set udg_SpecialEffect[45]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n01S_0082,"Objects\\RandomObject\\RandomObject.mdl")
    call ForGroupBJ(udg_HideoutGuards,function Trig_Quest_GreedIsGood_Start_Enum_RevealGuard)
    call GroupAddUnitSimple(gg_unit_nmgv_0115,udg_BossUnits)
    call EnableTrigger(gg_trg_GreedIsGood_DropStone)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_GreedIsGood_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I034'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I034': item "Portal Stone"
endfunction

function Trig_Quest_GreedIsGood_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_GreedIsGood_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_PortalStone_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I034')) // 'I034': item "Portal Stone"
    call DestroyEffectBJ(udg_SpecialEffect[45])
    if(Trig_Quest_GreedIsGood_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n01S_0082,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I have the Portal Stone with me. Here you go.",false)
        call Text_Say(gg_unit_n01S_0082,"Thank you very much. Now I can escape this dangerous world. If you ever do the same, do drop by on Aden and see me.",false)
        call Reward_Give($9C4,$9C4,gg_unit_n01S_0082) // $9C4 = 2500
        call Text_Say(gg_unit_n01S_0082,"Bye.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_n01S_0082)
        set udg_SpecialEffect[45]=AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl")
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(3.)
        call DestroyEffectBJ(udg_SpecialEffect[45])
        set udg_TempPoint=GetUnitLoc(gg_unit_n01S_0082)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(gg_unit_n01S_0082)
        call Wait_Polled(1.5)
        call Cine_ExitAction()
    else
        call Reward_Give($9C4,$9C4,gg_unit_n01S_0082) // $9C4 = 2500
        set udg_TempPoint=GetUnitLoc(gg_unit_n01S_0082)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call RemoveUnit(gg_unit_n01S_0082)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Greed is Good|r")
    call QuestSetCompletedBJ(udg_SideQuest[27],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call AddUnitToStockBJ('n0BF',gg_unit_n0BV_0229,1,1) // 'n0BF': unit "Hunt: Phantom Dancer"
    set udg_HuntStock[5]=(udg_HuntStock[5]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_GreedIsGood takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_GreedIsGood_Start takes nothing returns nothing
    set gg_trg_Quest_GreedIsGood_Start=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_GreedIsGood_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_GreedIsGood_Start,Condition(function Trig_Quest_GreedIsGood_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_GreedIsGood_Start,function Trig_Quest_GreedIsGood_Start_Actions)
endfunction

function Register_Quest_GreedIsGood_Complete takes nothing returns nothing
    set gg_trg_Quest_GreedIsGood_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_GreedIsGood_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_GreedIsGood_Complete,450.,gg_unit_n01S_0082)
    call TriggerAddCondition(gg_trg_Quest_GreedIsGood_Complete,Condition(function Trig_Quest_GreedIsGood_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_GreedIsGood_Complete,function Trig_Quest_GreedIsGood_Complete_Actions)
endfunction

endlibrary

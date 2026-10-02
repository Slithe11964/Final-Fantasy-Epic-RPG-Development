library TGiott requires TCam, TCine, TPlayerPart01, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Giott_FirstTalk=null
    trigger gg_trg_Giott_Letter_Deliver=null
endglobals

function Trig_Giott_FirstTalk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h00R_0256,true,true,true))
endfunction

function Trig_Giott_FirstTalk_PlayGiottScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Giott_FirstTalk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[87])
    if(Trig_Giott_FirstTalk_PlayGiottScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h00R_0256,"Lali-ho, strangers! Where do ye hail from?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are adventurers exploring these lands. We come from Kalm. Is this some kind of dwarf settlement?",false)
        call Text_Say(gg_unit_h00R_0256,"Ye right it is. I'm Giott, leader of this here pack of dwarves. We don' have much here but our trusted forge, but we got all we need ta survive.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Don't the monsters around here attack you?",false)
        call Text_Say(gg_unit_h00R_0256,"Aye. Used ta be more aggressive, but lately they jus' been leavin' us alone entirely. But in case somethin' does 'appen, we got Ziegfried over there. 'Es in charge of takin' down beasts so 'es got first pick on the gear we make.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, you craft gear with this forge here? Can you make me some powerful armor then?",false)
        call Text_Say(gg_unit_h00R_0256,"Possible aye, but we dwarves are the careful type. No offense, but 'tis be the first time we speak. We be proud of our craft, we don' make it for jus' anyone.",false)
        call Text_Say(gg_unit_h00R_0256,"Still, you say ye adventurers? Some brethren of mine could use a helping hand. If ye be trustworthy and reliable me pals will surely make you some good gear. Of course we be payin' gold for tasks as well.",false)
        call Cine_ExitAction()
    endif
    set udg_KalmTechLevel=1
    call ConditionalTriggerExecute(gg_trg_Loki_Talk_Enable)
    call ConditionalTriggerExecute(gg_trg_Watts_Talk_Enable)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Giott_Letter_Deliver_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0KP'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_h00R_0256)==false)and(udg_InCinematicMode==false))!=null // 'I0KP': item "Letter from Mid"
endfunction

function Trig_Giott_Letter_Deliver_IsFirstMeeting takes nothing returns boolean
    return(udg_KalmTechLevel==2)
endfunction

function Trig_Giott_Letter_Deliver_MidQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[20]))
endfunction

function Trig_Giott_Letter_Deliver_WasFirstMeeting takes nothing returns boolean
    return(udg_KalmTechLevel==2)
endfunction

function Trig_Giott_Letter_Deliver_PlayHandoverScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Giott_Letter_Deliver_OreQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[67]))
endfunction

function Trig_Giott_Letter_Deliver_NeedsIntroTriggers takes nothing returns boolean
    return(udg_KalmTechLevel==2)
endfunction

function Trig_Giott_Letter_Deliver_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Mid_Letter_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0KP')) // 'I0KP': item "Letter from Mid"
    call DestroyEffectBJ(udg_SpecialEffect[87])
    if(Trig_Giott_Letter_Deliver_PlayHandoverScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h00R_0256,0)
        if(Trig_Giott_Letter_Deliver_IsFirstMeeting())then
            call Text_Say(gg_unit_h00R_0256,"Lali-ho, strangers! What do ye need with us?",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"You are Giott, correct? I have here a letter from Mid, for you. He's the nephew of the head of community in Kalm.",false)
        else
            call Text_Say(gg_unit_h00R_0256,"Lali-ho again! Ye got some business with me?",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I have here a letter from Mid, for you. He's the nephew of the head of community in Kalm.",false)
        endif
        call Text_Say(gg_unit_h00R_0256,"Aye, we know Mid. He's a good lad. Let's see what he's written for us...",false)
        if(Trig_Giott_Letter_Deliver_MidQuestDone())then
            call Text_Say(gg_unit_h00R_0256,"Oh, so lil' Mid vouches for ye as a powerful adventurer and wants us to help ye in any way we can? Unusual for him to go out of his way that much, but if he did, you mus' be the real deal.",false)
        else
            call Text_Say(gg_unit_h00R_0256,"Hmm... so Kalm could use some aid in fendin' off hordes of monsters eh. Whaddya say everyone, shall we go help out little Mid?",false)
            call Text_Say(gg_unit_h00Q_0255,"Course we will! Can't let young lil' Mid down, can we?",false)
            call Text_Say(gg_unit_H00P_0260,"Agreed, he's a good lad. Let's get him some help.",false)
            call Text_Say(gg_unit_H036_0254,"Do as you wish, just don't expect me to run all the way over there myself.",false)
            call Text_Say(gg_unit_h00R_0256,"Well ye heard the boys. We'll be sendin' some reinforcements in for ye.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Thanks Giott. Your help will be very much welcome.",false)
            call Text_Say(gg_unit_h00R_0256,"Nah, the thanks be with ye, pal. Thanks for lettin' us know this was going on. We don' want harm coming to our friends either.",false)
            call Text_Say(gg_unit_h00R_0256,"So Mid trusts ye enough to make you carry this letter to us for him? Looks like you must be a fine lad yourself then.",false)
        endif
        if(Trig_Giott_Letter_Deliver_WasFirstMeeting())then
            call Text_Say(gg_unit_h00R_0256,"Usually we be rather wary of strangers, but a friend of a friend is a friend of ours. If ye need anything from us, we're here for ye!",false)
        else
            call Text_Say(gg_unit_h00R_0256,"Apologies for bein' cautious before. If ye need our skills with anything, we be glad to do what we can for ye.",false)
        endif
        call Cine_ExitAction()
    endif
    if(Trig_Giott_Letter_Deliver_NeedsIntroTriggers())then
        call ConditionalTriggerExecute(gg_trg_Loki_Talk_Enable)
        call ConditionalTriggerExecute(gg_trg_Watts_Talk_Enable)
    else
        if(Trig_Giott_Letter_Deliver_OreQuestDone())then
            set udg_SpecialEffect[88]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_H00P_0260,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
            call EnableTrigger(gg_trg_Loki_Reforge_Unlock)
        endif
    endif
    set udg_KalmTechLevel=3
    call ConditionalTriggerExecute(gg_trg_Forge_Bali_Init)
    call Wait_Polled(180.)
    call ConditionalTriggerExecute(gg_trg_Mid_Crossbow_Talk_Enable)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Giott automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Giott (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Giott takes nothing returns nothing
endfunction

function Register_Giott_FirstTalk takes nothing returns nothing
    set gg_trg_Giott_FirstTalk=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Giott_FirstTalk,Player(7),true)
    call TriggerAddCondition(gg_trg_Giott_FirstTalk,Condition(function Trig_Giott_FirstTalk_Conditions))
    call TriggerAddAction(gg_trg_Giott_FirstTalk,function Trig_Giott_FirstTalk_Actions)
endfunction

function Register_Giott_Letter_Deliver takes nothing returns nothing
    set gg_trg_Giott_Letter_Deliver=CreateTrigger()
    call DisableTrigger(gg_trg_Giott_Letter_Deliver)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Giott_Letter_Deliver,450.,gg_unit_h00R_0256)
    call TriggerAddCondition(gg_trg_Giott_Letter_Deliver,Condition(function Trig_Giott_Letter_Deliver_Conditions))
    call TriggerAddAction(gg_trg_Giott_Letter_Deliver,function Trig_Giott_Letter_Deliver_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Giott takes nothing returns nothing
    call Register_Giott_FirstTalk() // disabled by Epilogue, Mid
    call Register_Giott_Letter_Deliver() // starts off; enabled by Epilogue, Mid
endfunction

endlibrary

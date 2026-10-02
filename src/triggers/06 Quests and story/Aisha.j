library TAisha requires TCam, TCine, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Aisha_ArtemisTalk_Prepare=null
    trigger gg_trg_Aisha_ArtemisTale=null
endglobals

function Trig_Aisha_ArtemisTalk_Prepare_Conditions takes nothing returns boolean
    return(IsQuestFailed(udg_SideQuest[$E])==false) // $E = 14
endfunction

function Trig_Aisha_ArtemisTalk_Prepare_Cond_QuestNotDone takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[$E])==false) // $E = 14
endfunction

function Trig_Aisha_ArtemisTalk_Prepare_Actions takes nothing returns nothing
    if(Trig_Aisha_ArtemisTalk_Prepare_Cond_QuestNotDone())then
        call StartTimerBJ(udg_AishaTalkTimer,false,10.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set udg_SpecialEffect[81]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e017_0018,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Aisha_ArtemisTale)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Aisha_ArtemisTale_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e017_0018,true,true,true))
endfunction

function Trig_Aisha_ArtemisTale_Cond_ShowTale takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Aisha_ArtemisTale_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[81])
    call PauseUnitBJ(true,gg_unit_e017_0018)
    if(Trig_Aisha_ArtemisTale_Cond_ShowTale())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e017_0018,"Wow, you've made it to the top of our leaderboards!",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That was tough. You have some truly skilled archers among you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I recognized some of the names on the list, but I've never met this \"Artemis\" at the top. Who's that?",false)
        call Text_Say(gg_unit_e017_0018,"Artemis was the most skilled archer of our people. She was absolutely peerless.",false)
        call Text_Say(gg_unit_e017_0018,"Many of us have tried to match up to her but we never could. And the worst about it was that she was like you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Like me?",false)
        call Text_Say(gg_unit_e017_0018,"She didn't even necessarily want to be an Archer. She also learned to wield a sword, an axe, a spear, and even learned all different kinds of magic. Not that she was the absolute top in every category, but she certainly was at archery, and for us who spent our lives on archery it's frustrating, you know? To be outdone by someone who feels superhuman.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh so she 'job changed' as well?",false)
        call Text_Say(gg_unit_e017_0018,"Yeah. Ultimately she settled on becoming a Time Mage. It was what she was most passionate for. But one day, she just disappeared.",false)
        call Text_Say(gg_unit_e017_0018,"Nobody knows where. It's like her entire existence was removed from the world. Only our memories of her remain.",false)
        call Text_Say(gg_unit_e017_0018,"I'd hoped to offer her bow as a reward for whoever managed to beat her time in target practice at least, but it was lost along with her as well.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"She just disappeared one day... that's definitely strange.",false)
        call Text_Say(gg_unit_e017_0018,"Well sorry to bore you with this little tale. You're free to try to beat your own time if you ever feel up for it, of course!",false)
        call Cine_ExitAction()
    endif
    call PauseUnitBJ(false,gg_unit_e017_0018)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Aisha automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Aisha (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Aisha takes nothing returns nothing
endfunction

function Register_Aisha_ArtemisTalk_Prepare takes nothing returns nothing
    set gg_trg_Aisha_ArtemisTalk_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_Aisha_ArtemisTalk_Prepare)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Aisha_ArtemisTalk_Prepare,udg_AishaTalkTimer)
    call TriggerAddCondition(gg_trg_Aisha_ArtemisTalk_Prepare,Condition(function Trig_Aisha_ArtemisTalk_Prepare_Conditions))
    call TriggerAddAction(gg_trg_Aisha_ArtemisTalk_Prepare,function Trig_Aisha_ArtemisTalk_Prepare_Actions)
endfunction

function Register_Aisha_ArtemisTale takes nothing returns nothing
    set gg_trg_Aisha_ArtemisTale=CreateTrigger()
    call DisableTrigger(gg_trg_Aisha_ArtemisTale)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Aisha_ArtemisTale,Player(7),true)
    call TriggerAddCondition(gg_trg_Aisha_ArtemisTale,Condition(function Trig_Aisha_ArtemisTale_Conditions))
    call TriggerAddAction(gg_trg_Aisha_ArtemisTale,function Trig_Aisha_ArtemisTale_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Aisha takes nothing returns nothing
    call Register_Aisha_ArtemisTalk_Prepare()
    call Register_Aisha_ArtemisTale()
endfunction

endlibrary

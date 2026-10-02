library TPriestX requires TCam, TCine, TPlayerPart01, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_PriestX_Appear=null
    trigger gg_trg_PriestX_Talk1=null
    trigger gg_trg_PriestX_Talk2=null
endglobals

function Trig_PriestX_Appear_Quest20NotFound takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_PriestX_Appear_Actions takes nothing returns nothing
    if(Trig_PriestX_Appear_Quest20NotFound())then
        set udg_ExodusQuestStage=1
        call ShowUnitShow(gg_unit_n0D3_0117)
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0D3_0117,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_PriestX_Talk1)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_PriestX_Talk1_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0D3_0117,true,true,true))
endfunction

function Trig_PriestX_Talk1_Quest41Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_SideQuest[41]))
endfunction

function Trig_PriestX_Talk1_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_PriestX_Talk1_Quest20NotFound takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_PriestX_Talk1_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ExodusQuestStage=2
    if(Trig_PriestX_Talk1_CinematicsEnabled())then
        call DestroyEffectBJ(udg_SpecialEffect[28])
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hm? Who are you, are you a priest?",false)
        call Text_Say(gg_unit_n0D3_0117,"I'm just here mourning this pointless loss of lives. You may call me X.",false)
        if(Trig_PriestX_Talk1_Quest41Discovered())then
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"X? Hmm, you don't seem like the type to take people's swords...",false)
            call Text_Say(gg_unit_n0D3_0117,"What are you talking about?",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh nothing.",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's quite a peculiar name. Are you from the Farm?",false)
        call Text_Say(gg_unit_n0D3_0117,"You could say that.",false)
        call Text_Transmission(gg_unit_n0D3_0117,"X","You could say that. Say.","You could say that.",null,0,false)
        call Text_Transmission(gg_unit_n0D3_0117,"X","You could say that. Say. I have a question for you.","You could say that. Say.",null,0,false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Go ahead.",false)
        call Text_Say(gg_unit_n0D3_0117,"Do you think human lives are worth more than the lives of other beings in the world?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Well that's an unexpected question.",false)
        call Text_Say(gg_unit_n0D3_0117,"Well it's fine, you don't have to answer it.",false)
        call Text_Transmission(gg_unit_n0D3_0117,"X","Well it's fine, you don't have to answer it. My apologies for asking such a strange question.","Well it's fine, you don't have to answer it.",null,0,false)
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitHide(gg_unit_n0D3_0117)
        call Wait_Polled(1.5)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What the? Where did he go all of a sudden?",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0D3_0117,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(gg_unit_n0D3_0117)
    endif
    call Wait_Polled(120.)
    if(Trig_PriestX_Talk1_Quest20NotFound())then
        set udg_ExodusQuestStage=3
        set udg_TempPoint=GetRectCenter(gg_rct_488)
        call SetUnitPositionLoc(gg_unit_n0D3_0117,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_n0D3_0117)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_n0D3_0117,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call EnableTrigger(gg_trg_PriestX_Talk2)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_PriestX_Talk2_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0D3_0117,true,true,true))
endfunction

function Trig_PriestX_Talk2_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_PriestX_Talk2_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ExodusQuestStage=4
    call DestroyEffectBJ(udg_SpecialEffect[28])
    if(Trig_PriestX_Talk2_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"There you are. What are you doing here?",false)
        call Text_Say(gg_unit_n0D3_0117,"Mourning this pointless loss of lives.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Of vicious gnolls?",false)
        call Text_Say(gg_unit_n0D3_0117,"Is there something wrong with that?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You realize what these gnolls did, right?",false)
        call Text_Say(gg_unit_n0D3_0117,"Of course I do.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So why are you mourning these monsters?",false)
        call Text_Say(gg_unit_n0D3_0117,"Monsters or not, they remain living beings. This was a clan of gnolls whose existence stretches back through decades. And now here they lay, all of that extinguished.",false)
        call Text_Say(gg_unit_n0D3_0117,"I'm not asking for you to have sympathy for them after what they did. Still, the bigger picture remains as it is. And it is harrowing.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitHide(gg_unit_n0D3_0117)
        call Wait_Polled(1.5)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"He's gone again.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Who the hell is this strange priest, anyways?",false)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(gg_unit_n0D3_0117)
    endif
    set udg_SpecialEffect[28]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n00K_0150,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_LastRites_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_PriestX automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_PriestX (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_PriestX takes nothing returns nothing
endfunction

function Register_PriestX_Appear takes nothing returns nothing
    set gg_trg_PriestX_Appear=CreateTrigger()
    call DisableTrigger(gg_trg_PriestX_Appear)
    call TriggerAddAction(gg_trg_PriestX_Appear,function Trig_PriestX_Appear_Actions)
endfunction

function Register_PriestX_Talk1 takes nothing returns nothing
    set gg_trg_PriestX_Talk1=CreateTrigger()
    call DisableTrigger(gg_trg_PriestX_Talk1)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk1,Player(7),true)
    call TriggerAddCondition(gg_trg_PriestX_Talk1,Condition(function Trig_PriestX_Talk1_Conditions))
    call TriggerAddAction(gg_trg_PriestX_Talk1,function Trig_PriestX_Talk1_Actions)
endfunction

function Register_PriestX_Talk2 takes nothing returns nothing
    set gg_trg_PriestX_Talk2=CreateTrigger()
    call DisableTrigger(gg_trg_PriestX_Talk2)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_PriestX_Talk2,Player(7),true)
    call TriggerAddCondition(gg_trg_PriestX_Talk2,Condition(function Trig_PriestX_Talk2_Conditions))
    call TriggerAddAction(gg_trg_PriestX_Talk2,function Trig_PriestX_Talk2_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_PriestX takes nothing returns nothing
    call Register_PriestX_Appear()
    call Register_PriestX_Talk1()
    call Register_PriestX_Talk2()
endfunction

endlibrary

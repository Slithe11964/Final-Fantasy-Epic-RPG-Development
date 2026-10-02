library TTalk requires TCam, TCine, TMusic, TPlayerPart01, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Talk_PortalGuardian=null
    trigger gg_trg_Talk_ForestGuardian=null
    trigger gg_trg_Talk_Lothlorien_Greet=null
endglobals

function Trig_Talk_PortalGuardian_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ecen_0180,true,true,true))
endfunction

function Trig_Talk_PortalGuardian_ShowGuardianScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Talk_PortalGuardian_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[37])
    set udg_PortalGuardianMet=true
    call DisableTrigger(gg_trg_Portal_Reveal)
    if(Trig_Talk_PortalGuardian_ShowGuardianScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Ecen_0180,0)
        call Text_Say(gg_unit_Ecen_0180,"Hmmm? Where did you come from?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We just passed through these forests. We're looking for a Night Elf settlement. Are you a scout of their tribe?",false)
        call Text_Say(gg_unit_Ecen_0180,"I am the protector of the hidden portal connecting this forest to the continent of humans.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hidden portal? I've heard of something like that, but we didn't find it.",false)
        call Text_Say(gg_unit_Ecen_0180,"The portal reveals itself to anyone approaching it who knows of its existence. Here, I will show you.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_nwgt_0141)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call TriggerExecute(gg_trg_Portal_Reveal)
        call Wait_Polled(2.)
        call Text_Say(gg_unit_Ecen_0180,"It is by far the safest route to take to travel between the human and ancient continents.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I thank you.",false)
        call Text_Say(gg_unit_Ecen_0180,"Now then, you said you are looking for our settlement? You can find it if you go straight west from here.",false)
        call Text_Say(gg_unit_Ecen_0180,"If you need any help making it through these woods, I can turn you invisible against the fiends around here. I am sworn to aid humans in need of our assistance to reach our kin. Feel free to ask.",false)
        call Cine_ExitAction()
    else
        call TriggerExecute(gg_trg_Portal_Reveal)
    endif
    call UnitAddAbilityBJ('Ane2',gg_unit_Ecen_0180) // 'Ane2': object name not found in map data
endfunction

function Trig_Talk_ForestGuardian_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ecen_0180,true,true,true))
endfunction

function Trig_Talk_ForestGuardian_ShowForestGuardianScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Talk_ForestGuardian_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[37])
    set udg_PortalGuardianMet=true
    if(Trig_Talk_ForestGuardian_ShowForestGuardianScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Ecen_0180,0)
        call Text_Say(gg_unit_Ecen_0180,"It has been some time since a human has passed by these parts.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are looking for the night elf settlement around these parts. Are you a sentry of theirs?",false)
        call Text_Say(gg_unit_Ecen_0180,"Something like that. My task is protecting the gate between the human and ancient continents, and to aid human travellers pass through the Ancient Forest.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So will you join us in our pilgrimage?",false)
        call Text_Say(gg_unit_Ecen_0180,"I cannot leave here. Protecting this gate is of utmost importance. However, I can lend you my help in another way.",false)
        call Text_Say(gg_unit_Ecen_0180,"The tainted fiends in this forest are strong. You would do well not to engage them lightly. However, if you simply wish to reach our settlement it is enough to simply pass by them.",false)
        call Text_Say(gg_unit_Ecen_0180,"And for that purpose, I can turn you invisible. So long as you do not draw attention to yourself, you should be able to pass by the fiends without much issue.",false)
        call Text_Say(gg_unit_Ecen_0180,"Of course, if you are confident in your abilities you can try fighting your way through the forest. But be warned, the creatures around here are corrupted and have recently grown very aggressive and dangerous. I advise you to be on your guard and escape before you get surrounded.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright, thank you for your help.",false)
        call Cine_ExitAction()
    endif
    call UnitAddAbilityBJ('Ane2',gg_unit_Ecen_0180) // 'Ane2': object name not found in map data
endfunction

function Trig_Talk_Lothlorien_Greet_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Emns_0156,true,true,true))
endfunction

function Trig_Talk_Lothlorien_Greet_CameraOnLothlorien takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Talk_Lothlorien_Greet_ShowGreetScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Talk_Lothlorien_Greet_SceneQueueEmpty takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)
endfunction

function Trig_Talk_Lothlorien_Greet_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[30])
    if(Trig_Talk_Lothlorien_Greet_ShowGreetScene())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Talk_Lothlorien_Greet_CameraOnLothlorien)
        call Text_Say(gg_unit_Emns_0156,"Why have you come to Lothlorien, human?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We just happened upon this place. We are adventurers, traveling the world.",false)
        call Text_Say(gg_unit_Etyr_0155,"Adventurers? So you're just frivolous brutes invading people's homes for fun, are you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What ? No, we mean no harm. We just came here out of interest for seeing the world, that's all.",false)
        call Text_Say(gg_unit_Emns_0156,"Forgive my lady's harsh tone. We night elves prefer to keep to ourselves. So long as you do not cause unrest, you may look around.",false)
        call Text_Say(gg_unit_Emns_0156,"If we deem you a danger, however, we will not hesitate to banish you from here. Know that.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're not ones for hospitality, are you?",false)
        call Text_Say(gg_unit_Etyr_0155,"Hmph, well I may have overreacted. We have not had good experiences dealing with outsiders. I apologize for the tone.",false)
        call Text_Say(gg_unit_Etyr_0155,"Welcome to our remote settlement of Lothlorien. We live in the shadows of the Ancient Forest, in tune with Gaya and its needs.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Thanks. We aren't here to cause troubles.",false)
        call Text_Say(gg_unit_Emns_0156,"Good.",false)
        call Cine_ExitAction()
    endif
    set udg_LothlorienOpen=true
    call UnitAddAbilityBJ('Aneu',gg_unit_eaom_0159) // 'Aneu': standard ability reference "Neutral Building"
    call UnitAddAbilityBJ('Aneu',gg_unit_n00L_0153) // 'Aneu': standard ability reference "Neutral Building"
    call ConditionalTriggerExecute(gg_trg_Quest_LadyNashj_Available)
    call ConditionalTriggerExecute(gg_trg_DefiledFountain_Prepare)
    call ConditionalTriggerExecute(gg_trg_Liniel_ShowMarker)
    call ConditionalTriggerExecute(gg_trg_ShinrasPlan_Prepare)
    call ConditionalTriggerExecute(gg_trg_Krjn_ShowTalkIcon)
    call EnableTrigger(gg_trg_MysteriousCurse_Witness)
    set udg_QuestMarkerEffect[16]=AddSpecialEffectTargetUnitBJ("head",gg_unit_esen_0152,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_BridgeBattle_Prepare)
    if(Trig_Talk_Lothlorien_Greet_SceneQueueEmpty())then
        call TriggerExecute(gg_trg_NightElf_TalkPrepare)
    else
        call EnableTrigger(gg_trg_NightElf_TalkPrepare)
    endif
    call Music_SetZoneTrack(8)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Talk automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Talk_Part1 / RegisterTriggers_Talk_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Talk takes nothing returns nothing
endfunction

function Register_Talk_PortalGuardian takes nothing returns nothing
    set gg_trg_Talk_PortalGuardian=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_PortalGuardian,Player(7),true)
    call TriggerAddCondition(gg_trg_Talk_PortalGuardian,Condition(function Trig_Talk_PortalGuardian_Conditions))
    call TriggerAddAction(gg_trg_Talk_PortalGuardian,function Trig_Talk_PortalGuardian_Actions)
endfunction

function Register_Talk_ForestGuardian takes nothing returns nothing
    set gg_trg_Talk_ForestGuardian=CreateTrigger()
    call DisableTrigger(gg_trg_Talk_ForestGuardian)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_ForestGuardian,Player(7),true)
    call TriggerAddCondition(gg_trg_Talk_ForestGuardian,Condition(function Trig_Talk_ForestGuardian_Conditions))
    call TriggerAddAction(gg_trg_Talk_ForestGuardian,function Trig_Talk_ForestGuardian_Actions)
endfunction

function Register_Talk_Lothlorien_Greet takes nothing returns nothing
    set gg_trg_Talk_Lothlorien_Greet=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Talk_Lothlorien_Greet,Player(7),true)
    call TriggerAddCondition(gg_trg_Talk_Lothlorien_Greet,Condition(function Trig_Talk_Lothlorien_Greet_Conditions))
    call TriggerAddAction(gg_trg_Talk_Lothlorien_Greet,function Trig_Talk_Lothlorien_Greet_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Talk_Part1 takes nothing returns nothing
    call Register_Talk_PortalGuardian() // disabled by Epilogue, Portal, Quest_NightElves; destroyed by Epilogue, Portal, Quest_NightElves
    call Register_Talk_ForestGuardian() // starts off; enabled by Portal; disabled by Epilogue, Quest_NightElves; destroyed by Epilogue, Quest_NightElves
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Talk_Part2 takes nothing returns nothing
    call Register_Talk_Lothlorien_Greet() // disabled by Quest_NightElves, TrueIceAge; destroyed by Quest_NightElves
endfunction

endlibrary

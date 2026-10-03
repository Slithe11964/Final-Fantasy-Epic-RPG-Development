library TNaisha requires TCam, TCine, TGroup, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Naisha_Init=null
    trigger gg_trg_Naisha_Prepare=null
    trigger gg_trg_Naisha_Recruit=null
    trigger gg_trg_Naisha_Wounded=null
    trigger gg_trg_Naisha_AttackedRetreat=null
    trigger gg_trg_Naisha_Heal=null
    trigger gg_trg_Naisha_Death=null
    trigger gg_trg_Naisha_ArriveLothlorien=null
    trigger gg_trg_Naisha_Whirl=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    sound gg_snd_NaishaReady=null
endglobals

function Trig_Naisha_Init_Actions takes nothing returns nothing
    call PauseUnitBJ(true,gg_unit_ensh_0057)
    call SetUnitInvulnerable(gg_unit_ensh_0057,true)
    set udg_NaishaUnit=gg_unit_ensh_0057
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Naisha_Prepare_Cond_BoostEnabled takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Naisha_Prepare_Actions takes nothing returns nothing
    set udg_SpecialEffect[5]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ensh_0057,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Naisha_Recruit)
    if(Trig_Naisha_Prepare_Cond_BoostEnabled())then
        call UnitAddAbilityBJ('A1CG',udg_NaishaUnit) // 'A1CG': ability "Attack Speed +40%"
        call BlzSetUnitBaseDamage(udg_NaishaUnit,505,(1-1))
        call BlzSetUnitBaseDamage(udg_NaishaUnit,505,1)
        call BlzSetUnitMaxHP(udg_NaishaUnit,$4E20) // $4E20 = 20000
        call SetUnitLifePercentBJ(udg_NaishaUnit,'d')
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Naisha_Recruit_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_ensh_0057,true,true,true))
endfunction

function Trig_Naisha_Recruit_Cond_ShowRecruitTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Naisha_Recruit_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[5])
    if(Trig_Naisha_Recruit_Cond_ShowRecruitTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_ensh_0057,"Hello, my name is Naisha. I am new in this town just like you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),("And I am "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+". How did you come to be here?")),false)
        call Text_Say(gg_unit_ensh_0057,"Well, it seems that I came here from another world, but I don't know how exactly that happened.",false)
        call Text_Say(gg_unit_ensh_0057,"We were hunting Illidan the Betrayer but he set up a trap for us. We were going to be buried alive in the Tomb of Sargeras but Elune granted us a portal to escape the crumbling tomb.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Elune?",false)
        call Text_Say(gg_unit_ensh_0057,"Our goddess. It must have been a divine intervention to save us from death. So I passed through the portal and appeared here.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I see. So what do you plan on doing now that you're here?",false)
        call Text_Say(gg_unit_ensh_0057,"I need to find my fellow sisters and return to the hunt for Illidan as soon as possible. I've talked to the High Elves around here and unfortunately they don't know much to help me. So I'll be traveling the world in search for people who can help me get back to my own world.",false)
        call Text_Say(gg_unit_ensh_0057,"But it seems this world is crawling with monsters. I won't make it far alone.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are adventurers. If you lend us your aid in battle we may be able to help you reach places to find out more.",false)
        call Text_Say(gg_unit_ensh_0057,"That would be great. Of course I'm not simply going to stand by and let you do all the fighting. Let us explore this plane. And if you can help me find any clues as to the whereabouts of my fellow night elf sisters, or how to get back to Azeroth, I'll be grateful.",false)
        call Cine_ExitAction()
    endif
    call CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffNaisha","Naisha, night elf huntress from the world of Azeroth, is on the search for clues on where her fellow night elf sisters may have gone, and on how to get back to her own world. Use her strength to reach places and people she may be able to get information from! Be careful so that she does not die.","ReplaceableTextures\\CommandButtons\\BTNHuntress.blp")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Naisha|r")
    set udg_SideQuest[17]=GetLastCreatedQuestBJ()
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Naisha joins your party.")
    call PauseUnitBJ(false,gg_unit_ensh_0057)
    call SetUnitOwner(gg_unit_ensh_0057,Player($A),true) // $A = 10
    call RemoveGuardPosition(gg_unit_ensh_0057)
    call SetUnitInvulnerable(gg_unit_ensh_0057,false)
    call EnableTrigger(gg_trg_Naisha_Heal)
    call EnableTrigger(gg_trg_Naisha_Wounded)
    call EnableTrigger(gg_trg_Naisha_AttackedRetreat)
    call EnableTrigger(gg_trg_Naisha_Death)
    call EnableTrigger(gg_trg_Naisha_ArriveLothlorien)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Naisha_Wounded_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_NaishaUnit)and(IsUnitAliveBJ(udg_NaishaUnit))
endfunction

function Trig_Naisha_Wounded_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Naisha_AttackedRetreat)
    call StartTimerBJ(udg_NaishaHealTimer,false,4.)
    call UnitApplyTimedLifeBJ(4.05,'BEfn',udg_NaishaUnit) // 'BEfn': buff tooltip "Time Limit"
endfunction

function Trig_Naisha_AttackedRetreat_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_NaishaUnit)and(GetAttacker()==udg_SummonedBoss)
endfunction

function Trig_Naisha_AttackedRetreat_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Naisha_Wounded)
    call StartTimerBJ(udg_NaishaHealTimer,false,1.)
endfunction

function Trig_Naisha_Heal_Conditions takes nothing returns boolean
    return(IsUnitAliveBJ(udg_NaishaUnit))
endfunction

function Trig_Naisha_Heal_Cond_BoostActive takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Naisha_Heal_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(gg_trg_Naisha_Death)
    set l_tempPoint=GetUnitLoc(udg_NaishaUnit)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call KillUnit(udg_NaishaUnit)
    call RemoveUnit(udg_NaishaUnit)
    set l_tempPoint=GetDestructableLoc(gg_dest_BTrx_0011)
    call CreateNUnitsAtLoc(1,'ensh',Player(9),l_tempPoint,bj_UNIT_FACING) // 'ensh': editor label "Naisha"
    call RemoveLocation(l_tempPoint)
    set udg_NaishaUnit=GetLastCreatedUnit()
    if(Trig_Naisha_Heal_Cond_BoostActive())then
        call UnitAddAbilityBJ('A1CG',udg_NaishaUnit) // 'A1CG': ability "Attack Speed +40%"
        call BlzSetUnitBaseDamage(udg_NaishaUnit,505,(1-1))
        call BlzSetUnitBaseDamage(udg_NaishaUnit,505,1)
        call BlzSetUnitMaxHP(udg_NaishaUnit,$4E20) // $4E20 = 20000
    else
        call BlzSetUnitMaxHP(udg_NaishaUnit,(BlzGetUnitMaxHP(udg_NaishaUnit)+(udg_StoryProgress*'d')))
    endif
    call SetUnitLifePercentBJ(udg_NaishaUnit,11.11)
    call PauseUnitBJ(true,udg_NaishaUnit)
    call SetUnitInvulnerable(udg_NaishaUnit,true)
    set l_tempPoint=GetUnitLoc(udg_NaishaUnit)
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    call RemoveGuardPosition(udg_NaishaUnit)
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Naisha has been severly injured and is healing her wounds now. She will join you again in two minutes.")
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,22.22)
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,33.33)
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,44.44)
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,55.55)
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,66.66)
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,77.77)
    call Wait_Polled(15.)
    call SetUnitLifePercentBJ(udg_NaishaUnit,88.88)
    call Wait_Polled(15.)
    call PauseUnitBJ(false,udg_NaishaUnit)
    call SetUnitLifePercentBJ(udg_NaishaUnit,'d')
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Naisha healed her wounds and ready to fight again.")
    call PlaySoundBJ(gg_snd_NaishaReady)
    call SetUnitOwner(udg_NaishaUnit,Player($A),true) // $A = 10
    call RemoveGuardPosition(udg_NaishaUnit)
    call SetUnitInvulnerable(udg_NaishaUnit,false)
    call TriggerRegisterUnitLifeEvent(gg_trg_Naisha_Wounded,udg_NaishaUnit,LESS_THAN_OR_EQUAL,200.)
    call TriggerRegisterUnitEvent(gg_trg_Naisha_Death,udg_NaishaUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Naisha_Wounded)
    call EnableTrigger(gg_trg_Naisha_AttackedRetreat)
    call EnableTrigger(gg_trg_Naisha_Death)
    set l_tempPoint=null
endfunction

function Trig_Naisha_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_NaishaUnit)
endfunction

function Trig_Naisha_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"Naisha is dead.")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Naisha|r")
    call QuestSetFailedBJ(udg_SideQuest[17],true)
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    call DisableTrigger(gg_trg_Naisha_ArriveLothlorien)
    call DestroyTrigger(gg_trg_Naisha_ArriveLothlorien)
    call DisableTrigger(gg_trg_Naisha_Heal)
    call DestroyTrigger(gg_trg_Naisha_Heal)
    call DisableTrigger(gg_trg_Naisha_Wounded)
    call DestroyTrigger(gg_trg_Naisha_Wounded)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Naisha_ArriveLothlorien_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_NaishaUnit)and(udg_InCinematicMode==false)and(udg_LothlorienOpen)
endfunction

function Trig_Naisha_ArriveLothlorien_Cond_DemonQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[6]))
endfunction

function Trig_Naisha_ArriveLothlorien_Filter_IsHero takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Naisha_ArriveLothlorien_Filter_IsPlayerUnit takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_Naisha_ArriveLothlorien_Filter_PlayerHero takes nothing returns boolean
    return GetBooleanAnd(Trig_Naisha_ArriveLothlorien_Filter_IsHero(),Trig_Naisha_ArriveLothlorien_Filter_IsPlayerUnit())
endfunction

function Trig_Naisha_ArriveLothlorien_Cond_ShowArrivalTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Naisha_ArriveLothlorien_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call SetUnitInvulnerable(udg_NaishaUnit,true)
    call DisableTrigger(gg_trg_Naisha_Death)
    call DestroyTrigger(gg_trg_Naisha_Death)
    call DisableTrigger(gg_trg_Naisha_Heal)
    call DestroyTrigger(gg_trg_Naisha_Heal)
    call DisableTrigger(gg_trg_Naisha_Wounded)
    call DestroyTrigger(gg_trg_Naisha_Wounded)
    if(Trig_Naisha_ArriveLothlorien_Cond_ShowArrivalTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_NaishaUnit,0)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Emns_0156,udg_NaishaUnit,0)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Etyr_0155,udg_NaishaUnit,0)
        call SetUnitFacingToFaceUnitTimed(udg_NaishaUnit,gg_unit_Etyr_0155,0)
        call Text_Say(gg_unit_Emns_0156,"Tell me, Galadriel, do you know this huntress?",false)
        call Text_Say(gg_unit_Etyr_0155,"I have never seen her before. And that is really strange because there are no other Night Elven settlements in this world.",false)
        call Text_Say(udg_NaishaUnit,"You are right, Lady. I come from another world and I am very happy to find my kin here.",false)
        call Text_Say(gg_unit_Emns_0156,"How did you come to be here?",false)
        call Text_Say(udg_NaishaUnit,"|n|cffffcc00Naisha tells Celeborn and Galadriel her story.|r",false)
        call Text_Say(gg_unit_Etyr_0155,"So, your world suffered much from Demons. We know much about them. We ourselves battled them a long time ago.",false)
        if(Trig_Naisha_ArriveLothlorien_Cond_DemonQuestDone())then
            call Text_Say(gg_unit_Emns_0156,"And one very strong demon, Hashmalum, is free and once again threatens us. We must not allow Demons to rampage in this world as they did in yours.",false)
        endif
        call Text_Say(gg_unit_Etyr_0155,"I am sorry but none of your fellow sisters came here. I suggest that they were transported to another worlds.",false)
        call Text_Say(udg_NaishaUnit,"I hope so.",false)
        call Text_Say(gg_unit_Etyr_0155,"If you wish, you can stay here with us, learn our ways and share your knowledge with our people. We would appreciate it if you do.",false)
        call Text_Say(udg_NaishaUnit,"Yes, I will do that.",false)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempGroup=Group_UnitsInRangeOfLoc(3000.,udg_TempPoint,Condition(function Trig_Naisha_ArriveLothlorien_Filter_PlayerHero))
        call RemoveLocation(udg_TempPoint)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Etyr_0155,GroupPickRandomUnit(udg_TempGroup),0)
        call DestroyGroup(udg_TempGroup)
        call Text_Say(gg_unit_Etyr_0155,"Human. You helped our sister reach this town. For that difficult feat you will be rewarded.",false)
        call Reward_Give($7D0,$5DC,gg_unit_Etyr_0155) // $7D0 = 2000; $5DC = 1500
        call SetUnitFacingTimed(gg_unit_Emns_0156,.0,0)
        call SetUnitFacingTimed(gg_unit_Etyr_0155,.0,0)
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$5DC,gg_unit_Etyr_0155) // $7D0 = 2000; $5DC = 1500
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_354)
    call SetUnitPositionLoc(udg_NaishaUnit,udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call SetUnitFacingToFaceUnitTimed(udg_NaishaUnit,gg_unit_e007_0154,0)
    call SetUnitOwner(udg_NaishaUnit,Player(9),true)
    set udg_NaishaTownUnit=udg_NaishaUnit
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Naisha|r")
    call QuestSetCompletedBJ(udg_SideQuest[17],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,$7F,udg_GameStateHash) // $7F = 127
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Naisha_Whirl_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A158') // 'A158': ability "Whirl"
endfunction

function Trig_Naisha_Whirl_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(15000.,1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A159',GetLastCreatedUnit()) // 'A159': ability "Whirl"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
    set l_tempPoint=null
endfunction

// World Editor calls InitTrig_Naisha automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Naisha (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Naisha takes nothing returns nothing
endfunction

function Register_Naisha_Init takes nothing returns nothing
    set gg_trg_Naisha_Init=CreateTrigger()
    call TriggerAddAction(gg_trg_Naisha_Init,function Trig_Naisha_Init_Actions)
endfunction

function Register_Naisha_Prepare takes nothing returns nothing
    set gg_trg_Naisha_Prepare=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_Prepare)
    call TriggerAddAction(gg_trg_Naisha_Prepare,function Trig_Naisha_Prepare_Actions)
endfunction

function Register_Naisha_Recruit takes nothing returns nothing
    set gg_trg_Naisha_Recruit=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_Recruit)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Naisha_Recruit,Player(7),true)
    call TriggerAddCondition(gg_trg_Naisha_Recruit,Condition(function Trig_Naisha_Recruit_Conditions))
    call TriggerAddAction(gg_trg_Naisha_Recruit,function Trig_Naisha_Recruit_Actions)
endfunction

function Register_Naisha_Wounded takes nothing returns nothing
    set gg_trg_Naisha_Wounded=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_Wounded)
    call TriggerRegisterUnitLifeEvent(gg_trg_Naisha_Wounded,gg_unit_ensh_0057,LESS_THAN_OR_EQUAL,200.)
    call TriggerAddCondition(gg_trg_Naisha_Wounded,Condition(function Trig_Naisha_Wounded_Conditions))
    call TriggerAddAction(gg_trg_Naisha_Wounded,function Trig_Naisha_Wounded_Actions)
endfunction

function Register_Naisha_AttackedRetreat takes nothing returns nothing
    set gg_trg_Naisha_AttackedRetreat=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_AttackedRetreat)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Naisha_AttackedRetreat,Player($A),EVENT_PLAYER_UNIT_ATTACKED) // $A = 10
    call TriggerAddCondition(gg_trg_Naisha_AttackedRetreat,Condition(function Trig_Naisha_AttackedRetreat_Conditions))
    call TriggerAddAction(gg_trg_Naisha_AttackedRetreat,function Trig_Naisha_AttackedRetreat_Actions)
endfunction

function Register_Naisha_Heal takes nothing returns nothing
    set gg_trg_Naisha_Heal=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_Heal)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Naisha_Heal,udg_NaishaHealTimer)
    call TriggerAddCondition(gg_trg_Naisha_Heal,Condition(function Trig_Naisha_Heal_Conditions))
    call TriggerAddAction(gg_trg_Naisha_Heal,function Trig_Naisha_Heal_Actions)
endfunction

function Register_Naisha_Death takes nothing returns nothing
    set gg_trg_Naisha_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_Death)
    call TriggerRegisterUnitEvent(gg_trg_Naisha_Death,gg_unit_ensh_0057,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Naisha_Death,Condition(function Trig_Naisha_Death_Conditions))
    call TriggerAddAction(gg_trg_Naisha_Death,function Trig_Naisha_Death_Actions)
endfunction

function Register_Naisha_ArriveLothlorien takes nothing returns nothing
    set gg_trg_Naisha_ArriveLothlorien=CreateTrigger()
    call DisableTrigger(gg_trg_Naisha_ArriveLothlorien)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Naisha_ArriveLothlorien,450.,gg_unit_Etyr_0155)
    call TriggerAddCondition(gg_trg_Naisha_ArriveLothlorien,Condition(function Trig_Naisha_ArriveLothlorien_Conditions))
    call TriggerAddAction(gg_trg_Naisha_ArriveLothlorien,function Trig_Naisha_ArriveLothlorien_Actions)
endfunction

function Register_Naisha_Whirl takes nothing returns nothing
    set gg_trg_Naisha_Whirl=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Naisha_Whirl,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Naisha_Whirl,Condition(function Trig_Naisha_Whirl_Conditions))
    call TriggerAddAction(gg_trg_Naisha_Whirl,function Trig_Naisha_Whirl_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Naisha takes nothing returns nothing
    call Register_Naisha_Init() // run by MapBootstrap
    call Register_Naisha_Prepare() // starts off; run by Cid, Mid
    call Register_Naisha_Recruit() // starts off; enabled by Naisha
    call Register_Naisha_Wounded() // starts off; enabled by Naisha; disabled by Naisha; destroyed by Naisha
    call Register_Naisha_AttackedRetreat() // starts off; enabled by Naisha; disabled by Naisha
    call Register_Naisha_Heal() // starts off; enabled by Naisha; disabled by Naisha; destroyed by Naisha
    call Register_Naisha_Death() // starts off; enabled by Naisha; disabled by Naisha; destroyed by Naisha
    call Register_Naisha_ArriveLothlorien() // starts off; enabled by Naisha; disabled by Naisha; destroyed by Naisha
    call Register_Naisha_Whirl()
endfunction

endlibrary

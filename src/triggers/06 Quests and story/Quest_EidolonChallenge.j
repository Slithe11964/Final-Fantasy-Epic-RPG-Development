library TQuestEidolonChallenge requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_EidolonChallenge_Start=null
    trigger gg_trg_Quest_EidolonChallenge_Count=null
    trigger gg_trg_Quest_EidolonChallenge_Complete=null
    // Variables only this module uses.
    integer udg_EidolonsDefeated=0
endglobals

function Trig_Quest_EidolonChallenge_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ocb2_0147,true,true,true))
endfunction

function Trig_Quest_EidolonChallenge_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_EidolonChallenge_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[52])
    if(Trig_Quest_EidolonChallenge_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Ocb2_0147,"Hey, you. Been talkin' with bro.",false)
        call Text_Say(gg_unit_Ocbh_0148,"This town's been seeing some pretty hefty attacks lately. Can see why ya recruited us.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, you've been a tremendous help.",false)
        call Text_Say(gg_unit_Ocbh_0148,"Well, we got an idea for you there.",false)
        call Text_Say(gg_unit_Ocb2_0147,"Bro and I were thinking we could have our friends help defend the gates. Our Eidolon friends.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"More defenders? That sounds great. You can call them over right away!",false)
        call Text_Say(gg_unit_Ocb2_0147,"Slow down there, mighty one.",false)
        call Text_Say(gg_unit_Ocb2_0147,"We already contacted all of them. But us Eidolons have our pride you know.",false)
        call Text_Say(gg_unit_Ocbh_0148,"We know you're very powerful, mighty ones, but our friends need to be convinced of that themselves!",false)
        call Text_Say(gg_unit_Ocb2_0147,"So if you want to have them help defend the gates, you'll have to beat them in battle like you did us. Should be simple right?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm, that sounds fair. Alright we'll beat them up and drag them over here then. Where can I find them?",false)
        call Text_Say(gg_unit_Ocb2_0147,"They're scattered around the world. Maybe you'll be able to tell where to find them when you hear a bit more.",false)
        call Text_Say(gg_unit_Ocb2_0147,"We've four friends we asked for this little idea: Titan, Leviathan, Pandemona and Typhon.",false)
        call Text_Say(gg_unit_Ocbh_0148,"Titan is a very old friend of ours. He's specialized on earth, just like we are. Even though he's an ogre, like Cyclops, his intelligence is quite something. Him and Cyclops aren't related to each other, by the way.",false)
        call Text_Say(gg_unit_Ocbh_0148,"Leviathan is an Eidolon we met by coincidence. Just when we were fighting some guy who wanted us as his servants, he appeared and blew that guy away. We complained at first, but we eventually became good friends. His element is Water, by the way.",false)
        call Text_Say(gg_unit_Ocbh_0148,"Pandemona and Typhon are the lords of wind. They're pretty famous in the world of the Eidolons, so it's nothing special we know them. They're great fighters and are good friends, so you'll likely find them together.",false)
        call Text_Say(gg_unit_Ocb2_0147,"And that's all you need to know. Good Luck!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Eidolon Challenge|r")
    set udg_SideQuest[32]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Eidolon Challenge"),"The Brothers, Sacred and Minotaur, have tasked you with beating up their friends, Titan, Leviathan, Pandemona and Typhon, to have them help defend Kalm. Find and defeat them all!","ReplaceableTextures\\WorldEditUI\\Editor-MultipleUnits.blp")
    set udg_QuestReq[3]=CreateQuestItemBJ(udg_SideQuest[32],"Eidolons defeated: 0/4")
    set udg_SpecialEffect[52]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ocb2_0147,"Objects\\RandomObject\\RandomObject.mdl")
    call ShowUnitShow(gg_unit_H01I_0070)
    call PauseUnitBJ(false,gg_unit_H01I_0070)
    call SetUnitInvulnerable(gg_unit_H01I_0070,false)
    call ShowUnitShow(gg_unit_H01J_0069)
    call PauseUnitBJ(false,gg_unit_H01J_0069)
    call SetUnitInvulnerable(gg_unit_H01J_0069,false)
    call ShowUnitShow(gg_unit_H01K_0068)
    call PauseUnitBJ(false,gg_unit_H01K_0068)
    call SetUnitInvulnerable(gg_unit_H01K_0068,false)
    call EnableTrigger(gg_trg_Eidolon_Found_Reveal)
    call EnableTrigger(gg_trg_Eidolon_Leviathan_Ambush)
    call EnableTrigger(gg_trg_Quest_EidolonChallenge_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsLeviathan takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01L_0067)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordB takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01K_0068)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordA takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01J_0069)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_IsTitan takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_H01I_0070)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_SiegeInProgress takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_AllyRangerGroup)==false)
endfunction

function Trig_Quest_EidolonChallenge_Count_Cond_AllEidolonsBeaten takes nothing returns boolean
    return(udg_EidolonsDefeated==4)
endfunction

function Trig_Quest_EidolonChallenge_Count_Actions takes nothing returns nothing
    call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    set udg_EidolonsDefeated=(udg_EidolonsDefeated+1)
    call QuestItemSetDescriptionBJ(udg_QuestReq[3],("Eidolons defeated: "+(I2S(udg_EidolonsDefeated)+"/4")))
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_Quest_EidolonChallenge_Count_Cond_IsTitan())then
        set udg_TempPoint=GetRectCenter(gg_rct_405)
    else
        if(Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordA())then
            set udg_TempPoint=GetRectCenter(gg_rct_407)
        else
            if(Trig_Quest_EidolonChallenge_Count_Cond_IsWindLordB())then
                set udg_TempPoint=GetRectCenter(gg_rct_369)
            else
                if(Trig_Quest_EidolonChallenge_Count_Cond_IsLeviathan())then
                    set udg_TempPoint=GetRectCenter(gg_rct_228)
                endif
            endif
        endif
    endif
    call ReviveHeroLoc(GetTriggerUnit(),udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitManaPercentBJ(GetTriggerUnit(),'d')
    call SetUnitFacingTimed(GetTriggerUnit(),GetUnitFacing(gg_unit_hhes_0087),0)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_RecruitedAllies)
    if(Trig_Quest_EidolonChallenge_Count_Cond_SiegeInProgress())then
        call ShowUnitHide(GetTriggerUnit())
    endif
    call SetUnitOwner(GetTriggerUnit(),Player(9),true)
    call UnitAddAbilityBJ('A0VJ',GetTriggerUnit()) // 'A0VJ': ability "Unaffected by Cinematics"
    call SetUnitInvulnerable(GetTriggerUnit(),true)
    call PauseUnitBJ(true,GetTriggerUnit())
    call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,GetTriggerUnit())
    if(Trig_Quest_EidolonChallenge_Count_Cond_AllEidolonsBeaten())then
        call DisableTrigger(GetTriggeringTrigger())
        call DisableTrigger(gg_trg_Eidolon_Found_Reveal)
        call DestroyTrigger(gg_trg_Eidolon_Found_Reveal)
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Come back to the Brothers for a reward.")
        call QuestSetDescriptionBJ(udg_SideQuest[32],"Come back to the Brothers for a reward.")
        call QuestItemSetCompletedBJ(udg_QuestReq[3],true)
        call DestroyEffectBJ(udg_SpecialEffect[52])
        set udg_SpecialEffect[52]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Ocb2_0147,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
        call EnableTrigger(gg_trg_Quest_EidolonChallenge_Complete)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_Quest_EidolonChallenge_Complete_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Ocb2_0147,true,true,true))
endfunction

function Trig_Quest_EidolonChallenge_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_EidolonChallenge_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[52])
    if(Trig_Quest_EidolonChallenge_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Good news, we succeded in defeating Titan, Typhon, Pandemona and Leviathan.",false)
        call Text_Say(gg_unit_Ocb2_0147,"Yeah, we know, they're right here.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh, right.",false)
        call Text_Say(gg_unit_Ocbh_0148,"You really are strong, o mighty one!",false)
        call Text_Say(gg_unit_Ocb2_0147,"Defending this town will be much easier now. Also have this, a token of our respect.",false)
        call Reward_Give($FA0,$FA0,gg_unit_Ocb2_0147) // $FA0 = 4000
        call Cine_ExitAction()
    else
        call Reward_Give($FA0,$FA0,gg_unit_Ocb2_0147) // $FA0 = 4000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Eidolon Challenge|r")
    call QuestSetCompletedBJ(udg_SideQuest[32],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,93,udg_GameStateHash)
    call SaveIntegerBJ(1,2,94,udg_GameStateHash)
    call SaveIntegerBJ(1,2,95,udg_GameStateHash)
    call SaveIntegerBJ(1,2,96,udg_GameStateHash)
    call StartTimerBJ(udg_SharedDelayTimer4,false,60.)
    call EnableTrigger(gg_trg_Brothers_Alert_Rematch)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_EidolonChallenge takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part11, RegisterTriggers_Quest_Part12 (module Quest),
// which keeps the original registration order.

function Register_Quest_EidolonChallenge_Start takes nothing returns nothing
    set gg_trg_Quest_EidolonChallenge_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_EidolonChallenge_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_EidolonChallenge_Start,Condition(function Trig_Quest_EidolonChallenge_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Start,function Trig_Quest_EidolonChallenge_Start_Actions)
endfunction

function Register_Quest_EidolonChallenge_Count takes nothing returns nothing
    set gg_trg_Quest_EidolonChallenge_Count=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_EidolonChallenge_Count)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01I_0070,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01J_0069,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01K_0068,EVENT_UNIT_DEATH)
    call TriggerRegisterUnitEvent(gg_trg_Quest_EidolonChallenge_Count,gg_unit_H01L_0067,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Count,function Trig_Quest_EidolonChallenge_Count_Actions)
endfunction

function Register_Quest_EidolonChallenge_Complete takes nothing returns nothing
    set gg_trg_Quest_EidolonChallenge_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_EidolonChallenge_Complete)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_EidolonChallenge_Complete,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_EidolonChallenge_Complete,Condition(function Trig_Quest_EidolonChallenge_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_EidolonChallenge_Complete,function Trig_Quest_EidolonChallenge_Complete_Actions)
endfunction

endlibrary

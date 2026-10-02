library TCid requires TBerserk, TCine, TGroup, TMusic, TPlayerPart01, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Cid_Talk_FindMid=null
    trigger gg_trg_Cid_Talk_MidReturned=null
    trigger gg_trg_Cid_Berserk_Start=null
    trigger gg_trg_Cid_Talk_Hashmalum=null
    trigger gg_trg_Cid_Berserk_Aggro=null
    trigger gg_trg_Cid_Berserk_End=null
    trigger gg_trg_Cid_Berserk_Revive=null
    trigger gg_trg_Cid_Berserk_Aftermath=null
    trigger gg_trg_Cid_Research_Done=null
    trigger gg_trg_Cid_Talk_AoMadoushi=null
endglobals

function Trig_Cid_Talk_FindMid_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_Cid_Talk_FindMid_FirstVisit takes nothing returns boolean
    return(udg_SpeedrunStarted==false)
endfunction

function Trig_Cid_Talk_FindMid_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_002,GetEnumPlayer(),0)
endfunction

function Trig_Cid_Talk_FindMid_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cid_Talk_FindMid_FadeUnit_Area1 takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),'d','d','d',0)
endfunction

function Trig_Cid_Talk_FindMid_WeakenUnit_Area1 takes nothing returns nothing
    call SetUnitLifePercentBJ(GetEnumUnit(),50.)
    // (maximum health of the unit being visited) divided by (2).
    call BlzSetUnitMaxHP(GetEnumUnit(),(BlzGetUnitMaxHP(GetEnumUnit())/ 2))
    call UnitAddAbilityBJ('A0ZU',GetEnumUnit()) // 'A0ZU': ability "Double Vulnerable"
    // Calculation 1:
    // (BlzGetUnitBaseDamage(the unit being visited, 0)) divided by (4).
    // Calculation 2:
    // (1) minus (1).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),0)/ 4),(1-1))
    // (BlzGetUnitBaseDamage(the unit being visited, 1)) divided by (4).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),1)/ 4),1)
    // (BlzGetUnitArmor(the unit being visited)) times (0.5).
    call BlzSetUnitArmor(GetEnumUnit(),(BlzGetUnitArmor(GetEnumUnit())*.5))
    call SetUnitVertexColorBJ(GetEnumUnit(),'d','d','d',0)
endfunction

function Trig_Cid_Talk_FindMid_ShouldWeaken_Area1 takes nothing returns boolean
    return(udg_EternityMode==false)
endfunction

function Trig_Cid_Talk_FindMid_FadeUnit_Area2 takes nothing returns nothing
    call SetUnitVertexColorBJ(GetEnumUnit(),'d','d','d',0)
endfunction

function Trig_Cid_Talk_FindMid_WeakenUnit_Area2 takes nothing returns nothing
    call SetUnitLifePercentBJ(GetEnumUnit(),50.)
    // (maximum health of the unit being visited) divided by (2).
    call BlzSetUnitMaxHP(GetEnumUnit(),(BlzGetUnitMaxHP(GetEnumUnit())/ 2))
    call UnitAddAbilityBJ('A0ZU',GetEnumUnit()) // 'A0ZU': ability "Double Vulnerable"
    // Calculation 1:
    // (BlzGetUnitBaseDamage(the unit being visited, 0)) divided by (4).
    // Calculation 2:
    // (1) minus (1).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),0)/ 4),(1-1))
    // (BlzGetUnitBaseDamage(the unit being visited, 1)) divided by (4).
    call BlzSetUnitBaseDamage(GetEnumUnit(),(BlzGetUnitBaseDamage(GetEnumUnit(),1)/ 4),1)
    // (BlzGetUnitArmor(the unit being visited)) times (0.5).
    call BlzSetUnitArmor(GetEnumUnit(),(BlzGetUnitArmor(GetEnumUnit())*.5))
    call SetUnitVertexColorBJ(GetEnumUnit(),'d','d','d',0)
endfunction

function Trig_Cid_Talk_FindMid_ShouldWeaken_Area2 takes nothing returns boolean
    return(udg_EternityMode==false)
endfunction

function Trig_Cid_Talk_FindMid_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[19])
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,bj_UNIT_FACING,0)
    if(Trig_Cid_Talk_FindMid_FirstVisit())then
        call ConditionalTriggerExecute(gg_trg_Speedrun_Announce)
    endif
    if(Trig_Cid_Talk_FindMid_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cid_Talk_FindMid_ApplyCamera)
        call Text_Say(gg_unit_Hpb1_0013,"Welcome to the town of Kalm!  My name is Cid, and I am the head of this community",false)
        call Text_Say(gg_unit_Hpb1_0013,"I hope you enjoy your stay, also, I have a favor to ask of you.",false)
        call Text_Say(gg_unit_Hpb1_0013,"My nephew Mid went on a research expedition to the Guardia Forest and hasn't come back yet. I am worried something happened to him, as he usually is not gone for so long.  If you go out there, could you look for him?",false)
        call Text_Say(gg_unit_Hpb1_0013,"If you decide to look, good luck and be careful, as the creatures in the forest have become very aggressive of late!",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Find Mid|r")
    set udg_MainQuest[1]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Find Mid","Cid asked you to look for his nephew Mid who went to Guardia Forest and did not come back.","ReplaceableTextures\\CommandButtons\\BTNArthas.blp")
    set udg_SpecialEffect[19]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Mid_Cage_Ping)
    set udg_CidQuestStage=1
    set udg_TempGroup=Group_UnitsInRectOfPlayer(gg_rct_662,Player($B)) // $B = 11
    if(Trig_Cid_Talk_FindMid_ShouldWeaken_Area1())then
        call ForGroupBJ(udg_TempGroup,function Trig_Cid_Talk_FindMid_WeakenUnit_Area1)
    else
        call ForGroupBJ(udg_TempGroup,function Trig_Cid_Talk_FindMid_FadeUnit_Area1)
    endif
    call DestroyGroup(udg_TempGroup)
    set udg_TempGroup=Group_UnitsInRectOfPlayer(gg_rct_183,Player($B)) // $B = 11
    if(Trig_Cid_Talk_FindMid_ShouldWeaken_Area2())then
        call ForGroupBJ(udg_TempGroup,function Trig_Cid_Talk_FindMid_WeakenUnit_Area2)
    else
        call ForGroupBJ(udg_TempGroup,function Trig_Cid_Talk_FindMid_FadeUnit_Area2)
    endif
    call DestroyGroup(udg_TempGroup)
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTg4_0005)
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTe2_0020)
    call ConditionalTriggerExecute(gg_trg_MysticalGlyph_Prepare)
    call ConditionalTriggerExecute(gg_trg_Frakir_ShowMarker)
    call ConditionalTriggerExecute(gg_trg_Shadow_FirstAppear)
    call ConditionalTriggerExecute(gg_trg_Quest_Shimmerweed_Offer)
    call ConditionalTriggerExecute(gg_trg_Quest_Arachnophobia_Offer)
    call ConditionalTriggerExecute(gg_trg_Naisha_Prepare)
    call ConditionalTriggerExecute(gg_trg_Valera_ShowMarker)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call Music_SetZoneTrack(1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cid_Talk_MidReturned_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Cid_Talk_MidReturned_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cid_Talk_MidReturned_HashmalumKnown_Intro takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Cid_Talk_MidReturned_Quest20Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_Cid_Talk_MidReturned_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cid_Talk_MidReturned_HashmalumKnown_Research takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Cid_Talk_MidReturned_Quest20NotDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Cid_Talk_MidReturned_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[19])
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
    call SetUnitFacingTimed(udg_Mid,280.,0)
    if(Trig_Cid_Talk_MidReturned_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cid_Talk_MidReturned_ApplyCamera)
        call Text_Say(gg_unit_Hpb1_0013,"Let me thank you for saving Mid. I am very grateful for what you have done. I will share some of my battle experience with you.",false)
        call Reward_Give(0,$3E8,gg_unit_Hpb1_0013) // $3E8 = 1000
        if(Trig_Cid_Talk_MidReturned_Quest20Discovered())then
            call Text_Say(udg_Mid,"However it seems that during the time I was captured something very horrible has happened.",false)
            call Text_Say(gg_unit_Hpb1_0013,"Yes, though we are not sure what has been going on ourselves.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It's, uh, a long story.",false)
            call Text_Say(gg_unit_Hpb1_0013,"I see, well I bid you the best of luck in it.",false)
            call Text_Say(udg_Mid,"Come talk to us when you can.",false)
        else
            if(Trig_Cid_Talk_MidReturned_HashmalumKnown_Intro())then
                call Text_Say(udg_Mid,"However it seems that during the time I was captured something very horrible has happened.",false)
                call Text_Say(gg_unit_Hpb1_0013,"Yes I'm sure you noticed it too. An incredibly dark voice suddenly rang out. Everyone in Kalm heard it. The speaker introduced themselves as Hashmalum.",false)
                call Text_Say(gg_unit_Hpb1_0013,"I have a very bad feeling about this Hashmalum. Mid, we will need to research to see if we can find some information on that name right away.",false)
                call Text_Say(udg_Mid,"Right you are, uncle.",false)
            else
                call Text_Say(udg_Mid,"However, we have something else to tell you and a new favor to ask. During my research in the Guardia Forest, I discovered some vital information.",false)
                call Text_Say(udg_Mid,"It seems that the recent growth and hostile behavior of the monsters is somehow connected to a mysterious artifact that appeared in the forest.",false)
                call Text_Say(udg_Mid,"I found a large, glowing stone in the forest and discovered that it changes the creatures in the area. Not only does it make them incredibly destructive, but it gives them incredible strength, speed, and some unusual abilities in certain cases.",false)
                call Text_Say(udg_Mid,"Before yesterday, I had never seen a wolf so savagely attack any human with such a horrible force.",false)
                call Text_Say(udg_Mid,"But the most frightening thing is that it seems that all monsters are controlled by some unknown entity. You know, Goblins and Gnolls usually hate each other and continuously fight amongst themselves. But now, they work together against us.",false)
                call Text_Say(udg_Mid,"Also, it was very surprising for me to discover that the forest monsters did not attack those bandits who captured me. It looks like all of them serve one master.",false)
                call Text_Say(gg_unit_Hpb1_0013,"All these events are very troubling. You know, I taught Mid how to sense magical energy being emitted from any item. It is a very important skill for an engineer in this world.",false)
                call Text_Say(udg_Mid,"Yes, and when I stumbled upon that artifact, I sensed immense power inside it. Unfortunately, I didn't have enough time to research the stone - I was attacked by bandits.  The Chieftain I saw later seemed to be in possession of the artifact.",false)
                call Text_Say(gg_unit_Hpb1_0013,"Well, you seem to be very capable of handling yourself in battle. Could you look for this artifact? With its horrible effects on the monsters, finding it is key. We would go ourselves, but we must stay to protect Kalm. Please, we need your help.",false)
                call Text_Say(gg_unit_Hpb1_0013,"If you feel you need some additional training you are welcome to fight in our Battle Arena. Please talk to our Jester on top of the hill in the northern part of town, he will teleport you there.",false)
            endif
        endif
        call Cine_ExitAction()
    else
        call Reward_Give(0,$3E8,gg_unit_Hpb1_0013) // $3E8 = 1000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Find Mid|r")
    call QuestSetCompletedBJ(udg_MainQuest[1],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Arena_Unlock)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    set udg_CidQuestStage=3
    if(Trig_Cid_Talk_MidReturned_Quest20NotDiscovered())then
        call Music_SetZoneTrack(2)
        if(Trig_Cid_Talk_MidReturned_HashmalumKnown_Research())then
            call StartTimerBJ(udg_CidResearchTimer,false,120.)
            call EnableTrigger(gg_trg_Cid_Research_Done)
            call SetUnitAnimation(gg_unit_Hpb1_0013,"channel")
            call SetUnitAnimation(udg_Mid,"channel")
            // Decrease udg_QuestsTotal by 2.
            set udg_QuestsTotal=(udg_QuestsTotal-2)
            call SaveIntegerBJ(1,2,97,udg_GameStateHash)
        else
            set udg_SpecialEffect[19]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Objects\\RandomObject\\RandomObject.mdl")
            set udg_MainQuest[2]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Find Artifact","Cid asked you to look for the mysterious artifact in the forest.","ReplaceableTextures\\CommandButtons\\BTNHeartOfSearinox.blp")
            call CreateNUnitsAtLoc(1,'ndtw',Player($B),GetRectCenter(gg_rct_198),.0) // 'ndtw': unit "Dark Goblin Chieftain"; $B = 11
            call GroupAddUnitSimple(GetLastCreatedUnit(),udg_QuestUnits)
            call TriggerRegisterUnitEvent(gg_trg_GoblinChief_Death,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
            call EnableTrigger(gg_trg_GoblinChief_Death)
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
            call Wait_Polled(4.)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Find Artifact|r")
        endif
    else
        set udg_CidQuestOnHold=true
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cid_Berserk_Start_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'sehr'))and(IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null // 'sehr': item "Mysterious Artifact"
endfunction

function Trig_Cid_Berserk_Start_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cid_Berserk_Start_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cid_Berserk_Start_SpawnBerserkGuard takes nothing returns nothing
    call ShowUnitHide(GetEnumUnit())
    call PauseUnitBJ(true,GetEnumUnit())
    set udg_TempPoint=GetUnitLoc(GetEnumUnit())
    call CreateNUnitsAtLoc(1,GetUnitTypeId(GetEnumUnit()),Player(9),udg_TempPoint,GetUnitFacing(GetEnumUnit()))
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BerserkGuards)
    call Unit_ScaleToLevel60(GetEnumUnit())
    call SetUnitInvulnerable(GetLastCreatedUnit(),false)
    call TriggerRegisterUnitEvent(gg_trg_BerserkGuard_Decay,GetLastCreatedUnit(),EVENT_UNIT_DECAY)
endfunction

function Trig_Cid_Berserk_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Artifact_Ping)
    call DisableTrigger(gg_trg_Artifact_Carrier)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sehr')) // 'sehr': item "Mysterious Artifact"
    call DestroyEffectBJ(udg_SpecialEffect[19])
    set udg_CidQuestStage=5
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
    call SetUnitFacingTimed(udg_Mid,280.,0)
    call CreateNUnitsAtLoc(1,'o000',Player(PLAYER_NEUTRAL_PASSIVE),GetRectCenter(gg_rct_413),bj_UNIT_FACING) // 'o000': unit "Zodiac Stone"
    set udg_ZodiacStone=GetLastCreatedUnit()
    if(Trig_Cid_Berserk_Start_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cid_Berserk_Start_ApplyCamera)
        call Text_Say(gg_unit_Hpb1_0013,"The artifact! Thank you for bringing this to us.",false)
        call Text_Say(gg_unit_Hpb1_0013,"Hmm... It would appear from the markings that this is the legendary Zodiac Stone. This is very interesting indeed.",false)
        call Text_Say(udg_Mid,"I always thought the story of the Zodiac stone was just a legend!",false)
        call Text_Say(udg_Mid,"Uncle, we should immediately start research to understand what we are dealing with.",false)
        set udg_SpecialEffect[19]=AddSpecialEffectLocBJ(GetUnitLoc(udg_ZodiacStone),"Abilities\\Spells\\Undead\\RegenerationAura\\ObsidianRegenAura.mdl")
        call Text_Say(gg_unit_Hpb1_0013,"Yes, of course...What !?",false)
        call Text_Say(udg_Mid,"Hey, what's going... The artifact... what is it...?",false)
        call DestroyEffectBJ(udg_SpecialEffect[19])
        call AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Hpb1_0013),"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_SpecialEffect[19]=AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Hpb1_0013),"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
        call SetUnitFacingToFaceUnitTimed(udg_Mid,gg_unit_Hpb1_0013,.1)
        call Text_Say(udg_Mid,"Uncle !? What's wrong with you?",false)
        call Text_Say(gg_unit_Hpb1_0013,"Mid...no, not that…err…AARRGGHH!!!",false)
        call DestroyEffectBJ(udg_SpecialEffect[19])
        call SetUnitInvulnerable(udg_Mid,false)
        call PauseUnitBJ(false,gg_unit_Hpb1_0013)
        call IssueTargetOrderBJ(gg_unit_Hpb1_0013,"attack",udg_Mid)
        call SetUnitTimeScalePercent(gg_unit_Hpb1_0013,10.)
        call SetUnitTimeScalePercent(udg_Mid,25.)
        call Wait_Polled(2)
        call SetUnitInvulnerable(udg_Mid,true)
        call SetUnitAnimation(udg_Mid,"death")
        call Wait_Polled(6.)
        call SetUnitTimeScalePercent(gg_unit_Hpb1_0013,100.)
        call SetUnitTimeScalePercent(udg_Mid,100.)
        call Cine_ExitAction()
    else
        call SetUnitAnimation(udg_Mid,"death")
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Find Artifact|r")
    call QuestSetCompletedBJ(udg_MainQuest[2],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call PauseUnitBJ(true,udg_Mid)
    call DestroyTrigger(gg_trg_Cid_Talk_Hashmalum)
    call Wait_Polled(1.)
    set udg_CidQuestStage=6
    set udg_MainQuest[3]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Stop Cid","Cid went berserk. Stop him.","ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Stop Cid|r")
    call SetUnitInvulnerable(gg_unit_Hpb1_0013,false)
    call SetUnitOwner(gg_unit_Hpb1_0013,Player($B),false) // $B = 11
    call Music_SetZoneTrack(3)
    call GroupAddUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    call EnableTrigger(gg_trg_Cid_Berserk_Aggro)
    call EnableTrigger(gg_trg_BerserkGuard_Decay)
    call EnableTrigger(gg_trg_Cid_Berserk_End)
    call EnableTrigger(gg_trg_Cid_Berserk_Revive)
    call ForGroupBJ(udg_KalmGuards,function Trig_Cid_Berserk_Start_SpawnBerserkGuard)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cid_Talk_Hashmalum_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Cid_Talk_Hashmalum_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cid_Talk_Hashmalum_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cid_Talk_Hashmalum_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Artifact_Ping)
    call DestroyEffectBJ(udg_SpecialEffect[19])
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
    call SetUnitFacingTimed(udg_Mid,280.,0)
    if(Trig_Cid_Talk_Hashmalum_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cid_Talk_Hashmalum_ApplyCamera)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"What just happened !?",false)
        call Text_Say(gg_unit_Hpb1_0013,"We know. Everyone in Kalm heard that voice.",false)
        call Text_Say(udg_Mid,"Hashmalum, he said he was called.",false)
        call Text_Say(gg_unit_Hpb1_0013,"I have a very bad feeling about this Hashmalum. Mid, we will need to research to see if we can find some information on that name right away.",false)
        call Text_Say(udg_Mid,"Right you are, uncle.",false)
        call Cine_ExitAction()
    endif
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Find Artifact|r")
    call QuestSetCompletedBJ(udg_MainQuest[2],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call StartTimerBJ(udg_CidResearchTimer,false,120.)
    call EnableTrigger(gg_trg_Cid_Research_Done)
    call SetUnitAnimation(gg_unit_Hpb1_0013,"channel")
    call SetUnitAnimation(udg_Mid,"channel")
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cid_Berserk_Aggro_Conditions takes nothing returns boolean
    return(GetAttacker()==gg_unit_Hpb1_0013)
endfunction

function Trig_Cid_Berserk_Aggro_Actions takes nothing returns nothing
    call IssueTargetOrderBJ(GroupPickRandomUnit(udg_BerserkGuards),"attack",gg_unit_Hpb1_0013)
endfunction

function Trig_Cid_Berserk_End_Conditions takes nothing returns boolean
    return(GetUnitStateSwap(UNIT_STATE_LIFE,gg_unit_Hpb1_0013)<=3000.)
endfunction

function Trig_Cid_Berserk_End_KillBerserkGuard takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Cid_Berserk_End_RestoreGuard takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Cid_Berserk_End_ShouldTrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Cid_Berserk_End_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Cid_Berserk_Revive)
    call DestroyTrigger(gg_trg_Cid_Berserk_Revive)
    call SetUnitInvulnerable(gg_unit_Hpb1_0013,true)
    call SetUnitOwner(gg_unit_Hpb1_0013,Player(9),true)
    call Berserk_Remove(GetTriggerUnit())
    call SetUnitLifePercentBJ(gg_unit_Hpb1_0013,'d')
    call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL,gg_unit_Hpb1_0013)
    call DisableTrigger(gg_trg_Cid_Berserk_Aggro)
    call DestroyTrigger(gg_trg_Cid_Berserk_Aggro)
    call DisableTrigger(gg_trg_BerserkGuard_Decay)
    call DestroyTrigger(gg_trg_BerserkGuard_Decay)
    call ForGroupBJ(udg_BerserkGuards,function Trig_Cid_Berserk_End_KillBerserkGuard)
    call GroupClear(udg_BerserkGuards)
    call ForGroupBJ(udg_KalmGuards,function Trig_Cid_Berserk_End_RestoreGuard)
    call DestroyGroup(udg_BerserkGuards)
    if(Trig_Cid_Berserk_End_ShouldTrackKill())then
        set udg_BossUnit=gg_unit_Hpb1_0013
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call ConditionalTriggerExecute(gg_trg_Cid_Berserk_Aftermath)
endfunction

function Trig_Cid_Berserk_Revive_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_Hpb1_0013,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call TriggerExecute(gg_trg_Cid_Berserk_End)
endfunction

function Trig_Cid_Berserk_Aftermath_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cid_Berserk_Aftermath_NoHashmalum takes nothing returns boolean
    return(udg_HashmalumStage<=0)
endfunction

function Trig_Cid_Berserk_Aftermath_Quest20Discovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20]))
endfunction

function Trig_Cid_Berserk_Aftermath_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cid_Berserk_Aftermath_Quest20NotDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[20])==false)
endfunction

function Trig_Cid_Berserk_Aftermath_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    call SetUnitPositionLoc(gg_unit_Hpb1_0013,GetRectCenter(gg_rct_116))
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
    set udg_CidQuestStage=7
    if(Trig_Cid_Berserk_Aftermath_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cid_Berserk_Aftermath_ApplyCamera)
        call Text_Say(gg_unit_Hpb1_0013,"My head…What!? I attacked you…and Mid!!?",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Hpb1_0013,udg_Mid,.1)
        call Text_Say(gg_unit_Hpb1_0013,"Oh no, Mid, what have I done !? Hold on, I'll heal you ...",false)
        call SetUnitAnimation(gg_unit_Hpb1_0013,"channel")
        call AddSpecialEffectTargetUnitBJ("chest",udg_Mid,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(1.5)
        call AddSpecialEffectTargetUnitBJ("chest",udg_Mid,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(1.5)
        call AddSpecialEffectTargetUnitBJ("chest",udg_Mid,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(1.5)
        call ResetUnitAnimation(gg_unit_Hpb1_0013)
        call Text_Say(gg_unit_Hpb1_0013,"Mid, are you alright…?",false)
        call Text_Say(udg_Mid,"Oh, my head...",false)
        call Text_Say(gg_unit_Hpb1_0013,"Thank the gods, you are ok!!!",false)
        call PauseUnitBJ(false,udg_Mid)
        call ResetUnitAnimation(udg_Mid)
        call SetUnitFacingToFaceUnitTimed(udg_Mid,gg_unit_Hpb1_0013,.1)
        call Text_Say(udg_Mid,"What happened, Uncle? It feels like someone bashed my skull with a hammer...",false)
        call Text_Say(gg_unit_Hpb1_0013,"Well, that is because I bashed you with my hammer. It seems that something made me attack everyone nearby, starting with you. I am truly sorry for that.",false)
        call Text_Say(gg_unit_Hpb1_0013,"But, thanks to our friends bashing MY head, I regained sanity!",false)
        call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
        call Text_Say(gg_unit_Hpb1_0013,"Thank you. Once again you help us through a most dire crisis. What atrocities would I have committed had you not stepped in? I fear to imagine how many people I could have….",false)
        call Text_Say(udg_Mid,"Well, it is good that everyone is OK, but why did this happen? What made you go berserk?",false)
        call SetUnitFacingTimed(udg_Mid,280.,0)
        if(Trig_Cid_Berserk_Aftermath_Quest20Discovered())then
            call Text_Say(udg_Mid,"Also where did the Zodiac Stone go?",false)
            call Text_Say(gg_unit_Hpb1_0013,"I'm not sure what happened... but all the power from the stone just disappeared, as did the stone itself.",false)
            call Text_Say(gg_unit_Hpb1_0013,"Well I'm sure the adventurers are handling it just fine. They're reliable allies the likes of which we haven't had in a long time.",false)
            call Text_Say(udg_Mid,"I suppose there's not much for us to do but wait for them.",false)
        else
            if(Trig_Cid_Berserk_Aftermath_NoHashmalum())then
                call Text_Say(gg_unit_Hpb1_0013,"I think it was the Stone. This may sound absurd, but I am sure that it was this artifact that affected me...",false)
                call Text_Say(udg_Mid,"I have a strange feeling you are right. But how do you know?",false)
                call Text_Say(gg_unit_Hpb1_0013,"The effect I experienced is similar to the one on the monsters in the forest.  Despite my desire to research this powerful stone, I must admit that this artifact is extremely dangerous and must be destroyed. Mid?",false)
                call Text_Say(udg_Mid,"Yes, Uncle, I agree, it is much too dangerous to handle.",false)
                call IssueTargetOrderBJ(udg_Mid,"attack",udg_ZodiacStone)
                call SetUnitAnimation(gg_unit_Hpb1_0013,"channel")
                call AddSpecialEffectLocBJ(GetUnitLoc(udg_ZodiacStone),"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call Wait_Polled(1.5)
                call AddSpecialEffectLocBJ(GetUnitLoc(udg_ZodiacStone),"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call Wait_Polled(1.5)
                call AddSpecialEffectLocBJ(GetUnitLoc(udg_ZodiacStone),"Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call Wait_Polled(1.5)
                call ResetUnitAnimation(gg_unit_Hpb1_0013)
                call PauseUnitBJ(false,gg_unit_Hpb1_0013)
                call IssueTargetOrderBJ(gg_unit_Hpb1_0013,"attack",udg_ZodiacStone)
                call Wait_Polled(3.)
                call IssueImmediateOrderBJ(udg_Mid,"stop")
                call IssueImmediateOrderBJ(gg_unit_Hpb1_0013,"stop")
                call SetUnitFacingTimed(udg_Mid,280.,0)
                call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
                call Text_Say(gg_unit_Hpb1_0013,"The gods...! Not even a scratch! I doubt this stone can be damaged by mortal hands.",false)
                call Text_Say(udg_Mid,"So, after all, we'll have to research it.",false)
                call Text_Say(gg_unit_Hpb1_0013,"We have no other choice, it seems. We must perceive this Stone as a threat and find out how to neutralize it.  Otherwise, we might find ourselves in a crisis beyond what we are seeing now.",false)
                call Text_Say(udg_Mid,"You're right, uncle, as always.",false)
                call Text_Say(gg_unit_Hpb1_0013,"Thank you for your help. We shall start researching the Zodiac Stone right now, and inform you if we find something important. Goodbye for now!",false)
                call Text_Say(udg_Mid,"Oh, before you go, please take this gold as a compensation for your time. We really appreciate what you have done.",false)
                call Reward_Give($5DC,$3E8,udg_Mid) // $5DC = 1500; $3E8 = 1000
            else
                call Text_Say(udg_Mid,"Also where did the Zodiac Stone go?",false)
                call Text_Say(gg_unit_Hpb1_0013,"It seems the Zodiac Stone was no mere artifact, but instead a prison housing a demon. It seems it was that demon's mind controlling abilities that affected me.",false)
                call Text_Say(gg_unit_Hpb1_0013,"And just now the demon used the confusion I caused to break free. I am deeply ashamed I let this happen.",false)
                call Text_Say(udg_Mid,"Don't be silly, uncle. If there was a demon in this stone then we wouldn't have stood a chance at preventing him from breaking out.",false)
                call Text_Say(gg_unit_Hpb1_0013,"Thank you Mid. But now we have this demon to contend with. He introduced himself as Hashmalum.",false)
                call Text_Say(udg_Mid,"Hashmalum... I suppose we should research that name right away then.",false)
                call Text_Say(gg_unit_Hpb1_0013,"Right you are, Mid.",false)
            endif
        endif
        call Cine_ExitAction()
    else
        call Reward_Give($5DC,$3E8,udg_Mid) // $5DC = 1500; $3E8 = 1000
    endif
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Cid Went Berserk And Regained Sanity|r"
    set udg_NewsText[4]="Cid went berserk and attacked his nephew - and the adventurers. Thanks to them, however, he regained sanity. What was that? Cid and Mid are now researching."
    call QuestSetCompletedBJ(udg_MainQuest[3],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    if(Trig_Cid_Berserk_Aftermath_Quest20NotDiscovered())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Stop Cid|r")
        call StartTimerBJ(udg_CidResearchTimer,false,60.)
        call EnableTrigger(gg_trg_Cid_Research_Done)
        call SetUnitAnimation(gg_unit_Hpb1_0013,"channel")
        call SetUnitAnimation(udg_Mid,"channel")
        call Music_SetZoneTrack(4)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cid_Research_Done_CidVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)
endfunction

function Trig_Cid_Research_Done_Actions takes nothing returns nothing
    if(Trig_Cid_Research_Done_CidVisible())then
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffCid and Mid have something to tell you !!!|r")
        call PlaySoundBJ(gg_snd_UtherTaunt2)
    endif
    call UnitRemoveTypeBJ(UNIT_TYPE_PEON,udg_Mid)
    call GroupAddUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    set udg_SpecialEffect[20]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call ResetUnitAnimation(gg_unit_Hpb1_0013)
    call ResetUnitAnimation(udg_Mid)
    set udg_CidQuestStage=8
    call EnableTrigger(gg_trg_Cid_Talk_AoMadoushi)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Cid_Talk_AoMadoushi_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hpb1_0013,true,true,true))
endfunction

function Trig_Cid_Talk_AoMadoushi_ApplyCamera takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_001,GetEnumPlayer(),0)
endfunction

function Trig_Cid_Talk_AoMadoushi_HashmalumKnown_Intro takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Cid_Talk_AoMadoushi_HashmalumKnown_Hint takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Cid_Talk_AoMadoushi_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Cid_Talk_AoMadoushi_HashmalumKnown_Quest takes nothing returns boolean
    return(udg_HashmalumStage>0)
endfunction

function Trig_Cid_Talk_AoMadoushi_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[20])
    call GroupRemoveUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    call SetUnitFacingTimed(gg_unit_Hpb1_0013,260.,0)
    call SetUnitFacingTimed(udg_Mid,280.,0)
    set udg_CidQuestStage=9
    if(Trig_Cid_Talk_AoMadoushi_CinematicsOn())then
        call Cine_Enter()
        call ForForce(udg_PlayingPlayers,function Trig_Cid_Talk_AoMadoushi_ApplyCamera)
        if(Trig_Cid_Talk_AoMadoushi_HashmalumKnown_Intro())then
            call Text_Say(gg_unit_Hpb1_0013,"Hello again. Well, we have made some research about this Hashmalum.",false)
            call Text_Say(udg_Mid,"Unfortunately our information on him and demons in general are very scarce. But we did find out who knows more about them and could help us in this plight.",false)
        else
            call Text_Say(gg_unit_Hpb1_0013,"Hello again. Well, we have made some research about Zodiac Stone and we have very important information about it.",false)
            call Text_Say(udg_Mid,"We have discovered that Zodiac Stone holds incredible power. And this power is being actively used. I can sense a powerful magical storm raging inside the Stone.",false)
            call Text_Say(gg_unit_Hpb1_0013,"We suspect that the Stone is actually a prison of some sort that is holding a powerful entity inside. The magic storm that rages inside the stone most likely indicates that a prisoner is trying to break through the defense of the Stone and free himself.",false)
            call Text_Say(gg_unit_Hpb1_0013,"Now I think that trying to destroy the Stone was not a good idea. Who knows what power will be released when the stone is shattered? If the monster uprising was enforced by an imprisoned entity then we will have *huge* problems when it gets free.",false)
            call Text_Say(gg_unit_Hpb1_0013,"I think that the magic that affected my mind was produced by that power inside the Zodiac Stone that is now struggling to gain freedom. I am sure it wasn't just a backslash of a magical storm inside the stone, but a targeted assault on my mind.",false)
            call Text_Say(gg_unit_Hpb1_0013,"The success of the creature's actions show that it is very close to breaking free and already has some control over our world. Mindless creeps and weak-willed bandits were first to succumb to the creature's will. And even I, despite my mental training, was affected with the spell.",false)
            call Text_Say(udg_Mid,"Yes, the source of danger is not the Stone itself but an entity that is imprisoned within it. If we would have simply destroyed the Stone then we might have brought great perils on ourselves.",false)
            call Text_Say(gg_unit_Hpb1_0013,"As you may have heard, both I and Mid are outsiders to this world, just like you. We came here long time ago and spent long time researching Gaya but our knowledge is limited.",false)
            call Text_Say(udg_Mid,"We need the help of a person who is familiar with ancient legends of this land. We asked Elves but they too know very little about Stone. But they told us that a hermit lives somewhere nearby who is the last known descendant of proud people that inhabited this land long before Elves came here from ",false)
        endif
        call Text_Say(gg_unit_Hpb1_0013,"His name is Ao Madoushi and Elves say that he shares mystical connection with the beats of the wild. He is definitely an outstanding person from what I've heard of him.",false)
        call Text_Say(udg_Mid,"He was the one who taught Elves how to properly enchant the Wall to protect the town against the Great Winter. He is probably very old now. One of the reasons I went to the Guardia Forest was to find him and ask him what he knows about the monster breakout.",false)
        call Text_Say(udg_Mid,"However, I could not find him. As it turns out, he had left an artifact with us humans to call him if we ever need his aid again: Eiko's Flute. When I learned this I turned back around to find those who are now in possession of this flute.",false)
        call Text_Say(udg_Mid,"I failed and got captured but you saved me. And now I think that it is you who will have to find this mysterious person.",false)
        call Text_Say(gg_unit_Hpb1_0013,"The ones holding onto Eiko's Flute are members of the Hunt Club, Reno and Rude. They travel around a lot as they relay messages for the club. They're not in this town at this moment. I will mark their current locations on your map.",false)
        if(Trig_Cid_Talk_AoMadoushi_HashmalumKnown_Hint())then
            call Text_Say(udg_Mid,"Once you have the flute, you need only find the hermit. He is said to live near the forest, but not in it. Summon him and ask him about Hashmalum. And please hurry - I am afraid to imagine what happens this demon has gathered back enough of his energy.",false)
        else
            call Text_Say(udg_Mid,"Once you have the flute, you need only find the hermit. He is said to live near the forest, but not in it. Summon him and ask him about the Zodiac Stone. And please hurry - I am afraid to imagine what happens if the creature inside the Stone breaks free.",false)
        endif
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Ao Madoushi|r")
    if(Trig_Cid_Talk_AoMadoushi_HashmalumKnown_Quest())then
        call CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Ao Madoushi","Cid and Mid told you about the mysterious hermit who may know something about the demon Hashmalum. You must find him, but in order to call for his aid, Eiko's Flute is required. Find Reno and Rude, the Turks, to obtain it.","ReplaceableTextures\\CommandButtons\\BTNThrall.blp")
    else
        call CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cffff8040Ao Madoushi","Cid and Mid told you about the mysterious hermit who may know something about the Zodiac Stone and the entity that is imprisoned inside the Stone. You must find him, but in order to call for his aid, Eiko's Flute is required. Find Reno and Rude, the Turks, to obtain it.","ReplaceableTextures\\CommandButtons\\BTNThrall.blp")
    endif
    set udg_MainQuest[4]=GetLastCreatedQuestBJ()
    set udg_QuestMarkerEffect[2]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n012_0163,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    set udg_QuestMarkerEffect[3]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n013_0164,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call GroupAddUnitSimple(gg_unit_n012_0163,udg_QuestUnits)
    call GroupAddUnitSimple(gg_unit_n013_0164,udg_QuestUnits)
    call EnableTrigger(gg_trg_Turks_Give_Flute)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n0B5',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n0B5': unit "Angry Wolf"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n0B5',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n0B5': unit "Angry Wolf"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n0B4',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n0B4': unit "Big Wolf"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n0B4',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n0B4': unit "Big Wolf"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
    call CreateNUnitsAtLoc(1,'n0B4',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n0B4': unit "Big Wolf"; $B = 11
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call ConditionalTriggerExecute(gg_trg_Quest_KillSetag_Offer)
    call ConditionalTriggerExecute(gg_trg_Quest_Caravan_SamAvailable)
    call ConditionalTriggerExecute(gg_trg_Quest_KillElmdor_Available)
    call ConditionalTriggerExecute(gg_trg_Quest_DeliverLetter_Available)
    call ConditionalTriggerExecute(gg_trg_Quest_Beastslayer_Available)
    call ConditionalTriggerExecute(gg_trg_Monica_ShowMarker)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call Music_SetZoneTrack(5)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Cid automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Cid_Part1 / RegisterTriggers_Cid_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Cid takes nothing returns nothing
endfunction

function Register_Cid_Talk_FindMid takes nothing returns nothing
    set gg_trg_Cid_Talk_FindMid=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_FindMid,Player(7),true)
    call TriggerAddCondition(gg_trg_Cid_Talk_FindMid,Condition(function Trig_Cid_Talk_FindMid_Conditions))
    call TriggerAddAction(gg_trg_Cid_Talk_FindMid,function Trig_Cid_Talk_FindMid_Actions)
endfunction

function Register_Cid_Talk_MidReturned takes nothing returns nothing
    set gg_trg_Cid_Talk_MidReturned=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Talk_MidReturned)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Cid_Talk_MidReturned,450.,gg_unit_Hpb1_0013)
    call TriggerAddCondition(gg_trg_Cid_Talk_MidReturned,Condition(function Trig_Cid_Talk_MidReturned_Conditions))
    call TriggerAddAction(gg_trg_Cid_Talk_MidReturned,function Trig_Cid_Talk_MidReturned_Actions)
endfunction

function Register_Cid_Berserk_Start takes nothing returns nothing
    set gg_trg_Cid_Berserk_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Berserk_Start)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Cid_Berserk_Start,450.,gg_unit_Hpb1_0013)
    call TriggerAddCondition(gg_trg_Cid_Berserk_Start,Condition(function Trig_Cid_Berserk_Start_Conditions))
    call TriggerAddAction(gg_trg_Cid_Berserk_Start,function Trig_Cid_Berserk_Start_Actions)
endfunction

function Register_Cid_Talk_Hashmalum takes nothing returns nothing
    set gg_trg_Cid_Talk_Hashmalum=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Talk_Hashmalum)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Cid_Talk_Hashmalum,450.,gg_unit_Hpb1_0013)
    call TriggerAddCondition(gg_trg_Cid_Talk_Hashmalum,Condition(function Trig_Cid_Talk_Hashmalum_Conditions))
    call TriggerAddAction(gg_trg_Cid_Talk_Hashmalum,function Trig_Cid_Talk_Hashmalum_Actions)
endfunction

function Register_Cid_Berserk_Aggro takes nothing returns nothing
    set gg_trg_Cid_Berserk_Aggro=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Berserk_Aggro)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cid_Berserk_Aggro,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Cid_Berserk_Aggro,Condition(function Trig_Cid_Berserk_Aggro_Conditions))
    call TriggerAddAction(gg_trg_Cid_Berserk_Aggro,function Trig_Cid_Berserk_Aggro_Actions)
endfunction

function Register_Cid_Berserk_End takes nothing returns nothing
    set gg_trg_Cid_Berserk_End=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Berserk_End)
    call TriggerRegisterUnitEvent(gg_trg_Cid_Berserk_End,gg_unit_Hpb1_0013,EVENT_UNIT_DAMAGED)
    call TriggerAddCondition(gg_trg_Cid_Berserk_End,Condition(function Trig_Cid_Berserk_End_Conditions))
    call TriggerAddAction(gg_trg_Cid_Berserk_End,function Trig_Cid_Berserk_End_Actions)
endfunction

function Register_Cid_Berserk_Revive takes nothing returns nothing
    set gg_trg_Cid_Berserk_Revive=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Berserk_Revive)
    call TriggerRegisterUnitEvent(gg_trg_Cid_Berserk_Revive,gg_unit_Hpb1_0013,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Cid_Berserk_Revive,function Trig_Cid_Berserk_Revive_Actions)
endfunction

function Register_Cid_Berserk_Aftermath takes nothing returns nothing
    set gg_trg_Cid_Berserk_Aftermath=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Berserk_Aftermath)
    call TriggerAddAction(gg_trg_Cid_Berserk_Aftermath,function Trig_Cid_Berserk_Aftermath_Actions)
endfunction

function Register_Cid_Research_Done takes nothing returns nothing
    set gg_trg_Cid_Research_Done=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Research_Done)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Cid_Research_Done,udg_CidResearchTimer)
    call TriggerAddAction(gg_trg_Cid_Research_Done,function Trig_Cid_Research_Done_Actions)
endfunction

function Register_Cid_Talk_AoMadoushi takes nothing returns nothing
    set gg_trg_Cid_Talk_AoMadoushi=CreateTrigger()
    call DisableTrigger(gg_trg_Cid_Talk_AoMadoushi)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Cid_Talk_AoMadoushi,Player(7),true)
    call TriggerAddCondition(gg_trg_Cid_Talk_AoMadoushi,Condition(function Trig_Cid_Talk_AoMadoushi_Conditions))
    call TriggerAddAction(gg_trg_Cid_Talk_AoMadoushi,function Trig_Cid_Talk_AoMadoushi_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Cid_Part1 takes nothing returns nothing
    call Register_Cid_Talk_FindMid() // disabled by Mid; destroyed by Mid
    call Register_Cid_Talk_MidReturned() // starts off; enabled by Mid
    call Register_Cid_Berserk_Start() // starts off; enabled by Artifact; disabled by Cine, TrueIceAge; destroyed by Cine, TrueIceAge
    call Register_Cid_Talk_Hashmalum() // starts off; enabled by Cine; destroyed by Cid
    call Register_Cid_Berserk_Aggro() // starts off; enabled by Cid; disabled by Cid; destroyed by Cid
    call Register_Cid_Berserk_End() // starts off; enabled by Cid; run by Cid, Cine, TrueIceAge
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Cid_Part2 takes nothing returns nothing
    call Register_Cid_Berserk_Revive() // starts off; enabled by Cid; disabled by Cid; destroyed by Cid
    call Register_Cid_Berserk_Aftermath() // starts off; run by Cid
    call Register_Cid_Research_Done() // starts off; enabled by Cid; disabled by TrueIceAge
    call Register_Cid_Talk_AoMadoushi() // starts off; enabled by Cid; disabled by TrueIceAge
endfunction

endlibrary

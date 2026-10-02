library TBossZalera requires TCam, TCine, TGroup, TLink, TMusic, TPlayerHero, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Zalera_Intro=null
    trigger gg_trg_Boss_Zalera_Death=null
endglobals

function Trig_Boss_Zalera_Intro_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Boss_Zalera_Intro_IsGafgarionDead takes nothing returns boolean
    return(udg_ZaleraStage==3)
endfunction

function Trig_Boss_Zalera_Intro_KillGhost takes nothing returns nothing
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Boss_Zalera_Intro_IsGafgarionAlly takes nothing returns boolean
    return(udg_ZaleraStage==4)
endfunction

function Trig_Boss_Zalera_Intro_HasGafgarionReturned takes nothing returns boolean
    return(udg_ZaleraStage==4)
endfunction

function Trig_Boss_Zalera_Intro_ShowZaleraScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Zalera_Intro_IsGafgarionGuarding takes nothing returns boolean
    return(udg_ZaleraStage==4)
endfunction

function Trig_Boss_Zalera_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Zalera_Intro_IsGafgarionDead())then
        set udg_ZaleraStage=4
    endif
    set udg_TempGroup=Group_UnitsOfPlayerAndType(Player(8),'u00D') // 'u00D': unit "Death Ghost"
    call ForGroupBJ(udg_TempGroup,function Trig_Boss_Zalera_Intro_KillGhost)
    call DestroyGroup(udg_TempGroup)
    call GroupRemoveUnitSimple(gg_unit_U000_0248,udg_QuestUnits)
    call DisableTrigger(gg_trg_Ghost_Despawn)
    call DestroyTrigger(gg_trg_Ghost_Despawn)
    if(Trig_Boss_Zalera_Intro_ShowZaleraScene())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_U000_0248,0)
        call Wait_Polled(1.)
        call SetUnitVertexColorBJ(gg_unit_U000_0248,25.,25.,25.,25.)
        call Wait_Polled(1.)
        call SetUnitVertexColorBJ(gg_unit_U000_0248,50.,50.,50.,.0)
        call Wait_Polled(1.)
        call ResetUnitAnimation(gg_unit_U000_0248)
        call Wait_Polled(2)
        call Text_Transmission(gg_unit_U000_0248,"Mysterious Demon","Returned... at last...","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"What the !? Who are you?",false)
        call Text_Transmission(gg_unit_U000_0248,"Mysterious Demon","Hmm... so you've slain our knight. This is a troublesome situation. I need to join back up with the others, but...","(null)",null,0,false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Are you another one of the Zodiac Braves?",false)
        call Text_Transmission(gg_unit_U000_0248,"Mysterious Demon","That I am. Zalera is my name. I am the one who reigns over Death.","(null)",null,0,false)
        call Text_Say(gg_unit_U000_0248,"I see you've been blessed by this world with a Spirit of Gaya... you are not under my domain.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Not under your domain? Well definitely not! If you're another demon you're our enemy.",false)
        call Text_Say(gg_unit_U000_0248,"Hmm, hmm, this is quite a troublesome situation.",false)
        if(Trig_Boss_Zalera_Intro_HasGafgarionReturned())then
            call Text_Say(udg_StoryBoss,"Fear not, Zalera.",false)
            call ShowUnitShow(udg_StoryBoss)
            call PauseUnitBJ(true,udg_StoryBoss)
            call Wait_Polled(1.)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"What the... we just beat you!",false)
            call Text_Say(gg_unit_U000_0248,"My my, I'd almost forgotten what a tough cookie you are.",false)
            call Text_Say(udg_StoryBoss,"I know whose side I'm on in this war. And I can't just fail you. Not again.",false)
            call Text_Say(gg_unit_U000_0248,"You're still feeling guilt... well, no time for chitchat. For now, I'm glad to have you here. Let's show these outsiders the power of the Zodiac Braves!",false)
            call Text_Say(udg_StoryBoss,"You will not harm Zalera so long as I'm standing here!",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Damn it... this will be rough. Let's go!",false)
        else
            call Text_Say(gg_unit_U000_0248,"Nonetheless, I will do as I must. The cold hands of the underworld shall be your demise.",false)
        endif
        call Cine_ExitAction()
    else
        call SetUnitVertexColorBJ(gg_unit_U000_0248,50.,50.,50.,.0)
        call ResetUnitAnimation(gg_unit_U000_0248)
        if(Trig_Boss_Zalera_Intro_IsGafgarionAlly())then
            call ShowUnitShow(udg_StoryBoss)
        endif
    endif
    if(Trig_Boss_Zalera_Intro_IsGafgarionGuarding())then
        call PauseUnitBJ(false,udg_StoryBoss)
        call SetUnitInvulnerable(udg_StoryBoss,false)
        call SetUnitLifePercentBJ(udg_StoryBoss,100.)
        call UnitAddAbilityBJ('A0SJ',gg_unit_U000_0248) // 'A0SJ': ability "Dispel"
        call UnitRemoveAbilityBJ('A0VL',gg_unit_U000_0248) // 'A0VL': ability "Scourge"
        call UnitAddAbilityBJ('A0X2',gg_unit_U000_0248) // 'A0X2': ability "Perma Cover"
        call Link_SaveCaster(udg_StoryBoss,gg_unit_U000_0248,.0)
        call GroupAddUnitSimple(udg_StoryBoss,udg_QuestUnits)
        call TriggerRegisterUnitEvent(gg_trg_Boss_Gafgarion_Guard_Death,udg_StoryBoss,EVENT_UNIT_DEATH)
        call EnableTrigger(gg_trg_Boss_Gafgarion_Guard_Death)
    else
        call GroupAddUnitSimple(gg_unit_U000_0248,udg_QuestUnits)
        call EnableTrigger(gg_trg_Boss_Zalera_Death)
    endif
    call PauseUnitBJ(false,gg_unit_U000_0248)
    call SetUnitInvulnerable(gg_unit_U000_0248,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_U000_0248) // 'A0VJ': ability "Unaffected by Cinematics"
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Destroy Zalera, the Zodiac Brave of Death.")
    call QuestSetDescriptionBJ(udg_MainQuest[7],"Destroy Zalera, the Zodiac Brave of Death.")
    call Music_SetTrack($D) // $D = 13
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Zalera_Death_IsKillLogEnabled takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Zalera_Death_IsHeroSlain takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Zalera_Death_RollEther takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Zalera_Death_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Zalera_Death_CameraOnCouncilScene takes nothing returns nothing
    call CameraSetupApplyForPlayer(true,gg_cam_006,GetEnumPlayer(),0)
endfunction

function Trig_Boss_Zalera_Death_MetGafgarion takes nothing returns boolean
    return(udg_ZaleraStage<20)
endfunction

function Trig_Boss_Zalera_Death_ShowLothlorienScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Zalera_Death_WasDarkKnightQuest takes nothing returns boolean
    return(udg_ZaleraStage<20)
endfunction

function Trig_Boss_Zalera_Death_IsHardMode takes nothing returns boolean
    return(udg_HardMode)
endfunction

function Trig_Boss_Zalera_Death_IsCidVisible takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_Hpb1_0013)==false)
endfunction

function Trig_Boss_Zalera_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Zalera_Death_IsKillLogEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[1]=true
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Zalera_Death_IsHeroSlain())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call GroupRemoveUnitSimple(gg_unit_U000_0248,udg_QuestUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I039',udg_TempPoint) // 'I039': item "Death Skull"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    call CreateItemLoc('I067',udg_TempPoint) // 'I067': item "Death Seeker"
    if(Trig_Boss_Zalera_Death_RollEther())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    if(Trig_Boss_Zalera_Death_ShowLothlorienScene())then
        call Cam_PanToUnit(gg_unit_U000_0248,0)
        call Cine_Enter()
        if(Trig_Boss_Zalera_Death_KilledByPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(gg_unit_U000_0248,"Damn it... sorry my bretheren... I'll have to retire...",false)
        call Text_Say(udg_CinematicActor,"He's gone...",false)
        call Text_Say(udg_CinematicActor,"But still, this is bad... at this rate we'll have an entire legion of demons coming in. We'll need to report to Celeborn right away.",false)
        call Music_ClearTrack($D) // $D = 13
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
        call Wait_Polled(1.5)
        call ForForce(udg_PlayingPlayers,function Trig_Boss_Zalera_Death_CameraOnCouncilScene)
        call Text_Say(null,"Back in Lothlorien...",false)
        call Wait_Polled(.5)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,0,0)
        call Wait_Polled(1.5)
        call Text_Say(gg_unit_Etyr_0155,"You've fought well. We've been watching your fight through scrying.",false)
        call Text_Say(udg_CinematicActor,"So you saw that demon that appeared? Who was he?",false)
        call Text_Say(gg_unit_Emns_0156,"That was Zalera, the Zodiac Brave of Death. He is not one to usually fight on the front lines. Taking him out now is a great success. You are powerful fighters indeed.",false)
        call Text_Say(udg_CinematicActor,"You seem to know more about what's going on. Who are these Zodiac Braves? Is that Belias another one?",false)
        call Text_Say(gg_unit_Etyr_0155,"The Zodiac Braves are a legion of 12 demons that had conquered Gaya and reigned over it as despots long ago. They bent the entire world to their will.",false)
        call Text_Say(gg_unit_Etyr_0155,"100 years ago, we rose up against them. Not in battle, of course, they were far too powerful for that. But we managed to seal away their most crucial members: Hashmalum, the Zodiac Brave of Earth, who acts as their leader, and Ultima, the Zodiac Brave of Holy, who acts as their enforcer.",false)
        call Text_Say(gg_unit_Emns_0156,"With the two of them out of the picture, the others dispersed. Even demons are nothing but cowards when they don't hold the upper hand.",false)
        call Text_Say(udg_CinematicActor,"I see. But that means we may yet be facing 12 powerful demons very soon! That's not good news at all.",false)
        call Text_Say(gg_unit_Emns_0156,"You have already defeated two. Zalera has been banished, and we heard you also took down Cúchulainn?",false)
        call Text_Say(udg_CinematicActor,"That big ugly blob? Yeah we killed him. Are you telling me he was also a Zodiac Brave?",false)
        call Text_Say(gg_unit_Etyr_0155,"Yes, the Zodiac Brave of Poison. But it seems he went mad and lost much of his power in the last century.",false)
        if(Trig_Boss_Zalera_Death_MetGafgarion())then
            call Text_Say(udg_CinematicActor,"What about that Gafgarion?",false)
            call Text_Say(gg_unit_Emns_0156,"He is an outsider like you and once fought by our side. But the influence of the demons made him fall to the dark side. Unfortunately I doubt this will be the last we see of him. He is nothing if not tenacious.",false)
        endif
        call Text_Say(gg_unit_Etyr_0155,"Regardless, there are still 10 Zodiac Braves remaining. With Hashmalum back, I doubt they will bide their time for long. If they are not stopped, they will surely enact vengeance on us and take back the entire world.",false)
        call Text_Say(udg_CinematicActor,"We can't let that happen. We'll stop Hashmalum.",false)
        call Text_Say(gg_unit_Etyr_0155,"Unfortunately, our scouts still haven't located Hashmalum. We need more time. But don't mistake the goal here. We can't stop at Hashmalum this time.",false)
        call Text_Say(gg_unit_Emns_0156,"Galadriel is right. Even if we take down Hashmalum, the other Zodiac Braves will have nothing to lose. They will surely wreak havoc until we've hunted down every last one of them.",false)
        call Text_Say(udg_CinematicActor,"I see. Then we'll have to find and destroy them all.",false)
        call Text_Say(gg_unit_Etyr_0155,"Yes, there's no other way. Leave Hashmalum to us for now. We will call on you once we have further clues as to his whereabouts. Meanwhile I'm sure the other Zodiac Braves aren't going to lay around waiting. Watch your back, and may Gaya protect your soul.",false)
        call Reward_Give(4500,$FA0,gg_unit_Etyr_0155) // $FA0 = 4000
        call Text_Say(gg_unit_Etyr_0155,"|n|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(4500,$FA0,gg_unit_Etyr_0155) // $FA0 = 4000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00A new artifact is available for buying at the Ancient of Wonders.|r")
        call Music_ClearTrack($D) // $D = 13
    endif
    call SaveIntegerBJ(1,2,92,udg_GameStateHash)
    call EnableTrigger(gg_trg_DeathSeeker_Give)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call AddItemToStockBJ('I03I',gg_unit_n00L_0153,1,1) // 'I03I': item "Growth Egg"
    if(Trig_Boss_Zalera_Death_WasDarkKnightQuest())then
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Dark Knight|r")
    else
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Necrophobe|r")
    endif
    call QuestSetCompletedBJ(udg_MainQuest[7],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_MainQuest[8]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleColor+"World Liberation"),"The war against the 12 Zodiac Braves has begun! Return Gaya to the hands of humans and night elves and destroy the demonic usurpers.","ReplaceableTextures\\CommandButtons\\BTNArchimonde.blp")
    set udg_QuestReq[4]=CreateQuestItemBJ(udg_MainQuest[8],("Zodiac Braves defeated: "+(I2S(udg_BravesDefeated)+"/12")))
    if(Trig_Boss_Zalera_Death_IsHardMode())then
        call StartTimerBJ(udg_KalmSiegeTimer,false,90.)
    else
        call StartTimerBJ(udg_KalmSiegeTimer,false,480.)
    endif
    call EnableTrigger(gg_trg_Celeborn_Summon_Alert)
    call Wait_Polled(4.)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00World Liberation|r")
    call Wait_Polled(15.)
    if(Trig_Boss_Zalera_Death_IsCidVisible())then
        call DisplayTextToForce(GetPlayersAll(),"|cffff0000Cid is sending out an emergency distress signal !!!|r")
        call PlaySoundBJ(gg_snd_HornOfCenariusSound)
        set udg_TempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
        call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,5.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
        call RemoveLocation(udg_TempPoint)
    endif
    call GroupAddUnitSimple(gg_unit_Hpb1_0013,udg_QuestUnits)
    set udg_SpecialEffect[30]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hpb1_0013,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_KalmSiege1_Start)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Kalm under siege!|r"
    set udg_NewsText[4]="Our town is currently under siege! Meliadoul and Cid wish to publicly urge everyone to please, if they know any powerful allies, to help recruit them for the cause of defending our city!"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Zalera takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part1 (module Boss),
// which keeps the original registration order.

function Register_Boss_Zalera_Intro takes nothing returns nothing
    set gg_trg_Boss_Zalera_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Zalera_Intro)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Zalera_Intro,200.,gg_unit_U000_0248)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Zalera_Intro,500.,gg_unit_U000_0248)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Zalera_Intro,700.,gg_unit_U000_0248)
    call TriggerAddCondition(gg_trg_Boss_Zalera_Intro,Condition(function Trig_Boss_Zalera_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Zalera_Intro,function Trig_Boss_Zalera_Intro_Actions)
endfunction

function Register_Boss_Zalera_Death takes nothing returns nothing
    set gg_trg_Boss_Zalera_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Zalera_Death)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Zalera_Death,gg_unit_U000_0248,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Zalera_Death,function Trig_Boss_Zalera_Death_Actions)
endfunction

endlibrary

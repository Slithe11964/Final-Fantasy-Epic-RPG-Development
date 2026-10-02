library TBossHashmalum requires TCam, TCine, TLoc, TMusic, TPlayerHero, TReward, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Hashmalum_Intro=null
    trigger gg_trg_Boss_Hashmalum_Revive_Belias=null
    trigger gg_trg_Boss_Hashmalum_Revive_Loop=null
    trigger gg_trg_Boss_Hashmalum_Death_Final=null
endglobals

function Trig_Boss_Hashmalum_Intro_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Boss_Hashmalum_Intro_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Hashmalum_Intro_Cond_QuestNotDiscovered takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[18])==false)
endfunction

function Trig_Boss_Hashmalum_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Hashmalum_Intro_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call SetUnitAnimation(gg_unit_E002_0075,"stand alternate")
        call Cam_PanToUnit(gg_unit_E002_0075,0)
        call Text_Say(gg_unit_E002_0075,"So you have made it here after all.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's right. We've come to stop your nefarious plans once and for all!",false)
        call SetUnitFacingToFaceUnitTimed(gg_unit_E002_0075,GetTriggerUnit(),.0)
        call Text_Say(gg_unit_E002_0075,"You're too late. The summoning is already well underway. The mighty Echele will soon descend on this plane.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Then we'll just need to destroy your demon gate before he can get through!",false)
        call Text_Say(gg_unit_E002_0075,"Do not underestimate the power of the Zodiac Braves. I may be weakened right now, but my latent power is more than enough to strike you down here, once and for all.",false)
        call Text_Say(gg_unit_E002_0075,"Prepare to die, mortal !",false)
        call Cine_ExitAction()
    else
        call SetUnitAnimation(gg_unit_E002_0075,"stand alternate")
        call SetUnitFacingToFaceUnitTimed(gg_unit_E002_0075,GetTriggerUnit(),.0)
    endif
    call SetUnitInvulnerable(gg_unit_E002_0075,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_E002_0075) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,gg_unit_E002_0075)
    set udg_HashmalumEncountered=true
    call StartTimerBJ(udg_JobLevelTimer,false,.01)
    call EnableTrigger(gg_trg_Boss_Hashmalum_Revive_Belias)
    call Music_ClearTrack(19)
    if(Trig_Boss_Hashmalum_Intro_Cond_QuestNotDiscovered())then
        set udg_MainQuest[18]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleColor+"End of Zodiac Age"),"Hashmalum, the Zodiac Brave of Earth and leader of all Zodiac Braves, is summoning a calamity. Take him down before the summoning finishes!","ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp")
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00End of Zodiac Age|r")
        call Music_SetTrack(16)
    else
        call Music_SetTrack($F) // $F = 15
    endif
    call DestroyTrigger(gg_trg_Ambush_Skeletons_1)
    call DestroyTrigger(gg_trg_Ambush_Skeletons_2)
    call DestroyTrigger(gg_trg_Ambush_Skeletons_3)
    call DestroyTrigger(gg_trg_Ambush_Skeletons_4)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Hashmalum_Revive_Belias_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Hashmalum_Revive_Belias_Cond_MateusAlive takes nothing returns boolean
    return(udg_MateusDefeated==false)
endfunction

function Trig_Boss_Hashmalum_Revive_Belias_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_E002_0075,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_E002_0075,true)
    if(Trig_Boss_Hashmalum_Revive_Belias_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_E002_0075,0)
        call Text_Say(gg_unit_E002_0075,"Your power is vast, mortal, but your struggles are meaningless. This is but a fraction of what the Zodiac Braves are capable of.",false)
        call SetUnitAnimation(gg_unit_E002_0075,"stand ready alternate")
        call Text_Say(gg_unit_E002_0075,"Come to my aid, Belias!",false)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,0)
        call RemoveLocation(udg_TempPoint)
        call SetUnitPositionLoc(gg_unit_Uwar_0192,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Uwar_0192,gg_unit_E002_0075,.0)
        call PauseUnitBJ(true,gg_unit_Uwar_0192)
        call Wait_Polled(3.)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Undead\\DarkSummoning\\DarkSummonMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call ShowUnitShow(gg_unit_Uwar_0192)
        call SetUnitAnimation(gg_unit_E002_0075,"stand alternate")
        call Wait_Polled(3.)
        call Text_Say(gg_unit_Uwar_0192,"I am here, master.",false)
        call Text_Say(gg_unit_Uwar_0192,"I will not let you die.",false)
        call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_E002_0075,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_E002_0075,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
        call Wait_Polled(2)
        call ResetUnitAnimation(gg_unit_Uwar_0192)
        call Text_Say(gg_unit_E002_0075,"Now, Belias! Let us take down these wretched humans once and for all!",false)
        call Cine_ExitAction()
    else
        call PauseUnitBJ(true,gg_unit_E002_0075)
        call SetUnitLifeBJ(GetTriggerUnit(),1.)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,-200.,0)
        call RemoveLocation(udg_TempPoint)
        call SetUnitPositionLoc(gg_unit_Uwar_0192,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        call SetUnitFacingToFaceUnitTimed(gg_unit_Uwar_0192,gg_unit_E002_0075,.0)
        call PauseUnitBJ(true,gg_unit_Uwar_0192)
        call ShowUnitShow(gg_unit_Uwar_0192)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Undead\\DarkSummoning\\DarkSummonMissile.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
        call Wait_Polled(1.)
        call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
        call Wait_Polled(1.)
        call ResetUnitAnimation(gg_unit_Uwar_0192)
        call PauseUnitBJ(false,gg_unit_E002_0075)
    endif
    call SetUnitInvulnerable(gg_unit_E002_0075,false)
    call PauseUnitBJ(false,gg_unit_Uwar_0192)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,false)
    call EnableTrigger(gg_trg_Boss_Hashmalum_Revive_Loop)
    call EnableTrigger(gg_trg_Boss_Belias_Rescue_Gafgarion)
    if(Trig_Boss_Hashmalum_Revive_Belias_Cond_MateusAlive())then
        call EnableTrigger(gg_trg_Boss_Belias_Rescue_Mateus)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Hashmalum_Revive_Loop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_E002_0075,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitLifeBJ(GetTriggerUnit(),1.)
    call PauseUnitBJ(true,gg_unit_Uwar_0192)
    call PauseUnitBJ(true,gg_unit_E002_0075)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,true)
    call SetUnitInvulnerable(gg_unit_E002_0075,true)
    call SetUnitFacingToFaceUnitTimed(gg_unit_Uwar_0192,gg_unit_E002_0075,.0)
    call SetUnitAnimation(gg_unit_Uwar_0192,"spell slam")
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_E002_0075,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_E002_0075,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(1.)
    call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
    call Wait_Polled(1.)
    call ResetUnitAnimation(gg_unit_Uwar_0192)
    call PauseUnitBJ(false,gg_unit_Uwar_0192)
    call PauseUnitBJ(false,gg_unit_E002_0075)
    call SetUnitInvulnerable(gg_unit_E002_0075,false)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,false)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_TrackKill takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_RandomHalf_NoCine takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Hashmalum_Death_Final_Enum_ShakeCamera takes nothing returns nothing
    call CameraSetSourceNoiseForPlayer(GetEnumPlayer(),30.,.3)
    call CameraSetEQNoiseForPlayer(GetEnumPlayer(),5.)
endfunction

function Trig_Boss_Hashmalum_Death_Final_Enum_ClearCameraNoise takes nothing returns nothing
    call CameraClearNoiseForPlayer(GetEnumPlayer())
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_RandomHalf takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_PlayerMissingCredit takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[$F])==false) // $F = 15
endfunction

function Trig_Boss_Hashmalum_Death_Final_Enum_CreditPlayer takes nothing returns nothing
    if(Trig_Boss_Hashmalum_Death_Final_Cond_PlayerMissingCredit())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=$F // $F = 15
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Boss_Hashmalum_Death_Final_Cond_ShopAvailable takes nothing returns boolean
    return(IsUnitHiddenBJ(gg_unit_n00L_0153)==false)
endfunction

function Trig_Boss_Hashmalum_Death_Final_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Hashmalum_Death_Final_Cond_TrackKill())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    set udg_BossDefeated[7]=true
    call Music_ClearTrack($F) // $F = 15
    call Music_ClearTrack(16)
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Hashmalum_Death_Final_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    if(Trig_Boss_Hashmalum_Death_Final_Cond_CinematicsEnabled())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_E002_0075,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call Cine_Enter()
        call SetUnitAnimation(gg_unit_E002_0075,"death alternate")
        call Cam_PanToUnit(gg_unit_E002_0075,0)
        call Text_Say(null,"|n|cffffcc00All players get 9999 gold and 9999 exp.|r",true)
        call Text_Say(gg_unit_E002_0075,"Ugh...",false)
        if(Trig_Boss_Hashmalum_Death_Final_Cond_KillerIsPlayer())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        else
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        endif
        call Text_Say(Player_GetHero(udg_TempPlayer),"Enough! This is your last breath, demon!",false)
        call Text_Say(gg_unit_E002_0075,"Haha... don't tell me... have you forgotten already?",false)
        call Text_Say(gg_unit_E002_0075,"Our goal in this fight was not to defeat you... merely to stop you from destroying this demon gate before the summoning was complete.",false)
        call Text_Say(gg_unit_E002_0075,"And now it is...",false)
        call Text_Transmission(gg_unit_E002_0075,"Hashmalum","And now it is...\r\nCome forth into this world, Lord of Ice, Echele!","And now it is...",null,0,false)
        call Cam_PanToUnit(gg_unit_ndmg_0124,.5)
        call ForForce(udg_PlayingPlayers,function Trig_Boss_Hashmalum_Death_Final_Enum_ShakeCamera)
        call Text_Say(Player_GetHero(udg_TempPlayer),"What !?",false)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,2.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(.5)
        set udg_TempPoint=GetRectCenter(gg_rct_578)
        call CreateNUnitsAtLoc(1,'N08G',Player(8),udg_TempPoint,225.) // 'N08G': unit "Ice Demon"
        call RemoveLocation(udg_TempPoint)
        set udg_CinematicActor=GetLastCreatedUnit()
        call SetUnitPathing(udg_CinematicActor,false)
        set udg_TempPoint=GetRectCenter(gg_rct_579)
        call IssuePointOrderLocBJ(udg_CinematicActor,"move",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',60.)
        call Wait_Polled(.5)
        call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',40.)
        call Wait_Polled(.5)
        call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',20.)
        call Wait_Polled(.5)
        call SetUnitVertexColorBJ(udg_CinematicActor,'d','d','d',.0)
        call Wait_Polled(1.5)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,.0,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(1.)
        call ForForce(udg_PlayingPlayers,function Trig_Boss_Hashmalum_Death_Final_Enum_ClearCameraNoise)
        call Cam_PanToUnit(gg_unit_E002_0075,0)
        call SetUnitAnimation(gg_unit_E002_0075,"dissipate alternate")
        call SetUnitTimeScalePercent(gg_unit_E002_0075,.0)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint2=GetRectCenter(gg_rct_579)
        set udg_TempReal=AngleBetweenPoints(udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,256,udg_TempReal)
        call SetUnitPositionLocFacingLocBJ(udg_CinematicActor,udg_TempPoint2,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call Wait_Polled(1.)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(2.)
        call Text_Say(gg_unit_E002_0075,"Lord Echele, you've come.",false)
        call Text_Say(udg_CinematicActor,"Zodiac Brave, I have heard your call.",false)
        call Text_Say(udg_CinematicActor,"My daughter told me about the situation. So it really has come to this.",false)
        call Text_Say(gg_unit_E002_0075,"Yes. It's time to reduce this world to ice.",false)
        call Text_Say(gg_unit_E002_0075,"Take all of our power. All that is left of it.",false)
        call Text_Say(udg_CinematicActor,"So I shall, King of Gaya.",false)
        call SetUnitAnimation(udg_CinematicActor,"stand channel")
        call SetUnitTimeScalePercent(gg_unit_E002_0075,50.)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_E002_0075,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_E002_0075,"Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(2)
        call AddSpecialEffectTargetUnitBJ("origin",udg_CinematicActor,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call ResetUnitAnimation(udg_CinematicActor)
        call ShowUnitHide(gg_unit_E002_0075)
        call Wait_Polled(1.)
        call Text_Say(udg_CinematicActor,"I can feel the power of the Zodiac Braves, their hearts beating as one. I will heed your will, and return this world to one of ice.",false)
        set udg_TempPoint=GetRectCenter(gg_rct_645)
        call IssuePointOrderLocBJ(udg_CinematicActor,"move",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(1.5)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I0KZ',udg_TempPoint) // 'I0KZ': item "Gaya's Rod"
        call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
        if(Trig_Boss_Hashmalum_Death_Final_Cond_RandomHalf())then
            call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
        else
            call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
        endif
        call RemoveLocation(udg_TempPoint)
        call KillUnit(gg_unit_E002_0075)
        call KillUnit(udg_CinematicActor)
        call RemoveUnit(udg_CinematicActor)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN,1.,"ReplaceableTextures\\CameraMasks\\White_mask.blp",0,0,100.,0)
        call Wait_Polled(1.5)
        call Text_Say(Player_GetHero(udg_TempPlayer),"This is bad... very bad. If he has absorbed the powers of the Zodiac Braves, this demon lord possesses more than enough power to destroy this world.",false)
        call Text_Say(Player_GetHero(udg_TempPlayer),"Hmm, but the Zodiac Braves weren't at their full power anymore. We defeated some of them. We may still stand a chance.",false)
        call Reward_Give(9999,9999,null)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateItemLoc('I0KZ',udg_TempPoint) // 'I0KZ': item "Gaya's Rod"
        call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
        if(Trig_Boss_Hashmalum_Death_Final_Cond_RandomHalf_NoCine())then
            call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
        else
            call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
        endif
        call RemoveLocation(udg_TempPoint)
        call Reward_Give(9999,9999,gg_unit_E002_0075)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00End of Zodiac Age|r")
    call QuestSetCompletedBJ(udg_MainQuest[18],true)
    call SaveIntegerBJ(1,2,1,udg_GameStateHash)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call ForForce(udg_PlayingPlayers,function Trig_Boss_Hashmalum_Death_Final_Enum_CreditPlayer)
    set udg_MainQuest[19]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestTitleColor+"Advent of Ice Age"),"The demon lord Echele has been summoned. He has absorbed the power of all the Zodiac Braves and is intending on turning the world to ice. Face him atop the Snowy Mountain.","ReplaceableTextures\\CommandButtons\\BTNBlueMagnataur.blp")
    call ConditionalTriggerExecute(gg_trg_Dwarves_Disappear)
    call RemoveUnit(udg_StoryBoss)
    set udg_GafgarionRevived=true
    set udg_TempPoint=GetRectCenter(gg_rct_574)
    call ConditionalTriggerExecute(gg_trg_Spawn_Gafgarion)
    call RemoveLocation(udg_TempPoint)
    call GroupAddUnitSimple(udg_StoryBoss,udg_QuestUnits)
    call SetUnitFacingTimed(udg_StoryBoss,90.,0)
    call PauseUnitBJ(true,udg_StoryBoss)
    call IssueImmediateOrderBJ(udg_StoryBoss,"holdposition")
    call SetUnitInvulnerable(udg_StoryBoss,true)
    set udg_SpecialEffect[43]=AddSpecialEffectTargetUnitBJ("overhead",udg_StoryBoss,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Gafgarion_Join_Party)
    call Music_SetZoneTrack($B) // $B = 11
    call Wait_Polled(4.)
    call RemoveUnit(gg_unit_E002_0075)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Advent of Ice Age|r")
    call CreateFogModifierRectBJ(true,Player($B),FOG_OF_WAR_VISIBLE,gg_rct_658) // $B = 11
    call Wait_Polled(300.)
    if(Trig_Boss_Hashmalum_Death_Final_Cond_ShopAvailable())then
        call DisplayTextToForce(GetPlayersAll(),"|cff00ffffA new artifact is available for buying at the Ancient of Wonders !!|r")
    endif
    call AddItemToStockBJ('I0CS',gg_unit_n00L_0153,1,1) // 'I0CS': item "Life Staff"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Hashmalum takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part6 (module Boss),
// which keeps the original registration order.

function Register_Boss_Hashmalum_Intro takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Intro)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Boss_Hashmalum_Intro,700.,gg_unit_E002_0075)
    call TriggerAddCondition(gg_trg_Boss_Hashmalum_Intro,Condition(function Trig_Boss_Hashmalum_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Intro,function Trig_Boss_Hashmalum_Intro_Actions)
endfunction

function Register_Boss_Hashmalum_Revive_Belias takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Revive_Belias=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Revive_Belias)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Hashmalum_Revive_Belias,gg_unit_E002_0075,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Revive_Belias,function Trig_Boss_Hashmalum_Revive_Belias_Actions)
endfunction

function Register_Boss_Hashmalum_Revive_Loop takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Revive_Loop=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Revive_Loop)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Hashmalum_Revive_Loop,gg_unit_E002_0075,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Revive_Loop,function Trig_Boss_Hashmalum_Revive_Loop_Actions)
endfunction

function Register_Boss_Hashmalum_Death_Final takes nothing returns nothing
    set gg_trg_Boss_Hashmalum_Death_Final=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Hashmalum_Death_Final)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Hashmalum_Death_Final,gg_unit_E002_0075,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Hashmalum_Death_Final,function Trig_Boss_Hashmalum_Death_Final_Actions)
endfunction

endlibrary

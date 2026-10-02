library TBossBelias requires TCam, TCine, TLink, TPlayerPart01, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Belias_Rescue_Mateus=null
    trigger gg_trg_Boss_Belias_Revive_Loop=null
    trigger gg_trg_Boss_Belias_Rescue_Gafgarion=null
    trigger gg_trg_Boss_Belias_Gafgarion_Death=null
    trigger gg_trg_Boss_Belias_Death_Final=null
endglobals

function Trig_Boss_Belias_Rescue_Mateus_Conditions takes nothing returns boolean
    return(udg_MateusDefeated==false)
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Cond_DemesneDead_Silent takes nothing returns boolean
    return(IsUnitDeadBJ(gg_unit_U00M_0206))
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Cond_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Cond_DemesneDead takes nothing returns boolean
    return(IsUnitDeadBJ(gg_unit_U00M_0206))
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_A takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_B takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_C takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_D takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_E takes nothing returns nothing
    call RemoveDestructable(GetEnumDestructable())
endfunction

function Trig_Boss_Belias_Rescue_Mateus_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Boss_Mateus_Intro)
    call DisableTrigger(gg_trg_Boss_Mateus_Death)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_Uwar_0192,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_E002_0075,true)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,true)
    call SetUnitInvulnerable(gg_unit_U00L_0207,true)
    call SetUnitInvulnerable(gg_unit_U00M_0206,true)
    call UnitAddAbilityBJ('A0MS',gg_unit_U00L_0207) // 'A0MS': ability "Unstealable"
    call UnitRemoveAbilityBJ('A0X2',gg_unit_U00M_0206) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_U00M_0206) // 'B064': buff "Perma Cover"
    call UnitRemoveAbilityBJ('A12C',gg_unit_U00L_0207) // 'A12C': ability "!Raise"
    call PauseUnitBJ(true,gg_unit_U00M_0206)
    call SetUnitLifePercentBJ(gg_unit_U00L_0207,'d')
    call SetUnitLifePercentBJ(gg_unit_U00M_0206,'d')
    if(Trig_Boss_Belias_Rescue_Mateus_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Uwar_0192,0)
        call Text_Say(null,"Enough of this.",false)
        if(Trig_Boss_Belias_Rescue_Mateus_Cond_KillerIsPlayer())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        else
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        endif
        call Text_Say(Player_GetHero(udg_TempPlayer),"Who's there!?",false)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,200.,-100.)
        call SetUnitPositionLocFacingLocBJ(gg_unit_U00L_0207,udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,50.,200.)
        if(Trig_Boss_Belias_Rescue_Mateus_Cond_DemesneDead())then
            call ReviveHeroLoc(gg_unit_U00M_0206,udg_TempPoint,false)
            call SetUnitInvulnerable(gg_unit_U00M_0206,true)
            call PauseUnitBJ(true,gg_unit_U00M_0206)
        else
            call SetUnitPositionLocFacingLocBJ(gg_unit_U00M_0206,udg_TempPoint2,udg_TempPoint)
            call ShowUnitShow(gg_unit_U00M_0206)
        endif
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00L_0207,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_U00M_0206,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Wait_Polled(2.)
        call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
        call Text_Say(gg_unit_Uwar_0192,"Thank you for showing up, Mateus.",false)
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call Text_Say(gg_unit_U00L_0207,"I promised we would shield you here after all. Couldn't just let these people go behind our backs like that.",false)
        call Text_Say(gg_unit_U00M_0206,"We don't like having invaders move around these parts ourselves.",false)
        call Text_Say(gg_unit_Uwar_0192,"Reliable as always. You've done tremendous work. Now let's push them back!",false)
        call Cine_ExitAction()
    else
        call PauseUnitBJ(true,gg_unit_Uwar_0192)
        call PauseUnitBJ(true,gg_unit_E002_0075)
        call PauseUnitBJ(true,gg_unit_U00L_0207)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,400.,-100.)
        call SetUnitPositionLocFacingLocBJ(gg_unit_U00L_0207,udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,50.,200.)
        if(Trig_Boss_Belias_Rescue_Mateus_Cond_DemesneDead_Silent())then
            call ReviveHeroLoc(gg_unit_U00M_0206,udg_TempPoint,false)
            call SetUnitInvulnerable(gg_unit_U00M_0206,true)
            call PauseUnitBJ(true,gg_unit_U00M_0206)
        else
            call SetUnitPositionLocFacingLocBJ(gg_unit_U00M_0206,udg_TempPoint2,udg_TempPoint)
            call ShowUnitShow(gg_unit_U00M_0206)
        endif
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
        call Wait_Polled(1.)
        call PauseUnitBJ(false,gg_unit_Uwar_0192)
        call PauseUnitBJ(false,gg_unit_E002_0075)
    endif
    call SetUnitInvulnerable(gg_unit_Uwar_0192,false)
    call SetUnitInvulnerable(gg_unit_E002_0075,false)
    call SetUnitInvulnerable(gg_unit_U00L_0207,false)
    call SetUnitInvulnerable(gg_unit_U00M_0206,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_U00L_0207) // 'A0VJ': ability "Unaffected by Cinematics"
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_U00M_0206) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,gg_unit_U00L_0207)
    call PauseUnitBJ(false,gg_unit_U00M_0206)
    call SetUnitAcquireRangeBJ(gg_unit_U00L_0207,2560.)
    call SetUnitAcquireRangeBJ(gg_unit_U00M_0206,2560.)
    call UnitAddAbilityBJ('A0ZR',gg_unit_U00M_0206) // 'A0ZR': ability "Immortal"
    call EnableTrigger(gg_trg_Boss_Demesne_CoverSwap)
    call EnableTrigger(gg_trg_Boss_Mateus_CoverSwap)
    call EnableTrigger(gg_trg_Boss_Belias_Revive_Loop)
    call EnableTrigger(gg_trg_Boss_Mateus_Death_Final)
    call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_LTg2_0021)
    call EnumDestructablesInRectAll(gg_rct_494,function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_A)
    call EnumDestructablesInRectAll(gg_rct_495,function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_B)
    call EnumDestructablesInRectAll(gg_rct_666,function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_C)
    call EnumDestructablesInRectAll(gg_rct_667,function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_D)
    call EnumDestructablesInRectAll(gg_rct_668,function Trig_Boss_Belias_Rescue_Mateus_Enum_ClearRubble_E)
    call DisableTrigger(gg_trg_Gate_WinterKey_Unlock)
    call DestroyTrigger(gg_trg_Gate_WinterKey_Unlock)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Belias_Revive_Loop_Conditions takes nothing returns boolean
    return(udg_MateusDefeated==false)
endfunction

function Trig_Boss_Belias_Revive_Loop_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_Uwar_0192,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitLifeBJ(GetTriggerUnit(),1.)
    call PauseUnitBJ(true,gg_unit_Uwar_0192)
    call PauseUnitBJ(true,gg_unit_E002_0075)
    call PauseUnitBJ(true,gg_unit_U00L_0207)
    call SetUnitInvulnerable(gg_unit_U00L_0207,true)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,true)
    call SetUnitInvulnerable(gg_unit_E002_0075,true)
    call SetUnitFacingToFaceUnitTimed(gg_unit_U00L_0207,gg_unit_Uwar_0192,.0)
    call SetUnitAnimation(gg_unit_U00L_0207,"spell slam")
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectTargetUnitBJ("origin",gg_unit_Uwar_0192,"Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call Wait_Polled(1.)
    call SetUnitLifePercentBJ(gg_unit_Uwar_0192,'d')
    call Wait_Polled(1.)
    call ResetUnitAnimation(gg_unit_U00L_0207)
    call PauseUnitBJ(false,gg_unit_Uwar_0192)
    call PauseUnitBJ(false,gg_unit_E002_0075)
    call PauseUnitBJ(false,gg_unit_U00L_0207)
    call SetUnitInvulnerable(gg_unit_U00L_0207,false)
    call SetUnitInvulnerable(gg_unit_E002_0075,false)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,false)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Conditions takes nothing returns boolean
    return(udg_MateusDefeated)
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Cond_GafgarionElsewhere takes nothing returns boolean
    return(udg_ZaleraStage<5)and(udg_ZaleraStage>0)
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Cond_KillerIsPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Cond_MetGafgarion takes nothing returns boolean
    return(IsQuestDiscovered(udg_MainQuest[7]))
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Cond_ZaleraQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[7]))
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Belias_Rescue_Gafgarion_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call ReviveHeroLoc(gg_unit_Uwar_0192,udg_TempPoint,false)
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_E002_0075,true)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,true)
    if(Trig_Boss_Belias_Rescue_Gafgarion_Cond_GafgarionElsewhere())then
        set udg_ZaleraStage=$A // $A = 10
        call KillUnit(udg_StoryBoss)
        call RemoveUnit(udg_StoryBoss)
    endif
    if(Trig_Boss_Belias_Rescue_Gafgarion_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Uwar_0192,0)
        call Text_Say(udg_StoryBoss,"Stop right there!",false)
        if(Trig_Boss_Belias_Rescue_Gafgarion_Cond_KillerIsPlayer())then
            set udg_TempPlayer=GetOwningPlayer(GetKillingUnitBJ())
        else
            set udg_TempPlayer=ForcePickRandomPlayer(udg_PlayingPlayers)
        endif
        if(Trig_Boss_Belias_Rescue_Gafgarion_Cond_MetGafgarion())then
            call Text_Say(Player_GetHero(udg_TempPlayer),"That voice ... it can't be!",false)
        else
            call Text_Say(Player_GetHero(udg_TempPlayer),"Who is it now!?",false)
        endif
        call RemoveUnit(udg_StoryBoss)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,.0,-200.)
        call RemoveLocation(udg_TempPoint2)
        call ConditionalTriggerExecute(gg_trg_Spawn_Gafgarion)
        call RemoveLocation(udg_TempPoint)
        call SetUnitFacingToFaceUnitTimed(udg_StoryBoss,GetKillingUnitBJ(),.0)
        call PauseUnitBJ(true,udg_StoryBoss)
        call SetUnitInvulnerable(udg_StoryBoss,true)
        call Wait_Polled(2.)
        call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
        call Text_Say(gg_unit_Uwar_0192,"Gafgarion!",false)
        if(Trig_Boss_Belias_Rescue_Gafgarion_Cond_ZaleraQuestDone())then
            call Text_Say(udg_StoryBoss,"Forgive me, Belias. I failed to protect Zalera. But allow me to fight alongside you now.",false)
        else
            call Text_Say(udg_StoryBoss,"Belias! I know I'm late, but allow me to fight alongside you now.",false)
        endif
        call Text_Say(gg_unit_Uwar_0192,"Hmph. You are a tenacious one. But very well. Your assistance is appreciated.",false)
        call Text_Say(gg_unit_Uwar_0192,"Now let us vanquish these humans once and for all!",false)
        call Text_Say(udg_StoryBoss,"You will not harm Belias or Hashmalum so long as I stand here!",false)
        call Text_Transmission(udg_StoryBoss,"Gafgarion","You will not harm Belias or Hashmalum so long as I stand here! En garde!","You will not harm Belias or Hashmalum so long as I stand here!",null,0,false)
        call Cine_ExitAction()
    else
        call PauseUnitBJ(true,gg_unit_Uwar_0192)
        call PauseUnitBJ(true,gg_unit_E002_0075)
        set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,.0,-200.)
        call RemoveLocation(udg_TempPoint2)
        call ConditionalTriggerExecute(gg_trg_Spawn_Gafgarion)
        call RemoveLocation(udg_TempPoint)
        call SetUnitFacingToFaceUnitTimed(udg_StoryBoss,GetKillingUnitBJ(),.0)
        call PauseUnitBJ(true,udg_StoryBoss)
        call SetUnitInvulnerable(udg_StoryBoss,true)
        call SetUnitLifePercentBJ(gg_unit_E002_0075,'d')
        call Wait_Polled(1.)
        call PauseUnitBJ(false,gg_unit_Uwar_0192)
        call PauseUnitBJ(false,gg_unit_E002_0075)
    endif
    call UnitAddAbilityBJ('A0X2',gg_unit_Uwar_0192) // 'A0X2': ability "Perma Cover"
    call UnitAddAbilityBJ('A0X2',gg_unit_E002_0075) // 'A0X2': ability "Perma Cover"
    call Link_SaveCaster(udg_StoryBoss,gg_unit_Uwar_0192,.0)
    call Link_SaveCaster(udg_StoryBoss,gg_unit_E002_0075,.0)
    call SetUnitInvulnerable(gg_unit_Uwar_0192,false)
    call SetUnitInvulnerable(udg_StoryBoss,false)
    call SetUnitInvulnerable(gg_unit_E002_0075,false)
    call PauseUnitBJ(false,udg_StoryBoss)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Gafgarion_Death,udg_StoryBoss,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_Boss_Belias_Gafgarion_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Belias_Gafgarion_Death_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Belias_Gafgarion_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call UnitRemoveAbilityBJ('A0X2',gg_unit_Uwar_0192) // 'A0X2': ability "Perma Cover"
    call UnitRemoveAbilityBJ('A0X2',gg_unit_E002_0075) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_Uwar_0192) // 'B064': buff "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_E002_0075) // 'B064': buff "Perma Cover"
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Belias_Gafgarion_Death_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    call EnableTrigger(gg_trg_Boss_Belias_Death_Final)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Boss_Belias_Death_Final_Cond_DyingIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Belias_Death_Final_Cond_RandomHalf takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)<=1)
endfunction

function Trig_Boss_Belias_Death_Final_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Boss_Hashmalum_Revive_Loop)
    call DestroyTrigger(gg_trg_Boss_Hashmalum_Revive_Loop)
    call EnableTrigger(gg_trg_Boss_Hashmalum_Death_Final)
    set udg_BossDefeated[6]=true
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Boss_Belias_Death_Final_Cond_DyingIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I0E0',udg_TempPoint) // 'I0E0': item "Curse: Fire Wand"
    call CreateItemLoc('I01Z',udg_TempPoint) // 'I01Z': item "Crystal Shard"
    if(Trig_Boss_Belias_Death_Final_Cond_RandomHalf())then
        call CreateItemLoc('I05I',udg_TempPoint) // 'I05I': item "Spirit Potion"
    else
        call CreateItemLoc('I05H',udg_TempPoint) // 'I05H': item "Blood Ether"
    endif
    call RemoveLocation(udg_TempPoint)
    call ConditionalTriggerExecute(gg_trg_Quest_WorldLiberation_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Boss_Belias takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part6 (module Boss),
// which keeps the original registration order.

function Register_Boss_Belias_Rescue_Mateus takes nothing returns nothing
    set gg_trg_Boss_Belias_Rescue_Mateus=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Rescue_Mateus)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Rescue_Mateus,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Belias_Rescue_Mateus,Condition(function Trig_Boss_Belias_Rescue_Mateus_Conditions))
    call TriggerAddAction(gg_trg_Boss_Belias_Rescue_Mateus,function Trig_Boss_Belias_Rescue_Mateus_Actions)
endfunction

function Register_Boss_Belias_Revive_Loop takes nothing returns nothing
    set gg_trg_Boss_Belias_Revive_Loop=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Revive_Loop)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Revive_Loop,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Belias_Revive_Loop,Condition(function Trig_Boss_Belias_Revive_Loop_Conditions))
    call TriggerAddAction(gg_trg_Boss_Belias_Revive_Loop,function Trig_Boss_Belias_Revive_Loop_Actions)
endfunction

function Register_Boss_Belias_Rescue_Gafgarion takes nothing returns nothing
    set gg_trg_Boss_Belias_Rescue_Gafgarion=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Rescue_Gafgarion)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Rescue_Gafgarion,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Boss_Belias_Rescue_Gafgarion,Condition(function Trig_Boss_Belias_Rescue_Gafgarion_Conditions))
    call TriggerAddAction(gg_trg_Boss_Belias_Rescue_Gafgarion,function Trig_Boss_Belias_Rescue_Gafgarion_Actions)
endfunction

function Register_Boss_Belias_Gafgarion_Death takes nothing returns nothing
    set gg_trg_Boss_Belias_Gafgarion_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Gafgarion_Death)
    call TriggerAddAction(gg_trg_Boss_Belias_Gafgarion_Death,function Trig_Boss_Belias_Gafgarion_Death_Actions)
endfunction

function Register_Boss_Belias_Death_Final takes nothing returns nothing
    set gg_trg_Boss_Belias_Death_Final=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Belias_Death_Final)
    call TriggerRegisterUnitEvent(gg_trg_Boss_Belias_Death_Final,gg_unit_Uwar_0192,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Boss_Belias_Death_Final,function Trig_Boss_Belias_Death_Final_Actions)
endfunction

endlibrary

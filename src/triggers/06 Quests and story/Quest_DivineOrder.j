library TQuestDivineOrder requires TQuestEngine, TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
// Side quest "Divine Order", written for the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Siegfried, envoy of the Northern God, sends the party to strike down Ziegfried, who slew the Godbeast
// Fafnir with Arcanium gear. All steps are custom: this module's triggers and Ziegfried's confront scene
// (Ziegfried module) finish them, and this module keeps its own "!" / "?" markers (the "?" over Siegfried
// goes when the party confronts Ziegfried). Siegfried enables gg_trg_Quest_DivineOrder_Start.
// Does not count toward the story.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_DivineOrder_Start=null
    trigger gg_trg_Quest_DivineOrder_Complete=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_DIVINE_ORDER=0
    // Variables only this module uses (MapBootstrap sets some starting values).
    lightning udg_ExecutionLightning=null
    sound gg_snd_004=null
endglobals

function QuestDivineOrder_Define takes nothing returns nothing
    local integer q=Quest_Define("Divine Order",QUEST_SIDE,70,"ReplaceableTextures\\CommandButtons\\BTNSpell_Holy_RetributionAura.blp")
    set QUEST_DIVINE_ORDER=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Siegfried (gg_trg_Quest_DivineOrder_Start)
    call Quest_Custom(q,"Siegfried, envoy of the Northern God, has tasked you with taking down the heretic who killed the Godbeast. Confront him!")
    // 2. Confront Ziegfried (Ziegfried module, gg_trg_Ziegfried_Confront)
    call Quest_Custom(q,"Strike down Ziegfried.")
    // 3. Ziegfried falls (gg_trg_Quest_DivineOrder_Complete)
    call Quest_Custom(q,"")
endfunction

function Trig_Quest_DivineOrder_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_N0N0_0267,true,true,true))
endfunction

function Trig_Quest_DivineOrder_Start_PlayEnvoyScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 1: a hero talks to Siegfried. Ziegfried grows much stronger and waits in Fafnir's lair.
function Trig_Quest_DivineOrder_Start_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[90])
    if(Trig_Quest_DivineOrder_Start_PlayEnvoyScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_N0N0_0267,"Ah you must be the adventurers. I've been looking for you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What is this about?",false)
        call Text_Say(gg_unit_N0N0_0267,"My name is Siegfried and I'm here an an envoy of the Northern God himself. It seems there's been a bit of trouble in this world of late. A Godbeast was slain and the perpetrator is in possession of gear that mortals cannot be allowed to wield.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Cannot be allowed to wield?",false)
        call Text_Say(gg_unit_N0N0_0267,"I've heard from the dwarves here roughly what happened. You brought Arcanium from deep within the northern former mine, yes? And it was used to forge divine weaponry.",false)
        call Text_Say(gg_unit_N0N0_0267,"They were then misused to slay a Godbeast of the Northern God himself. The heretic who committed these acts is dangerous. He must be brought to justice.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmph, and why do you need me?",false)
        call Text_Say(gg_unit_N0N0_0267,"You are the one who caused this mess in the first place. Show me that you can clean it up. The heretic must be incapacitated, and the gear must be gotten rid of.",false)
        call Text_Say(gg_unit_N0N0_0267,"Of course I'm aware the heretic is clad in Arcanium forged armor. I know you can't slay him. Simply incapacitating him is enough.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And what if I refuse?",false)
        call Text_Say(gg_unit_N0N0_0267,"I don't think you realize just what exactly this heretic really is. Look, tell him one thing. Tell him an envoy of the Northern God is here and is keeping all these dwarves hostage, the very same that forged his blade and armor for him. You'll see how he reacts.",false)
        call Text_Say(gg_unit_N0N0_0267,"But in either case, if you won't do it, I will strike him down in your stead. And then I'll come after you myself. You're very strong yourself I know it. This is your chance to prove you're not a danger.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmm...",false)
        call Cine_ExitAction()
    endif
    if QUEST_DIVINE_ORDER==0 then
        call QuestDivineOrder_Define()
    endif
    call Quest_Start(QUEST_DIVINE_ORDER,GetTriggerPlayer(),GetTriggerUnit())
    set udg_SpecialEffect[90]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_N0N0_0267,"Objects\\RandomObject\\RandomObject.mdl")
    call SetHeroLevelBJ(gg_unit_H036_0254,85,false)
    call ModifyHeroStat(bj_HEROSTAT_STR,gg_unit_H036_0254,bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_AGI,gg_unit_H036_0254,bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call ModifyHeroStat(bj_HEROSTAT_INT,gg_unit_H036_0254,bj_MODIFYMETHOD_ADD,$96) // $96 = 150
    call BlzSetUnitMaxHP(gg_unit_H036_0254,(BlzGetUnitMaxHP(gg_unit_H036_0254)*2))
    call SetUnitLifePercentBJ(gg_unit_H036_0254,'d')
    call SetUnitManaPercentBJ(gg_unit_H036_0254,'d')
    set l_tempPoint=GetRectCenter(gg_rct_677)
    call SetUnitPositionLocFacingBJ(gg_unit_H036_0254,l_tempPoint,270.)
    call RemoveLocation(l_tempPoint)
    call ShowUnitShow(gg_unit_H036_0254)
    call GroupAddUnitSimple(gg_unit_H036_0254,udg_BossUnits)
    call EnableTrigger(gg_trg_Ziegfried_Confront)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempPoint=null
endfunction

function Trig_Quest_DivineOrder_Complete_DeathLogEnabled takes nothing returns boolean
    return(udg_SpeedrunMode)
endfunction

function Trig_Quest_DivineOrder_Complete_DyingUnitIsHero takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Quest_DivineOrder_Complete_KilledByPlayerForce takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Quest_DivineOrder_Complete_PlayExecutionScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

// Step 3: Ziegfried falls. The Northern God executes him; Siegfried explains why and leaves.
function Trig_Quest_DivineOrder_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Ziegfried_Arena_Leash)
    call DestroyTrigger(gg_trg_Ziegfried_Arena_Leash)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    if(Trig_Quest_DivineOrder_Complete_DeathLogEnabled())then
        set udg_BossUnit=GetTriggerUnit()
        call ConditionalTriggerExecute(gg_trg_Speedrun_Accolade)
    endif
    call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
    if(Trig_Quest_DivineOrder_Complete_DyingUnitIsHero())then
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
    else
        call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
    endif
    if(Trig_Quest_DivineOrder_Complete_PlayExecutionScene())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_H036_0254,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call Cine_Enter()
        call SetUnitAnimation(gg_unit_H036_0254,"death alternate")
        call Cam_PanToUnit(gg_unit_H036_0254,0)
        call Text_Say(gg_unit_H036_0254,"Hmph, you are still strong. But you know you can't kill me. Your weapons cannot pierce armor forged in Arcanium.",false)
        if(Trig_Quest_DivineOrder_Complete_KilledByPlayerForce())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"I know. But we've upheld our end of the task. The rest...",false)
        call Text_Say(null,"... I will take care of.",false)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call SetUnitPositionLocFacingLocBJ(gg_unit_H01M_0071,udg_TempPoint,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call SetUnitVertexColorBJ(gg_unit_H01M_0071,50.,37.5,5.,65.)
        call ShowUnitShow(gg_unit_H01M_0071)
        call SetUnitAnimationWithRarity(gg_unit_H01M_0071,"spell",RARITY_FREQUENT)
        set udg_TempPoint=GetUnitLoc(gg_unit_H01M_0071)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.6)
        call PlaySoundBJ(gg_snd_004)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,.5,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,0,0,0)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempPoint2=GetUnitLoc(udg_CinematicActor)
        call SetUnitPositionLocFacingLocBJ(gg_unit_N0N0_0267,udg_TempPoint,udg_TempPoint2)
        call RemoveLocation(udg_TempPoint2)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,300.,300.)
        call RemoveLocation(udg_TempPoint)
        set udg_TempPoint=OffsetLocation(udg_TempPoint2,-600.,-600.)
        set udg_ExecutionLightning=AddLightningLoc("AFOD",udg_TempPoint2,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call RemoveLocation(udg_TempPoint2)
        call KillUnit(GetTriggerUnit())
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(gg_unit_H01M_0071)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call SetUnitAnimation(gg_unit_H01M_0071,"stand victory")
        call Wait_Polled(.5)
        call DestroyLightningBJ(udg_ExecutionLightning)
        call ShowUnitHide(gg_unit_H01M_0071)
        call Wait_Polled(1.)
        call Text_Say(udg_CinematicActor,"What the... he's dead. What just happened !?",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_N0N0_0267)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.6)
        call ShowUnitShow(gg_unit_N0N0_0267)
        call Text_Say(gg_unit_N0N0_0267,"Good work, adventurers.",false)
        call Text_Say(udg_CinematicActor,"You're that knight again. Explain!",false)
        call Text_Say(gg_unit_N0N0_0267,"It's nothing obscure. With the heretic incapacitated, executing him was simple for the god himself.",false)
        call Text_Say(udg_CinematicActor,"I thought you were going to bring him to justice. Why did you just execute him!?",false)
        call Text_Say(gg_unit_N0N0_0267,"So you still don't understand, do you.",false)
        call Text_Say(gg_unit_N0N0_0267,"A long time ago, dwarves mined Arcanium from the mine here freely. Many weapons were forged like this man's sword. But that attracted the eyes of many who sought power for themselves.",false)
        call Text_Say(gg_unit_N0N0_0267,"Arcanium is the material of the Northern God himself. Clad in it, he is invincible and divine. At first, he did not object to the dwarves using it themselves. But it soon turned out the weapons and armor crafted from Arcanium were too great a power to be freely accessible.",false)
        call Text_Say(gg_unit_N0N0_0267,"Wars were fought over them time and time again. By many different people, for many different purposes, but the who and why didn't matter. So long as Arcanium weapons were around, the allure of their power alone would spark war after war.",false)
        call Text_Say(gg_unit_N0N0_0267,"At last, the Northern God stepped in himself. Destroying all the Arcanium gear and bringing down the Godbeast Fafnir to collapse the mine and keep Arcanium from the hands of mortals forever, so that these mistakes may never repeat.",false)
        call Text_Say(udg_CinematicActor,"What does any of that have to do with executing Ziegfried?",false)
        call Text_Say(gg_unit_N0N0_0267,"Surely by now you understand that this man was no different. He somehow got his hands on the old legends of Arcanium and sought its power for his own gain. Even if he had been pardoned, he would never have stopped seeking power and striking whoever or whatever got in his way.",false)
        call Text_Say(udg_CinematicActor,"Hmph...",false)
        call Text_Say(gg_unit_N0N0_0267,"You look dissatisfied. Well that's just how it is. But don't be foolish enough to go after this power yourself. This time, forget about this mine and Arcanium for good. The holy beast Fafnir is gone but the mine remains yet collapsed. So long as it remains forgotten, we will not have to return.",false)
        call Reward_Give($4E20,$4E20,gg_unit_N0N0_0267) // $4E20 = 20000
        call Text_Say(gg_unit_N0N0_0267,"Just forget about it all. Goodbye.",false)
        set udg_TempPoint=GetUnitLoc(gg_unit_N0N0_0267)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.5)
        call ShowUnitHide(gg_unit_N0N0_0267)
        call Wait_Polled(2.)
        call Text_Say(udg_CinematicActor,"Damn it... so this power is just too great to be safe in anyone's hands? Except the god himself?",false)
        call Text_Say(udg_CinematicActor,"Rest in peace... Ziegfried.",false)
        call Cine_ExitAction()
    else
        call PlaySoundBJ(gg_snd_004)
        call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN,.5,"ReplaceableTextures\\CameraMasks\\White_mask.blp",100.,0,0,0)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Reward_Give($4E20,$4E20,gg_unit_N0N0_0267) // $4E20 = 20000
    endif
    call Quest_StepDone(QUEST_DIVINE_ORDER,null,null)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'n0N7',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'n0N7': unit "Phantom Diary"
    call RemoveLocation(udg_TempPoint)
    set udg_PhantomDiaryUnit=GetLastCreatedUnit()
    call ShowUnitHide(udg_PhantomDiaryUnit)
    call Wait_Polled(3.)
    call EnableTrigger(gg_trg_PhantomDiary_Open)
    call ShowUnitShow(udg_PhantomDiaryUnit)
    call SetUnitVertexColorBJ(gg_unit_H01M_0071,100.,75.,10.,.0)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_DivineOrder takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part19, RegisterTriggers_Quest_Part20 (module Quest),
// which keeps the original registration order.

function Register_Quest_DivineOrder_Start takes nothing returns nothing
    set gg_trg_Quest_DivineOrder_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DivineOrder_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_DivineOrder_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_DivineOrder_Start,Condition(function Trig_Quest_DivineOrder_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_DivineOrder_Start,function Trig_Quest_DivineOrder_Start_Actions)
endfunction

function Register_Quest_DivineOrder_Complete takes nothing returns nothing
    set gg_trg_Quest_DivineOrder_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_DivineOrder_Complete)
    call TriggerRegisterUnitEvent(gg_trg_Quest_DivineOrder_Complete,gg_unit_H036_0254,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_DivineOrder_Complete,function Trig_Quest_DivineOrder_Complete_Actions)
endfunction

endlibrary

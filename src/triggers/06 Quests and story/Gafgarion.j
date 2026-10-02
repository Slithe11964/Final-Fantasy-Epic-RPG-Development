library TGafgarion requires TCam, TCine, TPlayerHero, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gafgarion_Join_Party=null
    trigger gg_trg_Gafgarion_Leash=null
    trigger gg_trg_Gafgarion_Death_Timer=null
    trigger gg_trg_Gafgarion_Revive=null
    trigger gg_trg_Gafgarion_Block_Portal_Scroll=null
    trigger gg_trg_Gafgarion_Join_Summit=null
    trigger gg_trg_Gafgarion_RegenBurst=null
endglobals

function Trig_Gafgarion_Join_Party_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_StoryBoss,true,true,true))
endfunction

function Trig_Gafgarion_Join_Party_Cond_BarrierNeeded takes nothing returns boolean
    return(udg_ExcaliburRockHidden)
endfunction

function Trig_Gafgarion_Join_Party_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Gafgarion_Join_Party_Enum_KillDestructable takes nothing returns nothing
    call KillDestructable(GetEnumDestructable())
endfunction

function Trig_Gafgarion_Join_Party_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[43])
    call GroupRemoveUnitSimple(udg_StoryBoss,udg_QuestUnits)
    if(Trig_Gafgarion_Join_Party_Cond_BarrierNeeded())then
        call ShowDestructableBJ(true,gg_dest_LTcr_0019)
        call EnableTrigger(gg_trg_ExcaliburII_Drop)
    else
        call RemoveDestructable(gg_dest_LTcr_0019)
    endif
    if(Trig_Gafgarion_Join_Party_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You again? It won't end any differently this time. Get out of our way.",false)
        call Text_Say(udg_StoryBoss,"Spare the taunts. I'm not here to fight you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're not here to fight us?",false)
        call Text_Say(udg_StoryBoss,"The demon atop this icy mountain, Echele...",false)
        call Text_Say(udg_StoryBoss,"I want him vanquished as much as you do.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What?? Aren't you the Dark Knight of the Zodiac Braves?",false)
        call Text_Say(udg_StoryBoss,"I am. The Zodiac Braves are the true rulers of this world. I wish nothing but prosperity to this world.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You say that after all of this? After siding with demons?",false)
        call Text_Say(udg_StoryBoss,"You do not understand. Gaya enjoyed peace under their rule for centuries.",false)
        call Text_Say(udg_StoryBoss,"But eventually the human and elves backstabbed them. And ever since, Gaya has been in disarray and chaos. I merely want to reinstate the world's proper rulers.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You are making no sense. You want them to rule, and yet now you tell us you want to fight their lord?",false)
        call Text_Say(udg_StoryBoss,"I do not believe in freezing this world. But I still believe in them as rulers. I'll get them back, and bring them to their senses. It's the least I can still do for them, and for this world.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I still don't get it, but we are up against an overwhelmingly powerful foe. If you want to assist us, we won't say no.",false)
        call Text_Say(udg_StoryBoss,"Don't get me wrong, I'm not on your side. But we certainly have a common goal, and a greater chance to achieve it if we go together.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"And how do we know you won't just backstab us?",false)
        call Text_Say(udg_StoryBoss,"I suppose my word means little. But we both aren't in a position to be picky about our allies.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I suppose not. Very well then. I hate to admit it, but we could use your help. Don't expect us to forgive and trust you, though.",false)
        call Text_Say(udg_StoryBoss,"Of course not. The feeling is mutual.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright then. Let's go.",false)
        call Cine_ExitAction()
    endif
    call PauseUnitBJ(false,udg_StoryBoss)
    call SetUnitInvulnerable(udg_StoryBoss,false)
    call SetUnitFacingTimed(udg_StoryBoss,270.,.5)
    call GroupAddUnitSimple(udg_StoryBoss,udg_BossGroup)
    call SetUnitOwner(udg_StoryBoss,Player($A),true) // $A = 10
    call UnitAddAbilityBJ('A0AV',udg_StoryBoss) // 'A0AV': ability "Magicdamage Reduction"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call SetItemDroppableBJ(UnitItemInSlotBJ(udg_StoryBoss,GetForLoopIndexA()),false)
        call SetItemUserData(UnitItemInSlotBJ(udg_StoryBoss,GetForLoopIndexA()),$B) // $B = 11
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Gafgarion joins your party.")
    call EnumDestructablesInRectAll(gg_rct_643,function Trig_Gafgarion_Join_Party_Enum_KillDestructable)
    call EnableTrigger(gg_trg_Boss_Echele_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Gafgarion_Leash_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_StoryBoss)and(GetOwningPlayer(GetTriggerUnit())==Player($A)) // $A = 10
endfunction

function Trig_Gafgarion_Leash_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_574)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,225.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Gafgarion_Death_Timer_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_StoryBoss)
endfunction

function Trig_Gafgarion_Death_Timer_Cond_SlotSixIsLoot takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_StoryBoss,6))!=$B) // $B = 11
endfunction

function Trig_Gafgarion_Death_Timer_Actions takes nothing returns nothing
    call StartTimerBJ(udg_GafgarionReviveTimer,false,60.)
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Gafgarion has been killed. He will be resummoned into this world in one minute.")
    if(Trig_Gafgarion_Death_Timer_Cond_SlotSixIsLoot())then
        call UnitRemoveItemFromSlotSwapped(6,udg_StoryBoss)
    endif
endfunction

function Trig_Gafgarion_Revive_Actions takes nothing returns nothing
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Gafgarion has revived.")
    set udg_TempPoint=GetRectCenter(gg_rct_574)
    call ReviveHeroLoc(udg_StoryBoss,udg_TempPoint,true)
    call RemoveLocation(udg_TempPoint)
    call SetUnitManaPercentBJ(udg_StoryBoss,'d')
    call SetUnitFacingTimed(udg_StoryBoss,270.,.01)
endfunction

function Trig_Gafgarion_Block_Portal_Scroll_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_StoryBoss)and(GetItemTypeId(GetManipulatedItem())=='stwp') // 'stwp': item "Scroll of Portal"
endfunction

function Trig_Gafgarion_Block_Portal_Scroll_Actions takes nothing returns nothing
    call UnitRemoveItemSwapped(GetManipulatedItem(),udg_StoryBoss)
endfunction

function Trig_Gafgarion_Join_Summit_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Gafgarion_Join_Summit_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call PauseUnitBJ(false,udg_StoryBoss)
    call GroupRemoveUnitSimple(udg_StoryBoss,udg_QuestUnits)
    call SetUnitInvulnerable(udg_StoryBoss,false)
    call SetUnitOwner(udg_StoryBoss,Player($A),false) // $A = 10
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Gafgarion joins your party.")
endfunction

function Trig_Gafgarion_RegenBurst_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1EF') // 'A1EF': ability "HP Regeneration Burst"
endfunction

function Trig_Gafgarion_RegenBurst_Actions takes nothing returns nothing
    call SetUnitAbilityLevelSwapped('A0TU',GetTriggerUnit(),20) // 'A0TU': ability "HP Regeneration Bonus"
    call Wait_Polled(15.)
    call SetUnitAbilityLevelSwapped('A0TU',GetTriggerUnit(),$A) // 'A0TU': ability "HP Regeneration Bonus"; $A = 10
endfunction

// World Editor calls InitTrig_Gafgarion automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Gafgarion (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Gafgarion takes nothing returns nothing
endfunction

function Register_Gafgarion_Join_Party takes nothing returns nothing
    set gg_trg_Gafgarion_Join_Party=CreateTrigger()
    call DisableTrigger(gg_trg_Gafgarion_Join_Party)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Gafgarion_Join_Party,Player(7),true)
    call TriggerAddCondition(gg_trg_Gafgarion_Join_Party,Condition(function Trig_Gafgarion_Join_Party_Conditions))
    call TriggerAddAction(gg_trg_Gafgarion_Join_Party,function Trig_Gafgarion_Join_Party_Actions)
endfunction

function Register_Gafgarion_Leash takes nothing returns nothing
    set gg_trg_Gafgarion_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Gafgarion_Leash,gg_rct_575)
    call TriggerRegisterEnterRectSimple(gg_trg_Gafgarion_Leash,gg_rct_576)
    call TriggerAddCondition(gg_trg_Gafgarion_Leash,Condition(function Trig_Gafgarion_Leash_Conditions))
    call TriggerAddAction(gg_trg_Gafgarion_Leash,function Trig_Gafgarion_Leash_Actions)
endfunction

function Register_Gafgarion_Death_Timer takes nothing returns nothing
    set gg_trg_Gafgarion_Death_Timer=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Gafgarion_Death_Timer,Player($A),EVENT_PLAYER_UNIT_DEATH) // $A = 10
    call TriggerAddCondition(gg_trg_Gafgarion_Death_Timer,Condition(function Trig_Gafgarion_Death_Timer_Conditions))
    call TriggerAddAction(gg_trg_Gafgarion_Death_Timer,function Trig_Gafgarion_Death_Timer_Actions)
endfunction

function Register_Gafgarion_Revive takes nothing returns nothing
    set gg_trg_Gafgarion_Revive=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Gafgarion_Revive,udg_GafgarionReviveTimer)
    call TriggerAddAction(gg_trg_Gafgarion_Revive,function Trig_Gafgarion_Revive_Actions)
endfunction

function Register_Gafgarion_Block_Portal_Scroll takes nothing returns nothing
    set gg_trg_Gafgarion_Block_Portal_Scroll=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Gafgarion_Block_Portal_Scroll,Player($A),EVENT_PLAYER_UNIT_PICKUP_ITEM) // $A = 10
    call TriggerAddCondition(gg_trg_Gafgarion_Block_Portal_Scroll,Condition(function Trig_Gafgarion_Block_Portal_Scroll_Conditions))
    call TriggerAddAction(gg_trg_Gafgarion_Block_Portal_Scroll,function Trig_Gafgarion_Block_Portal_Scroll_Actions)
endfunction

function Register_Gafgarion_Join_Summit takes nothing returns nothing
    set gg_trg_Gafgarion_Join_Summit=CreateTrigger()
    call DisableTrigger(gg_trg_Gafgarion_Join_Summit)
    call TriggerRegisterEnterRectSimple(gg_trg_Gafgarion_Join_Summit,gg_rct_643)
    call TriggerAddCondition(gg_trg_Gafgarion_Join_Summit,Condition(function Trig_Gafgarion_Join_Summit_Conditions))
    call TriggerAddAction(gg_trg_Gafgarion_Join_Summit,function Trig_Gafgarion_Join_Summit_Actions)
endfunction

function Register_Gafgarion_RegenBurst takes nothing returns nothing
    set gg_trg_Gafgarion_RegenBurst=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Gafgarion_RegenBurst,Player($A),EVENT_PLAYER_UNIT_SPELL_EFFECT) // $A = 10
    call TriggerAddCondition(gg_trg_Gafgarion_RegenBurst,Condition(function Trig_Gafgarion_RegenBurst_Conditions))
    call TriggerAddAction(gg_trg_Gafgarion_RegenBurst,function Trig_Gafgarion_RegenBurst_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Gafgarion takes nothing returns nothing
    call Register_Gafgarion_Join_Party() // starts off; enabled by Boss_Hashmalum
    call Register_Gafgarion_Leash() // disabled by IceAge; destroyed by IceAge
    call Register_Gafgarion_Death_Timer() // disabled by IceAge; destroyed by IceAge
    call Register_Gafgarion_Revive() // disabled by IceAge; destroyed by IceAge
    call Register_Gafgarion_Block_Portal_Scroll() // disabled by IceAge; destroyed by IceAge
    call Register_Gafgarion_Join_Summit() // starts off; enabled by IceAge
    call Register_Gafgarion_RegenBurst()
endfunction

endlibrary

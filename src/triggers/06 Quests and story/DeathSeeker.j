library TDeathSeeker requires TQuestEngine, TCam, TCine, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_DeathSeeker_Give=null
    trigger gg_trg_DeathSeeker_TurnIn=null
endglobals

function Trig_DeathSeeker_Give_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_DeathSeeker_Give_HasFreeSlot takes nothing returns boolean
    return(UnitItemInSlotBJ(GetTriggerUnit(),1)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),2)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),3)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),4)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),5)==null)or(UnitItemInSlotBJ(GetTriggerUnit(),6)==null)
endfunction

function Trig_DeathSeeker_Give_CanCarryItem takes nothing returns boolean
    return(Trig_DeathSeeker_Give_HasFreeSlot())
endfunction

function Trig_DeathSeeker_Give_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DeathSeeker_Give_CanCarryItem())then
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call UnitAddItemByIdSwapped('I067',GetTriggerUnit()) // 'I067': item "Death Seeker"
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call CreateItemLoc('I067',udg_TempPoint) // 'I067': item "Death Seeker"
        call RemoveLocation(udg_TempPoint)
    endif
    // A random whole number from 1 through 3.
    call SetItemCharges(GetLastCreatedItem(),GetRandomInt(1,3))
    call Wait_Polled(180.)
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_DeathSeeker_TurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I067'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I067': item "Death Seeker"
endfunction

function Trig_DeathSeeker_TurnIn_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067'))>=2) // 'I067': item "Death Seeker"
endfunction

function Trig_DeathSeeker_TurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_DeathSeeker_TurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_DeathSeeker_TurnIn_Cond_ItemHasCharges())then
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067'))-1)) // 'I067': item "Death Seeker"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I067')) // 'I067': item "Death Seeker"
    endif
    if(Trig_DeathSeeker_TurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[62])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go. One Death Seeker.",false)
        call Text_Say(gg_unit_n034_0109,"Wow you found it! That's great!",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"It wasn't easy. We're kind of in a pickle right now, so if you want us to keep helping you it better be worth it.",false)
        call Text_Say(gg_unit_n034_0109,"I know. But it's just one more artifact I need. And this one can't possibly be that hard to find.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That sounds like you have absolutely no idea where to find it.",false)
        call Text_Say(gg_unit_n034_0109,"It's just a Qu Frog's Head. A head of a Qu's Frog. You just need to find a Qu Frog and then kill it. Simple enough right?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm, I see. Well I'll try to find one then.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call Quest_StepDone(QUEST_DIMENSIONAL_BOUNDARY,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    call EnableTrigger(gg_trg_QuFrog_DrainTick)
    call EnableTrigger(gg_trg_QuFrog_Death)
    call ShowUnitShow(gg_unit_n03A_0136)
    call ShowUnitShow(gg_unit_n039_0095)
    call ShowUnitShow(gg_unit_n039_0083)
    call ShowUnitShow(gg_unit_n039_0175)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_DeathSeeker automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_DeathSeeker_Part1 / RegisterTriggers_DeathSeeker_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_DeathSeeker takes nothing returns nothing
endfunction

function Register_DeathSeeker_Give takes nothing returns nothing
    set gg_trg_DeathSeeker_Give=CreateTrigger()
    call DisableTrigger(gg_trg_DeathSeeker_Give)
    call TriggerRegisterEnterRectSimple(gg_trg_DeathSeeker_Give,gg_rct_550)
    call TriggerAddCondition(gg_trg_DeathSeeker_Give,Condition(function Trig_DeathSeeker_Give_Conditions))
    call TriggerAddAction(gg_trg_DeathSeeker_Give,function Trig_DeathSeeker_Give_Actions)
endfunction

function Register_DeathSeeker_TurnIn takes nothing returns nothing
    set gg_trg_DeathSeeker_TurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_DeathSeeker_TurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_DeathSeeker_TurnIn,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_DeathSeeker_TurnIn,Condition(function Trig_DeathSeeker_TurnIn_Conditions))
    call TriggerAddAction(gg_trg_DeathSeeker_TurnIn,function Trig_DeathSeeker_TurnIn_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_DeathSeeker_Part1 takes nothing returns nothing
    call Register_DeathSeeker_Give() // starts off; enabled by Boss_Zalera, Epilogue
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_DeathSeeker_Part2 takes nothing returns nothing
    call Register_DeathSeeker_TurnIn() // starts off; enabled by TropicalEssence
endfunction

endlibrary

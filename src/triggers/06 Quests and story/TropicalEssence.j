library TTropicalEssence requires TCam, TCine, TPlayerHero, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_TropicalEssence_TurnIn=null
endglobals

function Trig_TropicalEssence_TurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I06N'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I06N': item "Tropical Essence"
endfunction

function Trig_TropicalEssence_TurnIn_Cond_ItemHasCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06N'))>=2) // 'I06N': item "Tropical Essence"
endfunction

function Trig_TropicalEssence_TurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_TropicalEssence_TurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_TropicalEssence_TurnIn_Cond_ItemHasCharges())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I06N')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06N'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06N'))-1)) // 'I06N': item "Tropical Essence"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06N')) // 'I06N': item "Tropical Essence"
    endif
    if(Trig_TropicalEssence_TurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[62])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"There you go. Some Tropical Essence.",false)
        call Text_Say(gg_unit_n034_0109,"Great work! Unfortunately the next artifact in line is a lot more elusive.",false)
        call Text_Say(gg_unit_n034_0109,"It's called a Death Seeker. I've tried doing some research on where to get it, but to no avail. You'll have to find it yourself.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I see. Well we'll see if we can find it.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Bring a Death Seeker to Shinra.")
    call QuestSetDescriptionBJ(udg_SideQuest[40],"Shinra, an Al Bhed child from Spira, has asked you to find many artifacts so he can create a portal that can be used to warp through dimensions.\r\nShinra now needs a |cffffcc00Death Seeker|r. The reason is unknown.")
    call EnableTrigger(gg_trg_DeathSeeker_TurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_TropicalEssence automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_TropicalEssence (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_TropicalEssence takes nothing returns nothing
endfunction

function Register_TropicalEssence_TurnIn takes nothing returns nothing
    set gg_trg_TropicalEssence_TurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_TropicalEssence_TurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_TropicalEssence_TurnIn,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_TropicalEssence_TurnIn,Condition(function Trig_TropicalEssence_TurnIn_Conditions))
    call TriggerAddAction(gg_trg_TropicalEssence_TurnIn,function Trig_TropicalEssence_TurnIn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_TropicalEssence takes nothing returns nothing
    call Register_TropicalEssence_TurnIn() // starts off; enabled by GuideBook
endfunction

endlibrary

library TPortal requires TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Portal_Reveal=null
endglobals

function Trig_Portal_Reveal_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_ActivePlayers))
endfunction

function Trig_Portal_Reveal_IsPortalMarked takes nothing returns boolean
    return(IsUnitInGroup(gg_unit_nwgt_0142,udg_QuestUnits))
endfunction

function Trig_Portal_Reveal_NotMetGuardian takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[6])==false)and(udg_PortalGuardianMet==false)
endfunction

function Trig_Portal_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Portal_Reveal_IsPortalMarked())then
        call GroupRemoveUnitSimple(gg_unit_nwgt_0142,udg_QuestUnits)
        call GroupAddUnitSimple(gg_unit_Emns_0156,udg_QuestUnits)
    endif
    set udg_TempPoint=GetUnitLoc(gg_unit_nwgt_0142)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetUnitLoc(gg_unit_nwgt_0141)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Andt\\Andt.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    if(Trig_Portal_Reveal_NotMetGuardian())then
        call DisableTrigger(gg_trg_Talk_PortalGuardian)
        call DestroyTrigger(gg_trg_Talk_PortalGuardian)
        call EnableTrigger(gg_trg_Talk_ForestGuardian)
    endif
    call Wait_Polled(1.)
    call ShowUnitShow(gg_unit_nwgt_0142)
    call ShowUnitShow(gg_unit_nwgt_0141)
    call WaygateActivateBJ(true,gg_unit_nwgt_0142)
    call WaygateActivateBJ(true,gg_unit_nwgt_0141)
    call WaygateSetDestinationLocBJ(gg_unit_nwgt_0142,GetRectCenter(gg_rct_375))
    call WaygateSetDestinationLocBJ(gg_unit_nwgt_0141,GetRectCenter(gg_rct_374))
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Portal automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Portal (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Portal takes nothing returns nothing
endfunction

function Register_Portal_Reveal takes nothing returns nothing
    set gg_trg_Portal_Reveal=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Portal_Reveal,512.,gg_unit_nwgt_0142)
    call TriggerAddCondition(gg_trg_Portal_Reveal,Condition(function Trig_Portal_Reveal_Conditions))
    call TriggerAddAction(gg_trg_Portal_Reveal,function Trig_Portal_Reveal_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Portal takes nothing returns nothing
    call Register_Portal_Reveal() // disabled by Talk; run by Epilogue, Quest_NightElves, Talk
endfunction

endlibrary

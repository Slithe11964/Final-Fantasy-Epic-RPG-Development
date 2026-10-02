library TDwarves
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Dwarves_Disappear=null
endglobals

function Trig_Dwarves_Disappear_ReforgeItemHeld takes nothing returns boolean
    return(udg_LokiReforgeItem!=null)
endfunction

function Trig_Dwarves_Disappear_SmithItemAHeld takes nothing returns boolean
    return(udg_ForgeGearSlot!=null)
endfunction

function Trig_Dwarves_Disappear_SmithItemBHeld takes nothing returns boolean
    return(udg_ForgeMaterialSlot!=null)
endfunction

function Trig_Dwarves_Disappear_Actions takes nothing returns nothing
    if(Trig_Dwarves_Disappear_ReforgeItemHeld())then
        call SetItemDroppableBJ(udg_LokiReforgeItem,true)
        call UnitRemoveItemSwapped(udg_LokiReforgeItem,gg_unit_H00P_0260)
        call SetItemPositionLoc(udg_LokiReforgeItem,udg_LokiForgeSpot)
    endif
    if(Trig_Dwarves_Disappear_SmithItemAHeld())then
        call UnitRemoveItemSwapped(udg_ForgeGearSlot,gg_unit_Hmbr_0140)
        call SetItemPositionLoc(udg_ForgeGearSlot,udg_ForgeDropPoint)
    endif
    if(Trig_Dwarves_Disappear_SmithItemBHeld())then
        call UnitRemoveItemSwapped(udg_ForgeMaterialSlot,gg_unit_Hmbr_0140)
        call SetItemPositionLoc(udg_ForgeMaterialSlot,udg_ForgeDropPoint)
    endif
    call ShowUnitHide(gg_unit_h00R_0256)
    call ShowUnitHide(gg_unit_Hmbr_0140)
    call ShowUnitHide(gg_unit_H00P_0260)
    call ShowUnitHide(gg_unit_H036_0254)
    call ShowUnitHide(gg_unit_h00Q_0255)
    call ShowUnitHide(gg_unit_h037_0257)
    set udg_TempPoint=GetRectCenter(gg_rct_698)
    call SetUnitPositionLocFacingBJ(gg_unit_n012_0163,udg_TempPoint,bj_UNIT_FACING)
    call RemoveLocation(udg_TempPoint)
    set udg_QuestMarkerEffect[2]=AddSpecialEffectTargetUnitBJ("head",gg_unit_n012_0163,"Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl")
    call EnableTrigger(gg_trg_Npc_Talk_Reno)
    call EnableTrigger(gg_trg_Quest_DwarfDisappearance_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Dwarves automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Dwarves (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Dwarves takes nothing returns nothing
endfunction

function Register_Dwarves_Disappear takes nothing returns nothing
    set gg_trg_Dwarves_Disappear=CreateTrigger()
    call DisableTrigger(gg_trg_Dwarves_Disappear)
    call TriggerAddAction(gg_trg_Dwarves_Disappear,function Trig_Dwarves_Disappear_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Dwarves takes nothing returns nothing
    call Register_Dwarves_Disappear()
endfunction

endlibrary

library TFillVial requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_FillVial_Cast=null
endglobals

function Trig_FillVial_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A12H') // 'A12H': ability "Fill Vial"
endfunction

function Trig_FillVial_Cast_Cond_TargetBloodFountain takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='nbfl') // 'nbfl': object name not found in map data
endfunction

function Trig_FillVial_Cast_Cond_TargetRestorationFountain takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='nfnp') // 'nfnp': unit "Fountain of Restoration"
endfunction

function Trig_FillVial_Cast_Cond_TargetDefiledFountain takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='ndfl') // 'ndfl': unit "Defiled Fountain of Restoration"
endfunction

function Trig_FillVial_Cast_Cond_TargetIsFountain takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='ndfl')or(GetUnitTypeId(GetSpellTargetUnit())=='nfnp')or(GetUnitTypeId(GetSpellTargetUnit())=='nbfl') // 'ndfl': unit "Defiled Fountain of Restoration"; 'nfnp': unit "Fountain of Restoration"; 'nbfl': object name not found in map data
endfunction

function Trig_FillVial_Cast_Cond_ValidFountain takes nothing returns boolean
    return(Trig_FillVial_Cast_Cond_TargetIsFountain())
endfunction

function Trig_FillVial_Cast_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_FillVial_Cast_Cond_ValidFountain())then
        call DisplayTimedTextToForce(udg_TempForce,10.,("You filled the vial with the waters of the "+GetUnitName(GetSpellTargetUnit())))
        call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        if(Trig_FillVial_Cast_Cond_TargetDefiledFountain())then
            call CreateItemLoc('I0JL',udg_TempPoint) // 'I0JL': item "Filled Vial"
        else
            if(Trig_FillVial_Cast_Cond_TargetRestorationFountain())then
                call CreateItemLoc('bzbf',udg_TempPoint) // 'bzbf': item "Filled Vial"
            else
                if(Trig_FillVial_Cast_Cond_TargetBloodFountain())then
                    call CreateItemLoc('I0JM',udg_TempPoint) // 'I0JM': item "Filled Vial"
                else
                    call RemoveLocation(udg_TempPoint)
                    call DisplayTimedTextToForce(GetPlayersAll(),10.,"DEBUG: Invalid Fill Vial target!? Please report if you get this message.")
                    call DestroyForce(udg_TempForce)
                    return
                endif
            endif
        endif
        call RemoveLocation(udg_TempPoint)
        set udg_QuestItem[18]=GetLastCreatedItem()
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bzbe')) // 'bzbe': editor label "Empty Vial"
        call UnitAddItemSwapped(udg_QuestItem[18],GetTriggerUnit())
    else
        call DisplayTimedTextToForce(udg_TempForce,10.,"|cffff0000You must target a fountain with this item!|r")
    endif
    call DestroyForce(udg_TempForce)
endfunction

// World Editor calls InitTrig_FillVial automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_FillVial (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_FillVial takes nothing returns nothing
endfunction

function Register_FillVial_Cast takes nothing returns nothing
    set gg_trg_FillVial_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_FillVial_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_FillVial_Cast,Condition(function Trig_FillVial_Cast_Conditions))
    call TriggerAddAction(gg_trg_FillVial_Cast,function Trig_FillVial_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_FillVial takes nothing returns nothing
    call Register_FillVial_Cast()
endfunction

endlibrary

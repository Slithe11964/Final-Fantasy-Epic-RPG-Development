library TMiracle
function Trig_Miracle_Piece_Use_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0UQ')and(GetSpellTargetItem()!=null)and(GetItemType(GetSpellTargetItem())==ITEM_TYPE_CHARGED)and(GetItemLevel(GetSpellTargetItem())>0)and(GetItemCharges(GetSpellTargetItem())>0) // 'A0UQ': ability "Miracle"
endfunction

function Trig_Miracle_Piece_Use_Actions takes nothing returns nothing
    // (item charges of GetSpellTargetItem()) minus (1).
    call SetItemCharges(GetSpellTargetItem(),(GetItemCharges(GetSpellTargetItem())-1))
endfunction

// World Editor calls InitTrig_Miracle automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Miracle (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Miracle takes nothing returns nothing
endfunction

function Register_Miracle_Piece_Use takes nothing returns nothing
    set gg_trg_Miracle_Piece_Use=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Miracle_Piece_Use,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Miracle_Piece_Use,Condition(function Trig_Miracle_Piece_Use_Conditions))
    call TriggerAddAction(gg_trg_Miracle_Piece_Use,function Trig_Miracle_Piece_Use_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Miracle takes nothing returns nothing
    call Register_Miracle_Piece_Use()
endfunction

endlibrary

library TMiracle
function Trig_Miracle_Piece_Use_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0UQ')and(GetSpellTargetItem()!=null)and(GetItemType(GetSpellTargetItem())==ITEM_TYPE_CHARGED)and(GetItemLevel(GetSpellTargetItem())>0)and(GetItemCharges(GetSpellTargetItem())>0) // 'A0UQ': ability "Miracle"
endfunction

function Trig_Miracle_Piece_Use_Actions takes nothing returns nothing
    // (item charges of GetSpellTargetItem()) minus (1).
    call SetItemCharges(GetSpellTargetItem(),(GetItemCharges(GetSpellTargetItem())-1))
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Miracle takes nothing returns nothing
endfunction

function RegisterR11_Miracle_Piece_Use takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Miracle_Piece_Use=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Miracle_Piece_Use,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Miracle_Piece_Use,Condition(function Trig_Miracle_Piece_Use_Conditions))

call TriggerAddAction(gg_trg_Miracle_Piece_Use,function Trig_Miracle_Piece_Use_Actions)

endfunction




endlibrary

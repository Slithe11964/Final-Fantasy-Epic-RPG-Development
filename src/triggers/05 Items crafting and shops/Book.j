library TBook requires TForce
function Trig_Book_TransformGem_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1CD') // 'A1CD': ability "Transform Book"
endfunction

function Trig_Book_TransformGem_Cond_IsFireGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0FQ') // 'I0FQ': item "Fire Gem"
endfunction

function Trig_Book_TransformGem_Cond_IsIceGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0FR') // 'I0FR': item "Ice Gem"
endfunction

function Trig_Book_TransformGem_Cond_IsLightningGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0FS') // 'I0FS': item "Lightning Gem"
endfunction

function Trig_Book_TransformGem_Cond_IsWaterGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0FT') // 'I0FT': item "Water Gem"
endfunction

function Trig_Book_TransformGem_Cond_IsEarthGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0FU') // 'I0FU': item "Earth Gem"
endfunction

function Trig_Book_TransformGem_Cond_IsWindGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0FV') // 'I0FV': item "Wind Gem"
endfunction

function Trig_Book_TransformGem_Cond_IsDarkGem takes nothing returns boolean
    return(GetItemTypeId(GetSpellTargetItem())=='I0G8') // 'I0G8': item "Dark Gem"
endfunction

function Trig_Book_TransformGem_Cond_GemHasSpareCharge takes nothing returns boolean
    return(GetItemCharges(GetSpellTargetItem())>=2)
endfunction

function Trig_Book_TransformGem_Cond_NoBookMatched takes nothing returns boolean
    return(udg_TempItemId=='ciri') // 'ciri': item "Meta Fragment"
endfunction

function Trig_Book_TransformGem_Actions takes nothing returns nothing
    set udg_TempItemId='ciri' // 'ciri': item "Meta Fragment"
    if(Trig_Book_TransformGem_Cond_IsFireGem())then
        set udg_TempItemId='I05U' // 'I05U': item "Book of Flames"
    endif
    if(Trig_Book_TransformGem_Cond_IsIceGem())then
        set udg_TempItemId='I05V' // 'I05V': item "Book of Glaciers"
    endif
    if(Trig_Book_TransformGem_Cond_IsLightningGem())then
        set udg_TempItemId='I05W' // 'I05W': item "Book of Storms"
    endif
    if(Trig_Book_TransformGem_Cond_IsWaterGem())then
        set udg_TempItemId='I05X' // 'I05X': item "Book of Depths"
    endif
    if(Trig_Book_TransformGem_Cond_IsEarthGem())then
        set udg_TempItemId='I05Y' // 'I05Y': item "Book of Tremors"
    endif
    if(Trig_Book_TransformGem_Cond_IsWindGem())then
        set udg_TempItemId='I05Z' // 'I05Z': item "Book of Winds"
    endif
    if(Trig_Book_TransformGem_Cond_IsDarkGem())then
        set udg_TempItemId='I086' // 'I086': item "Akashic Records"
    endif
    if(Trig_Book_TransformGem_Cond_NoBookMatched())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"The target is not a viable Gem to absorb Elemental powers from.")
        call DestroyForce(udg_TempForce)
    else
        if(Trig_Book_TransformGem_Cond_GemHasSpareCharge())then
            // (item charges of GetSpellTargetItem()) minus (1).
            call SetItemCharges(GetSpellTargetItem(),(GetItemCharges(GetSpellTargetItem())-1))
        else
            call RemoveItem(GetSpellTargetItem())
        endif
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BN')) // 'I0BN': item "Book of Elements"
        call UnitAddItemByIdSwapped(udg_TempItemId,GetTriggerUnit())
        set udg_TempItemId='tkno' // 'tkno': object name not found in map data
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Book takes nothing returns nothing
endfunction

function RegisterR11_Book_TransformGem takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Book_TransformGem=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Book_TransformGem,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Book_TransformGem,Condition(function Trig_Book_TransformGem_Conditions))

call TriggerAddAction(gg_trg_Book_TransformGem,function Trig_Book_TransformGem_Actions)

endfunction




endlibrary

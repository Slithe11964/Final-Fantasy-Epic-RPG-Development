library THeroMedicineEvents
function Trig_Hero_Medicine_Pickup_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0A7')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'I0A7': item "Hidden Hero Medicine"
endfunction

function Trig_Hero_Medicine_Pickup_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call EnableTrigger(gg_trg_HeroMedicine_Refill)
    call EnableTrigger(gg_trg_HeroMedicine_Pickup)
endfunction

function InitTrig_Hero_MedicineEvents takes nothing returns nothing
endfunction

endlibrary

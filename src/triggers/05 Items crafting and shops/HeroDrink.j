library THeroDrink requires TMedicine
function Trig_HeroDrink_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0IP') // 'A0IP': ability "Hero Drink"
endfunction

function Trig_HeroDrink_Cast_Actions takes nothing returns nothing
    call Medicine_ApplyTimed(GetTriggerUnit(),(GetUnitAbilityLevel(GetTriggerUnit(),'A0HL')>0)) // 'A0HL': ability "Pharmacology"
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_HeroDrink takes nothing returns nothing
endfunction

function RegisterR11_HeroDrink_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_HeroDrink_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_HeroDrink_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_HeroDrink_Cast,Condition(function Trig_HeroDrink_Cast_Conditions))

call TriggerAddAction(gg_trg_HeroDrink_Cast,function Trig_HeroDrink_Cast_Actions)

endfunction




endlibrary

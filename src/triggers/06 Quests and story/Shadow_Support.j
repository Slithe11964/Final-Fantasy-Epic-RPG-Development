library TShadowSupport
function Trig_Shadow_HeroDrink_Conditions takes nothing returns boolean
    return(GetSpellTargetUnit()==udg_ShadowUnit)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetSpellAbilityId()=='A0FZ') // 'A0FZ': ability "Toss Hero Drink"
endfunction

function Trig_Shadow_HeroDrink_Actions takes nothing returns nothing
    // Increase udg_ShadowLoyalty by 3.
    set udg_ShadowLoyalty=(udg_ShadowLoyalty+3)
endfunction

function InitTrig_Shadow_Support takes nothing returns nothing
endfunction

endlibrary

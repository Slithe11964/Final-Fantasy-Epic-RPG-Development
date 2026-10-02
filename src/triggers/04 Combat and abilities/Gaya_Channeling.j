library TGayaChanneling
function Trig_Gaya_ChannelStart_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0P3' or GetSpellAbilityId()=='A0B4' or GetSpellAbilityId()=='A02L' or GetSpellAbilityId()=='A02K' // 'A0P3': ability "House Portal"; 'A0B4': ability "Break Stun"; 'A02L': ability "Mega Heal"; 'A02K': ability "Mana Transfer"
endfunction

function Trig_Gaya_ChannelStart_Actions takes nothing returns nothing
    // (GetPlayerId(GetOwningPlayer(the triggering unit))) plus (1).
    set udg_GayaReady[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1]=false
endfunction

function Trig_Gaya_ChannelEnd_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0P3' or GetSpellAbilityId()=='A0B4' or GetSpellAbilityId()=='A02L' or GetSpellAbilityId()=='A02K' // 'A0P3': ability "House Portal"; 'A0B4': ability "Break Stun"; 'A02L': ability "Mega Heal"; 'A02K': ability "Mana Transfer"
endfunction

function Trig_Gaya_ChannelEnd_Actions takes nothing returns nothing
    // (GetPlayerId(GetOwningPlayer(the triggering unit))) plus (1).
    set udg_GayaReady[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1]=true
endfunction

function InitTrig_Gaya_Channeling takes nothing returns nothing
endfunction

endlibrary

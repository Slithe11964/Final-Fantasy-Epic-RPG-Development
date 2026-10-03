library TGayaChanneling
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Gaya_ChannelStart=null
    trigger gg_trg_Gaya_ChannelEnd=null
endglobals

function Trig_Gaya_ChannelStart_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0P3' or GetSpellAbilityId()=='A0B4' or GetSpellAbilityId()=='A02L' or GetSpellAbilityId()=='A02K' // 'A0P3': ability "House Portal"; 'A0B4': ability "Break Stun"; 'A02L': ability "Mega Heal"; 'A02K': ability "Mana Transfer"
endfunction

function Trig_Gaya_ChannelStart_Actions takes nothing returns nothing
    set udg_GayaReady[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1]=false
endfunction

function Trig_Gaya_ChannelEnd_Conditions takes nothing returns boolean
    return GetSpellAbilityId()=='A0P3' or GetSpellAbilityId()=='A0B4' or GetSpellAbilityId()=='A02L' or GetSpellAbilityId()=='A02K' // 'A0P3': ability "House Portal"; 'A0B4': ability "Break Stun"; 'A02L': ability "Mega Heal"; 'A02K': ability "Mana Transfer"
endfunction

function Trig_Gaya_ChannelEnd_Actions takes nothing returns nothing
    set udg_GayaReady[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))+1]=true
endfunction

function InitTrig_Gaya_Channeling takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Gaya (module Gaya),
// which keeps the original registration order.

function Register_Gaya_ChannelStart takes nothing returns nothing
    set gg_trg_Gaya_ChannelStart=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ChannelStart,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddCondition(gg_trg_Gaya_ChannelStart,Condition(function Trig_Gaya_ChannelStart_Conditions))
    call TriggerAddAction(gg_trg_Gaya_ChannelStart,function Trig_Gaya_ChannelStart_Actions)
endfunction

function Register_Gaya_ChannelEnd takes nothing returns nothing
    set gg_trg_Gaya_ChannelEnd=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Gaya_ChannelEnd,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerAddCondition(gg_trg_Gaya_ChannelEnd,Condition(function Trig_Gaya_ChannelEnd_Conditions))
    call TriggerAddAction(gg_trg_Gaya_ChannelEnd,function Trig_Gaya_ChannelEnd_Actions)
endfunction

endlibrary

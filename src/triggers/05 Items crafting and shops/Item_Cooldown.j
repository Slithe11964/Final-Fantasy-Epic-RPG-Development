library TItemCooldown requires TAbil, TPlayerPart01
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Item_Cooldown_Start=null
endglobals

// ---- Item ----
function Trig_Item_Cooldown_Start_StartItemCooldown takes player p,real l_dur returns nothing
    // (GetPlayerId(p)) plus (1).
    call TimerStart(udg_SpellCooldownTimer[GetPlayerId(p)+1],l_dur,false,null)
endfunction

function Trig_Item_Cooldown_Start_IsItemAbility takes nothing returns boolean
    return(GetSpellAbilityId()=='A14X')or(GetSpellAbilityId()=='A14W')or(GetSpellAbilityId()=='A14V')or(GetSpellAbilityId()=='A14U')or(GetSpellAbilityId()=='A0KZ')or(GetSpellAbilityId()=='A0L0')or(GetSpellAbilityId()=='A0G5')or(GetSpellAbilityId()=='A0G3')or(GetSpellAbilityId()=='A0G1')or(GetSpellAbilityId()=='A0FY')or(GetSpellAbilityId()=='A0FN')or(GetSpellAbilityId()=='A0FZ')or(GetSpellAbilityId()=='A09L')or(GetSpellAbilityId()=='A0ZH')or(GetSpellAbilityId()=='A164')or(GetSpellAbilityId()=='A165')or(GetSpellAbilityId()=='A166')or(GetSpellAbilityId()=='A167')or(GetSpellAbilityId()=='A168')or(GetSpellAbilityId()=='A169')or(GetSpellAbilityId()=='A16A')or(GetSpellAbilityId()=='A16B')or(GetSpellAbilityId()=='A16C')or(GetSpellAbilityId()=='A16D')or(GetSpellAbilityId()=='AIh1')or(GetSpellAbilityId()=='AIm1')or(GetSpellAbilityId()=='AIh2')or(GetSpellAbilityId()=='AIm2')or(GetSpellAbilityId()=='A04A')or(GetSpellAbilityId()=='A04B')or(GetSpellAbilityId()=='A00C')or(GetSpellAbilityId()=='A00I')or(GetSpellAbilityId()=='AIre')or(GetSpellAbilityId()=='A00D')or(GetSpellAbilityId()=='A0C7')or(GetSpellAbilityId()=='A0C6')or(GetSpellAbilityId()=='A07B')or(GetSpellAbilityId()=='A0IP')or(GetSpellAbilityId()=='A0HT') // 'A14X': ability "Toss Potion"; 'A14W': ability "Toss Hi-Potion"; 'A14V': ability "Toss Mega Potion"; 'A14U': ability "Toss X-Potion"; 'A0KZ': ability "Toss Nectar"; 'A0L0': ability "Toss Greater Nectar"; 'A0G5': ability "Toss Ether"; 'A0G3': ability "Toss Hi-Ether"; 'A0G1': ability "Toss Mega Ether"; 'A0FY': ability "Toss Turbo Ether"; 'A0FN': ability "Toss Elixir"; 'A0FZ': ability "Toss Hero Drink"; 'A09L': ability "!Megalixir"; 'A0ZH': ability "Spirit of Lowtown"; 'A164': ability "Wild Bowl"; 'A165': ability "Triton Pot"; 'A166': ability "Tropical Dish"; 'A167': ability "Fish Soup"; 'A168': ability "Energy Brew"; 'A169': ability "Swift Drink"; 'A16A': ability "Spiced Salad"; 'A16B': ability "Nebra Bread"; 'A16C': ability "First Class Meat Plate"; 'A16D': ability "Adamant Stew"; 'AIh1': ability "Potion"; 'AIm1': ability "Ether"; 'AIh2': ability "Hi-Potion"; 'AIm2': ability "Hi-Ether"; 'A04A': ability "Mega Potion"; 'A04B': ability "Mega Ether"; 'A00C': ability "X-Potion"; 'A00I': ability "Turbo Ether"; 'AIre': ability "Nectar"; 'A00D': ability "Greater Nectar"; 'A0C7': ability "Spirit Potion"; 'A0C6': ability "Blood Ether"; 'A07B': ability "Elixir"; 'A0IP': ability "Hero Drink"; 'A0HT': ability "Remedy"
endfunction

function Trig_Item_Cooldown_Start_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==Player_GetHero(GetOwningPlayer(GetTriggerUnit())))and(Trig_Item_Cooldown_Start_IsItemAbility())
endfunction

function Trig_Item_Cooldown_Start_Actions takes nothing returns nothing
    call Trig_Item_Cooldown_Start_StartItemCooldown(GetOwningPlayer(GetTriggerUnit()),BlzGetAbilityCooldown(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId())))
    set udg_SpeedrunFlag[5]=true
endfunction

function InitTrig_Item_Cooldown takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Item_Part2 (module Item),
// which keeps the original registration order.

function Register_Item_Cooldown_Start takes nothing returns nothing
    set gg_trg_Item_Cooldown_Start=CreateTrigger()
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(0),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(1),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(2),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(3),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(4),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(5),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(6),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Item_Cooldown_Start,Player(7),EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Item_Cooldown_Start,Condition(function Trig_Item_Cooldown_Start_Conditions))
    call TriggerAddAction(gg_trg_Item_Cooldown_Start,function Trig_Item_Cooldown_Start_Actions)
endfunction

endlibrary

library TItemCooldown requires TAbil, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Item_Cooldown_Start=null
endglobals

// ---- Item ----
function Trig_Item_Cooldown_Start_StartItemCooldown takes player p,real l_dur returns nothing
    call TimerStart(udg_SpellCooldownTimer[GetPlayerId(p)+1],l_dur,false,null)
endfunction

// True for the food and potions that share one cooldown. Takes the spell as an argument so
// that it can judge an item before it is used, not only a spell already being cast.
function Item_Cooldown_IsConsumable takes integer id returns boolean
    return(id=='A14X')or(id=='A14W')or(id=='A14V')or(id=='A14U')or(id=='A0KZ')or(id=='A0L0')or(id=='A0G5')or(id=='A0G3')or(id=='A0G1')or(id=='A0FY')or(id=='A0FN')or(id=='A0FZ')or(id=='A09L')or(id=='A0ZH')or(id=='A164')or(id=='A165')or(id=='A166')or(id=='A167')or(id=='A168')or(id=='A169')or(id=='A16A')or(id=='A16B')or(id=='A16C')or(id=='A16D')or(id=='AIh1')or(id=='AIm1')or(id=='AIh2')or(id=='AIm2')or(id=='A04A')or(id=='A04B')or(id=='A00C')or(id=='A00I')or(id=='AIre')or(id=='A00D')or(id=='A0C7')or(id=='A0C6')or(id=='A07B')or(id=='A0IP')or(id=='A0HT') // 'A14X': ability "Toss Potion"; 'A14W': ability "Toss Hi-Potion"; 'A14V': ability "Toss Mega Potion"; 'A14U': ability "Toss X-Potion"; 'A0KZ': ability "Toss Nectar"; 'A0L0': ability "Toss Greater Nectar"; 'A0G5': ability "Toss Ether"; 'A0G3': ability "Toss Hi-Ether"; 'A0G1': ability "Toss Mega Ether"; 'A0FY': ability "Toss Turbo Ether"; 'A0FN': ability "Toss Elixir"; 'A0FZ': ability "Toss Hero Drink"; 'A09L': ability "!Megalixir"; 'A0ZH': ability "Spirit of Lowtown"; 'A164': ability "Wild Bowl"; 'A165': ability "Triton Pot"; 'A166': ability "Tropical Dish"; 'A167': ability "Fish Soup"; 'A168': ability "Energy Brew"; 'A169': ability "Swift Drink"; 'A16A': ability "Spiced Salad"; 'A16B': ability "Nebra Bread"; 'A16C': ability "First Class Meat Plate"; 'A16D': ability "Adamant Stew"; 'AIh1': ability "Potion"; 'AIm1': ability "Ether"; 'AIh2': ability "Hi-Potion"; 'AIm2': ability "Hi-Ether"; 'A04A': ability "Mega Potion"; 'A04B': ability "Mega Ether"; 'A00C': ability "X-Potion"; 'A00I': ability "Turbo Ether"; 'AIre': ability "Nectar"; 'A00D': ability "Greater Nectar"; 'A0C7': ability "Spirit Potion"; 'A0C6': ability "Blood Ether"; 'A07B': ability "Elixir"; 'A0IP': ability "Hero Drink"; 'A0HT': ability "Remedy"
endfunction

function Trig_Item_Cooldown_Start_IsItemAbility takes nothing returns boolean
    return Item_Cooldown_IsConsumable(GetSpellAbilityId())
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

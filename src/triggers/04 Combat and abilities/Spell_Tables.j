library TSpellTables
globals
    // Variables only this module uses.
    hashtable udg_UnusedHash=null
endglobals

function Trig_Spell_Tables_Init_DisableBrews takes nothing returns nothing
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>$A // $A = 10
        call SetPlayerAbilityAvailableBJ(false,udg_BrewAbility[udg_TempInteger],GetEnumPlayer())
        set udg_TempInteger=udg_TempInteger+1
    endloop
endfunction

function Trig_Spell_Tables_Init_Actions takes nothing returns nothing
    set udg_EffectModelPath[1]="Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl"
    set udg_EffectModelPath[2]="Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl"
    set udg_EffectModelPath[3]="Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
    set udg_EffectModelPath[4]="Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
    set udg_EffectModelPath[5]="Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set udg_EffectModelPath[6]="Abilities\\Spells\\NightElf\\Cyclone\\CycloneTarget.mdl"
    set udg_EffectModelPath[7]="Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl"
    set udg_MeteorDummyAbility[0]='A19O' // 'A19O': ability "Meteor"
    set udg_MeteorDummyAbility[1]='A0X3' // 'A0X3': ability "Meteor"
    set udg_MeteorDummyAbility[2]='A19M' // 'A19M': ability "Meteor"
    set udg_MeteorDummyAbility[3]='A19N' // 'A19N': ability "Meteor"
    set udg_MeteorDummyIndex=0
    set udg_BrewAbility[1]='A18U' // 'A18U': ability "Brew Potion"
    set udg_BrewAbility[2]='A18X' // 'A18X': ability "Brew Ether"
    set udg_BrewAbility[3]='A18Z' // 'A18Z': ability "Brew Hi-Potion"
    set udg_BrewAbility[4]='A191' // 'A191': ability "Brew Hi-Ether"
    set udg_BrewAbility[5]='A195' // 'A195': ability "Brew Hero Drink"
    set udg_BrewAbility[6]='A193' // 'A193': ability "Brew Mega Potion"
    set udg_BrewAbility[7]='A194' // 'A194': ability "Brew Mega Ether"
    set udg_BrewAbility[8]='A18Q' // 'A18Q': ability "Brew Nectar"
    set udg_BrewAbility[9]='A18R' // 'A18R': ability "Brew X-Potion"
    set udg_BrewAbility[$A]='A18S' // $A = 10; 'A18S': ability "Brew Turbo Ether"
    set udg_BrewAbility[$B]='A18T' // $B = 11; 'A18T': ability "Brew Elixir"
    set udg_BrewAbility[$C]='A196' // $C = 12; 'A196': ability "Brew Hero Drink"
    set udg_BrewAbility[$D]='A192' // $D = 13; 'A192': ability "Brew Nectar"
    call ForForce(udg_PlayingPlayers,function Trig_Spell_Tables_Init_DisableBrews)
    call InitHashtableBJ()
    set udg_UnusedHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_LinkedCasterHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_RunicHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_MolotovHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_MaxHpBuffHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_ChannelDrainHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_DivineShieldHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_HealOverTimeHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_AbsorbShieldHash=GetLastCreatedHashtableBJ()
    set udg_GolemUnitType[1]='e000' // 'e000': unit "Golem"
    set udg_GolemUnitType[2]='e000' // 'e000': unit "Golem"
    set udg_GolemUnitType[3]='e000' // 'e000': unit "Golem"
    set udg_GolemUnitType[4]='e000' // 'e000': unit "Golem"
    set udg_GolemUnitType[5]='e005' // 'e005': unit "Golem"
    set udg_GolemUnitType[6]='e005' // 'e005': unit "Golem"
    set udg_GolemUnitType[7]='e005' // 'e005': unit "Golem"
    set udg_GolemUnitType[8]='e005' // 'e005': unit "Golem"
    set udg_GolemUnitType[9]='e005' // 'e005': unit "Golem"
    set udg_GolemUnitType[$A]='e01N' // $A = 10; 'e01N': unit "Golem"
    set udg_GolemUnitType[$B]='e00T' // $B = 11; 'e00T': unit "Golem"
    set udg_ShivaUnitType[1]='e001' // 'e001': unit "Shiva"
    set udg_ShivaUnitType[2]='e001' // 'e001': unit "Shiva"
    set udg_ShivaUnitType[3]='e001' // 'e001': unit "Shiva"
    set udg_ShivaUnitType[4]='e001' // 'e001': unit "Shiva"
    set udg_ShivaUnitType[5]='e00L' // 'e00L': unit "Shiva"
    set udg_ShivaUnitType[6]='e00L' // 'e00L': unit "Shiva"
    set udg_ShivaUnitType[7]='e00L' // 'e00L': unit "Shiva"
    set udg_ShivaUnitType[8]='e00L' // 'e00L': unit "Shiva"
    set udg_ShivaUnitType[9]='e00L' // 'e00L': unit "Shiva"
    set udg_ShivaUnitType[$A]='e006' // $A = 10; 'e006': unit "Shiva"
    set udg_ShivaUnitType[$B]='e00U' // $B = 11; 'e00U': unit "Shiva"
    set udg_IfritUnitType[1]='n003' // 'n003': unit "Ifrit"
    set udg_IfritUnitType[2]='n003' // 'n003': unit "Ifrit"
    set udg_IfritUnitType[3]='n01E' // 'n01E': unit "Ifrit"
    set udg_IfritUnitType[4]='n01E' // 'n01E': unit "Ifrit"
    set udg_IfritUnitType[5]='n01F' // 'n01F': unit "Ifrit"
    set udg_IfritUnitType[6]='n01F' // 'n01F': unit "Ifrit"
    set udg_IfritUnitType[7]='n01F' // 'n01F': unit "Ifrit"
    set udg_IfritUnitType[8]='n01F' // 'n01F': unit "Ifrit"
    set udg_IfritUnitType[9]='n01F' // 'n01F': unit "Ifrit"
    set udg_IfritUnitType[$A]='n01D' // $A = 10; 'n01D': unit "Ifrit"
    set udg_IfritUnitType[$B]='n065' // $B = 11; 'n065': unit "Ifrit"
    set udg_CyclopsUnitType[1]='n004' // 'n004': unit "Cyclops"
    set udg_CyclopsUnitType[2]='n004' // 'n004': unit "Cyclops"
    set udg_CyclopsUnitType[3]='n01G' // 'n01G': unit "Cyclops"
    set udg_CyclopsUnitType[4]='n01G' // 'n01G': unit "Cyclops"
    set udg_CyclopsUnitType[5]='n0K7' // 'n0K7': unit "Cyclops"
    set udg_CyclopsUnitType[6]='n0K7' // 'n0K7': unit "Cyclops"
    set udg_CyclopsUnitType[7]='n08C' // 'n08C': unit "Cyclops"
    set udg_CyclopsUnitType[8]='n08C' // 'n08C': unit "Cyclops"
    set udg_CyclopsUnitType[9]='n08C' // 'n08C': unit "Cyclops"
    set udg_CyclopsUnitType[$A]='n08F' // $A = 10; 'n08F': unit "Cyclops"
    set udg_CyclopsUnitType[$B]='n064' // $B = 11; 'n064': unit "Cyclops"
    set udg_AnimalCompanionUnit[1]='n00R' // 'n00R': unit "Wolf"
    set udg_AnimalCompanionUnit[2]='n00R' // 'n00R': unit "Wolf"
    set udg_AnimalCompanionUnit[3]='n00S' // 'n00S': editor label "Dire Wolf"
    set udg_AnimalCompanionUnit[4]='n00S' // 'n00S': editor label "Dire Wolf"
    set udg_AnimalCompanionUnit[5]='n00T' // 'n00T': editor label "Bear"
    set udg_AnimalCompanionUnit[6]='n00T' // 'n00T': editor label "Bear"
    set udg_AnimalCompanionUnit[7]='n00U' // 'n00U': unit "Dire Bear"
    set udg_AnimalCompanionUnit[8]='n00U' // 'n00U': unit "Dire Bear"
    set udg_AnimalCompanionUnit[9]='n00V' // 'n00V': unit "Ancient Bear"
    set udg_AnimalCompanionUnit[$A]='n00V' // $A = 10; 'n00V': unit "Ancient Bear"
    set udg_AnimalCompanionUnit[$B]='n066' // $B = 11; 'n066': unit "Hellhound"
    set udg_DragonSummonUnit[1]='n01H' // 'n01H': unit "Young Dragon"
    set udg_DragonSummonUnit[2]='n01H' // 'n01H': unit "Young Dragon"
    set udg_DragonSummonUnit[3]='n01I' // 'n01I': unit "Dragon"
    set udg_DragonSummonUnit[4]='n01I' // 'n01I': unit "Dragon"
    set udg_DragonSummonUnit[5]='n01J' // 'n01J': unit "Elder Dragon"
    set udg_DragonSummonUnit[6]='n01J' // 'n01J': unit "Elder Dragon"
    set udg_DragonSummonUnit[7]='n01K' // 'n01K': unit "Ancient Dragon"
    set udg_DragonSummonUnit[8]='n01K' // 'n01K': unit "Ancient Dragon"
    set udg_DragonSummonUnit[9]='n01L' // 'n01L': unit "Ancient Wyrm"
    set udg_DragonSummonUnit[$A]='n01L' // $A = 10; 'n01L': unit "Ancient Wyrm"
    set udg_DragonSummonUnit[$B]='n07S' // $B = 11; 'n07S': unit "Greater Dragon"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Spell_Tables takes nothing returns nothing
endfunction

endlibrary

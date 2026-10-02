library TRemove requires TBerserk, TRunic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Remove_Debuffs=null
    trigger gg_trg_Remove_Buffs=null
endglobals

function Trig_Remove_Debuffs_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",udg_DispelTarget,"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitRemoveBuffBJ('B00P',udg_DispelTarget) // 'B00P': buff tooltip "Blind"
    call UnitRemoveBuffBJ('B00D',udg_DispelTarget) // 'B00D': buff "Cripple"
    call UnitRemoveBuffBJ('B070',udg_DispelTarget) // 'B070': buff tooltip "Death Screech"
    call UnitRemoveBuffBJ('B06J',udg_DispelTarget) // 'B06J': buff tooltip "Deprotect"
    call UnitRemoveBuffBJ('B06K',udg_DispelTarget) // 'B06K': buff tooltip "Deshell"
    call UnitRemoveBuffBJ('B008',udg_DispelTarget) // 'B008': buff tooltip "Exposed"
    call UnitRemoveBuffBJ('B06I',udg_DispelTarget) // 'B06I': buff "Fog"
    call UnitRemoveBuffBJ('B08X',udg_DispelTarget) // 'B08X': buff "Fogra"
    call UnitRemoveBuffBJ('B015',udg_DispelTarget) // 'B015': buff tooltip "Frog"
    call UnitRemoveBuffBJ('Bfro',udg_DispelTarget) // 'Bfro': buff tooltip "Frost"
    call UnitRemoveBuffBJ('B06H',udg_DispelTarget) // 'B06H': buff "Pain"
    call UnitRemoveBuffBJ('B08W',udg_DispelTarget) // 'B08W': buff "Painra"
    call UnitRemoveBuffBJ('Bapl',udg_DispelTarget) // 'Bapl': buff tooltip "Plague"
    call UnitRemoveBuffBJ('B01U',udg_DispelTarget) // 'B01U': buff tooltip "Bio"
    call UnitRemoveBuffBJ('B002',udg_DispelTarget) // 'B002': buff tooltip "Burn"
    call UnitRemoveBuffBJ('B019',udg_DispelTarget) // 'B019': buff tooltip "Power Break"
    call UnitRemoveBuffBJ('B05U',udg_DispelTarget) // 'B05U': buff tooltip "Scourge"
    call UnitRemoveBuffBJ('B013',udg_DispelTarget) // 'B013': buff tooltip "Shock"
    call UnitRemoveBuffBJ('B073',udg_DispelTarget) // 'B073': buff tooltip "Shock"
    call UnitRemoveBuffBJ('B02C',udg_DispelTarget) // 'B02C': buff tooltip "Silence"
    call UnitRemoveBuffBJ('Bslo',udg_DispelTarget) // 'Bslo': buff tooltip "Slow"
    call UnitRemoveBuffBJ('B08Y',udg_DispelTarget) // 'B08Y': buff "Slowra"
    call UnitRemoveBuffBJ('B03F',udg_DispelTarget) // 'B03F': buff tooltip "Slow Breath"
    call UnitRemoveBuffBJ('B00T',udg_DispelTarget) // 'B00T': buff tooltip "Threaten"
    call UnitRemoveBuffBJ('B003',udg_DispelTarget) // 'B003': buff tooltip "Oil"
    call UnitRemoveBuffBJ('B05T',udg_DispelTarget) // 'B05T': buff tooltip "Zombie"
    call Berserk_Remove(udg_DispelTarget)
endfunction

function Trig_Remove_Buffs_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",udg_DispelTarget,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call UnitRemoveBuffBJ('B00F',udg_DispelTarget) // 'B00F': buff "Haste"
    call UnitRemoveBuffBJ('B08T',udg_DispelTarget) // 'B08T': buff "Hastera"
    call UnitRemoveBuffBJ('B006',udg_DispelTarget) // 'B006': buff "Regen"
    call UnitRemoveBuffBJ('B007',udg_DispelTarget) // 'B007': buff "Protect"
    call UnitRemoveBuffBJ('BUfa',udg_DispelTarget) // 'BUfa': object name not found in map data
    call UnitRemoveBuffBJ('B005',udg_DispelTarget) // 'B005': buff "Shell"
    call UnitRemoveBuffBJ('B01W',udg_DispelTarget) // 'B01W': buff "Bravery"
    call UnitRemoveBuffBJ('B05A',udg_DispelTarget) // 'B05A': buff "Faith"
    call UnitRemoveBuffBJ('B07F',udg_DispelTarget) // 'B07F': buff "Haste"
    call UnitRemoveBuffBJ('B07G',udg_DispelTarget) // 'B07G': buff "Protect"
    call UnitRemoveBuffBJ('B08R',udg_DispelTarget) // 'B08R': buff "Protectra"
    call UnitRemoveBuffBJ('B07H',udg_DispelTarget) // 'B07H': buff "Shell"
    call UnitRemoveBuffBJ('B08S',udg_DispelTarget) // 'B08S': buff "Shellra"
    call UnitRemoveBuffBJ('B07I',udg_DispelTarget) // 'B07I': buff "Bravery"
    call UnitRemoveBuffBJ('B08P',udg_DispelTarget) // 'B08P': buff "Bravera"
    call UnitRemoveBuffBJ('B07J',udg_DispelTarget) // 'B07J': buff "Faith"
    call UnitRemoveBuffBJ('B08Q',udg_DispelTarget) // 'B08Q': buff "Faithra"
    call UnitRemoveBuffBJ('B06T',udg_DispelTarget) // 'B06T': buff tooltip "Sharp Eye"
    call UnitRemoveBuffBJ('B06W',udg_DispelTarget) // 'B06W': buff tooltip "Mirage"
    call UnitRemoveBuffBJ('B00X',udg_DispelTarget) // 'B00X': buff tooltip "Blessing of Might"
    call UnitRemoveBuffBJ('B00S',udg_DispelTarget) // 'B00S': buff tooltip "Praise"
    call UnitRemoveBuffBJ('B06F',udg_DispelTarget) // 'B06F': buff tooltip "Surge"
    call UnitRemoveBuffBJ('Broa',udg_DispelTarget) // 'Broa': buff tooltip "Roar"
    call Runic_Remove(udg_DispelTarget)
endfunction

// World Editor calls InitTrig_Remove automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Remove (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Remove takes nothing returns nothing
endfunction

function Register_Remove_Debuffs takes nothing returns nothing
    set gg_trg_Remove_Debuffs=CreateTrigger()
    call DisableTrigger(gg_trg_Remove_Debuffs)
    call TriggerAddAction(gg_trg_Remove_Debuffs,function Trig_Remove_Debuffs_Actions)
endfunction

function Register_Remove_Buffs takes nothing returns nothing
    set gg_trg_Remove_Buffs=CreateTrigger()
    call DisableTrigger(gg_trg_Remove_Buffs)
    call TriggerAddAction(gg_trg_Remove_Buffs,function Trig_Remove_Buffs_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Remove takes nothing returns nothing
    call Register_Remove_Debuffs()
    call Register_Remove_Buffs()
endfunction

endlibrary

library TSpellShared requires TAbil
function Spell_StoreManaCost takes nothing returns nothing
    set udg_SpellManaCost=BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))
endfunction

function InitTrig_Spell_Shared takes nothing returns nothing
endfunction

endlibrary

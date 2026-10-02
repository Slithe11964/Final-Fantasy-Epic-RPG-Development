library TAbil
function Abil_CopyOne takes unit u,unit t,integer a returns boolean
    if(GetUnitAbilityLevel(u,a)>0)then
        return UnitAddAbility(t,a)
    endif
    return false
endfunction

function Abil_CopyPassives takes unit u,unit t returns nothing
    call Abil_CopyOne(u,t,'A0P9') // 'A0P9': ability "Focus"
    call Abil_CopyOne(u,t,'A0RF') // 'A0RF': ability "Serenity"
    call Abil_CopyOne(u,t,'A0PA') // 'A0PA': ability "Adrenaline"
    call Abil_CopyOne(u,t,'A0RG') // 'A0RG': ability "Spellbreaker"
    call Abil_CopyOne(u,t,'A0T9') // 'A0T9': ability "Last Stand"
    call Abil_CopyOne(u,t,'A0ME') // 'A0ME': ability "Omni Ward"
    call Abil_CopyOne(u,t,'A0LV') // 'A0LV': ability "Fire Resistance"
    call Abil_CopyOne(u,t,'A0LW') // 'A0LW': ability "Ice Resistance"
    call Abil_CopyOne(u,t,'A0LX') // 'A0LX': ability "Thunder Resistance"
    call Abil_CopyOne(u,t,'A0LY') // 'A0LY': ability "Water Resistance"
    call Abil_CopyOne(u,t,'A0LZ') // 'A0LZ': ability "Earth Resistance"
    call Abil_CopyOne(u,t,'A0M0') // 'A0M0': ability "Wind Resistance"
    call Abil_CopyOne(u,t,'A1A4') // 'A1A4': ability "Non-elemental Damage"
    call Abil_CopyOne(u,t,'A15B') // 'A15B': ability "Omni Boost"
    call Abil_CopyOne(u,t,'A15C') // 'A15C': ability "Fire Boost"
    call Abil_CopyOne(u,t,'A15E') // 'A15E': ability "Ice Boost"
    call Abil_CopyOne(u,t,'A15D') // 'A15D': ability "Thunder Boost"
    call Abil_CopyOne(u,t,'A15F') // 'A15F': ability "Water Boost"
    call Abil_CopyOne(u,t,'A15G') // 'A15G': ability "Earth Boost"
    call Abil_CopyOne(u,t,'A15H') // 'A15H': ability "Wind Boost"
    call Abil_CopyOne(u,t,'A19Y') // 'A19Y': ability "Omni Knowledge"
    call Abil_CopyOne(u,t,'A19S') // 'A19S': ability "Fire Knowledge"
    call Abil_CopyOne(u,t,'A19T') // 'A19T': ability "Ice Knowledge"
    call Abil_CopyOne(u,t,'A19U') // 'A19U': ability "Thunder Knowledge"
    call Abil_CopyOne(u,t,'A19V') // 'A19V': ability "Water Knowledge"
    call Abil_CopyOne(u,t,'A19W') // 'A19W': ability "Earth Knowledge"
    call Abil_CopyOne(u,t,'A19X') // 'A19X': ability "Wind Knowledge"
    call Abil_CopyOne(u,t,'A0MG') // 'A0MG': ability "Omni Spell Amplification"
    call Abil_CopyOne(u,t,'A0LJ') // 'A0LJ': ability "Fire Spell Amplification"
    call Abil_CopyOne(u,t,'A0LK') // 'A0LK': ability "Ice Spell Amplification"
    call Abil_CopyOne(u,t,'A0LL') // 'A0LL': ability "Thunder Spell Amplification"
    call Abil_CopyOne(u,t,'A0LM') // 'A0LM': ability "Water Spell Amplification"
    call Abil_CopyOne(u,t,'A0LN') // 'A0LN': ability "Earth Spell Amplification"
    call Abil_CopyOne(u,t,'A0LO') // 'A0LO': ability "Wind Spell Amplification"
    call Abil_CopyOne(u,t,'A0MI') // 'A0MI': ability "Omni Orb Amplification"
    call Abil_CopyOne(u,t,'A0M7') // 'A0M7': ability "Fire Orb Amplification"
    call Abil_CopyOne(u,t,'A0M8') // 'A0M8': ability "Ice Orb Amplification"
    call Abil_CopyOne(u,t,'A0M9') // 'A0M9': ability "Thunder Orb Amplification"
    call Abil_CopyOne(u,t,'A0MA') // 'A0MA': ability "Water Orb Amplification"
    call Abil_CopyOne(u,t,'A0MB') // 'A0MB': ability "Earth Orb Amplification"
    call Abil_CopyOne(u,t,'A0MC') // 'A0MC': ability "Wind Orb Amplification"
endfunction

function Abil_GetLevel takes unit u,integer l_abilId returns integer
    local integer l_level=GetUnitAbilityLevel(u,l_abilId)
    if udg_AbilityLevelShift then
        // (l_level) minus (1).
        return l_level-1
    else
        return l_level
    endif
endfunction

function InitTrig_Abil takes nothing returns nothing
endfunction

endlibrary

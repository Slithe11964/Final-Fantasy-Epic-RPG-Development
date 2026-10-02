library TElement requires TProf
globals
    // Variables only this module uses.
    integer array udg_ElementDamageAbil
    integer array udg_ElementBoostBuff
endglobals

function Element_InitTables takes nothing returns nothing
    set udg_ElementOpposite[1]=2
    set udg_ElementOpposite[2]=1
    set udg_ElementOpposite[3]=4
    set udg_ElementOpposite[4]=3
    set udg_ElementOpposite[5]=6
    set udg_ElementOpposite[6]=5
    set udg_ElementWeaknessAbil[1]='A0LP' // 'A0LP': ability "Fire Weakness"
    set udg_ElementWeaknessAbil[2]='A0LQ' // 'A0LQ': ability "Ice Weakness"
    set udg_ElementWeaknessAbil[3]='A0LR' // 'A0LR': ability "Thunder Weakness"
    set udg_ElementWeaknessAbil[4]='A0LS' // 'A0LS': ability "Water Weakness"
    set udg_ElementWeaknessAbil[5]='A0LT' // 'A0LT': ability "Earth Weakness"
    set udg_ElementWeaknessAbil[6]='A0LU' // 'A0LU': ability "Wind Weakness"
    set udg_ElementWeaknessAbil[7]='A0MH' // 'A0MH': ability "Omni Weakness"
    set udg_ElementResistAbil[1]='A0LV' // 'A0LV': ability "Fire Resistance"
    set udg_ElementResistAbil[2]='A0LW' // 'A0LW': ability "Ice Resistance"
    set udg_ElementResistAbil[3]='A0LX' // 'A0LX': ability "Thunder Resistance"
    set udg_ElementResistAbil[4]='A0LY' // 'A0LY': ability "Water Resistance"
    set udg_ElementResistAbil[5]='A0LZ' // 'A0LZ': ability "Earth Resistance"
    set udg_ElementResistAbil[6]='A0M0' // 'A0M0': ability "Wind Resistance"
    set udg_ElementResistAbil[7]='A0ME' // 'A0ME': ability "Omni Ward"
    set udg_ElementImmunityAbil[1]='A0ST' // 'A0ST': ability "Fire Immunity"
    set udg_ElementImmunityAbil[2]='A0SU' // 'A0SU': ability "Ice Immunity"
    set udg_ElementImmunityAbil[3]='A0SV' // 'A0SV': ability "Thunder Immunity"
    set udg_ElementImmunityAbil[4]='A0SW' // 'A0SW': ability "Water Immunity"
    set udg_ElementImmunityAbil[5]='A0SY' // 'A0SY': ability "Earth Immunity"
    set udg_ElementImmunityAbil[6]='A0SX' // 'A0SX': ability "Wind Immunity"
    set udg_ElementImmunityAbil[7]='A1DN' // 'A1DN': ability "Omni Wall"
    set udg_ElementAbsorbAbil[1]='A0SZ' // 'A0SZ': ability "Fire Absorption"
    set udg_ElementAbsorbAbil[2]='A0T0' // 'A0T0': ability "Ice Absorption"
    set udg_ElementAbsorbAbil[3]='A0T1' // 'A0T1': ability "Thunder Absorption"
    set udg_ElementAbsorbAbil[4]='A0T2' // 'A0T2': ability "Water Absorption"
    set udg_ElementAbsorbAbil[5]='A0T3' // 'A0T3': ability "Earth Absorption"
    set udg_ElementAbsorbAbil[6]='A0T4' // 'A0T4': ability "Wind Absorption"
    set udg_ElementAbsorbAbil[7]='A1DO' // 'A1DO': ability "Omni Absorb"
    set udg_ElementDamageAbil[1]='A0M1' // 'A0M1': ability "Fire-elemental Damage"
    set udg_ElementDamageAbil[2]='A0M2' // 'A0M2': ability "Ice-elemental Damage"
    set udg_ElementDamageAbil[3]='A0M3' // 'A0M3': ability "Thunder-elemental Damage"
    set udg_ElementDamageAbil[4]='A0M4' // 'A0M4': ability "Water-elemental Damage"
    set udg_ElementDamageAbil[5]='A0M5' // 'A0M5': ability "Earth-elemental Damage"
    set udg_ElementDamageAbil[6]='A0M6' // 'A0M6': ability "Wind-elemental Damage"
    set udg_ElementDamageAbil[7]='A0MF' // 'A0MF': ability "Omni-elemental Damage"
    set udg_ElementAttackAbil[1]='A0LD' // 'A0LD': ability "Fire-elemental Attack"
    set udg_ElementAttackAbil[2]='A0LE' // 'A0LE': ability "Ice-elemental Attack"
    set udg_ElementAttackAbil[3]='A0LF' // 'A0LF': ability "Thunder-elemental Attack"
    set udg_ElementAttackAbil[4]='A0LG' // 'A0LG': ability "Water-elemental Attack"
    set udg_ElementAttackAbil[5]='A0LH' // 'A0LH': ability "Earth-elemental Attack"
    set udg_ElementAttackAbil[6]='A0LI' // 'A0LI': ability "Wind-elemental Attack"
    set udg_ElementAttackAbil[7]='A0MD' // 'A0MD': ability "Omnistrike"
    set udg_ElementKnowledgeAbil[1]='A19S' // 'A19S': ability "Fire Knowledge"
    set udg_ElementKnowledgeAbil[2]='A19T' // 'A19T': ability "Ice Knowledge"
    set udg_ElementKnowledgeAbil[3]='A19U' // 'A19U': ability "Thunder Knowledge"
    set udg_ElementKnowledgeAbil[4]='A19V' // 'A19V': ability "Water Knowledge"
    set udg_ElementKnowledgeAbil[5]='A19W' // 'A19W': ability "Earth Knowledge"
    set udg_ElementKnowledgeAbil[6]='A19X' // 'A19X': ability "Wind Knowledge"
    set udg_ElementKnowledgeAbil[7]='A19Y' // 'A19Y': ability "Omni Knowledge"
    set udg_ElementBoostAbil[1]='A15C' // 'A15C': ability "Fire Boost"
    set udg_ElementBoostAbil[2]='A15E' // 'A15E': ability "Ice Boost"
    set udg_ElementBoostAbil[3]='A15D' // 'A15D': ability "Thunder Boost"
    set udg_ElementBoostAbil[4]='A15F' // 'A15F': ability "Water Boost"
    set udg_ElementBoostAbil[5]='A15G' // 'A15G': ability "Earth Boost"
    set udg_ElementBoostAbil[6]='A15H' // 'A15H': ability "Wind Boost"
    set udg_ElementBoostAbil[7]='A15B' // 'A15B': ability "Omni Boost"
    set udg_ElementSpellAmpAbil[1]='A0LJ' // 'A0LJ': ability "Fire Spell Amplification"
    set udg_ElementSpellAmpAbil[2]='A0LK' // 'A0LK': ability "Ice Spell Amplification"
    set udg_ElementSpellAmpAbil[3]='A0LL' // 'A0LL': ability "Thunder Spell Amplification"
    set udg_ElementSpellAmpAbil[4]='A0LM' // 'A0LM': ability "Water Spell Amplification"
    set udg_ElementSpellAmpAbil[5]='A0LN' // 'A0LN': ability "Earth Spell Amplification"
    set udg_ElementSpellAmpAbil[6]='A0LO' // 'A0LO': ability "Wind Spell Amplification"
    set udg_ElementSpellAmpAbil[7]='A0MG' // 'A0MG': ability "Omni Spell Amplification"
    set udg_ElementOrbAmpAbil[1]='A0M7' // 'A0M7': ability "Fire Orb Amplification"
    set udg_ElementOrbAmpAbil[2]='A0M8' // 'A0M8': ability "Ice Orb Amplification"
    set udg_ElementOrbAmpAbil[3]='A0M9' // 'A0M9': ability "Thunder Orb Amplification"
    set udg_ElementOrbAmpAbil[4]='A0MA' // 'A0MA': ability "Water Orb Amplification"
    set udg_ElementOrbAmpAbil[5]='A0MB' // 'A0MB': ability "Earth Orb Amplification"
    set udg_ElementOrbAmpAbil[6]='A0MC' // 'A0MC': ability "Wind Orb Amplification"
    set udg_ElementOrbAmpAbil[7]='A0MI' // 'A0MI': ability "Omni Orb Amplification"
    set udg_ElementBoostBuff[1]='B065' // 'B065': buff tooltip "Fire Break"
    set udg_ElementBoostBuff[2]='B066' // 'B066': buff tooltip "Ice Break"
    set udg_ElementBoostBuff[3]='B067' // 'B067': buff tooltip "Thunder Break"
    set udg_ElementBoostBuff[4]='B068' // 'B068': buff tooltip "Water Break"
    set udg_ElementBoostBuff[5]='B069' // 'B069': buff tooltip "Earth Break"
    set udg_ElementBoostBuff[6]='B06A' // 'B06A': buff tooltip "Wind Break"
    set udg_ElementBoostBuff[7]=0
    set udg_ElementEnchantBuff[1]='B05C' // 'B05C': buff "Enfire"
    set udg_ElementEnchantBuff[2]='B05D' // 'B05D': buff "Enfrost"
    set udg_ElementEnchantBuff[3]='B05E' // 'B05E': buff "Enthunder"
    set udg_ElementEnchantBuff[4]='B05F' // 'B05F': buff "Enwater"
    set udg_ElementEnchantBuff[5]='B05G' // 'B05G': buff "Enstone"
    set udg_ElementEnchantBuff[6]='B05H' // 'B05H': buff "Enaero"
    set udg_ElementEnchantBuff[7]=0
    set udg_ElementAilmentBuff[1]='B003' // 'B003': buff tooltip "Oil"
    set udg_ElementAilmentBuff[2]='B013' // 'B013': buff tooltip "Shock"
    set udg_ElementAilmentBuff[3]='B00D' // 'B00D': buff "Cripple"
    set udg_ElementAilmentBuff[4]='Bfro' // 'Bfro': buff tooltip "Frost"
    set udg_ElementAilmentBuff[5]='B05M' // 'B05M': buff tooltip "Immobilize"
    set udg_ElementAilmentBuff[6]='B002' // 'B002': buff tooltip "Burn"
    set udg_ElementAilmentBuff[7]=0
    set udg_ElementAilmentBuff2[1]=0
    set udg_ElementAilmentBuff2[2]='B073' // 'B073': buff tooltip "Shock"
    set udg_ElementAilmentBuff2[3]=0
    set udg_ElementAilmentBuff2[4]='B00L' // 'B00L': buff tooltip "Freeze"
    set udg_ElementAilmentBuff2[5]='B08L' // 'B08L': buff tooltip "Heavy"
    set udg_ElementAilmentBuff2[6]=0
    set udg_ElementAilmentBuff2[7]=0
endfunction

function Element_GetOfUnit takes unit u,boolean l_isPhysical returns integer
    if(l_isPhysical)then
        if(GetUnitAbilityLevel(u,'B05C')>0)then // 'B05C': buff "Enfire"
            return 1
        elseif(GetUnitAbilityLevel(u,'B05D')>0)then // 'B05D': buff "Enfrost"
            return 2
        elseif(GetUnitAbilityLevel(u,'B05E')>0)then // 'B05E': buff "Enthunder"
            return 3
        elseif(GetUnitAbilityLevel(u,'B05F')>0)then // 'B05F': buff "Enwater"
            return 4
        elseif(GetUnitAbilityLevel(u,'B05G')>0)then // 'B05G': buff "Enstone"
            return 5
        elseif(GetUnitAbilityLevel(u,'B05H')>0)then // 'B05H': buff "Enaero"
            return 6
        endif
    endif
    if(GetUnitAbilityLevel(u,'A0MF')>0)then // 'A0MF': ability "Omni-elemental Damage"
        return 7
    elseif(GetUnitAbilityLevel(u,'A0M1')>0)then // 'A0M1': ability "Fire-elemental Damage"
        return 1
    elseif(GetUnitAbilityLevel(u,'A0M2')>0)then // 'A0M2': ability "Ice-elemental Damage"
        return 2
    elseif(GetUnitAbilityLevel(u,'A0M3')>0)then // 'A0M3': ability "Thunder-elemental Damage"
        return 3
    elseif(GetUnitAbilityLevel(u,'A0M4')>0)then // 'A0M4': ability "Water-elemental Damage"
        return 4
    elseif(GetUnitAbilityLevel(u,'A0M5')>0)then // 'A0M5': ability "Earth-elemental Damage"
        return 5
    elseif(GetUnitAbilityLevel(u,'A0M6')>0)then // 'A0M6': ability "Wind-elemental Damage"
        return 6
    elseif(l_isPhysical)then
        if(GetUnitAbilityLevel(u,'A0MD')>0)then // 'A0MD': ability "Omnistrike"
            return 7
        elseif(GetUnitAbilityLevel(u,'A0LD')>0)then // 'A0LD': ability "Fire-elemental Attack"
            return 1
        elseif(GetUnitAbilityLevel(u,'A0LE')>0)then // 'A0LE': ability "Ice-elemental Attack"
            return 2
        elseif(GetUnitAbilityLevel(u,'A0LF')>0)then // 'A0LF': ability "Thunder-elemental Attack"
            return 3
        elseif(GetUnitAbilityLevel(u,'A0LG')>0)then // 'A0LG': ability "Water-elemental Attack"
            return 4
        elseif(GetUnitAbilityLevel(u,'A0LH')>0)then // 'A0LH': ability "Earth-elemental Attack"
            return 5
        elseif(GetUnitAbilityLevel(u,'A0LI')>0)then // 'A0LI': ability "Wind-elemental Attack"
            return 6
        elseif(Prof_GetLevel(u,'R002')>0)then // 'R002': upgrade "Bow"
            if(GetUnitAbilityLevel(u,'A0YI')>0)then // 'A0YI': ability "Bow: Ice-elemental Attack"
                return 2
            elseif(GetUnitAbilityLevel(u,'A0YG')>0)then // 'A0YG': ability "Bow: Thunder-elemental Attack"
                return 3
            elseif(GetUnitAbilityLevel(u,'A0YH')>0)then // 'A0YH': ability "Bow: Wind-elemental Attack"
                return 6
            elseif(Prof_GetLevel(u,'R00M')>0)then // 'R00M': upgrade "Gun"
                if(GetUnitAbilityLevel(u,'A0YD')>0)then // 'A0YD': ability "Gun: Fire-elemental Attack"
                    return 1
                elseif(GetUnitAbilityLevel(u,'A0YF')>0)then // 'A0YF': ability "Gun: Water-elemental Attack"
                    return 4
                elseif(GetUnitAbilityLevel(u,'A0YE')>0)then // 'A0YE': ability "Gun: Earth-elemental Attack"
                    return 5
                endif
            endif
        elseif(Prof_GetLevel(u,'R00M')>0)then // 'R00M': upgrade "Gun"
            if(GetUnitAbilityLevel(u,'A0YD')>0)then // 'A0YD': ability "Gun: Fire-elemental Attack"
                return 1
            elseif(GetUnitAbilityLevel(u,'A0YF')>0)then // 'A0YF': ability "Gun: Water-elemental Attack"
                return 4
            elseif(GetUnitAbilityLevel(u,'A0YE')>0)then // 'A0YE': ability "Gun: Earth-elemental Attack"
                return 5
            endif
        endif
    endif
    return 0
endfunction

function Element_SetFromUnit takes unit l_source,boolean l_isPhysical returns nothing
    if(udg_DamageElement==0)then
        set udg_DamageElement=Element_GetOfUnit(l_source,l_isPhysical)
    endif
endfunction

function InitTrig_Element takes nothing returns nothing
endfunction

endlibrary

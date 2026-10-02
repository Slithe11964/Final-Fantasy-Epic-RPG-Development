library TGayaScan requires TDamage, TElement, TForce
function Trig_Gaya_Scan_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A11U') // 'A11U': ability "Scan"
endfunction

function Trig_Gaya_Scan_Cond_ItemUnowned takes nothing returns boolean
    return(GetItemUserData(GetSpellTargetItem())==0)or(GetItemUserData(GetSpellTargetItem())==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Gaya_Scan_Cond_ItemClaimable takes nothing returns boolean
    return(Trig_Gaya_Scan_Cond_ItemUnowned())
endfunction

function Trig_Gaya_Scan_Cond_TargetIsItem takes nothing returns boolean
    return(GetSpellTargetItem()!=null)
endfunction

function Trig_Gaya_Scan_Cond_TargetIsOversoul takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A134',GetSpellTargetUnit())>0) // 'A134': ability "Oversoul"
endfunction

function Trig_Gaya_Scan_Cond_TargetIsHero takes nothing returns boolean
    return(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Gaya_Scan_Cond_TargetHasMana takes nothing returns boolean
    return(BlzGetUnitMaxMana(GetSpellTargetUnit())>0)
endfunction

function Trig_Gaya_Scan_Cond_SpeciesKnown takes nothing returns boolean
    return(udg_TempInteger>0)
endfunction

function Trig_Gaya_Scan_Cond_HasTruecast takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0MY',GetSpellTargetUnit())>0) // 'A0MY': ability "Truecast"
endfunction

function Trig_Gaya_Scan_Cond_HasNullEvasion takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A127',GetSpellTargetUnit())>0) // 'A127': ability "Null Evasion"
endfunction

function Trig_Gaya_Scan_Cond_StrikesAll takes nothing returns boolean
    return(udg_DamageElement==7)
endfunction

function Trig_Gaya_Scan_Cond_StrikesWind takes nothing returns boolean
    return(udg_DamageElement==6)
endfunction

function Trig_Gaya_Scan_Cond_StrikesEarth takes nothing returns boolean
    return(udg_DamageElement==5)
endfunction

function Trig_Gaya_Scan_Cond_StrikesWater takes nothing returns boolean
    return(udg_DamageElement==4)
endfunction

function Trig_Gaya_Scan_Cond_StrikesThunder takes nothing returns boolean
    return(udg_DamageElement==3)
endfunction

function Trig_Gaya_Scan_Cond_StrikesIce takes nothing returns boolean
    return(udg_DamageElement==2)
endfunction

function Trig_Gaya_Scan_Cond_StrikesFire takes nothing returns boolean
    return(udg_DamageElement==1)
endfunction

function Trig_Gaya_Scan_Cond_HasStrikeElement takes nothing returns boolean
    return(udg_DamageElement>0)
endfunction

function Trig_Gaya_Scan_Cond_WeakFire takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LP',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0LV',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0ST',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SZ',GetSpellTargetUnit())<=0) // 'A0LP': ability "Fire Weakness"; 'A0LV': ability "Fire Resistance"; 'A0ST': ability "Fire Immunity"; 'A0SZ': ability "Fire Absorption"
endfunction

function Trig_Gaya_Scan_Cond_WeakIce takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LQ',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0LW',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SU',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T0',GetSpellTargetUnit())<=0) // 'A0LQ': ability "Ice Weakness"; 'A0LW': ability "Ice Resistance"; 'A0SU': ability "Ice Immunity"; 'A0T0': ability "Ice Absorption"
endfunction

function Trig_Gaya_Scan_Cond_WeakThunder takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LR',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0LX',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SV',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T1',GetSpellTargetUnit())<=0) // 'A0LR': ability "Thunder Weakness"; 'A0LX': ability "Thunder Resistance"; 'A0SV': ability "Thunder Immunity"; 'A0T1': ability "Thunder Absorption"
endfunction

function Trig_Gaya_Scan_Cond_WeakWater takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LS',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0LY',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SW',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T2',GetSpellTargetUnit())<=0) // 'A0LS': ability "Water Weakness"; 'A0LY': ability "Water Resistance"; 'A0SW': ability "Water Immunity"; 'A0T2': ability "Water Absorption"
endfunction

function Trig_Gaya_Scan_Cond_WeakEarth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LT',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0LZ',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SY',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T3',GetSpellTargetUnit())<=0) // 'A0LT': ability "Earth Weakness"; 'A0LZ': ability "Earth Resistance"; 'A0SY': ability "Earth Immunity"; 'A0T3': ability "Earth Absorption"
endfunction

function Trig_Gaya_Scan_Cond_WeakWind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LU',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0M0',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SX',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T4',GetSpellTargetUnit())<=0) // 'A0LU': ability "Wind Weakness"; 'A0M0': ability "Wind Resistance"; 'A0SX': ability "Wind Immunity"; 'A0T4': ability "Wind Absorption"
endfunction

function Trig_Gaya_Scan_Cond_WeakOmni takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0MH',GetSpellTargetUnit())>0) // 'A0MH': ability "Omni Weakness"
endfunction

function Trig_Gaya_Scan_Cond_NoOmniDefense takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0ME',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A1DN',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A1DO',GetSpellTargetUnit())<=0) // 'A0ME': ability "Omni Ward"; 'A1DN': ability "Omni Wall"; 'A1DO': ability "Omni Absorb"
endfunction

function Trig_Gaya_Scan_Cond_ShiftEarth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())==6) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftWind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())==5) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftThunder takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())==4) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftWater takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())==3) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftFire takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())==2) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftIce takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())==1) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_HasShiftingElements takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())>0) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_WeakListFilled takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Gaya_Scan_Cond_ResistNonElemental takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11O',GetSpellTargetUnit())>0) // 'A11O': ability "Non-Elemental Resistance"
endfunction

function Trig_Gaya_Scan_Cond_ResistFire takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LV',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0ST',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0SZ',GetSpellTargetUnit())<=0) // 'A0LV': ability "Fire Resistance"; 'A0ST': ability "Fire Immunity"; 'A0SZ': ability "Fire Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ResistIce takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LW',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0SU',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T0',GetSpellTargetUnit())<=0) // 'A0LW': ability "Ice Resistance"; 'A0SU': ability "Ice Immunity"; 'A0T0': ability "Ice Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ResistThunder takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LX',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0SV',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T1',GetSpellTargetUnit())<=0) // 'A0LX': ability "Thunder Resistance"; 'A0SV': ability "Thunder Immunity"; 'A0T1': ability "Thunder Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ResistWater takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LY',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0SW',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T2',GetSpellTargetUnit())<=0) // 'A0LY': ability "Water Resistance"; 'A0SW': ability "Water Immunity"; 'A0T2': ability "Water Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ResistEarth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0LZ',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0SY',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T3',GetSpellTargetUnit())<=0) // 'A0LZ': ability "Earth Resistance"; 'A0SY': ability "Earth Immunity"; 'A0T3': ability "Earth Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ResistWind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0M0',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0SX',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A0T4',GetSpellTargetUnit())<=0) // 'A0M0': ability "Wind Resistance"; 'A0SX': ability "Wind Immunity"; 'A0T4': ability "Wind Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ResistOmni takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0ME',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A1DN',GetSpellTargetUnit())<=0)and(GetUnitAbilityLevelSwapped('A1DO',GetSpellTargetUnit())<=0) // 'A0ME': ability "Omni Ward"; 'A1DN': ability "Omni Wall"; 'A1DO': ability "Omni Absorb"
endfunction

function Trig_Gaya_Scan_Cond_ResistListFilled takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Gaya_Scan_Cond_ImmunePhysical takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0PS',GetSpellTargetUnit())>0) // 'A0PS': ability "Physical Immunity"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneNonElemental takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11P',GetSpellTargetUnit())>0) // 'A11P': ability "Non-Elemental Immunity"
endfunction

function Trig_Gaya_Scan_Cond_ShiftNotFire takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())!=2) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftNotIce takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())!=1) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftNotThunder takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())!=4) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftNotWater takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())!=3) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftNotEarth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())!=6) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ShiftNotWind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())!=5) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneFire takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0ST',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0SZ',GetSpellTargetUnit())<=0) // 'A0ST': ability "Fire Immunity"; 'A0SZ': ability "Fire Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneIce takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SU',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0T0',GetSpellTargetUnit())<=0) // 'A0SU': ability "Ice Immunity"; 'A0T0': ability "Ice Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneThunder takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SV',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0T1',GetSpellTargetUnit())<=0) // 'A0SV': ability "Thunder Immunity"; 'A0T1': ability "Thunder Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneWater takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SW',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0T2',GetSpellTargetUnit())<=0) // 'A0SW': ability "Water Immunity"; 'A0T2': ability "Water Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneEarth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SY',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0T3',GetSpellTargetUnit())<=0) // 'A0SY': ability "Earth Immunity"; 'A0T3': ability "Earth Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneWind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SX',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A0T4',GetSpellTargetUnit())<=0) // 'A0SX': ability "Wind Immunity"; 'A0T4': ability "Wind Absorption"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneOmni takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1DN',GetSpellTargetUnit())>0)and(GetUnitAbilityLevelSwapped('A1DO',GetSpellTargetUnit())<=0) // 'A1DN': ability "Omni Wall"; 'A1DO': ability "Omni Absorb"
endfunction

function Trig_Gaya_Scan_Cond_ShiftingImmunity takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A11N',GetSpellTargetUnit())>0) // 'A11N': ability "Shifting Elements"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneListFilled takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Gaya_Scan_Cond_AbsorbFire takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0SZ',GetSpellTargetUnit())>0) // 'A0SZ': ability "Fire Absorption"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbIce takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T0',GetSpellTargetUnit())>0) // 'A0T0': ability "Ice Absorption"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbThunder takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T1',GetSpellTargetUnit())>0) // 'A0T1': ability "Thunder Absorption"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbWater takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T2',GetSpellTargetUnit())>0) // 'A0T2': ability "Water Absorption"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbEarth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T3',GetSpellTargetUnit())>0) // 'A0T3': ability "Earth Absorption"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbWind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T4',GetSpellTargetUnit())>0) // 'A0T4': ability "Wind Absorption"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbOmni takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A1DO',GetSpellTargetUnit())>0) // 'A1DO': ability "Omni Absorb"
endfunction

function Trig_Gaya_Scan_Cond_AbsorbListFilled takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Gaya_Scan_Cond_ImmuneBlind takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RA',GetSpellTargetUnit())>0) // 'A0RA': ability "Blindproof"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneDisease takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0FX',GetSpellTargetUnit())>0) // 'A0FX': ability "Diseaseproof"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneSleep takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0U6',GetSpellTargetUnit())>0) // 'A0U6': ability "Sleepproof"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneSlow takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0GJ',GetSpellTargetUnit())>0) // 'A0GJ': ability "Auto-Haste"
endfunction

function Trig_Gaya_Scan_Cond_ImmunePain takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WE',GetSpellTargetUnit())>0) // 'A0WE': ability "Auto-Bravery"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneFog takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WG',GetSpellTargetUnit())>0) // 'A0WG': ability "Auto-Faith"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneDeprotect takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A15P',GetSpellTargetUnit())>0) // 'A15P': ability "Auto-Protect"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneDeshell takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A15R',GetSpellTargetUnit())>0) // 'A15R': ability "Auto-Shell"
endfunction

function Trig_Gaya_Scan_Cond_ImmuneStun takes nothing returns boolean
    return(IsUnitInGroup(GetSpellTargetUnit(),udg_BossGroup))
endfunction

function Trig_Gaya_Scan_Cond_StatusListFilled takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Gaya_Scan_Cond_SurgeDefenseOnly takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T9',GetSpellTargetUnit())>0) // 'A0T9': ability "Last Stand"
endfunction

function Trig_Gaya_Scan_Cond_SurgeMagicDefense takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T9',GetSpellTargetUnit())>0) // 'A0T9': ability "Last Stand"
endfunction

function Trig_Gaya_Scan_Cond_SurgeMagicPotency takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RG',GetSpellTargetUnit())>0) // 'A0RG': ability "Spellbreaker"
endfunction

function Trig_Gaya_Scan_Cond_SurgePower takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RG',GetSpellTargetUnit())>0) // 'A0RG': ability "Spellbreaker"
endfunction

function Trig_Gaya_Scan_Cond_SurgePhysDefense takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0T9',GetSpellTargetUnit())>0) // 'A0T9': ability "Last Stand"
endfunction

function Trig_Gaya_Scan_Cond_HasAdrenaline takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0PA',GetSpellTargetUnit())>0) // 'A0PA': ability "Adrenaline"
endfunction

function Trig_Gaya_Scan_Cond_SurgeTextFilled takes nothing returns boolean
    return(udg_TempString!=" ")
endfunction

function Trig_Gaya_Scan_Actions takes nothing returns nothing
    if(Trig_Gaya_Scan_Cond_TargetIsItem())then
        if(Trig_Gaya_Scan_Cond_ItemClaimable())then
            set udg_TempPoint=GetRandomLocInRect(udg_PlayerStartRect[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
            call SetItemPositionLoc(GetSpellTargetItem(),udg_TempPoint)
            call RemoveLocation(udg_TempPoint)
            call UnitAddItemSwapped(GetSpellTargetItem(),udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
        endif
        return
    endif
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Gaya_Scan_Cond_TargetIsHero())then
        call DisplayTimedTextToForce(udg_TempForce,30,(("|cffffcc00"+(GetHeroProperName(GetSpellTargetUnit())+" ("))+(GetUnitName(GetSpellTargetUnit())+")|r")))
    else
        if(Trig_Gaya_Scan_Cond_TargetIsOversoul())then
            call DisplayTimedTextToForce(udg_TempForce,30,("|cffffcc00Oversoul "+(GetUnitName(GetSpellTargetUnit())+"|r")))
        else
            call DisplayTimedTextToForce(udg_TempForce,30,("|cffffcc00"+(GetUnitName(GetSpellTargetUnit())+"|r")))
        endif
    endif
    // Calculation 1:
    // (current health of the spell target) with its decimal part removed.
    // Calculation 2:
    // (maximum health of the spell target) with its decimal part removed.
    call DisplayTimedTextToForce(udg_TempForce,30,(("HP: "+I2S(R2I(GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit()))))+(" / "+I2S(R2I(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetSpellTargetUnit()))))))
    if(Trig_Gaya_Scan_Cond_TargetHasMana())then
        // Calculation 1:
        // (current mana of the spell target) with its decimal part removed.
        // Calculation 2:
        // (maximum mana of the spell target) with its decimal part removed.
        call DisplayTimedTextToForce(udg_TempForce,30,(("MP: "+I2S(R2I(GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit()))))+(" / "+I2S(R2I(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetSpellTargetUnit()))))))
    endif
    set udg_TempInteger=GetUnitTypeId(GetSpellTargetUnit())
    set udg_TempInteger=LoadIntegerBJ(1,udg_TempInteger,udg_MonsterDataHash)
    if(Trig_Gaya_Scan_Cond_SpeciesKnown())then
        call DisplayTimedTextToForce(udg_TempForce,30,("Species: "+udg_SpeciesName[udg_TempInteger]))
    endif
    if(Trig_Gaya_Scan_Cond_HasNullEvasion())then
        call DisplayTimedTextToForce(udg_TempForce,30,"Negates block and dodge chances.")
    else
        // Calculation 1:
        // (Trig_Damage_Engine_GetAccuracy(the spell target)) with its decimal part removed.
        // Calculation 2:
        // (Trig_Damage_Engine_GetEvasion(the spell target)) with its decimal part removed.
        set udg_TempString="Accuracy: "+I2S(R2I(Trig_Damage_Engine_GetAccuracy(GetSpellTargetUnit())))+" / Evasion: "+I2S(R2I(Trig_Damage_Engine_GetEvasion(GetSpellTargetUnit())))
        call DisplayTimedTextToForce(udg_TempForce,30,udg_TempString)
        if(Trig_Gaya_Scan_Cond_HasTruecast())then
            call DisplayTimedTextToForce(udg_TempForce,30,"Spells cannot be blocked or dodged.")
        endif
    endif
    call Element_SetFromUnit(GetSpellTargetUnit(),true)
    if(Trig_Gaya_Scan_Cond_HasStrikeElement())then
        if(Trig_Gaya_Scan_Cond_StrikesFire())then
            call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with Fire.")
        else
            if(Trig_Gaya_Scan_Cond_StrikesIce())then
                call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with Ice.")
            else
                if(Trig_Gaya_Scan_Cond_StrikesThunder())then
                    call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with Thunder.")
                else
                    if(Trig_Gaya_Scan_Cond_StrikesWater())then
                        call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with Water.")
                    else
                        if(Trig_Gaya_Scan_Cond_StrikesEarth())then
                            call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with Earth.")
                        else
                            if(Trig_Gaya_Scan_Cond_StrikesWind())then
                                call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with Wind.")
                            else
                                if(Trig_Gaya_Scan_Cond_StrikesAll())then
                                    call DisplayTimedTextToForce(udg_TempForce,30,"Strikes with all elements.")
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
        set udg_DamageElement=0
    endif
    set udg_TempString=" "
    if(Trig_Gaya_Scan_Cond_HasShiftingElements())then
        if(Trig_Gaya_Scan_Cond_ShiftIce())then
            set udg_TempString=(udg_TempString+"Ice, ")
        else
            if(Trig_Gaya_Scan_Cond_ShiftFire())then
                set udg_TempString=(udg_TempString+"Fire, ")
            else
                if(Trig_Gaya_Scan_Cond_ShiftWater())then
                    set udg_TempString=(udg_TempString+"Water, ")
                else
                    if(Trig_Gaya_Scan_Cond_ShiftThunder())then
                        set udg_TempString=(udg_TempString+"Thunder, ")
                    else
                        if(Trig_Gaya_Scan_Cond_ShiftWind())then
                            set udg_TempString=(udg_TempString+"Wind, ")
                        else
                            if(Trig_Gaya_Scan_Cond_ShiftEarth())then
                                set udg_TempString=(udg_TempString+"Earth, ")
                            endif
                        endif
                    endif
                endif
            endif
        endif
    else
        if(Trig_Gaya_Scan_Cond_NoOmniDefense())then
            if(Trig_Gaya_Scan_Cond_WeakOmni())then
                set udg_TempString=(udg_TempString+"all elements, ")
            else
                if(Trig_Gaya_Scan_Cond_WeakFire())then
                    set udg_TempString=(udg_TempString+"Fire, ")
                endif
                if(Trig_Gaya_Scan_Cond_WeakIce())then
                    set udg_TempString=(udg_TempString+"Ice, ")
                endif
                if(Trig_Gaya_Scan_Cond_WeakThunder())then
                    set udg_TempString=(udg_TempString+"Thunder, ")
                endif
                if(Trig_Gaya_Scan_Cond_WeakWater())then
                    set udg_TempString=(udg_TempString+"Water, ")
                endif
                if(Trig_Gaya_Scan_Cond_WeakEarth())then
                    set udg_TempString=(udg_TempString+"Earth, ")
                endif
                if(Trig_Gaya_Scan_Cond_WeakWind())then
                    set udg_TempString=(udg_TempString+"Wind, ")
                endif
            endif
        endif
    endif
    if(Trig_Gaya_Scan_Cond_WeakListFilled())then
        // (StringLength(udg_TempString)) minus (2).
        call DisplayTimedTextToForce(udg_TempForce,30,(("Weak to"+SubStringBJ(udg_TempString,1,(StringLength(udg_TempString)-2)))+"."))
    endif
    set udg_TempString=" "
    if(Trig_Gaya_Scan_Cond_ResistNonElemental())then
        set udg_TempString=(udg_TempString+"non-elemental attacks, ")
    endif
    if(Trig_Gaya_Scan_Cond_ResistOmni())then
        set udg_TempString=(udg_TempString+"all elements, ")
    else
        if(Trig_Gaya_Scan_Cond_ResistFire())then
            set udg_TempString=(udg_TempString+"Fire, ")
        endif
        if(Trig_Gaya_Scan_Cond_ResistIce())then
            set udg_TempString=(udg_TempString+"Ice, ")
        endif
        if(Trig_Gaya_Scan_Cond_ResistThunder())then
            set udg_TempString=(udg_TempString+"Thunder, ")
        endif
        if(Trig_Gaya_Scan_Cond_ResistWater())then
            set udg_TempString=(udg_TempString+"Water, ")
        endif
        if(Trig_Gaya_Scan_Cond_ResistEarth())then
            set udg_TempString=(udg_TempString+"Earth, ")
        endif
        if(Trig_Gaya_Scan_Cond_ResistWind())then
            set udg_TempString=(udg_TempString+"Wind, ")
        endif
    endif
    if(Trig_Gaya_Scan_Cond_ResistListFilled())then
        // (StringLength(udg_TempString)) minus (2).
        call DisplayTimedTextToForce(udg_TempForce,30,(("Resistant to"+SubStringBJ(udg_TempString,1,(StringLength(udg_TempString)-2)))+"."))
    endif
    set udg_TempString=" "
    if(Trig_Gaya_Scan_Cond_ImmunePhysical())then
        set udg_TempString=(udg_TempString+"physical attacks, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneNonElemental())then
        set udg_TempString=(udg_TempString+"non-elemental attacks, ")
    endif
    if(Trig_Gaya_Scan_Cond_ShiftingImmunity())then
        if(Trig_Gaya_Scan_Cond_ShiftNotFire())then
            set udg_TempString=(udg_TempString+"Fire, ")
        endif
        if(Trig_Gaya_Scan_Cond_ShiftNotIce())then
            set udg_TempString=(udg_TempString+"Ice, ")
        endif
        if(Trig_Gaya_Scan_Cond_ShiftNotThunder())then
            set udg_TempString=(udg_TempString+"Thunder, ")
        endif
        if(Trig_Gaya_Scan_Cond_ShiftNotWater())then
            set udg_TempString=(udg_TempString+"Water, ")
        endif
        if(Trig_Gaya_Scan_Cond_ShiftNotEarth())then
            set udg_TempString=(udg_TempString+"Earth, ")
        endif
        if(Trig_Gaya_Scan_Cond_ShiftNotWind())then
            set udg_TempString=(udg_TempString+"Wind, ")
        endif
    else
        if(Trig_Gaya_Scan_Cond_ImmuneOmni())then
            set udg_TempString=(udg_TempString+"all elements, ")
        else
            if(Trig_Gaya_Scan_Cond_ImmuneFire())then
                set udg_TempString=(udg_TempString+"Fire, ")
            endif
            if(Trig_Gaya_Scan_Cond_ImmuneIce())then
                set udg_TempString=(udg_TempString+"Ice, ")
            endif
            if(Trig_Gaya_Scan_Cond_ImmuneThunder())then
                set udg_TempString=(udg_TempString+"Thunder, ")
            endif
            if(Trig_Gaya_Scan_Cond_ImmuneWater())then
                set udg_TempString=(udg_TempString+"Water, ")
            endif
            if(Trig_Gaya_Scan_Cond_ImmuneEarth())then
                set udg_TempString=(udg_TempString+"Earth, ")
            endif
            if(Trig_Gaya_Scan_Cond_ImmuneWind())then
                set udg_TempString=(udg_TempString+"Wind, ")
            endif
        endif
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneListFilled())then
        // (StringLength(udg_TempString)) minus (2).
        call DisplayTimedTextToForce(udg_TempForce,30,(("Immune to"+SubStringBJ(udg_TempString,1,(StringLength(udg_TempString)-2)))+"."))
    endif
    set udg_TempString=" "
    if(Trig_Gaya_Scan_Cond_AbsorbOmni())then
        set udg_TempString=(udg_TempString+"all elements, ")
    else
        if(Trig_Gaya_Scan_Cond_AbsorbFire())then
            set udg_TempString=(udg_TempString+"Fire, ")
        endif
        if(Trig_Gaya_Scan_Cond_AbsorbIce())then
            set udg_TempString=(udg_TempString+"Ice, ")
        endif
        if(Trig_Gaya_Scan_Cond_AbsorbThunder())then
            set udg_TempString=(udg_TempString+"Thunder, ")
        endif
        if(Trig_Gaya_Scan_Cond_AbsorbWater())then
            set udg_TempString=(udg_TempString+"Water, ")
        endif
        if(Trig_Gaya_Scan_Cond_AbsorbEarth())then
            set udg_TempString=(udg_TempString+"Earth, ")
        endif
        if(Trig_Gaya_Scan_Cond_AbsorbWind())then
            set udg_TempString=(udg_TempString+"Wind, ")
        endif
    endif
    if(Trig_Gaya_Scan_Cond_AbsorbListFilled())then
        // (StringLength(udg_TempString)) minus (2).
        call DisplayTimedTextToForce(udg_TempForce,30,(("Absorbs"+SubStringBJ(udg_TempString,1,(StringLength(udg_TempString)-2)))+"."))
    endif
    set udg_TempString=" "
    if(Trig_Gaya_Scan_Cond_ImmuneBlind())then
        set udg_TempString=(udg_TempString+"Blind, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneDisease())then
        set udg_TempString=(udg_TempString+"Disease, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneSleep())then
        set udg_TempString=(udg_TempString+"Sleep, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneSlow())then
        set udg_TempString=(udg_TempString+"Slow, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmunePain())then
        set udg_TempString=(udg_TempString+"Pain, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneFog())then
        set udg_TempString=(udg_TempString+"Fog, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneDeprotect())then
        set udg_TempString=(udg_TempString+"Deprotect, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneDeshell())then
        set udg_TempString=(udg_TempString+"Deshell, ")
    endif
    if(Trig_Gaya_Scan_Cond_ImmuneStun())then
        set udg_TempString=(udg_TempString+"Stun and Freeze, ")
    endif
    if(Trig_Gaya_Scan_Cond_StatusListFilled())then
        // (StringLength(udg_TempString)) minus (2).
        call DisplayTimedTextToForce(udg_TempForce,30,(("Unaffected by"+SubStringBJ(udg_TempString,1,(StringLength(udg_TempString)-2)))+"."))
    endif
    set udg_TempString=" "
    if(Trig_Gaya_Scan_Cond_HasAdrenaline())then
        if(Trig_Gaya_Scan_Cond_SurgePower())then
            set udg_TempString="Power "
        else
            set udg_TempString="Physical damage "
        endif
        if(Trig_Gaya_Scan_Cond_SurgePhysDefense())then
            set udg_TempString=(udg_TempString+"and defense ")
        endif
    else
        if(Trig_Gaya_Scan_Cond_SurgeMagicPotency())then
            set udg_TempString="Magic potency "
            if(Trig_Gaya_Scan_Cond_SurgeMagicDefense())then
                set udg_TempString=(udg_TempString+"and defense ")
            endif
        else
            if(Trig_Gaya_Scan_Cond_SurgeDefenseOnly())then
                set udg_TempString="Defense "
            endif
        endif
    endif
    if(Trig_Gaya_Scan_Cond_SurgeTextFilled())then
        call DisplayTimedTextToForce(udg_TempForce,30,(udg_TempString+"surges when near death."))
    endif
    call DestroyForce(udg_TempForce)
endfunction

function InitTrig_Gaya_Scan takes nothing returns nothing
endfunction

endlibrary

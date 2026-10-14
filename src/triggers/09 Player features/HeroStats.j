library THeroStats requires TBackpack, TDamage, TElement, TProf, TUnit, TPlayerHero
// -stats: the hero's combat numbers as text, four pages, in both versions. Reforged's Forsaken
// map shows the same numbers in its stat panel; the calculations below come from it (Forsaken
// DZ), reading worn gear from the backpack's equipment pages instead of native equipment slots.
// Regeneration is not shown: 1.29.2 cannot read a unit's regeneration rate.
globals
    trigger gg_trg_HeroStats_Command=null
    constant real STATS_ARMOR_FACTOR=0.02     // the map's armor defense constant
    constant integer STATS_ROWS=16
    string array StatsElementName
    string array StatsLabel
    string array StatsValue
endglobals

function Stats_Row takes integer row,string label,string value returns nothing
    if row>=0 and row<STATS_ROWS then
        set StatsLabel[row]=label
        set StatsValue[row]=value
    endif
endfunction

// The weapon a Two-Handed hero swings: one weapon and nothing in the other hand.
function Stats_TwoHandedWeapon takes unit hero returns item
    call Trig_Damage_Engine_FindTwoHandedItem(hero)
    return udg_TwoHandedItem
endfunction

// Accuracy that worn spears add beyond the formula (Trig_Damage_Engine_GetAccuracy adds it in combat).
function Stats_ItemAccuracy takes unit hero returns real
    local real total=0.
    if Gear_Wears(hero,'I033') then // 'I033': item "Trident"
        set total=total+32.
    endif
    if Gear_Wears(hero,'I0D1') then // 'I0D1': item "Storm Lance"
        set total=total+55.
    endif
    return total
endfunction

function Stats_PageName takes integer page returns string
    if page==0 then
        return "damage bonuses"
    elseif page==1 then
        return "defenses"
    elseif page==2 then
        return "resistances"
    endif
    return "other bonuses"
endfunction

function Stats_DefensePercent takes integer defense returns real
    return 100.*I2R(defense)/I2R(defense+50)
endfunction

function Stats_Stat_GetSpeedBonus takes unit u returns real
    local real l_bonus=.0
    if udg_EternityMode and not IsUnitType(u,UNIT_TYPE_HERO)and GetOwningPlayer(u)==Player($B)then // $B = 11
        set l_bonus=l_bonus+20.
    endif
    if(GetUnitAbilityLevel(u,'A0R6')>0)then // 'A0R6': ability "Dexterity"
        set l_bonus=l_bonus+udg_DexterityBonus
    endif
    if(GetUnitAbilityLevel(u,'A0HX')>0)then // 'A0HX': ability "Swiftness"
        set l_bonus=l_bonus+150.
    endif
    if(GetUnitAbilityLevel(u,'A0AU')>0)then // 'A0AU': ability "Swiftness"
        set l_bonus=l_bonus+120.
    endif
    if(GetUnitAbilityLevel(u,'A0DB')>0)then // 'A0DB': ability "Chocobo Swiftness"
        set l_bonus=l_bonus+100.
    endif
    if(GetUnitAbilityLevel(u,'A0GY')>0)then // 'A0GY': ability "Swiftness"
        set l_bonus=l_bonus+80.
    endif
    if(GetUnitAbilityLevel(u,'A0JL')>0)then // 'A0JL': ability "Swiftness"
        set l_bonus=l_bonus+50.
    endif
    if(GetUnitAbilityLevel(u,'ACev')>0)then // 'ACev': ability "Swiftness"
        set l_bonus=l_bonus+30.
    endif
    return l_bonus
endfunction

function Stats_Stat_GetAccuracy takes unit u returns real
    local real l_acc=Stats_Stat_GetSpeedBonus(u)*.8
    local real ms=GetUnitDefaultMoveSpeed(u)-(GetHeroAgi(u,true)*.4)
    if(ms<=80)then
        set l_acc=l_acc+$96 // $96 = 150
    else
        // (l_acc) plus (((ms) minus (80)) times (0.75)).
        set l_acc=l_acc+(ms-80)*.75
    endif
    if IsUnitType(u,UNIT_TYPE_HERO)then
        set l_acc=l_acc+(I2R(GetHeroAgi(u,true))*.1)
    else
        set l_acc=l_acc+(I2R(GetUnitLevel(u))*.4)
    endif
    if(GetUnitAbilityLevel(u,'A1DI')>0 or GetUnitAbilityLevel(u,'A1DJ')>0)then // 'A1DI': ability "Sukugaya Unit Attack Speed +20%"; 'A1DJ': ability "Sukugaya Hero Bonus"
        set l_acc=l_acc+30.
    endif
    if(GetUnitAbilityLevel(u,'A16L')>0)then // 'A16L': ability "Accuracy"
        set l_acc=l_acc+70.
    endif
    if(GetUnitAbilityLevel(u,'A16R')>0)then // 'A16R': ability "Accuracy"
        set l_acc=l_acc+200.
    endif
    if(GetUnitAbilityLevel(u,'A19E')>0)then // 'A19E': ability "Spear Accuracy"
        set l_acc=l_acc+9.
    endif
    if(GetUnitAbilityLevel(u,'A19G')>0)then // 'A19G': ability "Spear Accuracy"
        set l_acc=l_acc+20.
    endif
    if(GetUnitAbilityLevel(u,'A19F')>0)then // 'A19F': ability "Spear Accuracy"
        set l_acc=l_acc+30.
    endif
    if(GetUnitAbilityLevel(u,'A19H')>0)then // 'A19H': ability "Spear Accuracy"
        set l_acc=l_acc+35.
    endif
    if(GetUnitAbilityLevel(u,'A1A1')>0)then // 'A1A1': ability "Spear Hybrid"
        set l_acc=l_acc+35.
    endif
    if(GetUnitAbilityLevel(u,'A19J')>0)then // 'A19J': ability "Spear Accuracy"
        set l_acc=l_acc+40.
    endif
    if(GetUnitAbilityLevel(u,'A19I')>0)then // 'A19I': ability "Spear Accuracy"
        set l_acc=l_acc+50.
    endif
    if(GetUnitAbilityLevel(u,'A19D')>0)then // 'A19D': ability "Spear Accuracy"
        set l_acc=l_acc+60.
    endif
    if(GetUnitAbilityLevel(u,'A19K')>0)then // 'A19K': ability "Spear Accuracy"
        set l_acc=l_acc+75.
    endif
    if(GetUnitAbilityLevel(u,'A18O')>0)then // 'A18O': ability "Strange Vision Accuracy"
        set l_acc=l_acc+255.
    endif
    if(GetUnitAbilityLevel(u,'A068')>0)then // 'A068': ability "Glasses Accuracy"
        set l_acc=l_acc+40.
    endif
    if(GetUnitAbilityLevel(u,'A02D')>0)then // 'A02D': ability "Rabite's Foot"
        set l_acc=l_acc+120.
    endif
    return l_acc
endfunction

function Stats_Stat_GetEvasion takes unit u returns real
    local real l_eva=Stats_Stat_GetSpeedBonus(u)
    local real ms=GetUnitDefaultMoveSpeed(u)-(GetHeroAgi(u,true)*.4)
    if(GetUnitAbilityLevel(u,'A0EI')>0)then // 'A0EI': ability "Adamant Armor"
        return .0
    endif
    if(ms>80)then
        // (l_eva) plus (((ms) minus (80)) times (0.25)).
        set l_eva=l_eva+(ms-80)*.25
    endif
    if(IsUnitType(u,UNIT_TYPE_HERO)and GetUnitAbilityLevel(u,'A02M')<=0)then // 'A02M': ability "No Evasion From Agility"
        // Result 1: Agility of u treated as a decimal-capable number.
        // Result 2: (result 1) times (0.005).
        // Result 3: (Prof_GetLevel(u, 'R006')) plus (20).
        // Result 4: result 3 treated as a decimal-capable number.
        // Result 5: (result 2) times (result 4).
        // Result 6: (l_eva) plus (result 5).
        set l_eva=l_eva+(I2R(GetHeroAgi(u,true))*.005*I2R(Prof_GetLevel(u,'R006')+20)) // 'R006': upgrade "Leather Armor"
    else
        set l_eva=l_eva+(I2R(GetUnitLevel(u))*.5)
    endif
    if(GetUnitAbilityLevel(u,'A1DI')>0 or GetUnitAbilityLevel(u,'A1DJ')>0)then // 'A1DI': ability "Sukugaya Unit Attack Speed +20%"; 'A1DJ': ability "Sukugaya Hero Bonus"
        set l_eva=l_eva+15.
    endif
    if(GetUnitAbilityLevel(u,'A1DB')>0)then // 'A1DB': ability "Evasion"
        set l_eva=l_eva-80.
    endif
    if(GetUnitAbilityLevel(u,'A16S')>0)then // 'A16S': ability "Evasion"
        set l_eva=l_eva+60.
    endif
    if(GetUnitAbilityLevel(u,'A182')>0)then // 'A182': ability "Kazuma Effect"
        set l_eva=l_eva+30.
    endif
    if(GetUnitAbilityLevel(u,'AIev')>0)then // 'AIev': ability "Jade Collar Evasion"
        set l_eva=l_eva+30.
    endif
    if(GetUnitAbilityLevel(u,'A0QB')>0)then // 'A0QB': ability "Main Gauche Evasion"
        set l_eva=l_eva+50.
    endif
    if(GetUnitAbilityLevel(u,'A1B6')>0)then // 'A1B6': ability "Slither Shield Evasion"
        set l_eva=l_eva+50.
    endif
    if(GetUnitAbilityLevel(u,'A02D')>0)then // 'A02D': ability "Rabite's Foot"
        set l_eva=l_eva+80.
    endif
    if(l_eva<0)then
        set l_eva=.0
    endif
    return l_eva
endfunction

function Stats_Stat_GetElementBonus takes unit u,integer l_element,boolean l_physical returns real
    local real l_bonus=.0
    if(GetUnitAbilityLevel(u,'A0PN')>0 or GetUnitAbilityLevel(u,'B08Z')>0)then // 'A0PN': ability "Gaya Strength"; 'B08Z': buff tooltip "Gaya Strength"
        set l_bonus=l_bonus+.33333
    endif
    if(l_physical and GetUnitAbilityLevel(u,udg_ElementAttackAbil[l_element])>0)then
        set l_bonus=l_bonus+.1
    endif
    if(GetUnitAbilityLevel(u,udg_ElementKnowledgeAbil[l_element])>0)then
        set l_bonus=l_bonus+.5
    endif
    if(GetUnitAbilityLevel(u,udg_ElementBoostAbil[l_element])>0)then
        set l_bonus=l_bonus+.3
    endif
    if(not l_physical and GetUnitAbilityLevel(u,udg_ElementSpellAmpAbil[l_element])>0)then
        set l_bonus=l_bonus+.8
    endif
    if(GetUnitAbilityLevel(u,udg_ElementOrbAmpAbil[l_element])>0)then
        set l_bonus=l_bonus+.6
    endif
    if(l_element==6 and GetUnitAbilityLevel(u,'A1FF')>0)then // 'A1FF': ability "Yatagarasu Power"
        set l_bonus=l_bonus+1.2
    endif
    if(l_element==1 and GetUnitAbilityLevel(u,'A0YW')>0)then // 'A0YW': ability "Gathering Heat"
        if(GetUnitAbilityLevel(u,'A0Z1')>0)then // 'A0Z1': ability "Full Heat"
            set l_bonus=l_bonus+2.
        else
            // (l_bonus) plus ((2) times ((1) minus ((current health of u) divided by (maximum health of u)))).
            set l_bonus=l_bonus+(2.*(1.-(GetUnitState(u,UNIT_STATE_LIFE)/ GetUnitState(u,UNIT_STATE_MAX_LIFE))))
        endif
    endif
    if(l_element==7)then
        set l_bonus=l_bonus*.5
    endif
    if(GetUnitAbilityLevel(u,udg_ElementEnchantBuff[l_element])>0)then
        // (((l_bonus) plus (1)) times (1.2)) minus (1).
        set l_bonus=((l_bonus+1.)*1.2)-1.
    endif
    return l_bonus
endfunction

function Stats_Stat_GetElementResist takes unit u,integer l_element returns integer
    local integer l_tier=3
    local integer i=1
    if(l_element<=0)then
        return 3
    endif
    if(GetUnitAbilityLevel(u,'A11N')>0)then // 'A11N': ability "Shifting Elements"
        if(l_element==7 or l_element==udg_ElementOpposite[GetUnitAbilityLevel(u,'A11N')])then // 'A11N': ability "Shifting Elements"
            return 1
        else
            return 6
        endif
    endif
    if(GetUnitAbilityLevel(u,udg_ElementAbsorbAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementAbsorbAbil[7])>0)then
        set l_tier=7
    elseif(l_tier<6 and(GetUnitAbilityLevel(u,udg_ElementImmunityAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementImmunityAbil[7])>0))then
        set l_tier=6
    elseif(l_tier<5 and(GetUnitAbilityLevel(u,udg_ElementResistAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementResistAbil[7])>0))then
        set l_tier=5
    elseif(l_tier==3 and(GetUnitAbilityLevel(u,udg_ElementWeaknessAbil[l_element])>0 or GetUnitAbilityLevel(u,udg_ElementWeaknessAbil[7])>0))then
        set l_tier=1
    endif
    if(l_element==7 and l_tier==3)then
        loop
            exitwhen i>=7
            if(GetUnitAbilityLevel(u,udg_ElementWeaknessAbil[i])>0)then
                set l_tier=1
                set i=7
            endif
            set i=i+1
        endloop
    endif
    return l_tier
endfunction

function Stats_StatElementDamageBonus takes unit u,integer element,boolean physical returns real
    local real bonus=Stats_Stat_GetElementBonus(u,element,physical)+Stats_Stat_GetElementBonus(u,7,physical)
    if element!=7 and (GetUnitAbilityLevel(u,'A0PN')>0 or GetUnitAbilityLevel(u,'B08Z')>0) then
        // Gaya Strength is already included in this element; remove its duplicate half from Omni.
        set bonus=bonus-.33333*.5
    endif
    return bonus
endfunction

function Stats_StatAttackMultiplier takes unit u returns real
    local integer l_weapon
    local integer l_prof
    local integer l_varied
    local integer i
    local item l_it
    local real l_rate=.04
    local player owningPlayer=GetOwningPlayer(u)
    if(owningPlayer!=Player($B)and u!=Player_GetHero(owningPlayer))then // $B = 11
        set owningPlayer=null
        return 1.5
    endif
    set l_weapon=Prof_GetWeaponUpgrade(u)
    if(l_weapon==0)then
        set l_prof=0
    elseif(l_weapon=='R00N')then // 'R00N': upgrade "Greatsword"
        set l_prof=Prof_GetHybridLevel(u)
    else
        set l_prof=Prof_GetLevel(u,l_weapon)
    endif
    if(GetUnitAbilityLevel(u,'A16Y')>0)then // 'A16Y': ability "Varied Proficiency"
        set l_varied=0
        if(GetUnitAbilityLevel(u,'A135')>0)then // 'A135': ability "Joker Proficiency"
            set l_varied=l_varied+$C // $C = 12
        else
            set l_varied=l_varied+5
        endif
        set i=0
        loop
            set l_it=Gear_WornInSlot(u,i)
            if(l_it!=null and GetItemType(l_it)==ITEM_TYPE_PERMANENT)then
                // ((l_varied) plus (((GetItemLifeBJ(l_it)) with its decimal part removed) divided by (10))) plus (1).
                set l_varied=l_varied+(R2I(GetItemLifeBJ(l_it))/ $A)+1 // $A = 10
            endif
            set i=i+1
            exitwhen i>=GEAR_WORN_SLOTS
        endloop
        set l_it=null
        if(l_varied>l_prof)then
            set l_prof=l_varied
        endif
    endif
    if(GetUnitAbilityLevel(u,'A15J')>0)then // 'A15J': ability "Striker"
        if Unit_HasNoEquipment(u)then
            set l_prof=60
            if(GetUnitAbilityLevel(u,'A136')>0)then // 'A136': ability "High Proficiency"
                set l_prof=90
            endif
        elseif(l_prof<$A)then // $A = 10
            set l_prof=$A // $A = 10
            if(GetUnitAbilityLevel(u,'A136')>0)then // 'A136': ability "High Proficiency"
                set l_prof=$F // $F = 15
            endif
        endif
    endif
    set owningPlayer=null
    if(l_prof>0)then
        if(l_weapon=='R00I')then // 'R00I': upgrade "Heavens Forged Axe"
            set l_rate=.02
        endif
        return I2R(l_prof)*l_rate+1
    else
        return 1.
    endif
endfunction

function Stats_StatSpellPower takes unit u,integer upgradeId,real manaWeight returns real
    local real l_mult=1
    local real currentMana=GetUnitState(u,UNIT_STATE_MANA)
    local real maximumMana=GetUnitState(u,UNIT_STATE_MAX_MANA)
    if IsPlayerInForce(GetOwningPlayer(u),udg_PlayingPlayers)then
        // Start the proficiency factor at 1, then add 0.1 per level: level 3 gives 1.3.
        set l_mult=l_mult+Prof_GetLevel(u,upgradeId)*.1
    endif
    if(maximumMana>0)then
        // Current mana divided by maximum mana is how full the mana bar is.
        // Half full means 0.5; multiply the proficiency factor by that fraction and the mana weight.
        set l_mult=l_mult*(currentMana/ maximumMana)*manaWeight
    endif
    // Add the base multiplier of 1 after the mana-based bonus.
    // Example: factor 1.3, half mana, and weight 0.5 give 1 + 1.3 x 0.5 x 0.5 = 1.325.
    set l_mult=l_mult+1
    if(GetUnitAbilityLevel(u,'B06N')>0)then // 'B06N': buff tooltip "Mind Charge"
        set l_mult=l_mult*2.
    endif
    if(GetUnitAbilityLevel(u,'A16K')>0 and currentMana>=maximumMana)then // 'A16K': ability "Concentration"
        set l_mult=l_mult*1.5
    endif
    return l_mult
endfunction

function Stats_StatBlockRoll takes unit u,boolean physical returns real
    local real miss=1.
    local real chance
    if GetUnitAbilityLevel(u,'A0RT')>0 then
        set miss=miss*.7
    endif
    if GetUnitAbilityLevel(u,'B07R')>0 then
        set chance=I2R(LoadInteger(udg_RunicHash,GetHandleId(u),6))
        if physical then
            set chance=chance*2.
        endif
        set miss=miss*(1.-RMinBJ(100.,RMaxBJ(0.,chance))/100.)
    endif
    if physical then
        if GetUnitAbilityLevel(u,'A0PP')>0 then
            if IsUnitInGroup(u,udg_DefendingUnits) then
                set miss=miss*.7
            else
                set miss=miss*.8
            endif
        endif
        if GetUnitAbilityLevel(u,'A0S0')>0 then
            set miss=miss*(1.-5/100.)
        endif
        if GetUnitAbilityLevel(u,'A0P2')>0 then
            set miss=miss*(1.-10/100.)
        endif
        if GetUnitAbilityLevel(u,'A0PT')>0 then
            set miss=miss*(1.-10/100.)
        endif
        if GetUnitAbilityLevel(u,'A0AM')>0 then
            set miss=miss*(1.-18/100.)
        endif
        if GetUnitAbilityLevel(u,'A05B')>0 then
            set miss=miss*(1.-20/100.)
        endif
        if GetUnitAbilityLevel(u,'A0S6')>0 then
            set miss=miss*(1.-20/100.)
        endif
        if GetUnitAbilityLevel(u,'A0US')>0 then
            set miss=miss*(1.-20/100.)
        endif
        if GetUnitAbilityLevel(u,'A07A')>0 then
            set miss=miss*(1.-25/100.)
        endif
        if GetUnitAbilityLevel(u,'A05C')>0 then
            set miss=miss*(1.-25/100.)
        endif
        if GetUnitAbilityLevel(u,'A05D')>0 then
            set miss=miss*(1.-30/100.)
        endif
        if GetUnitAbilityLevel(u,'A05E')>0 then
            set miss=miss*(1.-35/100.)
        endif
        if GetUnitAbilityLevel(u,'A05F')>0 then
            set miss=miss*(1.-40/100.)
        endif
        if GetUnitAbilityLevel(u,'A0QV')>0 then
            set miss=miss*(1.-40/100.)
        endif
        if GetUnitAbilityLevel(u,'A0FK')>0 then
            set miss=miss*(1.-45/100.)
        endif
        if GetUnitAbilityLevel(u,'A0CJ')>0 then
            set miss=miss*(1.-50/100.)
        endif
        if GetUnitAbilityLevel(u,'A1CF')>0 then
            set miss=miss*(1.-55/100.)
        endif
        if GetUnitAbilityLevel(u,'A0HG')>0 then
            set miss=miss*(1.-60/100.)
        endif
        if GetUnitAbilityLevel(u,'A0JR')>0 then
            set miss=miss*(1.-85/100.)
        endif
        if GetUnitAbilityLevel(u,'A0D2')>0 then
            set miss=miss*(1.-90/100.)
        endif
    else
        if GetUnitAbilityLevel(u,'A0S1')>0 then
            set miss=miss*(1.-10/100.)
        endif
        if GetUnitAbilityLevel(u,'A0S2')>0 then
            set miss=miss*(1.-15/100.)
        endif
        if GetUnitAbilityLevel(u,'A0S3')>0 then
            set miss=miss*(1.-20/100.)
        endif
        if GetUnitAbilityLevel(u,'A0S6')>0 then
            set miss=miss*(1.-20/100.)
        endif
        if GetUnitAbilityLevel(u,'A0S4')>0 then
            set miss=miss*(1.-25/100.)
        endif
        if GetUnitAbilityLevel(u,'A12W')>0 then
            set miss=miss*(1.-30/100.)
        endif
        if GetUnitAbilityLevel(u,'A0WF')>0 then
            set miss=miss*(1.-35/100.)
        endif
        if GetUnitAbilityLevel(u,'A0S5')>0 then
            set miss=miss*(1.-40/100.)
        endif
    endif
    // Independent block checks combine as one minus the probability that all checks miss.
    return 1.-miss
endfunction

function Stats_StatAttackSpeed takes unit hero returns real
    local integer rank=GetUnitAbilityLevel(hero,'A00V')
    local integer speed=R2I(SquareRoot(I2R(GetHeroAgi(hero,true)))*4.+I2R(GetHeroAgi(hero,true))*.4)
    if GetUnitAbilityLevel(hero,'A0HS')>0 then
        set speed=0
    elseif rank==11 then
        set speed=speed+100
    elseif rank==22 then
        set speed=speed+200
    else
        set speed=speed+rank*8
    endif
    set speed=(speed+100)
    if((GetUnitAbilityLevel(hero,'B01Q')>0))then
        set speed=(speed+20)
    endif
    if((GetUnitAbilityLevel(hero,'A0VH')>0))then
        set speed=(speed-50)
    endif
    if((GetUnitAbilityLevel(hero,'A1A6')>0))then
        set speed=(speed-100)
    endif
    if((GetUnitAbilityLevel(hero,'A0HS')>0))then
        set speed=(speed-$3E8) // $3E8 = 1000
    endif
    if((GetUnitAbilityLevel(hero,'A0EI')>0))then
        set speed=(speed-60)
    endif
    if((GetUnitAbilityLevel(hero,'A0NO')>0))then
        set speed=(speed+$A) // $A = 10
    endif
    if((GetUnitAbilityLevel(hero,'A0CM')>0))then
        set speed=(speed+100)
    endif
    if((GetUnitAbilityLevel(hero,'A16G')>0))then
        set speed=(speed+120)
    endif
    if((GetUnitAbilityLevel(hero,'A1BU')>0))then
        set speed=(speed+$8C) // $8C = 140
    endif
    if((GetUnitAbilityLevel(hero,'A1BO')>0))then
        set speed=(speed+$96) // $96 = 150
    endif
    if((GetUnitAbilityLevel(hero,'AIsx')>0))then
        set speed=(speed+16)
    endif
    if((GetUnitAbilityLevel(hero,'A1ZZ')>0))then
        set speed=(speed+20)
    endif
    if((GetUnitAbilityLevel(hero,'A04V')>0))then
        set speed=(speed+24)
    endif
    if((GetUnitAbilityLevel(hero,'A04W')>0))then
        set speed=(speed+30)
    endif
    if((GetUnitAbilityLevel(hero,'A04X')>0))then
        set speed=(speed+40)
    endif
    if((GetUnitAbilityLevel(hero,'A04Y')>0))then
        set speed=(speed+50)
    endif
    if((GetUnitAbilityLevel(hero,'A0AI')>0))then
        set speed=(speed+60)
    endif
    if((GetUnitAbilityLevel(hero,'A1CN')>0))then
        set speed=(speed+70)
    endif
    if((GetUnitAbilityLevel(hero,'A07X')>0))then
        set speed=(speed+74)
    endif
    if((GetUnitAbilityLevel(hero,'A04Z')>0))then
        set speed=(speed+76)
    endif
    if((GetUnitAbilityLevel(hero,'A0WI')>0))then
        set speed=(speed+80)
    endif
    if((GetUnitAbilityLevel(hero,'A0GO')>0))then
        set speed=(speed+90)
    endif
    if((GetUnitAbilityLevel(hero,'A0VI')>0))then
        set speed=(speed+50)
    endif
    if((speed<40))then
        set speed=40
    else
        if((speed>$3E8))then
            set speed=$3E8 // $3E8 = 1000
        endif
    endif
    if GetUnitAbilityLevel(hero,'B08T')>0 then
        set speed=speed+120
    elseif GetUnitAbilityLevel(hero,'B00F')>0 or GetUnitAbilityLevel(hero,'B07F')>0 then
        set speed=speed+80
    endif
    if GetUnitAbilityLevel(hero,'B08Y')>0 then
        set speed=speed-100
    elseif GetUnitAbilityLevel(hero,'Bslo')>0 then
        set speed=speed-50
    endif
    if GetUnitAbilityLevel(hero,'A0GP')>0 and IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER) and Stats_TwoHandedWeapon(hero)!=null then
        set speed=speed+240
    endif
    return I2R(IMaxBJ(40,IMinBJ(1000,speed)))
endfunction

function Stats_StatPercent takes real value returns string
    return R2SW(value,1,2)+"%"
endfunction

function Stats_StatCooldown takes unit hero returns real
    local real scale=1.
    if hero==Player_GetHero(GetOwningPlayer(hero)) and IsPlayerInForce(GetOwningPlayer(hero),udg_PlayingPlayers) then
        set scale=1000./(1000.+I2R(GetHeroAgi(hero,true)))
    endif
    if GetUnitAbilityLevel(hero,'A1C3')>0 then
        set scale=scale*.7
    endif
    if GetUnitAbilityLevel(hero,'A18K')>0 then
        set scale=scale*.8
    endif
    if GetUnitAbilityLevel(hero,'B08T')>0 then
        set scale=scale*.67
    elseif GetUnitAbilityLevel(hero,'B00F')>0 or GetUnitAbilityLevel(hero,'B07F')>0 or GetUnitAbilityLevel(hero,'A0GJ')>0 then
        set scale=scale*.75
    elseif GetUnitAbilityLevel(hero,'B08Y')>0 then
        set scale=scale*1.5
    elseif GetUnitAbilityLevel(hero,'Bslo')>0 then
        set scale=scale*1.3
    endif
    return 100.*(1.-scale)
endfunction

function Stats_StatArmorDefense takes real armor returns real
    local real factor=STATS_ARMOR_FACTOR
    if armor>=0. then
        return 100.*armor*factor/(1.+armor*factor)
    endif
    // Negative armor uses Warcraft's exponential vulnerability curve.
    return 100.*(Pow(1.-factor,-armor)-1.)
endfunction

function Stats_StatBlock takes unit hero,boolean physical returns real
    local real chance=Stats_StatBlockRoll(hero,physical)
    if not physical then
        set chance=chance+(1.-chance)*RMinBJ(1.,I2R(Prof_GetLevel(hero,'R001'))/50.)*Stats_StatBlockRoll(hero,true)
    endif
    return chance*100.
endfunction

function Stats_StatResistance takes unit hero,integer element returns string
    local integer tier=Stats_Stat_GetElementResist(hero,element)
    if GetUnitAbilityLevel(hero,'B057')>0 then
        set tier=tier-1
    endif
    if tier==7 then
        return "Absorb"
    elseif tier==6 then
        return "Immune"
    elseif tier==5 then
        return "50%"
    elseif tier==4 then
        return "20%"
    elseif tier==2 then
        return "-60%"
    elseif tier==1 then
        return "-100%"
    elseif tier==0 then
        return "Lethal"
    endif
    return "0%"
endfunction

function Stats_StatOutgoing takes unit hero,boolean physical returns real
    local real mult=1.
    local real hp=GetUnitState(hero,UNIT_STATE_LIFE)/GetUnitState(hero,UNIT_STATE_MAX_LIFE)
    if physical then
        if GetUnitAbilityLevel(hero,'B061')>0 then
            set mult=mult*3.
        endif
        if GetUnitAbilityLevel(hero,'B08P')>0 then
            set mult=mult*2.
        elseif GetUnitAbilityLevel(hero,'B01W')>0 or GetUnitAbilityLevel(hero,'B07I')>0 or GetUnitAbilityLevel(hero,'A0WE')>0 then
            set mult=mult*1.5
        elseif GetUnitAbilityLevel(hero,'B08W')>0 then
            set mult=mult*.5
        elseif GetUnitAbilityLevel(hero,'B06H')>0 then
            set mult=mult*.66666
        endif
        if GetUnitAbilityLevel(hero,'A0P9')>0 and hp>=.99 then
            set mult=mult*1.5
        elseif GetUnitAbilityLevel(hero,'A0PA')>0 and hp<=.3 then
            set mult=mult*2.
        endif
        if GetUnitAbilityLevel(hero,'A11F')>0 then
            set mult=mult*1.5*hp
        endif
    else
        if GetUnitAbilityLevel(hero,'B08Q')>0 then
            set mult=mult*2.
        elseif GetUnitAbilityLevel(hero,'B05A')>0 or GetUnitAbilityLevel(hero,'B07J')>0 or GetUnitAbilityLevel(hero,'A0WG')>0 then
            set mult=mult*1.5
        elseif GetUnitAbilityLevel(hero,'B08X')>0 then
            set mult=mult*.5
        elseif GetUnitAbilityLevel(hero,'B06I')>0 then
            set mult=mult*.66666
        endif
        if GetUnitAbilityLevel(hero,'A0RF')>0 and hp>=.99 then
            set mult=mult*1.5
        elseif GetUnitAbilityLevel(hero,'A0RG')>0 and hp<=.3 then
            set mult=mult*2.
        endif
    endif
    if GetUnitAbilityLevel(hero,'A03N')>0 and (GetFloatGameState(GAME_STATE_TIME_OF_DAY)<6. or GetFloatGameState(GAME_STATE_TIME_OF_DAY)>=18.) then
        set mult=mult*1.6
    endif
    if GetUnitAbilityLevel(hero,'B076')>0 then
        set mult=mult*2.
    endif
    if GetUnitAbilityLevel(hero,'A134')>0 then
        set mult=mult*1.65
    endif
    return (mult-1.)*100.
endfunction

function Stats_StatHealing takes unit hero,boolean mana returns real
    local real mult=1.
    if GetUnitAbilityLevel(hero,'B076')>0 then
        set mult=mult*2.
    endif
    if (mana and GetUnitAbilityLevel(hero,'B07E')>0) or (not mana and GetUnitAbilityLevel(hero,'B07D')>0) then
        set mult=mult*2.
    endif
    return (mult-1.)*100.
endfunction

function Stats_StatHealingReceived takes unit hero returns real
    local real mult=1.
    if GetUnitAbilityLevel(hero,'B070')>0 then
        set mult=mult*.7
    endif
    if GetUnitAbilityLevel(hero,'A13R')>0 then
        set mult=mult*1.5
    endif
    return (mult-1.)*100.
endfunction

function Stats_StatPenalty takes string value,boolean reduced returns string
    if reduced then
        return "|cffff4040"+value+"|r"
    endif
    return value
endfunction

function Stats_StatItemAccuracy takes unit hero returns real
    return Stats_ItemAccuracy(hero)
endfunction

function Stats_StatAccuracy takes unit hero returns real
    local real value=Stats_Stat_GetAccuracy(hero)+Stats_StatItemAccuracy(hero)
    if GetUnitAbilityLevel(hero,'B00X')>0 then
        set value=value+25.
    endif
    if GetUnitAbilityLevel(hero,'B01F')>0 then
        set value=value+40.
    endif
    if GetUnitAbilityLevel(hero,'B003')>0 then
        set value=value-40.
    endif
    // Blind halves the hit margin after target evasion; this rating is its target-independent display.
    if GetUnitAbilityLevel(hero,'B02V')>0 then
        return 0.
    elseif GetUnitAbilityLevel(hero,'B00P')>0 then
        set value=value*.5
    endif
    return RMaxBJ(0.,value)
endfunction

function Stats_StatDefenseMultiplier takes unit hero,boolean physical returns real
    local boolean inverted=GetUnitAbilityLevel(hero,'A0F3')>0
    local boolean penalty
    local boolean protect
    local boolean stronger
    if physical then
        set penalty=GetUnitAbilityLevel(hero,'B06J')>0 or GetUnitAbilityLevel(hero,'A15Q')>0
        set stronger=GetUnitAbilityLevel(hero,'B08R')>0
        set protect=stronger or GetUnitAbilityLevel(hero,'B007')>0 or GetUnitAbilityLevel(hero,'B07G')>0 or GetUnitAbilityLevel(hero,'A15P')>0
    else
        set penalty=GetUnitAbilityLevel(hero,'B06K')>0 or GetUnitAbilityLevel(hero,'A15S')>0
        set stronger=GetUnitAbilityLevel(hero,'B08S')>0
        set protect=stronger or GetUnitAbilityLevel(hero,'B005')>0 or GetUnitAbilityLevel(hero,'B07H')>0 or GetUnitAbilityLevel(hero,'A15R')>0
    endif
    if inverted then
        if penalty then
            return .66666
        elseif protect then
            return 1.5
        endif
    elseif stronger then
        return .5
    elseif protect then
        return .66666
    elseif penalty then
        return 1.5
    endif
    return 1.
endfunction

function Stats_StatEffectiveDefense takes real base,real multiplier returns real
    // Defense statuses multiply the damage remaining after armor; they do not change the raw rating.
    return 100.*(1.-(1.-base*.01)*multiplier)
endfunction

function Stats_StatElementText takes unit hero,integer element returns string
    local real physical=100.*(Stats_StatElementDamageBonus(hero,element,true))
    local real magical=100.*(Stats_StatElementDamageBonus(hero,element,false))
    if RAbsBJ(physical-magical)<.001 then
        return Stats_StatPercent(physical)
    endif
    if RAbsBJ(physical-I2R(R2I(physical)))<.001 then
        return I2S(R2I(physical))+"% | "+Stats_StatPercent(magical)
    endif
    return Stats_StatPercent(physical)+" | "+Stats_StatPercent(magical)
endfunction

function Stats_ConditionValue takes unit hero,integer index returns string
    local integer raw=0
    if index==0 then
        set raw='A0RA'
    elseif index==1 then
        set raw='A0FX'
    elseif index==2 then
        set raw='A0U6'
    elseif index==3 then
        set raw='A0GJ'
    elseif index==4 then
        set raw='A0WE'
    elseif index==5 then
        set raw='A0WG'
    elseif index==6 then
        set raw='A15P'
    elseif index==7 then
        set raw='A15R'
    elseif index==8 then
        if IsUnitInGroup(hero,udg_BossGroup) then
            return "Immune"
        endif
    elseif index==9 then
        if GetUnitAbilityLevel(hero,'A0KV')>0 then
            return "-80%"
        endif
    endif
    if raw!=0 and GetUnitAbilityLevel(hero,raw)>0 then
        return "Immune"
    endif
    return ""
endfunction

function Stats_ConditionName takes integer index returns string
    if index==0 then
        return "Blind"
    elseif index==1 then
        return "Disease"
    elseif index==2 then
        return "Sleep"
    elseif index==3 then
        return "Slow"
    elseif index==4 then
        return "Pain"
    elseif index==5 then
        return "Fog"
    elseif index==6 then
        return "Deprotect"
    elseif index==7 then
        return "Deshell"
    elseif index==8 then
        return "Stun / Freeze"
    endif
    return "Knockback"
endfunction

function Stats_ConditionCount takes unit hero returns integer
    local integer index=0
    local integer count=0
    loop
        exitwhen index>=10
        if Stats_ConditionValue(hero,index)!="" then
            set count=count+1
        endif
        set index=index+1
    endloop
    return count
endfunction

function Stats_RenderConditions takes unit hero,integer row returns nothing
    local integer index=0
    local string value
    loop
        exitwhen index>=10 or row>=12
        set value=Stats_ConditionValue(hero,index)
        if value!="" then
            call Stats_Row(row,Stats_ConditionName(index),"|cff00ff00"+value+"|r")
            set row=row+1
        endif
        set index=index+1
    endloop
endfunction

function Stats_StatGun takes unit hero returns boolean
    return Gear_WieldsWeaponLevel(hero,11)
endfunction

function Stats_StatCrit takes unit hero returns string
    local integer chance=0
    local real mult=1.
    // Gun effects in the same priority order as GetCritMult.
    if GetUnitAbilityLevel(hero,'A0H6')>0 then
        set chance=20
        set mult=4.3
    elseif GetUnitAbilityLevel(hero,'A0KU')>0 then
        set chance=15
        set mult=4.
    elseif GetUnitAbilityLevel(hero,'A0H4')>0 then
        set chance=10
        set mult=3.8
    elseif GetUnitAbilityLevel(hero,'A0VA')>0 then
        set chance=35
        set mult=3.5
    elseif GetUnitAbilityLevel(hero,'A0H5')>0 then
        set chance=15
        set mult=2.8
    elseif GetUnitAbilityLevel(hero,'A0V9')>0 then
        set chance=35
        set mult=2.5
    elseif GetUnitAbilityLevel(hero,'A119')>0 then
        set chance=15
        set mult=2.4
    elseif GetUnitAbilityLevel(hero,'A08N')>0 then
        set chance=35
        set mult=2.
    elseif GetUnitAbilityLevel(hero,'A0NP')>0 then
        set chance=20
        set mult=1.8
    elseif GetUnitAbilityLevel(hero,'A118')>0 then
        set chance=15
        set mult=1.8
    elseif GetUnitAbilityLevel(hero,'A116')>0 then
        set chance=15
        set mult=1.6
    elseif GetUnitAbilityLevel(hero,'A0NN')>0 then
        set chance=20
        set mult=1.5
    elseif GetUnitAbilityLevel(hero,'A115')>0 then
        set chance=15
        set mult=1.4
    endif
    if chance==0 then
        return ""
    endif
    if GetUnitAbilityLevel(hero,'A18L')>0 then
        set mult=mult+1.
    endif
    return I2S(chance)+"% | "+R2SW(mult,1,1)+"x"
endfunction

function Stats_StatCombo takes unit hero returns string
    local integer chance=0
    local integer hits=4
    if GetUnitAbilityLevel(hero,'A139')>0 or GetUnitAbilityLevel(hero,'A13H')>0 then
        set chance=chance+1
    endif
    if GetUnitAbilityLevel(hero,'A021')>0 or GetUnitAbilityLevel(hero,'B08M')>0 then
        set chance=chance+1
    endif
    if GetUnitAbilityLevel(hero,'A0TW')>0 then
        set chance=chance+2
    endif
    if GetUnitAbilityLevel(hero,'A182')>0 then
        set chance=chance+2
        set hits=hits-2
    endif
    if GetUnitAbilityLevel(hero,'A0HS')>0 then
        set chance=chance+6
        set hits=hits+11
    endif
    if GetUnitAbilityLevel(hero,'A0OQ')>0 then
        set chance=chance*3
    endif
    if GetUnitAbilityLevel(hero,'A13G')>0 then
        set hits=hits+8
    endif
    if GetUnitAbilityLevel(hero,'A1DG')>0 then
        set hits=hits+7
    endif
    if GetUnitAbilityLevel(hero,'A13F')>0 then
        set hits=hits+6
    endif
    if GetUnitAbilityLevel(hero,'A13E')>0 then
        set hits=hits+5
    endif
    if GetUnitAbilityLevel(hero,'A13D')>0 then
        set hits=hits+4
    endif
    if GetUnitAbilityLevel(hero,'A13C')>0 then
        set hits=hits+3
    endif
    if GetUnitAbilityLevel(hero,'A13H')>0 then
        set hits=hits+3
    endif
    if GetUnitAbilityLevel(hero,'A13B')>0 then
        set hits=hits+2
    endif
    if GetUnitAbilityLevel(hero,'A13A')>0 then
        set hits=hits+1
    endif
    if chance==0 then
        return ""
    endif
    if GetUnitAbilityLevel(hero,'B00O')>0 or GetUnitAbilityLevel(hero,'B07L')>0 then
        set chance=20
        if GetUnitAbilityLevel(hero,'B07L')>0 then
            set hits=hits+GetUnitAbilityLevel(hero,'A0IY')
        endif
    endif
    return I2S(IMinBJ(100,chance*5))+"% | "+I2S(hits)+"+"
endfunction

function Stats_RenderGearDamage takes unit hero,integer row returns nothing
    local string value
    local integer percent=0
    local integer flat=0
    local integer prof
    if Stats_StatGun(hero) then
        set value=Stats_StatCrit(hero)
        if value!="" then
            call Stats_Row(row,"Critical Chance",value)
            set row=row+1
        endif
        if GetUnitAbilityLevel(hero,'A145')>0 then
            call Stats_Row(row,"Attacks have Blinding Effect","")
            set row=row+1
        endif
        if GetUnitAbilityLevel(hero,'A0YB')>0 then
            call Stats_Row(row,"Armor-piercing damage","+"+I2S(15*(10+Prof_GetLevel(hero,'R00M'))))
            set row=row+1
        elseif GetUnitAbilityLevel(hero,'A1AM')>0 then
            call Stats_Row(row,"Armor-piercing damage","+"+I2S(30*(10+Prof_GetLevel(hero,'R00M'))))
            set row=row+1
        endif
        if GetUnitAbilityLevel(hero,'A144')>0 then
            call Stats_Row(row,"Every 10th Attack is Incendiary","")
            set row=row+1
        endif
        if GetUnitAbilityLevel(hero,'A0YC')>0 then
            call Stats_Row(row,"Attacks have Splash","")
            set row=row+1
        endif
        set flat=0
        if GetUnitAbilityLevel(hero,'A0YA')>0 then
            set flat=flat+35
        endif
        if GetUnitAbilityLevel(hero,'A1AL')>0 then
            set flat=flat+25
        endif
        if GetUnitAbilityLevel(hero,'A1FE')>0 then
            set flat=flat+10
        endif
        if flat>0 then
            call Stats_Row(row,"Shot attack damage","+"+I2S(flat*(10+Prof_GetLevel(hero,'R00M'))))
            set row=row+1
        endif
    elseif IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER) then
        set value=Stats_StatCombo(hero)
        if value!="" then
            call Stats_Row(row,"Combo Chance",value)
            set row=row+1
        endif
    endif
    if Gear_WieldsWeaponLevel(hero,3) then
        set prof=10+Prof_GetLevel(hero,'R002')
        if GetUnitAbilityLevel(hero,'A174')>0 then
            set percent=30
            set flat=80*prof
        elseif GetUnitAbilityLevel(hero,'A0Y9')>0 then
            set percent=25
            set flat=50*prof
        elseif GetUnitAbilityLevel(hero,'A0Y8')>0 then
            set percent=20
            set flat=20*prof
        elseif GetUnitAbilityLevel(hero,'A04H')>0 then
            set percent=15
            set flat=10*prof
        endif
        if percent>0 then
            call Stats_Row(row,"Tech Damage",I2S(percent)+"% | +"+I2S(flat))
            set row=row+1
        endif
        if GetUnitAbilityLevel(hero,'A0Y6')>0 then
            call Stats_Row(row,"AGI Tech Damage","+"+R2SW(GetHeroAgi(hero,true)*prof*.04,1,0))
            set row=row+1
        endif
    endif
    if GetUnitAbilityLevel(hero,'A1CB')>0 then
        call Stats_Row(row,"Elemental Weakness Damage","30%")
        set row=row+1
    endif
    if IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER) and GetUnitAbilityLevel(hero,'A1B9')>0 then
        call Stats_Row(row,"Backstab","1.5x")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A1EV')>0 then
        call Stats_Row(row,"Chance to Shock","10%")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A10X')>0 then
        if udg_EternityMode then
            call Stats_Row(row,"Kill Commons below 40","Disabled")
        else
            call Stats_Row(row,"Kill Commons below 40","5%")
        endif
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A0PQ')>0 or GetUnitAbilityLevel(hero,'A0PR')>0 then
        call Stats_Row(row,"Reduce Enemy Block Chance","66.67%")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A05L')>0 then
        call Stats_Row(row,"Damage Randomizes","20% - 200%")
    endif
endfunction

function Stats_RenderGearOther takes unit hero,integer row returns nothing
    if GetUnitAbilityLevel(hero,'A03R')>0 then
        call Stats_Row(row,"HP regen not in combat","1%")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A12S')>0 then
        call Stats_Row(row,"Mana on Kill","+100")
        set row=row+1
        call Stats_Row(row,"Mana on Tech Kill","+200")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A03D')>0 then
        call Stats_Row(row,"Using Gold instead of MP","")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A0QK')>0 then
        call Stats_Row(row,"Buffs are stronger","")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A12V')>0 then
        call Stats_Row(row,"Item drop chance","+20%")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A05H')>0 then
        call Stats_Row(row,"Increased Summon Stats","+80%")
        set row=row+1
    endif
    if GetUnitAbilityLevel(hero,'A0B3')>0 then
        call Stats_Row(row,"Movement speed penalty","|cffff3333-20%|r")
    endif
endfunction

// Fills the rows of one page (0 damage bonuses, 1 defenses, 2 resistances, 3 other bonuses) and
// returns its title. Same rows as the Forsaken stat panel, without regeneration.
function Stats_Fill takes unit hero,integer page returns string
    local integer i=0
    local integer element=Element_GetOfUnit(hero,true)
    local integer playerIndex=GetPlayerId(GetOwningPlayer(hero))+1
    local string name
    local string title="Defenses"
    local real value
    local item twoHandedWeapon=Stats_TwoHandedWeapon(hero)
    local real physicalDefense=Stats_StatDefenseMultiplier(hero,true)
    local real magicalDefense=Stats_StatDefenseMultiplier(hero,false)
    local boolean blind=GetUnitAbilityLevel(hero,'B00P')>0 or GetUnitAbilityLevel(hero,'B02V')>0 or GetUnitAbilityLevel(hero,'B003')>0
    loop
        exitwhen i>=STATS_ROWS
        call Stats_Row(i,"","")
        set i=i+1
    endloop
    if page==1 then
        call Stats_Row(0,"Magic Defense",I2S(udg_MagicDefense[playerIndex]))
        call Stats_Row(1,"Magic Defense %",Stats_StatPenalty(Stats_StatPercent(Stats_StatEffectiveDefense(Stats_DefensePercent(udg_MagicDefense[playerIndex]),magicalDefense)),magicalDefense>1.))
        call Stats_Row(2,"Armor",R2SW(BlzGetUnitArmor(hero),1,2))
        call Stats_Row(3,"Armor defense %",Stats_StatPenalty(Stats_StatPercent(Stats_StatEffectiveDefense(Stats_StatArmorDefense(BlzGetUnitArmor(hero)),physicalDefense)),physicalDefense>1.))
        call Stats_Row(4,"Evasion rating",Stats_StatPenalty(R2SW(Stats_Stat_GetEvasion(hero),1,2),GetUnitAbilityLevel(hero,'A1DB')>0))
        call Stats_Row(5,"Physical block",Stats_StatPercent(Stats_StatBlock(hero,true)))
        call Stats_Row(6,"Magical block",Stats_StatPercent(Stats_StatBlock(hero,false)))
        set value=0.
        if GetUnitAbilityLevel(hero,'A0RV')>0 or GetUnitAbilityLevel(hero,'A0EI')>0 then
            set value=25.
        elseif GetUnitAbilityLevel(hero,'A0RU')>0 then
            set value=10.
        endif
        call Stats_Row(7,"Flat damage guard",R2SW(value,1,0))
        if GetUnitAbilityLevel(hero,'A0T9')>0 and GetUnitState(hero,UNIT_STATE_LIFE)<=.3*GetUnitState(hero,UNIT_STATE_MAX_LIFE) then
            call Stats_Row(8,"Damage taken","Halved")
        endif
    elseif page==2 then
        set title="Resistances"
        set i=0
        loop
            exitwhen i>=6
            set name=StatsElementName[i]
            call Stats_Row(i,name+" resistance",Stats_StatPenalty(Stats_StatResistance(hero,i+1),GetUnitAbilityLevel(hero,'B057')>0))
            set i=i+1
        endloop
        set value=0.
        if GetUnitAbilityLevel(hero,'A11P')>0 then
            call Stats_Row(6,"Non-elemental","Immune")
        else
            if GetUnitAbilityLevel(hero,'A11O')>0 then
                set value=87.5
            endif
            call Stats_Row(6,"Non-elemental",Stats_StatPercent(value))
        endif
        set value=0.
        if GetUnitAbilityLevel(hero,'A0PM')>0 then
            set value=15.
        endif
        call Stats_Row(7,"Random absorption",Stats_StatPercent(value))
        call Stats_RenderConditions(hero,8)
    elseif page==0 then
        set title="Damage bonuses"
        set i=0
        loop
            exitwhen i>=6
            set name=StatsElementName[i]+" damage"
            if element==i+1 then
                set name="|cff00ff00"+name+"|r"
            endif
            call Stats_Row(i,name,Stats_StatElementText(hero,i+1))
            set i=i+1
        endloop
        call Stats_Row(6,"Physical damage",Stats_StatPenalty(Stats_StatPercent(Stats_StatOutgoing(hero,true)),GetUnitAbilityLevel(hero,'B08W')>0 or GetUnitAbilityLevel(hero,'B06H')>0))
        call Stats_Row(7,"Magical damage",Stats_StatPenalty(Stats_StatPercent(Stats_StatOutgoing(hero,false)),GetUnitAbilityLevel(hero,'B08X')>0 or GetUnitAbilityLevel(hero,'B06I')>0))
        call Stats_Row(8,"Attack speed",Stats_StatPenalty(R2SW(Stats_StatAttackSpeed(hero),1,0)+"%",GetUnitAbilityLevel(hero,'Bslo')>0 or GetUnitAbilityLevel(hero,'B08Y')>0))
        call Stats_Row(9,"Accuracy rating",Stats_StatPenalty(R2SW(Stats_StatAccuracy(hero),1,2),blind))
        if Stats_StatGun(hero) and GetUnitAbilityLevel(hero,'A0Y7')>0 then
            call Stats_Row(9,"Accuracy rating","Perfect")
        endif
        set i=10
        if GetUnitAbilityLevel(hero,'A0AP')>0 or GetUnitAbilityLevel(hero,'A15J')>0 then
            set i=12
            call Stats_Row(10,"Attack multiplier",R2SW(Stats_StatAttackMultiplier(hero),1,2)+"x")
            if Unit_HasNoEquipment(hero) then
                call Stats_Row(11,"Brawler","|cff00ff00Active|r")
            else
                call Stats_Row(11,"Brawler","Inactive")
            endif
        elseif GetUnitAbilityLevel(hero,'A0GP')>0 then
            set i=12
            if twoHandedWeapon!=null then
                call Stats_Row(10,"Two-Handed damage","+"+R2SW(GetWidgetLife(twoHandedWeapon)*5.,1,0))
                call Stats_Row(11,"Two-Handed speed","+240%")
            else
                call Stats_Row(10,"Two-Handed damage","+0")
                call Stats_Row(11,"Two-Handed speed","+0%")
            endif
        endif
        if element==7 and GetUnitAbilityLevel(hero,'A0AP')==0 and GetUnitAbilityLevel(hero,'A15J')==0 and GetUnitAbilityLevel(hero,'A0GP')==0 then
            call Stats_Row(i,"|cff00ff00Basic attack element|r","Omni")
            set i=i+1
        endif
        call Stats_RenderGearDamage(hero,i)
    else
        set title="Other bonuses"
        call Stats_Row(0,"HP healing buffs",Stats_StatPercent(Stats_StatHealing(hero,false)))
        call Stats_Row(1,"MP healing buffs",Stats_StatPercent(Stats_StatHealing(hero,true)))
        call Stats_Row(2,"Healing received",Stats_StatPenalty(Stats_StatPercent(Stats_StatHealingReceived(hero)),GetUnitAbilityLevel(hero,'B070')>0))
        call Stats_Row(3,"Cooldown reduction",Stats_StatPenalty(Stats_StatPercent(Stats_StatCooldown(hero)),(GetUnitAbilityLevel(hero,'B08Y')>0 or GetUnitAbilityLevel(hero,'Bslo')>0) and GetUnitAbilityLevel(hero,'B08T')==0 and GetUnitAbilityLevel(hero,'B00F')==0 and GetUnitAbilityLevel(hero,'B07F')==0 and GetUnitAbilityLevel(hero,'A0GJ')==0))
        call Stats_Row(4,"Move speed",Stats_StatPenalty(R2SW(GetUnitMoveSpeed(hero),1,0),GetUnitAbilityLevel(hero,'B08Y')>0 or GetUnitAbilityLevel(hero,'Bslo')>0 or GetUnitAbilityLevel(hero,'B05M')>0 or GetUnitAbilityLevel(hero,'B05N')>0))
        call Stats_RenderGearOther(hero,5)
    endif
    set twoHandedWeapon=null
    return title
endfunction

// Shows one page to its player, two rows to a line so a page fits on screen.
function Stats_Show takes player p,integer page returns nothing
    local unit hero=Player_GetHero(p)
    local string title
    local string line=""
    local integer row=0
    local integer shown=0
    local integer next=ModuloInteger(page+1,4)
    if hero==null then
        call DisplayTimedTextToPlayer(p,0.,0.,10.,"You need a hero to see its stats.")
        return
    endif
    set title=Stats_Fill(hero,page)
    if GetLocalPlayer()==p then
        call ClearTextMessages()
    endif
    call DisplayTimedTextToPlayer(p,0.,0.,30.,"|cffffcc00"+title+" ("+I2S(page+1)+"/4)|r")
    loop
        exitwhen row>=STATS_ROWS
        if StatsLabel[row]!="" then
            if StatsValue[row]!="" then
                set line=line+StatsLabel[row]+": |cffffffff"+StatsValue[row]+"|r"
            else
                set line=line+StatsLabel[row]
            endif
            set shown=shown+1
            if ModuloInteger(shown,2)==0 then
                call DisplayTimedTextToPlayer(p,0.,0.,30.,line)
                set line=""
            else
                set line=line+"   "
            endif
        endif
        set row=row+1
    endloop
    if line!="" then
        call DisplayTimedTextToPlayer(p,0.,0.,30.,line)
    endif
    call DisplayTimedTextToPlayer(p,0.,0.,30.,"|cff808080-stats "+I2S(next+1)+" for "+Stats_PageName(next)+". Pages: 1 damage, 2 defenses, 3 resistances, 4 other.|r")
    set hero=null
endfunction

function Stats_OnCommand takes nothing returns nothing
    local string text=StringCase(GetEventPlayerChatString(),false)
    local integer page=0
    if text!="-stats" and SubString(text,0,7)!="-stats " then
        return
    endif
    if StringLength(text)>7 then
        set page=S2I(SubString(text,7,StringLength(text)))-1
    endif
    if page<0 or page>3 then
        set page=0
    endif
    call Stats_Show(GetTriggerPlayer(),page)
endfunction

function InitTrig_HeroStats takes nothing returns nothing
    local integer pid=0
    set StatsElementName[0]="Fire"
    set StatsElementName[1]="Ice"
    set StatsElementName[2]="Thunder"
    set StatsElementName[3]="Water"
    set StatsElementName[4]="Earth"
    set StatsElementName[5]="Wind"
    set gg_trg_HeroStats_Command=CreateTrigger()
    loop
        exitwhen pid>=bj_MAX_PLAYERS
        call TriggerRegisterPlayerChatEvent(gg_trg_HeroStats_Command,Player(pid),"-stats",false)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_HeroStats_Command,function Stats_OnCommand)
endfunction

endlibrary

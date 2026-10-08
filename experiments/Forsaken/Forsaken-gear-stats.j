// Read-only equipment summaries. Never roll combat RNG or spend resources here.
function Forsaken_StatGun takes unit hero returns boolean
    return Forsaken_WeaponType(hero,11)
endfunction

function Forsaken_StatCrit takes unit hero returns string
    local integer chance=0
    local real mult=1.
    // Gun effects in the same priority order as GetCritMult.
    if Forsaken_StatAbilityLevel(hero,'A0H6')>0 then
        set chance=20
        set mult=4.3
    elseif Forsaken_StatAbilityLevel(hero,'A0KU')>0 then
        set chance=15
        set mult=4.
    elseif Forsaken_StatAbilityLevel(hero,'A0H4')>0 then
        set chance=10
        set mult=3.8
    elseif Forsaken_StatAbilityLevel(hero,'A0VA')>0 then
        set chance=35
        set mult=3.5
    elseif Forsaken_StatAbilityLevel(hero,'A0H5')>0 then
        set chance=15
        set mult=2.8
    elseif Forsaken_StatAbilityLevel(hero,'A0V9')>0 then
        set chance=35
        set mult=2.5
    elseif Forsaken_StatAbilityLevel(hero,'A119')>0 then
        set chance=15
        set mult=2.4
    elseif Forsaken_StatAbilityLevel(hero,'A08N')>0 then
        set chance=35
        set mult=2.
    elseif Forsaken_StatAbilityLevel(hero,'A0NP')>0 then
        set chance=20
        set mult=1.8
    elseif Forsaken_StatAbilityLevel(hero,'A118')>0 then
        set chance=15
        set mult=1.8
    elseif Forsaken_StatAbilityLevel(hero,'A116')>0 then
        set chance=15
        set mult=1.6
    elseif Forsaken_StatAbilityLevel(hero,'A0NN')>0 then
        set chance=20
        set mult=1.5
    elseif Forsaken_StatAbilityLevel(hero,'A115')>0 then
        set chance=15
        set mult=1.4
    endif
    if chance==0 then
        return ""
    endif
    if Forsaken_StatAbilityLevel(hero,'A18L')>0 then
        set mult=mult+1.
    endif
    return I2S(chance)+"% | "+R2SW(mult,1,1)+"x"
endfunction

function Forsaken_StatCombo takes unit hero returns string
    local integer chance=0
    local integer hits=4
    if Forsaken_StatAbilityLevel(hero,'A139')>0 or Forsaken_StatAbilityLevel(hero,'A13H')>0 then
        set chance=chance+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A021')>0 or Forsaken_StatAbilityLevel(hero,'B08M')>0 then
        set chance=chance+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A0TW')>0 then
        set chance=chance+2
    endif
    if Forsaken_StatAbilityLevel(hero,'A182')>0 then
        set chance=chance+2
        set hits=hits-2
    endif
    if Forsaken_StatAbilityLevel(hero,'A0HS')>0 then
        set chance=chance+6
        set hits=hits+11
    endif
    if Forsaken_StatAbilityLevel(hero,'A0OQ')>0 then
        set chance=chance*3
    endif
    if Forsaken_StatAbilityLevel(hero,'A13G')>0 then
        set hits=hits+8
    endif
    if Forsaken_StatAbilityLevel(hero,'A1DG')>0 then
        set hits=hits+7
    endif
    if Forsaken_StatAbilityLevel(hero,'A13F')>0 then
        set hits=hits+6
    endif
    if Forsaken_StatAbilityLevel(hero,'A13E')>0 then
        set hits=hits+5
    endif
    if Forsaken_StatAbilityLevel(hero,'A13D')>0 then
        set hits=hits+4
    endif
    if Forsaken_StatAbilityLevel(hero,'A13C')>0 then
        set hits=hits+3
    endif
    if Forsaken_StatAbilityLevel(hero,'A13H')>0 then
        set hits=hits+3
    endif
    if Forsaken_StatAbilityLevel(hero,'A13B')>0 then
        set hits=hits+2
    endif
    if Forsaken_StatAbilityLevel(hero,'A13A')>0 then
        set hits=hits+1
    endif
    if chance==0 then
        return ""
    endif
    if Forsaken_StatAbilityLevel(hero,'B00O')>0 or Forsaken_StatAbilityLevel(hero,'B07L')>0 then
        set chance=20
        if Forsaken_StatAbilityLevel(hero,'B07L')>0 then
            set hits=hits+Forsaken_StatAbilityLevel(hero,'A0IY')
        endif
    endif
    return I2S(IMinBJ(100,chance*5))+"% | "+I2S(hits)+"+"
endfunction

function Forsaken_RenderGearDamage takes unit hero,integer row returns nothing
    local string value
    local integer percent=0
    local integer flat=0
    local integer prof
    if Forsaken_StatGun(hero) then
        set value=Forsaken_StatCrit(hero)
        if value!="" then
            call Forsaken_StatRow(row,"Critical Chance",value)
            set row=row+1
        endif
        if Forsaken_StatAbilityLevel(hero,'A145')>0 then
            call Forsaken_StatRow(row,"Attacks have Blinding Effect","")
            set row=row+1
        endif
        if Forsaken_StatAbilityLevel(hero,'A0YB')>0 then
            call Forsaken_StatRow(row,"Armor-piercing damage","+"+I2S(15*(10+Prof_GetLevel(hero,'R00M'))))
            set row=row+1
        elseif Forsaken_StatAbilityLevel(hero,'A1AM')>0 then
            call Forsaken_StatRow(row,"Armor-piercing damage","+"+I2S(30*(10+Prof_GetLevel(hero,'R00M'))))
            set row=row+1
        endif
        if Forsaken_StatAbilityLevel(hero,'A144')>0 then
            call Forsaken_StatRow(row,"Every 10th Attack is Incendiary","")
            set row=row+1
        endif
        if Forsaken_StatAbilityLevel(hero,'A0YC')>0 then
            call Forsaken_StatRow(row,"Attacks have Splash","")
            set row=row+1
        endif
        set flat=0
        if Forsaken_StatAbilityLevel(hero,'A0YA')>0 then
            set flat=flat+35
        endif
        if Forsaken_StatAbilityLevel(hero,'A1AL')>0 then
            set flat=flat+25
        endif
        if Forsaken_StatAbilityLevel(hero,'A1FE')>0 then
            set flat=flat+10
        endif
        if flat>0 then
            call Forsaken_StatRow(row,"Shot attack damage","+"+I2S(flat*(10+Prof_GetLevel(hero,'R00M'))))
            set row=row+1
        endif
    elseif IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER) then
        set value=Forsaken_StatCombo(hero)
        if value!="" then
            call Forsaken_StatRow(row,"Combo Chance",value)
            set row=row+1
        endif
    endif
    if Forsaken_WeaponType(hero,3) then
        set prof=10+Prof_GetLevel(hero,'R002')
        if Forsaken_StatAbilityLevel(hero,'A174')>0 then
            set percent=30
            set flat=80*prof
        elseif Forsaken_StatAbilityLevel(hero,'A0Y9')>0 then
            set percent=25
            set flat=50*prof
        elseif Forsaken_StatAbilityLevel(hero,'A0Y8')>0 then
            set percent=20
            set flat=20*prof
        elseif Forsaken_StatAbilityLevel(hero,'A04H')>0 then
            set percent=15
            set flat=10*prof
        endif
        if percent>0 then
            call Forsaken_StatRow(row,"Tech Damage",I2S(percent)+"% | +"+I2S(flat))
            set row=row+1
        endif
        if Forsaken_StatAbilityLevel(hero,'A0Y6')>0 then
            call Forsaken_StatRow(row,"AGI Tech Damage","+"+R2SW(GetHeroAgi(hero,true)*prof*.04,1,0))
            set row=row+1
        endif
    endif
    if Forsaken_StatAbilityLevel(hero,'A1CB')>0 then
        call Forsaken_StatRow(row,"Elemental Weakness Damage","30%")
        set row=row+1
    endif
    if IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER) and Forsaken_StatAbilityLevel(hero,'A1B9')>0 then
        call Forsaken_StatRow(row,"Backstab","1.5x")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A1EV')>0 then
        call Forsaken_StatRow(row,"Chance to Shock","10%")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A10X')>0 then
        if udg_EternityMode then
            call Forsaken_StatRow(row,"Execute common enemies below lvl 40","Disabled")
        else
            call Forsaken_StatRow(row,"Execute common enemies below lvl 40","5%")
        endif
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A0PQ')>0 or Forsaken_StatAbilityLevel(hero,'A0PR')>0 then
        call Forsaken_StatRow(row,"Reduce Enemy Block Chance","66.67%")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A05L')>0 then
        call Forsaken_StatRow(row,"Damage Randomizes","20% - 200%")
    endif
endfunction

function Forsaken_RenderGearOther takes unit hero,integer row returns nothing
    if Forsaken_StatAbilityLevel(hero,'A03R')>0 then
        call Forsaken_StatRow(row,"Regenerate HP when out of combat","1%")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A12S')>0 then
        call Forsaken_StatRow(row,"Mana on Kill","+100")
        set row=row+1
        call Forsaken_StatRow(row,"Mana on Tech Kill","+200")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A03D')>0 then
        call Forsaken_StatRow(row,"Using Gold instead of MP","")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A0QK')>0 then
        call Forsaken_StatRow(row,"Buffs are stronger","")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A12V')>0 then
        call Forsaken_StatRow(row,"Item drop chance","+20%")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A05H')>0 then
        call Forsaken_StatRow(row,"Increased Summon Stats","+80%")
        set row=row+1
    endif
    if Forsaken_StatAbilityLevel(hero,'A0B3')>0 then
        call Forsaken_StatRow(row,"Movement speed penalty","|cffff3333-20%|r")
    endif
endfunction

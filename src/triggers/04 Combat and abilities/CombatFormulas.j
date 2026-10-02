library TCombatFormulas
constant function Trig_Spell_HolyBlast_DamageFormula takes integer manaCost,real heroIntelligence,real l_mult returns real
    // Holy Blast: add 6 times the mana cost and 4 times Intelligence.
    // Then multiply the whole total by the supplied spell-power multiplier.
    return(manaCost*6.+heroIntelligence*4.)*l_mult
endfunction
constant function Trig_Spell_Bolt_DamageFormula takes integer manaCost,real heroIntelligence,real l_mult returns real
    // Bolt: add 2 times the mana cost and 3 times Intelligence, then apply spell power.
    // Example: 10 mana, 20 Intelligence, and a multiplier of 1.5 give (20 + 60) x 1.5 = 120.
    return(manaCost*2+heroIntelligence*3.)*l_mult
endfunction
constant function Trig_Spell_Cure_HealFormula takes integer manaCost,integer heroIntelligence,real l_mult returns real
    // Cure: each point of mana cost and Intelligence adds 5 healing, before spell power.
    return(manaCost*5.+heroIntelligence*5.)*l_mult
endfunction
constant function Trig_Spell_Blizzaga_WaveDamageFormula takes integer manaCost,real heroIntelligence,real l_mult returns real
    // Blizzaga wave: add 65% of the mana cost and 1.5 times Intelligence, then apply spell power.
    return((manaCost*.65)+heroIntelligence*1.5)*l_mult
endfunction
constant function Trig_Spell_Blizzaga_ShardDamageFormula takes integer manaCost,real heroIntelligence,real l_mult returns real
    // Blizzaga shard: add 25% of the mana cost and all of Intelligence, then apply spell power.
    return((manaCost*.25)+heroIntelligence)*l_mult
endfunction
constant function Trig_Spell_Shuriken_DamageFormula takes integer manaCost,integer heroAgility,integer daggerProficiency returns real
    // Shuriken: start with 5 times mana cost plus 3 times Agility.
    // Each dagger proficiency level adds 10% of that base: level 3 means multiply by 1.3.
    return((manaCost*5.)+(heroAgility*3.))*(($A+daggerProficiency)*.1) // $A = 10
endfunction
constant function Trig_Spell_Tatsumaki_DamageFormula takes integer manaCost,integer heroStrength,integer heroAgility,integer katanaProficiency returns real
    // Tatsumaki: add mana cost, Strength, and Agility, then multiply their sum by 3.
    // Each katana proficiency level adds 10% of that base.
    return((manaCost*3.)+(heroStrength*3.)+(heroAgility*3.))*(($A+katanaProficiency)*.1) // $A = 10
endfunction
constant function Trig_Spell_LiquidSteel_DamageFormula takes integer manaCost,integer heroStrength,integer heroIntelligence,integer weaponProficiency returns real
    // Liquid Steel: add 2 times mana cost, 3 times Strength, and Intelligence.
    // Each weapon proficiency level adds 10% of that base.
    return((manaCost*2)+(heroStrength*3)+heroIntelligence)*(($A+weaponProficiency)*.1) // $A = 10
endfunction

// Editor entry point; gameplay startup remains in MapBootstrap.
function InitTrig_CombatFormulas takes nothing returns nothing
endfunction

endlibrary

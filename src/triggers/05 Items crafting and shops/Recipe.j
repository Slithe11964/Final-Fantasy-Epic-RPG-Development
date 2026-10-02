library TRecipe
function Recipe_InitTables takes nothing returns nothing
    set udg_RecipeName[1]="Crusher's Mace"
    set udg_RecipeResult[1]='I04E' // 'I04E': item "Doom Mace"
    set udg_RecipeItem1[1]='I02Y' // 'I02Y': item "Crusher's Mace"
    set udg_RecipeName[2]="Dark Bow"
    set udg_RecipeResult[2]='I04F' // 'I04F': item "Shadow Bow"
    set udg_RecipeItem1[2]='I036' // 'I036': item "Dark Bow"
    set udg_RecipeName[3]="Dark Claw"
    set udg_RecipeResult[3]='I04G' // 'I04G': item "Death Claw"
    set udg_RecipeItem1[3]='I02P' // 'I02P': item "Dark Claw"
    set udg_RecipeName[4]="Fel Axe"
    set udg_RecipeResult[4]='I04H' // 'I04H': item "Ancient Axe"
    set udg_RecipeItem1[4]='I00O' // 'I00O': item "Fel Axe"
    set udg_RecipeName[5]="Unholy Claw"
    set udg_RecipeResult[5]='I04I' // 'I04I': item "Demon Claw"
    set udg_RecipeItem1[5]='I02Q' // 'I02Q': item "Unholy Claw"
    set udg_RecipeName[6]="Unholy Shield"
    set udg_RecipeResult[6]='I04J' // 'I04J': item "Reflect Shield"
    set udg_RecipeItem1[6]='I02T' // 'I02T': item "Unholy Shield"
    set udg_RecipeName[7]="Necklace of the Sorcerer"
    set udg_RecipeResult[7]='I04L' // 'I04L': item "Necklace of the Necromancer"
    set udg_RecipeItem1[7]='I02W' // 'I02W': item "Necklace of the Sorcerer"
    set udg_RecipeName[8]="Crusher's Belt"
    set udg_RecipeResult[8]='I04M' // 'I04M': item "Stalwart Belt"
    set udg_RecipeItem1[8]='I031' // 'I031': item "Crusher's Belt"
    set udg_RecipeName[9]="Barbarian's Helmet"
    set udg_RecipeResult[9]='I04C' // 'I04C': item "Berserker's Helmet"
    set udg_RecipeItem1[9]='I02Z' // 'I02Z': item "Barbarian's Helmet"
    set udg_RecipeName[$A]="Zodiac Escutcheon" // $A = 10
    set udg_RecipeResult[$A]='I065' // $A = 10; 'I065': item "Ensanguined Shield"
    set udg_RecipeItem1[$A]='I064' // $A = 10; 'I064': item "Zodiac Escutcheon"
    set udg_RecipeName[$B]="Masamune" // $B = 11
    set udg_RecipeResult[$B]='I0DM' // $B = 11; 'I0DM': item "Masamune C"
    set udg_RecipeItem1[$B]='I019' // $B = 11; 'I019': item "Masamune"
    set udg_RecipeName[$C]="Ryuujin no Ken" // $C = 12
    set udg_RecipeResult[$C]='I03O' // $C = 12; 'I03O': item "Wyrmhero Blade"
    set udg_RecipeItem1[$C]='I0C7' // $C = 12; 'I0C7': item "Ryuujin no Ken"
    set udg_RecipeName[$D]="Ultimate Weapon" // $D = 13
    set udg_RecipeResult[$D]='I0ER' // $D = 13; 'I0ER': item "Caladbolg"
    set udg_RecipeItem1[$D]='I00S' // $D = 13; 'I00S': item "Ultimate Weapon"
    set udg_RecipeName[$E]="Poison Wand" // $E = 14
    set udg_RecipeResult[$E]='I0JU' // $E = 14; 'I0JU': item "Scourge Wand"
    set udg_RecipeItem1[$E]='I01D' // $E = 14; 'I01D': item "Poison Wand"
    set udg_RecipeName[$F]="Fire Wand" // $F = 15
    set udg_RecipeResult[$F]='I02F' // $F = 15; 'I02F': item "Fire Wand K"
    set udg_RecipeItem1[$F]='I01E' // $F = 15; 'I01E': item "Fire Wand"
    set udg_RecipeName[16]="Ice Wand"
    set udg_RecipeResult[16]='I0DY' // 'I0DY': item "Ice Wand U"
    set udg_RecipeItem1[16]='I01G' // 'I01G': item "Ice Wand"
    set udg_RecipeName[17]="Thunder Wand"
    set udg_RecipeResult[17]='I0DZ' // 'I0DZ': item "Thunder Wand J"
    set udg_RecipeItem1[17]='I01F' // 'I01F': item "Thunder Wand"
    set udg_RecipeName[18]="Magus Rod"
    set udg_RecipeResult[18]='I0E6' // 'I0E6': item "Magus Rod A"
    set udg_RecipeItem1[18]='I0E8' // 'I0E8': item "Magus Rod"
    set udg_RecipeName[19]="Heady Pipe"
    set udg_RecipeResult[19]='I0EC' // 'I0EC': item "White Materia"
    set udg_RecipeItem1[19]='I01X' // 'I01X': item "Heady Pipe"
    set udg_RecipeName[20]="Germinas Boots"
    set udg_RecipeResult[20]='I0FD' // 'I0FD': item "Jackboots"
    set udg_RecipeItem1[20]='I00I' // 'I00I': item "Germinas Boots"
    set udg_RecipeName[21]="Death Skull"
    set udg_RecipeResult[21]='I0GD' // 'I0GD': item "Death Skull X"
    set udg_RecipeItem1[21]='I039' // 'I039': item "Death Skull"
    set udg_RecipeName[22]="Death Skull X"
    set udg_RecipeResult[22]='I0B0' // 'I0B0': item "Genji Gloves"
    set udg_RecipeItem1[22]='I0GD' // 'I0GD': item "Death Skull X"
    set udg_RecipeName[23]="Wild Bowl"
    set udg_RecipeResult[23]='I0KF' // 'I0KF': item "Wild Bowl"
    set udg_RecipeItem1[23]='I06Q' // 'I06Q': item "Gnoll Head"
    set udg_RecipeItem2[23]='I0CJ' // 'I0CJ': item "Light Meat"
    set udg_RecipeCharges1[23]=3
    set udg_RecipeCharges2[23]=2
    set udg_RecipeName[24]="Triton Pot"
    set udg_RecipeResult[24]='I0KG' // 'I0KG': item "Triton Pot"
    set udg_RecipeItem1[24]='I07E' // 'I07E': item "Triton Head"
    set udg_RecipeItem2[24]='I06L' // 'I06L': item "Hydra Toxin"
    set udg_RecipeCharges1[24]=2
    set udg_RecipeCharges2[24]=2
    set udg_RecipeName[25]="Tropical Dish"
    set udg_RecipeResult[25]='I0KH' // 'I0KH': item "Tropical Dish"
    set udg_RecipeItem1[25]='I0CK' // 'I0CK': item "Strong Meat"
    set udg_RecipeItem2[25]='I0JN' // 'I0JN': item "Dark Goblin's Head"
    set udg_RecipeCharges1[25]=3
    set udg_RecipeCharges2[25]=2
    set udg_RecipeName[26]="Fish Soup"
    set udg_RecipeResult[26]='I0KI' // 'I0KI': item "Fish Soup"
    set udg_RecipeItem1[26]='I0GS' // 'I0GS': item "Small Fish"
    set udg_RecipeItem2[26]='I0GU' // 'I0GU': item "Strong Fish"
    set udg_RecipeCharges1[26]=2
    set udg_RecipeCharges2[26]=1
    set udg_RecipeName[27]="Energy Brew"
    set udg_RecipeResult[27]='I0KJ' // 'I0KJ': item "Energy Brew"
    set udg_RecipeItem1[27]='I0JO' // 'I0JO': item "Flan Fluid"
    set udg_RecipeItem2[27]='I0FM' // 'I0FM': item "Shimmerweed"
    set udg_RecipeCharges1[27]=2
    set udg_RecipeCharges2[27]=1
    set udg_RecipeName[28]="Swift Drink"
    set udg_RecipeResult[28]='I0KK' // 'I0KK': item "Swift Drink"
    set udg_RecipeItem1[28]='I06I' // 'I06I': item "Lizard Skin"
    set udg_RecipeItem2[28]='I082' // 'I082': item "Serpent Skin"
    set udg_RecipeCharges1[28]=3
    set udg_RecipeCharges2[28]=3
    set udg_RecipeName[29]="Spiced Salad"
    set udg_RecipeResult[29]='I0KL' // 'I0KL': item "Spiced Salad"
    set udg_RecipeItem1[29]='I0FN' // 'I0FN': item "Thunderbloom Bulb"
    set udg_RecipeItem2[29]='I06V' // 'I06V': item "Treant Leaves"
    set udg_RecipeCharges1[29]=1
    set udg_RecipeCharges2[29]=2
    set udg_RecipeName[30]="Nebra Bread"
    set udg_RecipeResult[30]='I0KM' // 'I0KM': item "Nebra Bread"
    set udg_RecipeItem1[30]='I0GT' // 'I0GT': item "Nebra Fish"
    set udg_RecipeItem2[30]='I0JP' // 'I0JP': item "Slime Oil"
    set udg_RecipeCharges1[30]=2
    set udg_RecipeCharges2[30]=1
    set udg_RecipeName[31]="First Class Meat Plate"
    set udg_RecipeResult[31]='I0KN' // 'I0KN': item "First Class Meat Plate"
    set udg_RecipeItem1[31]='I0CL' // 'I0CL': item "Great Meat"
    set udg_RecipeItem2[31]='I08I' // 'I08I': item "Dragon Snout"
    set udg_RecipeCharges1[31]=3
    set udg_RecipeCharges2[31]=4
    set udg_RecipeName[32]="Adamant Stew"
    set udg_RecipeResult[32]='I0KO' // 'I0KO': item "Adamant Stew"
    set udg_RecipeItem1[32]='I07D' // 'I07D': item "Turtle Tail"
    set udg_RecipeItem2[32]='I0CM' // 'I0CM': item "Salamander Fragment"
    set udg_RecipeCharges1[32]=2
    set udg_RecipeCharges2[32]=3
endfunction

function InitTrig_Recipe takes nothing returns nothing
endfunction

endlibrary

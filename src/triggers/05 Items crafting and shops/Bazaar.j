library TBazaar
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Bazaar_Init=null
    trigger gg_trg_Bazaar_Recipes=null
    trigger gg_trg_Bazaar_PawnMaterial=null
    trigger gg_trg_Bazaar_UpdateStock=null
    trigger gg_trg_Bazaar_Sell_Bundle=null
    // Variables only this module uses.
    hashtable udg_BazaarRecipeHash=null
    integer udg_MaterialTypeCount=0
    integer udg_BazaarGoodCount=0
    integer array udg_BazaarGoodItem
    integer array udg_BazaarResultItem
    boolean udg_RecipeAffordable=false
    integer udg_BazaarStockedCount=0
    unit udg_BazaarShopUnit=null
endglobals

function Trig_Bazaar_Init_Actions takes nothing returns nothing
    set udg_BazaarShopUnit=gg_unit_n030_0030
    set udg_MaterialTypeCount='j'
    set udg_BazaarGoodCount=56
    set udg_DropItemIdTable[1]='I051' // 'I051': item "Mark of Darkness: Bahamut"
    set udg_DropItemIdTable[2]='I04Z' // 'I04Z': item "Mark of Darkness: Bahamut Zero"
    set udg_DropItemIdTable[3]='I057' // 'I057': item "Mark of Darkness: Cyclops"
    set udg_DropItemIdTable[4]='I05N' // 'I05N': item "Mark of Darkness: Eden"
    set udg_DropItemIdTable[5]='I056' // 'I056': item "Mark of Darkness: Golem"
    set udg_DropItemIdTable[6]='I052' // 'I052': item "Mark of Darkness: Ifrit"
    set udg_DropItemIdTable[7]='I059' // 'I059': item "Mark of Darkness: Leviathan"
    set udg_DropItemIdTable[8]='I05M' // 'I05M': item "Mark of Darkness: Minotaur"
    set udg_DropItemIdTable[9]='I050' // 'I050': item "Mark of Darkness: Neo-Bahamut"
    set udg_DropItemIdTable[$A]='I054' // $A = 10; 'I054': item "Mark of Darkness: Pandemona"
    set udg_DropItemIdTable[$B]='I05K' // $B = 11; 'I05K': item "Mark of Darkness: Phoenix"
    set udg_DropItemIdTable[$C]='I05J' // $C = 12; 'I05J': item "Mark of Darkness: Quezacotl"
    set udg_DropItemIdTable[$D]='I05L' // $D = 13; 'I05L': item "Mark of Darkness: Sacred"
    set udg_DropItemIdTable[$E]='I053' // $E = 14; 'I053': item "Mark of Darkness: Shiva"
    set udg_DropItemIdTable[$F]='I058' // $F = 15; 'I058': item "Mark of Darkness: Titan"
    set udg_DropItemIdTable[16]='I055' // 'I055': item "Mark of Darkness: Typhon"
    set udg_DropItemIdTable[17]='I07G' // 'I07G': item "Carob Nut"
    set udg_DropItemIdTable[18]='I07F' // 'I07F': item "Luchil Nut"
    set udg_DropItemIdTable[19]='I045' // 'I045': item "Pram Nut"
    set udg_DropItemIdTable[20]='I06D' // 'I06D': item "Goblin Wizard's Head"
    set udg_DropItemIdTable[21]='I06C' // 'I06C': item "Goblin Warrior's Head"
    set udg_DropItemIdTable[22]='I06E' // 'I06E': item "Goblin Staff"
    set udg_DropItemIdTable[23]='I06F' // 'I06F': item "Spider Leg"
    set udg_DropItemIdTable[24]='I06H' // 'I06H': item "Harpy Feather"
    set udg_DropItemIdTable[25]='I06I' // 'I06I': item "Lizard Skin"
    set udg_DropItemIdTable[26]='I06J' // 'I06J': item "Centaur Head"
    set udg_DropItemIdTable[27]='I06Y' // 'I06Y': item "Ogre Head"
    set udg_DropItemIdTable[28]='I06Z' // 'I06Z': item "Tome of Cursing"
    set udg_DropItemIdTable[29]='I070' // 'I070': item "Gran Grimoire-Fake"
    set udg_DropItemIdTable[30]='I071' // 'I071': item "Power Sphere"
    set udg_DropItemIdTable[31]='I072' // 'I072': item "Book of Death"
    set udg_DropItemIdTable[32]='I073' // 'I073': item "Scroll of Shadows"
    set udg_DropItemIdTable[33]='I06L' // 'I06L': item "Hydra Toxin"
    set udg_DropItemIdTable[34]='I06M' // 'I06M': item "Crab Claw"
    set udg_DropItemIdTable[35]='I06S' // 'I06S': item "Damaged Adamantite"
    set udg_DropItemIdTable[36]='I06O' // 'I06O': item "Enchanted Rock"
    set udg_DropItemIdTable[37]='I08K' // 'I08K': item "Sharp Rock"
    set udg_DropItemIdTable[38]='I06Q' // 'I06Q': item "Gnoll Head"
    set udg_DropItemIdTable[39]='I08J' // 'I08J': item "Damaged Turtle Tail"
    set udg_DropItemIdTable[40]='I082' // 'I082': item "Serpent Skin"
    set udg_DropItemIdTable[41]='I08I' // 'I08I': item "Dragon Snout"
    set udg_DropItemIdTable[42]='I032' // 'I032': item "Flask of Darkness"
    set udg_DropItemIdTable[43]='I06V' // 'I06V': item "Treant Leaves"
    set udg_DropItemIdTable[44]='I06U' // 'I06U': item "Gas of Corruption"
    set udg_DropItemIdTable[45]='I06W' // 'I06W': item "Icy Claw"
    set udg_DropItemIdTable[46]='I08G' // 'I08G': item "Troll Head"
    set udg_DropItemIdTable[47]='I06G' // 'I06G': item "Forest Essence"
    set udg_DropItemIdTable[48]='I06K' // 'I06K': item "Barrens' Sand"
    set udg_DropItemIdTable[49]='I074' // 'I074': item "Mine Mineral"
    set udg_DropItemIdTable[50]='I06N' // 'I06N': item "Tropical Essence"
    set udg_DropItemIdTable[51]='I06R' // 'I06R': item "Wild Soul"
    set udg_DropItemIdTable[52]='I06T' // 'I06T': item "Theurgic Water"
    set udg_DropItemIdTable[53]='I068' // 'I068': item "Ancient Spirit"
    set udg_DropItemIdTable[54]='I06X' // 'I06X': item "Unique Ice Shard"
    set udg_DropItemIdTable[55]='I075' // 'I075': item "Abomination Eye"
    set udg_DropItemIdTable[56]='I076' // 'I076': item "Arcanium Imitate"
    set udg_DropItemIdTable[57]='I07E' // 'I07E': item "Triton Head"
    set udg_DropItemIdTable[58]='I07B' // 'I07B': item "Samurai's Amulet"
    set udg_DropItemIdTable[59]='I077' // 'I077': item "Demon's Blood"
    set udg_DropItemIdTable[60]='I0GX' // 'I0GX': item "Nebra Ore"
    set udg_DropItemIdTable[61]='I08H' // 'I08H': item "Wolf Fang"
    set udg_DropItemIdTable[62]='I05Q' // 'I05Q': item "Shadow Stone"
    set udg_DropItemIdTable[63]='I062' // 'I062': item "Aire Tam Enib Moc"
    set udg_DropItemIdTable[64]='I067' // 'I067': item "Death Seeker"
    set udg_DropItemIdTable[65]='I07D' // 'I07D': item "Turtle Tail"
    set udg_DropItemIdTable[66]='I083' // 'I083': item "Eye of Xhauron"
    set udg_DropItemIdTable[67]='I085' // 'I085': item "Wild Cry"
    set udg_DropItemIdTable[68]='I07C' // 'I07C': item "Nethril"
    set udg_DropItemIdTable[69]='I06P' // 'I06P': item "Scarletite"
    set udg_DropItemIdTable[70]='I0B7' // 'I0B7': item "Grand Crystal"
    set udg_DropItemIdTable[71]='I084' // 'I084': item "Adamantite"
    set udg_DropItemIdTable[72]='I087' // 'I087': item "Book of Suffering"
    set udg_DropItemIdTable[73]='I088' // 'I088': item "Magic Scroll"
    set udg_DropItemIdTable[74]='I089' // 'I089': item "Soul Powder"
    set udg_DropItemIdTable[75]='I08A' // 'I08A': item "Empyreal Soul"
    set udg_DropItemIdTable[76]='I08B' // 'I08B': item "Serpent Gem"
    set udg_DropItemIdTable[77]='I0G8' // 'I0G8': item "Dark Gem"
    set udg_DropItemIdTable[78]='I08L' // 'I08L': item "Healing Herb"
    set udg_DropItemIdTable[79]='I0GY' // 'I0GY': item "Naga Hide"
    set udg_DropItemIdTable[80]='I0DX' // 'I0DX': item "Satyr's Hoof"
    set udg_DropItemIdTable[81]='I0FM' // 'I0FM': item "Shimmerweed"
    set udg_DropItemIdTable[82]='I0FN' // 'I0FN': item "Thunderbloom Bulb"
    set udg_DropItemIdTable[83]='I02G' // 'I02G': item "Scroll of Rejuvenation"
    set udg_DropItemIdTable[84]='I0FQ' // 'I0FQ': item "Fire Gem"
    set udg_DropItemIdTable[85]='I0FR' // 'I0FR': item "Ice Gem"
    set udg_DropItemIdTable[86]='I0FS' // 'I0FS': item "Lightning Gem"
    set udg_DropItemIdTable[87]='I0FT' // 'I0FT': item "Water Gem"
    set udg_DropItemIdTable[88]='I0FU' // 'I0FU': item "Earth Gem"
    set udg_DropItemIdTable[89]='I0FV' // 'I0FV': item "Wind Gem"
    set udg_DropItemIdTable[90]='I0G2' // 'I0G2': item "Holy Gem"
    set udg_DropItemIdTable[91]='I0G7' // 'I0G7': item "Omni Gem"
    set udg_DropItemIdTable[92]='I0H8' // 'I0H8': item "Chef's Knife"
    set udg_DropItemIdTable[93]='I0H9' // 'I0H9': item "Bundle of Needles"
    set udg_DropItemIdTable[94]='I0HA' // 'I0HA': item "Malboro Tentacle"
    set udg_DropItemIdTable[95]='I0IP' // 'I0IP': item "Storm Wyrm Hide"
    set udg_DropItemIdTable[96]='I0JN' // 'I0JN': item "Dark Goblin's Head"
    set udg_DropItemIdTable[97]='I0JO' // 'I0JO': item "Flan Fluid"
    set udg_DropItemIdTable[98]='I0JP' // 'I0JP': item "Slime Oil"
    set udg_DropItemIdTable[99]='I0BY' // 'I0BY': item "Hell Gate's Flame"
    set udg_DropItemIdTable['d']='I0K0' // 'I0K0': item "Quality Mithril"
    set udg_DropItemIdTable['e']='I0CK' // 'I0CK': item "Strong Meat"
    set udg_DropItemIdTable['f']='I0CJ' // 'I0CJ': item "Light Meat"
    set udg_DropItemIdTable['g']='I0CL' // 'I0CL': item "Great Meat"
    set udg_DropItemIdTable['h']='I0CM' // 'I0CM': item "Salamander Fragment"
    set udg_DropItemIdTable['i']='I0GV' // 'I0GV': item "Great Fish"
    set udg_DropItemIdTable['j']='I0GW' // 'I0GW': item "Gold Fish"
    set udg_MaterialOwnedCount[32]=2
    set udg_MaterialOwnedCount[41]=3
    set udg_MaterialOwnedCount[55]=1
    set udg_MaterialOwnedCount[83]=2
    set udg_BazaarGoodItem[1]='I07J' // 'I07J': item "BAZAAR Ultimate Power"
    set udg_BazaarGoodItem[2]='I07K' // 'I07K': item "BAZAAR Nut of Deliciousness"
    set udg_BazaarGoodItem[3]='I07L' // 'I07L': item "BAZAAR Negative Rock"
    set udg_BazaarGoodItem[4]='I08C' // 'I08C': item "BAZAAR Legendary Katana"
    set udg_BazaarGoodItem[5]='I08E' // 'I08E': item "BAZAAR Shimmering Blue Blade"
    set udg_BazaarGoodItem[6]='I08D' // 'I08D': item "BAZAAR Sunflower"
    set udg_BazaarGoodItem[7]='I08T' // 'I08T': item "BAZAAR Pack of Potions"
    set udg_BazaarGoodItem[8]='I08U' // 'I08U': item "BAZAAR Medicine"
    set udg_BazaarGoodItem[9]='I08V' // 'I08V': item "BAZAAR Anti-Magic Potion"
    set udg_BazaarGoodItem[$A]='I08W' // $A = 10; 'I08W': item "BAZAAR Mystic Liquid"
    set udg_BazaarGoodItem[$B]='I08X' // $B = 11; 'I08X': item "BAZAAR Tincture"
    set udg_BazaarGoodItem[$C]='I08Y' // $C = 12; 'I08Y': item "BAZAAR Magic Recovery Pack"
    set udg_BazaarGoodItem[$D]='I08Z' // $D = 13; 'I08Z': item "BAZAAR Nectar Bottles"
    set udg_BazaarGoodItem[$E]='I090' // $E = 14; 'I090': item "BAZAAR Super Drink"
    set udg_BazaarGoodItem[$F]='I091' // $F = 15; 'I091': item "BAZAAR Ambrosium"
    set udg_BazaarGoodItem[16]='I092' // 'I092': item "BAZAAR Blood Medicine"
    set udg_BazaarGoodItem[17]='I093' // 'I093': item "BAZAAR Power Cry"
    set udg_BazaarGoodItem[18]='I094' // 'I094': item "BAZAAR Toxic Lance"
    set udg_BazaarGoodItem[19]='I095' // 'I095': item "BAZAAR Spirit of the Wild"
    set udg_BazaarGoodItem[20]='I096' // 'I096': item "BAZAAR Tropical Might"
    set udg_BazaarGoodItem[21]='I097' // 'I097': item "BAZAAR Gemsteel"
    set udg_BazaarGoodItem[22]='I098' // 'I098': item "BAZAAR Greather Mithril"
    set udg_BazaarGoodItem[23]='I099' // 'I099': item "BAZAAR Unbreakable Metal"
    set udg_BazaarGoodItem[24]='I09A' // 'I09A': item "BAZAAR Premium Ore Pack"
    set udg_BazaarGoodItem[25]='I09B' // 'I09B': item "BAZAAR Ultimate Arrows"
    set udg_BazaarGoodItem[26]='I09C' // 'I09C': item "BAZAAR Gaya's Legendary Material"
    set udg_BazaarGoodItem[27]='I09D' // 'I09D': item "BAZAAR Adamant Pride"
    set udg_BazaarGoodItem[28]='I09E' // 'I09E': item "BAZAAR Health Drops"
    set udg_BazaarGoodItem[29]='I09G' // 'I09G': item "BAZAAR Cursed Book"
    set udg_BazaarGoodItem[30]='I09F' // 'I09F': item "BAZAAR Parchment of Wizardry"
    set udg_BazaarGoodItem[31]='I09H' // 'I09H': item "BAZAAR Damned Spirit"
    set udg_BazaarGoodItem[32]='I09I' // 'I09I': item "BAZAAR Divine Power"
    set udg_BazaarGoodItem[33]='I09J' // 'I09J': item "BAZAAR Nature Stone"
    set udg_BazaarGoodItem[34]='I09K' // 'I09K': item "BAZAAR Final Elixir"
    set udg_BazaarGoodItem[35]='I09L' // 'I09L': item "BAZAAR Firm Belt"
    set udg_BazaarGoodItem[36]='I09M' // 'I09M': item "BAZAAR Expert Fishing Pole"
    set udg_BazaarGoodItem[37]='I09N' // 'I09N': item "BAZAAR Plant of Recovery"
    set udg_BazaarGoodItem[38]='I09O' // 'I09O': item "BAZAAR Mithril Armory"
    set udg_BazaarGoodItem[39]='I09P' // 'I09P': item "BAZAAR Strange Book"
    set udg_BazaarGoodItem[40]='I09Q' // 'I09Q': item "BAZAAR Ring of Legend"
    set udg_BazaarGoodItem[41]='I09R' // 'I09R': item "BAZAAR Reinforced Gear"
    set udg_BazaarGoodItem[42]='I09S' // 'I09S': item "BAZAAR Crystal Ammunition"
    set udg_BazaarGoodItem[43]='I09T' // 'I09T': item "BAZAAR Savage Helmet"
    set udg_BazaarGoodItem[44]='I0H7' // 'I0H7': item "BAZAAR Mystic Fists of Perception"
    set udg_BazaarGoodItem[45]='I09V' // 'I09V': item "BAZAAR Crystal of Earth"
    set udg_BazaarGoodItem[46]='I09W' // 'I09W': item "BAZAAR Crystal of Water"
    set udg_BazaarGoodItem[47]='I09X' // 'I09X': item "BAZAAR Crystal of Wind"
    set udg_BazaarGoodItem[48]='I09Y' // 'I09Y': item "BAZAAR Crystal of Gravity"
    set udg_BazaarGoodItem[49]='I0G9' // 'I0G9': item "BAZAAR All-Natural Stone"
    set udg_BazaarGoodItem[50]='I0CZ' // 'I0CZ': item "BAZAAR Statue Talisman"
    set udg_BazaarGoodItem[51]='I0H6' // 'I0H6': item "BAZAAR Elemental Powers"
    set udg_BazaarGoodItem[52]='I0CY' // 'I0CY': item "BAZAAR Cool Glasses"
    set udg_BazaarGoodItem[53]='I0IQ' // 'I0IQ': item "BAZAAR Well-Crafted Armor"
    set udg_BazaarGoodItem[54]='I0JZ' // 'I0JZ': item "BAZAAR Absorbing Staff"
    set udg_BazaarGoodItem[55]='I0C4' // 'I0C4': item "BAZAAR Hollow Orb"
    set udg_BazaarGoodItem[56]='I00A' // 'I00A': item "BAZAAR Fish Exchange"
    set udg_BazaarResultItem[1]='I05O' // 'I05O': item "Perfect Mark of Darkness"
    set udg_BazaarResultItem[2]='I07H' // 'I07H': item "Zeio Nut"
    set udg_BazaarResultItem[3]='I05Q' // 'I05Q': item "Shadow Stone"
    set udg_BazaarResultItem[4]='I019' // 'I019': item "Masamune"
    set udg_BazaarResultItem[5]='I066' // 'I066': item "Lion Heart"
    set udg_BazaarResultItem[6]='I081' // 'I081': item "Tournesol"
    set udg_BazaarResultItem[7]='phea' // 'phea': item "Potion"
    set udg_BazaarResultItem[8]='pghe' // 'pghe': item "Hi-Potion"
    set udg_BazaarResultItem[9]='ankh' // 'ankh': item "Dispel Tonic"
    set udg_BazaarResultItem[$A]='pman' // $A = 10; 'pman': item "Ether"
    set udg_BazaarResultItem[$B]='pgma' // $B = 11; 'pgma': item "Hi-Ether"
    set udg_BazaarResultItem[$C]='I02V' // $C = 12; 'I02V': item "Nectar"
    set udg_BazaarResultItem[$D]='I02X' // $D = 13; 'I02X': item "Greater Nectar"
    set udg_BazaarResultItem[$E]='pdiv' // $E = 14; 'pdiv': item "Hero Drink"
    set udg_BazaarResultItem[$F]='I05I' // $F = 15; 'I05I': item "Spirit Potion"
    set udg_BazaarResultItem[16]='I05H' // 'I05H': item "Blood Ether"
    set udg_BazaarResultItem[17]='sror' // 'sror': item "Spirit of Lowtown"
    set udg_BazaarResultItem[18]='I00M' // 'I00M': item "Poison Spear"
    set udg_BazaarResultItem[19]='I085' // 'I085': item "Wild Cry"
    set udg_BazaarResultItem[20]='I07C' // 'I07C': item "Nethril"
    set udg_BazaarResultItem[21]='I06P' // 'I06P': item "Scarletite"
    set udg_BazaarResultItem[22]='I0LK' // 'I0LK': item "Artemis Arrows"
    set udg_BazaarResultItem[23]='I084' // 'I084': item "Adamantite"
    set udg_BazaarResultItem[24]='I087' // 'I087': item "Book of Suffering"
    set udg_BazaarResultItem[25]='I088' // 'I088': item "Magic Scroll"
    set udg_BazaarResultItem[26]='I089' // 'I089': item "Soul Powder"
    set udg_BazaarResultItem[27]='I08A' // 'I08A': item "Empyreal Soul"
    set udg_BazaarResultItem[28]='I08B' // 'I08B': item "Serpent Gem"
    set udg_BazaarResultItem[29]='I03P' // 'I03P': item "Megalixir"
    set udg_BazaarResultItem[30]='I0DR' // 'I0DR': item "Cameo Belt"
    set udg_BazaarResultItem[31]='I08L' // 'I08L': item "Healing Herb"
    set udg_BazaarResultItem[32]='I00V' // 'I00V': item "Mithril Sword"
    set udg_BazaarResultItem[33]='I014' // 'I014': item "Mithril Shield"
    set udg_BazaarResultItem[34]='I01I' // 'I01I': item "Mithril Helmet"
    set udg_BazaarResultItem[35]='I01R' // 'I01R': item "Mithril Mail"
    set udg_BazaarResultItem[36]='I0BN' // 'I0BN': item "Book of Elements"
    set udg_BazaarResultItem[37]='I08F' // 'I08F': item "Iron Duke"
    set udg_BazaarResultItem[38]='I035' // 'I035': item "Platinum Dagger"
    set udg_BazaarResultItem[39]='I016' // 'I016': item "Platinum Shield"
    set udg_BazaarResultItem[40]='I01K' // 'I01K': item "Platinum Helmet"
    set udg_BazaarResultItem[41]='I01T' // 'I01T': item "Platinum Mail"
    set udg_BazaarResultItem[42]='I0CR' // 'I0CR': item "Crystal Pieces"
    set udg_BazaarResultItem[43]='I02Z' // 'I02Z': item "Barbarian's Helmet"
    set udg_BazaarResultItem[44]='I031' // 'I031': item "Crusher's Belt"
    set udg_BazaarResultItem[45]='I0DH' // 'I0DH': item "Strange Vision"
    set udg_BazaarResultItem[46]='I03G' // 'I03G': item "Quake Materia"
    set udg_BazaarResultItem[47]='I023' // 'I023': item "Water Materia"
    set udg_BazaarResultItem[48]='I07N' // 'I07N': item "Aero Materia"
    set udg_BazaarResultItem[49]='I03L' // 'I03L': item "Demi Materia"
    set udg_BazaarResultItem[50]='I0CX' // 'I0CX': item "Magic God Token"
    set udg_BazaarResultItem[51]='I0DI' // 'I0DI': item "Remedy"
    set udg_BazaarResultItem[52]='I0G7' // 'I0G7': item "Omni Gem"
    set udg_BazaarResultItem[53]='I0GB' // 'I0GB': item "Matamune"
    set udg_BazaarResultItem[54]='I03H' // 'I03H': item "Quakera Materia"
    set udg_BazaarResultItem[55]='I024' // 'I024': item "Watera Materia"
    set udg_BazaarResultItem[56]='I07O' // 'I07O': item "Aerora Materia"
    set udg_BazaarResultItem[57]='I03M' // 'I03M': item "Demira Materia"
    set udg_BazaarResultItem[58]='I0CO' // 'I0CO': item "Silver Glasses"
    set udg_BazaarResultItem[59]='I01O' // 'I01O': item "Storm Wyrm Hide Armor"
    set udg_BazaarResultItem[60]='I0JW' // 'I0JW': item "Dark Staff"
    set udg_BazaarResultItem[61]='I0BC' // 'I0BC': item "Canister Shot"
    set udg_BazaarResultItem[62]='I0B8' // 'I0B8': item "Pulsar Shot"
    set udg_BazaarResultItem[63]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_BazaarResultItem[64]='I0GT' // 'I0GT': item "Nebra Fish"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Bazaar_Recipes_Actions takes nothing returns nothing
    call InitHashtableBJ()
    set udg_BazaarRecipeHash=GetLastCreatedHashtableBJ()
    call SaveIntegerBJ(16,1,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,4,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,6,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,8,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,9,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,$A,1,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,1,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(5,$C,1,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,$D,1,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(6,$E,1,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(1,$F,1,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(7,16,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,17,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(8,18,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,19,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(9,20,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,21,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ($A,22,1,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,23,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ($B,24,1,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(1,25,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ($C,26,1,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,27,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ($D,28,1,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(1,29,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ($E,30,1,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(1,31,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ($F,32,1,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(1,33,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(16,34,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,35,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,36,1,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(17,4,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(18,6,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(19,8,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,9,2,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,$A,2,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,2,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(2,1,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(36,4,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,5,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(32,6,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,7,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,8,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,9,3,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(69,4,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(68,6,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(77,8,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,9,4,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,$A,4,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(2,1,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,2,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,3,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(71,4,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(70,6,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(5,7,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(5,8,5,udg_BazaarRecipeHash)
    call SaveIntegerBJ(61,$A,5,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(3,1,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(76,4,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,5,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(68,6,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,7,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(75,8,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(6,9,6,udg_BazaarRecipeHash)
    call SaveIntegerBJ(6,$A,6,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(2,1,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(6,3,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(23,4,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(21,6,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(7,7,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ(7,8,7,udg_BazaarRecipeHash)
    call SaveIntegerBJ($F,9,7,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(2,1,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(21,4,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,5,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,6,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(8,7,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ(8,8,8,udg_BazaarRecipeHash)
    call SaveIntegerBJ($F,9,8,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(1,1,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(81,4,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(9,5,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(9,6,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,7,9,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,1,$A,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,2,$A,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,3,$A,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(82,4,$A,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ($A,5,$A,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ($F,6,$A,udg_BazaarRecipeHash) // $F = 15; $A = 10
    call SaveIntegerBJ(5,7,$A,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(2,1,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(1,2,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(2,3,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(22,4,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(1,5,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(57,6,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ($B,7,$B,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ($A,8,$B,udg_BazaarRecipeHash) // $A = 10; $B = 11
    call SaveIntegerBJ($F,9,$B,udg_BazaarRecipeHash) // $F = 15; $B = 11
    call SaveIntegerBJ(1,1,$C,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,2,$C,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(2,3,$C,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(30,4,$C,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ($C,5,$C,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ($B,6,$C,udg_BazaarRecipeHash) // $B = 11; $C = 12
    call SaveIntegerBJ(4,7,$C,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,1,$D,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(1,2,$D,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(3,3,$D,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(47,4,$D,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ($D,5,$D,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ($C,6,$D,udg_BazaarRecipeHash) // $C = 12; $D = 13
    call SaveIntegerBJ(5,7,$D,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(2,1,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(1,2,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(2,3,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(43,4,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(2,5,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(38,6,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ($E,7,$E,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ($D,8,$E,udg_BazaarRecipeHash) // $D = 13; $E = 14
    call SaveIntegerBJ($A,9,$E,udg_BazaarRecipeHash) // $A = 10; $E = 14
    call SaveIntegerBJ(2,1,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(1,2,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(3,3,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(41,4,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(1,5,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(57,6,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ($F,7,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ($E,8,$F,udg_BazaarRecipeHash) // $E = 14; $F = 15
    call SaveIntegerBJ(1,9,$F,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(1,1,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,3,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(83,4,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(16,5,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(16,6,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,7,16,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,1,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,3,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(61,4,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(26,6,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(17,7,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(17,8,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(5,9,17,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,1,18,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,18,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,18,udg_BazaarRecipeHash)
    call SaveIntegerBJ(55,4,18,udg_BazaarRecipeHash)
    call SaveIntegerBJ(18,5,18,udg_BazaarRecipeHash)
    call SaveIntegerBJ(18,6,18,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(66,4,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(34,6,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(27,8,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(19,9,19,udg_BazaarRecipeHash)
    call SaveIntegerBJ(19,$A,19,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,19,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(3,1,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(45,4,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,5,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(38,6,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(50,8,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,9,20,udg_BazaarRecipeHash)
    call SaveIntegerBJ(19,$A,20,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(2,$B,20,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(2,1,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(36,4,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(48,6,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(21,7,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,8,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,9,21,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,1,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(96,4,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(59,6,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(22,7,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,8,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,9,22,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(49,4,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(68,6,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(51,8,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(23,9,23,udg_BazaarRecipeHash)
    call SaveIntegerBJ(21,$A,23,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,23,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(1,1,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,2,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,3,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(56,4,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(24,5,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,6,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(21,8,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,24,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(69,4,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(33,6,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(80,8,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(25,9,25,udg_BazaarRecipeHash)
    call SaveIntegerBJ(22,$A,25,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(3,1,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(65,4,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,5,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(52,6,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(35,8,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(26,9,26,udg_BazaarRecipeHash)
    call SaveIntegerBJ(23,$A,26,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,26,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(4,1,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(69,4,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(64,6,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(37,8,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,9,27,udg_BazaarRecipeHash)
    call SaveIntegerBJ(35,$A,27,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(27,$B,27,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(23,$C,27,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(2,$D,27,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(4,1,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(25,4,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(26,6,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(48,8,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,9,28,udg_BazaarRecipeHash)
    call SaveIntegerBJ(21,$A,28,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(28,$B,28,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(51,$C,28,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(5,$D,28,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(2,1,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(64,4,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(28,6,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(29,7,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(24,8,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,9,29,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,1,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(29,4,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(30,5,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(25,6,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,30,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(73,4,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(44,6,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(72,8,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(31,9,31,udg_BazaarRecipeHash)
    call SaveIntegerBJ(26,$A,31,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,31,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(4,1,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(74,4,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(67,6,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(54,8,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,9,32,udg_BazaarRecipeHash)
    call SaveIntegerBJ(53,$A,32,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(32,$B,32,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(27,$C,32,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,$D,32,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(4,1,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(33,4,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(39,6,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,7,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(40,8,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,9,33,udg_BazaarRecipeHash)
    call SaveIntegerBJ(25,$A,33,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(33,$B,33,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(28,$C,33,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,$D,33,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(3,1,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(71,4,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(78,6,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(77,8,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(34,9,34,udg_BazaarRecipeHash)
    call SaveIntegerBJ(29,$A,34,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,34,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(1,1,35,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,35,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,35,udg_BazaarRecipeHash)
    call SaveIntegerBJ(92,4,35,udg_BazaarRecipeHash)
    call SaveIntegerBJ(35,5,35,udg_BazaarRecipeHash)
    call SaveIntegerBJ(30,6,35,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(79,4,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(60,6,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(65,8,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(36,9,36,udg_BazaarRecipeHash)
    call SaveIntegerBJ(53,$A,36,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(3,1,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(43,4,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(25,6,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,7,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(24,8,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(37,9,37,udg_BazaarRecipeHash)
    call SaveIntegerBJ(31,$A,37,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,37,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(1,1,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,2,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ('d',4,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ(38,5,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ(32,6,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ(33,8,38,udg_BazaarRecipeHash)
    call SaveIntegerBJ(34,$A,38,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(35,$C,38,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,1,39,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,39,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,39,udg_BazaarRecipeHash)
    call SaveIntegerBJ(31,4,39,udg_BazaarRecipeHash)
    call SaveIntegerBJ(39,5,39,udg_BazaarRecipeHash)
    call SaveIntegerBJ(36,6,39,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(71,4,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(74,6,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(63,8,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(40,9,40,udg_BazaarRecipeHash)
    call SaveIntegerBJ(37,$A,40,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(2,1,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,2,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(37,4,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,5,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(41,6,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(41,7,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(38,8,41,udg_BazaarRecipeHash)
    call SaveIntegerBJ(39,$A,41,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(40,$C,41,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(41,$E,41,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(1,1,42,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,42,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,42,udg_BazaarRecipeHash)
    call SaveIntegerBJ(70,4,42,udg_BazaarRecipeHash)
    call SaveIntegerBJ(42,5,42,udg_BazaarRecipeHash)
    call SaveIntegerBJ(62,6,42,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,2,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(27,4,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(26,6,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(40,8,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(43,9,43,udg_BazaarRecipeHash)
    call SaveIntegerBJ(43,$A,43,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(44,$C,43,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,1,44,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,44,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,44,udg_BazaarRecipeHash)
    call SaveIntegerBJ(93,4,44,udg_BazaarRecipeHash)
    call SaveIntegerBJ(44,5,44,udg_BazaarRecipeHash)
    call SaveIntegerBJ(45,6,44,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(48,4,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(45,6,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(5,7,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(61,8,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(45,9,45,udg_BazaarRecipeHash)
    call SaveIntegerBJ(46,$A,45,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(20,$B,45,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(2,1,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(52,4,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,5,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(46,6,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(46,7,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(47,8,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,9,46,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,1,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(50,4,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(51,6,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,7,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(24,8,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(47,9,47,udg_BazaarRecipeHash)
    call SaveIntegerBJ(48,$A,47,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(20,$B,47,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(2,1,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(42,4,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(72,6,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(48,7,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(49,8,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(20,9,48,udg_BazaarRecipeHash)
    call SaveIntegerBJ(6,1,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(84,4,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(85,6,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,7,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(86,8,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,9,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(87,$A,49,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(1,$B,49,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(88,$C,49,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(1,$D,49,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(89,$E,49,udg_BazaarRecipeHash) // $E = 14
    call SaveIntegerBJ(49,$F,49,udg_BazaarRecipeHash) // $F = 15
    call SaveIntegerBJ(52,16,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,17,49,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,1,50,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,50,udg_BazaarRecipeHash)
    call SaveIntegerBJ(3,3,50,udg_BazaarRecipeHash)
    call SaveIntegerBJ(63,4,50,udg_BazaarRecipeHash)
    call SaveIntegerBJ(50,5,50,udg_BazaarRecipeHash)
    call SaveIntegerBJ(50,6,50,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,1,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,2,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(91,4,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(51,5,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(54,6,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(30,7,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(55,8,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(30,9,51,udg_BazaarRecipeHash)
    call SaveIntegerBJ(56,$A,51,udg_BazaarRecipeHash) // $A = 10
    call SaveIntegerBJ(30,$B,51,udg_BazaarRecipeHash) // $B = 11
    call SaveIntegerBJ(57,$C,51,udg_BazaarRecipeHash) // $C = 12
    call SaveIntegerBJ(30,$D,51,udg_BazaarRecipeHash) // $D = 13
    call SaveIntegerBJ(1,1,52,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,52,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,52,udg_BazaarRecipeHash)
    call SaveIntegerBJ(94,4,52,udg_BazaarRecipeHash)
    call SaveIntegerBJ(52,5,52,udg_BazaarRecipeHash)
    call SaveIntegerBJ(58,6,52,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,1,53,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,53,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,53,udg_BazaarRecipeHash)
    call SaveIntegerBJ(95,4,53,udg_BazaarRecipeHash)
    call SaveIntegerBJ(53,5,53,udg_BazaarRecipeHash)
    call SaveIntegerBJ(59,6,53,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,1,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(4,3,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(97,4,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,5,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(98,6,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(54,7,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(60,8,54,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,1,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,3,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(62,4,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(90,6,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(55,7,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(63,8,55,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,1,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,2,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ(2,3,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ('i',4,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ(1,5,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ('j',6,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ(56,7,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ(64,8,56,udg_BazaarRecipeHash)
    call SaveIntegerBJ(5,9,56,udg_BazaarRecipeHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Bazaar_PawnMaterial_HasCharges takes nothing returns boolean
    return(GetItemCharges(GetSoldItem())>=1)
endfunction

function Trig_Bazaar_PawnMaterial_IsMaterial takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())==udg_DropItemIdTable[GetForLoopIndexA()])
endfunction

function Trig_Bazaar_PawnMaterial_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_MaterialTypeCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Bazaar_PawnMaterial_IsMaterial())then
            if(Trig_Bazaar_PawnMaterial_HasCharges())then
                set udg_MaterialOwnedCount[GetForLoopIndexA()]=(udg_MaterialOwnedCount[GetForLoopIndexA()]+GetItemCharges(GetSoldItem()))
            else
                set udg_MaterialOwnedCount[GetForLoopIndexA()]=(udg_MaterialOwnedCount[GetForLoopIndexA()]+1)
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_LastBazaarShop=GetBuyingUnit()
    call StartTimerBJ(udg_BazaarUpdateTimer,false,.01)
endfunction

function Trig_Bazaar_UpdateStock_HasIngredient takes nothing returns boolean
    return(udg_RecipeAffordable)and(udg_MaterialOwnedCount[LoadIntegerBJ((GetForLoopIndexB()+1),GetForLoopIndexA(),udg_BazaarRecipeHash)]>=LoadIntegerBJ(GetForLoopIndexB(),GetForLoopIndexA(),udg_BazaarRecipeHash))
endfunction

function Trig_Bazaar_UpdateStock_IsIngredientSlot takes nothing returns boolean
    // The remainder after dividing (loop counter B) by (2).
    return(ModuloInteger(GetForLoopIndexB(),2)==1)
endfunction

function Trig_Bazaar_UpdateStock_IsIngredientSlotSpend takes nothing returns boolean
    // The remainder after dividing (loop counter B) by (2).
    return(ModuloInteger(GetForLoopIndexB(),2)==1)
endfunction

function Trig_Bazaar_UpdateStock_PawnedAtBazaar takes nothing returns boolean
    return(GetUnitTypeId(udg_LastBazaarShop)=='n030') // 'n030': unit "Bazaar Shop"
endfunction

function Trig_Bazaar_UpdateStock_CanCraftRecipe takes nothing returns boolean
    return(udg_RecipeAffordable)
endfunction

function Trig_Bazaar_UpdateStock_HasStock takes nothing returns boolean
    // Result 1: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
    // Result 2: (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)) times (2).
    // Result 3: (result 1) plus (result 2).
    // Result 4: (4) plus (result 3).
    return(LoadIntegerBJ((4+((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+(LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))),GetForLoopIndexA(),udg_BazaarRecipeHash)>=1)
endfunction

function Trig_Bazaar_UpdateStock_HasSpentMaterial takes nothing returns boolean
    return(udg_MaterialSpentCount[GetForLoopIndexA()]>0)
endfunction

function Trig_Bazaar_UpdateStock_Actions takes nothing returns nothing
    set udg_BazaarStockedCount=0
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_MaterialTypeCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_MaterialSpentCount[GetForLoopIndexA()]=0
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_BazaarGoodCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call RemoveItemFromStockBJ(udg_BazaarGoodItem[GetForLoopIndexA()],udg_BazaarShopUnit)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_BazaarGoodCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_RecipeAffordable=true
        set udg_MaterialOwnedCount[0]=99
        set bj_forLoopBIndex=3
        set bj_forLoopBIndexEnd=((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+2)
        loop
            exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
            if(Trig_Bazaar_UpdateStock_IsIngredientSlot())then
                if(Trig_Bazaar_UpdateStock_HasIngredient())then
                    set udg_MaterialOwnedCount[0]=IMinBJ(udg_MaterialOwnedCount[0],(udg_MaterialOwnedCount[LoadIntegerBJ((GetForLoopIndexB()+1),GetForLoopIndexA(),udg_BazaarRecipeHash)]/ LoadIntegerBJ(GetForLoopIndexB(),GetForLoopIndexA(),udg_BazaarRecipeHash)))
                else
                    set udg_RecipeAffordable=false
                endif
            endif
            set bj_forLoopBIndex=bj_forLoopBIndex+1
        endloop
        if(Trig_Bazaar_UpdateStock_CanCraftRecipe())then
            // Calculation 1:
            // Result 1: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 2: (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 3: (result 1) plus (result 2).
            // Result 4: (4) plus (result 3).
            // Result 5: (LoadIntegerBJ(result 4, loop counter A, udg_BazaarRecipeHash)) plus (udg_MaterialOwnedCount at
            // position 0).
            // Calculation 2:
            // Result 1: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 2: (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 3: (result 1) plus (result 2).
            // Result 4: (4) plus (result 3).
            call SaveIntegerBJ((LoadIntegerBJ((4+((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+(LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))),GetForLoopIndexA(),udg_BazaarRecipeHash)+udg_MaterialOwnedCount[0]),(4+((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+(LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))),GetForLoopIndexA(),udg_BazaarRecipeHash)
            set bj_forLoopBIndex=3
            set bj_forLoopBIndexEnd=((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+2)
            loop
                exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
                if(Trig_Bazaar_UpdateStock_IsIngredientSlotSpend())then
                    set udg_MaterialSpentCount[LoadIntegerBJ((GetForLoopIndexB()+1),GetForLoopIndexA(),udg_BazaarRecipeHash)]=IMaxBJ(udg_MaterialSpentCount[LoadIntegerBJ((GetForLoopIndexB()+1),GetForLoopIndexA(),udg_BazaarRecipeHash)],(LoadIntegerBJ(GetForLoopIndexB(),GetForLoopIndexA(),udg_BazaarRecipeHash)*udg_MaterialOwnedCount[0]))
                endif
                set bj_forLoopBIndex=bj_forLoopBIndex+1
            endloop
            set udg_TempPoint=GetUnitLoc(udg_LastBazaarShop)
            if(Trig_Bazaar_UpdateStock_PawnedAtBazaar())then
                call CreateTextTagLocBJ("New Bazaar Goods available!",udg_TempPoint,0,11.5,'d','d','d',0)
            else
                call CreateTextTagLocBJ("New Bazaar Goods available at Bazaar Shop!",udg_TempPoint,0,11.5,'d','d','d',0)
            endif
            call RemoveLocation(udg_TempPoint)
            call SetTextTagLifespanBJ(GetLastCreatedTextTag(),3.)
            call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        endif
        if(Trig_Bazaar_UpdateStock_HasStock())then
            // Result 1: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 2: (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 3: (result 1) plus (result 2).
            // Result 4: (4) plus (result 3).
            call AddItemToStockBJ(udg_BazaarGoodItem[GetForLoopIndexA()],udg_BazaarShopUnit,0,LoadIntegerBJ((4+((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+(LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))),GetForLoopIndexA(),udg_BazaarRecipeHash))
            set udg_BazaarStockedCount=(udg_BazaarStockedCount+1)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_MaterialTypeCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Bazaar_UpdateStock_HasSpentMaterial())then
            set udg_MaterialOwnedCount[GetForLoopIndexA()]=(udg_MaterialOwnedCount[GetForLoopIndexA()]-udg_MaterialSpentCount[GetForLoopIndexA()])
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call StartTimerBJ(udg_BazaarUpdateTimer,false,30)
endfunction

function Trig_Bazaar_Sell_Bundle_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetSellingUnit())=='n030')and(SubStringBJ(GetItemName(GetSoldItem()),1,7)=="BAZAAR ") // 'n030': unit "Bazaar Shop"
endfunction

function Trig_Bazaar_Sell_Bundle_HasCharges takes nothing returns boolean
    return(LoadIntegerBJ((GetForLoopIndexB()+1),GetForLoopIndexA(),udg_BazaarRecipeHash)>=1)and(GetItemType(GetLastCreatedItem())==ITEM_TYPE_CHARGED)
endfunction

function Trig_Bazaar_Sell_Bundle_IsEvenIndex takes nothing returns boolean
    // The remainder after dividing (loop counter B) by (2).
    return(ModuloInteger(GetForLoopIndexB(),2)==0)
endfunction

function Trig_Bazaar_Sell_Bundle_IsBazaarBundle takes nothing returns boolean
    return(GetItemTypeId(GetSoldItem())==udg_BazaarGoodItem[GetForLoopIndexA()])
endfunction

function Trig_Bazaar_Sell_Bundle_Actions takes nothing returns nothing
    call RemoveItemFromStockBJ(GetItemTypeId(GetSoldItem()),GetSellingUnit())
    set udg_LastBazaarShop=GetTriggerUnit()
    call StartTimerBJ(udg_BazaarUpdateTimer,false,.01)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=udg_BazaarGoodCount
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Bazaar_Sell_Bundle_IsBazaarBundle())then
            call RemoveItem(GetSoldItem())
            // Calculation 1:
            // Result 1: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 2: (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 3: (result 1) plus (result 2).
            // Result 4: (4) plus (result 3).
            // Result 5: (LoadIntegerBJ(result 4, loop counter A, udg_BazaarRecipeHash)) minus (1).
            // Calculation 2:
            // Result 1: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 2: (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 3: (result 1) plus (result 2).
            // Result 4: (4) plus (result 3).
            call SaveIntegerBJ((LoadIntegerBJ((4+((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+(LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))),GetForLoopIndexA(),udg_BazaarRecipeHash)-1),(4+((LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)+(LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))),GetForLoopIndexA(),udg_BazaarRecipeHash)
            set bj_forLoopBIndex=(4+(LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2))
            // Result 1: (2) times (LoadIntegerBJ(2, loop counter A, udg_BazaarRecipeHash)).
            // Result 2: (LoadIntegerBJ(1, loop counter A, udg_BazaarRecipeHash)) times (2).
            // Result 3: (3) plus (result 2).
            // Result 4: (result 1) plus (result 3).
            set bj_forLoopBIndexEnd=((2*LoadIntegerBJ(2,GetForLoopIndexA(),udg_BazaarRecipeHash))+(3+(LoadIntegerBJ(1,GetForLoopIndexA(),udg_BazaarRecipeHash)*2)))
            loop
                exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
                if(Trig_Bazaar_Sell_Bundle_IsEvenIndex())then
                    set udg_TempPoint=GetUnitLoc(GetBuyingUnit())
                    call CreateItemLoc(udg_BazaarResultItem[LoadIntegerBJ(GetForLoopIndexB(),GetForLoopIndexA(),udg_BazaarRecipeHash)],udg_TempPoint)
                    call RemoveLocation(udg_TempPoint)
                    if(Trig_Bazaar_Sell_Bundle_HasCharges())then
                        call SetItemCharges(GetLastCreatedItem(),LoadIntegerBJ((GetForLoopIndexB()+1),GetForLoopIndexA(),udg_BazaarRecipeHash))
                    endif
                    call UnitAddItemSwapped(GetLastCreatedItem(),GetBuyingUnit())
                endif
                set bj_forLoopBIndex=bj_forLoopBIndex+1
            endloop
            return
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// World Editor calls InitTrig_Bazaar automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Bazaar (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Bazaar takes nothing returns nothing
endfunction

function Register_Bazaar_Init takes nothing returns nothing
    set gg_trg_Bazaar_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Bazaar_Init,3.)
    call TriggerAddAction(gg_trg_Bazaar_Init,function Trig_Bazaar_Init_Actions)
endfunction

function Register_Bazaar_Recipes takes nothing returns nothing
    set gg_trg_Bazaar_Recipes=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Bazaar_Recipes,3.)
    call TriggerAddAction(gg_trg_Bazaar_Recipes,function Trig_Bazaar_Recipes_Actions)
endfunction

function Register_Bazaar_PawnMaterial takes nothing returns nothing
    set gg_trg_Bazaar_PawnMaterial=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bazaar_PawnMaterial,EVENT_PLAYER_UNIT_PAWN_ITEM)
    call TriggerAddAction(gg_trg_Bazaar_PawnMaterial,function Trig_Bazaar_PawnMaterial_Actions)
endfunction

function Register_Bazaar_UpdateStock takes nothing returns nothing
    set gg_trg_Bazaar_UpdateStock=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Bazaar_UpdateStock,udg_BazaarUpdateTimer)
    call TriggerAddAction(gg_trg_Bazaar_UpdateStock,function Trig_Bazaar_UpdateStock_Actions)
endfunction

function Register_Bazaar_Sell_Bundle takes nothing returns nothing
    set gg_trg_Bazaar_Sell_Bundle=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Bazaar_Sell_Bundle,EVENT_PLAYER_UNIT_SELL_ITEM)
    call TriggerAddCondition(gg_trg_Bazaar_Sell_Bundle,Condition(function Trig_Bazaar_Sell_Bundle_Conditions))
    call TriggerAddAction(gg_trg_Bazaar_Sell_Bundle,function Trig_Bazaar_Sell_Bundle_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Bazaar takes nothing returns nothing
    call Register_Bazaar_Init()
    call Register_Bazaar_Recipes()
    call Register_Bazaar_PawnMaterial()
    call Register_Bazaar_UpdateStock() // run by Quest_WolfFangs
    call Register_Bazaar_Sell_Bundle()
endfunction

endlibrary

library TArmory requires TForce, TPlayerHero
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Armory_Item_List=null
    trigger gg_trg_Armory_Item_Hash=null
    trigger gg_trg_Armory_Init=null
    trigger gg_trg_Armory_Open=null
    trigger gg_trg_Armory_Select=null
    trigger gg_trg_Armory_Back=null
    trigger gg_trg_Armory_Closed=null
    trigger gg_trg_Armory_Store_Item=null
    // Variables only this module uses.
    unit array udg_ArmoryUnit
    integer udg_ArmoryStockMax=0
endglobals

function Trig_Armory_Store_Item_CancelCodeLoad takes player p returns nothing
    if udg_ArmoryCodeSegment[GetPlayerId(p)]>0 then
        set udg_ArmoryCodeSegment[GetPlayerId(p)]=0
        call DisplayTimedTextToPlayer(p,0,0,30,"Cancelled loading of armory code segment.")
    endif
endfunction

function Trig_Armory_Item_List_Actions takes nothing returns nothing
    set udg_SaveFlagCount=351
    set udg_ItemIdTable[1]='pman' // 'pman': item "Ether"
    set udg_ItemIdTable[2]='pdiv' // 'pdiv': item "Hero Drink"
    set udg_ItemIdTable[3]='pgma' // 'pgma': item "Hi-Ether"
    set udg_ItemIdTable[4]='pghe' // 'pghe': item "Hi-Potion"
    set udg_ItemIdTable[5]='sman' // 'sman': item "Mega Ether"
    set udg_ItemIdTable[6]='ankh' // 'ankh': item "Dispel Tonic"
    set udg_ItemIdTable[7]='phea' // 'phea': item "Potion"
    set udg_ItemIdTable[8]='stwp' // 'stwp': item "Scroll of Portal"
    set udg_ItemIdTable[9]='I001' // 'I001': item "Mega Potion"
    set udg_ItemIdTable[$A]='I002' // $A = 10; 'I002': item "Turbo Ether"
    set udg_ItemIdTable[$B]='I000' // $B = 11; 'I000': item "X-Potion"
    set udg_ItemIdTable[68]='pres' // 'pres': item "Elixir"
    set udg_ItemIdTable[74]='sror' // 'sror': item "Spirit of Lowtown"
    set udg_ItemIdTable[78]='I02V' // 'I02V': item "Nectar"
    set udg_ItemIdTable[83]='I02X' // 'I02X': item "Greater Nectar"
    set udg_ItemIdTable[96]='I03P' // 'I03P': item "Megalixir"
    set udg_ItemIdTable['k']='I02E' // 'I02E': item "Chemist's Ether"
    set udg_ItemIdTable['l']='I02I' // 'I02I': item "Chemist's Hi-Ether"
    set udg_ItemIdTable['m']='I02K' // 'I02K': item "Chemist's Mega Ether"
    set udg_ItemIdTable['n']='I02N' // 'I02N': item "Chemist's Turbo Ether"
    set udg_ItemIdTable['p']='I02L' // 'I02L': item "Chemist's Potion"
    set udg_ItemIdTable['q']='I02J' // 'I02J': item "Chemist's Hi-Potion"
    set udg_ItemIdTable['r']='I02M' // 'I02M': item "Chemist's Mega Potion"
    set udg_ItemIdTable['s']='I02O' // 'I02O': item "Chemist's X-Potion"
    set udg_ItemIdTable['t']='I02H' // 'I02H': item "Chemist's Hero Drink"
    set udg_ItemIdTable['u']='I02D' // 'I02D': item "Chemist's Elixir"
    set udg_ItemIdTable[$7F]='I05I' // $7F = 127; 'I05I': item "Spirit Potion"
    set udg_ItemIdTable[$80]='I05H' // $80 = 128; 'I05H': item "Blood Ether"
    set udg_ItemIdTable[$BB]='I0DI' // $BB = 187; 'I0DI': item "Remedy"
    set udg_ItemIdTable[$DE]='I0ET' // $DE = 222; 'I0ET': item "Chemist's Nectar"
    set udg_ItemIdTable[$DF]='I0EU' // $DF = 223; 'I0EU': item "Chemist's Greater Nectar"
    set udg_ItemIdTable[$BC]='I0KF' // $BC = 188; 'I0KF': item "Wild Bowl"
    set udg_ItemIdTable[$C3]='I0KG' // $C3 = 195; 'I0KG': item "Triton Pot"
    set udg_ItemIdTable[$C4]='I0KH' // $C4 = 196; 'I0KH': item "Tropical Dish"
    set udg_ItemIdTable[$C5]='I0KI' // $C5 = 197; 'I0KI': item "Fish Soup"
    set udg_ItemIdTable['i']='I0KJ' // 'I0KJ': item "Energy Brew"
    set udg_ItemIdTable['j']='I0KK' // 'I0KK': item "Swift Drink"
    set udg_ItemIdTable[$93]='I0KL' // $93 = 147; 'I0KL': item "Spiced Salad"
    set udg_ItemIdTable[$99]='I0KM' // $99 = 153; 'I0KM': item "Nebra Bread"
    set udg_ItemIdTable[$D2]='I0KN' // $D2 = 210; 'I0KN': item "First Class Meat Plate"
    set udg_ItemIdTable[$A9]='I0KO' // $A9 = 169; 'I0KO': item "Adamant Stew"
    set udg_ItemIdTable[69]='I023' // 'I023': item "Water Materia"
    set udg_ItemIdTable[70]='I024' // 'I024': item "Watera Materia"
    set udg_ItemIdTable[71]='I025' // 'I025': item "Wateraga Materia"
    set udg_ItemIdTable[98]='I03G' // 'I03G': item "Quake Materia"
    set udg_ItemIdTable[99]='I03H' // 'I03H': item "Quakera Materia"
    set udg_ItemIdTable['d']='I03F' // 'I03F': item "Quakeraga Materia"
    set udg_ItemIdTable['e']='I03L' // 'I03L': item "Demi Materia"
    set udg_ItemIdTable['f']='I03M' // 'I03M': item "Demira Materia"
    set udg_ItemIdTable['g']='I03N' // 'I03N': item "Demiga Materia"
    set udg_ItemIdTable[$94]='I07N' // $94 = 148; 'I07N': item "Aero Materia"
    set udg_ItemIdTable[$95]='I07O' // $95 = 149; 'I07O': item "Aerora Materia"
    set udg_ItemIdTable[$96]='I07P' // $96 = 150; 'I07P': item "Aeroga Materia"
    set udg_ItemIdTable[$C2]='I0DT' // $C2 = 194; 'I0DT': item "Curse: Masamune"
    set udg_ItemIdTable[$C6]='I0E0' // $C6 = 198; 'I0E0': item "Curse: Fire Wand"
    set udg_ItemIdTable[$C7]='I0E1' // $C7 = 199; 'I0E1': item "Curse: Ice Wand"
    set udg_ItemIdTable[$C8]='I0E2' // $C8 = 200; 'I0E2': item "Curse: Thunder Wand"
    set udg_ItemIdTable[$D1]='I0E7' // $D1 = 209; 'I0E7': item "Curse: Magus Rod"
    set udg_ItemIdTable[$D3]='I0ED' // $D3 = 211; 'I0ED': item "Curse: Heady Pipe"
    set udg_ItemIdTable[$E0]='I0GE' // $E0 = 224; 'I0GE': item "Curse: Death Skull"
    set udg_ItemIdTable[$EF]='I07W' // $EF = 239; 'I07W': item "Curse: Zodiac Escutcheon"
    set udg_ItemIdTable[$EE]='I0ES' // $EE = 238; 'I0ES': item "Curse: Ultimate Weapon"
    set udg_ItemIdTable[269]='I0JV' // 'I0JV': item "Curse: Poison Wand"
    set udg_ItemIdTable[335]='I0BA' // 'I0BA': item "Curse: Death Skull X"
    set udg_ItemIdTable[$C]='I00D' // $C = 12; 'I00D': item "Champion's Belt"
    set udg_ItemIdTable[$D]='I00H' // $D = 13; 'I00H': item "Griever"
    set udg_ItemIdTable[$E]='I00B' // $E = 14; 'I00B': item "Touph Ring"
    set udg_ItemIdTable[17]='I00E' // 'I00E': item "Sprint Shoes"
    set udg_ItemIdTable[18]='I00J' // 'I00J': item "Chimes of Piercing"
    set udg_ItemIdTable[19]='I00G' // 'I00G': item "Armguard"
    set udg_ItemIdTable[20]='I00K' // 'I00K': item "Blue Amulet"
    set udg_ItemIdTable[21]='I00I' // 'I00I': item "Germinas Boots"
    set udg_ItemIdTable[22]='I00P' // 'I00P': item "Greater Totem of Power"
    set udg_ItemIdTable[23]='I00F' // 'I00F': item "Jade Collar"
    set udg_ItemIdTable[24]='I00C' // 'I00C': item "Blazer Gloves"
    set udg_ItemIdTable[25]='I00Q' // 'I00Q': item "Steel Gorget"
    set udg_ItemIdTable[26]='I00L' // 'I00L': item "Totem of Power"
    set udg_ItemIdTable[27]='I00R' // 'I00R': item "Cat's Bell"
    set udg_ItemIdTable[55]='I01X' // 'I01X': item "Heady Pipe"
    set udg_ItemIdTable[79]='I02W' // 'I02W': item "Necklace of the Sorcerer"
    set udg_ItemIdTable[87]='I031' // 'I031': item "Crusher's Belt"
    set udg_ItemIdTable[92]='I037' // 'I037': item "Magic Gloves"
    set udg_ItemIdTable[93]='I039' // 'I039': item "Death Skull"
    set udg_ItemIdTable[97]='I03I' // 'I03I': item "Growth Egg"
    set udg_ItemIdTable['v']='I04M' // 'I04M': item "Stalwart Belt"
    set udg_ItemIdTable['w']='I04L' // 'I04L': item "Necklace of the Necromancer"
    set udg_ItemIdTable[$7E]='I04D' // $7E = 126; 'I04D': item "Leather Gorget"
    set udg_ItemIdTable[$83]='I063' // $83 = 131; 'I063': item "Charming Banner"
    set udg_ItemIdTable[$98]='I08F' // $98 = 152; 'I08F': item "Iron Duke"
    set udg_ItemIdTable[$9D]='I0A7' // $9D = 157; 'I0A7': item "Hidden Hero Medicine"
    set udg_ItemIdTable[$A6]='I0CN' // $A6 = 166; 'I0CN': item "Summoner's Horn"
    set udg_ItemIdTable[$A7]='I0CO' // $A7 = 167; 'I0CO': item "Silver Glasses"
    set udg_ItemIdTable[$A8]='I0CP' // $A8 = 168; 'I0CP': item "Speed Bracers"
    set udg_ItemIdTable[$B4]='I0D0' // $B4 = 180; 'I0D0': item "Setzer's Coin"
    set udg_ItemIdTable[$BA]='I0DL' // $BA = 186; 'I0DL': item "Turtleshell Choker"
    set udg_ItemIdTable[$C1]='I0DR' // $C1 = 193; 'I0DR': item "Cameo Belt"
    set udg_ItemIdTable[$CD]='I0DS' // $CD = 205; 'I0DS': item "Memento Ring"
    set udg_ItemIdTable[$E1]='I0FD' // $E1 = 225; 'I0FD': item "Jackboots"
    set udg_ItemIdTable[95]='I0FW' // 'I0FW': item "Orb of Fire"
    set udg_ItemIdTable[$9E]='I0FX' // $9E = 158; 'I0FX': item "Orb of Frost"
    set udg_ItemIdTable[$9F]='I0FY' // $9F = 159; 'I0FY': item "Orb of Lightning"
    set udg_ItemIdTable[$A0]='I0FZ' // $A0 = 160; 'I0FZ': item "Orb of Water"
    set udg_ItemIdTable[$A1]='I0G0' // $A1 = 161; 'I0G0': item "Orb of Earth"
    set udg_ItemIdTable[$A2]='I0G1' // $A2 = 162; 'I0G1': item "Orb of Wind"
    set udg_ItemIdTable[94]='I0G6' // 'I0G6': item "Force of Nature"
    set udg_ItemIdTable[$EB]='I0GD' // $EB = 235; 'I0GD': item "Death Skull X"
    set udg_ItemIdTable[$EC]='I0GJ' // $EC = 236; 'I0GJ': item "Stopwatch"
    set udg_ItemIdTable[$FC]='I0HT' // $FC = 252; 'I0HT': item "Prominent Cloak"
    set udg_ItemIdTable[$B6]='I0IB' // $B6 = 182; 'I0IB': item "Hunter's Cloak"
    set udg_ItemIdTable['h']='I0EC' // 'I0EC': item "White Materia"
    set udg_ItemIdTable[271]='I0JX' // 'I0JX': item "Rabite's Foot"
    set udg_ItemIdTable[273]='I0K1' // 'I0K1': item "Bag of Tricks"
    set udg_ItemIdTable[275]='I0K2' // 'I0K2': item "Flag of Competition"
    set udg_ItemIdTable[276]='I0K3' // 'I0K3': item "Golden Skull"
    set udg_ItemIdTable[277]='I0K4' // 'I0K4': item "Crystal Skull"
    set udg_ItemIdTable[280]='I0KA' // 'I0KA': item "Firefly"
    set udg_ItemIdTable[281]='I0KC' // 'I0KC': item "Rosetta Stone"
    set udg_ItemIdTable[282]='I0KB' // 'I0KB': item "Hero's Badge"
    set udg_ItemIdTable[283]='I0KD' // 'I0KD': item "Ring of Rejuvenation"
    set udg_ItemIdTable[322]='I0A9' // 'I0A9': item "Blank Orb"
    set udg_ItemIdTable[334]='I04A' // 'I04A': item "Sleipnir"
    set udg_ItemIdTable[336]='I0B0' // 'I0B0': item "Genji Gloves"
    set udg_ItemIdTable[340]='I0C8' // 'I0C8': item "Orb of Cetra"
    set udg_ItemIdTable[351]='I0GF' // 'I0GF': item "Yatagarasu"
    set udg_ItemIdTable[$F]='I00N' // $F = 15; 'I00N': item "Kotetsu"
    set udg_ItemIdTable[16]='I00M' // 'I00M': item "Poison Spear"
    set udg_ItemIdTable[28]='I00S' // 'I00S': item "Ultimate Weapon"
    set udg_ItemIdTable[29]='I00U' // 'I00U': item "Long Sword"
    set udg_ItemIdTable[30]='I00V' // 'I00V': item "Mithril Sword"
    set udg_ItemIdTable[31]='I00W' // 'I00W': item "Ancient Sword"
    set udg_ItemIdTable[32]='I00Z' // 'I00Z': item "Rune Blade"
    set udg_ItemIdTable[33]='I010' // 'I010': item "Save the Queen"
    set udg_ItemIdTable[34]='I011' // 'I011': item "Excalibur"
    set udg_ItemIdTable[42]='I019' // 'I019': item "Masamune"
    set udg_ItemIdTable[43]='I01A' // 'I01A': item "Battle Axe"
    set udg_ItemIdTable[44]='I01B' // 'I01B': item "Mithril Axe"
    set udg_ItemIdTable[45]='I01C' // 'I01C': item "Giant Axe"
    set udg_ItemIdTable[46]='I01D' // 'I01D': item "Poison Wand"
    set udg_ItemIdTable[47]='I01E' // 'I01E': item "Fire Wand"
    set udg_ItemIdTable[48]='I01F' // 'I01F': item "Thunder Wand"
    set udg_ItemIdTable[49]='I01G' // 'I01G': item "Ice Wand"
    set udg_ItemIdTable[73]='I02C' // 'I02C': item "Dragon Wand"
    set udg_ItemIdTable[76]='I02P' // 'I02P': item "Dark Claw"
    set udg_ItemIdTable[77]='I02Q' // 'I02Q': item "Unholy Claw"
    set udg_ItemIdTable[80]='I02S' // 'I02S': item "Cursed Wand"
    set udg_ItemIdTable[84]='I02Y' // 'I02Y': item "Crusher's Mace"
    set udg_ItemIdTable[88]='I033' // 'I033': item "Trident"
    set udg_ItemIdTable[89]='I035' // 'I035': item "Platinum Dagger"
    set udg_ItemIdTable[90]='I036' // 'I036': item "Dark Bow"
    set udg_ItemIdTable[91]='I00O' // 'I00O': item "Fel Axe"
    set udg_ItemIdTable['x']='I04E' // 'I04E': item "Doom Mace"
    set udg_ItemIdTable['y']='I04F' // 'I04F': item "Shadow Bow"
    set udg_ItemIdTable['z']='I04G' // 'I04G': item "Death Claw"
    set udg_ItemIdTable['{']='I04H' // 'I04H': item "Ancient Axe"
    set udg_ItemIdTable['|']='I04I' // 'I04I': item "Demon Claw"
    set udg_ItemIdTable[$8E]='I066' // $8E = 142; 'I066': item "Lion Heart"
    set udg_ItemIdTable[$8F]='I07M' // $8F = 143; 'I07M': item "Excalibur II"
    set udg_ItemIdTable[$90]='I07Z' // $90 = 144; 'I07Z': item "Zodiac Spear"
    set udg_ItemIdTable[$91]='I080' // $91 = 145; 'I080': item "Artemis Bow"
    set udg_ItemIdTable[$92]='I081' // $92 = 146; 'I081': item "Tournesol"
    set udg_ItemIdTable[$97]='I08N' // $97 = 151; 'I08N': item "Nirvana"
    set udg_ItemIdTable[$AA]='I0CS' // $AA = 170; 'I0CS': item "Life Staff"
    set udg_ItemIdTable[$AB]='I0CT' // $AB = 171; 'I0CT': item "Main Gauche"
    set udg_ItemIdTable[$AC]='I0CU' // $AC = 172; 'I0CU': item "Assassin's Dagger"
    set udg_ItemIdTable[$B8]='I0DH' // $B8 = 184; 'I0DH': item "Strange Vision"
    set udg_ItemIdTable[$B9]='I0DG' // $B9 = 185; 'I0DG': item "Gladiator's Blade"
    set udg_ItemIdTable[$BD]='I0DM' // $BD = 189; 'I0DM': item "Masamune C"
    set udg_ItemIdTable[$C9]='I02F' // $C9 = 201; 'I02F': item "Fire Wand K"
    set udg_ItemIdTable[$CA]='I0DY' // $CA = 202; 'I0DY': item "Ice Wand U"
    set udg_ItemIdTable[$CB]='I0DZ' // $CB = 203; 'I0DZ': item "Thunder Wand J"
    set udg_ItemIdTable[$CF]='I0E6' // $CF = 207; 'I0E6': item "Magus Rod A"
    set udg_ItemIdTable[$D0]='I0E8' // $D0 = 208; 'I0E8': item "Magus Rod"
    set udg_ItemIdTable[$D4]='I0F2' // $D4 = 212; 'I0F2': item "Icebrand"
    set udg_ItemIdTable[$D5]='I0F3' // $D5 = 213; 'I0F3': item "Mjolnir"
    set udg_ItemIdTable[$D6]='I0F4' // $D6 = 214; 'I0F4': item "Longbow"
    set udg_ItemIdTable[$D7]='I0F5' // $D7 = 215; 'I0F5': item "Dagger"
    set udg_ItemIdTable[$D8]='I0F6' // $D8 = 216; 'I0F6': item "Wildfire Spear"
    set udg_ItemIdTable[$A3]='I0FO' // $A3 = 163; 'I0FO': item "Short Lance"
    set udg_ItemIdTable[$E2]='I0FP' // $E2 = 226; 'I0FP': item "Wirt's Leg"
    set udg_ItemIdTable[$E3]='I0EW' // $E3 = 227; 'I0EW': item "Demon Axe"
    set udg_ItemIdTable[$9A]='I0F7' // $9A = 154; 'I0F7': item "Muramasa"
    set udg_ItemIdTable[$E5]='I0GA' // $E5 = 229; 'I0GA': item "Final Wand"
    set udg_ItemIdTable[$E6]='I0F8' // $E6 = 230; 'I0F8': item "Ame-no-Murakumo"
    set udg_ItemIdTable[$E7]='I0EY' // $E7 = 231; 'I0EY': item "Fishing Pole"
    set udg_ItemIdTable[$E8]='I0EZ' // $E8 = 232; 'I0EZ': item "Muramata"
    set udg_ItemIdTable[$E9]='I0GB' // $E9 = 233; 'I0GB': item "Matamune"
    set udg_ItemIdTable[$EA]='I0GC' // $EA = 234; 'I0GC': item "Lu Shang"
    set udg_ItemIdTable[$F0]='I0H1' // $F0 = 240; 'I0H1': item "Mina"
    set udg_ItemIdTable[$FD]='I0HU' // $FD = 253; 'I0HU': item "Angbar"
    set udg_ItemIdTable[256]='I0ER' // 'I0ER': item "Caladbolg"
    set udg_ItemIdTable[266]='I0BW' // 'I0BW': item "Phantom Bow"
    set udg_ItemIdTable[$86]='I0C0' // $86 = 134; 'I0C0': item "Vega"
    set udg_ItemIdTable[$87]='I0C1' // $87 = 135; 'I0C1': item "Aldebaran"
    set udg_ItemIdTable[$88]='I0C2' // $88 = 136; 'I0C2': item "Arcturus"
    set udg_ItemIdTable[$89]='I0C3' // $89 = 137; 'I0C3': item "Formalhaut"
    set udg_ItemIdTable[$B5]='I0HW' // $B5 = 181; 'I0HW': item "Staff of Light"
    set udg_ItemIdTable['o']='I0EQ' // 'I0EQ': item "Deathbringer"
    set udg_ItemIdTable[268]='I0JU' // 'I0JU': item "Scourge Wand"
    set udg_ItemIdTable[270]='I0JW' // 'I0JW': item "Dark Staff"
    set udg_ItemIdTable[272]='I0JY' // 'I0JY': item "Heroic Lance"
    set udg_ItemIdTable[278]='I0K8' // 'I0K8': item "Buddha Fist"
    set udg_ItemIdTable[$E4]='I0G5' // $E4 = 228; 'I0G5': item "Masakados"
    set udg_ItemIdTable[288]='I0KW' // 'I0KW': item "Siphoning Staff"
    set udg_ItemIdTable[289]='I0L0' // 'I0L0': item "Aeon Scepter"
    set udg_ItemIdTable[294]='I0L6' // 'I0L6': item "Shimmering Spear"
    set udg_ItemIdTable[295]='I0L7' // 'I0L7': item "Shimmering Sword"
    set udg_ItemIdTable[296]='I0L8' // 'I0L8': item "Shimmering Axe"
    set udg_ItemIdTable[297]='I0L9' // 'I0L9': item "Shimmering Katana"
    set udg_ItemIdTable[298]='I0KX' // 'I0KX': item "Wand of the Wind"
    set udg_ItemIdTable[299]='I0KY' // 'I0KY': item "Serpent Rod"
    set udg_ItemIdTable[300]='I0KZ' // 'I0KZ': item "Gaya's Rod"
    set udg_ItemIdTable[316]='I0LQ' // 'I0LQ': item "Chunchunmaru"
    set udg_ItemIdTable[317]='I05S' // 'I05S': item "Holy Lance"
    set udg_ItemIdTable[318]='I05T' // 'I05T': item "Kiku-Ichimonji"
    set udg_ItemIdTable[319]='I061' // 'I061': item "Auto-Crossbow"
    set udg_ItemIdTable[320]='I060' // 'I060': item "Halberd of Justice"
    set udg_ItemIdTable[327]='I0BH' // 'I0BH': item "Knuckles"
    set udg_ItemIdTable[328]='I0BI' // 'I0BI': item "Pickaxe"
    set udg_ItemIdTable[329]='I0BJ' // 'I0BJ': item "Miner's Pickaxe"
    set udg_ItemIdTable[333]='I0BM' // 'I0BM': item "Gravity Staff"
    set udg_ItemIdTable[337]='I0C5' // 'I0C5': item "Rock Punch"
    set udg_ItemIdTable[338]='I0C6' // 'I0C6': item "Edgar's Drill"
    set udg_ItemIdTable[339]='I0C7' // 'I0C7': item "Ryuujin no Ken"
    set udg_ItemIdTable[341]='I0C9' // 'I0C9': item "Beast Claw"
    set udg_ItemIdTable[342]='I0BP' // 'I0BP': item "Executioner Sword"
    set udg_ItemIdTable[343]='I0LP' // 'I0LP': item "True Ice Axe"
    set udg_ItemIdTable[344]='I03D' // 'I03D': item "Gladius"
    set udg_ItemIdTable[345]='I03O' // 'I03O': item "Wyrmhero Blade"
    set udg_ItemIdTable[347]='I0BT' // 'I0BT': item "Brotherhood"
    set udg_ItemIdTable[348]='I0D1' // 'I0D1': item "Storm Lance"
    set udg_ItemIdTable[302]='I0LL' // 'I0LL': item "Celestium"
    set udg_ItemIdTable[321]='I0A8' // 'I0A8': item "Celestial Psypher"
    set udg_ItemIdTable[303]='I0LJ' // 'I0LJ': item "Chainsaw"
    set udg_ItemIdTable[304]='I0LE' // 'I0LE': item "Durandal"
    set udg_ItemIdTable[305]='I0LA' // 'I0LA': item "Sagittarius"
    set udg_ItemIdTable[306]='I0LH' // 'I0LH': item "Exeter"
    set udg_ItemIdTable[307]='I0LC' // 'I0LC': item "Ehrgeiz"
    set udg_ItemIdTable[308]='I0LG' // 'I0LG': item "Zwill Crossblade"
    set udg_ItemIdTable[309]='I0LD' // 'I0LD': item "Scorpio"
    set udg_ItemIdTable[310]='I0LI' // 'I0LI': item "Zanmatou"
    set udg_ItemIdTable[311]='I0LB' // 'I0LB': item "Longinus"
    set udg_ItemIdTable[312]='I0LF' // 'I0LF': item "Ragnarok"
    set udg_ItemIdTable[35]='I012' // 'I012': item "Round Shield"
    set udg_ItemIdTable[36]='I013' // 'I013': item "Iron Shield"
    set udg_ItemIdTable[37]='I014' // 'I014': item "Mithril Shield"
    set udg_ItemIdTable[38]='I015' // 'I015': item "Aegis Shield"
    set udg_ItemIdTable[39]='I016' // 'I016': item "Platinum Shield"
    set udg_ItemIdTable[40]='I017' // 'I017': item "Enchanted Shield"
    set udg_ItemIdTable[41]='I018' // 'I018': item "Absorber"
    set udg_ItemIdTable[81]='I02T' // 'I02T': item "Unholy Shield"
    set udg_ItemIdTable['}']='I04J' // 'I04J': item "Reflect Shield"
    set udg_ItemIdTable[$84]='I064' // $84 = 132; 'I064': item "Zodiac Escutcheon"
    set udg_ItemIdTable[$85]='I065' // $85 = 133; 'I065': item "Ensanguined Shield"
    set udg_ItemIdTable[$A5]='I0BU' // $A5 = 165; 'I0BU': item "Genji Shield"
    set udg_ItemIdTable[$CC]='I0E3' // $CC = 204; 'I0E3': item "Interceptor Guard"
    set udg_ItemIdTable[$DA]='I0FA' // $DA = 218; 'I0FA': item "Flame Shield"
    set udg_ItemIdTable[$DB]='I03A' // $DB = 219; 'I03A': item "Frost Shield"
    set udg_ItemIdTable[$F1]='I0HN' // $F1 = 241; 'I0HN': item "Onion Arrows"
    set udg_ItemIdTable[$F2]='I0HP' // $F2 = 242; 'I0HP': item "Icecloud Arrows"
    set udg_ItemIdTable[$F3]='I0HQ' // $F3 = 243; 'I0HQ': item "Shock Arrows"
    set udg_ItemIdTable[$F4]='I0HR' // $F4 = 244; 'I0HR': item "Tempest Arrows"
    set udg_ItemIdTable[$F5]='I0HO' // $F5 = 245; 'I0HO': item "Killer Arrows"
    set udg_ItemIdTable[$F6]='I0HH' // $F6 = 246; 'I0HH': item "Onion Shot"
    set udg_ItemIdTable[$F7]='I0HI' // $F7 = 247; 'I0HI': item "Piercing Shot"
    set udg_ItemIdTable[$F8]='I0HK' // $F8 = 248; 'I0HK': item "Rock Shot"
    set udg_ItemIdTable[$F9]='I0HJ' // $F9 = 249; 'I0HJ': item "Scattershot"
    set udg_ItemIdTable[$FA]='I0HL' // $FA = 250; 'I0HL': item "Molotov Shot"
    set udg_ItemIdTable[$FB]='I0HM' // $FB = 251; 'I0HM': item "Bubble Shot"
    set udg_ItemIdTable[$FE]='I0I8' // $FE = 254; 'I0I8': item "Tome of Agility"
    set udg_ItemIdTable[$FF]='I0I5' // $FF = 255; 'I0I5': item "Tome of Crippling"
    set udg_ItemIdTable[257]='I0I2' // 'I0I2': item "Tome of Strength"
    set udg_ItemIdTable[258]='I0I6' // 'I0I6': item "Tome of the Breaker"
    set udg_ItemIdTable[259]='I0I1' // 'I0I1': item "Tome of Banishment"
    set udg_ItemIdTable[260]='I0I4' // 'I0I4': item "Tome of Heresy"
    set udg_ItemIdTable[261]='I0HX' // 'I0HX': item "Tome of Life"
    set udg_ItemIdTable[262]='I0I7' // 'I0I7': item "Tome of Phantasm"
    set udg_ItemIdTable[263]='I0HZ' // 'I0HZ': item "Tome of Time"
    set udg_ItemIdTable[264]='I0I3' // 'I0I3': item "Holy Book of Galbados"
    set udg_ItemIdTable[265]='I0HY' // 'I0HY': item "Tome of the Tortoise"
    set udg_ItemIdTable[274]='I0H0' // 'I0H0': item "Paladin Shield"
    set udg_ItemIdTable[301]='I0LK' // 'I0LK': item "Artemis Arrows"
    set udg_ItemIdTable[313]='I0LN' // 'I0LN': item "Shimmering Shield"
    set udg_ItemIdTable[323]='I0B8' // 'I0B8': item "Pulsar Shot"
    set udg_ItemIdTable[$BE]='I05U' // $BE = 190; 'I05U': item "Book of Flames"
    set udg_ItemIdTable[$BF]='I05V' // $BF = 191; 'I05V': item "Book of Glaciers"
    set udg_ItemIdTable[$C0]='I05W' // $C0 = 192; 'I05W': item "Book of Storms"
    set udg_ItemIdTable[324]='I05X' // 'I05X': item "Book of Depths"
    set udg_ItemIdTable[325]='I05Y' // 'I05Y': item "Book of Tremors"
    set udg_ItemIdTable[326]='I05Z' // 'I05Z': item "Book of Winds"
    set udg_ItemIdTable[332]='I0BC' // 'I0BC': item "Canister Shot"
    set udg_ItemIdTable[331]='I0BF' // 'I0BF': item "Slither Shield"
    set udg_ItemIdTable[346]='I086' // 'I086': item "Akashic Records"
    set udg_ItemIdTable[350]='I0FK' // 'I0FK': item "Invert Shield"
    set udg_ItemIdTable[50]='I01H' // 'I01H': item "Iron Helmet"
    set udg_ItemIdTable[51]='I01I' // 'I01I': item "Mithril Helmet"
    set udg_ItemIdTable[52]='I01J' // 'I01J': item "Diamond Helmet"
    set udg_ItemIdTable[53]='I01K' // 'I01K': item "Platinum Helmet"
    set udg_ItemIdTable[72]='I026' // 'I026': item "Helm of the Magi"
    set udg_ItemIdTable[54]='I01L' // 'I01L': item "Grand Helmet"
    set udg_ItemIdTable[75]='I02R' // 'I02R': item "Headgear of the Damned"
    set udg_ItemIdTable[82]='I02U' // 'I02U': item "Helm of the Necromancer"
    set udg_ItemIdTable[85]='I02Z' // 'I02Z': item "Barbarian's Helmet"
    set udg_ItemIdTable[$81]='I04C' // $81 = 129; 'I04C': item "Berserker's Helmet"
    set udg_ItemIdTable[$8A]='I06A' // $8A = 138; 'I06A': item "Zodiac Helmet"
    set udg_ItemIdTable[$8B]='I069' // $8B = 139; 'I069': item "Circlet"
    set udg_ItemIdTable[$A4]='I0AA' // $A4 = 164; 'I0AA': item "Genji Mask"
    set udg_ItemIdTable[$B7]='I0D4' // $B7 = 183; 'I0D4': item "Helm of Divine Judgement"
    set udg_ItemIdTable[$DC]='I0FB' // $DC = 220; 'I0FB': item "Serpent Helmet"
    set udg_ItemIdTable[$DD]='I0FC' // $DD = 221; 'I0FC': item "Enchanted Helmet"
    set udg_ItemIdTable[290]='I0L4' // 'I0L4': item "Glimmering Hat"
    set udg_ItemIdTable[291]='I0L1' // 'I0L1': item "Ice Hat"
    set udg_ItemIdTable[292]='I0L2' // 'I0L2': item "Green Hat"
    set udg_ItemIdTable[293]='I0L3' // 'I0L3': item "Earth Hat"
    set udg_ItemIdTable[315]='I0LO' // 'I0LO': item "Shimmering Helmet"
    set udg_ItemIdTable[56]='I01M' // 'I01M': item "Studded Leather Armor"
    set udg_ItemIdTable[57]='I01N' // 'I01N': item "Reinforced Leather Armor"
    set udg_ItemIdTable[58]='I01O' // 'I01O': item "Storm Wyrm Hide Armor"
    set udg_ItemIdTable[59]='I01P' // 'I01P': item "Grandmasterwork Leather"
    set udg_ItemIdTable[60]='I01Q' // 'I01Q': item "Elven Mail"
    set udg_ItemIdTable[61]='I01R' // 'I01R': item "Mithril Mail"
    set udg_ItemIdTable[62]='I01S' // 'I01S': item "Shimmering Mail"
    set udg_ItemIdTable[63]='I01T' // 'I01T': item "Platinum Mail"
    set udg_ItemIdTable[64]='I01U' // 'I01U': item "Wizard's Robe"
    set udg_ItemIdTable[65]='I01V' // 'I01V': item "Magician's Robe"
    set udg_ItemIdTable[66]='I01W' // 'I01W': item "Sorcerer's Robe"
    set udg_ItemIdTable[67]='I01Y' // 'I01Y': item "Genji Armor"
    set udg_ItemIdTable[86]='I030' // 'I030': item "Fur Armor"
    set udg_ItemIdTable[$82]='I05G' // $82 = 130; 'I05G': item "Gaia Gear"
    set udg_ItemIdTable[$8C]='I07X' // $8C = 140; 'I07X': item "Robe of Lords"
    set udg_ItemIdTable[$9B]='I0A6' // $9B = 155; 'I0A6': item "Adamant Armor"
    set udg_ItemIdTable[$CE]='I0E5' // $CE = 206; 'I0E5': item "Maximillian"
    set udg_ItemIdTable[$D9]='I0F9' // $D9 = 217; 'I0F9': item "Windbreaker"
    set udg_ItemIdTable[$ED]='I0GZ' // $ED = 237; 'I0GZ': item "Nebra Suit"
    set udg_ItemIdTable[267]='I0BX' // 'I0BX': item "Grand Armor"
    set udg_ItemIdTable[279]='I0K9' // 'I0K9': item "Vishnu Vest"
    set udg_ItemIdTable[284]='I0KQ' // 'I0KQ': item "Glimmering Robe"
    set udg_ItemIdTable[285]='I0KS' // 'I0KS': item "Light Robe"
    set udg_ItemIdTable[286]='I0KR' // 'I0KR': item "Red Robe"
    set udg_ItemIdTable[287]='I0KT' // 'I0KT': item "Azure Robe"
    set udg_ItemIdTable[314]='I0LM' // 'I0LM': item "Shimmering Cloth"
    set udg_ItemIdTable[330]='I0BG' // 'I0BG': item "Mirage Vest"
    set udg_ItemIdTable[349]='I0D2' // 'I0D2': item "White Robe"
    set udg_ItemIdTable[$8D]='I062' // $8D = 141; 'I062': item "Aire Tam Enib Moc"
    set udg_ItemIdTable[$9C]='I084' // $9C = 156; 'I084': item "Adamantite"
    set udg_ItemIdTable[$AD]='I0CX' // $AD = 173; 'I0CX': item "Magic God Token"
    set udg_ItemIdTable[$AE]='I08A' // $AE = 174; 'I08A': item "Empyreal Soul"
    set udg_ItemIdTable[$AF]='I0B7' // $AF = 175; 'I0B7': item "Grand Crystal"
    set udg_ItemIdTable[$B0]='I06P' // $B0 = 176; 'I06P': item "Scarletite"
    set udg_ItemIdTable[$B1]='I08B' // $B1 = 177; 'I08B': item "Serpent Gem"
    set udg_ItemIdTable[$B2]='I089' // $B2 = 178; 'I089': item "Soul Powder"
    set udg_ItemIdTable[$B3]='I07C' // $B3 = 179; 'I07C': item "Nethril"
    call TriggerExecute(gg_trg_Armory_Item_Hash)
endfunction

function Trig_Armory_Item_Hash_Actions takes nothing returns nothing
    local integer i=1
    set udg_ItemSaveID=InitHashtable()
    loop
        call SaveInteger(udg_ItemSaveID,0,udg_ItemIdTable[i],i)
        set i=i+1
        exitwhen i>udg_SaveFlagCount
    endloop
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Armory_Init_Actions takes nothing returns nothing
    set udg_ArmoryStockMax=540
    set bj_forLoopAIndex=501
    set bj_forLoopAIndexEnd=udg_ArmoryStockMax
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_SaveFlagForce[GetForLoopIndexA()]=udg_PlayingPlayers
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_SaveFlagForce[507]=CreateForce()
    set udg_SaveFlagUnitID[501]='n0JG' // 'n0JG': unit "Gear: Physical Weapons"
    set udg_SaveFlagUnitID[502]='n0JH' // 'n0JH': unit "Gear: Magical Weapons"
    set udg_SaveFlagUnitID[503]='n0JI' // 'n0JI': unit "Gear: Offhand"
    set udg_SaveFlagUnitID[504]='n0JJ' // 'n0JJ': unit "Gear: Helmets"
    set udg_SaveFlagUnitID[505]='n0JK' // 'n0JK': unit "Gear: Armor"
    set udg_SaveFlagUnitID[506]='n0JL' // 'n0JL': unit "Gear: Accessories"
    set udg_SaveFlagUnitID[507]='n0LB' // 'n0LB': unit "Gear: Celestial Weapons"
    set udg_SaveFlagUnitID[511]='n0J3' // 'n0J3': unit "Weapon: Tools"
    set udg_SaveFlagUnitID[512]='n0J4' // 'n0J4': unit "Weapon: Sword"
    set udg_SaveFlagUnitID[513]='n0J5' // 'n0J5': unit "Weapon: Bow"
    set udg_SaveFlagUnitID[514]='n0JC' // 'n0JC': unit "Weapon: Gun"
    set udg_SaveFlagUnitID[515]='n0J6' // 'n0J6': unit "Weapon: Barehanded"
    set udg_SaveFlagUnitID[516]='n0J7' // 'n0J7': unit "Weapon: Dagger"
    set udg_SaveFlagUnitID[517]='n0J8' // 'n0J8': unit "Weapon: Spear"
    set udg_SaveFlagUnitID[518]='n0J9' // 'n0J9': unit "Weapon: Axe"
    set udg_SaveFlagUnitID[519]='n0JA' // 'n0JA': unit "Weapon: Katana"
    set udg_SaveFlagUnitID[520]='n0JB' // 'n0JB': unit "Weapon: Greatsword"
    set udg_SaveFlagUnitID[521]='n0JD' // 'n0JD': unit "Weapon: Rod"
    set udg_SaveFlagUnitID[522]='n0JE' // 'n0JE': unit "Weapon: Staff"
    set udg_SaveFlagUnitID[523]='n0JF' // 'n0JF': unit "Weapon: Inner Mana"
    set udg_SaveFlagUnitID[524]='n0IZ' // 'n0IZ': unit "Offhand: Physical Shield"
    set udg_SaveFlagUnitID[525]='n0J0' // 'n0J0': unit "Offhand: Magical Shield"
    set udg_SaveFlagUnitID[526]='n0J1' // 'n0J1': unit "Offhand: Buff Tomes"
    set udg_SaveFlagUnitID[527]='n0J2' // 'n0J2': unit "Offhand: Arrows"
    set udg_SaveFlagUnitID[528]='n0IX' // 'n0IX': unit "Helmet: Physical"
    set udg_SaveFlagUnitID[529]='n0IY' // 'n0IY': unit "Helmet: Magical"
    set udg_SaveFlagUnitID[530]='n0IU' // 'n0IU': unit "Armor: Leather"
    set udg_SaveFlagUnitID[531]='n0IV' // 'n0IV': unit "Armor: Plate"
    set udg_SaveFlagUnitID[532]='n0IW' // 'n0IW': unit "Armor: Mystic"
    set udg_SaveFlagUnitID[533]='n0IP' // 'n0IP': unit "Accessories: Simple"
    set udg_SaveFlagUnitID[534]='n0IQ' // 'n0IQ': unit "Accessories: Stats"
    set udg_SaveFlagUnitID[535]='n0IS' // 'n0IS': unit "Accessories: Elemental"
    set udg_SaveFlagUnitID[536]='n0IR' // 'n0IR': unit "Accessories: Special"
    set udg_SaveFlagUnitID[537]='n0IT' // 'n0IT': unit "Accessories: Ultimate"
    set udg_SaveFlagUnitID[538]='n0JN' // 'n0JN': unit "Offhand: Shot"
    set udg_SaveFlagUnitID[539]='n0JV' // 'n0JV': unit "Accessories: Grinder"
    set udg_SaveFlagUnitID[540]='n0M5' // 'n0M5': unit "Offhand: Elemental Books"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$A // $A = 10
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArmoryParentCategory[GetForLoopIndexA()]=0
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=$B // $B = 11
    set bj_forLoopAIndexEnd=20
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArmoryParentCategory[GetForLoopIndexA()]=1
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=21
    set bj_forLoopAIndexEnd=23
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArmoryParentCategory[GetForLoopIndexA()]=2
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=24
    set bj_forLoopAIndexEnd=27
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArmoryParentCategory[GetForLoopIndexA()]=3
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_ArmoryParentCategory[28]=4
    set udg_ArmoryParentCategory[29]=4
    set bj_forLoopAIndex=30
    set bj_forLoopAIndexEnd=32
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArmoryParentCategory[GetForLoopIndexA()]=5
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=33
    set bj_forLoopAIndexEnd=37
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_ArmoryParentCategory[GetForLoopIndexA()]=6
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_ArmoryParentCategory[38]=3
    set udg_ArmoryParentCategory[39]=6
    set udg_ArmoryParentCategory[40]=3
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce['i'])
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce['j'])
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$93]) // $93 = 147
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$99]) // $99 = 153
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$A9]) // $A9 = 169
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$AF]) // $AF = 175
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$BC]) // $BC = 188
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$D2]) // $D2 = 210
    set udg_SaveFlagUnitID[$C]='n0D8' // $C = 12; 'n0D8': unit "Champion's Belt"
    set udg_SaveFlagUnitID[$D]='n0D9' // $D = 13; 'n0D9': unit "Griever"
    set udg_SaveFlagUnitID[$E]='n0DA' // $E = 14; 'n0DA': unit "Touph Ring"
    set udg_SaveFlagUnitID[17]='n0DB' // 'n0DB': unit "Sprint Shoes"
    set udg_SaveFlagUnitID[18]='n0DC' // 'n0DC': unit "Chimes of Piercing"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[18])
    set udg_SaveFlagUnitID[19]='n0DD' // 'n0DD': unit "Armguard"
    set udg_SaveFlagUnitID[20]='n0DE' // 'n0DE': unit "Blue Amulet"
    set udg_SaveFlagUnitID[21]='n0DF' // 'n0DF': unit "Germinas Boots"
    set udg_SaveFlagUnitID[22]='n0DG' // 'n0DG': unit "Greater Totem of Power"
    set udg_SaveFlagUnitID[23]='n0DH' // 'n0DH': unit "Jade Collar"
    set udg_SaveFlagUnitID[24]='n0DI' // 'n0DI': unit "Blazer Gloves"
    set udg_SaveFlagUnitID[25]='n0DJ' // 'n0DJ': unit "Steel Gorget"
    set udg_SaveFlagUnitID[26]='n0DK' // 'n0DK': unit "Totem of Power"
    set udg_SaveFlagUnitID[27]='n0DL' // 'n0DL': unit "Cat's Bell"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[27])
    set udg_SaveFlagUnitID[55]='n0DM' // 'n0DM': unit "Heady Pipe"
    set udg_SaveFlagUnitID[79]='n0DN' // 'n0DN': unit "Necklace of the Sorcerer"
    set udg_SaveFlagUnitID[87]='n0DO' // 'n0DO': unit "Crusher's Belt"
    set udg_SaveFlagUnitID[92]='n0DP' // 'n0DP': unit "Magic Gloves"
    set udg_SaveFlagUnitID[93]='n0DQ' // 'n0DQ': unit "Death Skull"
    set udg_SaveFlagUnitID[97]='n0DR' // 'n0DR': unit "Growth Egg"
    set udg_SaveFlagUnitID['v']='n0DS' // 'n0DS': unit "Stalwart Belt"
    set udg_SaveFlagUnitID['w']='n0DT' // 'n0DT': unit "Necklace of the Necromancer"
    set udg_SaveFlagUnitID[$7E]='n0DU' // $7E = 126; 'n0DU': unit "Leather Gorget"
    set udg_SaveFlagUnitID[$83]='n0DV' // $83 = 131; 'n0DV': unit "Charming Banner"
    set udg_SaveFlagUnitID[$98]='n0DW' // $98 = 152; 'n0DW': unit "Iron Duke"
    set udg_SaveFlagUnitID[$9D]='n0DX' // $9D = 157; 'n0DX': unit "Hidden Hero Medicine"
    set udg_SaveFlagUnitID[$A6]='n0DY' // $A6 = 166; 'n0DY': unit "Summoner's Horn"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$A6]) // $A6 = 166
    set udg_SaveFlagUnitID[$A7]='n0DZ' // $A7 = 167; 'n0DZ': unit "Silver Glasses"
    set udg_SaveFlagUnitID[$A8]='n0E0' // $A8 = 168; 'n0E0': unit "Speed Bracers"
    set udg_SaveFlagUnitID[$B4]='n0E1' // $B4 = 180; 'n0E1': unit "Setzer's Coin"
    set udg_SaveFlagUnitID[$BA]='n0E2' // $BA = 186; 'n0E2': unit "Turtleshell Choker"
    set udg_SaveFlagUnitID[$C1]='n0E3' // $C1 = 193; 'n0E3': unit "Cameo Belt"
    set udg_SaveFlagUnitID[$CD]='n0E4' // $CD = 205; 'n0E4': unit "Memento Ring"
    set udg_SaveFlagUnitID[$E1]='n0E5' // $E1 = 225; 'n0E5': unit "Jackboots"
    set udg_SaveFlagUnitID[95]='n0E6' // 'n0E6': unit "Orb of Fire"
    set udg_SaveFlagUnitID[$9E]='n0E7' // $9E = 158; 'n0E7': unit "Orb of Frost"
    set udg_SaveFlagUnitID[$9F]='n0E8' // $9F = 159; 'n0E8': unit "Orb of Lightning"
    set udg_SaveFlagUnitID[$A0]='n0E9' // $A0 = 160; 'n0E9': unit "Orb of Water"
    set udg_SaveFlagUnitID[$A1]='n0EA' // $A1 = 161; 'n0EA': unit "Orb of Earth"
    set udg_SaveFlagUnitID[$A2]='n0EB' // $A2 = 162; 'n0EB': unit "Orb of Wind"
    set udg_SaveFlagUnitID[94]='n0EC' // 'n0EC': unit "Force of Nature"
    set udg_SaveFlagUnitID[$EB]='n0EE' // $EB = 235; 'n0EE': unit "Death Skull X"
    set udg_SaveFlagUnitID[$EC]='n0EF' // $EC = 236; 'n0EF': unit "Stopwatch"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$EC]) // $EC = 236
    set udg_SaveFlagUnitID[$FC]='n0EG' // $FC = 252; 'n0EG': unit "Prominent Cloak"
    set udg_SaveFlagUnitID[$B6]='n0EH' // $B6 = 182; 'n0EH': unit "Hunter's Cloak"
    set udg_SaveFlagUnitID['h']='n0EI' // 'n0EI': unit "White Materia"
    set udg_SaveFlagUnitID[271]='n0JQ' // 'n0JQ': unit "Rabite's Foot"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[271])
    set udg_SaveFlagUnitID[273]='n0JT' // 'n0JT': unit "Bag of Tricks"
    set udg_SaveFlagUnitID[275]='n0JW' // 'n0JW': unit "Flag of Competition"
    set udg_SaveFlagUnitID[276]='n0JX' // 'n0JX': unit "Golden Skull"
    set udg_SaveFlagUnitID[277]='n0JY' // 'n0JY': unit "Crystal Skull"
    set udg_SaveFlagUnitID[280]='n0K4' // 'n0K4': unit "Firefly"
    set udg_SaveFlagUnitID[281]='n0K6' // 'n0K6': unit "Rosetta Stone"
    set udg_SaveFlagUnitID[282]='n0K5' // 'n0K5': unit "Hero's Badge"
    set udg_SaveFlagUnitID[283]='n0KC' // 'n0KC': unit "Ring of Rejuvenation"
    set udg_SaveFlagUnitID[322]='n0M0' // 'n0M0': unit "Blank Orb"
    set udg_SaveFlagUnitID[334]='n0MR' // 'n0MR': unit "Sleipnir"
    set udg_SaveFlagUnitID[336]='n0MS' // 'n0MS': unit "Genji Gloves"
    set udg_SaveFlagUnitID[340]='n0MX' // 'n0MX': unit "Orb of Cetra"
    set udg_SaveFlagUnitID[351]='n0ND' // 'n0ND': unit "Yatagarasu"
    set udg_SaveFlagUnitID[$F]='n0GN' // $F = 15; 'n0GN': unit "Kotetsu"
    set udg_SaveFlagUnitID[16]='n0GO' // 'n0GO': unit "Poison Spear"
    set udg_SaveFlagUnitID[28]='n0GP' // 'n0GP': unit "Ultimate Weapon"
    set udg_SaveFlagUnitID[29]='n0GQ' // 'n0GQ': unit "Long Sword"
    set udg_SaveFlagUnitID[30]='n0GR' // 'n0GR': unit "Mithril Sword"
    set udg_SaveFlagUnitID[31]='n0GS' // 'n0GS': unit "Ancient Sword"
    set udg_SaveFlagUnitID[32]='n0GT' // 'n0GT': unit "Rune Blade"
    set udg_SaveFlagUnitID[33]='n0GU' // 'n0GU': unit "Save the Queen"
    set udg_SaveFlagUnitID[34]='n0GV' // 'n0GV': unit "Excalibur"
    set udg_SaveFlagUnitID[42]='n0GW' // 'n0GW': unit "Masamune"
    set udg_SaveFlagUnitID[43]='n0H0' // 'n0H0': unit "Battle Axe"
    set udg_SaveFlagUnitID[44]='n0H1' // 'n0H1': unit "Mithril Axe"
    set udg_SaveFlagUnitID[45]='n0H2' // 'n0H2': unit "Giant Axe"
    set udg_SaveFlagUnitID[46]='n0H3' // 'n0H3': unit "Poison Wand"
    set udg_SaveFlagUnitID[47]='n0H4' // 'n0H4': unit "Fire Wand"
    set udg_SaveFlagUnitID[48]='n0H5' // 'n0H5': unit "Thunder Wand"
    set udg_SaveFlagUnitID[49]='n0H6' // 'n0H6': unit "Ice Wand"
    set udg_SaveFlagUnitID[73]='n0H7' // 'n0H7': unit "Dragon Wand"
    set udg_SaveFlagUnitID[76]='n0H8' // 'n0H8': unit "Dark Claw"
    set udg_SaveFlagUnitID[77]='n0H9' // 'n0H9': unit "Unholy Claw"
    set udg_SaveFlagUnitID[80]='n0HA' // 'n0HA': unit "Cursed Wand"
    set udg_SaveFlagUnitID[84]='n0HB' // 'n0HB': unit "Crusher's Mace"
    set udg_SaveFlagUnitID[88]='n0HC' // 'n0HC': unit "Trident"
    set udg_SaveFlagUnitID[89]='n0HD' // 'n0HD': unit "Platinum Dagger"
    set udg_SaveFlagUnitID[90]='n0HE' // 'n0HE': unit "Dark Bow"
    set udg_SaveFlagUnitID[91]='n0HF' // 'n0HF': unit "Fel Axe"
    set udg_SaveFlagUnitID['x']='n0HG' // 'n0HG': unit "Doom Mace"
    set udg_SaveFlagUnitID['y']='n0HH' // 'n0HH': unit "Shadow Bow"
    set udg_SaveFlagUnitID['z']='n0HI' // 'n0HI': unit "Death Claw"
    set udg_SaveFlagUnitID['{']='n0HJ' // 'n0HJ': unit "Ancient Axe"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce['{'])
    set udg_SaveFlagUnitID['|']='n0HK' // 'n0HK': unit "Demon Claw"
    set udg_SaveFlagUnitID[$8E]='n0HL' // $8E = 142; 'n0HL': unit "Lion Heart"
    set udg_SaveFlagUnitID[$8F]='n0GZ' // $8F = 143; 'n0GZ': unit "Excalibur II"
    set udg_SaveFlagUnitID[$90]='n0HM' // $90 = 144; 'n0HM': unit "Zodiac Spear"
    set udg_SaveFlagUnitID[$91]='n0HN' // $91 = 145; 'n0HN': unit "Artemis Bow"
    set udg_SaveFlagUnitID[$92]='n0HO' // $92 = 146; 'n0HO': unit "Tournesol"
    set udg_SaveFlagUnitID[$97]='n0HP' // $97 = 151; 'n0HP': unit "Nirvana"
    set udg_SaveFlagUnitID[$AA]='n0HQ' // $AA = 170; 'n0HQ': unit "Life Staff"
    set udg_SaveFlagUnitID[$AB]='n0HR' // $AB = 171; 'n0HR': unit "Main Gauche"
    set udg_SaveFlagUnitID[$AC]='n0HS' // $AC = 172; 'n0HS': unit "Assassin's Dagger"
    set udg_SaveFlagUnitID[$B8]='n0HU' // $B8 = 184; 'n0HU': unit "Strange Vision"
    set udg_SaveFlagUnitID[$B9]='n0HV' // $B9 = 185; 'n0HV': unit "Gladiator's Blade"
    set udg_SaveFlagUnitID[$BD]='n0GX' // $BD = 189; 'n0GX': unit "Masamune C"
    set udg_SaveFlagUnitID[$C9]='n0HW' // $C9 = 201; 'n0HW': unit "Fire Wand K"
    set udg_SaveFlagUnitID[$CA]='n0HX' // $CA = 202; 'n0HX': unit "Ice Wand U"
    set udg_SaveFlagUnitID[$CB]='n0HY' // $CB = 203; 'n0HY': unit "Thunder Wand J"
    set udg_SaveFlagUnitID[$CF]='n0HZ' // $CF = 207; 'n0HZ': unit "Magus Rod A"
    set udg_SaveFlagUnitID[$D0]='n0I0' // $D0 = 208; 'n0I0': unit "Magus Rod"
    set udg_SaveFlagUnitID[$D4]='n0I1' // $D4 = 212; 'n0I1': unit "Icebrand"
    set udg_SaveFlagUnitID[$D5]='n0I2' // $D5 = 213; 'n0I2': unit "Mjolnir"
    set udg_SaveFlagUnitID[$D6]='n0I3' // $D6 = 214; 'n0I3': unit "Longbow"
    set udg_SaveFlagUnitID[$D7]='n0I4' // $D7 = 215; 'n0I4': unit "Dagger"
    set udg_SaveFlagUnitID[$D8]='n0I5' // $D8 = 216; 'n0I5': unit "Wildfire Spear"
    set udg_SaveFlagUnitID[$A3]='n0I6' // $A3 = 163; 'n0I6': unit "Short Lance"
    set udg_SaveFlagUnitID[$E2]='n0I7' // $E2 = 226; 'n0I7': unit "Wirt's Leg"
    set udg_SaveFlagUnitID[$E3]='n0I8' // $E3 = 227; 'n0I8': unit "Demon Axe"
    set udg_SaveFlagUnitID[$9A]='n0GY' // $9A = 154; 'n0GY': unit "Muramasa"
    set udg_SaveFlagUnitID[$E5]='n0I9' // $E5 = 229; 'n0I9': unit "Final Wand"
    set udg_SaveFlagUnitID[$E6]='n0IA' // $E6 = 230; 'n0IA': unit "Ame-no-Murakumo"
    set udg_SaveFlagUnitID[$E7]='n0IB' // $E7 = 231; 'n0IB': unit "Fishing Pole"
    set udg_SaveFlagUnitID[$E8]='n0IC' // $E8 = 232; 'n0IC': unit "Muramata"
    set udg_SaveFlagUnitID[$E9]='n0ID' // $E9 = 233; 'n0ID': unit "Matamune"
    set udg_SaveFlagUnitID[$EA]='n0IE' // $EA = 234; 'n0IE': unit "Lu Shang"
    set udg_SaveFlagUnitID[$F0]='n0HT' // $F0 = 240; 'n0HT': unit "Mina"
    set udg_SaveFlagUnitID[$FD]='n0IF' // $FD = 253; 'n0IF': unit "Angbar"
    set udg_SaveFlagUnitID[256]='n0IG' // 'n0IG': unit "Caladbolg"
    set udg_SaveFlagUnitID[266]='n0IH' // 'n0IH': unit "Phantom Bow"
    set udg_SaveFlagUnitID[$86]='n0II' // $86 = 134; 'n0II': unit "Vega"
    set udg_SaveFlagUnitID[$87]='n0IJ' // $87 = 135; 'n0IJ': unit "Aldebaran"
    set udg_SaveFlagUnitID[$88]='n0IK' // $88 = 136; 'n0IK': unit "Arcturus"
    set udg_SaveFlagUnitID[$89]='n0IL' // $89 = 137; 'n0IL': unit "Formalhaut"
    set udg_SaveFlagUnitID[$B5]='n0IM' // $B5 = 181; 'n0IM': unit "Staff of Light"
    set udg_SaveFlagUnitID['o']='n0IN' // 'n0IN': unit "Deathbringer"
    set udg_SaveFlagUnitID[268]='n0JO' // 'n0JO': unit "Scourge Wand"
    set udg_SaveFlagUnitID[270]='n0JP' // 'n0JP': unit "Dark Staff"
    set udg_SaveFlagUnitID[272]='n0JR' // 'n0JR': unit "Heroic Lance"
    set udg_SaveFlagUnitID[278]='n0K2' // 'n0K2': unit "Buddha Fist"
    set udg_SaveFlagUnitID[$E4]='n0ED' // $E4 = 228; 'n0ED': unit "Masakados"
    set udg_SaveFlagUnitID[288]='n0KU' // 'n0KU': unit "Siphoning Staff"
    set udg_SaveFlagUnitID[289]='n0KT' // 'n0KT': unit "Aeon Scepter"
    set udg_SaveFlagUnitID[294]='n0L1' // 'n0L1': unit "Shimmering Spear"
    set udg_SaveFlagUnitID[295]='n0L2' // 'n0L2': unit "Shimmering Sword"
    set udg_SaveFlagUnitID[296]='n0L3' // 'n0L3': unit "Shimmering Axe"
    set udg_SaveFlagUnitID[297]='n0L4' // 'n0L4': unit "Shimmering Katana"
    set udg_SaveFlagUnitID[298]='n0L7' // 'n0L7': unit "Wand of the Wind"
    set udg_SaveFlagUnitID[299]='n0L8' // 'n0L8': unit "Serpent Rod"
    set udg_SaveFlagUnitID[300]='n0L9' // 'n0L9': unit "Gaya's Rod"
    set udg_SaveFlagUnitID[316]='n0LP' // 'n0LP': unit "Chunchunmaru"
    set udg_SaveFlagUnitID[317]='n0LQ' // 'n0LQ': unit "Holy Lance"
    set udg_SaveFlagUnitID[318]='n0LX' // 'n0LX': unit "Kiku-Ichimonji"
    set udg_SaveFlagUnitID[319]='n0LY' // 'n0LY': unit "Auto-Crossbow"
    set udg_SaveFlagUnitID[320]='n0LZ' // 'n0LZ': unit "Halberd of Justice"
    set udg_SaveFlagUnitID[327]='n0MF' // 'n0MF': unit "Knuckles"
    set udg_SaveFlagUnitID[328]='n0MG' // 'n0MG': unit "Pickaxe"
    set udg_SaveFlagUnitID[329]='n0MH' // 'n0MH': unit "Miner's Pickaxe"
    set udg_SaveFlagUnitID[333]='n0MM' // 'n0MM': unit "Gravity Staff"
    set udg_SaveFlagUnitID[337]='n0MU' // 'n0MU': unit "Rock Punch"
    set udg_SaveFlagUnitID[338]='n0MV' // 'n0MV': unit "Edgar's Drill"
    set udg_SaveFlagUnitID[339]='n0MW' // 'n0MW': unit "Ryuujin no Ken"
    set udg_SaveFlagUnitID[341]='n0MY' // 'n0MY': unit "Beast Claw"
    set udg_SaveFlagUnitID[342]='n0N2' // 'n0N2': unit "Executioner Sword"
    set udg_SaveFlagUnitID[343]='n0N4' // 'n0N4': unit "True Ice Axe"
    set udg_SaveFlagUnitID[344]='n0N5' // 'n0N5': unit "Gladius"
    set udg_SaveFlagUnitID[345]='n0N6' // 'n0N6': unit "Wyrmhero Blade"
    set udg_SaveFlagUnitID[347]='n0N9' // 'n0N9': unit "Brotherhood"
    set udg_SaveFlagUnitID[348]='n0NA' // 'n0NA': unit "Storm Lance"
    set udg_SaveFlagUnitID[303]='n0LC' // 'n0LC': unit "Chainsaw"
    set udg_SaveFlagUnitID[304]='n0LD' // 'n0LD': unit "Durandal"
    set udg_SaveFlagUnitID[305]='n0LE' // 'n0LE': unit "Sagittarius"
    set udg_SaveFlagUnitID[306]='n0LF' // 'n0LF': unit "Exeter"
    set udg_SaveFlagUnitID[307]='n0LG' // 'n0LG': unit "Ehrgeiz"
    set udg_SaveFlagUnitID[308]='n0LH' // 'n0LH': unit "Zwill Crossblade"
    set udg_SaveFlagUnitID[309]='n0LI' // 'n0LI': unit "Scorpio"
    set udg_SaveFlagUnitID[310]='n0LJ' // 'n0LJ': unit "Zanmatou"
    set udg_SaveFlagUnitID[311]='n0LK' // 'n0LK': unit "Longinus"
    set udg_SaveFlagUnitID[312]='n0LL' // 'n0LL': unit "Ragnarok"
    set udg_SaveFlagUnitID[35]='n0FL' // 'n0FL': unit "Round Shield"
    set udg_SaveFlagUnitID[36]='n0FM' // 'n0FM': unit "Iron Shield"
    set udg_SaveFlagUnitID[37]='n0FN' // 'n0FN': unit "Mithril Shield"
    set udg_SaveFlagUnitID[38]='n0FO' // 'n0FO': unit "Aegis Shield"
    set udg_SaveFlagUnitID[39]='n0FP' // 'n0FP': unit "Platinum Shield"
    set udg_SaveFlagUnitID[40]='n0FQ' // 'n0FQ': unit "Enchanted Shield"
    set udg_SaveFlagUnitID[41]='n0FR' // 'n0FR': unit "Absorber"
    set udg_SaveFlagUnitID[81]='n0FS' // 'n0FS': unit "Unholy Shield"
    set udg_SaveFlagUnitID['}']='n0FT' // 'n0FT': unit "Reflect Shield"
    set udg_SaveFlagUnitID[$84]='n0FU' // $84 = 132; 'n0FU': unit "Zodiac Escutcheon"
    set udg_SaveFlagUnitID[$85]='n0FV' // $85 = 133; 'n0FV': unit "Ensanguined Shield"
    set udg_SaveFlagUnitID[$A5]='n0FW' // $A5 = 165; 'n0FW': unit "Genji Shield"
    set udg_SaveFlagUnitID[$CC]='n0FY' // $CC = 204; 'n0FY': unit "Interceptor Guard"
    set udg_SaveFlagUnitID[$DA]='n0FZ' // $DA = 218; 'n0FZ': unit "Flame Shield"
    set udg_SaveFlagUnitID[$DB]='n0G0' // $DB = 219; 'n0G0': unit "Frost Shield"
    set udg_SaveFlagUnitID[$F1]='n0G1' // $F1 = 241; 'n0G1': unit "Onion Arrows"
    set udg_SaveFlagUnitID[$F2]='n0G2' // $F2 = 242; 'n0G2': unit "Icecloud Arrows"
    set udg_SaveFlagUnitID[$F3]='n0G3' // $F3 = 243; 'n0G3': unit "Shock Arrows"
    set udg_SaveFlagUnitID[$F4]='n0G4' // $F4 = 244; 'n0G4': unit "Tempest Arrows"
    set udg_SaveFlagUnitID[$F5]='n0G5' // $F5 = 245; 'n0G5': unit "Killer Arrows"
    set udg_SaveFlagUnitID[$F6]='n0G6' // $F6 = 246; 'n0G6': unit "Onion Shot"
    set udg_SaveFlagUnitID[$F7]='n0G7' // $F7 = 247; 'n0G7': unit "Piercing Shot"
    set udg_SaveFlagUnitID[$F8]='n0G8' // $F8 = 248; 'n0G8': unit "Rock Shot"
    set udg_SaveFlagUnitID[$F9]='n0G9' // $F9 = 249; 'n0G9': unit "Scattershot"
    set udg_SaveFlagUnitID[$FA]='n0GA' // $FA = 250; 'n0GA': unit "Molotov Shot"
    set udg_SaveFlagUnitID[$FB]='n0GB' // $FB = 251; 'n0GB': unit "Bubble Shot"
    set udg_SaveFlagUnitID[$FE]='n0GC' // $FE = 254; 'n0GC': unit "Tome of Agility"
    set udg_SaveFlagUnitID[$FF]='n0GD' // $FF = 255; 'n0GD': unit "Tome of Crippling"
    set udg_SaveFlagUnitID[257]='n0GE' // 'n0GE': unit "Tome of Strength"
    set udg_SaveFlagUnitID[258]='n0GF' // 'n0GF': unit "Tome of the Breaker"
    set udg_SaveFlagUnitID[259]='n0GG' // 'n0GG': unit "Tome of Banishment"
    set udg_SaveFlagUnitID[260]='n0GH' // 'n0GH': unit "Tome of Heresy"
    set udg_SaveFlagUnitID[261]='n0GI' // 'n0GI': unit "Tome of Life"
    set udg_SaveFlagUnitID[262]='n0GJ' // 'n0GJ': unit "Tome of Phantasm"
    set udg_SaveFlagUnitID[263]='n0GK' // 'n0GK': unit "Tome of Time"
    set udg_SaveFlagUnitID[264]='n0GL' // 'n0GL': unit "Holy Book of Galbados"
    set udg_SaveFlagUnitID[265]='n0GM' // 'n0GM': unit "Tome of the Tortoise"
    set udg_SaveFlagUnitID[274]='n0JU' // 'n0JU': unit "Paladin Shield"
    set udg_SaveFlagUnitID[301]='n0LA' // 'n0LA': unit "Artemis Arrows"
    set udg_SaveFlagUnitID[313]='n0LO' // 'n0LO': unit "Shimmering Shield"
    set udg_SaveFlagUnitID[323]='n0M4' // 'n0M4': unit "Pulsar Shot"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$BE]) // $BE = 190
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$BF]) // $BF = 191
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$C0]) // $C0 = 192
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$C3]) // $C3 = 195
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$C4]) // $C4 = 196
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[$C5]) // $C5 = 197
    set udg_SaveFlagUnitID[$BE]='n0M6' // $BE = 190; 'n0M6': unit "Book of Flames"
    set udg_SaveFlagUnitID[$BF]='n0FH' // $BF = 191; 'n0FH': unit "Book of Glaciers"
    set udg_SaveFlagUnitID[$C0]='n0EX' // $C0 = 192; 'n0EX': unit "Book of Storms"
    set udg_SaveFlagUnitID[324]='n0FX' // 'n0FX': unit "Book of Depths"
    set udg_SaveFlagUnitID[325]='n0M7' // 'n0M7': unit "Book of Tremors"
    set udg_SaveFlagUnitID[326]='n0M8' // 'n0M8': unit "Book of Winds"
    set udg_SaveFlagUnitID[332]='n0M9' // 'n0M9': unit "Canister Shot"
    set udg_SaveFlagUnitID[331]='n0MD' // 'n0MD': unit "Slither Shield"
    set udg_SaveFlagUnitID[346]='n0N8' // 'n0N8': unit "Akashic Records"
    set udg_SaveFlagUnitID[350]='n0NC' // 'n0NC': unit "Invert Shield"
    set udg_SaveFlagUnitID[50]='n0F4' // 'n0F4': unit "Iron Helmet"
    set udg_SaveFlagUnitID[51]='n0F5' // 'n0F5': unit "Mithril Helmet"
    set udg_SaveFlagUnitID[52]='n0F6' // 'n0F6': unit "Diamond Helmet"
    set udg_SaveFlagUnitID[53]='n0F7' // 'n0F7': unit "Platinum Helmet"
    set udg_SaveFlagUnitID[72]='n0F8' // 'n0F8': unit "Helm of the Magi"
    set udg_SaveFlagUnitID[54]='n0F9' // 'n0F9': unit "Grand Helmet"
    set udg_SaveFlagUnitID[75]='n0FA' // 'n0FA': unit "Headgear of the Damned"
    set udg_SaveFlagUnitID[82]='n0FB' // 'n0FB': unit "Helm of the Necromancer"
    set udg_SaveFlagUnitID[85]='n0FC' // 'n0FC': unit "Barbarian's Helmet"
    set udg_SaveFlagUnitID[$81]='n0FD' // $81 = 129; 'n0FD': unit "Berserker's Helmet"
    set udg_SaveFlagUnitID[$8A]='n0FE' // $8A = 138; 'n0FE': unit "Zodiac Helmet"
    set udg_SaveFlagUnitID[$8B]='n0FF' // $8B = 139; 'n0FF': unit "Circlet"
    set udg_SaveFlagUnitID[$A4]='n0FG' // $A4 = 164; 'n0FG': unit "Genji Mask"
    set udg_SaveFlagUnitID[$B7]='n0FI' // $B7 = 183; 'n0FI': unit "Helm of Divine Judgment"
    set udg_SaveFlagUnitID[$DC]='n0FJ' // $DC = 220; 'n0FJ': unit "Serpent Helmet"
    set udg_SaveFlagUnitID[$DD]='n0FK' // $DD = 221; 'n0FK': unit "Enchanted Helmet"
    set udg_SaveFlagUnitID[290]='n0KV' // 'n0KV': unit "Glimmering Hat"
    set udg_SaveFlagUnitID[291]='n0KW' // 'n0KW': unit "Ice Hat"
    set udg_SaveFlagUnitID[292]='n0KX' // 'n0KX': unit "Green Hat"
    set udg_SaveFlagUnitID[293]='n0KY' // 'n0KY': unit "Earth Hat"
    set udg_SaveFlagUnitID[315]='n0LN' // 'n0LN': unit "Shimmering Helmet"
    set udg_SaveFlagUnitID[56]='n0EK' // 'n0EK': unit "Studded Leather Armor"
    set udg_SaveFlagUnitID[57]='n0EL' // 'n0EL': unit "Reinforced Leather Armor"
    set udg_SaveFlagUnitID[58]='n0EM' // 'n0EM': unit "Storm Wyrm Hide Armor"
    set udg_SaveFlagUnitID[59]='n0EN' // 'n0EN': unit "Grandmasterwork Leather"
    set udg_SaveFlagUnitID[60]='n0EP' // 'n0EP': unit "Elven Mail"
    set udg_SaveFlagUnitID[61]='n0EQ' // 'n0EQ': unit "Mithril Mail"
    set udg_SaveFlagUnitID[62]='n0ER' // 'n0ER': unit "Shimmering Mail"
    call ForceAddPlayerSimple(Player(9),udg_SaveFlagForce[62])
    set udg_SaveFlagUnitID[63]='n0ES' // 'n0ES': unit "Platinum Mail"
    set udg_SaveFlagUnitID[64]='n0ET' // 'n0ET': unit "Wizard's Robe"
    set udg_SaveFlagUnitID[65]='n0EU' // 'n0EU': unit "Magician's Robe"
    set udg_SaveFlagUnitID[66]='n0EV' // 'n0EV': unit "Sorcerer's Robe"
    set udg_SaveFlagUnitID[67]='n0EW' // 'n0EW': unit "Genji Armor"
    set udg_SaveFlagUnitID[86]='n0EO' // 'n0EO': unit "Fur Armor"
    set udg_SaveFlagUnitID[$82]='n0EY' // $82 = 130; 'n0EY': unit "Gaia Gear"
    set udg_SaveFlagUnitID[$8C]='n0EZ' // $8C = 140; 'n0EZ': unit "Robe of Lords"
    set udg_SaveFlagUnitID[$9B]='n0EJ' // $9B = 155; 'n0EJ': unit "Adamant Armor"
    set udg_SaveFlagUnitID[$CE]='n0F0' // $CE = 206; 'n0F0': unit "Maximillian"
    set udg_SaveFlagUnitID[$D9]='n0F1' // $D9 = 217; 'n0F1': unit "Windbreaker"
    set udg_SaveFlagUnitID[$ED]='n0F2' // $ED = 237; 'n0F2': unit "Nebra Suit"
    set udg_SaveFlagUnitID[267]='n0F3' // 'n0F3': unit "Grand Armor"
    set udg_SaveFlagUnitID[279]='n0K3' // 'n0K3': unit "Vishnu Vest"
    set udg_SaveFlagUnitID[284]='n0KH' // 'n0KH': unit "Glimmering Robe"
    set udg_SaveFlagUnitID[285]='n0KI' // 'n0KI': unit "Light Robe"
    set udg_SaveFlagUnitID[286]='n0KJ' // 'n0KJ': unit "Red Robe"
    set udg_SaveFlagUnitID[287]='n0KK' // 'n0KK': unit "Azure Robe"
    set udg_SaveFlagUnitID[314]='n0LM' // 'n0LM': unit "Shimmering Cloth"
    set udg_SaveFlagUnitID[330]='n0ME' // 'n0ME': unit "Mirage Vest"
    set udg_SaveFlagUnitID[349]='n0NB' // 'n0NB': unit "White Robe"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Armory_Open_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0MW')and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[35])) // 'A0MW': ability "Armory"
endfunction

function Trig_Armory_Open_HasCelestial takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[507]))
endfunction

function Trig_Armory_Open_NoArmoryYet takes nothing returns boolean
    return(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==null)
endfunction

function Trig_Armory_Open_Actions takes nothing returns nothing
    if(Trig_Armory_Open_NoArmoryYet())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call CreateNUnitsAtLoc(1,'e01G',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,bj_UNIT_FACING) // 'e01G': unit "Armory"
        call RemoveLocation(udg_TempPoint)
        set udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
        set bj_forLoopAIndex=501
        set bj_forLoopAIndexEnd=506
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call AddUnitToStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],1,1)
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        if(Trig_Armory_Open_HasCelestial())then
            call AddUnitToStockBJ(udg_SaveFlagUnitID[507],udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],1,1)
        endif
        call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[0])
    endif
    call SelectUnitForPlayerSingle(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetOwningPlayer(GetTriggerUnit()))
endfunction

function Trig_Armory_Select_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='e01G') // 'e01G': unit "Armory"
endfunction

function Trig_Armory_Select_IsClose takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0JM') // 'n0JM': unit "Close"
endfunction

function Trig_Armory_Select_IsCancel takes nothing returns boolean
    return(GetUnitTypeId(GetSoldUnit())=='n0IO') // 'n0IO': unit "Cancel"
endfunction

function Trig_Armory_Select_HeroNearby takes nothing returns boolean
    return(DistanceBetweenPoints(udg_TempPoint,udg_TempPoint2)<=500.)
endfunction

function Trig_Armory_Select_CanWithdraw takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[BlzGetUnitMaxMana(GetSoldUnit())]))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[35]))and(BlzGetUnitMaxMana(GetSoldUnit())<=udg_SaveFlagCount)
endfunction

function Trig_Armory_Select_InCategory takes nothing returns boolean
    return(GetUnitPointValueByType(udg_SaveFlagUnitID[GetForLoopIndexA()])==BlzGetUnitMaxMana(GetSoldUnit()))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[GetForLoopIndexA()]))
endfunction

function Trig_Armory_Select_IsCategoryNode takes nothing returns boolean
    return(GetUnitLevel(GetSoldUnit())>=1)
endfunction

function Trig_Armory_Select_HasStockId takes nothing returns boolean
    return(BlzGetUnitMaxMana(GetSoldUnit())>0)
endfunction

function Trig_Armory_Select_NotYourArmory takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())!=GetOwningPlayer(GetSoldUnit()))
endfunction

function Trig_Armory_Select_Actions takes nothing returns nothing
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    if(Trig_Armory_Select_NotYourArmory())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"This is not your armory!")
        call DestroyForce(udg_TempForce)
    else
        if(Trig_Armory_Select_HasStockId())then
            if(Trig_Armory_Select_IsCategoryNode())then
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=udg_ArmoryStockMax
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    call RemoveUnitFromStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],GetTriggerUnit())
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=udg_ArmoryStockMax
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    if(Trig_Armory_Select_InCategory())then
                        call AddUnitToStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],GetTriggerUnit(),1,1)
                    endif
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                call SetUnitAbilityLevelSwapped('A0MX',GetTriggerUnit(),(BlzGetUnitMaxMana(GetSoldUnit())+1)) // 'A0MX': ability "Cancel"
            else
                if(Trig_Armory_Select_CanWithdraw())then
                    set udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-1)
                    call RemoveUnitFromStockBJ(GetUnitTypeId(GetSoldUnit()),GetTriggerUnit())
                    set udg_TempPoint=GetRandomLocInRect(udg_PlayerStartRect[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                    call CreateItemLoc(udg_ItemIdTable[BlzGetUnitMaxMana(GetSoldUnit())],udg_TempPoint)
                    call RemoveLocation(udg_TempPoint)
                    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                    call DisplayTimedTextToForce(udg_TempForce,10.,("You took the "+(GetItemName(GetLastCreatedItem())+"|r from your armory.")))
                    call DestroyForce(udg_TempForce)
                    call SetItemUserData(GetLastCreatedItem(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
                    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
                    set udg_TempPoint2=GetUnitLoc(Player_GetHero(GetOwningPlayer(GetTriggerUnit())))
                    if(Trig_Armory_Select_HeroNearby())then
                        call UnitAddItemSwapped(GetLastCreatedItem(),Player_GetHero(GetOwningPlayer(GetTriggerUnit())))
                    else
                        call UnitAddItemSwapped(GetLastCreatedItem(),udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                    endif
                    call RemoveLocation(udg_TempPoint2)
                    call RemoveLocation(udg_TempPoint)
                    call ForceRemovePlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[BlzGetUnitMaxMana(GetSoldUnit())])
                endif
            endif
        else
            if(Trig_Armory_Select_IsCancel())then
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=540
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    call RemoveUnitFromStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],GetTriggerUnit())
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                set bj_forLoopAIndex=500
                set bj_forLoopAIndexEnd=506
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    call AddUnitToStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],GetTriggerUnit(),1,1)
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
            else
                if(Trig_Armory_Select_IsClose())then
                    call SelectUnitForPlayerSingle(udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetOwningPlayer(GetTriggerUnit()))
                    call ShowUnitHide(GetTriggerUnit())
                    call KillUnit(GetTriggerUnit())
                endif
            endif
        endif
    endif
endfunction

function Trig_Armory_Back_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0MX') // 'A0MX': ability "Cancel"
endfunction

function Trig_Armory_Back_MatchesBackCategory takes nothing returns boolean
    return(GetUnitPointValueByType(udg_SaveFlagUnitID[GetForLoopIndexA()])==udg_TempInteger)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[GetForLoopIndexA()]))
endfunction

function Trig_Armory_Back_IsTopLevel takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())==1)
endfunction

function Trig_Armory_Back_Actions takes nothing returns nothing
    if(Trig_Armory_Back_IsTopLevel())then
        call SelectUnitForPlayerSingle(udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetOwningPlayer(GetTriggerUnit()))
        call ShowUnitHide(GetTriggerUnit())
        call KillUnit(GetTriggerUnit())
    else
        set udg_TempInteger=udg_ArmoryParentCategory[(GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())-1)]
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=udg_ArmoryStockMax
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call RemoveUnitFromStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],GetTriggerUnit())
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=udg_ArmoryStockMax
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Armory_Back_MatchesBackCategory())then
                call AddUnitToStockBJ(udg_SaveFlagUnitID[GetForLoopIndexA()],GetTriggerUnit(),1,1)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call SetUnitAbilityLevelSwapped('A0MX',GetTriggerUnit(),(udg_TempInteger+1)) // 'A0MX': ability "Cancel"
    endif
endfunction

function Trig_Armory_Closed_Conditions takes nothing returns boolean
    return(GetTriggerUnit()!=null)and(GetTriggerUnit()==udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_Armory_Closed_Actions takes nothing returns nothing
    set udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
    call ForceRemovePlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[0])
endfunction

function Trig_Armory_Store_Item_ItemIsMine takes nothing returns boolean
    return(GetItemUserData(GetManipulatedItem())==0)or(GetItemUserData(GetManipulatedItem())==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_Armory_Store_Item_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_PlayerHouse[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[35]))and(GetItemType(GetManipulatedItem())!=ITEM_TYPE_CAMPAIGN)and(GetItemType(GetManipulatedItem())!=ITEM_TYPE_CHARGED)and(Trig_Armory_Store_Item_ItemIsMine())
endfunction

function Trig_Armory_Store_Item_ArmoryOpen takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[0]))
endfunction

function Trig_Armory_Store_Item_IsCelestialItem takes nothing returns boolean
    return(udg_ItemIndex>=303)and(udg_ItemIndex<=312)
endfunction

function Trig_Armory_Store_Item_Has50Items takes nothing returns boolean
    return(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=50)
endfunction

function Trig_Armory_Store_Item_MissingEntry takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_SaveFlagForce[udg_ItemIndex])==false)and(GetUnitPointValueByType(udg_SaveFlagUnitID[udg_ItemIndex])>0)
endfunction

function Trig_Armory_Store_Item_AllCollected takes nothing returns boolean
    return(udg_TempBoolean)
endfunction

function Trig_Armory_Store_Item_NoCompleteAward takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[56])==false)
endfunction

function Trig_Armory_Store_Item_Has250Items takes nothing returns boolean
    return(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=$FA) // $FA = 250
endfunction

function Trig_Armory_Store_Item_No250Award takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[58])==false)
endfunction

function Trig_Armory_Store_Item_Has200Items takes nothing returns boolean
    return(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=$C8) // $C8 = 200
endfunction

function Trig_Armory_Store_Item_No200Award takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[57])==false)
endfunction

function Trig_Armory_Store_Item_Has150Items takes nothing returns boolean
    return(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=$96) // $96 = 150
endfunction

function Trig_Armory_Store_Item_No150Award takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[38])==false)
endfunction

function Trig_Armory_Store_Item_Has100Items takes nothing returns boolean
    return(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>='d')
endfunction

function Trig_Armory_Store_Item_No100Award takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[37])==false)
endfunction

function Trig_Armory_Store_Item_No50Award takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[36])==false)
endfunction

function Trig_Armory_Store_Item_NewArmoryEntry takes nothing returns boolean
    return(udg_ItemIndex>0)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[udg_ItemIndex])==false)
endfunction

function Trig_Armory_Store_Item_Actions takes nothing returns nothing
    set udg_ItemIndex=LoadInteger(udg_ItemSaveID,0,GetItemTypeId(GetManipulatedItem()))
    if(Trig_Armory_Store_Item_NewArmoryEntry())then
        call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[udg_ItemIndex])
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,("The "+(GetItemName(GetManipulatedItem())+"|r has been added to your armory.")))
        call DestroyForce(udg_TempForce)
        call RemoveItem(GetManipulatedItem())
        if(Trig_Armory_Store_Item_ArmoryOpen())then
            call ShowUnitHide(udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
            call UnitApplyTimedLifeBJ(.01,'BTLF',udg_ArmoryUnit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) // 'BTLF': object name not found in map data
        endif
        if(Trig_Armory_Store_Item_IsCelestialItem())then
            call ForceAddPlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_SaveFlagForce[507])
        endif
        set udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ArmoryItemCount[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
        call Trig_Armory_Store_Item_CancelCodeLoad(GetOwningPlayer(GetTriggerUnit()))
        if(Trig_Armory_Store_Item_No50Award())then
            if(Trig_Armory_Store_Item_Has50Items())then
                set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
                set udg_TempInteger=36
                call ConditionalTriggerExecute(gg_trg_Title_Grant)
            endif
        else
            if(Trig_Armory_Store_Item_No100Award())then
                if(Trig_Armory_Store_Item_Has100Items())then
                    set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
                    set udg_TempInteger=37
                    call ConditionalTriggerExecute(gg_trg_Title_Grant)
                endif
            else
                if(Trig_Armory_Store_Item_No150Award())then
                    if(Trig_Armory_Store_Item_Has150Items())then
                        set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
                        set udg_TempInteger=38
                        call ConditionalTriggerExecute(gg_trg_Title_Grant)
                    endif
                else
                    if(Trig_Armory_Store_Item_No200Award())then
                        if(Trig_Armory_Store_Item_Has200Items())then
                            set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
                            set udg_TempInteger=57
                            call ConditionalTriggerExecute(gg_trg_Title_Grant)
                        endif
                    else
                        if(Trig_Armory_Store_Item_No250Award())then
                            if(Trig_Armory_Store_Item_Has250Items())then
                                set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
                                set udg_TempInteger=58
                                call ConditionalTriggerExecute(gg_trg_Title_Grant)
                            endif
                        else
                            if(Trig_Armory_Store_Item_NoCompleteAward())then
                                set udg_TempBoolean=true
                                set udg_ItemIndex=1
                                loop
                                    exitwhen udg_ItemIndex>udg_SaveFlagCount
                                    if(Trig_Armory_Store_Item_MissingEntry())then
                                        set udg_TempBoolean=false
                                    endif
                                    set udg_ItemIndex=udg_ItemIndex+1
                                endloop
                                if(Trig_Armory_Store_Item_AllCollected())then
                                    set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
                                    set udg_TempInteger=56
                                    call ConditionalTriggerExecute(gg_trg_Title_Grant)
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
endfunction

// World Editor calls InitTrig_Armory automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Armory_Part1 / RegisterTriggers_Armory_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Armory takes nothing returns nothing
endfunction

function Register_Armory_Item_List takes nothing returns nothing
    set gg_trg_Armory_Item_List=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Armory_Item_List,2.)
    call TriggerAddAction(gg_trg_Armory_Item_List,function Trig_Armory_Item_List_Actions)
endfunction

function Register_Armory_Item_Hash takes nothing returns nothing
    set gg_trg_Armory_Item_Hash=CreateTrigger()
    call TriggerAddAction(gg_trg_Armory_Item_Hash,function Trig_Armory_Item_Hash_Actions)
endfunction

function Register_Armory_Init takes nothing returns nothing
    set gg_trg_Armory_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Armory_Init,8.)
    call TriggerAddAction(gg_trg_Armory_Init,function Trig_Armory_Init_Actions)
endfunction

function Register_Armory_Open takes nothing returns nothing
    set gg_trg_Armory_Open=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Armory_Open,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Armory_Open,Condition(function Trig_Armory_Open_Conditions))
    call TriggerAddAction(gg_trg_Armory_Open,function Trig_Armory_Open_Actions)
endfunction

function Register_Armory_Select takes nothing returns nothing
    set gg_trg_Armory_Select=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Armory_Select,EVENT_PLAYER_UNIT_SELL)
    call TriggerAddCondition(gg_trg_Armory_Select,Condition(function Trig_Armory_Select_Conditions))
    call TriggerAddAction(gg_trg_Armory_Select,function Trig_Armory_Select_Actions)
endfunction

function Register_Armory_Back takes nothing returns nothing
    set gg_trg_Armory_Back=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Armory_Back,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Armory_Back,Condition(function Trig_Armory_Back_Conditions))
    call TriggerAddAction(gg_trg_Armory_Back,function Trig_Armory_Back_Actions)
endfunction

function Register_Armory_Closed takes nothing returns nothing
    set gg_trg_Armory_Closed=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Armory_Closed,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_Armory_Closed,Condition(function Trig_Armory_Closed_Conditions))
    call TriggerAddAction(gg_trg_Armory_Closed,function Trig_Armory_Closed_Actions)
endfunction

function Register_Armory_Store_Item takes nothing returns nothing
    set gg_trg_Armory_Store_Item=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Armory_Store_Item,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Armory_Store_Item,Condition(function Trig_Armory_Store_Item_Conditions))
    call TriggerAddAction(gg_trg_Armory_Store_Item,function Trig_Armory_Store_Item_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Armory_Part1 takes nothing returns nothing
    call Register_Armory_Item_List()
    call Register_Armory_Item_Hash() // run by Armory
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Armory_Part2 takes nothing returns nothing
    call Register_Armory_Init()
    call Register_Armory_Open()
    call Register_Armory_Select()
    call Register_Armory_Back()
    call Register_Armory_Closed()
    call Register_Armory_Store_Item()
endfunction

endlibrary

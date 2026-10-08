# ForsakenBS gear audit

276 equipment entries checked against Stage AS; four Materia remain outside the native equipment conversion.
Every original equipment ability definition and its numeric fields match AS. Every native variant retains the original abilities, cooldown group, charges and level/mastery requirements, adding only native slot/class metadata and the zero-stat storage marker. Original items remain available for Gaya.

Automated storage-cycle tests cover all 276 entries: passive bonuses detach in storage, active abilities survive, and the original passives restore when equipped. These are source/object and mocked lifecycle checks, not 276 in-game damage or equip trials. Native acceptance is still required.

Accuracy residual means a tooltip bonus missing from the original combat formula. Existing lance/Glasses/Strange Vision accuracy markers are not added again. Gun Critical Chance shows the weapon's base proc chance; the original elapsed-time/proficiency crit buildup still applies in combat. Ammunition flat damage includes current proficiency. Rock/Piercing Shot adds armor-piercing damage, not an armor-rating debuff. Bag of Tricks adds 20 percentage points to the ordinary item-drop roll. Magic Gloves activates at full HP; Leather/Steel Gorget and Armguard activate at or below 30% HP.

| Item | Slot | Requirement | Accuracy residual | Stored passive IDs | Active / other IDs |
|---|---|---|---|---|---|
| Champion's Belt | Trinket | 30 | 0 | A12A | — |
| Griever | Trinket | 50 | 0 | A045, A0VC, A0VI, A1BN | — |
| Touph Ring | Ring | 30 | 0 | A069 | — |
| Sprint Shoes | Boots | 1 | 0 | A0MU | — |
| Chimes of Piercing | Trinket | 15 | 0 | A0PQ, A0PR | — |
| Armguard | Gloves | 12 | 0 | A0T9 | — |
| Blue Amulet | Trinket | 10 | 0 | A12S | — |
| Germinas Boots | Boots | 14 | 0 | A0NG | — |
| Greater Totem of Power | Trinket | 24 | 0 | A0HC | — |
| Jade Collar | Trinket | 20 | 0 | AIev | — |
| Blazer Gloves | Gloves | 5 | 0 | A0P9 | — |
| Steel Gorget | Trinket | 9 | 0 | A0PA | — |
| Totem of Power | Trinket | 12 | 0 | A0J7 | — |
| Cat's Bell | Trinket | 5 | 0 | A03R | — |
| Heady Pipe | Trinket | 50 | 0 | A062, A0OH, A0V4 | — |
| Necklace of the Sorcerer | Trinket | 14 | 0 | A07M | — |
| Crusher's Belt | Trinket | 14 | 0 | A0H7 | — |
| Magic Gloves | Gloves | 5 | 0 | A0RF | — |
| Death Skull | Trinket | 30 | 0 | A0D1 | — |
| Growth Egg | Trinket | 50 | 0 | A0O7 | — |
| Stalwart Belt | Trinket | 45 | 0 | A0OL | — |
| Necklace of the Necromancer | Trinket | 60 | 0 | A0OJ | — |
| Leather Gorget | Trinket | 9 | 0 | A0RG | — |
| Charming Banner | Trinket | 40 | 0 | A0PM | — |
| Iron Duke | Trinket | 99 | 0 | A0AK, A0E1, A0NX, A0VI | — |
| Hidden Hero Medicine | Trinket | 99 | 0 | A0FF | — |
| Summoner's Horn | Trinket | 20 | 0 | A05H | — |
| Silver Glasses | Trinket | 20 | 0 | A068, A0RA | — |
| Speed Bracers | Gloves | 73 | 0 | A0GJ | — |
| Setzer's Coin | Trinket | 10 | 0 | A05L | — |
| Turtleshell Choker | Trinket | 10 | 0 | A03D | — |
| Cameo Belt | Trinket | 20 | 0 | A127 | — |
| Memento Ring | Ring | 1 | 0 | — | A1D8 |
| Jackboots | Boots | 60 | 0 | A0OK | — |
| Orb of Fire | Trinket | 50 | 0 | A0LV, A0M7 | — |
| Orb of Frost | Trinket | 50 | 0 | A0LW, A0M8 | — |
| Orb of Lightning | Trinket | 50 | 0 | A0LX, A0M9 | — |
| Orb of Water | Trinket | 50 | 0 | A0LY, A0MA | — |
| Orb of Earth | Trinket | 50 | 0 | A0LZ, A0MB | — |
| Orb of Wind | Trinket | 50 | 0 | A0M0, A0MC | — |
| Force of Nature | Trinket | 90 | 0 | A0ME, A0MI | — |
| Death Skull X | Trinket | 80 | 0 | A0OR, A0OS, A1A5 | — |
| Stopwatch | Trinket | 15 | 0 | A18K | — |
| Prominent Cloak | Trinket | 45 | 0 | A0Z6 | — |
| Hunter's Cloak | Trinket | 45 | 0 | A0ZS | — |
| White Materia | Trinket | 30 | 0 | A0QK | — |
| Rabite's Foot | Trinket | 99 | 0 | A02D, A1EX | — |
| Bag of Tricks | Trinket | 45 | 0 | A12V | — |
| Flag of Competition | Trinket | Inherited | 0 | A1EZ | — |
| Golden Skull | Trinket | 45 | 0 | A131 | — |
| Crystal Skull | Trinket | 60 | 0 | A132 | — |
| Firefly | Ring | 1 | 0 | A14P, A14Q | A01S |
| Rosetta Stone | Trinket | 60 | 0 | A135, A16Y | — |
| Hero's Badge | Trinket | 60 | 0 | A136 | — |
| Ring of Rejuvenation | Ring | 60 | 0 | A13R | — |
| Blank Orb | Trinket | 45 | 0 | A1A4 | — |
| Sleipnir | Trinket | 99 | 0 | A0A3, A0OT, A1C3 | — |
| Genji Gloves | Gloves | 30 | 0 | A0OQ | — |
| Orb of Cetra | Trinket | 60 | 0 | A0MD, A0MH | — |
| Yatagarasu | Trinket | 99 | 0 | A0LV, A0M7, A0SX, A1FF | — |
| Kotetsu | Primary | 16 | 0 | A04E, A0NH, A139, A13A | — |
| Poison Spear | Primary | 14 | 0 | A0PH, A0VE | — |
| Ultimate Weapon | Primary | 80 | 0 | A0CX, A0D1, A0WI, A11F | — |
| Long Sword | Primary | 5 | 0 | AIs3, AIsx, AItx | — |
| Mithril Sword | Primary | 14 | 0 | A034, A03H, A04W | — |
| Ancient Sword | Primary | 23 | 0 | A04X, A0AT, A1CL | — |
| Rune Blade | Primary | 38 | 0 | A0AI, A0VF, A16Z | — |
| Save the Queen | Primary | 58 | 0 | A0AI, A0VF, A11K | A0XZ |
| Excalibur | Primary | 73 | 0 | A0AI, A0VF, A11J | A0CY |
| Masamune | Primary | 90 | 0 | A08V, A139, A13E, A185 | — |
| Battle Axe | Primary | 6 | 0 | A12O, A17V, A17X, A1D0 | — |
| Mithril Axe | Primary | 14 | 0 | A053, A0EH, A0NV, A12O | — |
| Giant Axe | Primary | 35 | 0 | A04C, A055, A0CK, A12O | — |
| Poison Wand | Primary | 9 | 0 | A0GS, AImz, AItx | A10J |
| Fire Wand | Primary | 27 | 0 | A06R, A0LJ, A0NQ | A0QA |
| Thunder Wand | Primary | 18 | 0 | A060, A0LL, A106 | A07O |
| Ice Wand | Primary | 38 | 0 | A078, A07M, A0LK | A0Q9 |
| Dragon Wand | Primary | 71 | 0 | A0AO, A0DF, A0NS | A0TD |
| Dark Claw | Primary | 26 | 0 | A04W, A0EH, A17E | — |
| Unholy Claw | Primary | 32 | 0 | A04X, A0H3, A1CL | — |
| Cursed Wand | Primary | 49 | 0 | A078, A0A2, A0E3 | A0QN |
| Crusher's Mace | Primary | 26 | 0 | A0A2, A0C8, A0CI, A12O | — |
| Trident | Primary | 54 | 32 | A04G, A04I, A0LG | — |
| Platinum Dagger | Primary | 27 | 0 | A04Y, A054, A0NG, A1B9 | — |
| Dark Bow | Primary | 32 | 0 | A04X, A0A2, A0NG | — |
| Fel Axe | Primary | 64 | 0 | A0CX, A0D1, A0LH, A1D3 | — |
| Doom Mace | Primary | 47 | 0 | A0AO, A0H1, A12O, A1D1 | — |
| Shadow Bow | Primary | 54 | 0 | A07U, A0AI, A0D1, A0DV | — |
| Death Claw | Primary | 70 | 0 | A0MH, A0WI, A185, A1C2 | — |
| Ancient Axe | Primary | 99 | 0 | A06A, A0D1, A181, A1CB | — |
| Demon Claw | Primary | 47 | 0 | A0AI, A0AO, A0B0, A0DX | — |
| Lion Heart | Primary | 98 | 0 | A055, A079, A0A2, A0BE | — |
| Excalibur II | Primary | 99 | 0 | A0AI, A0VF, A1CX | A11L |
| Zodiac Spear | Primary | 99 | 0 | A19I, A1CP | — |
| Artemis Bow | Primary | 99 | 0 | A0GO, A19L, A1CM | — |
| Tournesol | Primary | 99 | 0 | A03X, A1CY, A1CZ | A18I |
| Nirvana | Primary | 99 | 0 | A062, A153 | A0E5 |
| Life Staff | Primary | 72 | 0 | A062, A0NU | A0W8 |
| Main Gauche | Primary | 33 | 0 | A04X, A0AS, A0FJ, A0QB | — |
| Assassin's Dagger | Primary | 63 | 0 | A0WH, A0WI, A17Y, A1CU | — |
| Strange Vision | Primary | 37 | 0 | A034, A0NI, A18O, A1ZZ | — |
| Gladiator's Blade | Primary | 69 | 0 | A0AO, A0H9, A0WI | — |
| Masamune C | Primary | 99 | 0 | A07P, A0I7, A0TW, A13F | — |
| Fire Wand K | Primary | 87 | 0 | A0IV, A0LB, A0LJ | A0UX |
| Ice Wand U | Primary | 87 | 0 | A0IV, A0LB, A0LK | A0UY |
| Thunder Wand J | Primary | 87 | 0 | A0IV, A0LB, A0LL | A0UZ |
| Magus Rod A | Primary | 99 | 0 | A013, A0MG, A1CT | A0U8 |
| Magus Rod | Primary | 61 | 0 | A0E3, A0L8, A0MG | A0JD |
| Icebrand | Primary | 53 | 0 | A055, A0LE, A11G, A1CN | — |
| Mjolnir | Primary | 64 | 0 | A02Z, A06A, A0H9, A0LF | — |
| Longbow | Primary | 15 | 0 | A04W, A05Y, A0AN | — |
| Dagger | Primary | 8 | 0 | A03I, A1B9, A1ZZ, AItf | — |
| Wildfire Spear | Primary | 60 | 0 | A0LD, A177, A19H | — |
| Short Lance | Primary | 6 | 0 | A0EH, A19E | — |
| Wirt's Leg | Primary | 59 | 0 | A02Z, A0FL, A0HC | A0UA |
| Demon Axe | Primary | 85 | 0 | A0NW, A12O, A16H, A184 | — |
| Muramasa | Primary | 71 | 0 | A117, A139, A13D, A1C2 | — |
| Final Wand | Primary | 99 | 0 | A0NU, A0OH, A117 | A0V1 |
| Ame-no-Murakumo | Primary | 58 | 0 | A0LI, A11G, A13H | — |
| Fishing Pole | Primary | 15 | 0 | A054, A05K, AId0 | A0VB |
| Muramata | Primary | 31 | 0 | A036, A0EH, A0VC | A0VT |
| Matamune | Primary | 67 | 0 | A0AO, A0HF, A0VD | A0VU |
| Lu Shang | Primary | 99 | 0 | A0KW, A18D, A1CO | A0VV |
| Mina | Primary | 99 | 0 | A0CM, A0WL, A1CV, A1CW | — |
| Angbar | Primary | 99 | 0 | A07P, A0H9, A0LD, A0YW | — |
| Caladbolg | Primary | 99 | 0 | A0CM, A11F, A11H, A185 | — |
| Phantom Bow | Primary | 60 | 0 | A0AO, A0IF, A1CN | — |
| Vega | Primary | 17 | 0 | A034, A115 | — |
| Aldebaran | Primary | 27 | 0 | A0VE, A116 | — |
| Arcturus | Primary | 54 | 0 | A0D1, A118 | — |
| Formalhaut | Primary | 99 | 0 | A0H5, A0WU | — |
| Staff of Light | Primary | 33 | 0 | A062, A0AL | A10K |
| Deathbringer | Primary | 40 | 0 | A04Y, A0AO, A0CI, A10X | — |
| Scourge Wand | Primary | Inherited | 0 | A0D1, A12N, A153 | A12M |
| Dark Staff | Primary | 55 | 0 | A062, A0L9 | A07J |
| Heroic Lance | Primary | 26 | 0 | A117, A19G | — |
| Buddha Fist | Primary | 99 | 0 | A08V, A0CM, A11G | — |
| Masakados | Primary | 99 | 0 | — | A0UW |
| Siphoning Staff | Primary | 64 | 0 | A062, A1CR | A0DG |
| Aeon Scepter | Primary | 84 | 0 | A046, A0EH, A0L9 | A0GL |
| Shimmering Spear | Primary | 45 | 0 | A0WU, A19F | — |
| Shimmering Sword | Primary | 45 | 0 | A02Z, A0AI, A0E6 | — |
| Shimmering Axe | Primary | 45 | 0 | A0H7, A0ND, A12O, A1D2 | — |
| Shimmering Katana | Primary | 45 | 0 | A0AO, A0DX, A139, A13C | — |
| Wand of the Wind | Primary | 71 | 0 | A0LO, A0O9, A0OO | A1AD |
| Serpent Rod | Primary | 66 | 0 | A0L9, A0LM, A0OH | A1AB |
| Gaya's Rod | Primary | 76 | 0 | A0JF, A0LN, A1CR | A1AH |
| Chunchunmaru | Primary | 77 | 0 | A0AS, A117, A182, A1CQ | — |
| Holy Lance | Primary | 85 | 0 | A03Y, A0WQ, A177, A19J | — |
| Kiku-Ichimonji | Primary | 27 | 0 | A0EH, A0H3, A139, A13B | — |
| Auto-Crossbow | Primary | 66 | 0 | A03X, A04C, A1A2 | A1A3 |
| Halberd of Justice | Primary | 85 | 0 | A0H9, A0OD, A185, A1A1 | — |
| Knuckles | Primary | 6 | 0 | A03J, A1BA, AIsx | — |
| Pickaxe | Primary | 2 | 0 | AId1, AItn, AIx2 | — |
| Miner's Pickaxe | Primary | 37 | 0 | A05K, A0OG, A0VE | A1BB |
| Gravity Staff | Primary | 88 | 0 | A062, A1CS | A1C4 |
| Rock Punch | Primary | 99 | 0 | A0IB, A0LH, A0WV, A13H | — |
| Edgar's Drill | Primary | 99 | 0 | A0E1, A0FL, A117 | A1D9 |
| Ryuujin no Ken | Primary | 99 | 0 | A07P, A08V, A139, A1DG | — |
| Beast Claw | Primary | 60 | 0 | A04Y, A0D1, A0DX | — |
| Executioner Sword | Primary | 99 | 0 | A0GV, A15K, A16G, A16H | — |
| True Ice Axe | Primary | 99 | 0 | A0LE, A0OD, A185, A1BR | — |
| Gladius | Primary | 99 | 0 | A0GO, A0I5, A0LI, A1B9 | — |
| Wyrmhero Blade | Primary | 99 | 0 | A0HS, A0WE, A0WG, A177 | — |
| Brotherhood | Primary | 99 | 0 | A0CM, A0LG, A184, A1BR | — |
| Storm Lance | Primary | 99 | 55 | A04M, A04S, A0LF, A1EV | — |
| Chainsaw | Primary | Legendary mastery | 0 | A04D, A0D1, A0IB | A19A |
| Durandal | Primary | Legendary mastery | 0 | A0DO, A0WU, A1BO | — |
| Sagittarius | Primary | Legendary mastery | 0 | A0CM, A177, A1BQ | — |
| Exeter | Primary | Legendary mastery | 0 | A0KU, A177 | — |
| Ehrgeiz | Primary | Legendary mastery | 0 | A0D1, A16G, A1BP | — |
| Zwill Crossblade | Primary | Legendary mastery | 0 | A0E8, A0HE, A1B9, A1BU | — |
| Scorpio | Primary | Legendary mastery | 0 | A0J4, A12O, A177, A1D4 | — |
| Zanmatou | Primary | Legendary mastery | 0 | A139, A13G, A177, A1D5 | — |
| Longinus | Primary | Legendary mastery | 0 | A0DK, A19D | — |
| Ragnarok | Primary | Legendary mastery | 0 | A0DP, A0WI, A185 | A183 |
| Round Shield | Offhand | 9 | 0 | A0P2, AId0 | — |
| Iron Shield | Offhand | 13 | 0 | A03F, A0PT | — |
| Mithril Shield | Offhand | 18 | 0 | A045, A05B | — |
| Aegis Shield | Offhand | 17 | 0 | A0FT, A0S0, A0S1 | — |
| Platinum Shield | Offhand | 29 | 0 | A05D, A0FL | — |
| Enchanted Shield | Offhand | 61 | 0 | A03X, A0PT, A0S4 | — |
| Absorber | Offhand | 87 | 0 | A05B, A0CN, A0S4 | — |
| Unholy Shield | Offhand | 31 | 0 | A0FU, A0P2, A0S2 | — |
| Reflect Shield | Offhand | 76 | 0 | A07T, A0B3, A0S5, A1B2 | — |
| Zodiac Escutcheon | Offhand | 95 | 0 | A0HF, A0HG | — |
| Ensanguined Shield | Offhand | 95 | 0 | A0EB, A0JR, A1CE | — |
| Genji Shield | Offhand | 65 | 0 | A069, A0CJ | — |
| Interceptor Guard | Offhand | 99 | 0 | A069, A0RT, A1C2 | — |
| Flame Shield | Offhand | 54 | 0 | A0CN, A0FK, A0LQ, A0LV | — |
| Frost Shield | Offhand | 55 | 0 | A03X, A0LP, A0LW, A0S6 | — |
| Onion Arrows | Offhand | 15 | 0 | A0Y8 | — |
| Icecloud Arrows | Offhand | 25 | 0 | A04H, A0YI, A13Q | — |
| Shock Arrows | Offhand | 30 | 0 | A04H, A0YG, A13W | — |
| Tempest Arrows | Offhand | 25 | 0 | A04H, A0Y6, A0YH | — |
| Killer Arrows | Offhand | 60 | 0 | A0Y9 | — |
| Onion Shot | Offhand | 20 | 0 | A0Y7, A0YA | — |
| Piercing Shot | Offhand | 25 | 0 | A0Y7, A0YB | — |
| Rock Shot | Offhand | 30 | 0 | A0Y7, A0YB, A0YE | — |
| Scattershot | Offhand | 40 | 0 | A0Y7, A0YC, A1AL | — |
| Molotov Shot | Offhand | 15 | 0 | A0Y7, A0YD, A144 | — |
| Bubble Shot | Offhand | 15 | 0 | A0Y7, A0YF, A145 | — |
| Tome of Agility | Offhand | 40 | 0 | A062, A07M | A0ZF |
| Tome of Crippling | Offhand | 40 | 0 | A038, A07M | A0ZC |
| Tome of Strength | Offhand | 45 | 0 | A062, A07M | A0Z9 |
| Tome of the Breaker | Offhand | 50 | 0 | A062, A07M | A0ZD |
| Tome of Banishment | Offhand | 40 | 0 | A062, A07M | A0L1 |
| Tome of Heresy | Offhand | 40 | 0 | A062, A07M | A0ZB |
| Tome of Life | Offhand | 25 | 0 | A038, A0NQ | A0FW |
| Tome of Phantasm | Offhand | 50 | 0 | A062, A07M | A0ZE |
| Tome of Time | Offhand | 25 | 0 | A038, A0NQ | A0ZG |
| Holy Book of Galbados | Offhand | 70 | 0 | A07T, A0AH | A0ZA |
| Tome of the Tortoise | Offhand | 40 | 0 | A062, A07M | A07D |
| Paladin Shield | Offhand | 99 | 0 | A05C, A0FL, A0ME, A12W | — |
| Artemis Arrows | Offhand | 99 | 0 | A174 | — |
| Shimmering Shield | Offhand | 45 | 0 | A0NX, A0PT, A0S3 | — |
| Pulsar Shot | Offhand | 99 | 0 | A0Y7, A1AM | — |
| Book of Flames | Offhand | 60 | 0 | A063, A0L9, A19S | A19P |
| Book of Glaciers | Offhand | 60 | 0 | A063, A0L9, A19T | A19Q |
| Book of Storms | Offhand | 60 | 0 | A063, A0L9, A19U | A19R |
| Book of Depths | Offhand | 60 | 0 | A063, A0L9, A19V | A08X |
| Book of Tremors | Offhand | 60 | 0 | A063, A0L9, A19W | A090 |
| Book of Winds | Offhand | 60 | 0 | A063, A0L9, A19X | A029 |
| Canister Shot | Offhand | 60 | 0 | A0Y7, A18L, A1FE | — |
| Slither Shield | Offhand | 63 | 0 | A0CN, A0DV, A1B6 | — |
| Akashic Records | Offhand | Inherited | 0 | A041, A063, A0NU | — |
| Invert Shield | Offhand | 91 | 0 | A05D, A0CN, A0F3, A0WF | — |
| Iron Helmet | Head | 7 | 0 | A0J1, A0OB, AI2m | — |
| Mithril Helmet | Head | 17 | 0 | A037, A061, A06G | — |
| Diamond Helmet | Head | 65 | 0 | A0CK, A0JF, A0LS, A0LX | — |
| Platinum Helmet | Head | 26 | 0 | A0C8, A0H2, A0JW | — |
| Helm of the Magi | Head | 25 | 0 | A037, A065, A06G | — |
| Grand Helmet | Head | 98 | 0 | A0J3, A0NS, A0OE | — |
| Headgear of the Damned | Head | 15 | 0 | A03G, A06C, A0IS | — |
| Helm of the Necromancer | Head | 67 | 0 | A06P, A0OH, A0OI | — |
| Barbarian's Helmet | Head | 65 | 0 | A0NS, A0OD, A0WQ | — |
| Berserker's Helmet | Head | 86 | 0 | A0H3, A0IA, A0J5, A0OE | — |
| Zodiac Helmet | Head | 89 | 0 | A0CK, A0J2 | — |
| Circlet | Head | 98 | 0 | A07T, A0CK, A0JF, A0WO | — |
| Genji Mask | Head | 74 | 0 | A065, A0OC, A0OD | — |
| Helm of Divine Judgement | Head | 99 | 0 | A0DX, A0FI, A0WP, A0WQ | — |
| Serpent Helmet | Head | 63 | 0 | A0J4, A0LR, A0LY, A0OE | — |
| Enchanted Helmet | Head | 33 | 0 | A01Y, A078, A0H2 | — |
| Glimmering Hat | Head | 45 | 0 | A00N, A06P, A093 | — |
| Ice Hat | Head | 56 | 0 | A05T, A06P, A0NS, A15E | — |
| Green Hat | Head | 58 | 0 | A046, A0C8, A0WQ, A15H | — |
| Earth Hat | Head | 61 | 0 | A00K, A0V0, A0WO, A15G | — |
| Shimmering Helmet | Head | 45 | 0 | A078, A0H1, A0JT | — |
| Studded Leather Armor | Chest | 5 | 0 | A0NV, AIa4, AId4 | — |
| Reinforced Leather Armor | Chest | 13 | 0 | A03I, A0OI, AId8 | — |
| Storm Wyrm Hide Armor | Chest | 24 | 0 | A06A, A0FT, A18A | — |
| Grandmasterwork Leather | Chest | 77 | 0 | A03X, A0CO, A0NG | — |
| Elven Mail | Chest | 7 | 0 | A0J1, A186, AIs4 | — |
| Mithril Mail | Chest | 17 | 0 | A053, A066, A0FL | — |
| Shimmering Mail | Chest | 45 | 0 | A055, A0H1, A0HF | — |
| Platinum Mail | Chest | 26 | 0 | A035, A037, A03X | — |
| Wizard's Robe | Chest | 14 | 0 | A05Q, A05U, A0NY, AId0 | — |
| Magician's Robe | Chest | 33 | 0 | A01Y, A045, A07M, A0JW | — |
| Sorcerer's Robe | Chest | 67 | 0 | A078, A0CK, A0CN, A0L9 | — |
| Genji Armor | Chest | 60 | 0 | A06A, A0DX, A0HF | — |
| Fur Armor | Chest | 36 | 0 | A0FT, A0NF, A0OD | — |
| Gaia Gear | Chest | 71 | 0 | A069, A0LU, A0LZ, A0O1 | — |
| Robe of Lords | Chest | 98 | 0 | A093, A0H1, A0HF, A0HW | — |
| Adamant Armor | Chest | 99 | 0 | A0EI, A0EJ, A0EK, A0I9 | — |
| Maximillian | Chest | 99 | 0 | A0H9, A0J4, A0WN, A18D | — |
| Windbreaker | Chest | 67 | 0 | A0J4, A0LT, A0M0, A18D | — |
| Nebra Suit | Chest | 98 | 0 | A0DV, A1B7, A1BZ | — |
| Grand Armor | Chest | 98 | 0 | A0CX, A16I, A1BX | — |
| Vishnu Vest | Chest | 81 | 0 | A0I2, A0ME, A1C0 | — |
| Glimmering Robe | Chest | 45 | 0 | A05T, A065, A0E3, A0FL | — |
| Light Robe | Chest | 53 | 0 | A07T, A0C8, A0LA, A15D | — |
| Red Robe | Chest | 55 | 0 | A069, A0CK, A0L9, A15C | — |
| Azure Robe | Chest | 57 | 0 | A0I2, A0O0, A15F, A1CR | — |
| Shimmering Cloth | Chest | 45 | 0 | A045, A0FJ, A0J4 | — |
| Mirage Vest | Chest | 99 | 0 | A03X, A0I9, A0IF, A1B8 | — |
| White Robe | Chest | 87 | 0 | A07H, A0HF, A0L9, A0OD | — |

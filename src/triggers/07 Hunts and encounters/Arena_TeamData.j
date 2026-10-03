library TArenaTeamData
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_InitData=null
    trigger gg_trg_Arena_TeamData1=null
    trigger gg_trg_Arena_TeamData2=null
endglobals

function Trig_Arena_InitData_Actions takes nothing returns nothing
    call InitHashtableBJ()
    set udg_GameStateHash=GetLastCreatedHashtableBJ()
    set udg_ArenaOrganizer[0]=gg_unit_e00G_0113
    set udg_ArenaOrganizer[1]=gg_unit_e00I_0111
    set udg_ArenaOrganizer[2]=gg_unit_e00H_0112
    set udg_ArenaOrganizer[3]=gg_unit_e00F_0172
    set udg_ArenaOrganizer[4]=gg_unit_e00J_0110
    set udg_ArenaOrganizer[5]=gg_unit_e008_0132
    set udg_ArenaOrganizer[6]=gg_unit_n0AX_0188
    set udg_ArenaOrganizerLast=4
    call SaveIntegerBJ($F0,1,0,udg_GameStateHash) // $F0 = 240
    call SaveIntegerBJ($BC,2,0,udg_GameStateHash) // $BC = 188
    call SaveIntegerBJ($F0,3,0,udg_GameStateHash) // $F0 = 240
    set udg_ArenaMonsterType[1]='E002' // 'E002': unit "Zodiac Brave of Earth"
    set udg_ArenaMonsterType[2]='Uwar' // 'Uwar': unit "Zodiac Brave of Fire"
    set udg_ArenaMonsterType[3]='Uear' // 'Uear': unit "Dark Knight"
    set udg_ArenaMonsterType[4]='Nman' // 'Nman': unit "Weapon"
    set udg_ArenaMonsterType[5]='N022' // 'N022': unit "Weapon"
    set udg_ArenaMonsterType[6]='uabc' // 'uabc': unit "Tainted Cúchulainn"
    set udg_ArenaMonsterType[7]='n01B' // 'n01B': unit "Infernal Templar"
    set udg_ArenaMonsterType[8]='n01A' // 'n01A': unit "Infernal Knight"
    set udg_ArenaMonsterType[9]='E00K' // 'E00K': unit "Just A Kid?"
    set udg_ArenaMonsterType[$A]='n032' // $A = 10; 'n032': unit "Chocobo"
    set udg_ArenaMonsterType[$B]='n033' // $B = 11; 'n033': unit "Chocobo"
    set udg_ArenaMonsterType[$C]='ngnb' // $C = 12; 'ngnb': unit "Forest Gnoll"
    set udg_ArenaMonsterType[$D]='nfsp' // $D = 13; 'nfsp': unit "Forest Goblin Shaman"
    set udg_ArenaMonsterType[$E]='nftt' // $E = 14; 'nftt': unit "Forest Goblin Trapper"
    set udg_ArenaMonsterType[$F]='nftb' // $F = 15; 'nftb': unit "Forest Goblin Berserker"
    set udg_ArenaMonsterType[16]='nfsh' // 'nfsh': unit "Forest Goblin Great Shaman"
    set udg_ArenaMonsterType[17]='nspg' // 'nspg': editor label "Forest Spider"
    set udg_ArenaMonsterType[18]='nwlt' // 'nwlt': unit "Forest Wolf"
    set udg_ArenaMonsterType[19]='n0B4' // 'n0B4': unit "Big Wolf"
    set udg_ArenaMonsterType[20]='n0B5' // 'n0B5': unit "Angry Wolf"
    set udg_ArenaMonsterType[21]='n00T' // 'n00T': editor label "Bear"
    set udg_ArenaMonsterType[22]='n00U' // 'n00U': unit "Dire Bear"
    set udg_ArenaMonsterType[23]='n00V' // 'n00V': unit "Ancient Bear"
    set udg_ArenaMonsterType[24]='nmrl' // 'nmrl': unit "Forest Triton"
    set udg_ArenaMonsterType[25]='nbrg' // 'nbrg': object name not found in map data
    set udg_ArenaMonsterType[26]='nass' // 'nass': object name not found in map data
    set udg_ArenaMonsterType[27]='nenf' // 'nenf': object name not found in map data
    set udg_ArenaMonsterType[28]='nbld' // 'nbld': object name not found in map data
    set udg_ArenaMonsterType[29]='ndtw' // 'ndtw': unit "Dark Goblin Chieftain"
    set udg_ArenaMonsterType[30]='nspb' // 'nspb': object name not found in map data
    set udg_ArenaMonsterType[31]='ncen' // 'ncen': object name not found in map data
    set udg_ArenaMonsterType[32]='ncim' // 'ncim': object name not found in map data
    set udg_ArenaMonsterType[33]='ncnk' // 'ncnk': object name not found in map data
    set udg_ArenaMonsterType[34]='ncks' // 'ncks': object name not found in map data
    set udg_ArenaMonsterType[35]='ncea' // 'ncea': object name not found in map data
    set udg_ArenaMonsterType[36]='nstw' // 'nstw': object name not found in map data
    set udg_ArenaMonsterType[37]='nthl' // 'nthl': object name not found in map data
    set udg_ArenaMonsterType[38]='nowk' // 'nowk': object name not found in map data
    set udg_ArenaMonsterType[39]='nowe' // 'nowe': object name not found in map data
    set udg_ArenaMonsterType[40]='nowb' // 'nowb': object name not found in map data
    set udg_ArenaMonsterType[41]='nhrr' // 'nhrr': object name not found in map data
    set udg_ArenaMonsterType[42]='nhar' // 'nhar': object name not found in map data
    set udg_ArenaMonsterType[43]='nhrq' // 'nhrq': object name not found in map data
    set udg_ArenaMonsterType[44]='nhrh' // 'nhrh': object name not found in map data
    set udg_ArenaMonsterType[45]='nhrw' // 'nhrw': object name not found in map data
    set udg_ArenaMonsterType[46]='nqbh' // 'nqbh': object name not found in map data
    set udg_ArenaMonsterType[47]='nrzb' // 'nrzb': object name not found in map data
    set udg_ArenaMonsterType[48]='nrzg' // 'nrzg': object name not found in map data
    set udg_ArenaMonsterType[49]='nrzm' // 'nrzm': object name not found in map data
    set udg_ArenaMonsterType[50]='n011' // 'n011': unit "Tempest Lizard"
    set udg_ArenaMonsterType[51]='nogr' // 'nogr': object name not found in map data
    set udg_ArenaMonsterType[52]='nogl' // 'nogl': object name not found in map data
    set udg_ArenaMonsterType[53]='nomg' // 'nomg': object name not found in map data
    set udg_ArenaMonsterType[54]='ngnw' // 'ngnw': object name not found in map data
    set udg_ArenaMonsterType[55]='ngna' // 'ngna': object name not found in map data
    set udg_ArenaMonsterType[56]='ngns' // 'ngns': object name not found in map data
    set udg_ArenaMonsterType[57]='nwzd' // 'nwzd': object name not found in map data
    set udg_ArenaMonsterType[58]='nwzr' // 'nwzr': object name not found in map data
    set udg_ArenaMonsterType[59]='nwiz' // 'nwiz': unit "Apprentice Dark Wizard"
    set udg_ArenaMonsterType[60]='nhfp' // 'nhfp': unit "Kultist"
    set udg_ArenaMonsterType[61]='nhdc' // 'nhdc': object name not found in map data
    set udg_ArenaMonsterType[62]='nhhr' // 'nhhr': object name not found in map data
    set udg_ArenaMonsterType[63]='nrel' // 'nrel': object name not found in map data
    set udg_ArenaMonsterType[64]='nsel' // 'nsel': object name not found in map data
    set udg_ArenaMonsterType[65]='ntrg' // 'ntrg': unit "Adamanchelid"
    set udg_ArenaMonsterType[66]='ntrd' // 'ntrd': unit "Adaman Tortoise"
    set udg_ArenaMonsterType[67]='nsgb' // 'nsgb': object name not found in map data
    set udg_ArenaMonsterType[68]='nsc3' // 'nsc3': object name not found in map data
    set udg_ArenaMonsterType[69]='n01O' // 'n01O': unit "Flan"
    set udg_ArenaMonsterType[70]='nehy' // 'nehy': object name not found in map data
    set udg_ArenaMonsterType[71]='H00W' // 'H00W': unit "Ogre Crusher"
    set udg_ArenaMonsterType[72]='nlkl' // 'nlkl': object name not found in map data
    set udg_ArenaMonsterType[73]='nlsn' // 'nlsn': object name not found in map data
    set udg_ArenaMonsterType[74]='nltc' // 'nltc': object name not found in map data
    set udg_ArenaMonsterType[75]='nmtw' // 'nmtw': object name not found in map data
    set udg_ArenaMonsterType[76]='nmbg' // 'nmbg': object name not found in map data
    set udg_ArenaMonsterType[77]='nmsc' // 'nmsc': object name not found in map data
    set udg_ArenaMonsterType[78]='nmrv' // 'nmrv': object name not found in map data
    set udg_ArenaMonsterType[79]='nmsn' // 'nmsn': object name not found in map data
    set udg_ArenaMonsterType[80]='njgb' // 'njgb': object name not found in map data
    set udg_ArenaMonsterType[81]='njga' // 'njga': object name not found in map data
    set udg_ArenaMonsterType[82]='n016' // 'n016': unit "Bloodstone Golem"
    set udg_ArenaMonsterType[83]='uabo' // 'uabo': object name not found in map data
    set udg_ArenaMonsterType[84]='n02V' // 'n02V': unit "Annoying Monster"
    set udg_ArenaMonsterType[85]='n019' // 'n019': unit "Satyr Farseer"
    set udg_ArenaMonsterType[86]='n00H' // 'n00H': unit "Gnoll Chieftain"
    set udg_ArenaMonsterType[87]='n023' // 'n023': unit "Vodyan"
    set udg_ArenaMonsterType[88]='n03S' // 'n03S': unit "Boco the Chocobo"
    set udg_ArenaMonsterType[89]='n03B' // 'n03B': unit "Tonberry"
    set udg_ArenaMonsterType[90]='n03U' // 'n03U': unit "Cactuar"
    set udg_ArenaMonsterType[91]='n03W' // 'n03W': unit "Malboro"
    set udg_ArenaMonsterType[92]='n015' // 'n015': unit "Mithril Golem"
    set udg_ArenaMonsterType[93]='n00F' // 'n00F': unit "Fire Golem"
    set udg_ArenaMonsterType[94]='n01M' // 'n01M': unit "Tempest Wyrm"
    set udg_ArenaMonsterType[95]='n03C' // 'n03C': unit "Mega-Tonberry"
    set udg_ArenaMonsterType[96]='n03V' // 'n03V': unit "Jumbo Cactuar"
    set udg_ArenaMonsterType[97]='n03X' // 'n03X': unit "Great Malboro"
    set udg_ArenaMonsterType[98]='nsts' // 'nsts': editor label "Satyr Shadowdancer"
    set udg_ArenaMonsterType[99]='nsat' // 'nsat': editor label "Satyr Trickster"
    set udg_ArenaMonsterType['d']='nsty' // 'nsty': editor label "Satyr"
    set udg_ArenaMonsterType['e']='nsth' // 'nsth': editor label "Satyr Hellcaller"
    set udg_ArenaMonsterType['f']='nstl' // 'nstl': editor label "Satyr Soulstealer"
    set udg_ArenaMonsterType['g']='n00N' // 'n00N': unit "Corrupted Ancient of War"
    set udg_ArenaMonsterType['h']='n00O' // 'n00O': unit "Corrupted Ancient Protector"
    set udg_ArenaMonsterType['i']='n00P' // 'n00P': unit "Corrupted Tree of Life"
    set udg_ArenaMonsterType['j']='n01N' // 'n01N': unit "Greater Flan"
    set udg_ArenaMonsterType['k']='n01Q' // 'n01Q': unit "Aqua Flan"
    set udg_ArenaMonsterType['l']='nenc' // 'nenc': editor label "Corrupted Treant"
    set udg_ArenaMonsterType['m']='nepl' // 'nepl': editor label "Plague Treant"
    set udg_ArenaMonsterType['n']='nenp' // 'nenp': editor label "Poison Treant"
    set udg_ArenaMonsterType['o']='ndtw' // 'ndtw': unit "Dark Goblin Chieftain"
    set udg_ArenaMonsterType['p']='nnmg' // 'nnmg': object name not found in map data
    set udg_ArenaMonsterType['q']='nmpe' // 'nmpe': object name not found in map data
    set udg_ArenaMonsterType['r']='nmyr' // 'nmyr': object name not found in map data
    set udg_ArenaMonsterType['s']='nnsw' // 'nnsw': object name not found in map data
    set udg_ArenaMonsterType['t']='nsnp' // 'nsnp': object name not found in map data
    set udg_ArenaMonsterType['u']='nnrg' // 'nnrg': object name not found in map data
    set udg_ArenaMonsterType['v']='nhyc' // 'nhyc': object name not found in map data
    set udg_ArenaMonsterType['w']='nwgs' // 'nwgs': object name not found in map data
    set udg_ArenaMonsterType['x']='n03E' // 'n03E': unit "Nether Drake"
    set udg_ArenaMonsterType['y']='n03F' // 'n03F': unit "Marsh Whelp"
    set udg_ArenaMonsterType['z']='n03H' // 'n03H': unit "Black Dragon"
    set udg_ArenaMonsterType['{']='n03G' // 'n03G': unit "Dusk Wyrm"
    set udg_ArenaMonsterType['|']='ugho' // 'ugho': object name not found in map data
    set udg_ArenaMonsterType['}']='Uvng' // 'Uvng': unit "Vampire"
    set udg_ArenaMonsterType[$7E]='U006' // $7E = 126; 'U006': unit "Necromancer"
    set udg_ArenaMonsterType[$7F]='Hgam' // $7F = 127; 'Hgam': unit "Warlock"
    set udg_ArenaMonsterType[$80]='N024' // $80 = 128; 'N024': unit "Ice Demon"
    set udg_ArenaMonsterType[$81]='H01L' // $81 = 129; 'H01L': unit "Friend of Brothers"
    set udg_ArenaMonsterType[$82]='H01J' // $82 = 130; 'H01J': unit "Friend of Brothers"
    set udg_ArenaMonsterType[$83]='H01I' // $83 = 131; 'H01I': unit "Friend of Brothers"
    set udg_ArenaMonsterType[$84]='H01K' // $84 = 132; 'H01K': unit "Friend of Brothers"
    set udg_ArenaMonsterType[$85]='U00C' // $85 = 133; 'U00C': unit "King of the Underworld"
    set udg_ArenaMonsterType[$86]='H00Y' // $86 = 134; 'H00Y': unit "Dark Ranger"
    set udg_ArenaMonsterType[$87]='e009' // $87 = 135; 'e009': unit "Shadow Queen Lilith"
    set udg_ArenaMonsterType[$88]='Hvsh' // $88 = 136; 'Hvsh': unit "Serpent Witch"
    set udg_ArenaMonsterType[$89]='n014' // $89 = 137; 'n014': unit "Centaur Genghis Khan"
    set udg_ArenaMonsterType[$8A]='Opgh' // $8A = 138; 'Opgh': unit "Corrupted Orc Chieftain"
    set udg_ArenaMonsterType[$8B]='nchr' // $8B = 139; 'nchr': unit "Corrupted Orc Wolf Rider"
    set udg_ArenaMonsterType[$8C]='N03D' // $8C = 140; 'N03D': unit "Mighty Swordsman"
    set udg_ArenaMonsterType[$8D]='Ocb2' // $8D = 141; 'Ocb2': unit "Brother"
    set udg_ArenaMonsterType[$8E]='Ocbh' // $8E = 142; 'Ocbh': unit "Brother"
    set udg_ArenaMonsterType[$8F]='N0LU' // $8F = 143; 'N0LU': unit "Mighty Swordsman"
    set udg_ArenaMonsterType[$90]='Ocb2' // $90 = 144; 'Ocb2': unit "Brother"
    set udg_ArenaMonsterType[$91]='Ocbh' // $91 = 145; 'Ocbh': unit "Brother"
    set udg_ArenaMonsterType[$92]='N02I' // $92 = 146; 'N02I': unit "Strongest Eidolon"
    set udg_ArenaMonsterType[$93]='n03Z' // $93 = 147; 'n03Z': unit "Lacerta"
    set udg_ArenaMonsterType[$94]='n03Y' // $94 = 148; 'n03Y': unit "Tindalos"
    set udg_ArenaMonsterType[$95]='n040' // $95 = 149; 'n040': unit "Aeshma"
    set udg_ArenaMonsterType[$96]='n042' // $96 = 150; 'n042': unit "Dark Flan"
    set udg_ArenaMonsterType[$97]='n041' // $97 = 151; 'n041': unit "Ruby Dragon"
    set udg_ArenaMonsterType[$98]='N03K' // $98 = 152; 'N03K': unit "The Judge"
    set udg_ArenaMonsterType[$99]='H01M' // $99 = 153; 'H01M': unit "Northern God"
    set udg_ArenaMonsterType[$9A]='Hpb1' // $9A = 154; 'Hpb1': unit "Engineer"
    set udg_ArenaMonsterType[$9B]='Hpb1' // $9B = 155; 'Hpb1': unit "Engineer"
    set udg_ArenaMonsterType[$9C]='Hjai' // $9C = 156; 'Hjai': unit "Cleric"
    set udg_ArenaMonsterType[$9D]='H00T' // $9D = 157; 'H00T': unit "High Priest"
    set udg_ArenaMonsterType[$9E]='Hdgo' // $9E = 158; 'Hdgo': unit "Blade Knight"
    set udg_ArenaMonsterType[$9F]='Hvwd' // $9F = 159; 'Hvwd': unit "First Ranger"
    set udg_ArenaMonsterType[$A0]='n045' // $A0 = 160; 'n045': unit "Frakir"
    set udg_ArenaMonsterType[$A1]='e00M' // $A1 = 161; 'e00M': editor label "Naisha"
    set udg_ArenaMonsterType[$A2]='h029' // $A2 = 162; 'h029': unit "Biggs"
    set udg_ArenaMonsterType[$A3]='h02A' // $A3 = 163; 'h02A': unit "Wedge"
    set udg_ArenaMonsterType[$A4]='n046' // $A4 = 164; 'n046': unit "Jessie"
    set udg_ArenaMonsterType[$A5]='h02B' // $A5 = 165; 'h02B': unit "Fire"
    set udg_ArenaMonsterType[$A6]='h02C' // $A6 = 166; 'h02C': unit "Storm"
    set udg_ArenaMonsterType[$A7]='h02D' // $A7 = 167; 'h02D': unit "Earth"
    set udg_ArenaMonsterType[$A8]='n020' // $A8 = 168; 'n020': unit "Ramuh"
    set udg_ArenaMonsterType[$A9]='n048' // $A9 = 169; 'n048': unit "Quezacotl"
    set udg_ArenaMonsterType[$AA]='e00O' // $AA = 170; 'e00O': unit "Golem"
    set udg_ArenaMonsterType[$AB]='n049' // $AB = 171; 'n049': unit "Cyclops"
    set udg_ArenaMonsterType[$AC]='e00N' // $AC = 172; 'e00N': unit "Shiva"
    set udg_ArenaMonsterType[$AD]='n04A' // $AD = 173; 'n04A': unit "Ifrit"
    set udg_ArenaMonsterType[$AE]='n047' // $AE = 174; 'n047': unit "Bahamut"
    set udg_ArenaMonsterType[$AF]='n04B' // $AF = 175; 'n04B': unit "Neo Bahamut"
    set udg_ArenaMonsterType[$B0]='n04C' // $B0 = 176; 'n04C': unit "Bahamut Zero"
    set udg_ArenaMonsterType[$B1]='Emns' // $B1 = 177; 'Emns': unit "Keeper of the Forest"
    set udg_ArenaMonsterType[$B2]='Etyr' // $B2 = 178; 'Etyr': unit "Priestess of Elune"
    set udg_ArenaMonsterType[$B3]='nwlg' // $B3 = 179; 'nwlg': object name not found in map data
    set udg_ArenaMonsterType[$B4]='nwld' // $B4 = 180; 'nwld': object name not found in map data
    set udg_ArenaMonsterType[$B5]='nggr' // $B5 = 181; 'nggr': object name not found in map data
    set udg_ArenaMonsterType[$B6]='ngst' // $B6 = 182; 'ngst': object name not found in map data
    set udg_ArenaMonsterType[$B7]='nsgg' // $B7 = 183; 'nsgg': object name not found in map data
    set udg_ArenaMonsterType[$B8]='nwrg' // $B8 = 184; 'nwrg': object name not found in map data
    set udg_ArenaMonsterType[$B9]='n02P' // $B9 = 185; 'n02P': unit "Adamantoise"
    set udg_ArenaMonsterType[$BA]='n02Q' // $BA = 186; 'n02Q': unit "Adaman Taimai"
    set udg_ArenaMonsterType[$BB]='n04D' // $BB = 187; 'n04D': unit "Kadaj"
    set udg_ArenaMonsterType[$BC]='n04E' // $BC = 188; 'n04E': unit "Loz"
    set udg_ArenaMonsterType[$BD]='n04F' // $BD = 189; 'n04F': unit "Yazoo"
    set udg_ArenaMonsterType[$BE]='nmrr' // $BE = 190; 'nmrr': unit "Triton Huntsman"
    set udg_ArenaMonsterType[$BF]='E00P' // $BF = 191; 'E00P': unit "Warring Triad Member"
    set udg_ArenaMonsterType[$C0]='E00Q' // $C0 = 192; 'E00Q': unit "Warring Triad Member"
    set udg_ArenaMonsterType[$C1]='E00R' // $C1 = 193; 'E00R': unit "Warring Triad Member"
    set udg_ArenaMonsterType[$C2]='h02K' // $C2 = 194; 'h02K': unit "Cup Organizer"
    set udg_ArenaMonsterType[$C3]='h02J' // $C3 = 195; 'h02J': unit "General Leo"
    set udg_ArenaMonsterType[$C4]='n04G' // $C4 = 196; 'n04G': unit "Limma"
    set udg_ArenaMonsterType[$C5]='n04M' // $C5 = 197; 'n04M': unit "Forest Goblin"
    set udg_ArenaMonsterType[$C6]='n04N' // $C6 = 198; 'n04N': object name not found in map data
    set udg_ArenaMonsterType[$C7]='n04O' // $C7 = 199; 'n04O': object name not found in map data
    set udg_ArenaMonsterType[$C8]='n04P' // $C8 = 200; 'n04P': object name not found in map data
    set udg_ArenaMonsterType[$C9]='n04Q' // $C9 = 201; 'n04Q': object name not found in map data
    set udg_ArenaMonsterType[$CA]='n04R' // $CA = 202; 'n04R': object name not found in map data
    set udg_ArenaMonsterType[$CB]='n04S' // $CB = 203; 'n04S': editor label "Satyr"
    set udg_ArenaMonsterType[$CC]='n04T' // $CC = 204; 'n04T': unit "Wendigo"
    set udg_ArenaMonsterType[$CD]='E00S' // $CD = 205; 'E00S': unit "Assassin"
    set udg_ArenaMonsterType[$CE]='e00W' // $CE = 206; 'e00W': unit "Relm"
    set udg_ArenaMonsterType[$CF]='n08E' // $CF = 207; 'n08E': unit "Penance's Left Arm"
    set udg_ArenaMonsterType[$D0]='n08B' // $D0 = 208; 'n08B': unit "Penance's Right Arm"
    set udg_ArenaMonsterType[$D1]='U000' // $D1 = 209; 'U000': unit "Zodiac Brave of Death"
    set udg_ArenaMonsterType[$D2]='U00G' // $D2 = 210; 'U00G': unit "Blazing Demon"
    set udg_ArenaMonsterType[$D3]='E018' // $D3 = 211; 'E018': unit "Arbiter of Time"
    set udg_ArenaMonsterType[$D4]='E018' // $D4 = 212; 'E018': unit "Arbiter of Time"
    set udg_ArenaMonsterType[$D5]='E018' // $D5 = 213; 'E018': unit "Arbiter of Time"
    set udg_ArenaMonsterType[$D6]='E018' // $D6 = 214; 'E018': unit "Arbiter of Time"
    set udg_ArenaMonsterType[$D7]='E018' // $D7 = 215; 'E018': unit "Arbiter of Time"
    set udg_ArenaMonsterType[$D8]='E01H' // $D8 = 216; 'E01H': unit "Illusion Hydra"
    set udg_ArenaMonsterType[$D9]='U00H' // $D9 = 217; 'U00H': unit "Zodiac Brave of Darkness"
    set udg_ArenaMonsterType[$DA]='U00F' // $DA = 218; 'U00F': unit "Zodiac Brave of Holy"
    set udg_ArenaMonsterType[$DB]='U00J' // $DB = 219; 'U00J': unit "Zodiac Brave of Gravity"
    set udg_ArenaMonsterType[$DC]='U00O' // $DC = 220; 'U00O': unit "Zodiac Brave of Wind"
    set udg_ArenaMonsterType[$DD]='U00K' // $DD = 221; 'U00K': unit "Zodiac Brave of Aether"
    set udg_ArenaMonsterType[$DE]='U00I' // $DE = 222; 'U00I': unit "Zodiac Brave of Soul"
    set udg_ArenaMonsterType[$DF]='U019' // $DF = 223; 'U019': unit "Zodiac Brave of Poison"
    set udg_ArenaMonsterType[$E0]='U00N' // $E0 = 224; 'U00N': unit "Zodiac Brave of Water"
    set udg_ArenaMonsterType[$E1]='U00E' // $E1 = 225; 'U00E': unit "Zodiac Brave of Thunder"
    set udg_ArenaMonsterType[$E2]='u00R' // $E2 = 226; 'u00R': unit "Shambling Corpse"
    set udg_ArenaMonsterType[$E3]='n0B0' // $E3 = 227; 'n0B0': unit "Melaiduma"
    set udg_ArenaMonsterType[$E4]='u00P' // $E4 = 228; 'u00P': unit "Skeleton Champion"
    set udg_ArenaMonsterType[$E5]='n0LR' // $E5 = 229; 'n0LR': unit "Black Rabite"
    set udg_ArenaMonsterType[$E6]='U01N' // $E6 = 230; 'U01N': unit "Zombie Dragon"
    set udg_ArenaMonsterType[$E7]='E01J' // $E7 = 231; 'E01J': unit "Warmech"
    set udg_ArenaMonsterType[$E8]='U01Q' // $E8 = 232; 'U01Q': unit "Black Pearl Demon"
    set udg_ArenaMonsterType[$E9]='H02W' // $E9 = 233; 'H02W': unit "Nebra King"
    set udg_ArenaMonsterType[$EA]='E01M' // $EA = 234; 'E01M': unit "Nebra Monstrum"
    set udg_ArenaMonsterType[$EB]='U01S' // $EB = 235; 'U01S': unit "Night's Terror"
    set udg_ArenaMonsterType[$EC]='E00X' // $EC = 236; 'E00X': unit "Black Devil"
    set udg_ArenaMonsterType[$ED]='ndtp' // $ED = 237; 'ndtp': unit "Dark Goblin Shaman"
    set udg_ArenaMonsterType[$EE]='ndth' // $EE = 238; 'ndth': unit "Dark Goblin Great Shaman"
    set udg_ArenaMonsterType[$EF]='n0AZ' // $EF = 239; 'n0AZ': unit "Mephorash"
    set udg_ArenaMonsterType[$F0]='U015' // $F0 = 240; 'U015': unit "Mage of Malice"
    set udg_ArenaMonsterItem[0]='I0FF' // 'I0FF': item "Omega Weapon"
    set udg_ArenaMonsterItem[1]='I046' // 'I046': item "Steel Bladed Sword"
    set udg_ArenaMonsterItem[2]='I049' // 'I049': item "Gunge Lance"
    set udg_ArenaMonsterItem[3]='I047' // 'I047': item "Odin's Helmet"
    set udg_ArenaMonsterItem[4]='I048' // 'I048': item "Odin's Armor"
    set udg_ArenaMonsterItem[5]='I0KU' // 'I0KU': item "Gram"
    set udg_ArenaMonsterItem[6]='I0D3' // 'I0D3': item "Memento Ring E"
    set udg_ArenaMonsterItem[7]='I0KV' // 'I0KV': item "Primordial Armor"
    set udg_ArenaMonsterItem[8]='I0H3' // 'I0H3': item "Left Arm"
    set udg_ArenaMonsterItem[9]='I0H4' // 'I0H4': item "Right Arm"
    set udg_ArenaMonsterItem[$A]='I0HD' // $A = 10; 'I0HD': item "Explosion Sword"
    set udg_ArenaMonsterItem[$B]='I0HE' // $B = 11; 'I0HE': item "Sanguine Sword"
    set udg_ArenaMonsterItem[$C]='I0HF' // $C = 12; 'I0HF': item "Demi Sword"
    set udg_ArenaMonsterItem[$D]='I0IN' // $D = 13; 'I0IN': item "Holy Energy"
    set udg_ArenaMonsterItem[$E]='I0H5' // $E = 14; 'I0H5': item "Dark Energy"
    set udg_ArenaBattleOffer[1]='n091' // 'n091': unit "Arena: Zodiac Vanguard Battle"
    set udg_ArenaBattleOffer[2]='n098' // 'n098': unit "Arena: Grand Legend Battle"
    set udg_ArenaBattleOffer[3]='n09R' // 'n09R': unit "Arena: Planet Protectors Battle"
    set udg_ArenaBattleOffer[49]='n0A1' // 'n0A1': unit "Arena: Treasure Hunters Battle"
    set udg_ArenaBattleOffer[57]='n08V' // 'n08V': unit "Arena: Choco's Honor Battle"
    set udg_ArenaBattleOffer[58]='n08R' // 'n08R': unit "Arena: Bobby Corwen Battle"
    set udg_ArenaBattleOffer[59]='n09Y' // 'n09Y': unit "Arena: Tonberry Battle"
    set udg_ArenaBattleOffer[60]='n08T' // 'n08T': unit "Arena: Cactuar Battle"
    set udg_ArenaBattleOffer[61]='n09I' // 'n09I': unit "Arena: Malboro Battle"
    set udg_ArenaBattleOffer[62]='n097' // 'n097': unit "Arena: Golem Heroes Battle"
    set udg_ArenaBattleOffer[63]='n09M' // 'n09M': unit "Arena: Mutant Collab Battle"
    set udg_ArenaBattleOffer[70]='n09F' // 'n09F': unit "Arena: Kings of Green Battle"
    set udg_ArenaBattleOffer[71]='n09V' // 'n09V': unit "Arena: Sub-Bevelle Guards Battle"
    set udg_ArenaBattleOffer[72]='n0A0' // 'n0A0': unit "Arena: Traitors of Sanubia Battle"
    set udg_ArenaBattleOffer[73]='n09B' // 'n09B': unit "Arena: Horrendous Breath Battle"
    set udg_ArenaBattleOffer[74]='n09G' // 'n09G': unit "Arena: Last Illusion Masters Battle"
    set udg_ArenaBattleOffer[75]='n08X' // 'n08X': unit "Arena: Deadly Karma Battle"
    set udg_ArenaBattleOffer[89]='n08U' // 'n08U': unit "Arena: Cursed Tomb Battle"
    set udg_ArenaBattleOffer[91]='n09C' // 'n09C': unit "Arena: Ice Demon Battle"
    set udg_ArenaBattleOffer[93]='n09X' // 'n09X': unit "Arena: Tidal Wave Battle"
    set udg_ArenaBattleOffer[94]='n095' // 'n095': unit "Arena: Disintegration Battle"
    set udg_ArenaBattleOffer[95]='n08N' // 'n08N': unit "Arena: Anger of the Land Battle"
    set udg_ArenaBattleOffer[96]='n09Z' // 'n09Z': unit "Arena: Tornado Zone Battle"
    set udg_ArenaBattleOffer[97]='n08Q' // 'n08Q': unit "Arena: Top Gang Battle"
    set udg_ArenaBattleOffer[98]='n09K' // 'n09K': unit "Arena: Master Necromancy Battle"
    set udg_ArenaBattleOffer[99]='n08Y' // 'n08Y': unit "Arena: Death Warlock Battle"
    set udg_ArenaBattleOffer['d']='n09P' // 'n09P': unit "Arena: Ogre Patriarch Battle"
    set udg_ArenaBattleOffer['e']='n09E' // 'n09E': unit "Arena: Devil Duo Battle"
    set udg_ArenaBattleOffer['f']='n092' // 'n092': unit "Arena: Demonic Archer Battle"
    set udg_ArenaBattleOffer['g']='n09S' // 'n09S': unit "Arena: Shadow Queen Battle"
    set udg_ArenaBattleOffer['j']='n099' // 'n099': unit "Arena: Greatest Khan Battle"
    set udg_ArenaBattleOffer['m']='n09Q' // 'n09Q': unit "Arena: Planeswalker Battle"
    set udg_ArenaBattleOffer['o']='n08S' // 'n08S': unit "Arena: Brothers Battle"
    set udg_ArenaBattleOffer['p']='n09U' // 'n09U': unit "Arena: Strongest Eidolon Battle"
    set udg_ArenaBattleOffer['q']='n08M' // 'n08M': unit "Arena: Abyssal Wolves Battle"
    set udg_ArenaBattleOffer['r']='n09W' // 'n09W': unit "Arena: Swift Lizards Battle"
    set udg_ArenaBattleOffer['w']='n08O' // 'n08O': unit "Arena: Bahamut's Guards Battle"
    set udg_ArenaBattleOffer['x']='n093' // 'n093': unit "Arena: Der Richter Battle"
    set udg_ArenaBattleOffer['y']='n09O' // 'n09O': unit "Arena: Northern God Battle"
    set udg_ArenaBattleOffer['{']='n09J' // 'n09J': unit "Arena: Master Engineer Battle"
    set udg_ArenaBattleOffer[$7F]='n096' // $7F = 127; 'n096': unit "Arena: Elune's Huntress Battle"
    set udg_ArenaBattleOffer[$86]='n08Z' // $86 = 134; 'n08Z': unit "Arena: Demon Banishers Battle"
    set udg_ArenaBattleOffer[$8C]='n09T' // $8C = 140; 'n09T': unit "Arena: Split Devil Battle"
    set udg_ArenaBattleOffer[$92]='n0A3' // $92 = 146; 'n0A3': unit "Arena: Warring Triad Battle"
    set udg_ArenaBattleOffer[$9A]='n0AT' // $9A = 154; 'n0AT': unit "Arena: Arena Owners Battle"
    set udg_ArenaBattleOffer[$A5]='n0AY' // $A5 = 165; 'n0AY': unit "Arena: Almighty Conflagration Battle"
    set udg_ArenaBattleOffer[$AA]='n0CX' // $AA = 170; 'n0CX': unit "Arena: No Mercy for the Judged Battle"
    set udg_ArenaBattleOffer[$AB]='n0KB' // $AB = 171; 'n0KB': unit "Arena: Outer Plane Envoy Battle"
    set udg_ArenaBattleOffer[$AC]='n0KD' // $AC = 172; 'n0KD': unit "Arena: Light and Darkness Battle"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=LoadIntegerBJ(3,0,udg_GameStateHash)
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call SaveIntegerBJ(GetForLoopIndexA(),1,(GetForLoopIndexA()+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_ArenaCupId=0
    set udg_ArenaBracketSlot[1]=0
    set udg_ArenaShowcaseOn=true
    set udg_CrystalShardCount=0
    set udg_ArenaRank=1
    set udg_ArenaOwnerStreak=1
    set udg_ArenaBonusBattle[0]=1
    set udg_ArenaBonusBattle[1]=$AA // $AA = 170
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_TeamData1_Actions takes nothing returns nothing
    call SaveStringBJ("Zodiac Vanguard",1,1,udg_GameStateHash)
    call SaveIntegerBJ(4,3,1,udg_GameStateHash)
    call SaveIntegerBJ(94,5,1,udg_GameStateHash)
    call SaveIntegerBJ(3,6,1,udg_GameStateHash)
    call SaveIntegerBJ((3+LoadIntegerBJ(2,0,udg_GameStateHash)),7,1,udg_GameStateHash)
    call SaveIntegerBJ((1+LoadIntegerBJ(2,0,udg_GameStateHash)),8,1,udg_GameStateHash)
    call SaveIntegerBJ((2+LoadIntegerBJ(2,0,udg_GameStateHash)),9,1,udg_GameStateHash)
    call SaveIntegerBJ(9,$A,1,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(1,20,1,udg_GameStateHash)
    call SaveStringBJ("Grand Legend",1,2,udg_GameStateHash)
    call SaveIntegerBJ(4,3,2,udg_GameStateHash)
    call SaveIntegerBJ(1,4,2,udg_GameStateHash)
    call SaveIntegerBJ(95,5,2,udg_GameStateHash)
    call SaveIntegerBJ(1,6,2,udg_GameStateHash)
    call SaveIntegerBJ((4+LoadIntegerBJ(2,0,udg_GameStateHash)),7,2,udg_GameStateHash)
    call SaveIntegerBJ(9,$A,2,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Planet Protectors",1,3,udg_GameStateHash)
    call SaveIntegerBJ(4,3,3,udg_GameStateHash)
    call SaveIntegerBJ(1,4,3,udg_GameStateHash)
    call SaveIntegerBJ($96,5,3,udg_GameStateHash) // $96 = 150
    call SaveIntegerBJ(2,6,3,udg_GameStateHash)
    call SaveIntegerBJ((5+LoadIntegerBJ(2,0,udg_GameStateHash)),7,3,udg_GameStateHash)
    call SaveIntegerBJ((4+LoadIntegerBJ(2,0,udg_GameStateHash)),8,3,udg_GameStateHash)
    call SaveStringBJ("Power of Nether",1,4,udg_GameStateHash)
    call SaveIntegerBJ(1,2,4,udg_GameStateHash)
    call SaveIntegerBJ(75,5,4,udg_GameStateHash)
    call SaveIntegerBJ(3,6,4,udg_GameStateHash)
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,4,udg_GameStateHash)
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),8,4,udg_GameStateHash)
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),9,4,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,4,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(9,$B,4,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Twisted Might",1,5,udg_GameStateHash)
    call SaveIntegerBJ(1,2,5,udg_GameStateHash)
    call SaveIntegerBJ(70,5,5,udg_GameStateHash)
    call SaveIntegerBJ(3,6,5,udg_GameStateHash)
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),8,5,udg_GameStateHash)
    call SaveIntegerBJ((8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,5,udg_GameStateHash)
    call SaveIntegerBJ((8+LoadIntegerBJ(2,0,udg_GameStateHash)),9,5,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,5,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(9,$B,5,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Fallen Brave",1,6,udg_GameStateHash)
    call SaveIntegerBJ(1,2,6,udg_GameStateHash)
    call SaveIntegerBJ(85,5,6,udg_GameStateHash)
    call SaveIntegerBJ(1,6,6,udg_GameStateHash)
    call SaveIntegerBJ((6+LoadIntegerBJ(2,0,udg_GameStateHash)),7,6,udg_GameStateHash)
    call SaveIntegerBJ(9,$A,6,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Almighty Shinra",1,7,udg_GameStateHash)
    call SaveIntegerBJ(1,4,7,udg_GameStateHash)
    call SaveIntegerBJ($96,5,7,udg_GameStateHash) // $96 = 150
    call SaveIntegerBJ(1,6,7,udg_GameStateHash)
    call SaveIntegerBJ((9+LoadIntegerBJ(2,0,udg_GameStateHash)),7,7,udg_GameStateHash)
    call SaveStringBJ("Sharp Fangs",1,8,udg_GameStateHash)
    call SaveIntegerBJ(1,2,8,udg_GameStateHash)
    call SaveIntegerBJ(5,5,8,udg_GameStateHash)
    call SaveIntegerBJ(3,6,8,udg_GameStateHash)
    call SaveIntegerBJ((18+LoadIntegerBJ(2,0,udg_GameStateHash)),7,8,udg_GameStateHash)
    call SaveIntegerBJ((19+LoadIntegerBJ(2,0,udg_GameStateHash)),8,8,udg_GameStateHash)
    call SaveIntegerBJ((18+LoadIntegerBJ(2,0,udg_GameStateHash)),9,8,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,8,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Assassin Team",1,9,udg_GameStateHash)
    call SaveIntegerBJ(1,2,9,udg_GameStateHash)
    call SaveIntegerBJ(5,5,9,udg_GameStateHash)
    call SaveIntegerBJ(3,6,9,udg_GameStateHash)
    call SaveIntegerBJ((25+LoadIntegerBJ(2,0,udg_GameStateHash)),8,9,udg_GameStateHash)
    call SaveIntegerBJ((27+LoadIntegerBJ(2,0,udg_GameStateHash)),7,9,udg_GameStateHash)
    call SaveIntegerBJ((27+LoadIntegerBJ(2,0,udg_GameStateHash)),9,9,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,9,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Outlawed",1,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(1,2,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(20,5,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(3,6,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((28+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((26+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((26+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(1,$A,$A,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(3,$B,$A,udg_GameStateHash) // $B = 11; $A = 10
    call SaveStringBJ("Goblin Scouts",1,$B,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(1,2,$B,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(5,5,$B,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(3,6,$B,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(($D+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B,udg_GameStateHash) // $D = 13; $B = 11
    call SaveIntegerBJ(($E+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B,udg_GameStateHash) // $E = 14; $B = 11
    call SaveIntegerBJ(($E+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$B,udg_GameStateHash) // $E = 14; $B = 11
    call SaveIntegerBJ(1,$A,$B,udg_GameStateHash) // $A = 10; $B = 11
    call SaveStringBJ("Goblin Guards",1,$C,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(1,2,$C,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(8,5,$C,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(3,6,$C,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ((16+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$C,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(($F+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$C,udg_GameStateHash) // $F = 15; $C = 12
    call SaveIntegerBJ(($F+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$C,udg_GameStateHash) // $F = 15; $C = 12
    call SaveIntegerBJ(1,$A,$C,udg_GameStateHash) // $A = 10; $C = 12
    call SaveStringBJ("Amphibian Woodsmen",1,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ(1,2,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ(5,5,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ(3,6,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ((24+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ((24+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ((24+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$D,udg_GameStateHash) // $D = 13
    call SaveIntegerBJ(1,$A,$D,udg_GameStateHash) // $A = 10; $D = 13
    call SaveStringBJ("Phobia Companions",1,$E,udg_GameStateHash) // $E = 14
    call SaveIntegerBJ(1,2,$E,udg_GameStateHash) // $E = 14
    call SaveIntegerBJ(5,5,$E,udg_GameStateHash) // $E = 14
    call SaveIntegerBJ(2,6,$E,udg_GameStateHash) // $E = 14
    call SaveIntegerBJ(($C+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$E,udg_GameStateHash) // $C = 12; $E = 14
    call SaveIntegerBJ((17+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$E,udg_GameStateHash) // $E = 14
    call SaveIntegerBJ(1,$A,$E,udg_GameStateHash) // $A = 10; $E = 14
    call SaveStringBJ("Terror Fangs",1,$F,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ(1,2,$F,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ($A,5,$F,udg_GameStateHash) // $A = 10; $F = 15
    call SaveIntegerBJ(3,6,$F,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ((20+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$F,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ((20+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$F,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ((20+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$F,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ(1,$A,$F,udg_GameStateHash) // $A = 10; $F = 15
    call SaveStringBJ("Forest Elite",1,16,udg_GameStateHash)
    call SaveIntegerBJ(1,2,16,udg_GameStateHash)
    call SaveIntegerBJ(9,5,16,udg_GameStateHash)
    call SaveIntegerBJ(3,6,16,udg_GameStateHash)
    call SaveIntegerBJ((21+LoadIntegerBJ(2,0,udg_GameStateHash)),8,16,udg_GameStateHash)
    call SaveIntegerBJ((19+LoadIntegerBJ(2,0,udg_GameStateHash)),7,16,udg_GameStateHash)
    call SaveIntegerBJ((19+LoadIntegerBJ(2,0,udg_GameStateHash)),9,16,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,16,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Monstrous Fangs",1,17,udg_GameStateHash)
    call SaveIntegerBJ(1,2,17,udg_GameStateHash)
    call SaveIntegerBJ($C,5,17,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(3,6,17,udg_GameStateHash)
    call SaveIntegerBJ((22+LoadIntegerBJ(2,0,udg_GameStateHash)),8,17,udg_GameStateHash)
    call SaveIntegerBJ((21+LoadIntegerBJ(2,0,udg_GameStateHash)),7,17,udg_GameStateHash)
    call SaveIntegerBJ((21+LoadIntegerBJ(2,0,udg_GameStateHash)),9,17,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,17,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Blood Fangs",1,18,udg_GameStateHash)
    call SaveIntegerBJ(1,2,18,udg_GameStateHash)
    call SaveIntegerBJ($C,5,18,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(1,6,18,udg_GameStateHash)
    call SaveIntegerBJ((23+LoadIntegerBJ(2,0,udg_GameStateHash)),7,18,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,18,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Infernal Knight",1,19,udg_GameStateHash)
    call SaveIntegerBJ(1,2,19,udg_GameStateHash)
    call SaveIntegerBJ($C,5,19,udg_GameStateHash) // $C = 12
    call SaveIntegerBJ(1,6,19,udg_GameStateHash)
    call SaveIntegerBJ((8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,19,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,19,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Cry of the Feather",1,20,udg_GameStateHash)
    call SaveIntegerBJ(45,5,20,udg_GameStateHash)
    call SaveIntegerBJ(1,6,20,udg_GameStateHash)
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),7,20,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(1,$A,20,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(5,$B,20,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Bug Catchers",1,21,udg_GameStateHash)
    call SaveIntegerBJ(20,5,21,udg_GameStateHash)
    call SaveIntegerBJ(3,6,21,udg_GameStateHash)
    call SaveIntegerBJ((30+LoadIntegerBJ(2,0,udg_GameStateHash)),7,21,udg_GameStateHash)
    call SaveIntegerBJ((30+LoadIntegerBJ(2,0,udg_GameStateHash)),8,21,udg_GameStateHash)
    call SaveIntegerBJ((30+LoadIntegerBJ(2,0,udg_GameStateHash)),9,21,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,21,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Genghis Youth",1,22,udg_GameStateHash)
    call SaveIntegerBJ(1,2,22,udg_GameStateHash)
    call SaveIntegerBJ($F,5,22,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ(3,6,22,udg_GameStateHash)
    call SaveIntegerBJ((31+LoadIntegerBJ(2,0,udg_GameStateHash)),8,22,udg_GameStateHash)
    call SaveIntegerBJ((32+LoadIntegerBJ(2,0,udg_GameStateHash)),7,22,udg_GameStateHash)
    call SaveIntegerBJ((32+LoadIntegerBJ(2,0,udg_GameStateHash)),9,22,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,22,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Axe Rushers",1,23,udg_GameStateHash)
    call SaveIntegerBJ(1,2,23,udg_GameStateHash)
    call SaveIntegerBJ(17,5,23,udg_GameStateHash)
    call SaveIntegerBJ(3,6,23,udg_GameStateHash)
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),7,23,udg_GameStateHash)
    call SaveIntegerBJ((34+LoadIntegerBJ(2,0,udg_GameStateHash)),8,23,udg_GameStateHash)
    call SaveIntegerBJ((35+LoadIntegerBJ(2,0,udg_GameStateHash)),9,23,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,23,udg_GameStateHash) // $A = 10
    call SaveStringBJ("High Volts",1,24,udg_GameStateHash)
    call SaveIntegerBJ(1,2,24,udg_GameStateHash)
    call SaveIntegerBJ(18,5,24,udg_GameStateHash)
    call SaveIntegerBJ(3,6,24,udg_GameStateHash)
    call SaveIntegerBJ((36+LoadIntegerBJ(2,0,udg_GameStateHash)),8,24,udg_GameStateHash)
    call SaveIntegerBJ((37+LoadIntegerBJ(2,0,udg_GameStateHash)),7,24,udg_GameStateHash)
    call SaveIntegerBJ((37+LoadIntegerBJ(2,0,udg_GameStateHash)),9,24,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,24,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Berserker Beasts",1,25,udg_GameStateHash)
    call SaveIntegerBJ(1,2,25,udg_GameStateHash)
    call SaveIntegerBJ(18,5,25,udg_GameStateHash)
    call SaveIntegerBJ(3,6,25,udg_GameStateHash)
    call SaveIntegerBJ((38+LoadIntegerBJ(2,0,udg_GameStateHash)),7,25,udg_GameStateHash)
    call SaveIntegerBJ((39+LoadIntegerBJ(2,0,udg_GameStateHash)),8,25,udg_GameStateHash)
    call SaveIntegerBJ((40+LoadIntegerBJ(2,0,udg_GameStateHash)),9,25,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,25,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Harpy Sisters",1,26,udg_GameStateHash)
    call SaveIntegerBJ(1,2,26,udg_GameStateHash)
    call SaveIntegerBJ($F,5,26,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ(2,6,26,udg_GameStateHash)
    call SaveIntegerBJ((41+LoadIntegerBJ(2,0,udg_GameStateHash)),7,26,udg_GameStateHash)
    call SaveIntegerBJ((42+LoadIntegerBJ(2,0,udg_GameStateHash)),8,26,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,26,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Daughters of Phoenix",1,27,udg_GameStateHash)
    call SaveIntegerBJ(1,2,27,udg_GameStateHash)
    call SaveIntegerBJ(17,5,27,udg_GameStateHash)
    call SaveIntegerBJ(3,6,27,udg_GameStateHash)
    call SaveIntegerBJ((43+LoadIntegerBJ(2,0,udg_GameStateHash)),7,27,udg_GameStateHash)
    call SaveIntegerBJ((44+LoadIntegerBJ(2,0,udg_GameStateHash)),8,27,udg_GameStateHash)
    call SaveIntegerBJ((45+LoadIntegerBJ(2,0,udg_GameStateHash)),9,27,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,27,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Singulari Porci",1,28,udg_GameStateHash)
    call SaveIntegerBJ(1,2,28,udg_GameStateHash)
    call SaveIntegerBJ(16,5,28,udg_GameStateHash)
    call SaveIntegerBJ(3,6,28,udg_GameStateHash)
    call SaveIntegerBJ((46+LoadIntegerBJ(2,0,udg_GameStateHash)),8,28,udg_GameStateHash)
    call SaveIntegerBJ((47+LoadIntegerBJ(2,0,udg_GameStateHash)),7,28,udg_GameStateHash)
    call SaveIntegerBJ((47+LoadIntegerBJ(2,0,udg_GameStateHash)),9,28,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,28,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Chief Piggum",1,29,udg_GameStateHash)
    call SaveIntegerBJ(1,2,29,udg_GameStateHash)
    call SaveIntegerBJ(19,5,29,udg_GameStateHash)
    call SaveIntegerBJ(3,6,29,udg_GameStateHash)
    call SaveIntegerBJ((48+LoadIntegerBJ(2,0,udg_GameStateHash)),8,29,udg_GameStateHash)
    call SaveIntegerBJ((49+LoadIntegerBJ(2,0,udg_GameStateHash)),7,29,udg_GameStateHash)
    call SaveIntegerBJ((49+LoadIntegerBJ(2,0,udg_GameStateHash)),9,29,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,29,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Nimble Thunder",1,30,udg_GameStateHash)
    call SaveIntegerBJ(1,2,30,udg_GameStateHash)
    call SaveIntegerBJ(21,5,30,udg_GameStateHash)
    call SaveIntegerBJ(1,6,30,udg_GameStateHash)
    call SaveIntegerBJ((50+LoadIntegerBJ(2,0,udg_GameStateHash)),7,30,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,30,udg_GameStateHash) // $A = 10
    call SaveStringBJ("No Think Just Hit",1,31,udg_GameStateHash)
    call SaveIntegerBJ(1,2,31,udg_GameStateHash)
    call SaveIntegerBJ(27,5,31,udg_GameStateHash)
    call SaveIntegerBJ(3,6,31,udg_GameStateHash)
    call SaveIntegerBJ((51+LoadIntegerBJ(2,0,udg_GameStateHash)),7,31,udg_GameStateHash)
    call SaveIntegerBJ((51+LoadIntegerBJ(2,0,udg_GameStateHash)),8,31,udg_GameStateHash)
    call SaveIntegerBJ((51+LoadIntegerBJ(2,0,udg_GameStateHash)),9,31,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,31,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Not-So-Brainless",1,32,udg_GameStateHash)
    call SaveIntegerBJ(1,2,32,udg_GameStateHash)
    call SaveIntegerBJ(28,5,32,udg_GameStateHash)
    call SaveIntegerBJ(3,6,32,udg_GameStateHash)
    call SaveIntegerBJ((52+LoadIntegerBJ(2,0,udg_GameStateHash)),8,32,udg_GameStateHash)
    call SaveIntegerBJ((53+LoadIntegerBJ(2,0,udg_GameStateHash)),7,32,udg_GameStateHash)
    call SaveIntegerBJ((53+LoadIntegerBJ(2,0,udg_GameStateHash)),9,32,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,32,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Clan Leaders Joined",1,33,udg_GameStateHash)
    call SaveIntegerBJ(1,2,33,udg_GameStateHash)
    call SaveIntegerBJ(28,5,33,udg_GameStateHash)
    call SaveIntegerBJ(3,6,33,udg_GameStateHash)
    call SaveIntegerBJ((28+LoadIntegerBJ(2,0,udg_GameStateHash)),7,33,udg_GameStateHash)
    call SaveIntegerBJ((28+LoadIntegerBJ(2,0,udg_GameStateHash)),8,33,udg_GameStateHash)
    call SaveIntegerBJ((28+LoadIntegerBJ(2,0,udg_GameStateHash)),9,33,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,33,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Ball on Chain",1,34,udg_GameStateHash)
    call SaveIntegerBJ(1,2,34,udg_GameStateHash)
    call SaveIntegerBJ(25,5,34,udg_GameStateHash)
    call SaveIntegerBJ(3,6,34,udg_GameStateHash)
    call SaveIntegerBJ((54+LoadIntegerBJ(2,0,udg_GameStateHash)),8,34,udg_GameStateHash)
    call SaveIntegerBJ((55+LoadIntegerBJ(2,0,udg_GameStateHash)),7,34,udg_GameStateHash)
    call SaveIntegerBJ((55+LoadIntegerBJ(2,0,udg_GameStateHash)),9,34,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,34,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(4,$B,34,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Brutal Stalkers",1,35,udg_GameStateHash)
    call SaveIntegerBJ(1,2,35,udg_GameStateHash)
    call SaveIntegerBJ(27,5,35,udg_GameStateHash)
    call SaveIntegerBJ(3,6,35,udg_GameStateHash)
    call SaveIntegerBJ((56+LoadIntegerBJ(2,0,udg_GameStateHash)),7,35,udg_GameStateHash)
    call SaveIntegerBJ((56+LoadIntegerBJ(2,0,udg_GameStateHash)),8,35,udg_GameStateHash)
    call SaveIntegerBJ((56+LoadIntegerBJ(2,0,udg_GameStateHash)),9,35,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,35,udg_GameStateHash) // $A = 10
    call SaveStringBJ("The Black Mages",1,36,udg_GameStateHash)
    call SaveIntegerBJ(1,2,36,udg_GameStateHash)
    call SaveIntegerBJ(31,5,36,udg_GameStateHash)
    call SaveIntegerBJ(3,6,36,udg_GameStateHash)
    call SaveIntegerBJ((57+LoadIntegerBJ(2,0,udg_GameStateHash)),7,36,udg_GameStateHash)
    call SaveIntegerBJ((57+LoadIntegerBJ(2,0,udg_GameStateHash)),8,36,udg_GameStateHash)
    call SaveIntegerBJ((57+LoadIntegerBJ(2,0,udg_GameStateHash)),9,36,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,36,udg_GameStateHash) // $A = 10
    call SaveStringBJ("The Black Apprentices",1,37,udg_GameStateHash)
    call SaveIntegerBJ(1,2,37,udg_GameStateHash)
    call SaveIntegerBJ(28,5,37,udg_GameStateHash)
    call SaveIntegerBJ(3,6,37,udg_GameStateHash)
    call SaveIntegerBJ((58+LoadIntegerBJ(2,0,udg_GameStateHash)),8,37,udg_GameStateHash)
    call SaveIntegerBJ((59+LoadIntegerBJ(2,0,udg_GameStateHash)),7,37,udg_GameStateHash)
    call SaveIntegerBJ((59+LoadIntegerBJ(2,0,udg_GameStateHash)),9,37,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,37,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Lowly Acolytes",1,38,udg_GameStateHash)
    call SaveIntegerBJ(1,2,38,udg_GameStateHash)
    call SaveIntegerBJ(26,5,38,udg_GameStateHash)
    call SaveIntegerBJ(3,6,38,udg_GameStateHash)
    call SaveIntegerBJ((60+LoadIntegerBJ(2,0,udg_GameStateHash)),7,38,udg_GameStateHash)
    call SaveIntegerBJ((61+LoadIntegerBJ(2,0,udg_GameStateHash)),8,38,udg_GameStateHash)
    call SaveIntegerBJ((62+LoadIntegerBJ(2,0,udg_GameStateHash)),9,38,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,38,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Spirits of Aqua",1,39,udg_GameStateHash)
    call SaveIntegerBJ(1,2,39,udg_GameStateHash)
    call SaveIntegerBJ(35,5,39,udg_GameStateHash)
    call SaveIntegerBJ(2,6,39,udg_GameStateHash)
    call SaveIntegerBJ((63+LoadIntegerBJ(2,0,udg_GameStateHash)),7,39,udg_GameStateHash)
    call SaveIntegerBJ((64+LoadIntegerBJ(2,0,udg_GameStateHash)),8,39,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,39,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Young Adamant Bros",1,40,udg_GameStateHash)
    call SaveIntegerBJ(1,2,40,udg_GameStateHash)
    call SaveIntegerBJ(40,5,40,udg_GameStateHash)
    call SaveIntegerBJ(2,6,40,udg_GameStateHash)
    call SaveIntegerBJ((65+LoadIntegerBJ(2,0,udg_GameStateHash)),7,40,udg_GameStateHash)
    call SaveIntegerBJ((65+LoadIntegerBJ(2,0,udg_GameStateHash)),8,40,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,40,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Lord of Tortoises",1,41,udg_GameStateHash)
    call SaveIntegerBJ(45,5,41,udg_GameStateHash)
    call SaveIntegerBJ(1,6,41,udg_GameStateHash)
    call SaveIntegerBJ((66+LoadIntegerBJ(2,0,udg_GameStateHash)),7,41,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,41,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Sea Hunters",1,42,udg_GameStateHash)
    call SaveIntegerBJ(1,2,42,udg_GameStateHash)
    call SaveIntegerBJ(43,5,42,udg_GameStateHash)
    call SaveIntegerBJ(3,6,42,udg_GameStateHash)
    call SaveIntegerBJ((67+LoadIntegerBJ(2,0,udg_GameStateHash)),7,42,udg_GameStateHash)
    call SaveIntegerBJ((68+LoadIntegerBJ(2,0,udg_GameStateHash)),8,42,udg_GameStateHash)
    call SaveIntegerBJ((69+LoadIntegerBJ(2,0,udg_GameStateHash)),9,42,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,42,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Hydra Family",1,43,udg_GameStateHash)
    call SaveIntegerBJ(1,2,43,udg_GameStateHash)
    call SaveIntegerBJ(40,5,43,udg_GameStateHash)
    call SaveIntegerBJ(3,6,43,udg_GameStateHash)
    call SaveIntegerBJ((70+LoadIntegerBJ(2,0,udg_GameStateHash)),7,43,udg_GameStateHash)
    call SaveIntegerBJ((70+LoadIntegerBJ(2,0,udg_GameStateHash)),8,43,udg_GameStateHash)
    call SaveIntegerBJ((70+LoadIntegerBJ(2,0,udg_GameStateHash)),9,43,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,43,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Crystal Cutters",1,44,udg_GameStateHash)
    call SaveIntegerBJ(1,2,44,udg_GameStateHash)
    call SaveIntegerBJ(39,5,44,udg_GameStateHash)
    call SaveIntegerBJ(3,6,44,udg_GameStateHash)
    call SaveIntegerBJ((72+LoadIntegerBJ(2,0,udg_GameStateHash)),7,44,udg_GameStateHash)
    call SaveIntegerBJ((73+LoadIntegerBJ(2,0,udg_GameStateHash)),8,44,udg_GameStateHash)
    call SaveIntegerBJ((74+LoadIntegerBJ(2,0,udg_GameStateHash)),9,44,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,44,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Evolved Tritons",1,45,udg_GameStateHash)
    call SaveIntegerBJ(1,2,45,udg_GameStateHash)
    call SaveIntegerBJ(37,5,45,udg_GameStateHash)
    call SaveIntegerBJ(3,6,45,udg_GameStateHash)
    call SaveIntegerBJ((75+LoadIntegerBJ(2,0,udg_GameStateHash)),8,45,udg_GameStateHash)
    call SaveIntegerBJ((76+LoadIntegerBJ(2,0,udg_GameStateHash)),7,45,udg_GameStateHash)
    call SaveIntegerBJ((76+LoadIntegerBJ(2,0,udg_GameStateHash)),9,45,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,45,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Dark Fish Clan",1,46,udg_GameStateHash)
    call SaveIntegerBJ(1,2,46,udg_GameStateHash)
    call SaveIntegerBJ(39,5,46,udg_GameStateHash)
    call SaveIntegerBJ(3,6,46,udg_GameStateHash)
    call SaveIntegerBJ((77+LoadIntegerBJ(2,0,udg_GameStateHash)),7,46,udg_GameStateHash)
    call SaveIntegerBJ((78+LoadIntegerBJ(2,0,udg_GameStateHash)),8,46,udg_GameStateHash)
    call SaveIntegerBJ((79+LoadIntegerBJ(2,0,udg_GameStateHash)),9,46,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,46,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Feared Devastators",1,47,udg_GameStateHash)
    call SaveIntegerBJ(1,2,47,udg_GameStateHash)
    call SaveIntegerBJ(38,5,47,udg_GameStateHash)
    call SaveIntegerBJ(3,6,47,udg_GameStateHash)
    call SaveIntegerBJ((80+LoadIntegerBJ(2,0,udg_GameStateHash)),8,47,udg_GameStateHash)
    call SaveIntegerBJ((81+LoadIntegerBJ(2,0,udg_GameStateHash)),7,47,udg_GameStateHash)
    call SaveIntegerBJ((81+LoadIntegerBJ(2,0,udg_GameStateHash)),9,47,udg_GameStateHash)
    call SaveIntegerBJ(4,$A,47,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Cute Couple",1,48,udg_GameStateHash)
    call SaveIntegerBJ(1,2,48,udg_GameStateHash)
    call SaveIntegerBJ(47,5,48,udg_GameStateHash)
    call SaveIntegerBJ(2,6,48,udg_GameStateHash)
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),7,48,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),8,48,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(5,$A,48,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Treasure Hunters",1,49,udg_GameStateHash)
    call SaveIntegerBJ(1,2,49,udg_GameStateHash)
    call SaveIntegerBJ(1,3,49,udg_GameStateHash)
    call SaveIntegerBJ(49,5,49,udg_GameStateHash)
    call SaveIntegerBJ(3,6,49,udg_GameStateHash)
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),8,49,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),7,49,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),9,49,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(5,$A,49,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Mine Warkers",1,50,udg_GameStateHash)
    call SaveIntegerBJ(1,2,50,udg_GameStateHash)
    call SaveIntegerBJ(50,5,50,udg_GameStateHash)
    call SaveIntegerBJ(3,6,50,udg_GameStateHash)
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),8,50,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((82+LoadIntegerBJ(2,0,udg_GameStateHash)),7,50,udg_GameStateHash)
    call SaveIntegerBJ((82+LoadIntegerBJ(2,0,udg_GameStateHash)),9,50,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,50,udg_GameStateHash) // $A = 10
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_TeamData2_Actions takes nothing returns nothing
    call SaveStringBJ("Uninfectable",1,51,udg_GameStateHash)
    call SaveIntegerBJ(1,2,51,udg_GameStateHash)
    call SaveIntegerBJ(46,5,51,udg_GameStateHash)
    call SaveIntegerBJ(3,6,51,udg_GameStateHash)
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),8,51,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ((83+LoadIntegerBJ(2,0,udg_GameStateHash)),7,51,udg_GameStateHash)
    call SaveIntegerBJ((83+LoadIntegerBJ(2,0,udg_GameStateHash)),9,51,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,51,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Sonic Speed",1,52,udg_GameStateHash)
    call SaveIntegerBJ(1,2,52,udg_GameStateHash)
    call SaveIntegerBJ(50,5,52,udg_GameStateHash)
    call SaveIntegerBJ(3,6,52,udg_GameStateHash)
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),8,52,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((50+LoadIntegerBJ(2,0,udg_GameStateHash)),7,52,udg_GameStateHash)
    call SaveIntegerBJ((50+LoadIntegerBJ(2,0,udg_GameStateHash)),9,52,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,52,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Kwehvasion",1,53,udg_GameStateHash)
    call SaveIntegerBJ(1,2,53,udg_GameStateHash)
    call SaveIntegerBJ(50,5,53,udg_GameStateHash)
    call SaveIntegerBJ(3,6,53,udg_GameStateHash)
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),8,53,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((84+LoadIntegerBJ(2,0,udg_GameStateHash)),7,53,udg_GameStateHash)
    call SaveIntegerBJ((84+LoadIntegerBJ(2,0,udg_GameStateHash)),9,53,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,53,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Elder Tribe",1,54,udg_GameStateHash)
    call SaveIntegerBJ(1,2,54,udg_GameStateHash)
    call SaveIntegerBJ(50,5,54,udg_GameStateHash)
    call SaveIntegerBJ(3,6,54,udg_GameStateHash)
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),8,54,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ((85+LoadIntegerBJ(2,0,udg_GameStateHash)),7,54,udg_GameStateHash)
    call SaveIntegerBJ((86+LoadIntegerBJ(2,0,udg_GameStateHash)),9,54,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,54,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Giant Allies",1,55,udg_GameStateHash)
    call SaveIntegerBJ(1,2,55,udg_GameStateHash)
    call SaveIntegerBJ(51,5,55,udg_GameStateHash)
    call SaveIntegerBJ(3,6,55,udg_GameStateHash)
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),8,55,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ((87+LoadIntegerBJ(2,0,udg_GameStateHash)),7,55,udg_GameStateHash)
    call SaveIntegerBJ((66+LoadIntegerBJ(2,0,udg_GameStateHash)),9,55,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,55,udg_GameStateHash) // $A = 10
    call SaveStringBJ("The Wrong Friends",1,56,udg_GameStateHash)
    call SaveIntegerBJ(1,2,56,udg_GameStateHash)
    call SaveIntegerBJ(49,5,56,udg_GameStateHash)
    call SaveIntegerBJ(3,6,56,udg_GameStateHash)
    call SaveIntegerBJ(($A+LoadIntegerBJ(2,0,udg_GameStateHash)),8,56,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,56,udg_GameStateHash)
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),9,56,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,56,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Choco's Honor",1,57,udg_GameStateHash)
    call SaveIntegerBJ(1,3,57,udg_GameStateHash)
    call SaveIntegerBJ(54,5,57,udg_GameStateHash)
    call SaveIntegerBJ(3,6,57,udg_GameStateHash)
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),7,57,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),8,57,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(($B+LoadIntegerBJ(2,0,udg_GameStateHash)),9,57,udg_GameStateHash) // $B = 11
    call SaveIntegerBJ(5,$A,57,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Bobby Corwen",1,58,udg_GameStateHash)
    call SaveIntegerBJ(1,3,58,udg_GameStateHash)
    call SaveIntegerBJ(1,4,58,udg_GameStateHash)
    call SaveIntegerBJ(60,5,58,udg_GameStateHash)
    call SaveIntegerBJ(1,6,58,udg_GameStateHash)
    call SaveIntegerBJ((88+LoadIntegerBJ(2,0,udg_GameStateHash)),7,58,udg_GameStateHash)
    call SaveIntegerBJ(5,$A,58,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Tonberry",1,59,udg_GameStateHash)
    call SaveIntegerBJ(1,2,59,udg_GameStateHash)
    call SaveIntegerBJ(2,3,59,udg_GameStateHash)
    call SaveIntegerBJ(60,5,59,udg_GameStateHash)
    call SaveIntegerBJ(1,6,59,udg_GameStateHash)
    call SaveIntegerBJ((89+LoadIntegerBJ(2,0,udg_GameStateHash)),7,59,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,59,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Cactuar",1,60,udg_GameStateHash)
    call SaveIntegerBJ(1,2,60,udg_GameStateHash)
    call SaveIntegerBJ(2,3,60,udg_GameStateHash)
    call SaveIntegerBJ(59,5,60,udg_GameStateHash)
    call SaveIntegerBJ(1,6,60,udg_GameStateHash)
    call SaveIntegerBJ((90+LoadIntegerBJ(2,0,udg_GameStateHash)),7,60,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,60,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Malboro",1,61,udg_GameStateHash)
    call SaveIntegerBJ(1,2,61,udg_GameStateHash)
    call SaveIntegerBJ(2,3,61,udg_GameStateHash)
    call SaveIntegerBJ(58,5,61,udg_GameStateHash)
    call SaveIntegerBJ(1,6,61,udg_GameStateHash)
    call SaveIntegerBJ((91+LoadIntegerBJ(2,0,udg_GameStateHash)),7,61,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,61,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Golem Heroes",1,62,udg_GameStateHash)
    call SaveIntegerBJ(1,2,62,udg_GameStateHash)
    call SaveIntegerBJ(2,3,62,udg_GameStateHash)
    call SaveIntegerBJ(57,5,62,udg_GameStateHash)
    call SaveIntegerBJ(3,6,62,udg_GameStateHash)
    call SaveIntegerBJ((92+LoadIntegerBJ(2,0,udg_GameStateHash)),7,62,udg_GameStateHash)
    call SaveIntegerBJ((82+LoadIntegerBJ(2,0,udg_GameStateHash)),8,62,udg_GameStateHash)
    call SaveIntegerBJ((93+LoadIntegerBJ(2,0,udg_GameStateHash)),9,62,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,62,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Mutant Collab",1,63,udg_GameStateHash)
    call SaveIntegerBJ(1,2,63,udg_GameStateHash)
    call SaveIntegerBJ(2,3,63,udg_GameStateHash)
    call SaveIntegerBJ(57,5,63,udg_GameStateHash)
    call SaveIntegerBJ(3,6,63,udg_GameStateHash)
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),7,63,udg_GameStateHash)
    call SaveIntegerBJ((85+LoadIntegerBJ(2,0,udg_GameStateHash)),8,63,udg_GameStateHash)
    call SaveIntegerBJ((87+LoadIntegerBJ(2,0,udg_GameStateHash)),9,63,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,63,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Straight From Archylte",1,64,udg_GameStateHash)
    call SaveIntegerBJ(1,2,64,udg_GameStateHash)
    call SaveIntegerBJ(56,5,64,udg_GameStateHash)
    call SaveIntegerBJ(3,6,64,udg_GameStateHash)
    call SaveIntegerBJ((66+LoadIntegerBJ(2,0,udg_GameStateHash)),7,64,udg_GameStateHash)
    call SaveIntegerBJ((66+LoadIntegerBJ(2,0,udg_GameStateHash)),8,64,udg_GameStateHash)
    call SaveIntegerBJ((66+LoadIntegerBJ(2,0,udg_GameStateHash)),9,64,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,64,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Storm, Earth and Fire",1,65,udg_GameStateHash)
    call SaveIntegerBJ(1,2,65,udg_GameStateHash)
    call SaveIntegerBJ(55,5,65,udg_GameStateHash)
    call SaveIntegerBJ(3,6,65,udg_GameStateHash)
    call SaveIntegerBJ((66+LoadIntegerBJ(2,0,udg_GameStateHash)),7,65,udg_GameStateHash)
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),8,65,udg_GameStateHash)
    call SaveIntegerBJ((93+LoadIntegerBJ(2,0,udg_GameStateHash)),9,65,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,65,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Odyne Bangled",1,66,udg_GameStateHash)
    call SaveIntegerBJ(1,2,66,udg_GameStateHash)
    call SaveIntegerBJ(55,5,66,udg_GameStateHash)
    call SaveIntegerBJ(2,6,66,udg_GameStateHash)
    call SaveIntegerBJ((92+LoadIntegerBJ(2,0,udg_GameStateHash)),7,66,udg_GameStateHash)
    call SaveIntegerBJ((85+LoadIntegerBJ(2,0,udg_GameStateHash)),8,66,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,66,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Piercers",1,67,udg_GameStateHash)
    call SaveIntegerBJ(60,5,67,udg_GameStateHash)
    call SaveIntegerBJ(2,6,67,udg_GameStateHash)
    call SaveIntegerBJ((89+LoadIntegerBJ(2,0,udg_GameStateHash)),7,67,udg_GameStateHash)
    call SaveIntegerBJ((90+LoadIntegerBJ(2,0,udg_GameStateHash)),8,67,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,67,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Slow But Powerful",1,68,udg_GameStateHash)
    call SaveIntegerBJ(60,5,68,udg_GameStateHash)
    call SaveIntegerBJ(2,6,68,udg_GameStateHash)
    call SaveIntegerBJ((89+LoadIntegerBJ(2,0,udg_GameStateHash)),7,68,udg_GameStateHash)
    call SaveIntegerBJ((91+LoadIntegerBJ(2,0,udg_GameStateHash)),8,68,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,68,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Tainted Needles",1,69,udg_GameStateHash)
    call SaveIntegerBJ(60,5,69,udg_GameStateHash)
    call SaveIntegerBJ(2,6,69,udg_GameStateHash)
    call SaveIntegerBJ((90+LoadIntegerBJ(2,0,udg_GameStateHash)),7,69,udg_GameStateHash)
    call SaveIntegerBJ((91+LoadIntegerBJ(2,0,udg_GameStateHash)),8,69,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,69,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Kings of Green",1,70,udg_GameStateHash)
    call SaveIntegerBJ(2,3,70,udg_GameStateHash)
    call SaveIntegerBJ(62,5,70,udg_GameStateHash)
    call SaveIntegerBJ(3,6,70,udg_GameStateHash)
    call SaveIntegerBJ((89+LoadIntegerBJ(2,0,udg_GameStateHash)),8,70,udg_GameStateHash)
    call SaveIntegerBJ((90+LoadIntegerBJ(2,0,udg_GameStateHash)),7,70,udg_GameStateHash)
    call SaveIntegerBJ((91+LoadIntegerBJ(2,0,udg_GameStateHash)),9,70,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,70,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Sub-Bevelle Guards",1,71,udg_GameStateHash)
    call SaveIntegerBJ(2,3,71,udg_GameStateHash)
    call SaveIntegerBJ(68,5,71,udg_GameStateHash)
    call SaveIntegerBJ(2,6,71,udg_GameStateHash)
    call SaveIntegerBJ((95+LoadIntegerBJ(2,0,udg_GameStateHash)),7,71,udg_GameStateHash)
    call SaveIntegerBJ((89+LoadIntegerBJ(2,0,udg_GameStateHash)),8,71,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,71,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Traitors of Sanubia",1,72,udg_GameStateHash)
    call SaveIntegerBJ(2,3,72,udg_GameStateHash)
    call SaveIntegerBJ(65,5,72,udg_GameStateHash)
    call SaveIntegerBJ(3,6,72,udg_GameStateHash)
    call SaveIntegerBJ((96+LoadIntegerBJ(2,0,udg_GameStateHash)),8,72,udg_GameStateHash)
    call SaveIntegerBJ((90+LoadIntegerBJ(2,0,udg_GameStateHash)),7,72,udg_GameStateHash)
    call SaveIntegerBJ((90+LoadIntegerBJ(2,0,udg_GameStateHash)),9,72,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,72,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Horrendous Breath",1,73,udg_GameStateHash)
    call SaveIntegerBJ(2,3,73,udg_GameStateHash)
    call SaveIntegerBJ(64,5,73,udg_GameStateHash)
    call SaveIntegerBJ(1,6,73,udg_GameStateHash)
    call SaveIntegerBJ((97+LoadIntegerBJ(2,0,udg_GameStateHash)),7,73,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,73,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Last Illusion Masters",1,74,udg_GameStateHash)
    call SaveIntegerBJ(2,3,74,udg_GameStateHash)
    call SaveIntegerBJ(1,4,74,udg_GameStateHash)
    call SaveIntegerBJ(70,5,74,udg_GameStateHash)
    call SaveIntegerBJ(3,6,74,udg_GameStateHash)
    call SaveIntegerBJ((95+LoadIntegerBJ(2,0,udg_GameStateHash)),7,74,udg_GameStateHash)
    call SaveIntegerBJ((96+LoadIntegerBJ(2,0,udg_GameStateHash)),8,74,udg_GameStateHash)
    call SaveIntegerBJ((97+LoadIntegerBJ(2,0,udg_GameStateHash)),9,74,udg_GameStateHash)
    call SaveIntegerBJ(6,$A,74,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ($A,$B,74,udg_GameStateHash) // $A = 10; $B = 11
    call SaveStringBJ("Deadly Karma",1,75,udg_GameStateHash)
    call SaveIntegerBJ(2,3,75,udg_GameStateHash)
    call SaveIntegerBJ(1,4,75,udg_GameStateHash)
    call SaveIntegerBJ('d',5,75,udg_GameStateHash)
    call SaveIntegerBJ(3,6,75,udg_GameStateHash)
    call SaveIntegerBJ((95+LoadIntegerBJ(2,0,udg_GameStateHash)),7,75,udg_GameStateHash)
    call SaveIntegerBJ((95+LoadIntegerBJ(2,0,udg_GameStateHash)),8,75,udg_GameStateHash)
    call SaveIntegerBJ((95+LoadIntegerBJ(2,0,udg_GameStateHash)),9,75,udg_GameStateHash)
    call SaveIntegerBJ($A,$A,75,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Evil Sorcery",1,76,udg_GameStateHash)
    call SaveIntegerBJ(1,2,76,udg_GameStateHash)
    call SaveIntegerBJ(67,5,76,udg_GameStateHash)
    call SaveIntegerBJ(3,6,76,udg_GameStateHash)
    call SaveIntegerBJ((98+LoadIntegerBJ(2,0,udg_GameStateHash)),7,76,udg_GameStateHash)
    call SaveIntegerBJ((99+LoadIntegerBJ(2,0,udg_GameStateHash)),8,76,udg_GameStateHash)
    call SaveIntegerBJ(('d'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,76,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,76,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Unsaveable",1,77,udg_GameStateHash)
    call SaveIntegerBJ(1,2,77,udg_GameStateHash)
    call SaveIntegerBJ(69,5,77,udg_GameStateHash)
    call SaveIntegerBJ(3,6,77,udg_GameStateHash)
    call SaveIntegerBJ(('e'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,77,udg_GameStateHash)
    call SaveIntegerBJ(('f'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,77,udg_GameStateHash)
    call SaveIntegerBJ((98+LoadIntegerBJ(2,0,udg_GameStateHash)),9,77,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,77,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Ancients of Pollution",1,78,udg_GameStateHash)
    call SaveIntegerBJ(1,2,78,udg_GameStateHash)
    call SaveIntegerBJ(67,5,78,udg_GameStateHash)
    call SaveIntegerBJ(3,6,78,udg_GameStateHash)
    call SaveIntegerBJ(('g'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,78,udg_GameStateHash)
    call SaveIntegerBJ(('h'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,78,udg_GameStateHash)
    call SaveIntegerBJ(('h'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,78,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,78,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Confusion",1,79,udg_GameStateHash)
    call SaveIntegerBJ(1,2,79,udg_GameStateHash)
    call SaveIntegerBJ(71,5,79,udg_GameStateHash)
    call SaveIntegerBJ(3,6,79,udg_GameStateHash)
    call SaveIntegerBJ(('i'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,79,udg_GameStateHash)
    call SaveIntegerBJ(('g'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,79,udg_GameStateHash)
    call SaveIntegerBJ(('g'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,79,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,79,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Is That Edible",1,80,udg_GameStateHash)
    call SaveIntegerBJ(1,2,80,udg_GameStateHash)
    call SaveIntegerBJ(68,5,80,udg_GameStateHash)
    call SaveIntegerBJ(2,6,80,udg_GameStateHash)
    call SaveIntegerBJ(('j'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,80,udg_GameStateHash)
    call SaveIntegerBJ(('k'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,80,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,80,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Mutated Trees",1,81,udg_GameStateHash)
    call SaveIntegerBJ(1,2,81,udg_GameStateHash)
    call SaveIntegerBJ(69,5,81,udg_GameStateHash)
    call SaveIntegerBJ(3,6,81,udg_GameStateHash)
    call SaveIntegerBJ(('l'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,81,udg_GameStateHash)
    call SaveIntegerBJ(('m'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,81,udg_GameStateHash)
    call SaveIntegerBJ(('n'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,81,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,81,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Grand Satyr",1,82,udg_GameStateHash)
    call SaveIntegerBJ(1,2,82,udg_GameStateHash)
    call SaveIntegerBJ(70,5,82,udg_GameStateHash)
    call SaveIntegerBJ(1,6,82,udg_GameStateHash)
    call SaveIntegerBJ((85+LoadIntegerBJ(2,0,udg_GameStateHash)),7,82,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,82,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Little Fishmen",1,83,udg_GameStateHash)
    call SaveIntegerBJ(1,2,83,udg_GameStateHash)
    call SaveIntegerBJ(63,5,83,udg_GameStateHash)
    call SaveIntegerBJ(3,6,83,udg_GameStateHash)
    call SaveIntegerBJ(('p'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,83,udg_GameStateHash)
    call SaveIntegerBJ(('q'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,83,udg_GameStateHash)
    call SaveIntegerBJ(('q'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,83,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,83,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Flying Dutchman",1,84,udg_GameStateHash)
    call SaveIntegerBJ(1,2,84,udg_GameStateHash)
    call SaveIntegerBJ(67,5,84,udg_GameStateHash)
    call SaveIntegerBJ(2,6,84,udg_GameStateHash)
    call SaveIntegerBJ(('r'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,84,udg_GameStateHash)
    call SaveIntegerBJ(('s'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,84,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,84,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Naga Special Forces",1,85,udg_GameStateHash)
    call SaveIntegerBJ(1,2,85,udg_GameStateHash)
    call SaveIntegerBJ(72,5,85,udg_GameStateHash)
    call SaveIntegerBJ(3,6,85,udg_GameStateHash)
    call SaveIntegerBJ(('t'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,85,udg_GameStateHash)
    call SaveIntegerBJ(('u'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,85,udg_GameStateHash)
    call SaveIntegerBJ(('u'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,85,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,85,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Lower Quezadamants",1,86,udg_GameStateHash)
    call SaveIntegerBJ(1,2,86,udg_GameStateHash)
    call SaveIntegerBJ(68,5,86,udg_GameStateHash)
    call SaveIntegerBJ(3,6,86,udg_GameStateHash)
    call SaveIntegerBJ(('v'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,86,udg_GameStateHash)
    call SaveIntegerBJ(('w'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,86,udg_GameStateHash)
    call SaveIntegerBJ(('w'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,86,udg_GameStateHash)
    call SaveIntegerBJ(7,$A,86,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Zodiark's Legacy",1,87,udg_GameStateHash)
    call SaveIntegerBJ(1,2,87,udg_GameStateHash)
    call SaveIntegerBJ(85,5,87,udg_GameStateHash)
    call SaveIntegerBJ(3,6,87,udg_GameStateHash)
    call SaveIntegerBJ(('x'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,87,udg_GameStateHash)
    call SaveIntegerBJ(('y'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,87,udg_GameStateHash)
    call SaveIntegerBJ(('y'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,87,udg_GameStateHash)
    call SaveIntegerBJ(9,$A,87,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Glory For Tiamat",1,88,udg_GameStateHash)
    call SaveIntegerBJ(1,2,88,udg_GameStateHash)
    call SaveIntegerBJ(85,5,88,udg_GameStateHash)
    call SaveIntegerBJ(3,6,88,udg_GameStateHash)
    call SaveIntegerBJ(('z'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,88,udg_GameStateHash)
    call SaveIntegerBJ(('{'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,88,udg_GameStateHash)
    call SaveIntegerBJ(('{'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,88,udg_GameStateHash)
    call SaveIntegerBJ(9,$A,88,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Cursed Tomb",1,89,udg_GameStateHash)
    call SaveIntegerBJ(1,3,89,udg_GameStateHash)
    call SaveIntegerBJ(86,5,89,udg_GameStateHash)
    call SaveIntegerBJ(3,6,89,udg_GameStateHash)
    call SaveIntegerBJ(('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,89,udg_GameStateHash)
    call SaveIntegerBJ(('|'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,89,udg_GameStateHash)
    call SaveIntegerBJ(('|'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,89,udg_GameStateHash)
    call SaveIntegerBJ(3,$A,89,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(9,$B,89,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Shadow Wizards United",1,90,udg_GameStateHash)
    call SaveIntegerBJ(1,2,90,udg_GameStateHash)
    call SaveIntegerBJ(88,5,90,udg_GameStateHash)
    call SaveIntegerBJ(2,6,90,udg_GameStateHash)
    call SaveIntegerBJ(($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),7,90,udg_GameStateHash) // $7E = 126
    call SaveIntegerBJ(($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),8,90,udg_GameStateHash) // $7F = 127
    call SaveIntegerBJ(3,$A,90,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Ice Demon",1,91,udg_GameStateHash)
    call SaveIntegerBJ(4,3,91,udg_GameStateHash)
    call SaveIntegerBJ(1,4,91,udg_GameStateHash)
    call SaveIntegerBJ(94,5,91,udg_GameStateHash)
    call SaveIntegerBJ(1,6,91,udg_GameStateHash)
    call SaveIntegerBJ(($80+LoadIntegerBJ(2,0,udg_GameStateHash)),7,91,udg_GameStateHash) // $80 = 128
    call SaveIntegerBJ(9,$A,91,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Death Seraph",1,92,udg_GameStateHash)
    call SaveIntegerBJ(91,5,92,udg_GameStateHash)
    call SaveIntegerBJ(2,6,92,udg_GameStateHash)
    call SaveIntegerBJ((3+LoadIntegerBJ(2,0,udg_GameStateHash)),7,92,udg_GameStateHash)
    call SaveIntegerBJ(($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),8,92,udg_GameStateHash) // $D1 = 209
    call SaveIntegerBJ(9,$A,92,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(1,20,92,udg_GameStateHash)
    call SaveStringBJ("Tidal Wave",1,93,udg_GameStateHash)
    call SaveIntegerBJ(3,3,93,udg_GameStateHash)
    call SaveIntegerBJ(80,5,93,udg_GameStateHash)
    call SaveIntegerBJ(1,6,93,udg_GameStateHash)
    call SaveIntegerBJ(($81+LoadIntegerBJ(2,0,udg_GameStateHash)),7,93,udg_GameStateHash) // $81 = 129
    call SaveIntegerBJ(8,$A,93,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Disintegration",1,94,udg_GameStateHash)
    call SaveIntegerBJ(3,3,94,udg_GameStateHash)
    call SaveIntegerBJ(79,5,94,udg_GameStateHash)
    call SaveIntegerBJ(1,6,94,udg_GameStateHash)
    call SaveIntegerBJ(($82+LoadIntegerBJ(2,0,udg_GameStateHash)),7,94,udg_GameStateHash) // $82 = 130
    call SaveIntegerBJ(8,$A,94,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Anger of the Land",1,95,udg_GameStateHash)
    call SaveIntegerBJ(3,3,95,udg_GameStateHash)
    call SaveIntegerBJ(78,5,95,udg_GameStateHash)
    call SaveIntegerBJ(1,6,95,udg_GameStateHash)
    call SaveIntegerBJ(($83+LoadIntegerBJ(2,0,udg_GameStateHash)),7,95,udg_GameStateHash) // $83 = 131
    call SaveIntegerBJ(8,$A,95,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Tornado Zone",1,96,udg_GameStateHash)
    call SaveIntegerBJ(3,3,96,udg_GameStateHash)
    call SaveIntegerBJ(77,5,96,udg_GameStateHash)
    call SaveIntegerBJ(1,6,96,udg_GameStateHash)
    call SaveIntegerBJ(($84+LoadIntegerBJ(2,0,udg_GameStateHash)),7,96,udg_GameStateHash) // $84 = 132
    call SaveIntegerBJ(8,$A,96,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Top Gang",1,97,udg_GameStateHash)
    call SaveIntegerBJ(1,3,97,udg_GameStateHash)
    call SaveIntegerBJ($E,5,97,udg_GameStateHash) // $E = 14
    call SaveIntegerBJ(3,6,97,udg_GameStateHash)
    call SaveIntegerBJ(('o'+LoadIntegerBJ(2,0,udg_GameStateHash)),8,97,udg_GameStateHash)
    call SaveIntegerBJ(($ED+LoadIntegerBJ(2,0,udg_GameStateHash)),7,97,udg_GameStateHash) // $ED = 237
    call SaveIntegerBJ(($ED+LoadIntegerBJ(2,0,udg_GameStateHash)),9,97,udg_GameStateHash) // $ED = 237
    call SaveIntegerBJ(1,$A,97,udg_GameStateHash) // $A = 10
    call SaveStringBJ("Master Necromancy",1,98,udg_GameStateHash)
    call SaveIntegerBJ(1,3,98,udg_GameStateHash)
    call SaveIntegerBJ($F,5,98,udg_GameStateHash) // $F = 15
    call SaveIntegerBJ(3,6,98,udg_GameStateHash)
    call SaveIntegerBJ(($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),8,98,udg_GameStateHash) // $7E = 126
    call SaveIntegerBJ((83+LoadIntegerBJ(2,0,udg_GameStateHash)),7,98,udg_GameStateHash)
    call SaveIntegerBJ((83+LoadIntegerBJ(2,0,udg_GameStateHash)),9,98,udg_GameStateHash)
    call SaveIntegerBJ(1,$A,98,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(3,$B,98,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Death Warlock",1,99,udg_GameStateHash)
    call SaveIntegerBJ(1,3,99,udg_GameStateHash)
    call SaveIntegerBJ(24,5,99,udg_GameStateHash)
    call SaveIntegerBJ(3,6,99,udg_GameStateHash)
    call SaveIntegerBJ(($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),8,99,udg_GameStateHash) // $7F = 127
    call SaveIntegerBJ((83+LoadIntegerBJ(2,0,udg_GameStateHash)),7,99,udg_GameStateHash)
    call SaveIntegerBJ((83+LoadIntegerBJ(2,0,udg_GameStateHash)),9,99,udg_GameStateHash)
    call SaveIntegerBJ(2,$A,99,udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(3,$B,99,udg_GameStateHash) // $B = 11
    call SaveStringBJ("Ogre Patriarch",1,'d',udg_GameStateHash)
    call SaveIntegerBJ(1,3,'d',udg_GameStateHash)
    call SaveIntegerBJ(34,5,'d',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'d',udg_GameStateHash)
    call SaveIntegerBJ((71+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'d',udg_GameStateHash)
    call SaveIntegerBJ((52+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'d',udg_GameStateHash)
    call SaveIntegerBJ((53+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'d',udg_GameStateHash)
    call SaveIntegerBJ(3,$A,'d',udg_GameStateHash) // $A = 10
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Arena_TeamData takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2 (module Arena),
// which keeps the original registration order.

function Register_Arena_InitData takes nothing returns nothing
    set gg_trg_Arena_InitData=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_InitData,4.)
    call TriggerAddAction(gg_trg_Arena_InitData,function Trig_Arena_InitData_Actions)
endfunction

function Register_Arena_TeamData1 takes nothing returns nothing
    set gg_trg_Arena_TeamData1=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_TeamData1,4.)
    call TriggerAddAction(gg_trg_Arena_TeamData1,function Trig_Arena_TeamData1_Actions)
endfunction

function Register_Arena_TeamData2 takes nothing returns nothing
    set gg_trg_Arena_TeamData2=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_TeamData2,4.)
    call TriggerAddAction(gg_trg_Arena_TeamData2,function Trig_Arena_TeamData2_Actions)
endfunction

endlibrary

library TMonsterData
function Trig_MonsterData_Init_1_Actions takes nothing returns nothing
    call InitHashtableBJ()
    set udg_MonsterDataHash=GetLastCreatedHashtableBJ()
    call InitHashtableBJ()
    set udg_DropItemHash=GetLastCreatedHashtableBJ()
    set udg_LevelItemIdTable[1]='gold' // 'gold': item "50 Gold Coins"
    set udg_LevelItemIdTable[2]='I004' // 'I004': item "100 Gold Coins"
    set udg_LevelItemIdTable[3]='I005' // 'I005': item "150 Gold Coins"
    set udg_LevelItemIdTable[4]='I003' // 'I003': item "200 Gold Coins"
    set udg_LevelItemIdTable[5]='I006' // 'I006': item "250 Gold Coins"
    set udg_LevelItemIdTable[6]='I00X' // 'I00X': item "500 Gold Coins"
    set udg_LevelItemIdTable[7]='I00Y' // 'I00Y': item "1000 Gold Coins"
    set udg_LevelItemIdTable[8]='I021' // 'I021': item "1500 Gold Coins"
    set udg_LevelItemIdTable[9]='I0JQ' // 'I0JQ': item "2500 Gold Coins"
    set udg_LevelItemIdTable[$A]='I0JS' // $A = 10; 'I0JS': item "5000 Gold Coins"
    set udg_LevelItemIdTable[$B]='I0CV' // $B = 11; 'I0CV': item "10000 Gold Coins"
    set udg_LevelItemIdTable[$C]='I01Z' // $C = 12; 'I01Z': item "Crystal Shard"
    set udg_MonsterTypeID='nftr' // 'nftr': unit "Forest Goblin"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EF,2,udg_TempInteger,udg_MonsterDataHash) // $3EF = 1007
    call SaveIntegerBJ(21,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D1,4,udg_TempInteger,udg_MonsterDataHash) // $7D1 = 2001
    set udg_MonsterTypeID='nmrl' // 'nmrl': unit "Forest Triton"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3E9,2,udg_TempInteger,udg_MonsterDataHash) // $3E9 = 1001
    call SaveIntegerBJ($7D2,3,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ(57,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='ngnb' // 'ngnb': unit "Forest Gnoll"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D1,2,udg_TempInteger,udg_MonsterDataHash) // $7D1 = 2001
    call SaveIntegerBJ($3EF,3,udg_TempInteger,udg_MonsterDataHash) // $3EF = 1007
    call SaveIntegerBJ($7D2,4,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    set udg_MonsterTypeID='nspg' // 'nspg': editor label "Forest Spider"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(4,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(23,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D1,3,udg_TempInteger,udg_MonsterDataHash) // $7D1 = 2001
    call SaveIntegerBJ($7D2,4,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    set udg_MonsterTypeID='nwlt' // 'nwlt': unit "Forest Wolf"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(61,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D1,3,udg_TempInteger,udg_MonsterDataHash) // $7D1 = 2001
    call SaveIntegerBJ($3EC,4,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    set udg_MonsterTypeID='nftt' // 'nftt': unit "Forest Goblin Trapper"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D1,3,udg_TempInteger,udg_MonsterDataHash) // $7D1 = 2001
    call SaveIntegerBJ($3EF,4,udg_TempInteger,udg_MonsterDataHash) // $3EF = 1007
    set udg_MonsterTypeID='nfsp' // 'nfsp': unit "Forest Goblin Shaman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(20,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3E9,4,udg_TempInteger,udg_MonsterDataHash) // $3E9 = 1001
    set udg_MonsterTypeID='nftb' // 'nftb': unit "Forest Goblin Berserker"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EF,3,udg_TempInteger,udg_MonsterDataHash) // $3EF = 1007
    call SaveIntegerBJ($3EC,4,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    set udg_MonsterTypeID='nfsh' // 'nfsh': unit "Forest Goblin Great Shaman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(20,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,4,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    set udg_MonsterTypeID='ncea' // 'ncea': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($420,4,udg_TempInteger,udg_MonsterDataHash) // $420 = 1056
    set udg_MonsterTypeID='ncer' // 'ncer': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($420,4,udg_TempInteger,udg_MonsterDataHash) // $420 = 1056
    set udg_MonsterTypeID='ncim' // 'ncim': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($41A,4,udg_TempInteger,udg_MonsterDataHash) // $41A = 1050
    set udg_MonsterTypeID='ncen' // 'ncen': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($41A,4,udg_TempInteger,udg_MonsterDataHash) // $41A = 1050
    set udg_MonsterTypeID='ncks' // 'ncks': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,3,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($416,4,udg_TempInteger,udg_MonsterDataHash) // $416 = 1046
    set udg_MonsterTypeID='ncnk' // 'ncnk': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($413,4,udg_TempInteger,udg_MonsterDataHash) // $413 = 1043
    set udg_MonsterTypeID='n0MN' // 'n0MN': unit "Centaur Berserker"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(6,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($413,4,udg_TempInteger,udg_MonsterDataHash) // $413 = 1043
    set udg_MonsterTypeID='nltl' // 'nltl': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(7,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,3,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nthl' // 'nthl': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(7,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,3,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nstw' // 'nstw': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(7,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ(95,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nrzt' // 'nrzt': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(8,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($4BF,4,udg_TempInteger,udg_MonsterDataHash) // $4BF = 1215
    set udg_MonsterTypeID='nrzs' // 'nrzs': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(8,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($4BF,4,udg_TempInteger,udg_MonsterDataHash) // $4BF = 1215
    set udg_MonsterTypeID='nqbh' // 'nqbh': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(8,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($4BF,4,udg_TempInteger,udg_MonsterDataHash) // $4BF = 1215
    set udg_MonsterTypeID='nrzb' // 'nrzb': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(8,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($40B,4,udg_TempInteger,udg_MonsterDataHash) // $40B = 1035
    set udg_MonsterTypeID='nrzm' // 'nrzm': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(8,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,3,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($416,4,udg_TempInteger,udg_MonsterDataHash) // $416 = 1046
    set udg_MonsterTypeID='nrzg' // 'nrzg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(8,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($40B,4,udg_TempInteger,udg_MonsterDataHash) // $40B = 1035
    set udg_MonsterTypeID='nowb' // 'nowb': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(9,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D3,3,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ($400,4,udg_TempInteger,udg_MonsterDataHash) // $400 = 1024
    set udg_MonsterTypeID='nowe' // 'nowe': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(9,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,3,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($400,4,udg_TempInteger,udg_MonsterDataHash) // $400 = 1024
    set udg_MonsterTypeID='nowk' // 'nowk': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(9,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($400,4,udg_TempInteger,udg_MonsterDataHash) // $400 = 1024
    set udg_MonsterTypeID='nhar' // 'nhar': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EE,3,udg_TempInteger,udg_MonsterDataHash) // $3EE = 1006
    call SaveIntegerBJ($3FF,4,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    set udg_MonsterTypeID='nhrr' // 'nhrr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EE,3,udg_TempInteger,udg_MonsterDataHash) // $3EE = 1006
    call SaveIntegerBJ($3FF,4,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    set udg_MonsterTypeID='nhrw' // 'nhrw': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($4A3,3,udg_TempInteger,udg_MonsterDataHash) // $4A3 = 1187
    call SaveIntegerBJ($444,4,udg_TempInteger,udg_MonsterDataHash) // $444 = 1092
    set udg_MonsterTypeID='nhrh' // 'nhrh': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EE,3,udg_TempInteger,udg_MonsterDataHash) // $3EE = 1006
    call SaveIntegerBJ($3FF,4,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    set udg_MonsterTypeID='nhrq' // 'nhrq': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($4A3,3,udg_TempInteger,udg_MonsterDataHash) // $4A3 = 1187
    call SaveIntegerBJ($444,4,udg_TempInteger,udg_MonsterDataHash) // $444 = 1092
    set udg_MonsterTypeID='n0L0' // 'n0L0': unit "Harpy Trickster"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EE,3,udg_TempInteger,udg_MonsterDataHash) // $3EE = 1006
    call SaveIntegerBJ($3FF,4,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    set udg_MonsterTypeID='nscb' // 'nscb': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($7D4,4,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    set udg_MonsterTypeID='nsc2' // 'nsc2': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nsc3' // 'nsc3': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nrel' // 'nrel': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($C,1,udg_TempInteger,udg_MonsterDataHash) // $C = 12
    call SaveIntegerBJ($7D3,2,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ($429,4,udg_TempInteger,udg_MonsterDataHash) // $429 = 1065
    set udg_MonsterTypeID='nsel' // 'nsel': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($C,1,udg_TempInteger,udg_MonsterDataHash) // $C = 12
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ($429,4,udg_TempInteger,udg_MonsterDataHash) // $429 = 1065
    set udg_MonsterTypeID='nsgn' // 'nsgn': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($D,1,udg_TempInteger,udg_MonsterDataHash) // $D = 13
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='nsgh' // 'nsgh': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($D,1,udg_TempInteger,udg_MonsterDataHash) // $D = 13
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($425,4,udg_TempInteger,udg_MonsterDataHash) // $425 = 1061
    set udg_MonsterTypeID='nsgb' // 'nsgb': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($D,1,udg_TempInteger,udg_MonsterDataHash) // $D = 13
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($425,4,udg_TempInteger,udg_MonsterDataHash) // $425 = 1061
    set udg_MonsterTypeID='nhyh' // 'nhyh': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($E,1,udg_TempInteger,udg_MonsterDataHash) // $E = 14
    call SaveIntegerBJ($7D3,2,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ(33,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='nhyd' // 'nhyd': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($E,1,udg_TempInteger,udg_MonsterDataHash) // $E = 14
    call SaveIntegerBJ($7D3,2,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ(33,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='nehy' // 'nehy': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($E,1,udg_TempInteger,udg_MonsterDataHash) // $E = 14
    call SaveIntegerBJ(33,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($421,4,udg_TempInteger,udg_MonsterDataHash) // $421 = 1057
    set udg_MonsterTypeID='nahy' // 'nahy': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($E,1,udg_TempInteger,udg_MonsterDataHash) // $E = 14
    call SaveIntegerBJ(33,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($421,4,udg_TempInteger,udg_MonsterDataHash) // $421 = 1057
    set udg_MonsterTypeID='nlpr' // 'nlpr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($424,4,udg_TempInteger,udg_MonsterDataHash) // $424 = 1060
    set udg_MonsterTypeID='nlpd' // 'nlpd': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($424,4,udg_TempInteger,udg_MonsterDataHash) // $424 = 1060
    set udg_MonsterTypeID='nltc' // 'nltc': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($424,4,udg_TempInteger,udg_MonsterDataHash) // $424 = 1060
    set udg_MonsterTypeID='nlds' // 'nlds': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($424,4,udg_TempInteger,udg_MonsterDataHash) // $424 = 1060
    set udg_MonsterTypeID='nlsn' // 'nlsn': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($401,4,udg_TempInteger,udg_MonsterDataHash) // $401 = 1025
    set udg_MonsterTypeID='nlkl' // 'nlkl': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($B,1,udg_TempInteger,udg_MonsterDataHash) // $B = 11
    call SaveIntegerBJ(34,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($401,4,udg_TempInteger,udg_MonsterDataHash) // $401 = 1025
    set udg_MonsterTypeID='nmcf' // 'nmcf': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D2,2,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nmbg' // 'nmbg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D2,2,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nmtw' // 'nmtw': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D3,2,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nmsn' // 'nmsn': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D3,2,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nmrv' // 'nmrv': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($466,4,udg_TempInteger,udg_MonsterDataHash) // $466 = 1126
    set udg_MonsterTypeID='nmsc' // 'nmsc': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($466,4,udg_TempInteger,udg_MonsterDataHash) // $466 = 1126
    set udg_MonsterTypeID='ntrv' // 'ntrv': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($F,1,udg_TempInteger,udg_MonsterDataHash) // $F = 15
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($4A3,3,udg_TempInteger,udg_MonsterDataHash) // $4A3 = 1187
    call SaveIntegerBJ($3ED,4,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    set udg_MonsterTypeID='nsrv' // 'nsrv': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($F,1,udg_TempInteger,udg_MonsterDataHash) // $F = 15
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($3EE,3,udg_TempInteger,udg_MonsterDataHash) // $3EE = 1006
    call SaveIntegerBJ($3ED,4,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    set udg_MonsterTypeID='ndrv' // 'ndrv': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($F,1,udg_TempInteger,udg_MonsterDataHash) // $F = 15
    call SaveIntegerBJ($4A3,2,udg_TempInteger,udg_MonsterDataHash) // $4A3 = 1187
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ($433,4,udg_TempInteger,udg_MonsterDataHash) // $433 = 1075
    set udg_MonsterTypeID='nlrv' // 'nlrv': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($F,1,udg_TempInteger,udg_MonsterDataHash) // $F = 15
    call SaveIntegerBJ($3EE,2,udg_TempInteger,udg_MonsterDataHash) // $3EE = 1006
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ($433,4,udg_TempInteger,udg_MonsterDataHash) // $433 = 1075
    set udg_MonsterTypeID='ntrh' // 'ntrh': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,2,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ(39,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='ntrs' // 'ntrs': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,2,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ(39,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='ntrt' // 'ntrt': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,2,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ(39,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='ntrg' // 'ntrg': unit "Adamanchelid"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(39,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(35,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='ntrd' // 'ntrd': unit "Adaman Tortoise"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(35,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,3,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(65,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='njg1' // 'njg1': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($40D,4,udg_TempInteger,udg_MonsterDataHash) // $40D = 1037
    set udg_MonsterTypeID='njga' // 'njga': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($40D,4,udg_TempInteger,udg_MonsterDataHash) // $40D = 1037
    set udg_MonsterTypeID='njgb' // 'njgb': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($40D,4,udg_TempInteger,udg_MonsterDataHash) // $40D = 1037
    set udg_MonsterTypeID='ndtr' // 'ndtr': unit "Dark Goblin"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(96,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($413,3,udg_TempInteger,udg_MonsterDataHash) // $413 = 1043
    call SaveIntegerBJ($402,4,udg_TempInteger,udg_MonsterDataHash) // $402 = 1026
    set udg_MonsterTypeID='ndtp' // 'ndtp': unit "Dark Goblin Shaman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(96,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($416,3,udg_TempInteger,udg_MonsterDataHash) // $416 = 1046
    call SaveIntegerBJ($402,4,udg_TempInteger,udg_MonsterDataHash) // $402 = 1026
    set udg_MonsterTypeID='ndtt' // 'ndtt': unit "Dark Goblin Trapper"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(96,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($413,3,udg_TempInteger,udg_MonsterDataHash) // $413 = 1043
    call SaveIntegerBJ($402,4,udg_TempInteger,udg_MonsterDataHash) // $402 = 1026
    set udg_MonsterTypeID='ndth' // 'ndth': unit "Dark Goblin Great Shaman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(96,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($416,3,udg_TempInteger,udg_MonsterDataHash) // $416 = 1046
    call SaveIntegerBJ($402,4,udg_TempInteger,udg_MonsterDataHash) // $402 = 1026
    set udg_MonsterTypeID='ndtb' // 'ndtb': unit "Dark Goblin Berserker"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(1,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(96,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($413,3,udg_TempInteger,udg_MonsterDataHash) // $413 = 1043
    call SaveIntegerBJ($402,4,udg_TempInteger,udg_MonsterDataHash) // $402 = 1026
    set udg_MonsterTypeID='n01O' // 'n01O': unit "Flan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,2,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ(97,4,udg_TempInteger,udg_MonsterDataHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MonsterData_Init_2_Actions takes nothing returns nothing
    set udg_MonsterTypeID='nban' // 'nban': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EF,2,udg_TempInteger,udg_MonsterDataHash) // $3EF = 1007
    call SaveIntegerBJ($7D2,3,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ($7D3,4,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    set udg_MonsterTypeID='nbrg' // 'nbrg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3E9,2,udg_TempInteger,udg_MonsterDataHash) // $3E9 = 1001
    call SaveIntegerBJ($7D2,3,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ($48B,4,udg_TempInteger,udg_MonsterDataHash) // $48B = 1163
    set udg_MonsterTypeID='nrog' // 'nrog': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D2,2,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ($7D3,3,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nass' // 'nass': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EF,2,udg_TempInteger,udg_MonsterDataHash) // $3EF = 1007
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($48B,4,udg_TempInteger,udg_MonsterDataHash) // $48B = 1163
    set udg_MonsterTypeID='nenf' // 'nenf': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3E9,2,udg_TempInteger,udg_MonsterDataHash) // $3E9 = 1001
    call SaveIntegerBJ($3EB,3,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nbld' // 'nbld': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,2,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($406,4,udg_TempInteger,udg_MonsterDataHash) // $406 = 1030
    set udg_MonsterTypeID='nhfp' // 'nhfp': unit "Kultist"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,2,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ(32,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(83,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nhdc' // 'nhdc': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(32,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(83,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nhhr' // 'nhhr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(32,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(83,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nkob' // 'nkob': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(20,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D3,2,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ($7D4,3,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='nkog' // 'nkog': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(20,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ($3FC,4,udg_TempInteger,udg_MonsterDataHash) // $3FC = 1020
    set udg_MonsterTypeID='nkot' // 'nkot': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(20,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($40C,4,udg_TempInteger,udg_MonsterDataHash) // $40C = 1036
    set udg_MonsterTypeID='nkol' // 'nkol': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(20,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,2,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($40C,4,udg_TempInteger,udg_MonsterDataHash) // $40C = 1036
    set udg_MonsterTypeID='nwiz' // 'nwiz': unit "Apprentice Dark Wizard"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(83,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nwzr' // 'nwzr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(30,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nwzg' // 'nwzg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(30,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nwzd' // 'nwzd': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(30,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($40E,4,udg_TempInteger,udg_MonsterDataHash) // $40E = 1038
    set udg_MonsterTypeID='nogr' // 'nogr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='nomg' // 'nomg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($3ED,4,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    set udg_MonsterTypeID='nogm' // 'nogm': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($414,4,udg_TempInteger,udg_MonsterDataHash) // $414 = 1044
    set udg_MonsterTypeID='nogl' // 'nogl': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($414,4,udg_TempInteger,udg_MonsterDataHash) // $414 = 1044
    set udg_MonsterTypeID='n0MO' // 'n0MO': unit "Ogre Berserker"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(21,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($414,4,udg_TempInteger,udg_MonsterDataHash) // $414 = 1044
    set udg_MonsterTypeID='ngna' // 'ngna': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(38,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($4BE,4,udg_TempInteger,udg_MonsterDataHash) // $4BE = 1214
    set udg_MonsterTypeID='ngns' // 'ngns': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(38,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($4BE,4,udg_TempInteger,udg_MonsterDataHash) // $4BE = 1214
    set udg_MonsterTypeID='ngno' // 'ngno': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(38,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($3F1,4,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    set udg_MonsterTypeID='ngnw' // 'ngnw': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(38,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EC,3,udg_TempInteger,udg_MonsterDataHash) // $3EC = 1004
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='ngnv' // 'ngnv': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(38,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F1,3,udg_TempInteger,udg_MonsterDataHash) // $3F1 = 1009
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nwlg' // 'nwlg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(61,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nwld' // 'nwld': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(61,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nspb' // 'nspb': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(4,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('f',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($4A3,3,udg_TempInteger,udg_MonsterDataHash) // $4A3 = 1187
    call SaveIntegerBJ($436,4,udg_TempInteger,udg_MonsterDataHash) // $436 = 1078
    set udg_MonsterTypeID='ngrk' // 'ngrk': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(36,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(37,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='ngst' // 'ngst': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(36,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(37,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nggr' // 'nggr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(36,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(37,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F3,4,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    set udg_MonsterTypeID='narg' // 'narg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(37,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(36,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,4,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    set udg_MonsterTypeID='nwrg' // 'nwrg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(37,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(36,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nsgg' // 'nsgg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(37,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(36,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F3,4,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    set udg_MonsterTypeID='n01P' // 'n01P': unit "Lesser Flan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EB,2,udg_TempInteger,udg_MonsterDataHash) // $3EB = 1003
    call SaveIntegerBJ($3ED,3,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ($428,4,udg_TempInteger,udg_MonsterDataHash) // $428 = 1064
    set udg_MonsterTypeID='nnmg' // 'nnmg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(57,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nwgs' // 'nwgs': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(24,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(40,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3F2,4,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    set udg_MonsterTypeID='nnsw' // 'nnsw': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(23,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(79,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($436,3,udg_TempInteger,udg_MonsterDataHash) // $436 = 1078
    call SaveIntegerBJ($3F2,4,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    set udg_MonsterTypeID='nsnp' // 'nsnp': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(24,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(40,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3F3,4,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    set udg_MonsterTypeID='nmyr' // 'nmyr': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(23,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(79,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F3,4,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    set udg_MonsterTypeID='nnrg' // 'nnrg': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(23,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(79,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F3,4,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    set udg_MonsterTypeID='nhyc' // 'nhyc': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(39,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($7D7,4,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    set udg_MonsterTypeID='nmpe' // 'nmpe': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(57,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='n01Q' // 'n01Q': unit "Aqua Flan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3ED,2,udg_TempInteger,udg_MonsterDataHash) // $3ED = 1005
    call SaveIntegerBJ(97,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(98,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nsty' // 'nsty': editor label "Satyr"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(80,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F2,3,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    call SaveIntegerBJ($441,4,udg_TempInteger,udg_MonsterDataHash) // $441 = 1089
    set udg_MonsterTypeID='nsat' // 'nsat': editor label "Satyr Trickster"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(80,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F2,3,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    call SaveIntegerBJ($439,4,udg_TempInteger,udg_MonsterDataHash) // $439 = 1081
    set udg_MonsterTypeID='nsts' // 'nsts': editor label "Satyr Shadowdancer"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(80,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F2,3,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    call SaveIntegerBJ($407,4,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    set udg_MonsterTypeID='nstl' // 'nstl': editor label "Satyr Soulstealer"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(80,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F2,3,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    call SaveIntegerBJ($430,4,udg_TempInteger,udg_MonsterDataHash) // $430 = 1072
    set udg_MonsterTypeID='nsth' // 'nsth': editor label "Satyr Hellcaller"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(80,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F2,3,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    call SaveIntegerBJ($429,4,udg_TempInteger,udg_MonsterDataHash) // $429 = 1065
    set udg_MonsterTypeID='n0ML' // 'n0ML': unit "Satyr Assassin"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(80,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3F2,3,udg_TempInteger,udg_MonsterDataHash) // $3F2 = 1010
    call SaveIntegerBJ($526,4,udg_TempInteger,udg_MonsterDataHash) // $526 = 1318
    set udg_MonsterTypeID='nenp' // 'nenp': editor label "Poison Treant"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(43,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3EA,4,udg_TempInteger,udg_MonsterDataHash) // $3EA = 1002
    set udg_MonsterTypeID='nenc' // 'nenc': editor label "Corrupted Treant"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(43,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3EA,4,udg_TempInteger,udg_MonsterDataHash) // $3EA = 1002
    set udg_MonsterTypeID='nepl' // 'nepl': editor label "Plague Treant"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(43,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(44,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EA,4,udg_TempInteger,udg_MonsterDataHash) // $3EA = 1002
    set udg_MonsterTypeID='n00N' // 'n00N': unit "Corrupted Ancient of War"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3F3,3,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    call SaveIntegerBJ($40F,4,udg_TempInteger,udg_MonsterDataHash) // $40F = 1039
    set udg_MonsterTypeID='n00O' // 'n00O': unit "Corrupted Ancient Protector"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3F3,3,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    call SaveIntegerBJ($41D,4,udg_TempInteger,udg_MonsterDataHash) // $41D = 1053
    set udg_MonsterTypeID='n00P' // 'n00P': unit "Corrupted Tree of Life"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(26,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3F3,3,udg_TempInteger,udg_MonsterDataHash) // $3F3 = 1011
    call SaveIntegerBJ($427,4,udg_TempInteger,udg_MonsterDataHash) // $427 = 1063
    set udg_MonsterTypeID='n010' // 'n010': unit "Vile Spider"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(4,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($436,2,udg_TempInteger,udg_MonsterDataHash) // $436 = 1078
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='n01N' // 'n01N': unit "Greater Flan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(97,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(98,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($42C,4,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    set udg_MonsterTypeID='n028' // 'n028': unit "Great Polar Bear"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(45,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($467,4,udg_TempInteger,udg_MonsterDataHash) // $467 = 1127
    set udg_MonsterTypeID='n027' // 'n027': unit "Elder Wendigo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(45,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($468,3,udg_TempInteger,udg_MonsterDataHash) // $468 = 1128
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n026' // 'n026': unit "Wendigo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(45,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($467,3,udg_TempInteger,udg_MonsterDataHash) // $467 = 1127
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n025' // 'n025': unit "Wendigo Shaman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(45,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($468,3,udg_TempInteger,udg_MonsterDataHash) // $468 = 1128
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0MQ' // 'n0MQ': unit "Wendigo Berserker"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(45,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($467,3,udg_TempInteger,udg_MonsterDataHash) // $467 = 1127
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n029' // 'n029': unit "Ice Troll"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(46,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($467,4,udg_TempInteger,udg_MonsterDataHash) // $467 = 1127
    set udg_MonsterTypeID='n02D' // 'n02D': unit "Ice Troll Priest"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(27,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(46,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($468,4,udg_TempInteger,udg_MonsterDataHash) // $468 = 1128
    set udg_MonsterTypeID='n02A' // 'n02A': unit "Ice Tusk Warrior"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ('g',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($467,4,udg_TempInteger,udg_MonsterDataHash) // $467 = 1127
    set udg_MonsterTypeID='n02C' // 'n02C': unit "Icy Whelp"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(41,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,3,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='n02B' // 'n02B': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($42C,4,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    set udg_MonsterTypeID='n03E' // 'n03E': unit "Nether Drake"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(42,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='n03F' // 'n03F': unit "Marsh Whelp"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(42,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($468,3,udg_TempInteger,udg_MonsterDataHash) // $468 = 1128
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='n03G' // 'n03G': unit "Dusk Wyrm"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(41,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($467,3,udg_TempInteger,udg_MonsterDataHash) // $467 = 1127
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='n03H' // 'n03H': unit "Black Dragon"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(41,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($3EA,3,udg_TempInteger,udg_MonsterDataHash) // $3EA = 1002
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='n03I' // 'n03I': unit "Toxic Triton"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(44,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($42C,3,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='n03J' // 'n03J': unit "Marsh Crawler"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($42C,3,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MonsterData_Init_3_Actions takes nothing returns nothing
    set udg_MonsterTypeID='uabo' // 'uabo': object name not found in map data
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(55,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(44,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='uabc' // 'uabc': unit "Tainted Cúchulainn"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(55,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(44,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='n0KZ' // 'n0KZ': unit "Harpy Matriarch"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($A,1,udg_TempInteger,udg_MonsterDataHash) // $A = 10
    call SaveIntegerBJ(24,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,3,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='n01U' // 'n01U': unit "Jungle Predator Elder"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,3,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='n01T' // 'n01T': unit "Thief Elite Guard"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($441,3,udg_TempInteger,udg_MonsterDataHash) // $441 = 1089
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='n016' // 'n016': unit "Bloodstone Golem"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ(56,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(56,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03B' // 'n03B': unit "Tonberry"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(30,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ(92,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(92,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03U' // 'n03U': unit "Cactuar"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(31,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ(93,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(93,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03W' // 'n03W': unit "Malboro"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(32,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ(94,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(94,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03C' // 'n03C': unit "Mega-Tonberry"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(30,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(92,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(92,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(92,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03V' // 'n03V': unit "Jumbo Cactuar"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(93,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(93,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(93,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03X' // 'n03X': unit "Great Malboro"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(32,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(94,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(94,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(94,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0B4' // 'n0B4': unit "Big Wolf"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(61,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D2,3,udg_TempInteger,udg_MonsterDataHash) // $7D2 = 2002
    call SaveIntegerBJ($7D3,4,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    set udg_MonsterTypeID='n0B5' // 'n0B5': unit "Angry Wolf"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(61,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D3,3,udg_TempInteger,udg_MonsterDataHash) // $7D3 = 2003
    call SaveIntegerBJ($7D4,4,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    set udg_MonsterTypeID='n0CG' // 'n0CG': unit "Bandersnatch"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(45,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,3,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='nmrr' // 'nmrr': unit "Triton Huntsman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,2,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nmrm' // 'nmrm': unit "Triton Nightcrawler"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(57,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(57,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(57,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='ncpn' // 'ncpn': unit "Corrupted Orc Snaga"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(59,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ($7D6,4,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    set udg_MonsterTypeID='nchg' // 'nchg': unit "Corrupted Orc Savage"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(59,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($415,3,udg_TempInteger,udg_MonsterDataHash) // $415 = 1045
    call SaveIntegerBJ($40F,4,udg_TempInteger,udg_MonsterDataHash) // $40F = 1039
    set udg_MonsterTypeID='nchw' // 'nchw': unit "Corrupted Orc Warlock"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(59,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($410,3,udg_TempInteger,udg_MonsterDataHash) // $410 = 1040
    call SaveIntegerBJ($419,4,udg_TempInteger,udg_MonsterDataHash) // $419 = 1049
    set udg_MonsterTypeID='nchr' // 'nchr': unit "Corrupted Orc Wolf Rider"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(59,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($408,3,udg_TempInteger,udg_MonsterDataHash) // $408 = 1032
    call SaveIntegerBJ($427,4,udg_TempInteger,udg_MonsterDataHash) // $427 = 1063
    set udg_MonsterTypeID='nckb' // 'nckb': unit "Corrupted Orc Kodo Rider"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(59,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($423,3,udg_TempInteger,udg_MonsterDataHash) // $423 = 1059
    call SaveIntegerBJ($41D,4,udg_TempInteger,udg_MonsterDataHash) // $41D = 1053
    set udg_MonsterTypeID='n042' // 'n042': unit "Dark Flan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(98,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7DA,3,udg_TempInteger,udg_MonsterDataHash) // $7DA = 2010
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='n0AU' // 'n0AU': unit "Nebra Guard"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(2,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(60,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(60,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(60,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n02J' // 'n02J': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D4,2,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($7D4,3,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    call SaveIntegerBJ($7D4,4,udg_TempInteger,udg_MonsterDataHash) // $7D4 = 2004
    set udg_MonsterTypeID='n02S' // 'n02S': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n02T' // 'n02T': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n02U' // 'n02U': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n032' // 'n032': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(19,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n033' // 'n033': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(18,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n04H' // 'n04H': unit "Trickster"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03S' // 'n03S': unit "Boco the Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($490,2,udg_TempInteger,udg_MonsterDataHash) // $490 = 1168
    call SaveIntegerBJ($490,3,udg_TempInteger,udg_MonsterDataHash) // $490 = 1168
    call SaveIntegerBJ($490,4,udg_TempInteger,udg_MonsterDataHash) // $490 = 1168
    set udg_MonsterTypeID='n04J' // 'n04J': unit "Chocobo"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(29,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(75,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(75,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(75,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n08A' // 'n08A': unit "Fire Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(84,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(84,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n08H' // 'n08H': unit "Ice Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(85,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(85,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n08I' // 'n08I': unit "Thunder Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(86,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(86,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n08J' // 'n08J': unit "Water Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(87,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(87,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n08K' // 'n08K': unit "Earth Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(88,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(88,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n08L' // 'n08L': unit "Wind Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(89,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(89,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AL' // 'n0AL': unit "Holy Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(90,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(90,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AM' // 'n0AM': unit "Dark Elemental"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,2,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    call SaveIntegerBJ(77,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(77,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AF' // 'n0AF': unit "Salamander Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(84,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(84,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(84,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AG' // 'n0AG': unit "Leshach Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(85,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(85,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(85,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AH' // 'n0AH': unit "Mardu Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(86,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(86,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(86,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AI' // 'n0AI': unit "Undin Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(87,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(87,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(87,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AJ' // 'n0AJ': unit "Gnoma Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(88,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(88,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(88,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AK' // 'n0AK': unit "Sylphi Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(89,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(89,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(89,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AN' // 'n0AN': unit "Diakon Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(90,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(90,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(90,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0AO' // 'n0AO': unit "Leamonde Entite"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(77,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(77,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(77,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CL' // 'n0CL': unit "Puroboros"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(0,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7DC,2,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ(99,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(99,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='Hpb1' // 'Hpb1': unit "Engineer"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7DC,2,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ($7DC,3,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='Nbbc' // 'Nbbc': unit "Corrupted Samurai"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($3FD,3,udg_TempInteger,udg_MonsterDataHash) // $3FD = 1021
    call SaveIntegerBJ($3FD,4,udg_TempInteger,udg_MonsterDataHash) // $3FD = 1021
    set udg_MonsterTypeID='Hgam' // 'Hgam': unit "Warlock"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($437,3,udg_TempInteger,udg_MonsterDataHash) // $437 = 1079
    call SaveIntegerBJ($437,4,udg_TempInteger,udg_MonsterDataHash) // $437 = 1079
    set udg_MonsterTypeID='n011' // 'n011': unit "Tempest Lizard"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(7,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ(95,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(95,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n01Z' // 'n01Z': unit "Quezacotl"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(24,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($7D6,3,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($7D7,4,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    set udg_MonsterTypeID='n00H' // 'n00H': unit "Gnoll Chieftain"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(3,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($432,3,udg_TempInteger,udg_MonsterDataHash) // $432 = 1074
    call SaveIntegerBJ($432,4,udg_TempInteger,udg_MonsterDataHash) // $432 = 1074
    set udg_MonsterTypeID='n02V' // 'n02V': unit "Annoying Monster"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($3FF,2,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    call SaveIntegerBJ($3FF,3,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    call SaveIntegerBJ($3FF,4,udg_TempInteger,udg_MonsterDataHash) // $3FF = 1023
    set udg_MonsterTypeID='n00F' // 'n00F': unit "Fire Golem"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($7D7,3,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($7D7,4,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    set udg_MonsterTypeID='u003' // 'u003': unit "Adria"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(73,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(73,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(73,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='u005' // 'u005': unit "Baba Yaga"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(73,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(73,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(73,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='u001' // 'u001': unit "Link"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($407,2,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    call SaveIntegerBJ($407,3,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    call SaveIntegerBJ($407,4,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    set udg_MonsterTypeID='h00U' // 'h00U': unit "Link"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($407,2,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    call SaveIntegerBJ($407,3,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    call SaveIntegerBJ($407,4,udg_TempInteger,udg_MonsterDataHash) // $407 = 1031
    set udg_MonsterTypeID='n015' // 'n015': unit "Mithril Golem"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(22,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('d',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('d',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(69,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n019' // 'n019': unit "Satyr Farseer"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(25,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ(72,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(72,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='U006' // 'U006': unit "Necromancer"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($439,3,udg_TempInteger,udg_MonsterDataHash) // $439 = 1081
    call SaveIntegerBJ($439,4,udg_TempInteger,udg_MonsterDataHash) // $439 = 1081
    set udg_MonsterTypeID='n014' // 'n014': unit "Centaur Genghis Khan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ($415,3,udg_TempInteger,udg_MonsterDataHash) // $415 = 1045
    call SaveIntegerBJ($415,4,udg_TempInteger,udg_MonsterDataHash) // $415 = 1045
    set udg_MonsterTypeID='H00W' // 'H00W': unit "Ogre Crusher"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($43F,3,udg_TempInteger,udg_MonsterDataHash) // $43F = 1087
    call SaveIntegerBJ($43F,4,udg_TempInteger,udg_MonsterDataHash) // $43F = 1087
    set udg_MonsterTypeID='Uvng' // 'Uvng': unit "Vampire"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($435,3,udg_TempInteger,udg_MonsterDataHash) // $435 = 1077
    call SaveIntegerBJ($434,4,udg_TempInteger,udg_MonsterDataHash) // $434 = 1076
    set udg_MonsterTypeID='Ocbh' // 'Ocbh': unit "Brother"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($43E,3,udg_TempInteger,udg_MonsterDataHash) // $43E = 1086
    call SaveIntegerBJ($43E,4,udg_TempInteger,udg_MonsterDataHash) // $43E = 1086
    set udg_MonsterTypeID='Ocb2' // 'Ocb2': unit "Brother"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ(68,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(68,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='H01I' // 'H01I': unit "Friend of Brothers"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($44A,3,udg_TempInteger,udg_MonsterDataHash) // $44A = 1098
    call SaveIntegerBJ($44A,4,udg_TempInteger,udg_MonsterDataHash) // $44A = 1098
    set udg_MonsterTypeID='H01K' // 'H01K': unit "Friend of Brothers"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($47C,3,udg_TempInteger,udg_MonsterDataHash) // $47C = 1148
    call SaveIntegerBJ($47C,4,udg_TempInteger,udg_MonsterDataHash) // $47C = 1148
    set udg_MonsterTypeID='H01J' // 'H01J': unit "Friend of Brothers"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($47C,3,udg_TempInteger,udg_MonsterDataHash) // $47C = 1148
    call SaveIntegerBJ($47C,4,udg_TempInteger,udg_MonsterDataHash) // $47C = 1148
    set udg_MonsterTypeID='H01L' // 'H01L': unit "Friend of Brothers"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($42D,3,udg_TempInteger,udg_MonsterDataHash) // $42D = 1069
    call SaveIntegerBJ($42D,4,udg_TempInteger,udg_MonsterDataHash) // $42D = 1069
    set udg_MonsterTypeID='Hvsh' // 'Hvsh': unit "Serpent Witch"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($4DA,2,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    call SaveIntegerBJ($4DA,3,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    call SaveIntegerBJ($4DA,4,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    set udg_MonsterTypeID='n023' // 'n023': unit "Vodyan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($427,3,udg_TempInteger,udg_MonsterDataHash) // $427 = 1063
    call SaveIntegerBJ($427,4,udg_TempInteger,udg_MonsterDataHash) // $427 = 1063
    set udg_MonsterTypeID='H00X' // 'H00X': unit "Phantom Ranger"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($4DA,2,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    call SaveIntegerBJ($4DA,3,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    call SaveIntegerBJ($4DA,4,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    set udg_MonsterTypeID='H00Y' // 'H00Y': unit "Dark Ranger"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($4DA,2,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    call SaveIntegerBJ($4DA,3,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    call SaveIntegerBJ($4DA,4,udg_TempInteger,udg_MonsterDataHash) // $4DA = 1242
    set udg_MonsterTypeID='Ewrd' // 'Ewrd': unit "Holy Knight"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($409,2,udg_TempInteger,udg_MonsterDataHash) // $409 = 1033
    call SaveIntegerBJ($409,3,udg_TempInteger,udg_MonsterDataHash) // $409 = 1033
    call SaveIntegerBJ($409,4,udg_TempInteger,udg_MonsterDataHash) // $409 = 1033
    set udg_MonsterTypeID='e009' // 'e009': unit "Shadow Queen Lilith"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(62,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(62,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(62,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='Opgh' // 'Opgh': unit "Corrupted Orc Chieftain"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(58,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(58,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(58,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n03L' // 'n03L': unit "Enkidu"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($432,2,udg_TempInteger,udg_MonsterDataHash) // $432 = 1074
    call SaveIntegerBJ($432,3,udg_TempInteger,udg_MonsterDataHash) // $432 = 1074
    call SaveIntegerBJ($432,4,udg_TempInteger,udg_MonsterDataHash) // $432 = 1074
    set udg_MonsterTypeID='N03D' // 'N03D': unit "Mighty Swordsman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($42C,2,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,3,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,4,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    set udg_MonsterTypeID='Nman' // 'Nman': unit "Weapon"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($42C,2,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,3,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,4,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    set udg_MonsterTypeID='N02I' // 'N02I': unit "Strongest Eidolon"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($42C,2,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,3,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,4,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    set udg_MonsterTypeID='E018' // 'E018': unit "Arbiter of Time"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($42C,2,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,3,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    call SaveIntegerBJ($42C,4,udg_TempInteger,udg_MonsterDataHash) // $42C = 1068
    set udg_MonsterTypeID='N022' // 'N022': unit "Weapon"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7DC,2,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ($448,3,udg_TempInteger,udg_MonsterDataHash) // $448 = 1096
    call SaveIntegerBJ($448,4,udg_TempInteger,udg_MonsterDataHash) // $448 = 1096
    set udg_MonsterTypeID='E00K' // 'E00K': unit "Just A Kid?"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($7DC,2,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ(63,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(63,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='H01M' // 'H01M': unit "Northern God"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($448,2,udg_TempInteger,udg_MonsterDataHash) // $448 = 1096
    call SaveIntegerBJ($448,3,udg_TempInteger,udg_MonsterDataHash) // $448 = 1096
    call SaveIntegerBJ($448,4,udg_TempInteger,udg_MonsterDataHash) // $448 = 1096
    set udg_MonsterTypeID='Uear' // 'Uear': unit "Dark Knight"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($457,2,udg_TempInteger,udg_MonsterDataHash) // $457 = 1111
    call SaveIntegerBJ($457,3,udg_TempInteger,udg_MonsterDataHash) // $457 = 1111
    call SaveIntegerBJ($457,4,udg_TempInteger,udg_MonsterDataHash) // $457 = 1111
    set udg_MonsterTypeID='Uwar' // 'Uwar': unit "Zodiac Brave of Fire"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='E002' // 'E002': unit "Zodiac Brave of Earth"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U000' // 'U000': unit "Zodiac Brave of Death"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00J' // 'U00J': unit "Zodiac Brave of Gravity"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00N' // 'U00N': unit "Zodiac Brave of Water"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00K' // 'U00K': unit "Zodiac Brave of Aether"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00E' // 'U00E': unit "Zodiac Brave of Thunder"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00O' // 'U00O': unit "Zodiac Brave of Wind"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U019' // 'U019': unit "Zodiac Brave of Poison"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00I' // 'U00I': unit "Zodiac Brave of Soul"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00L' // 'U00L': unit "Zodiac Brave of Ice"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00M' // 'U00M': unit "Winter Queen"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($43B,2,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,3,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    call SaveIntegerBJ($43B,4,udg_TempInteger,udg_MonsterDataHash) // $43B = 1083
    set udg_MonsterTypeID='U00F' // 'U00F': unit "Zodiac Brave of Holy"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($40A,2,udg_TempInteger,udg_MonsterDataHash) // $40A = 1034
    call SaveIntegerBJ($40A,3,udg_TempInteger,udg_MonsterDataHash) // $40A = 1034
    call SaveIntegerBJ($40A,4,udg_TempInteger,udg_MonsterDataHash) // $40A = 1034
    set udg_MonsterTypeID='U00H' // 'U00H': unit "Zodiac Brave of Darkness"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(75,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(75,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(75,4,udg_TempInteger,udg_MonsterDataHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_MonsterData_Init_4_Actions takes nothing returns nothing
    set udg_MonsterTypeID='nrvd' // 'nrvd': unit "Etem"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(64,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(62,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7DA,4,udg_TempInteger,udg_MonsterDataHash) // $7DA = 2010
    set udg_MonsterTypeID='nvdg' // 'nvdg': unit "Evil Spirit"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(64,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D9,3,udg_TempInteger,udg_MonsterDataHash) // $7D9 = 2009
    call SaveIntegerBJ(74,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='nslr' // 'nslr': unit "Zalamander"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(7,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(25,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D5,3,udg_TempInteger,udg_MonsterDataHash) // $7D5 = 2005
    call SaveIntegerBJ('h',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0L6' // 'n0L6': unit "Bomb"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(34,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D6,2,udg_TempInteger,udg_MonsterDataHash) // $7D6 = 2006
    call SaveIntegerBJ('h',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='nmgw' // 'nmgw': unit "Behemoth"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(33,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,2,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ('g',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='nmgr' // 'nmgr': unit "Grand Behemoth"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(33,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7DC,3,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ($43D,4,udg_TempInteger,udg_MonsterDataHash) // $43D = 1085
    set udg_MonsterTypeID='n0N1' // 'n0N1': unit "Xiao Long Gui"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(16,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(65,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7DC,3,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ(71,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0N3' // 'n0N3': unit "Forest Drake"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(41,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ($7D7,3,udg_TempInteger,udg_MonsterDataHash) // $7D7 = 2007
    call SaveIntegerBJ($7D8,4,udg_TempInteger,udg_MonsterDataHash) // $7D8 = 2008
    set udg_MonsterTypeID='n0CB' // 'n0CB': unit "Vulcan"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(34,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('h',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('h',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('h',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n041' // 'n041': unit "Ruby Dragon"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(28,1,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CK' // 'n0CK': unit "Cerberus"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(5,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('e',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CV' // 'n0CV': unit "Hell Shaman"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CU' // 'n0CU': unit "Hell Beast"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CW' // 'n0CW': unit "Elder Hell Beast"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveBooleanBJ(true,0,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(17,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ('g',4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CJ' // 'n0CJ': unit "Kelk"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CA' // 'n0CA': unit "Kinoc"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='n0CI' // 'n0CI': unit "Mika"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ(19,1,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,2,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,3,udg_TempInteger,udg_MonsterDataHash)
    call SaveIntegerBJ(31,4,udg_TempInteger,udg_MonsterDataHash)
    set udg_MonsterTypeID='U01S' // 'U01S': unit "Night's Terror"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($52A,2,udg_TempInteger,udg_MonsterDataHash) // $52A = 1322
    call SaveIntegerBJ($7DC,3,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    set udg_MonsterTypeID='U01U' // 'U01U': unit "Nightmare"
    set udg_TempInteger=udg_MonsterTypeID
    call SaveIntegerBJ($52A,2,udg_TempInteger,udg_MonsterDataHash) // $52A = 1322
    call SaveIntegerBJ($7DC,3,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call SaveIntegerBJ($7DC,4,udg_TempInteger,udg_MonsterDataHash) // $7DC = 2012
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_MonsterData takes nothing returns nothing
endfunction

function RegisterR11_MonsterData_Init_1 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_MonsterData_Init_1=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_MonsterData_Init_1,2.)

call TriggerAddAction(gg_trg_MonsterData_Init_1,function Trig_MonsterData_Init_1_Actions)

endfunction




function RegisterR11_MonsterData_Init_2 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_MonsterData_Init_2=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_MonsterData_Init_2,2.)

call TriggerAddAction(gg_trg_MonsterData_Init_2,function Trig_MonsterData_Init_2_Actions)

endfunction




function RegisterR11_MonsterData_Init_3 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_MonsterData_Init_3=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_MonsterData_Init_3,2.)

call TriggerAddAction(gg_trg_MonsterData_Init_3,function Trig_MonsterData_Init_3_Actions)

endfunction




function RegisterR11_MonsterData_Init_4 takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_MonsterData_Init_4=CreateTrigger()

call TriggerRegisterTimerEventSingle(gg_trg_MonsterData_Init_4,2.)

call TriggerAddAction(gg_trg_MonsterData_Init_4,function Trig_MonsterData_Init_4_Actions)

endfunction




endlibrary

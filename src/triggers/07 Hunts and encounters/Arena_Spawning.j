library TArenaSpawning requires TDifficulty, TLoc, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Unit_Data=null
    trigger gg_trg_Arena_Spawn_Team=null
    // Variables only this module uses.
    real udg_ArenaHpMultiplier=0
endglobals

function Trig_Arena_Unit_Data_Actions takes nothing returns nothing
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(91,3,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(81,4,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,5,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($82,6,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $82 = 130
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(21,7,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (1) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,(1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D8,3,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D8 = 216
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DA,4,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DA = 218
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DD,5,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(65,6,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($7E,7,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (2) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,(2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('o',3,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(39,4,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(53,5,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(62,6,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (3) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,9,(3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (4) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,2,(4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (4) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(28,3,(4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (4) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,9,(4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (4) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,(4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10
    // (4) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(28,$B,(4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11
    // (4) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,(4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,2,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3E8,3,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3E8 = 1000
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(322,4,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(98,9,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($EE,$B,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EE = 238; $B = 11
    // (5) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,(5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,2,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3E8,3,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3E8 = 1000
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3E8,4,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3E8 = 1000
    // (9) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(99,9,(9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(84,3,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(36,4,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,5,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(57,6,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(87,7,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(30,9,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(74,$B,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11
    // (71) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,(71+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(77,3,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(76,4,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(75,5,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(61,6,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,9,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash)
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,$A,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(77,$B,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(35,$C,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(76,$D,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D = 13
    // (125) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(35,$E,('}'+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E = 14
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(48,3,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(81,4,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(75,5,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(64,6,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(79,7,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (126) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,9,($7E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7E = 126
    // (127) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(4,2,($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7F = 127
    // (127) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(46,3,($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7F = 127
    // (127) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(75,5,($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7F = 127
    // (127) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(64,5,($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7F = 127
    // (127) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(18,6,($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $7F = 127
    // (127) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F,9,($7F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F = 15; $7F = 127
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $80 = 128
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(343,3,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $80 = 128
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DB,4,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219; $80 = 128
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,5,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $80 = 128
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(59,6,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $80 = 128
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(18,7,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $80 = 128
    // (128) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,9,($80+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $80 = 128
    // (129) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(40,9,($81+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $81 = 129
    // (130) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(35,9,($82+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $82 = 130
    // (131) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,9,($83+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $83 = 131
    // (132) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,9,($84+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $84 = 132
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(288,3,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('}',4,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(82,5,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(66,6,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($EB,7,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EB = 235; $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,9,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($EB,$B,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EB = 235; $B = 11; $85 = 133
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($85+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $85 = 133
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $86 = 134
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(90,3,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $86 = 134
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F5,4,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F5 = 245; $86 = 134
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(53,5,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $86 = 134
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(63,6,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $86 = 134
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A7,7,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A7 = 167; $86 = 134
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(40,9,($86+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $86 = 134
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $88 = 136
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D6,3,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D6 = 214; $88 = 136
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F2,4,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F2 = 242; $88 = 136
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(72,5,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $88 = 136
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(65,6,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $88 = 136
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(21,7,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $88 = 136
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(30,9,($88+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $88 = 136
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,3,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(39,4,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(53,5,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(63,6,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($E,7,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E = 14; $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,$B,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(6,$C,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $8A = 138
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(44,$D,($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D = 13; $8A = 138
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(34,3,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A5,4,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A5 = 165; $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A4,5,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A4 = 164; $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(67,6,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(19,7,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(60,9,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,$A,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(34,$B,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F,$C,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F = 15; $C = 12; $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(336,$D,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D = 13; $8C = 140
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,$E,($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E = 14; $8C = 140
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(44,3,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(37,4,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(51,5,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(61,6,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(24,7,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(30,9,($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8D = 141
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8E = 142
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(44,3,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8E = 142
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(35,4,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8E = 142
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,5,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8E = 142
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(57,6,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8E = 142
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8E = 142
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F,9,($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F = 15; $8E = 142
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(6,2,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(34,3,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F2,4,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F2 = 1010; $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F3,5,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F3 = 1011; $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F4,6,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F4 = 1012; $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(19,7,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(74,8,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(91,9,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($C2,$B,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C2 = 194; $B = 11; $8F = 143
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $8F = 143
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,3,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(37,4,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(51,5,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(61,6,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(24,7,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(60,9,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(98,$B,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $90 = 144
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A,$C,($90+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $C = 12; $90 = 144
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,3,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(37,4,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(51,5,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(61,6,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(98,$B,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $91 = 145
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A,$C,($91+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $C = 12; $91 = 145
    // (146) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(86,9,($92+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $92 = 146
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,2,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $98 = 152
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F0,3,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F0 = 1008; $98 = 152
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F1,4,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F1 = 1009; $98 = 152
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(97,9,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $98 = 152
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $98 = 152
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($CE,$B,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CE = 206; $B = 11; $98 = 152
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($98+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $98 = 152
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3E9,3,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3E9 = 1001; $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3EA,4,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3EA = 1002; $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3EB,5,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3EB = 1003; $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3EC,6,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3EC = 1004; $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(334,7,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(99,9,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(96,$B,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $99 = 153
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($99+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $99 = 153
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(44,3,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(37,4,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(51,5,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(61,6,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(40,9,($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9A = 154
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,3,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(39,4,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(53,5,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(63,6,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,9,($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9B = 155
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(49,3,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(38,4,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(72,5,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(65,6,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(19,7,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(55,9,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D3,$B,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D3 = 211; $B = 11; $9C = 156
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $9C = 156
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($AA,3,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $AA = 170; $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(40,4,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(72,5,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(66,6,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(79,7,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(70,9,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($AA,$B,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $AA = 170; $B = 11; $9D = 157
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $9D = 157
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(32,3,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(39,4,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(53,5,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(63,6,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,7,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(65,9,($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9F = 159
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D6,3,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D6 = 214; $9F = 159
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F1,4,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F1 = 241; $9F = 159
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(51,5,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9F = 159
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(61,6,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9F = 159
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(24,7,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9F = 159
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(60,9,($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9F = 159
    // (169) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($A9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $A9 = 169
    // (169) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($C8,$B,($A9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C8 = 200; $B = 11; $A9 = 169
    // (169) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(30,$C,($A9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $A9 = 169
    // (172) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($AC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $AC = 172
    // (172) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($C7,$B,($AC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C7 = 199; $B = 11; $AC = 172
    // (172) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(30,$C,($AC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $AC = 172
    // (173) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($AD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $AD = 173
    // (173) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($C6,$B,($AD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C6 = 198; $B = 11; $AD = 173
    // (173) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(30,$C,($AD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $AD = 173
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D0,3,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D0 = 208; $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(41,4,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DD,5,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221; $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(66,6,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D,7,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D = 13; $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,9,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D0,$B,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D0 = 208; $B = 11; $B1 = 177
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $B1 = 177
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B2 = 178
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(90,3,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B2 = 178
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F4,4,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F4 = 244; $B2 = 178
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(53,5,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B2 = 178
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(59,6,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B2 = 178
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($83,7,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $83 = 131; $B2 = 178
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,9,($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B2 = 178
    // (187) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($BB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $BB = 187
    // (187) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($EF,$B,($BB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EF = 239; $B = 11; $BB = 187
    // (187) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('d',$C,($BB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $BB = 187
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(3,2,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($CB,3,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CB = 203; $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($C0,4,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C0 = 192; $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($9F,5,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9F = 159; $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(95,9,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D1,$B,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209; $B = 11; $BF = 191
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('d',$C,($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $BF = 191
    // (192) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(3,2,($C0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C0 = 192
    // (192) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($C9,3,($C0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C9 = 201; $C0 = 192
    // (192) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($BE,4,($C0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $BE = 190; $C0 = 192
    // (192) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(95,5,($C0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C0 = 192
    // (192) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(90,9,($C0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C0 = 192
    // (193) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(3,2,($C1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C1 = 193
    // (193) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($CA,3,($C1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CA = 202; $C1 = 193
    // (193) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($BF,4,($C1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $BF = 191; $C1 = 193
    // (193) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($9E,5,($C1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $9E = 158; $C1 = 193
    // (193) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(90,9,($C1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C1 = 193
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($BD,3,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $BD = 189; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A5,4,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A5 = 165; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A4,5,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A4 = 164; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(67,6,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3EE,7,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3EE = 1006; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,9,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(3,$A,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(67,$B,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,$C,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A4,$D,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A4 = 164; $D = 13; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,$E,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E = 14; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($A5,$F,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A5 = 165; $F = 15; $CD = 205
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,16,($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $CD = 205
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,3,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(81,4,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DD,5,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221; $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(65,6,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(23,7,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(93,$B,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $D1 = 209
    // (209) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($D1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $D1 = 209
    // (210) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(82,9,($D2+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D2 = 210
    // (211) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,9,($D3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D3 = 211
    // (212) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($F,9,($D4+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F = 15; $D4 = 212
    // (213) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(45,9,($D5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D5 = 213
    // (214) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(70,9,($D6+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D6 = 214
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(6,2,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(320,3,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($84,4,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $84 = 132; $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(54,5,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(267,6,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(18,7,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(83,8,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(99,9,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(320,$B,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $D7 = 215
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('d',$C,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $D7 = 215
    // (216) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(99,9,($D8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D8 = 216
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D9 = 217
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(73,3,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D9 = 217
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(41,4,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D9 = 217
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($8A,5,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8A = 138; $D9 = 217
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(59,6,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D9 = 217
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D,7,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D = 13; $D9 = 217
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(90,9,($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D9 = 217
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DA = 218
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F5,3,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F5 = 1013; $DA = 218
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($FF,4,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $FF = 255; $DA = 218
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(82,5,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DA = 218
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(67,6,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DA = 218
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D,7,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D = 13; $DA = 218
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(75,9,($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DA = 218
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('x',3,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(37,4,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DD,5,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221; $DB = 219
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(62,6,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(87,7,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DB = 219
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DC = 220
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($E6,3,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E6 = 230; $DC = 220
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($E6,4,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E6 = 230; $DC = 220
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DD,5,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221; $DC = 220
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D9,6,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D9 = 217; $DC = 220
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($83,7,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $83 = 131; $DC = 220
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DC = 220
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,3,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(39,4,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,5,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(62,6,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(79,7,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DE = 222
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F6,3,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F6 = 1014; $DE = 222
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(80,4,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DE = 222
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DD,5,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DD = 221; $DE = 222
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(59,6,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DE = 222
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($83,7,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $83 = 131; $DE = 222
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DE = 222
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('x',3,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(81,4,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,5,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(86,6,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('v',7,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DF = 223
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E0 = 224
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(88,3,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E0 = 224
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(39,4,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E0 = 224
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($DC,5,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $DC = 220; $E0 = 224
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(62,6,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E0 = 224
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(22,7,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E0 = 224
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E0 = 224
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E1 = 225
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($D5,3,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $D5 = 213; $E1 = 225
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(81,4,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E1 = 225
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(52,5,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E1 = 225
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(59,6,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E1 = 225
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($EC,7,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EC = 236; $E1 = 225
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,9,($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E1 = 225
    // (227) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($E3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $E3 = 227
    // (227) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(330,$B,($E3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $E3 = 227
    // (227) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($E3+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $E3 = 227
    // (229) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($E5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $E5 = 229
    // (229) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(271,$B,($E5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $E5 = 229
    // (229) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($E5+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $E5 = 229
    // (230) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(99,9,($E6+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E6 = 230
    // (230) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($E6+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $E6 = 230
    // (230) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(339,$B,($E6+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $E6 = 230
    // (230) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('d',$C,($E6+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $E6 = 230
    // (231) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(99,9,($E7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E7 = 231
    // (231) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($E7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $E7 = 231
    // (231) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(338,$B,($E7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $E7 = 231
    // (231) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('d',$C,($E7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $E7 = 231
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(288,3,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F6,4,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F6 = 1014; $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(82,5,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(279,6,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($83,7,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $83 = 131; $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(90,9,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($97,$B,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $97 = 151; $B = 11; $E8 = 232
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $E8 = 232
    // (233) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(95,9,($E9+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E9 = 233
    // (234) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(65,9,($EA+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EA = 234
    // (235) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(66,9,($EB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EB = 235
    // (235) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($EB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $EB = 235
    // (235) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ('o',$B,($EB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $EB = 235
    // (235) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(25,$C,($EB+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $EB = 235
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(2,2,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EC = 236
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F6,3,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F6 = 1014; $EC = 236
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($3F6,4,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $3F6 = 1014; $EC = 236
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(85,9,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $EC = 236
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $EC = 236
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(333,$B,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $EC = 236
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $EC = 236
    // (239) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($EF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $EF = 239
    // (239) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(337,$B,($EF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $B = 11; $EF = 239
    // (239) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($EF+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $EF = 239
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(5,2,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($E5,3,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E5 = 229; $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(263,4,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($8B,5,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8B = 139; $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($8C,6,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $8C = 140; $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(92,7,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(88,9,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(1,$A,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $A = 10; $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ($E5,$B,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $E5 = 229; $B = 11; $F0 = 240
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(50,$C,($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $F0 = 240
endfunction

function Trig_Arena_Spawn_Team_IsBoostableUnit takes nothing returns boolean
    return((IsUnitType(GetLastCreatedUnit(),UNIT_TYPE_RESISTANT)==false)and(IsUnitType(GetLastCreatedUnit(),UNIT_TYPE_HERO)==false))!=null
endfunction

function Trig_Arena_Spawn_Team_IsDarkKnight takes nothing returns boolean
    return(GetUnitTypeId(GetLastCreatedUnit())=='Uear') // 'Uear': unit "Dark Knight"
endfunction

function Trig_Arena_Spawn_Team_IsNotArbiter takes nothing returns boolean
    return(GetUnitTypeId(GetLastCreatedUnit())!='E018') // 'E018': unit "Arbiter of Time"
endfunction

function Trig_Arena_Spawn_Team_HasHeroLevel takes nothing returns boolean
    // (6) plus (loop counter B).
    return(LoadIntegerBJ(9,LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)>=1)
endfunction

function Trig_Arena_Spawn_Team_IsLeaderSlot takes nothing returns boolean
    return(LoadIntegerBJ(20,udg_ArenaSpawnTeam,udg_GameStateHash)>=1)and(LoadIntegerBJ(20,udg_ArenaSpawnTeam,udg_GameStateHash)==GetForLoopIndexB())
endfunction

function Trig_Arena_Spawn_Team_IsCustomItem takes nothing returns boolean
    // Calculation 1:
    // (loop counter A) plus (2).
    // Calculation 2:
    // (6) plus (loop counter B).
    return(LoadIntegerBJ((GetForLoopIndexA()+2),LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)>=$3E8) // $3E8 = 1000
endfunction

function Trig_Arena_Spawn_Team_HasStartingItems takes nothing returns boolean
    // (6) plus (loop counter B).
    return(LoadIntegerBJ(2,LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)>0)
endfunction

function Trig_Arena_Spawn_Team_NeedsExtraSpawns takes nothing returns boolean
    return(udg_ArenaSpawnTeam==$AB) // $AB = 171
endfunction

function Trig_Arena_Spawn_Team_Actions takes nothing returns nothing
    // Result 1: (LoadIntegerBJ(6, udg_ArenaSpawnTeam, udg_GameStateHash)) minus (1).
    // Result 2: result 1 treated as a decimal-capable number.
    // Result 3: (-128) times (result 2).
    set udg_TempPoint=OffsetLocation(udg_ArenaSpawnLoc,(-128.*I2R((LoadIntegerBJ(6,udg_ArenaSpawnTeam,udg_GameStateHash)-1))),0)
    call RemoveLocation(udg_ArenaSpawnLoc)
    call Difficulty_SumHandicap(udg_CupArenaPlayers)
    // Divide the desired enemy health handicap by the enemy player's current handicap to get the adjustment factor.
    set udg_ArenaHpMultiplier=(udg_EnemyHandicap/ GetPlayerHandicapBJ(Player($B))) // $B = 11
    set bj_forLoopBIndex=1
    set bj_forLoopBIndexEnd=LoadIntegerBJ(6,udg_ArenaSpawnTeam,udg_GameStateHash)
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        // Place each next unit 256 map units farther along the row; the first has no offset.
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,(256.*I2R((GetForLoopIndexB()-1))),0)
        // (6) plus (loop counter B).
        call CreateNUnitsAtLoc(1,udg_ArenaMonsterType[LoadIntegerBJ(1,LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)],Player($B),udg_TempPoint2,udg_ArenaSpawnFacing) // $B = 11
        call RemoveLocation(udg_TempPoint2)
        // ((maximum health of GetLastCreatedUnit()) times (udg_ArenaHpMultiplier)) with its decimal part removed.
        call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*udg_ArenaHpMultiplier)))
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ArenaSpawnGroup)
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitInvulnerable(GetLastCreatedUnit(),true)
        call IssueImmediateOrderBJ(GetLastCreatedUnit(),"spiritwolf")
        call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
        if(Trig_Arena_Spawn_Team_HasHeroLevel())then
            // (6) plus (loop counter B).
            call SetHeroLevelBJ(GetLastCreatedUnit(),LoadIntegerBJ(9,LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash),false)
            if(Trig_Arena_Spawn_Team_IsDarkKnight())then
                call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossGroup)
                call UnitAddAbilityBJ('A0KS',GetLastCreatedUnit()) // 'A0KS': ability "Darkness"
                call SetUnitAbilityLevelSwapped('A0KS',GetLastCreatedUnit(),2) // 'A0KS': ability "Darkness"
                call UnitAddAbilityBJ('A0Z5',GetLastCreatedUnit()) // 'A0Z5': ability "Minus Strike"
                call SetUnitAbilityLevelSwapped('A0Z5',GetLastCreatedUnit(),$A) // 'A0Z5': ability "Minus Strike"; $A = 10
                call UnitAddAbilityBJ('A0R1',GetLastCreatedUnit()) // 'A0R1': ability "Drain Attack"
                call UnitAddAbilityBJ('A0TU',GetLastCreatedUnit()) // 'A0TU': ability "HP Regeneration Bonus"
                call SetUnitAbilityLevelSwapped('A0TU',GetLastCreatedUnit(),$A) // 'A0TU': ability "HP Regeneration Bonus"; $A = 10
                call UnitAddAbilityBJ('A1AA',GetLastCreatedUnit()) // 'A1AA': ability "!Dark Power"
            endif
            if(Trig_Arena_Spawn_Team_IsNotArbiter())then
                call Unit_ScaleToLevel60(bj_lastCreatedUnit)
            endif
        else
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
            if(Trig_Arena_Spawn_Team_IsBoostableUnit())then
                // ((maximum health of GetLastCreatedUnit()) times (2)) with its decimal part removed.
                call BlzSetUnitMaxHP(GetLastCreatedUnit(),R2I((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetLastCreatedUnit())*2.)))
                call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) times (2).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)*2),0)
                // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) times (2).
                call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)*2),1)
                // (BlzGetUnitArmor(GetLastCreatedUnit())) plus (50).
                call BlzSetUnitArmor(GetLastCreatedUnit(),(BlzGetUnitArmor(GetLastCreatedUnit())+50.))
            endif
        endif
        if(Trig_Arena_Spawn_Team_IsLeaderSlot())then
            set udg_ArenaLeaderUnit=GetLastCreatedUnit()
        endif
        call SetUnitAcquireRangeBJ(GetLastCreatedUnit(),1.28)
        // (LoadIntegerBJ((6) plus (loop counter B), udg_ArenaSpawnTeam, udg_GameStateHash)) plus (10).
        call SetUnitUserData(GetLastCreatedUnit(),(LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash)+$A)) // $A = 10
        if(Trig_Arena_Spawn_Team_HasStartingItems())then
            set bj_forLoopAIndex=1
            // (6) plus (loop counter B).
            set bj_forLoopAIndexEnd=LoadIntegerBJ(2,LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Arena_Spawn_Team_IsCustomItem())then
                    // Result 1: (loop counter A) plus (2).
                    // Result 2: (6) plus (loop counter B).
                    // Result 3: (LoadIntegerBJ(result 1, LoadIntegerBJ(result 2, udg_ArenaSpawnTeam, udg_GameStateHash),
                    // udg_GameStateHash)) minus (1000).
                    call UnitAddItemByIdSwapped(udg_ArenaMonsterItem[(LoadIntegerBJ((GetForLoopIndexA()+2),LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)-$3E8)],GetLastCreatedUnit()) // $3E8 = 1000
                else
                    // Calculation 1:
                    // (loop counter A) plus (2).
                    // Calculation 2:
                    // (6) plus (loop counter B).
                    call UnitAddItemByIdSwapped(udg_ItemIdTable[LoadIntegerBJ((GetForLoopIndexA()+2),LoadIntegerBJ((6+GetForLoopIndexB()),udg_ArenaSpawnTeam,udg_GameStateHash),udg_GameStateHash)],GetLastCreatedUnit())
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
        endif
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    if(Trig_Arena_Spawn_Team_NeedsExtraSpawns())then
        // (udg_ArenaSpawnFacing) minus (75).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,360.,(udg_ArenaSpawnFacing-75.))
        call CreateNUnitsAtLoc(1,'n0D7',Player($B),udg_TempPoint2,udg_ArenaSpawnFacing) // 'n0D7': unit "Unum"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ArenaSpawnGroup)
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitInvulnerable(GetLastCreatedUnit(),true)
        call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
        // (udg_ArenaSpawnFacing) minus (25).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,360.,(udg_ArenaSpawnFacing-25.))
        call CreateNUnitsAtLoc(1,'n0K8',Player($B),udg_TempPoint2,udg_ArenaSpawnFacing) // 'n0K8': unit "Duo"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ArenaSpawnGroup)
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitInvulnerable(GetLastCreatedUnit(),true)
        call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
        // (udg_ArenaSpawnFacing) plus (25).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,360.,(udg_ArenaSpawnFacing+25.))
        call CreateNUnitsAtLoc(1,'n0K9',Player($B),udg_TempPoint2,udg_ArenaSpawnFacing) // 'n0K9': unit "Tria"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ArenaSpawnGroup)
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitInvulnerable(GetLastCreatedUnit(),true)
        call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
        // (udg_ArenaSpawnFacing) plus (75).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,360.,(udg_ArenaSpawnFacing+75.))
        call CreateNUnitsAtLoc(1,'n0KA',Player($B),udg_TempPoint2,udg_ArenaSpawnFacing) // 'n0KA': unit "Quattour"; $B = 11
        call RemoveLocation(udg_TempPoint2)
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_ArenaSpawnGroup)
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitInvulnerable(GetLastCreatedUnit(),true)
        call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
    endif
    call RemoveLocation(udg_TempPoint)
endfunction

function InitTrig_Arena_Spawning takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2 (module Arena),
// which keeps the original registration order.

function Register_Arena_Unit_Data takes nothing returns nothing
    set gg_trg_Arena_Unit_Data=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Arena_Unit_Data,4.)
    call TriggerAddAction(gg_trg_Arena_Unit_Data,function Trig_Arena_Unit_Data_Actions)
endfunction

function Register_Arena_Spawn_Team takes nothing returns nothing
    set gg_trg_Arena_Spawn_Team=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Arena_Spawn_Team,udg_ArenaSpawnTimer)
    call TriggerAddAction(gg_trg_Arena_Spawn_Team,function Trig_Arena_Spawn_Team_Actions)
endfunction

endlibrary

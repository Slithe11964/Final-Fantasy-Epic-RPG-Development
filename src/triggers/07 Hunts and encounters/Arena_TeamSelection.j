library TArenaTeamSelection
function Trig_Arena_Team_Data_A_Actions takes nothing returns nothing
    call SaveStringBJ("Devil Duo",1,'e',udg_GameStateHash)
    call SaveIntegerBJ(4,3,'e',udg_GameStateHash)
    call SaveIntegerBJ(1,4,'e',udg_GameStateHash)
    call SaveIntegerBJ('f',5,'e',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'e',udg_GameStateHash)
    // (133) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($85+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'e',udg_GameStateHash) // $85 = 133
    // (236) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($EC+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'e',udg_GameStateHash) // $EC = 236
    call SaveIntegerBJ(9,$A,'e',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Demonic Archer",1,'f',udg_GameStateHash)
    call SaveIntegerBJ(1,3,'f',udg_GameStateHash)
    call SaveIntegerBJ(80,5,'f',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'f',udg_GameStateHash)
    // (134) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($86+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'f',udg_GameStateHash) // $86 = 134
    call SaveIntegerBJ(7,$A,'f',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Shadow Queen",1,'g',udg_GameStateHash)
    call SaveIntegerBJ(1,3,'g',udg_GameStateHash)
    call SaveIntegerBJ(85,5,'g',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'g',udg_GameStateHash)
    // (135) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($87+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'g',udg_GameStateHash) // $87 = 135
    call SaveIntegerBJ(9,$A,'g',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Mithril Golem",1,'h',udg_GameStateHash)
    call SaveIntegerBJ(55,5,'h',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'h',udg_GameStateHash)
    // (92) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((92+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'h',udg_GameStateHash)
    call SaveIntegerBJ(4,$A,'h',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Naga Matriarch",1,'i',udg_GameStateHash)
    call SaveIntegerBJ(70,5,'i',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'i',udg_GameStateHash)
    // (136) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($88+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'i',udg_GameStateHash) // $88 = 136
    // (115) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(('s'+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'i',udg_GameStateHash)
    // (115) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(('s'+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'i',udg_GameStateHash)
    call SaveIntegerBJ(7,$A,'i',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Greatest Khan",1,'j',udg_GameStateHash)
    call SaveIntegerBJ(1,3,'j',udg_GameStateHash)
    call SaveIntegerBJ(24,5,'j',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'j',udg_GameStateHash)
    // (137) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($89+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'j',udg_GameStateHash) // $89 = 137
    // (33) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'j',udg_GameStateHash)
    // (33) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'j',udg_GameStateHash)
    call SaveIntegerBJ(2,$A,'j',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Corrupted Blades",1,'k',udg_GameStateHash)
    call SaveIntegerBJ(80,5,'k',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'k',udg_GameStateHash)
    // (138) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8A+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'k',udg_GameStateHash) // $8A = 138
    // (139) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8B+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'k',udg_GameStateHash) // $8B = 139
    // (139) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8B+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'k',udg_GameStateHash) // $8B = 139
    call SaveIntegerBJ(7,$A,'k',udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(9,$B,'k',udg_GameStateHash) // $B = 11
    call SaveStringBJ("Planeswalker",1,'l',udg_GameStateHash)
    call SaveIntegerBJ(85,5,'l',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'l',udg_GameStateHash)
    // (140) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8C+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'l',udg_GameStateHash) // $8C = 140
    call SaveIntegerBJ(8,$A,'l',udg_GameStateHash) // $A = 10
    call SaveIntegerBJ(9,$B,'l',udg_GameStateHash) // $B = 11
    call SaveStringBJ("Planeswalker",1,'m',udg_GameStateHash)
    call SaveIntegerBJ(4,3,'m',udg_GameStateHash)
    call SaveIntegerBJ(1,4,'m',udg_GameStateHash)
    call SaveIntegerBJ('x',5,'m',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'m',udg_GameStateHash)
    // (143) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8F+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'m',udg_GameStateHash) // $8F = 143
    call SaveStringBJ("Brothers",1,'n',udg_GameStateHash)
    call SaveIntegerBJ(40,5,'n',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'n',udg_GameStateHash)
    // (141) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8D+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'n',udg_GameStateHash) // $8D = 141
    // (142) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($8E+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'n',udg_GameStateHash) // $8E = 142
    call SaveIntegerBJ(3,$A,'n',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Brothers",1,'o',udg_GameStateHash)
    call SaveIntegerBJ(3,3,'o',udg_GameStateHash)
    call SaveIntegerBJ(77,5,'o',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'o',udg_GameStateHash)
    // (144) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($90+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'o',udg_GameStateHash) // $90 = 144
    // (145) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($91+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'o',udg_GameStateHash) // $91 = 145
    call SaveIntegerBJ(8,$A,'o',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Strongest Eidolon",1,'p',udg_GameStateHash)
    call SaveIntegerBJ(4,3,'p',udg_GameStateHash)
    call SaveIntegerBJ(1,4,'p',udg_GameStateHash)
    call SaveIntegerBJ(96,5,'p',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'p',udg_GameStateHash)
    // (146) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($92+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'p',udg_GameStateHash) // $92 = 146
    call SaveIntegerBJ(9,$A,'p',udg_GameStateHash) // $A = 10
    call SaveIntegerBJ($A,$B,'p',udg_GameStateHash) // $A = 10; $B = 11
    call SaveStringBJ("Abyssal Wolves",1,'q',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'q',udg_GameStateHash)
    call SaveIntegerBJ(3,3,'q',udg_GameStateHash)
    call SaveIntegerBJ(99,5,'q',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'q',udg_GameStateHash)
    // (148) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($94+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'q',udg_GameStateHash) // $94 = 148
    // (148) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($94+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'q',udg_GameStateHash) // $94 = 148
    // (148) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($94+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'q',udg_GameStateHash) // $94 = 148
    call SaveIntegerBJ($A,$A,'q',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Swift Lizards",1,'r',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'r',udg_GameStateHash)
    call SaveIntegerBJ(3,3,'r',udg_GameStateHash)
    call SaveIntegerBJ(99,5,'r',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'r',udg_GameStateHash)
    // (147) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($93+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'r',udg_GameStateHash) // $93 = 147
    // (147) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($93+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'r',udg_GameStateHash) // $93 = 147
    // (147) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($93+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'r',udg_GameStateHash) // $93 = 147
    call SaveIntegerBJ($A,$A,'r',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Speed and Strength",1,'s',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'s',udg_GameStateHash)
    call SaveIntegerBJ(98,5,'s',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'s',udg_GameStateHash)
    // (147) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($93+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'s',udg_GameStateHash) // $93 = 147
    // (148) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($94+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'s',udg_GameStateHash) // $94 = 148
    call SaveIntegerBJ($A,$A,'s',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Spiritual Energy",1,'t',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'t',udg_GameStateHash)
    call SaveIntegerBJ(97,5,'t',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'t',udg_GameStateHash)
    // (150) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($96+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'t',udg_GameStateHash) // $96 = 150
    // (150) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($96+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'t',udg_GameStateHash) // $96 = 150
    call SaveIntegerBJ($A,$A,'t',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Farplane Predators",1,'u',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'u',udg_GameStateHash)
    call SaveIntegerBJ(98,5,'u',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'u',udg_GameStateHash)
    // (149) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($95+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'u',udg_GameStateHash) // $95 = 149
    // (149) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($95+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'u',udg_GameStateHash) // $95 = 149
    call SaveIntegerBJ($A,$A,'u',udg_GameStateHash) // $A = 10
    call SaveStringBJ("A Real Dragon!",1,'v',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'v',udg_GameStateHash)
    call SaveIntegerBJ(97,5,'v',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'v',udg_GameStateHash)
    // (151) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($97+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'v',udg_GameStateHash) // $97 = 151
    call SaveIntegerBJ($A,$A,'v',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Bahamut's Guards",1,'w',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'w',udg_GameStateHash)
    call SaveIntegerBJ(3,3,'w',udg_GameStateHash)
    call SaveIntegerBJ('e',5,'w',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'w',udg_GameStateHash)
    // (151) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($97+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'w',udg_GameStateHash) // $97 = 151
    // (151) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($97+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'w',udg_GameStateHash) // $97 = 151
    call SaveIntegerBJ($A,$A,'w',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Der Richter",1,'x',udg_GameStateHash)
    call SaveIntegerBJ(5,3,'x',udg_GameStateHash)
    call SaveIntegerBJ(1,4,'x',udg_GameStateHash)
    call SaveIntegerBJ('x',5,'x',udg_GameStateHash)
    call SaveIntegerBJ(3,6,'x',udg_GameStateHash)
    // (207) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CF+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'x',udg_GameStateHash) // $CF = 207
    // (152) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($98+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'x',udg_GameStateHash) // $98 = 152
    // (208) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D0+LoadIntegerBJ(2,0,udg_GameStateHash)),9,'x',udg_GameStateHash) // $D0 = 208
    call SaveStringBJ("Northern God",1,'y',udg_GameStateHash)
    call SaveIntegerBJ(5,3,'y',udg_GameStateHash)
    call SaveIntegerBJ(1,4,'y',udg_GameStateHash)
    call SaveIntegerBJ('x',5,'y',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'y',udg_GameStateHash)
    // (153) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($99+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'y',udg_GameStateHash) // $99 = 153
    call SaveStringBJ("Master Engineer",1,'z',udg_GameStateHash)
    call SaveIntegerBJ(1,2,'z',udg_GameStateHash)
    call SaveIntegerBJ(78,5,'z',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'z',udg_GameStateHash)
    // (154) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($9A+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'z',udg_GameStateHash) // $9A = 154
    call SaveIntegerBJ(8,$A,'z',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Master Engineer",1,'{',udg_GameStateHash)
    call SaveIntegerBJ(3,3,'{',udg_GameStateHash)
    call SaveIntegerBJ(1,4,'{',udg_GameStateHash)
    call SaveIntegerBJ(85,5,'{',udg_GameStateHash)
    call SaveIntegerBJ(1,6,'{',udg_GameStateHash)
    // (155) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($9B+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'{',udg_GameStateHash) // $9B = 155
    call SaveIntegerBJ(8,$A,'{',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Rays of Light",1,'|',udg_GameStateHash)
    call SaveIntegerBJ(81,5,'|',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'|',udg_GameStateHash)
    // (156) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($9C+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'|',udg_GameStateHash) // $9C = 156
    // (157) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($9D+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'|',udg_GameStateHash) // $9D = 157
    call SaveIntegerBJ(8,$A,'|',udg_GameStateHash) // $A = 10
    call SaveStringBJ("Defenders",1,'}',udg_GameStateHash)
    call SaveIntegerBJ(79,5,'}',udg_GameStateHash)
    call SaveIntegerBJ(2,6,'}',udg_GameStateHash)
    // (158) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($9E+LoadIntegerBJ(2,0,udg_GameStateHash)),7,'}',udg_GameStateHash) // $9E = 158
    // (159) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($9F+LoadIntegerBJ(2,0,udg_GameStateHash)),8,'}',udg_GameStateHash) // $9F = 159
    call SaveIntegerBJ(8,$A,'}',udg_GameStateHash) // $A = 10
    call SaveStringBJ("The Great Warrior",1,$7E,udg_GameStateHash) // $7E = 126
    call SaveIntegerBJ(1,2,$7E,udg_GameStateHash) // $7E = 126
    call SaveIntegerBJ(77,5,$7E,udg_GameStateHash) // $7E = 126
    call SaveIntegerBJ(1,6,$7E,udg_GameStateHash) // $7E = 126
    // (160) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A0+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$7E,udg_GameStateHash) // $A0 = 160; $7E = 126
    call SaveIntegerBJ(8,$A,$7E,udg_GameStateHash) // $A = 10; $7E = 126
    call SaveStringBJ("Elune's Huntress",1,$7F,udg_GameStateHash) // $7F = 127
    call SaveIntegerBJ(3,3,$7F,udg_GameStateHash) // $7F = 127
    call SaveIntegerBJ(76,5,$7F,udg_GameStateHash) // $7F = 127
    call SaveIntegerBJ(1,6,$7F,udg_GameStateHash) // $7F = 127
    // (161) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A1+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$7F,udg_GameStateHash) // $A1 = 161; $7F = 127
    call SaveIntegerBJ(8,$A,$7F,udg_GameStateHash) // $A = 10; $7F = 127
    call SaveStringBJ("AVALANCHE",1,$80,udg_GameStateHash) // $80 = 128
    call SaveIntegerBJ(1,2,$80,udg_GameStateHash) // $80 = 128
    call SaveIntegerBJ(80,5,$80,udg_GameStateHash) // $80 = 128
    call SaveIntegerBJ(3,6,$80,udg_GameStateHash) // $80 = 128
    // (162) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A2+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$80,udg_GameStateHash) // $A2 = 162; $80 = 128
    // (163) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A3+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$80,udg_GameStateHash) // $A3 = 163; $80 = 128
    // (164) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A4+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$80,udg_GameStateHash) // $A4 = 164; $80 = 128
    call SaveIntegerBJ(8,$A,$80,udg_GameStateHash) // $A = 10; $80 = 128
    call SaveStringBJ("Elemental Pandarens",1,$81,udg_GameStateHash) // $81 = 129
    call SaveIntegerBJ(1,2,$81,udg_GameStateHash) // $81 = 129
    call SaveIntegerBJ(80,5,$81,udg_GameStateHash) // $81 = 129
    call SaveIntegerBJ(3,6,$81,udg_GameStateHash) // $81 = 129
    // (165) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A5+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$81,udg_GameStateHash) // $A5 = 165; $81 = 129
    // (166) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A6+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$81,udg_GameStateHash) // $A6 = 166; $81 = 129
    // (167) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A7+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$81,udg_GameStateHash) // $A7 = 167; $81 = 129
    call SaveIntegerBJ(8,$A,$81,udg_GameStateHash) // $A = 10; $81 = 129
    call SaveStringBJ("Lords of Bolt",1,$82,udg_GameStateHash) // $82 = 130
    call SaveIntegerBJ(78,5,$82,udg_GameStateHash) // $82 = 130
    call SaveIntegerBJ(2,6,$82,udg_GameStateHash) // $82 = 130
    // (168) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$82,udg_GameStateHash) // $A8 = 168; $82 = 130
    // (169) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($A9+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$82,udg_GameStateHash) // $A9 = 169; $82 = 130
    call SaveIntegerBJ(8,$A,$82,udg_GameStateHash) // $A = 10; $82 = 130
    call SaveStringBJ("Super Smash Bros",1,$83,udg_GameStateHash) // $83 = 131
    call SaveIntegerBJ(1,2,$83,udg_GameStateHash) // $83 = 131
    call SaveIntegerBJ(77,5,$83,udg_GameStateHash) // $83 = 131
    call SaveIntegerBJ(2,6,$83,udg_GameStateHash) // $83 = 131
    // (170) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($AA+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$83,udg_GameStateHash) // $AA = 170; $83 = 131
    // (171) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($AB+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$83,udg_GameStateHash) // $AB = 171; $83 = 131
    call SaveIntegerBJ(8,$A,$83,udg_GameStateHash) // $A = 10; $83 = 131
    call SaveStringBJ("Temp Fayth",1,$84,udg_GameStateHash) // $84 = 132
    call SaveIntegerBJ(1,2,$84,udg_GameStateHash) // $84 = 132
    call SaveIntegerBJ(77,5,$84,udg_GameStateHash) // $84 = 132
    call SaveIntegerBJ(2,6,$84,udg_GameStateHash) // $84 = 132
    // (172) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($AC+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$84,udg_GameStateHash) // $AC = 172; $84 = 132
    // (173) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($AD+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$84,udg_GameStateHash) // $AD = 173; $84 = 132
    call SaveIntegerBJ(8,$A,$84,udg_GameStateHash) // $A = 10; $84 = 132
    call SaveStringBJ("A Rat's Tale",1,$85,udg_GameStateHash) // $85 = 133
    call SaveIntegerBJ(1,2,$85,udg_GameStateHash) // $85 = 133
    call SaveIntegerBJ(79,5,$85,udg_GameStateHash) // $85 = 133
    call SaveIntegerBJ(3,6,$85,udg_GameStateHash) // $85 = 133
    // (174) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($AE+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$85,udg_GameStateHash) // $AE = 174; $85 = 133
    // (175) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($AF+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$85,udg_GameStateHash) // $AF = 175; $85 = 133
    // (176) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B0+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$85,udg_GameStateHash) // $B0 = 176; $85 = 133
    call SaveIntegerBJ(8,$A,$85,udg_GameStateHash) // $A = 10; $85 = 133
    call SaveStringBJ("Demon Banishers",1,$86,udg_GameStateHash) // $86 = 134
    call SaveIntegerBJ(3,3,$86,udg_GameStateHash) // $86 = 134
    call SaveIntegerBJ(1,4,$86,udg_GameStateHash) // $86 = 134
    call SaveIntegerBJ(86,5,$86,udg_GameStateHash) // $86 = 134
    call SaveIntegerBJ(2,6,$86,udg_GameStateHash) // $86 = 134
    // (177) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B1+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$86,udg_GameStateHash) // $B1 = 177; $86 = 134
    // (178) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B2+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$86,udg_GameStateHash) // $B2 = 178; $86 = 134
    call SaveIntegerBJ(8,$A,$86,udg_GameStateHash) // $A = 10; $86 = 134
    call SaveStringBJ("Savage Wolves",1,$87,udg_GameStateHash) // $87 = 135
    call SaveIntegerBJ(1,2,$87,udg_GameStateHash) // $87 = 135
    call SaveIntegerBJ(39,5,$87,udg_GameStateHash) // $87 = 135
    call SaveIntegerBJ(3,6,$87,udg_GameStateHash) // $87 = 135
    // (179) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B3+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$87,udg_GameStateHash) // $B3 = 179; $87 = 135
    // (180) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B4+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$87,udg_GameStateHash) // $B4 = 180; $87 = 135
    // (180) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B4+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$87,udg_GameStateHash) // $B4 = 180; $87 = 135
    call SaveIntegerBJ(4,$A,$87,udg_GameStateHash) // $A = 10; $87 = 135
    call SaveStringBJ("Magic Rocks",1,$88,udg_GameStateHash) // $88 = 136
    call SaveIntegerBJ(1,2,$88,udg_GameStateHash) // $88 = 136
    call SaveIntegerBJ(38,5,$88,udg_GameStateHash) // $88 = 136
    call SaveIntegerBJ(3,6,$88,udg_GameStateHash) // $88 = 136
    // (181) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B5+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$88,udg_GameStateHash) // $B5 = 181; $88 = 136
    // (182) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B6+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$88,udg_GameStateHash) // $B6 = 182; $88 = 136
    // (182) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B6+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$88,udg_GameStateHash) // $B6 = 182; $88 = 136
    call SaveIntegerBJ(3,$A,$88,udg_GameStateHash) // $A = 10; $88 = 136
    call SaveIntegerBJ(4,$B,$88,udg_GameStateHash) // $B = 11; $88 = 136
    call SaveStringBJ("Mechanic Fighters",1,$89,udg_GameStateHash) // $89 = 137
    call SaveIntegerBJ(1,2,$89,udg_GameStateHash) // $89 = 137
    call SaveIntegerBJ(40,5,$89,udg_GameStateHash) // $89 = 137
    call SaveIntegerBJ(3,6,$89,udg_GameStateHash) // $89 = 137
    // (183) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B7+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$89,udg_GameStateHash) // $B7 = 183; $89 = 137
    // (184) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$89,udg_GameStateHash) // $B8 = 184; $89 = 137
    // (184) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B8+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$89,udg_GameStateHash) // $B8 = 184; $89 = 137
    call SaveIntegerBJ(4,$A,$89,udg_GameStateHash) // $A = 10; $89 = 137
    call SaveStringBJ("Heavenly Weight",1,$8A,udg_GameStateHash) // $8A = 138
    call SaveIntegerBJ(1,2,$8A,udg_GameStateHash) // $8A = 138
    call SaveIntegerBJ(99,5,$8A,udg_GameStateHash) // $8A = 138
    call SaveIntegerBJ(3,6,$8A,udg_GameStateHash) // $8A = 138
    // (186) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($BA+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$8A,udg_GameStateHash) // $BA = 186; $8A = 138
    // (185) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B9+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$8A,udg_GameStateHash) // $B9 = 185; $8A = 138
    // (185) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($B9+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$8A,udg_GameStateHash) // $B9 = 185; $8A = 138
    call SaveIntegerBJ($A,$A,$8A,udg_GameStateHash) // $A = 10; $8A = 138
    call SaveStringBJ("Tainted Cúchulainn",1,$8B,udg_GameStateHash) // $8B = 139
    call SaveIntegerBJ(70,5,$8B,udg_GameStateHash) // $8B = 139
    call SaveIntegerBJ(1,6,$8B,udg_GameStateHash) // $8B = 139
    // (6) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((6+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$8B,udg_GameStateHash) // $8B = 139
    call SaveStringBJ("Split Devil",1,$8C,udg_GameStateHash) // $8C = 140
    call SaveIntegerBJ(4,3,$8C,udg_GameStateHash) // $8C = 140
    call SaveIntegerBJ(90,5,$8C,udg_GameStateHash) // $8C = 140
    call SaveIntegerBJ(3,6,$8C,udg_GameStateHash) // $8C = 140
    // (187) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($BB+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$8C,udg_GameStateHash) // $BB = 187; $8C = 140
    // (188) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($BC+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$8C,udg_GameStateHash) // $BC = 188; $8C = 140
    // (189) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($BD+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$8C,udg_GameStateHash) // $BD = 189; $8C = 140
    call SaveIntegerBJ(8,$A,$8C,udg_GameStateHash) // $A = 10; $8C = 140
    call SaveStringBJ("Infernal Templar",1,$8D,udg_GameStateHash) // $8D = 141
    call SaveIntegerBJ($E,5,$8D,udg_GameStateHash) // $E = 14; $8D = 141
    call SaveIntegerBJ(1,6,$8D,udg_GameStateHash) // $8D = 141
    // (7) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$8D,udg_GameStateHash) // $8D = 141
    call SaveIntegerBJ(1,$A,$8D,udg_GameStateHash) // $A = 10; $8D = 141
    call SaveStringBJ("Deadly Fangs",1,$8E,udg_GameStateHash) // $8E = 142
    call SaveIntegerBJ($F,5,$8E,udg_GameStateHash) // $F = 15; $8E = 142
    call SaveIntegerBJ(3,6,$8E,udg_GameStateHash) // $8E = 142
    // (23) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((23+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$8E,udg_GameStateHash) // $8E = 142
    // (23) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((23+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$8E,udg_GameStateHash) // $8E = 142
    // (23) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((23+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$8E,udg_GameStateHash) // $8E = 142
    call SaveIntegerBJ(1,$A,$8E,udg_GameStateHash) // $A = 10; $8E = 142
    call SaveStringBJ("Disciples of Hell",1,$8F,udg_GameStateHash) // $8F = 143
    call SaveIntegerBJ($F,5,$8F,udg_GameStateHash) // $F = 15; $8F = 143
    call SaveIntegerBJ(2,6,$8F,udg_GameStateHash) // $8F = 143
    // (7) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$8F,udg_GameStateHash) // $8F = 143
    // (8) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((8+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$8F,udg_GameStateHash) // $8F = 143
    call SaveIntegerBJ(1,$A,$8F,udg_GameStateHash) // $A = 10; $8F = 143
    call SaveStringBJ("Goblin Magic",1,$90,udg_GameStateHash) // $90 = 144
    call SaveIntegerBJ(8,5,$90,udg_GameStateHash) // $90 = 144
    call SaveIntegerBJ(3,6,$90,udg_GameStateHash) // $90 = 144
    // (16) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((16+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$90,udg_GameStateHash) // $90 = 144
    // (16) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((16+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$90,udg_GameStateHash) // $90 = 144
    // (16) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((16+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$90,udg_GameStateHash) // $90 = 144
    call SaveIntegerBJ(1,$A,$90,udg_GameStateHash) // $A = 10; $90 = 144
    call SaveStringBJ("High Tritons",1,$91,udg_GameStateHash) // $91 = 145
    call SaveIntegerBJ(5,5,$91,udg_GameStateHash) // $91 = 145
    call SaveIntegerBJ(3,6,$91,udg_GameStateHash) // $91 = 145
    // (190) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($BE+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$91,udg_GameStateHash) // $BE = 190; $91 = 145
    // (24) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((24+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$91,udg_GameStateHash) // $91 = 145
    // (24) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((24+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$91,udg_GameStateHash) // $91 = 145
    call SaveIntegerBJ(1,$A,$91,udg_GameStateHash) // $A = 10; $91 = 145
    call SaveStringBJ("Warring Triad",1,$92,udg_GameStateHash) // $92 = 146
    call SaveIntegerBJ(4,3,$92,udg_GameStateHash) // $92 = 146
    call SaveIntegerBJ(1,4,$92,udg_GameStateHash) // $92 = 146
    call SaveIntegerBJ('o',5,$92,udg_GameStateHash) // $92 = 146
    call SaveIntegerBJ(3,6,$92,udg_GameStateHash) // $92 = 146
    // (191) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($BF+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$92,udg_GameStateHash) // $BF = 191; $92 = 146
    // (192) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C0+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$92,udg_GameStateHash) // $C0 = 192; $92 = 146
    // (193) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C1+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$92,udg_GameStateHash) // $C1 = 193; $92 = 146
    call SaveIntegerBJ($A,$A,$92,udg_GameStateHash) // $A = 10; $92 = 146
    call SaveStringBJ("Thieving Witches",1,$93,udg_GameStateHash) // $93 = 147
    call SaveIntegerBJ(17,5,$93,udg_GameStateHash) // $93 = 147
    call SaveIntegerBJ(3,6,$93,udg_GameStateHash) // $93 = 147
    // (41) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((41+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$93,udg_GameStateHash) // $93 = 147
    // (41) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((41+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$93,udg_GameStateHash) // $93 = 147
    // (41) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((41+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$93,udg_GameStateHash) // $93 = 147
    call SaveIntegerBJ(2,$A,$93,udg_GameStateHash) // $A = 10; $93 = 147
    call SaveStringBJ("Centaur Power",1,$94,udg_GameStateHash) // $94 = 148
    call SaveIntegerBJ(23,5,$94,udg_GameStateHash) // $94 = 148
    call SaveIntegerBJ(3,6,$94,udg_GameStateHash) // $94 = 148
    // (33) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$94,udg_GameStateHash) // $94 = 148
    // (33) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$94,udg_GameStateHash) // $94 = 148
    // (33) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$94,udg_GameStateHash) // $94 = 148
    call SaveIntegerBJ(2,$A,$94,udg_GameStateHash) // $A = 10; $94 = 148
    call SaveStringBJ("Desert Rage",1,$95,udg_GameStateHash) // $95 = 149
    call SaveIntegerBJ(23,5,$95,udg_GameStateHash) // $95 = 149
    call SaveIntegerBJ(3,6,$95,udg_GameStateHash) // $95 = 149
    // (33) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((33+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$95,udg_GameStateHash) // $95 = 149
    // (48) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((48+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$95,udg_GameStateHash) // $95 = 149
    // (38) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((38+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$95,udg_GameStateHash) // $95 = 149
    call SaveIntegerBJ(2,$A,$95,udg_GameStateHash) // $A = 10; $95 = 149
    call SaveStringBJ("Golden Beasts",1,$96,udg_GameStateHash) // $96 = 150
    call SaveIntegerBJ(22,5,$96,udg_GameStateHash) // $96 = 150
    call SaveIntegerBJ(3,6,$96,udg_GameStateHash) // $96 = 150
    // (38) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((38+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$96,udg_GameStateHash) // $96 = 150
    // (49) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((49+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$96,udg_GameStateHash) // $96 = 150
    // (44) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((44+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$96,udg_GameStateHash) // $96 = 150
    call SaveIntegerBJ(2,$A,$96,udg_GameStateHash) // $A = 10; $96 = 150
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_Team_Data_B_Actions takes nothing returns nothing
    call SaveStringBJ("Elder Wyrm",1,$97,udg_GameStateHash) // $97 = 151
    call SaveIntegerBJ(24,5,$97,udg_GameStateHash) // $97 = 151
    call SaveIntegerBJ(1,6,$97,udg_GameStateHash) // $97 = 151
    // (94) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$97,udg_GameStateHash) // $97 = 151
    call SaveIntegerBJ(2,$A,$97,udg_GameStateHash) // $A = 10; $97 = 151
    call SaveStringBJ("Master Lizards",1,$98,udg_GameStateHash) // $98 = 152
    call SaveIntegerBJ(24,5,$98,udg_GameStateHash) // $98 = 152
    call SaveIntegerBJ(2,6,$98,udg_GameStateHash) // $98 = 152
    // (94) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$98,udg_GameStateHash) // $98 = 152
    // (50) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((50+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$98,udg_GameStateHash) // $98 = 152
    call SaveIntegerBJ(2,$A,$98,udg_GameStateHash) // $A = 10; $98 = 152
    call SaveStringBJ("Final Bolt",1,$99,udg_GameStateHash) // $99 = 153
    call SaveIntegerBJ(28,5,$99,udg_GameStateHash) // $99 = 153
    call SaveIntegerBJ(2,6,$99,udg_GameStateHash) // $99 = 153
    // (94) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$99,udg_GameStateHash) // $99 = 153
    // (94) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$99,udg_GameStateHash) // $99 = 153
    // (94) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ((94+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$99,udg_GameStateHash) // $99 = 153
    call SaveIntegerBJ(2,$A,$99,udg_GameStateHash) // $A = 10; $99 = 153
    call SaveStringBJ("Arena Owners",1,$9A,udg_GameStateHash) // $9A = 154
    call SaveIntegerBJ(5,3,$9A,udg_GameStateHash) // $9A = 154
    call SaveIntegerBJ(1,4,$9A,udg_GameStateHash) // $9A = 154
    call SaveIntegerBJ('x',5,$9A,udg_GameStateHash) // $9A = 154
    call SaveIntegerBJ(3,6,$9A,udg_GameStateHash) // $9A = 154
    // (195) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C3+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$9A,udg_GameStateHash) // $C3 = 195; $9A = 154
    // (194) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C2+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$9A,udg_GameStateHash) // $C2 = 194; $9A = 154
    // (196) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C4+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$9A,udg_GameStateHash) // $C4 = 196; $9A = 154
    call SaveIntegerBJ(8,$A,$9A,udg_GameStateHash) // $A = 10; $9A = 154
    call SaveIntegerBJ(2,20,$9A,udg_GameStateHash) // $9A = 154
    call SaveStringBJ("Hostile Goblins",1,$9B,udg_GameStateHash) // $9B = 155
    call SaveIntegerBJ(18,5,$9B,udg_GameStateHash) // $9B = 155
    call SaveIntegerBJ(2,6,$9B,udg_GameStateHash) // $9B = 155
    // (197) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C5+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$9B,udg_GameStateHash) // $C5 = 197; $9B = 155
    // (197) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C5+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$9B,udg_GameStateHash) // $C5 = 197; $9B = 155
    call SaveIntegerBJ(1,$A,$9B,udg_GameStateHash) // $A = 10; $9B = 155
    call SaveStringBJ("Hostile Centaurs",1,$9C,udg_GameStateHash) // $9C = 156
    call SaveIntegerBJ(28,5,$9C,udg_GameStateHash) // $9C = 156
    call SaveIntegerBJ(2,6,$9C,udg_GameStateHash) // $9C = 156
    // (198) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C6+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$9C,udg_GameStateHash) // $C6 = 198; $9C = 156
    // (198) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C6+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$9C,udg_GameStateHash) // $C6 = 198; $9C = 156
    call SaveIntegerBJ(2,$A,$9C,udg_GameStateHash) // $A = 10; $9C = 156
    call SaveStringBJ("Hostile Hydras",1,$9D,udg_GameStateHash) // $9D = 157
    call SaveIntegerBJ(45,5,$9D,udg_GameStateHash) // $9D = 157
    call SaveIntegerBJ(2,6,$9D,udg_GameStateHash) // $9D = 157
    // (199) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$9D,udg_GameStateHash) // $C7 = 199; $9D = 157
    // (199) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C7+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$9D,udg_GameStateHash) // $C7 = 199; $9D = 157
    call SaveIntegerBJ(4,$A,$9D,udg_GameStateHash) // $A = 10; $9D = 157
    call SaveStringBJ("Hostile Ogres",1,$9E,udg_GameStateHash) // $9E = 158
    call SaveIntegerBJ(38,5,$9E,udg_GameStateHash) // $9E = 158
    call SaveIntegerBJ(2,6,$9E,udg_GameStateHash) // $9E = 158
    // (200) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$9E,udg_GameStateHash) // $C8 = 200; $9E = 158
    // (200) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C8+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$9E,udg_GameStateHash) // $C8 = 200; $9E = 158
    call SaveIntegerBJ(3,$A,$9E,udg_GameStateHash) // $A = 10; $9E = 158
    call SaveStringBJ("Hostile Golems",1,$9F,udg_GameStateHash) // $9F = 159
    call SaveIntegerBJ(49,5,$9F,udg_GameStateHash) // $9F = 159
    call SaveIntegerBJ(2,6,$9F,udg_GameStateHash) // $9F = 159
    // (201) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C9+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$9F,udg_GameStateHash) // $C9 = 201; $9F = 159
    // (201) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($C9+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$9F,udg_GameStateHash) // $C9 = 201; $9F = 159
    call SaveIntegerBJ(4,$A,$9F,udg_GameStateHash) // $A = 10; $9F = 159
    call SaveStringBJ("Hostile Naga",1,$A0,udg_GameStateHash) // $A0 = 160
    call SaveIntegerBJ(75,5,$A0,udg_GameStateHash) // $A0 = 160
    call SaveIntegerBJ(2,6,$A0,udg_GameStateHash) // $A0 = 160
    // (202) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CA+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A0,udg_GameStateHash) // $CA = 202; $A0 = 160
    // (202) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CA+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$A0,udg_GameStateHash) // $CA = 202; $A0 = 160
    call SaveIntegerBJ(7,$A,$A0,udg_GameStateHash) // $A = 10; $A0 = 160
    call SaveStringBJ("Hostile Satyrs",1,$A1,udg_GameStateHash) // $A1 = 161
    call SaveIntegerBJ(79,5,$A1,udg_GameStateHash) // $A1 = 161
    call SaveIntegerBJ(2,6,$A1,udg_GameStateHash) // $A1 = 161
    // (203) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CB+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A1,udg_GameStateHash) // $CB = 203; $A1 = 161
    // (203) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CB+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$A1,udg_GameStateHash) // $CB = 203; $A1 = 161
    call SaveIntegerBJ(7,$A,$A1,udg_GameStateHash) // $A = 10; $A1 = 161
    call SaveStringBJ("Hostile Wendigos",1,$A2,udg_GameStateHash) // $A2 = 162
    call SaveIntegerBJ(94,5,$A2,udg_GameStateHash) // $A2 = 162
    call SaveIntegerBJ(2,6,$A2,udg_GameStateHash) // $A2 = 162
    // (204) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CC+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A2,udg_GameStateHash) // $CC = 204; $A2 = 162
    // (204) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CC+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$A2,udg_GameStateHash) // $CC = 204; $A2 = 162
    call SaveIntegerBJ(9,$A,$A2,udg_GameStateHash) // $A = 10; $A2 = 162
    call SaveStringBJ("Lone Mercenary",1,$A3,udg_GameStateHash) // $A3 = 163
    call SaveIntegerBJ(1,4,$A3,udg_GameStateHash) // $A3 = 163
    call SaveIntegerBJ('d',5,$A3,udg_GameStateHash) // $A3 = 163
    call SaveIntegerBJ(1,6,$A3,udg_GameStateHash) // $A3 = 163
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A3,udg_GameStateHash) // $CD = 205; $A3 = 163
    call SaveIntegerBJ(8,$A,$A3,udg_GameStateHash) // $A = 10; $A3 = 163
    call SaveStringBJ("Father and Daughter",1,$A4,udg_GameStateHash) // $A4 = 164
    call SaveIntegerBJ(1,4,$A4,udg_GameStateHash) // $A4 = 164
    call SaveIntegerBJ('n',5,$A4,udg_GameStateHash) // $A4 = 164
    call SaveIntegerBJ(2,6,$A4,udg_GameStateHash) // $A4 = 164
    // (205) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CD+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A4,udg_GameStateHash) // $CD = 205; $A4 = 164
    // (206) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($CE+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$A4,udg_GameStateHash) // $CE = 206; $A4 = 164
    call SaveIntegerBJ(8,$A,$A4,udg_GameStateHash) // $A = 10; $A4 = 164
    call SaveIntegerBJ(1,20,$A4,udg_GameStateHash) // $A4 = 164
    call SaveStringBJ("The Almighty Conflagration",1,$A5,udg_GameStateHash) // $A5 = 165
    call SaveIntegerBJ('n',5,$A5,udg_GameStateHash) // $A5 = 165
    call SaveIntegerBJ(1,6,$A5,udg_GameStateHash) // $A5 = 165
    // (210) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D2+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A5,udg_GameStateHash) // $D2 = 210; $A5 = 165
    call SaveIntegerBJ(8,$A,$A5,udg_GameStateHash) // $A = 10; $A5 = 165
    call SaveStringBJ("No",1,$A6,udg_GameStateHash) // $A6 = 166
    call SaveIntegerBJ($96,5,$A6,udg_GameStateHash) // $96 = 150; $A6 = 166
    call SaveIntegerBJ(1,6,$A6,udg_GameStateHash) // $A6 = 166
    // (211) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D3+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A6,udg_GameStateHash) // $D3 = 211; $A6 = 166
    call SaveIntegerBJ($A,$A,$A6,udg_GameStateHash) // $A = 10; $A6 = 166
    call SaveStringBJ("No Mercy",1,$A7,udg_GameStateHash) // $A7 = 167
    call SaveIntegerBJ($96,5,$A7,udg_GameStateHash) // $96 = 150; $A7 = 167
    call SaveIntegerBJ(1,6,$A7,udg_GameStateHash) // $A7 = 167
    // (212) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D4+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A7,udg_GameStateHash) // $D4 = 212; $A7 = 167
    call SaveIntegerBJ($A,$A,$A7,udg_GameStateHash) // $A = 10; $A7 = 167
    call SaveStringBJ("No Mercy for",1,$A8,udg_GameStateHash) // $A8 = 168
    call SaveIntegerBJ($96,5,$A8,udg_GameStateHash) // $96 = 150; $A8 = 168
    call SaveIntegerBJ(1,6,$A8,udg_GameStateHash) // $A8 = 168
    // (213) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D5+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A8,udg_GameStateHash) // $D5 = 213; $A8 = 168
    call SaveIntegerBJ($A,$A,$A8,udg_GameStateHash) // $A = 10; $A8 = 168
    call SaveStringBJ("No Mercy for the",1,$A9,udg_GameStateHash) // $A9 = 169
    call SaveIntegerBJ($96,5,$A9,udg_GameStateHash) // $96 = 150; $A9 = 169
    call SaveIntegerBJ(1,6,$A9,udg_GameStateHash) // $A9 = 169
    // (214) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D6+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$A9,udg_GameStateHash) // $D6 = 214; $A9 = 169
    call SaveIntegerBJ($A,$A,$A9,udg_GameStateHash) // $A = 10; $A9 = 169
    call SaveStringBJ("No Mercy for the Judged",1,$AA,udg_GameStateHash) // $AA = 170
    call SaveIntegerBJ($96,5,$AA,udg_GameStateHash) // $96 = 150; $AA = 170
    call SaveIntegerBJ(1,6,$AA,udg_GameStateHash) // $AA = 170
    // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$AA,udg_GameStateHash) // $D7 = 215; $AA = 170
    call SaveIntegerBJ($A,$A,$AA,udg_GameStateHash) // $A = 10; $AA = 170
    call SaveStringBJ("Outer Plane Envoy",1,$AB,udg_GameStateHash) // $AB = 171
    call SaveIntegerBJ(5,3,$AB,udg_GameStateHash) // $AB = 171
    call SaveIntegerBJ($96,5,$AB,udg_GameStateHash) // $96 = 150; $AB = 171
    call SaveIntegerBJ(1,6,$AB,udg_GameStateHash) // $AB = 171
    // (216) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$AB,udg_GameStateHash) // $D8 = 216; $AB = 171
    call SaveIntegerBJ($A,$A,$AB,udg_GameStateHash) // $A = 10; $AB = 171
    call SaveIntegerBJ(1,20,$AB,udg_GameStateHash) // $AB = 171
    call SaveStringBJ("Light and Darkness",1,$AC,udg_GameStateHash) // $AC = 172
    call SaveIntegerBJ(4,3,$AC,udg_GameStateHash) // $AC = 172
    call SaveIntegerBJ($96,5,$AC,udg_GameStateHash) // $96 = 150; $AC = 172
    call SaveIntegerBJ(2,6,$AC,udg_GameStateHash) // $AC = 172
    // (217) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($D9+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$AC,udg_GameStateHash) // $D9 = 217; $AC = 172
    // (218) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($DA+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$AC,udg_GameStateHash) // $DA = 218; $AC = 172
    call SaveIntegerBJ($A,$A,$AC,udg_GameStateHash) // $A = 10; $AC = 172
    call SaveStringBJ("Condemner",1,$AD,udg_GameStateHash) // $AD = 173
    call SaveIntegerBJ(92,5,$AD,udg_GameStateHash) // $AD = 173
    call SaveIntegerBJ(1,6,$AD,udg_GameStateHash) // $AD = 173
    // (219) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($DB+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$AD,udg_GameStateHash) // $DB = 219; $AD = 173
    call SaveIntegerBJ(9,$A,$AD,udg_GameStateHash) // $A = 10; $AD = 173
    call SaveStringBJ("Walker of the Wheel",1,$AE,udg_GameStateHash) // $AE = 174
    call SaveIntegerBJ(92,5,$AE,udg_GameStateHash) // $AE = 174
    call SaveIntegerBJ(1,6,$AE,udg_GameStateHash) // $AE = 174
    // (220) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($DC+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$AE,udg_GameStateHash) // $DC = 220; $AE = 174
    call SaveIntegerBJ(9,$A,$AE,udg_GameStateHash) // $A = 10; $AE = 174
    call SaveStringBJ("Judge-Sal",1,$AF,udg_GameStateHash) // $AF = 175
    call SaveIntegerBJ(90,5,$AF,udg_GameStateHash) // $AF = 175
    call SaveIntegerBJ(1,6,$AF,udg_GameStateHash) // $AF = 175
    // (221) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($DD+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$AF,udg_GameStateHash) // $DD = 221; $AF = 175
    call SaveIntegerBJ(9,$A,$AF,udg_GameStateHash) // $A = 10; $AF = 175
    call SaveStringBJ("Impure Whispers",1,$B0,udg_GameStateHash) // $B0 = 176
    call SaveIntegerBJ(93,5,$B0,udg_GameStateHash) // $B0 = 176
    call SaveIntegerBJ(2,6,$B0,udg_GameStateHash) // $B0 = 176
    // (222) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($DE+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B0,udg_GameStateHash) // $DE = 222; $B0 = 176
    // (223) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($DF+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B0,udg_GameStateHash) // $DF = 223; $B0 = 176
    call SaveIntegerBJ(9,$A,$B0,udg_GameStateHash) // $A = 10; $B0 = 176
    call SaveStringBJ("Relics of Seiren",1,$B1,udg_GameStateHash) // $B1 = 177
    call SaveIntegerBJ(1,4,$B1,udg_GameStateHash) // $B1 = 177
    call SaveIntegerBJ('x',5,$B1,udg_GameStateHash) // $B1 = 177
    call SaveIntegerBJ(2,6,$B1,udg_GameStateHash) // $B1 = 177
    // (227) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E3+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B1,udg_GameStateHash) // $E3 = 227; $B1 = 177
    // (239) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($EF+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B1,udg_GameStateHash) // $EF = 239; $B1 = 177
    call SaveStringBJ("Darkening Cloud",1,$B2,udg_GameStateHash) // $B2 = 178
    call SaveIntegerBJ(90,5,$B2,udg_GameStateHash) // $B2 = 178
    call SaveIntegerBJ(1,6,$B2,udg_GameStateHash) // $B2 = 178
    // (224) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E0+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B2,udg_GameStateHash) // $E0 = 224; $B2 = 178
    call SaveIntegerBJ(9,$A,$B2,udg_GameStateHash) // $A = 10; $B2 = 178
    call SaveStringBJ("Wroth",1,$B3,udg_GameStateHash) // $B3 = 179
    call SaveIntegerBJ(90,5,$B3,udg_GameStateHash) // $B3 = 179
    call SaveIntegerBJ(3,6,$B3,udg_GameStateHash) // $B3 = 179
    // (225) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E1+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B3,udg_GameStateHash) // $E1 = 225; $B3 = 179
    // (226) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E2+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B3,udg_GameStateHash) // $E2 = 226; $B3 = 179
    // (226) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E2+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$B3,udg_GameStateHash) // $E2 = 226; $B3 = 179
    call SaveIntegerBJ(9,$A,$B3,udg_GameStateHash) // $A = 10; $B3 = 179
    call SaveStringBJ("Rippers",1,$B4,udg_GameStateHash) // $B4 = 180
    call SaveIntegerBJ(1,2,$B4,udg_GameStateHash) // $B4 = 180
    call SaveIntegerBJ(79,5,$B4,udg_GameStateHash) // $B4 = 180
    call SaveIntegerBJ(3,6,$B4,udg_GameStateHash) // $B4 = 180
    // (228) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E4+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B4,udg_GameStateHash) // $E4 = 228; $B4 = 180
    // (228) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E4+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B4,udg_GameStateHash) // $E4 = 228; $B4 = 180
    // (228) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E4+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$B4,udg_GameStateHash) // $E4 = 228; $B4 = 180
    call SaveIntegerBJ(9,$A,$B4,udg_GameStateHash) // $A = 10; $B4 = 180
    call SaveStringBJ("Walking Dead",1,$B5,udg_GameStateHash) // $B5 = 181
    call SaveIntegerBJ(1,2,$B5,udg_GameStateHash) // $B5 = 181
    call SaveIntegerBJ(80,5,$B5,udg_GameStateHash) // $B5 = 181
    call SaveIntegerBJ(3,6,$B5,udg_GameStateHash) // $B5 = 181
    // (226) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E2+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B5,udg_GameStateHash) // $E2 = 226; $B5 = 181
    // (228) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E4+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B5,udg_GameStateHash) // $E4 = 228; $B5 = 181
    // (228) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E4+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$B5,udg_GameStateHash) // $E4 = 228; $B5 = 181
    call SaveIntegerBJ(9,$A,$B5,udg_GameStateHash) // $A = 10; $B5 = 181
    call SaveStringBJ("Trial of Mana",1,$B6,udg_GameStateHash) // $B6 = 182
    call SaveIntegerBJ(1,4,$B6,udg_GameStateHash) // $B6 = 182
    call SaveIntegerBJ('x',5,$B6,udg_GameStateHash) // $B6 = 182
    call SaveIntegerBJ(1,6,$B6,udg_GameStateHash) // $B6 = 182
    // (229) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E5+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B6,udg_GameStateHash) // $E5 = 229; $B6 = 182
    call SaveStringBJ("Phantasm Dragon",1,$B7,udg_GameStateHash) // $B7 = 183
    call SaveIntegerBJ(1,4,$B7,udg_GameStateHash) // $B7 = 183
    call SaveIntegerBJ(500,5,$B7,udg_GameStateHash) // $B7 = 183
    call SaveIntegerBJ(1,6,$B7,udg_GameStateHash) // $B7 = 183
    // (230) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E6+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B7,udg_GameStateHash) // $E6 = 230; $B7 = 183
    call SaveStringBJ("Phantasm Mech",1,$B8,udg_GameStateHash) // $B8 = 184
    call SaveIntegerBJ(1,4,$B8,udg_GameStateHash) // $B8 = 184
    call SaveIntegerBJ(500,5,$B8,udg_GameStateHash) // $B8 = 184
    call SaveIntegerBJ(1,6,$B8,udg_GameStateHash) // $B8 = 184
    // (231) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E7+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B8,udg_GameStateHash) // $E7 = 231; $B8 = 184
    call SaveStringBJ("Pearl's Allure",1,$B9,udg_GameStateHash) // $B9 = 185
    call SaveIntegerBJ(1,4,$B9,udg_GameStateHash) // $B9 = 185
    call SaveIntegerBJ('x',5,$B9,udg_GameStateHash) // $B9 = 185
    call SaveIntegerBJ(2,6,$B9,udg_GameStateHash) // $B9 = 185
    // (232) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E8+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$B9,udg_GameStateHash) // $E8 = 232; $B9 = 185
    // (240) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($F0+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$B9,udg_GameStateHash) // $F0 = 240; $B9 = 185
    call SaveStringBJ("Fisherman's Horizon",1,$BA,udg_GameStateHash) // $BA = 186
    call SaveIntegerBJ(1,4,$BA,udg_GameStateHash) // $BA = 186
    call SaveIntegerBJ('x',5,$BA,udg_GameStateHash) // $BA = 186
    call SaveIntegerBJ(1,6,$BA,udg_GameStateHash) // $BA = 186
    // (233) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($E9+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$BA,udg_GameStateHash) // $E9 = 233; $BA = 186
    // (234) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($EA+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$BA,udg_GameStateHash) // $EA = 234; $BA = 186
    call SaveStringBJ("Lurking Death",1,$BB,udg_GameStateHash) // $BB = 187
    call SaveIntegerBJ(90,5,$BB,udg_GameStateHash) // $BB = 187
    call SaveIntegerBJ(1,6,$BB,udg_GameStateHash) // $BB = 187
    // (235) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($EB+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$BB,udg_GameStateHash) // $EB = 235; $BB = 187
    call SaveIntegerBJ(9,$A,$BB,udg_GameStateHash) // $A = 10; $BB = 187
    call SaveStringBJ("Shamaniacs",1,$BC,udg_GameStateHash) // $BC = 188
    call SaveIntegerBJ(1,2,$BC,udg_GameStateHash) // $BC = 188
    call SaveIntegerBJ(38,5,$BC,udg_GameStateHash) // $BC = 188
    call SaveIntegerBJ(3,6,$BC,udg_GameStateHash) // $BC = 188
    // (238) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($EE+LoadIntegerBJ(2,0,udg_GameStateHash)),8,$BC,udg_GameStateHash) // $EE = 238; $BC = 188
    // (237) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($ED+LoadIntegerBJ(2,0,udg_GameStateHash)),7,$BC,udg_GameStateHash) // $ED = 237; $BC = 188
    // (237) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
    call SaveIntegerBJ(($ED+LoadIntegerBJ(2,0,udg_GameStateHash)),9,$BC,udg_GameStateHash) // $ED = 237; $BC = 188
    call SaveIntegerBJ(4,$A,$BC,udg_GameStateHash) // $A = 10; $BC = 188
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_Pick_Team_IsSlotTaken takes nothing returns boolean
    return(udg_ArenaPickedTeam>=udg_ArenaBracketTeam[GetForLoopIndexA()])
endfunction

function Trig_Arena_Pick_Team_IsLaterSlot takes nothing returns boolean
    return(GetForLoopIndexB()>=3)
endfunction

function Trig_Arena_Pick_Team_IsTeamInCup takes nothing returns boolean
    return(LoadIntegerBJ(GetForLoopIndexA(),udg_ArenaPickedTeam,udg_GameStateHash)==udg_ArenaCupId)
endfunction

function Trig_Arena_Pick_Team_IsTeamEnabled takes nothing returns boolean
    return(LoadIntegerBJ(2,udg_ArenaPickedTeam,udg_GameStateHash)==1)
endfunction

function Trig_Arena_Pick_Team_IsBeforeSlot takes nothing returns boolean
    return(udg_ArenaPickedTeam<udg_ArenaBracketTeam[GetForLoopIndexA()])
endfunction

function Trig_Arena_Pick_Team_NotInserted takes nothing returns boolean
    return(udg_ArenaCheckFlag==false)
endfunction

function Trig_Arena_Pick_Team_NeedsInsertSort takes nothing returns boolean
    return(GetForLoopIndexB()>=3)
endfunction

function Trig_Arena_Pick_Team_IsTeamAccepted takes nothing returns boolean
    return(udg_ArenaCheckFlag)
endfunction

function Trig_Arena_Pick_Team_Actions takes nothing returns nothing
    // A random whole number from 1 through (LoadIntegerBJ(2, 0, udg_GameStateHash)) minus ((loop counter B) minus
    // (2)).
    set udg_ArenaPickedTeam=GetRandomInt(1,(LoadIntegerBJ(2,0,udg_GameStateHash)-(GetForLoopIndexB()-2)))
    if(Trig_Arena_Pick_Team_IsLaterSlot())then
        set bj_forLoopAIndex=2
        // (loop counter B) minus (1).
        set bj_forLoopAIndexEnd=(GetForLoopIndexB()-1)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_Pick_Team_IsSlotTaken())then
                set udg_ArenaPickedTeam=(udg_ArenaPickedTeam+1)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    set udg_ArenaCheckFlag=false
    if(Trig_Arena_Pick_Team_IsTeamEnabled())then
        set bj_forLoopAIndex=$A // $A = 10
        // (9) plus (udg_ArenaCupId).
        set bj_forLoopAIndexEnd=(9+udg_ArenaCupId)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_Pick_Team_IsTeamInCup())then
                set udg_ArenaCheckFlag=true
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    endif
    if(Trig_Arena_Pick_Team_IsTeamAccepted())then
        set udg_ArenaBracketSlot[GetForLoopIndexB()]=udg_ArenaPickedTeam
        set udg_ArenaCheckFlag=false
        if(Trig_Arena_Pick_Team_NeedsInsertSort())then
            set bj_forLoopAIndex=2
            set bj_forLoopAIndexEnd=GetForLoopIndexB()
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                if(Trig_Arena_Pick_Team_NotInserted())then
                    if(Trig_Arena_Pick_Team_IsBeforeSlot())then
                        set udg_ArenaCheckFlag=true
                        // (loop counter A) plus (1).
                        set udg_ArenaSwapTemp=udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]
                        // (loop counter A) plus (1).
                        set udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]=udg_ArenaBracketTeam[GetForLoopIndexA()]
                        set udg_ArenaBracketTeam[GetForLoopIndexA()]=udg_ArenaPickedTeam
                    endif
                else
                    // (loop counter A) plus (1).
                    set udg_ArenaSwapTemp2=udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]
                    // (loop counter A) plus (1).
                    set udg_ArenaBracketTeam[(GetForLoopIndexA()+1)]=udg_ArenaSwapTemp
                    set udg_ArenaSwapTemp=udg_ArenaSwapTemp2
                endif
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
        else
            set udg_ArenaBracketTeam[GetForLoopIndexB()]=udg_ArenaPickedTeam
        endif
    else
        call ConditionalTriggerExecute(GetTriggeringTrigger())
    endif
endfunction

function Trig_Arena_SyncTeams_Ch1Step2 takes nothing returns boolean
    return(udg_CupWins[1]==2)
endfunction

function Trig_Arena_SyncTeams_Ch1Step4 takes nothing returns boolean
    return(udg_CupWins[1]==4)
endfunction

function Trig_Arena_SyncTeams_Ch1Step6 takes nothing returns boolean
    return(udg_CupWins[1]==6)
endfunction

function Trig_Arena_SyncTeams_Ch1Step9 takes nothing returns boolean
    return(udg_CupWins[1]==9)
endfunction

function Trig_Arena_SyncTeams_IsChapter1 takes nothing returns boolean
    return(udg_ArenaCupId==1)
endfunction

function Trig_Arena_SyncTeams_Ch2Step1 takes nothing returns boolean
    return(udg_CupWins[2]==1)
endfunction

function Trig_Arena_SyncTeams_Ch2Step2 takes nothing returns boolean
    return(udg_CupWins[2]==2)
endfunction

function Trig_Arena_SyncTeams_Ch2Step5 takes nothing returns boolean
    return(udg_CupWins[2]==5)
endfunction

function Trig_Arena_SyncTeams_Ch2Step7 takes nothing returns boolean
    return(udg_CupWins[2]==7)
endfunction

function Trig_Arena_SyncTeams_Ch2Step10 takes nothing returns boolean
    return(udg_CupWins[2]==$A) // $A = 10
endfunction

function Trig_Arena_SyncTeams_IsChapter2 takes nothing returns boolean
    return(udg_ArenaCupId==2)
endfunction

function Trig_Arena_SyncTeams_Ch4Step5 takes nothing returns boolean
    return(udg_CupWins[4]==5)
endfunction

function Trig_Arena_SyncTeams_IsChapter4 takes nothing returns boolean
    return(udg_ArenaCupId==4)
endfunction

function Trig_Arena_SyncTeams_Ch5Step3 takes nothing returns boolean
    return(udg_CupWins[5]==3)
endfunction

function Trig_Arena_SyncTeams_IsChapter5 takes nothing returns boolean
    return(udg_ArenaCupId==5)
endfunction

function Trig_Arena_SyncTeams_Ch6Step2 takes nothing returns boolean
    return(udg_CupWins[6]==2)
endfunction

function Trig_Arena_SyncTeams_Ch6Step4 takes nothing returns boolean
    return(udg_CupWins[6]==4)
endfunction

function Trig_Arena_SyncTeams_Ch6Step6 takes nothing returns boolean
    return(udg_CupWins[6]==6)
endfunction

function Trig_Arena_SyncTeams_Ch6Step7 takes nothing returns boolean
    return(udg_CupWins[6]==7)
endfunction

function Trig_Arena_SyncTeams_IsChapter6 takes nothing returns boolean
    return(udg_ArenaCupId==6)
endfunction

function Trig_Arena_SyncTeams_ValfodrUnlockReady takes nothing returns boolean
    return(udg_CupWins[8]>=5)and(IsQuestCompleted(udg_MainQuest[19]))and(LoadIntegerBJ(2,'z',udg_GameStateHash)==1)
endfunction

function Trig_Arena_SyncTeams_IsChapter8 takes nothing returns boolean
    return(udg_ArenaCupId==8)
endfunction

function Trig_Arena_SyncTeams_BelowUnlockTier3 takes nothing returns boolean
    return(udg_ArenaRank<3)
endfunction

function Trig_Arena_SyncTeams_MissingQuest22 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[21]))
endfunction

function Trig_Arena_SyncTeams_GrantQuest22 takes nothing returns nothing
    if(Trig_Arena_SyncTeams_MissingQuest22())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=22
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_SyncTeams_MissingQuest23 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[23])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22]))
endfunction

function Trig_Arena_SyncTeams_GrantQuest23 takes nothing returns nothing
    if(Trig_Arena_SyncTeams_MissingQuest23())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=23
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_SyncTeams_AllTeamsStocked takes nothing returns boolean
    return(udg_ArenaUnitsUnlocked==44)and(udg_ArenaRank<4)
endfunction

function Trig_Arena_SyncTeams_ConquestComplete takes nothing returns boolean
    return(udg_ArenaOwnerStreak>=5)
endfunction

function Trig_Arena_SyncTeams_ConquestStarted takes nothing returns boolean
    return(udg_ArenaOwnerStreak>0)
endfunction

function Trig_Arena_SyncTeams_IsChapter10 takes nothing returns boolean
    return(udg_ArenaCupId==$A) // $A = 10
endfunction

function Trig_Arena_SyncTeams_IsEndgameStart takes nothing returns boolean
    // (udg_CupWins at position 8) plus ((udg_CupWins at position 9) plus (udg_CupWins at position 10)).
    return(udg_ArenaCupId>=8)and((udg_CupWins[8]+(udg_CupWins[9]+udg_CupWins[$A]))==1) // $A = 10
endfunction

function Trig_Arena_SyncTeams_Actions takes nothing returns nothing
    if(Trig_Arena_SyncTeams_IsChapter1())then
        if(Trig_Arena_SyncTeams_Ch1Step2())then
            call SaveIntegerBJ(0,2,$E,udg_GameStateHash) // $E = 14
            call SaveIntegerBJ(1,2,21,udg_GameStateHash)
            call SaveIntegerBJ(1,2,$8D,udg_GameStateHash) // $8D = 141
        endif
        if(Trig_Arena_SyncTeams_Ch1Step4())then
            call SaveIntegerBJ(0,2,$D,udg_GameStateHash) // $D = 13
            call SaveIntegerBJ(1,2,$90,udg_GameStateHash) // $90 = 144
            call SaveIntegerBJ(1,2,$91,udg_GameStateHash) // $91 = 145
        endif
        if(Trig_Arena_SyncTeams_Ch1Step6())then
            call SaveIntegerBJ(0,2,$B,udg_GameStateHash) // $B = 11
            call SaveIntegerBJ(0,2,19,udg_GameStateHash)
            call SaveIntegerBJ(0,2,$8D,udg_GameStateHash) // $8D = 141
            call SaveIntegerBJ(1,2,$8F,udg_GameStateHash) // $8F = 143
        endif
        if(Trig_Arena_SyncTeams_Ch1Step9())then
        endif
    endif
    if(Trig_Arena_SyncTeams_IsChapter2())then
        if(Trig_Arena_SyncTeams_Ch2Step1())then
            call SaveIntegerBJ(1,2,$93,udg_GameStateHash) // $93 = 147
        endif
        if(Trig_Arena_SyncTeams_Ch2Step2())then
            call SaveIntegerBJ(1,2,$94,udg_GameStateHash) // $94 = 148
            call SaveIntegerBJ(1,2,$95,udg_GameStateHash) // $95 = 149
            call SaveIntegerBJ(1,2,$96,udg_GameStateHash) // $96 = 150
        endif
        if(Trig_Arena_SyncTeams_Ch2Step5())then
            call SaveIntegerBJ(0,2,22,udg_GameStateHash)
            call SaveIntegerBJ(0,2,26,udg_GameStateHash)
            call SaveIntegerBJ(1,2,$97,udg_GameStateHash) // $97 = 151
        endif
        if(Trig_Arena_SyncTeams_Ch2Step7())then
            call SaveIntegerBJ(0,2,28,udg_GameStateHash)
            call SaveIntegerBJ(0,2,$97,udg_GameStateHash) // $97 = 151
            call SaveIntegerBJ(1,2,$98,udg_GameStateHash) // $98 = 152
        endif
        if(Trig_Arena_SyncTeams_Ch2Step10())then
            call SaveIntegerBJ(1,2,$99,udg_GameStateHash) // $99 = 153
        endif
    endif
    if(Trig_Arena_SyncTeams_IsChapter4())then
        if(Trig_Arena_SyncTeams_Ch4Step5())then
            call SaveIntegerBJ(1,2,41,udg_GameStateHash)
        endif
    endif
    if(Trig_Arena_SyncTeams_IsChapter5())then
        if(Trig_Arena_SyncTeams_Ch5Step3())then
            call SaveIntegerBJ(1,2,57,udg_GameStateHash)
        endif
    endif
    if(Trig_Arena_SyncTeams_IsChapter6())then
        if(Trig_Arena_SyncTeams_Ch6Step2())then
            call SaveIntegerBJ(4,$A,59,udg_GameStateHash) // $A = 10
            call SaveIntegerBJ(4,$A,60,udg_GameStateHash) // $A = 10
            call SaveIntegerBJ(4,$A,61,udg_GameStateHash) // $A = 10
            call SaveIntegerBJ(1,2,67,udg_GameStateHash)
            call SaveIntegerBJ(1,2,68,udg_GameStateHash)
            call SaveIntegerBJ(1,2,69,udg_GameStateHash)
            call SaveIntegerBJ(1,2,70,udg_GameStateHash)
        endif
        if(Trig_Arena_SyncTeams_Ch6Step4())then
            call SaveIntegerBJ(0,2,64,udg_GameStateHash)
            call SaveIntegerBJ(1,2,71,udg_GameStateHash)
            call SaveIntegerBJ(1,2,72,udg_GameStateHash)
            call SaveIntegerBJ(1,2,73,udg_GameStateHash)
        endif
        if(Trig_Arena_SyncTeams_Ch6Step6())then
            call SaveIntegerBJ(0,2,66,udg_GameStateHash)
        endif
        if(Trig_Arena_SyncTeams_Ch6Step7())then
            call SaveIntegerBJ(1,2,74,udg_GameStateHash)
        endif
    endif
    if(Trig_Arena_SyncTeams_IsChapter8())then
        if(Trig_Arena_SyncTeams_ValfodrUnlockReady())then
            call SaveIntegerBJ(0,2,'z',udg_GameStateHash)
            call SaveIntegerBJ(1,2,'{',udg_GameStateHash)
        endif
    endif
    if(Trig_Arena_SyncTeams_IsChapter10())then
        call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Arm)
        if(Trig_Arena_SyncTeams_ConquestStarted())then
            if(Trig_Arena_SyncTeams_ConquestComplete())then
                if(Trig_Arena_SyncTeams_BelowUnlockTier3())then
                    set udg_ArenaRank=3
                endif
                call AddUnitToStockBJ('n0CX',udg_ArenaOrganizer[4],1,1) // 'n0CX': unit "Arena: No Mercy for the Judged Battle"
                // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
                call SaveIntegerBJ(50,$C,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $D7 = 215
                call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Arm)
                call ForForce(udg_PlayingPlayers,function Trig_Arena_SyncTeams_GrantQuest22)
                set udg_ArenaOwnerStreak=0
                set udg_ArenaUnitsUnlocked=(udg_ArenaUnitsUnlocked+1)
                if(Trig_Arena_SyncTeams_AllTeamsStocked())then
                    set udg_ArenaRank=4
                    call SaveIntegerBJ(1,2,$9A,udg_GameStateHash) // $9A = 154
                    call ForForce(udg_PlayingPlayers,function Trig_Arena_SyncTeams_GrantQuest23)
                endif
            else
                set udg_ArenaOwnerStreak=(udg_ArenaOwnerStreak+1)
            endif
        endif
    endif
    if(Trig_Arena_SyncTeams_IsEndgameStart())then
        call ConditionalTriggerExecute(gg_trg_McBurn_Arena_Appear)
    endif
endfunction

function InitTrig_Arena_TeamSelection takes nothing returns nothing
endfunction

endlibrary

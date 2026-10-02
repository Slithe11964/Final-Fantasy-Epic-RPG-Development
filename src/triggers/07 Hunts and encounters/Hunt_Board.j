library THuntBoard
globals
    // Variables only this module uses.
    effect array udg_HuntMarkerEffect
endglobals

function Trig_Hunt_Setup_Actions takes nothing returns nothing
    set udg_HuntLeaderboard=CreateLeaderboardBJ(GetPlayersAll(),"Hunt Club")
    call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
    set udg_RareHuntsDone=0
    set bj_forLoopAIndex=$B // $B = 11
    set bj_forLoopAIndexEnd=24
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call ForceAddPlayerSimple(ConvertedPlayer(GetForLoopIndexA()),udg_HuntSlots)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_HuntShopStock=0
    set udg_HuntBoard[1]=gg_unit_n009_0051
    set udg_HuntBoard[2]=gg_unit_n0B3_0049
    set udg_HuntBoard[3]=gg_unit_h02Z_0230
    set udg_HuntBoard[4]=gg_unit_n0BW_0094
    set udg_HuntBoard[5]=gg_unit_n0BV_0229
    set udg_HuntBoard[6]=gg_unit_e014_0149
    set udg_HuntBoard[7]=gg_unit_e012_0227
    set udg_HuntBoard[8]=gg_unit_h030_0243
    set udg_HuntBoard[$A]=gg_unit_nsw2_0056 // $A = 10
    set udg_HuntRewardItem[1]='I0C0' // 'I0C0': item "Vega"
    set udg_HuntRewardItem[2]='I0HH' // 'I0HH': item "Onion Shot"
    set udg_HuntRewardItem[3]='I0HY' // 'I0HY': item "Tome of the Tortoise"
    set udg_HuntRewardItem[4]='sror' // 'sror': item "Spirit of Lowtown"
    set udg_HuntRewardItem[5]='I0HI' // 'I0HI': item "Piercing Shot"
    set udg_HuntRewardItem[6]='I0C2' // 'I0C2': item "Arcturus"
    set udg_HuntRewardItem[7]='I0HJ' // 'I0HJ': item "Scattershot"
    set udg_HuntRewardItem[8]='I0IB' // 'I0IB': item "Hunter's Cloak"
    set udg_HuntRewardItem[9]='I0I6' // 'I0I6': item "Tome of the Breaker"
    set udg_HuntRewardItem[$B]='I0C3' // $B = 11; 'I0C3': item "Formalhaut"
    call InitHashtableBJ()
    set udg_HuntData=GetLastCreatedHashtableBJ()
    call SaveBooleanBJ(true,0,1,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Thextera_Escort,1,1,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_591),2,1,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0B1'),3,1,udg_HuntData) // 'n0B1': unit "Thextera"
    call SaveRealBJ(180.,4,1,udg_HuntData)
    call SaveIntegerBJ(750,5,1,udg_HuntData)
    call SaveIntegerBJ(750,6,1,udg_HuntData)
    call SaveIntegerBJ(74,7,1,udg_HuntData)
    call SaveBooleanBJ(false,0,2,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_620),2,2,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0BS'),3,2,udg_HuntData) // 'n0BS': unit "Stinger"
    call SaveRealBJ(315.,4,2,udg_HuntData)
    call SaveIntegerBJ($3E8,5,2,udg_HuntData) // $3E8 = 1000
    call SaveIntegerBJ($3E8,6,2,udg_HuntData) // $3E8 = 1000
    call SaveIntegerBJ(46,7,2,udg_HuntData)
    call SaveBooleanBJ(false,0,3,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_619),2,3,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0BL'),3,3,udg_HuntData) // 'n0BL': unit "Marilith"
    call SaveRealBJ(45.,4,3,udg_HuntData)
    call SaveIntegerBJ($5DC,5,3,udg_HuntData) // $5DC = 1500
    call SaveIntegerBJ($7D0,6,3,udg_HuntData) // $7D0 = 2000
    call SaveIntegerBJ($410,7,3,udg_HuntData) // $410 = 1040
    call SaveBooleanBJ(true,0,4,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Shard_Register,1,4,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_607),2,4,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n03U'),3,4,udg_HuntData) // 'n03U': unit "Cactuar"
    call SaveRealBJ(180.,4,4,udg_HuntData)
    call SaveIntegerBJ($9C4,5,4,udg_HuntData) // $9C4 = 2500
    call SaveIntegerBJ($5DC,6,4,udg_HuntData) // $5DC = 1500
    call SaveIntegerBJ($445,7,4,udg_HuntData) // $445 = 1093
    call SaveBooleanBJ(false,0,5,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_610),2,5,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n01M'),3,5,udg_HuntData) // 'n01M': unit "Tempest Wyrm"
    call SaveRealBJ(270.,4,5,udg_HuntData)
    call SaveIntegerBJ($5DC,5,5,udg_HuntData) // $5DC = 1500
    call SaveIntegerBJ($5DC,6,5,udg_HuntData) // $5DC = 1500
    call SaveIntegerBJ($447,7,5,udg_HuntData) // $447 = 1095
    call SaveBooleanBJ(false,0,6,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_611),2,6,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n03Y'),3,6,udg_HuntData) // 'n03Y': unit "Tindalos"
    call SaveRealBJ(345.,4,6,udg_HuntData)
    call SaveIntegerBJ($FA0,5,6,udg_HuntData) // $FA0 = 4000
    call SaveIntegerBJ($FA0,6,6,udg_HuntData) // $FA0 = 4000
    call SaveIntegerBJ(2,7,6,udg_HuntData)
    call SaveBooleanBJ(true,0,7,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Demon_Setup,1,7,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_627),2,7,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0A4'),3,7,udg_HuntData) // 'n0A4': unit "Girimehkala"
    call SaveRealBJ(270.,4,7,udg_HuntData)
    call SaveIntegerBJ($DAC,5,7,udg_HuntData) // $DAC = 3500
    call SaveIntegerBJ(4500,6,7,udg_HuntData)
    call SaveIntegerBJ(83,7,7,udg_HuntData)
    call SaveBooleanBJ(false,0,8,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_618),2,8,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n02P'),3,8,udg_HuntData) // 'n02P': unit "Adamantoise"
    call SaveRealBJ(270.,4,8,udg_HuntData)
    call SaveIntegerBJ(5000,5,8,udg_HuntData)
    call SaveIntegerBJ($9C4,6,8,udg_HuntData) // $9C4 = 2500
    call SaveIntegerBJ($429,7,8,udg_HuntData) // $429 = 1065
    call SaveBooleanBJ(true,0,9,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Tonberry_Setup,1,9,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_608),2,9,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n03B'),3,9,udg_HuntData) // 'n03B': unit "Tonberry"
    call SaveRealBJ(.0,4,9,udg_HuntData)
    call SaveIntegerBJ($7D0,5,9,udg_HuntData) // $7D0 = 2000
    call SaveIntegerBJ($BB8,6,9,udg_HuntData) // $BB8 = 3000
    call SaveIntegerBJ($444,7,9,udg_HuntData) // $444 = 1092
    call SaveBooleanBJ(true,0,$A,udg_HuntData) // $A = 10
    call SaveTriggerHandleBJ(gg_trg_Hunt_Demon_Setup,1,$A,udg_HuntData) // $A = 10
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_628),2,$A,udg_HuntData) // $A = 10
    call SaveStringBJ(UnitId2StringBJ('n0A7'),3,$A,udg_HuntData) // 'n0A7': unit "Titania"; $A = 10
    call SaveRealBJ(300.,4,$A,udg_HuntData) // $A = 10
    call SaveIntegerBJ($FA0,5,$A,udg_HuntData) // $FA0 = 4000; $A = 10
    call SaveIntegerBJ($FA0,6,$A,udg_HuntData) // $FA0 = 4000; $A = 10
    call SaveIntegerBJ(262,7,$A,udg_HuntData) // $A = 10
    call SaveBooleanBJ(false,0,$B,udg_HuntData) // $B = 11
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_612),2,$B,udg_HuntData) // $B = 11
    call SaveStringBJ(UnitId2StringBJ('n03Z'),3,$B,udg_HuntData) // 'n03Z': unit "Lacerta"; $B = 11
    call SaveRealBJ(270.,4,$B,udg_HuntData) // $B = 11
    call SaveIntegerBJ($BB8,5,$B,udg_HuntData) // $BB8 = 3000; $B = 11
    call SaveIntegerBJ(4500,6,$B,udg_HuntData) // $B = 11
    call SaveIntegerBJ(68,7,$B,udg_HuntData) // $B = 11
    call SaveBooleanBJ(false,0,$C,udg_HuntData) // $C = 12
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_621),2,$C,udg_HuntData) // $C = 12
    call SaveStringBJ(UnitId2StringBJ('n04L'),3,$C,udg_HuntData) // 'n04L': unit "Very Annoying Monster"; $C = 12
    call SaveRealBJ(270.,4,$C,udg_HuntData) // $C = 12
    call SaveIntegerBJ($5DC,5,$C,udg_HuntData) // $5DC = 1500; $C = 12
    call SaveIntegerBJ($7D0,6,$C,udg_HuntData) // $7D0 = 2000; $C = 12
    call SaveIntegerBJ($FE,7,$C,udg_HuntData) // $FE = 254; $C = 12
    call SaveBooleanBJ(true,0,$D,udg_HuntData) // $D = 13
    call SaveTriggerHandleBJ(gg_trg_Hunt_Demon_Setup,1,$D,udg_HuntData) // $D = 13
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_629),2,$D,udg_HuntData) // $D = 13
    call SaveStringBJ(UnitId2StringBJ('n0A5'),3,$D,udg_HuntData) // 'n0A5': unit "Cu Chulainn"; $D = 13
    call SaveRealBJ(.0,4,$D,udg_HuntData) // $D = 13
    call SaveIntegerBJ($7D0,5,$D,udg_HuntData) // $7D0 = 2000; $D = 13
    call SaveIntegerBJ($BB8,6,$D,udg_HuntData) // $BB8 = 3000; $D = 13
    call SaveIntegerBJ(272,7,$D,udg_HuntData) // $D = 13
    call SaveBooleanBJ(true,0,$E,udg_HuntData) // $E = 14
    call SaveTriggerHandleBJ(gg_trg_Hunt_PhantomDancer_Setup,1,$E,udg_HuntData) // $E = 14
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_616),2,$E,udg_HuntData) // $E = 14
    call SaveStringBJ(UnitId2StringBJ('n0C8'),3,$E,udg_HuntData) // 'n0C8': unit "Phantom Dancer"; $E = 14
    call SaveRealBJ(270.,4,$E,udg_HuntData) // $E = 14
    call SaveIntegerBJ($9C4,5,$E,udg_HuntData) // $9C4 = 2500; $E = 14
    call SaveIntegerBJ($9C4,6,$E,udg_HuntData) // $9C4 = 2500; $E = 14
    call SaveIntegerBJ($AB,7,$E,udg_HuntData) // $AB = 171; $E = 14
    call SaveBooleanBJ(true,0,$F,udg_HuntData) // $F = 15
    call SaveTriggerHandleBJ(gg_trg_Hunt_Verci_Setup,1,$F,udg_HuntData) // $F = 15
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_617),2,$F,udg_HuntData) // $F = 15
    call SaveStringBJ(UnitId2StringBJ('n0MZ'),3,$F,udg_HuntData) // 'n0MZ': unit "Vercingetorix"; $F = 15
    call SaveRealBJ(.0,4,$F,udg_HuntData) // $F = 15
    call SaveIntegerBJ($3A98,5,$F,udg_HuntData) // $3A98 = 15000; $F = 15
    call SaveIntegerBJ($3A98,6,$F,udg_HuntData) // $3A98 = 15000; $F = 15
    call SaveIntegerBJ(344,7,$F,udg_HuntData) // $F = 15
    call SaveBooleanBJ(true,0,16,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Demon_Setup,1,16,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_625),2,16,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0A9'),3,16,udg_HuntData) // 'n0A9': unit "Arahabaki"
    call SaveRealBJ(270.,4,16,udg_HuntData)
    call SaveIntegerBJ($FA0,5,16,udg_HuntData) // $FA0 = 4000
    call SaveIntegerBJ($BB8,6,16,udg_HuntData) // $BB8 = 3000
    call SaveIntegerBJ($FF,7,16,udg_HuntData) // $FF = 255
    call SaveBooleanBJ(false,0,17,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_613),2,17,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n02Q'),3,17,udg_HuntData) // 'n02Q': unit "Adaman Taimai"
    call SaveRealBJ(.0,4,17,udg_HuntData)
    call SaveIntegerBJ(8000,5,17,udg_HuntData)
    call SaveIntegerBJ($FA0,6,17,udg_HuntData) // $FA0 = 4000
    call SaveIntegerBJ($42F,7,17,udg_HuntData) // $42F = 1071
    call SaveBooleanBJ(true,0,18,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Shard_Register,1,18,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_609),2,18,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n03W'),3,18,udg_HuntData) // 'n03W': unit "Malboro"
    call SaveRealBJ(270.,4,18,udg_HuntData)
    call SaveIntegerBJ($5DC,5,18,udg_HuntData) // $5DC = 1500
    call SaveIntegerBJ($7D0,6,18,udg_HuntData) // $7D0 = 2000
    call SaveIntegerBJ($446,7,18,udg_HuntData) // $446 = 1094
    call SaveBooleanBJ(true,0,19,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Demon_Setup,1,19,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_624),2,19,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0A6'),3,19,udg_HuntData) // 'n0A6': unit "Pixie"
    call SaveRealBJ(270.,4,19,udg_HuntData)
    call SaveIntegerBJ($7D0,5,19,udg_HuntData) // $7D0 = 2000
    call SaveIntegerBJ($BB8,6,19,udg_HuntData) // $BB8 = 3000
    call SaveIntegerBJ(260,7,19,udg_HuntData)
    call SaveBooleanBJ(true,0,20,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Trickster_Decoy_Spawn,1,20,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_384),2,20,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n04H'),3,20,udg_HuntData) // 'n04H': unit "Trickster"
    call SaveRealBJ(270.,4,20,udg_HuntData)
    call SaveIntegerBJ(6000,5,20,udg_HuntData)
    call SaveIntegerBJ($BB8,6,20,udg_HuntData) // $BB8 = 3000
    call SaveIntegerBJ($3F9,7,20,udg_HuntData) // $3F9 = 1017
    call SaveBooleanBJ(true,0,21,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Parvati_Setup,1,21,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_695),2,21,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0A8'),3,21,udg_HuntData) // 'n0A8': unit "Parvati"
    call SaveRealBJ(180.,4,21,udg_HuntData)
    call SaveIntegerBJ(5000,5,21,udg_HuntData)
    call SaveIntegerBJ(4500,6,21,udg_HuntData)
    call SaveIntegerBJ(259,7,21,udg_HuntData)
    call SaveBooleanBJ(true,0,22,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Mephorash_Setup,1,22,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_614),2,22,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0AZ'),3,22,udg_HuntData) // 'n0AZ': unit "Mephorash"
    call SaveRealBJ(270.,4,22,udg_HuntData)
    call SaveIntegerBJ($2710,5,22,udg_HuntData) // $2710 = 10000
    call SaveIntegerBJ($2710,6,22,udg_HuntData) // $2710 = 10000
    call SaveIntegerBJ(337,7,22,udg_HuntData)
    call SaveBooleanBJ(true,0,23,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Melaiduma_Setup,1,23,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_615),2,23,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0B0'),3,23,udg_HuntData) // 'n0B0': unit "Melaiduma"
    call SaveRealBJ(270.,4,23,udg_HuntData)
    call SaveIntegerBJ($4E20,5,23,udg_HuntData) // $4E20 = 20000
    call SaveIntegerBJ($4E20,6,23,udg_HuntData) // $4E20 = 20000
    call SaveIntegerBJ(330,7,23,udg_HuntData)
    call SaveBooleanBJ(true,0,24,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Exdeath_Setup,1,24,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_644),2,24,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0CM'),3,24,udg_HuntData) // 'n0CM': unit "Exdeath"
    call SaveRealBJ(270.,4,24,udg_HuntData)
    call SaveIntegerBJ($BB8,5,24,udg_HuntData) // $BB8 = 3000
    call SaveIntegerBJ($BB8,6,24,udg_HuntData) // $BB8 = 3000
    call SaveBooleanBJ(true,0,25,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_BlackPearl_Setup,1,25,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_579),2,25,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('U01Q'),3,25,udg_HuntData) // 'U01Q': unit "Black Pearl Demon"
    call SaveRealBJ(230.,4,25,udg_HuntData)
    call SaveIntegerBJ($2EE0,5,25,udg_HuntData) // $2EE0 = 12000
    call SaveIntegerBJ($2EE0,6,25,udg_HuntData) // $2EE0 = 12000
    call SaveIntegerBJ($97,7,25,udg_HuntData) // $97 = 151
    call SaveBooleanBJ(true,0,26,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Rabite_Setup,1,26,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_692),2,26,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0LR'),3,26,udg_HuntData) // 'n0LR': unit "Black Rabite"
    call SaveRealBJ(270.,4,26,udg_HuntData)
    call SaveIntegerBJ(9999,5,26,udg_HuntData)
    call SaveIntegerBJ(9999,6,26,udg_HuntData)
    call SaveIntegerBJ(271,7,26,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_626),2,27,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0MA'),3,27,udg_HuntData) // 'n0MA': unit "Umaro"
    call SaveRealBJ(180.,4,27,udg_HuntData)
    call SaveIntegerBJ($FA0,5,27,udg_HuntData) // $FA0 = 4000
    call SaveIntegerBJ($FA0,6,27,udg_HuntData) // $FA0 = 4000
    call SaveIntegerBJ(341,7,27,udg_HuntData)
    call SaveBooleanBJ(true,0,28,udg_HuntData)
    call SaveTriggerHandleBJ(gg_trg_Hunt_Okuu_Setup,1,28,udg_HuntData)
    call SaveLocationHandleBJ(GetRectCenter(gg_rct_714),2,28,udg_HuntData)
    call SaveStringBJ(UnitId2StringBJ('n0NE'),3,28,udg_HuntData) // 'n0NE': unit "Okuu"
    call SaveRealBJ(270.,4,28,udg_HuntData)
    call SaveIntegerBJ($61A8,5,28,udg_HuntData) // $61A8 = 25000
    call SaveIntegerBJ($61A8,6,28,udg_HuntData) // $61A8 = 25000
    call SaveIntegerBJ(351,7,28,udg_HuntData)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Hunt_Board_Markers_HasHuntAvailable takes nothing returns boolean
    return(udg_HuntStock[GetForLoopIndexA()]>0)
endfunction

function Trig_Hunt_Board_Markers_NoHuntAvailable takes nothing returns boolean
    return(udg_HuntStock[GetForLoopIndexA()]<=0)
endfunction

function Trig_Hunt_Board_Markers_IsMarked takes nothing returns boolean
    return(IsUnitInGroup(udg_HuntBoard[GetForLoopIndexA()],udg_HuntBoardMarked))
endfunction

function Trig_Hunt_Board_Markers_IsBoardActive takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Ane2',udg_HuntBoard[GetForLoopIndexA()])>0) // 'Ane2': object name not found in map data
endfunction

function Trig_Hunt_Board_Markers_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=$B // $B = 11
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Hunt_Board_Markers_IsBoardActive())then
            if(Trig_Hunt_Board_Markers_IsMarked())then
                if(Trig_Hunt_Board_Markers_NoHuntAvailable())then
                    call GroupRemoveUnitSimple(udg_HuntBoard[GetForLoopIndexA()],udg_HuntBoardMarked)
                    call DestroyEffectBJ(udg_HuntMarkerEffect[GetForLoopIndexA()])
                endif
            else
                if(Trig_Hunt_Board_Markers_HasHuntAvailable())then
                    call GroupAddUnitSimple(udg_HuntBoard[GetForLoopIndexA()],udg_HuntBoardMarked)
                    set udg_HuntMarkerEffect[GetForLoopIndexA()]=AddSpecialEffectTargetUnitBJ("overhead",udg_HuntBoard[GetForLoopIndexA()],"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
                    call BlzSetSpecialEffectColor(GetLastCreatedEffectBJ(),$FF,$7F,$7F) // $FF = 255; $7F = 127
                endif
            endif
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Hunt_Board takes nothing returns nothing
endfunction

endlibrary

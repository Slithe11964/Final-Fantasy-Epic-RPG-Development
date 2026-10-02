library TShadowLifecycle requires TCam, TCine, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shadow_Init=null
    trigger gg_trg_Shadow_FirstAppear=null
    trigger gg_trg_Shadow_Intro=null
    trigger gg_trg_Shadow_Respawn=null
    trigger gg_trg_Shadow_Leave=null
    trigger gg_trg_Shadow_NearbyDelay=null
    trigger gg_trg_Shadow_Death=null
    // Variables only this module uses.
    location array udg_ShadowSpawnPoint
endglobals

function Trig_Shadow_Init_Actions takes nothing returns nothing
    set udg_ShadowLoyalty=80
    set udg_ShadowHireOffer[0]='n07T' // 'n07T': unit "200 Gil - Shadow Offer"
    set udg_ShadowHireOffer[1]='n07U' // 'n07U': unit "400 Gil - Shadow Offer"
    set udg_ShadowHireOffer[2]='n07V' // 'n07V': unit "600 Gil - Shadow Offer"
    set udg_ShadowHireOffer[3]='n07W' // 'n07W': unit "800 Gil - Shadow Offer"
    set udg_ShadowHireOffer[4]='n07X' // 'n07X': unit "1200 Gil - Shadow Offer"
    set udg_ShadowHireOffer[5]='n07Y' // 'n07Y': unit "1800 Gil - Shadow Offer"
    set udg_ShadowHireOffer[6]='n07Z' // 'n07Z': unit "2400 Gil - Shadow Offer"
    set udg_ShadowHireOffer[7]='n080' // 'n080': unit "3000 Gil - Shadow Offer"
    set udg_ShadowHireOffer[8]='n081' // 'n081': unit "4500 Gil - Shadow Offer"
    set udg_ShadowHireOffer[9]='n082' // 'n082': unit "6000 Gil - Shadow Offer"
    set udg_ShadowHireOffer[$A]='n083' // $A = 10; 'n083': unit "8000 Gil - Shadow Offer"
    set udg_ShadowHireOffer[$B]='n084' // $B = 11; 'n084': unit "10000 Gil - Shadow Offer"
    set udg_DancingDaggersAbility[1]='S00A' // 'S00A': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[2]='S00B' // 'S00B': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[3]='S00C' // 'S00C': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[4]='S00D' // 'S00D': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[5]='S00E' // 'S00E': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[6]='S00F' // 'S00F': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[7]='S00G' // 'S00G': ability "Dancing Daggers"
    set udg_DancingDaggersAbility[8]='S00H' // 'S00H': ability "Dancing Daggers"
    set udg_ShadowPotion[0]='phea' // 'phea': item "Potion"
    set udg_ShadowHelmet[0]='tkno' // 'tkno': object name not found in map data
    set udg_ShadowDagger[0]='tkno' // 'tkno': object name not found in map data
    set udg_ShadowKatana[0]='tkno' // 'tkno': object name not found in map data
    set udg_ShadowArmor[0]='tkno' // 'tkno': object name not found in map data
    set udg_ShadowPotion[1]='pghe' // 'pghe': item "Hi-Potion"
    set udg_ShadowHelmet[1]='I01H' // 'I01H': item "Iron Helmet"
    set udg_ShadowDagger[1]='I0F5' // 'I0F5': item "Dagger"
    set udg_ShadowKatana[1]='I0F5' // 'I0F5': item "Dagger"
    set udg_ShadowArmor[1]='I01M' // 'I01M': item "Studded Leather Armor"
    set udg_ShadowPotion[2]='I001' // 'I001': item "Mega Potion"
    set udg_ShadowHelmet[2]='I01I' // 'I01I': item "Mithril Helmet"
    set udg_ShadowDagger[2]='I0F5' // 'I0F5': item "Dagger"
    set udg_ShadowKatana[2]='I00N' // 'I00N': item "Kotetsu"
    set udg_ShadowArmor[2]='I01N' // 'I01N': item "Reinforced Leather Armor"
    set udg_ShadowPotion[3]='I000' // 'I000': item "X-Potion"
    set udg_ShadowHelmet[3]='I01I' // 'I01I': item "Mithril Helmet"
    set udg_ShadowDagger[3]='I035' // 'I035': item "Platinum Dagger"
    set udg_ShadowKatana[3]='I05T' // 'I05T': item "Kiku-Ichimonji"
    set udg_ShadowArmor[3]='I01O' // 'I01O': item "Storm Wyrm Hide Armor"
    set udg_ShadowPotion[4]='I02V' // 'I02V': item "Nectar"
    set udg_ShadowHelmet[4]='I01K' // 'I01K': item "Platinum Helmet"
    set udg_ShadowDagger[4]='I035' // 'I035': item "Platinum Dagger"
    set udg_ShadowKatana[4]='I05T' // 'I05T': item "Kiku-Ichimonji"
    set udg_ShadowArmor[4]='I01O' // 'I01O': item "Storm Wyrm Hide Armor"
    set udg_ShadowPotion[5]='I02X' // 'I02X': item "Greater Nectar"
    set udg_ShadowHelmet[5]='I02Z' // 'I02Z': item "Barbarian's Helmet"
    set udg_ShadowDagger[5]='I035' // 'I035': item "Platinum Dagger"
    set udg_ShadowKatana[5]='I0L9' // 'I0L9': item "Shimmering Katana"
    set udg_ShadowArmor[5]='I0LM' // 'I0LM': item "Shimmering Cloth"
    set udg_ShadowPotion[6]='I02X' // 'I02X': item "Greater Nectar"
    set udg_ShadowHelmet[6]='I02Z' // 'I02Z': item "Barbarian's Helmet"
    set udg_ShadowDagger[6]='I035' // 'I035': item "Platinum Dagger"
    set udg_ShadowKatana[6]='I0L9' // 'I0L9': item "Shimmering Katana"
    set udg_ShadowArmor[6]='I0LM' // 'I0LM': item "Shimmering Cloth"
    set udg_ShadowPotion[7]='I02X' // 'I02X': item "Greater Nectar"
    set udg_ShadowHelmet[7]='I0AA' // 'I0AA': item "Genji Mask"
    set udg_ShadowDagger[7]='I0CU' // 'I0CU': item "Assassin's Dagger"
    set udg_ShadowKatana[7]='I0L9' // 'I0L9': item "Shimmering Katana"
    set udg_ShadowArmor[7]='I01Y' // 'I01Y': item "Genji Armor"
    set udg_ShadowPotion[8]='pres' // 'pres': item "Elixir"
    set udg_ShadowHelmet[8]='I0AA' // 'I0AA': item "Genji Mask"
    set udg_ShadowDagger[8]='I0CU' // 'I0CU': item "Assassin's Dagger"
    set udg_ShadowKatana[8]='I0F7' // 'I0F7': item "Muramasa"
    set udg_ShadowArmor[8]='I01Y' // 'I01Y': item "Genji Armor"
    set udg_ShadowPotion[9]='pres' // 'pres': item "Elixir"
    set udg_ShadowHelmet[9]='I0AA' // 'I0AA': item "Genji Mask"
    set udg_ShadowDagger[9]='I0BU' // 'I0BU': item "Genji Shield"
    set udg_ShadowKatana[9]='I0F7' // 'I0F7': item "Muramasa"
    set udg_ShadowArmor[9]='I01Y' // 'I01Y': item "Genji Armor"
    set udg_ShadowPotion[$A]='I03P' // $A = 10; 'I03P': item "Megalixir"
    set udg_ShadowHelmet[$A]='I0AA' // $A = 10; 'I0AA': item "Genji Mask"
    set udg_ShadowDagger[$A]='I0BU' // $A = 10; 'I0BU': item "Genji Shield"
    set udg_ShadowKatana[$A]='I0DM' // $A = 10; 'I0DM': item "Masamune C"
    set udg_ShadowSpawnPoint[0]=GetRectCenter(gg_rct_500)
    set udg_ShadowSpawnFacing[0]=180.
    set udg_ShadowSpawnPoint[1]=GetRectCenter(gg_rct_501)
    set udg_ShadowSpawnFacing[1]=240.
    set udg_ShadowSpawnPoint[2]=GetRectCenter(gg_rct_502)
    set udg_ShadowSpawnFacing[2]=285.
    set udg_ShadowSpawnPoint[3]=GetRectCenter(gg_rct_503)
    set udg_ShadowSpawnFacing[3]=190.
    set udg_ShadowSpawnPoint[4]=GetRectCenter(gg_rct_504)
    set udg_ShadowSpawnFacing[4]=330.
    set udg_ShadowSpawnPoint[5]=GetRectCenter(gg_rct_505)
    set udg_ShadowSpawnFacing[5]=200.
    set udg_ShadowSpawnPoint[6]=GetRectCenter(gg_rct_506)
    set udg_ShadowSpawnFacing[6]=.0
    set udg_ShadowSpawnPoint[7]=GetRectCenter(gg_rct_507)
    set udg_ShadowSpawnFacing[7]=315.
    set udg_ShadowSpawnPoint[8]=GetRectCenter(gg_rct_508)
    set udg_ShadowSpawnFacing[8]=250.
    set udg_ShadowSpawnPoint[9]=GetRectCenter(gg_rct_509)
    set udg_ShadowSpawnFacing[9]=270.
    set udg_ShadowSpawnPoint[$A]=GetRectCenter(gg_rct_510) // $A = 10
    set udg_ShadowSpawnFacing[$A]=90. // $A = 10
    set udg_ShadowSpawnPoint[$B]=GetRectCenter(gg_rct_511) // $B = 11
    set udg_ShadowSpawnFacing[$B]=270. // $B = 11
    set udg_ShadowSpawnPoint[$C]=GetRectCenter(gg_rct_512) // $C = 12
    set udg_ShadowSpawnFacing[$C]=260. // $C = 12
    set udg_ShadowSpawnPoint[$D]=GetRectCenter(gg_rct_513) // $D = 13
    set udg_ShadowSpawnFacing[$D]=.0 // $D = 13
    set udg_ShadowSpawnPoint[$E]=GetRectCenter(gg_rct_514) // $E = 14
    set udg_ShadowSpawnFacing[$E]=90. // $E = 14
    set udg_ShadowSpawnPoint[$F]=GetRectCenter(gg_rct_515) // $F = 15
    set udg_ShadowSpawnFacing[$F]=270. // $F = 15
    set udg_ShadowSpawnPoint[16]=GetRectCenter(gg_rct_516)
    set udg_ShadowSpawnFacing[16]=180.
    set udg_ShadowSpawnPoint[17]=GetRectCenter(gg_rct_517)
    set udg_ShadowSpawnFacing[17]=345.
    set udg_ShadowSpawnPoint[18]=GetRectCenter(gg_rct_518)
    set udg_ShadowSpawnFacing[18]=270.
    set udg_ShadowSpawnPoint[19]=GetRectCenter(gg_rct_519)
    set udg_ShadowSpawnFacing[19]=325.
    set udg_ShadowSpawnPoint[20]=GetRectCenter(gg_rct_520)
    set udg_ShadowSpawnFacing[20]=155.
    set udg_ShadowSpawnPoint[21]=GetRectCenter(gg_rct_521)
    set udg_ShadowSpawnFacing[21]=270.
    set udg_ShadowSpawnPoint[22]=GetRectCenter(gg_rct_522)
    set udg_ShadowSpawnFacing[22]=.0
    set udg_ShadowSpawnPoint[23]=GetRectCenter(gg_rct_523)
    set udg_ShadowSpawnFacing[23]=.0
    set udg_ShadowSpawnPoint[24]=GetRectCenter(gg_rct_524)
    set udg_ShadowSpawnFacing[24]=270.
    set udg_ShadowSpawnPoint[25]=GetRectCenter(gg_rct_525)
    set udg_ShadowSpawnFacing[25]=270.
    set udg_ShadowSpawnPoint[26]=GetRectCenter(gg_rct_526)
    set udg_ShadowSpawnFacing[26]=280.
    set udg_ShadowSpawnPoint[27]=GetRectCenter(gg_rct_527)
    set udg_ShadowSpawnFacing[27]=50.
    set udg_ShadowSpawnPoint[28]=GetRectCenter(gg_rct_528)
    set udg_ShadowSpawnFacing[28]=225.
    set udg_ShadowSpawnPoint[29]=GetRectCenter(gg_rct_529)
    set udg_ShadowSpawnFacing[29]=.0
    set udg_ShadowSpawnPoint[30]=GetRectCenter(gg_rct_530)
    set udg_ShadowSpawnFacing[30]=180.
    set udg_ShadowSpawnPoint[31]=GetRectCenter(gg_rct_531)
    set udg_ShadowSpawnFacing[31]=90.
    set udg_ShadowSpawnPoint[32]=GetRectCenter(gg_rct_532)
    set udg_ShadowSpawnFacing[32]=310.
    set udg_ShadowSpawnPoint[33]=GetRectCenter(gg_rct_533)
    set udg_ShadowSpawnFacing[33]=80.
    set udg_ShadowSpawnPoint[34]=GetRectCenter(gg_rct_534)
    set udg_ShadowSpawnFacing[34]=220.
    set udg_ShadowSpawnPoint[35]=GetRectCenter(gg_rct_535)
    set udg_ShadowSpawnFacing[35]=225.
    set udg_ShadowSpawnPoint[36]=GetRectCenter(gg_rct_536)
    set udg_ShadowSpawnFacing[36]=315.
    set udg_ShadowSpawnPoint[37]=GetRectCenter(gg_rct_537)
    set udg_ShadowSpawnFacing[37]=290.
    set udg_ShadowSpawnPoint[38]=GetRectCenter(gg_rct_538)
    set udg_ShadowSpawnFacing[38]=180.
    set udg_ShadowSpawnPoint[39]=GetRectCenter(gg_rct_539)
    set udg_ShadowSpawnFacing[39]=200.
    set udg_ShadowSpawnPoint[40]=GetRectCenter(gg_rct_540)
    set udg_ShadowSpawnFacing[40]=85.
    set udg_ShadowSpawnPoint[41]=GetRectCenter(gg_rct_541)
    set udg_ShadowSpawnFacing[41]=255.
    set udg_ShadowSpawnPoint[42]=GetRectCenter(gg_rct_542)
    set udg_ShadowSpawnFacing[42]=315.
    set udg_ShadowSpawnPoint[43]=GetRectCenter(gg_rct_543)
    set udg_ShadowSpawnFacing[43]=.0
    set udg_ShadowSpawnPoint[44]=GetRectCenter(gg_rct_544)
    set udg_ShadowSpawnFacing[44]=225.
    set udg_ShadowSpawnPoint[45]=GetRectCenter(gg_rct_545)
    set udg_ShadowSpawnFacing[45]=225.
    set udg_ShadowSpawnPoint[46]=GetRectCenter(gg_rct_546)
    set udg_ShadowSpawnFacing[46]=300.
    set udg_ShadowSpawnPoint[47]=GetRectCenter(gg_rct_547)
    set udg_ShadowSpawnFacing[47]=180.
    set udg_ShadowSpawnPoint[48]=GetRectCenter(gg_rct_548)
    set udg_ShadowSpawnFacing[48]=310.
    set udg_ShadowSpawnPoint[49]=GetRectCenter(gg_rct_566)
    set udg_ShadowSpawnFacing[49]=135.
    call CreateNUnitsAtLoc(1,'n04K',Player(8),udg_ShadowSpawnPoint[0],udg_ShadowSpawnFacing[0]) // 'n04K': unit "Shadow"
    set udg_ShadowUnit=GetLastCreatedUnit()
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shadow_FirstAppear_Actions takes nothing returns nothing
    set udg_SpecialEffect[65]=AddSpecialEffectTargetUnitBJ("overhead",udg_ShadowUnit,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call StartTimerBJ(udg_ShadowTimer,false,900.)
    call EnableTrigger(gg_trg_Shadow_Intro)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shadow_Intro_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_ShadowUnit,true,true,true))
endfunction

function Trig_Shadow_Intro_IsShadowCinematicAllowed takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Shadow_Intro_AddPlayerBestLevel takes nothing returns nothing
    // (udg_TempInteger) plus (udg_HighestJobLevel at position GetConvertedPlayerId(the player being visited)).
    set udg_TempInteger=(udg_TempInteger+udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())])
endfunction

function Trig_Shadow_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[65])
    call PauseTimerBJ(true,udg_ShadowTimer)
    if(Trig_Shadow_Intro_IsShadowCinematicAllowed())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(GetTriggerUnit(),"Hmm. You are adventurers, are you not?",false)
        call Text_Say(GetTriggerUnit(),"I am a traveling mercenary. They call me Shadow. For an adequate amount of gold, I might lend you my blade in battle.",false)
        call Text_Say(GetTriggerUnit(),"If you are interested, tell me. May we meet each other often.",false)
        call Cine_ExitAction()
    endif
    set udg_TempInteger=0
    call ForForce(udg_PlayingPlayers,function Trig_Shadow_Intro_AddPlayerBestLevel)
    // Result 1: (udg_TempInteger) divided by (CountPlayersInForceBJ(udg_PlayingPlayers)); drop the remainder.
    // Result 2: (result 1) minus (1).
    // Result 3: (result 2) divided by (10); drop the remainder.
    set udg_ShadowOfferTier=(((udg_TempInteger/ CountPlayersInForceBJ(udg_PlayingPlayers))-1)/ $A) // $A = 10
    call AddUnitToStockBJ(udg_ShadowHireOffer[udg_ShadowOfferTier],udg_ShadowUnit,1,1)
    // (udg_ShadowOfferTier) plus (1).
    call AddUnitToStockBJ(udg_ShadowHireOffer[(udg_ShadowOfferTier+1)],udg_ShadowUnit,2,2)
    // (udg_ShadowOfferTier) plus (2).
    call AddUnitToStockBJ(udg_ShadowHireOffer[(udg_ShadowOfferTier+2)],udg_ShadowUnit,3,3)
    // (remaining seconds of udg_ShadowTimer) plus (30).
    call StartTimerBJ(udg_ShadowTimer,false,(TimerGetRemaining(udg_ShadowTimer)+30.))
    call EnableTrigger(gg_trg_Shadow_Hire)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Shadow_Respawn_IsShadowRetired takes nothing returns boolean
    return(udg_ShadowLoyalty<=0)or(udg_SpawnsPaused)
endfunction

function Trig_Shadow_Respawn_Cond_ShadowRetired takes nothing returns boolean
    return(Trig_Shadow_Respawn_IsShadowRetired())
endfunction

function Trig_Shadow_Respawn_IsPlayerLevelHigher takes nothing returns boolean
    return(udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())]>udg_TempInteger)
endfunction

function Trig_Shadow_Respawn_TakeHighestPlayerLevel takes nothing returns nothing
    if(Trig_Shadow_Respawn_IsPlayerLevelHigher())then
        set udg_TempInteger=udg_HighestJobLevel[GetConvertedPlayerId(GetEnumPlayer())]
    endif
endfunction

function Trig_Shadow_Respawn_IsMainQuestDone takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[GetForLoopIndexA()]))
endfunction

function Trig_Shadow_Respawn_IsSpawnIndexTooHigh takes nothing returns boolean
    return(udg_TempInteger>=50)
endfunction

function Trig_Shadow_Respawn_HasForcedSpawn takes nothing returns boolean
    return(udg_ShadowForcedSpawn>0)
endfunction

function Trig_Shadow_Respawn_AddHeroLevel takes nothing returns nothing
    // (udg_TempInteger) plus (hero level of udg_SpiritOfGaya at position GetConvertedPlayerId(the player being
    // visited)).
    set udg_TempInteger=(udg_TempInteger+GetHeroLevel(udg_SpiritOfGaya[GetConvertedPlayerId(GetEnumPlayer())]))
endfunction

function Trig_Shadow_Respawn_IsSideQuest44Open takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[44])==false)
endfunction

function Trig_Shadow_Respawn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Shadow_Respawn_Cond_ShadowRetired())then
        call DestroyTrigger(GetTriggeringTrigger())
        return
    endif
    if(Trig_Shadow_Respawn_HasForcedSpawn())then
        set udg_TempInteger=udg_ShadowForcedSpawn
        set udg_ShadowForcedSpawn=0
    else
        set udg_TempInteger=1
        call ForForce(udg_PlayingPlayers,function Trig_Shadow_Respawn_TakeHighestPlayerLevel)
        // (udg_TempInteger) plus (udg_QuestsCompleted).
        set udg_TempInteger=(udg_TempInteger+udg_QuestsCompleted)
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=19
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Shadow_Respawn_IsMainQuestDone())then
                // Increase udg_TempInteger by 2.
                set udg_TempInteger=(udg_TempInteger+2)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        // (a random whole number from 1 through udg_TempInteger) divided by (4); drop the remainder.
        set udg_TempInteger=(GetRandomInt(1,udg_TempInteger)/ 4)
        if(Trig_Shadow_Respawn_IsSpawnIndexTooHigh())then
            set udg_TempInteger=49
        endif
    endif
    call CreateNUnitsAtLoc(1,'n04K',Player(8),udg_ShadowSpawnPoint[udg_TempInteger],udg_ShadowSpawnFacing[udg_TempInteger]) // 'n04K': unit "Shadow"
    set udg_ShadowUnit=GetLastCreatedUnit()
    if(Trig_Shadow_Respawn_IsSideQuest44Open())then
        set udg_TempInteger=0
        call ForForce(udg_PlayingPlayers,function Trig_Shadow_Respawn_AddHeroLevel)
        // Result 1: (udg_TempInteger) divided by (CountPlayersInForceBJ(udg_PlayingPlayers)); drop the remainder.
        // Result 2: (result 1) minus (1).
        // Result 3: (result 2) divided by (10); drop the remainder.
        set udg_ShadowOfferTier=(((udg_TempInteger/ CountPlayersInForceBJ(udg_PlayingPlayers))-1)/ $A) // $A = 10
        call AddUnitToStockBJ(udg_ShadowHireOffer[udg_ShadowOfferTier],udg_ShadowUnit,1,1)
        // (udg_ShadowOfferTier) plus (1).
        call AddUnitToStockBJ(udg_ShadowHireOffer[(udg_ShadowOfferTier+1)],udg_ShadowUnit,2,2)
        // (udg_ShadowOfferTier) plus (2).
        call AddUnitToStockBJ(udg_ShadowHireOffer[(udg_ShadowOfferTier+2)],udg_ShadowUnit,3,3)
    else
        call AddUnitToStockBJ('n085',udg_ShadowUnit,1,1) // 'n085': unit "Hiring Shadow For Free"
    endif
    call StartTimerBJ(udg_ShadowTimer,false,300.)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Shadow_NearbyDelay,1280.,udg_ShadowUnit)
    call EnableTrigger(gg_trg_Shadow_Hire)
    call EnableTrigger(gg_trg_Shadow_Leave)
    call EnableTrigger(gg_trg_Shadow_NearbyDelay)
endfunction

function Trig_Shadow_Leave_IsIntroPending takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Shadow_Intro))
endfunction

function Trig_Shadow_Leave_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Shadow_Leave_IsIntroPending())then
        call DestroyEffectBJ(udg_SpecialEffect[65])
        call DisableTrigger(gg_trg_Shadow_Intro)
        call DestroyTrigger(gg_trg_Shadow_Intro)
    endif
    call RemoveUnit(udg_ShadowUnit)
    call ConditionalTriggerExecute(gg_trg_Shadow_Respawn)
endfunction

function Trig_Shadow_NearbyDelay_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Shadow_NearbyDelay_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    // (remaining seconds of udg_ShadowTimer) plus (60).
    call StartTimerBJ(udg_ShadowTimer,false,(TimerGetRemaining(udg_ShadowTimer)+60.))
endfunction

function Trig_Shadow_Death_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==udg_ShadowUnit)
endfunction

function Trig_Shadow_Death_IsNotShadowItem takes nothing returns boolean
    return(GetItemUserData(UnitItemInSlotBJ(udg_ShadowUnit,GetForLoopIndexA()))!=$B) // $B = 11
endfunction

function Trig_Shadow_Death_IsFewKills takes nothing returns boolean
    return(udg_ShadowKills<=20)
endfunction

function Trig_Shadow_Death_IsManyKills takes nothing returns boolean
    return(udg_ShadowKills>30)
endfunction

function Trig_Shadow_Death_IsVeryFewKills takes nothing returns boolean
    return(udg_ShadowKills<$A) // $A = 10
endfunction

function Trig_Shadow_Death_HasLoyaltyLeft takes nothing returns boolean
    return(udg_ShadowLoyalty>=1)
endfunction

function Trig_Shadow_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Shadow_Death_IsNotShadowItem())then
            call UnitRemoveItemFromSlotSwapped(GetForLoopIndexA(),udg_ShadowUnit)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    call RemoveUnit(udg_ShadowUnit)
    call DisplayTimedTextToForce(GetPlayersAll(),15.,"Shadow leaves the party.")
    if(Trig_Shadow_Death_IsVeryFewKills())then
        // Decrease udg_ShadowLoyalty by 8.
        set udg_ShadowLoyalty=(udg_ShadowLoyalty-8)
    else
        if(Trig_Shadow_Death_IsManyKills())then
            // Increase udg_ShadowLoyalty by 4.
            set udg_ShadowLoyalty=(udg_ShadowLoyalty+4)
        else
            if(Trig_Shadow_Death_IsFewKills())then
                // Decrease udg_ShadowLoyalty by 4.
                set udg_ShadowLoyalty=(udg_ShadowLoyalty-4)
            endif
        endif
    endif
    if(Trig_Shadow_Death_HasLoyaltyLeft())then
        call DisableTrigger(gg_trg_Shadow_KillCount)
        call DisableTrigger(gg_trg_Shadow_LoyaltyTick)
        call DisableTrigger(gg_trg_Shadow_AttackedByParty)
        call DisableTrigger(gg_trg_Shadow_HealedBonus)
        call StartTimerBJ(udg_ShadowTimer,false,120.)
        call EnableTrigger(gg_trg_Shadow_Respawn)
    else
        call ConditionalTriggerExecute(gg_trg_Shadow_Disband)
        call TriggerExecute(gg_trg_Quest_LostMemories_RingFade)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Shadow_Lifecycle takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Shadow (module Shadow),
// which keeps the original registration order.

function Register_Shadow_Init takes nothing returns nothing
    set gg_trg_Shadow_Init=CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_Shadow_Init,2.)
    call TriggerAddAction(gg_trg_Shadow_Init,function Trig_Shadow_Init_Actions)
endfunction

function Register_Shadow_FirstAppear takes nothing returns nothing
    set gg_trg_Shadow_FirstAppear=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_FirstAppear)
    call TriggerAddAction(gg_trg_Shadow_FirstAppear,function Trig_Shadow_FirstAppear_Actions)
endfunction

function Register_Shadow_Intro takes nothing returns nothing
    set gg_trg_Shadow_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Intro)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Shadow_Intro,Player(7),true)
    call TriggerAddCondition(gg_trg_Shadow_Intro,Condition(function Trig_Shadow_Intro_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Intro,function Trig_Shadow_Intro_Actions)
endfunction

function Register_Shadow_Respawn takes nothing returns nothing
    set gg_trg_Shadow_Respawn=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Respawn)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shadow_Respawn,udg_ShadowTimer)
    call TriggerAddAction(gg_trg_Shadow_Respawn,function Trig_Shadow_Respawn_Actions)
endfunction

function Register_Shadow_Leave takes nothing returns nothing
    set gg_trg_Shadow_Leave=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Shadow_Leave,udg_ShadowTimer)
    call TriggerAddAction(gg_trg_Shadow_Leave,function Trig_Shadow_Leave_Actions)
endfunction

function Register_Shadow_NearbyDelay takes nothing returns nothing
    set gg_trg_Shadow_NearbyDelay=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_NearbyDelay)
    call TriggerAddCondition(gg_trg_Shadow_NearbyDelay,Condition(function Trig_Shadow_NearbyDelay_Conditions))
    call TriggerAddAction(gg_trg_Shadow_NearbyDelay,function Trig_Shadow_NearbyDelay_Actions)
endfunction

function Register_Shadow_Death takes nothing returns nothing
    set gg_trg_Shadow_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Shadow_Death)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Shadow_Death,Player($A),EVENT_PLAYER_UNIT_DEATH) // $A = 10
    call TriggerAddCondition(gg_trg_Shadow_Death,Condition(function Trig_Shadow_Death_Conditions))
    call TriggerAddAction(gg_trg_Shadow_Death,function Trig_Shadow_Death_Actions)
endfunction

endlibrary

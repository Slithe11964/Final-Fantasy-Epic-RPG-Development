library TArenaConquest requires TForce
function Trig_Arena_Conquest_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A12B') // 'A12B': ability "Arena Conquest"
endfunction

function Trig_Arena_Conquest_ArenaNotUnlocked takes nothing returns boolean
    return(IsQuestCompleted(udg_MainQuest[1])==false)
endfunction

function Trig_Arena_Conquest_FullyUnlocked takes nothing returns boolean
    return(udg_ArenaRank>=4)
endfunction

function Trig_Arena_Conquest_IsMaxTier takes nothing returns boolean
    return(udg_TempInteger==0)
endfunction

function Trig_Arena_Conquest_ConquestBlocked takes nothing returns boolean
    return(udg_HardcoreOff)
endfunction

function Trig_Arena_Conquest_AlreadyAtTier takes nothing returns boolean
    return(udg_TempInteger<=udg_ArenaRank)
endfunction

function Trig_Arena_Conquest_IsTier2 takes nothing returns boolean
    return(udg_TempInteger==2)
endfunction

function Trig_Arena_Conquest_HasExtraCups takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[38]))
endfunction

function Trig_Arena_Conquest_ShouldUnlockCups takes nothing returns boolean
    return(udg_TempInteger>=2)and(udg_ArenaRank<2)
endfunction

function Trig_Arena_Conquest_IsTier3 takes nothing returns boolean
    return(udg_TempInteger==3)
endfunction

function Trig_Arena_Conquest_LacksQuest23 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[23])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22]))
endfunction

function Trig_Arena_Conquest_AwardQuest23 takes nothing returns nothing
    if(Trig_Arena_Conquest_LacksQuest23())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=23
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_Conquest_AllTeamsInStock takes nothing returns boolean
    return(udg_ArenaUnitsUnlocked==44)and(udg_TempInteger==3)
endfunction

function Trig_Arena_Conquest_ShouldUnlockValfodr takes nothing returns boolean
    return(udg_TempInteger>=3)and(udg_ArenaRank<3)
endfunction

function Trig_Arena_Conquest_TeamHasShop takes nothing returns boolean
    return(LoadIntegerBJ(3,GetForLoopIndexA(),udg_GameStateHash)>=1)and(LoadIntegerBJ(3,GetForLoopIndexA(),udg_GameStateHash)<=4)
endfunction

function Trig_Arena_Conquest_ShouldUnlockTeams takes nothing returns boolean
    return(udg_TempInteger>=4)
endfunction

function Trig_Arena_Conquest_Actions takes nothing returns nothing
    if(Trig_Arena_Conquest_ArenaNotUnlocked())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"The Arena has not yet been unlocked!")
        call DestroyForce(udg_TempForce)
        return
    endif
    if(Trig_Arena_Conquest_FullyUnlocked())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"The Arena is already fully unlocked!")
        call DestroyForce(udg_TempForce)
        return
    endif
    // The remainder after dividing (GetUnitAbilityLevelSwapped('A12B', the triggering unit)) by (5).
    set udg_TempInteger=ModuloInteger(GetUnitAbilityLevelSwapped('A12B',GetTriggerUnit()),5) // 'A12B': ability "Arena Conquest"
    if(Trig_Arena_Conquest_IsMaxTier())then
        set udg_TempInteger=4
    endif
    if(Trig_Arena_Conquest_AlreadyAtTier())then
        if(Trig_Arena_Conquest_ConquestBlocked())then
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
            call DisplayTimedTextToForce(udg_TempForce,10.,"You are not permitted to unlock any more of the Arena!")
            call DestroyForce(udg_TempForce)
        endif
        return
    endif
    if(Trig_Arena_Conquest_ShouldUnlockCups())then
        if(Trig_Arena_Conquest_IsTier2())then
            call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r Player "+(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" unlocked all cups in the Arena!")))
        endif
        set udg_ChocoboCupStage=2
        call AddUnitToStockBJ('n08P',udg_ArenaOrganizer[0],1,1) // 'n08P': unit "Arena: Barrens Cup"
        call AddItemToStockBJ('I0IU',gg_unit_e01A_0252,1,1) // 'I0IU': item "Crusher's Belt (BP)"
        call AddItemToStockBJ('I0IV',gg_unit_e01A_0252,1,1) // 'I0IV': item "Germinas Boots (BP)"
        call AddItemToStockBJ('I0IW',gg_unit_e01A_0252,1,1) // 'I0IW': item "Necklace of the Sorcerer (BP)"
        call AddUnitToStockBJ('n09L',udg_ArenaOrganizer[0],1,1) // 'n09L': unit "Arena: Mountains Cup"
        call AddItemToStockBJ('I0IX',gg_unit_e01A_0252,1,1) // 'I0IX': item "Thunder Wand (BP)"
        call AddItemToStockBJ('I0IY',gg_unit_e01A_0252,1,1) // 'I0IY': item "Fire Wand (BP)"
        call AddItemToStockBJ('I0IZ',gg_unit_e01A_0252,1,1) // 'I0IZ': item "Ice Wand (BP)"
        call AddUnitToStockBJ('n09D',udg_ArenaOrganizer[0],1,1) // 'n09D': unit "Arena: Island Cup"
        call AddItemToStockBJ('I0J3',gg_unit_e01B_0028,1,1) // 'I0J3': item "Staff of Light (BP)"
        call AddItemToStockBJ('I0J4',gg_unit_e01B_0028,1,1) // 'I0J4': item "Barbarian's Helmet (BP)"
        call AddItemToStockBJ('I0J5',gg_unit_e01B_0028,1,1) // 'I0J5': item "Grandmasterwork Leather (BP)"
        call AddUnitToStockBJ('n08W',udg_ArenaOrganizer[0],1,1) // 'n08W': unit "Arena: Chocobo Cup"
        call AddItemToStockBJ('I0J0',gg_unit_e01B_0028,1,1) // 'I0J0': item "X-Potion (BP)"
        call AddItemToStockBJ('I0J1',gg_unit_e01B_0028,1,1) // 'I0J1': item "Turbo Ether (BP)"
        call AddItemToStockBJ('I0J2',gg_unit_e01B_0028,1,1) // 'I0J2': item "Luchil Nut (BP)"
        call AddUnitToStockBJ('n0A2',udg_ArenaOrganizer[0],1,1) // 'n0A2': unit "Arena: Unique Enemy Cup"
        call AddItemToStockBJ('I0J6',gg_unit_e01B_0028,1,1) // 'I0J6': item "Spirit Potion (BP)"
        call AddItemToStockBJ('I0J7',gg_unit_e01B_0028,1,1) // 'I0J7': item "Blood Ether (BP)"
        call AddItemToStockBJ('I0J8',gg_unit_e01B_0028,1,1) // 'I0J8': item "Champion's Belt (BP)"
        if(Trig_Arena_Conquest_HasExtraCups())then
            call AddUnitToStockBJ('n09N',udg_ArenaOrganizer[0],1,1) // 'n09N': unit "Arena: Ningen Cup"
            call AddItemToStockBJ('I0JC',gg_unit_e01C_0027,1,1) // 'I0JC': item "Gladiator's Blade (BP)"
            call AddItemToStockBJ('I0JD',gg_unit_e01C_0027,1,1) // 'I0JD': item "Muramasa (BP)"
            call AddItemToStockBJ('I0JE',gg_unit_e01C_0027,1,1) // 'I0JE': item "Heady Pipe (BP)"
            call AddUnitToStockBJ('n090',udg_ArenaOrganizer[0],1,1) // 'n090': unit "Arena: Demon Cup"
            call AddItemToStockBJ('I0JF',gg_unit_e01C_0027,1,1) // 'I0JF': item "Assassin's Dagger (BP)"
            call AddItemToStockBJ('I0JG',gg_unit_e01C_0027,1,1) // 'I0JG': item "Helm of the Necromancer (BP)"
            call AddItemToStockBJ('I0JH',gg_unit_e01C_0027,1,1) // 'I0JH': item "Zodiac Helmet (BP)"
            call AddUnitToStockBJ('n094',udg_ArenaOrganizer[0],1,1) // 'n094': unit "Arena: Dimension Cup"
            call AddItemToStockBJ('I0JI',gg_unit_e01D_0026,1,1) // 'I0JI': item "Zodiac Escutcheon (BP)"
            call AddItemToStockBJ('I0JJ',gg_unit_e01D_0026,1,1) // 'I0JJ': item "Robe of Lords (BP)"
            call AddItemToStockBJ('I0JK',gg_unit_e01D_0026,1,1) // 'I0JK': item "Circlet (BP)"
            call AddItemToStockBJ('I0K5',gg_unit_e01D_0026,1,1) // 'I0K5': item "Golden Skull (BP)"
            call AddItemToStockBJ('I0K6',gg_unit_e01D_0026,1,1) // 'I0K6': item "Crystal Skull (BP)"
        endif
    endif
    if(Trig_Arena_Conquest_ShouldUnlockValfodr())then
        if(Trig_Arena_Conquest_IsTier3())then
            call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r Player "+(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" unlocked all cups as well as Valfodr's final battle in the Arena!")))
        endif
        set udg_ArenaOwnerStreak=0
        call AddUnitToStockBJ('n0CX',udg_ArenaOrganizer[4],1,1) // 'n0CX': unit "Arena: No Mercy for the Judged Battle"
        // (215) plus (LoadIntegerBJ(2, 0, udg_GameStateHash)).
        call SaveIntegerBJ(50,$C,($D7+LoadIntegerBJ(2,0,udg_GameStateHash)),udg_GameStateHash) // $C = 12; $D7 = 215
        set udg_ArenaUnitsUnlocked=(udg_ArenaUnitsUnlocked+1)
        call ConditionalTriggerExecute(gg_trg_AlmightyShinra_Arm)
        if(Trig_Arena_Conquest_AllTeamsInStock())then
            set udg_ArenaRank=4
            call SaveIntegerBJ(1,2,$9A,udg_GameStateHash) // $9A = 154
            call ForForce(udg_PlayingPlayers,function Trig_Arena_Conquest_AwardQuest23)
        endif
    endif
    if(Trig_Arena_Conquest_ShouldUnlockTeams())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r Player "+(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" unlocked all teams in the Arena!")))
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=LoadIntegerBJ(2,0,udg_GameStateHash)
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_Conquest_TeamHasShop())then
                call AddUnitToStockBJ(udg_ArenaBattleOffer[GetForLoopIndexA()],udg_ArenaOrganizer[LoadIntegerBJ(3,GetForLoopIndexA(),udg_GameStateHash)],1,1)
                call SaveIntegerBJ(9,3,GetForLoopIndexA(),udg_GameStateHash)
                set udg_ArenaUnitsUnlocked=44
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call SaveIntegerBJ(1,2,$9A,udg_GameStateHash) // $9A = 154
    endif
    set udg_ArenaRank=udg_TempInteger
endfunction

function InitTrig_Arena_Conquest takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part3 (module Arena),
// which keeps the original registration order.

function Register_Arena_Conquest takes nothing returns nothing
    set gg_trg_Arena_Conquest=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Conquest,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arena_Conquest,Condition(function Trig_Arena_Conquest_Conditions))
    call TriggerAddAction(gg_trg_Arena_Conquest,function Trig_Arena_Conquest_Actions)
endfunction

endlibrary

library TMultiboard requires TPlayerPart01, TText, TTime
function Trig_Multiboard_Create_HasMultiboard takes nothing returns boolean
    return(udg_PendingEventCount>0)
endfunction

function Trig_Multiboard_Create_IsPlayingSlot takes nothing returns boolean
    return(IsPlayerInForce(ConvertedPlayer(GetForLoopIndexA()),udg_PlayingPlayers))
endfunction

function Trig_Multiboard_Create_Actions takes nothing returns nothing
    if(Trig_Multiboard_Create_HasMultiboard())then
        call DestroyMultiboardBJ(udg_ScoreBoard)
    endif
    set udg_PendingEventCount=CountPlayersInForceBJ(udg_PlayingPlayers)
    // (udg_PendingEventCount) plus (1).
    set udg_ScoreBoard=CreateMultiboardBJ(6,(udg_PendingEventCount+1),(udg_BoardTitlePrefix+(udg_GameModeName+(udg_BoardTitleMid+udg_DifficultyName))))
    call MultiboardSetItemValueBJ(udg_ScoreBoard,1,1,"|cff00ffffPlayer Name|r")
    call MultiboardSetItemValueBJ(udg_ScoreBoard,2,1,"|cff00ffffJob|r")
    call MultiboardSetItemValueBJ(udg_ScoreBoard,3,1,"|cff00ffffLevel|r")
    call MultiboardSetItemValueBJ(udg_ScoreBoard,4,1,"|cff00ffffDPS|r")
    call MultiboardSetItemValueBJ(udg_ScoreBoard,5,1,"|cff00ffffKills|r")
    call MultiboardSetItemValueBJ(udg_ScoreBoard,6,1,"|cff00ffffGold|r")
    call MultiboardSetItemWidthBJ(udg_ScoreBoard,1,0,11.)
    call MultiboardSetItemWidthBJ(udg_ScoreBoard,2,0,8.)
    call MultiboardSetItemWidthBJ(udg_ScoreBoard,3,0,7.5)
    call MultiboardSetItemWidthBJ(udg_ScoreBoard,4,0,4.5)
    call MultiboardSetItemWidthBJ(udg_ScoreBoard,5,0,3.5)
    call MultiboardSetItemWidthBJ(udg_ScoreBoard,6,0,5.5)
    call MultiboardSetItemStyleBJ(udg_ScoreBoard,0,0,true,false)
    call MultiboardSetItemStyleBJ(udg_ScoreBoard,2,0,true,true)
    call MultiboardSetItemStyleBJ(udg_ScoreBoard,2,1,true,false)
    set udg_BoardRowIndex=1
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Multiboard_Create_IsPlayingSlot())then
            set udg_BoardPlayer[udg_BoardRowIndex]=ConvertedPlayer(GetForLoopIndexA())
            set udg_BoardRowIndex=(udg_BoardRowIndex+1)
        endif
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call TriggerExecute(gg_trg_Multiboard_Refresh)
endfunction

function Trig_Multiboard_Refresh_Actions takes nothing returns nothing
    local integer i=1
    local integer l_pid
    local integer l_jobTypeId
    local integer l_heroLevel
    local integer l_totalLevel
    local unit l_hero=null
    local multiboarditem l_cell
    local string l_dpsText
    loop
        exitwhen i>udg_PendingEventCount
        // (GetPlayerId(udg_BoardPlayer at position i)) plus (1).
        set l_pid=GetPlayerId(udg_BoardPlayer[i])+1
        set l_hero=Player_GetHero(udg_BoardPlayer[i])
        set l_heroLevel=GetHeroLevel(l_hero)
        if(l_heroLevel==99 and GetUnitAbilityLevel(l_hero,'A02F')>=4)then // 'A02F': ability "Mastery"
            set l_heroLevel='d'
        endif
        set l_totalLevel=udg_TotalJobLevel[l_pid]
        if(udg_NewGamePlusLevel[l_pid]>0)then
            // (l_totalLevel) plus (((udg_NewGamePlusLevel at position l_pid) times (100)) times ((udg_JobCount) plus
            // (1))).
            set l_totalLevel=l_totalLevel+(udg_NewGamePlusLevel[l_pid]*'d'*(udg_JobCount+1))
        endif
        set l_dpsText=R2S(LoadReal(udg_DpsHash,l_pid,LoadInteger(udg_DpsHash,0,3)))
        set l_cell=MultiboardGetItem(udg_ScoreBoard,i,1)
        call MultiboardSetItemValue(l_cell,GetUnitName(l_hero))
        call MultiboardReleaseItem(l_cell)
        set l_cell=MultiboardGetItem(udg_ScoreBoard,i,0)
        call MultiboardSetItemValue(l_cell,udg_PlayerName[l_pid])
        call MultiboardReleaseItem(l_cell)
        set l_jobTypeId=GetUnitTypeId(l_hero)
        set l_cell=MultiboardGetItem(udg_ScoreBoard,i,1)
        if(l_jobTypeId=='H000')then // 'H000': unit "Squire"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Squire_Male.blp")
        elseif(l_jobTypeId=='H002')then // 'H002': unit "Chemist"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Chemist_Male.blp")
        elseif(l_jobTypeId=='H003')then // 'H003': unit "Knight"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Knight_Male.blp")
        elseif(l_jobTypeId=='H00A')then // 'H00A': unit "Monk"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Monk_Male.blp")
        elseif(l_jobTypeId=='H00B')then // 'H00B': unit "Thief"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Thief_Female.blp")
        elseif(l_jobTypeId=='H00D')then // 'H00D': unit "Geomancer"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Geomancer_Male.blp")
        elseif(l_jobTypeId=='H00C')then // 'H00C': unit "Lancer"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Lancer_Male.blp")
        elseif(l_jobTypeId=='H00M')then // 'H00M': unit "Holy Swordsman"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT__Orlandu.blp")
        elseif(l_jobTypeId=='H00F')then // 'H00F': unit "Ninja"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Ninja_Male.blp")
        elseif(l_jobTypeId=='H00E')then // 'H00E': unit "Samurai"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Samurai_Male.blp")
        elseif(l_jobTypeId=='H001')then // 'H001': unit "Archer"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Archer_Female.blp")
        elseif(l_jobTypeId=='H005')then // 'H005': unit "Priest"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Priest_Male.blp")
        elseif(l_jobTypeId=='H004')then // 'H004': unit "Wizard"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Wizard_Male.blp")
        elseif(l_jobTypeId=='H009')then // 'H009': unit "Summoner"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Summoner_Female.blp")
        elseif(l_jobTypeId=='H008')then // 'H008': unit "Time Mage"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_TimeMage_Male.blp")
        elseif(l_jobTypeId=='H00G')then // 'H00G': unit "Mediator"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Mediator_Male.blp")
        elseif(l_jobTypeId=='H00I')then // 'H00I': unit "Oracle"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Oracle_Male.blp")
        elseif(l_jobTypeId=='H00J')then // 'H00J': unit "Prophet"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Bard_Male.blp")
        elseif(l_jobTypeId=='H00H')then // 'H00H': unit "Calculator"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Calculator_Male.blp")
        elseif(l_jobTypeId=='H00L')then // 'H00L': unit "Sorcerer"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT__Beowulf.blp")
        elseif(l_jobTypeId=='H02X')then // 'H02X': unit "Dark Knight"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNDarkKnight.blp")
        elseif(l_jobTypeId=='H02Y')then // 'H02Y': unit "Necromancer"
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNFFT_Necromancer.blp")
        elseif(GetUnitName(l_hero)=="Freelancer")then
            call MultiboardSetItemIcon(l_cell,"ReplaceableTextures\\CommandButtons\\BTNVillagerMan1.blp")
        endif
        call MultiboardReleaseItem(l_cell)
        set l_cell=MultiboardGetItem(udg_ScoreBoard,i,2)
        call MultiboardSetItemValue(l_cell,Text_IntToString(l_heroLevel)+udg_BoardLevelSeparator+Text_IntToString(GetUnitLevel(udg_SpiritOfGaya[l_pid]))+udg_BoardLevelSeparator+Text_IntToString(l_totalLevel))
        call MultiboardReleaseItem(l_cell)
        if udg_DpsRefresh then
            set l_cell=MultiboardGetItem(udg_ScoreBoard,i,3)
            // (StringLength(l_dpsText)) minus (2).
            call MultiboardSetItemValue(l_cell,SubString(l_dpsText,0,StringLength(l_dpsText)-2))
            call MultiboardReleaseItem(l_cell)
        endif
        set l_cell=MultiboardGetItem(udg_ScoreBoard,i,4)
        call MultiboardSetItemValue(l_cell,Text_IntToString(udg_PlayerKillCount[l_pid]))
        call MultiboardReleaseItem(l_cell)
        set l_cell=MultiboardGetItem(udg_ScoreBoard,i,5)
        call MultiboardSetItemValue(l_cell,Text_IntToString(GetPlayerState(udg_BoardPlayer[i],PLAYER_STATE_RESOURCE_GOLD)))
        call MultiboardReleaseItem(l_cell)
        set i=i+1
    endloop
    call MultiboardDisplay(udg_ScoreBoard,true)
    set l_cell=null
    set l_hero=null
    set l_dpsText=null
endfunction

function Trig_Multiboard_Title_Actions takes nothing returns nothing
    call MultiboardSetTitleText(udg_ScoreBoard,(udg_BoardTitlePrefix+udg_GameModeName+udg_BoardTitleMid+udg_DifficultyName+udg_BoardTimeLabel+Time_ElapsedString()))
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Multiboard takes nothing returns nothing
endfunction

function RegisterR11_Multiboard_Create takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Multiboard_Create=CreateTrigger()

call DisableTrigger(gg_trg_Multiboard_Create)

call TriggerAddAction(gg_trg_Multiboard_Create,function Trig_Multiboard_Create_Actions)

endfunction




function RegisterR11_Multiboard_Refresh takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Multiboard_Refresh=CreateTrigger()

call DisableTrigger(gg_trg_Multiboard_Refresh)

call TriggerRegisterTimerEvent(gg_trg_Multiboard_Refresh,2.,true)

call TriggerAddAction(gg_trg_Multiboard_Refresh,function Trig_Multiboard_Refresh_Actions)

endfunction




function RegisterR11_Multiboard_Title takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Multiboard_Title=CreateTrigger()

call DisableTrigger(gg_trg_Multiboard_Title)

call TriggerRegisterTimerEventPeriodic(gg_trg_Multiboard_Title,1.)

call TriggerAddAction(gg_trg_Multiboard_Title,function Trig_Multiboard_Title_Actions)

endfunction




endlibrary

library THuntContracts requires TForce, TReward, TUnit
function Trig_Hunt_Accept_Conditions takes nothing returns boolean
    return(SubStringBJ(GetUnitName(GetSoldUnit()),1,6)=="Hunt: ")
endfunction

function Trig_Hunt_Accept_NoHuntSlotLeft takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_HuntSlots)<=0)
endfunction

function Trig_Hunt_Accept_IsHuntBoard takes nothing returns boolean
    return(GetTriggerUnit()==udg_HuntBoard[udg_TempInteger])
endfunction

function Trig_Hunt_Accept_IsFirstActiveHunt takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_Hunt_Accept_IsNotHero takes nothing returns boolean
    return(IsUnitType(GetLastCreatedUnit(),UNIT_TYPE_HERO)==false)!=null
endfunction

function Trig_Hunt_Accept_IsNotHunt22 takes nothing returns boolean
    return(udg_TempInteger!=22)
endfunction

function Trig_Hunt_Accept_HasHuntTrigger takes nothing returns boolean
    return(LoadBooleanBJ(0,udg_TempInteger,udg_HuntData))
endfunction

function Trig_Hunt_Accept_Actions takes nothing returns nothing
    call ShowUnitHide(GetSoldUnit())
    call UnitApplyTimedLifeBJ(.21,'BTLF',GetSoldUnit()) // 'BTLF': object name not found in map data
    if(Trig_Hunt_Accept_NoHuntSlotLeft())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetSoldUnit()))
        call DisplayTimedTextToForce(udg_TempForce,5.,"You currently cannot take on any additional hunts.")
        call DestroyForce(udg_TempForce)
        return
    endif
    set udg_TempInteger=1
    loop
        exitwhen udg_TempInteger>$A // $A = 10
        if(Trig_Hunt_Accept_IsHuntBoard())then
            set udg_HuntStock[udg_TempInteger]=(udg_HuntStock[udg_TempInteger]-1)
        endif
        set udg_TempInteger=udg_TempInteger+1
    endloop
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_TempInteger=GetUnitPointValue(GetSoldUnit())
    call RemoveUnitFromStockBJ(GetUnitTypeId(GetSoldUnit()),GetTriggerUnit())
    call PlaySoundBJ(gg_snd_ArrangedTeamInvitation)
    set udg_TempPlayer=ForcePickRandomPlayer(udg_HuntSlots)
    call ForceRemovePlayerSimple(udg_TempPlayer,udg_HuntSlots)
    call SaveIntegerBJ(GetConvertedPlayerId(udg_TempPlayer),8,udg_TempInteger,udg_HuntData)
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_Hunt_Accept_IsFirstActiveHunt())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    call LeaderboardAddItemBJ(udg_TempPlayer,udg_HuntLeaderboard,SubStringBJ(GetUnitName(GetSoldUnit()),7,StringLength(GetUnitName(GetSoldUnit()))),0)
    call LeaderboardSetPlayerItemLabelColorBJ(udg_TempPlayer,udg_HuntLeaderboard,40.,65.,75.,0)
    call LeaderboardSetPlayerItemValueColorBJ(udg_TempPlayer,udg_HuntLeaderboard,.0,.0,.0,100.)
    set udg_TempPoint=LoadLocationHandleBJ(2,udg_TempInteger,udg_HuntData)
    call CreateNUnitsAtLoc(1,String2UnitIdBJ(LoadStringBJ(3,udg_TempInteger,udg_HuntData)),Player($B),udg_TempPoint,LoadRealBJ(4,udg_TempInteger,udg_HuntData)) // $B = 11
    set udg_HuntTarget[udg_TempInteger]=GetLastCreatedUnit()
    if(Trig_Hunt_Accept_IsNotHero())then
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    endif
    if(Trig_Hunt_Accept_IsNotHunt22())then
        call TriggerRegisterUnitEvent(gg_trg_Hunt_Complete,GetLastCreatedUnit(),EVENT_UNIT_DEATH)
    endif
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,3.,bj_MINIMAPPINGSTYLE_SIMPLE,30.,50.,100.)
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_HuntMonsters)
    call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cffffcc00"+(SubStringBJ(GetUnitName(GetSoldUnit()),7,StringLength(GetUnitName(GetSoldUnit())))+"|r - The Hunt Begins!")))
    if(Trig_Hunt_Accept_HasHuntTrigger())then
        call ConditionalTriggerExecute(LoadTriggerHandleBJ(1,udg_TempInteger,udg_HuntData))
    endif
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Hunt_Complete_NoHuntsActive takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_Hunt_Complete_IsCommonReward takes nothing returns boolean
    return(LoadIntegerBJ(7,GetUnitPointValue(GetTriggerUnit()),udg_HuntData)<$7D0) // $7D0 = 2000
endfunction

function Trig_Hunt_Complete_IsBasicReward takes nothing returns boolean
    return(LoadIntegerBJ(7,GetUnitPointValue(GetTriggerUnit()),udg_HuntData)<$3E8) // $3E8 = 1000
endfunction

function Trig_Hunt_Complete_HasReward takes nothing returns boolean
    return(LoadIntegerBJ(7,GetUnitPointValue(GetTriggerUnit()),udg_HuntData)>0)
endfunction

function Trig_Hunt_Complete_IsFirstHuntDone takes nothing returns boolean
    return(udg_RareHuntsDone==1)
endfunction

function Trig_Hunt_Complete_Actions takes nothing returns nothing
    call PlayThematicMusicBJ("war3mapImported\\FF9-Victory.mp3")
    set udg_RareHuntsDone=(udg_RareHuntsDone+1)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_HuntMonsters)
    set udg_TempPlayer=ConvertedPlayer(LoadIntegerBJ(8,GetUnitPointValue(GetTriggerUnit()),udg_HuntData))
    call LeaderboardRemovePlayerItemBJ(udg_TempPlayer,udg_HuntLeaderboard)
    call SaveIntegerBJ(0,8,GetUnitPointValue(GetTriggerUnit()),udg_HuntData)
    set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
    if(Trig_Hunt_Complete_NoHuntsActive())then
        call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
    endif
    call ForceAddPlayerSimple(udg_TempPlayer,udg_HuntSlots)
    call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cffffcc00"+(GetUnitName(GetTriggerUnit())+"|r vanquished!")))
    call Reward_Give(LoadIntegerBJ(5,GetUnitPointValue(GetTriggerUnit()),udg_HuntData),LoadIntegerBJ(6,GetUnitPointValue(GetTriggerUnit()),udg_HuntData),udg_NarratorUnit)
    if(Trig_Hunt_Complete_HasReward())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        if(Trig_Hunt_Complete_IsBasicReward())then
            call CreateItemLoc(udg_ItemIdTable[LoadIntegerBJ(7,GetUnitPointValue(GetTriggerUnit()),udg_HuntData)],udg_TempPoint)
        else
            if(Trig_Hunt_Complete_IsCommonReward())then
                // (LoadIntegerBJ(7, GetUnitPointValue(the triggering unit), udg_HuntData)) minus (1000).
                call CreateItemLoc(udg_DropItemIdTable[(LoadIntegerBJ(7,GetUnitPointValue(GetTriggerUnit()),udg_HuntData)-$3E8)],udg_TempPoint) // $3E8 = 1000
            endif
        endif
        call RemoveLocation(udg_TempPoint)
    endif
    if(Trig_Hunt_Complete_IsFirstHuntDone())then
        call AddUnitToStockBJ('n0BT',gg_unit_n009_0051,1,1) // 'n0BT': unit "Hunt: Stinger"
        set udg_HuntStock[1]=(udg_HuntStock[1]+1)
        call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    endif
endfunction

function InitTrig_Hunt_Contracts takes nothing returns nothing
endfunction

endlibrary

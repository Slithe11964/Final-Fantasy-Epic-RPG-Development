library TArenaRounds requires TForce, TJob, TLink, TPlayerHero, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Round_Start=null
    trigger gg_trg_Arena_Round_End=null
endglobals

function Trig_Arena_Round_Start_IsEliminatedSlot takes nothing returns boolean
    return(GetForLoopIndexA()>(9-udg_ArenaRound))
endfunction

function Trig_Arena_Round_Start_IsRound1 takes nothing returns boolean
    return(udg_ArenaRound==1)
endfunction

function Trig_Arena_Round_Start_IsRound2 takes nothing returns boolean
    return(udg_ArenaRound==2)
endfunction

function Trig_Arena_Round_Start_IsRound3 takes nothing returns boolean
    return(udg_ArenaRound==3)
endfunction

function Trig_Arena_Round_Start_IsSurvivalMode takes nothing returns boolean
    return(udg_ArenaSurvivalMode)
endfunction

function Trig_Arena_Round_Start_WaitGuard01 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard02 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard03 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard04 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard05 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard06 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard07 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard08 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard09 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard10 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard11 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_RemoveShowcaseUnit1 takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_Round_Start_WaitGuard12 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_IsBeforeRound3 takes nothing returns boolean
    return(udg_ArenaRound<3)
endfunction

function Trig_Arena_Round_Start_WaitGuard13 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard14 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard15 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard16 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_RemoveShowcaseUnit2 takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_Round_Start_WaitGuard17 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard18 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard19 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard20 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard21 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_RemoveShowcaseUnit3 takes nothing returns nothing
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_Round_Start_WaitGuard22 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_ShowMatchupPair3 takes nothing returns boolean
    return(udg_ArenaShowcaseOn)and(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_ShowMatchupPair2 takes nothing returns boolean
    return(udg_ArenaShowcaseOn)and(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_IsBeforeRound2 takes nothing returns boolean
    return(udg_ArenaRound<2)
endfunction

function Trig_Arena_Round_Start_ShowMatchups takes nothing returns boolean
    return(udg_ArenaShowcaseOn)and(udg_ArenaSurvivalMode==false)and(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_NeedsAward23 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[23])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22]))
endfunction

function Trig_Arena_Round_Start_GiveAward23 takes nothing returns nothing
    if(Trig_Arena_Round_Start_NeedsAward23())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=23
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_Round_Start_AllUnitsUnlocked takes nothing returns boolean
    return(udg_ArenaUnitsUnlocked==44)and(udg_ArenaRank<4)
endfunction

function Trig_Arena_Round_Start_IsUnlockableTeam takes nothing returns boolean
    return(LoadIntegerBJ(3,udg_ArenaBracketSlot[2],udg_GameStateHash)<=4)
endfunction

function Trig_Arena_Round_Start_HasShopUnlock takes nothing returns boolean
    return(LoadIntegerBJ(3,udg_ArenaBracketSlot[2],udg_GameStateHash)>=1)and(LoadIntegerBJ(3,udg_ArenaBracketSlot[2],udg_GameStateHash)<=5)
endfunction

function Trig_Arena_Round_Start_WaitGuard23 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard24 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard25 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_WaitGuard26 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_IsFinalRound takes nothing returns boolean
    return(udg_ArenaSurvivalMode==false)or(udg_ArenaRound==7)
endfunction

function Trig_Arena_Round_Start_ShowFinalRoundLabel takes nothing returns boolean
    return(udg_ArenaRound>=3)and(Trig_Arena_Round_Start_IsFinalRound())
endfunction

function Trig_Arena_Round_Start_WaitGuard27 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_Start_IsTeam120 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]=='x')
endfunction

function Trig_Arena_Round_Start_IsSoloRun takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)==1)
endfunction

function Trig_Arena_Round_Start_IsCountedUnit takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RQ',GetEnumUnit())<=0) // 'A0RQ': ability "Invalid Arena Summon"
endfunction

function Trig_Arena_Round_Start_NeedsTrueSight takes nothing returns boolean
    return(LoadIntegerBJ(4,udg_ArenaBracketSlot[2],udg_GameStateHash)>=1)
endfunction

function Trig_Arena_Round_Start_IsCoverGuard takes nothing returns boolean
    return(LoadIntegerBJ(20,udg_ArenaBracketSlot[2],udg_GameStateHash)>=1)and(GetEnumUnit()!=udg_ArenaLeaderUnit)
endfunction

function Trig_Arena_Round_Start_IsNotPausedGlobally takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Arena_Round_Start_ActivateArenaUnit takes nothing returns nothing
    call SetUnitInvulnerable(GetEnumUnit(),false)
    call UnitRemoveAbilityBJ('Abun',GetEnumUnit()) // 'Abun': object name not found in map data
    call SetUnitAcquireRangeBJ(GetEnumUnit(),1920.)
    if(Trig_Arena_Round_Start_IsCountedUnit())then
        call GroupAddUnitSimple(GetEnumUnit(),udg_CupArenaUnits)
    else
        call GroupAddUnitSimple(GetEnumUnit(),udg_ArenaSummonGroup)
    endif
    if(Trig_Arena_Round_Start_NeedsTrueSight())then
        call GroupAddUnitSimple(GetEnumUnit(),udg_BossGroup)
        call UnitAddAbilityBJ('Agyv',GetEnumUnit()) // 'Agyv': editor label "True Sight"
    endif
    if(Trig_Arena_Round_Start_IsCoverGuard())then
        call UnitAddAbilityBJ('A0X2',GetEnumUnit()) // 'A0X2': ability "Perma Cover"
        call Link_SaveCaster(udg_ArenaLeaderUnit,GetEnumUnit(),.0)
    endif
    if(Trig_Arena_Round_Start_IsNotPausedGlobally())then
        call PauseUnitBJ(false,GetEnumUnit())
    endif
endfunction

function Trig_Arena_Round_Start_CanAttackGround takes nothing returns boolean
    return(IsUnitType(GetEnumUnit(),UNIT_TYPE_ATTACKS_GROUND))!=null
endfunction

function Trig_Arena_Round_Start_OrderAttackPlayer takes nothing returns nothing
    if(Trig_Arena_Round_Start_CanAttackGround())then
        set udg_TempPoint=GetUnitLoc(Player_GetHero(ForcePickRandomPlayer(udg_CupArenaPlayers)))
        call IssuePointOrderLocBJ(GetEnumUnit(),"attack",udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
    endif
endfunction

function Trig_Arena_Round_Start_Actions takes nothing returns nothing
    set udg_TempPoint=GetRectCenter(gg_rct_044)
    set udg_ArenaTextTag[1]=CreateTextTagLocBJ("Adventurers",udg_TempPoint,0,12.,'d',80.,.0,0)
    call RemoveLocation(udg_TempPoint)
    set bj_forLoopBIndex=2
    set bj_forLoopBIndexEnd=8
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        set udg_TempPoint=OffsetLocation(GetRectCenter(gg_rct_044),0,(-128.*(I2R(GetForLoopIndexB())-1)))
        set udg_ArenaTextTag[GetForLoopIndexB()]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaBracketSlot[GetForLoopIndexB()],udg_GameStateHash),udg_TempPoint,0,12.,'d',100.,100.,0)
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    call SetTextTagColorBJ(udg_ArenaTextTag[2],100.,80.,.0,0)
    if(Trig_Arena_Round_Start_IsSurvivalMode())then
        set bj_forLoopAIndex=3
        set bj_forLoopAIndexEnd=8
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_Round_Start_IsEliminatedSlot())then
                call SetTextTagColorBJ(udg_ArenaTextTag[GetForLoopIndexA()],'d',.0,.0,0)
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
    else
        if(Trig_Arena_Round_Start_IsRound1())then
            call SetTextTagColorBJ(udg_ArenaTextTag[3],.0,100.,.0,0)
            call SetTextTagColorBJ(udg_ArenaTextTag[4],.0,100.,.0,0)
            call SetTextTagColorBJ(udg_ArenaTextTag[5],88.,88.,88.,0)
            call SetTextTagColorBJ(udg_ArenaTextTag[6],88.,88.,88.,0)
            call SetTextTagColorBJ(udg_ArenaTextTag[7],10.,10.,100.,0)
            call SetTextTagColorBJ(udg_ArenaTextTag[8],10.,10.,100.,0)
        endif
        if(Trig_Arena_Round_Start_IsRound2())then
            call SetTextTagColorBJ(udg_ArenaTextTag[3],.0,100.,.0,0)
            call SetTextTagColorBJ(udg_ArenaTextTag[4],.0,100.,.0,0)
            set bj_forLoopAIndex=5
            set bj_forLoopAIndexEnd=8
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                call SetTextTagColorBJ(udg_ArenaTextTag[GetForLoopIndexA()],'d',.0,.0,0)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
        endif
        if(Trig_Arena_Round_Start_IsRound3())then
            set bj_forLoopAIndex=3
            set bj_forLoopAIndexEnd=8
            loop
                exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                call SetTextTagColorBJ(udg_ArenaTextTag[GetForLoopIndexA()],'d',.0,.0,0)
                set bj_forLoopAIndex=bj_forLoopAIndex+1
            endloop
        endif
    endif
    if(Trig_Arena_Round_Start_WaitGuard07())then
        call Wait_Polled(1.)
        if(Trig_Arena_Round_Start_WaitGuard06())then
            call Wait_Polled(1.)
            if(Trig_Arena_Round_Start_WaitGuard05())then
                call Wait_Polled(1.)
                if(Trig_Arena_Round_Start_WaitGuard04())then
                    call Wait_Polled(1.)
                    if(Trig_Arena_Round_Start_WaitGuard03())then
                        call Wait_Polled(1.)
                        if(Trig_Arena_Round_Start_WaitGuard02())then
                            call Wait_Polled(1.)
                            if(Trig_Arena_Round_Start_WaitGuard01())then
                                call Wait_Polled(1.)
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call DestroyTextTagBJ(udg_ArenaTextTag[GetForLoopIndexA()])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set udg_TempPoint=GetRectCenter(gg_rct_046)
    set udg_ArenaTextTag[3]=CreateTextTagLocBJ("VERSUS",udg_TempPoint,0,$A,'d',90.,10.,0) // $A = 10
    call RemoveLocation(udg_TempPoint)
    if(Trig_Arena_Round_Start_ShowMatchups())then
        if(Trig_Arena_Round_Start_IsBeforeRound3())then
            set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_044)
            set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[3]
            set udg_ArenaTextTag[1]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
            set udg_ArenaSpawnFacing=270.
            call ConditionalTriggerExecute(gg_trg_Arena_Spawn_Team)
            set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_045)
            set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[4]
            set udg_ArenaTextTag[2]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
            set udg_ArenaSpawnFacing=90.
            call StartTimerBJ(udg_ArenaSpawnTimer,false,.0)
            call Wait_Polled(1.)
            if(Trig_Arena_Round_Start_WaitGuard11())then
                call Wait_Polled(1.)
                if(Trig_Arena_Round_Start_WaitGuard10())then
                    call Wait_Polled(1.)
                    if(Trig_Arena_Round_Start_WaitGuard09())then
                        call Wait_Polled(1.)
                        if(Trig_Arena_Round_Start_WaitGuard08())then
                            call Wait_Polled(1.)
                        endif
                    endif
                endif
            endif
            call DestroyTextTagBJ(udg_ArenaTextTag[1])
            call DestroyTextTagBJ(udg_ArenaTextTag[2])
            call Wait_Polled(1.)
            call ForGroupBJ(udg_ArenaSpawnGroup,function Trig_Arena_Round_Start_RemoveShowcaseUnit1)
            call GroupClear(udg_ArenaSpawnGroup)
            call Wait_Polled(1.)
            if(Trig_Arena_Round_Start_WaitGuard12())then
                call Wait_Polled(1.)
            endif
        endif
        if(Trig_Arena_Round_Start_IsBeforeRound2())then
            if(Trig_Arena_Round_Start_ShowMatchupPair2())then
                call SetTextTagTextBJ(udg_ArenaTextTag[3],"VERSUS",$A) // $A = 10
                set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_044)
                set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[5]
                set udg_ArenaTextTag[1]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
                set udg_ArenaSpawnFacing=270.
                call ConditionalTriggerExecute(gg_trg_Arena_Spawn_Team)
                set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_045)
                set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[6]
                set udg_ArenaTextTag[2]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
                set udg_ArenaSpawnFacing=90.
                call StartTimerBJ(udg_ArenaSpawnTimer,false,.0)
                call Wait_Polled(1.)
                if(Trig_Arena_Round_Start_WaitGuard16())then
                    call Wait_Polled(1.)
                    if(Trig_Arena_Round_Start_WaitGuard15())then
                        call Wait_Polled(1.)
                        if(Trig_Arena_Round_Start_WaitGuard14())then
                            call Wait_Polled(1.)
                            if(Trig_Arena_Round_Start_WaitGuard13())then
                                call Wait_Polled(1.)
                            endif
                        endif
                    endif
                endif
                call DestroyTextTagBJ(udg_ArenaTextTag[1])
                call DestroyTextTagBJ(udg_ArenaTextTag[2])
                call Wait_Polled(1.)
                call ForGroupBJ(udg_ArenaSpawnGroup,function Trig_Arena_Round_Start_RemoveShowcaseUnit2)
                call GroupClear(udg_ArenaSpawnGroup)
                call Wait_Polled(1.)
                if(Trig_Arena_Round_Start_WaitGuard17())then
                    call Wait_Polled(1.)
                endif
                if(Trig_Arena_Round_Start_ShowMatchupPair3())then
                    call SetTextTagTextBJ(udg_ArenaTextTag[3],"VERSUS",$A) // $A = 10
                    set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_044)
                    set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[7]
                    set udg_ArenaTextTag[1]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
                    set udg_ArenaSpawnFacing=270.
                    call ConditionalTriggerExecute(gg_trg_Arena_Spawn_Team)
                    set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_045)
                    set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[8]
                    set udg_ArenaTextTag[2]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
                    set udg_ArenaSpawnFacing=90.
                    call StartTimerBJ(udg_ArenaSpawnTimer,false,.0)
                    call Wait_Polled(1.)
                    if(Trig_Arena_Round_Start_WaitGuard21())then
                        call Wait_Polled(1.)
                        if(Trig_Arena_Round_Start_WaitGuard20())then
                            call Wait_Polled(1.)
                            if(Trig_Arena_Round_Start_WaitGuard19())then
                                call Wait_Polled(1.)
                                if(Trig_Arena_Round_Start_WaitGuard18())then
                                    call Wait_Polled(1.)
                                endif
                            endif
                        endif
                    endif
                    call DestroyTextTagBJ(udg_ArenaTextTag[1])
                    call DestroyTextTagBJ(udg_ArenaTextTag[2])
                    call Wait_Polled(1.)
                    call ForGroupBJ(udg_ArenaSpawnGroup,function Trig_Arena_Round_Start_RemoveShowcaseUnit3)
                    call GroupClear(udg_ArenaSpawnGroup)
                    call Wait_Polled(1.)
                    if(Trig_Arena_Round_Start_WaitGuard22())then
                        call Wait_Polled(1.)
                    endif
                endif
            endif
        endif
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_044)
    set udg_ArenaTextTag[1]=CreateTextTagLocBJ("Adventurers",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
    call RemoveLocation(udg_TempPoint)
    if(Trig_Arena_Round_Start_HasShopUnlock())then
        call AddUnitToStockBJ(udg_ArenaBattleOffer[udg_ArenaBracketSlot[2]],udg_ArenaOrganizer[LoadIntegerBJ(3,udg_ArenaBracketSlot[2],udg_GameStateHash)],1,1)
        if(Trig_Arena_Round_Start_IsUnlockableTeam())then
            set udg_ArenaUnitsUnlocked=(udg_ArenaUnitsUnlocked+1)
            if(Trig_Arena_Round_Start_AllUnitsUnlocked())then
                set udg_ArenaRank=4
                call SaveIntegerBJ(1,2,$9A,udg_GameStateHash) // $9A = 154
                call ForForce(udg_PlayingPlayers,function Trig_Arena_Round_Start_GiveAward23)
            endif
        endif
        call SaveIntegerBJ(9,3,udg_ArenaBracketSlot[2],udg_GameStateHash)
    endif
    call SetTextTagTextBJ(udg_ArenaTextTag[3],"VERSUS",$A) // $A = 10
    set udg_ArenaSpawnLoc=GetRectCenter(gg_rct_045)
    set udg_ArenaSpawnTeam=udg_ArenaBracketSlot[2]
    set udg_ArenaTextTag[2]=CreateTextTagLocBJ(LoadStringBJ(1,udg_ArenaSpawnTeam,udg_GameStateHash),udg_ArenaSpawnLoc,0,$A,'d','d','d',0) // $A = 10
    set udg_ArenaSpawnFacing=90.
    call StartTimerBJ(udg_ArenaSpawnTimer,false,.0)
    call Wait_Polled(1.)
    if(Trig_Arena_Round_Start_WaitGuard26())then
        call Wait_Polled(1.)
        if(Trig_Arena_Round_Start_WaitGuard25())then
            call Wait_Polled(1.)
            if(Trig_Arena_Round_Start_WaitGuard24())then
                call Wait_Polled(1.)
                if(Trig_Arena_Round_Start_WaitGuard23())then
                    call Wait_Polled(1.)
                endif
            endif
        endif
    endif
    call DestroyTextTagBJ(udg_ArenaTextTag[1])
    call DestroyTextTagBJ(udg_ArenaTextTag[2])
    if(Trig_Arena_Round_Start_ShowFinalRoundLabel())then
        call SetTextTagTextBJ(udg_ArenaTextTag[3],"Final Round",$A) // $A = 10
    else
        call SetTextTagTextBJ(udg_ArenaTextTag[3],("Round "+I2S(udg_ArenaRound)),$A) // $A = 10
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_047)
    set udg_TempPoint2=GetRectCenter(gg_rct_048)
    set udg_ArenaLightning[1]=AddLightningLoc("FORK",udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=GetRectCenter(gg_rct_049)
    set udg_ArenaLightning[2]=AddLightningLoc("FORK",udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    set udg_TempPoint=GetRectCenter(gg_rct_050)
    set udg_ArenaLightning[3]=AddLightningLoc("FORK",udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint2)
    set udg_TempPoint2=GetRectCenter(gg_rct_048)
    set udg_ArenaLightning[4]=AddLightningLoc("FORK",udg_TempPoint,udg_TempPoint2)
    call RemoveLocation(udg_TempPoint)
    call RemoveLocation(udg_TempPoint2)
    call Wait_Polled(1.)
    if(Trig_Arena_Round_Start_WaitGuard27())then
        call SetTextTagColorBJ(udg_ArenaTextTag[3],'d',45.,5.,0)
        call Wait_Polled(1.)
    endif
    if(Trig_Arena_Round_Start_IsTeam120())then
        set udg_PenanceArmsActive=true
    endif
    set udg_ArenaEliteKilled=false
    if(Trig_Arena_Round_Start_IsSoloRun())then
        set udg_ArenaSoloPlayer=ForcePickRandomPlayer(udg_CupArenaPlayers)
    else
        set udg_ArenaSoloPlayer=Player($B) // $B = 11
    endif
    call ForGroupBJ(udg_ArenaSpawnGroup,function Trig_Arena_Round_Start_ActivateArenaUnit)
    call GroupClear(udg_ArenaSpawnGroup)
    set udg_ArenaIntermission=false
    call ForGroupBJ(udg_CupArenaUnits,function Trig_Arena_Round_Start_OrderAttackPlayer)
    call DestroyTextTagBJ(udg_ArenaTextTag[3])
    set udg_TempPoint=GetRectCenter(gg_rct_046)
    call CreateTextTagLocBJ("FIGHT!",udg_TempPoint,0,$A,'d',.0,.0,0) // $A = 10
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.)
    call RemoveLocation(udg_TempPoint)
    set udg_ArenaStallTicks=0
    call StartTimerBJ(udg_ArenaRoundTimer,false,300.)
    call EnableTrigger(gg_trg_Arena_Round_End)
    call EnableTrigger(gg_trg_Arena_OutOfBounds)
    call ConditionalTriggerExecute(gg_trg_Arena_BattleLost)
endfunction

function Trig_Arena_Round_End_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_CupArenaUnits))
endfunction

function Trig_Arena_Round_End_RollDropChance takes nothing returns boolean
    // A random whole number from 1 through 100.
    return(GetRandomInt(1,'d')<=LoadIntegerBJ(($A+(2*GetForLoopIndexA())),(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash)) // $A = 10
endfunction

function Trig_Arena_Round_End_HasLootTable takes nothing returns boolean
    return(IsUnitDeadBJ(GetTriggerUnit()))and(GetUnitUserData(GetTriggerUnit())>=$A)and(LoadIntegerBJ($A,(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash)>=1) // $A = 10
endfunction

function Trig_Arena_Round_End_RemoveCoverFromFighter takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0X2',GetEnumUnit()) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',GetEnumUnit()) // 'B064': buff "Perma Cover"
endfunction

function Trig_Arena_Round_End_RemoveCoverFromSummon takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0X2',GetEnumUnit()) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',GetEnumUnit()) // 'B064': buff "Perma Cover"
endfunction

function Trig_Arena_Round_End_HasArenaSummons takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_ArenaSummonGroup)==false)
endfunction

function Trig_Arena_Round_End_IsLeaderDead takes nothing returns boolean
    return(GetTriggerUnit()==udg_ArenaLeaderUnit)
endfunction

function Trig_Arena_Round_End_KilledEliteHero takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_ArenaSoloPlayer!=Player($B))and(GetHeroLevel(GetTriggerUnit())>=90))!=null // $B = 11
endfunction

function Trig_Arena_Round_End_IsTeamWiped takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_CupArenaUnits))
endfunction

function Trig_Arena_Round_End_IsFirstTeam20Win takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==20)and(udg_ChocoboCupStage==0)
endfunction

function Trig_Arena_Round_End_CanEarnMastery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',Player_GetHero(udg_ArenaSoloPlayer))==3)and(IsPlayerInForce(udg_ArenaSoloPlayer,udg_QuestForce[udg_TempInteger])==false) // 'A02F': ability "Mastery"
endfunction

function Trig_Arena_Round_End_HasEliteKill takes nothing returns boolean
    return(udg_ArenaEliteKilled)
endfunction

function Trig_Arena_Round_End_NeedsAward49 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[49])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[33]))
endfunction

function Trig_Arena_Round_End_GiveAward49 takes nothing returns nothing
    if(Trig_Arena_Round_End_NeedsAward49())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=49
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_Round_End_IsTeam120Beaten takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]=='x')and(udg_PenanceArmsActive)
endfunction

function Trig_Arena_Round_End_NeedsAward34 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[34])==false)
endfunction

function Trig_Arena_Round_End_GiveAward34 takes nothing returns nothing
    if(Trig_Arena_Round_End_NeedsAward34())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=34
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_Round_End_IsTeam146 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$92) // $92 = 146
endfunction

function Trig_Arena_Round_End_NeedsAward28 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[28])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[27]))
endfunction

function Trig_Arena_Round_End_GiveAward28 takes nothing returns nothing
    if(Trig_Arena_Round_End_NeedsAward28())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=28
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_Round_End_IsTeam171 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$AB) // $AB = 171
endfunction

function Trig_Arena_Round_End_NeedsAward24 takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[24])==false)and(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[23]))
endfunction

function Trig_Arena_Round_End_GiveAward24 takes nothing returns nothing
    if(Trig_Arena_Round_End_NeedsAward24())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=24
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Arena_Round_End_IsTeam154 takes nothing returns boolean
    return(udg_ArenaBracketSlot[2]==$9A) // $9A = 154
endfunction

function Trig_Arena_Round_End_KillLeftoverSummon takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0ZR',GetEnumUnit()) // 'A0ZR': ability "Immortal"
    call KillUnit(GetEnumUnit())
    call RemoveUnit(GetEnumUnit())
endfunction

function Trig_Arena_Round_End_HasBpBonusFlag takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Arena_Round_End_IsCup10Plus takes nothing returns boolean
    return(udg_ArenaCupId>=$A) // $A = 10
endfunction

function Trig_Arena_Round_End_IsCup8Plus takes nothing returns boolean
    return(udg_ArenaCupId>=8)
endfunction

function Trig_Arena_Round_End_IsCup5Plus takes nothing returns boolean
    return(udg_ArenaCupId>=5)
endfunction

function Trig_Arena_Round_End_IsSurvivalBonus takes nothing returns boolean
    return(udg_ArenaSurvivalMode)
endfunction

function Trig_Arena_Round_End_HasDoubleBP takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[22]))
endfunction

function Trig_Arena_Round_End_IsBpOverCap takes nothing returns boolean
    return(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]>$F423F) // $F423F = 999999
endfunction

function Trig_Arena_Round_End_GiveBattlePoints takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetEnumPlayer())
    if(Trig_Arena_Round_End_HasDoubleBP())then
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]+(udg_BattlePoints[0]*2))
        // (udg_BattlePoints at position 0) times (2).
        call DisplayTimedTextToForce(l_tempForce,10.,(("|cffffcc00You get "+I2S((udg_BattlePoints[0]*2)))+" Battle Points.|r"))
    else
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]+udg_BattlePoints[0])
        call DisplayTimedTextToForce(l_tempForce,10.,(("|cffffcc00You get "+I2S(udg_BattlePoints[0]))+" Battle Points.|r"))
    endif
    if(Trig_Arena_Round_End_IsBpOverCap())then
        set udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())]=$F423F // $F423F = 999999
    endif
    call DestroyTextTagBJ(udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())])
    set udg_ArenaBpTag[GetConvertedPlayerId(GetEnumPlayer())]=CreateTextTagUnitBJ(("Current BP: |cffffcc00"+(I2S(udg_BattlePoints[GetConvertedPlayerId(GetEnumPlayer())])+"|r")),gg_unit_h02I_0167,0,$A,'d','d','d',0) // $A = 10
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),l_tempForce)
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

function Trig_Arena_Round_End_RollWinnerPair1 takes nothing returns boolean
    return(((LoadIntegerBJ(5,udg_ArenaBracketSlot[3],udg_GameStateHash)+GetRandomInt(1,20))-$A)<=LoadIntegerBJ(5,udg_ArenaBracketSlot[4],udg_GameStateHash)) // $A = 10
endfunction

function Trig_Arena_Round_End_IsEarlyRound takes nothing returns boolean
    return(udg_ArenaRound<=2)
endfunction

function Trig_Arena_Round_End_RollWinnerPair2 takes nothing returns boolean
    return(((LoadIntegerBJ(5,udg_ArenaBracketSlot[5],udg_GameStateHash)+GetRandomInt(1,20))-$A)<=LoadIntegerBJ(5,udg_ArenaBracketSlot[6],udg_GameStateHash)) // $A = 10
endfunction

function Trig_Arena_Round_End_RollWinnerPair3 takes nothing returns boolean
    return(((LoadIntegerBJ(5,udg_ArenaBracketSlot[7],udg_GameStateHash)+GetRandomInt(1,20))-$A)<=LoadIntegerBJ(5,udg_ArenaBracketSlot[8],udg_GameStateHash)) // $A = 10
endfunction

function Trig_Arena_Round_End_IsRoundOne takes nothing returns boolean
    return(udg_ArenaRound==1)
endfunction

function Trig_Arena_Round_End_IsRoundTwo takes nothing returns boolean
    return(udg_ArenaRound==2)
endfunction

function Trig_Arena_Round_End_IsFirstRoundShift takes nothing returns boolean
    return(udg_ArenaRound==1)
endfunction

function Trig_Arena_Round_End_IsSurvivalRotation takes nothing returns boolean
    return(udg_ArenaSurvivalMode)
endfunction

function Trig_Arena_Round_End_IsCupFinished takes nothing returns boolean
    return(udg_ArenaSurvivalMode==false)or(udg_ArenaRound>7)
endfunction

function Trig_Arena_Round_End_IsDimensionFinale takes nothing returns boolean
    return(udg_ArenaCupId==$A)and(LoadIntegerBJ(2,7,udg_GameStateHash)>=2) // $A = 10
endfunction

function Trig_Arena_Round_End_ArenaBusy01 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_End_ArenaBusy02 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_End_ArenaBusy03 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_End_ArenaBusy04 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_End_ArenaBusy05 takes nothing returns boolean
    return(CountPlayersInForceBJ(udg_CupArenaPlayers)>0)
endfunction

function Trig_Arena_Round_End_HasMoreRounds takes nothing returns boolean
    return(udg_ArenaRound>3)and(Trig_Arena_Round_End_IsCupFinished())
endfunction

function Trig_Arena_Round_End_Actions takes nothing returns nothing
    if(Trig_Arena_Round_End_HasLootTable())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=LoadIntegerBJ($A,(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash) // $A = 10
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            if(Trig_Arena_Round_End_RollDropChance())then
                call CreateItemLoc(udg_ItemIdTable[LoadIntegerBJ((9+(2*GetForLoopIndexA())),(GetUnitUserData(GetTriggerUnit())-$A),udg_GameStateHash)],udg_TempPoint) // $A = 10
            endif
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call RemoveLocation(udg_TempPoint)
    endif
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_CupArenaUnits)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossGroup)
    if(Trig_Arena_Round_End_IsLeaderDead())then
        call ForGroupBJ(udg_CupArenaUnits,function Trig_Arena_Round_End_RemoveCoverFromFighter)
        if(Trig_Arena_Round_End_HasArenaSummons())then
            call ForGroupBJ(udg_ArenaSummonGroup,function Trig_Arena_Round_End_RemoveCoverFromSummon)
        endif
    endif
    if(Trig_Arena_Round_End_KilledEliteHero())then
        set udg_ArenaEliteKilled=true
    endif
    if(Trig_Arena_Round_End_IsTeamWiped())then
    else
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTimedTextToForce(GetPlayersAll(),10.,("|cff00ff00Arena:|r Team |cffff0000"+(LoadStringBJ(1,udg_ArenaBracketSlot[2],udg_GameStateHash)+"|r has been defeated!")))
    if(Trig_Arena_Round_End_IsFirstTeam20Win())then
        set udg_ChocoboCupStage=1
    endif
    if(Trig_Arena_Round_End_HasEliteKill())then
        set udg_TempInteger=Job_GetIndex(Player_GetHero(udg_ArenaSoloPlayer))
        if(Trig_Arena_Round_End_CanEarnMastery())then
            call ForceAddPlayerSimple(udg_ArenaSoloPlayer,udg_QuestForce[udg_TempInteger])
            call AddSpecialEffectTargetUnitBJ("origin",Player_GetHero(udg_ArenaSoloPlayer),"Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
        endif
    endif
    if(Trig_Arena_Round_End_IsTeam154())then
        call ForForce(udg_PlayingPlayers,function Trig_Arena_Round_End_GiveAward24)
    else
        if(Trig_Arena_Round_End_IsTeam171())then
            call ForForce(udg_PlayingPlayers,function Trig_Arena_Round_End_GiveAward28)
        else
            if(Trig_Arena_Round_End_IsTeam146())then
                call ForceAddPlayerSimple(Player($A),udg_TitleForce[34]) // $A = 10
                call ForForce(udg_PlayingPlayers,function Trig_Arena_Round_End_GiveAward34)
            else
                if(Trig_Arena_Round_End_IsTeam120Beaten())then
                    call ForceAddPlayerSimple(Player($A),udg_TitleForce[49]) // $A = 10
                    call ForForce(udg_PlayingPlayers,function Trig_Arena_Round_End_GiveAward49)
                endif
            endif
        endif
    endif
    call DestroyLightningBJ(udg_ArenaLightning[1])
    call DestroyLightningBJ(udg_ArenaLightning[2])
    call DestroyLightningBJ(udg_ArenaLightning[3])
    call DestroyLightningBJ(udg_ArenaLightning[4])
    call DisableTrigger(gg_trg_Arena_OutOfBounds)
    call GroupClear(udg_CupArenaUnits)
    call ForGroupBJ(udg_ArenaSummonGroup,function Trig_Arena_Round_End_KillLeftoverSummon)
    call GroupClear(udg_ArenaSummonGroup)
    set udg_BattlePoints[0]=(LoadIntegerBJ(5,udg_ArenaBracketSlot[2],udg_GameStateHash)+2)
    if(Trig_Arena_Round_End_HasBpBonusFlag())then
        set udg_BattlePoints[0]=(udg_BattlePoints[0]+60)
    endif
    // Multiply base battle points by 10 x (elapsed seconds + 30) / (2 x elapsed seconds + 30), then drop decimals.
    // At 0 seconds the multiplier is 10; at 30 seconds it is about 6.67. Longer fights move it toward 5.
    set udg_BattlePoints[0]=R2I(((I2R(udg_BattlePoints[0])*10.)*((TimerGetElapsed(udg_ArenaRoundTimer)+30.)/((TimerGetElapsed(udg_ArenaRoundTimer)*2.)+30.))))
    if(Trig_Arena_Round_End_IsCup5Plus())then
        if(Trig_Arena_Round_End_IsCup8Plus())then
            if(Trig_Arena_Round_End_IsCup10Plus())then
                set udg_BattlePoints[0]=R2I(((I2R(udg_BattlePoints[0])*4.)+50.))
            else
                set udg_BattlePoints[0]=R2I(((I2R(udg_BattlePoints[0])*2.)+25.))
            endif
        else
            set udg_BattlePoints[0]=R2I(((I2R(udg_BattlePoints[0])*1.5)+10.))
        endif
    endif
    if(Trig_Arena_Round_End_IsSurvivalBonus())then
        // Result 1: udg_BattlePoints at position 0 treated as a decimal-capable number.
        // Result 2: udg_ArenaRound treated as a decimal-capable number.
        // Result 3: (result 2) times (0.2).
        // Result 4: (0.8) plus (result 3).
        // Result 5: (result 1) times (result 4).
        // Result 6: (result 5) plus (15).
        // Result 7: (result 6) with its decimal part removed.
        set udg_BattlePoints[0]=R2I(((I2R(udg_BattlePoints[0])*(.8+(I2R(udg_ArenaRound)*.2)))+15.))
    endif
    call ForForce(udg_CupArenaPlayers,function Trig_Arena_Round_End_GiveBattlePoints)
    set udg_ArenaBracketSlot[9]=udg_ArenaBracketSlot[2]
    if(Trig_Arena_Round_End_IsSurvivalRotation())then
        set udg_ArenaBracketSlot[2]=udg_ArenaBracketSlot[3]
        set udg_ArenaBracketSlot[3]=udg_ArenaBracketSlot[4]
        set udg_ArenaBracketSlot[4]=udg_ArenaBracketSlot[5]
        set udg_ArenaBracketSlot[5]=udg_ArenaBracketSlot[6]
        set udg_ArenaBracketSlot[6]=udg_ArenaBracketSlot[7]
        set udg_ArenaBracketSlot[7]=udg_ArenaBracketSlot[8]
        set udg_ArenaBracketSlot[8]=udg_ArenaBracketSlot[9]
    else
        if(Trig_Arena_Round_End_IsEarlyRound())then
            if(Trig_Arena_Round_End_RollWinnerPair1())then
                set udg_ArenaBracketSlot[2]=udg_ArenaBracketSlot[4]
                set udg_ArenaBracketSlot[$A]=udg_ArenaBracketSlot[3] // $A = 10
            else
                set udg_ArenaBracketSlot[2]=udg_ArenaBracketSlot[3]
                set udg_ArenaBracketSlot[$A]=udg_ArenaBracketSlot[4] // $A = 10
            endif
        endif
        if(Trig_Arena_Round_End_IsRoundOne())then
            if(Trig_Arena_Round_End_RollWinnerPair2())then
                set udg_ArenaBracketSlot[3]=udg_ArenaBracketSlot[6]
                set udg_ArenaBracketSlot[$B]=udg_ArenaBracketSlot[5] // $B = 11
            else
                set udg_ArenaBracketSlot[3]=udg_ArenaBracketSlot[5]
                set udg_ArenaBracketSlot[$B]=udg_ArenaBracketSlot[6] // $B = 11
            endif
            if(Trig_Arena_Round_End_RollWinnerPair3())then
                set udg_ArenaBracketSlot[4]=udg_ArenaBracketSlot[8]
                set udg_ArenaBracketSlot[$C]=udg_ArenaBracketSlot[7] // $C = 12
            else
                set udg_ArenaBracketSlot[4]=udg_ArenaBracketSlot[7]
                set udg_ArenaBracketSlot[$C]=udg_ArenaBracketSlot[8] // $C = 12
            endif
        endif
        if(Trig_Arena_Round_End_IsFirstRoundShift())then
            set udg_ArenaBracketSlot[5]=udg_ArenaBracketSlot[9]
            set udg_ArenaBracketSlot[6]=udg_ArenaBracketSlot[$A] // $A = 10
            set udg_ArenaBracketSlot[7]=udg_ArenaBracketSlot[$B] // $B = 11
            set udg_ArenaBracketSlot[8]=udg_ArenaBracketSlot[$C] // $C = 12
        else
            if(Trig_Arena_Round_End_IsRoundTwo())then
                set udg_ArenaBracketSlot[3]=udg_ArenaBracketSlot[9]
                set udg_ArenaBracketSlot[4]=udg_ArenaBracketSlot[$A] // $A = 10
            endif
        endif
    endif
    set udg_ArenaRound=(udg_ArenaRound+1)
    call GroupClear(udg_ArenaSpawnGroup)
    if(Trig_Arena_Round_End_HasMoreRounds())then
        if(Trig_Arena_Round_End_IsDimensionFinale())then
            set udg_TempUnit=GetTriggerUnit()
        endif
        call ConditionalTriggerExecute(gg_trg_Arena_Cup_Won)
    else
        set udg_ArenaIntermission=true
        call Wait_Polled(1.)
        if(Trig_Arena_Round_End_ArenaBusy05())then
            call Wait_Polled(1.)
            if(Trig_Arena_Round_End_ArenaBusy04())then
                call Wait_Polled(1.)
                if(Trig_Arena_Round_End_ArenaBusy03())then
                    call Wait_Polled(1.)
                    if(Trig_Arena_Round_End_ArenaBusy02())then
                        call Wait_Polled(1.)
                        if(Trig_Arena_Round_End_ArenaBusy01())then
                            call Wait_Polled(1.)
                        endif
                    endif
                endif
            endif
        endif
        call ConditionalTriggerExecute(gg_trg_Arena_Round_Start)
    endif
endfunction

function InitTrig_Arena_Rounds takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2 (module Arena),
// which keeps the original registration order.

function Register_Arena_Round_Start takes nothing returns nothing
    set gg_trg_Arena_Round_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Round_Start)
    call TriggerAddAction(gg_trg_Arena_Round_Start,function Trig_Arena_Round_Start_Actions)
endfunction

function Register_Arena_Round_End takes nothing returns nothing
    set gg_trg_Arena_Round_End=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Round_End)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Round_End,EVENT_PLAYER_UNIT_DEATH)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_Round_End,EVENT_PLAYER_UNIT_CHANGE_OWNER)
    call TriggerAddCondition(gg_trg_Arena_Round_End,Condition(function Trig_Arena_Round_End_Conditions))
    call TriggerAddAction(gg_trg_Arena_Round_End,function Trig_Arena_Round_End_Actions)
endfunction

endlibrary

library TBossGafgarion requires TCam, TCine, TGroup, TLoc, TPlayerHero, TText, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Boss_Gafgarion_Intro=null
    trigger gg_trg_Boss_Gafgarion_Death=null
    trigger gg_trg_Boss_Gafgarion_Guard_Death=null
endglobals

function Trig_Boss_Gafgarion_Intro_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Boss_Gafgarion_Intro_ShowGafgarionScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Boss_Gafgarion_Intro_IsIntroStage takes nothing returns boolean
    return(udg_ZaleraStage==1)
endfunction

function Trig_Boss_Gafgarion_Intro_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Gafgarion_Intro_IsIntroStage())then
        set udg_ZaleraStage=2
        call SetUnitFacingToFaceUnitTimed(udg_StoryBoss,GetTriggerUnit(),.0)
        if(Trig_Boss_Gafgarion_Intro_ShowGafgarionScene())then
            call Cine_Enter()
            call Cam_PanToUnit(udg_StoryBoss,0)
            call Text_Say(udg_StoryBoss,"So, you are one of those outsiders Belias told me about.",false)
            call Text_Say(udg_StoryBoss,"Hmmm, you have defeated Cúchulainn. It seems I cannot take you lightly.",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"That's enough. We have no need to talk. We will stop you and your plans.",false)
            call Text_Say(udg_StoryBoss,"But will you succeed?",false)
            call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Certainly. You will die here and now.",false)
            call Text_Say(udg_StoryBoss,"I've died many times. I don't fear death.",false)
            call Text_Transmission(udg_StoryBoss,"Gafgarion","I've died many times. I don't fear death.\r\nEn garde!","I've died many times. I don't fear death.",null,0,false)
            call Cine_ExitAction()
        endif
        call UnitRemoveAbilityBJ('A0VJ',udg_StoryBoss) // 'A0VJ': ability "Unaffected by Cinematics"
        call PauseUnitBJ(false,udg_StoryBoss)
        call SetUnitInvulnerable(udg_StoryBoss,false)
        call SetUnitAcquireRangeBJ(udg_StoryBoss,2560.)
        call StartTimerBJ(udg_JobLevelTimer,false,.01)
    endif
endfunction

function Trig_Boss_Gafgarion_Death_IsHeroKill takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Gafgarion_Death_IsFightStage takes nothing returns boolean
    return(udg_ZaleraStage==2)
endfunction

function Trig_Boss_Gafgarion_Death_OrderGhostsMove takes nothing returns nothing
    call IssuePointOrderLocBJ(GetEnumUnit(),"move",udg_TempPoint)
endfunction

function Trig_Boss_Gafgarion_Death_ShouldReviveGafgarion takes nothing returns boolean
    return(udg_ZaleraStage==3)
endfunction

function Trig_Boss_Gafgarion_Death_Actions takes nothing returns nothing
    local group l_tempGroup
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Boss_Gafgarion_Intro)
    if(Trig_Boss_Gafgarion_Death_IsFightStage())then
        call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
        if(Trig_Boss_Gafgarion_Death_IsHeroKill())then
            call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
        else
            call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
        endif
        set udg_ZaleraStage=3
    endif
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestUnits)
    call GroupAddUnitSimple(gg_unit_U000_0248,udg_QuestUnits)
    call Wait_Polled(2.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,128.,(I2R(GetForLoopIndexA())*90.))
        call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint2,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRandomLocInRect(gg_rct_151)
        call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=2
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRandomLocInRect(gg_rct_152)
        call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetRandomLocInRect(gg_rct_153)
        call CreateNUnitsAtLoc(1,'u00D',Player(8),udg_TempPoint,bj_UNIT_FACING) // 'u00D': unit "Death Ghost"
        call RemoveLocation(udg_TempPoint)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call Wait_Polled(1.)
    set l_tempGroup=Group_UnitsOfPlayerAndType(Player(8),'u00D') // 'u00D': unit "Death Ghost"
    set udg_TempPoint=GetRectCenter(gg_rct_582)
    call ForGroupBJ(l_tempGroup,function Trig_Boss_Gafgarion_Death_OrderGhostsMove)
    call RemoveLocation(udg_TempPoint)
    call DestroyGroup(l_tempGroup)
    call Wait_Polled(1.)
    if(Trig_Boss_Gafgarion_Death_ShouldReviveGafgarion())then
        set udg_TempPoint=GetRectCenter(gg_rct_550)
        call ReviveHeroLoc(udg_StoryBoss,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitHide(udg_StoryBoss)
        call SetUnitInvulnerable(udg_StoryBoss,true)
    endif
    call ShowUnitShow(gg_unit_U000_0248)
    call EnableTrigger(gg_trg_Boss_Zalera_Intro)
    call DestroyTrigger(GetTriggeringTrigger())
    set l_tempGroup=null
endfunction

function Trig_Boss_Gafgarion_Guard_Death_IsHeroVictim takes nothing returns boolean
    return(IsUnitType(GetDyingUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Boss_Gafgarion_Guard_Death_IsGuardStage takes nothing returns boolean
    return(udg_ZaleraStage==4)
endfunction

function Trig_Boss_Gafgarion_Guard_Death_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Boss_Gafgarion_Guard_Death_IsGuardStage())then
        call PlayThematicMusicBJ("FF7-Victory Fanfare.mp3")
        if(Trig_Boss_Gafgarion_Guard_Death_IsHeroVictim())then
            call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetHeroProperName(GetDyingUnit()))+"|r was defeated !!!"))
        else
            call DisplayTextToForce(udg_PlayingPlayers,(("|cffaa0000"+GetUnitName(GetDyingUnit()))+"|r was defeated !!!"))
        endif
        set udg_ZaleraStage=5
    endif
    call UnitRemoveAbilityBJ('A0X2',gg_unit_U000_0248) // 'A0X2': ability "Perma Cover"
    call UnitRemoveBuffBJ('B064',gg_unit_U000_0248) // 'B064': buff "Perma Cover"
    call UnitRemoveAbilityBJ('A0SJ',gg_unit_U000_0248) // 'A0SJ': ability "Dispel"
    call UnitAddAbilityBJ('A0VL',gg_unit_U000_0248) // 'A0VL': ability "Scourge"
    call GroupRemoveUnitSimple(udg_StoryBoss,udg_QuestUnits)
    call GroupAddUnitSimple(gg_unit_U000_0248,udg_QuestUnits)
    call EnableTrigger(gg_trg_Boss_Zalera_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Boss_Gafgarion takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Boss_Part1 (module Boss),
// which keeps the original registration order.

function Register_Boss_Gafgarion_Intro takes nothing returns nothing
    set gg_trg_Boss_Gafgarion_Intro=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gafgarion_Intro)
    call TriggerAddCondition(gg_trg_Boss_Gafgarion_Intro,Condition(function Trig_Boss_Gafgarion_Intro_Conditions))
    call TriggerAddAction(gg_trg_Boss_Gafgarion_Intro,function Trig_Boss_Gafgarion_Intro_Actions)
endfunction

function Register_Boss_Gafgarion_Death takes nothing returns nothing
    set gg_trg_Boss_Gafgarion_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gafgarion_Death)
    call TriggerAddAction(gg_trg_Boss_Gafgarion_Death,function Trig_Boss_Gafgarion_Death_Actions)
endfunction

function Register_Boss_Gafgarion_Guard_Death takes nothing returns nothing
    set gg_trg_Boss_Gafgarion_Guard_Death=CreateTrigger()
    call DisableTrigger(gg_trg_Boss_Gafgarion_Guard_Death)
    call TriggerAddAction(gg_trg_Boss_Gafgarion_Guard_Death,function Trig_Boss_Gafgarion_Guard_Death_Actions)
endfunction

endlibrary

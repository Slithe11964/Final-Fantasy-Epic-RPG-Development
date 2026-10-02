library TGuideBook requires TCam, TCine, TPlayerHero, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_GuideBook_Search1=null
    trigger gg_trg_GuideBook_Search2=null
    trigger gg_trg_GuideBook_Search3=null
    trigger gg_trg_GuideBook_Search4=null
    trigger gg_trg_GuideBook_Search5=null
    trigger gg_trg_GuideBook_Search6=null
    trigger gg_trg_GuideBook_TurnIn=null
    // Variables only this module uses.
    integer udg_GuideBookSearches=0
endglobals

function Trig_GuideBook_Search1_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)))!=null
endfunction

function Trig_GuideBook_Search1_Cond_BookFound takes nothing returns boolean
    return(udg_GuideBookSearches>=udg_Difficulty)
endfunction

function Trig_GuideBook_Search1_Cond_BookNotFoundYet takes nothing returns boolean
    return(udg_GuideBookSearches<udg_Difficulty)
endfunction

function Trig_GuideBook_Search1_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_GuideBook_Search1_Cond_BookNotFoundYet())then
        set udg_GuideBookSearches=(udg_GuideBookSearches+1)
        set udg_TempPoint=GetRectCenter(gg_rct_415)
        if(Trig_GuideBook_Search1_Cond_BookFound())then
            call CreateTextTagLocBJ("Found the |cffffcc00Guide Book|r!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            call UnitAddItemByIdSwapped('I06B',GetTriggerUnit()) // 'I06B': item "Guide Book"
            call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Guide Book to Shinra.")
        else
            call CreateTextTagLocBJ("The Guide Book is not here...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GuideBook_Search2_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)))!=null
endfunction

function Trig_GuideBook_Search2_Cond_BookFound takes nothing returns boolean
    return(udg_GuideBookSearches>=udg_Difficulty)
endfunction

function Trig_GuideBook_Search2_Cond_BookNotFoundYet takes nothing returns boolean
    return(udg_GuideBookSearches<udg_Difficulty)
endfunction

function Trig_GuideBook_Search2_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_GuideBook_Search2_Cond_BookNotFoundYet())then
        set udg_GuideBookSearches=(udg_GuideBookSearches+1)
        set udg_TempPoint=GetRectCenter(gg_rct_416)
        if(Trig_GuideBook_Search2_Cond_BookFound())then
            call CreateTextTagLocBJ("Found the |cffffcc00Guide Book|r!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            call UnitAddItemByIdSwapped('I06B',GetTriggerUnit()) // 'I06B': item "Guide Book"
            call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Guide Book to Shinra.")
        else
            call CreateTextTagLocBJ("The Guide Book is not here...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GuideBook_Search3_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)))!=null
endfunction

function Trig_GuideBook_Search3_Cond_BookFound takes nothing returns boolean
    return(udg_GuideBookSearches>=udg_Difficulty)
endfunction

function Trig_GuideBook_Search3_Cond_BookNotFoundYet takes nothing returns boolean
    return(udg_GuideBookSearches<udg_Difficulty)
endfunction

function Trig_GuideBook_Search3_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_GuideBook_Search3_Cond_BookNotFoundYet())then
        set udg_GuideBookSearches=(udg_GuideBookSearches+1)
        set udg_TempPoint=GetRectCenter(gg_rct_417)
        if(Trig_GuideBook_Search3_Cond_BookFound())then
            call CreateTextTagLocBJ("Found the |cffffcc00Guide Book|r!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            call UnitAddItemByIdSwapped('I06B',GetTriggerUnit()) // 'I06B': item "Guide Book"
            call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Guide Book to Shinra.")
        else
            call CreateTextTagLocBJ("The Guide Book is not here...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GuideBook_Search4_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)))!=null
endfunction

function Trig_GuideBook_Search4_Cond_BookFound takes nothing returns boolean
    return(udg_GuideBookSearches>=udg_Difficulty)
endfunction

function Trig_GuideBook_Search4_Cond_BookNotFoundYet takes nothing returns boolean
    return(udg_GuideBookSearches<udg_Difficulty)
endfunction

function Trig_GuideBook_Search4_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_GuideBook_Search4_Cond_BookNotFoundYet())then
        set udg_GuideBookSearches=(udg_GuideBookSearches+1)
        set udg_TempPoint=GetRectCenter(gg_rct_418)
        if(Trig_GuideBook_Search4_Cond_BookFound())then
            call CreateTextTagLocBJ("Found the |cffffcc00Guide Book|r!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            call UnitAddItemByIdSwapped('I06B',GetTriggerUnit()) // 'I06B': item "Guide Book"
            call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Guide Book to Shinra.")
        else
            call CreateTextTagLocBJ("The Guide Book is not here...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GuideBook_Search5_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)))!=null
endfunction

function Trig_GuideBook_Search5_Cond_BookFound takes nothing returns boolean
    return(udg_GuideBookSearches>=udg_Difficulty)
endfunction

function Trig_GuideBook_Search5_Cond_BookNotFoundYet takes nothing returns boolean
    return(udg_GuideBookSearches<udg_Difficulty)
endfunction

function Trig_GuideBook_Search5_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_GuideBook_Search5_Cond_BookNotFoundYet())then
        set udg_GuideBookSearches=(udg_GuideBookSearches+1)
        set udg_TempPoint=GetRectCenter(gg_rct_419)
        if(Trig_GuideBook_Search5_Cond_BookFound())then
            call CreateTextTagLocBJ("Found the |cffffcc00Guide Book|r!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            call UnitAddItemByIdSwapped('I06B',GetTriggerUnit()) // 'I06B': item "Guide Book"
            call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Guide Book to Shinra.")
        else
            call CreateTextTagLocBJ("The Guide Book is not here...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GuideBook_Search6_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)))!=null
endfunction

function Trig_GuideBook_Search6_Cond_BookFound takes nothing returns boolean
    return(udg_GuideBookSearches>=udg_Difficulty)
endfunction

function Trig_GuideBook_Search6_Cond_BookNotFoundYet takes nothing returns boolean
    return(udg_GuideBookSearches<udg_Difficulty)
endfunction

function Trig_GuideBook_Search6_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_GuideBook_Search6_Cond_BookNotFoundYet())then
        set udg_GuideBookSearches=(udg_GuideBookSearches+1)
        set udg_TempPoint=GetRectCenter(gg_rct_489)
        if(Trig_GuideBook_Search6_Cond_BookFound())then
            call CreateTextTagLocBJ("Found the |cffffcc00Guide Book|r!",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
            call UnitAddItemByIdSwapped('I06B',GetTriggerUnit()) // 'I06B': item "Guide Book"
            call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
            call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Guide Book to Shinra.")
        else
            call CreateTextTagLocBJ("The Guide Book is not here...",udg_TempPoint,0,$A,'d','d','d',0) // $A = 10
        endif
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),GetPlayersAll())
        call RemoveLocation(udg_TempPoint)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_GuideBook_TurnIn_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I06B'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I06B': item "Guide Book"
endfunction

function Trig_GuideBook_TurnIn_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_GuideBook_TurnIn_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I06B')) // 'I06B': item "Guide Book"
    if(Trig_GuideBook_TurnIn_Cond_ShowDialogue())then
        call DestroyEffectBJ(udg_SpecialEffect[62])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n034_0109,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So, after we checked a few different ships, it turns out one finally contained the Guide Book.",false)
        call Text_Say(gg_unit_n034_0109,"That is good. Let's see...",false)
        call Text_Say(gg_unit_n034_0109,"Aha! It seems the madman actually found a way to reach the border of the world by opening a portal! Seems he didn't manage to reach it, but he noted down the artifacts you need to make it.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Seems we're going to have to gather a few things huh.",false)
        call Text_Say(gg_unit_n034_0109,"First up I'll need some Tropical Essence. You should be able to find some on the Central Islands.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[62]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n034_0109,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Bring some Tropical Essence to Shinra.")
    call QuestSetDescriptionBJ(udg_SideQuest[40],"Shinra, an Al Bhed child from Spira, has asked you to find many artifacts so he can create a portal that can be used to warp through dimensions.\r\nNow Shinra wants you to find some |cffffcc00Tropical Essence|r.")
    call EnableTrigger(gg_trg_TropicalEssence_TurnIn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_GuideBook automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_GuideBook (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_GuideBook takes nothing returns nothing
endfunction

function Register_GuideBook_Search1 takes nothing returns nothing
    set gg_trg_GuideBook_Search1=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_Search1)
    call TriggerRegisterEnterRectSimple(gg_trg_GuideBook_Search1,gg_rct_415)
    call TriggerAddCondition(gg_trg_GuideBook_Search1,Condition(function Trig_GuideBook_Search1_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_Search1,function Trig_GuideBook_Search1_Actions)
endfunction

function Register_GuideBook_Search2 takes nothing returns nothing
    set gg_trg_GuideBook_Search2=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_Search2)
    call TriggerRegisterEnterRectSimple(gg_trg_GuideBook_Search2,gg_rct_416)
    call TriggerAddCondition(gg_trg_GuideBook_Search2,Condition(function Trig_GuideBook_Search2_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_Search2,function Trig_GuideBook_Search2_Actions)
endfunction

function Register_GuideBook_Search3 takes nothing returns nothing
    set gg_trg_GuideBook_Search3=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_Search3)
    call TriggerRegisterEnterRectSimple(gg_trg_GuideBook_Search3,gg_rct_417)
    call TriggerAddCondition(gg_trg_GuideBook_Search3,Condition(function Trig_GuideBook_Search3_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_Search3,function Trig_GuideBook_Search3_Actions)
endfunction

function Register_GuideBook_Search4 takes nothing returns nothing
    set gg_trg_GuideBook_Search4=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_Search4)
    call TriggerRegisterEnterRectSimple(gg_trg_GuideBook_Search4,gg_rct_418)
    call TriggerAddCondition(gg_trg_GuideBook_Search4,Condition(function Trig_GuideBook_Search4_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_Search4,function Trig_GuideBook_Search4_Actions)
endfunction

function Register_GuideBook_Search5 takes nothing returns nothing
    set gg_trg_GuideBook_Search5=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_Search5)
    call TriggerRegisterEnterRectSimple(gg_trg_GuideBook_Search5,gg_rct_419)
    call TriggerAddCondition(gg_trg_GuideBook_Search5,Condition(function Trig_GuideBook_Search5_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_Search5,function Trig_GuideBook_Search5_Actions)
endfunction

function Register_GuideBook_Search6 takes nothing returns nothing
    set gg_trg_GuideBook_Search6=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_Search6)
    call TriggerRegisterEnterRectSimple(gg_trg_GuideBook_Search6,gg_rct_489)
    call TriggerAddCondition(gg_trg_GuideBook_Search6,Condition(function Trig_GuideBook_Search6_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_Search6,function Trig_GuideBook_Search6_Actions)
endfunction

function Register_GuideBook_TurnIn takes nothing returns nothing
    set gg_trg_GuideBook_TurnIn=CreateTrigger()
    call DisableTrigger(gg_trg_GuideBook_TurnIn)
    call TriggerRegisterUnitInRangeSimple(gg_trg_GuideBook_TurnIn,250.,gg_unit_n034_0109)
    call TriggerAddCondition(gg_trg_GuideBook_TurnIn,Condition(function Trig_GuideBook_TurnIn_Conditions))
    call TriggerAddAction(gg_trg_GuideBook_TurnIn,function Trig_GuideBook_TurnIn_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_GuideBook takes nothing returns nothing
    call Register_GuideBook_Search1() // starts off; enabled by DimensionalBoundary
    call Register_GuideBook_Search2() // starts off; enabled by DimensionalBoundary
    call Register_GuideBook_Search3() // starts off; enabled by DimensionalBoundary
    call Register_GuideBook_Search4() // starts off; enabled by DimensionalBoundary
    call Register_GuideBook_Search5() // starts off; enabled by DimensionalBoundary
    call Register_GuideBook_Search6() // starts off; enabled by DimensionalBoundary
    call Register_GuideBook_TurnIn() // starts off; enabled by DimensionalBoundary
endfunction

endlibrary

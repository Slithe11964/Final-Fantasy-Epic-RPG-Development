library TAlma requires TCam, TCine, TPlayerPart01, TText
function Trig_Alma_Disappear_CinematicBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Alma_Disappear_Actions takes nothing returns nothing
    if(Trig_Alma_Disappear_CinematicBusy())then
        call StartTimerBJ(udg_AlmaDisappearTimer,false,5.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Hjai_0093,udg_RecruitedAllies)
    call ShowUnitHide(gg_unit_Hjai_0093)
    call EnableTrigger(gg_trg_Alma_Missing_Notice)
    set udg_NewsText[3]=udg_NewsText[2]
    set udg_NewsText[2]=udg_NewsText[1]
    set udg_NewsText[6]=udg_NewsText[5]
    set udg_NewsText[5]=udg_NewsText[4]
    set udg_NewsText[1]="|cffffcc00Alma Has Disappeared|r"
    set udg_NewsText[4]="The beloved town cleric Alma, has recently disappeared. Cid and Zalmo both have no idea where she could have gone. Please contact Cid if you have any information."
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Alma_Missing_Notice_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_Hjai_0093))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Alma_Missing_Notice_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Alma_Missing_Notice_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Alma_Missing_Notice_CinematicsEnabled())then
        call Cine_Enter()
        call SetUnitFacingToFaceUnitTimed(GetTriggerUnit(),gg_unit_Hjai_0093,0)
        call Cam_PanToUnit(gg_unit_Hjai_0093,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"...",false)
        call Text_Transmission(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"... wait.","...",null,0,false)
        call Text_Transmission(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"... wait. Where did Alma go?","... wait.",null,0,false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm that's unusual. I wonder if Ramza has any idea where she is.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Talk to Ramza.")
    call EnableTrigger(gg_trg_Quest_LightOfJudgment_Start)
    set udg_SpecialEffect[50]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Eill_0119,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call GroupAddUnitSimple(gg_unit_Eill_0119,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Alma takes nothing returns nothing
endfunction

function RegisterR11_Alma_Disappear takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Alma_Disappear=CreateTrigger()

call DisableTrigger(gg_trg_Alma_Disappear)

call TriggerRegisterTimerExpireEventBJ(gg_trg_Alma_Disappear,udg_AlmaDisappearTimer)

call TriggerAddAction(gg_trg_Alma_Disappear,function Trig_Alma_Disappear_Actions)

endfunction




function RegisterR11_Alma_Missing_Notice takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Alma_Missing_Notice=CreateTrigger()

call DisableTrigger(gg_trg_Alma_Missing_Notice)

call TriggerRegisterUnitInRangeSimple(gg_trg_Alma_Missing_Notice,550.,gg_unit_Hjai_0093)

call TriggerAddCondition(gg_trg_Alma_Missing_Notice,Condition(function Trig_Alma_Missing_Notice_Conditions))

call TriggerAddAction(gg_trg_Alma_Missing_Notice,function Trig_Alma_Missing_Notice_Actions)

endfunction




endlibrary

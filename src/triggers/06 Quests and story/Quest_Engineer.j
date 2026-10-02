library TQuestEngineer requires TCam, TCine, TPlayerPart01, TText, TUnit
function Trig_Quest_Engineer_GetAdvice_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h00R_0256,true,true,true))
endfunction

function Trig_Quest_Engineer_GetAdvice_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Engineer_GetAdvice_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[87])
    if(Trig_Quest_Engineer_GetAdvice_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h00R_0256,"Lali-ho again! Do ye need something more from us?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed we do, Giott. We're on a task from Mid again, but this time he needs your advice.",false)
        call Text_Say(gg_unit_h00R_0256,"Advice? What be little Mid tryin' ta do?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"He's making some sort of mechanical crossbow and said he needs advice on how to properly implement the trigger. Can you help him there?",false)
        call Text_Say(gg_unit_h00R_0256,"Ar, that be one of his old projects. He talked to us about it before. Alberich sho' be able to help you with tha' one. He be the oldest and wisest of us by a long shot.",false)
        call Text_Say(gg_unit_h037_0257,"Lali-ho to you. Yes I recall talking with Mid about his idea for a mechanical crossbow. If he decided to take that project up again I suppose the situation in Kalm is quite dire.",false)
        call Text_Say(gg_unit_h037_0257,"Fortunately I should be able to help him with the issue he's having. Here, take this piece of paper and bring it to him. It should contain all the details he needs.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Wow that was fast. Thanks!",false)
        call Text_Say(gg_unit_h037_0257,"Think nothing of it. Just helping out the little guy.",false)
        call Cine_ExitAction()
    endif
    set udg_QuestItem[29]=UnitAddItemByIdSwapped('I042',Player_GetHero(GetTriggerPlayer())) // 'I042': item "Engineering Advice"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Bring the Engineering Advice to Mid.")
    call QuestItemSetDescriptionBJ(udg_QuestReq[$A],"Bring the Engineering Advice to Mid.") // $A = 10
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Engineer takes nothing returns nothing
endfunction

endlibrary

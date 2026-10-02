library TQuestLightOfJudgment requires TCam, TCine, TPlayerPart01, TText, TUnit
function Trig_Quest_LightOfJudgment_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Eill_0119,true,true,true))
endfunction

function Trig_Quest_LightOfJudgment_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_LightOfJudgment_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Eill_0119,udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[50])
    if(Trig_Quest_LightOfJudgment_Start_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Eill_0119,("En Taro Adun, "+(udg_PlayerName[GetConvertedPlayerId(GetTriggerPlayer())]+".")),false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"En Taro Tassadar, brother.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ramza, do you know where Alma has gone? She has disappeared from Kalm.",false)
        call Text_Say(gg_unit_Eill_0119,"My sister? No I haven't heard about this.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I have a bad feeling about this... we better try and find her as soon as possible.",false)
        call Text_Say(gg_unit_Eill_0119,"Yes you're right. Alma would never just disappear like that without a word. Let's split up and look for her.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Light of Judgment|r")
    set udg_MainQuest[16]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"Light of Judgment"),"Alma has gone missing! Find her!","ReplaceableTextures\\CommandButtons\\BTNJaina.blp")
    call ShowUnitHide(gg_unit_Eill_0119)
    set udg_TempPoint=GetUnitLoc(gg_unit_U00F_0221)
    call CreateNUnitsAtLoc(1,'Hjai',Player(8),udg_TempPoint,GetUnitFacing(gg_unit_U00F_0221)) // 'Hjai': unit "Cleric"
    call RemoveLocation(udg_TempPoint)
    set udg_AlmaUnit=GetLastCreatedUnit()
    call SetUnitColor(udg_AlmaUnit,PLAYER_COLOR_LIGHT_BLUE)
    call SetHeroLevelBJ(udg_AlmaUnit,$F,false) // $F = 15
    call UnitRemoveAbilityBJ('AInv',udg_AlmaUnit) // 'AInv': standard ability reference "Inventory"
    set udg_SpecialEffect[50]=AddSpecialEffectTargetUnitBJ("overhead",udg_AlmaUnit,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Ultima_Possession)
    call PauseUnitBJ(true,gg_unit_Eill_0119)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_LightOfJudgment takes nothing returns nothing
endfunction

endlibrary

library TQuestKillSetag requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit, TWait
function Trig_Quest_KillSetag_Hide_Actions takes nothing returns nothing
    call PauseUnitBJ(true,gg_unit_Hant_0059)
    call UnitAddAbilityBJ('A0VJ',gg_unit_Hant_0059) // 'A0VJ': ability "Unaffected by Cinematics"
    call ShowUnitHide(gg_unit_uabo_0061)
    call PauseUnitBJ(true,gg_unit_uabo_0061)
    call ShowUnitHide(gg_unit_uabo_0062)
    call PauseUnitBJ(true,gg_unit_uabo_0062)
    call ShowUnitHide(gg_unit_uabo_0002)
    call PauseUnitBJ(true,gg_unit_uabo_0002)
    call ShowUnitHide(gg_unit_Hgam_0060)
    call SetUnitInvulnerable(gg_unit_Hgam_0060,true)
    call PauseUnitBJ(true,gg_unit_Hgam_0060)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Offer_Actions takes nothing returns nothing
    call Unit_ScaleToLevel60(gg_unit_Hant_0059)
    set udg_SpecialEffect[6]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hant_0059,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_KillSetag_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Hant_0059,true,true,true))
endfunction

function Trig_Quest_KillSetag_Start_CinematicsOnHalaster takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KillSetag_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[6])
    if(Trig_Quest_KillSetag_Start_CinematicsOnHalaster())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Hant_0059,"I greet you. My name is Halaster. I am the Archwizard of Gransdale Castle. I traveled to this world in order to find evil warlock Setag who killed king Leoric in my homeworld.",false)
        call Text_Say(gg_unit_Hant_0059,"I swore to avenge my king, but Setag escaped into this world. I followed him and finaly overtook him. We engaged in a magic duel and I was close to victory when something totally unexpected happened - some abominable monsters came to help Setag and I had to retreat.",false)
        call Text_Say(gg_unit_Hant_0059,"I used my magic to locate him but he is now guarded by those monsters and my magic skills are simply not enough to fight all of them at once. However, if you help me, together we will be able to defeat him.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Will you join us now?",false)
        call Text_Say(gg_unit_Hant_0059,"No, but when you encounter Setag and attack him I will immediately teleport to your position and together we will be able to defeat him.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Kill Setag|r")
    set udg_SideQuest[3]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,"|cff00ffffKill Setag","Archwizard Halaster asked you to help him in defeating evil warlock named Setag.","ReplaceableTextures\\CommandButtons\\BTNAcolyte.blp")
    set udg_SpecialEffect[7]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Hant_0059,"Objects\\RandomObject\\RandomObject.mdl")
    call ShowUnitShow(gg_unit_Hgam_0060)
    call PauseUnitBJ(false,gg_unit_Hgam_0060)
    call SetUnitInvulnerable(gg_unit_Hgam_0060,false)
    call GroupAddUnitSimple(gg_unit_Hgam_0060,udg_BossUnits)
    call ShowUnitShow(gg_unit_uabo_0061)
    call PauseUnitBJ(false,gg_unit_uabo_0061)
    call ShowUnitShow(gg_unit_uabo_0062)
    call PauseUnitBJ(false,gg_unit_uabo_0062)
    call ShowUnitShow(gg_unit_uabo_0002)
    call PauseUnitBJ(false,gg_unit_uabo_0002)
    call EnableTrigger(gg_trg_Quest_KillSetag_Ambush)
    call EnableTrigger(gg_trg_Quest_KillSetag_Failed)
    call EnableTrigger(gg_trg_Quest_KillSetag_Complete)
    call AddItemToStockBJ('I04Y',gg_unit_n02Y_0052,1,1) // 'I04Y': item "Information: Setag"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Ambush_Conditions takes nothing returns boolean
    return(udg_InCinematicMode==false)
endfunction

function Trig_Quest_KillSetag_Ambush_WasAttacked takes nothing returns boolean
    return(GetAttacker()!=null)
endfunction

function Trig_Quest_KillSetag_Ambush_CinematicsOnAmbush takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KillSetag_Ambush_EternityMode takes nothing returns boolean
    return(udg_EternityMode)
endfunction

function Trig_Quest_KillSetag_Ambush_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[7])
    call SetUnitInvulnerable(gg_unit_Hant_0059,false)
    call UnitRemoveAbilityBJ('A0VJ',gg_unit_Hant_0059) // 'A0VJ': ability "Unaffected by Cinematics"
    call PauseUnitBJ(false,gg_unit_Hant_0059)
    if(Trig_Quest_KillSetag_Ambush_WasAttacked())then
        set udg_TempPoint=GetUnitLoc(GetAttacker())
    else
        call BlzSetEventDamage(.0)
        set udg_TempPoint=GetUnitLoc(GetEventDamageSource())
    endif
    call SetUnitPositionLocFacingBJ(gg_unit_Hant_0059,udg_TempPoint,bj_UNIT_FACING)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(udg_TempPoint)
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call SetUnitInvulnerable(gg_unit_Hgam_0060,true)
    if(Trig_Quest_KillSetag_Ambush_CinematicsOnAmbush())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hant_0059,0)
        call Text_Say(gg_unit_Hant_0059,"Setag !!! Now you will not escape ! You will pay for your crimes !",false)
        call Cam_PanToUnit(gg_unit_Hgam_0060,.5)
        call Text_Say(gg_unit_Hgam_0060,"You again, old man. If my memory serves me right it was you who escaped last time we met. Nevertheless, your death is near. And your puny allies will not help you. Prepare to die, Halaster.",false)
        call Cine_ExitAction()
    endif
    call SetUnitInvulnerable(gg_unit_Hgam_0060,false)
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=4
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint=GetUnitLoc(gg_unit_Hgam_0060)
        set udg_TempPoint2=OffsetLocation(udg_TempPoint,300.,300.)
        call RemoveLocation(udg_TempPoint)
        call CreateNUnitsAtLoc(1,'uabo',Player($B),udg_TempPoint2,bj_UNIT_FACING) // 'uabo': object name not found in map data; $B = 11
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Quest_KillSetag_Ambush_EternityMode())then
            call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        else
            // Calculation 1:
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 0)) divided by (2).
            // Calculation 2:
            // (1) minus (1).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),0)/ 2),(1-1))
            // (BlzGetUnitBaseDamage(GetLastCreatedUnit(), 1)) divided by (2).
            call BlzSetUnitBaseDamage(GetLastCreatedUnit(),(BlzGetUnitBaseDamage(GetLastCreatedUnit(),1)/ 2),1)
            // (maximum health of GetLastCreatedUnit()) divided by (2).
            call BlzSetUnitMaxHP(GetLastCreatedUnit(),(BlzGetUnitMaxHP(GetLastCreatedUnit())/ 2))
            call SetUnitLifePercentBJ(GetLastCreatedUnit(),'d')
        endif
        call IssueTargetOrderBJ(GetLastCreatedUnit(),"attack",GetAttacker())
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveItemFromStockBJ('I04Y',gg_unit_n02Y_0052) // 'I04Y': item "Information: Setag"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Failed_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisplayTextToForce(GetPlayersAll(),"Halaster is dead.")
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_FAILED,"Quest Failed: |cffffcc00Kill Setag|r")
    call QuestSetFailedBJ(udg_SideQuest[3],true)
    set udg_QuestsTotal=(udg_QuestsTotal-1)
    call GroupRemoveUnitSimple(gg_unit_Hgam_0060,udg_BossUnits)
    call DisableTrigger(gg_trg_Quest_KillSetag_Complete)
    call DestroyTrigger(gg_trg_Quest_KillSetag_Complete)
    call SaveIntegerBJ(1,2,99,udg_GameStateHash)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_KillSetag_Complete_Cond_CinematicRunning takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Quest_KillSetag_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_KillSetag_Complete_Actions takes nothing returns nothing
    if(Trig_Quest_KillSetag_Complete_Cond_CinematicRunning())then
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ReviveHeroLoc(gg_unit_Hgam_0060,udg_TempPoint,false)
        call RemoveLocation(udg_TempPoint)
        call SetUnitLifeBJ(GetTriggerUnit(),10.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Hgam_0060,udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I02R',udg_TempPoint) // 'I02R': item "Headgear of the Damned"
    call RemoveLocation(udg_TempPoint)
    call SetUnitInvulnerable(gg_unit_Hant_0059,true)
    if(Trig_Quest_KillSetag_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_Hant_0059,0)
        call Text_Say(gg_unit_Hant_0059,"Thank you, my friends for helping me in this difficult task. As I promised, I will reward you greatly.",false)
        call Reward_Give($7D0,$5DC,gg_unit_Hant_0059) // $7D0 = 2000; $5DC = 1500
        call Text_Say(gg_unit_Hant_0059,"Thank you once again and good bye.",false)
        call SetUnitAnimation(gg_unit_Hant_0059,"stand channel")
        set udg_SpecialEffect[7]=AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Hant_0059),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl")
        call Wait_Polled(2.)
        call DestroyEffectBJ(udg_SpecialEffect[7])
        call AddSpecialEffectLocBJ(GetUnitLoc(gg_unit_Hant_0059),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveUnit(gg_unit_Hant_0059)
        call Wait_Polled(1.5)
        call Cine_ExitAction()
    else
        call Reward_Give($7D0,$5DC,gg_unit_Hant_0059) // $7D0 = 2000; $5DC = 1500
        call RemoveUnit(gg_unit_Hant_0059)
    endif
    call DestroyTrigger(gg_trg_Quest_KillSetag_Failed)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Kill Setag|r")
    call QuestSetCompletedBJ(udg_SideQuest[3],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,99,udg_GameStateHash)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_KillSetag takes nothing returns nothing
endfunction

endlibrary

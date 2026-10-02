library TQuestGodDragon requires TCam, TCine, TPlayerPart01, TText, TUnit
function Trig_Quest_GodDragon_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0CE_0020,true,true,true))
endfunction

function Trig_Quest_GodDragon_Start_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_GodDragon_Start_HuntStillOpen takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[61])==false)and(IsQuestFailed(udg_SideQuest[61])==false)
endfunction

function Trig_Quest_GodDragon_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[82])
    if(Trig_Quest_GodDragon_Start_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n0CE_0020,"Greetings again, adventurers. You've been one of our absolute most important members of late. As such, there is a task I would like to entrust to you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are ready for anything. Try us!",false)
        call Text_Say(gg_unit_n0CE_0020,"You know how our club operates nowadays, but that was not the initial idea. This club was not just created for the sake of keeping the common monsters in check and hunting down the occasional rare game. I've always been on the lookout for the most powerful fighters in the world to take down our true foe.",false)
        call Text_Say(gg_unit_n0CE_0020,"Several years back I encountered a being of unimaginable power. Its power was beyond measure. It was all I could do to run in fear. You may call me a coward for it but to this day I'm sure I would have died that day if I hadn't.",false)
        call Text_Say(gg_unit_n0CE_0020,"I soon realized I was not the only one who encountered this being. It was a rare sight, but among the more experiences explorers it's become known as the God Dragon. And everyone who ever encountered it has had many a sleepless night over its sheer terror. Believe me when I say that none of the rare game you ever hunted for us come close to its level.",false)
        call Text_Say(gg_unit_n0CE_0020,"I don't know what this being is or if it's even malicious at all, but the idea that this being could one day just attack and wipe us all out still frightens me. So I founded this club in the pursuit of finding and nurturing the most powerful fighters in Gaya, so that we can one day hunt it down, or defend us against it should it attack.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So this being is the club's true reason for existence.",false)
        call Text_Say(gg_unit_n0CE_0020,"Originally yes. And now I believe I've found a suitable candidate for taking it on. You.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We are honored. We would gladly test our might against this foe.",false)
        call Text_Say(gg_unit_n0CE_0020,"I am glad to hear it. But please don't be reckless. If you feel this being is beyond even your power, don't put yourself at risk.",false)
        call Text_Say(gg_unit_n0CE_0020,"I've marked on your map where you will most likely encounter it. Godspeed, mighty hunter.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00God Dragon|r")
    set udg_MainQuest[17]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"God Dragon"),"Montblanc, leader of the Hunt Club, hired you to take down the god dragon, the primary target and founding reason of the entire club.","ReplaceableTextures\\CommandButtons\\BTNAzureDragon.blp")
    set udg_MontblancHasNews=false
    if(Trig_Quest_GodDragon_Start_HuntStillOpen())then
        set udg_SpecialEffect[82]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n0CE_0020,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call UnitRemoveAbilityBJ('A0YQ',gg_unit_U00H_0211) // 'A0YQ': ability "!Darkja"
    set udg_TempPoint=GetRectCenter(gg_rct_647)
    call CreateNUnitsAtLoc(1,'n0CC',Player($B),udg_TempPoint,GetUnitFacing(gg_unit_U00H_0211)) // 'n0CC': unit "Shinryu"; $B = 11
    call RemoveLocation(udg_TempPoint)
    set udg_GodDragonUnit=GetLastCreatedUnit()
    call PauseUnitBJ(true,udg_GodDragonUnit)
    call SetUnitInvulnerable(udg_GodDragonUnit,true)
    call UnitAddAbilityBJ('A0VJ',udg_GodDragonUnit) // 'A0VJ': ability "Unaffected by Cinematics"
    call UnitAddAbilityBJ('A0ZR',udg_GodDragonUnit) // 'A0ZR': ability "Immortal"
    call GroupAddUnitSimple(udg_GodDragonUnit,udg_BossUnits)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Zodiark_Encounter,700.,udg_GodDragonUnit)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Zodiark_Encounter,250.,udg_GodDragonUnit)
    call EnableTrigger(gg_trg_Zodiark_Encounter)
    call TriggerRegisterUnitLifeEvent(gg_trg_GodDragon_Transfusion,udg_GodDragonUnit,LESS_THAN,5000.)
    call EnableTrigger(gg_trg_GodDragon_Transfusion)
    call TriggerRegisterUnitEvent(gg_trg_GodDragon_Death,udg_GodDragonUnit,EVENT_UNIT_DEATH)
    call EnableTrigger(gg_trg_GodDragon_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_GodDragon takes nothing returns nothing
endfunction

endlibrary

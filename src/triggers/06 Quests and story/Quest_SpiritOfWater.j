library TQuestSpiritOfWater requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_SpiritOfWater_Start=null
    trigger gg_trg_Quest_SpiritOfWater_WaterGem=null
    trigger gg_trg_Quest_SpiritOfWater_Complete=null
endglobals

function Trig_Quest_SpiritOfWater_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_u007_0128,true,true,true))
endfunction

function Trig_Quest_SpiritOfWater_Start_Cond_HeroIsSummoner takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))=='H009') // 'H009': unit "Summoner"
endfunction

function Trig_Quest_SpiritOfWater_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SpiritOfWater_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[47])
    if(Trig_Quest_SpiritOfWater_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_u007_0128,"You are the one who can help me - you are strong enough to complete the mission I am willing to give you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I'm sure I can. But remember - harder task means greater reward.",false)
        call Text_Say(gg_unit_u007_0128,"You will have all the gold you ever wished for. And maybe even more than that. Do you agree?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds good to me.",false)
        call Text_Say(gg_unit_u007_0128,"Good. My name is Priscilla and I am a Summoner, one who can call mighty Eidolons to do my bidding.",false)
        if(Trig_Quest_SpiritOfWater_Start_Cond_HeroIsSummoner())then
            call Text_Say(gg_unit_u007_0128,"Well, I guess you know that already since you are a Summoner yourself.",false)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Indeed.",false)
        endif
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So, why don't you use those Eidolons you can summon to fulfill your task?",false)
        call Text_Say(gg_unit_u007_0128,"They are not strong enough. Only you can help me.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Ok. so what do you need?",false)
        call Text_Say(gg_unit_u007_0128,"Many things. I am going to summon a very powerful Eidolon but I need some rare things to do it. Your task is to find them.",false)
        call Text_Say(gg_unit_u007_0128,"First of all, bring me a Water Gem.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Where can I find it?",false)
        call Text_Say(gg_unit_u007_0128,"I have no idea. Elemental gems are not common but I'm sure you'll be able to find one.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"All right, I'll try to find it.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Spirit of Water|r")
    set udg_SideQuest[29]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Spirit of Water"),"Summoner Priscilla wants you to bring her a Water Gem.","ReplaceableTextures\\CommandButtons\\BTNCrushingWave.blp")
    set udg_SpecialEffect[47]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u007_0128,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_Quest_SpiritOfWater_WaterGem)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SpiritOfWater_WaterGem_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0FT'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I0FT': item "Water Gem"
endfunction

function Trig_Quest_SpiritOfWater_WaterGem_Cond_ExtraCharges takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FT'))>=2) // 'I0FT': item "Water Gem"
endfunction

function Trig_Quest_SpiritOfWater_WaterGem_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SpiritOfWater_WaterGem_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_SpiritOfWater_WaterGem_Cond_ExtraCharges())then
        // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0FT')) minus (1).
        call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FT'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FT'))-1)) // 'I0FT': item "Water Gem"
    else
        call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0FT')) // 'I0FT': item "Water Gem"
    endif
    if(Trig_Quest_SpiritOfWater_WaterGem_Cond_CinematicsEnabled())then
        call DestroyEffectBJ(udg_SpecialEffect[47])
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_u007_0128,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"This is it. The Water Gem.",false)
        call Text_Say(gg_unit_u007_0128,"Yes, this is what I need. Thank you. But this was just a first step. Now I need another item - Tiara of the Deep.",false)
        call Text_Say(gg_unit_u007_0128,"Luckily, I know where it can be found. Vodyan, the Sea Giant, has it. He can be found on the islands to the south.",false)
        call Cine_ExitAction()
        set udg_SpecialEffect[47]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_u007_0128,"Objects\\RandomObject\\RandomObject.mdl")
    endif
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Defeat Vodyan, take Tiara of the Deep and bring it to Priscilla.")
    call QuestSetDescriptionBJ(udg_SideQuest[29],"Defeat Vodyan, take Tiara of the Deep and bring it to Priscilla.")
    call ShowUnitShow(gg_unit_n023_0121)
    call PauseUnitBJ(false,gg_unit_n023_0121)
    call SetUnitInvulnerable(gg_unit_n023_0121,false)
    call GroupAddUnitSimple(gg_unit_n023_0121,udg_BossUnits)
    call EnableTrigger(gg_trg_Vodyan_Death_DropTiara)
    call AddItemToStockBJ('I04V',gg_unit_n02Y_0052,1,1) // 'I04V': item "Information: Tiara of the Deep"
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_SpiritOfWater_Complete_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'I038'))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'I038': item "Tiara of the Deep"
endfunction

function Trig_Quest_SpiritOfWater_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_SpiritOfWater_Complete_Cond_UltimaWeaponBeaten takes nothing returns boolean
    return(IsQuestCompleted(udg_SideQuest[46]))
endfunction

function Trig_Quest_SpiritOfWater_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Tiara_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I038')) // 'I038': item "Tiara of the Deep"
    call DestroyEffectBJ(udg_SpecialEffect[47])
    if(Trig_Quest_SpiritOfWater_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_u007_0128,0)
        call Text_Say(gg_unit_u007_0128,"Thank you very much for bringing me Tiara of the Deep.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So what is this mighty Eidolon you're going to summon?",false)
        call Text_Say(gg_unit_u007_0128,"That's going to be a surprise. Come back when you're the strongest person in Gaya, and I will let you try fighting this Eidolon.",false)
        call Text_Say(gg_unit_u007_0128,"The only thing I'll tell you is that Tiara of the Deep also goes by the name Tiara of the Holy Garden. People started calling it that when Vodyan stole it.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Then I'd better hurry up and become the strongest person in Gaya!",false)
        call Text_Say(gg_unit_u007_0128,"*laughs* Sure.",false)
        call Reward_Give($2710,5000,gg_unit_u007_0128) // $2710 = 10000
        call Cine_ExitAction()
    else
        call Reward_Give($2710,5000,gg_unit_u007_0128) // $2710 = 10000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Spirit of Water|r")
    call QuestSetCompletedBJ(udg_SideQuest[29],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call RemoveItemFromStockBJ('I04V',gg_unit_n02Y_0052) // 'I04V': item "Information: Tiara of the Deep"
    if(Trig_Quest_SpiritOfWater_Complete_Cond_UltimaWeaponBeaten())then
        call ConditionalTriggerExecute(gg_trg_Priscilla_ShowMarker_Eden)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_SpiritOfWater takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10 (module Quest),
// which keeps the original registration order.

function Register_Quest_SpiritOfWater_Start takes nothing returns nothing
    set gg_trg_Quest_SpiritOfWater_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SpiritOfWater_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_SpiritOfWater_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_SpiritOfWater_Start,Condition(function Trig_Quest_SpiritOfWater_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_SpiritOfWater_Start,function Trig_Quest_SpiritOfWater_Start_Actions)
endfunction

function Register_Quest_SpiritOfWater_WaterGem takes nothing returns nothing
    set gg_trg_Quest_SpiritOfWater_WaterGem=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SpiritOfWater_WaterGem)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SpiritOfWater_WaterGem,450.,gg_unit_u007_0128)
    call TriggerAddCondition(gg_trg_Quest_SpiritOfWater_WaterGem,Condition(function Trig_Quest_SpiritOfWater_WaterGem_Conditions))
    call TriggerAddAction(gg_trg_Quest_SpiritOfWater_WaterGem,function Trig_Quest_SpiritOfWater_WaterGem_Actions)
endfunction

function Register_Quest_SpiritOfWater_Complete takes nothing returns nothing
    set gg_trg_Quest_SpiritOfWater_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_SpiritOfWater_Complete)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_SpiritOfWater_Complete,450.,gg_unit_u007_0128)
    call TriggerAddCondition(gg_trg_Quest_SpiritOfWater_Complete,Condition(function Trig_Quest_SpiritOfWater_Complete_Conditions))
    call TriggerAddAction(gg_trg_Quest_SpiritOfWater_Complete,function Trig_Quest_SpiritOfWater_Complete_Actions)
endfunction

endlibrary

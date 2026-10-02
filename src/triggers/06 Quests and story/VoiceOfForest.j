library TVoiceOfForest requires TCam, TCine, TForce, TGroup, TMusic, TPlayerPart01, TText, TUnit, TWait
function Trig_VoiceOfForest_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_Etyr_0155,true,true,true))
endfunction

function Trig_VoiceOfForest_Start_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_VoiceOfForest_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call GroupRemoveUnitSimple(gg_unit_Etyr_0155,udg_BossUnits)
    call DestroyEffectBJ(udg_SpecialEffect[85])
    if(Trig_VoiceOfForest_Start_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_Etyr_0155,"Greetings, humans. Allow me to thank you. Our forests are much less corrupted thanks to you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We managed to cleanse the spirits, but the woods are still crawling with satyrs and corrupted ents. Restoring the forest will still be a hard undertaking.",false)
        call Text_Say(gg_unit_Etyr_0155,"You are right. But it is a goal worth aiming for. As the representative of the Lothlorien rangers, I'd like to make a formal request of you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That sounds serious. What is it?",false)
        call Text_Say(gg_unit_Etyr_0155,"Please take this Essence Crystal. You can use its powers to call forth the demon infesting the forests, Chaos.",false)
        call Text_Say(gg_unit_Emns_0156,"The demon Chaos has dwelled in these forests since before even our time, corrupting it from within since time immemorial.",false)
        call Text_Say(gg_unit_Etyr_0155,"It is his presence that prevents these forests from recovering. And he has been using his powers to corner us more and more. Very few night elves even dare venture into the forest anymore.",false)
        call Text_Say(gg_unit_Etyr_0155,"But through your efforts, his grip on the forest has weakened. Now would be the time to strike, to take him down once and for all.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Chaos, is it. Is he another Zodiac Brave?",false)
        call Text_Say(gg_unit_Emns_0156,"He is. But even among the Braves he is exceptionally powerful. Our resistance against him has been fruitless and only caused some of us to become corrupted ourselves. You know this well.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Are you talking about that ranger?",false)
        call Text_Say(gg_unit_Etyr_0155,"Yes, Yukale was corrupted by Chaos as well. She was not the first to fall to his grasp, and if this demon continues to reign, she won't be the last, either.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's horrible. So what is this Essence Crystal?",false)
        call Text_Say(gg_unit_Emns_0156,"It is one of the remaining artifacts used by the previous Lady of Lothlorien. She was a kind soul and tried to settle things with the Braves peacefully, but her naivite allowed those demons to take advantage of her, and she paid the price for it.",false)
        call Text_Say(gg_unit_Etyr_0155,"This Essence Crystal was how she communicated with the demon. When all three spirits gather at the soul fire in the forest, the crystal will call for him.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Gathering all the spirits at the soul fire... alright, we should be able to do this.",false)
        call Text_Say(gg_unit_Etyr_0155,"We are grateful. Please make haste, to free us all.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not, Galadriel. We won't allow these demons to continue corrupting this world. We shall expunge them all.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Voice of the Forest|r")
    set udg_MainQuest[$C]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_ColorGold+"Voice of the Forest"),"Galadriel, queen of Lothlorien, handed you an Essence Crystal with which you may be able to summon and confront the Zodiac Brave of Wind, Chaos. Gather the Forest Spirits in the ancient soul fire and activate the crystal!","ReplaceableTextures\\CommandButtons\\BTNEnt.blp") // $C = 12
    set udg_QuestItem[$F]=UnitAddItemByIdSwapped('I0DJ',Player_GetHero(GetTriggerPlayer())) // $F = 15; 'I0DJ': item "Essence Crystal"
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    set udg_SpecialEffect[85]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Etyr_0155,"Objects\\RandomObject\\RandomObject.mdl")
    call EnableTrigger(gg_trg_VoiceOfForest_SummonChaos)
    call EnableTrigger(gg_trg_VoiceOfForest_PingCrystal)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_VoiceOfForest_PingCrystal_Conditions takes nothing returns boolean
    return(udg_QuestItem[$F]!=null) // $F = 15
endfunction

function Trig_VoiceOfForest_PingCrystal_CrystalCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[$F])) // $F = 15
endfunction

function Trig_VoiceOfForest_PingCrystal_Actions takes nothing returns nothing
    if(Trig_VoiceOfForest_PingCrystal_CrystalCarried())then
        set udg_TempPoint=GetRectCenter(gg_rct_570)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[$F]) // $F = 15
    endif
    call PingMinimapLocForForce(GetPlayersAll(),udg_TempPoint,2.)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_VoiceOfForest_SummonChaos_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='I0DJ')and(udg_InCinematicMode==false) // 'I0DJ': item "Essence Crystal"
endfunction

function Trig_VoiceOfForest_SummonChaos_IsForestSpirit takes nothing returns boolean
    return(GetUnitTypeId(GetFilterUnit())=='n089') // 'n089': unit "Forest Spirit"
endfunction

function Trig_VoiceOfForest_SummonChaos_SpiritsMissing takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)<3)
endfunction

function Trig_VoiceOfForest_SummonChaos_NotAtSoulFire takes nothing returns boolean
    return(RectContainsUnit(gg_rct_570,GetTriggerUnit())==false)
endfunction

function Trig_VoiceOfForest_SummonChaos_CinematicsOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_VoiceOfForest_SummonChaos_ReleaseElemental takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
    call SetUnitInvulnerable(GetEnumUnit(),false)
endfunction

function Trig_VoiceOfForest_SummonChaos_Actions takes nothing returns nothing
    if(Trig_VoiceOfForest_SummonChaos_NotAtSoulFire())then
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"You must be near the Soul Fire to activate the Crystal!")
        call DestroyForce(udg_TempForce)
        return
    else
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        set udg_TempGroup=Group_UnitsInRangeOfLoc(800.,udg_TempPoint,Condition(function Trig_VoiceOfForest_SummonChaos_IsForestSpirit))
        call RemoveLocation(udg_TempPoint)
        if(Trig_VoiceOfForest_SummonChaos_SpiritsMissing())then
            call DestroyGroup(udg_TempGroup)
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
            call DisplayTimedTextToForce(udg_TempForce,10.,"The three Forest Spirits must all be nearby for the crystal to activate!")
            call DestroyForce(udg_TempForce)
            return
        endif
        call DestroyGroup(udg_TempGroup)
    endif
    call DisableTrigger(GetTriggeringTrigger())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitAddAbilityBJ('A0VJ',udg_SpiritUnit[GetForLoopIndexA()]) // 'A0VJ': ability "Unaffected by Cinematics"
        call PauseUnitBJ(true,udg_SpiritUnit[GetForLoopIndexA()])
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call DisableTrigger(gg_trg_ForestSpirit_Flee)
    call DisableTrigger(gg_trg_ForestSpirit_Wander)
    call DisableTrigger(gg_trg_VoiceOfForest_PingCrystal)
    call RemoveItem(GetManipulatedItem())
    call DestroyEffectBJ(udg_SpecialEffect[85])
    if(Trig_VoiceOfForest_SummonChaos_CinematicsOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Wait_Polled(2)
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=3
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call AddSpecialEffectTargetUnitBJ("chest",udg_SpiritUnit[GetForLoopIndexA()],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call Wait_Polled(.6)
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=3
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call KillUnit(udg_SpiritUnit[GetForLoopIndexA()])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call Wait_Polled(1.4)
        set udg_TempPoint=GetUnitLoc(gg_unit_U00O_0191)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.6)
        call ShowUnitShow(gg_unit_U00O_0191)
        call Cam_PanToUnit(gg_unit_U00O_0191,.4)
        call Wait_Polled(1.4)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Wow, it actually worked!",false)
        call Text_Say(gg_unit_U00O_0191,"Human. You are the one who called for me?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"We are. Your days of corrupting this forest are at an end. We will strike you down.",false)
        call Text_Say(gg_unit_U00O_0191,"And here I thought Lady Dana had returned. Are you acting as a grunt of Galadriel's?",false)
        call Text_Say(gg_unit_U00O_0191,"No matter. I have no more patience for you humans and night elves alike. I'll make an example out of you.",false)
        call Text_Say(gg_unit_U00O_0191,"Come forth, elemental spirits!",false)
        call ConditionalTriggerExecute(gg_trg_Chaos_Spawn_Chaosjets)
        call Wait_Polled(2)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Damn it, so this demon is capable of controlling all six elements, not just Wind.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"This'll be a hard fight. For Lothlorien!",false)
        call Cine_ExitAction()
    else
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=3
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call AddSpecialEffectTargetUnitBJ("chest",udg_SpiritUnit[GetForLoopIndexA()],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call Wait_Polled(.6)
        set bj_forLoopAIndex=1
        set bj_forLoopAIndexEnd=3
        loop
            exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
            call KillUnit(udg_SpiritUnit[GetForLoopIndexA()])
            set bj_forLoopAIndex=bj_forLoopAIndex+1
        endloop
        call Wait_Polled(1.4)
        set udg_TempPoint=GetUnitLoc(gg_unit_U00O_0191)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call Wait_Polled(.6)
        call ShowUnitShow(gg_unit_U00O_0191)
        call Wait_Polled(1.4)
        call ConditionalTriggerExecute(gg_trg_Chaos_Spawn_Chaosjets)
        call Wait_Polled(1.)
    endif
    set udg_ChaosBoss=gg_unit_U00O_0191
    call PauseUnitBJ(false,gg_unit_U00O_0191)
    call SetUnitInvulnerable(gg_unit_U00O_0191,false)
    call GroupAddUnitSimple(gg_unit_U00O_0191,udg_BossUnits)
    call ForGroupBJ(udg_ChaosElementalGroup,function Trig_VoiceOfForest_SummonChaos_ReleaseElemental)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Destroy Chaos, the Zodiac Brave of Wind.")
    call QuestSetDescriptionBJ(udg_MainQuest[$C],"Destroy Chaos, the Zodiac Brave of Wind.") // $C = 12
    call Music_SetTrack($D) // $D = 13
    call EnableTrigger(gg_trg_Boss_Chaos_Death)
    call DestroyTrigger(gg_trg_ForestSpirit_Flee)
    call DestroyTrigger(gg_trg_ForestSpirit_Wander)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_VoiceOfForest takes nothing returns nothing
endfunction

function RegisterR11_VoiceOfForest_Start takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_VoiceOfForest_Start=CreateTrigger()

call DisableTrigger(gg_trg_VoiceOfForest_Start)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(0),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(1),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(2),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(3),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(4),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(5),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(6),true)

call TriggerRegisterPlayerSelectionEventBJ(gg_trg_VoiceOfForest_Start,Player(7),true)

call TriggerAddCondition(gg_trg_VoiceOfForest_Start,Condition(function Trig_VoiceOfForest_Start_Conditions))

call TriggerAddAction(gg_trg_VoiceOfForest_Start,function Trig_VoiceOfForest_Start_Actions)

endfunction




function RegisterR11_VoiceOfForest_PingCrystal takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_VoiceOfForest_PingCrystal=CreateTrigger()

call DisableTrigger(gg_trg_VoiceOfForest_PingCrystal)

call TriggerRegisterTimerEventPeriodic(gg_trg_VoiceOfForest_PingCrystal,15.)

call TriggerAddCondition(gg_trg_VoiceOfForest_PingCrystal,Condition(function Trig_VoiceOfForest_PingCrystal_Conditions))

call TriggerAddAction(gg_trg_VoiceOfForest_PingCrystal,function Trig_VoiceOfForest_PingCrystal_Actions)

endfunction




function RegisterR11_VoiceOfForest_SummonChaos takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_VoiceOfForest_SummonChaos=CreateTrigger()

call DisableTrigger(gg_trg_VoiceOfForest_SummonChaos)

call TriggerRegisterAnyUnitEventBJ(gg_trg_VoiceOfForest_SummonChaos,EVENT_PLAYER_UNIT_USE_ITEM)

call TriggerAddCondition(gg_trg_VoiceOfForest_SummonChaos,Condition(function Trig_VoiceOfForest_SummonChaos_Conditions))

call TriggerAddAction(gg_trg_VoiceOfForest_SummonChaos,function Trig_VoiceOfForest_SummonChaos_Actions)

endfunction




endlibrary

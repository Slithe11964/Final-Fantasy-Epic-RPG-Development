library TExodus requires TCam, TCine, TMusic, TPlayerPart01, TProf, TText, TUnit, TWait
function Trig_Exodus_Prepare_Actions takes nothing returns nothing
    call ShowUnitHide(gg_unit_U00K_0208)
    call PauseUnitBJ(true,gg_unit_U00K_0208)
    call SetUnitInvulnerable(gg_unit_U00K_0208,true)
    call ShowUnitHide(gg_unit_n0D3_0117)
    call SetUnitTimeScalePercent(gg_unit_u01M_0258,.0)
    call SetDoodadAnimationRectBJ("hide",'LOpg',gg_rct_648) // 'LOpg': object name not found in map data
    call SetDoodadAnimationRectBJ("hide",'ZPfw',gg_rct_648) // 'ZPfw': object name not found in map data
    set udg_SecretDigSpotRevealed=false
    set udg_ExodusQuestStage=0
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Exodus_Reveal_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n0D3_0117,true,true,true))
endfunction

function Trig_Exodus_Reveal_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Exodus_Reveal_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ExodusQuestStage=6
    call DestroyEffectBJ(udg_SpecialEffect[28])
    if(Trig_Exodus_Reveal_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"So there you are. You're Maester Exodus, aren't you?",false)
        call Text_Say(gg_unit_n0D3_0117,"Correct, that is my name. You've heard from the farmers then.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"What's your deal? You're no ordinary priest.",false)
        call Text_Say(gg_unit_n0D3_0117,"Me? I'm an observer.",false)
        call Text_Transmission(gg_unit_n0D3_0117,"X","Me? I'm an observer. I've been wanting to see if you were capable of living responsibly and in harmony with your surroundings.","Me? I'm an observer.",null,0,false)
        call Text_Say(gg_unit_n0D3_0117,"By now the answer is more than clear. There is no chance of you coexisting harmlessly with monsters and beasts. You'd rather ravage the world than dial back your ego.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Hmph. Come to think of it, the monsters around haven't been attacking you at all. Almost as if...",false)
        call Text_Say(gg_unit_n0D3_0117,"Allow me to remove this veil.",false)
        call ShowUnitHide(gg_unit_n0D3_0117)
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call SetUnitPositionLoc(gg_unit_U00K_0208,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_U00K_0208)
        call Wait_Polled(2)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"You're not human at all. You're a demon!",false)
        call Text_Say(gg_unit_U00K_0208,"I am Exodus, the Zodiac Brave of Aether.",false)
        call Text_Say(gg_unit_U00K_0208,"It's shameful. The Lady pleaded with us, to let us give you a chance to govern this world on your own terms. And I, too, wanted to believe in you humans.",false)
        call Text_Say(gg_unit_U00K_0208,"But there is none of that hope or sympathy remaining now. You merely consume this world as it suits you. You've caused this world far too much pain already. I won't allow you to go on.",false)
        call Text_Say(gg_unit_U00K_0208,"May space and time swallow you up!",false)
        call Cine_ExitAction()
    else
        call ShowUnitHide(gg_unit_n0D3_0117)
        set udg_TempPoint=GetUnitLoc(gg_unit_n0D3_0117)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call SetUnitPositionLoc(gg_unit_U00K_0208,udg_TempPoint)
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_U00K_0208)
    endif
    call GroupAddUnitSimple(gg_unit_U00K_0208,udg_BossUnits)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"Defeat Exodus, the Zodiac Brave of Aether.")
    call QuestSetDescriptionBJ(udg_MainQuest[$E],"Defeat Exodus, the Zodiac Brave of Aether.") // $E = 14
    call PauseUnitBJ(false,gg_unit_U00K_0208)
    call SetUnitInvulnerable(gg_unit_U00K_0208,false)
    call Music_SetTrack($D) // $D = 13
    call EnableTrigger(gg_trg_Boss_Exodus_Death)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Exodus_Stomp_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0QX',GetAttacker())>0) // 'A0QX': ability "Devaluing Attack"
endfunction

function Trig_Exodus_Stomp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempPoint=GetRectCenter(gg_rct_649)
    call IssuePointOrderLocBJ(GetTriggerUnit(),"move",udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(10.)
    call IssueImmediateOrderBJ(GetTriggerUnit(),"stomp")
    call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_Exodus_SummonTrees_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A12L') // 'A12L': ability "Summon Trees of Ages"
endfunction

function Trig_Exodus_SummonTrees_TrackedCaster_First takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Exodus_SummonTrees_TrackedCaster_Second takes nothing returns boolean
    return(GetTriggerUnit()==udg_EcheleBoss)
endfunction

function Trig_Exodus_SummonTrees_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,256.,0)
    call CreateNUnitsAtLoc(1,'n0D5',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'n0D5': unit "Tree of Ages"
    call RemoveLocation(udg_TempPoint2)
    call UnitApplyTimedLifeBJ(45.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_Exodus_SummonTrees_TrackedCaster_First())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    set udg_TempPoint2=OffsetLocation(udg_TempPoint,-256.,0)
    call CreateNUnitsAtLoc(1,'n0D5',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'n0D5': unit "Tree of Ages"
    call RemoveLocation(udg_TempPoint2)
    call UnitApplyTimedLifeBJ(45.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call Unit_ScaleToLevel60(bj_lastCreatedUnit)
    call AddSpecialEffectTargetUnitBJ("origin",GetLastCreatedUnit(),"Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    if(Trig_Exodus_SummonTrees_TrackedCaster_Second())then
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_BossSummons)
    endif
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Exodus_Cometeorite_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0YP') // 'A0YP': ability "!Cometeorite"
endfunction

function Trig_Exodus_Cometeorite_NoTargetUnit takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Exodus_Cometeorite_ShowRock takes nothing returns nothing
    call ShowUnitShow(GetEnumUnit())
endfunction

function Trig_Exodus_Cometeorite_Actions takes nothing returns nothing
    if(Trig_Exodus_Cometeorite_NoTargetUnit())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    set udg_TempReal=Prof_InnerManaPower(GetTriggerUnit())
    // (15000) times (udg_TempReal).
    call SaveRealBJ((15000.*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(4.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0YO',GetLastCreatedUnit()) // 'A0YO': ability "Cometeorite"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)
    call CreateNUnitsAtLoc(1,'n0D6',Player($B),udg_TempPoint,bj_UNIT_FACING) // 'n0D6': unit "Meteorite Rocks"; $B = 11
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(1200.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call GroupAddUnitSimple(GetLastCreatedUnit(),udg_MeteoriteRocks)
    call RemoveLocation(udg_TempPoint)
    call Wait_Polled(1.2)
    call ForGroupBJ(udg_MeteoriteRocks,function Trig_Exodus_Cometeorite_ShowRock)
endfunction

// World Editor calls InitTrig_Exodus automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Exodus_Part1 / RegisterTriggers_Exodus_Part2 (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Exodus takes nothing returns nothing
endfunction

function Register_Exodus_Prepare takes nothing returns nothing
    set gg_trg_Exodus_Prepare=CreateTrigger()
    call TriggerAddAction(gg_trg_Exodus_Prepare,function Trig_Exodus_Prepare_Actions)
endfunction

function Register_Exodus_Reveal takes nothing returns nothing
    set gg_trg_Exodus_Reveal=CreateTrigger()
    call DisableTrigger(gg_trg_Exodus_Reveal)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Exodus_Reveal,Player(7),true)
    call TriggerAddCondition(gg_trg_Exodus_Reveal,Condition(function Trig_Exodus_Reveal_Conditions))
    call TriggerAddAction(gg_trg_Exodus_Reveal,function Trig_Exodus_Reveal_Actions)
endfunction

function Register_Exodus_Stomp takes nothing returns nothing
    set gg_trg_Exodus_Stomp=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_Exodus_Stomp,gg_unit_U00K_0208,EVENT_UNIT_ATTACKED)
    call TriggerAddCondition(gg_trg_Exodus_Stomp,Condition(function Trig_Exodus_Stomp_Conditions))
    call TriggerAddAction(gg_trg_Exodus_Stomp,function Trig_Exodus_Stomp_Actions)
endfunction

function Register_Exodus_SummonTrees takes nothing returns nothing
    set gg_trg_Exodus_SummonTrees=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Exodus_SummonTrees,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Exodus_SummonTrees,Condition(function Trig_Exodus_SummonTrees_Conditions))
    call TriggerAddAction(gg_trg_Exodus_SummonTrees,function Trig_Exodus_SummonTrees_Actions)
endfunction

function Register_Exodus_Cometeorite takes nothing returns nothing
    set gg_trg_Exodus_Cometeorite=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Exodus_Cometeorite,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Exodus_Cometeorite,Condition(function Trig_Exodus_Cometeorite_Conditions))
    call TriggerAddAction(gg_trg_Exodus_Cometeorite,function Trig_Exodus_Cometeorite_Actions)
endfunction

// Creates part 1 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Exodus_Part1 takes nothing returns nothing
    call Register_Exodus_Prepare()
endfunction

// Creates part 2 of 2 of this module's triggers. Called once at startup from
// Startup_RegisterTriggers (MapBootstrap). The parts are registered at different points so that
// triggers sharing an event with other modules keep their original firing order.
function RegisterTriggers_Exodus_Part2 takes nothing returns nothing
    call Register_Exodus_Reveal()
    call Register_Exodus_Stomp()
    call Register_Exodus_SummonTrees()
    call Register_Exodus_Cometeorite()
endfunction

endlibrary

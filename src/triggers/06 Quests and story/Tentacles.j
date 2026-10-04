library TTentacles requires TQuestEngine, TCam, TCine, TLoc, TPlayerHero, TReward, TText, TUnit, TWait
// Side quest "Tentacles", run by the quest engine (QuestEngine module, docs/QUEST_ENGINE.md).
// Sarai from the Phantom Village wants the squid Ultros punished: lure him out with a female hero,
// beat him (Ultros module), and report back. The talks stay module triggers (Sarai is paused during them
// and the hand-in needs her to be visible); Ultros moves the quest on through ExecuteFunc. The quest
// fails if Dana dies (Tentacles_Fail, run by Dana). Does not count toward the story; Sarai's own markers
// (udg_SpecialEffect[77]) are kept.
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Tentacles_Start=null
    trigger gg_trg_Tentacles_Ambush=null
    trigger gg_trg_Tentacles_Yelp=null
    trigger gg_trg_Tentacles_Despawn=null
    trigger gg_trg_Tentacles_Fail=null
    trigger gg_trg_Tentacles_Reward=null
    // The quest's number in the quest engine (0 until it is defined).
    integer QUEST_TENTACLES=0
endglobals

function Tentacles_Define takes nothing returns nothing
    local integer q=Quest_Define("Tentacles",QUEST_SIDE,58,"ReplaceableTextures\\CommandButtons\\BTNTentacle.blp")
    set QUEST_TENTACLES=q
    call Quest_NotStory(q)
    call Quest_NoMarker(q)
    // 1. Talk to Sarai (gg_trg_Tentacles_Start)
    call Quest_Custom(q,"Sarai from the Phantom Village has asked you to punish the squid monster that is running wild harassing the girls around the village. It seems he is not fond of male strangers. Find a way to lure him out!")
    // 2. Ultros shows up (Tentacles_UltrosAppears, from Ultros_Spawn)
    call Quest_Custom(q,"Defeat Ultros.")
    // 3. Ultros is beaten (Tentacles_UltrosSlain, from Ultros_Death)
    call Quest_Custom(q,"Return to Sarai.")
    // 4. Report back to Sarai (gg_trg_Tentacles_Reward)
    call Quest_Custom(q,"")
endfunction

// Called by Ultros_Spawn (through ExecuteFunc) when Ultros appears.
function Tentacles_UltrosAppears takes nothing returns nothing
    if Quest_IsActive(QUEST_TENTACLES) then
        call Quest_StepDone(QUEST_TENTACLES,null,null)
    endif
endfunction

// Called by Ultros_Death (through ExecuteFunc): Sarai is pinged and waits for the party.
function Tentacles_UltrosSlain takes nothing returns nothing
    if Quest_IsActive(QUEST_TENTACLES) then
        call Quest_StepDone(QUEST_TENTACLES,null,null)
        call GroupAddUnitSimple(gg_unit_e013_0176,udg_BossUnits)
        call EnableTrigger(gg_trg_Tentacles_Reward)
    endif
endfunction

function Trig_Tentacles_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_e013_0176,true,true,true))
endfunction

function Trig_Tentacles_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Tentacles_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[77])
    if(Trig_Tentacles_Start_IsDialogueOn())then
        call PauseUnitBJ(true,gg_unit_e013_0176)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_e013_0176,"Hello there, fair adventurers. I've heard about you from Lady Dana.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings, mistress. Is there something you'd have us do?",false)
        call Text_Say(gg_unit_e013_0176,"There is. It's a trifling matter, but I would appreciate and reward your help still.",false)
        call Text_Say(gg_unit_e013_0176,"Around these parts there lives a squid. He's a bit of a mischievous guy. But it seems with us no longer being on Gaya to keep him company he's running wild a bit.",false)
        call Text_Say(gg_unit_e013_0176,"See he's a bit of a pervert and he likes using his tentacles to feel up girls. It usually just ends with him getting donked on the head but... well.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Sounds like quite a perverted fellow.",false)
        call Text_Say(gg_unit_e013_0176,"He's kind of endearing, but it seems he needs to be put back in his place a bit. So I'd appreciate if you clonked him on the head a bit for us so he leaves the girls alone again.",false)
        call Text_Say(gg_unit_e013_0176,"Of course you'll have to lure him out. He doesn't like male strangers very much.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"No problem. I'll draw him out and punish him good.",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e013_0176)
    endif
    if QUEST_TENTACLES==0 then
        call Tentacles_Define()
    endif
    call Quest_Start(QUEST_TENTACLES,GetTriggerPlayer(),Player_GetHero(GetTriggerPlayer()))
    set udg_SpecialEffect[77]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_e013_0176,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_TentacleCount=0
    call EnableTrigger(gg_trg_Tentacles_Ambush)
    call EnableTrigger(gg_trg_Tentacles_Despawn)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Tentacles_Ambush_Conditions takes nothing returns boolean
    // A random whole number from 1 through 6.
    return((GetUnitUserData(GetTriggerUnit())==6)and(IsPlayerInForce(GetOwningPlayer(GetAttacker()),udg_PlayingPlayers))and(IsUnitType(GetAttacker(),UNIT_TYPE_HERO))and(GetRandomInt(1,6)==1))!=null
endfunction

function Trig_Tentacles_Ambush_IsFemaleHeroType takes nothing returns boolean
    return(GetUnitTypeId(GetAttacker())=='H00B')or(GetUnitTypeId(GetAttacker())=='H001')or(GetUnitTypeId(GetAttacker())=='H009') // 'H00B': unit "Thief"; 'H001': unit "Archer"; 'H009': unit "Summoner"
endfunction

function Trig_Tentacles_Ambush_UnpauseEnumUnit takes nothing returns nothing
    call PauseUnitBJ(false,GetEnumUnit())
endfunction

function Trig_Tentacles_Ambush_IsLureTarget takes nothing returns boolean
    return(Trig_Tentacles_Ambush_IsFemaleHeroType())
endfunction

function Trig_Tentacles_Ambush_Actions takes nothing returns nothing
    local location l_tempPoint
    call DisableTrigger(GetTriggeringTrigger())
    set l_tempPoint=GetUnitLoc(GetAttacker())
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=8
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,300.,(45.*I2R(GetForLoopIndexA())))
        call CreateNUnitsAtLocFacingLocBJ(1,'n0C9',Player($B),udg_TempPoint2,l_tempPoint) // 'n0C9': object name not found in map data; $B = 11
        call PauseUnitBJ(true,GetLastCreatedUnit())
        call SetUnitAnimation(GetLastCreatedUnit(),"birth")
        call QueueUnitAnimationBJ(GetLastCreatedUnit(),"stand")
        call GroupAddUnitSimple(GetLastCreatedUnit(),udg_TentacleGroup)
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint)
    if(Trig_Tentacles_Ambush_IsLureTarget())then
        call EnableTrigger(gg_trg_Tentacles_Yelp)
        call Wait_Polled(.5)
        call ForGroupBJ(udg_TentacleGroup,function Trig_Tentacles_Ambush_UnpauseEnumUnit)
        call StartTimerBJ(udg_TentacleTimer,false,15.)
    else
        call StartTimerBJ(udg_TentacleTimer,false,.5)
    endif
    set l_tempPoint=null
endfunction

function Trig_Tentacles_Yelp_Conditions takes nothing returns boolean
    return(IsUnitInGroup(GetTriggerUnit(),udg_TentacleGroup))and(GetKillingUnitBJ()!=null)
endfunction

function Trig_Tentacles_Yelp_KillEnumUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Tentacles_Yelp_PickYelpB takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Tentacles_Yelp_PickYelpA takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Tentacles_Yelp_PickYelpGroup takes nothing returns boolean
    // A random whole number from 1 through 2.
    return(GetRandomInt(1,2)==1)
endfunction

function Trig_Tentacles_Yelp_IsLureComplete takes nothing returns boolean
    return(udg_TentacleCount>3)
endfunction

function Trig_Tentacles_Yelp_Actions takes nothing returns nothing
    call ForGroupBJ(udg_TentacleGroup,function Trig_Tentacles_Yelp_KillEnumUnit)
    call GroupClear(udg_TentacleGroup)
    set udg_TentacleCount=(udg_TentacleCount+1)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    if(Trig_Tentacles_Yelp_IsLureComplete())then
        call DisableTrigger(GetTriggeringTrigger())
        call CreateTextTagLocBJ("THAT HURTS! ENOUGH ALREADY!!",udg_TempPoint,0,12.,'d',50.,'d',0)
        call RemoveLocation(udg_TempPoint)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
        call DisableTrigger(gg_trg_Tentacles_Despawn)
        call DestroyTrigger(gg_trg_Tentacles_Despawn)
        call Wait_Polled(4.)
        set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
        call ConditionalTriggerExecute(gg_trg_Ultros_Spawn)
        call DestroyTrigger(GetTriggeringTrigger())
    else
        if(Trig_Tentacles_Yelp_PickYelpGroup())then
            if(Trig_Tentacles_Yelp_PickYelpA())then
                call CreateTextTagLocBJ("YEOWCH!",udg_TempPoint,0,12.,'d',50.,'d',0)
            else
                call CreateTextTagLocBJ("GAH!",udg_TempPoint,0,12.,'d',50.,'d',0)
            endif
        else
            if(Trig_Tentacles_Yelp_PickYelpB())then
                call CreateTextTagLocBJ("OW!!",udg_TempPoint,0,12.,'d',50.,'d',0)
            else
                call CreateTextTagLocBJ("OUCH!",udg_TempPoint,0,12.,'d',50.,'d',0)
            endif
        endif
        call RemoveLocation(udg_TempPoint)
        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
    endif
endfunction

function Trig_Tentacles_Despawn_KillEnumUnit takes nothing returns nothing
    call KillUnit(GetEnumUnit())
endfunction

function Trig_Tentacles_Despawn_HasTentacles takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TentacleGroup)==false)
endfunction

function Trig_Tentacles_Despawn_Actions takes nothing returns nothing
    if(Trig_Tentacles_Despawn_HasTentacles())then
        call DisableTrigger(gg_trg_Tentacles_Yelp)
        call ForGroupBJ(udg_TentacleGroup,function Trig_Tentacles_Despawn_KillEnumUnit)
        call GroupClear(udg_TentacleGroup)
        call Wait_Polled(5.)
    endif
    call EnableTrigger(gg_trg_Tentacles_Ambush)
endfunction

function Trig_Tentacles_Fail_Actions takes nothing returns nothing
    call DestroyEffectBJ(udg_SpecialEffect[77])
    call Quest_Fail(QUEST_TENTACLES)
    call GroupRemoveUnitSimple(gg_unit_e013_0176,udg_BossUnits)
    call DisableTrigger(gg_trg_Tentacles_Reward)
    call DestroyTrigger(gg_trg_Tentacles_Reward)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Tentacles_Reward_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(IsUnitVisible(gg_unit_e013_0176,GetOwningPlayer(GetTriggerUnit())))and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Tentacles_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Tentacles_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[77])
    call GroupRemoveUnitSimple(gg_unit_e013_0176,udg_BossUnits)
    if(Trig_Tentacles_Reward_IsDialogueOn())then
        call PauseUnitBJ(true,gg_unit_e013_0176)
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Well we've taken him down a peg. Should be a while before he tries something like that again.",false)
        call Text_Say(gg_unit_e013_0176,"Oh thank you! Here, as promised.",false)
        call Reward_Give(4500,$FA0,gg_unit_e013_0176) // $FA0 = 4000
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So I've been wondering something. If you can't punish him yourself anymore because you're not on Gaya, how come he can still bother you just fine?",false)
        call Text_Say(gg_unit_e013_0176,"Oh it's not us in the Phantom Village he's bothering. Rather, it's the female Naga.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"The Naga?",false)
        call Text_Say(gg_unit_e013_0176,"Yeah. Besides Lady Dana, we of the Phantom Village do not have a physical body on Gaya. But we do have familiars on the other side, the Naga. We can control them should we need to interact with the other side, but we haven't had to much lately.",false)
        call Text_Say(gg_unit_e013_0176,"Still, as they are our familiars it is still our responsibility to look out for them and punish the squid for harassing them. Normally Lady Olga would do this with her powerful familiar but it seems to have been incapacitated not long ago.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"So the naga are your familiars? What about Olga's familiar, was it a Naga too?",false)
        call Text_Say(gg_unit_e013_0176,"Yes, quite a formidable one even. Her name is Lady Nashj. Well she'll likely recover soon, but if you happen to find out what happened to her, please do tell Lady Dana about it.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm...",false)
        call Cine_ExitAction()
        call PauseUnitBJ(false,gg_unit_e013_0176)
    else
        call Reward_Give(4500,$FA0,gg_unit_e013_0176) // $FA0 = 4000
    endif
    call Quest_StepDone(QUEST_TENTACLES,GetOwningPlayer(GetTriggerUnit()),GetTriggerUnit())
    set udg_PhantomVillagersMet=(udg_PhantomVillagersMet+1)
    call DestroyTrigger(gg_trg_Tentacles_Fail)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Tentacles automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Tentacles (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Tentacles takes nothing returns nothing
endfunction

function Register_Tentacles_Start takes nothing returns nothing
    set gg_trg_Tentacles_Start=CreateTrigger()
    call DisableTrigger(gg_trg_Tentacles_Start)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Tentacles_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Tentacles_Start,Condition(function Trig_Tentacles_Start_Conditions))
    call TriggerAddAction(gg_trg_Tentacles_Start,function Trig_Tentacles_Start_Actions)
endfunction

function Register_Tentacles_Ambush takes nothing returns nothing
    set gg_trg_Tentacles_Ambush=CreateTrigger()
    call DisableTrigger(gg_trg_Tentacles_Ambush)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Tentacles_Ambush,Player($B),EVENT_PLAYER_UNIT_ATTACKED) // $B = 11
    call TriggerAddCondition(gg_trg_Tentacles_Ambush,Condition(function Trig_Tentacles_Ambush_Conditions))
    call TriggerAddAction(gg_trg_Tentacles_Ambush,function Trig_Tentacles_Ambush_Actions)
endfunction

function Register_Tentacles_Yelp takes nothing returns nothing
    set gg_trg_Tentacles_Yelp=CreateTrigger()
    call DisableTrigger(gg_trg_Tentacles_Yelp)
    call TriggerRegisterPlayerUnitEventSimple(gg_trg_Tentacles_Yelp,Player($B),EVENT_PLAYER_UNIT_DEATH) // $B = 11
    call TriggerAddCondition(gg_trg_Tentacles_Yelp,Condition(function Trig_Tentacles_Yelp_Conditions))
    call TriggerAddAction(gg_trg_Tentacles_Yelp,function Trig_Tentacles_Yelp_Actions)
endfunction

function Register_Tentacles_Despawn takes nothing returns nothing
    set gg_trg_Tentacles_Despawn=CreateTrigger()
    call DisableTrigger(gg_trg_Tentacles_Despawn)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Tentacles_Despawn,udg_TentacleTimer)
    call TriggerAddAction(gg_trg_Tentacles_Despawn,function Trig_Tentacles_Despawn_Actions)
endfunction

function Register_Tentacles_Fail takes nothing returns nothing
    set gg_trg_Tentacles_Fail=CreateTrigger()
    call DisableTrigger(gg_trg_Tentacles_Fail)
    call TriggerAddAction(gg_trg_Tentacles_Fail,function Trig_Tentacles_Fail_Actions)
endfunction

function Register_Tentacles_Reward takes nothing returns nothing
    set gg_trg_Tentacles_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_Tentacles_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Tentacles_Reward,200.,gg_unit_e013_0176)
    call TriggerRegisterUnitInRangeSimple(gg_trg_Tentacles_Reward,450.,gg_unit_e013_0176)
    call TriggerAddCondition(gg_trg_Tentacles_Reward,Condition(function Trig_Tentacles_Reward_Conditions))
    call TriggerAddAction(gg_trg_Tentacles_Reward,function Trig_Tentacles_Reward_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Tentacles takes nothing returns nothing
    call Register_Tentacles_Start() // starts off; enabled by Sarai
    call Register_Tentacles_Ambush() // starts off; enabled by Tentacles
    call Register_Tentacles_Yelp() // starts off; enabled by Tentacles; disabled by Tentacles
    call Register_Tentacles_Despawn() // starts off; enabled by Tentacles; disabled by Tentacles; destroyed by Tentacles
    call Register_Tentacles_Fail() // starts off; run by Dana; destroyed by Tentacles
    call Register_Tentacles_Reward() // starts off; enabled by Ultros; disabled by Tentacles; destroyed by Tentacles
endfunction

endlibrary

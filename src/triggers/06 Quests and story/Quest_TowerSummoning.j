library TQuestTowerSummoning requires TCam, TCine, TPlayerHero, TReward, TText, TUnit, TWait
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_TowerSummoning_Start=null
    trigger gg_trg_Quest_TowerSummoning_Complete=null
endglobals

function Trig_Quest_TowerSummoning_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_n020_0129,true,true,true))
endfunction

function Trig_Quest_TowerSummoning_Start_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_TowerSummoning_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[48])
    if(Trig_Quest_TowerSummoning_Start_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_n020_0129,"Greetings young people. What brings you to this distant island?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Greetings old geezer. We're just passing by. Nice tower you have here.",false)
        call Text_Say(gg_unit_n020_0129,"*Laughs* Oh yes, indeed.",false)
        call Text_Say(gg_unit_n020_0129,"This is the legendary Tower of Summoning, It gives great power to the one who controls it.",false)
        call Text_Say(gg_unit_n020_0129,"Do you want power?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Yes, I do.",false)
        call Text_Say(gg_unit_n020_0129,"What for?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"To destroy evil of course !",false)
        call Text_Say(gg_unit_n020_0129,"*Laughs* How unexpected.",false)
        call Text_Say(gg_unit_n020_0129,"I've seen many would-be heroes consumed by the power they sought to use against evil. Can you handle it? Can you control the power and not be controlled by it?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"I can.",false)
        call Text_Say(gg_unit_n020_0129,"We shall see. I will give you a chance. But before that you must prove to me that you deserve to have that power.",false)
        call SetUnitAnimation(gg_unit_n020_0129,"channel")
        call Wait_Polled(1.)
        set udg_TempPoint=GetUnitLoc(gg_unit_n01Z_0127)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_n01Z_0127)
        call ResetUnitAnimation(gg_unit_n020_0129)
        call Wait_Polled(2)
        call Text_Say(gg_unit_n020_0129,"If you can defeat Quezacotl I will give you control of the Tower of Summoning. But that won't be easy. Let's see how really strong you are.",false)
        call Cine_ExitAction()
    else
        set udg_TempPoint=GetUnitLoc(gg_unit_n01Z_0127)
        call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint)
        call ShowUnitShow(gg_unit_n01Z_0127)
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Tower of Summoning|r")
    set udg_SideQuest[30]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Tower of Summoning"),"Defeat Quezacotl to gain control of the Tower of Summoning.","ReplaceableTextures\\CommandButtons\\BTNArcaneObservatory.blp")
    call EnableTrigger(gg_trg_Quest_TowerSummoning_Complete)
    set udg_SpecialEffect[48]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_n020_0129,"Objects\\RandomObject\\RandomObject.mdl")
    call SetUnitInvulnerable(gg_unit_n01Z_0127,false)
    call PauseUnitBJ(false,gg_unit_n01Z_0127)
    call GroupAddUnitSimple(gg_unit_n01Z_0127,udg_ShockAuraUnitGroup)
    call GroupAddUnitSimple(gg_unit_n01Z_0127,udg_BossUnits)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_TowerSummoning_Complete_Cond_KilledByPlayer takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_PlayingPlayers))
endfunction

function Trig_Quest_TowerSummoning_Complete_Cond_CinematicsEnabled takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_TowerSummoning_Complete_Enum_ShareTowerVision takes nothing returns nothing
    call UnitShareVisionBJ(true,gg_unit_h00Z_0130,GetEnumPlayer())
endfunction

function Trig_Quest_TowerSummoning_Complete_Cond_PlayerMissingCredit takes nothing returns boolean
    return(IsPlayerInForce(GetEnumPlayer(),udg_TitleForce[30])==false)
endfunction

function Trig_Quest_TowerSummoning_Complete_Enum_GrantTowerCredit takes nothing returns nothing
    if(Trig_Quest_TowerSummoning_Complete_Cond_PlayerMissingCredit())then
        set udg_TempPlayer=GetEnumPlayer()
        set udg_TempInteger=30
        call ConditionalTriggerExecute(gg_trg_Title_Grant)
    endif
endfunction

function Trig_Quest_TowerSummoning_Complete_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[48])
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_ShockAuraUnitGroup)
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_BossUnits)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateItemLoc('I01F',udg_TempPoint) // 'I01F': item "Thunder Wand"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Quest_TowerSummoning_Complete_Cond_CinematicsEnabled())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_n020_0129,0)
        if(Trig_Quest_TowerSummoning_Complete_Cond_KilledByPlayer())then
            set udg_CinematicActor=Player_GetHero(GetOwningPlayer(GetKillingUnitBJ()))
        else
            set udg_CinematicActor=Player_GetHero(ForcePickRandomPlayer(udg_PlayingPlayers))
        endif
        call Text_Say(udg_CinematicActor,"So, do you believe now that we are strong enough?",false)
        call Text_Say(gg_unit_n020_0129,"I believe that you are strong enough to handle the power of Tower of Summoning.",false)
        call Text_Say(gg_unit_n020_0129,"But still you can be corrupted by its power. So I will stay here and watch your progress. Should I see that you use the power given to you not to fight but to do evil then you will face me as an opponent.",false)
        call Text_Say(udg_CinematicActor,"Hope it doesn't come to that.",false)
        call Text_Say(gg_unit_n020_0129,"You can use the Tower of Summoning to summon Eidolons who pledged their loyality to you. You have defeated Quezacotl and he will now serve you. But there are other ways to make Eidolon help you apart from beating them up. Good luck.",false)
        call Reward_Give($7D0,$7D0,gg_unit_n020_0129) // $7D0 = 2000
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Tower of Summoning|r")
    call QuestSetCompletedBJ(udg_SideQuest[30],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call SaveIntegerBJ(1,2,$82,udg_GameStateHash) // $82 = 130
    call SetUnitOwner(gg_unit_h00Z_0130,Player($A),true) // $A = 10
    call ForForce(udg_PlayingPlayers,function Trig_Quest_TowerSummoning_Complete_Enum_ShareTowerVision)
    call UnitAddAbilityBJ('A088',gg_unit_h00Z_0130) // 'A088': ability "Quezacotl"
    call UnitAddAbilityBJ('Ane2',gg_unit_h00Z_0130) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n088',gg_unit_h00Z_0130,1,1) // 'n088': unit "Restore MP"
    call ForceAddPlayerSimple(Player($A),udg_TitleForce[30]) // $A = 10
    call ForForce(udg_PlayingPlayers,function Trig_Quest_TowerSummoning_Complete_Enum_GrantTowerCredit)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_TowerSummoning takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part10, RegisterTriggers_Quest_Part11 (module Quest),
// which keeps the original registration order.

function Register_Quest_TowerSummoning_Start takes nothing returns nothing
    set gg_trg_Quest_TowerSummoning_Start=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Quest_TowerSummoning_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_Quest_TowerSummoning_Start,Condition(function Trig_Quest_TowerSummoning_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_TowerSummoning_Start,function Trig_Quest_TowerSummoning_Start_Actions)
endfunction

function Register_Quest_TowerSummoning_Complete takes nothing returns nothing
    set gg_trg_Quest_TowerSummoning_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_TowerSummoning_Complete)
    call TriggerRegisterUnitEvent(gg_trg_Quest_TowerSummoning_Complete,gg_unit_n01Z_0127,EVENT_UNIT_DEATH)
    call TriggerAddAction(gg_trg_Quest_TowerSummoning_Complete,function Trig_Quest_TowerSummoning_Complete_Actions)
endfunction

endlibrary

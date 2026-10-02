library TAdamantHunt requires TCam, TCine, TPlayerPart01, TReward, TText, TUnit
function Trig_AdamantHunt_Start_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,gg_unit_h02Z_0230,true,true,true))
endfunction

function Trig_AdamantHunt_Start_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_AdamantHunt_Start_IsFirstBoardEntry takes nothing returns boolean
    return(udg_HuntCounter[0]==1)
endfunction

function Trig_AdamantHunt_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[71])
    if(Trig_AdamantHunt_Start_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(gg_unit_h02Z_0230,"Greetings, adventurers. My name is Bansat. Have you come from Kalm?",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We have. What is this place exactly?",false)
        call Text_Say(gg_unit_h02Z_0230,"This place is an important checkpoint outside of Kalm, the Shipyard. There aren't too many waters around here but you still need a boat to reach the islands on the other side of this river. You can purchase your own right over there. And if you're planning on heading over there I may have a proposal for you.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"We're listening.",false)
        call Text_Say(gg_unit_h02Z_0230,"Perhaps you've heard of the Hunt Club? Well I'm the representative in charge of these islands and we're in a bit of a pickle. These islands contain a highly diverse fauna and there's a lot to hunt. However there's one type of monster that we generally do not engage in hunting: the Adamants.",false)
        call Text_Say(gg_unit_h02Z_0230,"They are gigantic turtles and most weapons won't even make a dent in their shells. Normally they wouldn't be a problem since they are quite rare but since we've been leaving them alone for so long their numbers have started to multiply.",false)
        call Text_Say(gg_unit_h02Z_0230,"I'm not asking for a genocide, but if you can thin their numbers by 10 that would be a great help already, and I'd be willing to give you a handsome reward on behalf of the club. And hey if you're lucky you may be able to harvest their valuable shells. They're incredibly durable and will net you a good amount of gold on the market.",false)
        call Text_Say(Player_GetHero(GetTriggerPlayer()),"Worry not. We will thin their numbers and restore balance.",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Adamant Hunt|r")
    set udg_SideQuest[53]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Adamant Hunt"),"Bansat from the Hunt Club hired you to kill 10 adamants. Adamants are gigantic turtles predominantly found on the Central Islands.","ReplaceableTextures\\CommandButtons\\BTNSeaTurtleGreen.blp")
    set udg_SpecialEffect[71]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h02Z_0230,"Objects\\RandomObject\\RandomObject.mdl")
    set udg_HuntCounter[0]=(udg_HuntCounter[0]+1)
    if(Trig_AdamantHunt_Start_IsFirstBoardEntry())then
        call LeaderboardDisplayBJ(true,udg_HuntLeaderboard)
    endif
    set udg_HuntCounter[3]=$A // $A = 10
    set udg_HuntBoardLabel[3]="Adamants to kill"
    call LeaderboardAddItemBJ(Player(2),udg_HuntLeaderboard,udg_HuntBoardLabel[3],udg_HuntCounter[3])
    call LeaderboardSetPlayerItemLabelColorBJ(Player(2),udg_HuntLeaderboard,65.,75.,40.,0)
    call LeaderboardSetPlayerItemValueColorBJ(Player(2),udg_HuntLeaderboard,80.,20.,20,0)
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    call EnableTrigger(gg_trg_AdamantHunt_Count)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_AdamantHunt_Count_IsAdamantUnit takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='ntrg')or(GetUnitTypeId(GetTriggerUnit())=='ntrd')or(GetUnitTypeId(GetTriggerUnit())=='n02P')or(GetUnitTypeId(GetTriggerUnit())=='n02Q')or(GetUnitTypeId(GetTriggerUnit())=='n0N1') // 'ntrg': unit "Adamanchelid"; 'ntrd': unit "Adaman Tortoise"; 'n02P': unit "Adamantoise"; 'n02Q': unit "Adaman Taimai"; 'n0N1': unit "Xiao Long Gui"
endfunction

function Trig_AdamantHunt_Count_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetKillingUnitBJ()),udg_ActivePlayers))and(Trig_AdamantHunt_Count_IsAdamantUnit())
endfunction

function Trig_AdamantHunt_Count_NoQuestsLeft takes nothing returns boolean
    return(udg_HuntCounter[0]<=0)
endfunction

function Trig_AdamantHunt_Count_IsCountDone takes nothing returns boolean
    return(udg_HuntCounter[3]<=0)
endfunction

function Trig_AdamantHunt_Count_Actions takes nothing returns nothing
    set udg_HuntCounter[3]=(udg_HuntCounter[3]-1)
    call LeaderboardSetPlayerItemValueBJ(Player(2),udg_HuntLeaderboard,udg_HuntCounter[3])
    call LeaderboardSortItemsBJ(udg_HuntLeaderboard,bj_SORTTYPE_SORTBYVALUE,false)
    if(Trig_AdamantHunt_Count_IsCountDone())then
        call DisableTrigger(GetTriggeringTrigger())
        call LeaderboardRemovePlayerItemBJ(Player(2),udg_HuntLeaderboard)
        set udg_HuntCounter[0]=(udg_HuntCounter[0]-1)
        if(Trig_AdamantHunt_Count_NoQuestsLeft())then
            call LeaderboardDisplayBJ(false,udg_HuntLeaderboard)
        endif
        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_UPDATED,"You have killed enough adamants. Return to Bansat for a reward.\r\n")
        call QuestSetDescriptionBJ(udg_SideQuest[53],"Return to Bansat for a reward.")
        call GroupAddUnitSimple(gg_unit_h02Z_0230,udg_BossUnits)
        call EnableTrigger(gg_trg_AdamantHunt_Reward)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

function Trig_AdamantHunt_Reward_Conditions takes nothing returns boolean
    return((IsUnitHiddenBJ(gg_unit_h02Z_0230)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(udg_InCinematicMode==false))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_AdamantHunt_Reward_IsDialogueOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_AdamantHunt_Reward_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[71])
    call GroupRemoveUnitSimple(gg_unit_h02Z_0230,udg_BossUnits)
    if(Trig_AdamantHunt_Reward_IsDialogueOn())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h02Z_0230,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Those turtles are HUGE! But we still managed to take 10 of them down.",false)
        call Text_Say(gg_unit_h02Z_0230,"Great work! This'll surely give our hunters on the islands an easier time.",false)
        call Text_Say(gg_unit_h02Z_0230,"Here's your reward, as promised.",false)
        call Reward_Give($FA0,$FA0,gg_unit_h02Z_0230) // $FA0 = 4000
        call Text_Say(gg_unit_h02Z_0230,"By the way, did you know that if you use physical techs, you gain more experience from killing enemies?",false)
        call Text_Say(gg_unit_h02Z_0230,"Not just you yourself either, everyone around you gains more experience from watching you finish off a foe in graceful fashion.",false)
        call Text_Say(gg_unit_h02Z_0230,"So keep that in mind if you want to become a professional hunter more efficiently!",false)
        call Cine_ExitAction()
    else
        call Reward_Give($FA0,$FA0,gg_unit_h02Z_0230) // $FA0 = 4000
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Adamant Hunt|r")
    call QuestSetCompletedBJ(udg_SideQuest[53],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    set udg_CommonHuntsDone=(udg_CommonHuntsDone+1)
    call UnitAddAbilityBJ('Ane2',gg_unit_h02Z_0230) // 'Ane2': object name not found in map data
    call AddUnitToStockBJ('n0C6',gg_unit_h02Z_0230,1,1) // 'n0C6': unit "Hunt: Girimehkala"
    set udg_HuntStock[3]=(udg_HuntStock[3]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_AdamantHunt takes nothing returns nothing
endfunction
function RegisterR11_AdamantHunt_Start takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AdamantHunt_Start=CreateTrigger()
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_AdamantHunt_Start,Player(7),true)
    call TriggerAddCondition(gg_trg_AdamantHunt_Start,Condition(function Trig_AdamantHunt_Start_Conditions))
    call TriggerAddAction(gg_trg_AdamantHunt_Start,function Trig_AdamantHunt_Start_Actions)
endfunction
function RegisterR11_AdamantHunt_Count takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AdamantHunt_Count=CreateTrigger()
    call DisableTrigger(gg_trg_AdamantHunt_Count)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_AdamantHunt_Count,EVENT_PLAYER_UNIT_DEATH)
    call TriggerAddCondition(gg_trg_AdamantHunt_Count,Condition(function Trig_AdamantHunt_Count_Conditions))
    call TriggerAddAction(gg_trg_AdamantHunt_Count,function Trig_AdamantHunt_Count_Actions)
endfunction
function RegisterR11_AdamantHunt_Reward takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_AdamantHunt_Reward=CreateTrigger()
    call DisableTrigger(gg_trg_AdamantHunt_Reward)
    call TriggerRegisterUnitInRangeSimple(gg_trg_AdamantHunt_Reward,450.,gg_unit_h02Z_0230)
    call TriggerAddCondition(gg_trg_AdamantHunt_Reward,Condition(function Trig_AdamantHunt_Reward_Conditions))
    call TriggerAddAction(gg_trg_AdamantHunt_Reward,function Trig_AdamantHunt_Reward_Actions)
endfunction




endlibrary

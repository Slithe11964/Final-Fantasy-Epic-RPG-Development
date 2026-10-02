library TLadyCurse requires TCam, TCine, TPlayerPart01, TReward, TText
function Trig_LadyCurse_ShowMarker_Actions takes nothing returns nothing
    set udg_SpecialEffect[54]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_h01P_0017,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call EnableTrigger(gg_trg_Quest_AnnoyingMonster_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_LadyCurse_ReturnBelongings_Conditions takes nothing returns boolean
    return((UnitHasItemOfTypeBJ(GetTriggerUnit(),'ktrm'))and(IsUnitHiddenBJ(gg_unit_h01P_0017)==false)and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(udg_InCinematicMode==false))!=null // 'ktrm': item "A Lady's Belongings"
endfunction

function Trig_LadyCurse_ReturnBelongings_Cond_ShowDialogue takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_LadyCurse_ReturnBelongings_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Belongings_Ping)
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ktrm')) // 'ktrm': item "A Lady's Belongings"
    call DestroyEffectBJ(udg_SpecialEffect[54])
    if(Trig_LadyCurse_ReturnBelongings_Cond_ShowDialogue())then
        call Cine_Enter()
        call Cam_PanToUnit(gg_unit_h01P_0017,0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Here you go. This is what you wanted back, right?",false)
        call Text_Say(gg_unit_h01P_0017,"Yes that's it. Thank you so much.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Definitely not what I expected, but now it makes sense why you were being so vague.",false)
        call Text_Say(gg_unit_h01P_0017,"I appreciate your help without asking much. It was so hard finding someone to approach about this you understand right?",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"I sure do. So the deal was that now you will curse some gear for us, right?",false)
        call Text_Say(gg_unit_h01P_0017,"Yes. So this is how it works, I will need a particular piece of gear to draw out the cursed power from, as well as a curse scroll to do so with. Curse scrolls are rare and only work on a particular piece of equipment each, but I can also craft some of them myself with Crystal Shards. I'll tell you beforehand what a curse on an item will do to it, don't worry.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Sounds good. I'll see what curses would do well.",false)
        call Reward_Give(0,$7D0,gg_unit_h01P_0017) // $7D0 = 2000
        call Text_Say(gg_unit_h01P_0017,"|n|cffffcc00Lady Curse now sells cursing scrolls.|r",true)
        call Cine_ExitAction()
    else
        call Reward_Give(0,$7D0,gg_unit_h01P_0017) // $7D0 = 2000
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cffffcc00Lady Curse now sells cursing scrolls.|r")
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Annoying Monster|r")
    call QuestSetCompletedBJ(udg_SideQuest[36],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call ReplaceUnitBJ(gg_unit_h01P_0017,'h01Q',bj_UNIT_STATE_METHOD_RELATIVE) // 'h01Q': unit "Lady Curse"
    call AddUnitToStockBJ('n0B9',gg_unit_n0BW_0094,1,1) // 'n0B9': unit "Hunt: Very Annoying Monster"
    set udg_HuntStock[4]=(udg_HuntStock[4]+1)
    call ConditionalTriggerExecute(gg_trg_Hunt_Board_Markers)
    set udg_StoryProgress=(udg_StoryProgress+1)
    call ConditionalTriggerExecute(gg_trg_QuestCount_Milestones)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_LadyCurse takes nothing returns nothing
endfunction
function RegisterR11_LadyCurse_ShowMarker takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_LadyCurse_ShowMarker=CreateTrigger()
    call DisableTrigger(gg_trg_LadyCurse_ShowMarker)
    call TriggerAddAction(gg_trg_LadyCurse_ShowMarker,function Trig_LadyCurse_ShowMarker_Actions)
endfunction
function RegisterR11_LadyCurse_ReturnBelongings takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_LadyCurse_ReturnBelongings=CreateTrigger()
    call DisableTrigger(gg_trg_LadyCurse_ReturnBelongings)
    call TriggerRegisterUnitInRangeSimple(gg_trg_LadyCurse_ReturnBelongings,450.,gg_unit_h01P_0017)
    call TriggerAddCondition(gg_trg_LadyCurse_ReturnBelongings,Condition(function Trig_LadyCurse_ReturnBelongings_Conditions))
    call TriggerAddAction(gg_trg_LadyCurse_ReturnBelongings,function Trig_LadyCurse_ReturnBelongings_Actions)
endfunction




endlibrary

library TQuestCooking requires TCam, TCine, TPlayerHero, TReward, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Quest_Cooking_Start=null
    trigger gg_trg_Quest_Cooking_Complete=null
endglobals

function Trig_Quest_Cooking_Start_Conditions takes nothing returns boolean
    return((IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(gg_unit_n0KG_0263)==false)and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Quest_Cooking_Start_PlayCookingScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Cooking_Start_CookingRank3 takes nothing returns boolean
    return(udg_CookingStage>=3)
endfunction

function Trig_Quest_Cooking_Start_CookingRank2 takes nothing returns boolean
    return(udg_CookingStage>=2)
endfunction

function Trig_Quest_Cooking_Start_CookingRank1 takes nothing returns boolean
    return(udg_CookingStage>=1)
endfunction

function Trig_Quest_Cooking_Start_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    if(Trig_Quest_Cooking_Start_PlayCookingScene())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Hmm, a lit fireplace. That gives me an idea.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"They say you can make some pretty delicious meals when you have the right ingredients.",false)
        call Text_Say(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),"Let's see if I can still remember some classic recipes...",false)
        call Cine_ExitAction()
    endif
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00Cooking Choices|r")
    set udg_SideQuest[69]=CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,(udg_QuestNamePrefix+"Cooking Choices"),"You decided to try your hand at cooking a meal at a fireplace in the Northern Mountains. Make a delicious meal!","ReplaceableTextures\\CommandButtons\\BTNFdWildBowl.blp")
    set udg_TempPoint=GetUnitLoc(gg_unit_n0KG_0263)
    call AddSpecialEffectLocBJ(udg_TempPoint,"Objects\\RandomObject\\RandomObject.mdl")
    // (BlzGetLocalSpecialEffectZ(GetLastCreatedEffectBJ())) plus (64).
    call BlzSetSpecialEffectZ(GetLastCreatedEffectBJ(),(BlzGetLocalSpecialEffectZ(GetLastCreatedEffectBJ())+64.))
    set udg_SpecialEffect[92]=GetLastCreatedEffectBJ()
    call RemoveLocation(udg_TempPoint)
    call UnitAddAbilityBJ('Aneu',gg_unit_n0KG_0263) // 'Aneu': standard ability reference "Neutral Building"
    call AddItemToStockBJ('I0B9',gg_unit_n0KG_0263,1,1) // 'I0B9': item "Recipe: Wild Bowl"
    if(Trig_Quest_Cooking_Start_CookingRank1())then
        call AddItemToStockBJ('I0CA',gg_unit_n0KG_0263,1,1) // 'I0CA': item "Recipe: Triton Pot"
        call AddItemToStockBJ('I0CB',gg_unit_n0KG_0263,1,1) // 'I0CB': item "Recipe: Tropical Dish"
        call AddItemToStockBJ('I0CC',gg_unit_n0KG_0263,1,1) // 'I0CC': item "Recipe: Fish Soup"
        call AddItemToStockBJ('I0CD',gg_unit_n0KG_0263,1,1) // 'I0CD': item "Recipe: Energy Brew"
        call AddItemToStockBJ('I0CE',gg_unit_n0KG_0263,1,1) // 'I0CE': item "Recipe: Swift Drink"
        if(Trig_Quest_Cooking_Start_CookingRank2())then
            call AddItemToStockBJ('I0CF',gg_unit_n0KG_0263,1,1) // 'I0CF': item "Recipe: Spiced Salad"
            call AddItemToStockBJ('I0CG',gg_unit_n0KG_0263,1,1) // 'I0CG': item "Recipe: Nebra Bread"
            if(Trig_Quest_Cooking_Start_CookingRank3())then
                call AddItemToStockBJ('I0CH',gg_unit_n0KG_0263,1,1) // 'I0CH': item "Recipe: First Class Meat Plate"
                call AddItemToStockBJ('I0CI',gg_unit_n0KG_0263,1,1) // 'I0CI': item "Recipe: Adamant Stew"
            endif
        endif
    endif
    call EnableTrigger(gg_trg_Quest_Cooking_Complete)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Quest_Cooking_Complete_SceneBusy takes nothing returns boolean
    return(udg_InCinematicMode)
endfunction

function Trig_Quest_Cooking_Complete_PlayMealScene takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Quest_Cooking_Complete_CookingRankZero takes nothing returns boolean
    return(udg_CookingStage<=0)
endfunction

function Trig_Quest_Cooking_Complete_Actions takes nothing returns nothing
    if(Trig_Quest_Cooking_Complete_SceneBusy())then
        call StartTimerBJ(udg_ShortDelayTimer,false,1.)
        return
    endif
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[92])
    if(Trig_Quest_Cooking_Complete_PlayMealScene())then
        call Cine_Enter()
        call Cam_PanToUnit(udg_CinematicActor,0)
        call Text_Say(udg_CinematicActor,"Phew, took some effort but this should make a good meal.",false)
        call Text_Say(udg_CinematicActor,"Self-cooked meals like these really do prepare you for battle like nothing else.",false)
        call Reward_Give(0,$7D0,udg_CinematicActor) // $7D0 = 2000
        call Text_Say(udg_CinematicActor,"Hmm? Seems like something came out of the fireplace.",false)
        call Cine_ExitAction()
    else
        call Reward_Give(0,$7D0,udg_CinematicActor) // $7D0 = 2000
    endif
    if(Trig_Quest_Cooking_Complete_CookingRankZero())then
        set udg_CookingStage=1
        call AddItemToStockBJ('I0CA',gg_unit_n0KG_0263,1,1) // 'I0CA': item "Recipe: Triton Pot"
        call AddItemToStockBJ('I0CB',gg_unit_n0KG_0263,1,1) // 'I0CB': item "Recipe: Tropical Dish"
        call AddItemToStockBJ('I0CC',gg_unit_n0KG_0263,1,1) // 'I0CC': item "Recipe: Fish Soup"
        call AddItemToStockBJ('I0CD',gg_unit_n0KG_0263,1,1) // 'I0CD': item "Recipe: Energy Brew"
        call AddItemToStockBJ('I0CE',gg_unit_n0KG_0263,1,1) // 'I0CE': item "Recipe: Swift Drink"
    endif
    set udg_TempPoint=GetRectCenter(gg_rct_694)
    call CreateItemLoc('I0BE',udg_TempPoint) // 'I0BE': item "Firewood"
    call RemoveLocation(udg_TempPoint)
    call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
    call EnableTrigger(gg_trg_Firewood_Light_Fireplace)
    call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_COMPLETED,"Quest Completed: |cffffcc00Cooking Choices|r")
    call QuestSetCompletedBJ(udg_SideQuest[69],true)
    set udg_QuestsCompleted=(udg_QuestsCompleted+1)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function InitTrig_Quest_Cooking takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Quest_Part19 (module Quest),
// which keeps the original registration order.

function Register_Quest_Cooking_Start takes nothing returns nothing
    set gg_trg_Quest_Cooking_Start=CreateTrigger()
    call TriggerRegisterUnitInRangeSimple(gg_trg_Quest_Cooking_Start,450.,gg_unit_n0KG_0263)
    call TriggerAddCondition(gg_trg_Quest_Cooking_Start,Condition(function Trig_Quest_Cooking_Start_Conditions))
    call TriggerAddAction(gg_trg_Quest_Cooking_Start,function Trig_Quest_Cooking_Start_Actions)
endfunction

function Register_Quest_Cooking_Complete takes nothing returns nothing
    set gg_trg_Quest_Cooking_Complete=CreateTrigger()
    call DisableTrigger(gg_trg_Quest_Cooking_Complete)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Quest_Cooking_Complete,udg_ShortDelayTimer)
    call TriggerAddAction(gg_trg_Quest_Cooking_Complete,function Trig_Quest_Cooking_Complete_Actions)
endfunction

endlibrary

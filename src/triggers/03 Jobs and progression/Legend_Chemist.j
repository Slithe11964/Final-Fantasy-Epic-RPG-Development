library TLegendChemist requires TCam, TCine, TForce, TGroup, TPlayerPart01, TText, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Legend_Chemist_Talk=null
endglobals

function Trig_Legend_Chemist_Talk_Conditions takes nothing returns boolean
    return(Unit_PlayersNearby(udg_TalkRange,udg_NpcUnit[$A],true,true,true)) // $A = 10
endfunction

function Trig_Legend_Chemist_Talk_Cond_WrongJobOrLevel takes nothing returns boolean
    return(GetUnitTypeId(Player_GetHero(GetTriggerPlayer()))!=udg_JobUnitType[udg_TempInteger])or(GetHeroLevel(Player_GetHero(GetTriggerPlayer()))<99)
endfunction

function Trig_Legend_Chemist_Talk_Cond_TaskLocked takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]>=2)and(Trig_Legend_Chemist_Talk_Cond_WrongJobOrLevel())
endfunction

function Trig_Legend_Chemist_Talk_Cond_PartialRecipes_Text takes nothing returns boolean
    return(udg_CookingStage==1)and(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KG_0263)>0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Legend_Chemist_Talk_Cond_PartialRecipes_Cine takes nothing returns boolean
    return(udg_CookingStage==1)and(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KG_0263)>0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Legend_Chemist_Talk_Cond_CinematicsOnTask takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Chemist_Talk_StockExtraRecipes takes nothing returns nothing
    call AddItemToStockBJ('I0CF',GetEnumUnit(),1,1) // 'I0CF': item "Recipe: Spiced Salad"
    call AddItemToStockBJ('I0CG',GetEnumUnit(),1,1) // 'I0CG': item "Recipe: Nebra Bread"
endfunction

function Trig_Legend_Chemist_Talk_Cond_HasBaseRecipes takes nothing returns boolean
    return(udg_CookingStage==1)
endfunction

function Trig_Legend_Chemist_Talk_StockAllRecipes takes nothing returns nothing
    call AddItemToStockBJ('I0CA',GetEnumUnit(),1,1) // 'I0CA': item "Recipe: Triton Pot"
    call AddItemToStockBJ('I0CB',GetEnumUnit(),1,1) // 'I0CB': item "Recipe: Tropical Dish"
    call AddItemToStockBJ('I0CC',GetEnumUnit(),1,1) // 'I0CC': item "Recipe: Fish Soup"
    call AddItemToStockBJ('I0CD',GetEnumUnit(),1,1) // 'I0CD': item "Recipe: Energy Brew"
    call AddItemToStockBJ('I0CE',GetEnumUnit(),1,1) // 'I0CE': item "Recipe: Swift Drink"
    call AddItemToStockBJ('I0CF',GetEnumUnit(),1,1) // 'I0CF': item "Recipe: Spiced Salad"
    call AddItemToStockBJ('I0CG',GetEnumUnit(),1,1) // 'I0CG': item "Recipe: Nebra Bread"
endfunction

function Trig_Legend_Chemist_Talk_Cond_NoRecipesYet takes nothing returns boolean
    return(udg_CookingStage==0)
endfunction

function Trig_Legend_Chemist_Talk_Cond_FireplaceUsable takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('Aneu',gg_unit_n0KG_0263)>0) // 'Aneu': standard ability reference "Neutral Building"
endfunction

function Trig_Legend_Chemist_Talk_Cond_RecipesNotGranted takes nothing returns boolean
    return(udg_CookingStage<2)
endfunction

function Trig_Legend_Chemist_Talk_Cond_CinematicsOnIntro takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Legend_Chemist_Talk_Cond_FirstVisit takes nothing returns boolean
    return(udg_QuestStage[udg_TempInteger]==2)
endfunction

function Trig_Legend_Chemist_Talk_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_TempInteger=$A // $A = 10
    if(Trig_Legend_Chemist_Talk_Cond_TaskLocked())then
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call DisplayTimedTextToForce(udg_TempForce,15.,((GetHeroProperName(GetTriggerUnit())+": You need to be |cffffcc00Ultimate Master ")+(udg_JobName[udg_TempInteger]+"|r to take on my task.")))
        call DestroyForce(udg_TempForce)
        return
    endif
    call DestroyEffectBJ(udg_LegendMarker[udg_TempInteger])
    set udg_QuestStage[udg_TempInteger]=(udg_QuestStage[udg_TempInteger]+1)
    if(Trig_Legend_Chemist_Talk_Cond_FirstVisit())then
        if(Trig_Legend_Chemist_Talk_Cond_CinematicsOnIntro())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(udg_NpcUnit[$A],"Hail and well met, adventurers. I am Quina, the Legendary Chemist.",false) // $A = 10
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"So you are. Do you have any advice to give to a budding Chemist?",false)
            call Text_Say(udg_NpcUnit[$A],"In reality, not much. For you see, this title of Legendary Chemist is mine not for combat prowess, but for my skills as a chef.",false) // $A = 10
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"... as a chef? What?",false)
            call Text_Say(udg_NpcUnit[$A],"You heard correct. After all, there is no greater form of applied chemistry than cooking, is there?",false) // $A = 10
            call Text_Say(udg_NpcUnit[$A],"If there is but one advice I can give you it's to hone your cooking skills. A good meal will prepare you well for any battle, and as a Chemist, meals used by you are still more effective - not only will they heal more, but the buffs will also last longer.",false) // $A = 10
            call Text_Say(udg_NpcUnit[$A],"A good cook will prepare any warrior for battle even better than a Priest or Oracle can. Wield your advantages wisely.",false) // $A = 10
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"That's certainly a unique take on being a Chemist. But thanks.",false)
            call Cine_ExitAction()
        endif
    else
        if(Trig_Legend_Chemist_Talk_Cond_CinematicsOnTask())then
            call Cine_Enter()
            call Cam_PanToUnit(GetTriggerUnit(),0)
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Alright Quina. As the Legendary Chemist, what would you have us do to prove ourselves?",false)
            call Text_Say(udg_NpcUnit[$A],"Do you really need to ask? You need to cook some delicious food.",false) // $A = 10
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"... are you serious?",false)
            call Text_Say(udg_NpcUnit[$A],"Most certainly. Surely you already know the powers that food can bring. But did you realize that there's food that can bestow not just one, but two buffs at once?",false) // $A = 10
            call Text_Say(Player_GetHero(GetTriggerPlayer()),"Oh, is there? I wasn't aware. That does sound powerful.",false)
            call Text_Say(udg_NpcUnit[$A],"All you need to do is make one of these dishes. I will add some recipes to your repertoire. Surely this will be easy doing for an adventurer such as yourself.",false) // $A = 10
            if(Trig_Legend_Chemist_Talk_Cond_PartialRecipes_Cine())then
                call Text_Say(udg_NpcUnit[$A],"|n|cffffcc00You can now cook Spiced Salad and Nebra Bread at lit Fireplaces.|r",true) // $A = 10
            endif
            call Cine_ExitAction()
        else
            if(Trig_Legend_Chemist_Talk_Cond_PartialRecipes_Text())then
                call DisplayTimedTextToForce(GetPlayersAll(),10.,"|cffffcc00You can now cook Spiced Salad and Nebra Bread at lit Fireplaces.|r")
            endif
        endif
        if(Trig_Legend_Chemist_Talk_Cond_RecipesNotGranted())then
            if(Trig_Legend_Chemist_Talk_Cond_FireplaceUsable())then
                set udg_TempGroup=Group_UnitsOfType('n0KG') // 'n0KG': unit "Fireplace"
                if(Trig_Legend_Chemist_Talk_Cond_NoRecipesYet())then
                    call ForGroupBJ(udg_TempGroup,function Trig_Legend_Chemist_Talk_StockAllRecipes)
                else
                    if(Trig_Legend_Chemist_Talk_Cond_HasBaseRecipes())then
                        call ForGroupBJ(udg_TempGroup,function Trig_Legend_Chemist_Talk_StockExtraRecipes)
                    endif
                endif
                call DestroyGroup(udg_TempGroup)
            endif
            set udg_CookingStage=2
        endif
    endif
    call StartTimerBJ(udg_UnitUpdateTimer,false,1.)
endfunction

function InitTrig_Legend_Chemist takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Legend (module Legend),
// which keeps the original registration order.

function Register_Legend_Chemist_Talk takes nothing returns nothing
    set gg_trg_Legend_Chemist_Talk=CreateTrigger()
    call DisableTrigger(gg_trg_Legend_Chemist_Talk)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Legend_Chemist_Talk,Player(7),true)
    call TriggerAddCondition(gg_trg_Legend_Chemist_Talk,Condition(function Trig_Legend_Chemist_Talk_Conditions))
    call TriggerAddAction(gg_trg_Legend_Chemist_Talk,function Trig_Legend_Chemist_Talk_Actions)
endfunction

endlibrary

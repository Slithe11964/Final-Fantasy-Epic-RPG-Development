library TSpring requires TCam, TCine, TForce, TJob, TLoc, TWait
function Trig_Spring_Of_Life_Ritual_Conditions takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())!='H01D') // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_HasJobIndex takes nothing returns boolean
    return(udg_TempInteger>=0)or(GetUnitName(GetTriggerUnit())=="Freelancer")
endfunction

function Trig_Spring_Of_Life_Ritual_Filter_ActiveAlly takes nothing returns boolean
    return(IsPlayerInForce(GetFilterPlayer(),udg_PlayingPlayers))
endfunction

function Trig_Spring_Of_Life_Ritual_Filter_NotSelfOwner takes nothing returns boolean
    return(GetFilterPlayer()!=GetOwningPlayer(GetTriggerUnit()))
endfunction

function Trig_Spring_Of_Life_Ritual_Filter_OtherActiveA takes nothing returns boolean
    return GetBooleanAnd(Trig_Spring_Of_Life_Ritual_Filter_ActiveAlly(),Trig_Spring_Of_Life_Ritual_Filter_NotSelfOwner())
endfunction

function Trig_Spring_Of_Life_Ritual_Filter_ActiveAlly2 takes nothing returns boolean
    return(IsPlayerInForce(GetFilterPlayer(),udg_PlayingPlayers))
endfunction

function Trig_Spring_Of_Life_Ritual_Filter_NotSelfOwner2 takes nothing returns boolean
    return(GetFilterPlayer()!=GetOwningPlayer(GetTriggerUnit()))
endfunction

function Trig_Spring_Of_Life_Ritual_Filter_OtherActiveB takes nothing returns boolean
    return GetBooleanAnd(Trig_Spring_Of_Life_Ritual_Filter_ActiveAlly2(),Trig_Spring_Of_Life_Ritual_Filter_NotSelfOwner2())
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_RitualCineOn takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_HasSpareCrystal takes nothing returns boolean
    return(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0B7'))>=2) // 'I0B7': item "Grand Crystal"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_NotHardMode takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_CheaterForce)==false)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_SpecialTaskPending takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[udg_TempInteger])==false)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_PromotionPending takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_QuestForce[udg_TempInteger])==false)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_LacksGrandCrystal takes nothing returns boolean
    return(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0B7')==false) // 'I0B7': item "Grand Crystal"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_NotUltimateMaster takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())<3) // 'A02F': ability "Mastery"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_AllMageJobsMastered takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[47])==false)and(Job_GetSavedLevel(udg_TempPlayer,'H002')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H004')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H005')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H009')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H008')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00G')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00I')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00H')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00J')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00L')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H02Y')>='d') // 'H002': unit "Chemist"; 'H004': unit "Wizard"; 'H005': unit "Priest"; 'H009': unit "Summoner"; 'H008': unit "Time Mage"; 'H00G': unit "Mediator"; 'H00I': unit "Oracle"; 'H00H': unit "Calculator"; 'H00J': unit "Prophet"; 'H00L': unit "Sorcerer"; 'H02Y': unit "Necromancer"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_MageMasterUnclaimed takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[46])==false)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_IsMageJob takes nothing returns boolean
    return(udg_TempInteger>=$A)and(udg_TempInteger!=22) // $A = 10
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_AllWarriorJobsMastered takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[45])==false)and(Job_GetSavedLevel(udg_TempPlayer,'H000')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H003')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H001')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00A')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00B')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00C')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00D')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00E')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00F')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H00M')>='d')and(Job_GetSavedLevel(udg_TempPlayer,'H02X')>='d') // 'H000': unit "Squire"; 'H003': unit "Knight"; 'H001': unit "Archer"; 'H00A': unit "Monk"; 'H00B': unit "Thief"; 'H00C': unit "Lancer"; 'H00D': unit "Geomancer"; 'H00E': unit "Samurai"; 'H00F': unit "Ninja"; 'H00M': unit "Holy Swordsman"; 'H02X': unit "Dark Knight"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_WarriorMasterUnclaimed takes nothing returns boolean
    return(IsPlayerInForce(udg_TempPlayer,udg_TitleForce[44])==false)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_IsWarriorJob takes nothing returns boolean
    return(udg_TempInteger<=9)or(udg_TempInteger==20)
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_IsWarriorJobWrap takes nothing returns boolean
    return(Trig_Spring_Of_Life_Ritual_Cond_IsWarriorJob())
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_AllJobsMastered takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[45]))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_TitleForce[47]))and(GetUnitAbilityLevelSwapped('A02F',udg_FreelancerHero[GetConvertedPlayerId(udg_TempPlayer)])>=4) // 'A02F': ability "Mastery"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_RitualReady takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[udg_TempInteger]))and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_QuestForce[udg_TempInteger]))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0B7')) // 'A02F': ability "Mastery"; 'I0B7': item "Grand Crystal"
endfunction

function Trig_Spring_Of_Life_Ritual_Cond_EligibleHero takes nothing returns boolean
    return((Trig_Spring_Of_Life_Ritual_Cond_HasJobIndex())and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(udg_InCinematicMode==false))!=null
endfunction

function Trig_Spring_Of_Life_Ritual_Actions takes nothing returns nothing
    set udg_TempInteger=Job_GetIndex(GetTriggerUnit())
    if(Trig_Spring_Of_Life_Ritual_Cond_EligibleHero())then
        if(Trig_Spring_Of_Life_Ritual_Cond_RitualReady())then
            call DisableTrigger(GetTriggeringTrigger())
            if(Trig_Spring_Of_Life_Ritual_Cond_RitualCineOn())then
                call Cine_Enter()
                call Cam_PanToUnit(GetTriggerUnit(),0)
                call Wait_Polled(1.)
                set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=4
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    // (90) times (loop counter A treated as a decimal-capable number).
                    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,(90.*I2R(GetForLoopIndexA())))
                    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    call RemoveLocation(udg_TempPoint)
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                call RemoveLocation(udg_TempPoint2)
                call Wait_Polled(1.)
                set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=4
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    // (45) plus ((90) times (loop counter A treated as a decimal-capable number)).
                    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,(45.+(90.*I2R(GetForLoopIndexA()))))
                    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    call RemoveLocation(udg_TempPoint)
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                call RemoveLocation(udg_TempPoint2)
                call Wait_Polled(1.)
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call PlaySoundBJ(gg_snd_003)
                set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                call DisplayTimedTextToForce(udg_TempForce,30,("Congratulations, you are now |cfffee101Legendary Master|r "+("|cff00ff00"+(GetUnitName(GetTriggerUnit())+"|r"))))
                call DestroyForce(udg_TempForce)
                set udg_TempForce=Force_Matching(Condition(function Trig_Spring_Of_Life_Ritual_Filter_OtherActiveB))
                call DisplayTimedTextToForce(udg_TempForce,30,(("|cff0000a0"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r is now |cfffee101Legendary Master|r "+GetUnitName(GetTriggerUnit()))))
                call DestroyForce(udg_TempForce)
                call Wait_Polled(2)
                call Cine_ExitAction()
            else
                call PauseUnitBJ(true,GetTriggerUnit())
                set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=4
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    // (90) times (loop counter A treated as a decimal-capable number).
                    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,(90.*I2R(GetForLoopIndexA())))
                    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    call RemoveLocation(udg_TempPoint)
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                call RemoveLocation(udg_TempPoint2)
                call Wait_Polled(1.)
                set udg_TempPoint2=GetUnitLoc(GetTriggerUnit())
                set bj_forLoopAIndex=1
                set bj_forLoopAIndexEnd=4
                loop
                    exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
                    // (45) plus ((90) times (loop counter A treated as a decimal-capable number)).
                    set udg_TempPoint=Loc_PolarOffset(udg_TempPoint2,256,(45.+(90.*I2R(GetForLoopIndexA()))))
                    call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                    call DestroyEffectBJ(GetLastCreatedEffectBJ())
                    call RemoveLocation(udg_TempPoint)
                    set bj_forLoopAIndex=bj_forLoopAIndex+1
                endloop
                call RemoveLocation(udg_TempPoint2)
                call Wait_Polled(1.)
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Other\\Awaken\\Awaken.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl")
                call DestroyEffectBJ(GetLastCreatedEffectBJ())
                call PlaySoundBJ(gg_snd_003)
                set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
                call DisplayTimedTextToForce(udg_TempForce,30,("Congratulations, you are now |cfffee101Legendary Master|r "+("|cff00ff00"+(GetUnitName(GetTriggerUnit())+"|r"))))
                call DestroyForce(udg_TempForce)
                set udg_TempForce=Force_Matching(Condition(function Trig_Spring_Of_Life_Ritual_Filter_OtherActiveA))
                call DisplayTimedTextToForce(udg_TempForce,30,(("|cff0000a0"+udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+("|r is now |cfffee101Legendary Master|r "+GetUnitName(GetTriggerUnit()))))
                call DestroyForce(udg_TempForce)
                call PauseUnitBJ(false,GetTriggerUnit())
            endif
            call ForceRemovePlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[udg_TempInteger])
            call ForceRemovePlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_QuestForce[udg_TempInteger])
            if(Trig_Spring_Of_Life_Ritual_Cond_HasSpareCrystal())then
                // (item charges of GetItemOfTypeFromUnitBJ(the triggering unit, 'I0B7')) minus (1).
                call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0B7'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0B7'))-1)) // 'I0B7': item "Grand Crystal"
            else
                call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0B7')) // 'I0B7': item "Grand Crystal"
            endif
            call SetUnitAbilityLevelSwapped('A02F',GetTriggerUnit(),4) // 'A02F': ability "Mastery"
            set udg_TotalJobLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_TotalJobLevel[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
            if(Trig_Spring_Of_Life_Ritual_Cond_NotHardMode())then
                call ModifyHeroStat(bj_HEROSTAT_STR,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,50)
                call ModifyHeroStat(bj_HEROSTAT_AGI,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,50)
                call ModifyHeroStat(bj_HEROSTAT_INT,GetTriggerUnit(),bj_MODIFYMETHOD_ADD,50)
            endif
            set udg_TempPoint=GetRectCenter(gg_rct_674)
            call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,270.)
            call RemoveLocation(udg_TempPoint)
            call StartTimerBJ(udg_UnitUpdateTimer,false,.2)
            set udg_TempPlayer=GetOwningPlayer(GetTriggerUnit())
            set udg_TempInteger=Job_GetIndex(GetTriggerUnit())
            if(Trig_Spring_Of_Life_Ritual_Cond_IsWarriorJobWrap())then
                if(Trig_Spring_Of_Life_Ritual_Cond_WarriorMasterUnclaimed())then
                    set udg_TempPoint=GetUnitLoc(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                    call CreateItemLoc('I0LL',udg_TempPoint) // 'I0LL': item "Celestium"
                    call RemoveLocation(udg_TempPoint)
                    call SetItemUserData(GetLastCreatedItem(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
                    call UnitAddItemSwapped(GetLastCreatedItem(),udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                    call UnitAddItemSwapped(GetLastCreatedItem(),GetTriggerUnit())
                    set udg_TempInteger=44
                    call ConditionalTriggerExecute(gg_trg_Title_Grant)
                else
                    if(Trig_Spring_Of_Life_Ritual_Cond_AllWarriorJobsMastered())then
                        set udg_TempInteger=45
                        call ConditionalTriggerExecute(gg_trg_Title_Grant)
                    endif
                endif
            else
                if(Trig_Spring_Of_Life_Ritual_Cond_IsMageJob())then
                    if(Trig_Spring_Of_Life_Ritual_Cond_MageMasterUnclaimed())then
                        set udg_TempPoint=GetUnitLoc(udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                        call CreateItemLoc('I0LL',udg_TempPoint) // 'I0LL': item "Celestium"
                        call RemoveLocation(udg_TempPoint)
                        call SetItemUserData(GetLastCreatedItem(),GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
                        call UnitAddItemSwapped(GetLastCreatedItem(),udg_SpiritOfGaya[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                        call UnitAddItemSwapped(GetLastCreatedItem(),GetTriggerUnit())
                        set udg_TempInteger=46
                        call ConditionalTriggerExecute(gg_trg_Title_Grant)
                    else
                        if(Trig_Spring_Of_Life_Ritual_Cond_AllMageJobsMastered())then
                            set udg_TempInteger=47
                            call ConditionalTriggerExecute(gg_trg_Title_Grant)
                        endif
                    endif
                endif
            endif
            if(Trig_Spring_Of_Life_Ritual_Cond_AllJobsMastered())then
                set udg_TempInteger=48
                call ConditionalTriggerExecute(gg_trg_Title_Grant)
            endif
            call EnableTrigger(GetTriggeringTrigger())
        else
            set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
            call DisplayTimedTextToForce(udg_TempForce,15.,"You cannot yet enter the Spring of Life...")
            if(Trig_Spring_Of_Life_Ritual_Cond_NotUltimateMaster())then
                call DisplayTimedTextToForce(udg_TempForce,15.,"You have yet to reach Ultimate Master.")
            else
                if(Trig_Spring_Of_Life_Ritual_Cond_SpecialTaskPending())then
                    call DisplayTimedTextToForce(udg_TempForce,15.,"You have yet to clear your Special Task...")
                endif
                if(Trig_Spring_Of_Life_Ritual_Cond_PromotionPending())then
                    call DisplayTimedTextToForce(udg_TempForce,15.,"You have yet to clear your Promotion Battle...")
                endif
                if(Trig_Spring_Of_Life_Ritual_Cond_LacksGrandCrystal())then
                    call DisplayTimedTextToForce(udg_TempForce,15.,"Only one who carries a Grand Crystal may enter to fulfill the ritual...")
                endif
            endif
            call DestroyForce(udg_TempForce)
            set udg_TempPoint=GetRectCenter(gg_rct_674)
            call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,270.)
            call RemoveLocation(udg_TempPoint)
        endif
    else
        set udg_TempPoint=GetRectCenter(gg_rct_674)
        call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,270.)
        call RemoveLocation(udg_TempPoint)
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Spring takes nothing returns nothing
endfunction
function RegisterR11_Spring_Of_Life_Ritual takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Spring_Of_Life_Ritual=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Spring_Of_Life_Ritual,gg_rct_673)
    call TriggerAddCondition(gg_trg_Spring_Of_Life_Ritual,Condition(function Trig_Spring_Of_Life_Ritual_Conditions))
    call TriggerAddAction(gg_trg_Spring_Of_Life_Ritual,function Trig_Spring_Of_Life_Ritual_Actions)
endfunction




endlibrary

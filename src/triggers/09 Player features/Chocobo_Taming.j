library TChocoboTaming requires TForce, TGroup, TMusic
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Chocobo_Tame_Limit=null
    trigger gg_trg_Chocobo_Tame_Breed=null
endglobals

function Trig_Chocobo_Tame_Limit_Conditions takes nothing returns boolean
    return(GetAbilityName(GetSpellAbilityId())=="Chocobo Tame")
endfunction

function Trig_Chocobo_Tame_Limit_Filter_IsChocobo takes nothing returns boolean
    return(GetUnitName(GetFilterUnit())=="Chocobo")
endfunction

function Trig_Chocobo_Tame_Limit_Filter_IsAlive takes nothing returns boolean
    return(IsUnitAliveBJ(GetFilterUnit()))
endfunction

function Trig_Chocobo_Tame_Limit_Filter_LiveChocobo takes nothing returns boolean
    return GetBooleanAnd(Trig_Chocobo_Tame_Limit_Filter_IsChocobo(),Trig_Chocobo_Tame_Limit_Filter_IsAlive())
endfunction

function Trig_Chocobo_Tame_Limit_HasMaxChocobos takes nothing returns boolean
    return(CountUnitsInGroup(udg_TempGroup)>=5)
endfunction

function Trig_Chocobo_Tame_Limit_Actions takes nothing returns nothing
    set udg_TempGroup=Group_UnitsOfPlayer(GetOwningPlayer(GetTriggerUnit()),Condition(function Trig_Chocobo_Tame_Limit_Filter_LiveChocobo))
    if(Trig_Chocobo_Tame_Limit_HasMaxChocobos())then
        call DestroyGroup(udg_TempGroup)
        set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
        call DisplayTimedTextToForce(udg_TempForce,10.,"You may not have more than 5 chocobos at a time!")
        call DestroyForce(udg_TempForce)
        call PauseUnitBJ(true,GetTriggerUnit())
        call IssueImmediateOrderBJ(GetTriggerUnit(),"stop")
        call PauseUnitBJ(false,GetTriggerUnit())
    else
        call DestroyGroup(udg_TempGroup)
    endif
endfunction

function Trig_Chocobo_Tame_Breed_Conditions takes nothing returns boolean
    return(GetAbilityName(GetSpellAbilityId())=="Chocobo Tame")
endfunction

function Trig_Chocobo_Tame_Breed_HasSpellTarget takes nothing returns boolean
    return(GetSpellTargetUnit()!=null)
endfunction

function Trig_Chocobo_Tame_Breed_IsZeioNut takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CV') // 'A0CV': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsCarobNut takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CU') // 'A0CU': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsLuchilNut takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CT') // 'A0CT': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsNotPramNut takes nothing returns boolean
    return(GetSpellAbilityId()!='A0A8') // 'A0A8': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsChocoboTooHighLevel takes nothing returns boolean
    return(GetUnitLevel(GetSpellTargetUnit())>=(udg_TempInteger+29))
endfunction

function Trig_Chocobo_Tame_Breed_TameRollSucceeds takes nothing returns boolean
    // A random whole number from udg_TempInteger through (udg_TempInteger) plus (29).
    return(udg_TempInteger>GetUnitLevel(GetSpellTargetUnit()))or(GetRandomInt(udg_TempInteger,(udg_TempInteger+29))>GetUnitLevel(GetSpellTargetUnit()))
endfunction

function Trig_Chocobo_Tame_Breed_TameFlagUnset takes nothing returns boolean
    return(LoadIntegerBJ(2,20,udg_GameStateHash)<=0)
endfunction

function Trig_Chocobo_Tame_Breed_TameSucceeded takes nothing returns boolean
    return(Trig_Chocobo_Tame_Breed_TameRollSucceeds())
endfunction

function Trig_Chocobo_Tame_Breed_Filter_IsChocobo takes nothing returns boolean
    return(GetUnitName(GetFilterUnit())=="Chocobo")
endfunction

function Trig_Chocobo_Tame_Breed_Filter_IsPlayerOwned takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetFilterUnit()),udg_PlayingPlayers))
endfunction

function Trig_Chocobo_Tame_Breed_Filter_NotSpellTarget takes nothing returns boolean
    return(GetSpellTargetUnit()!=GetFilterUnit())
endfunction

function Trig_Chocobo_Tame_Breed_Filter_PlayerNotTarget takes nothing returns boolean
    return GetBooleanAnd(Trig_Chocobo_Tame_Breed_Filter_IsPlayerOwned(),Trig_Chocobo_Tame_Breed_Filter_NotSpellTarget())
endfunction

function Trig_Chocobo_Tame_Breed_Filter_BreedPartner takes nothing returns boolean
    return GetBooleanAnd(Trig_Chocobo_Tame_Breed_Filter_IsChocobo(),Trig_Chocobo_Tame_Breed_Filter_PlayerNotTarget())
endfunction

function Trig_Chocobo_Tame_Breed_NoPartnerFound takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_TempGroup))
endfunction

function Trig_Chocobo_Tame_Breed_IsZeioNutAgain takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CV') // 'A0CV': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsCarobNutAgain takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CU') // 'A0CU': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsLuchilNutAgain takes nothing returns boolean
    return(GetSpellAbilityId()=='A0CT') // 'A0CT': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsBreedScore12Plus takes nothing returns boolean
    return(udg_ChocoboAbilityIndex>=$C) // $C = 12
endfunction

function Trig_Chocobo_Tame_Breed_IsBreedScore14 takes nothing returns boolean
    return(udg_ChocoboAbilityIndex==$E) // $E = 14
endfunction

function Trig_Chocobo_Tame_Breed_IsBreedScore15 takes nothing returns boolean
    return(udg_ChocoboAbilityIndex==$F) // $F = 15
endfunction

function Trig_Chocobo_Tame_Breed_AbilityNotQuickJoin takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=3)
endfunction

function Trig_Chocobo_Tame_Breed_AbilityNotSprint takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=5)
endfunction

function Trig_Chocobo_Tame_Breed_AbilityNotAttack takes nothing returns boolean
    return(udg_ChocoboAbilityIndex!=$F) // $F = 15
endfunction

function Trig_Chocobo_Tame_Breed_IsTargetOwnedByCaster takes nothing returns boolean
    return(GetOwningPlayer(GetSpellTargetUnit())!=Player($B))and(GetOwningPlayer(GetSpellTargetUnit())==GetOwningPlayer(GetTriggerUnit())) // $B = 11
endfunction

function Trig_Chocobo_Tame_Breed_IsNotPramNutAgain takes nothing returns boolean
    return(GetSpellAbilityId()!='A0A8') // 'A0A8': ability "Chocobo Tame"
endfunction

function Trig_Chocobo_Tame_Breed_IsTargetWild takes nothing returns boolean
    return(GetOwningPlayer(GetSpellTargetUnit())==Player(8))
endfunction

function Trig_Chocobo_Tame_Breed_IsChocoboUnitType takes nothing returns boolean
    return(GetUnitTypeId(GetSpellTargetUnit())=='n02J')or(GetUnitTypeId(GetSpellTargetUnit())=='n02S')or(GetUnitTypeId(GetSpellTargetUnit())=='n02T')or(GetUnitTypeId(GetSpellTargetUnit())=='n02U')or(GetUnitTypeId(GetSpellTargetUnit())=='n035')or(GetUnitTypeId(GetSpellTargetUnit())=='n036')or(GetUnitTypeId(GetSpellTargetUnit())=='n037')or(GetUnitTypeId(GetSpellTargetUnit())=='n038') // 'n02J': unit "Chocobo"; 'n02S': unit "Chocobo"; 'n02T': unit "Chocobo"; 'n02U': unit "Chocobo"; 'n035': unit "Chocobo"; 'n036': unit "Chocobo"; 'n037': unit "Chocobo"; 'n038': unit "Chocobo"
endfunction

function Trig_Chocobo_Tame_Breed_IsTameableChocobo takes nothing returns boolean
    return(Trig_Chocobo_Tame_Breed_IsChocoboUnitType())
endfunction

function Trig_Chocobo_Tame_Breed_IsBoco takes nothing returns boolean
    return(GetSpellTargetUnit()==gg_unit_n00E_0138)
endfunction

function Trig_Chocobo_Tame_Breed_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Chocobo_Tame_Breed_IsBoco())then
        call DisplayTimedTextToForce(l_tempForce,10.,"You cannot tame Boco! He has already been tamed by Ao Madoushi.")
    else
        if(Trig_Chocobo_Tame_Breed_IsTameableChocobo())then
            if(Trig_Chocobo_Tame_Breed_IsTargetWild())then
                set udg_TempInteger=1
                if(Trig_Chocobo_Tame_Breed_IsNotPramNut())then
                    if(Trig_Chocobo_Tame_Breed_IsLuchilNut())then
                        set udg_TempInteger=21
                    else
                        if(Trig_Chocobo_Tame_Breed_IsCarobNut())then
                            set udg_TempInteger=31
                        else
                            if(Trig_Chocobo_Tame_Breed_IsZeioNut())then
                                set udg_TempInteger='d'
                            endif
                        endif
                    endif
                endif
                if(Trig_Chocobo_Tame_Breed_TameSucceeded())then
                    call Music_SetTrack(46)
                    call DisplayTimedTextToForce(l_tempForce,10.,"Successfully tamed the Chocobo!")
                    call GroupRemoveUnitSimple(GetSpellTargetUnit(),udg_TownNpcUnits)
                    call SetUnitOwner(GetSpellTargetUnit(),GetOwningPlayer(GetTriggerUnit()),true)
                    call UnitRemoveAbilityBJ('Awan',GetSpellTargetUnit()) // 'Awan': object name not found in map data
                    call SetUnitMoveSpeed(GetSpellTargetUnit(),GetRandomReal((GetUnitMoveSpeed(GetSpellTargetUnit())-20.),(GetUnitMoveSpeed(GetSpellTargetUnit())+20.)))
                    call UnitRemoveAbilityBJ('A0AB',GetSpellTargetUnit()) // 'A0AB': ability "Choco-Shell"
                    call UnitRemoveAbilityBJ('A0U0',GetSpellTargetUnit()) // 'A0U0': ability "Choco-Shell"
                    call UnitRemoveAbilityBJ('A0AA',GetSpellTargetUnit()) // 'A0AA': ability "Choco-Protect"
                    call UnitAddAbilityBJ('S005',GetSpellTargetUnit()) // 'S005': ability "Chocobo Ride"
                    call UnitAddAbilityBJ('S006',GetSpellTargetUnit()) // 'S006': ability "Start Chocobo Riding"
                    call UnitAddAbilityBJ('S007',GetSpellTargetUnit()) // 'S007': ability "Stop Chocobo Ride"
                    call UnitAddAbilityBJ('A04F',GetSpellTargetUnit()) // 'A04F': ability "Join Fast"
                    call CreateTextTagUnitBJ("Wark, wark!",GetTriggerUnit(),0,11.,'d',100.,100.,0)
                    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
                    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),5)
                    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),3.5)
                    if(Trig_Chocobo_Tame_Breed_TameFlagUnset())then
                        call SaveIntegerBJ(1,2,20,udg_GameStateHash)
                    endif
                else
                    if(Trig_Chocobo_Tame_Breed_IsChocoboTooHighLevel())then
                        call DisplayTimedTextToForce(l_tempForce,10.,"The chocobo eats the nut, but does not appear to be impressed with the type of nut you fed it.")
                    else
                        call DisplayTimedTextToForce(l_tempForce,10.,"The chocobo eats the nut with pleasure, but does not react otherwise.")
                    endif
                endif
            else
                if(Trig_Chocobo_Tame_Breed_IsNotPramNutAgain())then
                    if(Trig_Chocobo_Tame_Breed_IsTargetOwnedByCaster())then
                        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
                        set udg_TempGroup=Group_UnitsInRangeOfLoc(512,udg_TempPoint,Condition(function Trig_Chocobo_Tame_Breed_Filter_BreedPartner))
                        if(Trig_Chocobo_Tame_Breed_NoPartnerFound())then
                            call RemoveLocation(udg_TempPoint)
                            call DestroyGroup(udg_TempGroup)
                            call DisplayTimedTextToForce(l_tempForce,10.,"There is no partner within 512m range of the chocobo! But the chocobo still eats the nut with pleasure.")
                            set l_tempForce=null
                            return
                        endif
                        set udg_BreedPartnerChocobo=GroupPickRandomUnit(udg_TempGroup)
                        call DestroyGroup(udg_TempGroup)
                        call SetUnitPositionLocFacingLocBJ(udg_BreedPartnerChocobo,udg_TempPoint,udg_TempPoint)
                        set udg_BreedTargetChocobo=GetSpellTargetUnit()
                        if(Trig_Chocobo_Tame_Breed_IsLuchilNutAgain())then
                            set udg_ChocoboAbilityIndex=1
                        else
                            if(Trig_Chocobo_Tame_Breed_IsCarobNutAgain())then
                                set udg_ChocoboAbilityIndex=2
                            else
                                if(Trig_Chocobo_Tame_Breed_IsZeioNutAgain())then
                                    set udg_ChocoboAbilityIndex=3
                                endif
                            endif
                        endif
                        call ConditionalTriggerExecute(gg_trg_Chocobo_Breed_Score)
                        call CreateTextTagLocBJ("Wark, wark, wark, wark-kkk!",udg_TempPoint,0,11.,'d','d','d',0)
                        call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
                        call SetTextTagLifespanBJ(GetLastCreatedTextTag(),3.5)
                        call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
                        if(Trig_Chocobo_Tame_Breed_IsBreedScore15())then
                            call CreateNUnitsAtLoc(1,'n038',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetRandomDirectionDeg()) // 'n038': unit "Chocobo"
                            call UnitAddAbilityBJ('A0K8',GetLastCreatedUnit()) // 'A0K8': ability "Chocobo Tech Copy"
                            call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastCreatedUnit())
                            call SetUnitAbilityLevelSwapped(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastCreatedUnit(),$B) // $B = 11
                        else
                            if(Trig_Chocobo_Tame_Breed_IsBreedScore14())then
                                call CreateNUnitsAtLoc(1,'n037',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetRandomDirectionDeg()) // 'n037': unit "Chocobo"
                                call UnitAddAbilityBJ('A0K8',GetLastCreatedUnit()) // 'A0K8': ability "Chocobo Tech Copy"
                                call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastCreatedUnit())
                                call SetUnitAbilityLevelSwapped(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastCreatedUnit(),6)
                            else
                                if(Trig_Chocobo_Tame_Breed_IsBreedScore12Plus())then
                                    call CreateNUnitsAtLoc(1,'n036',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetRandomDirectionDeg()) // 'n036': unit "Chocobo"
                                else
                                    call CreateNUnitsAtLoc(1,'n035',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,GetRandomDirectionDeg()) // 'n035': unit "Chocobo"
                                endif
                                call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetLastCreatedUnit())
                            endif
                        endif
                        call RemoveLocation(udg_TempPoint)
                        if(Trig_Chocobo_Tame_Breed_AbilityNotQuickJoin())then
                            call UnitAddAbilityBJ('A04F',GetLastCreatedUnit()) // 'A04F': ability "Join Fast"
                        endif
                        if(Trig_Chocobo_Tame_Breed_AbilityNotSprint())then
                            call UnitAddAbilityBJ('A0A4',GetLastCreatedUnit()) // 'A0A4': ability "Chocobo Sprint"
                        endif
                        if(Trig_Chocobo_Tame_Breed_AbilityNotAttack())then
                            call UnitAddAbilityBJ('Abun',GetLastCreatedUnit()) // 'Abun': object name not found in map data
                        endif
                        call UnitAddAbilityBJ('S005',GetLastCreatedUnit()) // 'S005': ability "Chocobo Ride"
                        call UnitAddAbilityBJ('S006',GetLastCreatedUnit()) // 'S006': ability "Start Chocobo Riding"
                        call UnitAddAbilityBJ('S007',GetLastCreatedUnit()) // 'S007': ability "Stop Chocobo Ride"
                        call DisplayTimedTextToForce(l_tempForce,15.,"The chocobos have bred and a |cffffcc00new chocobo|r is born!")
                        call DisplayTimedTextToForce(l_tempForce,15.,("The new chocobo has gained special ability: |cffffcc00"+(GetAbilityName(udg_ChocoboAbility[udg_ChocoboAbilityIndex])+"|r!")))
                    else
                        call DisplayTimedTextToForce(l_tempForce,10.,"This chocobo cannot be tamed.")
                    endif
                else
                    call DisplayTimedTextToForce(l_tempForce,10.,"This chocobo cannot be tamed.")
                endif
            endif
        else
            if(Trig_Chocobo_Tame_Breed_HasSpellTarget())then
                call DisplayTimedTextToForce(l_tempForce,10.,"The target is not a tameable chocobo!")
            endif
        endif
    endif
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

function InitTrig_Chocobo_Taming takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Chocobo_Part1 (module Chocobo),
// which keeps the original registration order.

function Register_Chocobo_Tame_Limit takes nothing returns nothing
    set gg_trg_Chocobo_Tame_Limit=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Tame_Limit,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_Chocobo_Tame_Limit,Condition(function Trig_Chocobo_Tame_Limit_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Tame_Limit,function Trig_Chocobo_Tame_Limit_Actions)
endfunction

function Register_Chocobo_Tame_Breed takes nothing returns nothing
    set gg_trg_Chocobo_Tame_Breed=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Chocobo_Tame_Breed,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Chocobo_Tame_Breed,Condition(function Trig_Chocobo_Tame_Breed_Conditions))
    call TriggerAddAction(gg_trg_Chocobo_Tame_Breed,function Trig_Chocobo_Tame_Breed_Actions)
endfunction

endlibrary

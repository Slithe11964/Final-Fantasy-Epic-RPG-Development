library TChocoboTechCopy requires TForce, TPlayerPart01
function Trig_Chocobo_TechCopy_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0K8')and(GetUnitName(GetTriggerUnit())=="Chocobo")and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers)) // 'A0K8': ability "Chocobo Tech Copy"
endfunction

function Trig_Chocobo_TechCopy_TargetNotOwnedChocobo takes nothing returns boolean
    return(GetUnitName(GetSpellTargetUnit())!="Chocobo")or(IsPlayerInForce(GetOwningPlayer(GetSpellTargetUnit()),udg_PlayingPlayers)==false)
endfunction

function Trig_Chocobo_TechCopy_IsInvalidTarget takes nothing returns boolean
    return(Trig_Chocobo_TechCopy_TargetNotOwnedChocobo())
endfunction

function Trig_Chocobo_TechCopy_CasterHasAbilityAtIndex takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetTriggerUnit())>=1)
endfunction

function Trig_Chocobo_TechCopy_TargetHasAbilityAtIndex takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetSpellTargetUnit())>=1)
endfunction

function Trig_Chocobo_TechCopy_NoAbilityToCopy takes nothing returns boolean
    return(udg_ChocoboAbilityIndex==0)
endfunction

function Trig_Chocobo_TechCopy_IsCarryingRider takes nothing returns boolean
    return(IsUnitInTransportBJ(Player_GetHero(GetOwningPlayer(GetTriggerUnit())),GetTriggerUnit()))or(IsUnitInTransportBJ(udg_ShadowUnit,GetTriggerUnit()))
endfunction

function Trig_Chocobo_TechCopy_CannotCopyWhileRidden takes nothing returns boolean
    return(Trig_Chocobo_TechCopy_IsCarryingRider())and(GetUnitAbilityLevelSwapped('Abun',GetTriggerUnit())<=0) // 'Abun': object name not found in map data
endfunction

function Trig_Chocobo_TechCopy_IsAttackSlot takes nothing returns boolean
    return(GetForLoopIndexB()==$F) // $F = 15
endfunction

function Trig_Chocobo_TechCopy_IsSprintSlot takes nothing returns boolean
    return(GetForLoopIndexB()==5)
endfunction

function Trig_Chocobo_TechCopy_IsQuickJoinSlot takes nothing returns boolean
    return(GetForLoopIndexB()==3)
endfunction

function Trig_Chocobo_TechCopy_CasterHasSlotAbility takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped(udg_ChocoboAbility[GetForLoopIndexB()],GetTriggerUnit())>=1)
endfunction

function Trig_Chocobo_TechCopy_CopiedIsAttack takes nothing returns boolean
    return(udg_ChocoboAbilityIndex==$F) // $F = 15
endfunction

function Trig_Chocobo_TechCopy_CopiedIsSprint takes nothing returns boolean
    return(udg_ChocoboAbilityIndex==5)
endfunction

function Trig_Chocobo_TechCopy_CopiedIsQuickJoin takes nothing returns boolean
    return(udg_ChocoboAbilityIndex==3)
endfunction

function Trig_Chocobo_TechCopy_IsStage3Chocobo takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n038') // 'n038': unit "Chocobo"
endfunction

function Trig_Chocobo_TechCopy_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    if(Trig_Chocobo_TechCopy_IsInvalidTarget())then
        call DisplayTextToForce(udg_TempForce,"Invalid target for Tech Copy!")
        call DestroyForce(udg_TempForce)
        return
    endif
    set udg_ChocoboAbilityIndex=0
    set bj_forLoopBIndex=3
    set bj_forLoopBIndexEnd=$F // $F = 15
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        if(Trig_Chocobo_TechCopy_TargetHasAbilityAtIndex())then
            if(Trig_Chocobo_TechCopy_CasterHasAbilityAtIndex())then
                call DisplayTextToForce(udg_TempForce,"The target chocobo has the same ability as the casting chocobo!")
                call DestroyForce(udg_TempForce)
                return
            else
                set udg_ChocoboAbilityIndex=GetForLoopIndexB()
            endif
        endif
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    if(Trig_Chocobo_TechCopy_NoAbilityToCopy())then
        call DisplayTextToForce(udg_TempForce,"The target chocobo has no ability to copy!")
        call DestroyForce(udg_TempForce)
        return
    endif
    if(Trig_Chocobo_TechCopy_CannotCopyWhileRidden())then
        call DisplayTextToForce(udg_TempForce,"This action cannot be executed while your hero is riding the chocobo!")
        call DestroyForce(udg_TempForce)
        return
    endif
    set bj_forLoopBIndex=3
    set bj_forLoopBIndexEnd=$F // $F = 15
    loop
        exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
        if(Trig_Chocobo_TechCopy_CasterHasSlotAbility())then
            call UnitRemoveAbilityBJ(udg_ChocoboAbility[GetForLoopIndexB()],GetTriggerUnit())
            if(Trig_Chocobo_TechCopy_IsQuickJoinSlot())then
                call UnitAddAbilityBJ('A04F',GetTriggerUnit()) // 'A04F': ability "Join Fast"
            else
                if(Trig_Chocobo_TechCopy_IsSprintSlot())then
                    call UnitAddAbilityBJ('A0A4',GetTriggerUnit()) // 'A0A4': ability "Chocobo Sprint"
                else
                    if(Trig_Chocobo_TechCopy_IsAttackSlot())then
                        call UnitRemoveAbilityBJ('S005',GetTriggerUnit()) // 'S005': ability "Chocobo Ride"
                        call UnitAddAbilityBJ('Abun',GetTriggerUnit()) // 'Abun': object name not found in map data
                        call UnitAddAbilityBJ('S005',GetTriggerUnit()) // 'S005': ability "Chocobo Ride"
                    endif
                endif
            endif
        endif
        set bj_forLoopBIndex=bj_forLoopBIndex+1
    endloop
    call UnitAddAbilityBJ(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetTriggerUnit())
    call DisplayTimedTextToForce(udg_TempForce,15.,("The chocobo has successfully copied the ability |cffffcc00"+(GetAbilityName(udg_ChocoboAbility[udg_ChocoboAbilityIndex])+"|r!")))
    call DestroyForce(udg_TempForce)
    if(Trig_Chocobo_TechCopy_CopiedIsQuickJoin())then
        call UnitRemoveAbilityBJ('A04F',GetTriggerUnit()) // 'A04F': ability "Join Fast"
    else
        if(Trig_Chocobo_TechCopy_CopiedIsSprint())then
            call UnitRemoveAbilityBJ('A0A4',GetTriggerUnit()) // 'A0A4': ability "Chocobo Sprint"
        else
            if(Trig_Chocobo_TechCopy_CopiedIsAttack())then
                call UnitRemoveAbilityBJ('Abun',GetTriggerUnit()) // 'Abun': object name not found in map data
            endif
        endif
    endif
    if(Trig_Chocobo_TechCopy_IsStage3Chocobo())then
        call SetUnitAbilityLevelSwapped(udg_ChocoboAbility[udg_ChocoboAbilityIndex],GetTriggerUnit(),$B) // $B = 11
    endif
endfunction

function InitTrig_Chocobo_TechCopy takes nothing returns nothing
endfunction

endlibrary

library TSleep
function Trig_Sleep_Cast_IsSleepSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ED')or(GetSpellAbilityId()=='A0U4')or(GetSpellAbilityId()=='A16M')or(GetSpellAbilityId()=='A0E9') // 'A1ED': ability "Sleep"; 'A0U4': ability "Sleep"; 'A16M': ability "Dormina"; 'A0E9': ability "Sleep"
endfunction

function Trig_Sleep_Cast_Conditions takes nothing returns boolean
    return(Trig_Sleep_Cast_IsSleepSpell())
endfunction

function Trig_Sleep_Cast_MasteryTargetValid takes nothing returns boolean
    return(GetSpellAbilityId()=='A1ED')and(GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit())>=30000.)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_JobMasterForce[19])==false)and(GetUnitAbilityLevelSwapped('A02F',GetTriggerUnit())==3) // 'A1ED': ability "Sleep"; 'A02F': ability "Mastery"
endfunction

function Trig_Sleep_Cast_TargetIsSleepproof takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0U6',GetSpellTargetUnit())>0) // 'A0U6': ability "Sleepproof"
endfunction

function Trig_Sleep_Cast_Actions takes nothing returns nothing
    if(Trig_Sleep_Cast_TargetIsSleepproof())then
        call GroupAddUnitSimple(GetSpellTargetUnit(),udg_ActiveHeroGroup)
        call StartTimerBJ(udg_HeroRefreshTimer,false,.01)
    else
        if(Trig_Sleep_Cast_MasteryTargetValid())then
            set udg_SleepTarget[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetSpellTargetUnit()
        endif
    endif
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Sleep takes nothing returns nothing
endfunction
function RegisterR11_Sleep_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Sleep_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Sleep_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Sleep_Cast,Condition(function Trig_Sleep_Cast_Conditions))
    call TriggerAddAction(gg_trg_Sleep_Cast,function Trig_Sleep_Cast_Actions)
endfunction




endlibrary

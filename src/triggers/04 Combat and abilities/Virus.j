library TVirus requires TAbil, TBerserk
function Trig_Virus_Cast_Expire takes nothing returns nothing
    local timer expiredTimer=GetExpiredTimer()
    local unit u=LoadUnitHandle(udg_MaxHpBuffHash,GetHandleId(expiredTimer),3)
    call Berserk_Remove(u)
    set u=null
    set expiredTimer=null
endfunction

function Trig_Virus_Cast_Apply takes unit u,real duration returns nothing
    local timer t
    if(GetUnitAbilityLevel(u,'A0FX')>0 or GetUnitAbilityLevel(u,'B07U')>0)then // 'A0FX': ability "Diseaseproof"; 'B07U': buff "Goliath Tonic"
        call GroupAddUnit(udg_VirusImmuneGroup,u)
        return
    endif
    if(LoadBoolean(udg_MaxHpBuffHash,GetHandleId(u),0))then
        set t=LoadTimerHandle(udg_MaxHpBuffHash,GetHandleId(u),2)
    else
        set t=CreateTimer()
        call SaveBoolean(udg_MaxHpBuffHash,GetHandleId(u),0,true)
        call SaveReal(udg_MaxHpBuffHash,GetHandleId(u),1,.0)
        call SaveTimerHandle(udg_MaxHpBuffHash,GetHandleId(u),2,t)
        call SaveUnitHandle(udg_MaxHpBuffHash,GetHandleId(t),3,u)
        call GroupAddUnit(udg_BerserkGroup,u)
    endif
    call TimerStart(t,duration,false,function Trig_Virus_Cast_Expire)
    set t=null
endfunction

function Trig_Virus_Cast_IsVirus takes nothing returns boolean
    return(GetSpellAbilityId()=='A0AQ')or(GetSpellAbilityId()=='A007')or(GetSpellAbilityId()=='A0G0') // 'A0AQ': ability "Virus"; 'A007': ability "Virus"; 'A0G0': ability "Virus"
endfunction

function Trig_Virus_Cast_Conditions takes nothing returns boolean
    return(Trig_Virus_Cast_IsVirus())
endfunction

function Trig_Virus_Cast_Actions takes nothing returns nothing
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (0.1).
    set udg_TempReal=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*.1)
    call Trig_Virus_Cast_Apply(GetSpellTargetUnit(),udg_TempReal)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Virus takes nothing returns nothing
endfunction

function RegisterR11_Virus_Cast takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Virus_Cast=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Virus_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Virus_Cast,Condition(function Trig_Virus_Cast_Conditions))

call TriggerAddAction(gg_trg_Virus_Cast,function Trig_Virus_Cast_Actions)

endfunction




endlibrary

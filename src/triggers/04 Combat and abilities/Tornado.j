library TTornado requires TAbil, TProf, TWait
function Trig_Tornado_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A149' or GetSpellAbilityId()=='A00A') // 'A149': ability "!Tornado"; 'A00A': ability "!Tornado"
endfunction

function Trig_Tornado_Cast_Actions takes nothing returns nothing
    local integer l_abilId=GetSpellAbilityId()
    local unit triggeringUnit=GetTriggerUnit()
    local player owningPlayer=GetOwningPlayer(triggeringUnit)
    local real l_ux=GetUnitX(triggeringUnit)
    local real l_uy=GetUnitY(triggeringUnit)
    local integer l_dummyId
    // Starting value for l_manaDmg:
    // (BlzGetAbilityManaCost(l_abilId, Abil_GetLevel(triggeringUnit, l_abilId))) times (3).
    local integer l_manaDmg=BlzGetAbilityManaCost(l_abilId,Abil_GetLevel(triggeringUnit,l_abilId))*3
    // Starting value for l_intDmg:
    // (Intelligence of triggeringUnit) times (4).
    local integer l_intDmg=GetHeroInt(triggeringUnit,true)*4
    local real damageAmount
    local unit l_dummy
    local effect l_fxTornado
    local effect l_fxClap
    set l_dummy=CreateUnit(owningPlayer,'h01B',l_ux,l_uy,.0) // 'h01B': unit "Proxy Dummy"
    set l_dummyId=GetHandleId(l_dummy)
    call SaveUnitHandle(udg_ProxyDamageHash,l_dummyId,0,triggeringUnit)
    // ((l_manaDmg) plus (l_intDmg)) times (Prof_RodPower(triggeringUnit)).
    set damageAmount=(l_manaDmg+l_intDmg)*Prof_RodPower(triggeringUnit)
    call SaveReal(udg_ProxyDamageHash,l_dummyId,1,damageAmount)
    call SaveInteger(udg_ProxyDamageHash,l_dummyId,2,3)
    set l_fxTornado=AddSpecialEffect("Abilities\\Spells\\Other\\Tornado\\TornadoElemental.mdl",l_ux,l_uy)
    set l_fxClap=AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",l_ux,l_uy)
    call BlzSetSpecialEffectScale(l_fxTornado,1.5)
    call BlzSetSpecialEffectScale(l_fxClap,12.)
    call BlzSetSpecialEffectZ(l_fxClap,32.)
    call ShowUnit(l_dummy,false)
    call UnitApplyTimedLife(l_dummy,'BTLF',8.) // 'BTLF': object name not found in map data
    call UnitAddAbility(l_dummy,'A0M6') // 'A0M6': ability "Wind-elemental Damage"
    call UnitAddAbility(l_dummy,'A012') // 'A012': ability "Tornado"
    call Wait_Polled(1.)
    call IssueImmediateOrderById(l_dummy,$D0080) // $D0080 = 852096
    call Wait_Polled(2.)
    call IssueImmediateOrderById(l_dummy,$D0080) // $D0080 = 852096
    call Wait_Polled(2.)
    call IssueImmediateOrderById(l_dummy,$D0080) // $D0080 = 852096
    call Wait_Polled(2.)
    call DestroyEffect(l_fxTornado)
    call DestroyEffect(l_fxClap)
    set triggeringUnit=null
    set l_dummy=null
    set owningPlayer=null
    set l_fxTornado=null
    set l_fxClap=null
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Tornado takes nothing returns nothing
endfunction
function RegisterR11_Tornado_Cast takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Tornado_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Tornado_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Tornado_Cast,Condition(function Trig_Tornado_Cast_Conditions))
    call TriggerAddAction(gg_trg_Tornado_Cast,function Trig_Tornado_Cast_Actions)
endfunction




endlibrary

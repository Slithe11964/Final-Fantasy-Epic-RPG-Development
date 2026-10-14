library TSpellWater requires TAbil, TProf, TBackpack
function Trig_Spell_Water_IsWaterSpell takes nothing returns boolean
    return(GetSpellAbilityId()=='A08X')or(GetSpellAbilityId()=='A0Q0')or(GetSpellAbilityId()=='A0Q1')or(GetSpellAbilityId()=='A0Q2')or(GetSpellAbilityId()=='A0SM')or(GetSpellAbilityId()=='A0TP')or(GetSpellAbilityId()=='A0SA')or(GetSpellAbilityId()=='A150') // 'A08X': ability "Water"; 'A0Q0': ability "Water"; 'A0Q1': ability "Watera"; 'A0Q2': ability "Wateraga"; 'A0SM': ability "Water"; 'A0TP': ability "Water"; 'A0SA': ability "Water"; 'A150': ability "Water"
endfunction

function Trig_Spell_Water_Conditions takes nothing returns boolean
    return(Trig_Spell_Water_IsWaterSpell())
endfunction

function Trig_Spell_Water_IsPointCast takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Spell_Water_IsCasterHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_Water_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local integer l_tempInteger
    local location l_tempPoint
    local real l_tempReal
    local unit proxy
    local unit source=GetTriggerUnit()
    local integer pid=GetPlayerId(GetOwningPlayer(source))
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    set proxy=GetLastCreatedUnit()
    call RemoveLocation(l_tempPoint)
    if Backpack_PageOf(pid,source)>=0 then
        set source=Player_GetHero(Player(pid))
    endif
    if(Trig_Spell_Water_IsPointCast())then
        set l_tempPoint=GetSpellTargetLoc()
    else
        set l_tempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(proxy,l_tempPoint,0)
    set l_tempHandleId=GetHandleIdBJ(proxy)
    call SaveUnitHandleBJ(source,0,l_tempHandleId,udg_ProxyDamageHash)
    set l_tempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*5)
    if IsUnitType(source,UNIT_TYPE_HERO) then
        set l_tempInteger=(l_tempInteger+(GetHeroStatBJ(bj_HEROSTAT_INT,source,true)*6))
    endif
    set l_tempReal=Prof_RodPower(source)
    call SaveRealBJ((I2R(l_tempInteger)*l_tempReal),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(3,2,l_tempHandleId,udg_ProxyDamageHash)
    // Keep the proxy active for classic casting; hide its model rather than the unit.
    call SetUnitVertexColor(proxy,255,255,255,0)
    call UnitApplyTimedLifeBJ(6.,'BTLF',proxy) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M4',proxy) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0PZ',proxy) // 'A0PZ': ability "Water"
    call IssuePointOrderLocBJ(proxy,"carrionswarm",l_tempPoint)
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
    set proxy=null
    set source=null
endfunction

function InitTrig_Spell_Water takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part6 (module Spell),
// which keeps the original registration order.

function Register_Spell_Water takes nothing returns nothing
    set gg_trg_Spell_Water=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_Water,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_Water,Condition(function Trig_Spell_Water_Conditions))
    call TriggerAddAction(gg_trg_Spell_Water,function Trig_Spell_Water_Actions)
endfunction

endlibrary

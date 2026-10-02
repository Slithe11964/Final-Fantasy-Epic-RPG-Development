library TFan requires TAbil, TProf
function Trig_Fan_Of_Knives_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0QS') // 'A0QS': ability "Fan of Knives"
endfunction

function Trig_Fan_Of_Knives_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Fan_Of_Knives_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // (BlzGetAbilityManaCost(GetSpellAbilityId(), Abil_GetLevel(the triggering unit, GetSpellAbilityId()))) times
    // (2).
    set udg_TempInteger=(BlzGetAbilityManaCost(GetSpellAbilityId(),Abil_GetLevel(GetTriggerUnit(),GetSpellAbilityId()))*2)
    if(Trig_Fan_Of_Knives_IsHero())then
        // (udg_TempInteger) plus ((Agility of the triggering unit) times (4)).
        set udg_TempInteger=(udg_TempInteger+(GetHeroStatBJ(bj_HEROSTAT_AGI,GetTriggerUnit(),true)*4))
    endif
    // (0.1) times ((10) plus (Prof_GetLevel(the triggering unit, 'R00B'))).
    set udg_TempReal=.1*($A+Prof_GetLevel(GetTriggerUnit(),'R00B')) // $A = 10; 'R00B': upgrade "Dagger"
    // (udg_TempInteger treated as a decimal-capable number) times (udg_TempReal).
    call SaveRealBJ((I2R(udg_TempInteger)*udg_TempReal),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(5.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0QT',GetLastCreatedUnit()) // 'A0QT': ability "Fan of Knives"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"fanofknives")
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Fan takes nothing returns nothing
endfunction

function RegisterR11_Fan_Of_Knives takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Fan_Of_Knives=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Fan_Of_Knives,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Fan_Of_Knives,Condition(function Trig_Fan_Of_Knives_Conditions))

call TriggerAddAction(gg_trg_Fan_Of_Knives,function Trig_Fan_Of_Knives_Actions)

endfunction




endlibrary

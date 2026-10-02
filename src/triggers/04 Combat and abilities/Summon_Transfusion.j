library TSummonTransfusion
function Trig_Summon_Transfusion_Consume_IsSummonUltimate takes nothing returns boolean
    return(GetSpellAbilityId()=='A0RM')or(GetSpellAbilityId()=='A0RK')or(GetSpellAbilityId()=='A13L')or(GetSpellAbilityId()=='A13U') // 'A0RM': ability "!Diamond Dust"; 'A0RK': ability "!Hellfire"; 'A13L': ability "!Living Wall"; 'A13U': ability "!Final Smash"
endfunction

function Trig_Summon_Transfusion_Consume_Conditions takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0I3',GetTriggerUnit())>0)and(Trig_Summon_Transfusion_Consume_IsSummonUltimate()) // 'A0I3': ability "Transfusion Powerup"
endfunction

function Trig_Summon_Transfusion_Consume_CasterIsSummon4 takes nothing returns boolean
    return(GetTriggerUnit()==udg_Eidolon3)
endfunction

function Trig_Summon_Transfusion_Consume_CasterIsSummon3 takes nothing returns boolean
    return(GetTriggerUnit()==udg_Eidolon2)
endfunction

function Trig_Summon_Transfusion_Consume_CasterIsSummon2 takes nothing returns boolean
    return(GetTriggerUnit()==udg_Eidolon1)
endfunction

function Trig_Summon_Transfusion_Consume_CasterIsSummon1 takes nothing returns boolean
    return(GetTriggerUnit()==udg_GolemSummon)
endfunction

function Trig_Summon_Transfusion_Consume_Actions takes nothing returns nothing
    call UnitRemoveAbilityBJ('A0I3',GetTriggerUnit()) // 'A0I3': ability "Transfusion Powerup"
    call BlzSetUnitMaxMana(GetTriggerUnit(),0)
    // Result 1: BlzGetUnitBaseDamage(the triggering unit, 0) treated as a decimal-capable number.
    // Result 2: (result 1) divided by (1.5).
    // Result 3: (result 2) with its decimal part removed.
    call BlzSetUnitBaseDamage(GetTriggerUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetTriggerUnit(),0))/ 1.5)),0)
    // Result 1: BlzGetUnitBaseDamage(the triggering unit, 1) treated as a decimal-capable number.
    // Result 2: (result 1) divided by (1.5).
    // Result 3: (result 2) with its decimal part removed.
    call BlzSetUnitBaseDamage(GetTriggerUnit(),R2I((I2R(BlzGetUnitBaseDamage(GetTriggerUnit(),1))/ 1.5)),1)
    if(Trig_Summon_Transfusion_Consume_CasterIsSummon1())then
        call BlzSetUnitArmor(GetTriggerUnit(),udg_GolemBaseArmor)
    else
        if(Trig_Summon_Transfusion_Consume_CasterIsSummon2())then
            call BlzSetUnitArmor(GetTriggerUnit(),udg_ShivaBaseArmor)
        else
            if(Trig_Summon_Transfusion_Consume_CasterIsSummon3())then
                call BlzSetUnitArmor(GetTriggerUnit(),udg_IfritBaseArmor)
            else
                if(Trig_Summon_Transfusion_Consume_CasterIsSummon4())then
                    call BlzSetUnitArmor(GetTriggerUnit(),udg_CyclopsBaseArmor)
                else
                    // (BlzGetUnitArmor(the triggering unit)) divided by (1.5).
                    call BlzSetUnitArmor(GetTriggerUnit(),(BlzGetUnitArmor(GetTriggerUnit())/ 1.5))
                endif
            endif
        endif
    endif
endfunction

function InitTrig_Summon_Transfusion takes nothing returns nothing
endfunction

endlibrary

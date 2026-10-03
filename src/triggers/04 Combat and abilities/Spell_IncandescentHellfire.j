library TSpellIncandescentHellfire requires TLoc
function Trig_Spell_IncandescentHellfire_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0FS') // 'A0FS': ability "!Incandescent Hellfire"
endfunction

function Trig_Spell_IncandescentHellfire_Cond_IsHero takes nothing returns boolean
    return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null
endfunction

function Trig_Spell_IncandescentHellfire_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=3
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // Result 1: loop counter A treated as a decimal-capable number.
        // Result 2: (result 1) times (90).
        // Result 3: (facing in degrees of the triggering unit) plus (result 2).
        // Result 4: the remainder after dividing (result 3) by (360).
        set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,384.,ModuloReal((GetUnitFacing(GetTriggerUnit())+(I2R(GetForLoopIndexA())*90.)),360.))
        call CreateNUnitsAtLoc(1,'u012',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint2,bj_UNIT_FACING) // 'u012': unit "Incandescent Hellfire"
        call RemoveLocation(udg_TempPoint2)
        if(Trig_Spell_IncandescentHellfire_Cond_IsHero())then
            call BlzSetUnitName(GetLastCreatedUnit(),GetHeroProperName(GetTriggerUnit()))
        else
            call BlzSetUnitName(GetLastCreatedUnit(),GetUnitName(GetTriggerUnit()))
        endif
        call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
        call SetUnitColor(GetLastCreatedUnit(),PLAYER_COLOR_RED)
        // Result 1: current health divided by maximum health for the triggering unit, times 100 (or 0 if the unit is
        // missing or its maximum is 0).
        // Result 2: (220) minus (result 1).
        call SetUnitMoveSpeed(GetLastCreatedUnit(),(220.-GetUnitLifePercent(GetTriggerUnit())))
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=null
endfunction

function InitTrig_Spell_IncandescentHellfire takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Spell_Part4 (module Spell),
// which keeps the original registration order.

function Register_Spell_IncandescentHellfire takes nothing returns nothing
    set gg_trg_Spell_IncandescentHellfire=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Spell_IncandescentHellfire,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Spell_IncandescentHellfire,Condition(function Trig_Spell_IncandescentHellfire_Conditions))
    call TriggerAddAction(gg_trg_Spell_IncandescentHellfire,function Trig_Spell_IncandescentHellfire_Actions)
endfunction

endlibrary

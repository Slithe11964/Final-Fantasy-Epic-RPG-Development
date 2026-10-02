library TDismantle
function Trig_Dismantle_Cast_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A1BB') // 'A1BB': ability "Dismantle"
endfunction

function Trig_Dismantle_Cast_IsDismantlable takes nothing returns boolean
    return(udg_TempInteger==22)
endfunction

function Trig_Dismantle_Cast_Actions takes nothing returns nothing
    set udg_TempInteger=GetUnitTypeId(GetSpellTargetUnit())
    set udg_TempInteger=LoadIntegerBJ(1,udg_TempInteger,udg_MonsterDataHash)
    if(Trig_Dismantle_Cast_IsDismantlable())then
        call UnitAddAbilityBJ('A0MV',GetSpellTargetUnit()) // 'A0MV': ability "Plentiful"
        set udg_DmgFlagPure=true
        set udg_DmgFlagUnavoidable=-1
        set udg_IgnoresReduction=true
        call UnitDamageTarget(GetTriggerUnit(),GetSpellTargetUnit(),6666666.,true,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_UNIVERSAL,WEAPON_TYPE_METAL_HEAVY_BASH)
    endif
endfunction

// World Editor calls InitTrig_Dismantle automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Dismantle (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Dismantle takes nothing returns nothing
endfunction

function Register_Dismantle_Cast takes nothing returns nothing
    set gg_trg_Dismantle_Cast=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Dismantle_Cast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Dismantle_Cast,Condition(function Trig_Dismantle_Cast_Conditions))
    call TriggerAddAction(gg_trg_Dismantle_Cast,function Trig_Dismantle_Cast_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Dismantle takes nothing returns nothing
    call Register_Dismantle_Cast()
endfunction

endlibrary

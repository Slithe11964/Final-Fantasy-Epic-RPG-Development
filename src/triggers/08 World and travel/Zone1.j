library TZone1
function Trig_Zone1_Leash_IsChocobo_Z1 takes nothing returns boolean
    return(GetUnitName(GetTriggerUnit())=="Chocobo")and(GetOwningPlayer(GetTriggerUnit())==Player(8))
endfunction

function Trig_Zone1_Leash_IsLeashTarget_Z1 takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B))or(Trig_Zone1_Leash_IsChocobo_Z1()) // $B = 11
endfunction

function Trig_Zone1_Leash_Conditions takes nothing returns boolean
    return(GetUnitUserData(GetTriggerUnit())==0)and(Trig_Zone1_Leash_IsLeashTarget_Z1())and(IsUnitInGroup(GetTriggerUnit(),udg_SpecialUnits)==false)and(IsUnitInGroup(GetTriggerUnit(),udg_SummonedUnits)==false)and(IsUnitInGroup(GetTriggerUnit(),udg_EscortUnits)==false)and(GetTriggerUnit()!=gg_unit_Hpb1_0013)and(GetTriggerUnit()!=gg_unit_U00E_0222)
endfunction

function Trig_Zone1_Leash_Actions takes nothing returns nothing
    // A random whole number from 1 through LoadIntegerBJ(1, 2, udg_SpawnDataHashRef).
    set udg_TempPoint=GetRandomLocInRect(LoadRectHandleBJ(GetRandomInt(1,LoadIntegerBJ(1,2,udg_SpawnDataHashRef)),1,udg_SpawnRectHashRef))
    call SetUnitPositionLoc(GetTriggerUnit(),udg_TempPoint)
    call RemoveLocation(udg_TempPoint)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Zone1 takes nothing returns nothing
endfunction
function RegisterR11_Zone1_Leash takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Zone1_Leash=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Zone1_Leash,gg_rct_224)
    call TriggerAddCondition(gg_trg_Zone1_Leash,Condition(function Trig_Zone1_Leash_Conditions))
    call TriggerAddAction(gg_trg_Zone1_Leash,function Trig_Zone1_Leash_Actions)
endfunction




endlibrary

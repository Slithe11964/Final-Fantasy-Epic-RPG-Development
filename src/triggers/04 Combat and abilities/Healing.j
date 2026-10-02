library THealing
function Trig_Healing_Periodic_Func001Func003C takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B006')) // 'B006': buff "Regen"
endfunction

function Trig_Healing_Periodic_Func001Func004C takes nothing returns boolean
    return(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)>.0)
endfunction

function Trig_Healing_Periodic_Func001Func005C takes nothing returns boolean
    return(udg_TempReal<=.0)
endfunction

function Trig_Healing_Periodic_Func003Func003C takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B006')) // 'B006': buff "Regen"
endfunction

function Trig_Healing_Periodic_Func003Func004C takes nothing returns boolean
    return(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)>.0)
endfunction

function Trig_Healing_Periodic_Func003Func005C takes nothing returns boolean
    return(udg_TempReal<=.0)
endfunction

function Trig_Healing_Periodic_Func004Func003C takes nothing returns boolean
    return(UnitHasBuffBJ(GetEnumUnit(),'B006')) // 'B006': buff "Regen"
endfunction

function Trig_Healing_Periodic_Func004Func004C takes nothing returns boolean
    return(LoadRealBJ(2,GetHandleIdBJ(GetEnumUnit()),udg_HealOverTimeHash)>.0)
endfunction

function Trig_Healing_Periodic_Func004Func005C takes nothing returns boolean
    return(udg_TempReal<=.0)
endfunction

function InitTrig_Healing takes nothing returns nothing
endfunction

endlibrary

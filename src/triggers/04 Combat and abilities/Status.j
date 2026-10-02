library TStatus
function Trig_Status_AutoCleanse_Conditions takes nothing returns boolean
    return(IsUnitGroupEmptyBJ(udg_ActiveHeroGroup)==false)
endfunction

function Trig_Status_AutoCleanse_HasSleepproof takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0U6',GetEnumUnit())>0) // 'A0U6': ability "Sleepproof"
endfunction

function Trig_Status_AutoCleanse_HasBlindproof takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RA',GetEnumUnit())>0) // 'A0RA': ability "Blindproof"
endfunction

function Trig_Status_AutoCleanse_HasAutoHaste takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0GJ',GetEnumUnit())>0) // 'A0GJ': ability "Auto-Haste"
endfunction

function Trig_Status_AutoCleanse_HasAutoBravery takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WE',GetEnumUnit())>0) // 'A0WE': ability "Auto-Bravery"
endfunction

function Trig_Status_AutoCleanse_HasAutoFaith takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0WG',GetEnumUnit())>0) // 'A0WG': ability "Auto-Faith"
endfunction

function Trig_Status_AutoCleanse_HasAutoGrowth takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0O7',GetEnumUnit())>0) // 'A0O7': ability "Auto-Growth"
endfunction

function Trig_Status_AutoCleanse_CleanseEnum takes nothing returns nothing
    if(Trig_Status_AutoCleanse_HasSleepproof())then
        call UnitRemoveBuffBJ('B03A',GetEnumUnit()) // 'B03A': buff tooltip "Sleep"
        call UnitRemoveBuffBJ('B03B',GetEnumUnit()) // 'B03B': buff "Sleep (Pause)"
        call UnitRemoveBuffBJ('B03C',GetEnumUnit()) // 'B03C': buff "Sleep (Stunned)"
    endif
    if(Trig_Status_AutoCleanse_HasBlindproof())then
        call UnitRemoveBuffBJ('B00P',GetEnumUnit()) // 'B00P': buff tooltip "Blind"
    endif
    if(Trig_Status_AutoCleanse_HasAutoHaste())then
        call UnitRemoveBuffBJ('B00F',GetEnumUnit()) // 'B00F': buff "Haste"
        call UnitRemoveBuffBJ('B08T',GetEnumUnit()) // 'B08T': buff "Hastera"
        call UnitRemoveBuffBJ('B07F',GetEnumUnit()) // 'B07F': buff "Haste"
        call UnitRemoveBuffBJ('Bslo',GetEnumUnit()) // 'Bslo': buff tooltip "Slow"
        call UnitRemoveBuffBJ('B08Y',GetEnumUnit()) // 'B08Y': buff "Slowra"
    endif
    if(Trig_Status_AutoCleanse_HasAutoBravery())then
        call UnitRemoveBuffBJ('B01W',GetEnumUnit()) // 'B01W': buff "Bravery"
        call UnitRemoveBuffBJ('B08P',GetEnumUnit()) // 'B08P': buff "Bravera"
        call UnitRemoveBuffBJ('B07I',GetEnumUnit()) // 'B07I': buff "Bravery"
        call UnitRemoveBuffBJ('B06H',GetEnumUnit()) // 'B06H': buff "Pain"
        call UnitRemoveBuffBJ('B08W',GetEnumUnit()) // 'B08W': buff "Painra"
    endif
    if(Trig_Status_AutoCleanse_HasAutoFaith())then
        call UnitRemoveBuffBJ('B05A',GetEnumUnit()) // 'B05A': buff "Faith"
        call UnitRemoveBuffBJ('B08Q',GetEnumUnit()) // 'B08Q': buff "Faithra"
        call UnitRemoveBuffBJ('B07J',GetEnumUnit()) // 'B07J': buff "Faith"
        call UnitRemoveBuffBJ('B06I',GetEnumUnit()) // 'B06I': buff "Fog"
        call UnitRemoveBuffBJ('B08X',GetEnumUnit()) // 'B08X': buff "Fogra"
    endif
    if(Trig_Status_AutoCleanse_HasAutoGrowth())then
        call UnitRemoveBuffBJ('B04X',GetEnumUnit()) // 'B04X': buff "Growth"
    endif
endfunction

function Trig_Status_AutoCleanse_Actions takes nothing returns nothing
    call ForGroupBJ(udg_ActiveHeroGroup,function Trig_Status_AutoCleanse_CleanseEnum)
    call GroupClear(udg_ActiveHeroGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Status takes nothing returns nothing
endfunction
function RegisterR11_Status_AutoCleanse takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Status_AutoCleanse=CreateTrigger()
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Status_AutoCleanse,udg_HeroRefreshTimer)
    call TriggerAddCondition(gg_trg_Status_AutoCleanse,Condition(function Trig_Status_AutoCleanse_Conditions))
    call TriggerAddAction(gg_trg_Status_AutoCleanse,function Trig_Status_AutoCleanse_Actions)
endfunction




endlibrary

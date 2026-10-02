library TArenaPresentation requires TGroup
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_FreezeNpcs=null
    trigger gg_trg_Arena_ToggleShowcase=null
endglobals

function Trig_Arena_FreezeNpcs_IsNotStructure takes nothing returns boolean
    return(IsUnitType(GetFilterUnit(),UNIT_TYPE_STRUCTURE)==false)!=null
endfunction

function Trig_Arena_FreezeNpcs_IsNeutralPassive takes nothing returns boolean
    return(GetOwningPlayer(GetFilterUnit())==Player(8))
endfunction

function Trig_Arena_FreezeNpcs_IsFreezableNpc takes nothing returns boolean
    return GetBooleanAnd(Trig_Arena_FreezeNpcs_IsNotStructure(),Trig_Arena_FreezeNpcs_IsNeutralPassive())
endfunction

function Trig_Arena_FreezeNpcs_FreezeNpc takes nothing returns nothing
    call GroupAddUnitSimple(GetEnumUnit(),udg_ArenaNpcGroup)
    call UnitAddAbilityBJ('Abun',GetEnumUnit()) // 'Abun': object name not found in map data
    call UnitAddAbilityBJ('Amim',GetEnumUnit()) // 'Amim': object name not found in map data
    call IssueImmediateOrderBJ(GetEnumUnit(),"holdposition")
endfunction

function Trig_Arena_FreezeNpcs_Actions takes nothing returns nothing
    call SetDestructableInvulnerableBJ(gg_dest_ZTsg_0025,true)
    call ForGroupBJ(Group_UnitsInRect(gg_rct_373,Condition(function Trig_Arena_FreezeNpcs_IsFreezableNpc)),function Trig_Arena_FreezeNpcs_FreezeNpc)
    call GroupRemoveUnitSimple(gg_unit_n0AX_0188,udg_ArenaNpcGroup)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_ToggleShowcase_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0J9') // 'A0J9': ability "Arena Match Toggle"
endfunction

function Trig_Arena_ToggleShowcase_ShowcaseEnabled takes nothing returns boolean
    return(udg_ArenaShowcaseOn)
endfunction

function Trig_Arena_ToggleShowcase_Actions takes nothing returns nothing
    if(Trig_Arena_ToggleShowcase_ShowcaseEnabled())then
        set udg_ArenaShowcaseOn=false
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff00ff00Arena:|r The matchup showcase before tournament rounds is now turned off.")
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),2)
    else
        set udg_ArenaShowcaseOn=true
        call DisplayTimedTextToForce(udg_PlayingPlayers,10.,"|cff00ff00Arena:|r The matchup showcase before tournament rounds is now turned on.")
        call SetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit(),1)
    endif
endfunction

function InitTrig_Arena_Presentation takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2, RegisterTriggers_Arena_Part3 (module Arena),
// which keeps the original registration order.

function Register_Arena_FreezeNpcs takes nothing returns nothing
    set gg_trg_Arena_FreezeNpcs=CreateTrigger()
    call TriggerAddAction(gg_trg_Arena_FreezeNpcs,function Trig_Arena_FreezeNpcs_Actions)
endfunction

function Register_Arena_ToggleShowcase takes nothing returns nothing
    set gg_trg_Arena_ToggleShowcase=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Arena_ToggleShowcase,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Arena_ToggleShowcase,Condition(function Trig_Arena_ToggleShowcase_Conditions))
    call TriggerAddAction(gg_trg_Arena_ToggleShowcase,function Trig_Arena_ToggleShowcase_Actions)
endfunction

endlibrary

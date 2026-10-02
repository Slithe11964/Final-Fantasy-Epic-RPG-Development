library TArenaPresentation requires TGroup
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

endlibrary

library TGlyph
function Trig_Glyph_Area_Enter_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitHiddenBJ(GetTriggerUnit())==false)
endfunction

function Trig_Glyph_Area_Enter_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set udg_ShadowForcedSpawn=49
    call UnitAddAbilityBJ('Ane2',gg_unit_n03T_0008) // 'Ane2': object name not found in map data
    call CreateFogModifierRectBJ(true,Player($B),FOG_OF_WAR_VISIBLE,gg_rct_496) // $B = 11
    call EnableTrigger(gg_trg_Summon_Item_Dropped)
    call EnableTrigger(gg_trg_Arena_Enter_Eject)
    call EnableTrigger(gg_trg_Arena_Leave_Player)
    call EnableTrigger(gg_trg_Arena_Abandoned_Reset)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Glyph takes nothing returns nothing
endfunction
function RegisterR11_Glyph_Area_Enter takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
    set gg_trg_Glyph_Area_Enter=CreateTrigger()
    call DisableTrigger(gg_trg_Glyph_Area_Enter)
    call TriggerRegisterEnterRectSimple(gg_trg_Glyph_Area_Enter,gg_rct_496)
    call TriggerAddCondition(gg_trg_Glyph_Area_Enter,Condition(function Trig_Glyph_Area_Enter_Conditions))
    call TriggerAddAction(gg_trg_Glyph_Area_Enter,function Trig_Glyph_Area_Enter_Actions)
endfunction




endlibrary

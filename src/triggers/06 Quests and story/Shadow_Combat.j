library TShadowCombat
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Shadow_FumaShuriken=null
endglobals

function Trig_Shadow_FumaShuriken_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0WS') // 'A0WS': ability "Fuma Shuriken"
endfunction

function Trig_Shadow_FumaShuriken_IsGroundTarget takes nothing returns boolean
    return(GetSpellTargetUnit()==null)
endfunction

function Trig_Shadow_FumaShuriken_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    call RemoveLocation(udg_TempPoint)
    if(Trig_Shadow_FumaShuriken_IsGroundTarget())then
        set udg_TempPoint=GetSpellTargetLoc()
    else
        set udg_TempPoint=GetUnitLoc(GetSpellTargetUnit())
    endif
    call SetUnitFacingToFaceLocTimed(GetLastCreatedUnit(),udg_TempPoint,0)
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    // Result 1: (unit level of the triggering unit) plus (1).
    // Result 2: (result 1) times (100).
    // Result 3: the square of (udg_ShadowLoyalty).
    // Result 4: (result 3) divided by (2); drop the remainder.
    // Result 5: (result 2) plus (result 4).
    // Result 6: (CountPlayersInForceBJ(udg_PlayingPlayers)) plus (1).
    // Result 7: (result 5) divided by (result 6).
    set udg_TempInteger=((((GetUnitLevel(GetTriggerUnit())+1)*'d')+((udg_ShadowLoyalty*udg_ShadowLoyalty)/ 2))/(CountPlayersInForceBJ(udg_PlayingPlayers)+1))
    // Udg_TempInteger treated as a decimal-capable number.
    call SaveRealBJ(I2R(udg_TempInteger),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,2,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(2,3,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0WT',GetLastCreatedUnit()) // 'A0WT': ability "Fuma Shuriken"
    call IssueTargetOrderBJ(GetLastCreatedUnit(),"creepthunderbolt",GetSpellTargetUnit())
endfunction

function InitTrig_Shadow_Combat takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Shadow (module Shadow),
// which keeps the original registration order.

function Register_Shadow_FumaShuriken takes nothing returns nothing
    set gg_trg_Shadow_FumaShuriken=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Shadow_FumaShuriken,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Shadow_FumaShuriken,Condition(function Trig_Shadow_FumaShuriken_Conditions))
    call TriggerAddAction(gg_trg_Shadow_FumaShuriken,function Trig_Shadow_FumaShuriken_Actions)
endfunction

endlibrary

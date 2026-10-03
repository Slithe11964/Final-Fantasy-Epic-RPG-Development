library TArenaAccess requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Arena_Lock_Controls=null
    trigger gg_trg_Arena_Enter_Region=null
    trigger gg_trg_Arena_PlayerLeft=null
    trigger gg_trg_Arena_GateWrongSide=null
    trigger gg_trg_Arena_GateOpen=null
    trigger gg_trg_Arena_Enter_Eject=null
    trigger gg_trg_Arena_Leave_Player=null
endglobals

function Trig_Arena_Lock_Controls_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    set bj_forLoopAIndex=0
    set bj_forLoopAIndexEnd=udg_ArenaOrganizerLast
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        call UnitRemoveAbilityBJ('Ane2',udg_ArenaOrganizer[GetForLoopIndexA()]) // 'Ane2': object name not found in map data
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call UnitRemoveAbilityBJ('A0GG',gg_unit_h02T_0064) // 'A0GG': ability "Teleport"
endfunction

function Trig_Arena_Enter_Region_IsCountedFighter takes nothing returns boolean
    return(GetUnitAbilityLevelSwapped('A0RQ',GetTriggerUnit())<=0) // 'A0RQ': ability "Invalid Arena Summon"
endfunction

function Trig_Arena_Enter_Region_IsIntruder takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_CupArenaPlayers)==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(GetUnitAbilityLevelSwapped('Avul',GetTriggerUnit())<=0)and(IsUnitAliveBJ(GetTriggerUnit())) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Arena_Enter_Region_IsHostileUnit takes nothing returns boolean
    return(GetOwningPlayer(GetTriggerUnit())==Player($B)) // $B = 11
endfunction

function Trig_Arena_Enter_Region_Actions takes nothing returns nothing
    if(Trig_Arena_Enter_Region_IsHostileUnit())then
        if(Trig_Arena_Enter_Region_IsCountedFighter())then
            call GroupAddUnitSimple(GetTriggerUnit(),udg_CupArenaUnits)
        else
            call GroupAddUnitSimple(GetTriggerUnit(),udg_ArenaSummonGroup)
        endif
    else
        if(Trig_Arena_Enter_Region_IsIntruder())then
            set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
            call AddSpecialEffectLocBJ(udg_TempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call RemoveLocation(udg_TempPoint)
            set udg_TempPoint=GetRectCenter(gg_rct_483)
            call SetUnitPositionLocFacingBJ(GetTriggerUnit(),udg_TempPoint,180.)
            call RemoveLocation(udg_TempPoint)
            call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
            call DestroyEffectBJ(GetLastCreatedEffectBJ())
            call ConditionalTriggerExecute(gg_trg_Npc_Thorn_BattleWait)
        endif
    endif
endfunction

function Trig_Arena_PlayerLeft_Conditions takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_CupArenaPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Arena_PlayerLeft_Actions takes nothing returns nothing
    call ForceRemovePlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_CupArenaPlayers)
    call ConditionalTriggerExecute(gg_trg_Arena_BattleLost)
endfunction

function Trig_Arena_GateWrongSide_IsFacingGate takes nothing returns boolean
    return(GetUnitFacing(GetTriggerUnit())>=270.)or(GetUnitFacing(GetTriggerUnit())<=90.)
endfunction

function Trig_Arena_GateWrongSide_Conditions takes nothing returns boolean
    return((udg_ArenaGateOpened==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(Trig_Arena_GateWrongSide_IsFacingGate()))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Arena_GateWrongSide_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetOwningPlayer(GetTriggerUnit()))
    call DisplayTimedTextToForce(l_tempForce,5.,"This gate cannot be opened from this side.")
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

function Trig_Arena_GateOpen_IsPlayerHero takes nothing returns boolean
    return((IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)))!=null
endfunction

function Trig_Arena_GateOpen_IsGateOpener takes nothing returns boolean
    return(Trig_Arena_GateOpen_IsPlayerHero())or(GetUnitTypeId(GetTriggerUnit())=='n0B0') // 'n0B0': unit "Melaiduma"
endfunction

function Trig_Arena_GateOpen_Conditions takes nothing returns boolean
    return(udg_ArenaGateOpened==false)and(GetUnitTypeId(GetTriggerUnit())!='H01D')and(Trig_Arena_GateOpen_IsGateOpener()) // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Arena_GateOpen_IsMelaiduma takes nothing returns boolean
    return(GetUnitTypeId(GetTriggerUnit())=='n0B0') // 'n0B0': unit "Melaiduma"
endfunction

function Trig_Arena_GateOpen_BattleNotRunning takes nothing returns boolean
    return(IsTriggerEnabled(gg_trg_Arena_Enter_Region)==false)
endfunction

function Trig_Arena_GateOpen_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DisableTrigger(gg_trg_Arena_GateWrongSide)
    call DestroyTrigger(gg_trg_Arena_GateWrongSide)
    if(Trig_Arena_GateOpen_IsMelaiduma())then
        call DisplayTimedTextToForce(GetPlayersAll(),10.,"Melaiduma opened the gate to the Battle Arena.")
    else
        call DisplayTimedTextToForce(GetPlayersAll(),10.,(udg_PlayerName[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+" opened the gate to the Battle Arena."))
    endif
    set udg_ArenaGateOpened=true
    if(Trig_Arena_GateOpen_BattleNotRunning())then
        call ModifyGateBJ(bj_GATEOPERATION_OPEN,gg_dest_ZTsg_0025)
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Arena_Enter_Eject_Conditions takes nothing returns boolean
    return(udg_RingHintsReady==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_DuelArenaPlayers)==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(IsUnitAliveBJ(GetTriggerUnit()))and(GetUnitAbilityLevelSwapped('Avul',GetTriggerUnit())<=0) // 'Avul': standard ability reference "Invulnerable"
endfunction

function Trig_Arena_Enter_Eject_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call AddSpecialEffectLocBJ(l_tempPoint,"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call RemoveLocation(l_tempPoint)
    set l_tempPoint=GetRectCenter(gg_rct_634)
    call SetUnitPositionLocFacingBJ(GetTriggerUnit(),l_tempPoint,90.)
    call RemoveLocation(l_tempPoint)
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    set l_tempPoint=null
endfunction

function Trig_Arena_Leave_Player_Conditions takes nothing returns boolean
    return((udg_RingHintsReady==false)and(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_DuelArenaPlayers))and(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))and(GetUnitTypeId(GetTriggerUnit())!='H01D'))!=null // 'H01D': unit "Spirit of Gaya"
endfunction

function Trig_Arena_Leave_Player_Actions takes nothing returns nothing
    call ForceRemovePlayerSimple(GetOwningPlayer(GetTriggerUnit()),udg_DuelArenaPlayers)
    call StartTimerBJ(udg_ArenaCheckTimer,false,.01)
endfunction

function InitTrig_Arena_Access takes nothing returns nothing
endfunction

// ---- Trigger registration ----
// These create this module's triggers. They run at startup from RegisterTriggers_Arena_Part2, RegisterTriggers_Arena_Part4 (module Arena),
// which keeps the original registration order.

function Register_Arena_Lock_Controls takes nothing returns nothing
    set gg_trg_Arena_Lock_Controls=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Lock_Controls)
    call TriggerRegisterTimerExpireEventBJ(gg_trg_Arena_Lock_Controls,udg_ArenaLockTimer)
    call TriggerAddAction(gg_trg_Arena_Lock_Controls,function Trig_Arena_Lock_Controls_Actions)
endfunction

function Register_Arena_Enter_Region takes nothing returns nothing
    set gg_trg_Arena_Enter_Region=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Enter_Region)
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_Enter_Region,gg_rct_373)
    call TriggerAddAction(gg_trg_Arena_Enter_Region,function Trig_Arena_Enter_Region_Actions)
endfunction

function Register_Arena_PlayerLeft takes nothing returns nothing
    set gg_trg_Arena_PlayerLeft=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_PlayerLeft)
    call TriggerRegisterLeaveRectSimple(gg_trg_Arena_PlayerLeft,gg_rct_373)
    call TriggerAddCondition(gg_trg_Arena_PlayerLeft,Condition(function Trig_Arena_PlayerLeft_Conditions))
    call TriggerAddAction(gg_trg_Arena_PlayerLeft,function Trig_Arena_PlayerLeft_Actions)
endfunction

function Register_Arena_GateWrongSide takes nothing returns nothing
    set gg_trg_Arena_GateWrongSide=CreateTrigger()
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_GateWrongSide,gg_rct_485)
    call TriggerAddCondition(gg_trg_Arena_GateWrongSide,Condition(function Trig_Arena_GateWrongSide_Conditions))
    call TriggerAddAction(gg_trg_Arena_GateWrongSide,function Trig_Arena_GateWrongSide_Actions)
endfunction

function Register_Arena_GateOpen takes nothing returns nothing
    set gg_trg_Arena_GateOpen=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_GateOpen)
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_GateOpen,gg_rct_043)
    call TriggerAddCondition(gg_trg_Arena_GateOpen,Condition(function Trig_Arena_GateOpen_Conditions))
    call TriggerAddAction(gg_trg_Arena_GateOpen,function Trig_Arena_GateOpen_Actions)
endfunction

function Register_Arena_Enter_Eject takes nothing returns nothing
    set gg_trg_Arena_Enter_Eject=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Enter_Eject)
    call TriggerRegisterEnterRectSimple(gg_trg_Arena_Enter_Eject,gg_rct_496)
    call TriggerAddCondition(gg_trg_Arena_Enter_Eject,Condition(function Trig_Arena_Enter_Eject_Conditions))
    call TriggerAddAction(gg_trg_Arena_Enter_Eject,function Trig_Arena_Enter_Eject_Actions)
endfunction

function Register_Arena_Leave_Player takes nothing returns nothing
    set gg_trg_Arena_Leave_Player=CreateTrigger()
    call DisableTrigger(gg_trg_Arena_Leave_Player)
    call TriggerRegisterLeaveRectSimple(gg_trg_Arena_Leave_Player,gg_rct_496)
    call TriggerAddCondition(gg_trg_Arena_Leave_Player,Condition(function Trig_Arena_Leave_Player_Conditions))
    call TriggerAddAction(gg_trg_Arena_Leave_Player,function Trig_Arena_Leave_Player_Actions)
endfunction

endlibrary

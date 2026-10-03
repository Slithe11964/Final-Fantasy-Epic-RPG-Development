library TVendetta requires TLoc
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Vendetta_Stance=null
    trigger gg_trg_Vendetta_Release=null
    trigger gg_trg_Vendetta_Cancel=null
endglobals

function Trig_Vendetta_Stance_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0N4') // 'A0N4': ability "!Vendetta"
endfunction

function Trig_Vendetta_Stance_Actions takes nothing returns nothing
    local location l_tempPoint
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateTextTagLocBJ("|cffffcc00COUNTER STANCE",l_tempPoint,0,13.,'d','d','d',0)
    call RemoveLocation(l_tempPoint)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_AbsorbShieldGroup)
    call SaveRealBJ(.5,0,GetHandleIdBJ(GetTriggerUnit()),udg_AbsorbShieldHash)
    set l_tempPoint=null
endfunction

function Trig_Vendetta_Release_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0N4') // 'A0N4': ability "!Vendetta"
endfunction

function Trig_Vendetta_Release_Actions takes nothing returns nothing
    local integer l_tempHandleId
    local location l_tempPoint
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Objects\\Spawnmodels\\NightElf\\NEDeathMedium\\NEDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AbsorbShieldGroup)
    set l_tempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),l_tempPoint,l_tempPoint) // 'h01B': unit "Proxy Dummy"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(l_tempPoint,275.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(l_tempPoint)
    set l_tempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,l_tempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(LoadRealBJ(0,GetHandleIdBJ(GetTriggerUnit()),udg_AbsorbShieldHash),1,l_tempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,l_tempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0N3',GetLastCreatedUnit()) // 'A0N3': ability "Vendetta"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"thunderclap")
    call FlushChildHashtableBJ(GetHandleIdBJ(GetTriggerUnit()),udg_AbsorbShieldHash)
    set l_tempPoint=null
endfunction

function Trig_Vendetta_Cancel_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0N4') // 'A0N4': ability "!Vendetta"
endfunction

function Trig_Vendetta_Cancel_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AbsorbShieldGroup)
endfunction

// World Editor calls InitTrig_Vendetta automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Vendetta (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Vendetta takes nothing returns nothing
endfunction

function Register_Vendetta_Stance takes nothing returns nothing
    set gg_trg_Vendetta_Stance=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Vendetta_Stance,EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    call TriggerAddCondition(gg_trg_Vendetta_Stance,Condition(function Trig_Vendetta_Stance_Conditions))
    call TriggerAddAction(gg_trg_Vendetta_Stance,function Trig_Vendetta_Stance_Actions)
endfunction

function Register_Vendetta_Release takes nothing returns nothing
    set gg_trg_Vendetta_Release=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Vendetta_Release,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(gg_trg_Vendetta_Release,Condition(function Trig_Vendetta_Release_Conditions))
    call TriggerAddAction(gg_trg_Vendetta_Release,function Trig_Vendetta_Release_Actions)
endfunction

function Register_Vendetta_Cancel takes nothing returns nothing
    set gg_trg_Vendetta_Cancel=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Vendetta_Cancel,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    call TriggerAddCondition(gg_trg_Vendetta_Cancel,Condition(function Trig_Vendetta_Cancel_Conditions))
    call TriggerAddAction(gg_trg_Vendetta_Cancel,function Trig_Vendetta_Cancel_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Vendetta takes nothing returns nothing
    call Register_Vendetta_Stance()
    call Register_Vendetta_Release()
    call Register_Vendetta_Cancel()
endfunction

endlibrary

library TVendetta requires TLoc
function Trig_Vendetta_Stance_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0N4') // 'A0N4': ability "!Vendetta"
endfunction

function Trig_Vendetta_Stance_Actions takes nothing returns nothing
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateTextTagLocBJ("|cffffcc00COUNTER STANCE",udg_TempPoint,0,13.,'d','d','d',0)
    call RemoveLocation(udg_TempPoint)
    call SetTextTagVelocityBJ(GetLastCreatedTextTag(),80.,90)
    call SetTextTagPermanentBJ(GetLastCreatedTextTag(),false)
    call SetTextTagLifespanBJ(GetLastCreatedTextTag(),1.5)
    call SetTextTagFadepointBJ(GetLastCreatedTextTag(),1.)
    call ShowTextTagForceBJ(false,GetLastCreatedTextTag(),GetPlayersAll())
    call ShowTextTagForceBJ(true,GetLastCreatedTextTag(),udg_AbilityTextForce)
    call GroupAddUnitSimple(GetTriggerUnit(),udg_AbsorbShieldGroup)
    call SaveRealBJ(.5,0,GetHandleIdBJ(GetTriggerUnit()),udg_AbsorbShieldHash)
endfunction

function Trig_Vendetta_Release_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0N4') // 'A0N4': ability "!Vendetta"
endfunction

function Trig_Vendetta_Release_Actions takes nothing returns nothing
    call AddSpecialEffectTargetUnitBJ("origin",GetTriggerUnit(),"Objects\\Spawnmodels\\NightElf\\NEDeathMedium\\NEDeath.mdl")
    call DestroyEffectBJ(GetLastCreatedEffectBJ())
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AbsorbShieldGroup)
    set udg_TempPoint=GetUnitLoc(GetTriggerUnit())
    call CreateNUnitsAtLocFacingLocBJ(1,'h01B',GetOwningPlayer(GetTriggerUnit()),udg_TempPoint,udg_TempPoint) // 'h01B': unit "Proxy Dummy"
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        // (loop counter A treated as a decimal-capable number) times (60).
        set udg_TempPoint2=Loc_PolarOffset(udg_TempPoint,275.,(I2R(GetForLoopIndexA())*60.))
        call AddSpecialEffectLocBJ(udg_TempPoint2,"Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl")
        call DestroyEffectBJ(GetLastCreatedEffectBJ())
        call RemoveLocation(udg_TempPoint2)
        set bj_forLoopAIndex=bj_forLoopAIndex+1
    endloop
    call RemoveLocation(udg_TempPoint)
    set udg_TempHandleId=GetHandleIdBJ(GetLastCreatedUnit())
    call SaveUnitHandleBJ(GetTriggerUnit(),0,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveRealBJ(LoadRealBJ(0,GetHandleIdBJ(GetTriggerUnit()),udg_AbsorbShieldHash),1,udg_TempHandleId,udg_ProxyDamageHash)
    call SaveIntegerBJ(4,2,udg_TempHandleId,udg_ProxyDamageHash)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(2.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0N3',GetLastCreatedUnit()) // 'A0N3': ability "Vendetta"
    call IssueImmediateOrderBJ(GetLastCreatedUnit(),"thunderclap")
    call FlushChildHashtableBJ(GetHandleIdBJ(GetTriggerUnit()),udg_AbsorbShieldHash)
endfunction

function Trig_Vendetta_Cancel_Conditions takes nothing returns boolean
    return(GetSpellAbilityId()=='A0N4') // 'A0N4': ability "!Vendetta"
endfunction

function Trig_Vendetta_Cancel_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_AbsorbShieldGroup)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Vendetta takes nothing returns nothing
endfunction

function RegisterR11_Vendetta_Stance takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vendetta_Stance=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Vendetta_Stance,EVENT_PLAYER_UNIT_SPELL_CHANNEL)

call TriggerAddCondition(gg_trg_Vendetta_Stance,Condition(function Trig_Vendetta_Stance_Conditions))

call TriggerAddAction(gg_trg_Vendetta_Stance,function Trig_Vendetta_Stance_Actions)

endfunction




function RegisterR11_Vendetta_Release takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vendetta_Release=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Vendetta_Release,EVENT_PLAYER_UNIT_SPELL_EFFECT)

call TriggerAddCondition(gg_trg_Vendetta_Release,Condition(function Trig_Vendetta_Release_Conditions))

call TriggerAddAction(gg_trg_Vendetta_Release,function Trig_Vendetta_Release_Actions)

endfunction




function RegisterR11_Vendetta_Cancel takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_Vendetta_Cancel=CreateTrigger()

call TriggerRegisterAnyUnitEventBJ(gg_trg_Vendetta_Cancel,EVENT_PLAYER_UNIT_SPELL_ENDCAST)

call TriggerAddCondition(gg_trg_Vendetta_Cancel,Condition(function Trig_Vendetta_Cancel_Conditions))

call TriggerAddAction(gg_trg_Vendetta_Cancel,function Trig_Vendetta_Cancel_Actions)

endfunction




endlibrary

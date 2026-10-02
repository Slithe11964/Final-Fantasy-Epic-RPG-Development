library TArtifact requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Artifact_Ping=null
    trigger gg_trg_Artifact_PickedUp=null
    trigger gg_trg_Artifact_Carrier=null
endglobals

function Trig_Artifact_Ping_ArtifactSpawned takes nothing returns boolean
    return(udg_QuestItem[$B]!=null)or(udg_HashmalumStage>0) // $B = 11
endfunction

function Trig_Artifact_Ping_Conditions takes nothing returns boolean
    return(Trig_Artifact_Ping_ArtifactSpawned())
endfunction

function Trig_Artifact_Ping_ArtifactCarried takes nothing returns boolean
    return(IsItemOwned(udg_QuestItem[$B]))or(udg_HashmalumStage>0) // $B = 11
endfunction

function Trig_Artifact_Ping_ShouldPingCid takes nothing returns boolean
    return(Trig_Artifact_Ping_ArtifactCarried())
endfunction

function Trig_Artifact_Ping_Actions takes nothing returns nothing
    if(Trig_Artifact_Ping_ShouldPingCid())then
        set udg_TempPoint=GetUnitLoc(gg_unit_Hpb1_0013)
    else
        set udg_TempPoint=GetItemLoc(udg_QuestItem[$B]) // $B = 11
    endif
    call PingMinimapLocForForceEx(GetPlayersAll(),udg_TempPoint,2.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',80.,.0)
    call RemoveLocation(udg_TempPoint)
endfunction

function Trig_Artifact_PickedUp_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='sehr') // 'sehr': item "Mysterious Artifact"
endfunction

function Trig_Artifact_PickedUp_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call QuestMessageBJ(Force_OfPlayer(GetOwningPlayer(GetManipulatingUnit())),bj_QUESTMESSAGE_UPDATED,"Bring the artifact to Cid.")
    call QuestSetDescriptionBJ(udg_MainQuest[2],"Bring mysterious artifact to Cid.")
    call EnableTrigger(gg_trg_Cid_Berserk_Start)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Artifact_Carrier_Conditions takes nothing returns boolean
    return(GetItemTypeId(GetManipulatedItem())=='sehr') // 'sehr': item "Mysterious Artifact"
endfunction

function Trig_Artifact_Carrier_Actions takes nothing returns nothing
    set udg_ArtifactCarrier=GetTriggerUnit()
endfunction

// World Editor calls InitTrig_Artifact automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Artifact (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Artifact takes nothing returns nothing
endfunction

function Register_Artifact_Ping takes nothing returns nothing
    set gg_trg_Artifact_Ping=CreateTrigger()
    call DisableTrigger(gg_trg_Artifact_Ping)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Artifact_Ping,15.)
    call TriggerAddCondition(gg_trg_Artifact_Ping,Condition(function Trig_Artifact_Ping_Conditions))
    call TriggerAddAction(gg_trg_Artifact_Ping,function Trig_Artifact_Ping_Actions)
endfunction

function Register_Artifact_PickedUp takes nothing returns nothing
    set gg_trg_Artifact_PickedUp=CreateTrigger()
    call DisableTrigger(gg_trg_Artifact_PickedUp)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Artifact_PickedUp,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Artifact_PickedUp,Condition(function Trig_Artifact_PickedUp_Conditions))
    call TriggerAddAction(gg_trg_Artifact_PickedUp,function Trig_Artifact_PickedUp_Actions)
endfunction

function Register_Artifact_Carrier takes nothing returns nothing
    set gg_trg_Artifact_Carrier=CreateTrigger()
    call DisableTrigger(gg_trg_Artifact_Carrier)
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Artifact_Carrier,EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_Artifact_Carrier,Condition(function Trig_Artifact_Carrier_Conditions))
    call TriggerAddAction(gg_trg_Artifact_Carrier,function Trig_Artifact_Carrier_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Artifact takes nothing returns nothing
    call Register_Artifact_Ping() // starts off; enabled by GoblinChief; disabled by Cid, TrueIceAge
    call Register_Artifact_PickedUp() // starts off; enabled by GoblinChief
    call Register_Artifact_Carrier() // starts off; enabled by GoblinChief; disabled by Cid, Cine, TrueIceAge
endfunction

endlibrary

library TTurks requires TForce, TPlayerHero, TUnit
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Turks_Give_Flute=null
endglobals

function Trig_Turks_Give_Flute_IsTurk takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n012_0163)or(GetTriggerUnit()==gg_unit_n013_0164)
endfunction

function Trig_Turks_Give_Flute_IsChosenTurk takes nothing returns boolean
    return(udg_FluteHolder==GetTriggerUnit())or(udg_FluteHolder==null)
endfunction

function Trig_Turks_Give_Flute_Conditions takes nothing returns boolean
    return(Trig_Turks_Give_Flute_IsTurk())and(Trig_Turks_Give_Flute_IsChosenTurk())and(Unit_PlayersNearby(udg_TalkRange,GetTriggerUnit(),false,true,true))
endfunction

function Trig_Turks_Give_Flute_IsFirstTurk takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n012_0163)
endfunction

function Trig_Turks_Give_Flute_IsFirstTurk_Pick takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n012_0163)
endfunction

function Trig_Turks_Give_Flute_NoTurkChosen takes nothing returns boolean
    return(udg_FluteHolder==null)
endfunction

function Trig_Turks_Give_Flute_Actions takes nothing returns nothing
    call GroupRemoveUnitSimple(GetTriggerUnit(),udg_QuestUnits)
    if(Trig_Turks_Give_Flute_IsFirstTurk())then
        call DestroyEffectBJ(udg_QuestMarkerEffect[2])
    else
        call DestroyEffectBJ(udg_QuestMarkerEffect[3])
    endif
    if(Trig_Turks_Give_Flute_NoTurkChosen())then
        if(Trig_Turks_Give_Flute_IsFirstTurk_Pick())then
            set udg_FluteHolder=gg_unit_n013_0164
        else
            set udg_FluteHolder=gg_unit_n012_0163
        endif
        set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
        call TransmissionFromUnitWithNameBJ(udg_TempForce,GetTriggerUnit(),GetUnitName(GetTriggerUnit()),null,("Eiko's Flute? No, I don't have it, try talking to "+(GetUnitName(udg_FluteHolder)+".")),bj_TIMETYPE_SET,5.,false)
        call DestroyForce(udg_TempForce)
    else
        call DisableTrigger(GetTriggeringTrigger())
        call TransmissionFromUnitWithNameBJ(udg_PlayingPlayers,GetTriggerUnit(),GetUnitName(GetTriggerUnit()),null,"Eiko's Flute? Yes, I have it here. Here you go.",bj_TIMETYPE_SET,5.,false)
        call UnitAddItemByIdSwapped('I0E9',Player_GetHero(GetTriggerPlayer())) // 'I0E9': item "Eiko's Flute"
        call SetItemInvulnerableBJ(GetLastCreatedItem(),true)
        set udg_QuestItem[$B]=GetLastCreatedItem() // $B = 11
        call GroupAddUnitSimple(gg_unit_Othr_0106,udg_QuestUnits)
        call EnableTrigger(gg_trg_AoMadoushi_Summon)
        set udg_CidQuestStage=$A // $A = 10
        call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Find Ao Madoushi's hut and play the flute to make him appear.")
        call QuestSetDescriptionBJ(udg_MainQuest[4],"Find Ao Madoushi's hut and play the flute to make him appear.")
        set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
        call CreateNUnitsAtLoc(1,'n00V',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n00V': unit "Ancient Bear"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
        call CreateNUnitsAtLoc(1,'n00U',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n00U': unit "Dire Bear"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        set udg_TempPoint=GetRandomLocInRect(gg_rct_189)
        call CreateNUnitsAtLoc(1,'n00T',Player($B),udg_TempPoint,GetRandomDirectionDeg()) // 'n00T': editor label "Bear"; $B = 11
        call RemoveLocation(udg_TempPoint)
        call Unit_ScaleToLevel60(bj_lastCreatedUnit)
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction

// World Editor calls InitTrig_Turks automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Turks (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Turks takes nothing returns nothing
endfunction

function Register_Turks_Give_Flute takes nothing returns nothing
    set gg_trg_Turks_Give_Flute=CreateTrigger()
    call DisableTrigger(gg_trg_Turks_Give_Flute)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Turks_Give_Flute,Player(7),true)
    call TriggerAddCondition(gg_trg_Turks_Give_Flute,Condition(function Trig_Turks_Give_Flute_Conditions))
    call TriggerAddAction(gg_trg_Turks_Give_Flute,function Trig_Turks_Give_Flute_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Turks takes nothing returns nothing
    call Register_Turks_Give_Flute() // starts off; enabled by Cid; disabled by TrueIceAge
endfunction

endlibrary

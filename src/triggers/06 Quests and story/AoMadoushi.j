library TAoMadoushi
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_AoMadoushi_Hide=null
    trigger gg_trg_AoMadoushi_Summon=null
    // Variables only this module uses (MapBootstrap sets some starting values).
    sound gg_snd_LoadUnload=null
endglobals

function Trig_AoMadoushi_Hide_Actions takes nothing returns nothing
    set udg_AoMadoushiFacing=GetUnitFacing(gg_unit_Othr_0106)
    set udg_AoMadoushiLoc=GetUnitLoc(gg_unit_Othr_0106)
    call ShowUnitHide(gg_unit_Othr_0106)
    call SetUnitInvulnerable(gg_unit_Othr_0106,true)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_AoMadoushi_Summon_Conditions takes nothing returns boolean
    return(IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers))and(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I0E9')) // 'I0E9': item "Eiko's Flute"
endfunction

function Trig_AoMadoushi_Summon_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0E9')) // 'I0E9': item "Eiko's Flute"
    call PlaySoundOnUnitBJ(gg_snd_LoadUnload,'d',gg_unit_Othr_0106)
    set udg_SpecialEffect[21]=AddSpecialEffectTargetUnitBJ("overhead",gg_unit_Othr_0106,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
    call ShowUnitShow(gg_unit_Othr_0106)
    set udg_CidQuestStage=$B // $B = 11
    call QuestMessageBJ(udg_PlayingPlayers,bj_QUESTMESSAGE_UPDATED,"Talk to Ao Madoushi.")
    call ExecuteFunc("QuestAoMadoushi_Summoned")
    call EnableTrigger(gg_trg_Quest_AoMadoushi_Talk)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_AoMadoushi automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_AoMadoushi (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_AoMadoushi takes nothing returns nothing
endfunction

function Register_AoMadoushi_Hide takes nothing returns nothing
    set gg_trg_AoMadoushi_Hide=CreateTrigger()
    call TriggerAddAction(gg_trg_AoMadoushi_Hide,function Trig_AoMadoushi_Hide_Actions)
endfunction

function Register_AoMadoushi_Summon takes nothing returns nothing
    set gg_trg_AoMadoushi_Summon=CreateTrigger()
    call DisableTrigger(gg_trg_AoMadoushi_Summon)
    call TriggerRegisterUnitInRangeSimple(gg_trg_AoMadoushi_Summon,450.,gg_unit_Othr_0106)
    call TriggerAddCondition(gg_trg_AoMadoushi_Summon,Condition(function Trig_AoMadoushi_Summon_Conditions))
    call TriggerAddAction(gg_trg_AoMadoushi_Summon,function Trig_AoMadoushi_Summon_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_AoMadoushi takes nothing returns nothing
    call Register_AoMadoushi_Hide() // run by MapBootstrap
    call Register_AoMadoushi_Summon() // starts off; enabled by Turks; disabled by TrueIceAge
endfunction

endlibrary

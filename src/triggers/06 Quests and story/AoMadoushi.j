library TAoMadoushi
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
    call QuestSetDescriptionBJ(udg_MainQuest[4],"Talk to Ao Madoushi.")
    call EnableTrigger(gg_trg_Quest_AoMadoushi_Talk)
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_AoMadoushi takes nothing returns nothing
endfunction

function RegisterR11_AoMadoushi_Hide takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_AoMadoushi_Hide=CreateTrigger()

call TriggerAddAction(gg_trg_AoMadoushi_Hide,function Trig_AoMadoushi_Hide_Actions)

endfunction




function RegisterR11_AoMadoushi_Summon takes nothing returns nothing

if not udg_InitTrigFromMain then

return

endif

set gg_trg_AoMadoushi_Summon=CreateTrigger()

call DisableTrigger(gg_trg_AoMadoushi_Summon)

call TriggerRegisterUnitInRangeSimple(gg_trg_AoMadoushi_Summon,450.,gg_unit_Othr_0106)

call TriggerAddCondition(gg_trg_AoMadoushi_Summon,Condition(function Trig_AoMadoushi_Summon_Conditions))

call TriggerAddAction(gg_trg_AoMadoushi_Summon,function Trig_AoMadoushi_Summon_Actions)

endfunction




endlibrary

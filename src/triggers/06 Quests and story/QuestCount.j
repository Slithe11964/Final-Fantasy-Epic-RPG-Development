library TQuestCount
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_QuestCount_Milestones=null
    // Variables only this module uses.
    boolean udg_QuestCountLocked=false
endglobals

function Trig_QuestCount_Milestones_Conditions takes nothing returns boolean
    return(udg_QuestCountLocked==false)
endfunction

function Trig_QuestCount_Milestones_CountIs4 takes nothing returns boolean
    return(udg_StoryProgress==4)
endfunction

function Trig_QuestCount_Milestones_CountIs6 takes nothing returns boolean
    return(udg_StoryProgress==6)
endfunction

function Trig_QuestCount_Milestones_CountIs8 takes nothing returns boolean
    return(udg_StoryProgress==8)
endfunction

function Trig_QuestCount_Milestones_Actions takes nothing returns nothing
    call SetPlayerTechResearchedSwap('R021',udg_StoryProgress,Player($A)) // 'R021': upgrade "Naisha Powerup"; $A = 10
    if(Trig_QuestCount_Milestones_CountIs4())then
        call ConditionalTriggerExecute(gg_trg_Elixir_Prepare)
    endif
    if(Trig_QuestCount_Milestones_CountIs6())then
        call RemoveItemFromStockBJ('I08P',gg_unit_n02Y_0052) // 'I08P': item "Information: Welcome to Kalm!"
        call ConditionalTriggerExecute(gg_trg_Quest_Phoenix_Available)
        call ConditionalTriggerExecute(gg_trg_LadyCurse_ShowMarker)
    endif
    if(Trig_QuestCount_Milestones_CountIs8())then
        call ConditionalTriggerExecute(gg_trg_Shinra_TalkPrepare)
    endif
endfunction

// World Editor calls InitTrig_QuestCount automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_QuestCount (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_QuestCount takes nothing returns nothing
endfunction

function Register_QuestCount_Milestones takes nothing returns nothing
    set gg_trg_QuestCount_Milestones=CreateTrigger()
    call DisableTrigger(gg_trg_QuestCount_Milestones)
    call TriggerAddCondition(gg_trg_QuestCount_Milestones,Condition(function Trig_QuestCount_Milestones_Conditions))
    call TriggerAddAction(gg_trg_QuestCount_Milestones,function Trig_QuestCount_Milestones_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_QuestCount takes nothing returns nothing
    call Register_QuestCount_Milestones()
endfunction

endlibrary

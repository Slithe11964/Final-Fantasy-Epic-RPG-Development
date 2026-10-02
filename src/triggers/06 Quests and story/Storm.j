library TStorm requires TCam, TCine, TText
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Storm_Greet=null
endglobals

function Trig_Storm_Greet_Conditions takes nothing returns boolean
    return(GetTriggerUnit()==gg_unit_n007_0105)and(udg_InCinematicMode==false)
endfunction

function Trig_Storm_Greet_Cond_ShowStormTalk takes nothing returns boolean
    return(udg_CinematicsDisabled==false)
endfunction

function Trig_Storm_Greet_Cond_InfoNotStocked takes nothing returns boolean
    return(udg_QuestFlag[3]==false)
endfunction

function Trig_Storm_Greet_Actions takes nothing returns nothing
    call DisableTrigger(GetTriggeringTrigger())
    call DestroyEffectBJ(udg_SpecialEffect[18])
    if(Trig_Storm_Greet_Cond_ShowStormTalk())then
        call Cine_Enter()
        call Cam_PanToUnit(GetTriggerUnit(),0)
        call Text_Transmission(gg_unit_n007_0105,"Storm","Greetings to you. I am Storm and I can offer you help.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","The spirit that follows you is the benevolent spirit of this planet.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","I have never witnessed that before, so I think that there must be something special about you.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","I am familiar with the spirits of this land and I can perform certain rituals that will empower your spirit of Gaya.","(null)",null,0,false)
        call Text_Transmission(gg_unit_n007_0105,"Storm","I will be glad to help you, but I still require gold for my services - rituals I perform require rare and exotic ingredients that are hard to find.","(null)",null,0,false)
        call Cine_ExitAction()
    endif
    if(Trig_Storm_Greet_Cond_InfoNotStocked())then
        call AddItemToStockBJ('I05F',gg_unit_n02Y_0052,1,1) // 'I05F': item "Information: Mystical Glyph"
        set udg_QuestFlag[3]=true
    endif
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Storm automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Storm (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Storm takes nothing returns nothing
endfunction

function Register_Storm_Greet takes nothing returns nothing
    set gg_trg_Storm_Greet=CreateTrigger()
    call DisableTrigger(gg_trg_Storm_Greet)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(0),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(1),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(2),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(3),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(4),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(5),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(6),true)
    call TriggerRegisterPlayerSelectionEventBJ(gg_trg_Storm_Greet,Player(7),true)
    call TriggerAddCondition(gg_trg_Storm_Greet,Condition(function Trig_Storm_Greet_Conditions))
    call TriggerAddAction(gg_trg_Storm_Greet,function Trig_Storm_Greet_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Storm takes nothing returns nothing
    call Register_Storm_Greet()
endfunction

endlibrary

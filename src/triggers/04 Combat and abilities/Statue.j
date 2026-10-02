library TStatue
function Trig_Statue_Keeper_Anim_Actions takes nothing returns nothing
    call SetDoodadAnimationRectBJ("stand alternate",'AOks',gg_rct_448) // 'AOks': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_Statue_Guardian_Anim_Actions takes nothing returns nothing
    call SetDoodadAnimationRectBJ("stand alternate",'AOgs',gg_rct_449) // 'AOgs': object name not found in map data
    call DestroyTrigger(GetTriggeringTrigger())
endfunction

// World Editor calls InitTrig_Statue automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Statue (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Statue takes nothing returns nothing
endfunction

function Register_Statue_Keeper_Anim takes nothing returns nothing
    set gg_trg_Statue_Keeper_Anim=CreateTrigger()
    call TriggerAddAction(gg_trg_Statue_Keeper_Anim,function Trig_Statue_Keeper_Anim_Actions)
endfunction

function Register_Statue_Guardian_Anim takes nothing returns nothing
    set gg_trg_Statue_Guardian_Anim=CreateTrigger()
    call TriggerAddAction(gg_trg_Statue_Guardian_Anim,function Trig_Statue_Guardian_Anim_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Statue takes nothing returns nothing
    call Register_Statue_Keeper_Anim()
    call Register_Statue_Guardian_Anim()
endfunction

endlibrary

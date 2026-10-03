library TTeleporters requires TForce
globals
    // Trigger variables. Each is created by the matching Register_* function in this module.
    trigger gg_trg_Teleporters_Command=null
endglobals

function Trig_Teleporters_Command_Actions takes nothing returns nothing
    local force l_tempForce
    set l_tempForce=Force_OfPlayer(GetTriggerPlayer())
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_394),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_395),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_396),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_397),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_398),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_399),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_400),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_401),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_402),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_403),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(l_tempForce,GetRectCenter(gg_rct_456),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call DestroyForce(l_tempForce)
    set l_tempForce=null
endfunction

// World Editor calls InitTrig_Teleporters automatically; it is intentionally empty. This module's
// triggers are created by RegisterTriggers_Teleporters (bottom of this module), which
// MapBootstrap's Startup_RegisterTriggers runs at the right point during startup.
function InitTrig_Teleporters takes nothing returns nothing
endfunction

function Register_Teleporters_Command takes nothing returns nothing
    set gg_trg_Teleporters_Command=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(0),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(1),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(2),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(3),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(4),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(5),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(6),"-teleporters",true)
    call TriggerRegisterPlayerChatEvent(gg_trg_Teleporters_Command,Player(7),"-teleporters",true)
    call TriggerAddAction(gg_trg_Teleporters_Command,function Trig_Teleporters_Command_Actions)
endfunction

// Creates this module's triggers. Called once at startup from Startup_RegisterTriggers (MapBootstrap).
function RegisterTriggers_Teleporters takes nothing returns nothing
    call Register_Teleporters_Command()
endfunction

endlibrary

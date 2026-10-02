library TTeleporters requires TForce
function Trig_Teleporters_Command_Actions takes nothing returns nothing
    set udg_TempForce=Force_OfPlayer(GetTriggerPlayer())
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_394),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_395),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_396),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_397),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_398),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_399),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_400),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_401),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_402),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_403),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call PingMinimapLocForForceEx(udg_TempForce,GetRectCenter(gg_rct_456),3.,bj_MINIMAPPINGSTYLE_SIMPLE,'d',60.,20.)
    call DestroyForce(udg_TempForce)
endfunction

// Registration ownership; called at the original bootstrap positions.
function InitTrig_Teleporters takes nothing returns nothing
endfunction
function RegisterR11_Teleporters_Command takes nothing returns nothing
    if not udg_InitTrigFromMain then
        return
    endif
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




endlibrary

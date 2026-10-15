library TCheckpointStrings requires TForsakenFreshLoad
// Diagnostic copy only. Never included in normal gameplay builds.
globals
    string CheckpointStrings_Value=null
endglobals

function CheckpointStrings_Run takes nothing returns nothing
    local integer i=0
    local player owner=GetTriggerPlayer()
    if CheckpointStrings_Value!=null then
        call DisplayTimedTextToPlayer(owner,0.,0.,30.,"String diagnostic already ran. Use a fresh game for another test.")
        set owner=null
        return
    endif
    set CheckpointStrings_Value=""
    loop
        exitwhen i>=1500
        set CheckpointStrings_Value=CheckpointStrings_Value+"A"
        set i=i+1
    endloop
    call DisplayTimedTextToPlayer(owner,0.,0.,120.,"String diagnostic: created "+I2S(StringLength(CheckpointStrings_Value))+" characters. Make a NEW Warcraft menu save, fully exit, restart and load it. Character and inventory were not changed.")
    set owner=null
endfunction

function InitTrig_CheckpointStrings takes nothing returns nothing
    local integer pid=0
    set gg_trg_CheckpointStrings=CreateTrigger()
    loop
        exitwhen pid>=8
        call TriggerRegisterPlayerChatEvent(gg_trg_CheckpointStrings,Player(pid),"-checkpointstrings",true)
        set pid=pid+1
    endloop
    call TriggerAddAction(gg_trg_CheckpointStrings,function CheckpointStrings_Run)
endfunction
endlibrary

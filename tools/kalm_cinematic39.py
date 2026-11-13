"""Quiesce the gear presentation before Kalm's native cinematic transition."""
import re

from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations
from session_v22 import WHEEL


def refresh(source):
    fs = functions(source)
    if "Cine_Enter" in fs and "C20_UIPause" in fs["Cine_Enter"]:
        source = declarations(source, ["boolean Cine_KalmDrain=false"])
        original = fs["Cine_Enter"]
        entry = original.replace("function Cine_Enter takes nothing", "function Cine_EnterPrepared takes boolean settle", 1)
        entry = entry.replace("    set udg_InCinematicMode=true", "    set Cine_KalmDrain=settle\n    set udg_InCinematicMode=true", 1)
        entry = entry.replace("    call ClearSelection()", """    // Give the hidden frame tree a render interval before the native transition.
    if settle then
        call TriggerSleepAction(.15)
    endif
    call ClearSelection()""", 1)
        assert entry != original and "call TriggerSleepAction(.15)" in entry
        wrappers = """function Cine_Enter takes nothing returns nothing
    call Cine_EnterPrepared(false)
endfunction

function Cine_EnterKalm takes nothing returns nothing
    call Cine_EnterPrepared(true)
endfunction"""
        source = put(source, "Cine_Enter", entry.strip() + "\n\n" + wrappers)
        exit_body = fs["Cine_Exit"]
        marker = "    set udg_InCinematicMode=false"
        assert exit_body.count(marker) == 1
        exit_body = exit_body.replace(marker, """    if Cine_KalmDrain then
        call TriggerSleepAction(bj_CINEMODE_INTERFACEFADE)
        set Cine_KalmDrain=false
    endif
""" + marker, 1)
        source = put(source, "Cine_Exit", exit_body)
    for name, body in fs.items():
        if re.match(r"^Trig_KalmSiege[123]_", name) and "call Cine_Enter()" in body:
            source = put(source, name, body.replace("call Cine_Enter()", "call Cine_EnterKalm()"))
    if "QuickGear_DrawWheel" in fs:
        source = put(source, "QuickGear_DrawWheel", WHEEL)
        init = fs["QuickGear_Init"]
        block = r"(?m)^        set QuickGearNativeWheel\[slot\]=BlzCreateFrameByType\([^\n]+\n(?:^        call BlzFrame[^\n]+QuickGearNativeWheel\[slot\][^\n]*\n)+"
        init, removed = re.subn(block, "", init)
        assert removed == 1
        init = re.sub(r"(?m)^        // Preserve the original animated cooldown[^\n]*\n(?:^        //[^\n]*\n){0,2}(?=        if slot==0 then)", "", init)
        source = put(source, "QuickGear_Init", init)
        hide = fs["C20_HideUI"]
        marker = "    call Forsaken_CloseBackpack()\n"
        assert hide.count(marker) == 1
        hide = hide.replace(marker, "", 1)
        hide = hide.replace("    call QuickGear_ClearPreview()", marker + "    call QuickGear_ClearPreview()", 1)
        source = put(source, "C20_HideUI", hide)
        pause = fs["C23_PauseControls"]
        if "trigger GearProbeEvents62" in source or "function GearProbe_Init62" in fs:
            pause = pause.replace("    loop\n        exitwhen i>=22", "    set C23Control[22]=GearProbeEvents62\n    loop\n        exitwhen i>=23", 1)
            source = put(source, "C23_PauseControls", pause)
            resume = fs["C23_ResumeControls"].replace("exitwhen i>=22", "exitwhen i>=23", 1)
            source = put(source, "C23_ResumeControls", resume)
    if "Armory_PollCounter" in fs:
        poll = fs["Armory_PollCounter"]
        marker = "    local integer revision\n"
        assert poll.count(marker) == 1
        poll = poll.replace(marker, marker + "    if udg_InCinematicMode or InventoryCinematicActive then\n        set viewer=null\n        return\n    endif\n", 1)
        source = put(source, "Armory_PollCounter", poll)
    return source

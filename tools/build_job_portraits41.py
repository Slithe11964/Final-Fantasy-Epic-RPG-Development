"""Fix the job-switch portrait order and keep travel shortcuts accessible."""
from pathlib import Path

from build_control_order40 import build
from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations

ROOT = Path(__file__).resolve().parents[1]
JOB_CHANGE = "Trig_Job_Change_Actions"


def refresh_job_order(source):
    fs = functions(source)
    if JOB_CHANGE not in fs:
        return source
    body = fs[JOB_CHANGE]
    restore = """    if gaya!=null then
        call SetUnitOwner(gaya,jobOwner,false)
    endif
    set gaya=null
"""
    show = "    call ShowUnitShow(jobNext)\n"
    assert body.count(restore) == body.count(show) == 1
    body = body.replace("    local unit gaya=null", "    local unit gaya=null\n    local boolean gayaWasVisible=false", 1)
    detach = "        call SetUnitOwner(gaya,Player(PLAYER_NEUTRAL_PASSIVE),false)"
    assert body.count(detach) == 1
    body = body.replace(detach, """        set gayaWasVisible=not IsUnitHidden(gaya)
        if gayaWasVisible then
            call ShowUnit(gaya,false)
        endif
""" + detach, 1)
    body = body.replace(restore, "", 1)
    restore = restore.replace("        call SetUnitOwner(gaya,jobOwner,false)", """        call SetUnitOwner(gaya,jobOwner,false)
        if gayaWasVisible then
            call ShowUnit(gaya,true)
        endif""", 1)
    body = body.replace(show, show + restore, 1)
    return put(source, JOB_CHANGE, body)


def refresh(source):
    source = refresh_job_order(source)
    fs = functions(source)
    if "TravelPanel_Render" not in fs:
        return source
    source = declarations(source, ["boolean TravelModalActive=false", "unit TravelModalPreviousUnit=null"])
    render = fs["TravelPanel_Render"]
    marker = "    local real stride=.04"
    assert render.count(marker) == 1
    render = render.replace(marker, marker + "\n    local unit gaya=null", 1)
    old_lock = "    call EnableUserControl(false)"
    assert render.count(old_lock) == 1
    render = render.replace(old_lock, """    // Keep raw letter-key events available. Native commands have no selection.
    if not TravelModalActive then
        set TravelModalActive=true
        set TravelModalPreviousUnit=Player_GetHero(owner)
        set gaya=udg_SpiritOfGaya[pid+1]
        if gaya!=null and IsUnitSelected(gaya,owner) then
            set TravelModalPreviousUnit=gaya
        endif
        set QuickGearChatOpen=false
        call ClearSelection()
        call BlzEnableSelections(false,true)
    endif
    set gaya=null""", 1)
    source = put(source, "TravelPanel_Render", render)
    hide = fs["Travel_Hide"]
    old_unlock = """        if TravelVisible[pid] and not udg_InCinematicMode and not InventoryCinematicActive then
            call EnableUserControl(true)
        endif"""
    assert hide.count(old_unlock) == 1
    hide = hide.replace(old_unlock, """        if TravelModalActive then
            set TravelModalActive=false
            call BlzEnableSelections(true,true)
            if not udg_InCinematicMode and not InventoryCinematicActive and TravelModalPreviousUnit!=null and GetOwningPlayer(TravelModalPreviousUnit)==owner and not IsUnitHidden(TravelModalPreviousUnit) then
                call SelectUnit(TravelModalPreviousUnit,true)
            endif
            set TravelModalPreviousUnit=null
        endif""", 1)
    return put(source, "Travel_Hide", hide)


if __name__ == "__main__":
    options = dict(transform=refresh, expected_changes={JOB_CHANGE, "TravelPanel_Render", "Travel_Hide"}, expected_added=frozenset())
    build(ROOT / "release/0.9.7.5h/Controls01/FFERPG-0.9.7.5h-Controls01.w3x",
          ROOT / "release/0.9.7.5h/Controls02/FFERPG-0.9.7.5h-Controls02.w3x",
          "FFERPG 0.9.7.5h Controls02", "h Controls01", "h Controls02", **options)
    build(ROOT / "release/development/V40/FFERPG-V40.w3x",
          ROOT / "release/development/V41/FFERPG-V41.w3x",
          "FFERPG V41", "V40", "V41", **options)

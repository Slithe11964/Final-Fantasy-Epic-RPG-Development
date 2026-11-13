"""Keep Gaya behind the active hero and lock gameplay input during travel."""
from jtok import functions
from performance_runtime import put


def refresh(source):
    fs = functions(source)
    if "Trig_Job_Change_Actions" in fs:
        body = fs["Trig_Job_Change_Actions"]
        marker = "    call SetUnitOwner(jobNext,jobOwner,true)"
        assert body.count(marker) == 1
        body = body.replace("    local unit jobNext=null", "    local unit jobNext=null\n    local unit gaya=null", 1)
        body = body.replace(marker, """    // Register the incoming job before the existing Gaya in the native hero list.
    set gaya=udg_SpiritOfGaya[jobPid+1]
    if gaya!=null and GetOwningPlayer(gaya)==jobOwner then
        call SetUnitOwner(gaya,Player(PLAYER_NEUTRAL_PASSIVE),false)
    else
        set gaya=null
    endif
""" + marker + """
    if gaya!=null then
        call SetUnitOwner(gaya,jobOwner,false)
    endif
    set gaya=null""", 1)
        source = put(source, "Trig_Job_Change_Actions", body)
    if "FFL_Commit" in fs:
        body = fs["FFL_Commit"]
        assert body.count("    call ShowUnit(FFN_Unit[pid*3+1],true)") == 1
        body = body.replace("    local integer i=0", "    local integer i=0\n    local unit gaya=FFN_Unit[pid*3+1]", 1)
        body = body.replace("    call ShowUnit(FFN_Unit[pid*3+1],true)\n", "", 1)
        selection = "    call SelectUnitForPlayerSingle(FFN_Unit[(pid * 3)],Player(pid))\n"
        assert body.count(selection) == 1
        body = body.replace(selection, "", 1)
        marker = "    call FFL_RetireStarter(FFL_OldHero[pid])"
        body = body.replace(marker, "    call SetUnitOwner(gaya,Player(PLAYER_NEUTRAL_PASSIVE),false)\n"+marker, 1)
        marker = "    call FFL_RetireSpareHeroes(pid)"
        body = body.replace(marker, marker + """
    call SetUnitOwner(gaya,Player(pid),false)
    call ShowUnit(gaya,true)
    set gaya=null
""" + selection.rstrip(), 1)
        source = put(source, "FFL_Commit", body)
    if "TravelPanel_Render" in fs:
        body = fs["TravelPanel_Render"]
        marker = "    call BlzFrameSetVisible(TravelPanel,true)"
        assert body.count(marker) == 1
        source = put(source, "TravelPanel_Render", body.replace(marker, marker + "\n    call EnableUserControl(false)", 1))
        body = fs["Travel_Hide"]
        marker = "        call BlzFrameSetVisible(TravelPanel,false)"
        assert body.count(marker) == 1
        body = body.replace(marker, marker + """
        if TravelVisible[pid] and not udg_InCinematicMode and not InventoryCinematicActive then
            call EnableUserControl(true)
        endif""", 1)
        source = put(source, "Travel_Hide", body.strip() + """

function Travel_CloseForCinematic takes nothing returns nothing
    local integer pid=0
    loop
        exitwhen pid>=8
        if TravelVisible[pid] then
            call Travel_Hide(Player(pid))
        endif
        set pid=pid+1
    endloop
endfunction""")
    for name, marker, update in (
        ("Travel_Show", "if TravelPanel==null then", "if TravelPanel==null or udg_InCinematicMode or InventoryCinematicActive then"),
        ("Forsaken_RequestBackpackToggle", "if InventoryCinematicActive then", "if InventoryCinematicActive or TravelVisible[GetPlayerId(GetLocalPlayer())] then"),
        ("Forsaken_PanelClick", "if GetLocalPlayer()==viewer then", "if GetLocalPlayer()==viewer and not TravelVisible[GetPlayerId(viewer)] then"),
        ("QuickGear_Request", "    set owner=GetLocalPlayer()", """    set owner=GetLocalPlayer()
if TravelVisible[GetPlayerId(owner)] then
    set owner=null
    return
endif"""),
    ):
        if name not in fs:
            continue
        body = fs[name]
        assert marker in body, name
        source = put(source, name, body.replace(marker, update, 1))
    if "Cine_EnterPrepared" in fs:
        body = fs["Cine_EnterPrepared"]
        marker = "    set InventoryCinematicActive=true"
        assert body.count(marker) == 1
        source = put(source, "Cine_EnterPrepared", body.replace(marker, marker + '\n    call ExecuteFunc("Travel_CloseForCinematic")', 1))
    return source

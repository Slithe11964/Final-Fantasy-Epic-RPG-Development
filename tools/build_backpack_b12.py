"""Move backpack setup out of the UI poll and validate exact item use."""
from pathlib import Path

from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
CHANGES = {"BagB1_Init", "BagB1_Tick", "Register_Forsaken_PanelAccess",
           "QuickGear_Request", "QuickGear_Receive", "BagB1_Click"}


def refresh(source):
    fs = functions(source)
    if "BagB1_Init" not in fs:
        return source

    init = fs["BagB1_Init"]
    init = replace(init, """    local trigger sync=CreateTrigger()
    local timer animation=CreateTimer()""", "")
    init = replace(init, "    call TriggerAddAction(sync,function BagB1_Receive)\n", "")
    init = replace(init, """    set i=0
    loop
        exitwhen i>=8
        call BlzTriggerRegisterPlayerSyncEvent(sync,Player(i),"FFBagB1",false)
        set i=i+1
    endloop
    call TimerStart(animation,1./30.,true,function BagB3_AnimateCooldowns)
    set animation=null
""", "")
    init = replace(init, "    set sync=null\n", "")
    startup = """function BagB12_Startup takes nothing returns nothing
    local integer pid=0
    local trigger inventorySync
    local timer cooldownAnimation
    if Bag04Ready then
        return
    endif
    set inventorySync=CreateTrigger()
    set cooldownAnimation=CreateTimer()
    loop
        exitwhen pid>=8
        call BlzTriggerRegisterPlayerSyncEvent(inventorySync,Player(pid),"FFBagB1",false)
        set pid=pid+1
    endloop
    call TriggerAddAction(inventorySync,function BagB1_Receive)
    call BagB1_Init()
    call TimerStart(cooldownAnimation,1./30.,true,function BagB3_AnimateCooldowns)
    set inventorySync=null
    set cooldownAnimation=null
endfunction"""
    source = put(source, "BagB1_Init", init.strip() + "\n\n" + startup)
    tick = replace(fs["BagB1_Tick"], "        call BagB1_Init()", "        return")
    source = put(source, "BagB1_Tick", tick)
    register = replace(fs["Register_Forsaken_PanelAccess"], '    call ExecuteFunc("QuickGear_Init")',
                       '    call BagB12_Startup()\n    call ExecuteFunc("QuickGear_Init")')
    source = put(source, "Register_Forsaken_PanelAccess", register)

    request = replace(fs["QuickGear_Request"], "    local integer cast",
                      "    local integer cast\n    local integer itemIdentity")
    request = replace(request, "        if LoadInteger(QuickGearData,1,raw)==0", """        if slot>=10 then
            set itemIdentity=GetHandleId(carried)
        else
            set itemIdentity=GetItemUserData(carried)
        endif
        if LoadInteger(QuickGearData,1,raw)==0""")
    request = request.replace("raw,GetItemUserData(carried),0", "raw,itemIdentity,0")
    request = replace(request, "set QuickGearPendingMark=GetItemUserData(carried)",
                      "set QuickGearPendingMark=itemIdentity")
    source = put(source, "QuickGear_Request", request)
    receive = replace(fs["QuickGear_Receive"], "    local integer targetId",
                      "    local integer targetId\n    local integer itemIdentity")
    receive = replace(receive, "    set raw=GetItemTypeId(carried)", """    if slot>=10 then
        set itemIdentity=GetHandleId(carried)
    else
        set itemIdentity=GetItemUserData(carried)
    endif
    set raw=GetItemTypeId(carried)""")
    receive = replace(receive, "GetItemUserData(carried)!=S2I(QuickGear_Field(data,3))",
                      "itemIdentity!=S2I(QuickGear_Field(data,3))")
    source = put(source, "QuickGear_Receive", receive)

    click = replace(fs["BagB1_Click"], "    local integer i=0", "    local integer i=0\n    local item clicked")
    click = replace(click, """                    elseif Bag04ItemId[i]!=0 then
                        call QuickGear_Request(10+i)""", """                    elseif Bag04ItemId[i]>0 then
                        set clicked=QuickGear_Item(Player_GetHero(p),10+i)
                        if clicked!=null and GetHandleId(clicked)==Bag04ItemId[i] then
                            call QuickGear_Request(10+i)
                        endif""")
    click = replace(click, "    set f=null", "    set clicked=null\n    set f=null")
    return put(source, "BagB1_Click", click)


if __name__ == "__main__":
    build(ROOT / "release/development/B11/FFERPG-B11.w3x",
          ROOT / "release/development/B12/FFERPG-B12.w3x",
          "FFERPG B12", "B11", "B12", transform=refresh,
          expected_changes=CHANGES, expected_added={"BagB12_Startup"})

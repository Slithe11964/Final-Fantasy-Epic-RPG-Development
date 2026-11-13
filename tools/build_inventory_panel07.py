"""Standalone Backpack07 layout test, based on the multiplayer-tested Backpack06."""
from pathlib import Path
import sys

import build_inventory_panel06 as panel
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "release/development/InventoryPanel07/FFERPG-Independent-Backpack-07.w3x"
NAME = "FFERPG Backpack07"


def source_for(source):
    fs = functions(source)
    init = fs["Bag04_Init"]
    init = init.replace("    local framehandle model", "    local framehandle portrait\n    local framehandle console", 1)
    marker = "    call BlzFrameSetAbsPoint(Bag04Root,FRAMEPOINT_BOTTOMRIGHT,.797,.166)"
    assert marker in init
    init = init.replace(marker, """    set console=BlzGetFrameByName("ConsoleBottomBar",0)
    if console==null then
        call BlzFrameSetAbsPoint(Bag04Root,FRAMEPOINT_BOTTOMRIGHT,.8,.16)
    else
        call BlzFrameSetPoint(Bag04Root,FRAMEPOINT_BOTTOMRIGHT,console,FRAMEPOINT_TOPRIGHT,0.,.03)
    endif
    set console=null""", 1)
    start = init.index('    set model=BlzCreateFrameByType("SPRITE"')
    end = init.index("    set Bag04Close=", start)
    init = init[:start] + r'''    // A bounded icon for the stand-alone tester. No scene model in the UI.
    set portrait=BlzCreateFrameByType("BACKDROP","BagPortrait07",Bag04Gear,"",0)
    call BlzFrameSetPoint(portrait,FRAMEPOINT_CENTER,Bag04Gear,FRAMEPOINT_CENTER,.014,.007)
    call BlzFrameSetSize(portrait,.116,.116)
    call BlzFrameSetTexture(portrait,"ReplaceableTextures\\CommandButtons\\BTNFootman.blp",0,true)
    call BlzFrameSetEnable(portrait,false)
    set portrait=null
    set Bag04Title=Bag04_Text(Bag04Gear,"BagTitle07",.029,-.004,.150,.037,.010,"Inventory Tester")
    call BlzFrameSetTextAlignment(Bag04Title,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
''' + init[end:]
    init = init.replace('Bag04Gear,"X 06",-.010,-.008,.026,.025','Bag04Gear,"X",-.006,-.004,.023,.021',1)
    init = init.replace('Bag04Root,"Drop held item",0.,.024,.090,.022','Bag04Gear,"Drop held item",-.010,-.145,.096,.022',1)
    init = init.replace('    set Bag05Hover=hover','    call BlzFrameSetVisible(Bag04Drop,false)\n    set Bag05Hover=hover',1)
    start = init.index("    set Bag04Access=")
    end = init.index("    set i=0", start)
    init = init[:start] + r'''    set Bag04Access=BlzCreateFrameByType("BUTTON","BagAccess07",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetAllPoints(Bag04Access,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,4))
    call BlzFrameSetLevel(Bag04Access,90)
    set portrait=BlzCreateFrameByType("BACKDROP","BagAccessIcon07",Bag04Access,"",0)
    call BlzFrameSetAllPoints(portrait,Bag04Access)
    call BlzFrameSetTexture(portrait,"ReplaceableTextures\\CommandButtons\\BTNBackpack.blp",0,true)
    call BlzFrameSetEnable(portrait,false)
    set portrait=Bag04_Text(Bag04Access,"BagAccessKey07",.002,-.001,.015,.015,.010,"B")
    set portrait=null
    call BlzTriggerRegisterFrameEvent(Bag04ClickTrigger,Bag04Access,FRAMEEVENT_CONTROL_CLICK)
''' + init[end:]
    init = init.replace("    set model=null", "", 1)
    source = put(source, "Bag04_Init", init)
    slots = fs["Bag05_InitSlots"]
    marker = "        call BlzFrameSetSize(Bag04Button[i],.03125,.03125)"
    assert marker in slots
    slots = slots.replace(marker, marker + """
        if i>=39 then
            call BlzFrameClearAllPoints(Bag04Button[i])
            call BlzFrameSetAllPoints(Bag04Button[i],BlzGetOriginFrame(ORIGIN_FRAME_ITEM_BUTTON,i-39))
        endif""", 1)
    marker = "        call BlzFrameSetVisible(tip,false)"
    slots = slots.replace(marker, marker + """
        if i>=39 then
            call BlzFrameSetVisible(Bag04Icon[i],false)
            call BlzFrameSetVisible(Bag04Count[i],false)
        endif""", 1)
    source = put(source, "Bag05_InitSlots", slots)
    draw = fs["Bag04_Draw"]
    draw = draw.replace("    call BlzFrameSetText(Bag04Title,", "    call BlzFrameSetVisible(Bag04Drop,Bag04Held>=0)\n    call BlzFrameSetText(Bag04Title,",1)
    source = put(source, "Bag04_Draw", draw)
    instructions = "Backpack07: use B, the backpack icon, or -bag. Right-click an item to move it. Drop held item appears while carrying an item. Use -bagstate to compare both players."
    old = fs["InvCheck_Help"]
    source = put(source, "InvCheck_Help", old.strip().splitlines()[0] + '\n    call DisplayTimedTextToPlayer(p,0.,0.,40.,"' + instructions + '")\nendfunction')
    main = fs["main_old"]
    import re
    main = re.sub(r'call QuestSetDescription\(info,"[^\n]*"\)', 'call QuestSetDescription(info,"'+instructions+'")', main, count=1)
    source = put(source, "main_old", main)
    return source.replace("Bag06 slots=", "Bag07 slots=").replace("Bag06 setup", "Bag07 setup").replace("Bag06 open=", "Bag07 open=")


if __name__ == "__main__":
    panel.OUT = OUT
    panel.NAME = NAME
    panel.source_for = source_for
    panel.build(Path(sys.argv[1]))

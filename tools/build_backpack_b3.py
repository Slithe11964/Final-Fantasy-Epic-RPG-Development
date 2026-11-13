"""Improve replacement backpack counters and animate active cooldowns at 30 Hz."""
from pathlib import Path

from backpack_catalog import setf
from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from mpq import MPQ
from objdata import read_objects, write_objects
from performance_runtime import put
from priest_ultimate import declarations

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "release/development/B2/FFERPG-B2.w3x"
OUTPUT = ROOT / "release/development/B3/FFERPG-B3.w3x"
FDF = r"BagUI\BagTooltip08.fdf"
WHEEL_TICK = """function BagB3_AnimateCooldowns takes nothing returns nothing
    local integer index=0
    local integer slot
    local real now
    local real left
    if not Bag04Open or BagB3Active==0 or InventoryCinematicActive or udg_InCinematicMode then
        return
    endif
    set now=TimerGetElapsed(NativeCDClock)
    loop
        exitwhen index>=BagB3Active
        set slot=BagB3ActiveSlot[index]
        set left=BagB3End[slot]-now
        if left>.01 then
            call BlzFrameSetValue(BagB2Wheel[slot],1.-RMinBJ(1.,left/BagB3Duration[slot]))
        else
            call BlzFrameSetVisible(BagB2Wheel[slot],false)
            call BlzFrameSetVisible(BagB1Cooldown[slot],false)
            set BagB1CooldownText[slot]=""
        endif
        set index=index+1
    endloop
endfunction"""
BADGE = r'''
Frame "BACKDROP" "BagB3ChargeBadge" {
    BackdropTileBackground,
    BackdropBackground "UI\Widgets\Tooltips\Human\human-tooltip-background.blp",
    BackdropEdgeFile "UI\Widgets\Tooltips\Human\human-tooltip-border.blp",
    BackdropCornerFlags "UL|UR|BL|BR|T|L|B|R",
    BackdropCornerSize 0.0025,
    BackdropBackgroundInsets 0.0007 0.0007 0.0007 0.0007,
    BackdropBackgroundSize 0.0625,
    BackdropBlendAll,
}
'''


def refresh(source):
    fs = functions(source)
    if "BagB1_Init" not in fs:
        return source
    source = declarations(source, ["framehandle array BagB3Badge", "integer BagB3Active=0",
                                   "integer array BagB3ActiveSlot", "real array BagB3End",
                                   "real array BagB3Duration"])
    body = replace(fs["Bag04_Control"], '.0015,width,height,.014,', '.0015,width,height,.017,')
    source = put(source, "Bag04_Control", body)
    body = replace(fs["Bag05_InitSlots"], '        set Bag04Count[i]=Bag04_Text(Bag04Button[i],"BagCount04",.012,-.015,.018,.016,.010,"")\n        call BlzFrameSetTextAlignment(Bag04Count[i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)', '''        set BagB3Badge[i]=BlzCreateFrame("BagB3ChargeBadge",Bag04Button[i],0,1300+i)
        call BlzFrameSetPoint(BagB3Badge[i],FRAMEPOINT_BOTTOMRIGHT,Bag04Button[i],FRAMEPOINT_BOTTOMRIGHT,-.0015,.0015)
        call BlzFrameSetSize(BagB3Badge[i],.0115,.0105)
        call BlzFrameSetLevel(BagB3Badge[i],79)
        call BlzFrameSetEnable(BagB3Badge[i],false)
        set Bag04Count[i]=Bag04_Text(BagB3Badge[i],"BagCount04",0.,0.,.0115,.0105,.010,"")
        call BlzFrameSetTextAlignment(Bag04Count[i],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetVisible(BagB3Badge[i],false)''')
    source = put(source, "Bag05_InitSlots", body)
    body = replace(fs["BagB1_Init"], ".046,-.016,.145,.035,.010", ".040,-.016,.145,.035,.010")
    body = replace(body, '    local trigger sync=CreateTrigger()', '    local trigger sync=CreateTrigger()\n    local timer animation=CreateTimer()')
    body = replace(body, "        call BlzFrameSetAllPoints(BagB2Wheel[i],Bag04Button[i])", """        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_TOPLEFT,Bag04Button[i],FRAMEPOINT_TOPLEFT,.003,-.008)
        call BlzFrameSetPoint(BagB2Wheel[i],FRAMEPOINT_BOTTOMRIGHT,Bag04Button[i],FRAMEPOINT_BOTTOMRIGHT,-.003,.002)""")
    body = replace(body, '.0305,.029,.016,"")', '.0295,.029,.030,"")')
    body = replace(body, '    set Bag04Ready=true', '    call TimerStart(animation,1./30.,true,function BagB3_AnimateCooldowns)\n    set animation=null\n    set Bag04Ready=true')
    source = put(source, "BagB1_Init", WHEEL_TICK + "\n\n" + body.strip())
    body = replace(fs["BagB1_Draw"], '    local real duration', '    local real duration\n    local real now=TimerGetElapsed(NativeCDClock)')
    body = replace(body, '    loop\n        exitwhen i>=39', '    set BagB3Active=0\n    loop\n        exitwhen i>=39')
    body = replace(body, '            call BlzFrameSetText(Bag04Count[i],value)', '            call BlzFrameSetText(Bag04Count[i],value)\n            call BlzFrameSetVisible(BagB3Badge[i],value!="")')
    body = replace(body, '            call BlzFrameSetValue(BagB2Wheel[i],1.-RMinBJ(1.,left/RMaxBJ(.01,duration)))', '''            set BagB3ActiveSlot[BagB3Active]=i
            set BagB3Active=BagB3Active+1
            set BagB3End[i]=now+left
            set BagB3Duration[i]=RMaxBJ(.01,duration)
            call BlzFrameSetValue(BagB2Wheel[i],1.-RMinBJ(1.,left/BagB3Duration[i]))''')
    return put(source, "BagB1_Draw", body)


if __name__ == "__main__":
    archive = MPQ(str(BASE))
    table = read_objects(archive.read("war3map.w3a"), "w3a")
    opener = next(obj for obj in table["custom"] if obj["id"] == "bBp1")
    for field in ("acat", "atat", "asat", "aeat", "aefs", "aefl", "aani", "aefs"):
        setf(opener, field, 3, "")
    files = {"war3map.w3a": write_objects(table, table["version"], "w3a"),
             FDF: archive.read(FDF) + BADGE.encode()}
    build(BASE, OUTPUT, "FFERPG B3", "B2", "B3", transform=refresh, extra_files=files,
          expected_changes={"Bag04_Control", "Bag05_InitSlots", "BagB1_Init", "BagB1_Draw"},
          expected_added={"BagB3_AnimateCooldowns"})

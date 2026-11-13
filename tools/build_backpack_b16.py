"""Improve targeting, keyboard focus and held-item feedback in the custom backpack."""
from pathlib import Path

from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations

ROOT = Path(__file__).resolve().parents[1]
CHANGES = {
    "BagB1_Init", "BagB1_Draw", "BagB1_Click", "BagB1_Tick",
    "BagB3_AnimateCooldowns", "Forsaken_BackpackAccess", "QuickGear_Request",
    "Forsaken_PrepareWeaponHand", "BagB1_Receive", "BagB1_RefreshVisibility",
}


def refresh(source):
    fs = functions(source)
    if "BagB1_Init" not in fs:
        return source
    source = declarations(source, ["framehandle BagB16HeldIcon", "framehandle array BagB16Eligible",
                                   "string BagB16HeldArt=\"\""])
    init = fs["BagB1_Init"]
    init = replace(init, '        set Bag04ItemId[i]=-1', r'''        if i<9 then
            set BagB16Eligible[i]=BlzCreateFrameByType("BACKDROP","BagEquipHighlight",Bag04Button[i],"",1400+i)
            call BlzFrameSetAllPoints(BagB16Eligible[i],Bag04Button[i])
            call BlzFrameSetTexture(BagB16Eligible[i],"UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp",0,true)
            call BlzFrameSetLevel(BagB16Eligible[i],85)
            call BlzFrameSetEnable(BagB16Eligible[i],false)
            call BlzFrameSetVisible(BagB16Eligible[i],false)
        endif
        set Bag04ItemId[i]=-1''')
    init = replace(init, '    set BagB13Cancel=Bag04_Control(Bag04Gear,"Cancel targeting",-.015,-.138,.105,.024)', r'''    set BagB16HeldIcon=BlzCreateFrameByType("BACKDROP","BagHeldItem",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
    call BlzFrameSetSize(BagB16HeldIcon,.027,.027)
    call BlzFrameSetLevel(BagB16HeldIcon,220)
    call BlzFrameSetEnable(BagB16HeldIcon,false)
    call BlzFrameSetVisible(BagB16HeldIcon,false)
    set BagB13Cancel=BlzCreateFrameByType("BUTTON","BagCancelAim",BlzFrameGetParent(BagB13CommandCover),"",0)
    call BlzFrameSetAllPoints(BagB13Cancel,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,11))
    call BlzFrameSetLevel(BagB13Cancel,151)
    set console=BlzCreateFrameByType("BACKDROP","BagCancelAimIcon",BagB13Cancel,"",0)
    call BlzFrameSetAllPoints(console,BagB13Cancel)
    call BlzFrameSetTexture(console,"ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0,true)
    call BlzFrameSetEnable(console,false)
    call BlzTriggerRegisterFrameEvent(Bag04ClickTrigger,BagB13Cancel,FRAMEEVENT_CONTROL_CLICK)
    set console=BlzCreateFrameByType("BACKDROP","BagBlackCommands",BagB13CommandCover,"",0)
    call BlzFrameSetAllPoints(console,BagB13CommandCover)
    call BlzFrameSetTexture(console,"Textures\\black32.dds",0,true)
    call BlzFrameSetEnable(console,false)''')
    source = put(source, "BagB1_Init", init)
    draw = replace(fs["BagB1_Draw"], "    local string description", """    local string description
    local item held=BagB1_Item(hero,Bag04Held)
    local integer heldRaw
    local boolean dualWeapon=false
    if held!=null and GetHandleId(held)==Bag04HeldId then
        set heldRaw=GetItemTypeId(held)
        set BagB16HeldArt=BlzGetItemIconPath(held)
        set dualWeapon=GetUnitAbilityLevel(hero,'A0HP')>0 and (LoadInteger(ForsakenGearTypes,5,heldRaw)!=0 or LoadInteger(ForsakenGearTypes,6,heldRaw)!=0)
    else
        set held=null
        set BagB16HeldArt=""
    endif""")
    draw = replace(draw, '    call BlzFrameSetVisible(Bag04Drop,Bag04Held>=0)', """    set i=0
    loop
        exitwhen i>=9
        call BlzFrameSetVisible(BagB16Eligible[i],held!=null and (Bag04_Compatible(held,i) or (dualWeapon and (i==6 or i==7))))
        set i=i+1
    endloop
    set held=null""")
    source = put(source, "BagB1_Draw", draw)

    tick = replace(fs["BagB1_Tick"], "    call BlzFrameSetVisible(BagB13CommandCover", """    call BlzFrameSetVisible(Bag04Drop,false)
    call BlzFrameSetVisible(BagB13CommandCover""")
    source = put(source, "BagB1_Tick", tick)
    close = replace(fs["BagB1_RefreshVisibility"], "            call BlzFrameSetVisible(BagB13CommandCover,false)", """            call BlzFrameSetVisible(BagB13CommandCover,false)
            call BlzFrameSetVisible(BagB13Cancel,false)
            call BlzFrameSetVisible(BagB16HeldIcon,false)
            set BagB16HeldArt="" """)
    source = put(source, "BagB1_RefreshVisibility", close)
    animation = replace(fs["BagB3_AnimateCooldowns"], "    if not Bag04Open or BagB3Active==0 or InventoryCinematicActive or udg_InCinematicMode then", """    if Bag04Open and not InventoryCinematicActive and not udg_InCinematicMode then
        if GearInputTarget and QuickGearPending>=10 then
            call GearInput_Cursor()
        endif
        if Bag04Held>=0 and BagB16HeldArt!="" then
            call BlzFrameSetTexture(BagB16HeldIcon,BagB16HeldArt,0,true)
            call BlzFrameSetAbsPoint(BagB16HeldIcon,FRAMEPOINT_CENTER,BlzPixelToFrameX(BlzGetMouseScreenPosX())-.008,BlzPixelToFrameY(BlzGetMouseScreenPosY())+.008)
            call BlzFrameSetVisible(BagB16HeldIcon,true)
        else
            call BlzFrameSetVisible(BagB16HeldIcon,false)
        endif
    endif
    if not Bag04Open or BagB3Active==0 or InventoryCinematicActive or udg_InCinematicMode then""")
    source = put(source, "BagB3_AnimateCooldowns", animation)
    click = replace(fs["BagB1_Click"], "        if f==BagB13Cancel then", """        call BlzFrameSetFocus(f,false)
        if f==BagB13Cancel then
            call BlzFrameSetVisible(BagB13CommandCover,false)
            call BlzFrameSetVisible(BagB13Cancel,false)""")
    source = put(source, "BagB1_Click", click)
    keys = replace(fs["Forsaken_BackpackAccess"], "        call Forsaken_CloseBackpack()", """        if Bag04Open and QuickGearPending>=10 then
            set QuickGearPending=-1
            call ExecuteFunc("QuickGear_ClearPreview")
        elseif Bag04Open and Bag04Held>=0 then
            set Bag04Held=-1
            set Bag04HeldId=0
        else
            call Forsaken_CloseBackpack()
        endif""")
    source = put(source, "Forsaken_BackpackAccess", keys)

    request = replace(fs["QuickGear_Request"], "            set GearInputTarget=slot>=10 or mode==1", "            set GearInputTarget=(slot>=10 and cast!='A0PY') or mode==1")
    request = replace(request, "                call QuickGear_MovePreview()", """                if slot>=10 and cast=='A0PY' then
                    set QuickGearPreview=2
                endif
                call QuickGear_MovePreview()""")
    source = put(source, "QuickGear_Request", request)

    hand = replace(fs["Forsaken_PrepareWeaponHand"], "elseif LoadInteger(ForsakenGearTypes,6,raw)!=0 then",
                   "elseif (hand==6 or not dual) and LoadInteger(ForsakenGearTypes,6,raw)!=0 then")
    source = put(source, "Forsaken_PrepareWeaponHand", hand)
    receive = replace(fs["BagB1_Receive"], "        if it!=null and Bag04_Compatible(it,dest) then", """        if it!=null and (Bag04_Compatible(it,dest) or (dest==7 and BlzGetItemEquipmentType(it)==EQUIPMENT_TYPE_PRIMARY and GetUnitAbilityLevel(hero,'A0HP')>0)) then""")
    return put(source, "BagB1_Receive", receive)


if __name__ == "__main__":
    build(ROOT / "release/development/B15/FFERPG-B15.w3x",
          ROOT / "release/development/B16/FFERPG-B16.w3x",
          "FFERPG B16", "B15", "B16", transform=refresh,
          expected_changes=CHANGES, expected_added=frozenset())

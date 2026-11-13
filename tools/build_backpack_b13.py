"""Restore backpack item targeting, shared cooldowns and drag-to-ground."""
from pathlib import Path
from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations

ROOT = Path(__file__).resolve().parents[1]

def refresh(source):
    fs = functions(source)
    if "BagB1_Init" not in fs:
        return source
    changed = {}
    lookup = """function BagB13_Cast takes item carried returns integer
    local integer index=0
    local ability entry
    local integer raw
    loop
        set entry=BlzGetItemAbilityByIndex(carried,index)
        exitwhen entry==null
        set raw=BlzGetAbilityId(entry)
        if NativeCD_Pool(raw)!=0 or raw=='A0Q6' or raw=='A0BU' or raw=='A0PY' then
            set entry=null
            return raw
        endif
        set index=index+1
    endloop
    return 0
endfunction

function BagB13_Mode takes item carried,integer cast returns integer
    local ability entry
    local integer mode
    if cast=='A0Q6' or cast=='A0BU' or cast=='A0PY' then
        set entry=BlzGetItemAbility(carried,cast)
        if entry!=null then
            set mode=BlzGetAbilityIntegerLevelField(entry,ABILITY_ILF_TARGET_TYPE,0)
        endif
        set entry=null
        return mode
    endif
    return LoadInteger(QuickGearData,1,GetItemTypeId(carried))
endfunction"""
    for name in ("QuickGear_Request","QuickGear_Receive"):
        body = fs[name]
        body = replace(body,"    if slot>=10 and cast==0 then\n        set cast=LoadInteger(GearInputSpells,0,raw)\n    endif","""    if slot>=10 and cast==0 and carried!=null then
        set cast=LoadInteger(GearInputSpells,0,raw)
        if cast==0 then
            set cast=BagB13_Cast(carried)
        endif
    endif""")
        if name=="QuickGear_Request":
            body=replace(body,"    local integer cast","    local integer cast\n    local integer mode")
            body=replace(body,"    set UI73AimRevision=", """    set mode=LoadInteger(QuickGearData,1,raw)
    if slot>=10 and carried!=null then
        set mode=BagB13_Mode(carried,cast)
    endif
    set UI73AimRevision=""")
            body=replace(body,"if LoadInteger(QuickGearData,1,raw)==0 and", "if mode==0 and")
            body=replace(body,"set GearInputTarget=LoadInteger(QuickGearData,1,raw)==1","set GearInputTarget=slot>=10 or mode==1\n            set BagB13TargetMode=mode")
            body=replace(body,"if GearWaveMode==0 and LoadInteger(QuickGearData,1,raw)>=2 then","if GearWaveMode==0 and mode>=2 then")
            body=replace(body,"    set owner=GetLocalPlayer()", """    if slot<10 and QuickGearPending>=10 then
        return
    endif
    set owner=GetLocalPlayer()""")
        else:
            body=replace(body,"    set mode=LoadInteger(QuickGearData,1,raw)","""    set mode=LoadInteger(QuickGearData,1,raw)
    if slot>=10 and carried!=null then
        set mode=BagB13_Mode(carried,cast)
    endif""")
        changed[name]=body
    source=declarations(source,["integer BagB13TargetMode=0","framehandle BagB13Cancel","framehandle BagB13CommandCover"])
    changed["QuickGear_Item"]=lookup+"\n\n"+fs["QuickGear_Item"].strip()
    changed["QuickGear_Mouse"]=replace(fs["QuickGear_Mouse"],"if target==null and LoadInteger(QuickGearData,1,QuickGearPendingItem)==1 then","if target==null and BagB13TargetMode==1 then")
    body=fs["BagB1_Draw"]
    changed["BagB1_Draw"]=replace(body,"            if cast!=0 then\n                set pool", """            if cast==0 then
                set cast=BagB13_Cast(it)
            endif
            if cast!=0 then
                set pool""")
    body=fs["BagB1_Init"]
    changed["BagB1_Init"]=replace(body,"    set Bag04Ready=true", """    set BagB13CommandCover=BlzCreateFrameByType("BUTTON","BagCommandCover",BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)),"",0)
    call BlzFrameSetPoint(BagB13CommandCover,FRAMEPOINT_TOPLEFT,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,0),FRAMEPOINT_TOPLEFT,0.,0.)
    call BlzFrameSetPoint(BagB13CommandCover,FRAMEPOINT_BOTTOMRIGHT,BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,11),FRAMEPOINT_BOTTOMRIGHT,0.,0.)
    call BlzFrameSetLevel(BagB13CommandCover,150)
    call BlzFrameSetVisible(BagB13CommandCover,false)
    set BagB13Cancel=Bag04_Control(Bag04Gear,"Cancel targeting",-.015,-.138,.105,.024)
    call BlzFrameSetVisible(BagB13Cancel,false)
    set Bag04Ready=true""")
    changed["BagB1_Tick"]=replace(fs["BagB1_Tick"],"    if Bag04Open then","""    call BlzFrameSetVisible(BagB13CommandCover,Bag04Open and QuickGearPending>=10)
    call BlzFrameSetVisible(BagB13Cancel,Bag04Open and QuickGearPending>=10)
    if Bag04Open then""")
    body=replace(fs["BagB1_Click"],"        if f==Bag04Close then","""        if f==BagB13Cancel then
            set QuickGearPending=-1
            call QuickGear_ClearPreview()
        elseif f==Bag04Close then""")
    changed["BagB1_Click"]=body
    changed["BagB1_RefreshVisibility"]=replace(fs["BagB1_RefreshVisibility"],"        if not Bag04Open then","""        if not Bag04Open then
            call BlzFrameSetVisible(BagB13CommandCover,false)
            if QuickGearPending>=10 then
                set QuickGearPending=-1
                call QuickGear_ClearPreview()
            endif""")
    body=replace(fs["BagB1_WorldClick"]," or Bag04Hover<0","")
    body=replace(body," or BlzGetTriggerPlayerMouseButton()!=MOUSE_BUTTON_TYPE_RIGHT","")
    body=replace(body,"    if Bag04Held>=0 then", """    if Bag04Hover<0 then
        if Bag04Held>=0 and (BlzGetTriggerPlayerMouseX()!=0. or BlzGetTriggerPlayerMouseY()!=0.) then
            call BlzSendSyncData("FFBagB1",I2S(Bag04Held)+":"+I2S(Bag04HeldId)+":-2:"+R2S(BlzGetTriggerPlayerMouseX())+":"+R2S(BlzGetTriggerPlayerMouseY()))
            set Bag04Held=-1
            set Bag04HeldId=0
        endif
        return
    endif
    if BlzGetTriggerPlayerMouseButton()!=MOUSE_BUTTON_TYPE_RIGHT then
        return
    endif
    if Bag04Held>=0 then""")
    changed["BagB1_WorldClick"]=body
    body=replace(fs["BagB1_Receive"],"    local integer nativeSlot","    local integer nativeSlot\n    local real x\n    local real y\n    local integer alternate")
    body=replace(body,"dest < -1","dest < -2")
    body=replace(body,"    elseif dest==-1 then","""    elseif dest==-2 then
        set x=S2R(Bag04_Field(data,3))
        set y=S2R(Bag04_Field(data,4))
        if x>=GetRectMinX(bj_mapInitialPlayableArea) and x<=GetRectMaxX(bj_mapInitialPlayableArea) and y>=GetRectMinY(bj_mapInitialPlayableArea) and y<=GetRectMaxY(bj_mapInitialPlayableArea) then
            set accepted=UnitDropItemPoint(hero,it,x,y)
        endif
    elseif dest==-1 then""")
    body=replace(body,"    elseif dest<9 then\n        if Bag04_Compatible", """    elseif dest<9 then
        if source>=9 and source<39 and (dest==6 or dest==7) and GetUnitAbilityLevel(hero,'A0HP')>0 then
            set alternate=LoadInteger(ForsakenGearTypes,6,GetItemTypeId(it))
            if alternate!=0 or LoadInteger(ForsakenGearTypes,5,GetItemTypeId(it))!=0 then
                call Forsaken_PrepareWeaponHand(hero,it,source-9,dest)
                set it=BagB1_Item(hero,source)
            endif
        endif
        if it!=null and Bag04_Compatible""")
    changed["BagB1_Receive"]=body
    body=replace(fs["Forsaken_PrepareWeaponHand"],"integer bagSlot returns","integer bagSlot,integer hand returns")
    body=replace(body,"if dual and LoadInteger","if (hand==7 or (hand==0 and dual)) and LoadInteger")
    changed["Forsaken_PrepareWeaponHand"]=body
    changed["Forsaken_PrepareDualWield"]=replace(fs["Forsaken_PrepareDualWield"],"Forsaken_PrepareWeaponHand(holder,carried,slot)","Forsaken_PrepareWeaponHand(holder,carried,slot,0)")
    for name, body in changed.items():
        source=put(source,name,body)
    weapon_hand = functions(source)["Forsaken_PrepareWeaponHand"].strip()
    source = source.replace(weapon_hand, "", 1)
    return source.replace("function BagB1_Receive takes", weapon_hand + "\n\nfunction BagB1_Receive takes", 1)

if __name__=="__main__":
    build(ROOT/"release/development/B12/FFERPG-B12.w3x",ROOT/"release/development/B13/FFERPG-B13.w3x",
          "FFERPG B13","B12","B13",transform=refresh,
          expected_changes={"QuickGear_Request","QuickGear_Receive","QuickGear_Mouse","BagB1_Draw","BagB1_Init","BagB1_Tick","BagB1_Click","BagB1_RefreshVisibility","BagB1_WorldClick","BagB1_Receive","Forsaken_PrepareWeaponHand","Forsaken_PrepareDualWield"},
          expected_added={"BagB13_Cast","BagB13_Mode"})

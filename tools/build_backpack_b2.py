"""Refine the full-map replacement backpack for the B2 comparison test."""
from pathlib import Path

from build_control_order40 import build
from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations

ROOT = Path(__file__).resolve().parents[1]
CHANGES = {"Bag04_Control", "Bag05_InitSlots", "BagB1_Init", "BagB1_Draw", "Forsaken_PollPanels"}


def replace(body, old, new):
    assert body.count(old) == 1, old
    return body.replace(old, new, 1)


def refresh(source):
    fs = functions(source)
    if "BagB1_Init" not in fs:
        return source
    source = declarations(source, ["framehandle array BagB2Wheel"])
    body = replace(fs["Bag04_Control"], '.0015,width,height,.012,caption',
                   '.0015,width,height,.014,"|cffffcc00"+caption+"|r"')
    source = put(source, "Bag04_Control", body)

    body = replace(fs["Bag05_InitSlots"], "        set Bag04Icon[i]=", """        if i<9 then
            call BlzFrameSetSize(Bag04Button[i],.0295,.0295)
        elseif i<39 then
            call BlzFrameSetSize(Bag04Button[i],.0305,.0305)
        endif
        set Bag04Icon[i]=""")
    source = put(source, "Bag05_InitSlots", body)

    body = fs["BagB1_Init"]
    body = replace(body, ".030,-.016,.147,.035,.010", ".046,-.016,.145,.035,.010")
    body = replace(body, '"Talents",-.015,-.045,.071,.026', '"Talents",-.015,-.045,.077,.028')
    body = replace(body, '"Move to hero",-.015,-.168,.102,.025', '"Move to hero",-.015,-.168,.111,.027')
    body = replace(body, '"X",-.015,-.013,.024,.023', '"X",-.015,-.013,.025,.024')
    body = replace(body, '"Drop held item",-.015,-.148,.090,.020', '"Drop held item",-.015,-.148,.092,.021')
    body = replace(body, '        set BagB1Cooldown[i]=Bag04_Text', r'''        set BagB2Wheel[i]=BlzCreateFrameByType("STATUSBAR","BagB2Wheel",Bag04Button[i],"",1200+i)
        call BlzFrameSetModel(BagB2Wheel[i],"UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdl",0)
        call BlzFrameSetMinMaxValue(BagB2Wheel[i],0.,1.)
        call BlzFrameSetAllPoints(BagB2Wheel[i],Bag04Button[i])
        call BlzFrameSetEnable(BagB2Wheel[i],false)
        call BlzFrameSetVisible(BagB2Wheel[i],false)
        set BagB1Cooldown[i]=Bag04_Text''')
    body = replace(body, '.029,.027,.012,"")', '.0305,.029,.016,"")')
    body = replace(body, '        call BlzFrameSetTextAlignment(BagB1Cooldown[i]', '''        call BlzFrameSetLevel(BagB1Cooldown[i],80)
        call BlzFrameSetTextAlignment(BagB1Cooldown[i]''')
    source = put(source, "BagB1_Init", body)

    body = replace(fs["BagB1_Draw"], "    local real left", "    local real left\n    local real duration\n    local integer pool")
    body = replace(body, '        set value=""\n        if it!=null then\n            set cast=', '        set value=""\n        set left=0.\n        set duration=0.\n        if it!=null then\n            set cast=')
    body = replace(body, '                set left=RMaxBJ(NativeCD_Left(hero,NativeCD_Pool(cast)),BlzGetUnitAbilityCooldownRemaining(hero,cast))', '''                set pool=NativeCD_Pool(cast)
                set left=RMaxBJ(NativeCD_Left(hero,pool),BlzGetUnitAbilityCooldownRemaining(hero,cast))
                set duration=LoadReal(NativeCDData,48+GetPlayerId(GetOwningPlayer(hero)),pool)
                if duration<left then
                    set duration=RMaxBJ(left,BlzGetUnitAbilityCooldown(hero,cast,IMaxBJ(0,GetUnitAbilityLevel(hero,cast)-1)))
                endif''')
    body = replace(body, '        if value!=BagB1CooldownText[i] then', '''        if left>.01 then
            call BlzFrameSetValue(BagB2Wheel[i],1.-RMinBJ(1.,left/RMaxBJ(.01,duration)))
        endif
        if BlzFrameIsVisible(BagB2Wheel[i])!=(left>.01) then
            call BlzFrameSetVisible(BagB2Wheel[i],left>.01)
        endif
        if value!=BagB1CooldownText[i] then''')
    source = put(source, "BagB1_Draw", body)

    body = replace(fs["Forsaken_PollPanels"], "    set anchor=Bag04Gear", """    set anchor=Bag04Gear
    if visible and ForsakenInspectTarget==null then
        call BlzFrameClearAllPoints(ForsakenTalentRoot)
        call BlzFrameSetPoint(ForsakenTalentRoot,FRAMEPOINT_TOPRIGHT,Bag04Gear,FRAMEPOINT_TOPLEFT,-.008,0.)
    endif""")
    return put(source, "Forsaken_PollPanels", body)


if __name__ == "__main__":
    build(ROOT / "release/development/B1/FFERPG-B1.w3x",
          ROOT / "release/development/B2/FFERPG-B2.w3x",
          "FFERPG B2", "B1", "B2", transform=refresh,
          expected_changes=CHANGES, expected_added=frozenset())

"""Build the V43 backpack replacement test and its standalone layout fixture."""
from pathlib import Path
import sys

import build_inventory_panel06 as panel
from add_header import build_header, read_header
from backpack_catalog import setf
from downgrade import wts_write
from editor_pair import View
from jtok import functions
from mpq import MPQ, compact, write_files
from objdata import read_objects, write_objects
from performance_runtime import put
from priest_ultimate import declarations
from test_map_identity import info_labels
from wct import raw_of, text_of, write_wct

ROOT = Path(__file__).resolve().parents[1]
TEST = ROOT / "release/development"
FIXTURE = TEST / "InventoryPanel12/FFERPG-Independent-Backpack-12.w3x"
OUTPUT = TEST / "B1/FFERPG-B1.w3x"
RAW = "'bBp1'"
TOC = r"BagUI\BagTooltip08.toc"
FDF = r"BagUI\BagTooltip08.fdf"


def buttons(source):
    fs = functions(source)
    init = fs["Bag04_Init"].replace('"Move to hero",-.015,-.173', '"Move to hero",-.015,-.168')
    source = put(source, "Bag04_Init", init)
    control = fs["Bag04_Control"].replace("    call BlzFrameSetPoint", "    local framehandle label\n    call BlzFrameSetPoint", 1)
    control = control.replace("    call BlzFrameSetText(f,caption)", """    if caption=="Talents" or caption=="Move to hero" then
        call BlzFrameSetText(f,"")
        set label=Bag04_Text(f,"BagRaisedLabel",0.,.0015,width,height,.012,caption)
        call BlzFrameSetTextAlignment(label,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetTextColor(label,BlzConvertColor(255,255,204,0))
        set label=null
    else
        call BlzFrameSetText(f,caption)
    endif""")
    return put(source, "Bag04_Control", control)


def spell_objects(data):
    table = read_objects(data, "w3a")
    obj = dict(base="ANcl", id=RAW.strip("'"), sets=[dict(flag=0, mods=[])])
    assert all(entry["id"] != obj["id"] for entry in table["custom"])
    for field, kind, value in (
        ("anam", 3, "Backpack"), ("aart", 3, r"ReplaceableTextures\CommandButtons\BTNBackpack.blp"),
        ("aher", 0, 0), ("alev", 0, 1), ("abpx", 0, 0), ("abpy", 0, 1), ("ahky", 3, ""),
    ):
        setf(obj, field, kind, value)
    for field, kind, value in (("atp1", 3, "Backpack (B)"), ("aub1", 3, "Open or close your backpack."),
                               ("amcs", 0, 0), ("acdn", 2, 0.), ("acas", 2, 0.)):
        setf(obj, field, kind, value, 1)
    for index, kind, value in ((1, 2, 0.), (2, 0, 0), (3, 0, 1), (4, 2, 0.), (5, 0, 0), (6, 3, "channel")):
        setf(obj, f"Ncl{index}", kind, value, 1, index)
    table["custom"].append(obj)
    return write_objects(table, table["version"], "w3a")


def opener_functions(fs):
    init = fs["Bag04_Init"]
    start = init.index("    set Bag04Access=BlzCreateFrame")
    end = init.index("    set i=0", start)
    init = init[:start] + """    set Bag04Access=null
""" + init[end:]
    init = init.replace("call UnitRemoveAbility(InvCheckHero[i],'ASpc')",
                        f"call UnitRemoveAbility(InvCheckHero[i],'ASpc')\n        call UnitAddAbility(InvCheckHero[i],{RAW})")
    init = init.replace("    set Bag04Ready=true", """    call TriggerRegisterAnyUnitEventBJ(BagB1Command,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(BagB1Command,function BagB1_OpenSpell)
    set Bag04Ready=true""")
    init = init.replace("    set Bag04ClickTrigger=CreateTrigger()", "    local trigger BagB1Command=CreateTrigger()\n    set Bag04ClickTrigger=CreateTrigger()")
    init = init.replace("    set Bag04Ready=true", "    set BagB1Command=null\n    set Bag04Ready=true")
    handler = f"""function BagB1_OpenSpell takes nothing returns nothing
    local player p=GetTriggerPlayer()
    if GetSpellAbilityId()=={RAW} and GetLocalPlayer()==p and GetTriggerUnit()==InvCheckHero[GetPlayerId(p)] and not InvCheckScene then
        call Bag04_Show(not Bag04Open)
    endif
    set p=null
endfunction"""
    return handler, init


def fixture_build():
    out = TEST / "InventoryPanel13/FFERPG-Independent-Backpack-13.w3x"
    archive = MPQ(str(FIXTURE))
    def transform(source):
        source = buttons(source)
        handler, init = opener_functions(functions(source))
        source = put(source, "Bag04_Init", handler + "\n\n" + init.strip())
        return source.replace("Backpack12", "Backpack13").replace("Bag12", "Bag13")
    panel.OUT = out
    panel.NAME = "FFERPG Backpack13"
    panel.source_for = transform
    panel.build(FIXTURE, {"war3map.w3a": fixture_abilities(archive)})
    return out


def fixture_abilities(archive):
    data = read_objects(spell_objects(archive.read("war3map.w3a")), "w3a")
    opener = next(obj for obj in data["original"] if obj["base"] == "ASpc")
    setf(opener, "ahky", 3, "J")
    setf(opener, "atp1", 3, "Native Backpack (J)", 1)
    return write_objects(data, data["version"], "w3a")


def b1_transform(source, fixture_source, icons):
    fs = functions(source)
    if "Forsaken_RequestBackpackToggle" not in fs:
        return source.replace("'ASpc'", RAW)
    f = functions(buttons(fixture_source))
    body = (ROOT / "tools/backpack_b1.j").read_text()
    helper_globals, helper_functions = body.split("// FUNCTIONS\n", 1)
    helper_functions = helper_functions.replace("// JOB_ICONS", icons)
    globals_start = fixture_source.index("    framehandle Bag04")
    globals_end = fixture_source.index("endglobals", globals_start)
    wanted = ("Bag04Root", "Bag04Gear", "Bag04Bag", "Bag04Title", "Bag04Close", "Bag04Home",
              "Bag04Drop", "Bag04Talents", "Bag04ClickTrigger", "Bag04Button", "Bag04Icon",
              "Bag04TipText", "Bag04Count", "Bag04Held", "Bag04HeldId", "Bag04Hover", "Bag04Ready",
              "Bag04Open", "Bag04ItemId", "Bag08TooltipFrame", "Bag05Hover", "Bag05Next")
    imports = [line for line in fixture_source[globals_start:globals_end].splitlines()
               if line.strip().split("=")[0].split()[-1] in wanted]
    source = declarations(source, imports + helper_globals.strip().splitlines())
    init = f["Bag04_Init"]
    slot_init = init[init.index("    set Bag04Root="):init.index("    set Bag04Access=BlzCreateFrame")]
    slot_init = slot_init.replace("set portrait=BlzCreateFrameByType", "set BagB1Portrait=BlzCreateFrameByType", 1)
    slot_init = slot_init.replace("portrait,", "BagB1Portrait,").replace("    set portrait=null\n", "")
    slot_init = slot_init[:slot_init.index("    if Bag05Next!=45")]
    helper_functions = helper_functions.replace("    // CREATE_PANEL", slot_init.rstrip())
    slots = f["Bag05_InitSlots"].replace("exitwhen i>=stop", "exitwhen i>=stop or i>=39")

    helpers = [f[name] for name in ("Bag04_Field", "Bag04_Compatible", "Bag08_EmptyIcon", "Bag04_Text", "Bag04_Control")]
    helpers += [slots, helper_functions]
    marker = "function Forsaken_PollPanels takes"
    assert source.count(marker) == 1
    source = source.replace(marker, "\n\n".join(s.strip() for s in helpers) + "\n\n" + marker)
    poll = fs["Forsaken_PollPanels"]
    start = poll.index("    set nativePanel=Forsaken_FindFrame")
    end = poll.index("    call Forsaken_BackpackInputControl", start)
    poll = poll[:start] + """    call BagB1_Tick(hero,viewer)
    set visible=Bag04Open
    set anchor=Bag04Gear
""" + poll[end:]
    poll = poll.replace("call Forsaken_BackpackControls(nativePanel,anchor,visible and ForsakenInspectTarget==null)",
                        "call Forsaken_BackpackControls(null,null,false)")
    poll = poll.replace("visible or ForsakenInspectTarget!=null)", "ForsakenInspectTarget!=null)", 1)
    source = put(source, "Forsaken_PollPanels", poll)
    source = put(source, "Forsaken_BackpackToggleAction", """function Forsaken_BackpackToggleAction takes nothing returns nothing
    local player p=GetTriggerPlayer()
    if GetSpellAbilityId()=='bBp1' and GetLocalPlayer()==p and GetTriggerUnit()==Player_GetHero(p) then
        call Forsaken_RequestBackpackToggle(2)
    endif
    set p=null
endfunction""")
    reg = fs["Forsaken_RegisterBackpackActivity"].replace(
        "call BlzTriggerRegisterFrameEvent(ForsakenBackpackToggleEvents,ForsakenBackpackCommand,FRAMEEVENT_CONTROL_CLICK)",
        "call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackToggleEvents,EVENT_PLAYER_UNIT_SPELL_EFFECT)")
    source = put(source, "Forsaken_RegisterBackpackActivity", reg)
    toggle = fs["Forsaken_RequestBackpackToggle"].replace(
        "    set ForsakenInventoryBindPhase=1\n    set ForsakenInventoryBindUntil=now+.2",
        '    call ExecuteFunc("BagB1_RefreshVisibility")')
    source = put(source, "Forsaken_RequestBackpackToggle", toggle)
    close = fs["Forsaken_CloseBackpack"].replace("    call Forsaken_HideInventory()", '    call ExecuteFunc("BagB1_Close")')
    source = put(source, "Forsaken_CloseBackpack", close)
    item_lookup = fs["QuickGear_Item"].replace("    elseif slot==0 then", """    elseif slot>=10 and slot<49 then
        if slot<19 then
            return BlzUnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot-10))
        endif
        return BlzUnitItemInBagSlot(hero,slot-19)
    elseif slot==0 then""")
    source = put(source, "QuickGear_Item", item_lookup)
    receive = fs["QuickGear_Receive"].replace("slot<0 or slot>1", "(slot<0 or (slot>1 and slot<10) or slot>=49)")
    receive = receive.replace(" or cast==0 then", " then", 1)
    receive = receive.replace("    if NativeCD_Left", """    if cast==0 and slot>=10 then
        call UnitUseItem(hero,carried)
    elseif cast!=0 and NativeCD_Left""", 1)
    source = put(source, "QuickGear_Receive", receive)
    request = fs["QuickGear_Request"].replace("and carried!=null and cast!=0 then", "and carried!=null and (cast!=0 or slot>=10) then")
    source = put(source, "QuickGear_Request", request)
    mouse = fs["QuickGear_Mouse"].replace("        call BagScreen_Event66()", '        call ExecuteFunc("BagB1_WorldClick")\n        set BagHandled66=Bag04Open and Bag04Hover>=0')
    source = put(source, "QuickGear_Mouse", mouse)
    return source.replace("'ASpc'", RAW)


def build():
    base = TEST / "V43/FFERPG-V43.w3x"
    view = View(base)
    archive = view.archive
    fixture = MPQ(str(FIXTURE))
    fixture_source = fixture.read("war3map.j").decode().replace("\r\n", "\n")
    icon_lines = []
    import re
    board = view.runtime
    for raw, icon in dict(re.findall(r"l_jobTypeId=='(....)'[^\n]*\n\s*call MultiboardSetItemIcon\(l_cell,\"([^\"]+)\"", board)).items():
        icon_lines.append(f'    if raw==\'{raw}\' then\n        return "{icon}"\n    endif')
    assert any("BTNFFT_Ninja_Male" in line for line in icon_lines)
    icons = "\n".join(icon_lines)
    def transform(text):
        return b1_transform(text, fixture_source, icons).replace(view.strings[38788], "FFERPG B1").replace("V43 F/G:", "B1 F/G:")
    runtime = transform(view.runtime)
    for index, raw in enumerate(view.wct["entries"]):
        text = text_of(raw).replace("\r\r\n", "\n").replace("\r\n", "\n")
        changed = transform(text)
        if changed != text:
            view.wct["entries"][index] = raw_of(changed.replace("\n", "\r\n"))
    strings = view.strings.copy()
    strings[4] = strings[38788] = "FFERPG B1"
    files = {"war3map.j": runtime.replace("\n", "\r\n").encode(), "war3map.wct": write_wct(view.wct),
             "war3map.w3a": spell_objects(archive.read("war3map.w3a")),
             "war3map.wts": wts_write(strings), "war3map.w3i": info_labels(archive.read("war3map.w3i"), "FFERPG B1"),
             TOC: fixture.read(TOC), FDF: fixture.read(FDF)}
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    assert not OUTPUT.exists()
    temp = OUTPUT.with_suffix(".unpacked.w3x")
    write_files(str(base), str(temp), files)
    compact(str(temp), str(OUTPUT))
    _, flags, players = read_header(str(base))
    data = OUTPUT.read_bytes()
    OUTPUT.write_bytes(build_header("FFERPG B1", flags, players) + data[data.index(b"MPQ\x1a"):])
    result = MPQ(str(OUTPUT))
    for name in set(archive.read("(listfile)").decode().splitlines()) | files.keys():
        if name.lower() not in {"(listfile)", "(attributes)", "(signature)"}:
            assert result.read(name) == files.get(name, archive.read(name)), name
    return OUTPUT


if __name__ == "__main__":
    if "--fixture" in sys.argv:
        print(fixture_build())
    else:
        print(build())

"""Isolate load verification and restore exact custom-backpack moves."""
from pathlib import Path

from build_backpack_b2 import replace
from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]

PLACE = """function BagB17_Place takes unit hero,integer dest,item carried returns boolean
    local integer position=0
    local integer limit=dest-33
    local integer slot
    local integer count=0
    local integer charges=GetItemCharges(carried)
    local item array spacers
    local item spacer
    local boolean placed=false
    if dest<39 then
        set limit=dest-3
    endif
    loop
        exitwhen position>=limit
        set slot=position+33
        if position>=6 then
            set slot=position+3
        endif
        if BagB1_Item(hero,slot)==null then
            set spacer=CreateItem('fGap',GetUnitX(hero),GetUnitY(hero))
            if spacer==null then
                exitwhen true
            endif
            set spacers[count]=spacer
            set count=count+1
            call UnitAddItem(hero,spacer)
            exitwhen BagB1_Item(hero,slot)!=spacer
        endif
        set position=position+1
    endloop
    if position==limit then
        call SetItemCharges(carried,0)
        call UnitAddItem(hero,carried)
        call SetItemCharges(carried,charges)
        set placed=BagB1_Item(hero,dest)==carried
    endif
    loop
        exitwhen count==0
        set count=count-1
        call RemoveItem(spacers[count])
        set spacers[count]=null
    endloop
    set spacer=null
    return placed
endfunction

function BagB17_Move takes unit hero,integer source,integer dest,item carried,item other returns boolean
    local boolean converting=ForsakenConvertingGear
    local boolean placed
    if source<9 and other!=null then
        return false
    endif
    set ForsakenConvertingGear=true
    if source<9 then
        call BlzUnitUnequipItem(hero,carried)
    endif
    if BlzUnitHasItemEquipped(hero,carried) then
        set ForsakenConvertingGear=converting
        return false
    endif
    if other!=null then
        call UnitRemoveItem(hero,other)
    endif
    call UnitRemoveItem(hero,carried)
    set placed=BagB17_Place(hero,dest,carried)
    if placed and other!=null then
        set placed=BagB17_Place(hero,source,other)
    endif
    if not placed then
        call UnitRemoveItem(hero,carried)
        if other!=null then
            call UnitRemoveItem(hero,other)
        endif
        if source<9 then
            call UnitAddItem(hero,carried)
            call BlzUnitEquipItem(hero,carried)
        elseif not BagB17_Place(hero,source,carried) then
            call SetItemPosition(carried,GetUnitX(hero),GetUnitY(hero))
        endif
        if other!=null and not BagB17_Place(hero,dest,other) then
            call SetItemPosition(other,GetUnitX(hero),GetUnitY(hero))
        endif
    endif
    set ForsakenConvertingGear=converting
    return placed
endfunction"""


def refresh(source):
    fs = functions(source)
    changed = {}
    if "Inventory71_Reconcile" in fs:
        body = fs["Inventory71_Reconcile"]
        changed["Inventory71_Reconcile"] = replace(body, "    if hero==null", """    if FFP_Locked[pid] then
        return
    endif
    if hero==null""")
    if "Forsaken_RebindBag" in fs:
        body = fs["Forsaken_RebindBag"]
        changed["Forsaken_RebindBag"] = replace(body, "    set size=BlzUnitExtendedInventorySize(holder)", """    if FFP_Locked[GetPlayerId(GetOwningPlayer(holder))] then
        call RemoveSavedBoolean(ForsakenBagAbilities,GetHandleId(holder),-5)
        call FlushChildHashtable(ForsakenBagAbilities,key)
        call DestroyTimer(clock)
        set holder=null
        set clock=null
        return
    endif
    set size=BlzUnitExtendedInventorySize(holder)""")
    if "FFL_Restore" in fs:
        changed["FFL_Restore"] = replace(fs["FFL_Restore"], """    if restored then
        set cleaned=FFN_Cleanup(pid)
    endif""", """    set cleaned=FFN_Cleanup(pid)""")
        changed["FFL_Tick"] = replace(fs["FFL_Tick"], 'call FFL_Fail(pid,FSS_Concat("full profile readback differs: ",FRC_Error[pid]))', """if FRC_Ready[pid] then
                    call FFL_Fail(pid,"restored profile differs from the saved profile")
                else
                    call FFL_Fail(pid,FSS_Concat("full profile readback differs: ",FRC_Error[pid]))
                endif""")
    if "FFN_Cleanup" in fs:
        body = replace(fs["FFN_Cleanup"], "    local boolean occupied", "    local item carried")
        body = replace(body, "return (not FFP_Locked[pid])", "return true")
        start = body.index("            // Quarantine")
        end = body.index("        endif\n        set i=", start)
        body = body[:start] + """            // Only attempt-owned units are listed here. Inventory conversion
            // can leave a replacement handle that was never in FFN_Item.
            call ShowUnit(candidate,false)
            call SetUnitOwner(candidate,Player(PLAYER_NEUTRAL_PASSIVE),false)
            set position=0
            loop
                exitwhen position>=45
                if position<6 then
                    set carried=UnitItemInSlot(candidate,position)
                elseif i==1 then
                    exitwhen true
                elseif position<36 then
                    set carried=BlzUnitItemInBagSlot(candidate,position-6)
                else
                    set carried=BlzUnitItemInEquipmentSlot(candidate,ConvertLoadoutSlot(position-36))
                endif
                if carried!=null then
                    call RemoveItem(carried)
                    if GetItemTypeId(carried)!=0 then
                        set clean=false
                    endif
                endif
                set position=position+1
            endloop
            call RemoveUnit(candidate)
            if GetUnitTypeId(candidate)==0 then
                set FFN_Unit[index]=null
                set FFN_UnitRaw[index]=0
            else
                set clean=false
            endif
""" + body[end:]
        changed["FFN_Cleanup"] = replace(body,"    set candidate=null","    set carried=null\n    set candidate=null")
    if "BagB1_Receive" in fs:
        body = fs["BagB1_Receive"]
        body = replace(body,"    local integer nativeSlot\n","")
        body = replace(body,"or GetOwningPlayer(hero)!=p", "or FFP_Locked[GetPlayerId(p)] or GetOwningPlayer(hero)!=p")
        start = body.index("        set other=BagB1_Item(hero,dest)")
        end = body.index("    // Native slot orders",start)
        changed["BagB1_Receive"] = PLACE + "\n\n" + body[:start] + """        set other=BagB1_Item(hero,dest)
        set accepted=BagB17_Move(hero,source,dest,it,other)
    endif
""" + body[end:]
        init = fs["BagB1_Init"]
        init = replace(init,'set BagB16Eligible[i]=BlzCreateFrameByType("BACKDROP","BagEquipHighlight",Bag04Button[i],"",1400+i)',
                       'set BagB16Eligible[i]=BlzCreateFrame("BagEquipOutline17",Bag04Button[i],0,1400+i)')
        init = "\n".join(line for line in init.split("\n") if "human-console-button-highlight" not in line)
        init = replace(init,"            call BlzFrameSetLevel(BagB16Eligible[i],85)", "            call BlzFrameSetLevel(BagB16Eligible[i],85)\n            call BlzFrameSetVertexColor(BagB16Eligible[i],BlzConvertColor(255,100,255,110))")
        changed["BagB1_Init"] = init
        request = replace(fs["QuickGear_Receive"],"or hero==null or GetOwningPlayer(hero)!=owner",
                          "or hero==null or FFP_Locked[GetPlayerId(owner)] or GetOwningPlayer(hero)!=owner")
        changed["QuickGear_Receive"] = request
    for name, body in changed.items():
        source = put(source,name,body)
    return source


if __name__ == "__main__":
    from mpq import MPQ
    for old,new in (("B16","B17"),("V45","V46")):
        base = ROOT / f"release/development/{old}/FFERPG-{old}.w3x"
        expected = {"Inventory71_Reconcile","Forsaken_RebindBag","FFL_Restore","FFL_Tick","FFN_Cleanup"}
        files = None
        added = frozenset()
        if old=="B16":
            expected |= {"BagB1_Receive","BagB1_Init","QuickGear_Receive"}
            added = {"BagB17_Move","BagB17_Place"}
            name = r"BagUI\BagTooltip08.fdf"
            files = {name:MPQ(str(base)).read(name)+br'''
Frame "BACKDROP" "BagEquipOutline17" {
    BackdropEdgeFile "UI\Widgets\Tooltips\Human\human-tooltip-border.blp",
    BackdropCornerFlags "UL|UR|BL|BR|T|L|B|R",
    BackdropCornerSize 0.003,
    BackdropBlendAll,
}
'''}
        build(base,ROOT/f"release/development/{new}/FFERPG-{new}.w3x",
              f"FFERPG {new}",old,new,transform=refresh,expected_changes=expected,
              expected_added=added,extra_files=files)

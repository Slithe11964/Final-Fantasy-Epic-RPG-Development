"""Keep the local armory counters aligned with the shared shop's collection owner."""
from jtok import functions
from performance_runtime import put
from priest_ultimate import declarations


def refresh(source):
    fs = functions(source)
    if "Armory_PollCounter" not in fs or "Armory_VisitHouse" not in fs:
        return source
    counter = fs["Armory_RefreshCounter"]
    if "takes player collectionOwner" in counter:
        return source
    source = declarations(source, [
        "integer ArmoryCounterOwner=-1",
    ])
    counter = counter.replace("takes nothing", "takes player collectionOwner", 1)
    counter = counter.replace("    local player p=GetLocalPlayer()\n", "", 1)
    counter = counter.replace("Armory_CollectionText(p)", "Armory_CollectionText(collectionOwner)", 1)
    counter = counter.replace("call Armory_CountProgress(p)", "call Armory_CountProgress(collectionOwner)", 1)
    counter = counter.replace("    set p=null\n", "", 1)
    source = put(source, "Armory_RefreshCounter", counter)
    source = put(source, "Armory_PollCounter", """function Armory_PollCounter takes nothing returns nothing
    local player viewer=GetLocalPlayer()
    local integer viewerId=GetPlayerId(viewer)
    local integer ownerId=viewerId
    local integer inspected=ArmoryViewOwner[viewerId+1]
    local integer revision
    if inspected>=1 and inspected<=8 and inspected!=viewerId+1 then
        if (udg_ArmoryUnit[viewerId+1]!=null and IsUnitSelected(udg_ArmoryUnit[viewerId+1],viewer)) or (udg_PlayerHouse[inspected]!=null and IsUnitSelected(udg_PlayerHouse[inspected],viewer)) then
            set ownerId=inspected-1
        endif
    endif
    set revision=CollectionArmoryRevision[ownerId]
    if ownerId!=ArmoryCounterOwner or revision!=ArmoryCounterRevision then
        call Armory_RefreshCounter(Player(ownerId))
        set ArmoryCounterOwner=ownerId
        set ArmoryCounterRevision=revision
    endif
    set viewer=null
endfunction""")
    visit = fs["Armory_VisitHouse"]
    visit = visit.replace("+\"'s armory (read only).\")", "+\"'s armory (read only). Collection: \"+Armory_CollectionText(Player(owner-1)))", 1)
    assert visit != fs["Armory_VisitHouse"]
    source = put(source, "Armory_VisitHouse", visit)
    withdraw = fs["Trig_Armory_Select_CanWithdraw"]
    withdraw = withdraw.replace("    return", """    local integer viewer=GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
    if ArmoryViewOwner[viewer]>0 and ArmoryViewOwner[viewer]!=viewer then
        return false
    endif
    return""", 1)
    return put(source, "Trig_Armory_Select_CanWithdraw", withdraw)

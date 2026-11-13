"""Test native portrait ordering by recreating Gaya after a successful job swap."""
from pathlib import Path

from build_control_order40 import build
from jtok import functions
from performance_runtime import put

ROOT = Path(__file__).resolve().parents[1]


def refresh(source):
    fs = functions(source)
    if "Gaya_RecreateSpirit" in fs:
        body = fs["Gaya_RecreateSpirit"]
        body = body.replace("    local item l_carried", """    local item l_carried
    local item array carried
    local integer charges
    local integer rollback
    local integer raw
    local real cooldown
    local ability oldAbility""", 1)
        body = body.replace("if(l_oldSpirit==null)then", """if l_oldSpirit==null or IsUnitType(l_oldSpirit,UNIT_TYPE_DEAD) or IsUnitHidden(l_oldSpirit) or GetOwningPlayer(l_oldSpirit)!=p then""", 1)
        marker = "    call ShowUnit(l_oldSpirit,false)"
        body = body.replace(marker, """    // Only replace the six-slot Spirit. Preserve any unexpected extended storage.
    if UnitExtendedInventorySize(l_oldSpirit)>0 or GetUnitAbilityLevel(l_oldSpirit,'fGer')>0 then
        return
    endif
    loop
        exitwhen i>=bj_MAX_INVENTORY
        set carried[i]=UnitItemInSlot(l_oldSpirit,i)
        set i=i+1
    endloop
    set i=0""", 1)
        start = body.index("    call SetUnitState(l_newSpirit,UNIT_STATE_MANA")
        end = body.index("    set i=1", start)
        body = body[:start] + """    if l_newSpirit==null then
        set l_oldSpirit=null
        return
    endif
    call SetHeroXP(l_newSpirit,GetHeroXP(l_oldSpirit),false)
    loop
        exitwhen i>=bj_MAX_INVENTORY
        set l_carried=carried[i]
        if l_carried!=null then
            set charges=GetItemCharges(l_carried)
            call UnitRemoveItem(l_oldSpirit,l_carried)
            call SetItemCharges(l_carried,0)
            call UnitAddItem(l_newSpirit,l_carried)
            call SetItemCharges(l_carried,charges)
            if UnitHasItem(l_newSpirit,l_carried) and UnitItemInSlot(l_newSpirit,i)!=l_carried then
                call UnitDropItemSlot(l_newSpirit,l_carried,i)
            endif
            if UnitItemInSlot(l_newSpirit,i)!=l_carried then
                set rollback=0
                loop
                    exitwhen rollback>i
                    set l_carried=carried[rollback]
                    if l_carried!=null then
                        set charges=GetItemCharges(l_carried)
                        if UnitHasItem(l_newSpirit,l_carried) then
                            call UnitRemoveItem(l_newSpirit,l_carried)
                        endif
                        if not UnitHasItem(l_oldSpirit,l_carried) then
                            call SetItemCharges(l_carried,0)
                            call UnitAddItem(l_oldSpirit,l_carried)
                            call SetItemCharges(l_carried,charges)
                        endif
                        if UnitHasItem(l_oldSpirit,l_carried) and UnitItemInSlot(l_oldSpirit,rollback)!=l_carried then
                            call UnitDropItemSlot(l_oldSpirit,l_carried,rollback)
                        endif
                        if not UnitHasItem(l_oldSpirit,l_carried) then
                            call SetItemPosition(l_carried,GetUnitX(l_oldSpirit),GetUnitY(l_oldSpirit))
                        endif
                    endif
                    set carried[rollback]=null
                    set rollback=rollback+1
                endloop
                call RemoveUnit(l_newSpirit)
                set l_newSpirit=null
                set l_oldSpirit=null
                set l_carried=null
                return
            endif
        endif
        set i=i+1
    endloop
""" + body[end:]
        body = body.replace("    call RemoveUnit(l_oldSpirit)", """    call SetUnitState(l_newSpirit,UNIT_STATE_LIFE,GetUnitState(l_oldSpirit,UNIT_STATE_LIFE))
    call SetUnitState(l_newSpirit,UNIT_STATE_MANA,GetUnitState(l_oldSpirit,UNIT_STATE_MANA))
    set i=0
    loop
        set oldAbility=BlzGetUnitAbilityByIndex(l_oldSpirit,i)
        exitwhen oldAbility==null
        set raw=BlzGetAbilityId(oldAbility)
        set cooldown=BlzGetUnitAbilityCooldownRemaining(l_oldSpirit,raw)
        if cooldown>0. and BlzGetUnitAbility(l_newSpirit,raw)!=null then
            call BlzStartUnitAbilityCooldown(l_newSpirit,raw,cooldown)
        endif
        set i=i+1
    endloop
    set i=0
    loop
        exitwhen i>=bj_MAX_INVENTORY
        set carried[i]=null
        set i=i+1
    endloop
    call RemoveUnit(l_oldSpirit)""", 1)
        source = put(source, "Gaya_RecreateSpirit", body)
    if "Trig_Job_Change_Actions" in fs:
        body = fs["Trig_Job_Change_Actions"]
        body = body.replace("    local unit gaya=null\n    local boolean gayaWasVisible=false\n", "", 1)
        start = body.index("    // Register the incoming job")
        end = body.index("    call Berserk_Remove(jobHero)", start)
        body = body[:start] + """    call SetUnitOwner(jobNext,jobOwner,true)
    call SetUnitPathing(jobNext,true)
    call SetUnitInvulnerable(jobNext,false)
    call ShowUnitShow(jobNext)
""" + body[end:]
        marker = "    call SelectUnitForPlayerSingle(jobHero,jobOwner)"
        assert body.count(marker)==1
        body = body.replace(marker, "    call Gaya_RecreateSpirit(jobOwner)\n" + marker)
        source = put(source, "Trig_Job_Change_Actions", body)
    return source


if __name__ == "__main__":
    options = dict(transform=refresh, expected_changes={"Trig_Job_Change_Actions", "Gaya_RecreateSpirit"}, expected_added=frozenset())
    build(ROOT / "release/development/V41/FFERPG-V41.w3x",
          ROOT / "release/development/V42/FFERPG-V42.w3x",
          "FFERPG V42", "V41", "V42", **options)
    build(ROOT / "release/0.9.7.5h/Controls02/FFERPG-0.9.7.5h-Controls02.w3x",
          ROOT / "release/0.9.7.5h/Controls03/FFERPG-0.9.7.5h-Controls03.w3x",
          "FFERPG 0.9.7.5h Controls03", "h Controls02", "h Controls03", **options)

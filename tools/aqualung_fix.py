"""Apply the current Aqualung order fix to a packaged native runtime."""
from jtok import functions
from performance_runtime import put


def refresh(source):
    name='Trig_Aqualung_Cast_IsCasterHero'
    if name not in functions(source):
        return source
    body=functions(source)[name].replace('return(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO))!=null',
                                        'return IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)')
    source=put(source,name,body)
    name='Trig_Aqualung_Cast_Actions'
    body=functions(source)[name]
    old="""    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data
    call UnitAddAbilityBJ('A0M4',GetLastCreatedUnit()) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0C5',GetLastCreatedUnit()) // 'A0C5': ability "Aqualung"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),\"blizzard\",udg_TempPoint)"""
    new="""    call UnitAddAbilityBJ('A0M4',GetLastCreatedUnit()) // 'A0M4': ability "Water-elemental Damage"
    call UnitAddAbilityBJ('A0C5',GetLastCreatedUnit()) // 'A0C5': ability "Aqualung"
    call IssuePointOrderLocBJ(GetLastCreatedUnit(),\"blizzard\",udg_TempPoint)
    call ShowUnitHide(GetLastCreatedUnit())
    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data"""
    if old in body:
        body=body.replace(old,new)
    else:
        # QuickUI40 predates the explicit hide call.  Its dummy lifetime was
        # still assigned before abilities/order, which can remove it before
        # Blizzard begins.  Normalize that older sequence too.
        lifetime="    call UnitApplyTimedLifeBJ(6.,'BTLF',GetLastCreatedUnit()) // 'BTLF': object name not found in map data\n"
        body=body.replace(lifetime,'')
        order='    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)'
        if order in body:
            body=body.replace(order,order+'\n    call ShowUnitHide(GetLastCreatedUnit())\n'+lifetime,1)
    # Hiding a channeling unit cancels Blizzard even after its order succeeds.
    # h01B already uses nothing.mdl and Locust, so it needs no HideUnit call.
    import re
    body=re.sub(r'^\s*call ShowUnitHide\(GetLastCreatedUnit\(\)\)[^\n]*\n','',body,flags=re.M)
    body=re.sub(r'^\s*call UnitApplyTimedLifeBJ\([^\n]*\n','',body,flags=re.M)
    order='    call IssuePointOrderLocBJ(GetLastCreatedUnit(),"blizzard",udg_TempPoint)'
    mana='    call SetUnitState(GetLastCreatedUnit(),UNIT_STATE_MANA,GetUnitState(GetLastCreatedUnit(),UNIT_STATE_MAX_MANA))'
    if mana not in body:body=body.replace(order,mana+'\n'+order)
    body=body.replace(order,order+'\n    call UnitApplyTimedLifeBJ(12.,\'BTLF\',GetLastCreatedUnit())')
    return put(source,name,body)

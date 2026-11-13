"""Reject removed inventory owners before calling native inventory functions."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    fs=functions(source)
    if 'Forsaken_EnableHero' not in fs:return source
    name='Forsaken_EnableHero';body=fs[name]
    first="    call UnitAddAbility(holder,'fBag')"
    assert first in body
    body=body.replace(first,"""    // Player-leave cleanup removes heroes before the next maintenance tick.
    if holder==null or GetUnitTypeId(holder)==0 then
        return
    endif
"""+first,1)
    source=put(source,name,body)
    name='Forsaken_PrepareInventories';body=fs[name]
    assert 'if hero!=null then' in body
    source=put(source,name,body.replace('if hero!=null then','if hero!=null and GetUnitTypeId(hero)!=0 then'))
    name='Forsaken_RebindBag';body=fs[name]
    assert 'local integer size=BlzUnitExtendedInventorySize(holder)' in body
    body=body.replace('local integer size=BlzUnitExtendedInventorySize(holder)','local integer size=0')
    body=body.replace('if holder==null or holder!=Player_GetHero(GetOwningPlayer(holder)) then',
        'if holder==null or GetUnitTypeId(holder)==0 or holder!=Player_GetHero(GetOwningPlayer(holder)) then')
    body=body.replace('    set ForsakenConvertingGear=true',
        '    set size=BlzUnitExtendedInventorySize(holder)\n    set ForsakenConvertingGear=true',1)
    return put(source,name,body)

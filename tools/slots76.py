"""Remove the hidden legacy origin-button gate from native quick-slot aiming."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    fs=functions(source)
    if 'Preview75_QuickVisible' not in fs:return source
    n='Preview75_QuickVisible';b=fs[n]
    old='''    if show then
        set show=Preview75Button!=null and BlzFrameIsVisible(Preview75Button)
    endif'''
    assert old in b
    b=b.replace(old,'    set show=show and BagConsole65!=null',1)
    # The clicked item's actual slot lookup is the authority; the legacy
    # inventory ability's reported capacity need not describe extended slots.
    b=b.replace(' and UnitInventorySize(caster)>=6','',1)
    source=put(source,n,b)
    n='Preview75_QuickSlot';b=fs[n]
    old='    local real scale=BlzFrameGetWidth(Preview75Button)/.03125'
    assert old in b
    b=b.replace(old,'    local real scale=BlzFrameGetHeight(BagConsole65)/.13',1)
    source=put(source,n,b)
    return source

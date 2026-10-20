"""Project validated imports into Speedrun without changing their saved payload."""
from jtok import functions
from performance_runtime import put


def refresh(source):
    fs=functions(source)
    if 'FFP_Build' in fs:
        helper='''function FFP_FilterSpeedrun takes integer pid returns nothing
    local integer i=0
    local integer kept=0
    local integer src
    local integer dst
    local integer raw
    if not udg_SpeedrunMode then
        return
    endif
    loop
        exitwhen i>=FFP_Count[pid]
        set src=pid*57+i
        set dst=pid*57+kept
        set raw=FFP_Raw[src]
        if raw!='I045' and raw!='I07F' and raw!='I07G' and raw!='I07H' and raw!='I027' and raw!='I07Q' and raw!='I0KE' then
FIELDS
            set kept=kept+1
        endif
        set i=i+1
    endloop
    set FFP_Count[pid]=kept
endfunction'''.replace('FIELDS','\n'.join('            set FFP_'+field+'[dst]=FFP_'+field+'[src]' for field in ['Raw','Holder','Slot','Quantity','Bound','High','Low','Flags']))
        if 'FFP_FilterSpeedrun' in fs:source=put(source,'FFP_FilterSpeedrun',helper)
        else:source=source.replace('function FFP_Build takes',helper+'\n\nfunction FFP_Build takes',1)
        body=functions(source)['FFP_Build']
        if 'call FFP_FilterSpeedrun(pid)' not in body:
            before,after=body.rsplit('    call FSC_ClearSeen(ctx)',1)
            body=before+'    if valid then\n        call FFP_FilterSpeedrun(pid)\n    endif\n    call FSC_ClearSeen(ctx)'+after
        source=put(source,'FFP_Build',body)
    return source

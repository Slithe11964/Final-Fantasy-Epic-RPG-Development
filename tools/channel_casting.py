"""Keep invisible casting proxies active for channelled boss/shared spells."""
import re
from jtok import functions
from performance_runtime import put
ORDERS={'blizzard','starfall','volcano','rainoffire','earthquake','tranquility','flamestrike','channel','stampede','tornado','deathanddecay'}
CREATE=re.compile(r"(?m)^\s*call CreateNUnits[^\n]*")
ORDER=re.compile(r'(?m)^([ \t]*)call Issue\w*Order\w*\(GetLastCreatedUnit\(\),"([^"\n]+)"[^\n]*')
HIDE=re.compile(r'(?m)^([ \t]*)call (?:ShowUnitHide\(GetLastCreatedUnit\(\)\)|ShowUnit\(GetLastCreatedUnit\(\),false\))[^\n]*\n')


def refresh(source):
    for name,body in functions(source).items():
        matches=list(CREATE.finditer(body));updated=body
        for i,m in reversed(list(enumerate(matches))):
            end=matches[i+1].start() if i+1<len(matches) else len(body)
            block=body[m.start():end]
            if not re.search(r"'(?:h01B|h02S)'",m[0]):continue
            if not any(o[2] in ORDERS for o in ORDER.finditer(block)):continue
            block=HIDE.sub('',block)
            def mana(o):
                if o[2] not in ORDERS:return o[0]
                line=o[1]+'call SetUnitState(GetLastCreatedUnit(),UNIT_STATE_MANA,GetUnitState(GetLastCreatedUnit(),UNIT_STATE_MAX_MANA))'
                if block[:o.start()].rstrip().endswith(line.strip()):return o[0]
                return line+'\n'+o[0]
            block=ORDER.sub(mana,block)
            updated=updated[:m.start()]+block+updated[end:]
        if updated!=body:source=put(source,name,updated)
    return source

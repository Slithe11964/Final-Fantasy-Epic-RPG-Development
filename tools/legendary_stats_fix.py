"""Legendary +10 is part of a job hero's stats, not an activation-only delta."""
import re
from jtok import functions
from performance_runtime import put

def refresh(source):
    fs=functions(source)
    name='Trig_Job_Change_Actions'
    if name not in fs:return source
    body=fs[name]
    pattern=r'(?m)^\s*call ModifyHeroStat\(bj_HEROSTAT_(?:STR|AGI|INT),(?:jobHero|Player_GetHero\(udg_TempPlayer\)),bj_MODIFYMETHOD_(?:ADD|SUB),\$A\)[^\n]*\n'
    lines=re.findall(pattern,body)
    assert len(lines)==6,('Expected only the three remove/add Legendary +10 lines',len(lines))
    body=re.sub(pattern,'\n',body)
    body=body.replace('if(((GetUnitAbilityLevelSwapped(\'A02F\',jobHero)==4)))then',
        'if(((GetUnitAbilityLevelSwapped(\'A02F\',jobHero)==4)))then\n                // All Stats +10 stays on this cached job hero; do not strip/re-add it.')
    body=body.replace('if(Trig_Job_Change_OldMasteryIsFour())then',
        'if(Trig_Job_Change_OldMasteryIsFour())then\n            // All Stats +10 stays on this cached job hero.')
    body=body.replace('if(Trig_Job_Change_NewMasteryIsFour())then',
        'if(Trig_Job_Change_NewMasteryIsFour())then\n                // Constructors/loaders already include the selected +10.')
    return put(source,name,body)

"""Prepare native spell instances before casting; commit reduced timers afterward."""
import re
from jtok import functions
from performance_runtime import put

HELPER='''function Cooldown_ApplyCurrent takes unit caster,integer raw,integer level,real duration returns nothing
    local ability entry=GetSpellAbility()
    set level=IMaxBJ(0,level)
    set duration=RMaxBJ(0.,duration)
    if entry!=null and GetSpellAbilityId()==raw then
        call BlzSetAbilityRealLevelField(entry,ABILITY_RLF_COOLDOWN,level,duration)
    endif
    call BlzSetUnitAbilityCooldown(caster,raw,level,duration)
    if GetTriggerEventId()==EVENT_PLAYER_UNIT_SPELL_EFFECT and not SharedItemCD_IsItem(raw) then
        call NativeCD_Queue(caster,raw,duration,false)
    endif
    set entry=null
endfunction'''

def refresh(source,*,native=False):
    fs=functions(source)
    if not native or 'Trig_Cooldown_Scaling_Actions' not in fs:return source
    for name in ['Cooldown_ApplyCurrent']:
        source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
    pos=re.search(r'^function ',source,re.M).start()
    source=source[:pos]+HELPER+'\n\n'+source[pos:]
    if 'Forsaken_SetCastCooldown' in functions(source):
        source=put(source,'Forsaken_SetCastCooldown','''function Forsaken_SetCastCooldown takes unit caster,integer raw,integer level,real duration returns nothing
    call Cooldown_ApplyCurrent(caster,raw,level,duration)
endfunction''')
    name='Register_Cooldown_Scaling';body=functions(source)[name]
    for event in ['EVENT_PLAYER_UNIT_SPELL_CHANNEL','EVENT_PLAYER_UNIT_SPELL_CAST']:
        line='    call TriggerRegisterAnyUnitEventBJ(gg_trg_Cooldown_Scaling,'+event+')'
        if line not in body:body=body.replace('    call TriggerAddCondition(',line+'\n    call TriggerAddCondition(',1)
    return put(source,name,body)

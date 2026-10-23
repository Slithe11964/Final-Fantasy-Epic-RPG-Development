"""Quest keys can be carried by the player's hero or Gaya, in any inventory slot."""
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency

HELPER='''function Carry_QuestItem takes unit holder,integer raw returns item
    local item found
    local player owner
    local unit hero
    local unit gaya
    if holder==null then
        return null
    endif
    set found=Carry_Find(holder,raw)
    if found!=null then
        return found
    endif
    set owner=GetOwningPlayer(holder)
    set hero=Player_GetHero(owner)
    set gaya=udg_SpiritOfGaya[GetPlayerId(owner)+1]
    if holder==hero and gaya!=null then
        set found=Carry_Find(gaya,raw)
    elseif holder==gaya and hero!=null then
        set found=Carry_Find(hero,raw)
    endif
    set owner=null
    set hero=null
    set gaya=null
    return found
endfunction'''

def objects(data):
    """Excalipoor is a carried quest item, not native or legacy equipment."""
    if not data:return data
    from objdata import read_objects,write_objects
    table=read_objects(data,'w3t')
    for obj in table['custom']:
        if obj['id']=='I0A3':
            for st in obj['sets']:
                changes={'icla':'Campaign','iequ':'','ilev':0,'ilvo':0}
                st['mods'][:]=[m for m in st['mods'] if m['field'] not in changes]
                for field,value in changes.items():
                    st['mods'].append(dict(field=field,type=3 if isinstance(value,str) else 0,level=None,data=None,value=value,end=0))
    return write_objects(table,table['version'],'w3t')

def refresh(source):
    fs=functions(source)
    if 'Trig_FillVial_Cast_Actions' in fs:
        source=dependency(source,'TItemStack')
        name='Trig_FillVial_Cast_Actions';body=fs[name]
        if 'local item empty=' not in body:
            body=body.replace('    local force l_tempForce','    local item empty=Carry_QuestItem(GetTriggerUnit(),\'bzbe\')\n    local force l_tempForce',1)
            body=body.replace('    set l_tempForce=', '    if empty==null then\n        return\n    endif\n    set l_tempForce=',1)
        import re
        body=re.sub(r"(?:Gear_Carried|GetItemOfTypeFromUnitBJ)\(GetTriggerUnit\(\),\s*'bzbe'\)",'empty',body)
        body=body.replace('    set l_tempForce=null\nendfunction','    set l_tempForce=null\n    set empty=null\nendfunction')
        source=put(source,name,body)
    if 'Carry_Find' in fs:
        if 'Carry_QuestItem' in fs:source=put(source,'Carry_QuestItem',HELPER)
        else:source=source.replace('function Carry_Worn takes',HELPER+'\n\nfunction Carry_Worn takes',1)
    if 'Trig_HolyAnkh_Waygate_Conditions' in fs:
        source=dependency(source,'TItemStack')
        source=put(source,'Trig_HolyAnkh_Waygate_Conditions',"""function Trig_HolyAnkh_Waygate_Conditions takes nothing returns boolean
    return IsPlayerInForce(GetOwningPlayer(GetTriggerUnit()),udg_PlayingPlayers) and Carry_QuestItem(GetTriggerUnit(),'I0BZ')!=null
endfunction""")
        name='Trig_HolyAnkh_Waygate_Actions'
        body=fs[name].replace("Gear_Carried(GetTriggerUnit(),'I0BZ')","Carry_QuestItem(GetTriggerUnit(),'I0BZ')").replace("GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0BZ')","Carry_QuestItem(GetTriggerUnit(),'I0BZ')")
        source=put(source,name,body)
    if 'Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey' in fs:
        source=dependency(source,'TItemStack')
        source=put(source,'Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey',"""function Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey takes nothing returns boolean
    return Carry_QuestItem(GetTriggerUnit(),'I0IM')!=null
endfunction""")
        source=put(source,'Trig_Gate_WinterKey_Unlock_Cond_HasKeyOrNotSpirit',"""function Trig_Gate_WinterKey_Unlock_Cond_HasKeyOrNotSpirit takes nothing returns boolean
    return Carry_QuestItem(GetTriggerUnit(),'I0IM')!=null or GetUnitTypeId(GetTriggerUnit())!='H01D'
endfunction""")
        name='Trig_Gate_WinterKey_Unlock_Actions'
        body=fs[name].replace("Gear_Carried(GetTriggerUnit(),'I0IM')","Carry_QuestItem(GetTriggerUnit(),'I0IM')").replace("GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I0IM')","Carry_QuestItem(GetTriggerUnit(),'I0IM')")
        source=put(source,name,body)
    return source

"""Read-only proficiency presentation; keep completed research descriptions in houses."""
import re
from objdata import read_objects,write_objects
from jtok import functions
from performance_runtime import put

PROFS=[('R000','Tools'),('R001','Sword'),('R002','Bow'),('R00B','Dagger'),
       ('R009','Spear'),('R008','Axe'),('R00I','Heavens Forged Axe'),('R00A','Katana'),
       ('R00N','Greatsword'),('R003','Rod'),('R004','Staff'),('R00M','Gun'),
       ('R00L','Inner Mana'),('R006','Leather Armor'),('R005','Plate Armor'),('R007','Mystic Armor')]


def catalogue(main,skin,units):
    records={}
    for data in (main,skin):
        if not data:continue
        for obj in read_objects(data,'w3q')['custom']:
            fields=records.setdefault(obj['id'],{})
            for st in obj['sets']:
                for m in st['mods']:fields[m['field'],m['level']]=m['value']
    houses={}
    for obj in read_objects(units,'w3u')['custom']:
        for st in obj['sets']:
            for m in st['mods']:
                if m['field']=='ures' and any(raw in m['value'].split(',') for raw,_ in PROFS):
                    houses[obj['id']]=m['value'].split(',')
    result=[]
    for i,(raw,name) in enumerate(PROFS):
        f=records.get(raw,{})
        if not f:continue
        cap=f.get(('glvl',0),10)
        desc=f.get(('gub1',cap),f.get(('gub1',1),''))
        # Required-level text refers to purchasing the upgrade, not its permanent effect.
        desc=re.split(r'\|n\|n\|cffffcc00Required level',desc)[0]
        result.append(dict(raw=raw,name=name,ability='pF'+format(i,'02X'),cap=cap,
            icon=f.get(('gar1',cap),f.get(('gar1',1),'')),description=desc,
            x=f.get(('gbpx',0),0),y=f.get(('gbpy',0),0),
            houses=[h for h,upgrades in houses.items() if raw in upgrades]))
    return result


def objects(data,entries):
    table=read_objects(data,'w3a')
    for e in entries:
        if not e['houses']:continue
        values=[('aher',0,0,0),('aite',0,0,0),('alev',0,0,1),('arac',3,0,'other'),
                ('Eev1',2,1,0.),('areq',3,0,''),('aart',3,0,e['icon']),
                ('abpx',0,0,e['x']),('abpy',0,0,e['y']),
                ('anam',3,0,e['name']+' proficiency (complete)'),
                ('atp1',3,1,e['name']+' - |cffffcc00Maximum level '+str(e['cap'])+'|r'),
                ('aub1',3,1,e['description'])]
        obj=dict(base='AIev',id=e['ability'],sets=[dict(flag=0,mods=[dict(field=f,type=k,level=l,
                 data=1 if f=='Eev1' else 0,value=v,end=0) for f,k,l,v in values])])
        old=next((o for o in table['custom'] if o['id']==e['ability']),None)
        if old and old!=obj:raise ValueError('reserved proficiency display ID differs: '+e['ability'])
        if not old:table['custom'].append(obj)
    return write_objects(table,table['version'],'w3a')


def house_runtime(source,entries):
    if 'Trig_House_Options_Switch_Actions' not in functions(source):return source
    # Called by synchronized selection/research/spell-finish events, never local UI.
    lines=['function ProfHouse_Refresh takes unit house returns nothing',
           '    local player owner=GetOwningPlayer(house)',
           '    if house!=udg_PlayerHouse[GetPlayerId(owner)+1] then',
           '        set owner=null','        return','    endif']
    for e in entries:
        if not e['houses']:continue
        kinds=' or '.join("GetUnitTypeId(house)=='"+h+"'" for h in e['houses'])
        lines.extend(["    if ("+kinds+") and GetPlayerTechCount(owner,'"+e['raw']+"',true)>="+str(e['cap'])+' then',
                      "        call UnitAddAbility(house,'"+e['ability']+"')",'    else',
                      "        call UnitRemoveAbility(house,'"+e['ability']+"')",'    endif'])
    lines+=['    set owner=null','endfunction','',
        'function ProfHouse_Event takes nothing returns nothing','    call ProfHouse_Refresh(GetTriggerUnit())','endfunction','',
        'function ProfHouse_Register takes nothing returns nothing','    local trigger events=CreateTrigger()',
        '    call TriggerRegisterAnyUnitEventBJ(events,EVENT_PLAYER_UNIT_SELECTED)',
        '    call TriggerRegisterAnyUnitEventBJ(events,EVENT_PLAYER_UNIT_RESEARCH_FINISH)',
        '    call TriggerRegisterAnyUnitEventBJ(events,EVENT_PLAYER_UNIT_SPELL_FINISH)',
        '    call TriggerAddAction(events,function ProfHouse_Event)','    set events=null','endfunction']
    helper='\n'.join(lines)
    for name,body in functions(helper).items():
        if name in functions(source):source=put(source,name,body)
        else:source=source.replace('function RegisterTriggers_House takes',body+'\n\nfunction RegisterTriggers_House takes',1)
    body=functions(source)['RegisterTriggers_House']
    if 'call ProfHouse_Register()' not in body:body=body.replace('endfunction','    call ProfHouse_Register()\nendfunction')
    return put(source,'RegisterTriggers_House',body)


def stat_helper(prefix,row):
    lines=['function '+prefix+'_RenderProficiencies takes unit hero returns nothing']
    for i,(raw,name) in enumerate((raw,name) for raw,name in PROFS if raw!='R00I'):
        value="GetPlayerTechCount(GetOwningPlayer(hero),'R008',true)" if raw=='R008' else "Prof_GetLevel(hero,'"+raw+"')"
        lines.append('    call '+row+'('+str(i)+',"'+name+'",I2S('+value+'))')
    return '\n'.join(lines+['endfunction'])

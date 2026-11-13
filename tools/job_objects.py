"""Job object corrections, applied after editor/profile merges to both art tables."""
import copy
import re
from objdata import read_objects,write_objects

# Moon Glaive is an upgrade ability: even with empty art it can create a moon
# upgrade indicator. These are trigger-only markers, so use zero evasion instead.
MARKERS={'A14S','A14T','A0Z8','A1FC'}
# Ordinary-unit templates, isolated from lower ranks and world/enemy uses.
MASTER_SUMMONS={'n066':'sM00','n07S':'sM01','e00T':'sM02','e00U':'sM03',
                'n065':'sM04','n064':'sM05','n005':'sM06','n00G':'sM07',
                'u00P':'sM08','u00R':'sM09','o00H':'sM0A'}


def refresh_units(data):
    if not data:return data
    table=read_objects(data,'w3u')
    originals={o['id']:o for o in table['custom'] if o['id'] in MASTER_SUMMONS}
    for raw,obj in originals.items():
        clone=copy.deepcopy(obj);clone['id']=MASTER_SUMMONS[raw]
        if not clone['base'][0].islower() or not clone['id'][0].islower():
            raise ValueError('master summon must remain a nonhero: '+raw)
        for entry in clone['sets']:
            mods=entry['mods']
            mods[:]=[m for m in mods if m['field']!='ulev']
            mods.append(dict(field='ulev',type=0,level=None,data=None,value=40,end=0))
        existing=next((o for o in table['custom'] if o['id']==clone['id']),None)
        if existing:
            if existing!=clone:raise ValueError('reserved master summon ID differs: '+clone['id'])
        else:table['custom'].append(clone)
    return write_objects(table,table['version'],'w3u')

IMPERIL=('Lowers each elemental resistance by one tier: Absorb -> Immune -> 50% -> 20% -> 0% -> -60% -> -100% -> Lethal. '
         'Negative resistance increases damage taken. Lethal kills ordinary units with a matching element; heroes and resistant units take double damage instead.')


def refresh(data):
    if not data:return data
    table=read_objects(data,'w3a')
    for obj in table['custom']:
        if obj['id']=='A0RY':
            # Installed AbilityMetaData: ANdh uses Nsi1..4, not Ndh fields.
            for entry in obj['sets']:
                entry['mods'][:]=[m for m in entry['mods'] if m['field'] not in ('Ndh1','Ndh2','Nsi1','Nsi2','Nsi3','Nsi4')]
                for rank in range(1,12):
                    entry['mods'].append(dict(field='Nsi1',type=0,level=rank,data=1,value=0,end=0))
                    for field,data_index in [('Nsi2',2),('Nsi3',3),('Nsi4',4)]:
                        entry['mods'].append(dict(field=field,type=2,level=rank,data=data_index,value=0.,end=0))
        raw=obj['id']
        if raw in MARKERS:obj['base']='AIev'
        for entry in obj['sets']:
            mods=entry['mods']
            def set_value(field,value,kind=0,level=0):
                found=next((m for m in mods if m['field']==field and m['level']==level),None)
                if found is None:
                    mods.append(dict(field=field,type=kind,level=level,data=0,value=value,end=0))
                else:found.update(value=value,type=kind)
            if raw in MARKERS:
                set_value('Eev1',0.,1,1)
                set_value('aher',0);set_value('aite',0)
                set_value('areq','',3)
            for m in mods:
                if m['level']==11 and raw=='A0Z2' and m['field'] in {'Rai3','Rai4','Raiu'}:
                    m['value']=MASTER_SUMMONS.get(m['value'],m['value'])
                if m['level']==11 and raw=='A07V' and m['field']=='Hwe1':
                    m['value']=MASTER_SUMMONS.get(m['value'],m['value'])
            if raw=='A14B':
                for rank in range(1,12):set_value('Blo1',-(.30+.06*(rank-1)),1,rank)
            if raw=='A0RH':
                set_value('alev',15)
                for rank in range(1,16):set_value('Eev1',0.,1,rank)
            for m in mods:
                if m['type']!=3:continue
                if raw in {'A025','A070'} and m['field'] in {'aub1','arut'} and m['level']:
                    rank=m['level']
                    speed=(120 if rank>=11 else 55+5*rank) if raw=='A070' else (100 if rank>=11 else 35+5*rank)
                    m['value']=re.sub(r'(attack(?: speed by | ))[0-9]+%( faster)?',
                                      lambda match:match[1]+str(speed)+'%'+(match[2] or ''),m['value'])
                if raw in {'A14T','A14S'}:
                    m['value']=m['value'].replace('30 seconds','90 seconds')
                if raw=='A0I4' and m['field'] in {'aub1','arut'}:
                    # Preserve rank-specific duration/cost following the old first sentence.
                    old=m['value'];tail=old.split('.',1)[1] if '.' in old else ''
                    if 'Lowers each elemental resistance' not in old:m['value']=IMPERIL+tail
    return write_objects(table,table['version'],'w3a')


WHITE_ROBE_TEXT=('Adds 6 Staff proficiency to Life spells (+30% of base spell power at full mana before other bonuses). '
                 'The final percentage depends on current mana and Staff proficiency; see Other bonuses for the current increase.')


def refresh_robe(data,ext):
    if not data:return data
    table=read_objects(data,ext)
    for obj in table['custom']:
        if obj['id'] not in {'I0D2','f275','n0NB'}:continue
        for entry in obj['sets']:
            for mod in entry['mods']:
                if mod['type']==3 and mod['field'] in {'ides','utub'}:
                    mod['value']=mod['value'].replace('Increases the power of Life spells.',WHITE_ROBE_TEXT)
    return write_objects(table,table['version'],ext)

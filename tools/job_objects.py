"""Job object corrections, applied after editor/profile merges to both art tables."""
from objdata import read_objects,write_objects

# Moon Glaive is an upgrade ability: even with empty art it can create a moon
# upgrade indicator. These are trigger-only markers, so use zero evasion instead.
MARKERS={'A14S','A14T','A0Z8','A1FC'}
IMPERIL=('Lowers each elemental resistance by one tier: Absorb -> Immune -> 50% -> 20% -> 0% -> -60% -> -100% -> Lethal. '
         'Negative resistance increases damage taken. Lethal kills ordinary units with a matching element; heroes and resistant units take double damage instead.')


def refresh(data):
    if not data:return data
    table=read_objects(data,'w3a')
    for obj in table['custom']:
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
            if raw=='A14B':
                for rank in range(1,12):set_value('Blo1',-(.30+.06*(rank-1)),1,rank)
            if raw=='A0RH':
                set_value('alev',15)
                for rank in range(1,16):set_value('Eev1',0.,1,rank)
            for m in mods:
                if m['type']!=3:continue
                if raw in {'A14T','A14S'}:
                    m['value']=m['value'].replace('30 seconds','90 seconds')
                if raw=='A0I4' and m['field'] in {'aub1','arut'}:
                    # Preserve rank-specific duration/cost following the old first sentence.
                    old=m['value'];tail=old.split('.',1)[1] if '.' in old else ''
                    if 'Lowers each elemental resistance' not in old:m['value']=IMPERIL+tail
    return write_objects(table,table['version'],'w3a')

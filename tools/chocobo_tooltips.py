"""Remove obsolete unsavable labels from Chocobo greens/nuts; preserve item data."""
import re
from objdata import read_objects,write_objects
IDS={'I045','I07F','I07G','I07H','I027','I07Q','I0KE','I0J2','I03S','I03Q','I07K'}
LABEL=re.compile(r'\s*\(\s*not\s+sav(?:e)?able\s*\)',re.I)

def objects(data,strings=None):
    if not data:return data
    strings=strings or {}
    def resolve(value):
        match=re.fullmatch(r'TRIGSTR_(\d+)',value) if isinstance(value,str) else None
        return strings.get(int(match[1]),value) if match else value
    table=read_objects(data,'w3t');changed=False
    for group in ('original','custom'):
        for obj in table[group]:
            mods=[m for st in obj['sets'] for m in st['mods']]
            name=next((resolve(m['value']) for m in mods if m['field']=='unam'),'')
            if (obj['id'] or obj['base']) not in IDS and not re.search(r'\b(?:greens|nut)\b',str(name),re.I):continue
            for mod in mods:
                if mod['field'] not in {'unam','ides','utip','utub'}:continue
                value=resolve(mod['value'])
                if isinstance(value,str):
                    cleaned=LABEL.sub('',value)
                    if cleaned!=value:mod['value']=cleaned;changed=True
    return write_objects(table,table['version'],'w3t') if changed else data

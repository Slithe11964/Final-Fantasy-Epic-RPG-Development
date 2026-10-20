"""Materialize authored Channel rank inheritance before runtime tooltip writes.

Only carry values from an explicitly authored earlier rank. Do not guess base
defaults or replace deliberate rank-specific channel times/options/orders.
"""
import copy
from objdata import read_objects,write_objects

FIELDS={f'Ncl{i}' for i in range(1,7)}


def complete(main,skin=None):
    blobs=[main,skin];tables=[read_objects(b,'w3a') if b else None for b in blobs]
    effective={}
    for table in tables:
        if not table:continue
        for group in ['original','custom']:
            for obj in table[group]:
                if obj['base']!='ANcl':continue
                key=obj['id'] or obj['base'];entry=effective.setdefault(key,{})
                for st in obj['sets']:
                    for mod in st['mods']:entry[mod['field'],mod['level']]=copy.deepcopy(mod)
    for table in tables:
        if not table:continue
        for group in ['original','custom']:
            for obj in table[group]:
                if obj['base']!='ANcl':continue
                data=effective[obj['id'] or obj['base']]
                levels=int(data.get(('alev',0),{}).get('value',1))
                for st in obj['sets']:
                    present={(m['field'],m['level']) for m in st['mods']}
                    for field in sorted(FIELDS):
                        inherited=None
                        for rank in range(1,levels+1):
                            if (field,rank) in data:inherited=data[field,rank]
                            if inherited is not None and (field,rank) not in present:
                                mod=copy.deepcopy(inherited);mod.update(level=rank,data=int(field[-1]))
                                st['mods'].append(mod)
    return tuple(write_objects(t,t['version'],'w3a') if t else b for t,b in zip(tables,blobs))

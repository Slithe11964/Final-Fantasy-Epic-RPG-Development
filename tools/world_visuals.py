"""Remove inherited dummy-passive attachments without replacing authored art."""
from objdata import read_objects,write_objects
ART_FIELDS=('acat','atat','aeat','asat')


def clear_marker_art(data):
    table=read_objects(data,'w3a');changed=[]
    for obj in table['custom']:
        if obj['base']!='Amgl':continue
        touched=False
        for values in obj['sets']:
            mods=values['mods'];present={m['field'] for m in mods}
            for field in ART_FIELDS:
                if field not in present:
                    mods.append(dict(field=field,type=3,level=0,data=0,value='',end=0))
                    touched=True
        if touched:changed.append(obj['id'])
    return write_objects(table,table['version'],'w3a'),changed

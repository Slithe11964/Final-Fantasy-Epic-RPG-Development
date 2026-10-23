"""Quest sight follows possession, independent of equipped-item passive rules."""
from pathlib import Path
import re
from jtok import functions
from performance_runtime import put
from objdata import read_objects,write_objects
ROOT=Path(__file__).resolve().parents[1]

def refresh(source):
    if 'Carry_Has' not in functions(source):return source
    declarations=['boolean array MaidenEyeDirty','unit array MaidenEyeHero','unit array MaidenEyeGaya',
                  'integer MaidenEyeSweep=19','timer MaidenEyeTimer=null','trigger MaidenEyeEvents=null']
    for declaration in declarations:
        name=declaration.split('=')[0].split()[-1]
        if not re.search(r'^\s*\w+\s+(?:array )?'+name+r'\b',source,re.M):
            source=source.replace('endglobals','    '+declaration+'\nendglobals',1)
    helper=(ROOT/'experiments/Forsaken/MaidensEye.j').read_text()
    for name in functions(helper):
        source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
    marker='function Register_Item_Stack_Order takes'
    if marker not in source:raise ValueError('ItemStack startup boundary changed')
    source=source.replace(marker,helper+'\n'+marker,1)
    body=functions(source)['Register_Item_Stack_Order']
    if 'call MaidenEye_Init()' not in body:
        body=body.replace('returns nothing\n','returns nothing\n    call MaidenEye_Init()\n',1)
    return put(source,'Register_Item_Stack_Order',body)

def objects(data):
    table=read_objects(data,'w3a')
    found=[o for group in ('original','custom') for o in table[group] if (o['id'] or o['base'])=='aMEy']
    if found:
        if len(found)!=1 or found[0]['base']!='Atru':raise ValueError('Maiden Eye ability ID collision')
        return data
    mods=[dict(field=key,type=kind,level=0,data=0,value=value,end=0) for key,kind,value in
          [('anam',3,'Maiden Eye - carried sight'),('aher',0,0),('aite',0,1),('alev',0,1)]]
    table['custom'].append(dict(base='Atru',id='aMEy',sets=[dict(flag=0,mods=mods)]))
    return write_objects(table,table['version'],'w3a')

"""Aqualung uses the original eight waves/formula without a proxy caster."""
import re
import copy
from pathlib import Path
from jtok import functions
from performance_runtime import put
from damage_tooltips import merged
from priest_master import fields,setf
from objdata import read_objects,write_objects

ROOT=Path(__file__).resolve().parents[1]
RAW=('A1AB','A0SN','A0WB')
TIP='Erupt the target area with eight bursts of water, dealing water damage to enemies.|n|n|cffffcc00Damage calculation|r|nWater damage per burst: (MP cost + INT) x Rod spell power.|n8 bursts over 7 seconds. Radius: 250.'


def refresh(source):
    if 'Trig_Aqualung_Cast_Actions' not in functions(source):return source
    fragment=(ROOT/'experiments/Forsaken/AqualungPulses.j').read_text()
    declarations=re.search(r'globals\n(.*?)endglobals',fragment,re.S)[1]
    if 'hashtable AquaData=' not in source:source=source.replace('endglobals',declarations+'endglobals',1)
    helpers='\n\n'.join(body for name,body in functions(fragment).items() if name!='Trig_Aqualung_Cast_Actions')
    source=source.replace('function Trig_Aqualung_Cast_Actions takes',helpers+'\n\nfunction Trig_Aqualung_Cast_Actions takes',1)
    source=put(source,'Trig_Aqualung_Cast_Actions',functions(fragment)['Trig_Aqualung_Cast_Actions'])
    return source


def objects(main,skin):
    resolved=merged(main,skin,'w3a')
    replacements={}
    for raw in RAW:
        obj=copy.deepcopy(resolved[raw])
        for rank in range(1,int(fields(obj).get(('alev',0),1))+1):
            setf(obj,'atp1','Aqualung',rank)
            setf(obj,'aub1',TIP,rank)
        setf(obj,'arut',TIP)
        replacements[raw]=obj
    table=read_objects(main,'w3a')
    table['custom']=[replacements.get(o['id'],o) for o in table['custom']]
    main=write_objects(table,table['version'],'w3a')
    table=read_objects(skin,'w3a')
    table['custom']=[o for o in table['custom'] if o['id'] not in replacements]
    return main,write_objects(table,table['version'],'w3a')

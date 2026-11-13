"""Route F/G through the native equipment button, retaining engine targeting."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from priest_master import fields
from equipment_quickcast import refresh as quickcast_refresh,catalogue

ROOT=Path(__file__).resolve().parents[1]


def refresh(source,config):
    if 'Forsaken_PollPanels' not in functions(source):return source
    source=quickcast_refresh(source,config,native=True)
    original=functions(source)
    fragment=(ROOT/'experiments/Forsaken/NativeGearButtons.j').read_text()
    globals_=re.search(r'globals\n(.*?)endglobals',fragment,re.S)
    source=source.replace('endglobals',globals_[1]+'endglobals',1)
    fs=functions(fragment)
    # Keep the same authoritative gear aliases/target modes and spell shapes.
    catalogue_rows='\n'.join(line for line in original['QuickGear_Init'].splitlines() if 'call SaveInteger(QuickGearData,' in line)
    aliases={alias:raw for raw,mapping in config['mapping'].items() for alias in (mapping.get('variant'),mapping.get('offhand'),config['quick'].get(raw)) if alias}
    for raw in catalogue(config):
        obj=config['items'].get(aliases.get(raw,raw))
        icon=str(fields(obj).get(('iico',None),'')) if obj else ''
        if icon:
            catalogue_rows+='\n    call SaveStr(QuickGearData,3,\''+raw+'\',"'+icon.replace('\\','\\\\')+'")'
    fs['QuickGear_Init']=fs['QuickGear_Init'].replace('    // ITEM CATALOGUE',catalogue_rows)
    helpers='\n\n'.join(body for name,body in fs.items() if name not in original)
    source=source.replace('function QuickGear_Request takes',helpers+'\n\nfunction QuickGear_Request takes',1)
    for name,body in fs.items():
        if name in original:source=put(source,name,body)
    return source

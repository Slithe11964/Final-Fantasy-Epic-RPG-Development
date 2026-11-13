"""Native equipped-item shortcuts; local input sends requests, shared code casts."""
import json,re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
from priest_master import fields,at
ROOT=Path(__file__).resolve().parents[1]

def catalogue(config):
    bases=json.loads((ROOT/'experiments/Forsaken/ability-base-codes.json').read_text())
    result={}
    instant={'AIgo','AIha','Absk'}
    unit={'AHdr','AHhb','AHtb','ANdh','AUfa','Acri','Arej','Auhf'}
    for raw in sorted(config['gear']|config.get('materia',set())):
        obj=config['items'].get(raw)
        if not obj:continue
        for ability in str(fields(obj).get(('iabi',None),'')).split(','):
            if ability not in config['abilities'] or ability in config['passive']:continue
            a=config['abilities'][ability];f=fields(a)
            base=f.get(('acod',0),bases.get(a['base'],a['base']))
            if base=='ANcl':mode=int(at(f,'Ncl2',1,0))
            elif base in instant:mode=0
            elif base in unit:mode=1
            elif base=='AOws':mode=2
            else:raise ValueError('Review equipped-item target mode: '+raw+'/'+ability+'/'+base)
            result[raw]=(ability,mode)
            for alias in (config['mapping'].get(raw,{}).get('variant'),config['mapping'].get(raw,{}).get('offhand'),config.get('quick',{}).get(raw)):
                if alias:result[alias]=(ability,mode)
            break
    return result

def refresh(source,config,*,native=False):
    # Owner rejected UI47..49 and explicitly restored the working release.
    # Keep future normal builds on that implementation until asked otherwise.
    if not native:return source
    from release_gear import refresh as released_refresh
    from gear_recovery53 import refresh as load_refresh
    return load_refresh(released_refresh(source))


def experimental_refresh(source,config,*,native=False):
    if not native or 'Forsaken_PollPanels' not in functions(source):return source
    # Full-number images cover every authored gear cooldown, including Slowra.
    # Fail future builds explicitly instead of silently displaying a capped timer.
    for item,(ability,mode) in catalogue(config).items():
        f=fields(config['abilities'][ability])
        maximum=max(float(at(f,'acdn',rank,0)) for rank in range(1,int(f.get(('alev',0),1))+1))
        if maximum*1.5>300:raise ValueError('Extend quick-gear countdown images for '+item+'/'+ability)
    source=dependency(dependency(source,'TItemCooldown'),'TTravel')
    fragment=(ROOT/'experiments/Forsaken/EquipmentQuickCast.j').read_text()
    declarations,fragment=fragment.split('// FUNCTIONS\n',1)
    declarations='\n'.join(line for line in declarations.splitlines() if re.match(r'^\s*\w+\s+(?:array\s+)?QuickGear\w+',line))
    for line in declarations.splitlines():
        if not line.strip():continue
        name=line.split('=')[0].split()[-1]
        if not re.search(r'^\s*\w+\s+(?:array )?'+name+r'\b',source,re.M):
            source=source.replace('endglobals',line+'\nendglobals',1)
    init=functions(fragment)['QuickGear_Init']
    lines=[]
    for raw,(ability,mode) in sorted(catalogue(config).items()):
        lines.extend([f"    call SaveInteger(QuickGearData,0,'{raw}','{ability}')",f"    call SaveInteger(QuickGearData,1,'{raw}',{mode})"])
    for ability in ('A08X','A0Q0','A0Q1','A0Q2','A0SM','A0TP','A0SA','A150'):
        lines.append(f"    call SaveInteger(QuickGearData,2,'{ability}',1)")
    lines.append("    call SaveInteger(QuickGearData,2,'A0UY',2)")
    f=fields(config['abilities']['A0Q2'])
    hotkey=str(f.get(('ahky',0),''))
    if len(hotkey)==1:lines.append(f"    call SaveInteger(QuickGearData,5,{ord(hotkey.upper())},'A0Q2')")
    position=int(f.get(('abpx',0),0))+4*int(f.get(('abpy',0),0))
    lines.append(f"    call SaveInteger(QuickGearData,6,{position},'A0Q2')")
    init=init.replace('    // ITEM CATALOGUE','\n'.join(lines))
    fragment=put(fragment,'QuickGear_Init',init)
    # Match the authored AoE at each rank; unit-only tomes get no ground circle.
    preview_rows={}
    for raw,(ability,mode) in catalogue(config).items():
        if mode<2:continue
        f=fields(config['abilities'][ability])
        for rank in range(1,int(f.get(('alev',0),1))+1):
            radius=float(at(f,'aare',rank,0))
            if radius>0:preview_rows[ability,rank]=radius
    radii={radius:i+1 for i,radius in enumerate(sorted(set(preview_rows.values())))}
    lines=[f'    set QuickGearPreviewCount={len(radii)}']
    lines.extend(f'    set QuickGearPreviewRadius[{index}]={radius}' for radius,index in radii.items())
    lines.extend(f"    call SaveInteger(QuickGearData,{32+rank},'{ability}',{radii[radius]})" for (ability,rank),radius in sorted(preview_rows.items()))
    body=functions(fragment)['QuickGear_InitPreviews'].replace('    // AREA PREVIEWS','\n'.join(lines))
    fragment=put(fragment,'QuickGear_InitPreviews',body)
    # This namespace is wholly owned by this fragment. Clear retired helpers
    # and declarations too, so a rollback cannot keep a later startup callback.
    for name in functions(source):
        if name.startswith('QuickGear_'):
            source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
    wanted={line.split('=')[0].split()[-1] for line in declarations.splitlines() if line.strip()}
    source=re.sub(r'^\s*\w+\s+(?:array\s+)?(QuickGear\w+)(?:=[^\n]*)?\n',
        lambda m:m[0] if m[1] in wanted else '',source,flags=re.M)
    source=source.replace('function Forsaken_PanelAccess takes',fragment+'\nfunction Forsaken_PanelAccess takes',1)
    body=functions(source)['Register_Forsaken_PanelAccess']
    if 'call QuickGear_Init()' not in body and 'call QuickGear_ScheduleInit()' not in body:
        body=body.replace('    call Forsaken_RegisterBackpackActivity()','    call Forsaken_RegisterBackpackActivity()\n    call QuickGear_Init()')
    body=body.replace('call QuickGear_ScheduleInit()','call QuickGear_Init()')
    source=put(source,'Register_Forsaken_PanelAccess',body)
    body=functions(source)['Forsaken_PollPanels']
    body=body.replace('    call QuickGear_Draw(hero,viewer)\n','')
    source=put(source,'Forsaken_PollPanels',body)
    body=functions(source).get('Forsaken_RebuildPanels')
    if body and 'call QuickGear_Reset()' not in body:
        body=body.replace('    call PauseTimer(ForsakenUITimer)','    call QuickGear_Reset()\n    call PauseTimer(ForsakenUITimer)',1)
        source=put(source,'Forsaken_RebuildPanels',body)
    return source

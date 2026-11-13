"""Native quick-build Thief ultimate; preserves the saved A0KY skill identity."""
import copy,re
from pathlib import Path
from jtok import functions
from performance_runtime import put
from priest_master import fields,setf
from objdata import read_objects,write_objects

ROOT=Path(__file__).resolve().parents[1]
MANA=(0,0,0,0,0,0)
COOLDOWNS=(120.,)*6
ICON='ReplaceableTextures\\CommandButtons\\BTNSpecialDagger5.blp'
DESCRIPTION="Activate to start stabbing the daggers you've collected into the opponent stacking for 30 seconds. When cast again rip the daggers out of your target dealing moderate damage based on how many daggers were pulled out of the target."

def tooltip(rank):
    return (DESCRIPTION+'|n|nDrains 20 MP per second while active. Ripping costs 300 MP. Cooldown after ripping: 120 seconds.'
        +'|n|n|cffffcc00Damage calculation|r|nPhysical damage per dagger: (100 + 0.3 x AGI) x (1 + 5% x Dagger proficiency).'
        +'|nBehind the target: 25% more rip damage. Daggers are owned by this Thief, last 30 seconds, and can be ripped only within 250 range.')

def refresh(source):
    source=re.sub(r"call SaveStr\(SpellCalcData,'A0KY',(\d+),\"(?:\\.|[^\"\\])*\"\)",
        lambda m:'call SaveStr(SpellCalcData,\'A0KY\','+m[1]+',"'+(tooltip(min(6,int(m[1]))) if int(m[1])<100 else '')+'")',source)
    fs=functions(source)
    if 'Trig_Damage_Engine_Actions' in fs:
        if 'Cuts_OnHit' not in fs:
            fragment=(ROOT/'experiments/Forsaken/ThousandCuts.j').read_text()
            globals_=re.search(r'globals\n(.*?)endglobals',fragment,re.S)
            source=source.replace('endglobals',globals_[1]+'endglobals',1)
            helpers=fragment[globals_.end():].strip()
            source=source.replace('function Trig_Damage_Engine_FindTwoHandedItem takes',helpers+'\n\nfunction Trig_Damage_Engine_FindTwoHandedItem takes',1)
        else:
            if 'timer CutsClock=' not in source:source=source.replace('endglobals','    timer CutsClock=CreateTimer()\nendglobals',1)
            if 'boolean array CutsRipRequested' not in source:source=source.replace('endglobals','    boolean array CutsRipRequested\nendglobals',1)
            updated=functions((ROOT/'experiments/Forsaken/ThousandCuts.j').read_text())
            for name,body in updated.items():
                if name in functions(source):
                    source=put(source,name,body)
                else:
                    source=source.replace('function Cuts_Label takes',body+'\n\nfunction Cuts_Label takes',1)
        header=source.splitlines()[0]
        if 'TItemCooldown' not in header:source=source.replace(header,header+', TItemCooldown',1)
        name='Trig_Damage_Engine_Actions';body=functions(source)[name]
        hook='        if priestBasic and l_amount>0. then\n            call Cuts_OnHit(u,triggeringUnit)\n        endif'
        if 'call Cuts_OnHit(' not in body:
            anchor='        call BlzSetEventDamage(l_amount)'
            assert body.count(anchor)==1
            body=body.replace(anchor,anchor+'\n'+hook,1)
        source=put(source,name,body)
        name='RegisterTriggers_Damage';body=functions(source)[name]
        if 'call Cuts_Init()' not in body:body=body.replace('endfunction','    call Cuts_Init()\nendfunction')
        source=put(source,name,body)
    if 'Trig_Cooldown_Scaling_Conditions' in fs:
        name='Trig_Cooldown_Scaling_Conditions';body=functions(source)[name]
        if "GetSpellAbilityId()!='A0KY'" not in body:body=body.replace('\n    return','\n    return(GetSpellAbilityId()!=\'A0KY\')and',1)
        source=put(source,name,body)
    return source

def objects(main,skin):
    from damage_tooltips import merged
    resolved=merged(main,skin,'w3a');old=resolved['A0KY'];f=fields(old)
    new=copy.deepcopy(old);new['base']='ANcl'
    # Retain learned-rank identity and requirements; discard old Immolation data.
    for entry in new['sets']:
        entry['mods']=[m for m in entry['mods'] if not m['field'].startswith('Eim') and (not m['level'] or m['level']<=6)]
    for k,v in {'anam':'1000 Cuts','ansf':'[Thief - Ultimate]','alev':6,'aher':1,'ahky':'T','arhk':'T','abpx':1,'abpy':1,
        'arpx':1,'arpy':1,'aani':'spell','aart':ICON,
        'arar':ICON,'auar':'','aeat':'','acat':'','atat':'',
        'aret':'Learn 1000 Cuts (|cffffcc00T|r) - [|cffffcc00Level %d|r]',
        'arut':DESCRIPTION+'|n|nDrains 20 MP per second while active. Ripping costs 300 MP. Cooldown after ripping: 120 seconds.'}.items():setf(new,k,v)
    for rank in range(1,7):
        for k,v,data in [('Ncl1',0.,1),('Ncl2',0,2),('Ncl3',1,3),('Ncl4',0.,4),('Ncl5',0,5),('Ncl6','channel',6)]:setf(new,k,v,rank,data=data)
        for k,v in {'amcs':MANA[rank-1],'acdn':COOLDOWNS[rank-1],'aare':0.,'aran':0.,'acas':0.,'adur':0.,'ahdu':0.,'abuf':'',
            'atp1':'1000 Cuts (|cffffcc00T|r) - [|cffffcc00'+('MASTER' if rank==6 else 'Level '+str(rank))+'|r]',
            'aub1':tooltip(rank),'aut1':'','auu1':''}.items():setf(new,k,v,rank)
    table=read_objects(main,'w3a');table['custom']=[new if o['id']=='A0KY' else o for o in table['custom']]
    result=write_objects(table,table['version'],'w3a')
    if skin:
        table=read_objects(skin,'w3a');table['custom']=[o for o in table['custom'] if o['id']!='A0KY'];skin=write_objects(table,table['version'],'w3a')
    return result,skin

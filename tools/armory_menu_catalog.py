"""Create Armory category ability buttons so classic can update their tooltips."""
import argparse
from collections import defaultdict
from pathlib import Path
from mpq import MPQ, replace_files
from objdata import read_objects,write_objects,fields
from check_save_compat import assignments
from source_checks import sources
from talents_catalog import setf

ORDERS=('acidbomb','ancestralspirit','antimagicshell','avatar','banish','battleroar','berserk','blizzard',
        'blink','bloodlust','breathoffire','carrionswarm','chainlightning','charm','clusterrockets','coldarrows',
        'creepthunderbolt','cripple','cyclone','deathcoil','deathpact','dispel','divineshield','doom',
        'drunkenhaze','earthquake','ensnare','entanglingroots','fanofknives','farsight','fingerofdeath',
        'flamestrike','forkedlightning','frostarmor','frostnova','heal','healingwave','hex','holybolt','howlofterror')

def prepare(base,out):
    archive=MPQ(str(base))
    table=read_objects(archive.read('war3map.w3a'),'w3a')
    units={o['id']:fields(o) for o in read_objects(archive.read('war3map.w3u'),'w3u')['custom']}
    if archive.read('war3mapSkin.w3u'):
        for o in read_objects(archive.read('war3mapSkin.w3u'),'w3u')['custom']:
            units.setdefault(o['id'],{}).update(fields(o))
    _,texts=sources();ids,errors=assignments(texts,'udg_SaveFlagUnitID',repeated=True)
    if errors:raise ValueError(errors)
    members={int(i)-500:units[raw[-1]] for i,raw in ids.items() if 501<=int(i)<=540}
    siblings=defaultdict(list)
    for category,data in sorted(members.items()):siblings[data.get('upoi',0)].append(category)
    used={o['id'] for o in table['custom']}
    for category,data in members.items():
        raw='aR%02d'%category
        if raw in used:raise ValueError('category ability already exists: '+raw)
        peers=siblings[data.get('upoi',0)];position=peers.index(category)
        columns=4 if len(peers)>8 else 3
        obj=dict(base='ANcl',id=raw,sets=[dict(flag=0,mods=[])])
        for field,kind,value in [('anam',3,data.get('utip',data['unam'])),('aart',3,data['uico']),
                                 ('aher',0,0),('alev',0,1),('abpx',0,position%columns),('abpy',0,position//columns),('ahky',3,'')]:
            setf(obj,field,kind,value)
        for field,kind,value in [('atp1',3,data.get('utip',data['unam'])),('aub1',3,data.get('utub','Browse this category.')),
                                 ('amcs',0,0),('acdn',2,0.),('acas',2,0.),('adur',2,0.),('ahdu',2,0.)]:
            setf(obj,field,kind,value,1)
        for field,kind,value,n in [('Ncl1',2,0.,1),('Ncl2',0,0,2),('Ncl3',0,1,3),('Ncl4',2,0.,4),('Ncl5',0,0,5),('Ncl6',3,ORDERS[category-1],6)]:
            setf(obj,field,kind,value,1,n)
        table['custom'].append(obj)
    replace_files(str(base),str(out),{'war3map.w3a':write_objects(table,table['version'],'w3a')})
    return members

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('base',type=Path);ap.add_argument('out',type=Path)
    args=ap.parse_args();prepare(args.base,args.out);print('Created Armory category ability buttons.')

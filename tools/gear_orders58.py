"""Give triggered Channel item spells distinct orders; no runtime item mutation."""
import re
from pathlib import Path
from objdata import read_objects,write_objects
from priest_master import fields
from jtok import functions
from damage_tooltips import merged
ROOT=Path(__file__).resolve().parents[1]

# Valid order strings found in the installed game's *AbilityFunc.txt tables.
# Exclude any already used by an authored ability or script before allocation.
CANDIDATES='absorbmana bearform blackarrow burrow cannibalize chemicalrage cloudoffog controlmagic corporealform creepdevour creepsleep creepthunderclap darkconversion darkritual darksummoning defend demolish detonate devour eattree entangle evileye flare forceofnature freezingbreath healingspray healingward inferno lightningshield manashield metamorphosis monsoon parasite phaseshift polymorph possession purge robogoblin scout selfdestruct sentinel sphinxform spiritofvengeance spiritwolf stasistrap stoneform summonfactory summonphoenix summonquillbeast summonwareagle tornado transmute unstableconcoction unsummon voodoo wateryminion web whirlwind'.split()


def mapping(view,abilities):
    stock={}
    for p in (ROOT/'tools/build-inputs/native-ui').glob('*abilityfunc.txt'):
        current=None
        for line in p.read_text().splitlines():
            line=line.strip()
            if line.startswith('['):current=line[1:-1]
            elif line.lower().startswith('order='):stock[current]=line.split('=',1)[1]
    assert stock,'Read installed ability order definitions first.'
    used=set(re.findall(r'"([^"\n]*)"',view.runtime))
    referenced=set(re.findall(r"'(.{4})'",view.runtime))
    for kind in ('w3u','w3t'):
        objects=merged(view.object_bytes('war3map.'+kind),view.object_bytes('war3mapSkin.'+kind),kind)
        for obj in objects.values():
            for value in fields(obj).values():
                if isinstance(value,str):referenced.update(value.split(','))
    used.update(stock[raw] for raw in referenced if raw in stock)
    for raw,obj in abilities.items():
        used.add(stock.get(obj['base'],''))
        used.update(str(v) for (f,l),v in fields(obj).items() if f in ('Ncl6','Ans5','spb5'))
    casts=set(re.findall(r"SaveInteger\(QuickGearData,0,'.{4}','(.{4})'",functions(view.modules['TEquip'])['QuickGear_Init']))
    channels=sorted(k for k in casts if abilities[k]['base']=='ANcl')
    available=[s for s in CANDIDATES if s not in used]
    assert len(available)>=len(channels),(len(available),len(channels))
    return dict(zip(channels,available))


def refresh(data,orders):
    if not data:return data
    table=read_objects(data,'w3a')
    for obj in table['custom']+table['original']:
        raw=obj['id'] or obj['base']
        if raw not in orders:continue
        for group in obj['sets']:
            # Update every explicit rank to prevent a skin/rank overriding it.
            mods=group['mods'];found=False
            for mod in mods:
                if mod['field']=='Ncl6':mod['value']=orders[raw];found=True
            if not any(m['field']=='Ncl6' and m['level']==1 for m in mods):
                mods.append(dict(field='Ncl6',type=3,level=1,data=6,value=orders[raw],end=0))
    return write_objects(table,table['version'],'w3a')

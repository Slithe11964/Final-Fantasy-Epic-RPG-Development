"""V3: forward all accepted production h corrections onto the full V2 content."""
from build_forest86 import *
import build_central95 as package
from item_refresh_h02 import refresh as item_refresh
from backpack_b_h02 import refresh as backpack_refresh
from autosave_h02 import refresh as auto_refresh
from autosave_twenty import refresh as timing_refresh
from travel_h02 import refresh as travel_refresh
BASE=ROOT/'release/development/V2/FFERPG-V2.w3x'
OUT=ROOT/'release/development/V3/FFERPG-V3.w3x'
def refresh(s):return timing_refresh(auto_refresh(travel_refresh(backpack_refresh(item_refresh(s)))))
def objects(v):
 a=all_objects(v,'w3a')['aMEy'];assert a['base']=='Atru';setf(a,'abpx',0,0);setf(a,'abpy',-11,0)
 return {},{'aMEy':a},{}
if __name__=='__main__':
 package.BASE=BASE;package.OUT=OUT;package.LABEL='FFERPG V3';package.STATS={};package.ICONS={};package.objects95=objects;package.refresh95=refresh;package.build()
 p=OUT.with_suffix('.json');r=json.loads(p.read_text());r.update(production_forwardport='Accepted H02 UI, inspect, tooltip, teleporter and autosave changes; Maiden Eye hidden True Sight; first autosave20min then10min.',development_content='V2 jobs, Dragoon, Thief, spells, regions, creatures and imports preserved.',multiplayer='Not yet tested by owner.');p.write_text(json.dumps(r,indent=2))

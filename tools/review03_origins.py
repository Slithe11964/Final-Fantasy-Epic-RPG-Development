"""Derive area encounters from actual fixed/spawn/hunt positions."""
import re,json,math
from pathlib import Path
from jtok import functions
from build_creature_review import num
def distance(point,rect):
 x,y=point;a,b,c,d=rect
 return max(a-x,0.,x-c)**2+max(b-y,0.,y-d)**2
def origins(script):
 fs=functions(script);compact=lambda s:re.sub(r'[ \t]','',s)
 rects={m[1]:tuple(map(float,m.groups()[1:])) for m in re.finditer(r'set(gg_rct_\w+)=Rect\(([-\d.]+),([-\d.]+),([-\d.]+),([-\d.]+)\)',compact(fs['CreateRegions']))}
 areas={i:[] for i in range(1,10)}
 for m in re.finditer(r'SaveRectHandle\(udg_SpawnRectHash,\s*(\d+),[^,]+,\s*(gg_rct_\w+)\)',script):
  if int(m[1]) in areas and m[2] in rects:areas[int(m[1])].append(rects[m[2]])
 def locate(p):return min(areas,key=lambda a:min((distance(p,r) for r in areas[a]),default=1e30))
 evidence={};fixed={};hunts={}
 def add(raw,point,source,kind):evidence.setdefault(raw,[]).append(dict(area=locate(point),point=list(point),source=source,kind=kind,distance=math.sqrt(min(distance(point,r) for r in areas[locate(point)]))))
 for name,body in fs.items():
  if not name.startswith('CreateUnitsFor'):continue
  for line in compact(body).splitlines():
   m=re.search(r"set(gg_unit_(.{4})_\d+)=(?:BlzCreateUnitWithSkin|CreateUnit)\(p,'(.{4})',([^,]+),([^,]+),",line)
   if not m:continue
   try:point=(num(m[4]),num(m[5]))
   except ValueError:continue
   fixed[m[1]]=point
   if name=='CreateUnitsForPlayer11':add(m[3],point,name,'Fixed hostile placement')
 # Hunt board explicitly pairs a monster type with its world spawn rectangle.
 board=compact(fs['Trig_Hunt_Setup_Actions'])
 positions={}
 for m in re.finditer(r'SaveLocationHandleBJ\(GetRectCenter\((gg_rct_\w+)\),2,([^,]+),udg_HuntData\)',board):positions[int(num(m[2]))]=m[1]
 for m in re.finditer(r"SaveStringBJ\(UnitId2StringBJ\('(.{4})'\),3,([^,]+),udg_HuntData\)",board):
  idx=int(num(m[2]));rect=positions.get(idx)
  if rect in rects:
   a,b,c,d=rects[rect];point=((a+c)/2,(b+d)/2);hunts[m[1]]=dict(index=idx,area=locate(point),rect=rect,point=list(point));add(m[1],point,'Hunt board '+str(idx)+' / '+rect,'Rare hunt')
 # Resolve literal location variables and direct unit creations in world setups.
 for name,body in fs.items():
  if any(x in name for x in ['Arena','Review','CreateUnitsFor']):continue
  locations={};b=compact(body)
  for line in b.splitlines():
   for m in re.finditer(r'set(\w+)=GetRectCenter\((gg_rct_\w+)\)',line):
    if m[2] in rects:
     a,y,c,d=rects[m[2]];locations[m[1]]=((a+c)/2,(y+d)/2)
   for m in re.finditer(r'set(\w+)=GetUnitLoc\((gg_unit_\w+)\)',line):
    if m[2] in fixed:locations[m[1]]=fixed[m[2]]
   for m in re.finditer(r"(?:CreateNUnitsAtLoc|CreateNUnitsAtLocFacingLocBJ)\([^,]+,'(.{4})',Player\((?:\$B|11)\),([^,)]+)",line):
    if m[2] in locations:add(m[1],locations[m[2]],name,'Scripted world spawn')
   for m in re.finditer(r"(?:BlzCreateUnitWithSkin|CreateUnit)\(Player\((?:\$B|11)\),'(.{4})',([^,]+),([^,]+),",line):
    try:add(m[1],(num(m[2]),num(m[3])),name,'Scripted world spawn')
    except ValueError:pass
 # Owner-confirmed example; place Nilrem's authored Necromancer form by Forest.
 mapping={raw:min(refs,key=lambda e:(e['kind']!='Rare hunt',e['distance']))['area'] for raw,refs in evidence.items()}
 mapping['U006']=1
 evidence.setdefault('U006',[]).append(dict(area=1,source='Owner: Nilrem beside Guardia Forest',kind='Confirmed area boss',distance=0.,point=None))
 return mapping,hunts,evidence,rects,areas
if __name__=='__main__':
 import sys;sys.path.insert(0,str(Path(__file__).resolve().parent));from editor_pair import View
 v=View(Path('release/development/QuickUI90/FFERPG-QuickUI90.w3x'));mapping,hunts,evidence,*_=origins(v.runtime)
 Path('tools/tests/fixtures/historical-build/review03-origin-audit.json').write_text(json.dumps(dict(mapping=mapping,hunts=hunts,evidence=evidence),indent=2))
 print('Hunts',hunts);print('Mapped encounter types',len(mapping))

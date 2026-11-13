"""V6: solid rooted footprints, icy fire-breath and dark swarm, 3% lifesteal."""
from creatures_v5 import *
BASE=ROOT/'release/development/V5/FFERPG-V5.w3x'
OUT=ROOT/'release/development/V6/FFERPG-V6.w3x'
ASSETS=ROOT/'experiments/V6/Assets'

def objects(v):
 a=all_objects(v,'w3a');u=all_objects(v,'w3u');b=all_objects(v,'w3h')
 aa={r:copy.deepcopy(a[r]) for r in ['jBF2','kOB2','kVA2']};bb={'bVA2':copy.deepcopy(b['bVA2'])};uu={}
 mod(aa['jBF2'],'amat',r'war3mapImported\IcyFireBreathV6.mdx',0)
 mod(aa['kOB2'],'amat',r'war3mapImported\DarkSwarmBreathV6.mdx',0)
 text=fields(aa['kOB2'])['aub1',1].replace('Black flame uses the Breath of Fire shape.','A dark Carrion Swarm spreads across the breath cone.')
 mod(aa['kOB2'],'aub1',text,1)
 text=fields(aa['kVA2'])['aub1',1].replace('Physical damage restores 1%','Physical damage restores 3%');mod(aa['kVA2'],'aub1',text,1)
 f=fields(bb['bVA2']);setf(bb['bVA2'],'fube',f.get(('fube',None),f.get(('fube',0),'' )).replace('Physical lifesteal: 1%','Physical lifesteal: 3%'),None)
 o=copy.deepcopy(u['n03H']);text=fields(o)['utub',None].replace('Physical damage restores 1%','Physical damage restores 3%').replace('Black flame uses the Breath of Fire shape.','A dark Carrion Swarm spreads across the breath cone.');setf(o,'utub',text,None);uu['n03H']=o
 return uu,aa,bb

FX='''
function D6_ClearFootprint takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer i=600
 if F99Data==null then
 return
 endif
 loop
 exitwhen i>=604
 if HaveSavedHandle(F99Data,id,i) then
 call RemoveDestructable(LoadDestructableHandle(F99Data,id,i))
 call RemoveSavedHandle(F99Data,id,i)
 endif
 set i=i+1
 endloop
endfunction
function D6_RootFootprint takes unit u returns nothing
 local integer id=GetHandleId(u)
 local integer i=0
 local real x=GetUnitX(u)
 local real y=GetUnitY(u)
 local real dx
 local real dy
 local destructable block=null
 call D6_ClearFootprint(u)
 loop
 exitwhen i>=4
 set dx=-32.+64.*I2R(ModuloInteger(i,2))
 set dy=-32.+64.*I2R(i/2)
 // Four overlapping native ground blockers make a 192x192 solid footprint.
 // YTpc is nonrendered, nonselectable and does not block flying creatures.
 set block=CreateDestructable('YTpc',x+dx,y+dy,0.,1.,0)
 call SetDestructableInvulnerable(block,true)
 call SaveDestructableHandle(F99Data,id,600+i,block)
 set i=i+1
 endloop
 set block=null
endfunction
'''

def sort6(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_','C95_','R93_','C97_','N98_','F99_','D2_','I2_','M2_','D5_','D6_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
 if not helpers:return s
 names=set(helpers);deps={n:(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',re.sub(r'"(?:\\.|[^"\\])*"','""',b)))|set(re.findall(r'\bfunction\s+(\w+)',b)))&names-{n} for n,b in helpers.items()};ordered=[];todo=list(helpers)
 while todo:
  ready=[n for n in todo if not deps[n]-set(ordered)];assert ready,todo
  for n in ready:ordered.append(n);todo.remove(n)
 start=min(s.index(b) for b in helpers.values());prefix=s[:start];tail=s[start:]
 for b in helpers.values():tail=tail.replace(b,'',1)
 return prefix+'\n\n'.join(helpers[n] for n in ordered)+'\n'+tail

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='F99_Root':t=t.replace(' call D2_RootWeapons(u,true)',' call D6_RootFootprint(u)\n call D2_RootWeapons(u,true)',1)
  if n=='F99_RootEnd':t=t.replace(' if not HaveSavedReal(F99Data,id,10) then',' call D6_ClearFootprint(u)\n if not HaveSavedReal(F99Data,id,10) then',1)
  if n=='D2_Cleanup':t=t.replace(' if D2Data==null then',' call D6_ClearFootprint(u)\n if D2Data==null then',1)
  if n=='M2_Lifesteal':t=t.replace('GetWidgetLife(victim))*.01','GetWidgetLife(victim))*.03',1)
  if n=='F99_TickUnit':t=t.replace("GetUnitX(u)+100.,GetUnitY(u),60.)","GetUnitX(u)+160.,GetUnitY(u),60.)")
  if t!=b:s=put(s,n,t)
 if 'RegisterTriggers_MonsterData' in fs:s=s.replace('function RegisterTriggers_MonsterData takes',FX+'\nfunction RegisterTriggers_MonsterData takes',1)
 return sort6(s)

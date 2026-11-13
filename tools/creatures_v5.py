"""Creature-only root, breath and sustained-beam corrections on V4."""
from build_forest86 import *
BASE=ROOT/'release/development/V4/FFERPG-V4.w3x'
OUT=ROOT/'release/development/V5/FFERPG-V5.w3x'
ASSETS=ROOT/'experiments/V5/Assets'

def objects(v):
 u=all_objects(v,'w3u');a=all_objects(v,'w3a');b=all_objects(v,'w3h');outa={};outu={};outb={}
 for r in ['n00P','n00N','n00O']:
  o=copy.deepcopy(u[r])
  for k,val in [('ubdg',0),('umvt','foot'),('umvs',270),('ucol',96.),('upat','')]:setf(o,k,val,None)
  outu[r]=o
 for r in ['zIM9','jIS2','jIB2','jIM2','jBF2','kOB2','kLB2','kWB2','kFB2']:outa[r]=copy.deepcopy(a[r])
 mod(outa['zIM9'],'acdn',30.,1)
 mod(outa['zIM9'],'aub1',fields(outa['zIM9'])['aub1',1].replace('15-second cooldown','30-second cooldown'),1)
 for rank in range(1,65):mod(outa['jIS2'],'Isx1',-.1*rank,rank)
 for r in ['jIS2','jIB2','jIM2']:
  text=fields(outa[r]).get(('aub1',1),'').replace('20%','10%')
  if r=='jIB2':text='Channels a visible icy beam at one enemy for up to 10 seconds. Each second adds -10% attack speed. The caster must remain focused: stun, death, cancellation, or losing the target interrupts the beam and stops new stacks. Each applied stack lasts 30 seconds. 200 mana; 30-second cooldown.'
  mod(outa[r],'aub1',text,1)
 outb['bIB2']=copy.deepcopy(b['bIB2'])
 for k in ['fube','ftip']:
  f=fields(outb['bIB2']);old=f.get((k,None),f.get((k,0),''))
  if old:setf(outb['bIB2'],k,old.replace('20%','10%'),None)
 # Ucs3 is travel distance; Ucs4 is final radius. The old width truncated travel.
 for r in ['jBF2','kOB2','kLB2','kWB2','kFB2']:
  mod(outa[r],'Ucs3',800.,1);mod(outa[r],'Ucs4',300.,1);mod(outa[r],'aare',150.,1)
  model=r'Abilities\Spells\Undead\FreezingBreath\FreezingBreathMissile.mdl' if r=='jBF2' else (r'war3mapImported\OmniBreathV5.mdx' if r=='kOB2' else (r'war3mapImported\NoAuraV2.mdx' if r=='kLB2' else fields(a[r])['amat',0]))
  mod(outa[r],'amat',model,0);mod(outa[r],'amsp',1050,0)
  text=fields(outa[r])['aub1',1]
  if r=='jBF2':text+=' Breath of Fire-shaped cone: 800 travel distance; width expands from 150 to 300.'
  if r=='kLB2':text+=' Forked lightning traces the expanding breath cone.'
  if r=='kOB2':text+=' Black flame uses the Breath of Fire shape.'
  mod(outa[r],'aub1',text,1)
 for r,spell in [('qS99','zIM9'),('n02C','jBF2'),('n03H','kOB2'),('n03G','kLB2')]:
  o=copy.deepcopy(u[r]);text=fields(o).get(('utub',None),'')
  if r=='qS99':text+='|nImperil cooldown: 30 seconds.'
  elif r=='n02C':text=text.replace('20% attack-speed','10% attack-speed').replace('-20%','-10%')+'|nIce Beam: -10% attack speed each second while channeling, up to 10 seconds. Stacks last 30 seconds; interruption ends the beam. Frost Breath: 800-long expanding ice cone.'
  else:text+='|n'+fields(outa[spell])['aub1',1]
  setf(o,'utub',text,None);outu[r]=o
 return outu,outa,outb

FX=r'''
function D5_LightningEnd takes nothing returns nothing
 local timer t=GetExpiredTimer()
 local integer id=GetHandleId(t)
 local integer i=0
 loop
 exitwhen i>=3
 call DestroyLightning(LoadLightningHandle(F99Data,id,i))
 set i=i+1
 endloop
 call FlushChildHashtable(F99Data,id)
 call DestroyTimer(t)
 set t=null
endfunction
function D5_ForkBreath takes unit u returns nothing
 local real x=GetUnitX(u)
 local real y=GetUnitY(u)
 local real angle=Atan2(GetSpellTargetY()-y,GetSpellTargetX()-x)
 local real sideways
 local real tx
 local real ty
 local integer i=0
 local timer t=CreateTimer()
 local lightning beam
 loop
 exitwhen i>=3
 set sideways=I2R(i-1)*300.
 set tx=x+800.*Cos(angle)-sideways*Sin(angle)
 set ty=y+800.*Sin(angle)+sideways*Cos(angle)
 set beam=AddLightningEx("FORK",true,x,y,BlzGetUnitZ(u)+80.,tx,ty,BlzGetUnitZ(u)+80.)
 call SetLightningColor(beam,.55,.75,1.,1.)
 call SaveLightningHandle(F99Data,GetHandleId(t),i,beam)
 set i=i+1
 endloop
 call TimerStart(t,.4,false,function D5_LightningEnd)
 set beam=null
 set t=null
endfunction
function D5_BeamInterrupted takes nothing returns nothing
 if GetSpellAbilityId()=='jIB2' then
 call I2_BeamEnd(GetTriggerUnit())
 endif
endfunction
'''

def sort5(s):
 helpers={n:b for n,b in functions(s).items() if n.startswith(('Forest86_','B88_','M89_','H90_','C95_','R93_','C97_','N98_','F99_','D2_','I2_','M2_','D5_')) and not n.endswith(('UpdateSpawnTimer','BioMana'))}
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
  if n=='F99_Root':
   t=t.replace(" call UnitRemoveAbility(u,'Amov')"," call UnitAddType(u,UNIT_TYPE_STRUCTURE)\n call BlzSetUnitBooleanField(u,UNIT_BF_IS_A_BUILDING,true)\n call SetUnitPathing(u,true)\n call BlzUnitDisableAbility(u,'Amov',true,false)")
  if n=='F99_RootEnd':
   t=t.replace(" call UnitAddAbility(u,'Amov')"," call UnitRemoveType(u,UNIT_TYPE_STRUCTURE)\n call BlzSetUnitBooleanField(u,UNIT_BF_IS_A_BUILDING,false)\n call BlzSetUnitIntegerField(u,UNIT_IF_MOVE_TYPE,GetHandleId(MOVE_TYPE_FOOT))\n call SetUnitPathing(u,true)\n call UnitAddAbility(u,'Amov')\n call BlzUnitDisableAbility(u,'Amov',false,false)")
  if n in ['I2_AI','M2_AI']:t=t.replace('"breathoffrost"','"breathoffire"')
  if n=='I2_Spell':
   t=t.replace('AddLightningEx("CHIM"','AddLightningEx("DRAM"').replace('GetUnitY(caster),80.,GetUnitX(victim),GetUnitY(victim),60.)','GetUnitY(caster),BlzGetUnitZ(caster)+100.,GetUnitX(victim),GetUnitY(victim),BlzGetUnitZ(victim)+80.)')
  if n=='I2_BeamTick':
   t=t.replace('if not Forest86_Enemy(u,victim)',"if not Forest86_Alive(u) or IsUnitPaused(u) or GetUnitAbilityLevel(u,'BPSE')>0 or GetUnitAbilityLevel(u,'BSTN')>0 or not Forest86_Enemy(u,victim)",1)
   t=t.replace('GetUnitY(u),80.,GetUnitX(victim),GetUnitY(victim),60.)','GetUnitY(u),BlzGetUnitZ(u)+100.,GetUnitX(victim),GetUnitY(victim),BlzGetUnitZ(victim)+80.)')
  if n=='M2_Spell':t=t.replace(" if raw=='kDV2' then"," if raw=='kLB2' then\n call D5_ForkBreath(caster)\n elseif raw=='kDV2' then",1)
  if n=='Forest86_Init':
   t=t.replace(' local trigger spell=CreateTrigger()',' local trigger spell=CreateTrigger()\n local trigger beamEnd=CreateTrigger()',1)
   t=t.replace(' call TriggerRegisterPlayerUnitEvent(spell,Player(i),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)',' call TriggerRegisterPlayerUnitEvent(spell,Player(i),EVENT_PLAYER_UNIT_SPELL_EFFECT,null)\n call TriggerRegisterPlayerUnitEvent(beamEnd,Player(i),EVENT_PLAYER_UNIT_SPELL_ENDCAST,null)',1)
   t=t.replace(' call TriggerAddAction(spell,function Forest86_Spell)',' call TriggerAddAction(spell,function Forest86_Spell)\n call TriggerAddAction(beamEnd,function D5_BeamInterrupted)',1)
   t=t.replace(' set spell=null',' set spell=null\n set beamEnd=null',1)
  if t!=b:s=put(s,n,t)
 if 'RegisterTriggers_MonsterData' in fs:s=s.replace('function RegisterTriggers_MonsterData takes',FX+'\nfunction RegisterTriggers_MonsterData takes',1)
 return sort5(s)

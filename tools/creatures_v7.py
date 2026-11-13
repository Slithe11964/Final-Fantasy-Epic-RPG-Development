"""V7 creature polish, cancellable Ice Beam, stack badges and spell difficulty."""
from creatures_v6 import *
BASE=ROOT/'release/development/V6/FFERPG-V6.w3x'
OUT=ROOT/'release/development/V7/FFERPG-V7.w3x'
ASSETS=ROOT/'experiments/V7/Assets'
FACTOR_TEXT='|nSpell damage by difficulty: Simple x0.7; Easy x0.9; Normal x1.0; Hard x1.1; Inferno x1.2; Nightmare x1.4.'

def objects(v):
 a=all_objects(v,'w3a');u=all_objects(v,'w3u');outa={};outu={}
 for raw in ['jBF2','kOB2','jIB2']:outa[raw]=copy.deepcopy(a[raw])
 mod(outa['jBF2'],'amat',r'Abilities\Spells\Other\BreathOfFrost\BreathOfFrostMissile.mdl',0)
 mod(outa['kOB2'],'amat',r'war3mapImported\DarkSwarmBreathV7.mdx',0)
 mod(outa['jIB2'],'Ncl5',0,1)
 mod(outa['jIB2'],'aub1',fields(outa['jIB2'])['aub1',1]+' Move, Stop, or casting another ability cancels the channel normally.',1)
 outu['n02B']=copy.deepcopy(u['n02B'])
 for k in ['umpm','umpi']:setf(outu['n02B'],k,1900,None)
 setf(outu['n02B'],'utub',fields(outu['n02B'])['utub',None]+'|nBase mana: 1900 (before Devour bonuses).',None)
 # Cover the new NPC abilities referenced by the regional creature module.
 # Existing shared hero/item spells are deliberately outside this catalogue.
 olda=all_objects(View(ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h.w3x'),'w3a')
 refs=set(re.findall(r"'(.{4})'",v.modules['TMonsterData']))
 for raw in refs-set(olda):
  if raw not in a:continue
  o=outa.setdefault(raw,copy.deepcopy(a[raw]));text=fields(o).get(('aub1',1),'')
  if re.search(r'\bdamage\b',text,re.I) and not text.startswith('No damage') and FACTOR_TEXT not in text:mod(o,'aub1',text+FACTOR_TEXT,1)
 # Do not rewrite passives that have no damage value to scale.
 outa={r:o for r,o in outa.items() if o!=a[r]}
 for raw,unit in u.items():
  f=fields(unit);spells=f.get(('uabi',None),'').split(',');text=f.get(('utub',None),'');updated=text
  for r in spells:
   if r in outa:
    before=fields(a[r]).get(('aub1',1),'');after=fields(outa[r]).get(('aub1',1),'')
    if before and before in updated:updated=updated.replace(before,after)
  if updated!=text:
   o=outu.setdefault(raw,copy.deepcopy(unit));setf(o,'utub',updated,None)
 # Ensure the Queen's explicit mana note survives any tooltip replacement.
 text=fields(outu['n02B'])['utub',None]
 if 'Base mana: 1900' not in text:setf(outu['n02B'],'utub',text+'|nBase mana: 1900 (before Devour bonuses).',None)
 return outu,outa,{}

DIFFICULTY='''
function D7_SpellFactor takes nothing returns real
 if udg_Difficulty==1 then
 return .7
 elseif udg_Difficulty==2 then
 return .9
 elseif udg_Difficulty==4 then
 return 1.1
 elseif udg_Difficulty==5 then
 return 1.2
 elseif udg_Difficulty==6 then
 return 1.4
 endif
 return 1.
endfunction
function D7_RegionalSpell takes unit u returns boolean
 local integer raw=GetUnitTypeId(u)
 return not BlzGetEventIsAttack() and (Forest86_Actor(raw) or F99_SummonType(raw) or raw=='nsbm' or raw=='nspr')
endfunction
'''

def sort7(s):
 # Reuse the existing regional dependency ordering, extending its helper prefix.
 source=Path(__file__).with_name('creatures_v6.py').read_text();start=source.index('def sort6(');end=source.index('\ndef refresh(',start)
 ns=dict(globals());exec(source[start:end].replace("'D6_'))","'D6_','D7_'))"),ns);return ns['sort6'](s)

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='F99_RootEnd':t=t.replace('call SetUnitPathing(u,true)','call SetUnitPathing(u,not D7ReviewNoCollision)',1)
  if n=='I2_AddSlow':t=t.replace(" call M89_Dummy(caster,victim,'jIM2',\"curse\")"," if count==1 then\n call M89_Dummy(caster,victim,'jIM2',\"curse\")\n endif",1)
  if n=='I2_BeamEnd':
   t=t.replace(' local integer id=GetHandleId(u)',' local integer id=GetHandleId(u)\n local unit victim=LoadUnitHandle(I2Data,id,20)',1)
   t=t.replace(' call RemoveSavedReal(I2Data,id,21)',' call RemoveSavedReal(I2Data,id,21)\n call RemoveSavedReal(I2Data,id,22)\n if GetUnitTypeId(u)!=0 and Forest86_Alive(victim) and LoadInteger(I2Data,GetHandleId(victim),72)>0 then\n call M89_Dummy(u,victim,\'jIM2\',"curse")\n endif\n set victim=null',1)
  if n=='I2_BeamTick':
   t=t.replace(' call I2_AddSlow(u,victim)\n call SaveReal(I2Data,id,22,Forest86Now+1.)',' call SaveReal(I2Data,id,22,Forest86Now+1.)\n call I2_AddSlow(u,victim)',1)
   t=t.replace(' call MoveLightningEx(', ' if LoadUnitHandle(I2Data,id,20)==victim and HaveSavedHandle(I2Data,id,23) then\n call MoveLightningEx(',1)
   t=t.replace(' if Forest86Now>=LoadReal(I2Data,id,21) then',' endif\n if Forest86Now>=LoadReal(I2Data,id,21) then',1)
  if n=='Trig_Damage_Engine_Step14_Difficulty':
   old='            set l_amount=l_amount/ udg_DifficultyScale';assert old in t
   t=t.replace(old,'            if not l_heal and not DmgCtx_ManaDamage[c] and D7_RegionalSpell(u) then\n                set l_amount=l_amount*D7_SpellFactor()\n            else\n'+old+'\n            endif',1)
  if n=='Forest86_Init':t=t.replace(' set t=null',' call D7_BadgeInit()\n set t=null',1)
  if n=='Forest86_Tick':t=t.replace('endfunction',' call D7_BadgeDraw()\nendfunction',1)
  if t!=b:s=put(s,n,t)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/V7/StackBadges.j').read_text();g=re.search(r'globals\n(.*?)endglobals',fragment,re.S)
  s=s.replace('endglobals',g[1]+'endglobals',1).replace('function RegisterTriggers_MonsterData takes',DIFFICULTY+'\n'+fragment[g.end():].strip()+'\nfunction RegisterTriggers_MonsterData takes',1)
 return sort7(s)

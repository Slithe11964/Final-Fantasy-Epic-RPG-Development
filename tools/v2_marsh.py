"""Dark Dragon Marsh abilities, without changing shared hero spells."""
from build_forest86 import *
STATS={'n03H':(75,13000,77,None,None),'n03G':(72,12000,75,None,None),'n03J':(None,None,68,None,None),'n03I':(None,None,63,238,309),'n03E':(None,None,37,256,289),'n03F':(65,None,35,157,193)}
def objects(v):
 u=all_objects(v,'w3u');old=all_objects(v,'w3a');oldb=all_objects(v,'w3h');a={};b={}
 def add(raw,base,name,desc,icon,cd=0.,mana=0,area=0.,reach=800.,target='air,ground,enemy'):
  a[raw]=ability(raw,base,name,desc,icon,cd,mana,target,area,reach);return a[raw]
 def ch(raw,name,desc,icon,order,target,cd,mana,reach=800.):
  o=channel(raw,name,desc,icon,order,target,cd,mana,0.,reach);a[raw]=o;mod(o,'Ncl3',1,1)
  for k in ['acat','atat','aeat','asat']:mod(o,k,'war3mapImported\\NoAuraV2.mdx',0)
  return o
 def buff(raw,base,name,desc,icon,art):
  o={'base':base,'id':raw,'sets':[{'flag':0,'mods':[]}]}
  for k,val in [('fnam',name),('ftip',name),('fube',desc),('fart','ReplaceableTextures\\CommandButtons\\'+icon),('ftat',art),('fta0','origin')]:setf(o,k,val,0)
  b[raw]=o
 ch('kDV2','Devour Dark Dragon Creature','Consumes an injured friendly creature from the Dark Dragon Marsh pool. Absorbs its attack damage, maximum HP, maximum mana and armor, and heals by its remaining HP. No heroes, illusions or special quest creatures. Two uses maximum. 200 mana; 20-second cooldown.','BTNRedDragonDevour.blp','devour',1,20.,200,350.)
 mod(a['kDV2'],'atar','air,ground,friend,organic,mechanical,vulnerable',1)
 o=add('kVA2','AUav','Vampiric Aura','Allies within 800 gain physical and spell lifesteal.|n|n|cffffcc00Healing Calculation|r|nPhysical damage restores 1% of damage dealt. Magic/spell damage restores 5%. Uses damage up to the victim\'s remaining HP; does not trigger on healing, mana damage, allies or reflected pure damage.','BTNVampiricAura.blp',area=800.,target='air,ground,friend,self,vulnerable')
 for k,val in [('Uav1',0.),('abuf','bVA2')]:mod(o,k,val,1)
 buff('bVA2','BUav','Dark Dragon Vampirism','Physical lifesteal: 1%. Spell lifesteal: 5%.','BTNVampiricAura.blp',r'Abilities\Spells\Undead\VampiricAura\VampiricAuraTarget.mdl')
 for raw,name,damage,element,icon,mana,cd,model in [
 ('kOB2','Omni Breath',5000,7,'BTNDarkPortal.blp',1000,30.,r'Abilities\Weapons\ChimaeraAcidMissile\ChimaeraAcidMissile.mdl'),
 ('kLB2','Lightning Breath',4000,3,'BTNMonsoon.blp',200,10.,r'Abilities\Weapons\ChimaeraLightningMissile\ChimaeraLightningMissile.mdl'),
 ('kWB2','Wind Breath',4000,6,'BTNCyclone.blp',200,10.,r'Abilities\Spells\Other\Tornado\TornadoElementalSmall.mdl'),
 ('kFB2','Fire Breath',4000,1,'BTNFire.blp',200,10.,r'Abilities\Spells\Other\BreathOfFire\BreathOfFireMissile.mdl')]:
  o=add(raw,'ACbf',name,f'Breathes {name.split()[0].lower()} energy in an 800-unit cone.|n|n|cffffcc00Damage Calculation|r|n{damage} '+{7:'omni-elemental',3:'lightning',6:'wind',1:'fire'}[element]+f' damage to each enemy struck. No damage over time. Cone width expands from 150 to 300. {mana} mana; {int(cd)}-second cooldown.',icon,cd,mana,150.)
  for k,val in [('Ucs1',float(damage)),('Ucs2',99999.),('Ucs3',300.),('Nbf5',0.),('adur',0.),('ahdu',0.),('amat',model)]:mod(o,k,val,0 if k=='amat' else 1)
 ch('kES2','Elemental Shell','Protects one ally for 20 seconds. Reduces incoming elemental damage by an additional 25%, on top of existing resistances. Immunity and absorption remain intact. 100 mana; 30-second cooldown.','BTNOrbOfDarkness.blp','antimagicshell',1,30.,100)
 mod(a['kES2'],'atar','air,ground,friend,self,vulnerable',1)
 o=add('kEM2','Acrs','Elemental Shell','Additional 25% protection against elemental damage.','BTNOrbOfDarkness.blp',reach=99999.,target='air,ground,friend,self,enemy,organic,mechanical')
 setf(o,'Crs\0',0.,1,data=1)
 for k,val in [('abuf','bES2'),('adur',20.),('ahdu',20.)]:mod(o,k,val,1)
 buff('bES2','Bcrs','Elemental Shell','Takes 25% less elemental damage in addition to existing resistances.','BTNOrbOfDarkness.blp',r'Abilities\Spells\Undead\AntiMagicShell\AntiMagicShell.mdl')
 o=add('kOF2','AHtb','Omni Fireball','Launches an omni-elemental fireball.|n|n|cffffcc00Damage Calculation|r|n2000 omni-elemental damage on impact and a 3-second stun. 200 mana; 15-second cooldown.','BTNOrbOfFire.blp',15.,200)
 for k,val in [('Htb1',2000.),('adur',3.),('ahdu',3.),('amat',r'Abilities\Weapons\FireBallMissile\FireBallMissile.mdl')]:mod(o,k,val,0 if k=='amat' else 1)
 ch('kSC2','Sacrifice','When below 3000 HP, sacrifices itself in a burst of blood, healing other allies within 600 and granting normal kill experience to nearby heroes.|n|n|cffffcc00Healing Calculation|r|n5000 HP per living ally within 600. No mana cost. Can be used only once because the caster dies.','BTNDeathPact.blp','deathpact',0,0.,0)
 a['kPL2']=copy.deepcopy(old['zPL9']);a['kPL2']['id']='kPL2'
 for k,val in [('anam','Toxic Plague'),('atp1','Toxic Plague'),('aub1','Enemies within 300 take 500 damage per second and lose 40 accuracy. The accuracy penalty ends when Plague wears off.'),('Apl2',500.),('aare',300.),('abuf','bPL2'),('atar','air,ground,enemy,organic,mechanical,vulnerable')]:mod(a['kPL2'],k,val,0 if k=='anam' else 1)
 buff('bPL2','Bapl','Toxic Plague','Taking 500 damage per second; accuracy reduced by 40.','BTNPlagueCloud.blp',r'Abilities\Spells\Undead\PlagueCloud\PlagueCloudCaster.mdl')
 adds={'n03H':['kDV2','kVA2','kOB2','kES2','kOF2'],'n03G':['kLB2'],'n03J':['kSC2'],'n03I':['kPL2'],'n03E':['kWB2'],'n03F':['kFB2']}
 removes={'n03H':['A040'],'n03G':[],'n03J':['Acrs'],'n03I':['Aap3'],'n03E':['A11D'],'n03F':[]}
 for raw,(lv,hp,armor,low,high) in STATS.items():
  f=fields(u[raw]);ab=[x for x in f.get(('uabi',None),'').split(',') if len(x)==4 and x not in removes[raw]]
  for k,val in [('ulev',lv),('uhpm',hp),('udef',float(armor)),('ua1b',low-1 if low is not None else None),('ua1d',1 if low is not None else None),('ua1s',high-low+1 if low is not None else None),('uabi',','.join(dict.fromkeys(ab+adds[raw]))),('umpm',3000),('umpi',3000),('umpr',30.)]:
   if val is not None:setf(u[raw],k,val,None)
  desc=f'Normal mode. Armor: {armor}.'+(f' Level: {lv}.' if lv else '')+(f' HP: {hp}.' if hp else '')+(f' Attack: {low}-{high}.' if low else '')
  setf(u[raw],'utub',desc+'|n'+'|n'.join(fields(a[r]).get(('atp1',1),r)+': '+fields(a[r]).get(('aub1',1),'') for r in adds[raw]),None)
  if f.get(('udaa',None)) in removes[raw]:setf(u[raw],'udaa','',None)
 assert not set(a)&set(old),set(a)&set(old)
 return {r:u[r] for r in STATS},a,b

def refresh(s):
 fs=functions(s)
 for n,b in fs.items():
  t=b
  if n=='Forest86_Actor':t=t.replace(' return ',' return M2_Pool(raw) or ',1)
  if n=='Forest86_Spell':t=t.replace(' call I2_Spell(caster,victim,raw)',' call I2_Spell(caster,victim,raw)\n call M2_Spell(caster,victim,raw)',1)
  if n=='Forest86_AI':
   t=t.replace('or I2_Pool(raw) then','or I2_Pool(raw) or M2_Pool(raw) then',1)
   t=t.replace(' if I2_Pool(raw) then',' if M2_Pool(raw) then\n call M2_AI(u,victim)\n elseif I2_Pool(raw) then',1)
  if n=='Element_GetOfUnit':t=t.replace('    if(l_isPhysical)then',"    if not l_isPhysical then\n        if GetUnitTypeId(u)=='n03H' then\n            return 7\n        elseif GetUnitTypeId(u)=='n03G' then\n            return 3\n        elseif GetUnitTypeId(u)=='n03E' then\n            return 6\n        elseif GetUnitTypeId(u)=='n03F' then\n            return 1\n        endif\n    endif\n    if(l_isPhysical)then",1)
  if n in ['Trig_Damage_Engine_GetAccuracy','Forsaken_Stat_GetAccuracy','Stats_Stat_GetAccuracy']:
   pos=t.rfind('    return ')
   if pos>=0:t=t[:pos]+"    if GetUnitAbilityLevel(u,'bPL2')>0 then\n        set l_acc=l_acc-40.\n    endif\n"+t[pos:]
  if n=='Trig_Damage_Engine_Step08_Elements':t=t.replace('    // Rengeki Bonus',"    if not l_heal and not l_pure and l_element>0 and l_amount>0. and Forsaken_ElementAbilityLevel(t,'bES2')>0 then\n        set l_amount=l_amount*.75\n    endif\n    // Rengeki Bonus",1)
  if n=='Trig_Damage_Engine_Step18_FinalModifiers':t=t.replace('    set DmgCtx_Amount[c]=l_amount','    call M2_Lifesteal(u,t,l_amount,l_physical,l_magical,l_heal,l_manaDamage,l_pure)\n    set DmgCtx_Amount[c]=l_amount',1)
  if t!=b:s=put(s,n,t)
 if 'RegisterTriggers_MonsterData' in fs:
  fragment=(ROOT/'experiments/V2/Marsh.j').read_text()
  s=s.replace('function RegisterTriggers_MonsterData takes',fragment+'\nfunction RegisterTriggers_MonsterData takes',1)
 return s

"""Build isolated Dragoon arena using the working native map container."""
from pathlib import Path
import copy,sys,hashlib,json,struct,subprocess,math
sys.path.insert(0,str(Path(__file__).resolve().parent))
from mpq import MPQ,write_files,compact
from build_thief_daggers import ability,editor_files
from build_thief_daggers_template import patch_objects,arena_terrain
from damage_tooltips import merged
from priest_master import setf,fields
from objdata import read_objects,write_objects
from downgrade import wts_read,wts_write
from jtok import functions
from add_header import read_header,build_header
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI30/FFERPG-QuickUI30-Forsaken.w3x'
OUT=ROOT/'release/development/Dragoon10/FFERPG-Dragoon-10.w3x'
NAME='Dragoon - Selected Kit 10'
def build():
 assert not OUT.exists()
 base=MPQ(str(BASE));fs=functions(base.read('war3map.j').decode())
 script=(ROOT/'experiments/Dragoon/Dragoon.j').read_text()
 script=script.replace(functions(script)['config'],fs['config'])
 for name in ['InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities']:
  script=script.replace('function config takes',fs[name]+'\n\nfunction config takes',1)
 units=merged(base.read('war3map.w3u'),base.read('war3mapSkin.w3u'),'w3u')
 hero=copy.deepcopy(units['H00C']);dummy=copy.deepcopy(units['u01M'])
 for k,v in dict(uabi='pSTh,pDrB,pRoD,pJmp,pSum',uhab='',upgr='',uhpm=5000,umpm=2000,ustr=100,uagi=100,uint=100,uacq=0.,ua1r=100.,ua1w='normal',ua1m='',ucs1='MetalMediumSlice',unam='Dragoon',upro='Dragoon',umvs=350,umdl='Units\\Human\\CityGuard\\CityGuard.mdl').items():setf(hero,k,v,rank=None)
 for k,v in dict(uabi='',upgr='',uhpm=100000,uhpr=0.,udef=0.,udty='normal',uaen=0,uacq=0.,umvt='foot',umvs=1,unam='Training target').items():setf(dummy,k,v,rank=None)
 icon='ReplaceableTextures\\CommandButtons\\'
 specs=[('pSTh','Sonic Thrust','Q',0,2,'channel',1,'BTNValiantCharge.blp','Charge to melee range and stab; the impact reaches 150 units beyond the target. Each enemy is damaged once. Only the selected target gains a stacking flat -10 evasion debuff.'),('pDrB','Drakesbane','W',1,2,'shockwave',2,'BTNSweepingStrike.blp','90-degree cone. Adds max(0, accuracy - current evasion) damage. One 50% proc roll per cast that hits.'),('pRoD','Rise of the Dragon','R',3,2,'flamestrike',2,'BTNDragonRoost.blp','Requires and consumes Life of the Dragon. 300 radius, 1.5s stun. Adds accuracy minus evasion; 50% bonus below 30% HP.'),('pJmp','Jump','E',2,2,'blizzard',2,'BTNBoots.blp','Jump and landing damage. Ordinary ability. 15-second cooldown.'),('pSum','Summon Dragon','D',0,1,'roar',0,'BTNRedDragon.blp','Summon a prototype dragon companion. RPG summon progression remains for integration.')]
 abilities=[]
 for raw,name,key,x,y,order,target,art,tip in specs:
  o=ability(raw,name,key,x,y,order,target,icon+art,tip)
  setf(o,'aran',900.,rank=1);setf(o,'Ncl3',19 if raw=='pRoD' else 1,rank=1,data=3)
  if raw=='pSTh':setf(o,'aani','walk')
  if raw=='pJmp':setf(o,'aani','stand ready')
  if raw=='pRoD':
   setf(o,'aare',300.,rank=1);setf(o,'aran',800.,rank=1)
  abilities.append(o)
 # Native AHsw supplies the campaign cone cursor; zero its own combat to avoid double hits.
 sweep=next(o for o in abilities if o['id']=='pDrB')
 sweep['base']='AHsw'
 for entry in sweep['sets']:
  entry['mods'][:]=[m for m in entry['mods'] if not m['field'].startswith('Ncl') and m['field']!='aare']
 for key,value in [('aani','spell,slam'),('acat',''),('atat',''),('aefs','')]:setf(sweep,key,value)
 for field,value,data_index in [('swp1',0.,1),('swp2',450.,0),('swp3',90.,2),('swp4',.1,3),('swp5',0,4),('swp6',0.,5),('swp7',0,6),('swp8',0.,7),('swp9',0,8),('swpa',0.,9),('swpb',0.,10),('swpe',0.,11),('swpf',0.,12),('swpg',0.,13),('swph',0.,14)]:setf(sweep,field,value,rank=1,data=data_index)
 for field,value in [('aran',99999.),('abuf',''),('swpc',0.),('swpd',0.)]:setf(sweep,field,value,rank=1)
 for raw,reach,delay in [('pDr2',450.,.1),('pDr3',450.,.1)]:
  o=copy.deepcopy(sweep);o['id']=raw;setf(o,'swp2',reach,rank=1);setf(o,'aran',99999.,rank=1);setf(o,'swp4',delay,rank=1,data=3);abilities.append(o)
 rise=next(o for o in abilities if o['id']=='pRoD')
 for raw,radius in [('pRo2',300.),('pRo3',300.)]:
  o=copy.deepcopy(rise);o['id']=raw;setf(o,'aare',radius,rank=1);abilities.append(o)
 cd=15.
 files={'war3map.j':script.replace('\n','\r\n').encode(),'war3map.w3u':patch_objects(base,'war3map.w3u','w3u',[hero,dummy]),'war3map.w3a':patch_objects(base,'war3map.w3a','w3a',abilities)}
 for ext,ids in [('w3u',{'H00C','u01M'}),('w3a',{o['id'] for o in abilities})]:
  name='war3mapSkin.'+ext;t=read_objects(base.read(name),ext);t['custom']=[o for o in t['custom'] if o['id'] not in ids];files[name]=write_objects(t,t['version'],ext)
 strings=wts_read(base.read('war3map.wts'));strings[38788]=NAME;strings[38790]='Q thrust, W sweep, E Jump, R Rise, D dragon. -help, -variant 1/2/3, -reset.';files['war3map.wts']=wts_write(strings)
 files['war3map.w3e']=arena_terrain(base.read('war3map.w3e'))
 p=base.read('war3map.wpm');files['war3map.wpm']=p[:16]+bytes(len(p)-16)
 files['war3map.shd']=bytes(len(base.read('war3map.shd')))
 files['war3map.doo']=base.read('war3map.doo')[:12]+struct.pack('<iii',0,0,0)
 files['war3mapUnits.doo']=base.read('war3mapUnits.doo')[:12]+struct.pack('<i',0)
 # Small transparent ground rune used to trace exact cone/circle boundaries.
 pixels=bytearray()
 for y in range(64):
  for x in range(64):
   dx=x-31.5;dy=y-31.5;r=math.hypot(dx,dy)
   ink=(21<r<25) or (abs(dx)<1.5 and abs(dy)<29) or (abs(dy)<1.5 and abs(dx)<29) or (abs(abs(dx)+abs(dy)-17)<1.8)
   pixels.extend((255,220,75,240 if ink else 0))
 files['DragoonRune.tga']=struct.pack('<BBBHHBHHHHBB',0,0,2,0,0,0,0,0,64,64,32,8)+pixels
 files['DragoonStab.ogg']=(ROOT/'experiments/Dragoon/StabImpact.ogg').read_bytes()
 files['DragoonCharge.ogg']=(ROOT/'experiments/Dragoon/ValiantCharge.ogg').read_bytes()
 files.update(editor_files(script))
 OUT.parent.mkdir(parents=True,exist_ok=True)
 runtime=OUT.parent/'runtime.j';runtime.write_text(script)
 result=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(runtime)],capture_output=True,text=True)
 print(result.stdout,result.stderr);assert result.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT));tmp.unlink()
 _,flags,players=read_header(str(BASE));raw=OUT.read_bytes();OUT.write_bytes(build_header(NAME,flags,players)+raw[raw.index(b'MPQ\x1a'):])
 check=MPQ(str(OUT))
 for name,data in files.items():assert check.read(name)==data,name
 for name in ['war3map.w3i','war3mapMap.blp','war3mapPreview.tga','war3map.imp']:assert check.read(name)==base.read(name),name
 report=dict(output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),base=str(BASE),jump_cooldown=cd,sonic_evasion_per_stack=10,sonic_extension=150,sweep_indicator='90-degree ground rune cone, 450 reach; unit-body edge overlap',rise_indicator='single native 300-radius rune while aiming; custom image removed',sonic_indicator='Q centre line only through target +150',variant_mode='selected variant-1 effects; old variant commands alias selected kit',jump_status='approved trajectory/timing/damage/landing retained; owner-requested airborne facing and action lock added',sweep_visual='restored campaign SweepingStrike.mdl at original 1.0 scale; campaign target hits retained',sonic_hit='20-unit whole-unit primary-target push; foot-movement test targets; stab sound retained',rise_ready='native autocast-style icon sprite; visible only with unexpired Life and ready cooldown',rise_status='owner locked; only cast range changed to 800',rise_cast_range=800,auto_attack_sound='MetalMediumSlice',sonic_stop='90 units before target; only stab impact extends behind',sonic_effects='nonfire cast burst plus campaign ValiantCharge audio; paused action lock and instantaneous target facing',jump_motion='continuous horizontal interpolation and height arc',compile='PASS',archive_readback='PASS',gameplay='pending',scope='isolated native prototype; simulated accuracy/evasion; simplified Jump and dragon companion')
 (OUT.parent/'checks.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
if __name__=='__main__':build()

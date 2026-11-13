"""QuickUI83: repair Zodiac native damage field and expose Poison Spear calculation."""
from pathlib import Path
import re,json,hashlib,subprocess
from editor_pair import View,runtime_for
from jtok import functions,tokens
from performance_runtime import put
from order_libraries import order
from wct import text_of,raw_of,write_wct
from objdata import read_objects,write_objects
from priest_master import fields,setf
from damage_tooltips import merged
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from mpq import MPQ,write_files,compact
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI82/FFERPG-QuickUI82.w3x'
OUT=ROOT/'release/development/QuickUI83/FFERPG-QuickUI83.w3x'
POISON='|n|n|cffffcc00Poison Damage Calculation|r|nBase poison damage per second: 5 + 3 x attacker level, for 10 seconds (before damage modifiers and defenses). At level 99: 302 damage per second.'
PASSIVE='Attacks poison enemies. Base poison damage per second: 5 + 3 x attacker level, for 10 seconds (before damage modifiers and defenses). At level 99: 302 damage per second.'
def clean(s):return re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',s)
def refresh(s):
 fs=functions(s)
 if 'DG_Deal' in fs:
  b=fs['DG_Deal']
  assert 'set udg_IsPhysicalAttack=technique' in b
  b=b.replace('set udg_IsPhysicalAttack=technique','set udg_IsPhysicalAttack=technique or kind==3').replace(' if technique then',' if technique or kind==3 then')
  s=put(s,'DG_Deal',b)
 for n,b in fs.items():
  if "SaveStr(SpellCalcData,'A14D'" in b:
   lines=[line.replace('Fire damage:','Physical Fire damage:') if "SaveStr(SpellCalcData,'A14D'" in line else line for line in b.splitlines()]
   s=put(s,n,'\n'.join(lines))
 if 'Forsaken_RenderGearDamage' in fs:
  n='Forsaken_RenderGearDamage';b=fs[n];anchor='    if Forsaken_StatGun(hero) then';assert b.count(anchor)==1
  b=b.replace(anchor,'''    if Forsaken_StatAbilityLevel(hero,'A0PH')>0 then
        call Forsaken_StatRow(row,"Attacks poison enemies",I2S(5+3*GetUnitLevel(hero))+" DPS")
        set row=row+1
    endif
'''+anchor,1)
  s=put(s,n,b)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);w=wts_read(v.archive.read('war3map.wts'));files={};updated=[]
 def resolve(s):return w.get(int(s[8:]),s) if isinstance(s,str) and s.startswith('TRIGSTR_') else s
 items=merged(v.archive.read('war3map.w3t'),v.archive.read('war3mapSkin.w3t'),'w3t');base_tip=resolve(fields(items['I00M'])['utub',None])+POISON
 for ext in ['w3a','w3t','w3u']:
  for prefix in ['war3map','war3mapSkin']:
   name=prefix+'.'+ext;d=v.archive.read(name)
   if not d:continue
   t=read_objects(d,ext)
   for o in t['custom']+t['original']:
    raw=o['id'] or o['base'];f=fields(o)
    if ext=='w3a':
     if raw=='A1CP':setf(o,'Iatt',800,1,data=1)
     if raw in ['A0PH','A0PG']:setf(o,'aub1',PASSIVE,1)
     if raw=='A14D':
      for st in o['sets']:
       for m in st['mods']:
        if isinstance(m['value'],str):m['value']=m['value'].replace('Fire damage:','Physical Fire damage:')
    if ext=='w3t' and clean(resolve(f.get(('unam',None),'')))=='Zodiac Spear':setf(o,'ides',resolve(f['utub',None]),None)
    if ext in ['w3t','w3u'] and clean(resolve(f.get(('unam',None),'')))=='Poison Spear':
     setf(o,'utub',base_tip,None)
     if ext=='w3t':setf(o,'ides',base_tip,None)
     updated.append((name,raw))
   data=write_objects(t,t['version'],ext)
   if data!=d:files[name]=data
 assert len(updated)>=5,updated
 modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]};assert changed=={'TEquip','TDamage','TRegen'},changed
 runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 label='FFERPG QuickUI83 (Dragoon)';w[38788]=label
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True);print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 tmp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 m=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert m.read(name)==files.get(name,v.archive.read(name)),name
 before,after=functions(v.runtime),functions(runtime)
 OUT.with_suffix('.json').write_text(json.dumps(dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),poison_tooltips=updated,notes='A1CP Iatt800 corrected data index0->1; native AItx fallback20 explains report. Poison persecond5+3*level,10s from original attack/proxy/ANab1sectick; mechanics untouched. All Poison item/armory/passive tooltipcopies and damagepanel. Physicaldamage affects auto/spells(Sonic/Drakes/Jump). OwneraddedRisephysical+Firescaling: DG_Deal routeskind3throughphysicalattackclassification whileexplicitFireelement1persists; magicalbonusesexcluded. Tooltipsmatch. No timers/input/inventory changes; Dragoon test only.'),indent=2));print(OUT)
if __name__=='__main__':build()

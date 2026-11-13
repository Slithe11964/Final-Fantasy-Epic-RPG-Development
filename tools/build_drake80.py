"""QuickUI80: spear proficiency scales Dragon Ally attack damage."""
from pathlib import Path
import re,json,hashlib,subprocess
from editor_pair import View,runtime_for
from jtok import functions,tokens
from performance_runtime import put
from order_libraries import order
from wct import text_of,raw_of,write_wct
from objdata import read_objects,write_objects
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from mpq import MPQ,write_files,compact
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/development/QuickUI79/FFERPG-QuickUI79.w3x'
OUT=ROOT/'release/development/QuickUI80/FFERPG-QuickUI80.w3x'
HELPER='''function Dragoon80_ScaleDrake takes unit caster,unit drake returns nothing
 local real multiplier=1.+.1*I2R(Prof_GetLevel(caster,'R009'))
 call BlzSetUnitBaseDamage(drake,R2I(I2R(BlzGetUnitBaseDamage(drake,0))*multiplier),0)
 call BlzSetUnitBaseDamage(drake,R2I(I2R(BlzGetUnitBaseDamage(drake,1))*multiplier),1)
endfunction
'''
OLD="Uses the summoned dragon's attack damage and the original ranked Dragon Ally scaling."
NEW="Summoned dragon base attack damage x (1 + 0.1 x Spear Proficiency). Shared summon bonuses also apply. Spear Proficiency is taken from the caster when summoned."
def refresh(s):
 s=s.replace('Spear Technique','Spear Proficiency').replace(OLD,NEW)
 fs=functions(s)
 if 'Trig_Lancer_DragonAlly_Actions' in fs:
  n='Trig_Lancer_DragonAlly_Actions';b=fs[n];anchor='    call ConditionalTriggerExecute(gg_trg_Summon_Powerup)'
  assert b.count(anchor)==1
  b=b.replace(anchor,anchor+'\n    call Dragoon80_ScaleDrake(GetTriggerUnit(),GetLastCreatedUnit())')
  s=put(s,n,b);s=s.replace('function '+n+' takes',HELPER+'\nfunction '+n+' takes',1)
 return s

def build():
 assert not OUT.exists()
 v=View(BASE);modules={lib:refresh(s) for lib,s in v.modules.items()};changed={lib for lib in modules if modules[lib]!=v.modules[lib]}
 assert changed=={'TLancer','TRegen'},changed
 runtime,_=order(runtime_for(v,v,v,modules));runtime=re.sub(r'\n{3,}','\n\n',runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 files={}
 for name in ['war3map.w3a','war3mapSkin.w3a']:
  d=v.archive.read(name)
  if not d:continue
  t=read_objects(d,'w3a')
  for o in t['custom']+t['original']:
   for st in o['sets']:
    for mod in st['mods']:
     if isinstance(mod['value'],str):mod['value']=mod['value'].replace('Spear Technique','Spear Proficiency').replace(OLD,NEW)
  files[name]=write_objects(t,t['version'],'w3a')
 w=wts_read(v.archive.read('war3map.wts'));label='FFERPG QuickUI80 (Dragoon)';w[38788]=label
 for k,s in list(w.items()):w[k]=s.replace('Spear Technique','Spear Proficiency')
 files.update({'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct),'war3map.wts':wts_write(w)})
 OUT.parent.mkdir(parents=True,exist_ok=True);OUT.with_suffix('.j').write_text(runtime)
 r=subprocess.run([str(ROOT/'tools/bin/pjass.exe'),str(ROOT/'tools/build-inputs/bag-quick-future-common.j'),str(ROOT/'tools/bin/blizzard.j'),str(OUT.with_suffix('.j'))],capture_output=True,text=True)
 print(r.stdout[-1500:],r.stderr);assert r.returncode==0
 temp=OUT.with_suffix('.unpacked.w3x');write_files(str(BASE),str(temp),files);compact(str(temp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 m=MPQ(str(OUT))
 for name in v.archive.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert m.read(name)==files.get(name,v.archive.read(name)),name
 before,after=functions(v.runtime),functions(runtime)
 report=dict(base=str(BASE),output=str(OUT),sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_modules=sorted(changed),changed_functions=sorted(n for n in before if n in after and tokens(before[n])!=tokens(after[n])),new_functions=sorted(after.keys()-before.keys()),notes='Drake base attack damage, both attack slots, multiplied by 1+0.1*caster Spear Proficiency once after shared summon bonuses. Health/armor/abilities/lifetime unchanged. Terminology updated. No inventory/UI/input/timer changes. Normal release/classic/master unchanged.')
 OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(OUT)
if __name__=='__main__':build()

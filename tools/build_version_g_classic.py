"""Production g for 1.29.2: stable classic base, house7%, labels and minus parity."""
import re,json,hashlib
from pathlib import Path
from mpq import MPQ,write_files,compact
from wct import read_wct,write_wct,text_of,raw_of
from downgrade import wts_read,wts_write
from add_header import read_header,build_header
from jtok import functions,tokens
from performance_runtime import put
from build_version_g_house import house7
from house79 import units
from objdata import read_objects
from priest_master import fields
ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-1.29.2.w3x'
OUT=ROOT/'release/0.9.7.5g/FFERPG-0.9.7.5g-1.29.2.w3x'
LABEL='FFERPG 0.9.7.5g 1.29.2'

def refresh(s):
 s=s.replace('0.9.7.5f','0.9.7.5g').replace('All your base stats increase by 10! Additionally, you may now enter New Game Minus mode!','All your base stats increase by 10!')
 fs=functions(s)
 n='Trig_Title_UnlockEffects_Actions'
 if n in fs:
  b,count=re.subn(r'(    if\(Trig_Title_UnlockEffects_IsTitle_LucifersGeneral\(\)\)then\n).*?(        return\n    endif)',r'\1\2',fs[n],flags=re.S);assert count==1
  s=put(s,n,b)
 n='Save_CondNewGameMinus'
 if n in fs:s=put(s,n,'function Save_CondNewGameMinus takes nothing returns boolean\n    return false\nendfunction')
 return s

def main():
 assert not OUT.exists(),'Preserve earlier releases.'
 m=MPQ(str(BASE));old=m.read('war3map.j').decode().replace('\r\n','\n');runtime=refresh(old)
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(refresh(text_of(wct['header']).replace('\r\n','\n')))
 for i,e in enumerate(wct['entries']):
  s=text_of(e).replace('\r\n','\n');updated=refresh(s)
  if s!=updated:wct['entries'][i]=raw_of(updated.replace('\n','\r\n'))
 w={k:v.replace('0.9.7.5f','0.9.7.5g').replace('|n- Unlocked New Game Minus.','') for k,v in wts_read(m.read('war3map.wts')).items()};w[38788]=LABEL
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(w),'war3map.w3a':house7(m.read('war3map.w3a')),'war3map.w3u':units(m.read('war3map.w3u'))}
 info=m.read('war3map.w3i');updated=info.replace(b'0.9.7.5f',b'0.9.7.5g')
 if info!=updated:files['war3map.w3i']=updated
 OUT.parent.mkdir(parents=True,exist_ok=True);tmp=OUT.with_suffix('.unpacked.w3x');assert not tmp.exists()
 write_files(str(BASE),str(tmp),files);compact(str(tmp),str(OUT))
 _,flags,players=read_header(str(BASE));d=OUT.read_bytes();OUT.write_bytes(build_header(LABEL,flags,players)+d[d.index(b'MPQ\x1a'):])
 packed=MPQ(str(OUT))
 for name in m.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert packed.read(name)==files.get(name,m.read(name)),name
 a,b=functions(old),functions(runtime)
 changed={n for n in a if tokens(a[n])!=tokens(b[n])}
 assert changed=={'Trig_Title_UnlockEffects_Actions','Trig_Titles_Init_Actions','Save_CondNewGameMinus','Trig_Intro_WelcomeMessages_Actions'},changed
 for n in a:
  if n.startswith(('Save_','Load_','Trig_Cmd_Load_Code_')) and n!='Save_CondNewGameMinus':assert tokens(a[n])==tokens(b[n]),n
 assert 'EnableTrigger(udg_NewGameMinusTrig)' not in runtime
 for ext,allowed in [('w3a',set()),('w3u',{'h006','h00N'})]:
  def table(data):
   t=read_objects(data,ext);return {o['id'] or o['base']:o for o in t['original']+t['custom']}
  before,after=table(m.read('war3map.'+ext)),table(packed.read('war3map.'+ext))
  assert set(after)-set(before)==({'hH79','hM79'} if ext=='w3a' else set())
  for raw in before:
   if raw not in allowed:assert before[raw]==after[raw],raw
  if ext=='w3a':
   for raw,k in [('hH79','Oar1'),('hM79','Arm1')]:assert abs(fields(after[raw])[k,1]-.07)<1e-7
 OUT.with_suffix('.j').write_text(runtime)
 report=dict(base=str(BASE),output=str(OUT),version='0.9.7.5g',profile='1.29.2',date='2026-11-04',sha256=hashlib.sha256(OUT.read_bytes()).hexdigest(),changed_resources=sorted(files),changed_functions=sorted(changed),archive_readback='PASS',save_format='unchanged; original Plus eligibility and reset writer retained',house='7% maximum health and mana per second; both houses;350range;original fountains unchanged',minus='disabled; obsolete unlock notices removed; stat rewards retained',modern_ui='Not transplanted: 1.29.2 uses its original inventory, without modern F/G/frame/extended-gear natives.',runtime_acceptance='Native 1.29.2 and multiplayer acceptance pending.')
 OUT.with_suffix('.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))

if __name__=='__main__':main()

"""Two-function UI-transition comparison, preserving Recovery12 gameplay/UI."""
from build_f1030_inventory_rollback import *
def build(base,out,label):
 assert not out.exists();v=view(str(base));source=v.modules['TCine'];fs=functions(source);rt=v.runtime
 for n,on in [('Cine_Enter','false'),('Cine_Exit','true')]:
  old='ShowInterface('+on+',bj_CINEMODE_INTERFACEFADE)';assert old in fs[n]
  b=fs[n].replace(old,'ShowInterface('+on+',0.)',1);source=put(source,n,b);rt=put(rt,n,b)
 for i,raw in enumerate(v.wct['entries']):
  if re.match(r'\s*library TCine\b',text_of(raw)):v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
 files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(rt)
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 result=MPQ(str(out))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert result.read(n)==files.get(n,v.archive.read(n)),n
 before,after=functions(v.runtime),functions(rt);assert {n for n in before if tokens(before[n])!=tokens(after[n])}=={'Cine_Enter','Cine_Exit'}
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=['Cine_Enter','Cine_Exit'],difference='Only ShowInterface fade duration .5 -> 0; cinematic text/cameras/waits, F/G renderer, inventory, profiles and gameplay unchanged.',status='DIAGNOSTIC CANDIDATE, not confirmed fix; native bag cross-close unresolved'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/V23/FFERPG-V23.w3x',ROOT/'release/development/V24/FFERPG-V24.w3x','FFERPG V24 - UI transition test')
 build(ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x',ROOT/'release/development/GRecovery13/FFERPG-0.9.7.5g-Recovery13.w3x','FFERPG 0.9.7.5g Recovery13 - UI transition test')

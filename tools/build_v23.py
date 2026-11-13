"""Reject Recovery11: patch Recovery10/V21, preserving native renderer."""
from build_f1030_inventory_rollback import *
from cinematic_v23 import refresh

def build(base,out,label,classic=False):
 assert not out.exists()
 v=view(str(base));modules={lib:refresh(lib,s,classic) for lib,s in v.modules.items()}
 changed=[lib for lib in modules if modules[lib]!=v.modules[lib]]
 runtime=v.runtime;new=[]
 for lib in changed:
  old,newfs=functions(v.modules[lib]),functions(modules[lib])
  for n,b in newfs.items():
   if n not in old:
    if lib=='TEquip':runtime=runtime.replace('function C20_HideUI takes',b+'\nfunction C20_HideUI takes',1)
    else:new.append(b)
   elif tokens(old[n])!=tokens(b):runtime=put(runtime,n,b)
  dg=decls(modules[lib]);og=decls(v.modules[lib]);add=[dg[n] for n in dg if n not in og]
  if add:runtime=runtime.replace('endglobals','\n'.join(add)+'\nendglobals',1)
 runtime=runtime+'\n'+'\n'.join(new)+'\n';runtime,_=order(runtime)
 for i,raw in enumerate(v.wct['entries']):
  m=re.match(r'\s*library (\w+)',text_of(raw))
  if m and m[1] in changed:v.wct['entries'][i]=raw_of(modules[m[1]].replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(runtime)
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 result=MPQ(str(out))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert result.read(n)==files.get(n,v.archive.read(n)),n
 rb=functions(v.runtime);ra=functions(runtime)
 assert set(rb)<=set(ra)
 if not classic:
  for n in ['QuickGear_Init','QuickGear_DrawWheel','QuickGear_PaintIcon','Forsaken_BackpackVisible','Forsaken_PollPanels','Forsaken_CloseBackpack','Forsaken_RequestBackpackToggle']:
   assert tokens(rb[n])==tokens(ra[n]),n
  assert 'Bag22' not in runtime
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_modules=changed,changed_functions=[n for n in rb if tokens(rb[n])!=tokens(ra[n])],added_functions=list(set(ra)-set(rb)),changed_resources=list(files),scope='Recovery10 native renderer/panes preserved. Common cinematic suspension and explicit player-only input gates.',live_test='pending; native cross-player bag closure not proven fixed'),indent=2))
 print(out)

if __name__=='__main__':
 build(ROOT/'release/development/V21/FFERPG-V21.w3x',ROOT/'release/development/V23/FFERPG-V23.w3x','FFERPG V23')
 build(ROOT/'release/development/GRecovery10/FFERPG-0.9.7.5g-Recovery10.w3x',ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x','FFERPG 0.9.7.5g Recovery12')
 build(ROOT/'release/development/GRecovery09/FFERPG-0.9.7.5g-1.29.2-Recovery09.w3x',ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-1.29.2-Recovery12.w3x','FFERPG 0.9.7.5g Recovery12 1.29.2',True)

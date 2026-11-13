"""Only two display functions change; no object or inventory gameplay edits."""
from build_f1030_inventory_rollback import *
from panel_v21 import refresh

def build(base,out,label):
 assert not out.exists()
 v=view(str(base));before=functions(v.modules['TEquip']);source=refresh(v.modules['TEquip']);after=functions(source)
 names=[n for n in before if tokens(before[n])!=tokens(after[n])]
 assert set(names)=={'Forsaken_BackpackVisible','Forsaken_PollPanels'}
 runtime=v.runtime
 for n in names:runtime=put(runtime,n,after[n])
 for i,raw in enumerate(v.wct['entries']):
  if re.match(r'\s*library TEquip\b',text_of(raw)):v.wct['entries'][i]=raw_of(source.replace('\n','\r\n'))
 files={'war3map.j':runtime.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 out.parent.mkdir(parents=True,exist_ok=True)
 out.with_suffix('.j').write_text(runtime)
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header(label,flags,players)+data[data.index(b'MPQ\x1a'):])
 result=MPQ(str(out))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert result.read(n)==files.get(n,v.archive.read(n)),n
 rb=functions(v.runtime);ra=functions(runtime)
 assert set(rb)==set(ra)
 assert {n for n in rb if tokens(rb[n])!=tokens(ra[n])}==set(names)
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=names,changed_resources=list(files),scope='Only live native-panel display observation and fallback anchor. No new frames, lookups, timers, gameplay writes or save changes.',live_test='pending'),indent=2))
 print(out)

if __name__=='__main__':
 build(ROOT/'release/development/V20/FFERPG-V20.w3x',ROOT/'release/development/V21/FFERPG-V21.w3x','FFERPG V21')
 build(ROOT/'release/development/GRecovery09/FFERPG-0.9.7.5g-Recovery09.w3x',ROOT/'release/development/GRecovery10/FFERPG-0.9.7.5g-Recovery10.w3x','FFERPG 0.9.7.5g Recovery10')

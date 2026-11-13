"""Promote the production Maiden Eye fix to h; labels only, both engines."""
from build_forest86 import *
from wct import read_wct

DIR=ROOT/'release/0.9.7.5h'
def rename(text):return text.replace('0.9.7.5g','0.9.7.5h')
def build(classic=False):
 suffix='-1.29.2' if classic else ''
 base=ROOT/'release/0.9.7.5g'/('FFERPG-0.9.7.5g'+suffix+'.w3x');out=DIR/('FFERPG-0.9.7.5h'+suffix+'.w3x');assert not out.exists()
 m=MPQ(str(base));script=m.read('war3map.j').decode();updated=rename(script)
 wct=read_wct(m.read('war3map.wct'));wct['header']=raw_of(rename(text_of(wct['header'])))
 wct['entries']=[raw_of(rename(text_of(raw))) if '0.9.7.5g' in text_of(raw) else raw for raw in wct['entries']]
 strings=wts_read(m.read('war3map.wts'));strings={k:rename(v) for k,v in strings.items()}
 files={'war3map.j':updated.encode(),'war3map.wct':write_wct(wct),'war3map.wts':wts_write(strings)}
 DIR.mkdir(parents=True,exist_ok=True);tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 _,flags,players=read_header(str(base));data=out.read_bytes();out.write_bytes(build_header('FFERPG 0.9.7.5h'+(' 1.29.2' if classic else ''),flags,players)+data[data.index(b'MPQ\x1a'):])
 new=MPQ(str(out))
 for file in m.read('(listfile)').decode().splitlines():
  if file.lower() not in ['(listfile)','(attributes)','(signature)']:assert new.read(file)==files.get(file,m.read(file)),file
 oldfunc,newfunc=functions(script),functions(updated);assert oldfunc.keys()==newfunc.keys()
 changed=[]
 for n,b in oldfunc.items():
  assert newfunc[n]==rename(b),n
  if newfunc[n]!=b:changed.append(n)
 assert new.read('war3map.w3a')==m.read('war3map.w3a')
 out.with_suffix('.j').write_bytes(updated.encode())
 report=dict(base=str(base),output=str(out),version='0.9.7.5h',sha256=hashlib.sha256(out.read_bytes()).hexdigest(),promotion='Current production g with Maiden Eye hidden True Sight; version labels only.',changed_functions=changed,gameplay='unchanged',save_format='unchanged',archive_readback='PASS',native_test='pending')
 out.with_suffix('.json').write_text(json.dumps(report,indent=2));print(out)
if __name__=='__main__':build();build(True)

"""Build V6 with solid rooted footprints and native breath-model variants."""
from creatures_v6 import *
import build_central95 as package
import struct

def main():
 package.BASE=BASE;package.OUT=OUT;package.LABEL='FFERPG V6';package.STATS={};package.ICONS={};package.objects95=objects;package.refresh95=refresh
 write=package.write_files
 assets={'war3mapImported\\'+p.name:p.read_bytes() for p in ASSETS.iterdir() if p.suffix in ['.mdx','.tga']}
 assert len(assets)==9
 def add_assets(src,dest,files):
  files.update(assets);imp=MPQ(str(src)).read('war3map.imp');version,count=struct.unpack_from('<II',imp)
  for name in assets:assert name.encode()+b'\0' not in imp
  files['war3map.imp']=struct.pack('<II',version,count+len(assets))+imp[8:]+b''.join(bytes([13])+name.encode()+b'\0' for name in assets)
  return write(src,dest,files)
 package.write_files=add_assets;package.build()
 m=MPQ(str(OUT))
 for n,d in assets.items():assert m.read(n)==d,n
 p=OUT.with_suffix('.json');data=json.loads(p.read_text());data.update(assets=list(assets),new_polling_timers=0,rooted_collision='Four invulnerable nonrendered YTpc ground blockers per rooted ancient; cleanup on uproot, death, devour/removal.',live_verification='Native pathing and visual acceptance pending; no multiplayer claim.');p.write_text(json.dumps(data,indent=2))
if __name__=='__main__':main()

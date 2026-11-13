"""Build the next full creature test, preserving production and V4."""
from creatures_v5 import *
import build_central95 as package
import struct

def main():
 package.BASE=BASE;package.OUT=OUT;package.LABEL='FFERPG V5';package.STATS={};package.ICONS={};package.objects95=objects;package.refresh95=refresh
 write=package.write_files
 assets={'war3mapImported\\'+p.name:p.read_bytes() for p in ASSETS.iterdir() if p.suffix in ['.mdx','.tga']}
 assert len(assets)==3
 def add_assets(src,dest,files):
  files.update(assets);imp=MPQ(str(src)).read('war3map.imp');version,count=struct.unpack_from('<II',imp)
  for name in assets:assert name.encode()+b'\0' not in imp
  files['war3map.imp']=struct.pack('<II',version,count+len(assets))+imp[8:]+b''.join(bytes([13])+name.encode()+b'\0' for name in assets)
  return write(src,dest,files)
 package.write_files=add_assets;package.build()
 m=MPQ(str(OUT))
 for n,d in assets.items():assert m.read(n)==d,n
 p=OUT.with_suffix('.json');data=json.loads(p.read_text());data.update(assets=list(assets),new_polling_timers=0,beam_cleanup='Shared endcast event plus existing 1Hz heartbeat; fork effect uses one 0.4s cleanup timer per cast.',live_verification='Movement, collision, native breath areas, effects and multiplayer require in-game testing.');p.write_text(json.dumps(data,indent=2))
if __name__=='__main__':main()

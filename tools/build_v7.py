"""Package the next full development test without replacing production."""
from creatures_v7 import *
import build_central95 as package
import struct

def model():
 ASSETS.mkdir(parents=True,exist_ok=True)
 data=View(BASE).archive.read(r'war3mapImported\DarkSwarmBreathV6.mdx');out=bytearray(data[:4]);i=4;removed=0
 while i<len(data):
  n=struct.unpack_from('<I',data,i+4)[0]
  if data[i:i+4]!=b'RIBB':out+=data[i:i+8+n]
  else:removed+=1
  i+=8+n
 assert i==len(data) and removed==1
 (ASSETS/'DarkSwarmBreathV7.mdx').write_bytes(out)

def main():
 model();package.BASE=BASE;package.OUT=OUT;package.LABEL='FFERPG V7';package.STATS={};package.ICONS={};package.objects95=objects;package.refresh95=refresh
 write=package.write_files;assets={r'war3mapImported\DarkSwarmBreathV7.mdx':(ASSETS/'DarkSwarmBreathV7.mdx').read_bytes()}
 def add_assets(src,dest,files):
  files.update(assets);imp=MPQ(str(src)).read('war3map.imp');version,count=struct.unpack_from('<II',imp)
  files['war3map.imp']=struct.pack('<II',version,count+1)+imp[8:]+bytes([13])+next(iter(assets)).encode()+b'\0'
  return write(src,dest,files)
 package.write_files=add_assets;package.build()
if __name__=='__main__':main()

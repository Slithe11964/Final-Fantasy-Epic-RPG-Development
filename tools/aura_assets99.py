"""Create native aura variants with baked texture colors; runtime tint cannot recolor blue pixels."""
from pathlib import Path
import struct,io
from PIL import Image
from local_casc import LocalCasc
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'experiments/Ancient99/Assets'
def main():
 OUT.mkdir(parents=True,exist_ok=True);c=LocalCasc()
 try:
  for source,name,rgb in [('Brilliance','AbyssalPurple',(190,55,255)),('Endurance','EvasiveGreen',(55,255,115))]:
   d=bytearray((ROOT/f'tools/build-inputs/ancient99-assets/{source}.mdx').read_bytes());i=4
   while i<len(d):
    tag=d[i:i+4];n=struct.unpack_from('<I',d,i+4)[0];start=i+8
    if tag==b'TEXS':
     for pos in range(start,start+n,268):
      path=bytes(d[pos+4:pos+264]).split(b'\0')[0].decode();raw=c.read('war3.w3mod:'+path) or c.read('war3.w3mod:'+path[:-4]+'.dds');assert raw,path
      image=Image.open(io.BytesIO(raw)).convert('RGBA');colored=Image.new('RGBA',image.size)
      colored.putdata([tuple(round(max(r,g,b)*v/255) for v in rgb)+(a,) for r,g,b,a in image.getdata()]);colored.save(OUT/(name+'.tga'))
      dest=('war3mapImported\\'+name+'.tga').encode();d[pos+4:pos+264]=dest+b'\0'*(260-len(dest))
    if tag==b'GEOA':
     pos=start
     while pos<start+n:
      size=struct.unpack_from('<I',d,pos)[0];assert size>=28
      struct.pack_into('<3f',d,pos+12,1.,1.,1.);pos+=size
     assert pos==start+n
    i+=8+n
   assert i==len(d);(OUT/(name+'.mdx')).write_bytes(d)
 finally:c.close()
if __name__=='__main__':main()


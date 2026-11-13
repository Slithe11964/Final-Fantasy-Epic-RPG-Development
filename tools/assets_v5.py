"""Recolor the native fire-breath mesh and particle textures as dark flame."""
from pathlib import Path
import struct,io
from PIL import Image
from local_casc import LocalCasc
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'experiments/V5/Assets'

def build():
 OUT.mkdir(parents=True,exist_ok=True);c=LocalCasc()
 try:
  source=c.read(r'war3.w3mod:Abilities\Spells\Other\BreathOfFire\BreathOfFireMissile.mdx')
  assert source and source[:4]==b'MDLX'
  assert c.read(r'war3.w3mod:Abilities\Spells\Undead\FreezingBreath\FreezingBreathMissile.mdx')
  out=bytearray(source[:4]);i=4;texture=0
  while i<len(source):
   tag=source[i:i+4];size=struct.unpack_from('<I',source,i+4)[0];d=bytearray(source[i+8:i+8+size])
   if tag==b'TEXS':
    for p in range(0,len(d),268):
     path=bytes(d[p+4:p+264]).split(b'\0')[0].decode();raw=c.read('war3.w3mod:'+path) or c.read('war3.w3mod:'+path[:-4]+'.dds');assert raw,path
     image=Image.open(io.BytesIO(raw)).convert('RGBA');colored=Image.new('RGBA',image.size)
     # Alpha blending preserves a charcoal silhouette; additive black would disappear.
     colored.putdata([(18,12,26,round(max(r,g,b)*a/255)) for r,g,b,a in image.getdata()])
     name='OmniBreathV5-'+str(texture)+'.tga';colored.save(OUT/name);dest=('war3mapImported\\'+name).encode();d[p+4:p+264]=dest+b'\0'*(260-len(dest));texture+=1
   if tag==b'MTLS':
    p=0
    while p<len(d):
     msize=struct.unpack_from('<I',d,p)[0];assert d[p+12:p+16]==b'LAYS';count=struct.unpack_from('<I',d,p+16)[0];lp=p+20
     for _ in range(count):
      lsize=struct.unpack_from('<I',d,lp)[0];struct.pack_into('<I',d,lp+4,2);lp+=lsize
     p+=msize
   if tag==b'PRE2':
    p=0
    while p<len(d):
     esize,node=struct.unpack_from('<II',d,p);static=p+4+node
     struct.pack_into('<I',d,static+32,0)
     # Segment colors start after 8 floats, four integers and two floats.
     struct.pack_into('<9f',d,static+56,*([1.,1.,1.]*3));p+=esize
   if tag!=b'LITE':out+=tag+struct.pack('<I',len(d))+d
   i+=8+size
  assert i==len(source)
  (OUT/'OmniBreathV5.mdx').write_bytes(out)
 finally:c.close()
 return OUT

if __name__=='__main__':print(build())

"""Native fire-breath recolored icy; visible dark Carrion Swarm for Omni Breath."""
from pathlib import Path
import struct,io
from PIL import Image
from local_casc import LocalCasc
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'experiments/V6/Assets'

def neutral_track(d,tag):
 start=0
 while True:
  p=d.find(tag,start)
  if p<0:return
  count,mode,_=struct.unpack_from('<III',d,p+4);assert mode<=3 and count<10000
  stride=16+(24 if mode>1 else 0);q=p+16
  for _ in range(count):
   struct.pack_into('<3f',d,q+4,1.,1.,1.)
   if mode>1:struct.pack_into('<6f',d,q+16,*([1.]*6))
   q+=stride
  start=q

def variant(c,path,name,icy):
 source=c.read('war3.w3mod:'+path);assert source and source[:4]==b'MDLX'
 out=bytearray(source[:4]);i=4;texture=0
 while i<len(source):
  tag=source[i:i+4];size=struct.unpack_from('<I',source,i+4)[0];d=bytearray(source[i+8:i+8+size])
  if tag==b'TEXS':
   for p in range(0,len(d),268):
    texture_path=bytes(d[p+4:p+264]).split(b'\0')[0].decode();raw=c.read('war3.w3mod:'+texture_path) or c.read('war3.w3mod:'+texture_path[:-4]+'.dds');assert raw,texture_path
    image=Image.open(io.BytesIO(raw)).convert('RGBA');colored=Image.new('RGBA',image.size);pixels=[]
    for r,g,b,a in image.getdata():
     lum=max(r,g,b)
     if icy:pixels.append((round(lum*.28),round(lum*.78),lum,a))
     else:pixels.append((round(36+lum*.22),round(32+lum*.20),round(45+lum*.25),round(a*min(1.,lum/72.))))
    colored.putdata(pixels);file=name+'-'+str(texture)+'.tga';colored.save(OUT/file)
    dest=('war3mapImported\\'+file).encode();d[p+4:p+264]=dest+b'\0'*(260-len(dest));texture+=1
  if tag==b'MTLS' and not icy:
   p=0
   while p<len(d):
    msize=struct.unpack_from('<I',d,p)[0];assert d[p+12:p+16]==b'LAYS';count=struct.unpack_from('<I',d,p+16)[0];lp=p+20
    for _ in range(count):
     lsize=struct.unpack_from('<I',d,lp)[0];struct.pack_into('<I',d,lp+4,2);lp+=lsize
    p+=msize
  if tag==b'GEOA':
   p=0
   while p<len(d):
    n=struct.unpack_from('<I',d,p)[0];assert n>=28;struct.pack_into('<3f',d,p+12,1.,1.,1.);p+=n
   neutral_track(d,b'KGAC')
  if tag==b'PRE2':
   p=0
   while p<len(d):
    esize,node=struct.unpack_from('<II',d,p);static=p+4+node
    if not icy:struct.pack_into('<I',d,static+32,0)
    struct.pack_into('<9f',d,static+56,*([1.,1.,1.]*3));p+=esize
  if tag==b'RIBB':
   p=0
   while p<len(d):
    n,node=struct.unpack_from('<II',d,p);static=p+4+node;struct.pack_into('<3f',d,static+12,1.,1.,1.);p+=n
   neutral_track(d,b'KRCO')
  if tag!=b'LITE':out+=tag+struct.pack('<I',len(d))+d
  i+=8+size
 assert i==len(source)
 (OUT/(name+'.mdx')).write_bytes(out)
 return texture

def build():
 OUT.mkdir(parents=True,exist_ok=True);c=LocalCasc()
 try:
  assert variant(c,r'Abilities\Spells\Other\BreathOfFire\BreathOfFireMissile.mdx','IcyFireBreathV6',True)==2
  assert variant(c,r'Abilities\Spells\Undead\CarrionSwarm\CarrionSwarmMissile.mdx','DarkSwarmBreathV6',False)==5
 finally:c.close()
 return OUT
if __name__=='__main__':print(build())

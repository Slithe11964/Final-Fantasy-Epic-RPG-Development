"""Remove Carrion Swarm's skinned creature mesh; retain its wave geometry."""
import struct
NONE=0xffffffff

def chunks(data):
 assert data[:4]==b'MDLX';i=4
 while i<len(data):
  n=struct.unpack_from('<I',data,i+4)[0];assert i+8+n<=len(data);yield data[i:i+4],data[i+8:i+8+n];i+=8+n
 assert i==len(data)

def records(data):
 p=0
 while p<len(data):
  n=struct.unpack_from('<I',data,p)[0];assert n>=4 and p+n<=len(data);yield data[p:p+n];p+=n
 assert p==len(data)

def strip_creature(data):
 source=dict(chunks(data));assert b'PRE2' not in source and b'RIBB' not in source
 geos=list(records(source[b'GEOS']));assert len(geos)==3
 # The first mesh has 520 skinned vertices and uses the creature-skin material3.
 geo=geos[0];assert geo[4:8]==b'VRTX' and struct.unpack_from('<I',geo,8)[0]==520
 a=geo.index(b'MATS');count=struct.unpack_from('<I',geo,a+4)[0];assert struct.unpack_from('<I',geo,a+8+4*count)[0]==3
 replacements={b'GEOS':b''.join(geos[1:])}
 animations=list(records(source[b'GEOA']));amap={};out=[]
 for old,record in enumerate(animations):
  gid=struct.unpack_from('<I',record,24)[0]
  if gid==0:continue
  assert 0<gid<3
  amap[old]=len(out);r=bytearray(record);struct.pack_into('<I',r,24,gid-1);out.append(r)
 replacements[b'GEOA']=b''.join(out)
 bones=bytearray(source[b'BONE']);p=0
 while p<len(bones):
  n=struct.unpack_from('<I',bones,p)[0];assert n>=96 and p+n+8<=len(bones)
  gid,aid=struct.unpack_from('<II',bones,p+n)
  struct.pack_into('<II',bones,p+n,NONE if gid in [0,NONE] else gid-1,amap.get(aid,NONE))
  p+=n+8
 assert p==len(bones)
 replacements[b'BONE']=bytes(bones)
 result=bytearray(b'MDLX')
 for tag,payload in chunks(data):
  payload=replacements.get(tag,payload);result+=tag+struct.pack('<I',len(payload))+payload
 return bytes(result)

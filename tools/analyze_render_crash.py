"""Read-only minidump instruction/RTTI evidence; no client patching/debug hooks."""
from pathlib import Path
import sys,struct,re,json,hashlib,collections
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools/build-inputs/crash-analysis-deps'))
import capstone,pefile
REPORT=Path('C:/Users/jaked/Documents/Warcraft III/Errors/2026-11-09 13.26.32 913ccee4')
OUT=ROOT/'release/development/RenderInvestigation20261109'
def analyze():
 text=(REPORT/'Crash.txt').read_text(errors='replace');d=(REPORT/'War3.dmp').read_bytes()
 u32=lambda o:struct.unpack_from('<I',d,o)[0]
 u64=lambda o:struct.unpack_from('<Q',d,o)[0]
 assert d[:4]==b'MDMP'
 streams={}
 for i in range(u32(8)):
  t,size,rva=struct.unpack_from('<III',d,u32(12)+i*12);streams[t]=(size,rva)
 assert struct.unpack_from('<H',d,streams[7][1])[0]==9 # AMD64
 r=streams[5][1];ranges=[struct.unpack_from('<QII',d,r+4+i*16) for i in range(u32(r))]
 def read(a,n):
  for start,size,off in ranges:
   if start<=a and a+n<=start+size:return d[off+a-start:off+a-start+n]
  return b''
 ex=streams[6][1];ctx=u32(ex+164)
 registers={n:u64(ctx+o) for n,o in [('rax',120),('rcx',128),('rdx',136),('rbx',144),('rsp',152),('rdi',176),('r12',216),('rip',248)]}
 match=re.search(r'DBG-MODULE<([0-9A-F]+)\s+[0-9a-f]+ "Warcraft III.exe".*? ([0-9]+)>',text,re.I)
 assert match
 base=int(match[1],16)
 exe=Path('C:/Program Files (x86)/Warcraft III/_retail_/x86_64/Warcraft III.exe')
 pe=pefile.PE(str(exe),fast_load=True);assert pe.FILE_HEADER.TimeDateStamp==int(match[2])
 original=pe.OPTIONAL_HEADER.ImageBase;cache={}
 def typename(vt):
  if vt in cache:return cache[vt]
  cache[vt]=None
  if not base+0x22eb000<vt<base+0x2f26000:return None
  try:
   col=struct.unpack('<Q',pe.get_data(vt-base-8,8))[0]-original;raw=pe.get_data(col,24)
   if struct.unpack_from('<I',raw)[0]!=1:return None
   type_rva=struct.unpack_from('<I',raw,12)[0]
   name=pe.get_data(type_rva+16,180).split(b'\0')[0].decode()
   if name.startswith('.?AV'):cache[vt]=name
  except (ValueError,struct.error,UnicodeDecodeError,pefile.PEFormatError):pass
  return cache[vt]
 typed={}
 for name,addr in registers.items():
  raw=read(addr,8)
  if raw:
   t=typename(struct.unpack('<Q',raw)[0])
   if t:typed[name]=t
 stack_objects=[]
 for off in range(0,128,8):
  raw=read(registers['rsp']+off,8)
  if not raw:continue
  ptr=struct.unpack('<Q',raw)[0];obj=read(ptr,8)
  if obj:
   t=typename(struct.unpack('<Q',obj)[0])
   if t:stack_objects.append(dict(stack_offset=hex(off),object_address=hex(ptr),type=t))
 classes=collections.Counter()
 for start,size,off in ranges:
  for j in range(0,size-8,8):
   t=typename(struct.unpack_from('<Q',d,off+j)[0])
   if t:classes[t]+=1
 md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_64)
 instructions=[dict(address=hex(i.address),rva=hex(i.address-base),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(read(registers['rip'],48),registers['rip'])]
 report=dict(report=str(REPORT),dump_sha256=hashlib.sha256(d).hexdigest(),exception=hex(u32(ex+8)),engine_base=hex(base),engine_timestamp=pe.FILE_HEADER.TimeDateStamp,map='FFERPG-0.9.7.5g-Recovery12.w3x',players=7,registers={n:hex(v) for n,v in registers.items()},typed_registers=typed,stack_object_types=stack_objects,captured_object_classes=classes.most_common(30),fault_instructions_from_dump_memory=instructions,interpretation='Fault while clearing a simple-frame render batch; invalid pointer in RDI. This locates the failure in native rendering, not the first corrupting operation. It does not identify a particular frame/model or prove the F/G dock is responsible.')
 assert typed['r12']=='.?AVCRenderBatch@@' and classes['.?AVCSimpleTop@@']>0
 OUT.mkdir(parents=True,exist_ok=True);(OUT/'render-dump-analysis.json').write_text(json.dumps(report,indent=2))
 print(json.dumps({k:report[k] for k in ['exception','typed_registers','fault_instructions_from_dump_memory','interpretation']},indent=2))
if __name__=='__main__':analyze()

"""Asset-only Omni corrections in full development and creature review."""
from build_forest86 import *
from omni_wave_v13 import strip_creature
KEY=r'war3mapImported\DarkSwarmBreathV7.mdx'

def build(base,out,label):
 assert not out.exists()
 m=MPQ(str(base));old=m.read(KEY);new=strip_creature(old);assert old!=new
 out.parent.mkdir(parents=True,exist_ok=True);tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),{KEY:new});compact(str(tmp),str(out));_,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 final=MPQ(str(out))
 for name in m.read('(listfile)').decode().splitlines():
  if name.lower() not in ['(listfile)','(attributes)','(signature)']:assert final.read(name)==(new if name.lower()==KEY.lower() else m.read(name)),name
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_resources=[KEY],script_changes=0,removed='520-vertex creature mesh/material3; its geoset animation removed and remaining bone/geoset-animation IDs remapped.',retained='Both smoke/wave geosets and their materials, textures, node transforms, model sequences and event data.',acceptance='Native visual confirmation pending. All scripts/objects and all other resources unchanged.'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/V12/FFERPG-V12.w3x',ROOT/'release/development/V13/FFERPG-V13.w3x','FFERPG V13')
 build(ROOT/'release/development/CreatureReview03m/FFERPG-Creature-Review-03m.w3x',ROOT/'release/development/CreatureReview03n/FFERPG-Creature-Review-03n.w3x','FFERPG Creature Review03n')

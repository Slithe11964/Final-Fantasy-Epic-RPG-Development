"""Keep normal cinematic timing; compare F/G frontend only."""
from build_f1030_inventory_rollback import *
from gear_frontend25 import refresh
def build(base,out,label,absent=False):
 assert not out.exists();v=view(str(base));src=refresh(v.modules['TEquip'],absent)
 old,new=functions(v.modules['TEquip']),functions(src);names=[n for n in old if tokens(old[n])!=tokens(new[n])]
 assert set(names)==({'QuickGear_Init','QuickGear_Reset','QuickGear_Poll','QuickGear_Request'} if absent else {'QuickGear_Init','QuickGear_Reset','QuickGear_RepaintIcons'})
 rt=v.runtime
 for n in names:rt=put(rt,n,new[n])
 for i,raw in enumerate(v.wct['entries']):
  if re.match(r'\s*library TEquip\b',text_of(raw)):v.wct['entries'][i]=raw_of(src.replace('\n','\r\n'))
 files={'war3map.j':rt.replace('\n','\r\n').encode(),'war3map.wct':write_wct(v.wct)}
 out.parent.mkdir(parents=True,exist_ok=True);out.with_suffix('.j').write_text(rt)
 tmp=out.with_suffix('.unpacked.w3x');write_files(str(base),str(tmp),files);compact(str(tmp),str(out))
 _,flags,players=read_header(str(base));d=out.read_bytes();out.write_bytes(build_header(label,flags,players)+d[d.index(b'MPQ\x1a'):])
 result=MPQ(str(out))
 for n in v.archive.read('(listfile)').decode().splitlines():
  if n.lower() not in ['(listfile)','(attributes)','(signature)']:assert result.read(n)==files.get(n,v.archive.read(n)),n
 bf,af=functions(v.runtime),functions(rt);assert {n for n in bf if tokens(bf[n])!=tokens(af[n])}==set(names)
 for n in ['Cine_Enter','Cine_Exit','Forsaken_PollPanels','Forsaken_CloseBackpack','Forsaken_OnEquip','QuickGear_Receive','GearInput_Init','QuickGear_DrawWheel']:
  assert tokens(bf[n])==tokens(af[n]),n
 out.with_suffix('.json').write_text(json.dumps(dict(base=str(base),output=str(out),sha256=hashlib.sha256(out.read_bytes()).hexdigest(),changed_functions=names,mode='No F/G dock constructed (diagnostic)' if absent else 'Regular-frame F/G dock; original icons, keys, placement and cooldown model retained',status='multiplayer/native acceptance pending; native backpack cross-closing confirmed separately'),indent=2));print(out)
if __name__=='__main__':
 build(ROOT/'release/development/V23/FFERPG-V23.w3x',ROOT/'release/development/V25/FFERPG-V25.w3x','FFERPG V25 - F/G frontend test')
 build(ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x',ROOT/'release/development/GRecovery14/FFERPG-0.9.7.5g-Recovery14.w3x','FFERPG 0.9.7.5g Recovery14 - F/G frontend test')
 build(ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x',ROOT/'release/development/GRecovery14/FFERPG-0.9.7.5g-NoFG-Test.w3x','FFERPG - No F/G diagnostic',True)

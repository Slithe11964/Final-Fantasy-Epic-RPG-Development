import sys,unittest,re,struct
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from test_armory_materia import execute
from test_shared_context import mocks
from inventory_snap_h05 import ROOTS,READERS
ROOT=Path(__file__).resolve().parents[2]
class Snapshots(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  c.prod=View(ROOT/'release/development/VersionHHotfix05/FFERPG-0.9.7.5h-Hotfix05.w3x');c.dev=View(ROOT/'release/development/V9/FFERPG-V9.w3x');c.f=functions(c.prod.runtime)
 def env(self):
  names=['Inventory05_Capture','Inventory05_Refresh','Inventory05_Slot','Inventory05_Bag','Inventory05_Size','Inventory05_Equipment'];s='\n'.join(self.f[n] for n in names);e=mocks(s);data={};native=[]
  e.update(Inventory05Data=1,Inventory05ReadOnly=False,Inventory94Paused=False,Inventory05Dirty=defaultdict(bool),Inventory05Hero=defaultdict(lambda:None),Inventory05Gaya=defaultdict(lambda:None),udg_PlayerHero=defaultdict(lambda:None),udg_SpiritOfGaya=defaultdict(lambda:None),Load04_Busy=lambda:False,GetHandleId=lambda x:x or 0,GetUnitTypeId=lambda u:1 if u else 0,SaveInteger=lambda t,k,s,v:data.__setitem__((k,s),v),LoadInteger=lambda t,k,s:data.get((k,s),0),SaveItemHandle=lambda t,k,s,v:data.__setitem__((k,s),v),LoadItemHandle=lambda t,k,s:data.get((k,s)),ConvertLoadoutSlot=lambda x:x,FlushChildHashtable=lambda t,k:[data.pop(x) for x in list(data) if x[0]==k])
  def read(k,u,i=None):
   native.append((k,u,i));return 60 if k=='size' else (k,u,i)
  e.update(BlzUnitExtendedInventorySize=lambda u:read('size',u),UnitItemInSlot=lambda u,i:read('slot',u,i),BlzUnitItemInBagSlot=lambda u,i:read('bag',u,i),BlzUnitItemInEquipmentSlot=lambda u,i:read('equip',u,i))
  return execute(s,names,e),data,native
 def test_presentation_never_calls_inventory_engine_and_handles_large_bags(self):
  e,data,native=self.env();e['Inventory05_Capture'](10);native.clear();e['Inventory05ReadOnly']=True
  self.assertEqual(e['Inventory05_Slot'](10,2),('slot',10,2));self.assertEqual(e['Inventory05_Bag'](10,59),('bag',10,59));self.assertEqual(e['Inventory05_Equipment'](10,6),('equip',10,6));self.assertEqual(e['Inventory05_Size'](10),60);self.assertIsNone(e['Inventory05_Bag'](10,60));self.assertEqual(native,[])
 def test_two_clients_agree_after_loaded_player_drops_with_other_player_unloaded(self):
  a,da,na=self.env();b,db,nb=self.env()
  for e in [a,b]:
   e['udg_PlayerHero'][1]=10;e['udg_SpiritOfGaya'][1]=20;e['Inventory05_Refresh']()
  a['Inventory05ReadOnly']=True
  for e in [a,b]:
   e['Inventory05Dirty'][0]=True;e['UnitItemInSlot']=lambda u,i:None if u==10 and i==2 else ('slot',u,i);e['Inventory05_Refresh']()
  self.assertEqual(da,db);self.assertIsNone(a['Inventory05_Slot'](10,2));self.assertIsNone(a['Inventory05_Slot'](None,0))
 def test_gameplay_keeps_native_queries(self):
  e,data,native=self.env();self.assertEqual(e['Inventory05_Equipment'](10,6),('equip',10,6));self.assertEqual(len(native),1)
 def test_dirty_refresh_once_per_event_and_never_while_loading(self):
  e,data,native=self.env();e['udg_PlayerHero'][1]=10;e['udg_SpiritOfGaya'][1]=20;e['Inventory05_Refresh']();self.assertTrue(native);native.clear();e['Inventory05_Refresh']();self.assertEqual(native,[])
  e['Inventory05Dirty'][0]=True;e['Load04_Busy']=lambda:True;e['Inventory05_Refresh']();e['Inventory05_Capture'](10);self.assertEqual(native,[]);self.assertTrue(e['Inventory05Dirty'][0]);e['Load04_Busy']=lambda:False;e['Inventory05_Refresh']();self.assertTrue(native);self.assertFalse(e['Inventory05Dirty'][0])
 def test_unknown_or_retired_units_cannot_reuse_snapshots(self):
  e,data,native=self.env();e['udg_PlayerHero'][1]=10;e['Inventory05_Refresh']();e['udg_PlayerHero'][1]=11;e['Inventory05_Refresh']();e['Inventory05ReadOnly']=True;self.assertIsNone(e['Inventory05_Slot'](10,0));self.assertEqual(e['Inventory05_Slot'](11,0),('slot',11,0))
 def test_nested_ui_scope_restores_flags_on_early_return(self):
  for n in ROOTS:
   wrapper=self.f[n];self.assertIn('local boolean previous=Inventory05ReadOnly',wrapper);self.assertIn('set Inventory05ReadOnly=previous',wrapper);self.assertEqual(wrapper.count('return\n'),0)
  b=self.f['UI72_Tick'];self.assertLess(b.index('call Inventory05_Refresh'),b.index('set Inventory05ReadOnly=true'));self.assertNotIn('GetLocalPlayer',self.f['Inventory05_Refresh'])
 def test_all_inventory_reads_of_ui_helpers_use_snapshot_wrappers(self):
  for n in READERS:
   b=self.f.get('Inventory05_UI_'+n,self.f[n]);self.assertNotRegex(b,r'\b(?:BlzUnitItemInEquipmentSlot|BlzUnitItemInBagSlot|BlzUnitExtendedInventorySize|UnitItemInSlot)\(')
 def test_native_cast_and_saving_paths_preserved(self):
  pairs=[(self.prod,'release/development/VersionHHotfix04/FFERPG-0.9.7.5h-Hotfix04.w3x'),(self.dev,'release/development/V8/FFERPG-V8.w3x')]
  for view,base in pairs:
   old=functions(View(ROOT/base).runtime);new=functions(view.runtime)
   for n in old:
    if n.startswith('FFL_') or n in ['QuickGear_Receive','Forsaken_CarryDrop','Forsaken_RestoreStoredItem']:self.assertEqual(tokens(new[n]),tokens(old[n]),n)
 def test_creature_mesh_and_damage_preserved_trail_removed(self):
  old=View(ROOT/'release/development/V8/FFERPG-V8.w3x');new=self.dev
  key=r'war3mapImported\DarkSwarmBreathV7.mdx'
  def chunks(d):
   i=4;out={}
   while i<len(d):
    n=struct.unpack_from('<I',d,i+4)[0];out[d[i:i+4]]=d[i+8:i+8+n];i+=8+n
   self.assertEqual(i,len(d));return out
  a,b=chunks(old.archive.read(key)),chunks(new.archive.read(key));self.assertNotIn(b'PRE2',b);self.assertNotIn(b'RIBB',b)
  for tag in b:self.assertEqual(a[tag],b[tag])
  x,y=functions(old.runtime),functions(new.runtime)
  for n in x:
   if n.startswith(('D5_','D6_','F99_','I2_')):self.assertEqual(tokens(x[n]),tokens(y[n]),n)
  self.assertIn('FRAMEPOINT_TOPLEFT,D7BadgeBuffBar,FRAMEPOINT_BOTTOMRIGHT,.003,.018',y['D7_BadgeFrames'])
if __name__=='__main__':unittest.main()

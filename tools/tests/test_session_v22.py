"""Private native-pane recovery, explicit close, and model-free gear UI."""
import sys,unittest
from pathlib import Path
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions
from session_v22 import refresh,WHEEL
import test_panel_v21 as panel_test
from test_armory_materia import execute
from test_shared_context import mocks

class Session22Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.base=view(str(ROOT/'release/development/V21/FFERPG-V21.w3x')).modules['TEquip']
  cls.source=refresh(cls.base);cls.fs=functions(cls.source)
  panel_test.Panel21Tests.setUpClass()
 def engine(self):
  e,live,shown=panel_test.Panel21Tests().engine();repairs=[];clock=[5.]
  e.update(Bag22Armed=False,Bag22Hero=None,Bag22Gear=None,Bag22Bag=None,Bag22Backdrop=None,Bag22NextRestore=0.,
   TimerGetElapsed=lambda t:clock[0])
  def visible(f,on):
   shown[f]=on
   if f in {'gear','bag','backdrop'}:
    repairs.append((f,on))
    if on:live.add(f)
    else:live.discard(f)
  e['BlzFrameSetVisible']=visible
  names=['Forsaken_SelectCachedFrame','Forsaken_InventoryContext','Forsaken_BackpackVisible','Forsaken_BackpackControls','CarryUI_ShowAccess','Forsaken_PollPanels']
  e=execute('\n'.join(self.fs[n] for n in names),names,e)
  return e,live,shown,repairs,clock
 def test_remote_native_hide_restores_only_last_verified_own_pair(self):
  e,live,shown,repairs,clock=self.engine()
  self.assertTrue(e['Forsaken_BackpackVisible']('gear'));self.assertTrue(e['Bag22Armed'])
  live.clear();clock[0]=5.2
  self.assertTrue(e['Forsaken_BackpackVisible']('gear'))
  self.assertEqual(repairs,[('gear',True),('bag',True),('backdrop',True)])
  e['Forsaken_PollPanels']()
  for f in ['talents','x','move']:self.assertTrue(shown[f])
  self.assertFalse(shown['hunt']);self.assertFalse(shown['version'])
 def test_never_shows_an_inventory_that_was_not_verified_open(self):
  e,live,shown,repairs,clock=self.engine();live.clear()
  self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertEqual(repairs,[])
 def test_real_close_or_context_change_cannot_trigger_recovery(self):
  for mode in ['closed','deselected','foreign','inspect','cinematic']:
   e,live,shown,repairs,clock=self.engine();e['Forsaken_BackpackVisible']('gear');live.clear()
   if mode=='closed':e.update(ForsakenBackpackWanted=False,ForsakenBackpackExplicitlyClosed=True)
   if mode=='deselected':e['IsUnitSelected']=lambda *a:False
   if mode=='foreign':e['GetOwningPlayer']=lambda *a:1
   if mode=='inspect':e['ForsakenInspectTarget']='other'
   if mode=='cinematic':e['InventoryCinematicActive']=True
   self.assertFalse(e['Forsaken_BackpackVisible']('gear'),mode);self.assertEqual(repairs,[],mode)
 def test_delayed_native_close_does_not_rearm_the_open_request(self):
  e,live,shown,repairs,clock=self.engine();e['Forsaken_BackpackVisible']('gear')
  e.update(ForsakenBackpackWanted=False,ForsakenBackpackExplicitlyClosed=True,ForsakenInventoryBindUntil=5.2,Bag22Armed=False)
  self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertFalse(e['ForsakenBackpackWanted'])
  clock[0]=5.3;live.clear();self.assertFalse(e['Forsaken_BackpackVisible']('gear'));self.assertEqual(repairs,[])
 def test_recovery_is_rate_limited_and_private_to_each_client(self):
  a,al,_,ar,ac=self.engine();b,bl,_,br,bc=self.engine()
  a['Forsaken_BackpackVisible']('gear');b['Forsaken_BackpackVisible']('gear')
  al.clear();a['Forsaken_BackpackVisible']('gear');al.clear();ac[0]=5.1
  self.assertFalse(a['Forsaken_BackpackVisible']('gear'));self.assertEqual(len(ar),3)
  self.assertEqual(br,[]);self.assertEqual(bl,{'gear','bag','backdrop'});self.assertTrue(b['Bag22Armed'])
 def test_radial_shadow_tracks_original_deadline_and_clears_at_ready(self):
  e=mocks(WHEEL);paint=[]
  e.update(QuickGearEnds={0:100.},QuickGearActive={0:True},QuickGearDuration={0:100.},QuickGearWheelStep={0:-1},QuickGearWheelPanel={0:'panel'},QuickGearWheelImage={0:'texture'},
   RMaxBJ=max,RMinBJ=min,IMinBJ=min,IMaxBJ=max,R2I=int,I2S=str,BlzFrameIsVisible=lambda f:True,BlzFrameSetTexture=lambda f,p,*a:paint.append(p))
  e=execute(WHEEL,['QuickGear_DrawWheel'],e)
  for now,step in [(0.,64),(50.,32),(100.,0)]:
   e['QuickGear_DrawWheel'](0,True,now);self.assertEqual(e['QuickGearWheelStep'][0],step)
   self.assertTrue(paint[-1].endswith('CD%02d.tga'%step))
  self.assertEqual(e['QuickGearEnds'][0],100.)
 def test_cinematic_callbacks_return_before_any_frame_or_hero_getter(self):
  for n in ['GearInput_Hover','GearWave_CancelKey','GearWave_WaterCommand','GearWave_IceCommand','GearWave_CalculatorArm','QuickGear_RecordSpell','QuickGear_Draw','QuickGear_RepaintIcons']:
   b=self.fs[n];e=mocks(b)
   def fail(*a):self.fail(n+' accessed native UI/hero during cutscene')
   e.update(udg_InCinematicMode=True,InventoryCinematicActive=True,GetTriggerUnit=fail,GetOwningPlayer=fail,GetLocalPlayer=fail,Player_GetHero=fail,BlzGetTriggerFrame=fail,BlzFrameIsVisible=fail)
   e=execute(b,[n],e);e[n](*(['hero',0] if n=='QuickGear_Draw' else []))
 def test_no_new_model_or_gameplay_mutation_or_inventory_query_in_recovery(self):
  self.assertNotIn('BlzCreateFrameByType("STATUSBAR"',self.fs['QuickGear_Init'])
  self.assertNotIn('BlzFrameSetModel(',self.fs['QuickGear_Init'])
  b=self.fs['Forsaken_BackpackVisible']
  for x in ['CreateTimer(','BlzCreateFrame','BlzGetFrameByName(','UnitAdd','UnitRemove','Issue','ForceUI','BlzSendSyncData(','UnitItemIn','BlzUnitItemIn']:
   self.assertNotIn(x,b)
  for n in ['Forsaken_CloseBackpack','Forsaken_ResetBackpackControls']:self.assertIn('set Bag22Armed=false',self.fs[n])

if __name__=='__main__':unittest.main()

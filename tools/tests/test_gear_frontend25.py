"""Exercise F/G frame families/ownership and preserve cast/gameplay paths."""
from pathlib import Path
from collections import defaultdict
import sys,re,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from build_f1030_inventory_rollback import view
from build_forest86 import ROOT,functions
from gear_frontend25 import refresh,CONTROLS
from test_shared_context import mocks
from test_armory_materia import execute
from jtok import tokens

class Frontend25Tests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.base=view(str(ROOT/'release/development/GRecovery12/FFERPG-0.9.7.5g-Recovery12.w3x')).modules['TEquip']
  cls.old=functions(cls.base);cls.source=refresh(cls.base);cls.fs=functions(cls.source)
 def test_controls_use_regular_types_keep_icons_keys_model_and_clicks(self):
  # The lightweight Python translator unescapes JASS string backslashes twice.
  # Use equivalent forward slashes in this executable fixture only; compare
  # the actual emitted model literal against the baseline separately below.
  source=('function BuildControls takes nothing returns nothing\n'+CONTROLS+'\nendfunction').replace('\\\\','/');e=mocks(source);nodes={};models=[];clicks=[];texts={}
  for n in re.findall(r'\b(QuickGear\w+)\[',source):e[n]=defaultdict(lambda:None)
  def create(kind,name,parent,template,context):
   key=name+str(context);self.assertNotIn(key,nodes);nodes[key]=(kind,parent);return key
  e.update(slot=0,QuickGearRoot='root',FRAMEPOINT_TOPLEFT=0,FRAMEEVENT_CONTROL_CLICK=1,TEXT_JUSTIFY_TOP=0,TEXT_JUSTIFY_LEFT=0,
   QuickGearClick='click',QuickGearWeaponKey={0:70},QuickGearOffhandKey={0:71},
   BlzCreateFrameByType=create,GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,I2R=float,
   QuickGear_KeyName=lambda k:chr(k),BlzFrameSetModel=lambda f,p,c:models.append((f,p,c)),
   BlzTriggerRegisterFrameEvent=lambda t,b,ev:clicks.append(b),BlzFrameSetText=lambda f,s:texts.update({f:s}))
  e=execute(source,['BuildControls'],e);e['BuildControls']()
  self.assertEqual([nodes[b][0] for b in clicks],['BUTTON','BUTTON'])
  self.assertEqual([texts[e['QuickGearLabel'][i]] for i in range(2)],['F','G'])
  self.assertTrue(all(n[0] in ['BUTTON','FRAME','TEXT','BACKDROP','STATUSBAR'] for n in nodes.values()))
  for slot in range(2):
   model=e['QuickGearNativeWheel'][slot];self.assertEqual(nodes[model],('STATUSBAR',e['QuickGearWheelPanel'][slot]))
   self.assertEqual(nodes[e['QuickGearIcon'][slot]],('BACKDROP',e['QuickGearButton'][slot]))
  self.assertTrue(all(p=='UI/Feedback/Cooldown/UI-Cooldown-Indicator.mdl' for f,p,c in models))
  old=re.search(r'BlzFrameSetModel\(QuickGearNativeWheel\[slot\],("[^"]+"),0\)',self.old['QuickGear_Init'])[1]
  new=re.search(r'BlzFrameSetModel\(QuickGearNativeWheel\[slot\],("[^"]+"),0\)',self.fs['QuickGear_Init'])[1]
  self.assertEqual(old,new)
 def test_reset_destroys_models_before_their_overlay_parent(self):
  b=self.fs['QuickGear_Reset'];e=mocks(b);deleted=[]
  for n in re.findall(r'\bQuickGear\w+\b',b):e.setdefault(n,None)
  for n in re.findall(r'\b(QuickGear\w+)\[',b):e[n]=defaultdict(lambda:None)
  e.update(QuickGearClick='click',QuickGearPreviewCount=0,QuickGearRoot='root',
   QuickGearNativeWheel={0:'model0',1:'model1'},QuickGearWheelPanel={0:'clock0',1:'clock1'},QuickGearButton={0:'button0',1:'button1'},
   GearInput_Reset=lambda:None,QuickGear_ClearPreview=lambda:None,BlzDestroyFrame=lambda f:deleted.append(f))
  e=execute(b,['QuickGear_Reset'],e);e['QuickGear_Reset']()
  for i in range(2):self.assertLess(deleted.index('model'+str(i)),deleted.index('clock'+str(i)))
  self.assertNotIn(None,deleted);self.assertEqual(deleted[-1],'root')
 def test_no_dock_does_not_construct_its_frames_but_keeps_backpack_tick(self):
  f=functions(refresh(self.base,True));b=f['QuickGear_Init']
  for x in ['BlzCreateSimpleFrame(','BlzCreateFrameByType(','BlzFrameSetModel(','QuickGearItemImage','QuickGearItemKey']:
   self.assertNotIn(x,b)
  self.assertIn('call ExecuteFunc("GearInput_Init")',b)
  self.assertIn('TimerStart(QuickGearUITimer,.1,true,function UI72_Tick)',b)
  self.assertNotIn('QuickGear_Item(',f['QuickGear_Request'])
  self.assertEqual(tokens(f['UI72_Tick']),tokens(self.old['UI72_Tick']))
 def test_casting_poll_timers_saves_and_cinematic_code_are_not_rewritten(self):
  changed={n for n in self.old if tokens(self.old[n])!=tokens(self.fs[n])}
  self.assertEqual(changed,{'QuickGear_Init','QuickGear_Reset','QuickGear_RepaintIcons'})
  for n in ['QuickGear_Input','QuickGear_Request','QuickGear_Click','QuickGear_Mouse','QuickGear_Receive','QuickGear_PaintIcon','QuickGear_DrawWheel','QuickGear_Poll','Forsaken_PollPanels','C20_UIPause','C20_UIResume']:
   self.assertEqual(tokens(self.old[n]),tokens(self.fs[n]),n)
  self.assertEqual(self.old['QuickGear_Init'].count('CreateTimer()'),self.fs['QuickGear_Init'].count('CreateTimer()'))
  self.assertNotIn('BlzCreateSimpleFrame(',self.fs['QuickGear_Init'])
  self.assertNotIn('BlzGetFrameByName("QuickGear',self.fs['QuickGear_Init'])

if __name__=='__main__':unittest.main()

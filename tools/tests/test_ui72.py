"""Capped UI scheduling, idle work avoidance, and gear refresh regressions."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from ui72 import refresh
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class UI72Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.view=View(ROOT/'release/development/QuickUI71/FFERPG-QuickUI71.w3x')
        cls.source=refresh(cls.view.modules['TEquip'],True);cls.fs=functions(cls.source)

    def test_one_background_ui_timer_replaces_four(self):
        self.assertIn('TimerStart(QuickGearUITimer,.1,true,function UI72_Tick)',self.fs['QuickGear_Init'])
        for n in ['QuickGear_Init','GearInput_Init','Register_Forsaken_PanelAccess']:
            self.assertNotIn('function QuickGear_WheelTick)',self.fs[n])
            self.assertNotIn('function GearCursor_Draw60)',self.fs[n])
            self.assertNotIn('function Forsaken_PollPanels)',self.fs[n])
        calls=[];s=self.fs['UI72_Tick'];env=mocks(s)
        for n in ['GearChat_Poll63','QuickGear_WheelTick','QuickGear_Poll','GearInput_Poll','GearCursor_Draw60','UI72_Extra']:
            env[n]=lambda n=n:calls.append(n)
        env['ExecuteFunc']=calls.append
        e=execute(s,['UI72_Tick'],env);e['UI72_Tick']()
        self.assertEqual(len(calls),7);self.assertEqual(calls[0],'GearChat_Poll63')
        self.assertEqual(calls.count('Forsaken_PollPanels'),1)

    def test_idle_input_has_no_bag_cursor_or_rune_work_active_aim_still_does(self):
        calls=[];s=self.fs['GearInput_Poll'];env=mocks(s)
        env.update(BlzIsLocalClientActive=lambda:True,QuickGearChatOpen=False,InventoryCinematicActive=False,
            BagMoving64=False,ForsakenLinkedBag=None,GearInputTarget=False,GearCursorWasShown60=False,
            GearWaveMode=0,QuickGearPending=-1,BlzFrameIsVisible=lambda f:True,
            BagScreen_Poll65=lambda:calls.append('bag'),GearInput_Cursor=lambda:calls.append('cursor'),
            GearWave_Draw=lambda:calls.append('wave'))
        e=execute(s,['GearInput_Poll'],env)
        for _ in range(100):e['GearInput_Poll']()
        self.assertEqual(calls,[])
        e.update(ForsakenLinkedBag='bag',GearInputTarget=True,QuickGearPending=1,GearWaveMode=1)
        e['GearInput_Poll']();self.assertEqual(calls,['bag','cursor','wave'])

    def test_clearing_idle_runes_does_not_repeat_image_calls(self):
        calls=[];s=self.fs['GearWave_Clear'];env=mocks(s)
        env.update(GearWaveMode=0,Wave65_Clear=lambda:calls.append('wave'),
            GearWaveRune=defaultdict(lambda:'rune'),ShowImage=lambda *a:calls.append(a))
        e=execute(s,['GearWave_Clear'],env)
        for _ in range(100):e['GearWave_Clear']()
        self.assertEqual(calls,[])
        e['GearWaveMode']=1;e['GearWave_Clear']();self.assertEqual(len(calls),65)
        e['GearWave_Clear']();self.assertEqual(len(calls),65)

    def test_mouse_events_cannot_redraw_wave_over_ten_hz(self):
        state={'time':0.};calls=[];s=self.fs['GearWave_Draw'];env=mocks(s)
        env.update(NativeCDClock='clock',TimerGetElapsed=lambda t:state['time'],GearWaveMode=1,
            UI72WaveNext=0.,Wave65_Draw=lambda:calls.append(state['time']))
        e=execute(s,['GearWave_Draw'],env)
        for i in range(1000):
            state['time']=i/1000.;e['GearWave_Draw']()
        self.assertLessEqual(len(calls),11);self.assertGreaterEqual(len(calls),10)
        e['GearWaveMode']=0;state['time']=10.;e['GearWave_Draw']()
        self.assertLessEqual(len(calls),11)

    def test_icons_refresh_on_equip_revision_not_idle_ticks(self):
        source=self.fs['QuickGear_Poll']+'\n'+self.fs['UI72_GearChanged'];env=mocks(source)
        state={'time':10.};draws=[]
        env.update(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',
            TimerGetElapsed=lambda t:state['time'],NativeCDClock='clock',
            FFL_Phase={0:0},FFN_State={0:0},QuickGearReady=False,QuickGearHero=None,
            QuickGearSeenRevision=-1,QuickGearRevision={0:0},UI72GearNext=0.,
            QuickGear_SlotsChanged=lambda h:False,QuickGear_Draw=lambda *a:draws.append(a),
            QuickGearSeenCooldownRevision=0,NativeCDData='table',LoadInteger=lambda *a:0,
            InventoryCinematicActive=False,IsUnitSelected=lambda *a:True,
            QuickGearActive={0:True,1:True},QuickGearPending=-1,QuickGearRoot='root',
            QuickGearButton={0:'F',1:'G'},QuickGearWheelPanel={0:None,1:None},
            QuickGearEnds={0:0.,1:0.},QuickGearLastSeconds={0:0,1:0},RMaxBJ=max,R2I=int,
            BlzFrameIsVisible=lambda f:True,BlzFrameSetVisible=lambda *a:None,
            QuickGear_DrawWheel=lambda *a:None,QuickGear_UpdateCooldowns=lambda *a:None,
            QuickGear_RefreshIcons=lambda *a:self.fail('unconditional icon repaint'))
        e=execute(source,['UI72_GearChanged','QuickGear_Poll'],env)
        e['QuickGear_Poll']();self.assertEqual(len(draws),1)
        for i in range(30):state['time']=10.+i*.1;e['QuickGear_Poll']()
        self.assertEqual(len(draws),1)
        e['QuickGearRevision'][0]+=1;e['QuickGear_Poll']();self.assertEqual(len(draws),2)

    def test_working_input_cast_geometry_and_icon_paint_are_unchanged(self):
        a=functions(self.view.modules['TEquip'])
        for n in ['QuickGear_Mouse','QuickGear_Input','QuickGear_Request','QuickGear_Receive',
            'GearChat_Sent64','GearChat_Poll63','GearRaw_Poll64','QuickGear_FocusReset',
            'QuickGear_Draw','QuickGear_PaintIcon','QuickGear_RepaintIcons','Wave65_Draw','Wave65_Init',
            'Wave67_BuildEdge','GearCursor_Error60','Inventory71_Reconcile']:
            self.assertEqual(tokens(a[n]),tokens(self.fs[n]),n)
        self.assertNotIn('QuickGear_RefreshIcons',self.fs['QuickGear_WheelTick'])

    def test_dragoon_motion_unchanged_and_ui_hides_runes_only_once(self):
        a=self.view.modules['TDamage'];b=refresh(a,True);af,bf=functions(a),functions(b)
        self.assertEqual(tokens(af['DG_Tick'].replace(' call DG_UIUpdate()','')),tokens(bf['DG_Tick']))
        self.assertIn('if not show and not UI72DragoonRunes then',bf['DG_UIUpdate'])
        self.assertIn('ExecuteFunc("DG_UIUpdate")',self.fs['UI72_Extra'])

if __name__=='__main__':unittest.main()

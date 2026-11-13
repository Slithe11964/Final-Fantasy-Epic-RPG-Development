"""Native aim must survive hidden F/G dock; emphasize paths without changing damage."""
import sys,math,unittest
from pathlib import Path
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
import test_quest_lifecycle as harness
from test_backpack_sync import unsafe_paths
from historical_map import historical_map
from editor_pair import View
from jtok import functions,tokens
ROOT=Path(__file__).resolve().parents[2]
WAVE=(ROOT/'experiments/Forsaken/Wave67.j').read_text()
PAIRS=[('QuickUI66/FFERPG-QuickUI66-Forsaken','QuickUI67/FFERPG-QuickUI67-Forsaken'),
 ('VersionEHotfix14/FFERPG-0.9.7.5e-Hotfix14-Forsaken','VersionEHotfix15/FFERPG-0.9.7.5e-Hotfix15-Forsaken')]

class Preview67Tests(unittest.TestCase):
    def test_actual_dock_poll_does_not_cancel_native_aim_with_no_castable_equipment(self):
        v=View(ROOT/'release/development/QuickUI67/FFERPG-QuickUI67-Forsaken.w3x')
        state=dict(selected=True);cleared=[]
        env=dict(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',
            NativeCDClock='clock',TimerGetElapsed=lambda t:10.,FFL_Phase={0:0},FFN_State={0:0},
            QuickGearRoot='dock',BlzFrameSetVisible=lambda *a:None,QuickGearShown=False,
            QuickGearReady=True,QuickGearHero='hero',QuickGearSeenRevision=1,QuickGearRevision={0:1},
            QuickGear_SlotsChanged=lambda h:False,QuickGearActive={0:False,1:False},QuickGearRetryUntil=0.,
            NativeCDData='cd',LoadInteger=lambda *a:0,QuickGearSeenCooldownRevision=0,
            InventoryCinematicActive=False,IsUnitSelected=lambda *a:state['selected'],QuickGearPending=-1,
            BlzFrameIsVisible=lambda f:False,QuickGearButton={0:'f',1:'g'},
            QuickGearWheelPanel={0:None,1:None},QuickGearEnds={0:0.,1:0.},
            QuickGearLastSeconds={0:0,1:0},QuickGear_DrawWheel=lambda *a:None,
            R2I=int,RMaxBJ=max,QuickGear_RefreshIcons=lambda *a:None,GearWaveMode=1)
        e=execute(v.runtime,['QuickGear_Poll'],env)
        def clear():cleared.append(True);e['GearWaveMode']=0
        e['QuickGear_ClearPreview']=clear
        for _ in range(20):e['QuickGear_Poll']()
        self.assertEqual(cleared,[]);self.assertEqual(e['GearWaveMode'],1)
        # A stale F/G request still cancels if its own equipment disappears.
        e['QuickGearPending']=0;e['QuickGear_Poll']();self.assertEqual(len(cleared),1)
        e['QuickGearPending']=-1;e['GearWaveMode']=2;state['selected']=False
        e['QuickGear_Poll']();self.assertEqual(len(cleared),2)

    def edge(self):
        env=dict(IceEdgeX67={},IceEdgeY67={},bj_DEGTORAD=math.pi/180.,
            I2R=float,Cos=math.cos,Sin=math.sin,RMaxBJ=max,SquareRoot=math.sqrt)
        expr=harness.expression
        with patch.object(harness,'expression',lambda s:expr(s).replace('//','/')):
            e=execute(WAVE,['Wave67_BuildEdge'],env)
        e['Wave67_BuildEdge']();return e

    def test_small_ice_boundary_is_on_actual_main_wave_damage_circles(self):
        e=self.edge();centers=[]
        for lane in range(3):
            a=math.radians(-11.25+22.5*lane)
            centers.extend((200*s*math.cos(a),200*s*math.sin(a)) for s in range(1,6))
        count=0
        for i in range(1,65):
            x,y=e['IceEdgeX67'][i],e['IceEdgeY67'][i]
            if math.hypot(x,y)>.01:
                count+=1
                self.assertAlmostEqual(min(math.hypot(x-cx,y-cy) for cx,cy in centers),200.,places=5)
                self.assertLessEqual(math.hypot(x,y),1200.00001)
        self.assertGreater(count,50)
        self.assertNotIn('GetRandom',functions(WAVE)['Wave67_BuildEdge'])

    def test_water_middle_only_is_replaced_for_depths_and_wateraga(self):
        for raw,enlarged in [('A08X',True),('A0Q2',True),('A0Q0',False)]:
            shown={};positions={}
            env=dict(GearWaveMode=1,GearWaveCast67=raw,Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
                QuickGearMouseX=1000.,QuickGearMouseY=0.,IsUnitSelected=lambda *a:True,
                InventoryCinematicActive=False,QuickGearChatOpen=False,BlzIsLocalClientActive=lambda:True,
                BlzGetMouseFocusUnit=lambda:None,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,
                GearWave_Clear=lambda:None,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,
                I2R=float,ModuloInteger=lambda a,b:a%b,bj_DEGTORAD=math.pi/180.,
                GearWaveRune={i:('old',i) for i in range(1,65)},
                WaterMiddle67={i:('middle',i) for i in range(1,18)},
                IceEdge67={i:('edge',i) for i in range(1,65)},
                IceAreaRune65={i:('ice',i) for i in range(1,64)},IceEdgeX67={},IceEdgeY67={},
                SetImagePosition=lambda image,x,y,z:positions.update({image:(x,y)}),
                ShowImage=lambda image,show:shown.update({image:show}))
            e=execute(WAVE,['Wave65_WaterWidth','Wave67_Draw'],env);e['Wave67_Draw']()
            self.assertEqual(sum(v for (kind,i),v in shown.items() if kind=='middle'),17 if enlarged else 0)
            self.assertEqual(shown['old',1],not enlarged);self.assertTrue(shown['old',18])
            self.assertTrue(shown['old',63])
            if enlarged:self.assertEqual(positions['middle',1],(-48.,-48.))

    def test_equipped_and_bag_item_reads_never_use_invalid_native_slot(self):
        v=View(ROOT/'release/development/QuickUI67/FFERPG-QuickUI67-Forsaken.w3x');reads=[]
        e=execute(v.runtime,['BagScreen_Item67'],dict(
            BlzUnitItemInBagSlot=lambda h,s:reads.append(('bag',s)) or ('bag',s),
            QuickGear_Item=lambda h,s:reads.append(('gear',s)) or ('gear',s)))
        for s in (0,29,100,101):self.assertIsNotNone(e['BagScreen_Item67']('hero',s))
        self.assertEqual(reads,[('bag',0),('bag',29),('gear',0),('gear',1)])
        for s in (-1,30,99,102):self.assertIsNone(e['BagScreen_Item67']('hero',s))

    def test_packaged_preservation_and_preview_lifecycle(self):
        for old,new in PAIRS:
            av=View(historical_map(ROOT, old));bv=View(historical_map(ROOT, new))
            a,b=functions(av.runtime),functions(bv.runtime)
            for n in ['GearChat_Sent64','GearChat_Poll63','GearRaw_Poll64','QuickGear_Input',
                'QuickGear_Request','QuickGear_Receive','QuickGear_Mouse','QuickGear_PaintIcon',
                'QuickGear_RepaintIcons','GearCursor_Error60','Forsaken_WaterTick','Forsaken_WaterTouches',
                'Trig_Spell_Blizzaga_Loop','Trig_Spell_Blizzaga_Actions']:
                self.assertEqual(tokens(a[n]),tokens(b[n]),n)
            self.assertEqual(unsafe_paths(b,['Wave65_Draw','BagScreen_Event66','BagScreen_Poll66']),[])
            for pool in ('WaterMiddle67','IceEdge67'):
                self.assertIn('CreateImage',b['Wave65_Init']);self.assertIn('DestroyImage('+pool,b['Wave65_Reset'])
            self.assertIn('96.,96.',b['Wave65_Init']);self.assertIn('48.,48.',b['Wave65_Init'])
            self.assertIn('BagHoverSlot64=100',b['BagScreen_Update66'])
            for asset in ('war3map.w3a','war3map.w3u','war3map.w3t','GearError66.fdf','GearTarget61.tga'):
                self.assertEqual(av.archive.read(asset),bv.archive.read(asset))

if __name__=='__main__':unittest.main()

"""No bag hit-testing controls; previews reflect existing water/ice damage code."""
import sys,unittest,math
from unittest.mock import patch
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
import test_quest_lifecycle as harness
from test_backpack_sync import unsafe_paths,calls
from jtok import functions,tokens
from historical_map import historical_map
from editor_pair import View
ROOT=Path(__file__).resolve().parents[2]
WAVE=(ROOT/'experiments/Forsaken/Wave65.j').read_text()
BAG=(ROOT/'experiments/Forsaken/BagScreen65.j').read_text()
PAIRS=[('QuickUI64/FFERPG-QuickUI64-Forsaken','QuickUI65/FFERPG-QuickUI65-Forsaken'),
 ('VersionEHotfix12/FFERPG-0.9.7.5e-Hotfix12-Forsaken','VersionEHotfix13/FFERPG-0.9.7.5e-Hotfix13-Forsaken')]

class PreviewTests(unittest.TestCase):
    def test_native_click_observer_skips_pickup_drop_and_arms_only_cast_click(self):
        state=dict(left=False,right=False,visible=True);arms=[]
        env=dict(ForsakenLinkedBag='bag',BagConsole65='console',Player_GetHero=lambda p:'hero',
            GetLocalPlayer=lambda:0,IsUnitSelected=lambda *a:True,QuickGearChatOpen=False,
            InventoryCinematicActive=False,BlzIsLocalClientActive=lambda:True,
            MOUSE_BUTTON_TYPE_LEFT=0,MOUSE_BUTTON_TYPE_RIGHT=1,
            BlzIsMouseButtonPressed=lambda b:state['right'] if b==1 else state['left'],
            BlzFrameIsVisible=lambda f:state['visible'],BlzPixelToFrameX=lambda n:n/1000.,
            BlzPixelToFrameY=lambda n:1.-n/1000.,BlzGetLocalClientWidth=lambda:1000,
            BlzGetLocalClientHeight=lambda:1000,BlzFrameGetWidth=lambda f:.8 if f=='console' else .3,
            BlzFrameGetHeight=lambda f:.13 if f=='console' else .2408,
            BlzGetMouseScreenPosX=lambda:680,BlzGetMouseScreenPosY=lambda:675,
            BagLeftEdge65=0.,BagTopEdge65=0.,BagCellX65=0.,BagCellY65=0.,R2I=int,
            BagHoverSlot64=-1,BagRight64=False,BagLeft64=False,BagMoving64=False,
            BagScreenArms65=0,QuickGearPending=-1,GearInputArmedAt=0.,
            GetItemTypeId=lambda i:123,BlzUnitItemInBagSlot=lambda h,s:'depths' if s==7 else None,
            BagCast_Spell63=lambda r:456,GearWave_Clear=lambda:None,QuickGear_ClearPreview=lambda:None,
            GearWave_Arm=arms.append,TimerGetElapsed=lambda t:10.,NativeCDClock='clock')
        # The quest harness floors every division. These screen functions use
        # real division exclusively, so compile them with real arithmetic.
        original_expression=harness.expression
        with patch.object(harness,'expression',lambda text:original_expression(text).replace('//','/')):
            e=execute(BAG,['BagScreen_Slot65','BagScreen_Poll65'],env)
        e['BagScreen_Poll65']();self.assertEqual(e['BagHoverSlot64'],7,
            {k:e[k] for k in ('BagLeftEdge65','BagTopEdge65','BagCellX65','BagCellY65')})
        state['right']=True;e['BagScreen_Poll65']()  # native right pickup
        state.update(right=False,left=True);e['BagScreen_Poll65']() # native drop
        self.assertEqual(arms,[])
        state['left']=False;e['BagScreen_Poll65']()
        state['left']=True;e['BagScreen_Poll65']();e['BagScreen_Poll65']()
        self.assertEqual(arms,[456])
        state.update(left=False,visible=False);e['BagScreen_Poll65']()
        state['left']=True;e['BagScreen_Poll65']();self.assertEqual(arms,[456])

    def test_screen_slot_boundaries_and_row_major_layout(self):
        e=execute(BAG,['BagScreen_Slot65'],dict(BagLeftEdge65=.5,BagTopEdge65=.5,
            BagCellX65=.04,BagCellY65=.04,R2I=int))
        for row in range(5):
            for col in range(6):
                self.assertEqual(e['BagScreen_Slot65'](.5+(col+.5)*.04,.5-(row+.5)*.04),row*6+col)
        for x,y in [(.49,.4),(.75,.4),(.6,.51),(.6,.29)]:
            self.assertEqual(e['BagScreen_Slot65'](x,y),-1)

    def draw(self,mode):
        positions={};shown={}
        env=dict(GearWaveMode=mode,Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
            QuickGearMouseX=1000.,QuickGearMouseY=0.,IsUnitSelected=lambda *a:True,
            InventoryCinematicActive=False,QuickGearChatOpen=False,BlzIsLocalClientActive=lambda:True,
            BlzGetMouseFocusUnit=lambda:None,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,
            GearWave_Clear=lambda:None,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,
            I2R=float,ModuloInteger=lambda a,b:a%b,bj_DEGTORAD=math.pi/180.,
            GearWaveRune={i:('water',i) for i in range(1,65)},
            IceAreaRune65={i:('ice',i) for i in range(1,16)},
            SetImagePosition=lambda image,x,y,z:positions.update({image:(x,y)}),
            ShowImage=lambda image,show:shown.update({image:show}))
        e=execute(WAVE,['Wave65_WaterWidth','Wave65_Draw'],env);e['Wave65_Draw']()
        return positions,shown

    def test_water_outline_tracks_widening_damage_width(self):
        p,s=self.draw(1)
        self.assertEqual(sum(s.values()),63)
        # Center locations add back the 24-unit glyph origin correction.
        self.assertEqual(tuple(round(v+24,5) for v in p['water',18]),(0.,78.))
        self.assertEqual(tuple(round(v+24,5) for v in p['water',34]),(800.,278.))
        self.assertFalse(any(shown for image,shown in s.items() if image[0]=='ice'))
        original=(ROOT/'src/triggers/04 Combat and abilities/Spell_Water.j').read_text()
        self.assertIn('100.+200.*',functions(original)['Water_Touches'])

    def test_ice_circles_match_fifteen_actual_pulse_centers(self):
        p,s=self.draw(2);self.assertEqual(sum(s.values()),15)
        for i in range(1,16):
            distance=200*((i-1)%5+1)
            angle=math.radians(-11.25+22.5*((i-1)//5))
            x,y=p['ice',i]
            self.assertAlmostEqual(x+221,distance*math.cos(angle),places=5)
            self.assertAlmostEqual(y+221,distance*math.sin(angle),places=5)
        original=(ROOT/'src/triggers/04 Combat and abilities/Spell_Blizzaga.j').read_text()
        self.assertIn('Dist[d]+200.',original);self.assertIn('Dist[d]<1200.',original)
        self.assertIn('x,y,200.,udg_BlizzagaFilter',original)
        self.assertIn('GetRandomReal(.0,360.)',original)

    def test_packaged_preserves_confirmed_chat_fg_and_gameplay(self):
        for old,new in PAIRS:
            aview=View(historical_map(ROOT, old));bview=View(historical_map(ROOT, new))
            a,b=functions(aview.runtime),functions(bview.runtime)
            for name in ['GearChat_Sent64','GearChat_Poll63','GearRaw_Poll64','QuickGear_Input',
                'QuickGear_WheelTick','QuickGear_Request','QuickGear_Receive','QuickGear_Mouse',
                'QuickGear_PaintIcon','QuickGear_RepaintIcons','Forsaken_WaterTouches','Forsaken_WaterTick',
                'Trig_Spell_Blizzaga_Loop','Trig_Spell_Blizzaga_Actions']:
                self.assertEqual(tokens(a[name]),tokens(b[name]),name)
            self.assertEqual(unsafe_paths(b,['BagScreen_Poll65','Wave65_Draw']),[])
            self.assertNotIn('BlzCreate',b['BagCast_Init63'])
            self.assertNotIn('BlzFrameSetTooltip',b['BagCast_Init63'])
            self.assertNotIn('BlzFrameSetVisible',b['BagScreen_Poll65'])
            self.assertIn('call Wave65_Reset()',b['GearWave_Reset'])
            self.assertIn('call Wave65_Init()',b['GearWave_Init'])
            self.assertIn('Width()/2),.155',b['GearCursor_Error60'])
            self.assertIn('0.027',bview.archive.read('GearError65.fdf').decode())
            for asset in ['war3map.w3a','war3map.w3u','war3map.w3t','GearTarget61.tga']:
                self.assertEqual(aview.archive.read(asset),bview.archive.read(asset))

if __name__=='__main__':unittest.main()

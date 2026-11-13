"""Event versus polling input, water damage boundaries, and one readable renderer."""
import sys,unittest,math
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
from jtok import functions,tokens
from historical_map import historical_map
from editor_pair import View
ROOT=Path(__file__).resolve().parents[2]
BAG=(ROOT/'experiments/Forsaken/BagEvent66.j').read_text()
PAIRS=[('QuickUI65/FFERPG-QuickUI65-Forsaken','QuickUI66/FFERPG-QuickUI66-Forsaken'),
 ('VersionEHotfix13/FFERPG-0.9.7.5e-Hotfix13-Forsaken','VersionEHotfix14/FFERPG-0.9.7.5e-Hotfix14-Forsaken')]

class Preview66Tests(unittest.TestCase):
    def test_native_event_then_poll_only_arms_once_and_fallback_still_works(self):
        state=dict(now=5.,left=True,right=False,button=0);arms=[]
        env=dict(Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,BagHoverSlot64=7,
            BagScreen_Update66=lambda:None,BagMoving64=False,BagMovedAt66=-100.,
            BagSourceSlot66=-1,BagCarried66=None,QuickGearPending=-1,GearInputArmedAt=0.,
            BagScreenArms65=0,BagHandled66=False,BagLastEvent66=-100.,BagLeft64=False,BagRight64=False,
            QuickGear_ClearPreview=lambda:None,BlzUnitItemInBagSlot=lambda h,s:'item',
            BagCast_Spell63=lambda r:123,GetItemTypeId=lambda i:456,
            TimerGetElapsed=lambda t:state['now'],NativeCDClock='clock',GearWave_Arm=arms.append,
            BlzGetTriggerPlayerMouseButton=lambda:state['button'],MOUSE_BUTTON_TYPE_LEFT=0,
            MOUSE_BUTTON_TYPE_RIGHT=1,BlzIsMouseButtonPressed=lambda b:state['right'] if b==1 else state['left'])
        e=execute(BAG,['BagScreen_Click66','BagScreen_Event66','BagScreen_Poll66'],env)
        e['BagScreen_Event66']();state['now']=5.05;e['BagScreen_Poll66']()
        self.assertEqual(arms,[123]);self.assertTrue(e['BagHandled66'])
        state.update(left=False,now=5.3);e['BagScreen_Poll66']()
        state.update(left=True,now=5.5);e['BagScreen_Poll66']();self.assertEqual(arms,[123,123])
        state.update(button=1,right=True,left=False,now=6.);e['BagScreen_Event66']()
        self.assertTrue(e['BagMoving64'])
        state.update(button=0,right=False,left=True,now=6.3);e['BagScreen_Event66']()
        self.assertFalse(e['BagMoving64']);self.assertEqual(arms,[123,123])

    def test_ui_event_returns_before_stale_world_coordinates_can_clear_preview(self):
        v=View(ROOT/'release/development/QuickUI66/FFERPG-QuickUI66-Forsaken.w3x')
        env=dict(GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,GetTriggerEventId=lambda:1,
            EVENT_PLAYER_MOUSE_DOWN=1,EVENT_PLAYER_MOUSE_MOVE=2,BagHandled66=False)
        e=execute(v.runtime,['QuickGear_Mouse'],env)
        e['BagScreen_Event66']=lambda:e.update(BagHandled66=True)
        def forbidden():raise AssertionError('UI click reached world cast/cancel path')
        e['BlzGetTriggerPlayerMouseX']=forbidden;e['QuickGear_Mouse']()

    def test_water_damage_stops_at_800_plus_target_collision_only(self):
        v=View(ROOT/'release/development/QuickUI66/FFERPG-QuickUI66-Forsaken.w3x')
        e=execute(v.runtime,['Forsaken_WaterTouches'],dict(RMaxBJ=max,RMinBJ=min,RAbsBJ=abs))
        touch=e['Forsaken_WaterTouches']
        self.assertTrue(touch(800.,300.,0.,792.,800.))
        self.assertFalse(touch(800.,301.,0.,792.,800.))
        self.assertFalse(touch(801.,0.,0.,792.,800.))
        self.assertTrue(touch(816.,0.,16.,792.,800.))
        self.assertFalse(touch(817.,0.,16.,792.,800.))

    def test_three_ice_paths_have_96_unit_glyphs_and_no_large_circle_pool(self):
        for old,new in PAIRS:
            av=View(historical_map(ROOT, old));bv=View(historical_map(ROOT, new))
            a,b=functions(av.runtime),functions(bv.runtime)
            self.assertIn('96.,96.',b['Wave65_Init']);self.assertNotIn('442.',b['Wave65_Init'])
            self.assertIn('exitwhen i>63',b['Wave65_Init']);self.assertIn('exitwhen i>63',b['Wave65_Reset'])
            self.assertIn('ModuloInteger(i-1,21)',b['Wave65_Draw']);self.assertIn('1200.',b['Wave65_Draw'])
            for n in ('GearChat_Sent64','GearChat_Poll63','GearRaw_Poll64','QuickGear_Input',
                'QuickGear_Request','QuickGear_Receive','QuickGear_PaintIcon','QuickGear_RepaintIcons',
                'Forsaken_WaterTouches','Forsaken_WaterTick','Trig_Spell_Blizzaga_Loop','Trig_Spell_Blizzaga_Actions'):
                self.assertEqual(tokens(a[n]),tokens(b[n]),n)
            if 'DG_UIUpdate' in b:
                self.assertNotIn('Wave_Draw(',b['DG_UIUpdate'])
                self.assertNotIn('ShowImage',b['Wave_Draw'])
                diff={n for n in functions(av.modules['TDamage']) if tokens(a[n])!=tokens(b[n])}
                self.assertEqual(diff,{'Wave_Poll','Wave_Draw','DG_UIUpdate'})
            self.assertEqual(unsafe_paths(b,['BagScreen_Event66','BagScreen_Poll66','Wave65_Draw']),[])
            self.assertIn('FRAMEPOINT_CENTER,.4,.20',b['GearCursor_Error60'])
            self.assertIn('0.037',bv.archive.read('GearError66.fdf').decode())
            for asset in ('war3map.w3a','war3map.w3u','war3map.w3t','GearTarget61.tga'):
                self.assertEqual(av.archive.read(asset),bv.archive.read(asset))

if __name__=='__main__':unittest.main()

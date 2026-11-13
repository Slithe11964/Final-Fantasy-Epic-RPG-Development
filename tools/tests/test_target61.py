"""Cursor visibility fallback, pre-click tooltip capture, and passive wave arming."""
import sys,unittest,io
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from jtok import functions,tokens
from historical_map import historical_map
from editor_pair import View
from target_recovery61 import CURSOR
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Forsaken/GearBag61.j').read_text()


class TargetRecoveryTests(unittest.TestCase):
    def runtime(self):
        state=dict(down=False,text='|cff0088ffBook of Depths|r',tip=True,x=1200,y=300,time=10.,open=True)
        arms=[];clears=[]
        env=dict(GearBagNames61={1:'book of depths',2:'wateraga',3:'ice wand u'},
            GearBagCasts61={1:'A08X',2:'A0Q2',3:'A0UY'},GearBagNameCount61=3,
            GearBagText61={0:'title'},GearBagTextCount61=1,GearBagTip61='tip',GearBagUber61=None,
            GearBagHoverCast61=0,GearBagHoverAt61=-1.,GearBagHoverX61=0,GearBagHoverY61=0,
            GearBagNextRead61=0.,GearBagLeft61=False,GearBagArms61=0,GearBagLast61='',
            ForsakenLinkedBag='bag',ForsakenCachedEquipment=None,NativeCDClock='clock',
            QuickGearChatOpen=False,InventoryCinematicActive=False,QuickGearPending=-1,
            GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',IsUnitSelected=lambda *a:True,
            BlzIsLocalClientActive=lambda:True,BlzIsMouseButtonPressed=lambda b:state['down'],
            MOUSE_BUTTON_TYPE_LEFT='left',BlzFrameIsVisible=lambda f:state['open'] if f=='bag' else state['tip'],
            BlzFrameGetText=lambda f:state['text'],BlzGetMouseScreenPosX=lambda:state['x'],
            BlzGetMouseScreenPosY=lambda:state['y'],TimerGetElapsed=lambda t:state['time'],
            IMinBJ=min,IAbsBJ=abs,StringLength=len,SubString=lambda s,a,b:s[a:b],
            StringCase=lambda s,upper:s.upper() if upper else s.lower(),
            QuickGear_ClearPreview=lambda:clears.append(True),GearWave_Arm=arms.append)
        return execute(SOURCE,['GearBag_Normalize61','GearBag_Find61','GearBag_Poll61'],env),state,arms,clears

    def test_all_three_native_items_arm_even_when_click_hides_tooltip(self):
        for name,cast in [('Book of Depths','A08X'),('Wateraga','A0Q2'),('Ice Wand U','A0UY')]:
            env,state,arms,clears=self.runtime();state['text']='|cff0088ff'+name+'|r'
            env['GearBag_Poll61']();self.assertEqual(arms,[])
            state.update(down=True,tip=False,time=10.01);env['GearBag_Poll61']();env['GearBag_Poll61']()
            self.assertEqual(arms,[cast]);self.assertEqual(len(clears),1)
            self.assertEqual(env['GearBagArms61'],1)

    def test_snapshot_does_not_follow_pointer_into_world_or_survive_closed_bag(self):
        for changed in [{'x':1400},{'time':10.3},{'open':False}]:
            env,state,arms,clears=self.runtime();env['GearBag_Poll61']()
            state.update(down=True,tip=False,time=10.01);state.update(changed)
            env['GearBag_Poll61']();self.assertEqual(arms,[])

    def test_cursor_never_hides_os_pointer_for_missing_or_invisible_frame(self):
        for cursor,visible in [(None,False),('cursor',False),('cursor',True)]:
            enabled=[]
            env=dict(GearInputCursor=cursor,GearInputTarget=True,QuickGearPending=1,
                QuickGearChatOpen=False,InventoryCinematicActive=False,BlzIsLocalClientActive=lambda:True,
                BlzEnableCursor=enabled.append,GetHandleId=lambda f:123,
                BlzGetMouseScreenPosX=lambda:100,BlzGetMouseScreenPosY=lambda:200,
                BlzPixelToFrameX=lambda n:.3,BlzPixelToFrameY=lambda n:.4,
                FRAMEPOINT_CENTER='center',BlzFrameSetAbsPoint=lambda *a:None,
                BlzFrameSetVisible=lambda *a:None,BlzFrameIsVisible=lambda f:visible)
            env=execute(CURSOR,['GearInput_Cursor'],env);env['GearInput_Cursor']()
            self.assertEqual(enabled[-1],not (cursor is not None and visible))

    def test_preview_poll_has_no_cast_frame_discovery_or_native_click_path(self):
        body=functions(SOURCE)['GearBag_Poll61']
        for forbidden in ('UnitUseItem','BlzSendSyncData','BlzFrameClick','BlzGetFrameByName','BlzFrameGetChild','CreateTrigger','CreateTimer'):
            self.assertNotIn(forbidden,body)
        cache=functions(SOURCE)['GearBag_CacheTip61']
        self.assertNotIn('BlzFrameGetChildrenCount(child)',cache)

    def test_packaged_cursor_has_visible_pixels_and_preserves_casting(self):
        from PIL import Image
        for old,new in [('VersionEHotfix08/FFERPG-0.9.7.5e-Hotfix08-Forsaken','VersionEHotfix09/FFERPG-0.9.7.5e-Hotfix09-Forsaken'),
            ('QuickUI60/FFERPG-QuickUI60-Forsaken','QuickUI61/FFERPG-QuickUI61-Forsaken')]:
            before=View(historical_map(ROOT, old));after=View(historical_map(ROOT, new))
            a,b=functions(before.runtime),functions(after.runtime)
            for name in ('QuickGear_Receive','QuickGear_Request','QuickGear_Mouse','QuickGear_PaintIcon','QuickGear_RepaintIcons','Cine_Exit','Text_Caption'):
                self.assertEqual(tokens(a[name]),tokens(b[name]),name)
            if 'DG_Tick' in a:self.assertEqual(tokens(a['DG_Tick']),tokens(b['DG_Tick']))
            image=Image.open(io.BytesIO(after.archive.read('GearTarget61.tga'))).convert('RGBA')
            self.assertEqual(image.size,(32,32));self.assertIsNotNone(image.getchannel('A').getbbox())
            native=Image.open(ROOT/'tools/build-inputs/native-ui/humancursor.dds').convert('RGBA').crop((32,96,64,128))
            self.assertEqual(image.tobytes(),native.tobytes())
            self.assertIn('"BACKDROP"',b['GearInput_Init']);self.assertNotIn('GearTargetCursor60',b['GearInput_Init'])
            self.assertNotIn('GearInput_CacheBatch',b['GearInput_Init'])
            self.assertIn('GearBag_Poll61()',b['GearCursor_Draw60'])
            self.assertIn('FRAMEPOINT_CENTER,.4,.295',b['GearInput_Init'])
            fdf=after.archive.read('GearError61.fdf').decode()
            self.assertIn('FontColor 1.0 0.86 0.0 1.0',fdf);self.assertIn('FontShadowColor',fdf)
            for suffix in ('w3a','w3u','w3t'):
                for prefix in ('war3map.','war3mapSkin.'):
                    self.assertEqual(before.archive.read(prefix+suffix),after.archive.read(prefix+suffix))


if __name__=='__main__':unittest.main()

"""Casting recovery, passive bag preview arming, and isolated object-order changes."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from priest_master import fields
from damage_tooltips import merged
from test_armory_materia import execute
import test_native_gear57
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Forsaken/GearInput58.j').read_text()


class GearInputTests(unittest.TestCase):
    def test_hover_click_arms_wateraga_without_issuing_or_replacing_native_click(self):
        calls=[];state={'down':False,'bagitem':'Wateraga'}
        env=dict(GearInputLeft=False,GearInputHoverSlot=104,GearInputBagClicks=0,
            QuickGearPending=-1,QuickGearChatOpen=False,InventoryCinematicActive=False,
            ForsakenLinkedBag='bag',ForsakenCachedEquipment='equipment',NativeCDClock='clock',
            QuickGearData='quick',GearInputSpells='waves',
            BlzIsMouseButtonPressed=lambda b:state['down'],MOUSE_BUTTON_TYPE_LEFT='left',
            BlzIsLocalClientActive=lambda:True,Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
            IsUnitSelected=lambda *a:True,BlzFrameIsVisible=lambda f:True,
            BlzUnitItemInBagSlot=lambda u,s:state['bagitem'],GetItemTypeId=lambda i:i,
            LoadInteger=lambda t,p,c:'A0Q2' if t=='waves' and c=='Wateraga' else 0,
            GearWave_ModeFor=lambda cast:int(cast=='A0Q2'),QuickGear_ClearPreview=lambda:None,
            GearWave_Arm=lambda cast:calls.append(('preview',cast)),TimerGetElapsed=lambda t:10.,
            GearInput_Cursor=lambda:None,GearWave_Draw=lambda:None)
        env=execute(SOURCE,['GearInput_Poll'],env)
        env['GearInput_Poll']();self.assertEqual(calls,[])
        state['down']=True;env['GearInput_Poll']();env['GearInput_Poll']()
        self.assertEqual(calls,[('preview','A0Q2')]);self.assertEqual(env['QuickGearPending'],-1)
        self.assertEqual(env['GearInputBagClicks'],1)
        # The preview has no item-use, native-click or sync-send path.
        for forbidden in ('UnitUseItem','BlzFrameClick','BlzSendSyncData','FRAMEEVENT_CONTROL_CLICK'):
            self.assertNotIn(forbidden,functions(SOURCE)['GearInput_Poll'])
        hook=functions(SOURCE)['GearInput_Hook']
        self.assertNotIn('FRAMEEVENT_CONTROL_CLICK',hook)
        self.assertIn('FRAMEEVENT_MOUSE_ENTER',hook)

    def test_packaged_dispatch_and_balance_preservation(self):
        baseline=View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x')
        for folder,name,base in [('QuickUI58','FFERPG-QuickUI58-Forsaken','QuickUI56/FFERPG-QuickUI56-Forsaken'),
            ('VersionEHotfix06','FFERPG-0.9.7.5e-Hotfix06-Forsaken','VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-Forsaken')]:
            before=View(ROOT/f'release/development/{base}.w3x')
            suffix = '.unpacked.w3x' if folder in ('QuickUI58', 'VersionEHotfix06') else '.w3x'
            after=View(ROOT/f'release/development/{folder}/{name}{suffix}')
            fs=functions(after.modules['TEquip']);old=functions(baseline.modules['TEquip'])
            for n in ('QuickGear_PaintIcon','QuickGear_RepaintIcons','QuickGear_RefreshIcons','QuickGear_Draw'):
                self.assertEqual(tokens(fs[n]),tokens(old[n]))
            self.assertIn('call QuickGear_Send(',fs['QuickGear_Mouse'])
            self.assertIn('UnitUseItemPoint(hero,carried,x,y)',fs['QuickGear_Receive'])
            self.assertIn('UnitUseItemTarget(hero,carried,target)',fs['QuickGear_Receive'])
            self.assertNotIn('NativeGear_Click',fs);self.assertNotIn('QuickGear_BindWeaponCast',fs)
            self.assertTrue(after.archive.read('QuickGearTarget.tga'))
            self.assertIn('GearInputSpells',fs['GearInput_InitSpells'])
            self.assertIn("'A0Q2'",fs['GearInput_InitSpells'])
            a=merged(before.object_bytes('war3map.w3a'),before.object_bytes('war3mapSkin.w3a'),'w3a')
            b=merged(after.object_bytes('war3map.w3a'),after.object_bytes('war3mapSkin.w3a'),'w3a')
            orders=[];changed=0
            self.assertEqual(a.keys(),b.keys())
            for raw in a:
                fa,fb=fields(a[raw]),fields(b[raw])
                delta={key for key in fa.keys()|fb.keys() if fa.get(key)!=fb.get(key)}
                self.assertTrue(all(key[0]=='Ncl6' for key in delta),(raw,delta))
                if delta:orders.append(fb['Ncl6',1]);changed+=1
            self.assertGreater(changed,20);self.assertEqual(len(orders),len(set(orders)))

    def test_wave_geometry_uses_the_tested_standalone_renderer(self):
        test_native_gear57.NativeGearTests().test_standalone_wave_geometry_stops_at_spell_range()

    def test_target_cursor_is_explicitly_drawn_and_cancelled(self):
        shown=[];position=[]
        env=dict(GearInputCursor='cursor',GearInputTarget=True,QuickGearPending=1,
            QuickGearChatOpen=False,InventoryCinematicActive=False,
            BlzIsLocalClientActive=lambda:True,BlzGetMouseScreenPosX=lambda:1200,
            BlzGetMouseScreenPosY=lambda:500,BlzPixelToFrameX=lambda n:n/2000.,
            BlzPixelToFrameY=lambda n:.6-n/2000.,FRAMEPOINT_CENTER='center',
            BlzFrameSetAbsPoint=lambda *args:position.append(args),
            BlzFrameSetVisible=lambda f,b:shown.append(b),BlzEnableCursor=lambda b:None)
        env=execute(SOURCE,['GearInput_Cursor'],env)
        env['GearInput_Cursor']();self.assertEqual(shown,[True])
        self.assertEqual(position[-1],('cursor','center',.6,.35))
        env['QuickGearPending']=-1;env['GearInput_Cursor']();self.assertEqual(shown,[True,False])


if __name__=='__main__':unittest.main()

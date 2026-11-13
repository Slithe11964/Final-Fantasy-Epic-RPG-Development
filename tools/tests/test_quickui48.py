"""Exercise live swaps, input, wave geometry and the packaged spell objects."""
import math
import sys
import unittest
from collections import defaultdict
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
sys.path.insert(0,str(Path(__file__).resolve().parent))
import test_equipment_quickcast as gear_tests
from editor_pair import View
from damage_tooltips import merged
from priest_master import fields
from jtok import functions


class QuickUI48Tests(unittest.TestCase):
    def runtime(self):
        result=gear_tests.QuickCastTests().runtime()
        e=result[0]
        e.update(QuickGearRune={i:i for i in range(1,97)},ShowImage=lambda *a:None,
            QuickGearCursor=None,QuickGearNativePreview=False,QuickGearPath=0,
            BlzEnableCursor=lambda *a:None,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,
            ModuloInteger=lambda a,b:a%b,bj_DEGTORAD=math.pi/180.,
            GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,SetImagePosition=lambda *a:None)
        return result

    def test_both_live_icons_change_without_equip_event_and_hide_when_empty(self):
        e,s,w,db,calls,packets,v,textures=self.runtime()
        e['BlzGetItemIconPath']=lambda item:item+'-icon'
        e['QuickGear_Poll']()
        self.assertEqual((textures['fi'],textures['gi']),('weapon-icon','offhand-icon'))
        w[0]='new-primary';w[1]='new-offhand'
        raws={'new-primary':103,'new-offhand':104}
        e['GetItemTypeId']=lambda item:raws.get(item,0)
        db.update({(0,103):203,(0,104):204})
        e['QuickGear_Poll']()
        self.assertEqual((textures['fi'],textures['gi']),('new-primary-icon','new-offhand-icon'))
        w.clear();e['QuickGear_Poll']()
        self.assertFalse(v['F']);self.assertFalse(v['G'])
        self.assertFalse(v['fi']);self.assertFalse(v['gi']);self.assertFalse(v['dock'])

    def test_f_and_g_each_arm_the_equipped_target_spell(self):
        e,s,w,db,calls,packets,v,textures=self.runtime()
        db[1,101]=3
        s['key']='F';e['QuickGear_Input']()
        self.assertEqual(e['QuickGearPending'],0)
        self.assertTrue(e['QuickGearTargetPreview'])
        s['key']='G';e['QuickGear_Input']()
        self.assertEqual(e['QuickGearPending'],1)
        self.assertEqual(e['QuickGearPendingItem'],102)
        self.assertTrue(e['QuickGearTargetPreview'])
        e['QuickGear_Mouse']();s['data']=packets[-1];e['QuickGear_Receive']()
        self.assertEqual(calls[-1],('target',('hero','offhand','enemy')))

    def test_water_preview_marks_the_same_widening_800_unit_path(self):
        e,*_=self.runtime();positions={}
        e.update(QuickGearPath=1,QuickGearMouseKnown=True,QuickGearMouseX=800.,QuickGearMouseY=0.,
            SetImagePosition=lambda image,x,y,z:positions.__setitem__(image,(x+12.,y+12.)))
        e['QuickGear_MovePreview']()
        self.assertEqual(len(positions),96)
        self.assertEqual(positions[32],(800.,0.))
        self.assertEqual(positions[64],(800.,-300.))
        self.assertEqual(positions[96],(800.,300.))

    def test_target_cursor_is_drawn_in_screen_space_and_restores_on_escape(self):
        # The legacy quest harness floors every division, including reals.
        # Preserve real division for these explicitly converted pixel values.
        from unittest.mock import patch
        import test_quest_lifecycle as harness
        expression=harness.expression
        with patch.object(harness,'expression',lambda text:expression(text).replace('// I2R','/ I2R')):
            e,s,w,db,calls,packets,v,textures=self.runtime()
        cursor=[];points=[]
        e.update(QuickGearCursor='cursor',BlzGetMouseScreenPosX=lambda:960,
            BlzGetMouseScreenPosY=lambda:540,FRAMEPOINT_CENTER=0,
            BlzFrameSetAbsPoint=lambda *args:points.append(args),BlzEnableCursor=cursor.append)
        e['QuickGear_Request'](1)
        self.assertEqual(points[-1],('cursor',0,.4,.3))
        self.assertTrue(v['cursor']);self.assertFalse(cursor[-1])
        s['key']='esc';e['QuickGear_Input']()
        self.assertFalse(v['cursor']);self.assertTrue(cursor[-1])

    def test_local_ui_never_creates_gameplay_handles_or_issues_orders(self):
        from test_backpack_sync import unsafe_paths
        self.assertEqual(unsafe_paths(functions(gear_tests.SOURCE),
            ['QuickGear_Input','QuickGear_Click','QuickGear_Mouse','QuickGear_Poll','QuickGear_NativeClick']),[])

    def test_ice_preview_has_three_authored_wave_endpoints(self):
        e,*_=self.runtime();positions={}
        e.update(QuickGearPath=2,QuickGearMouseKnown=True,QuickGearMouseX=1000.,QuickGearMouseY=0.,
            SetImagePosition=lambda image,x,y,z:positions.__setitem__(image,(x+12.,y+12.)))
        e['QuickGear_MovePreview']()
        for image,angle in [(32,-11.25),(64,11.25),(96,33.75)]:
            self.assertAlmostEqual(positions[image][0],1000.*math.cos(math.radians(angle)))
            self.assertAlmostEqual(positions[image][1],1000.*math.sin(math.radians(angle)))

    def test_packaged_tooltips_damage_and_aqualung_channel(self):
        root=Path(__file__).resolve().parents[2]
        view=View(root/'release/development/QuickUI48/FFERPG-QuickUI48-Forsaken.w3x')
        abilities=merged(view.object_bytes('war3map.w3a'),view.object_bytes('war3mapSkin.w3a'),'w3a')
        for rank in range(1,7):
            self.assertIn('100 + 0.3 x AGI',fields(abilities['A0KY'])['aub1',rank])
        units=merged(view.object_bytes('war3map.w3u'),view.object_bytes('war3mapSkin.w3u'),'w3u')
        self.assertTrue(fields(units['H00C'])['utub',None].endswith('|cffbf80ffTier 5 Strength Warrior|r'))
        fs=functions(view.runtime)
        self.assertIn('100.+.3*I2R(GetHeroAgi',fs['Cuts_Damage'])
        self.assertIn('GetUnitX(target)+10.*dx/d',fs['DG_Impact'])
        self.assertNotIn('ShowUnitHide',fs['Trig_Aqualung_Cast_Actions'])
        self.assertIn('UnitApplyTimedLifeBJ(12.',fs['Trig_Aqualung_Cast_Actions'])
        for raw in ('f220','g104','q104','I025'):
            self.assertIn("SaveInteger(QuickGearData,0,'"+raw+"'",fs['QuickGear_Init'])
        self.assertTrue(view.archive.read('QuickGearTarget.tga'))
        self.assertTrue(view.archive.read('DragoonRune.tga'))


if __name__=='__main__':unittest.main()

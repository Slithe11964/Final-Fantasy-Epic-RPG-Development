"""The confirmed Dragoon rune bank now previews Wateraga and the three ice waves."""
import math
import sys
import unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions
from test_shared_context import mocks
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
from editor_pair import View
from release_gear import audit

ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Dragoon/WaveRunes.j').read_text()


class WaveRuneTests(unittest.TestCase):
    def runtime(self):
        data={};positions={};visible={};mouse=[900.,200.]
        ui=functions((ROOT/'experiments/Dragoon/DragoonUI.j').read_text())['DG_UIMouse']
        ui=ui.replace('endfunction',' call Wave_MouseCommit()\nendfunction')
        source=SOURCE+'\n'+ui
        env=mocks(source)
        env.update(Wave_Mode=0,Wave_FromGear=False,Wave_ClickCount=0,Wave_ArmedAt=-1.,NativeCDClock='clock',TimerGetElapsed=lambda timer:10.,QuickGearPending=-1,QuickGearPendingItem=0,QuickGearData='gear',Wave_Controls='controls',Wave_Spells='wave',DG_UIMode=0,
            DG_Rune={i:i for i in range(1,65)},DG_MouseX=900.,DG_MouseY=200.,
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,Player_GetHero=lambda p:1,
            GetWidgetLife=lambda u:1000.,IsUnitSelected=lambda *args:True,InventoryCinematicActive=False,
            BlzGetMouseFocusUnit=lambda:None,GetUnitX=lambda u:100.,GetUnitY=lambda u:200.,
            IsUnitEnemy=lambda *args:True,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,I2R=float,
            bj_DEGTORAD=math.pi/180.,ModuloInteger=lambda a,b:a%b,
            SetImagePosition=lambda image,x,y,z:positions.__setitem__(image,(x+12.,y+12.)),
            ShowImage=lambda image,show:visible.__setitem__(image,show),LoadInteger=lambda table,p,c:data.get(('wave',c),0) if table=='wave' else data.get((p,c),0),
            GetHandleId=lambda h:55,BlzGetTriggerFrame=lambda:'bag',GetItemTypeId=lambda item:item,
            BlzUnitItemInBagSlot=lambda hero,slot:'I025',UnitItemInSlot=lambda hero,slot:'I025',
            EVENT_PLAYER_MOUSE_MOVE=1,GetTriggerEventId=lambda:1,
            BlzGetTriggerPlayerMouseX=lambda:mouse[0],BlzGetTriggerPlayerMouseY=lambda:mouse[1])
        return execute(source,list(functions(source)),env),data,positions,visible,mouse

    def test_water_is_one_800_unit_line_and_moves_with_the_cursor(self):
        e,data,pos,visible,mouse=self.runtime();e['Wave_Mode']=1
        e['Wave_Draw'](1)
        self.assertEqual(sum(visible.values()),32)
        self.assertEqual(pos[1],(100.,200.));self.assertEqual(pos[32],(900.,200.))
        mouse[:]=[100.,1000.];e['DG_UIMouse']();e['Wave_Draw'](1)
        self.assertAlmostEqual(pos[32][0],100.)
        self.assertAlmostEqual(pos[32][1],1000.)
        e['DG_MouseY']=5000.;e['Wave_Draw'](1)
        self.assertAlmostEqual(pos[32][1],1000.)

    def test_ice_has_three_lines_at_the_authored_wave_angles(self):
        e,data,pos,visible,mouse=self.runtime();e['Wave_Mode']=2;e['Wave_Draw'](1)
        self.assertEqual(sum(visible.values()),63)
        for index,angle in [(21,-11.25),(42,11.25),(63,33.75)]:
            self.assertAlmostEqual(pos[index][0],100.+1000.*math.cos(math.radians(angle)))
            self.assertAlmostEqual(pos[index][1],200.+1000.*math.sin(math.radians(angle)))
        self.assertFalse(visible[64])

    def test_released_f_g_pending_state_arms_then_clears_the_overlay(self):
        e,data,pos,visible,mouse=self.runtime();data[0,'f220']='A08X'
        e.update(QuickGearPending=1,QuickGearPendingItem='f220');e['Wave_Poll']()
        self.assertEqual(e['Wave_Mode'],1);self.assertTrue(e['Wave_FromGear'])
        e['QuickGearPending']=-1;e['Wave_Poll']()
        self.assertEqual(e['Wave_Mode'],0)

    def test_clicking_wateraga_in_the_native_bag_arms_the_same_rune_bank(self):
        e,data,pos,visible,mouse=self.runtime();data[0,55]=100
        e['Wave_FrameClick']();e['Wave_Draw'](1)
        self.assertEqual(e['Wave_Mode'],1);self.assertFalse(e['Wave_FromGear'])
        self.assertEqual(sum(visible.values()),32)

    def test_overlay_callbacks_only_read_gameplay_and_draw_images(self):
        self.assertEqual(unsafe_paths(functions(SOURCE),['Wave_Draw','Wave_Poll','Wave_FrameClick','Wave_MouseCommit']),[])

    def test_packaged_f_g_matches_release_and_confirmed_gameplay_stays_identical(self):
        path=ROOT/'release/development/QuickUI50/FFERPG-QuickUI50-Forsaken.w3x'
        audit(path)
        before=View(ROOT/'release/development/QuickUI49/FFERPG-QuickUI49-Forsaken.w3x')
        after=View(path)
        fa,fb=functions(before.runtime),functions(after.runtime)
        for name in ('Cuts_Damage','Aqua_Pulse','Trig_Aqualung_Cast_Actions','DG_Impact'):
            from jtok import tokens
            self.assertEqual(tokens(fa[name]),tokens(fb[name]))
        for name in ('war3map.w3a','war3mapSkin.w3a','war3map.w3u','war3mapSkin.w3u','war3map.w3h'):
            self.assertEqual(before.archive.read(name),after.archive.read(name))
        self.assertIn('call Wave_Draw(u)',fb['DG_UIUpdate'])
        self.assertIn('call ExecuteFunc("Wave_Init")',fb['DG_UIInit'])


if __name__=='__main__':unittest.main()

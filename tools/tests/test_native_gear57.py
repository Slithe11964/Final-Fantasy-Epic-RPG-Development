"""Native equipment dispatch guards; engine cursor behavior still needs client testing."""
import sys
import unittest
import math
from collections import defaultdict
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from test_armory_materia import execute

ROOT=Path(__file__).resolve().parents[2]
NATIVE=(ROOT/'experiments/Forsaken/NativeGear57.j').read_text()


class NativeGearTests(unittest.TestCase):
    def runtime(self):
        events=[]
        gear={0:'wand',1:'book'}
        env=dict(NativeGearRoot=defaultdict(lambda:None,{17:'panel'}),
            NativeGearControl=defaultdict(lambda:None,{34:'weapon-button',35:'offhand-button'}),
            ForsakenCachedEquipment='panel',NativeGearClickCount=0,
            NativeGearWaiting=-1,NativeGearHero=None,NativeGearItem=None,
            NativeGearArmed=False,ForsakenBackpackKeyHeld=False,
            QuickGearRequests=0,QuickGearChatOpen=False,InventoryCinematicActive=False,
            ForsakenInventoryHero='hero',NativeCDClock='clock',ForsakenPanelClock='clock',
            NativeGearUntil=0.,Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
            QuickGear_Item=lambda hero,slot:gear.get(slot),IsUnitSelected=lambda *a:True,
            GetWidgetLife=lambda u:100.,TimerGetElapsed=lambda t:10.,
            BlzFrameGetEnable=lambda f:True,BlzFrameClick=lambda f:events.append(('click',f)),
            NativeGear_Arm=lambda slot:events.append(('arm',slot)),
            QuickGear_ClearPreview=lambda:None,GearWave_Clear=lambda:None,
            GearWave_Draw=lambda:None,BlzIsLocalClientActive=lambda:True,
            ForceUIKey=lambda key:events.append(('key',key)),
            DisplayTimedTextToPlayer=lambda *args:events.append(('message',args[-1])))
        env=execute(NATIVE,['NativeGear_Click','NativeGear_Cancel','NativeGear_Request','NativeGear_Tick'],env)
        return env,gear,events

    def test_each_shortcut_clicks_exact_native_equipment_control(self):
        env,gear,events=self.runtime()
        env['NativeGear_Request'](0);env['NativeGear_Request'](1)
        self.assertEqual(events,[('arm',0),('click','weapon-button'),('arm',1),('click','offhand-button')])
        self.assertEqual(gear,{0:'wand',1:'book'})

    def test_unbound_hero_binds_once_then_clicks_captured_slot(self):
        env,gear,events=self.runtime();env['ForsakenInventoryHero']=None
        env['NativeGear_Request'](1)
        self.assertEqual(events,[('key','B')])
        env['NativeGear_Tick']();self.assertEqual(events,[('key','B')])
        env['ForsakenInventoryHero']='hero';env['NativeGear_Tick']()
        self.assertEqual(events[-2:],[('arm',1),('click','offhand-button')])
        self.assertEqual(env['NativeGearWaiting'],-1)

    def test_equipment_swap_or_focus_loss_cancels_queued_click(self):
        for focus_lost in (False,True):
            env,gear,events=self.runtime();env['ForsakenInventoryHero']=None
            env['NativeGear_Request'](0)
            if focus_lost:env['BlzIsLocalClientActive']=lambda:False
            else:gear[0]='replacement'
            env['ForsakenInventoryHero']='hero';env['NativeGear_Tick']()
            self.assertEqual(events,[('key','B')]);self.assertEqual(env['NativeGearWaiting'],-1)

    def test_disabled_control_does_not_cast_or_force_backpack(self):
        env,gear,events=self.runtime();env['BlzFrameGetEnable']=lambda f:False
        env['NativeGear_Request'](0);self.assertEqual(events,[])

    def test_input_path_has_no_manual_cast_or_frame_discovery(self):
        fs=functions(NATIVE)
        path='\n'.join(fs[n] for n in ('NativeGear_Click','NativeGear_Request','NativeGear_Tick','NativeGear_Arm','NativeGear_Cancel'))
        for forbidden in ('UnitUseItem','BlzItemAddAbility','BlzItemRemoveAbility','UnitRemoveItem','UnitAddItem','BlzGetFrameByName','BlzFrameGetChild','CreateTrigger','CreateTimer'):
            self.assertNotIn(forbidden,path)
        for folder,name in [('QuickUI57','FFERPG-QuickUI57-Forsaken'),('VersionEHotfix05','FFERPG-0.9.7.5e-Hotfix05-Forsaken')]:
            current=functions(View(ROOT/f'release/development/{folder}/{name}.w3x').modules['TEquip'])
            self.assertNotIn('QuickGear_Send',current['QuickGear_Mouse'])
            self.assertNotIn('QuickGear_BindWeaponCast',current)
            base=functions(View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x').modules['TEquip'])
            for preserved in ('QuickGear_PaintIcon','QuickGear_RepaintIcons','QuickGear_RefreshIcons','QuickGear_Draw'):
                self.assertEqual(tokens(current[preserved]),tokens(base[preserved]))

    def test_standalone_wave_geometry_stops_at_spell_range(self):
        source=(ROOT/'experiments/Forsaken/GearWave57.j').read_text()
        positions={};visible={}
        env=dict(GearWaveRune={i:i for i in range(1,65)},GearWaveMode=1,
            QuickGearMouseX=900.,QuickGearMouseY=200.,QuickGearChatOpen=False,
            InventoryCinematicActive=False,Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
            IsUnitSelected=lambda *args:True,BlzIsLocalClientActive=lambda:True,
            BlzGetMouseFocusUnit=lambda:None,GetUnitX=lambda u:100.,GetUnitY=lambda u:200.,
            Atan2=math.atan2,Cos=math.cos,Sin=math.sin,I2R=float,ModuloInteger=lambda a,b:a%b,
            bj_DEGTORAD=math.pi/180.,ShowImage=lambda i,v:visible.__setitem__(i,v),
            SetImagePosition=lambda i,x,y,z:positions.__setitem__(i,(x+12.,y+12.)))
        env=execute(source,['GearWave_Clear','GearWave_Draw'],env)
        env['GearWave_Draw']();self.assertEqual(sum(visible.values()),32)
        self.assertEqual(positions[32],(900.,200.))
        env['QuickGearMouseX']=100.;env['QuickGearMouseY']=5000.;env['GearWave_Draw']()
        self.assertAlmostEqual(positions[32][0],100.);self.assertAlmostEqual(positions[32][1],1000.)
        env['QuickGearMouseX']=900.;env['QuickGearMouseY']=200.;env['GearWaveMode']=2
        env['GearWave_Draw']();self.assertEqual(sum(visible.values()),63)
        for i,angle in [(21,-11.25),(42,11.25),(63,33.75)]:
            self.assertAlmostEqual(positions[i][0],100.+1000.*math.cos(math.radians(angle)))
            self.assertAlmostEqual(positions[i][1],200.+1000.*math.sin(math.radians(angle)))


if __name__=='__main__':unittest.main()

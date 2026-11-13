"""Cursor feedback and native skin identity; client visuals remain acceptance tests."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from historical_map import historical_map
from editor_pair import View
from jtok import functions,tokens
from gear_target60 import refresh,SKIN
from test_armory_materia import execute
ROOT=Path(__file__).resolve().parents[2]


class TargetTests(unittest.TestCase):
    def test_empty_ground_keeps_unit_item_armed_without_sending_a_cast(self):
        base=View(ROOT/'release/development/VersionEHotfix07/FFERPG-0.9.7.5e-Hotfix07-Forsaken.w3x')
        source=refresh(base.modules['TEquip']);warnings=[];casts=[];clears=[]
        state={'target':None}
        env=dict(GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,
            GetTriggerEventId=lambda:'click',EVENT_PLAYER_MOUSE_MOVE='move',
            BlzGetTriggerPlayerMouseButton=lambda:'left',MOUSE_BUTTON_TYPE_RIGHT='right',MOUSE_BUTTON_TYPE_LEFT='left',
            QuickGearPending=1,QuickGearPendingItem=101,QuickGearPendingHero=77,QuickGearPendingMark=6,
            QuickGearData='data',BlzGetMouseFocusUnit=lambda:state['target'],GetHandleId=lambda u:123,
            BlzGetTriggerPlayerMouseX=lambda:500.,BlzGetTriggerPlayerMouseY=lambda:600.,
            LoadInteger=lambda t,p,c:1,GearCursor_Error60=warnings.append,
            QuickGear_Send=lambda *args:casts.append(args),QuickGear_ClearPreview=lambda:clears.append(True))
        env=execute(source,['QuickGear_Mouse'],env)
        env['QuickGear_Mouse']()
        self.assertEqual(warnings,['Must target a unit with this action.'])
        self.assertEqual(env['QuickGearPending'],1);self.assertEqual(casts,[]);self.assertEqual(clears,[])
        state['target']='enemy';env['QuickGear_Mouse']()
        self.assertEqual(len(casts),1);self.assertEqual(casts[0][4],123)
        self.assertEqual(env['QuickGearPending'],-1)

    def test_skin_changes_only_dragoon_and_only_when_needed(self):
        skins={'hero':'H00C','other':'H00A'};calls=[]
        env=dict(GetUnitTypeId=lambda u:'H00C' if u=='hero' else 'H00A',
            BlzGetUnitSkin=lambda u:skins[u],
            BlzSetUnitSkin=lambda u,raw:(skins.__setitem__(u,raw),calls.append((u,raw))))
        env=execute(SKIN,['DG_GraphicsSkin60'],env)
        env['DG_GraphicsSkin60']('hero');env['DG_GraphicsSkin60']('hero');env['DG_GraphicsSkin60']('other')
        self.assertEqual(calls,[('hero','hctg')]);self.assertEqual(skins['other'],'H00A')

    def test_error_is_ui_text_and_cursor_has_its_own_fast_clock(self):
        base=View(ROOT/'release/development/VersionEHotfix07/FFERPG-0.9.7.5e-Hotfix07-Forsaken.w3x')
        fs=functions(refresh(base.modules['TEquip']))
        self.assertNotIn('DisplayTimedText',fs['GearCursor_Error60'])
        self.assertIn('BlzFrameSetText(GearCursorError60,message)',fs['GearCursor_Error60'])
        self.assertIn('TimerStart(GearCursorTimer60,.01,true,function GearCursor_Draw60)',fs['GearInput_Init'])
        self.assertIn('DestroyTimer(GearCursorTimer60)',fs['GearInput_Reset'])
        self.assertNotIn('QuickGearTarget.tga',fs['GearInput_Init'])

    def test_packaged_art_and_casting_preservation(self):
        from damage_tooltips import merged
        from priest_master import fields
        for old,new in [('VersionEHotfix07/FFERPG-0.9.7.5e-Hotfix07-Forsaken','VersionEHotfix08/FFERPG-0.9.7.5e-Hotfix08-Forsaken'),
            ('QuickUI59/FFERPG-QuickUI59-Forsaken','QuickUI60/FFERPG-QuickUI60-Forsaken')]:
            before=View(historical_map(ROOT, old));after=View(historical_map(ROOT, new))
            a,b=functions(before.runtime),functions(after.runtime)
            for name in ('QuickGear_Receive','QuickGear_Request','QuickGear_PaintIcon','QuickGear_RepaintIcons','Text_Caption','Cine_Exit'):
                self.assertEqual(tokens(a[name]),tokens(b[name]),name)
            fdf=after.archive.read('GearTarget60.fdf').decode()
            self.assertIn('UseActiveContext',fdf);self.assertIn('HumanCursor.dds',fdf)
            self.assertIn('TexCoord 0, 0.125, 0.25, 0.5',fdf)
            if 'DG_Tick' in a:
                self.assertIn('call DG_GraphicsSkin60(u)',b['DG_Tick'])
                units=merged(after.object_bytes('war3map.w3u'),after.object_bytes('war3mapSkin.w3u'),'w3u')
                self.assertEqual(fields(units['H00C'])['umdl',None],'Units\\Human\\Footman\\Footman.mdl')
            for resource in ('war3map.w3a','war3mapSkin.w3a','war3map.w3t','war3mapSkin.w3t'):
                self.assertEqual(before.archive.read(resource),after.archive.read(resource),resource)


if __name__=='__main__':unittest.main()

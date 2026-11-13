"""Check repaint timing, visibility preservation and unchanged casting."""
import sys
import unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from gear_icons55 import refresh
from test_armory_materia import execute
import test_quickui54

ROOT=Path(__file__).resolve().parents[2]


class RepaintTests(unittest.TestCase):
    def runtime(self):
        env,state,worn,art,raw,textures,paints=test_quickui54.IconRefreshTests().runtime()
        visibility={'dock':True};events=[];presented={}
        def show(frame,value):
            visibility[frame]=value;events.append((frame,value))
            if frame=='dock' and value:
                presented.update({key:textures[key] for key in ('fi','gi') if key in textures})
        env.update(BlzFrameIsVisible=lambda f:visibility.get(f,False),BlzFrameSetVisible=show,
            QuickGearShownKey=defaultdict(int,{0:70,1:71}),QuickGearCustomKeys=False,
            QuickGearShown=True)
        base=View(ROOT/'release/development/QuickUI54/FFERPG-QuickUI54-Forsaken.w3x')
        source=refresh(base.modules['TEquip'])
        env=execute(source,['QuickGear_RepaintIcons','QuickGear_PaintIcon','QuickGear_RefreshIcons','QuickGear_WheelTick'],env)
        return env,state,worn,textures,visibility,events,presented

    def test_idle_wheel_tick_refreshes_and_repaints_before_early_return(self):
        env,state,worn,textures,visibility,events,presented=self.runtime()
        env['QuickGear_WheelTick']()
        self.assertEqual(presented['gi'],'book-water.blp')
        events.clear();env['QuickGearPending']=1
        worn[1]='tremors'
        env['QuickGear_WheelTick']()
        self.assertEqual(presented['gi'],'book-earth.blp')
        self.assertEqual(events,[('dock',False),('dock',True)])
        self.assertEqual(env['QuickGearPending'],1)
        self.assertTrue(visibility['dock'])
        events.clear();env['QuickGear_WheelTick']()
        self.assertEqual(events,[])

    def test_icons_are_painted_before_a_native_cooldown_render_failure(self):
        env,state,worn,textures,visibility,events,presented=self.runtime()
        env['QuickGearEnds'].update({0:100.,1:100.})
        env['QuickGear_DrawWheel']=lambda *args:(_ for _ in ()).throw(RuntimeError('native draw failed'))
        worn[1]='tremors'
        with self.assertRaisesRegex(RuntimeError,'native draw failed'):env['QuickGear_WheelTick']()
        self.assertEqual(presented['gi'],'book-earth.blp')
        self.assertEqual((env['QuickGearEnds'][0],env['QuickGearEnds'][1]),(100.,100.))

    def test_hidden_panel_is_not_shown_by_an_icon_change(self):
        env,state,worn,textures,visibility,events,presented=self.runtime()
        visibility['dock']=False
        env['QuickGear_WheelTick']()
        self.assertFalse(visibility['dock'])
        self.assertEqual(events,[])
        self.assertEqual(textures['gi'],'book-water.blp')

    def test_packaged_scope_and_casting_are_preserved(self):
        old=View(ROOT/'release/development/QuickUI54/FFERPG-QuickUI54-Forsaken.w3x')
        new=View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x')
        a,b=functions(old.runtime),functions(new.runtime)
        self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},
            {'QuickGear_PaintIcon','QuickGear_WheelTick','QuickGear_Diagnostic'})
        self.assertEqual(set(b)-set(a),{'QuickGear_RepaintIcons'})
        self.assertLess(b['QuickGear_WheelTick'].index('call QuickGear_RefreshIcons'),b['QuickGear_WheelTick'].index('if not QuickGearShown'))
        for module in old.modules:
            if module!='TEquip':self.assertEqual(old.modules[module],new.modules[module])
        for name in old.archive.read('(listfile)').decode().splitlines():
            if name.lower() in ('(listfile)','(attributes)','(signature)','war3map.j','war3map.wct','war3map.wts'):continue
            self.assertEqual(old.archive.read(name),new.archive.read(name),name)


if __name__=='__main__':unittest.main()

"""Exercise icon swaps despite stale native art/cached panels, preserving UI53."""
import sys
import unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from damage_tooltips import merged
from jtok import functions,tokens
from gear_icons54 import refresh
from test_armory_materia import execute
import test_quickui53

ROOT=Path(__file__).resolve().parents[2]


class IconRefreshTests(unittest.TestCase):
    def runtime(self):
        env,state,worn,db,calls,packets,visible,textures=test_quickui53.RecoveryTests().runtime()
        base=View(ROOT/'release/development/QuickUI53/FFERPG-QuickUI53-Forsaken.w3x')
        items=merged(base.object_bytes('war3map.w3t'),base.object_bytes('war3mapSkin.w3t'),'w3t')
        source=refresh(base.modules['TEquip'],items)
        art={101:'weapon.blp',102:'book-water.blp',103:'new-weapon.blp',104:'book-earth.blp'}
        raw={'weapon':101,'offhand':102,'newweapon':103,'tremors':104}
        paints=[]
        def paint(frame,path,*args):
            textures[frame]=path
            if frame in ('fi','gi','new-gi'):paints.append((frame,path))
        env.update(QuickGearIconPaths='art',QuickGearPaintedPath=defaultdict(str),
            QuickGearPaintedItem=defaultdict(lambda:None),QuickGearPaintedFrame=defaultdict(lambda:None),
            LoadStr=lambda table,parent,key:art.get(key,''),GetItemTypeId=lambda item:raw.get(item,0),
            BlzGetItemIconPath=lambda item:'STALE-NATIVE-ICON.blp',BlzFrameSetTexture=paint)
        env=execute(source,[n for n in functions(source) if n.startswith('QuickGear_')],env)
        return env,state,worn,art,raw,textures,paints

    def test_both_icons_refresh_with_stale_native_art_and_no_panel_redraw(self):
        env,state,worn,art,raw,textures,paints=self.runtime()
        env['QuickGear_Poll']()
        self.assertEqual((textures['fi'],textures['gi']),('weapon.blp','book-water.blp'))
        # Deliberately keep the old panel revision/draw path. Icon painting must
        # operate independently, rather than relying on the rejected solution.
        env['QuickGear_SlotsChanged']=lambda hero:False
        env['QuickGear_Draw']=lambda *args:self.fail('icon swap required a panel redraw')
        env['QuickGearEnds'].update({0:75.,1:100.})
        env['QuickGearPending']=1
        worn.update({0:'newweapon',1:'tremors'})
        env['QuickGear_Poll']()
        self.assertEqual((textures['fi'],textures['gi']),('new-weapon.blp','book-earth.blp'))
        self.assertEqual((env['QuickGearEnds'][0],env['QuickGearEnds'][1]),(75.,100.))
        self.assertEqual(env['QuickGearPending'],1)

    def test_same_handle_changed_art_and_recreated_owned_texture_are_repainted(self):
        env,state,worn,art,raw,textures,paints=self.runtime()
        env['QuickGear_RefreshIcons']('hero')
        art[102]='book-earth.blp'
        env['QuickGear_RefreshIcons']('hero')
        self.assertEqual(textures['gi'],'book-earth.blp')
        env['QuickGearIcon'][1]='new-gi'
        env['QuickGear_RefreshIcons']('hero')
        self.assertEqual(textures['new-gi'],'book-earth.blp')
        count=len(paints)
        env['QuickGear_RefreshIcons']('hero')
        self.assertEqual(len(paints),count)

    def test_unknown_inherited_art_falls_back_and_empty_slot_clears_paint_cache(self):
        env,state,worn,art,raw,textures,paints=self.runtime()
        art.pop(102)
        env['QuickGear_RefreshIcons']('hero')
        self.assertEqual(textures['gi'],'STALE-NATIVE-ICON.blp')
        worn.pop(1);env['QuickGear_RefreshIcons']('hero')
        self.assertIsNone(env['QuickGearPaintedItem'][1])
        self.assertEqual(env['QuickGearPaintedPath'][1],'')
        art[102]='book-water.blp';worn[1]='offhand'
        env['QuickGear_RefreshIcons']('hero')
        self.assertEqual(textures['gi'],'book-water.blp')

    def test_packaged_change_is_only_icon_refresh_and_real_book_art(self):
        old=View(ROOT/'release/development/QuickUI53/FFERPG-QuickUI53-Forsaken.w3x')
        new=View(ROOT/'release/development/QuickUI54/FFERPG-QuickUI54-Forsaken.w3x')
        a,b=functions(old.runtime),functions(new.runtime)
        changed={n for n in a if tokens(a[n])!=tokens(b[n])}
        self.assertEqual(changed,{'QuickGear_Draw','QuickGear_Poll','QuickGear_Init'})
        source=new.modules['TEquip']
        self.assertIn('SaveStr(QuickGearIconPaths,0,\'f221\',"ReplaceableTextures\\\\CommandButtons\\\\BTNBookEarth.blp")',source)
        self.assertIn('SaveStr(QuickGearIconPaths,0,\'f220\',"ReplaceableTextures\\\\CommandButtons\\\\BTNBookWater.blp")',source)
        for name in old.modules:
            if name!='TEquip':self.assertEqual(old.modules[name],new.modules[name],name)
        for name in old.archive.read('(listfile)').decode().splitlines():
            if name.lower() in ('(listfile)','(attributes)','(signature)','war3map.j','war3map.wct','war3map.wts'):continue
            self.assertEqual(old.archive.read(name),new.archive.read(name),name)


if __name__=='__main__':unittest.main()

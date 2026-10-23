"""Disabled custom gear images must exist and visibly differ from ready images."""
import io,sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from PIL import Image,ImageStat
from editor_pair import View
from equipment_integrity import catalogue
from equipment_quickcast import catalogue as active_items
from priest_master import fields
ROOT=Path(__file__).resolve().parents[2]

class DisabledGearIcons(unittest.TestCase):
    def test_custom_active_icons_have_darker_disabled_images(self):
        view=View(ROOT/'release/development/QuickUI12/FFERPG-QuickUI12-Forsaken.w3x')
        config=catalogue(View(ROOT/'editor/FFERPG-Editor-Master.w3x'))
        icons={str(fields(config['items'][raw]).get(('iico',None),'')) for raw in active_items(config) if raw in config['items']}
        checked=0
        for icon in icons:
            normal=view.archive.read(icon) if icon else None
            if not normal:continue
            path='ReplaceableTextures\\CommandButtonsDisabled\\DIS'+icon.replace('/','\\').rsplit('\\',1)[-1]
            disabled=view.archive.read(path)
            self.assertIsNotNone(disabled,path)
            with Image.open(io.BytesIO(normal)) as a,Image.open(io.BytesIO(disabled)) as b:
                ready=sum(ImageStat.Stat(a.convert('RGB')).mean)
                dark=sum(ImageStat.Stat(b.convert('RGB')).mean)
                self.assertLess(dark,ready*.75,path)
            checked+=1
        self.assertEqual(checked,19)

if __name__=='__main__':unittest.main()

"""The cooldown art is native BLP1, retains alpha, and is registered for import."""
from pathlib import Path
import struct,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from quickgear_wheel import assets,add_assets,import_entries,ROOT
from mpq import MPQ
from PIL import Image
REPO=Path(__file__).resolve().parents[2]

class GearAssetTests(unittest.TestCase):
    def test_blp1_alpha_pixels_and_full_mip_chains(self):
        packed=assets();self.assertEqual(len(packed),366)
        for name,data in packed.items():
            self.assertEqual(data[:4],b'BLP1')
            self.assertEqual(struct.unpack_from('<6I',data,4),(1,8,64,64,4,1))
            offsets=struct.unpack_from('<16I',data,28);sizes=struct.unpack_from('<16I',data,92)
            position=1180
            for level in range(7):
                self.assertEqual(offsets[level],position)
                self.assertEqual(sizes[level],2*(64>>level)**2)
                position+=sizes[level]
            self.assertEqual(position,len(data));self.assertEqual(offsets[7:],(0,)*9)
        for source,target in [('Number34.tga','QuickGearNumber34.blp'),('CD00.tga','QuickGearWheelCD00.blp'),('CD64.tga','QuickGearWheelCD64.blp')]:
            data=packed['war3mapImported/'+target]
            offset=struct.unpack_from('<I',data,28)[0]
            indices=data[offset:offset+4096];alpha=data[offset+4096:offset+8192]
            decoded=bytearray()
            for index,a in zip(indices,alpha):
                blue,green,red,_=data[156+index*4:160+index*4]
                decoded.extend((red,green,blue,a))
            with Image.open(ROOT/source) as image:self.assertEqual(bytes(decoded),image.convert('RGBA').tobytes())

    def test_import_list_preserves_existing_entries_and_replaces_old_art(self):
        archive=MPQ(str(REPO/'release/development/QuickUI04/FFERPG-QuickUI04-Forsaken.w3x'))
        old=import_entries(archive.read('war3map.imp'));replacements={}
        add_assets(replacements,archive)
        new=import_entries(replacements['war3map.imp'])
        if '.tga"' in (ROOT.parent/'QuickGear.fdf').read_text():
            self.assertTrue(set(old)<=set(new))
            tgas={name:data for name,data in replacements.items() if name.endswith('.tga') and data is not None}
            self.assertEqual(len(tgas),366)
            self.assertEqual(tgas['war3mapImported/QuickGearNumber34.tga'],(ROOT/'Number34.tga').read_bytes())
            self.assertNotIn('war3mapImported/QuickGearNumber34.blp',replacements)
            return
        self.assertTrue(set(old)<=set(new))
        paths={name.replace('\\','/'):flag for flag,name in new}
        for name,data in assets().items():
            self.assertEqual(paths[name],13);self.assertEqual(replacements[name],data)
        self.assertEqual(paths['war3mapImported/QuickGear.fdf'],13)
        self.assertIsNone(replacements['war3mapImported/QuickGearNumber34.tga'])
        keys=list(replacements)
        self.assertLess(keys.index('war3mapImported/QuickGearNumber34.tga'),keys.index('war3mapImported/QuickGearNumber34.blp'))
        occupied=sum(entry[4] not in (0xFFFFFFFF,0xFFFFFFFE) for entry in archive.ht)
        added=sum(value is not None and archive.block_index(name) is None for name,value in replacements.items())
        deleted=sum(value is None and archive.block_index(name) is not None for name,value in replacements.items())
        self.assertLess(occupied+added-deleted,len(archive.ht))

if __name__=='__main__':unittest.main()

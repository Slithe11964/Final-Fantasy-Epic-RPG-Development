from pathlib import Path
from collections import defaultdict
import json,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_asset_gallery import ROOT,BASE,OUT,city_plans
from asset_gallery_catalogue import HD
from mpq import MPQ
from objdata import read_objects
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks

SOURCE=(ROOT/'experiments/AssetGallery/AssetGallery.j').read_text()

class AssetGalleryTests(unittest.TestCase):
    def test_catalogue_models_are_unused_named_hd_files_and_unique(self):
        c=json.loads((ROOT/'experiments/AssetGallery/catalogue.json').read_text());names=set(json.loads((ROOT/'tools/build-inputs/asset-gallery/casc-names.json').read_text()))
        self.assertEqual(len({m['path'] for m in c['models']}),len(c['models']))
        self.assertEqual([m['id'] for m in c['models']],list(range(1,len(c['models'])+1)))
        for m in c['models']:
            self.assertFalse(m['used']);self.assertIn(HD+m['path'],names)
        for g in range(1,8):
            ids=[m['id'] for m in c['models'] if m['group']==g]
            self.assertEqual(ids,list(range(min(ids),max(ids)+1)))

    def test_city_layouts_are_bounded_and_reference_actual_world_assets(self):
        c=json.loads((ROOT/'experiments/AssetGallery/catalogue.json').read_text());paths={m['path'] for m in c['all_world_models']}
        cities=city_plans(paths);self.assertEqual(len(cities),4)
        for name,rows in cities:
            self.assertGreater(len(rows),40);self.assertLess(len(rows),100)
            for row in rows:
                self.assertIn(row['path'],paths);self.assertLess(abs(row['x']),3500);self.assertLess(abs(row['y']),3500)

    def test_native_metadata_and_player_configuration_are_preserved(self):
        b=MPQ(str(BASE));m=MPQ(str(OUT))
        for name in ['war3map.w3i','war3mapMap.blp','war3mapPreview.tga','war3map.imp']:self.assertEqual(m.read(name),b.read(name),name)
        a=functions(b.read('war3map.j').decode());z=functions(m.read('war3map.j').decode())
        for name in ['config','InitCustomTeams','InitCustomPlayerSlots','InitAllyPriorities']:self.assertEqual(tokens(a[name]),tokens(z[name]),name)
        self.assertNotIn('Forsaken_PollPanels',z)

    def test_curator_and_icon_card_buttons_do_not_overlap(self):
        m=MPQ(str(OUT));units={o['id']:fields(o) for o in read_objects(m.read('war3map.w3u'),'w3u')['custom']};abilities={o['id']:fields(o) for o in read_objects(m.read('war3map.w3a'),'w3a')['custom']}
        for raw,native_slots in [('YEXP',{(0,0),(1,0),(2,0),(0,1)}),('yICO',set())]:
            used=set(native_slots)
            for skill in units[raw]['uabi',None].split(','):
                if skill=='Avul':continue
                f=abilities[skill];slot=(f['abpx',0],f['abpy',0]);self.assertNotIn(slot,used,(raw,skill));used.add(slot)
                self.assertEqual(f['Ncl1',1],0.);self.assertEqual(f['Ncl5',1],0)
            if raw=='yICO':self.assertEqual(len(used),12)

    def test_page_step_is_mode_aware_and_city_wraps(self):
        for mode,key in [(0,'GalPage'),(1,'GalIconPage')]:
            calls=[];e=mocks(SOURCE);e.update(GalMode=mode,GalPage=2,GalIconPage=2,GalCity=1,ModuloInteger=lambda a,b:a%b,Gal_ShowModels=lambda:calls.append('models'),Gal_ShowIcons=lambda:calls.append('icons'),Gal_ShowCity=lambda:calls.append('city'))
            e=execute(SOURCE,['Gal_Step'],e);e['Gal_Step'](1);self.assertEqual(e[key],3);self.assertEqual(len(calls),1)
        e['GalMode']=2;e['GalCity']=4;e['Gal_Step'](1);self.assertEqual(e['GalCity'],1)
        e['Gal_Step'](-1);self.assertEqual(e['GalCity'],4)

    def test_search_is_batched_and_finds_late_results(self):
        paths=defaultdict(lambda:'units\\test\\none.mdx');paths[101]='units\\other\\elftest.mdx';calls=[]
        e=mocks(SOURCE);e.update(GalSearchMode=0,GalSearchCursor=1,GalSearchWord='elftest',GalSearchTimer='search',GalSearchUser=0,GalUser=0,GalPage=0,GalCategory=1,GalModelCount=101,GalPath=paths,GalGroup=defaultdict(lambda:1),GalFirst={1:1},StringLength=len,SubString=lambda s,a,b:s[a:b],I2S=str,Gal_ShowModels=lambda:calls.append('models'),Gal_Message=lambda p,t:calls.append(t))
        e=execute(SOURCE,['Gal_SearchChunk'],e)
        e['Gal_SearchChunk']();self.assertEqual(e['GalSearchCursor'],49);self.assertFalse(calls)
        e['Gal_SearchChunk']();self.assertEqual(e['GalSearchCursor'],97)
        e['Gal_SearchChunk']();self.assertEqual(e['GalPage'],4);self.assertIn('models',calls)

    def test_local_blocks_only_change_camera_and_selection(self):
        import re
        blocks=re.findall(r'if GetLocalPlayer\(\)==[^\n]+ then\n(.*?)endif',SOURCE,re.S)
        self.assertEqual(len(blocks),3)
        for block in blocks:
            for unsafe in ['CreateUnit','CreateTimer','CreateTrigger','SetUnit','RemoveUnit','Destroy','SetTerrain']:self.assertNotIn(unsafe,block)
        self.assertNotIn('BlzCreateFrame',SOURCE)

if __name__=='__main__':unittest.main()

"""Coverage and isolation gates for the separate creature review map."""
import sys,re,json,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from jtok import functions
from build_creature_review import BASE,OUT

class CreatureReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.base=MPQ(str(BASE));cls.map=MPQ(str(OUT))
        cls.source=cls.map.read('war3map.j').decode()
        cls.fs=functions(cls.source)
        cls.catalogue=json.loads((OUT.parent/'Creature-Catalogue.json').read_text())

    def test_every_taxonomy_creature_is_catalogued(self):
        original=self.base.read('war3map.j').decode()
        taxonomy=set(re.findall(r"set udg_MonsterTypeID\s*=\s*'(.{4})'",original))
        entries={r['raw'] for r in self.catalogue['creatures'] if r['valid_object']}
        self.assertEqual(len(taxonomy),275)
        self.assertFalse(taxonomy-entries)

    def test_boundary_duplicates_match_authored_pools(self):
        expected={1:{'nrvd','n0N3'},2:{'nslr','n0L6'},3:{'nvdg','n0N1'},4:{'nmgw','nmgr'},5:{'n0L6','nrvd'},6:{'n0N1','nvdg','nrvd'},7:{'n0N3','nvdg'}}
        for i,raws in expected.items():
            actual={r['raw'] for r in self.catalogue['creatures'] if r['area']==i and r['section']=='After Dimensional Boundary'}
            self.assertEqual(actual,raws)
        self.assertEqual(sum(r['section']=='Later Hell invasion' for r in self.catalogue['creatures']),8)

    def test_arena_and_hostile_batch_creations_covered(self):
        s=re.sub(r'\s+','',self.base.read('war3map.j').decode())
        expected=set(re.findall(r"CreateNUnitsAtLoc(?:FacingLocBJ)?\([^,]+,'(.{4})',Player\((?:11|\$B)\)",s))
        expected.update(re.findall(r"setudg_ArenaMonsterType\[[^\]]+\]='(.{4})'",s))
        covered={r['raw'] for r in self.catalogue['creatures']}
        excluded=set(self.catalogue['coverage']['excluded_dynamic_helpers'])
        self.assertFalse(expected-covered-excluded)

    def test_original_objects_assets_and_browser_metadata_retained(self):
        for name in ['war3map.w3u','war3map.w3a','war3mapSkin.w3u','war3map.imp','war3map.w3i']:
            self.assertEqual(self.base.read(name),self.map.read(name),name)

    def test_review_entry_does_not_start_rpg(self):
        main=self.fs['main']
        for forbidden in ['main_old','InitCustomTriggers','Startup_RegisterTriggers','Startup_RunMapInitTriggers','Startup_CreateUnits','CreateAllUnits','Startup_InitSharedSystems']:
            self.assertNotRegex(main,r'\b'+forbidden+r'\b')
        for m in re.finditer(r'ExecuteFunc\("([^"]+)"\)',main):
            body=self.fs[m[1]]
            if m[1].startswith('Register'):
                events=re.findall(r'EVENT_[A-Z_]+',body)
                self.assertTrue(events)
                self.assertTrue(all(e.startswith('EVENT_PLAYER_UNIT_SPELL_') for e in events))

    def test_all_exhibits_are_shared_red_units_not_local_handles(self):
        add=self.fs['Review_Add']
        self.assertIn('CreateUnit(Player(0),raw,x,y,270.)',add)
        review='\n'.join(b for n,b in self.fs.items() if n.startswith('Review_'))
        self.assertNotIn('GetLocalPlayer',review)
        self.assertNotIn('TimerStart',review)
        rows=[r for r in self.catalogue['creatures'] if r['valid_object']]
        self.assertEqual(len(re.findall(r'call Review_Add\(',review)),len(rows))
        for r in rows:
            self.assertTrue(-3968<=r['x']<=28544 and -28544<=r['y']<=3968)
        self.assertEqual(self.catalogue['coverage']['unresolved'],['m02A'])

if __name__=='__main__':unittest.main()

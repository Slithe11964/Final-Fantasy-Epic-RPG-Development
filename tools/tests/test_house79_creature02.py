"""House aura isolation and the Normal-baseline review's user-facing contracts."""
import sys,json,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from objdata import read_objects
from priest_master import fields
from jtok import functions,tokens
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

def objects(m,ext):return {o['id'] or o['base']:o for o in read_objects(m.read('war3map.'+ext),ext)['original']+read_objects(m.read('war3map.'+ext),ext)['custom']}

class House79Tests(unittest.TestCase):
    def test_house_only_percentages_fountain_and_runtime_preserved(self):
        pairs=[('release/development/VersionFHotfix08/FFERPG-0.9.7.5f-Hotfix08.w3x','release/development/VersionFHotfix09/FFERPG-0.9.7.5f-Hotfix09.w3x'),('release/development/QuickUI77/FFERPG-QuickUI77.w3x','release/development/QuickUI78/FFERPG-QuickUI78.w3x'),('release/0.9.7.5f/FFERPG-0.9.7.5f-1.29.2.w3x','release/development/VersionFHotfix09/FFERPG-0.9.7.5f-Hotfix09-1.29.2.w3x')]
        for before,after in pairs:
            a=MPQ(str(ROOT/before));b=MPQ(str(ROOT/after));oa,ob=objects(a,'w3a'),objects(b,'w3a');ua,ub=objects(a,'w3u'),objects(b,'w3u')
            self.assertEqual(a.read('war3map.j'),b.read('war3map.j'))
            self.assertEqual(a.read('war3map.wct'),b.read('war3map.wct'))
            self.assertEqual(oa['A001'],ob['A001']);self.assertEqual(oa['A00F'],ob['A00F'])
            self.assertEqual(ua['nfnp'],ub['nfnp'])
            hp,mp=fields(ob['hH79']),fields(ob['hM79'])
            self.assertAlmostEqual(hp['Oar1',1],.05);self.assertEqual(hp['Oar2',1],1)
            self.assertAlmostEqual(mp['Arm1',1],.05);self.assertEqual(mp['Arm2',1],1)
            self.assertEqual(hp['aare',1],350.);self.assertEqual(mp['aare',1],350.)
            for raw in ['h006','h00N']:
                abilities=fields(ub[raw])['uabi',None]
                self.assertIn('hH79',abilities);self.assertIn('hM79',abilities)
                self.assertNotIn('A001',abilities);self.assertNotIn('A00F',abilities)

class Creature02Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.folder=ROOT/'release/development/CreatureReview02'
        cls.map=MPQ(str(cls.folder/'FFERPG-Creature-Review-02.w3x'))
        cls.source=cls.map.read('war3map.j').decode();cls.fs=functions(cls.source)
        cls.catalogue=json.loads((cls.folder/'Creature-Catalogue.json').read_text())
        cls.spells=json.loads((cls.folder/'Spell-Calculations.json').read_text())

    def test_selection_is_silent_and_info_is_explicit(self):
        self.assertNotIn('Display',self.fs['Review_Select'])
        s=self.fs['Review_Select'];env=mocks(s);env.update(ReviewSelected=None,GetTriggerUnit=lambda:'monster')
        e=execute(s,['Review_Select'],env);e['Review_Select']();self.assertEqual(e['ReviewSelected'],'monster')
        self.assertIn('call Review02_Stats(u)',self.fs['Review_Chat'])
        for token in ['GetAccuracy','GetEvasion','GetElementResist','BlzGetUnitArmor','HIT_POINTS_REGENERATION_RATE','MANA_REGENERATION','LoadStr(Review02Data,GetUnitTypeId(u),-3)']:
            self.assertIn(token,self.fs['Review02_Stats'])
        self.assertNotIn('set udg_',self.fs['Review02_Stats'])

    def test_vulnerable_and_authored_levels_and_starting_gear(self):
        self.assertIn('SetUnitInvulnerable(u,false)',self.fs['Review_Add'])
        self.assertIn("UnitRemoveAbility(u,'Avul')",self.fs['Review_Add'])
        self.assertNotIn('SetHeroLevel(u,10',self.fs['Review_Add'])
        self.assertIn('SetUnitInvulnerable(ReviewFighter,false)',self.fs['Review_Chat'])
        self.assertEqual(self.spells['hero_levels']['N0LU'],91)
        self.assertEqual(self.spells['hero_levels']['N03K'],97)
        self.assertIn('I011',self.spells['starting_items']['N0LU'])
        self.assertIn('I00N',self.spells['starting_items']['Nbbc'])
        self.assertIn('I0H3',self.spells['starting_items']['N03K'])
        self.assertEqual(self.spells['ability_ranks']['U01T']['A1BF'],8)

    def test_separate_encounters_and_full_original_creature_coverage(self):
        rows=self.catalogue['creatures'];groups={i:{r['raw'] for r in rows if r['area']==i} for i in [10,11,12]}
        self.assertTrue({'N0LU','N03K','E00Z','E00X','U01T','U01N','E01J'}<=groups[10])
        self.assertIn('Nbbc',groups[11]);self.assertGreater(len(groups[12]),200)
        original=json.loads((ROOT/'release/development/CreatureReview01/Creature-Catalogue.json').read_text())
        self.assertEqual({r['raw'] for r in original['creatures']},{r['raw'] for r in rows})
        self.assertIn('Arena of Darkness',self.catalogue['areas']['10'])

    def test_native_and_scripted_calculations_are_present_and_paged(self):
        self.assertGreaterEqual(len(self.spells['spells']),500)
        self.assertIn('Damage: 100',self.spells['spells']['ACtb'][0])
        self.assertIn('Damage',self.spells['spells']['A00O'][0])
        self.assertFalse(self.spells['scripted']['N03K'].startswith('No additional'))
        self.assertIn('Review02_Pages',self.fs['Review_Chat'])
        self.assertIn('IMinBJ(count,i+5)',self.fs['Review02_Pages'])
        table=objects(self.map,'w3a')
        for raw,entries in self.spells['spells'].items():
            if raw in table:self.assertIn('Calculation / effect values',fields(table[raw]).get(('aub1',1),''),raw)

    def test_normal_enemy_research_and_game_stat_functions(self):
        data='\n'.join(b for n,b in self.fs.items() if n.startswith('Review02_Data'))
        for value in ['set udg_Difficulty=3','set udg_DifficultyScale=1.','set udg_EnemyHpPerPlayer=100.','SetPlayerHandicap(Player(0),1.)']:
            self.assertIn(value,data)
        self.assertIn("'R001',5,Player(0)",self.fs['Review02_EnemyTech'].replace(' ',''))
        base=functions(MPQ(str(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x')).read('war3map.j').decode())
        for name in ['Trig_Damage_Engine_GetAccuracy','Trig_Damage_Engine_GetEvasion','Trig_Damage_Engine_GetElementResist']:
            self.assertEqual(tokens(base[name]),tokens(self.fs[name]))
        self.assertIn('"Earth"',data);self.assertIn('"Wind"',data)

    def test_spell_math_annotations_do_not_change_ability_balance_fields(self):
        base=MPQ(str(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x'))
        for filename in ['war3map.w3a','war3mapSkin.w3a']:
            old=read_objects(base.read(filename),'w3a');new=read_objects(self.map.read(filename),'w3a')
            lookup={o['id'] or o['base']:o for o in new['original']+new['custom']}
            for o in old['original']+old['custom']:
                raw=o['id'] or o['base'];a={k:v for k,v in fields(o).items() if k[0]!='aub1'};b={k:v for k,v in fields(lookup[raw]).items() if k[0]!='aub1'}
                self.assertEqual(a,b,raw)

if __name__=='__main__':unittest.main()

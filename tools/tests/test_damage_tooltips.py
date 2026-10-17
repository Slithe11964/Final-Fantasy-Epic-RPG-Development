"""Validate tooltip coverage/rank data and exemption without changing combat objects."""
from pathlib import Path
import sys,unittest,re
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from damage_tooltips import catalogue,abilities,scroll_objects,runtime,details,KINDS,MARK
from priest_master import fields,at
from objdata import read_objects
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]


class DamageTooltipTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        p=ROOT/'editor/FFERPG-Editor-Master.w3x'
        if not p.exists():p=next((ROOT/'release').glob('*stageATV.w3x'))
        cls.view=View(p)
        cls.config=catalogue(*(cls.view.object_bytes(n) for n in ['war3map.w3a','war3mapSkin.w3a','war3map.w3t','war3mapSkin.w3t']))

    def test_all_requested_skills_and_each_rank_have_damage_details(self):
        self.assertEqual(len(set(KINDS.values())),40)
        for name in ['war3map.w3a','war3mapSkin.w3a']:
            updated=abilities(self.view.object_bytes(name),self.config)
            self.assertEqual(abilities(updated,self.config),updated)
            objs={o['id']:o for o in read_objects(updated,'w3a')['custom']}
            for raw in KINDS:
                original=fields(self.config['abilities'][raw])
                for rank in range(1,original.get(('alev',0),1)+1):
                    tip=fields(objs[raw])['aub1',rank]
                    self.assertEqual(tip.count(MARK),1,(raw,rank))
                    self.assertRegex(tip.split(MARK)[1],r'\d')
                    self.assertLess(len(tip),2300,(raw,rank,len(tip)))

    def test_numeric_mana_terms_follow_actual_rank_and_proxy_waves(self):
        c=self.config
        for raw,mult in [('A0QS',2),('A13K',3),('A0QQ',4),('A18P',10),('A039',6)]:
            f=fields(c['abilities'][raw])
            for rank in [1,f.get(('alev',0),1)]:
                self.assertIn(str(int(at(f,'amcs',rank,0))*mult),details(raw,rank,c))
        self.assertIn('12 waves',details('A0QM',1,c))
        self.assertIn('36 waves',details('A0QM',11,c))
        self.assertIn('32 waves',details('A0R0',6,c))
        self.assertIn('66%',details('A0UF',1,c))

    def test_old_numeric_claims_do_not_contradict_damage_details(self):
        updated=read_objects(abilities(self.view.object_bytes('war3map.w3a'),self.config),'w3a')
        objs={o['id']:fields(o) for o in updated['custom']}
        self.assertNotIn('33% damage',objs['A0UF']['aub1',1])
        self.assertIn('36 waves of meteors',objs['A0QM']['aub1',11])
        self.assertNotIn('dealing 100 damage',objs['A19R']['aub1',1])
        self.assertIn('up to 15 hits',objs['A0QH']['aub1',11])
        self.assertIn('up to 15 enemy units',objs['A0QF']['aub1',11])

    def test_no_damage_cost_or_target_data_changes(self):
        for name in ['war3map.w3a','war3mapSkin.w3a']:
            before=read_objects(self.view.object_bytes(name),'w3a')
            after=read_objects(abilities(self.view.object_bytes(name),self.config),'w3a')
            strip=lambda o:{k:v for k,v in fields(o).items() if k[0] not in {'aub1','arut'}}
            for a,b in zip(before['custom'],after['custom']):
                self.assertEqual((a['id'],a['base'],strip(a)),(b['id'],b['base'],strip(b)))

    def test_finisher_and_mixture_branches_are_explicit(self):
        first=details('A0HN',1,self.config);master=details('A0HN',11,self.config)
        for text in ['Mighty Swipe','Holy Strike','Elemental Quartet','9,999','Holy Power','(10 + Hybrid']:
            self.assertIn(text,master)
        self.assertIn('10/26',first);self.assertIn('0/26',master)
        mix=details('A0GZ',11,self.config)
        for text in ['80 / 125 / 200 / 300','100 / 156 / 250 / 375 / 625','3 x INT','6 x INT','difficulty scale']:
            self.assertIn(text,mix)
        self.assertIn('current HP percent',details('A0Z5',1,self.config))

    def test_scroll_tooltips_and_old_item_life_exemption_preserve_gear(self):
        c=self.config;self.assertIn('I073',c['scrolls']);self.assertIn('I04N',c['scrolls'])
        for name in ['war3map.w3t','war3mapSkin.w3t']:
            before=read_objects(self.view.object_bytes(name),'w3t')
            updated=scroll_objects(self.view.object_bytes(name),c)
            self.assertEqual(scroll_objects(updated,c),updated)
            after=read_objects(updated,'w3t')
            for a,b in zip(before['custom'],after['custom']):
                strip=lambda o:{k:v for k,v in fields(o).items() if k[0] not in {'utub','ides'}}
                self.assertEqual(strip(a),strip(b))
        s=next((ROOT/'src/triggers').rglob('Equip.j')).read_text();s=runtime(s)
        self.assertEqual(runtime(s),s)
        n='Trig_Equip_Restrictions_GaiaLevelTooLow';current=['I073','Scroll of Shadows']
        env=mocks(s);env.update(GetManipulatedItem=lambda:'item',GetItemTypeId=lambda i:current[0],GetItemName=lambda i:current[1],
            GetItemEquipmentType=lambda i:1 if current[0]=='gear' else 0,EQUIPMENT_TYPE_NONE=0,
            ForsakenElementSources='sources',LoadBoolean=lambda *a:False,Forsaken_EventItem=lambda:'item',
            SubString=lambda s,a,b:s[a:b],IsPlayerInForce=lambda *a:True,GetOwningPlayer=lambda u:0,GetTriggerUnit=lambda:'hero',
            udg_PlayingPlayers='players',GetItemLifeBJ=lambda i:99.,I2R=float,GetHeroLevel=lambda u:1,
            udg_SpiritOfGaya={1:'gaya'},GetConvertedPlayerId=lambda p:1)
        e=execute(s,[n],env)
        self.assertFalse(e[n]())
        current[:]=['I04N',"Curse: Crusher's Belt"];self.assertFalse(e[n]())
        current[:]=['gear','High level gear'];self.assertTrue(e[n]())


if __name__=='__main__':unittest.main()

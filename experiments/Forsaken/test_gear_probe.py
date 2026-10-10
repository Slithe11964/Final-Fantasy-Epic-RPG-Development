"""Actual gear-probe JASS, with effect and failure natives; engine gate stays separate."""
import unittest
import test_house_probe as house
from test_save_jass import engine,SOURCE
from test_save_position import Handle
from build_save_probe import modules,house_probe_source,probe_source,validate_gear_fixture,ROOT
from mpq import MPQ
from objdata import read_objects,fields

class GearProbeTests(unittest.TestCase):
    def setUp(self):
        house.HouseProbeTests.setUp(self)
        self.ignore_passive=False;self.reject_equip=False;self.base_speed=250.
        self.no_bonus=False;self.sticky_bonus=False
        create_item=self.w.create
        def create(raw,x,y):
            item=create_item(raw,x,y)
            if item is not None:item['abilities']=['A0MU','fGmk'] if raw=='f003' else []
            return item
        def add_ability(unit,raw):
            if raw=='fBag':unit['bag']=[None]*30
            return True
        def remove_ability(item,raw):
            if not self.ignore_passive:item['abilities'].remove(raw)
            return True
        def equip(unit,item):
            if not self.reject_equip:
                self.w.detach(item);unit['equip'][3]=item;item['owned']=True
            return True
        def speed(unit):
            bonus=sum(80 for kind in ['quick','bag','equip'] for i in unit[kind] if i and 'A0MU' in i.get('abilities',[]))
            if self.no_bonus:bonus=0
            if self.sticky_bonus and self.w.adds>0:bonus=80
            return self.base_speed+bonus
        self.env=dict(self.e)
        self.env.update(CreateItem=create,UnitAddAbility=add_ability,
            SaveInteger=lambda t,p,k,v:t.__setitem__((p,k),v),
            GetUnitMoveSpeed=speed,IsUnitType=lambda u,t:u['raw']!='h006',
            BlzGetItemAbilityByIndex=lambda i,s:Handle(raw=i['abilities'][s]) if s<len(i['abilities']) else None,
            BlzGetItemAbility=lambda i,r:Handle(raw=r) if r in i['abilities'] else None,
            BlzGetAbilityId=lambda a:a['raw'],BlzItemRemoveAbility=remove_ability,
            UnitEquipItem=equip)
        pieces=[SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in ('life','native','journal','effects','position','equipment')]
        self.e=engine(house.DECL+house.GLOBALS+'\n'.join(pieces)+probe_source({'fGap':1,'orig':2})+house_probe_source(house.RUNTIME)+SOURCE.with_name('Forsaken-gear-probe.j').read_text(),self.env)
        self.e['gg_trg_One']=Handle(enabled=True);self.e['gg_trg_Two']=Handle(enabled=False)
        self.e['udg_PlayerHero'][1]=self.hero;self.e['udg_SpiritOfGaya'][1]=self.gaya;self.e['udg_PlayerHouse'][1]=self.house

    def guarded_originals(self):house.HouseProbeTests.guarded_originals(self)

    def test_equipped_and_last_bag_slot_effects_cleanup(self):
        before=dict(self.original)
        self.e['FGT_Run'](0)
        self.assertIn('Gear test: PASS:',self.messages[-1])
        self.assertEqual(dict(self.original),before)
        self.assertEqual(self.created[-1]['raw'],0)
        self.assertEqual(self.e['FSN_AuxCount'][0],0)
        self.assertTrue(all(i['raw']==0 for i in self.w.items if i is not self.original))
        self.assertEqual(len(modules(gear=True)),10)
        self.guarded_originals()

    def test_native_effect_and_placement_failures_cleanup(self):
        for fault,label in [('ignore_passive','ability preparation'),('reject_equip','equipment slot3'),('no_bonus','equipped speed'),('sticky_bonus','cleanup baseline speed')]:
            with self.subTest(fault=fault):
                self.setUp();setattr(self,fault,True);self.e['FGT_Run'](0)
                self.assertIn('FAIL at '+label if label in ('equipped speed','cleanup baseline speed') else label,self.messages[-1])
                self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
                self.guarded_originals()

    def test_silent_bag_insertion_failure_cleanup(self):
        self.w.reject_add=37
        self.e['FGT_Run'](0)
        self.assertIn('FAIL at stored boots bag slot29',self.messages[-1])
        self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
        self.guarded_originals()

    def test_foreign_bag_item_blocks_unit_disposal(self):
        foreign=self.w.create('foreign',0,0)
        def frame(seconds):
            if self.created and self.e['FSN_Count'][0]==0 and self.w.adds>0:
                self.created[-1]['bag'][0]=foreign
        self.e['TriggerSleepAction']=frame
        self.e['FGT_Run'](0)
        self.assertIn('needs attention',self.messages[-1]);self.assertNotEqual(foreign['raw'],0)
        self.assertIsNotNone(self.e['FHT_Unit'][0]);self.guarded_originals()
        self.e['TriggerSleepAction']=lambda s:None
        self.created[-1]['bag'][0]=None
        self.e['FHT_Retry'](0);self.assertIn('PASS: temporary cleanup',self.messages[-1])

    def test_busy_or_capture_refuses_allocation(self):
        self.e['FHT_Busy']=True;self.e['FGT_Run'](0);self.assertEqual(self.created,[])
        self.e['FHT_Busy']=False;self.e['FSX_Phase'][7]=1;self.e['FGT_Run'](0)
        self.assertEqual(self.created,[])

    def test_measured_baseline_and_bonus_headroom(self):
        for baseline in (175.,250.,440.):
            self.setUp();self.base_speed=baseline;self.e['FGT_Run'](0)
            self.assertIn('Gear test: PASS:',self.messages[-1]);self.guarded_originals()
        self.setUp();self.base_speed=443.;self.e['FGT_Run'](0)
        self.assertIn('FAIL at speed baseline',self.messages[-1])
        self.assertIn('outside45..442 actual=443.000',self.messages[-1])
        self.assertEqual(self.w.adds,0);self.guarded_originals()

    def test_builder_checks_actual_fixture_and_rejects_changed_item_policy(self):
        archive=MPQ(str(ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x'))
        table=read_objects(archive.read('war3map.w3t'),'w3t')
        objects={o['id'] or o['base']:fields(o) for group in ('original','custom') for o in table[group]}
        validate_gear_fixture(archive,objects)
        for field,value in [('iabi','A0MU,unknown'),('iequ','Ring'),('ihtp',50)]:
            changed={**objects,'f003':{**objects['f003'],field:value}}
            with self.assertRaises(ValueError):validate_gear_fixture(archive,changed)

if __name__=='__main__':unittest.main()

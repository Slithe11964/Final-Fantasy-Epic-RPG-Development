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
        self.hide_equipped_lookup=False
        self.lazy_abilities=False
        self.hide_held_abilities=False;self.duplicate_on_equip=False
        self.pickup_recalculation=0.
        self.bonus_size=80
        self.opaque_bag=False;self.reject_detach=False;self.regenerate_bag_passive=False
        self.equipped_quick_alias=False
        self.unknown_ability=False
        self.route_gear_to_bag=False;self.reject_equip_call=0;self.equip_calls=0;self.reject_unequip=False
        create_item=self.w.create
        def create(raw,x,y):
            item=create_item(raw,x,y)
            if item is not None:item['abilities']=['A0MU','fGmk'] if raw=='f003' else []
            if item is not None and raw=='f003' and self.unknown_ability:item['abilities'].append('zzzz')
            return item
        def add_ability(unit,raw):
            if raw=='fBag':unit['bag']=[None]*30
            return True
        def remove_ability(item,raw):
            if not self.ignore_passive:item['abilities'].remove(raw)
            return True
        def equip(unit,item):
            self.equip_calls+=1
            if not self.reject_equip and self.equip_calls!=self.reject_equip_call and unit['equip'][3] is None:
                if not self.equipped_quick_alias:self.w.detach(item)
                unit['equip'][3]=item;item['owned']=True
                if self.duplicate_on_equip:item['abilities'].append('A0MU')
            return True
        def unequip(unit,item):
            if not self.reject_unequip and not self.reject_detach:self.w.detach(item)
        def exposed(item):
            bagged=any(i is item for u in self.w.units for i in u['bag'])
            return not self.hide_held_abilities and not (self.opaque_bag and bagged) and (not self.lazy_abilities or item['owned'])
        def detach(unit,item):
            if not self.reject_detach:self.w.detach(item)
        add_item=self.w.add
        def add(unit,item):
            result=add_item(unit,item)
            if self.route_gear_to_bag and item['raw']=='f003' and item['owned']:
                self.w.detach(item)
                for slot,candidate in enumerate(unit['bag']):
                    if candidate is None:
                        unit['bag'][slot]=item;item['owned']=True;break
            if self.regenerate_bag_passive and any(i is item for i in unit['bag']) and item['raw']=='f003' and 'A0MU' not in item['abilities']:item['abilities'].append('A0MU')
            return result
        def speed(unit):
            active={id(i):i for kind in ['quick','bag','equip'] for i in unit[kind] if i}
            bonus=sum(self.bonus_size for i in active.values() if 'A0MU' in i.get('abilities',[]))
            if self.no_bonus:bonus=0
            if self.sticky_bonus and self.w.adds>0 and all(i['raw']==0 for i in self.w.items if i is not self.original):bonus=80
            return self.base_speed+(self.pickup_recalculation if self.w.adds>0 else 0.)+bonus
        self.env=dict(self.e)
        self.env.update(CreateItem=create,UnitAddAbility=add_ability,
            SaveInteger=lambda t,p,k,v:t.__setitem__((p,k),v),
            GetUnitMoveSpeed=speed,IsUnitType=lambda u,t:u['raw']!='h006',
            BlzGetItemAbilityByIndex=lambda i,s:Handle(raw=i['abilities'][s]) if exposed(i) and s<len(i['abilities']) else None,
            BlzGetItemAbility=lambda i,r:None if not exposed(i) or self.hide_equipped_lookup and i is self.created[-1]['equip'][3] else Handle(raw=r) if r in i['abilities'] else None,
            BlzGetAbilityId=lambda a:a['raw'],BlzItemRemoveAbility=remove_ability,
            UnitRemoveItem=detach,UnitAddItem=add,
            UnitEquipItem=equip,UnitUnequipItem=unequip)
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
        for fault,label in [('ignore_passive','stored boots bag slot29'),('reject_equip','equipment slot3'),('no_bonus','cleanup baseline speed'),('sticky_bonus','cleanup baseline speed')]:
            with self.subTest(fault=fault):
                self.setUp();setattr(self,fault,True);self.e['FGT_Run'](0)
                self.assertIn('FAIL at '+label if label in ('equipped speed','cleanup baseline speed') else label,self.messages[-1])
                self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
                self.guarded_originals()

    def test_silent_bag_insertion_failure_cleanup(self):
        self.w.reject_add=39
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

    def test_equipped_lookup_failure_keeps_enumeration_and_speed_evidence(self):
        self.hide_equipped_lookup=True
        self.e['FGT_Run'](0)
        self.assertIn('ability missing A0MU(speed)',self.messages[-1])
        self.assertIn('item IDs=A0MU(speed),fGmk(marker),',self.messages[-1])
        self.assertIn('unit ability=no speed=330.000',self.messages[-1])
        self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
        self.guarded_originals()

    def test_builder_checks_actual_fixture_and_rejects_changed_item_policy(self):
        archive=MPQ(str(ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x'))
        table=read_objects(archive.read('war3map.w3t'),'w3t')
        objects={o['id'] or o['base']:fields(o) for group in ('original','custom') for o in table[group]}
        validate_gear_fixture(archive,objects)
        for field,value in [('iabi','A0MU,unknown'),('iequ','Ring'),('ihtp',50)]:
            changed={**objects,'f003':{**objects['f003'],field:value}}
            with self.assertRaises(ValueError):validate_gear_fixture(archive,changed)

    def test_ground_abilities_unreadable_and_add_ability_unavailable(self):
        self.lazy_abilities=True
        self.e['FGT_Run'](0)
        self.assertIn('Gear test: PASS:',self.messages[-1])
        self.guarded_originals()

    def test_unreadable_held_and_duplicate_equipped_abilities_fail_safely(self):
        for fault,label in [('hide_held_abilities','equipment slot3'),('duplicate_on_equip','equipment slot3')]:
            self.setUp();self.lazy_abilities=True;setattr(self,fault,True)
            self.e['FGT_Run'](0)
            self.assertIn('FAIL at real boots '+label,self.messages[-1])
            self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
            self.guarded_originals()

    def test_pickup_speed_recalculation_is_separate_from_exact_boots_bonus(self):
        self.base_speed=340.;self.pickup_recalculation=20.
        self.lazy_abilities=True
        self.e['FGT_Run'](0)
        self.assertIn('Gear test: PASS:',self.messages[-1])
        self.guarded_originals()
        self.setUp();self.base_speed=430.;self.pickup_recalculation=20.
        self.e['FGT_Run'](0)
        self.assertIn('FAIL at equipped speed',self.messages[-1])
        self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
        self.guarded_originals()

    def test_wrong_nonzero_bonus_cannot_pass_cleanup_delta(self):
        for bonus in (40,100):
            self.setUp();self.bonus_size=bonus
            self.e['FGT_Run'](0)
            self.assertIn('FAIL at cleanup baseline speed',self.messages[-1])
            self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
            self.guarded_originals()

    def test_opaque_bag_after_verified_active_preparation(self):
        self.lazy_abilities=True;self.opaque_bag=True
        self.e['FGT_Run'](0)
        self.assertIn('Gear test: PASS:',self.messages[-1]);self.guarded_originals()

    def test_detach_failure_or_regenerated_opaque_bag_passive_cannot_pass(self):
        for fault in ('reject_detach','regenerate_bag_passive'):
            self.setUp();self.lazy_abilities=True;self.opaque_bag=True;setattr(self,fault,True)
            self.e['FGT_Run'](0)
            self.assertIn('FAIL at ',self.messages[-1])
            self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
            self.guarded_originals()

    def test_equipment_still_visible_in_quick_zero_uses_next_free_slot(self):
        self.equipped_quick_alias=True;self.opaque_bag=True;self.lazy_abilities=True
        self.e['FGT_Run'](0)
        self.assertIn('Gear test: PASS:',self.messages[-1]);self.guarded_originals()

    def test_unreviewed_preparation_ability_is_reported_before_cleanup(self):
        self.unknown_ability=True
        self.e['FGT_Run'](0)
        self.assertIn('ability unreviewed role=0 zzzz',self.messages[-1])
        self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
        self.guarded_originals()

    def test_bag_routed_pickup_prepares_in_equipment_without_quick_move(self):
        self.route_gear_to_bag=True;self.opaque_bag=True;self.lazy_abilities=True
        self.w.reject_drop=True
        self.e['FGT_Run'](0)
        self.assertIn('Gear test: PASS:',self.messages[-1]);self.guarded_originals()
        self.assertEqual(self.equip_calls,3)
        self.assertFalse(any(c[0]=='drop' for c in self.w.calls))

    def test_equipment_swap_failures_preserve_originals_and_cleanup(self):
        for fault,value,label in [('reject_detach',True,'first equipment detach'),('reject_equip_call',2,'second equipment pickup'),('reject_equip_call',3,'first equipment return')]:
            self.setUp();setattr(self,fault,value);self.e['FGT_Run'](0)
            self.assertIn('boots '+label,self.messages[-1])
            self.assertIn('cleanup=yes; originals=yes; release=yes',self.messages[-1])
            self.guarded_originals()

if __name__=='__main__':unittest.main()

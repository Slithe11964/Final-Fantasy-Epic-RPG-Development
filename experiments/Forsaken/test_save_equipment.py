"""Actual JASS staged ability membership and exact equipment placement."""
import unittest

from test_save_jass import engine, SOURCE
from test_save_life import LIFE
from test_save_native import NATIVE
from test_save_position import InventoryWorld, Handle, JOURNAL, EFFECTS, POSITION, SPACER

EQUIPMENT=SOURCE.with_name('Forsaken-save-equipment.j')
RING_FILLER=888
POLICY={(0,10):1,(0,20):2,(0,30):2}


class EquipmentWorld(InventoryWorld):
    def __init__(self):
        super().__init__()
        self.definitions={RING_FILLER:[30]}
        self.types={RING_FILLER:4}
        self.ignore_remove=False
        self.remove_extra=False
        self.equips=0
        self.reject_equip=0
        self.compact_rings=False

    def create(self,raw,x,y):
        item=super().create(raw,x,y)
        if item is not None:
            item['abilities']=list(self.definitions.get(raw,[10,20,30]))
            item['equipment']=self.types.get(raw,raw-1000)
        return item

    def ability(self,item,index):
        return Handle(raw=item['abilities'][index]) if index<len(item['abilities']) else None

    def by_id(self,item,raw):
        return Handle(raw=raw) if raw in item['abilities'] else None

    def remove_ability(self,item,raw):
        self.calls.append(('remove_ability',raw))
        if self.callback: self.callback()
        if not self.ignore_remove:
            item['abilities']=[a for a in item['abilities'] if a!=raw]
            if self.remove_extra: item['abilities']=[]
        return True

    def equip(self,unit,item):
        self.equips+=1
        self.calls.append(('equip',id(item)))
        if self.callback: self.callback()
        if self.equips==self.reject_equip: return True
        if not item['owned']: return False
        kind=item['equipment']
        slot=4 if kind==4 and unit['equip'][4] is None else 5 if kind==4 else kind
        if not 0<=slot<9 or unit['equip'][slot] is not None: return False
        self.detach(item)
        unit['equip'][slot]=item
        item['owned']=True
        return True

    def remove(self,item):
        super().remove(item)
        if self.compact_rings:
            for unit in self.units:
                if unit['equip'][4] is None and unit['equip'][5] is not None:
                    unit['equip'][4]=unit['equip'][5]
                    unit['equip'][5]=None

    def natives(self):
        env=super().natives()
        env.update(LoadInteger=lambda table,p,k:table.get((p,k),0),
                   BlzGetItemAbilityByIndex=self.ability,BlzGetItemAbility=self.by_id,
                   BlzGetAbilityId=lambda a:a['raw'],BlzItemRemoveAbility=self.remove_ability,
                   GetItemEquipmentType=lambda i:i['equipment'],UnitEquipItem=self.equip)
        return env


class EquipmentTests(unittest.TestCase):
    def setUp(self):
        self.w=EquipmentWorld()
        self.e=engine('\n'.join(p.read_text() for p in [LIFE,NATIVE,JOURNAL,EFFECTS,POSITION,EQUIPMENT]),self.w.natives())
        self.hero=self.w.unit(bag=30)

    def stage(self,slot=0,pid=0):
        self.w.types[1000+slot]=4 if slot==5 else slot
        self.assertTrue(self.e['FSN_Stage'](pid,1000+slot,127,True,7,0x4311,0x4000,0.,0.))
        return self.e['FSN_Item'][pid*57+self.e['FSN_Count'][pid]-1]

    def prepare(self,ordinal=0,stored=False,pid=0):
        return self.e['FSA_Prepare'](pid,ordinal,stored,POLICY)

    def place(self,slot=0,ordinal=0,pid=0,hero=None):
        return self.e['FSE_Place'](pid,ordinal,hero or self.hero,slot,RING_FILLER,30)

    def test_stored_passives_removed_active_and_marker_retained(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        item=self.stage()
        self.assertTrue(self.prepare(stored=True))
        self.assertEqual(item['abilities'],[20,30])
        self.assertTrue(self.e['FSA_Check'](0))
        self.assertTrue(self.e['FSP_Place'](0,0,self.hero,2,29,SPACER))
        self.assertTrue(self.e['FSP_Verify'](0))
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertFalse(self.e['FSN_EffectsReady'][0])
        self.assertEqual(self.e['FSN_EffectCount'][0],0)
        self.assertTrue(all(self.e['FSN_EffectId'][i]==0 for i in range(16)))

    def test_equipped_preparation_retains_exact_ability_set(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        item=self.stage()
        self.assertTrue(self.prepare())
        self.assertEqual(item['abilities'],[10,20,30])
        self.assertFalse(any(c[0]=='remove_ability' for c in self.w.calls))

    def test_unprepared_or_wrong_passive_mode_cannot_enter_storage(self):
        for stored in [None,False]:
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            self.stage()
            if stored is not None: self.assertTrue(self.prepare(stored=stored))
            self.w.calls.clear()
            self.assertFalse(self.e['FSP_Place'](0,0,self.hero,2,29,SPACER))
            self.assertFalse(any(c[0]=='add' for c in self.w.calls))

    def test_target_owner_change_during_equipping_refuses_readback(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.stage()
        self.assertTrue(self.prepare())
        self.w.callback=lambda:self.hero.update(owner=1)
        self.assertFalse(self.place())
        self.assertEqual(self.e['FSN_Count'][0],0)

    def test_entire_batch_must_be_prepared_before_first_placement(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.stage(0)
        self.stage(1)
        self.assertTrue(self.prepare(0))
        self.w.calls.clear()
        self.assertFalse(self.place(0))
        self.assertFalse(any(c[0] in ['add','equip'] for c in self.w.calls))
        self.assertEqual(self.e['FSN_Count'][0],0)

    def test_unclassified_duplicate_and_17_abilities_refuse_before_removal(self):
        for ids in [[10,999],[10,10],list(range(1,18))]:
            self.setUp()
            self.w.definitions[1000]=ids
            self.assertTrue(self.e['FSN_Begin'](0))
            self.stage()
            policy={(0,a):1 for a in range(1,18)} if len(ids)==17 else POLICY
            self.assertFalse(self.e['FSA_Prepare'](0,0,True,policy))
            self.assertFalse(any(c[0]=='remove_ability' for c in self.w.calls))
            self.assertEqual(self.e['FSN_Count'][0],0)

    def test_silent_removal_and_unexpected_active_removal_fail_readback(self):
        for fault in ['ignore_remove','remove_extra']:
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            item=self.stage()
            setattr(self.w,fault,True)
            self.assertFalse(self.prepare(stored=True))
            self.assertEqual(item['raw'],0)
            self.assertEqual(self.e['FSN_Count'][0],0)

    def test_16_ability_limit_for_last_player_last_item_stays_array_safe(self):
        self.assertTrue(self.e['FSN_Begin'](7))
        self.w.definitions[1000]=list(range(1,17))
        policy={(0,a):1 if a%2 else 2 for a in range(1,17)}
        for ordinal in range(57):
            item=self.stage(pid=7)
            self.assertTrue(self.e['FSA_Prepare'](7,ordinal,True,policy))
            self.assertEqual(item['abilities'],list(range(2,17,2)))
        self.assertEqual(self.e['FSN_EffectId'][7295],16)
        self.assertTrue(self.e['FSN_Abort'](7))
        self.assertEqual(self.e['FSN_EffectId'][7295],0)

    def test_all_9_equipment_slots_including_lone_second_ring(self):
        for slot in range(9):
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            item=self.stage(slot)
            self.assertTrue(self.prepare())
            self.assertTrue(self.place(slot))
            self.assertIs(self.hero['equip'][slot],item)
            if slot==5: self.assertIsNone(self.hero['equip'][4])
            self.assertTrue(self.e['FSP_Verify'](0))
            self.assertEqual(self.e['FSN_AuxCount'][0],0)
            self.assertTrue(self.e['FSN_Abort'](0))
            self.assertTrue(all(i is None for i in self.hero['equip']))

    def test_original_equipment_refuses_before_mutation(self):
        original=self.w.create(1004,0.,0.)
        original['owned']=True
        self.hero['equip'][4]=original
        before=dict(original)
        self.assertTrue(self.e['FSN_Begin'](0))
        self.stage(5)
        self.assertTrue(self.prepare())
        self.w.calls.clear()
        self.assertFalse(self.place(5))
        self.assertIs(self.hero['equip'][4],original)
        self.assertEqual(dict(original),before)
        self.assertFalse(any(c[0] in ['add','equip'] for c in self.w.calls))

    def test_unprepared_or_stored_item_cannot_equip(self):
        for stored in [None,True]:
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            self.stage()
            if stored is not None: self.assertTrue(self.prepare(stored=stored))
            self.assertFalse(self.place())
            self.assertEqual(self.w.equips,0)

    def test_bad_ring_filler_marker_type_or_creation_refuses(self):
        for fault in ['marker','extra','type','null']:
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            self.stage(5)
            self.assertTrue(self.prepare())
            if fault=='marker': self.w.definitions[RING_FILLER]=[20]
            elif fault=='extra': self.w.definitions[RING_FILLER]=[30,10]
            elif fault=='type': self.w.types[RING_FILLER]=0
            else: self.w.fail_create=2
            self.assertFalse(self.place(5))
            self.assertEqual(self.e['FSN_Count'][0],0)
            self.assertEqual(self.e['FSN_AuxCount'][0],0)

    def test_silent_equip_failure_at_filler_or_actual_item(self):
        for failure in [1,2]:
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            self.stage(5)
            self.assertTrue(self.prepare())
            self.w.reject_equip=failure
            self.assertFalse(self.place(5))
            self.assertTrue(all(i['raw']==0 for i in self.w.items))

    def test_ring_compaction_after_filler_removal_is_refused(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.stage(5)
        self.assertTrue(self.prepare())
        self.w.compact_rings=True
        self.assertFalse(self.place(5))
        self.assertEqual(self.e['FSN_Count'][0],0)

    def test_failed_ring_filler_deletion_retains_guarded_allocation_for_retry(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.stage(5)
        self.assertTrue(self.prepare())
        create=self.w.create
        def refuse(raw,x,y):
            item=create(raw,x,y)
            if raw==RING_FILLER: self.w.refuse_delete.add(id(item))
            return item
        self.e['CreateItem']=refuse
        self.assertFalse(self.place(5))
        self.assertEqual(self.e['FSN_State'][0],3)
        self.assertIsNotNone(self.e['FSN_AuxItem'][0])
        self.w.refuse_delete.clear()
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertIsNone(self.e['FSN_AuxItem'][0])

    def test_later_added_or_missing_ability_is_detected_by_placement_verifier(self):
        for change in ['extra','missing']:
            self.setUp()
            self.assertTrue(self.e['FSN_Begin'](0))
            item=self.stage()
            self.assertTrue(self.prepare())
            self.assertTrue(self.place())
            if change=='extra': item['abilities'].append(999)
            else: item['abilities'].remove(10)
            self.assertFalse(self.e['FSP_Verify'](0))
            self.assertEqual(item['raw'],0)

    def test_full_57_batch_equipment_first_then_storage(self):
        gaya,house=self.w.unit(),self.w.unit(9)
        self.assertTrue(self.e['FSN_Begin'](0))
        for ordinal in range(57):
            slot=ordinal if ordinal<9 else 0
            self.stage(slot)
            self.assertTrue(self.prepare(ordinal,stored=15<=ordinal<45))
        for slot in range(9): self.assertTrue(self.place(slot,slot))
        ordinal=9
        for unit,kind,size in [(self.hero,1,6),(self.hero,2,30),(gaya,4,6),(house,5,6)]:
            for slot in range(size):
                self.assertTrue(self.e['FSP_Place'](0,ordinal,unit,kind,slot,SPACER))
                ordinal+=1
        self.assertTrue(self.e['FSP_Verify'](0))
        self.assertTrue(self.e['FSN_Abort'](0))
        self.assertTrue(all(i['raw']==0 for i in self.w.items))

    def test_reentrant_ability_and_equipment_callbacks_cannot_abort_batch(self):
        self.assertTrue(self.e['FSN_Begin'](0))
        self.stage(5)
        self.assertTrue(self.prepare())
        results=[]
        self.w.callback=lambda:results.extend([self.e['FSN_Abort'](0),self.place(5),self.e['FSP_Verify'](0)])
        self.assertTrue(self.place(5))
        self.assertTrue(results)
        self.assertFalse(any(results))

    def test_sources_crlf_and_no_initializers_or_promotion(self):
        for path in [EFFECTS,EQUIPMENT]:
            self.assertNotIn(b'\n',path.read_bytes().replace(b'\r\n',b''))
            for forbidden in ['initializer ', 'GetLocalPlayer', 'FSC_Decode(', 'FSC_Reset(', 'UnitResetCooldown(']:
                self.assertNotIn(forbidden,path.read_text())

    def test_held_preparation_requires_exact_tracked_slot_and_storage_mode(self):
        for fault in ('none','untracked','wrong_slot','wrong_mode','visible','foreign_owner'):
            self.setUp();self.assertTrue(self.e['FSN_Begin'](0))
            item=self.stage(3)
            self.w.add(self.hero,item);self.w.equip(self.hero,item)
            self.e['FSN_PlacedItem'][0]=item
            self.e['FSN_PlacedUnit'][0]=self.hero
            self.e['FSN_PlacedOwner'][0]=0
            self.e['FSN_PlacedHolder'][0]=3
            self.e['FSN_PlacedSlot'][0]=3
            if fault=='untracked':self.e['FSN_PlacedItem'][0]=None
            if fault=='wrong_slot':self.e['FSN_PlacedSlot'][0]=2
            if fault=='visible':item['visible']=True
            if fault=='foreign_owner':self.hero['owner']=9;self.e['FSN_PlacedOwner'][0]=9
            with self.subTest(fault=fault):
                self.assertEqual(self.prepare(stored=fault=='wrong_mode'),fault=='none')
                if fault=='none':self.assertEqual(self.e['FSN_EffectCount'][0],3)
                self.assertTrue(self.e['FSN_Abort'](0))


if __name__=='__main__': unittest.main()

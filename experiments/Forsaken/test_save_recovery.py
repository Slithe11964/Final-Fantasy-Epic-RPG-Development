"""Actual JASS quarantine/recovery of original items; cooldown refresh is allowed."""
import unittest

from test_save_jass import engine, SOURCE
from test_save_life import LIFE, Real32
from test_save_native import NATIVE
from test_save_position import JOURNAL, EFFECTS, POSITION, SPACER, Handle
from test_save_equipment import EquipmentWorld, EQUIPMENT, RING_FILLER, POLICY

RECOVERY=SOURCE.with_name('Forsaken-save-recovery.j')


class RecoveryWorld(EquipmentWorld):
    def __init__(self):
        super().__init__()
        self.removals=0
        self.reject_remove=0
        self.refuse_detach=set()

    def create(self,raw,x,y):
        item=super().create(raw,x,y)
        if item is not None:
            item['ability_objects']={a:Handle(raw=a) for a in item['abilities']}
            item['cooldown']=17.25  # Model session field, deliberately no native accessor.
        return item

    def ability(self,item,index):
        return item['ability_objects'][item['abilities'][index]] if index<len(item['abilities']) else None

    def by_id(self,item,raw):
        return item['ability_objects'].get(raw) if raw in item['abilities'] else None

    def remove_from_unit(self,unit,item):
        self.calls.append(('detach',id(item)))
        self.removals+=1
        if self.callback: self.callback()
        if self.removals==self.reject_remove or id(item) in self.refuse_detach: return
        if any(candidate is item for k in ['quick','bag','equip'] for candidate in unit[k]):
            self.detach(item)

    def unequip(self,unit,item):
        self.calls.append(('unequip',id(item)))
        if self.callback: self.callback()
        if id(item) in self.refuse_detach: return
        if any(candidate is item for candidate in unit['equip']):
            self.detach(item)

    def drop_slot(self,unit,item,slot):
        if not any(candidate is item for k in ['quick','bag'] for candidate in unit[k]):
            return False
        return super().drop_slot(unit,item,slot)

    def natives(self):
        env=super().natives()
        env.update(GetHandleId=id,UnitRemoveItem=self.remove_from_unit,
                   UnitUnequipItem=self.unequip,
                   UnitHasItemEquipped=lambda u,i:any(candidate is i for candidate in u['equip']))
        return env


class RecoveryTests(unittest.TestCase):
    def setUp(self):
        self.w=RecoveryWorld()
        self.e=engine('\n'.join(p.read_text() for p in [LIFE,NATIVE,JOURNAL,EFFECTS,POSITION,EQUIPMENT,RECOVERY]),self.w.natives())
        self.hero,self.gaya,self.house=self.w.unit(bag=30),self.w.unit(),self.w.unit(9)
        self.table={}
        self.originals=[]

    def original(self,position):
        if position<6: unit,kind,slot=self.hero,'quick',position
        elif position<36: unit,kind,slot=self.hero,'bag',position-6
        elif position<45: unit,kind,slot=self.hero,'equip',position-36
        elif position<51: unit,kind,slot=self.gaya,'quick',position-45
        else: unit,kind,slot=self.house,'quick',position-51
        raw=1000+slot if kind=='equip' else 1100+position
        self.w.types[raw]=4 if kind=='equip' and slot==5 else slot
        item=self.w.create(raw,0.,0.)
        item.update(charges=127,binding=3,life=Real32(145.25),owner=9,owned=True,
                    visible=position%2==0,invulnerable=True,droppable=False,pawnable=True)
        if kind=='bag':
            item['abilities'].remove(10)
            self.table.update({(id(item),-1):True,(id(item),0):1,(id(item),1):10})
        unit[kind][slot]=item
        self.originals.append(item)
        return item

    def capture(self):
        self.assertTrue(self.e['FSJ_Capture'](0,self.hero,self.gaya,self.house,True))
        return self.e['FQR_Begin'](0,self.table)

    def recover(self):
        return self.e['FQR_Recover'](0,SPACER,RING_FILLER,30)

    def verify_originals(self,before):
        self.assertTrue(self.e['FSJ_Verify'](0))
        self.assertTrue(self.e['FQR_CheckAll'](0))
        for item,metadata in zip(self.originals,before): self.assertEqual(dict(item),metadata)
        original_ids={id(i) for i in self.originals}
        self.assertFalse(any(c[0]=='remove' and c[1] in original_ids for c in self.w.calls))

    def test_full_57_originals_survive_quarantine_and_exact_recovery(self):
        for position in range(57): self.original(position)
        before=[dict(i) for i in self.originals]
        before_table=dict(self.table)
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        self.assertTrue(all(not i['owned'] and not i['visible'] and i['raw'] for i in self.originals))
        self.assertFalse(self.e['FSJ_Verify'](0))
        self.assertFalse(self.e['FSJ_Release'](0))
        self.assertTrue(self.recover())
        self.verify_originals(before)
        self.assertEqual(self.table,before_table)
        self.assertEqual(self.e['FQR_State'][0],5)
        self.assertFalse(self.e['FSN_Begin'](0))
        self.assertFalse(self.e['FSJ_Release'](0))
        self.assertTrue(self.e['FQR_Release'](0))
        self.assertTrue(self.e['FSJ_Release'](0))
        self.assertTrue(all(self.e['FQR_Ability'][s] is None for s in range(57*16)))

    def test_each_sparse_position_including_lone_second_ring(self):
        for position in range(57):
            self.setUp()
            item=self.original(position)
            before=[dict(item)]
            self.assertTrue(self.capture())
            self.assertTrue(self.e['FQR_Quarantine'](0))
            self.assertTrue(self.recover(),position)
            self.verify_originals(before)
            self.assertIs(self.e['FSJ_Item'][position],item)

    def test_failed_quarantine_each_of_57_positions_is_recoverable(self):
        for failure in range(1,58):
            self.setUp()
            for position in range(57): self.original(position)
            before=[dict(i) for i in self.originals]
            self.assertTrue(self.capture())
            self.w.refuse_detach.add(id(self.originals[failure-1]))
            self.assertFalse(self.e['FQR_Quarantine'](0))
            self.assertEqual(self.e['FQR_State'][0],4)
            self.assertFalse(self.e['FSN_Begin'](0))
            self.w.refuse_detach.clear()
            self.assertTrue(self.recover())
            self.verify_originals(before)

    def test_silent_recovery_add_failure_at_each_of_57_items_retains_originals(self):
        for failure in range(1,58):
            self.setUp()
            for position in range(57): self.original(position)
            before=[dict(i) for i in self.originals]
            self.assertTrue(self.capture())
            self.assertTrue(self.e['FQR_Quarantine'](0))
            self.w.reject_add=failure
            self.assertFalse(self.recover())
            self.assertEqual(self.e['FQR_State'][0],4)
            self.assertTrue(all(i['raw'] for i in self.originals))
            self.assertFalse(self.e['FQR_Release'](0))
            self.w.reject_add=0
            self.assertTrue(self.recover())
            self.verify_originals(before)

    def test_replacements_are_deleted_before_original_recovery(self):
        for position in [0,35,40,41,50,56]: self.original(position)
        before=[dict(i) for i in self.originals]
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        self.assertTrue(self.e['FSN_Begin'](0))
        self.assertTrue(self.e['FSN_Stage'](0,1004,127,True,7,0x4311,0x4000,0.,0.))
        self.assertTrue(self.e['FSA_Prepare'](0,0,False,POLICY))
        replacement=self.e['FSN_Item'][0]
        self.assertTrue(self.e['FSE_Place'](0,0,self.hero,4,RING_FILLER,30))
        self.assertTrue(self.recover())
        self.assertEqual(replacement['raw'],0)
        self.verify_originals(before)

    def test_failed_replacement_cleanup_blocks_original_movement(self):
        item=self.original(5)
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        self.assertTrue(self.e['FSN_Begin'](0))
        self.assertTrue(self.e['FSN_Stage'](0,1000,127,True,7,0x4311,0x4000,0.,0.))
        replacement=self.e['FSN_Item'][0]
        self.w.refuse_delete.add(id(replacement))
        self.w.calls.clear()
        self.assertFalse(self.recover())
        self.assertFalse(any(c[0] in ['add','detach','unequip'] for c in self.w.calls))
        self.assertEqual(item['raw'],1105)
        self.w.refuse_delete.clear()
        self.assertTrue(self.recover())

    def test_untracked_occupant_is_neither_deleted_nor_overwritten(self):
        item=self.original(5)
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        foreign=self.w.create(1200,0.,0.)
        self.hero['quick'][0]=foreign
        foreign['owned']=True
        self.assertFalse(self.recover())
        self.assertIs(self.hero['quick'][0],foreign)
        self.assertNotEqual(foreign['raw'],0)
        self.assertNotEqual(item['raw'],0)
        self.w.detach(foreign)
        self.assertTrue(self.recover())

    def test_ability_instance_or_passive_bookkeeping_change_blocks_recovery(self):
        for fault in ['instance','table','extra']:
            self.setUp()
            item=self.original(35)
            self.assertTrue(self.capture())
            self.assertTrue(self.e['FQR_Quarantine'](0))
            if fault=='instance': item['ability_objects'][20]=Handle(raw=20)
            elif fault=='table': self.table[(id(item),1)]=999
            else:
                item['abilities'].append(999)
                item['ability_objects'][999]=Handle(raw=999)
            self.assertFalse(self.recover())
            self.assertEqual(self.e['FQR_State'][0],4)
            self.assertFalse(self.e['FQR_Release'](0))
            self.assertNotEqual(item['raw'],0)

    def test_destroyed_original_never_gets_a_replacement_copy(self):
        item=self.original(0)
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        item['raw']=0
        count=len(self.w.items)
        self.assertFalse(self.recover())
        self.assertEqual(len(self.w.items),count)

    def test_changed_metadata_is_reapplied_and_setter_failure_stays_blocked(self):
        item=self.original(35)
        before=[dict(item)]
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        item['charges']=0
        self.w.silent='charges'
        self.assertFalse(self.recover())
        self.assertEqual(self.e['FQR_State'][0],4)
        self.w.silent=None
        self.assertTrue(self.recover())
        self.verify_originals(before)

    def test_recovery_fillers_track_failed_deletion_and_retry(self):
        item=self.original(41)
        before=[dict(item)]
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        create=self.w.create
        def refuse(raw,x,y):
            filler=create(raw,x,y)
            if raw==RING_FILLER: self.w.refuse_delete.add(id(filler))
            return filler
        self.e['CreateItem']=refuse
        self.assertFalse(self.recover())
        self.assertIsNotNone(self.e['FQR_AuxItem'][0])
        self.assertNotEqual(item['raw'],0)
        self.w.refuse_delete.clear()
        self.e['CreateItem']=create
        self.assertTrue(self.recover())
        self.verify_originals(before)

    def test_preflight_bounds_and_invalid_passive_state_do_not_mutate_originals(self):
        for count in [-1,17]:
            self.setUp()
            item=self.original(35)
            self.assertTrue(self.e['FSJ_Capture'](0,self.hero,self.gaya,self.house,True))
            self.table[(id(item),0)]=count
            self.w.calls.clear()
            self.assertFalse(self.e['FQR_Begin'](0,self.table))
            self.assertEqual(self.w.calls,[])
            self.assertEqual(self.e['FQR_State'][0],0)
        for pid in [-1,8,2147483647]:
            self.assertFalse(self.e['FQR_Begin'](pid,self.table))
            self.assertFalse(self.e['FQR_Quarantine'](pid))
            self.assertFalse(self.e['FQR_Recover'](pid,SPACER,RING_FILLER,30))
            self.assertFalse(self.e['FQR_Release'](pid))

    def test_seventeenth_ability_and_duplicate_suspended_ids_refuse_capture(self):
        self.w.definitions[1100]=list(range(1,18))
        self.original(0)
        self.assertFalse(self.capture())
        self.assertEqual(self.e['FQR_State'][0],0)
        self.setUp()
        item=self.original(35)
        self.table.update({(id(item),0):2,(id(item),2):10})
        self.assertFalse(self.capture())
        self.assertEqual(self.e['FQR_State'][0],0)

    def test_failed_concealment_and_changed_unit_context_stay_blocked(self):
        item=self.original(0)
        before=[dict(item)]
        self.assertTrue(self.capture())
        self.w.silent='visible'
        self.assertFalse(self.e['FQR_Quarantine'](0))
        self.assertEqual(self.e['FQR_State'][0],4)
        self.assertTrue(item['visible'])  # Do not claim that hiding succeeded.
        self.w.silent=None
        self.hero['owner']=1
        self.assertFalse(self.recover())
        self.hero['owner']=0
        self.assertTrue(self.recover())
        self.verify_originals(before)

    def test_each_of_35_recovery_filler_creation_failures_never_deletes_original(self):
        for failure in range(2,37):
            self.setUp()
            item=self.original(35)
            before=[dict(item)]
            self.assertTrue(self.capture())
            self.assertTrue(self.e['FQR_Quarantine'](0))
            self.w.fail_create=failure
            self.assertFalse(self.recover())
            self.assertEqual(item['raw'],1135)
            self.assertEqual(self.e['FQR_AuxCount'][0],0)
            self.w.fail_create=0
            self.assertTrue(self.recover())
            self.verify_originals(before)

    def test_last_player_full_ability_bound_and_reference_release(self):
        self.hero['owner']=7
        self.gaya['owner']=7
        for position in range(57):
            if position<36 or position>=45: raw=1100+position
            else: raw=1000+position-36
            self.w.definitions[raw]=list(range(1,17))
            self.original(position)
        self.assertTrue(self.e['FSJ_Capture'](7,self.hero,self.gaya,self.house,True))
        self.assertTrue(self.e['FQR_Begin'](7,self.table))
        self.assertEqual(self.e['FQR_AbilityId'][7295],16)
        self.assertTrue(self.e['FQR_Quarantine'](7))
        self.assertTrue(self.e['FQR_Recover'](7,SPACER,RING_FILLER,30))
        self.assertTrue(self.e['FQR_Release'](7))
        self.assertIsNone(self.e['FQR_Ability'][7295])

    def test_reentrant_public_calls_are_refused_during_movement(self):
        self.original(5)
        self.assertTrue(self.capture())
        reentries=[]
        self.w.callback=lambda:reentries.extend([self.e['FQR_Quarantine'](0),self.recover(),self.e['FQR_Release'](0),self.e['FSJ_Release'](0)])
        self.assertTrue(self.e['FQR_Quarantine'](0))
        self.assertTrue(self.recover())
        self.assertTrue(reentries)
        self.assertFalse(any(reentries))

    def test_cancel_before_quarantine_never_detaches_originals(self):
        item=self.original(41)
        before=[dict(item)]
        self.assertTrue(self.capture())
        self.w.calls.clear()
        self.assertTrue(self.recover())
        self.assertFalse(any(c[0] in ['detach','unequip','add'] for c in self.w.calls))
        self.verify_originals(before)

    def test_user_allowed_cooldown_refresh_does_not_prevent_item_recovery(self):
        item=self.original(5)
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        item['cooldown']=0.
        self.assertTrue(self.recover())
        self.assertEqual(item['cooldown'],0.)
        self.assertEqual(self.e['FQR_State'][0],5)  # Items restored, not full session equality.

    def test_source_crlf_never_removes_original_or_changes_ability_instances(self):
        self.assertNotIn(b'\n',RECOVERY.read_bytes().replace(b'\r\n',b''))
        text=RECOVERY.read_text()
        self.assertIn('RemoveItem(FQR_AuxItem[index])',text)
        for forbidden in ['RemoveItem(FSJ_Item','RemoveItem(carried)','BlzItemAddAbility(',
                          'BlzItemRemoveAbility(','UnitResetCooldown(','FSC_Decode(','initializer ']:
            self.assertNotIn(forbidden,text)


if __name__=='__main__': unittest.main()

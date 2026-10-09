"""Explicit profile -> actual guarded JASS inventory calls, with mocked natives."""
import json
from pathlib import Path
import unittest
import test_save_cargo_placement as placement_tests
from test_save_jass import engine, SOURCE
from test_save_units import MODULES
from test_save_references import REFERENCES
from test_save_body import BODY
from test_save_ownership import OWNERSHIP
from test_save_prepared_heroes import PREPARED, SKILL_GLOBALS
from test_save_activation import ACTIVATION
from test_save_cargo import CARGO
from test_save_session import SESSION_GLOBALS
from test_save_progression_journal import DECLARATIONS
from test_save_heroes import EXTRA
from test_save_equipment import EquipmentWorld, POLICY, RING_FILLER
from test_save_position import SPACER, InventoryWorld, Handle
from test_save_inventory_plan import record, envelope
import save_vnext as codec
import migrate_save as migration
from test_save_migration import CASES

PROFILE=SOURCE.with_name('Forsaken-save-inventory-profile.j')
CATALOG=json.loads(SOURCE.with_name('save-identities.json').read_text())['items']
MAPPING=json.loads((SOURCE.parents[2]/'release/Forsaken/gear-slots-BS.json').read_text())
GLOBALS='globals\n integer array udg_ItemIdTable\n hashtable ForsakenDefenseTypes=null\n hashtable ForsakenGearTypes=null\nendglobals\n'


class InventoryProfileTests(unittest.TestCase):
    def setUp(self):
        placement_tests.CargoPlacementTests.setUp(self)
        old=self.e
        sources='\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in MODULES)
        env=self.w.natives();env.update(HaveSavedInteger=lambda t,p,k:(p,k) in t or ('integer',p,k) in t)
        self.e=engine(DECLARATIONS+EXTRA+SESSION_GLOBALS+SKILL_GLOBALS+GLOBALS+sources+
            REFERENCES.read_text()+BODY.read_text()+OWNERSHIP.read_text()+PREPARED.read_text()+
            ACTIVATION.read_text()+CARGO.read_text()+PROFILE.read_text(),env)
        self.e.update({k:v for k,v in old.items() if not callable(v)})
        self.e['BlzItemRemoveAbility']=lambda item,raw:EquipmentWorld.remove_ability(self.w,item,raw)
        self.policy={};defense={};gear={};self.ids={r['rawcode']:r['id'] for r in CATALOG}
        slots={'Head':0,'Chest':1,'Gloves':2,'Boots':3,'Ring':4,'Primary':6,'Offhand':7,'Trinket':8}
        for r in CATALOG:
            self.e['udg_ItemIdTable'][r['id']]=r['rawcode'];self.policy[0,r['id']]=r['rawcode']
        for raw,m in MAPPING.items():
            if 'variant' in m:
                v=m['variant'];defense[0,raw]=v;gear[0,raw]=v;gear[1,raw]=slots[m['slot']]
                self.w.types[v]=slots[m['slot']]
                if 'offhand' in m:
                    g=m['offhand'];defense[1,raw]=g;gear[6,g]=v;self.w.types[g]=7
        self.e['ForsakenDefenseTypes']=defense;self.e['ForsakenGearTypes']=gear
        def create(raw,x,y):
            # Real rawcodes are strings in this interpreter; numeric subtraction
            # in the older equipment fixture is only a synthetic type shortcut.
            item=InventoryWorld.create(self.w,raw,x,y)
            if item is not None:
                item['equipment']=self.w.types.get(raw,999)
                item['abilities']=list(self.w.definitions.get(raw,[10,20,30]))
                item['ability_objects']={a:Handle(raw=a) for a in item['abilities']}
            return item
        self.e['CreateItem']=create

    def core(self,stage=0,pid=0,level=11): return placement_tests.CargoPlacementTests.core(self,stage,pid,level)

    def ready(self,pid=0):
        placement_tests.CargoPlacementTests.ready(self,pid)
        self.assertTrue(self.e['FCG_Recover'](pid));self.assertTrue(self.e['FCG_Release'](pid))

    def begin(self,rows,pid=0):
        source=envelope(rows);code=codec.encode(source)
        self.assertTrue(self.e['FIP_Begin'](pid,code,42,self.policy));return code

    def apply(self,pid=0):
        for _ in range(self.e['FIP_Count'][pid]):self.assertTrue(self.e['FIP_StageNext'](pid))
        for _ in range(self.e['FIP_Count'][pid]):self.assertTrue(self.e['FIP_PrepareNext'](pid,POLICY))
        for _ in range(self.e['FIP_Count'][pid]):self.assertTrue(self.e['FIP_PlaceNext'](pid,SPACER,RING_FILLER,30))
        self.assertTrue(self.e['FIP_Seal'](pid));self.assertTrue(self.e['FCG_Verify'](pid))

    def close(self,pid=0):
        self.assertTrue(self.e['FIP_Recover'](pid));self.assertTrue(self.e['FIP_Release'](pid))
        import test_save_prepared_heroes as prepared_tests
        prepared_tests.PreparedTests.cleanup(self,pid)

    def gear_id(self,slot):
        return self.ids[next(raw for raw,m in MAPPING.items() if m['slot']==slot and 'variant' in m)]

    def test_complete51_profile_freezes_and_drives_exact_native_route(self):
        self.ready();rows=[];names=('Head','Chest','Gloves','Boots','Ring','Ring','Primary','Offhand','Trinket')
        for h,n in ((1,6),(2,30),(3,9),(4,6)):
            for s in range(n):
                identity=self.gear_id(names[s]) if h==3 else self.gear_id('Boots')
                rows.append(record(identity,h,s,len(rows)+1,127,True))
        before=self.e['FSC_Code'][0];code=self.begin(rows)
        self.assertEqual(self.e['FIP_Code'][0],code);self.assertEqual(self.e['FIP_Count'][0],51)
        self.apply();self.assertEqual(self.e['FSC_Code'][0],before)
        self.assertEqual(self.e['FIP_Count'][0],51);self.close()

    def test_primary_in_offhand_and_explicit_reviewed_default(self):
        self.ready(7);identity=self.gear_id('Primary');raw=CATALOG[identity-1]['rawcode']
        alternate=MAPPING[raw]['offhand'];self.policy[4,alternate]=0
        self.begin([record(identity,3,7,quantity=None)],7)
        self.assertEqual(self.e['FIP_Raw'][7*57],alternate);self.apply(7)
        item=self.e['FSN_Item'][7*57];self.assertEqual((item['binding'],item['charges']),(8,0));self.close(7)

    def test_unknown_records_and_optional_metadata_preserve_entire_code(self):
        self.ready();known=record(self.gear_id('Boots'))
        optional=known[:6]+(known[6]+((100,False,'ABC'),),)
        code=self.begin([optional,record(1000,slot=29,ordinal=2)])
        self.assertEqual(self.e['FIP_Dormant'][0],2);self.assertEqual(self.e['FIP_Count'][0],0)
        self.assertEqual(self.e['FIP_Code'][0],code);self.assertTrue(self.e['FIP_Seal'](0));self.close()

    def test_house_wrong_account_cheat_and_legacy_refuse_before_cargo_begin(self):
        self.ready();identity=self.gear_id('Boots');house=codec.encode(envelope([record(identity,5,0)]))
        self.assertFalse(self.e['FIP_Begin'](0,house,42,self.policy))
        unknown_house=codec.encode(envelope([record(1000,5,0)]))
        self.assertFalse(self.e['FIP_Begin'](0,unknown_house,42,self.policy))
        source=envelope([record(identity)]);code=codec.encode(source)
        self.assertFalse(self.e['FIP_Begin'](0,code,43,self.policy))
        sections=[]
        for s in source.sections:
            if s.id==4:s=codec.Section(4,1,True,codec.pairs([(i,1 if i==11 else v) for i,v in codec.read_pairs(s.payload)]))
            sections.append(s)
        self.assertFalse(self.e['FIP_Begin'](0,codec.encode(codec.Envelope(42,tuple(sections))),42,self.policy))
        migrated=migration.translate(CASES[0]['code'])
        self.assertFalse(self.e['FIP_Begin'](0,codec.encode(migrated),migrated.account_hash,self.policy))
        self.assertEqual(self.e['FCG_State'][0],0);self.assertFalse(self.e['FSJ_CargoPending'][0])

    def test_existing_house_contents_refuse_even_without_saved_house_records(self):
        self.ready()
        item=self.w.create(SPACER,0,0)
        self.house['quick'][0]=item
        item['owned']=True
        self.e['FSJ_Item'][51]=item
        for field,native in [('Raw','GetItemTypeId'),('Charges','GetItemCharges'),
                             ('Binding','GetItemUserData'),('Owner','GetItemPlayer'),
                             ('Visible','IsItemVisible'),('Flags','FSJ_ReadFlags')]:
            self.e['FSJ_'+field][51]=self.e[native](item)
        self.assertTrue(self.e['FSL_Pack'](0,self.e['GetWidgetLife'](item)))
        self.e['FSJ_High'][51]=self.e['FSL_High'][0]
        self.e['FSJ_Low'][51]=self.e['FSL_Low'][0]
        self.assertTrue(self.e['FSJ_Verify'](0))
        code=codec.encode(envelope([record(self.gear_id('Boots'))]))
        self.assertFalse(self.e['FIP_Begin'](0,code,42,self.policy))
        self.assertEqual(self.e['FCG_State'][0],0)
        self.assertFalse(self.e['FSJ_CargoPending'][0])
        self.assertEqual(self.e['FSN_Count'][0],0)
        self.assertIs(self.house['quick'][0],item)

    def test_registry_mismatch_slot_mismatch_and_absent_default_refuse(self):
        self.ready();identity=self.gear_id('Boots');code=codec.encode(envelope([record(identity)]))
        self.policy[0,1]='fake';self.assertFalse(self.e['FIP_Begin'](0,code,42,self.policy))
        self.policy[0,1]=self.e['udg_ItemIdTable'][1]
        bad=codec.encode(envelope([record(identity,3,0)]))
        self.assertFalse(self.e['FIP_Begin'](0,bad,42,self.policy))
        no_default=codec.encode(envelope([record(identity,quantity=None)]))
        self.assertFalse(self.e['FIP_Begin'](0,no_default,42,self.policy))
        self.assertEqual(self.e['FSN_Count'][0],0);self.assertEqual(self.e['FIP_State'][0],0)

    def test_failed_native_placement_retains_explicit_target_until_recovered(self):
        self.ready();code=self.begin([record(self.gear_id('Boots'),1,3)])
        self.assertTrue(self.e['FIP_StageNext'](0));self.assertTrue(self.e['FIP_PrepareNext'](0,POLICY))
        self.w.reject_drop=True
        self.assertFalse(self.e['FIP_PlaceNext'](0,SPACER,RING_FILLER,30))
        self.assertEqual(self.e['FIP_State'][0],3);self.assertEqual(self.e['FIP_Code'][0],code)
        self.w.reject_drop=False;self.close()

    def test_incomplete_calls_and_reentry_do_not_advance_counters(self):
        self.ready();self.begin([record(self.gear_id('Boots'))])
        self.assertFalse(self.e['FIP_PrepareNext'](0,POLICY));self.assertFalse(self.e['FIP_Seal'](0))
        attempts=[]
        self.w.callback=lambda:attempts.append((self.e['FIP_StageNext'](0),self.e['FIP_PrepareNext'](0,POLICY),self.e['FIP_Recover'](0)))
        self.apply();self.w.callback=None
        self.assertTrue(attempts);self.assertTrue(all(a==(False,False,False) for a in attempts));self.close()


if __name__=='__main__':unittest.main()

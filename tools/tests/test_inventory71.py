"""Inventory changes still reconcile; preview-only idle ticks never rebuild gear."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from inventory71 import refresh
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class Inventory71Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.before=View(ROOT/'release/development/QuickUI70/FFERPG-QuickUI70.w3x').modules['TEquip']
        cls.source=refresh(cls.before)

    def runtime(self):
        fs=functions(self.source);names=['Inventory71_Scan','Inventory71_Clear','Inventory71_Reconcile','Forsaken_PrepareInventories']
        source='\n'.join(fs[n] for n in names);env=mocks(source)
        state=dict(size=30,level=99,dual=0,grip=0,quick={},bag={},gear={},raw={})
        changes=[]
        env.update(BlzUnitExtendedInventorySize=lambda h:state['size'],GetHeroLevel=lambda h:state['level'],
            GetUnitAbilityLevel=lambda h,r:state['dual'] if r=='A0HP' else state['grip'] if r=='A0GP' else 1,
            GetUnitTypeId=lambda h:0 if h in (None,'removed') else 1,
            UnitItemInSlot=lambda h,s:state['quick'].get(s),
            BlzUnitItemInBagSlot=lambda h,s:state['bag'].get(s),
            BlzUnitItemInEquipmentSlot=lambda h,s:state['gear'].get(s),ConvertLoadoutSlot=lambda s:s,
            GetItemTypeId=lambda item:state['raw'].get(item,1 if item else 0),
            Forsaken_EnableHero=changes.append,ForsakenSaveBlocked=True,
            Inventory71Hero=defaultdict(lambda:None),Inventory71Item=defaultdict(lambda:None),
            Inventory71Raw=defaultdict(int),Inventory71Size=defaultdict(int),Inventory71Level=defaultdict(int),
            Inventory71Dual=defaultdict(int),Inventory71Grip=defaultdict(int))
        e=execute(source,names,env)
        return e,state,changes

    def test_many_preview_only_ticks_reconcile_once(self):
        e,s,changes=self.runtime();s['bag'][1]='water';s['gear'][0]='ice'
        for _ in range(120):e['Inventory71_Reconcile']('loaded',0)
        self.assertEqual(changes,['loaded'])

    def test_native_moves_swaps_and_type_changes_are_detected_without_events(self):
        e,s,changes=self.runtime();s['bag'][1]='water';e['Inventory71_Reconcile']('hero',0)
        s['gear'][1]=s['bag'].pop(1);e['Inventory71_Reconcile']('hero',0)
        s['quick'][3]=s['gear'].pop(1);e['Inventory71_Reconcile']('hero',0)
        s['raw']['water']=999;e['Inventory71_Reconcile']('hero',0)
        e['Inventory71_Reconcile']('hero',0)
        self.assertEqual(len(changes),4)

    def test_loaded_job_change_level_and_dual_changes_reconcile(self):
        e,s,changes=self.runtime()
        e['Inventory71_Reconcile']('loaded',0);e['Inventory71_Reconcile']('newjob',0)
        s['level']=100;e['Inventory71_Reconcile']('newjob',0)
        s['dual']=1;e['Inventory71_Reconcile']('newjob',0)
        s['grip']=1;e['Inventory71_Reconcile']('newjob',0)
        self.assertEqual(len(changes),5)

    def test_snapshot_records_post_conversion_state_and_is_separate_per_player(self):
        e,s,changes=self.runtime();s['bag'][1]='old'
        def convert(h):changes.append(h);s['bag'][1]='converted'
        e['Forsaken_EnableHero']=convert
        e['Inventory71_Reconcile']('hero',0);e['Inventory71_Reconcile']('hero',0)
        self.assertEqual(changes,['hero'])
        e['Inventory71_Reconcile']('other',1);self.assertEqual(changes,['hero','other'])

    def test_departure_clears_cached_handles_and_skips_native_bag_read(self):
        e,s,changes=self.runtime();s['bag'][1]='water';e['Inventory71_Reconcile']('hero',0)
        e['BlzUnitExtendedInventorySize']=lambda h:self.fail('removed hero inventory queried')
        e['Inventory71_Reconcile']('removed',0)
        self.assertIsNone(e['Inventory71Hero'][0]);self.assertIsNone(e['Inventory71Item'][7])
        self.assertEqual(changes,['hero'])

    def test_existing_inventory_abilities_are_not_readded_on_gear_change(self):
        source=functions(self.source)['Forsaken_EnableHero'];env=mocks(source);writes=[]
        env.update(GetUnitTypeId=lambda h:1,GetUnitAbilityLevel=lambda *a:1,
            UnitAddAbility=lambda *a:writes.append(a),UnitMakeAbilityPermanent=lambda *a:writes.append(a),
            Forsaken_TwoHandedWeapon=lambda h:'weapon',Forsaken_ElementAbilityLevel=lambda *a:1)
        e=execute(source,['Forsaken_EnableHero'],env);e['Forsaken_EnableHero']('hero')
        self.assertEqual(writes,[])
        e['GetUnitAbilityLevel']=lambda *a:0;e['Forsaken_EnableHero']('fresh')
        self.assertEqual(len(writes),6)

    def test_input_icons_previews_and_gameplay_functions_are_unchanged(self):
        a,b=functions(self.before),functions(self.source)
        self.assertEqual({n for n in a if tokens(a[n])!=tokens(b[n])},
            {'Forsaken_EnableHero','Forsaken_PrepareInventories'})
        for n in ['Inventory71_Scan','Inventory71_Clear','Inventory71_Reconcile']:
            self.assertNotIn('GetLocalPlayer',b[n]);self.assertNotIn('BlzIsLocalClientActive',b[n])

if __name__=='__main__':unittest.main()

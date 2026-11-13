"""Removed players' cached heroes never reach native inventory maintenance."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from editor_pair import View
from leave_guard70 import refresh
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-Forsaken.w3x'

class LeaveGuardTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.before=View(BASE).modules['TEquip'];cls.source=refresh(cls.before)

    def test_removed_hero_enable_never_touches_inventory(self):
        source=functions(self.source)['Forsaken_EnableHero'];env=mocks(source);calls=[]
        env.update(GetUnitTypeId=lambda h:0 if h in (None,'removed') else 1,
            UnitAddAbility=lambda *a:calls.append(a),Forsaken_TwoHandedWeapon=lambda h:None,
            GetUnitAbilityLevel=lambda *a:0,Forsaken_ElementAbilityLevel=lambda *a:0)
        e=execute(source,['Forsaken_EnableHero'],env)
        for hero in (None,'removed'):e['Forsaken_EnableHero'](hero)
        self.assertEqual(calls,[])
        e['Forsaken_EnableHero']('live');self.assertEqual(len(calls),3)

    def test_maintenance_skips_cached_removed_player_and_keeps_live_player(self):
        source=functions(self.source)['Forsaken_PrepareInventories'];calls=[];env=mocks(source)
        env.update(ForsakenSaveBlocked=True,Player=lambda i:i,
            Player_GetHero=lambda p:{0:'removed',1:'live'}.get(p),
            GetUnitTypeId=lambda h:0 if h=='removed' else 1,Forsaken_EnableHero=calls.append)
        e=execute(source,['Forsaken_PrepareInventories'],env);e['Forsaken_PrepareInventories']()
        self.assertEqual(calls,['live'])

    def test_deferred_rebind_validates_removed_owner_before_native_bag_read(self):
        source=functions(self.source)['Forsaken_RebindBag'];env=mocks(source);destroyed=[]
        def reject(*a):self.fail('native inventory accessed for removed owner')
        env.update(ForsakenBagAbilities='table',GetExpiredTimer=lambda:'clock',GetHandleId=lambda h:1,
            LoadUnitHandle=lambda *a:'removed',GetUnitTypeId=lambda h:0,
            GetOwningPlayer=lambda h:0,Player_GetHero=lambda p:'removed',
            BlzUnitExtendedInventorySize=reject,BlzUnitItemInBagSlot=reject,
            DestroyTimer=destroyed.append)
        e=execute(source,['Forsaken_RebindBag'],env);e['Forsaken_RebindBag']()
        self.assertEqual(destroyed,['clock'])

    def test_all_other_functions_including_casting_and_previews_unchanged(self):
        before,after=functions(self.before),functions(self.source)
        changed={n for n in before if tokens(before[n])!=tokens(after[n])}
        self.assertEqual(changed,{'Forsaken_EnableHero','Forsaken_PrepareInventories','Forsaken_RebindBag'})

if __name__=='__main__':unittest.main()

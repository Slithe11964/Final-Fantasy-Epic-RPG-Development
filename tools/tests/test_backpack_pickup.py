"""Real pickup/deferred routing fills gear kinds without replacing or copying items."""
import unittest
from pathlib import Path
from unittest.mock import patch
import test_quest_lifecycle as harness

SOURCE=Path(__file__).resolve().parents[2]/'src/triggers/05 Items crafting and shops/Backpack.j'

class PickupTests(unittest.TestCase):
    def setUp(self):
        self.bags={};self.types={};self.charges={};self.checks=[];self.event={};self.reject=set()
        holders={}
        for pid in (0,1):
            self.bags['hero'+str(pid)]=[None]*6
            for page in range(7):
                u='holder'+str(pid)+':'+str(page);holders[pid*8+page]=u;self.bags[u]=[None]*6
                if page==1:
                    for slot in range(3,6):
                        raw='locked'+str(pid)+str(slot);self.types[raw]=0;self.bags[u][slot]=raw
        def remove(u,i):
            if i in self.bags[u]:self.bags[u][self.bags[u].index(i)]=None
        def add(u,i):
            self.assertTrue(self.e['BackpackMoving'][owner(u)])
            if u in self.reject or None not in self.bags[u]:return False
            for old in self.bags:remove(old,i)
            self.bags[u][self.bags[u].index(None)]=i
            saved=self.event.copy();self.event.update(unit=u,item=i)
            self.e['Backpack_OnPickup']()
            self.event.clear();self.event.update(saved)
            return True
        def owner(u):return int(u[6]) if u.startswith('holder') else int(u[-1])
        def pageof(pid,u):
            for page in range(7):
                if holders[pid*8+page]==u:return page
            return -1
        env=dict(BACKPACK_SLOTS=6,BACKPACK_PAGES=7,BACKPACK_EQUIPMENT_PAGES=2,
            GEAR_PRIMARY=1,GEAR_BOOTS=6,GEAR_RING=7,GEAR_TRINKET=8,BACKPACK_HOLDER='tBpk',bj_MAX_PLAYERS=2,
            BackpackHolder=holders,Backpack_PageHolder=lambda pid,p:holders[pid*8+p],
            Backpack_PageOf=pageof,Gear_KindOf=lambda i:self.types.get(i,0),
            GetItemTypeId=lambda i:i if i in self.types else 0,IsItemPowerup=lambda i:False,
            UnitItemInSlot=lambda u,n:self.bags[u][n],UnitHasItem=lambda u,i:i in self.bags.get(u,[]),
            UnitRemoveItem=remove,UnitAddItem=add,SetItemPosition=lambda *a:None,
            GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,Player=lambda pid:pid,
            GetOwningPlayer=owner,GetPlayerId=lambda p:p,Player_GetHero=lambda pid:'hero'+str(pid),
            GetItemName=lambda i:i,Gear_KindName=lambda k:str(k),DisplayTimedTextToPlayer=lambda *a:None,
            GetTriggerUnit=lambda:self.event['unit'],GetManipulatedItem=lambda:self.event['item'],
            GetTriggerPlayer=lambda:0,GetEventPlayerChatString=lambda:'-take 1',
            S2I=int,SubString=lambda s,a,b:s[a:b],StringLength=len,
            Backpack_Holder=lambda pid:holders[pid*8+self.e['BackpackPage'][pid]],
            GetUnitTypeId=lambda u:'tBpk' if u.startswith('holder') else 'hero',
            BackpackPendingItem={0:None,1:None},BackpackPendingPage={0:2,1:2},
            BackpackPage={0:2,1:2},BackpackShown={0:False,1:False},BackpackMoving={0:False,1:False},
            BackpackEquipPending={i:None for i in range(128)},BackpackEquipCarrier={i:None for i in range(128)},
            BackpackDefer={0:'clock0',1:'clock1'},GetExpiredTimer=lambda:self.clock,
            Backpack_QueueWork=lambda pid:None,Backpack_OnHolderChange=lambda:None,
            Backpack_CheckPage=lambda pid,page:self.checks.append((pid,page)),Backpack_StripQuickSlots=lambda pid:None,
            BackpackCdAbility={0:0,1:0},BackpackSettleMana={0:False,1:False},
            Backpack_WearBlock=lambda pid,i:None)
        names=['Backpack_StoreOn','Backpack_Store','Backpack_PageLimit','Backpack_TryEquipPickup',
            'Backpack_QueueEquipPickup','Backpack_OnPickup','Backpack_RunDeferred','Backpack_OnCommand']
        with patch.object(harness,'SELECTED',[]):self.e=harness.load_engine(SOURCE.read_text(),names,env)

    def pickup(self,item,kind,u='hero0'):
        self.types[item]=kind;self.charges[item]=7
        self.bags[u][self.bags[u].index(None)]=item
        self.event.update(unit=u,item=item);self.e['Backpack_OnPickup']()

    def run_pending(self,pid=0):
        self.clock='clock'+str(pid);self.e['Backpack_RunDeferred']()

    def test_book_and_loaded_gear_fill_missing_pages_even_with_bag_open(self):
        self.e['BackpackShown'][0]=True
        for raw,kind in [('I05X',2),('chest',4),('helmet',3),('trinket',8),('weapon',1)]:self.pickup(raw,kind)
        self.assertNotIn('I05X',self.bags['holder0:0']) # no move inside the pickup event
        self.run_pending()
        self.assertEqual(set(i for i in self.bags['holder0:0'] if i),{'I05X','chest','helmet','weapon'})
        self.assertIn('trinket',self.bags['holder0:1'])
        self.assertTrue(all(i is None for i in self.bags['hero0']))
        self.assertTrue(all(v==7 for v in self.charges.values()))
        self.assertEqual(self.checks,[(0,0),(0,1)])

    def test_open_bag_holder_pickup_also_equips(self):
        self.pickup('offhand',2,'holder0:2');self.run_pending()
        self.assertIn('offhand',self.bags['holder0:0']);self.assertNotIn('offhand',self.bags['holder0:2'])

    def test_occupied_kind_and_extra_ring_keep_existing_gear(self):
        self.e['BackpackShown'][0]=True
        for raw,kind in [('old',2),('ring1',7),('ring2',7)]:self.pickup(raw,kind)
        self.run_pending()
        for raw,kind in [('new',2),('ring3',7),('potion',0)]:self.pickup(raw,kind)
        self.run_pending()
        self.assertIn('old',self.bags['holder0:0']);self.assertNotIn('new',self.bags['holder0:0'])
        self.assertIn('new',self.bags['hero0']+self.bags['holder0:2'])
        self.assertNotIn('ring3',self.bags['holder0:1'])
        self.assertNotIn('potion',self.bags['holder0:0']+self.bags['holder0:1'])

    def test_internal_store_does_not_re_equip_intentionally_bagged_gear(self):
        self.types['weapon']=1;self.bags['holder0:0'][0]='weapon'
        self.assertTrue(self.e['Backpack_StoreOn'](0,2,'holder0:0','weapon'))
        self.run_pending();self.assertIn('weapon',self.bags['holder0:2'])
        self.assertTrue(all(i is None for i in self.e['BackpackEquipPending'].values()))

    def test_take_command_leaves_gear_on_hero_until_a_real_pickup(self):
        self.types['weapon']=1;self.bags['holder0:0'][0]='weapon'
        self.e['BackpackPage'][0]=0;self.e['BackpackShown'][0]=True
        self.e['Backpack_OnCommand']();self.run_pending()
        self.assertIn('weapon',self.bags['hero0'])
        self.assertTrue(all(i is None for i in self.bags['holder0:0']))

    def test_failed_equipment_add_restores_same_item_and_player_isolation(self):
        self.reject.add('holder0:0');self.pickup('weapon0',1);self.pickup('weapon1',1,'hero1')
        self.run_pending(0);self.run_pending(1)
        self.assertIn('weapon0',self.bags['hero0']);self.assertIn('weapon1',self.bags['holder1:0'])
        self.assertEqual(sum(u.count('weapon0') for u in self.bags.values()),1)
        self.assertFalse(self.e['BackpackMoving'][0]);self.assertFalse(self.e['BackpackMoving'][1])

    def test_dropped_candidate_is_not_equipped_and_later_pickup_can_retry(self):
        self.pickup('chest',4);self.bags['hero0'][0]=None;self.run_pending()
        self.assertNotIn('chest',self.bags['holder0:0'])
        self.pickup('chest',4);self.run_pending();self.assertIn('chest',self.bags['holder0:0'])

if __name__=='__main__':unittest.main()

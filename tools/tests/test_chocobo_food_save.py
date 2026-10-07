"""Execute inventory saving/loading, including Speedrun discards and bit alignment."""
from collections import defaultdict
import copy
import json
import unittest
from test_armory_materia import execute, CMD, SAVE, ARMORY, CONTRACT
from test_shared_context import mocks
from source_checks import ROOT, sources
from check_save_compat import assignments, compare, snapshot, FOOD_EXTENSION
import savecode

FOOD = dict(zip(range(352,359),['I045','I07F','I07G','I07H','I027','I07Q','I0KE']))
HELPERS=['Trig_Cmd_Load_Code_IsChocoboFood','Trig_Cmd_Load_Code_ItemAllowed']
IDS={**{int(i):raw for i,raw in CONTRACT['items'].items()},**FOOD}
INDEX={raw:i for i,raw in IDS.items()}
CHARGED={int(i):v for i,v in CONTRACT['charged'].items()}|{i:True for i in FOOD}


def runtime(speedrun, inventory=(), stream=(), version=7, legacy_blocked=()):
    source=SAVE.read_text()+'\n'+CMD.read_text()
    env=mocks(source)
    inv=list(inventory)+[None]*(6-len(inventory))
    writes=[]
    queue=list(stream)
    removed=[]
    def read(sid,width):
        value,size=queue.pop(0)
        assert width==size,(width,size)
        return value
    def create(raw,x,y):
        return {'raw':raw,'qty':1,'owner':0}
    def add(u,item):
        for i in range(6):
            if inv[i] is None:
                inv[i]=item
                return True
        return False
    env.update(udg_SpeedrunMode=speedrun,udg_SavePlayer=defaultdict(int,{0:1}),
               udg_SaveVersion=defaultdict(int,{0:version}),
               udg_ItemIdTable=defaultdict(int,IDS),udg_SaveFlagForce=defaultdict(set,{i:{9} for i in legacy_blocked}),
               udg_IsAutosave=True,bj_MAX_INVENTORY=6,ITEM_TYPE_CHARGED='charged',
               GetPlayerId=lambda p:p-1,GetUnitX=lambda u:0,GetUnitY=lambda u:0,
               UnitItemInSlot=lambda u,i:inv[i],GetItemTypeId=lambda i:i['raw'] if i else 0,
               LoadInteger=lambda h,p,raw:INDEX.get(raw,0),GetItemUserData=lambda i:i['owner'],
               GetItemType=lambda i:'charged' if CHARGED[INDEX[i['raw']]] else 'permanent',
               GetItemCharges=lambda i:i['qty'],SetItemUserData=lambda i,owner:i.update(owner=owner),
               SetItemCharges=lambda i,qty:i.update(qty=qty),GetItemName=lambda i:i['raw'],
               Save_WriteBits=lambda sid,value,width:writes.append((value,width)),
               Trig_Cmd_Load_Code_ReadBits=read,CreateItem=create,UnitAddItem=add,
               RemoveItem=removed.append,UnitRemoveItemFromSlot=lambda u,i:inv.__setitem__(i,None),
               Player=lambda p:p,IsPlayerInForce=lambda p,f:p in f,
               Trig_Cmd_Load_Code_CharToValue=lambda c:5)
    env=execute(source,HELPERS+['Save_EncodeInventory','Trig_Cmd_Load_Code_LoadInventory'],env)
    return env,inv,writes,queue,removed


class ChocoboFoodSaveTests(unittest.TestCase):
    def test_seven_food_indexes_are_appended_and_quantities_classified(self):
        _,texts=sources()
        items,errors=assignments(texts,'udg_ItemIdTable')
        self.assertFalse(errors)
        self.assertEqual({int(i):raw for i,raw in items.items() if int(i)>351},FOOD)
        table=savecode.load_items(str(ROOT/'src/itemtable.txt'))
        for i,raw in FOOD.items():
            self.assertEqual(table[i]['id'],raw)
            self.assertTrue(table[i]['charged'])
        self.assertIn('set udg_SaveFlagCount=358',ARMORY.read_text())

    def test_all_food_quantities_save_and_load_outside_speedrun(self):
        for difficulty in range(7):
            for index,raw in FOOD.items():
                with self.subTest(difficulty=difficulty,item=raw):
                    item={'raw':raw,'qty':99,'owner':0}
                    env,inv,writes,_,_=runtime(False,[item])
                    env['udg_Difficulty']=difficulty
                    env['Save_EncodeInventory'](0,'hero')
                    self.assertEqual(writes,[(1,3),(index,9),(99,7)])
                    load,inv,_,queue,removed=runtime(False,stream=writes+[(77,13)])
                    load['udg_Difficulty']=difficulty
                    load['Trig_Cmd_Load_Code_LoadInventory'](0,'hero')
                    self.assertEqual([i for i in inv if i],[{'raw':raw,'qty':99,'owner':1}])
                    self.assertEqual(load['Trig_Cmd_Load_Code_ReadBits'](0,13),77)
                    self.assertFalse(queue)
                    self.assertFalse(removed)

    def test_speedrun_saving_omits_food_and_keeps_other_owned_items(self):
        food={'raw':'I045','qty':19,'owner':0}
        potion={'raw':'phea','qty':7,'owner':0}
        sword={'raw':'I00U','qty':1,'owner':1}
        env,inv,writes,_,_=runtime(True,[food,potion,sword])
        env['Save_EncodeInventory'](0,'hero')
        self.assertEqual(writes,[(2,3),(7,9),(7,7),(29,9)])
        self.assertEqual(food['owner'],0)
        for index,raw in FOOD.items():
            env,_,writes,_,_=runtime(True,[{'raw':raw,'qty':99,'owner':0}])
            env['Save_EncodeInventory'](0,'hero')
            self.assertEqual(writes,[(0,3)])

    def test_speedrun_loading_discards_food_and_keeps_following_item_alignment(self):
        for index in FOOD:
            stream=[(3,3),(index,9),(99,7),(29,9),(7,9),(17,7),(77,13)]
            env,inv,_,queue,removed=runtime(True,stream=stream)
            env['Trig_Cmd_Load_Code_LoadInventory'](0,'hero')
            self.assertEqual([i for i in inv if i],[{'raw':'I00U','qty':1,'owner':1},{'raw':'phea','qty':17,'owner':1}])
            self.assertEqual(len(removed),1)
            self.assertEqual(removed[0]['raw'],FOOD[index])
            self.assertEqual(env['Trig_Cmd_Load_Code_ReadBits'](0,13),77)
            self.assertFalse(queue)
        env,inv,_,_,removed=runtime(True,stream=[(2,3),(352,9),(3,7),(358,9),(9,7)])
        env['Trig_Cmd_Load_Code_LoadInventory'](0,'house')
        self.assertFalse(any(inv))
        self.assertEqual(len(removed),2)

    def test_ownership_and_legacy_rejection_are_preserved(self):
        env,_,writes,_,_=runtime(False,[{'raw':'I07H','qty':17,'owner':2}])
        env['Save_EncodeInventory'](0,'gaya')
        self.assertEqual(writes,[(0,3)])
        for speedrun in [False,True]:
            env,inv,_,queue,removed=runtime(speedrun,stream=[(2,3),(7,9),(9,7),(29,9)],version=5,legacy_blocked=[7])
            env['Trig_Cmd_Load_Code_LoadInventory'](0,'hero')
            self.assertEqual([i['raw'] for i in inv if i],['I00U'])
            self.assertEqual(len(removed),1)
            self.assertFalse(queue)

    def test_reviewed_food_policy_rejects_changed_mode_filter(self):
        current,errors=snapshot(ROOT/'baseline/Reforged/FFERPG_0.9.7.3-r16.w3x')
        self.assertFalse(errors)
        self.assertEqual(compare(current,CONTRACT),[])
        changed=copy.deepcopy(current)
        changed['serializers'][HELPERS[1]]='wrong'
        self.assertTrue(any('Speedrun filter' in e for e in compare(changed,CONTRACT)))
        changed=copy.deepcopy(current)
        changed['charged']['358']=False
        self.assertTrue(any('charge classification' in e for e in compare(changed,CONTRACT)))

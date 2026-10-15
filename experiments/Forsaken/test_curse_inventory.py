"""Run native curse item lookup and replacement against the real recipe/gear tables."""
from collections import defaultdict
from pathlib import Path
import json
import sys
import unittest

ROOT=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(ROOT/'tools'),str(ROOT/'tools/tests')]
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions

SOURCE=Path(__file__).with_name('Forsaken-curse.j').read_text()
RECIPES=(ROOT/'src/triggers/05 Items crafting and shops/Recipe.j').read_text()
CATALOG=json.loads((ROOT/'release/Forsaken/gear-slots-BS.json').read_text())


def runtime():
    e=mocks(SOURCE+'\n'+RECIPES)
    hero={'owner':0,'quick':[None]*6,'bags':[None]*30,'gear':[None]*9}
    gaya={'owner':0,'quick':[None]*6,'bags':[],'gear':[None]*9}
    units=[hero,gaya]
    mapping={}
    for raw,record in CATALOG.items():
        if record.get('variant'):
            mapping[0,raw]=record['variant']
            mapping[4,record['variant']]=raw
            if record.get('offhand'):
                mapping[4,record['offhand']]=raw
                mapping[5,record['variant']]=record['offhand']
                mapping[6,record['offhand']]=record['variant']
    e.update(ForsakenGearTypes=mapping,ForsakenBagAbilities={},ForsakenConvertingGear=False,
        GetOwningPlayer=lambda u:u['owner'],Player_GetHero=lambda p:hero if p==0 else None,
        GetConvertedPlayerId=lambda p:p+1,udg_SpiritOfGaya=defaultdict(lambda:None,{1:gaya}),
        UnitExtendedInventorySize=lambda u:len(u['bags']),ConvertLoadoutSlot=lambda i:i,
        UnitItemInSlot=lambda u,i:u['quick'][i],UnitItemInBagSlot=lambda u,i:u['bags'][i],
        UnitItemInEquipmentSlot=lambda u,i:u['gear'][i],
        GetItemTypeId=lambda i:i['raw'] if i and not i.get('removed') else 0,
        LoadInteger=lambda table,a,b:table.get((a,b),0),
        GetUnitX=lambda u:0,GetUnitY=lambda u:0,GetHandleId=id,
        GetItemName=lambda i:i['name'],StringLength=len,SubString=lambda s,a,b:s[a:b],
        GetRectCenterX=lambda r:0,GetRectCenterY=lambda r:0,gg_rct_227='Lady Curse',
        near=True,reject=False,creation_failure=False,created=[],messages=[],guard_checks=[])
    for name in ('Name','Result','Item1','Item2','Item3','Item4','Item5','Item6',
                 'Charges1','Charges2','Count3','Count4','Count5','Count6'):
        e['udg_Recipe'+name]=defaultdict(lambda:None) if name=='Name' else defaultdict(int)
    def contains(u,i,kind):
        return any(v is i for v in u[kind])
    def remove(i):
        for u in units:
            for kind in ('quick','bags','gear'):
                for index,v in enumerate(u[kind]):
                    if v is i:u[kind][index]=None
    def add(u,i):
        live['guard_checks'].append(live['ForsakenConvertingGear'])
        if live['reject'] and i in live['created']:return False
        for kind in ('quick','bags'):
            for n,v in enumerate(u[kind]):
                if v is None:
                    u[kind][n]=i
                    return True
        return False
    def create(raw,x,y):
        if live['creation_failure']:return None
        i={'raw':raw,'removed':False}
        live['created'].append(i)
        return i
    def equip(u,i):
        n=next((n for n,v in enumerate(u['gear']) if v is None),None)
        if n is None:return False
        remove(i);u['gear'][n]=i
        return True
    def destroy(i):
        remove(i);i['removed']=True
    e.update(UnitHasItem=lambda u,i:contains(u,i,'quick'),
        UnitHasItemBagged=lambda u,i:contains(u,i,'bags'),
        UnitHasItemEquipped=lambda u,i:contains(u,i,'gear'),
        UnitUnequipItem=lambda u,i:remove(i),UnitRemoveItem=lambda u,i:remove(i),
        UnitAddItem=add,UnitEquipItem=equip,CreateItem=create,RemoveItem=destroy,
        IsUnitInRangeXY=lambda *a:live['near'],
        DisplayTimedTextToPlayer=lambda *a:live['messages'].append(a[-1]))
    live=execute(SOURCE+'\n'+RECIPES,list(functions(SOURCE))+['Recipe_InitTables'],e)
    live['Recipe_InitTables']()
    def use(user,name="Crusher's Belt"):
        scroll={'raw':'scroll','name':'Curse: '+name,'removed':False}
        live['GetManipulatingUnit']=lambda:user
        live['GetManipulatedItem']=lambda:scroll
        live['Curse_UseItem']()
        return scroll
    return live,hero,gaya,use


class CurseTests(unittest.TestCase):
    def test_every_bag_slot_works_from_hero_or_gaya_with_native_aliases(self):
        for slot in range(30):
            for caster in ('hero','gaya'):
                e,h,g,use=runtime()
                original={'raw':CATALOG['I031']['variant']}
                h['bags'][slot]=original
                scroll=use(h if caster=='hero' else g)
                self.assertTrue(original['removed'])
                self.assertTrue(scroll['removed'])
                self.assertEqual([i['raw'] for i in e['created']],[CATALOG['I04M']['variant']])
                self.assertFalse(e['ForsakenConvertingGear'])
                self.assertTrue(all(e['guard_checks']))

    def test_all_curse_recipes_transform_one_item_without_requiring_the_legacy_id(self):
        for recipe in range(1,23):
            e,h,g,use=runtime()
            raw=e['udg_RecipeItem1'][recipe]
            original={'raw':CATALOG.get(raw,{}).get('variant') or raw}
            h['bags'][29]=original
            scroll=use(g,e['udg_RecipeName'][recipe])
            self.assertTrue(scroll['removed'],recipe)
            self.assertTrue(original['removed'],recipe)
            result=e['udg_RecipeResult'][recipe]
            self.assertEqual(e['Curse_BaseType'](e['created'][0]),result)

    def test_gaya_and_equipped_items_are_found_but_other_players_items_are_ignored(self):
        for location in ('gaya','equipment'):
            e,h,g,use=runtime()
            original={'raw':'I031' if location=='gaya' else CATALOG['I031']['variant']}
            (g['quick'] if location=='gaya' else h['gear'])[5]=original
            scroll=use(h)
            self.assertTrue(scroll['removed'])
            self.assertTrue(original['removed'])
            if location=='equipment':self.assertTrue(any(i is e['created'][0] for i in h['gear']))
        e,h,g,use=runtime()
        h['owner']=1  # The caller is neither the registered hero nor Gaya of player 1.
        h['bags'][0]={'raw':'I031'}
        self.assertFalse(use(h)['removed'])
        self.assertFalse(e['created'])

    def test_failed_curse_keeps_original_and_scroll_and_clears_conversion_guard(self):
        for failure in ('missing','far','reject','creation_failure','busy'):
            e,h,g,use=runtime()
            original={'raw':'I031'}
            if failure!='missing':h['bags'][29]=original
            if failure=='far':e['near']=False
            if failure in ('reject','creation_failure'):e[failure]=True
            if failure=='busy':e['ForsakenConvertingGear']=True
            scroll=use(g)
            self.assertFalse(scroll['removed'],failure)
            self.assertFalse(original.get('removed',False),failure)
            self.assertEqual(e['ForsakenConvertingGear'],failure=='busy')
            if failure=='reject':self.assertTrue(any(i is original for i in h['quick']+h['bags']))
            self.assertTrue(all(i['removed'] for i in e['created']),failure)

    def test_full_bags_replace_only_one_copy(self):
        e,h,g,use=runtime()
        h['quick']=[{'raw':'filler','slot':n} for n in range(6)]
        h['bags']=[{'raw':'filler','slot':n} for n in range(30)]
        first={'raw':CATALOG['I031']['variant'],'copy':1}
        second={'raw':CATALOG['I031']['variant'],'copy':2}
        h['bags'][28:]=[first,second]
        scroll=use(g)
        self.assertTrue(scroll['removed'])
        self.assertTrue(first['removed'])
        self.assertFalse(second.get('removed',False))
        self.assertEqual(len(e['created']),1)
        self.assertIs(h['bags'][28],e['created'][0])
        self.assertIs(h['bags'][29],second)


if __name__=='__main__':unittest.main()

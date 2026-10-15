"""Curse scrolls see classic pages and retain gear/scrolls on failure."""
from collections import defaultdict
from pathlib import Path
import unittest
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions

ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'src/triggers/04 Combat and abilities/Curse.j').read_text(encoding='utf-8')
RECIPES=(ROOT/'src/triggers/05 Items crafting and shops/Recipe.j').read_text(encoding='utf-8')


def runtime():
    hero={'owner':0,'items':[None]*6,'page':-1}
    gaya={'owner':0,'items':[None]*6,'page':-1}
    pages=[{'owner':0,'items':[None]*6,'page':p} for p in range(7)]
    units=[hero,gaya]+pages
    e=mocks(SOURCE+'\n'+RECIPES)
    e.update(BackpackHolder=defaultdict(lambda:None,enumerate(pages)),BackpackMoving=defaultdict(bool),
        BACKPACK_PAGES=7,BACKPACK_EQUIPMENT_PAGES=2,GetPlayerId=lambda p:p,
        GetOwningPlayer=lambda u:u['owner'],Player_GetHero=lambda p:hero if p==0 else None,
        GetConvertedPlayerId=lambda p:p+1,udg_SpiritOfGaya=defaultdict(lambda:None,{1:gaya}),
        GetItemOfTypeFromUnitBJ=lambda u,raw:next((i for i in u['items'] if i and i['raw']==raw),None) if u else None,
        UnitHasItem=lambda u,i:any(v is i for v in u['items']),
        UnitItemInSlot=lambda u,i:u['items'][i],GetItemTypeId=lambda i:i['raw'] if i else 0,
        Backpack_PageOf=lambda pid,u:u['page'],GetUnitX=lambda u:0,GetUnitY=lambda u:0,
        GetItemName=lambda i:i['name'],StringLength=len,SubString=lambda s,a,b:s[a:b],
        GetRectCenterX=lambda r:0,GetRectCenterY=lambda r:0,
        near=True,reject=False,creation_failure=False,wear_block=False,created=[],messages=[],bonuses=[])
    for name in ('Name','Result','Item1','Item2','Item3','Item4','Item5','Item6',
                 'Charges1','Charges2','Count3','Count4','Count5','Count6'):
        e['udg_Recipe'+name]=defaultdict(lambda:None) if name=='Name' else defaultdict(int)
    def remove(i):
        for u in units:
            for n,v in enumerate(u['items']):
                if v is i:u['items'][n]=None
    def add(u,i):
        if live['reject'] and any(v is i for v in live['created']):return False
        for n,v in enumerate(u['items']):
            if v is None:u['items'][n]=i;return True
        return False
    def create(raw,*args):
        if live['creation_failure']:return None
        i={'raw':raw,'removed':False};live['created'].append(i);return i
    def destroy(i):
        remove(i);i['removed']=True
    e.update(CreateItem=create,UnitAddItem=add,UnitRemoveItem=lambda u,i:remove(i),RemoveItem=destroy,
        IsUnitInRangeXY=lambda *a:live['near'],
        DisplayTimedTextToPlayer=lambda *a:live['messages'].append(a[-1]),
        Backpack_ApplyBonuses=lambda pid:live['bonuses'].append(pid),
        Backpack_TryEquipPickup=lambda pid,carrier,i:False if live['wear_block'] else add(pages[1],i),
        Backpack_Store=lambda pid,carrier,i:any(add(p,i) for p in pages[2:]))
    live=execute(SOURCE+'\n'+RECIPES,list(functions(SOURCE))+['Recipe_InitTables'],e)
    live['Recipe_InitTables']()
    def use(u,name="Crusher's Belt"):
        scroll={'raw':'scroll','name':'Curse: '+name,'removed':False}
        live['GetManipulatingUnit']=lambda:u;live['GetManipulatedItem']=lambda:scroll
        live['Curse_UseItem']();return scroll
    return live,hero,gaya,pages,use


class CursePageTests(unittest.TestCase):
    def test_every_page_slot_and_either_scroll_user(self):
        for page in range(7):
            for slot in range(6):
                for caster in ('hero','gaya'):
                    e,h,g,p,use=runtime();original={'raw':'I031'};p[page]['items'][slot]=original
                    self.assertTrue(use(h if caster=='hero' else g)['removed'])
                    self.assertTrue(original['removed'])
                    self.assertEqual([i['raw'] for i in e['created']],['I04M'])
                    self.assertFalse(e['BackpackMoving'][0])

    def test_quick_slots_gaya_and_all_existing_curses(self):
        for recipe in range(1,23):
            e,h,g,p,use=runtime();original={'raw':e['udg_RecipeItem1'][recipe]};g['items'][5]=original
            self.assertTrue(use(h,e['udg_RecipeName'][recipe])['removed'])
            self.assertTrue(original['removed'])
            self.assertEqual(e['created'][0]['raw'],e['udg_RecipeResult'][recipe])

    def test_equipment_rechecks_wear_rules_and_puts_blocked_result_in_bag(self):
        e,h,g,p,use=runtime();original={'raw':'I031'};p[1]['items'][0]=original;e['wear_block']=True
        self.assertTrue(use(g)['removed'])
        self.assertIs(p[2]['items'][0],e['created'][0])
        self.assertTrue(e['bonuses'])

    def test_missing_far_busy_and_failed_placement_keep_original_and_scroll(self):
        for failure in ('missing','far','busy','reject','creation_failure'):
            e,h,g,p,use=runtime();original={'raw':'I031'}
            if failure!='missing':p[6]['items'][5]=original
            if failure=='far':e['near']=False
            if failure=='busy':e['BackpackMoving'][0]=True
            if failure in ('reject','creation_failure'):e[failure]=True
            self.assertFalse(use(g)['removed'])
            self.assertFalse(original.get('removed',False))
            self.assertEqual(e['BackpackMoving'][0],failure=='busy')
            self.assertTrue(all(i['removed'] for i in e['created']))


if __name__=='__main__':unittest.main()

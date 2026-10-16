"""Execute inventory consolidation, complete travel menus and equipment eligibility."""
from collections import defaultdict
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from jtok import functions
from vjass_lite import resolve_static_ifs
from gameplay_runtime import refresh
ROOT=Path(__file__).resolve().parents[2]
HERE=ROOT/'experiments/Forsaken'


class Item(dict):
    def __eq__(self,other):return self is other
    def __ne__(self,other):return self is not other

def item(raw='I074',charges=1,bound=0):
    return Item(raw=raw,charges=charges,bound=bound,level=99,kind='charged')


class GameplayTests(unittest.TestCase):
    def inventory(self,classic=False):
        units=defaultdict(list);bags=defaultdict(list);gear=defaultdict(list)
        def slot(table,u,i):
            values=table[u]
            return values[i] if 0<=i<len(values) else None
        def field(i,k,default=0):return i.get(k,default) if i else default
        source=resolve_static_ifs((HERE/'CarrySupport.j').read_text(),{'TBackpack'} if classic else set())
        env=dict(GetItemTypeId=lambda i:field(i,'raw'),GetItemType=lambda i:field(i,'kind'),
            GetItemCharges=lambda i:field(i,'charges'),GetItemLevel=lambda i:field(i,'level'),
            GetItemUserData=lambda i:field(i,'bound'),SetItemCharges=lambda i,n:i.update(charges=n),
            SetItemUserData=lambda i,n:i.update(bound=n),RemoveItem=lambda i:i.update(raw=0),
            GetPlayerId=lambda p:p,GetOwningPlayer=lambda u:0,IMinBJ=min,
            ITEM_TYPE_CHARGED='charged',UnitItemInSlot=lambda u,i:slot(units,u,i),
            UnitItemInBagSlot=lambda u,i:slot(bags,u,i),UnitExtendedInventorySize=lambda u:len(bags[u]),
            UnitItemInEquipmentSlot=lambda u,i:slot(gear,u,i),ConvertLoadoutSlot=lambda i:i,
            ModuloInteger=lambda a,b:a%b,LoadInteger=lambda t,a,b:t.get((a,b),0),
            ForsakenGearTypes={(4,'f025'):'I0A7'},ItemStackGatherItem=None,ItemStackGatherOwner=0,
            Gear_IsPlayerHero=lambda u:u=='hero',BACKPACK_PAGES=7,BACKPACK_SLOTS=6,
            BackpackHolder={i:'page'+str(i) for i in range(8)},
            Gear_WornOfType=lambda u,r:next((i for i in units['page0']+units['page1'] if i['raw']==r),None))
        env=execute(source,list(functions(source)),env)
        return env,units,bags,gear

    def test_pickups_consolidate_two_two_one_across_last_native_bag_slot(self):
        e,u,b,g=self.inventory();existing=item(charges=2);b['hero']=[None]*29+[existing]
        for amount in [2,1]:
            picked=item(charges=amount);e['ItemStack_MergeUnit']('hero',picked)
            self.assertEqual(picked['raw'],0)
        self.assertEqual(existing['charges'],5)
        self.assertIs(e['Carry_Find']('hero','I074'),existing)

    def test_classic_last_backpack_page_is_searched_and_stacked(self):
        e,u,b,g=self.inventory(classic=True);existing=item(charges=2);u['page6']=[None]*5+[existing]
        e['ItemStack_MergeUnit']('hero',item(charges=3))
        self.assertEqual(existing['charges'],5)
        self.assertIs(e['Carry_Find']('hero','I074'),existing)

    def test_gather_consolidates_existing_split_stacks_without_changing_total(self):
        e,u,b,g=self.inventory();b['hero']=[item(charges=2),item(charges=2),item()]
        e['ItemStack_ConsolidateUnit']('hero')
        live=[i for i in b['hero'] if i['raw']]
        self.assertEqual(len(live),1);self.assertEqual(live[0]['charges'],5)
        b['hero']=[item(charges=80),item(charges=80)]
        e['ItemStack_ConsolidateUnit']('hero')
        self.assertEqual(sorted(i['charges'] for i in b['hero'] if i['raw']),[61,99])

    def test_stack_overflow_and_ownership_preserve_items_and_binding(self):
        e,u,b,g=self.inventory();target=item(charges=98);picked=item(charges=4,bound=1)
        e['ItemStack_MergePair'](picked,target,1)
        self.assertEqual((target['charges'],target['bound'],picked['charges']),(99,1,3))
        foreign=item(charges=2,bound=2)
        e['ItemStack_MergePair'](foreign,item(),1)
        self.assertEqual((foreign['charges'],foreign['raw']),(2,'I074'))
        e['ItemStack_MergePair'](picked,item(raw='I075'),1)
        self.assertEqual(picked['charges'],3)

    def test_gather_merges_house_ground_stacks_without_taking_foreign_items(self):
        e,u,b,g=self.inventory();ground=[item(),item(),item(bound=2)]
        e['GetEnumItem']=lambda:e['enum']
        e['IsItemVisible']=lambda i:True;e['IsItemOwned']=lambda i:False
        def enum(area,condition,callback):
            for target in list(ground):e['enum']=target;callback()
        e['EnumItemsInRect']=enum
        picked=item();e['ItemStack_MergeGround'](picked,'house',1)
        self.assertEqual(picked['raw'],0)
        self.assertEqual(sum(i['charges'] for i in ground if i['raw'] and not i['bound']),3)
        self.assertEqual(len([i for i in ground if i['raw'] and not i['bound']]),1)
        self.assertEqual(ground[2]['charges'],1)
        self.assertIsNone(e['ItemStackGatherItem'])

    def test_medicine_counts_only_worn_equipment_and_resolves_native_alias(self):
        e,u,b,g=self.inventory();medicine=item(raw='f025');b['hero']=[medicine]
        self.assertTrue(e['Carry_Has']('hero','I0A7'))
        self.assertFalse(e['Carry_Worn']('hero','I0A7'))
        g['hero']=[medicine]
        self.assertTrue(e['Carry_Worn']('hero','I0A7'))
        g['hero']=[]
        self.assertFalse(e['Carry_Worn']('hero','I0A7'))

    def test_complete_travel_pages_are_ordered_and_independent_for_players(self):
        source=(HERE/'TravelPages.j').read_text();dialogs=defaultdict(list);serial=[0];event={};moved=[]
        def add(dialog,text,hotkey):
            serial[0]+=1;button=serial[0];dialogs[dialog].append((button,text));return button
        env=dict(TravelDialog={0:'p0',1:'p1'},TravelChoice=defaultdict(lambda:None),
            TravelPage=defaultdict(int),TravelVisible=defaultdict(bool),
            TravelOrder=dict(enumerate([1,2,3,5,12,6,4,8,7,10,9,11,13],1)),
            udg_TravelCount=13,udg_WarpUnlocked=defaultdict(lambda:True),
            udg_TravelName=dict(enumerate(['Kalm','Guardia','Barrens','Farm','Northern','Central','Naga','Loth','Icy','Dark Dragon','Elysium','Shipyard','Arena'],1)),
            udg_TravelHotkey=defaultdict(int),GetPlayerId=lambda p:p,I2S=str,IMaxBJ=max,
            DialogClear=lambda d:dialogs[d].clear(),DialogSetMessage=lambda *a:None,
            DialogAddButton=add,DialogDisplay=lambda *a:None,
            GetClickedButton=lambda:event['button'],GetTriggerPlayer=lambda:event['player'],
            Player_GetHero=lambda p:('hero',p),GetLocalPlayer=lambda:0,
            udg_TravelX={i:i*10 for i in range(1,14)},udg_TravelY={i:i*20 for i in range(1,14)},
            udg_WarpEnterTrigger='warp',udg_InCinematicMode=False,
            DisableTrigger=lambda t:None,EnableTrigger=lambda t:None,TriggerSleepAction=lambda t:None,
            SetUnitX=lambda u,x:moved.append((u,x)),SetUnitY=lambda *a:None,
            PanCameraToTimed=lambda *a:None)
        e=execute(source,['Travel_Hide','Travel_Show','Trig_Travel_Dialog_Click_Actions'],env)
        e['Travel_Show'](0,0)
        self.assertEqual([t for _,t in dialogs['p0']],['Kalm','Guardia','Barrens','Northern','Shipyard','Central','Farm','Loth','Naga','Dark Dragon','Next page','Cancel'])
        first=list(dialogs['p0']);e['Travel_Show'](1,1)
        self.assertEqual([t for _,t in dialogs['p1']],['Icy','Elysium','Arena','Previous page','Cancel'])
        self.assertEqual(dialogs['p0'],first)
        event.update(player=0,button=e['TravelChoice'][12]);e['Trig_Travel_Dialog_Click_Actions']()
        event.update(player=1,button=e['TravelChoice'][16+13]);e['Trig_Travel_Dialog_Click_Actions']()
        self.assertEqual(moved,[(('hero',0),120),(('hero',1),130)])
        self.assertIsNone(e['TravelChoice'][16+12])
        e['Travel_Show'](0,1)
        self.assertIsNone(e['TravelChoice'][12])

    def test_sleipnir_marker_ignores_stale_native_ability_after_unequipping(self):
        source=(HERE/'Forsaken-active-gear.j').read_text()
        gear=[None]
        env=dict(GetUnitAbilityLevel=lambda u,r:1,GetOwningPlayer=lambda u:0,
            Player_GetHero=lambda p:'hero',GetUnitTypeId=lambda u:'HERO',LoadBoolean=lambda t,a,b:a==0 and b=='A1C3',
            ForsakenElementSources={},UnitItemInSlot=lambda *a:None,
            UnitItemInEquipmentSlot=lambda u,s:gear[0] if s==0 else None,
            ConvertLoadoutSlot=lambda s:s,GetItemTypeId=lambda i:'f056' if i else 0,
            GetItemEquipmentType=lambda i:0,EQUIPMENT_TYPE_NONE=0,
            BlzGetItemAbilityByIndex=lambda i,n:'A1C3' if i and n==0 else None,
            BlzGetAbilityId=lambda a:a)
        e=execute(source,['Forsaken_ActiveGear','Forsaken_ActiveAbilityLevel','Forsaken_ElementAbilityLevel'],env)
        self.assertEqual(e['Forsaken_ElementAbilityLevel']('hero','A1C3'),0)
        gear[0]='Sleipnir'
        self.assertEqual(e['Forsaken_ElementAbilityLevel']('hero','A1C3'),1)
        gear[0]=None
        self.assertEqual(e['Forsaken_ElementAbilityLevel']('hero','A1C3'),0)

    def test_medicine_refill_starts_and_stops_with_equipment(self):
        e,u,b,g=self.inventory();drinks=[]
        e.update(GetEnumPlayer=lambda:0,Player_GetHero=lambda p:'hero',
            GetConvertedPlayerId=lambda p:p+1,udg_SpiritOfGaya={1:'gaya'},
            TimerGetRemaining=lambda t:0.,udg_SpellCooldownTimer={1:'timer'},
            UnitAddItemByIdSwapped=lambda *a:drinks.append(a),udg_TempBoolean=False)
        source=(ROOT/'src/triggers/05 Items crafting and shops/HeroMedicine.j').read_text()
        e=execute(source,['Trig_HeroMedicine_Refill_Cond_HasMedicine','Trig_HeroMedicine_Refill_Cond_CooldownReady','Trig_HeroMedicine_Refill_GiveDrinkToPlayer'],e)
        medicine=item(raw='f025');b['hero']=[medicine]
        e['Trig_HeroMedicine_Refill_GiveDrinkToPlayer']();self.assertEqual(drinks,[])
        g['hero']=[medicine]
        e['Trig_HeroMedicine_Refill_GiveDrinkToPlayer']();self.assertEqual(len(drinks),1)
        g['hero']=[]
        e['Trig_HeroMedicine_Refill_GiveDrinkToPlayer']();self.assertEqual(len(drinks),1)

    def test_eidolon_turn_in_is_proximity_return_and_maintenance_is_idempotent(self):
        for relative in ['06 Quests and story/Quest_EidolonChallenge.j','08 World and travel/Travel.j',
                         '08 World and travel/Warp.j','05 Items crafting and shops/Item_Stack.j',
                         '04 Combat and abilities/Gaya_Inventory.j','05 Items crafting and shops/HeroMedicine.j']:
            source=(ROOT/'src/triggers'/relative).read_text()
            self.assertEqual(refresh(source),source,relative)
        source=(ROOT/'src/triggers/06 Quests and story/Quest_EidolonChallenge.j').read_text()
        self.assertIn('call Quest_Return(q,gg_unit_Ocb2_0147,"")',source)

if __name__=='__main__':unittest.main()

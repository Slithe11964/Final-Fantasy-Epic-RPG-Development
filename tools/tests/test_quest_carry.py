"""Gate checks and consumption use the same all-slot, owner-scoped lookup."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from quest_carry import HELPER,refresh
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class QuestCarryTests(unittest.TestCase):
    def test_vial_is_consumed_from_all_inventories_before_next_fill(self):
        source=refresh(next((ROOT/'src/triggers').rglob('FillVial.j')).read_text())
        self.assertEqual(refresh(source),source)
        for fountain,filled in [('nfnp','bzbf'),('ndfl','I0JL'),('nbfl','I0JM')]:
            for carrier in ['hero0','gaya0']:
                for slot in [0,5,6,35,44]:
                    base,items,state,removed=self.runtime();created=[];empty={'raw':'bzbe'}
                    items[carrier]=[None]*45;items[carrier][slot]=empty
                    items['hero1']=[{'raw':'bzbe'}]
                    env=mocks(source);env.update(base)
                    env.update(udg_QuestItem={},udg_TempPoint=None,
                        GetSpellTargetUnit=lambda:fountain,GetUnitTypeId=lambda u:u,
                        GetUnitName=lambda u:'Fountain',GetUnitLoc=lambda u:'point',
                        Force_OfPlayer=lambda p:'force',
                        CreateItemLoc=lambda raw,point:created.append({'raw':raw}),
                        GetLastCreatedItem=lambda:created[-1],UnitAddItemSwapped=lambda *a:None)
                    names=[n for n in functions(source) if n.startswith('Trig_FillVial_')]
                    e=execute(source,names,env);e['Trig_FillVial_Cast_Actions']()
                    self.assertEqual(created,[{'raw':filled}]);self.assertEqual(removed,[empty])
                    e['Trig_FillVial_Cast_Actions']();self.assertEqual(len(created),1)
                    self.assertIsNotNone(items['hero1'][0])

    def test_excalipoor_object_is_quest_cargo_and_other_weapons_are_unchanged(self):
        from quest_carry import objects
        from objdata import read_objects,write_objects
        from priest_master import fields
        table={'version':3,'original':[],'custom':[{'base':'afac','id':raw,'sets':[{'flag':0,'mods':[
            dict(field='iabi',type=3,level=None,data=None,value='A0EC',end=0),
            dict(field='ilev',type=0,level=None,data=None,value=8,end=0)]}]} for raw in ['I0A3','Ixxx']]}
        data=write_objects(table,3,'w3t');updated=objects(data)
        self.assertEqual(objects(updated),updated)
        actual=read_objects(updated,'w3t');f=fields(actual['custom'][0])
        self.assertEqual(f['icla',None],'Campaign');self.assertEqual(f['iequ',None],'')
        self.assertEqual(f['ilev',None],0);self.assertEqual(f['iabi',None],'A0EC')
        self.assertEqual(actual['custom'][1],table['custom'][1])
    def runtime(self):
        holy=refresh(next((ROOT/'src/triggers').rglob('HolyAnkh.j')).read_text())
        gate=refresh(next((ROOT/'src/triggers').rglob('Gate.j')).read_text())
        source=HELPER+'\n'+holy+'\n'+gate
        items={};state={'enter':'hero0'};removed=[];owners={'hero0':0,'gaya0':0,'summon0':0,'hero1':1,'gaya1':1}
        def find(holder,raw):return next((i for i in items.get(holder,[]) if i and i['raw']==raw),None)
        def remove(item):
            self.assertIsNotNone(item);removed.append(item)
            for inventory in items.values():
                for n,held in enumerate(inventory):
                    if held is item:inventory[n]=None
        env=mocks(source);env.update(Carry_Find=find,GetOwningPlayer=lambda u:owners[u],GetPlayerId=lambda p:p,
            Player_GetHero=lambda p:'hero'+str(p),udg_SpiritOfGaya={1:'gaya0',2:'gaya1'},
            GetTriggerUnit=lambda:state['enter'],GetUnitTypeId=lambda u:'H01D' if u.startswith('gaya') else 'H000',
            IsPlayerInForce=lambda p,f:p in f,udg_PlayingPlayers={0,1},RemoveItem=remove,
            udg_RingHintsReady=False,udg_HolyAnkhUsed=False,udg_MainQuest={18:'quest'},udg_HashmalumEncountered=False,
            udg_PlayerName={1:'one',2:'two'},GetConvertedPlayerId=lambda p:p+1,
            GetRectCenter=lambda r:r,gg_rct_472='destination',gg_unit_n0AP_0240='waygate',udg_InCinematicMode=False,
            GetPlayersAll=lambda:'players',udg_ShadowForcedSpawn=0,gg_dest_LTg2_0021='gate',bj_GATEOPERATION_OPEN=1,
            IsQuestDiscovered=lambda q:False,UNIT_TYPE_HERO=1,IsUnitType=lambda *a:True,
            gg_rct_494=494,gg_rct_495=495,gg_rct_666=666,gg_rct_667=667,gg_rct_668=668,
            IsQuestCompleted=lambda q:False)
        names=['Carry_QuestItem']+[n for n in functions(holy) if n.startswith('Trig_HolyAnkh_')]+[n for n in functions(gate) if n.startswith('Trig_Gate_WinterKey_')]
        return execute(source,names,env),items,state,removed

    def test_both_items_in_every_hero_gaya_slot_are_found_and_consumed_once(self):
        for raw,condition,action in [('I0BZ','Trig_HolyAnkh_Waygate_Conditions','Trig_HolyAnkh_Waygate_Actions'),('I0IM','Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey','Trig_Gate_WinterKey_Unlock_Actions')]:
            for carrier in ['hero0','gaya0']:
                for slot in range(45):
                    e,items,state,removed=self.runtime();key={'raw':raw};items[carrier]=[None]*45;items[carrier][slot]=key
                    self.assertTrue(e[condition](),(raw,carrier,slot));e[action]()
                    self.assertEqual(removed,[key]);self.assertIsNone(e['Carry_QuestItem']('hero0',raw))

    def test_gaya_can_approach_with_the_item_in_hero_backpack(self):
        e,items,s,removed=self.runtime();s['enter']='gaya0';key={'raw':'I0IM'};items['hero0']=[None]*29+[key]
        self.assertTrue(e['Trig_Gate_WinterKey_Unlock_Conditions']())
        e['Trig_Gate_WinterKey_Unlock_Actions']();self.assertEqual(removed,[key])

    def test_other_players_and_unrelated_summons_cannot_supply_a_key(self):
        e,items,s,removed=self.runtime();items['hero1']=[{'raw':'I0BZ'},{'raw':'I0IM'}]
        self.assertFalse(e['Trig_HolyAnkh_Waygate_Conditions']());self.assertFalse(e['Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey']())
        items['hero0']=items['hero1'];s['enter']='summon0'
        self.assertFalse(e['Trig_HolyAnkh_Waygate_Conditions']());self.assertFalse(e['Trig_Gate_WinterKey_Unlock_Cond_HasWinterKey']())
        self.assertFalse(removed)

    def test_first_matching_copy_only_is_removed(self):
        e,items,s,removed=self.runtime();a={'raw':'I0BZ'};b={'raw':'I0BZ'};items['hero0']=[a,b]
        e['Trig_HolyAnkh_Waygate_Actions']();self.assertIs(removed[0],a);self.assertIs(e['Carry_QuestItem']('hero0','I0BZ'),b)

    def test_both_source_profiles_are_idempotent_and_old_consumption_is_replaced(self):
        for name in ['HolyAnkh','Gate','Item_Stack']:
            source=next((ROOT/'src/triggers').rglob(name+'.j')).read_text()
            for native in [False,True]:
                adapted=source.replace('Gear_HasCarried','UnitHasItemOfTypeBJ').replace('Gear_Carried','GetItemOfTypeFromUnitBJ') if native else source
                updated=refresh(adapted);self.assertEqual(refresh(updated),updated)
                if name!='Item_Stack':self.assertIn('TItemStack',updated.splitlines()[0])

if __name__=='__main__':unittest.main()

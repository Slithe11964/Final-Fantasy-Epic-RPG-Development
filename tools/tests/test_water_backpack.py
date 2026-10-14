"""Water proxy casts stay active and attribute backpack casts to the real hero."""
import unittest
from pathlib import Path
from unittest.mock import patch
import test_quest_lifecycle as harness

SOURCE=Path(__file__).resolve().parents[2]/'src/triggers/04 Combat and abilities/Spell_Water.j'

class WaterBackpackTests(unittest.TestCase):
    def run_cast(self,from_page,targeted,ability):
        hero={'owner':0,'hero':True};page={'owner':0,'hero':False}
        caster=page if from_page else hero
        proxy={'owner':0,'visible':True};last=[proxy];data={};orders=[];costs=[]
        def ability_add(raw,u):
            self.assertIs(u,proxy)
            last[0]={'unrelated creation':True}
        def order(u,name,target):
            self.assertIs(u,proxy)
            self.assertTrue(u['visible'])
            self.assertEqual(u['alpha'],0)
            orders.append((name,target));return True
        def mana(raw,level):
            costs.append((raw,level));return 400
        env=dict(GetTriggerUnit=lambda:caster,GetOwningPlayer=lambda u:u['owner'],GetPlayerId=lambda p:p,
            Player=lambda p:p,Player_GetHero=lambda p:hero,Backpack_PageOf=lambda p,u:2 if u is page else -1,
            GetUnitLoc=lambda u:(40.,100.),GetSpellTargetUnit=lambda:hero if targeted else None,
            GetSpellTargetLoc=lambda:(80.,120.),CreateNUnitsAtLocFacingLocBJ=lambda *a:None,
            GetLastCreatedUnit=lambda:last[0],RemoveLocation=lambda *a:None,
            SetUnitFacingToFaceLocTimed=lambda *a:None,GetHandleIdBJ=lambda u:21,
            SaveUnitHandleBJ=lambda value,key,handle,table:table.__setitem__(key,value),
            SaveRealBJ=lambda value,key,handle,table:table.__setitem__(key,value),
            SaveIntegerBJ=lambda value,key,handle,table:table.__setitem__(key,value),
            WaterOrders=[0]*8,udg_ProxyDamageHash=data,GetSpellAbilityId=lambda:ability,Abil_GetLevel=lambda u,a:1,
            BlzGetAbilityManaCost=mana,UNIT_TYPE_HERO=1,IsUnitType=lambda u,t:u['hero'],
            bj_HEROSTAT_INT=1,GetHeroStatBJ=lambda stat,u,b:75 if u is hero else 0,
            Prof_RodPower=lambda u:1.5 if u is hero else 1.,I2R=float,
            SetUnitVertexColor=lambda u,r,g,b,a:u.__setitem__('alpha',a),
            UnitApplyTimedLifeBJ=lambda *a:None,UnitAddAbilityBJ=ability_add,IssuePointOrderLocBJ=order)
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(SOURCE.read_text(),['Trig_Spell_Water_IsPointCast','Trig_Spell_Water_Actions'],env)
        e['Trig_Spell_Water_Actions']()
        self.assertEqual(len(orders),1)
        self.assertEqual(orders[0][0],'carrionswarm')
        self.assertIs(data[0],hero)
        self.assertEqual(data[1],3675.)
        self.assertEqual(data[2],3)
        self.assertEqual(costs,[(ability,1)])

    def test_wateraga_and_book_cast_from_hero_and_page_with_point_or_unit_target(self):
        for ability in ('A0Q2','A08X'):
            for page in (False,True):
                for target in (False,True):
                    with self.subTest(ability=ability,page=page,target=target):
                        self.run_cast(page,target,ability)

    def test_diagnostic_requires_proxy_effect_not_channel(self):
        for event in (1,2):
            saved=[]
            env=dict(GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,
                GetSpellAbilityId=lambda:'A0PZ',GetTriggerEventId=lambda:event,
                EVENT_PLAYER_UNIT_SPELL_CHANNEL=1,EVENT_PLAYER_UNIT_SPELL_EFFECT=2,
                Trig_Spell_Water_IsWaterSpell=lambda:False,WaterProxyEffects=[0]*8,
                WaterCheckData={},GetTriggerUnit=lambda:42,GetHandleId=lambda u:u,
                LoadInteger=lambda *a:2,SaveBoolean=lambda *a:saved.append(a))
            with patch.object(harness,'SELECTED',[]):
                e=harness.load_engine(SOURCE.read_text(),['Water_Observe'],env)
            e['Water_Observe']()
            self.assertEqual(len(saved),1 if event==2 else 0)

if __name__=='__main__':unittest.main()

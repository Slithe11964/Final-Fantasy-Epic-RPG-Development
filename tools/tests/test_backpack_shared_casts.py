"""Both cooldown pools span all carriers and reserve at the first spell effect."""
from pathlib import Path
import unittest
from unittest.mock import patch
import test_quest_lifecycle as harness

ROOT=Path(__file__).resolve().parents[2]

class SharedCastTests(unittest.TestCase):
    def setUp(self):
        hero={'owner':0};page={'owner':0};self.hero=hero;self.page=page
        consumables={'AIh1','A164'};magic={'A0Q2','A08X','A0FW'}
        self.timers={};self.orders=[];self.cost_reads=[]
        def create():
            timer=len(self.timers)+1;self.timers[timer]=0.;return timer
        food=create()
        env=dict(I2S=str,R2I=int,Gear_IsGearAbility=lambda a:a in magic|consumables,
            Item_Cooldown_IsConsumable=lambda a:a in consumables,Gear_IsItemAbility=lambda a:a in magic|consumables,
            BackpackGearCooldown={0:None},udg_SpellCooldownTimer={1:food},CreateTimer=create,
            TimerGetRemaining=lambda t:self.timers[t],TimerStart=lambda t,d,r,c:self.timers.__setitem__(t,d),
            GetOwningPlayer=lambda u:u['owner'],GetPlayerId=lambda p:p,Player=lambda p:p,
            Player_GetHero=lambda p:hero,Backpack_PageOf=lambda p,u:2 if u is page else -1,
            PauseUnit=lambda *a:None,IssueImmediateOrder=lambda u,o:self.orders.append((u,o)),
            DisplayTimedTextToPlayer=lambda *a:None,GetTriggerUnit=lambda:page,GetSpellAbilityId=lambda:'A0Q2',
            BackpackSettleMana={0:False},Backpack_QueueWork=lambda p:None,
            BackpackCdAbility={0:0},BackpackCdCaster={0:None},
            udg_AbilityLevelIndex=1,GetUnitAbilityLevel=lambda u,a:1,BlzGetUnitAbilityCooldownRemaining=lambda u,a:0.,Abil_GetLevel=lambda u,a:1,
            BlzGetAbilityCooldown=lambda a,l:self.cost_reads.append((a,l)) or 20.)
        source=(ROOT/'src/triggers/05 Items crafting and shops/Backpack.j').read_text()
        names=['Backpack_PoolOf','Backpack_PoolTimer','Backpack_PoolLeft','Backpack_StartPool',
               'Backpack_CooldownAfterCast','Backpack_RefusePool','Backpack_OnItemCast']
        with patch.object(harness,'SELECTED',[]):self.e=harness.load_engine(source,names,env)

    def test_magic_and_food_pools_are_distinct_and_do_not_shorten(self):
        e=self.e
        for a in ('A0Q2','A08X','A0FW'):self.assertEqual(e['Backpack_PoolOf'](a),1)
        for a in ('AIh1','A164'):self.assertEqual(e['Backpack_PoolOf'](a),2)
        self.assertEqual(e['Backpack_PoolOf']('A00G'),0)
        e['Backpack_StartPool'](0,1,20.);e['Backpack_StartPool'](0,1,10.)
        self.assertEqual(e['Backpack_PoolLeft'](0,1),20.)
        self.assertEqual(e['Backpack_PoolLeft'](0,2),0.)

    def test_last_consumed_charge_uses_the_client_first_level_index(self):
        e=self.e;e['GetUnitAbilityLevel']=lambda u,a:0
        for level_index in (0,1):
            e['udg_AbilityLevelIndex']=level_index
            e['Backpack_CooldownAfterCast'](self.hero,'AIh1')
            self.assertEqual(self.cost_reads[-1],('AIh1',level_index))

    def test_effect_reserves_pool_before_deferred_work_and_refuses_other_carriers(self):
        e=self.e;e['Backpack_OnItemCast']()
        self.assertEqual(self.cost_reads,[('A0Q2',1)])
        self.assertEqual(e['Backpack_PoolLeft'](0,1),20.)
        self.assertTrue(e['Backpack_RefusePool'](self.hero,1))
        self.assertTrue(e['Backpack_RefusePool'](self.page,1))
        self.assertFalse(e['Backpack_RefusePool'](self.hero,2))
        self.assertEqual(len(self.orders),2)

if __name__=='__main__':unittest.main()

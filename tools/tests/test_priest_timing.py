"""Shield contributions expire independently, including partially consumed chunks."""
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from priest_followup import refresh
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class PriestTimingTests(unittest.TestCase):
    def runtime(self):
        source=refresh(next((ROOT/'src/triggers').rglob('Talents.j')).read_text())
        store={};queue={};clock=[0.];serial=[100];expired=[None];dead=set();destroyed=[]
        def create():serial[0]+=1;return serial[0]
        def flush(h,key):
            for pair in list(store):
                if pair[0]==key:del store[pair]
        env=mocks(source);env.update(TalentShieldState='shields',GetHandleId=lambda x:x,
            LoadReal=lambda h,p,c:store.get((p,c),0.),SaveReal=lambda h,p,c,v:store.__setitem__((p,c),v),
            LoadTimerHandle=lambda h,p,c:store.get((p,c)),SaveTimerHandle=lambda h,p,c,v:store.__setitem__((p,c),v),
            LoadUnitHandle=lambda h,p,c:store.get((p,c)),SaveUnitHandle=lambda h,p,c,v:store.__setitem__((p,c),v),
            FlushChildHashtable=flush,CreateTimer=create,TimerStart=lambda t,d,r,f:queue.__setitem__(t,(clock[0]+d,f)),
            DestroyTimer=lambda t:(destroyed.append(t),queue.pop(t,None)),PauseTimer=lambda t:None,
            GetExpiredTimer=lambda:expired[0],GetWidgetLife=lambda u:0. if u in dead else 100.,
            RMaxBJ=max,RMinBJ=min,Talent_ShieldDisplayUpdate=lambda u:None,GetTriggerUnit=lambda:'target')
        names=['Talent_ShieldRemove','Talent_ShieldExpire','Talent_AddShield','Talent_AbsorbShield','Talent_ShieldDeath','Talent_ShieldAmount']
        e=execute(source,names,env)
        def advance(t):
            while queue and min(v[0] for v in queue.values())<=t:
                pending=min(queue,key=lambda k:queue[k][0]);when,callback=queue.pop(pending)
                clock[0]=when;expired[0]=pending;callback()
            clock[0]=t
        return e,advance,queue,store,destroyed,dead

    def test_new_heals_do_not_refresh_old_shields(self):
        e,advance,queue,store,_,_=self.runtime()
        e['Talent_AddShield']('target',100.);advance(10.)
        e['Talent_AddShield']('target',200.);advance(29.99)
        self.assertEqual(e['Talent_ShieldAmount']('target'),300.)
        advance(30.);self.assertEqual(e['Talent_ShieldAmount']('target'),200.)
        advance(40.);self.assertEqual(e['Talent_ShieldAmount']('target'),0.)
        self.assertFalse(queue);self.assertFalse(store)

    def test_damage_consumes_oldest_and_expiry_removes_only_its_remainder(self):
        e,advance,queue,store,_,_=self.runtime()
        e['Talent_AddShield']('target',100.);advance(10.);e['Talent_AddShield']('target',200.)
        self.assertEqual(e['Talent_AbsorbShield']('target',60.),0.)
        advance(30.);self.assertEqual(e['Talent_ShieldAmount']('target'),200.)
        self.assertEqual(e['Talent_AbsorbShield']('target',250.),50.)
        self.assertFalse(queue);self.assertFalse(store)
        advance(45.);self.assertEqual(e['Talent_ShieldAmount']('target'),0.)

    def test_absorption_spans_chunks_without_expiring_newer_amount(self):
        e,advance,_,_,_,_=self.runtime()
        e['Talent_AddShield']('target',100.);advance(10.);e['Talent_AddShield']('target',200.)
        self.assertEqual(e['Talent_AbsorbShield']('target',150.),0.)
        advance(30.);self.assertEqual(e['Talent_ShieldAmount']('target'),150.)
        advance(40.);self.assertEqual(e['Talent_ShieldAmount']('target'),0.)

    def test_targets_are_independent_and_death_cleans_every_timer(self):
        e,advance,queue,store,destroyed,dead=self.runtime()
        for _ in range(4):e['Talent_AddShield']('target',50.)
        e['Talent_AddShield']('other',75.)
        e['Talent_ShieldDeath']();self.assertEqual(len(queue),1)
        self.assertEqual(e['Talent_ShieldAmount']('other'),75.)
        dead.add('target');e['Talent_AddShield']('target',500.);self.assertEqual(len(queue),1)
        advance(30.);self.assertFalse(store);self.assertEqual(len(destroyed),5)

    def test_rain_damage_reaches_engine_after_a_heal_leaves_a_probe_armed(self):
        from collections import defaultdict
        from unittest.mock import patch
        import test_quest_lifecycle as harness
        rain=refresh(next((ROOT/'src/triggers').rglob('Regen.j')).read_text())
        damage=next((ROOT/'src/triggers').rglob('Damage.j')).read_text()
        source=rain+'\n'+damage;group=[];hp={'ally':10000.,'enemy':10000.,'gaya':1000000.};hit={};calls=[]
        env=mocks(source);env.update(PriestRainCaster=defaultdict(lambda:None,{0:'priest'}),PriestRainCount=1,
            PriestRainLeft=defaultdict(float,{0:15.}),PriestRainNext=defaultdict(float,{0:.1}),
            PriestRainDamageNext=defaultdict(float,{0:1.}),PriestRainHealing={6:400.},PriestRainPeriod={6:.1},
            PriestRainRadius={6:900.},PriestRainEnemies={0:group},PriestRainTimer='rain',
            GetWidgetLife=lambda u:hp.get(u,10000.),GetUnitCurrentOrder=lambda u:1,OrderId=lambda s:1,
            GetUnitAbilityLevel=lambda u,a:6 if a=='A0OM' else 0,GetUnitTypeId=lambda u:'H005',
            Talent_Active=lambda *a:True,Talent_PriestChoice=lambda *a:False,GetOwningPlayer=lambda u:0,
            Forsaken_ElementAbilityLevel=lambda *a:0,
            GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GroupEnumUnitsInRange=lambda g,*a:g.extend(['ally','gaya','enemy']),
            FirstOfGroup=lambda g:g[0] if g else None,GroupRemoveUnit=lambda g,u:g.remove(u),
            BlzIsUnitInvulnerable=lambda u:u=='gaya',IsUnitAlly=lambda u,p:u in ['ally','gaya'],IsUnitEnemy=lambda u,p:u=='enemy',IsUnitType=lambda *a:False,
            ATTACK_TYPE_NORMAL=1,ATTACK_TYPE_CHAOS=2,DAMAGE_TYPE_MAGIC=3,WEAPON_TYPE_WHOKNOWS=0,
            UNIT_TYPE_STRUCTURE=1,UNIT_TYPE_MAGIC_IMMUNE=2,GetEventDamageSource=lambda:'priest',
            GetTriggerUnit=lambda:hit['target'],GetEventDamage=lambda:hit['amount'],
            BlzSetEventDamage=lambda n:hit.update(final=n),Talent_CleansingProtected=lambda u:False,
            udg_DmgArmorProbe=False,udg_DmgFlagUnavoidable=0,udg_DmgFlagNoCrit=1.,
            Trig_Damage_Engine_PostDamageEffects=lambda:None)
        expression=harness.expression
        with patch.object(harness,'expression',lambda text:expression(text).replace('//','/')):
            e=execute(source,['Priest_RainTick','Trig_Damage_Engine_Actions'],env)
        def calculate(n,c,u,*flags):
            if u=='gaya':raise ZeroDivisionError('invulnerable healing armor probe returns zero')
            if flags[6]:
                hp[u]+=n;e['udg_DmgArmorProbe']=True # failed native armor-probe callback
                return 0.
            self.assertFalse(e['udg_DmgFlagManaDamage']);return n
        def native(c,u,n,*flags):
            calls.append(flags);hit.update(target=u,amount=n,final=n)
            e['Trig_Damage_Engine_Actions']();hp[u]-=hit['final']
        e['Trig_Damage_Engine_CalcDamage']=calculate;e['UnitDamageTarget']=native
        for _ in range(9):e['Priest_RainTick']()
        self.assertEqual(hp,{'ally':10000.,'enemy':10000.,'gaya':1000000.})
        e['Priest_RainTick']()
        self.assertEqual(hp,{'ally':12000.,'enemy':8000.,'gaya':1000000.})
        self.assertEqual(calls[0][:4],(True,False,1,3))
        self.assertFalse(e['udg_DmgArmorProbe'])

    def test_transform_is_idempotent_in_both_affected_modules(self):
        for name in ['Talents','Regen']:
            s=next((ROOT/'src/triggers').rglob(name+'.j')).read_text()
            self.assertEqual(refresh(refresh(s)),refresh(s))

if __name__=='__main__':unittest.main()

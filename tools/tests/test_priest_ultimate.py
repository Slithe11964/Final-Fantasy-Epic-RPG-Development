"""Execute rank-99 shields, expiry and actual damage interception."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1])]
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions
from priest_ultimate import refresh
from speedrun_inventory import refresh as filter_refresh
ROOT=Path(__file__).resolve().parents[2]


class PriestUltimateTests(unittest.TestCase):
    def runtime(self):
        source=(ROOT/'experiments/Forsaken/PriestUltimate.j').read_text().split('// FUNCTIONS\n')[1]
        memo={};timers=[];destroyed=[];buffs=set();world={'job':12,'choice':1,'living':True,'order':1,'x':0.,'ally':True}
        def flush(h,p):
            for key in list(memo):
                if key[0]==p:del memo[key]
        env=mocks(source);env.update(TalentShieldState='shield',GetHandleId=lambda x:x,
            LoadReal=lambda h,p,c:memo.get((p,c),0.),SaveReal=lambda h,p,c,v:memo.__setitem__((p,c),v),
            LoadTimerHandle=lambda h,p,c:memo.get((p,c)),SaveTimerHandle=lambda h,p,c,v:memo.__setitem__((p,c),v),
            LoadUnitHandle=lambda h,p,c:memo.get((p,c)),SaveUnitHandle=lambda h,p,c,v:memo.__setitem__((p,c),v),
            FlushChildHashtable=flush,CreateTimer=lambda:'expiry',TimerStart=lambda *a:timers.append(a),
            DestroyTimer=destroyed.append,GetExpiredTimer=lambda:'expiry',PauseTimer=lambda t:None,
            GetTriggerUnit=lambda:'target',GetWidgetLife=lambda u:100. if world['living'] else 0.,
            Job_GetIndex=lambda u:world['job'],Talent_Has=lambda u,r,c:c==world['choice'],
            GetUnitAbilityLevel=lambda u,a:int(a in buffs),RMinBJ=min,
            TalentRainCaster=defaultdict(lambda:None,{0:'priest'}),TalentRainRadius={0:900.},
            GetUnitCurrentOrder=lambda u:world['order'],OrderId=lambda s:1,IsUnitAlly=lambda *a:world['ally'],
            IsUnitType=lambda *a:False,UNIT_TYPE_STRUCTURE=1,GetOwningPlayer=lambda u:0,
            GetUnitX=lambda u:world['x'] if u=='target' else 0.,GetUnitY=lambda u:0.)
        e=execute(source,list(functions(source)),env)
        return e,memo,timers,destroyed,buffs,world

    def test_shields_add_absorb_exactly_refresh_30_seconds_and_expire(self):
        e,memo,timers,destroyed,_,_=self.runtime()
        e['Talent_AddShield']('target',300.);e['Talent_AddShield']('target',200.)
        self.assertEqual(memo['target',0],500.);self.assertEqual([t[1] for t in timers],[30.,30.])
        self.assertEqual(e['Talent_AbsorbShield']('target',200.),0.)
        self.assertEqual(e['Talent_AbsorbShield']('target',400.),100.)
        e['Talent_AddShield']('target',50.);e['Talent_ShieldExpire']()
        self.assertEqual(e['Talent_AbsorbShield']('target',90.),90.)
        self.assertEqual(destroyed,['expiry']);self.assertEqual(memo,{})

    def test_dead_targets_do_not_get_shields_and_death_clears_old_shield(self):
        e,memo,timers,destroyed,_,world=self.runtime()
        e['Talent_AddShield']('target',50.);e['Talent_ShieldDeath']();self.assertFalse(memo)
        world['living']=False;e['Talent_AddShield']('target',500.);self.assertFalse(memo)
        self.assertEqual(len(timers),1)

    def test_rejuvenation_is_exactly_50_percent_and_other_jobs_get_no_holy_bolts(self):
        e,_,_,_,buffs,world=self.runtime();world['choice']=3
        buffs.add('A13R');self.assertEqual(e['Talent_HolyBolts']('priest'),.5)
        buffs.add('B07D');self.assertEqual(e['Talent_HolyBolts']('priest'),2.)
        world['job']=11;self.assertEqual(e['Talent_HolyBolts']('priest'),0.)
        world['job']=12;world['choice']=1;self.assertEqual(e['Talent_HolyBolts']('priest'),0.)

    def test_blessed_rain_ends_with_channel_or_leaving_radius_and_is_allies_only(self):
        e,_,_,_,_,world=self.runtime();world['choice']=2
        self.assertTrue(e['Talent_BlessedRain']('target'))
        for field,value in [('x',901.),('order',2),('living',False),('ally',False),('job',11),('choice',1)]:
            before=world[field];world[field]=value;self.assertFalse(e['Talent_BlessedRain']('target'),field);world[field]=before

    def test_overhealing_is_final_health_only_and_absorb_is_after_existing_shields(self):
        path=next((ROOT/'src/triggers').rglob('Damage.j'));s=path.read_text();f=functions(s)
        body=f['Trig_Damage_Engine_Step19_Apply'];shields=[]
        env=mocks(s)
        for name in ['Amount','Source','Target','ManaDamage','Heal','Melee','Physical','FxCode','TargetHandle','SourcePlayer','TargetPlayer','Dummy','PriestShield']:
            env['DmgCtx_'+name]=defaultdict(lambda:None)
        env.update(GetWidgetLife=lambda u:900.,GetUnitState=lambda u,k:1000. if k=='max' else 900.,UNIT_STATE_MAX_LIFE='max',UNIT_STATE_LIFE='life',
            SetUnitState=lambda *a:None,Talent_PriestChoice=lambda u,c:u=='priest',Talent_AddShield=lambda t,n:shields.append(n),
            RMaxBJ=max,Text_FloatingDamage=lambda *a:None,IsUnitInGroup=lambda *a:False,IsPlayerInForce=lambda *a:False,
            Talent_AbsorbShield=lambda t,n:max(0.,n-300.))
        e=execute(s,['Trig_Damage_Engine_Step19_Apply'],env)
        e['DmgCtx_Source'][1]='priest';e['DmgCtx_Target'][1]='target';e['DmgCtx_PriestShield'][1]='priest'
        e['DmgCtx_Heal'][1]=True;e['DmgCtx_Amount'][1]=400.;e['DmgCtx_FxCode'][1]=0;e['DmgCtx_Physical'][1]=False
        e['Trig_Damage_Engine_Step19_Apply'](1);self.assertEqual(shields,[300.])
        self.assertEqual(e['DmgCtx_Amount'][1],0.)
        e['DmgCtx_Heal'][1]=False;e['DmgCtx_Amount'][1]=500.
        e['Trig_Damage_Engine_Step19_Apply'](1);self.assertEqual(e['DmgCtx_Amount'][1],200.)
        self.assertIn('set DmgCtx_PriestShield[c]=null',f['Trig_Damage_Engine_FreeContext'])

    def test_speedrun_plan_filters_all_seven_raws_and_preserves_every_retained_field(self):
        source=filter_refresh('library Test\nglobals\nendglobals\nfunction FFP_Build takes nothing returns nothing\n    call FSC_ClearSeen(ctx)\nendfunction\nendlibrary')
        rows=['I045','I07F','I07G','I07H','I027','I07Q','I0KE','phea']
        env=mocks(source);env.update(udg_SpeedrunMode=True,FFP_Count={0:8})
        for field in ['Raw','Holder','Slot','Quantity','Bound','High','Low','Flags']:
            env['FFP_'+field]=dict(enumerate(rows if field=='Raw' else range(8)))
        e=execute(source,['FFP_FilterSpeedrun'],env);e['FFP_FilterSpeedrun'](0)
        self.assertEqual(e['FFP_Count'][0],1);self.assertEqual(e['FFP_Raw'][0],'phea')
        for field in ['Holder','Slot','Quantity','Bound','High','Low','Flags']:self.assertEqual(e['FFP_'+field][0],7)

    def test_transform_idempotent_and_shield_flags_are_per_hit(self):
        for name in ['Damage','Talents','Regen','Missile','Spell_Cure']:
            s=next((ROOT/'src/triggers').rglob(name+'.j')).read_text()
            self.assertEqual(refresh(refresh(s)),refresh(s),name)
        s=next((ROOT/'src/triggers').rglob('Damage.j')).read_text()
        self.assertIn('set PriestShieldHealSource=null',functions(s)['Trig_Damage_Engine_CalcDamage'])

    def test_food_replacing_regen_clears_shield_source_but_swiftmend_preserves_it(self):
        s=next((ROOT/'src/triggers').rglob('Regen.j')).read_text();memo={}
        env=mocks(s);env.update(PriestBuffTypes='types',PriestBuffSource='source',PriestBuffRanks='ranks',
            PriestBuffExpiry='expiry',PriestBuffUntil='until',udg_HealOverTimeHash='hot',
            GetHandleId=lambda u:u,LoadInteger=lambda h,p,c:(1 if c==16 else 'B006') if h=='types' else memo.get((h,p,c),0),
            SaveInteger=lambda h,p,c,v:memo.__setitem__((h,p,c),v),
            RemoveSavedHandle=lambda h,p,c:memo.pop((h,p,c),None),
            LoadTimerHandle=lambda *a:None,SupportBuff_Now=lambda:0.,LoadReal=lambda *a:60.)
        e=execute(s,['Priest_RecordUnit'],env)
        for raw,keeps in [('A00L',True),('pReg',True),('food',False)]:
            memo['hot','target',12]='priest';e['Priest_RecordUnit']('target',raw,1)
            self.assertEqual(('hot','target',12) in memo,keeps,raw)

if __name__=='__main__':unittest.main()

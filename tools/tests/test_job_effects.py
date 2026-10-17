"""Execute job resource changes, inventory searches and rank-aware presentation."""
from collections import defaultdict
from pathlib import Path
import sys,unittest,re,copy
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions
from job_runtime import refresh
from job_objects import refresh as objects, refresh_units, MASTER_SUMMONS
from objdata import read_objects,write_objects,fields
ROOT=Path(__file__).resolve().parents[2]


def source(name):
    return next((ROOT/'src/triggers').rglob(name+'.j')).read_text()


class JobTests(unittest.TestCase):
    def test_master_templates_change_only_monster_level_and_keep_originals(self):
        def mod(field,value,kind=0):
            return dict(field=field,type=kind,level=None,data=None,value=value,end=0)
        table=dict(version=2,original=[],custom=[dict(base='ninf',id=raw,
            sets=[dict(flag=0,mods=[mod('ulev',12),mod('unam','Fixture '+raw,3),mod('uhpm',300)])])
            for raw in MASTER_SUMMONS])
        data=write_objects(table,2,'w3u');updated=refresh_units(data)
        self.assertEqual(refresh_units(updated),updated)
        result={o['id']:o for o in read_objects(updated,'w3u')['custom']}
        for original in table['custom']:
            self.assertEqual(result[original['id']],original)
            clone=result[MASTER_SUMMONS[original['id']]]
            self.assertTrue(clone['id'][0].islower());self.assertTrue(clone['base'][0].islower())
            self.assertEqual(fields(clone)['ulev'],40)
            expected=copy.deepcopy(original);expected['id']=clone['id']
            expected['sets'][0]['mods']=[m for m in expected['sets'][0]['mods'] if m['field']!='ulev']
            expected['sets'][0]['mods'].append(mod('ulev',40))
            self.assertEqual(clone,expected)

    def test_raise_dead_ward_master_fields_and_rank_aware_rage_tooltips(self):
        def ability(raw,mods):
            return dict(base='Arai',id=raw,sets=[dict(flag=0,mods=[dict(field=f,type=k,level=l,data=0,value=v,end=0)
                for f,k,l,v in mods])])
        table=dict(version=2,original=[],custom=[
            ability('A0Z2',[(f,3,rank,raw) for rank in (1,10,11)
                for f,raw in [('Rai3','u00P'),('Raiu','u00P'),('Rai4','u00R')]]),
            ability('A07V',[('Hwe1',3,10,'o00G'),('Hwe1',3,11,'o00H')]),
            ability('A070',[('aub1',3,rank,'Causes Hero to attack 240% faster and deal 10% increased damage.')
                for rank in (1,6,11)]),
            ability('A025',[('aub1',3,rank,'Causes Hero to attack 200% faster, but take 60% more damage.')
                for rank in (1,6,11)])])
        data=objects(write_objects(table,2,'w3a'));self.assertEqual(objects(data),data)
        records={o['id']:fields(o) for o in read_objects(data,'w3a')['custom']}
        for field,raw in [('Rai3','u00P'),('Raiu','u00P'),('Rai4','u00R')]:
            self.assertEqual(records['A0Z2'][field,10],raw)
            self.assertEqual(records['A0Z2'][field,11],MASTER_SUMMONS[raw])
        self.assertEqual(records['A07V']['Hwe1',10],'o00G')
        self.assertEqual(records['A07V']['Hwe1',11],'sM0A')
        for raw,speeds in [('A070',(60,85,120)),('A025',(40,65,100))]:
            for rank,speed in zip((1,6,11),speeds):
                self.assertIn('attack '+str(speed)+'% faster',records[raw]['aub1',rank])

    def test_master_rank_tables_keep_lower_rank_creatures(self):
        s=refresh(source('Spell_Tables'));self.assertEqual(refresh(s),s)
        env=mocks(s)
        e=execute(s,['Trig_Spell_Tables_Init_Actions'],env)
        e['Trig_Spell_Tables_Init_Actions']()
        for table,raw in [('AnimalCompanionUnit','n066'),('DragonSummonUnit','n07S'),
                          ('GolemUnitType','e00T'),('ShivaUnitType','e00U'),
                          ('IfritUnitType','n065'),('CyclopsUnitType','n064')]:
            self.assertEqual(e['udg_'+table][11],MASTER_SUMMONS[raw])
            self.assertNotIn(e['udg_'+table][10],MASTER_SUMMONS.values())

    def test_bahamut_creation_uses_level40_template_only_at_master_rank(self):
        class Created(Exception):pass
        for module,fn,ability,original,master in [
                ('Summon_Bahamut','Trig_Summon_Bahamut_Actions','A146','n005','sM06'),
                ('Oracle','Trig_Oracle_NeoBahamut_Actions','A147','n00G','sM07')]:
            s=refresh(source(module));self.assertEqual(refresh(s),s)
            for rank,expected in [(1,original),(5,original),(6,master)]:
                env=mocks(s);created=[]
                def create(count,raw,*args):
                    created.append(raw);raise Created()
                env.update(GetTriggerUnit=lambda:'caster',GetSpellAbilityUnit=lambda:'caster',
                    GetUnitAbilityLevel=lambda u,a:rank,GetOwningPlayer=lambda u:0,bj_UNIT_FACING=0,
                    CreateNUnitsAtLoc=create)
                e=execute(s,[fn],env)
                with self.assertRaises(Created):e[fn]()
                self.assertEqual(created,[expected])

    def test_deathbringer_cannot_execute_a_normal_level40_creature(self):
        s=source('Damage')
        line=next(l.strip().split(' //')[0] for l in s.splitlines() if "(u,'A10X')" in l and 'GetUnitLevel(t)<40' in l)
        condition=line[len('if('):-len(')then')]
        body='function CanExecute takes unit u,unit t returns boolean\n    return '+condition+'\nendfunction'
        level=[39]
        env=mocks(body);env.update(GetUnitAbilityLevel=lambda u,a:int(a=='A10X'),
            Forsaken_ElementAbilityLevel=lambda u,a:int(a=='A10X'),
            GetUnitLevel=lambda u:level[0] if u=='summon' else 99,GetRandomInt=lambda *a:1,
            IsUnitType=lambda *a:False,UNIT_TYPE_HERO='hero',UNIT_TYPE_RESISTANT='resistant',
            udg_EternityMode=False,udg_StoryBoss=None,udg_SummonedBoss=None)
        e=execute(body,['CanExecute'],env)
        self.assertTrue(e['CanExecute']('attacker','summon'))
        level[0]=40;self.assertFalse(e['CanExecute']('attacker','summon'))

    def test_trance_mirage_and_aim_defense_rows_match_live_buffs_in_both_profiles(self):
        template=(ROOT/'experiments/Forsaken/JobStats.j').read_text()
        for prefix,getter in [('Stats','GetUnitAbilityLevel'),('Forsaken','Forsaken_StatAbilityLevel')]:
            s=template.replace('JSTAT',prefix).replace('JGET',getter).replace('JROW',prefix+'_Row')
            active={'B06L':1,'B06W':1,'B01F':1,'A0RH':15};rows=[]
            env=mocks(s);env.update({getter:lambda u,a:active.get(a,0),prefix+'_Row':lambda *a:rows.append(a),
                'R2SW':lambda n,w,d:format(n,'.%df'%d)})
            e=execute(s,[prefix+'_RenderJob'],env)
            e[prefix+'_RenderJob']('hero',1,9)
            self.assertIn((9,'Protection from lethal damage','Trance'),rows)
            self.assertIn((10,'Mirage physical evasion','+40'),rows)
            self.assertIn((11,'Mirage physical hit chance','x0.8'),rows)
            self.assertIn((12,'Aim damage taken','+20%'),rows)
            active.clear();rows.clear()
            self.assertEqual(e[prefix+'_RenderJob']('hero',1,9),9);self.assertEqual(rows,[])

    def test_undead_healing_never_inverts_mana(self):
        s=source('Damage');env=mocks(s)
        env.update(DmgCtx_Amount={1:400.},DmgCtx_Target={1:'necro'},DmgCtx_Holy={1:False},
            DmgCtx_Heal={1:True},DmgCtx_HealUndead={1:False},DmgCtx_Pure={1:False},DmgCtx_ManaDamage={1:True},
            IsUnitType=lambda *a:True,GetUnitAbilityLevel=lambda *a:0,UNIT_TYPE_UNDEAD='undead')
        e=execute(s,['Trig_Damage_Engine_Step02_HealingUndead'],env)
        e['Trig_Damage_Engine_Step02_HealingUndead'](1)
        self.assertTrue(e['DmgCtx_Heal'][1]);self.assertEqual(e['DmgCtx_Amount'][1],400.)
        e['DmgCtx_ManaDamage'][1]=False;e['Trig_Damage_Engine_Step02_HealingUndead'](1)
        self.assertFalse(e['DmgCtx_Heal'][1]);self.assertEqual(e['DmgCtx_Amount'][1],600.)

    def test_chemist_searches_to_last_bag_slot_and_consumes_only_first_match(self):
        s=source('Chemist');env=mocks(s);bag=[None]*36
        item={'charges':3,'raw':123};bag[-1]=item
        env.update(udg_CurrentHero='hero',Carry_Size=lambda u:len(bag),Carry_At=lambda u,i:bag[i],
            Trig_Chemist_TakeItem_Cond_IsChemistItem=lambda: e['udg_ChemistItem'] is not None,
            Carry_Type=lambda it:it['raw'],GetItemCharges=lambda it:it['charges'],
            SetItemCharges=lambda it,n:it.update(charges=n))
        e=execute(s,['Trig_Chemist_TakeItem_Actions'],env)
        e['Trig_Chemist_TakeItem_Actions']();self.assertEqual(e['udg_TempItemId'],123);self.assertEqual(item['charges'],2)
        first={'charges':4,'raw':456};bag[0]=first
        e['Trig_Chemist_TakeItem_Actions']();self.assertEqual(e['udg_TempItemId'],456);self.assertEqual(first['charges'],3);self.assertEqual(item['charges'],2)
        bag[:]=[None]*36;e['Trig_Chemist_TakeItem_Actions']();self.assertEqual(e['udg_TempItemId'],'tkno')

    def test_shield_debits_rank_efficiency_and_handles_insufficient_mana(self):
        s=source('Abil');env=mocks(s);mana=[1000.];eff=[2.];removed=[]
        env.update(udg_DivineShieldHash='links',GetHandleId=lambda u:7,LoadUnitHandle=lambda *a:'caster',
            LoadReal=lambda *a:eff[0],GetUnitState=lambda *a:mana[0],GetUnitTypeId=lambda u:1,
            GetWidgetLife=lambda u:100.,GetUnitAbilityLevel=lambda *a:0,
            RMinBJ=min,SetUnitState=lambda u,k,n:mana.__setitem__(0,n),UNIT_STATE_MANA='mp',
            UnitRemoveAbility=lambda *a:removed.append(a))
        e=execute(s,['JobFX_Shield'],env)
        self.assertEqual(e['JobFX_Shield']('ward',600.),300.);self.assertEqual(mana[0],850.)
        eff[0]=5.;self.assertEqual(e['JobFX_Shield']('ward',600.),300.);self.assertEqual(mana[0],790.)
        mana[0]=10.;self.assertEqual(e['JobFX_Shield']('ward',600.),550.);self.assertEqual(mana[0],0.);self.assertEqual(len(removed),1)

    def test_undying_timer_owns_90_second_cooldown_and_releases_handles(self):
        s=source('Abil');env=mocks(s);table={};group=set();timers=[];dead=[]
        env.update(JobFXData=table,udg_UndyingGroup=group,GetHandleId=lambda u:u,
            CreateTimer=lambda:'clock',SaveUnitHandle=lambda h,k,i,u:h.__setitem__((k,i),u),
            GroupAddUnit=lambda g,u:g.add(u),GroupRemoveUnit=lambda g,u:g.discard(u),
            TimerStart=lambda *a:timers.append(a),GetExpiredTimer=lambda:'clock',
            LoadUnitHandle=lambda h,k,i:h[k,i],FlushChildHashtable=lambda h,k:h.clear(),DestroyTimer=dead.append)
        e=execute(s,['JobFX_UndyingReady','JobFX_UndyingStart'],env)
        e['JobFX_UndyingStart']('necro');self.assertEqual(group,{'necro'});self.assertEqual(timers[0][1:3],(90.,False))
        e['JobFX_UndyingReady']();self.assertEqual(group,set());self.assertEqual(table,{});self.assertEqual(dead,['clock'])

    def test_current_buff_source_rank_drives_speed(self):
        s=re.sub(r"'([A-Za-z0-9]{4})'",lambda m:str(int.from_bytes(m[1].encode(),'big')),source('Abil'));env=mocks(s);rank=[1];raw=[int.from_bytes(b'A070','big')]
        env.update(GetHandleId=lambda u:1,JobFXData={},LoadInteger=lambda h,k,c:raw[0] if c==int.from_bytes(b'B00K','big')+1 else rank[0],
            IMaxBJ=max,IMinBJ=min,I2R=float,GetUnitAbilityLevel=lambda u,raw:int(raw==int.from_bytes(b'B00K','big')))
        e=execute(s,['JobFX_Rank','JobFX_RageSpeed','JobFX_DarkSpeed'],env)
        self.assertEqual(e['JobFX_RageSpeed']('hero'),60.)
        rank[0]=11;self.assertEqual(e['JobFX_RageSpeed']('hero'),120.)
        rank[0]=1;self.assertEqual(e['JobFX_DarkSpeed']('hero'),75.)
        rank[0]=6;self.assertEqual(e['JobFX_DarkSpeed']('hero'),125.)

    def test_shield_handoff_disconnects_old_caster_without_removing_new_shield(self):
        s=source('Prophet');env=mocks(s);table={};caster=['first'];target=['ward'];timers=[];removed=[]
        def create():
            clock='timer'+str(len(timers));timers.append(clock);return clock
        env.update(udg_DivineShieldHash=table,CreateTimer=create,GetTriggerUnit=lambda:caster[0],
            GetSpellTargetUnit=lambda:target[0],GetHandleId=lambda u:u,
            GetUnitAbilityLevel=lambda *a:1,Forsaken_ElementAbilityLevel=lambda *a:1,
            LoadBoolean=lambda h,k,c:h.get((k,c),False),LoadUnitHandle=lambda h,k,c:h.get((k,c)),
            LoadTimerHandle=lambda h,k,c:h.get((k,c)),
            SaveBoolean=lambda h,k,c,v:h.__setitem__((k,c),v),SaveUnitHandle=lambda h,k,c,v:h.__setitem__((k,c),v),
            SaveTimerHandle=lambda h,k,c,v:h.__setitem__((k,c),v),SaveReal=lambda h,k,c,v:h.__setitem__((k,c),v),
            FlushChildHashtable=lambda h,k:[h.pop(key) for key in list(h) if key[0]==k],
            UnitRemoveAbility=lambda *a:removed.append(a))
        e=execute(s,['Trig_Prophet_DivineShield_Actions'],env)
        e['Trig_Prophet_DivineShield_Actions']();self.assertTrue(table['first',0])
        caster[0]='second';e['Trig_Prophet_DivineShield_Actions']()
        self.assertFalse(table['first',0]);self.assertEqual(table['ward',4],'second')
        self.assertFalse(any(key[0]=='timer0' for key in table))
        removed.clear();caster[0]='first';target[0]='other';e['Trig_Prophet_DivineShield_Actions']()
        self.assertEqual(removed,[]);self.assertEqual(table['ward',4],'second')
        self.assertTrue(table['ward',3])

    def test_undying_lethal_hit_restores_health_and_cannot_repeat_during_cooldown(self):
        s=source('Damage');env=mocks(s);life=[];zero=[];cool=[];pending=[False]
        ability=lambda u,raw:int(raw=='A14T')
        env.update(GetTriggerUnit=lambda:'necro',GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GetOwningPlayer=lambda u:0,
            GetPlayerId=lambda p:0,GetEventDamage=lambda:500.,GetUnitAbilityLevel=ability,Forsaken_ElementAbilityLevel=ability,
            Player_GetHero=lambda p:'necro',IsUnitInGroup=lambda u,g:pending[0] if g=='cooldown' else False,
            udg_UndyingGroup='cooldown',GetWidgetLife=lambda u:100.,GetUnitState=lambda u,state:1000.,
            UNIT_STATE_LIFE='hp',UNIT_STATE_MAX_LIFE='maxhp',BlzSetEventDamage=zero.append,
            SetUnitState=lambda *a:life.append(a),JobFX_UndyingStart=lambda u:cool.append(u) or pending.__setitem__(0,True),
            GetLocalPlayer=lambda:0,IsPlayerInForce=lambda *a:True)
        e=execute(s,['Trig_Damage_Engine_PostDamageEffects'],env)
        e['Trig_Damage_Engine_PostDamageEffects']()
        self.assertEqual(zero,[0.]);self.assertEqual(life,[('necro','hp',250.)]);self.assertEqual(cool,['necro'])
        e['Trig_Damage_Engine_PostDamageEffects']();self.assertEqual(zero,[0.]);self.assertEqual(cool,['necro'])

    def test_proxies_remain_visible_to_engine_and_maintenance_is_idempotent(self):
        for module,fn in [('Myriad','Trig_Myriad_Arrows_Actions'),('Meteor','Trig_Meteor_Cast_Actions')]:
            s=source(module);env=mocks(s);hidden=[];orders=[]
            env.update(Trig_Myriad_Arrows_NoTargetUnit=lambda:True,Trig_Meteor_Cast_NoTargetUnit=lambda:True,
                Trig_Myriad_Arrows_IsHero=lambda:False,Trig_Meteor_Cast_IsHero=lambda:False,
                UNIT_STATE_MANA='mp',UNIT_STATE_MAX_MANA='maxmp',GetUnitState=lambda *a:99999.,
                BlzGetAbilityManaCost=lambda *a:300,GetUnitAbilityLevelSwapped=lambda *a:1,
                Prof_GetLevel=lambda *a:0,Prof_InnerManaPower=lambda *a:1.,I2R=float,ModuloInteger=lambda a,b:a%b,
                ShowUnitHide=hidden.append,IssuePointOrderLocBJ=lambda *a:orders.append(a),Rain_Start=lambda *a:orders.append(a))
            execute(s,[fn],env)[fn]();self.assertEqual(hidden,[]);self.assertEqual(len(orders),1)
            self.assertEqual(refresh(s),s)

    def test_stat_rows_follow_current_rank_and_disappear_with_buff(self):
        paths=list((ROOT/'src/triggers').rglob('HeroStats.j'))
        s=paths[0].read_text() if paths else source('Equip')
        prefix='Stats' if 'Stats_RenderJob' in functions(s) else 'Forsaken'
        env=mocks(s);active={'B01F':1,'A14B':1,'A0RH':3};rows=[]
        env.update(GetUnitAbilityLevel=lambda u,raw:active.get(raw,0),Stats_Row=lambda *a:rows.append(a),
            I2S=str,I2R=float,IMaxBJ=max,R2SW=lambda n,w,d:format(n,'.%df'%d))
        env.update(Forsaken_StatAbilityLevel=lambda u,raw:active.get(raw,0),Forsaken_StatRow=lambda *a:rows.append(a))
        fn=prefix+'_RenderJob'
        e=execute(s,[fn],env)
        self.assertEqual(e[fn]('archer',0,10),12)
        self.assertIn((10,'Aim tech damage','+20% | +150'),rows);self.assertIn((11,'Aim attack speed','-30%'),rows)
        active.update(A14B=11,A0RH=15);rows.clear();e[fn]('archer',0,10)
        self.assertIn((10,'Aim tech damage','+20% | +750'),rows);self.assertIn((11,'Aim attack speed','-90%'),rows)
        rows.clear();e[fn]('archer',1,9);self.assertIn((9,'Aim damage taken','+20%'),rows)
        active.clear();rows.clear()
        for page,start in [(0,10),(1,9),(3,7)]:self.assertEqual(e[fn]('archer',page,start),start)
        self.assertEqual(rows,[])
        active['B06N']=1;self.assertEqual(e[fn]('calculator',0,10),11)
        active.clear();active['B052']=1;self.assertEqual(e[fn]('prophet',1,9),10)
        active.clear();active['B00X']=1;self.assertEqual(e[fn]('prophet',3,7),8)

    def test_marker_and_aim_objects_and_tooltips(self):
        def obj(raw,base,mods=[]):return dict(base=base,id=raw,sets=[dict(flag=0,mods=mods.copy())])
        def mod(key,value,kind=3,level=0):return dict(field=key,type=kind,level=level,data=0,value=value,end=0)
        table=dict(version=3,original=[],custom=[obj('A14T','Amgl',[mod('aub1','Revives every 30 seconds.',level=1)]),obj('A14B','Afzy'),obj('A0RH','ACev')])
        data=objects(write_objects(table,3,'w3a'));parsed=read_objects(data,'w3a')['custom']
        self.assertEqual(parsed[0]['base'],'AIev');self.assertEqual(fields(parsed[0])[('Eev1',1)],0.)
        self.assertIn('90 seconds',fields(parsed[0])[('aub1',1)])
        self.assertAlmostEqual(fields(parsed[1])[('Blo1',1)],-.3);self.assertAlmostEqual(fields(parsed[1])[('Blo1',11)],-.9)
        self.assertEqual(fields(parsed[2])['alev'],15);self.assertEqual(objects(data),data)


if __name__=='__main__':unittest.main()

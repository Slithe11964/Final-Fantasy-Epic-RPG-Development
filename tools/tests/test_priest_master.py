"""Execute Priest Master effects, rank data, refresh snapshots and timer preservation."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from priest_master import plan,objects,fields,at,refresh,initializer
from objdata import read_objects
from editor_pair import View
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]


def source(name):return next((ROOT/'src/triggers').rglob(name+'.j')).read_text()


class PriestMasterTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        reference=next((ROOT/'release').glob('*stageATV.w3x')) if not (ROOT/'editor/FFERPG-Editor-Master.w3x').exists() else ROOT/'editor/FFERPG-Editor-Master.w3x'
        cls.view=View(reference)
        cls.config=plan(cls.view.object_bytes('war3map.w3a'),cls.view.object_bytes('war3mapSkin.w3a'))

    def test_master_choices_gate_on_level50_mastery_and_are_exclusive(self):
        from test_talents import runtime
        e,heroes=runtime();hero=heroes[0]
        for choice,name in [(1,'Acid Rain'),(2,'Refresh'),(3,'Swiftmend')]:
            self.assertEqual(e['TalentName'][e['Talent_Index'](12,2,choice)],name)
        self.assertFalse(e['Talent_Choose'](0,2,1))
        e['world']['mastery'][hero]=2
        self.assertTrue(e['Talent_Choose'](0,2,1));self.assertFalse(e['Talent_Choose'](0,2,2))
        e['Talent_ResetJob'](0);self.assertTrue(e['Talent_Choose'](0,2,3))

    def test_swift_engine_duration_halves_every_rank_without_changing_healing(self):
        blob=self.view.object_bytes('war3map.w3a');out=objects(blob,self.config)
        self.assertEqual(objects(out,self.config),out)
        t={o['id']:o for o in read_objects(out,'w3a')['custom']};normal=fields(self.config['abilities']['A00L']);swift=fields(t['pReg'])
        for rank in range(1,12):
            self.assertEqual(swift['adur',rank],at(normal,'adur',rank,12.)/2)
            self.assertEqual(at(swift,'Rej1',rank),at(normal,'Rej1',rank))
        self.assertEqual(swift['adur',11],30.)
        skin=read_objects(objects(self.view.object_bytes('war3mapSkin.w3a'),self.config),'w3a')
        regen=next(o for o in skin['custom'] if o['id']=='A00L')
        self.assertTrue(any('Heals [' in m['value'] for st in regen['sets'] for m in st['mods'] if m['field']=='aub1'))
        for e in self.config['buff_entries']:
            self.assertEqual(fields(t[e['clone']['id']])['amcs',1],0)
            self.assertEqual(fields(t[e['clone']['id']])['acdn',1],0.)
            if e['object']['base']=='AIpr':
                self.assertEqual(fields(t[e['clone']['id']])['Rej2',1],at(fields(e['object']),'irl2',1,0.))

    def test_swift_cast_snapshots_flag_and_later_normal_cast_cancels_pending(self):
        s=source('Regen');writes={};timers=[];active=[True]
        env=mocks(s);env.update(Talent_Active=lambda *a:active[0],GetHandleId=lambda u:u,
            LoadInteger=lambda h,p,c:writes.get((h,p,c),0),SaveInteger=lambda h,p,c,v:writes.__setitem__((h,p,c),v),
            SaveBoolean=lambda h,p,c,v:writes.__setitem__((h,p,c),v),SaveUnitHandle=lambda h,p,c,v:writes.__setitem__((h,p,c),v),
            udg_HealOverTimeHash='hot',PriestDeferred='deferred',CreateTimer=lambda:'pending',
            GetUnitAbilityLevel=lambda *a:11,TimerStart=lambda *a:timers.append(a))
        e=execute(s,['Priest_Swiftmend'],env)
        e['Priest_Swiftmend']('hero','target','A00L')
        self.assertTrue(writes['hot','target',10]);self.assertEqual(writes['deferred','pending',1],11)
        self.assertEqual(writes['hot','target',11],1);self.assertEqual(len(timers),1)
        active[0]=False;e['Priest_Swiftmend']('hero','target','A00L')
        self.assertFalse(writes['hot','target',10]);self.assertEqual(writes['hot','target',11],2)

    def test_regen_doubles_only_regen_part_including_target_strength(self):
        s=source('Regen');hits=[];swift=[False]
        env=mocks(s);env.update(udg_TempReal=0.,udg_HealOverTimeHash='hot',udg_IsPureDamage=False,
            GetEnumUnit=lambda:'target',GetHandleId=lambda u:u,
            Trig_Regen_Periodic_IsNotPaused=lambda:True,Trig_Regen_Periodic_HasRegenBuff=lambda:True,
            Trig_Regen_Periodic_HasNegateHeals=lambda:False,Trig_Regen_Periodic_IsEnumHero=lambda:True,
            Trig_Regen_Periodic_IsHostileOwned=lambda:False,Trig_Regen_Periodic_LacksNegateHeals=lambda:True,
            Trig_Regen_Periodic_HasStoredRegen=lambda:False,Trig_Regen_Periodic_HasRegenAmount=lambda:True,
            Trig_Regen_Periodic_HasClarityBuff=lambda:False,GetHeroStatBJ=lambda *a:100,I2R=float,
            LoadRealBJ=lambda *a:100.,LoadBoolean=lambda *a:swift[0],GetRandomReal=lambda *a:16.,
            ATTACK_TYPE_CHAOS=0,DAMAGE_TYPE_UNIVERSAL=0,bj_HEROSTAT_STR=0,
            UnitDamageTargetBJ=lambda u,t,n,*a:hits.append(n))
        e=execute(s,['Trig_Regen_Periodic_RegenUnit'],env)
        e['Trig_Regen_Periodic_RegenUnit']();self.assertEqual(hits[-1],125.)
        swift[0]=True;e['Trig_Regen_Periodic_RegenUnit']();self.assertEqual(hits[-1],250.)
        self.assertEqual(125.*60,250.*30)

    def test_acid_rain_current_rank_half_healing_enemy_filters_and_stops(self):
        s=source('Regen');damage=[];paused=[];rank=[1];units=[];active=[True];flags=[]
        env=mocks(s);env.update(PriestRainCaster=defaultdict(lambda:None,{0:'caster'}),PriestRainCount=1,
            PriestRainLeft=defaultdict(float,{0:15.}),PriestRainNext=defaultdict(float,{0:.1}),
            PriestRainHealing={1:50.,6:400.},PriestRainRadius={1:900.,6:900.},PriestRainPeriod={1:.1,6:.1},
            PriestRainEnemies={0:units},PriestRainTimer='rain',GetUnitAbilityLevel=lambda *a:rank[0],
            GetWidgetLife=lambda u:0. if u=='dead' else 100.,GetUnitCurrentOrder=lambda u:1,OrderId=lambda s:1,
            Talent_Active=lambda *a:active[0],GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GetOwningPlayer=lambda u:0,
            GroupEnumUnitsInRange=lambda g,*a:g.extend(['enemy','ally','immune','dead']),
            FirstOfGroup=lambda g:g[0] if g else None,GroupRemoveUnit=lambda g,u:g.remove(u),
            IsUnitEnemy=lambda u,p:u!='ally',IsUnitAlly=lambda u,p:u=='ally',IsUnitType=lambda u,t:u=='immune' and t==0,UNIT_TYPE_MAGIC_IMMUNE=0,UNIT_TYPE_STRUCTURE=1,DAMAGE_TYPE_UNIVERSAL=1,
            ATTACK_TYPE_NORMAL=0,DAMAGE_TYPE_MAGIC=0,WEAPON_TYPE_WHOKNOWS=0,
            UnitDamageTarget=lambda c,u,n,*a:damage.append((u,n)),PauseTimer=lambda t:paused.append(t))
        e=execute(s,['Priest_RainTick'],env)
        e['UnitDamageTarget']=lambda c,u,n,*a:(damage.append((u,n)),flags.append((u,e['udg_IsPureDamage'])))
        for _ in range(10):e['Priest_RainTick']()
        self.assertEqual(sum(n for u,n in damage if u=='enemy'),250.);self.assertEqual(sum(n for u,n in damage if u=='ally'),250.)
        self.assertTrue(all(flag==(u=='ally') for u,flag in flags));self.assertFalse(e['udg_IsPureDamage'])
        damage.clear();rank[0]=6
        for _ in range(10):e['Priest_RainTick']()
        self.assertEqual(sum(n for u,n in damage if u=='enemy'),2000.)
        self.assertEqual(sum(n for u,n in damage if u=='ally'),2000.)
        damage.clear();active[0]=False
        for _ in range(10):e['Priest_RainTick']()
        self.assertEqual(sum(n for u,n in damage if u=='ally'),4000.);self.assertFalse(any(u=='enemy' for u,n in damage))
        e['GetUnitCurrentOrder']=lambda u:2;e['Priest_RainTick']()
        self.assertIsNone(e['PriestRainCaster'][0]);self.assertEqual(e['PriestRainCount'],0);self.assertIn('rain',paused)

    def test_refresh_replays_only_present_buffs_preserves_rank_and_custom_state(self):
        s=source('Regen');replays=[];timers=[];stamps=[];memo={}
        env=mocks(s);env.update(PriestRefreshSerial=0,PriestBuffCount=3,PriestBuffIds={0:'B007',1:'B006',2:'B051'},
            PriestBuffSource='source',PriestBuffRanks='rank',PriestReplay='replay',
            GetUnitAbilityLevel=lambda u,b:int(b in ['B007','B051']),GetHandleId=lambda u:u,
            LoadInteger=lambda h,p,c:('A163' if c=='B007' else 'A0RY') if h=='source' else 6 if h=='rank' else memo.get((p,c),0),
            SaveInteger=lambda h,p,c,v:memo.__setitem__((p,c),v),Priest_ReapplyBuff=lambda *a:replays.append(a),
            LoadBoolean=lambda *a:True,LoadUnitHandle=lambda *a:'prophet',LoadTimerHandle=lambda *a:'shield',
            udg_DivineShieldHash='shieldhash',udg_RunicHash='runichash',udg_RunicGroup='runic',
            TimerStart=lambda *a:timers.append(a),SupportBuff_Refresh=lambda u:stamps.append(u),IsUnitInGroup=lambda *a:False,
            Trig_Prophet_DivineShield_ExpireLink=lambda:None,Trig_Runic_Shield_Expire=lambda:None,TimerGetRemaining=lambda t:4.)
        e=execute(s,['Priest_Refresh'],env);e['Priest_Refresh']('target')
        self.assertEqual(replays,[('target','A163',6,'B007'),('target','A0RY',6,'B051')])
        self.assertEqual(timers[0][:3],('shield',7.,False));self.assertEqual(stamps,['target'])
        self.assertNotIn('Trig_Runic_Shield_Apply',functions(s)['Priest_Refresh'])

    def test_refresh_cooldown_changes_only_selected_priest_and_respects_reset(self):
        s=source('Regen');active=[True]
        env=mocks(s);env.update(Talent_Active=lambda *a:active[0],BlzGetAbilityCooldown=lambda *a:10.)
        e=execute(s,['Priest_CooldownBase'],env)
        self.assertEqual(e['Priest_CooldownBase']('hero','A0W9',0),45.)
        self.assertEqual(e['Priest_CooldownBase']('hero','other',0),10.)
        active[0]=False;self.assertEqual(e['Priest_CooldownBase']('hero','A0W9',0),10.)

    def test_special_effect_adds_three_seconds_to_remaining_time_not_full_duration(self):
        s=source('Regen');memo={('target','B052'):10.};starts=[];now=[4.]
        env=mocks(s);env.update(PriestBuffClone='clones',PriestBuffTypes='types',PriestBuffUntil='until',PriestBuffExpiry='timers',
            GetHandleId=lambda u:u,LoadInteger=lambda *a:'clone',CreateUnit=lambda *a:'dummy',
            GetOwningPlayer=lambda u:0,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GetUnitState=lambda *a:100.,
            UNIT_STATE_MANA='mp',UNIT_STATE_MAX_MANA='maxmp',LoadBoolean=lambda h,p,c:p==0,
            LoadStr=lambda *a:'curse',IssueTargetOrder=lambda *a:True,SupportBuff_Now=lambda:now[0],RMaxBJ=max,
            LoadReal=lambda h,p,c:memo.get((p,c),0.),SaveReal=lambda h,p,c,v:memo.__setitem__((p,c),v),
            LoadTimerHandle=lambda *a:'expiry',TimerStart=lambda *a:starts.append(a),Priest_SpecialExpire=lambda:None)
        e=execute(s,['Priest_ReapplyBuff'],env)
        e['Priest_ReapplyBuff']('target','A0L2',6,'B052')
        self.assertEqual(starts[-1][1],9.);self.assertEqual(memo['target','B052'],13.)
        now[0]=5.;e['Priest_ReapplyBuff']('target','A0L2',6,'B052')
        self.assertEqual(starts[-1][1],11.);self.assertEqual(memo['target','B052'],16.)
        starts.clear();e['LoadBoolean']=lambda *a:False
        e['Priest_ReapplyBuff']('target','A163',6,'B007');self.assertEqual(starts,[])

    def test_item_cast_rank_zero_uses_first_rank_even_after_last_charge(self):
        s=source('Regen');recorded=[]
        env=mocks(s);env.update(GetSpellAbilityId=lambda:'A0FW',GetTriggerUnit=lambda:'gaya',GetSpellTargetUnit=lambda:'hero',
            GetUnitAbilityLevel=lambda *a:0,IMaxBJ=max,HaveSavedInteger=lambda *a:True,PriestBuffTypes='types',
            LoadReal=lambda *a:0.,Priest_RecordUnit=lambda *a:recorded.append(a))
        e=execute(s,['Priest_RecordBuff'],env);e['Priest_RecordBuff']()
        self.assertEqual(recorded,[('hero','A0FW',1)])

    def test_proxy_support_buffs_replace_placeholders_and_tooltip_has_selected_talent(self):
        entries={e['raw'] for e in self.config['buff_entries']}
        self.assertTrue({'A163','A179','A162'}<=entries)
        self.assertTrue({'A00G','A0TZ','A01D'}.isdisjoint(entries))
        s=source('Regen');tips=[];active=[True]
        env=mocks(s);env.update(GetUnitAbilityLevel=lambda *a:6,LoadStr=lambda *a:'Original spell.',Talent_Active=lambda *a:active[0],
            TalentName=defaultdict(lambda:'Acid Rain'),TalentText=defaultdict(lambda:'50% healing as damage.'),
            PriestRainHealing={6:400.},PriestRainPeriod={6:.125},I2R=float,R2I=int,R2SW=lambda n,*a:format(n,'.0f'),
            Talent_Index=lambda *a:0,PriestTooltipOffset=0,PriestAbilityText='text',BlzSetAbilityExtendedTooltip=lambda *a:tips.append(a))
        env.update(SpellCalcData='calc',SpellCalcHidden=defaultdict(bool),GetPlayerId=lambda p:0,GetLocalPlayer=lambda:0,LoadInteger=lambda h,r,k:(2 if k==-1 else 1) if r=='A0OM' else 0)
        e=execute(s,['SpellCalc_Tooltip','Priest_AbilityTalentTip'],env);e['Priest_AbilityTalentTip']('hero','A0OM',2,1)
        self.assertIn('Talent: Acid Rain',tips[-1][1]);self.assertEqual(tips[-1][2],5)
        active[0]=False;e['Priest_AbilityTalentTip']('hero','A0OM',2,1);self.assertIn('Original spell.',tips[-1][1]);self.assertNotIn('Talent:',tips[-1][1])

    def test_tranquility_uses_one_scripted_heal_and_rank_math_tooltips(self):
        out=objects(self.view.object_bytes('war3map.w3a'),self.config)
        table={o['id']:o for o in read_objects(out,'w3a')['custom']}
        for rank in range(1,7):
            self.assertEqual(fields(table['A0OM'])['Etq1',rank],0.)
            rate=at(fields(self.config['abilities']['A0OM']),'Etq1',rank)/at(fields(self.config['abilities']['A0OM']),'Etq2',rank)
            self.assertIn('HP per second',fields(table['A0OM'])['aub1',rank])
            if rank==6:self.assertEqual(round(rate*.5),2000)
        s=source('Regen');tips=[]
        env=mocks(s);env.update(GetUnitAbilityLevel=lambda *a:1,LoadStr=lambda *a:'Formula.',Talent_Active=lambda *a:False,
            BlzGetAbilityManaCost=lambda *a:100,GetHeroInt=lambda *a:90,Prof_StaffPower=lambda *a:2.,I2R=float,R2I=int,
            R2SW=lambda n,*a:format(n,'.0f'),PriestTooltipOffset=0,PriestAbilityText='text',BlzSetAbilityExtendedTooltip=lambda *a:tips.append(a))
        env.update(SpellCalcData='calc',SpellCalcHidden=defaultdict(bool),GetPlayerId=lambda p:0,GetLocalPlayer=lambda:0,LoadInteger=lambda h,r,k:(2 if k==-1 else 1) if r=='A0OM' else 0)
        e=execute(s,['SpellCalc_Tooltip','Priest_AbilityTalentTip'],env)
        for raw,number in [('A00M','1900 HP'),('A089','1140 HP'),('A0PC','144 queued HP')]:
            e['Priest_AbilityTalentTip']('hero',raw,0,0);self.assertIn(number,tips[-1][1])

    def test_profile_transform_idempotent_and_initializer_bounded(self):
        for native in [False,True]:
            s=refresh(source('Talents'),self.config,native=native)
            self.assertEqual(refresh(s,self.config,native=native),s)
        for name,body in functions(initializer(self.config)).items():self.assertLessEqual(len(body.splitlines()),163)


if __name__=='__main__':unittest.main()

"""Execute Life attack scaling, attack-path healing and rain revival routing."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
from unittest.mock import patch
import test_quest_lifecycle as harness
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions
from priest_legendary import refresh,objects
from objdata import read_objects
from editor_pair import View
ROOT=Path(__file__).resolve().parents[2]


class PriestLegendaryTests(unittest.TestCase):
    def source(self,name):return next((ROOT/'src/triggers').rglob(name+'.j')).read_text()

    def test_holy_bolts_uses_exact_staff_life_power_including_robe_and_buffs(self):
        s=self.source('Prof');power=[1.5];buff=[0.];chosen=[True]
        e=execute(s,['Talent_LifeAttackPower'],dict(Talent_PriestChoice=lambda *a:chosen[0],Talent_HealingPower=lambda u:buff[0],Prof_StaffPower=lambda u:power[0]))
        self.assertAlmostEqual(e['Talent_LifeAttackPower']('hero'),.5)
        power[0]=1.8;self.assertAlmostEqual(e['Talent_LifeAttackPower']('hero'),.8) # White Robe adds 30 percentage points.
        power[0]=2.3;self.assertAlmostEqual(e['Talent_LifeAttackPower']('hero'),1.3) # Ten Staff levels add another 50.
        buff[0]=.5;self.assertAlmostEqual(e['Talent_LifeAttackPower']('hero'),2.45)
        chosen[0]=False;self.assertEqual(e['Talent_LifeAttackPower']('hero'),0.)

    def test_legendary_row_unlocks_at_100_and_remains_one_choice(self):
        from test_talents import runtime
        e,heroes=runtime();hero=heroes[0]
        e['world']['mastery'][hero]=3;self.assertFalse(e['Talent_Choose'](0,4,1))
        e['world']['mastery'][hero]=4;self.assertTrue(e['Talent_Choose'](0,4,1));self.assertFalse(e['Talent_Choose'](0,4,2))
        self.assertEqual([e['TalentName'][e['Talent_Index'](12,4,c)] for c in (1,2,3)],['Healing Bolts','Tranquility of Life','Refresh'])

    def test_healing_bolts_heal_all_friendly_units_inside_attack_segment_only(self):
        s=self.source('Talents');memo={(0,0):'priest',(0,1):0.,(0,2):0.,(0,3):1000.,(0,4):0.,(0,5):250.}
        positions={'priest':(0.,0.),'ally':(500.,0.),'edge':(750.,128.),'far':(500.,129.),'behind':(-5.,0.),'past':(1005.,0.),'enemy':(500.,0.),'dead':(100.,0.),'building':(600.,0.)}
        hits=[];destroyed=[];env=mocks(s)
        env.update(TalentLegendState='legend',GetExpiredTimer=lambda:0,GetHandleId=lambda x:x,
            LoadUnitHandle=lambda h,p,c:memo[p,c],LoadReal=lambda h,p,c:memo[p,c],
            CreateGroup=list,GroupEnumUnitsInRange=lambda g,*a:g.extend(positions),FirstOfGroup=lambda g:g[0] if g else None,GroupRemoveUnit=lambda g,u:g.remove(u),
            DestroyGroup=lambda g:destroyed.append('group'),FlushChildHashtable=lambda h,k:None,DestroyTimer=lambda t:destroyed.append('timer'),
            GetUnitX=lambda u:positions[u][0],GetUnitY=lambda u:positions[u][1],GetOwningPlayer=lambda u:0,
            IsUnitAlly=lambda u,p:u!='enemy',GetWidgetLife=lambda u:0. if u=='dead' else 100.,IsUnitType=lambda u,k:u=='building',UNIT_TYPE_STRUCTURE=0,
            SquareRoot=lambda n:n**.5,ATTACK_TYPE_CHAOS=0,DAMAGE_TYPE_UNIVERSAL=1,UnitDamageTarget=lambda c,u,n,*a:hits.append((u,n)))
        expression=harness.expression
        # This geometry function uses real division; the quest harness defaults to integer division.
        with patch.object(harness,'expression',lambda text:expression(text).replace('//','/')):
            e=execute(s,['Talent_HealingBoltResolve'],env)
        e['Talent_HealingBoltResolve']()
        self.assertEqual(hits,[('ally',250.),('edge',250.)]);self.assertEqual(destroyed,['group','timer'])
        self.assertFalse(e['udg_IsPureDamage']);self.assertFalse(e['udg_DmgFlagPure'])

    def test_rain_never_revives_its_caster_but_other_priests_can_be_allies(self):
        s=(ROOT/'experiments/Forsaken/PriestLegendary.j').read_text().split('// FUNCTIONS\n',1)[1]
        casters=defaultdict(lambda:None,{0:'caster',1:'other'})
        env=mocks(s);env.update(TalentRainCaster=casters,TalentRainRadius=defaultdict(lambda:600.),
            GetPlayerId=lambda p:p,GetOwningPlayer=lambda u:0 if u=='caster' else 1,
            Talent_LegendChoice=lambda u,c:u is not None,GetWidgetLife=lambda u:100.,
            GetUnitCurrentOrder=lambda u:1,OrderId=lambda s:1,IsUnitAlly=lambda *a:True,
            IsUnitType=lambda *a:False,UNIT_TYPE_STRUCTURE=0,GetUnitX=lambda u:0.,GetUnitY=lambda u:0.)
        e=execute(s,['Talent_RainCanRevive'],env)
        self.assertFalse(e['Talent_RainCanRevive']('caster'))
        casters[1]=None
        self.assertTrue(e['Talent_RainCanRevive']('other'))

    def test_rain_revives_hero_at_death_position_with_full_health_and_mana(self):
        s=self.source('Talents');restores=[];revives=[]
        env=mocks(s);env.update(Talent_RainCanRevive=lambda u:True,IsUnitType=lambda *a:True,UNIT_TYPE_HERO=0,
            GetUnitX=lambda u:123.,GetUnitY=lambda u:456.,ReviveHero=lambda *a:(revives.append(a) or True),
            UNIT_STATE_LIFE='hp',UNIT_STATE_MAX_LIFE='maxhp',UNIT_STATE_MANA='mp',UNIT_STATE_MAX_MANA='maxmp',
            GetUnitState=lambda u,k:4000. if k=='maxhp' else 2500.,SetUnitState=lambda *a:restores.append(a))
        e=execute(s,['Talent_TryRainRevive'],env)
        self.assertTrue(e['Talent_TryRainRevive']('ally'));self.assertEqual(revives,[('ally',123.,456.,True)])
        self.assertEqual(restores,[('ally','hp',4000.),('ally','mp',2500.)])
        body=functions(self.source('Hero_Death'))['Trig_Hero_Death_Revive_Actions']
        self.assertLess(body.index('Talent_TryRainRevive'),body.index('call DialogDisplay'))

    def test_prolonged_cleansing_refreshes_ten_second_expiry_and_does_not_clear_beneficial_buffs(self):
        s=self.source('Talents');memo={};members=set();starts=[];now=[50.];cleansed=[]
        env=mocks(s);env.update(TalentLegendState='legend',TalentLegendClock='clock',TalentCleansingTimer='clean',TalentCleansingUnits=members,
            Job_GetIndex=lambda u:12,Talent_Has=lambda *a:True,GetHandleId=lambda u:u,TimerGetElapsed=lambda t:now[0],
            SaveReal=lambda h,p,c,v:memo.__setitem__((p,c),v),LoadReal=lambda h,p,c:memo.get((p,c),0.),
            GroupAddUnit=lambda g,u:g.add(u),TimerStart=lambda *a:starts.append(a),Talent_CleanseStatus=lambda u:cleansed.append(u))
        e=execute(s,['Talent_ProlongedCleansing','Talent_CleansingProtected'],env)
        e['Talent_ProlongedCleansing']('priest','ally');self.assertEqual(memo['ally',10],60.)
        now[0]=55.;e['Talent_ProlongedCleansing']('priest','ally');self.assertEqual(memo['ally',10],65.)
        now[0]=64.99;self.assertTrue(e['Talent_CleansingProtected']('ally'))
        now[0]=65.;self.assertFalse(e['Talent_CleansingProtected']('ally'))
        self.assertIn('UnitRemoveBuffsEx(target,false,true',functions(s)['Talent_CleanseStatus'])
        self.assertEqual(members,{'ally'})

    def test_ordinary_allies_use_untargeted_resurrection_at_the_death_position(self):
        s=self.source('Talents');spawns=[];orders=[];starts=[];env=mocks(s)
        env.update(GetTriggerUnit=lambda:'ally',IsUnitType=lambda *a:False,UNIT_TYPE_HERO=0,
            Talent_RainCanRevive=lambda u:True,GetOwningPlayer=lambda u:2,GetUnitX=lambda u:123.,GetUnitY=lambda u:456.,
            CreateUnit=lambda *a:(spawns.append(a) or 'dummy'),IssueImmediateOrder=lambda *a:orders.append(a),
            CreateTimer=lambda:'pending',TalentLegendState='legend',GetHandleId=lambda u:u,TimerStart=lambda *a:starts.append(a))
        e=execute(s,['Talent_RainDeath'],env);e['Talent_RainDeath']()
        self.assertEqual(spawns,[(2,'h02S',123.,456.,0.)])
        self.assertEqual(orders,[('dummy','resurrection')]);self.assertEqual(starts[0][1],.1)

    def test_damage_hook_only_heals_for_actual_basic_health_damage_after_absorb(self):
        s=self.source('Damage');f=functions(s)
        self.assertIn('DmgCtx_PriestBasic[c] and not l_heal and not l_manaDamage',f['Trig_Damage_Engine_Step19_Apply'])
        self.assertIn('RMinBJ(l_amount,GetWidgetLife(t))',f['Trig_Damage_Engine_Step19_Apply'])
        self.assertLess(f['Trig_Damage_Engine_Step19_Apply'].index('Talent_AbsorbShield'),f['Trig_Damage_Engine_Step19_Apply'].index('Talent_HealingBolt'))
        self.assertIn('DmgCtx_PriestBasic[c]=false',f['Trig_Damage_Engine_FreeContext'])

    def test_transform_and_resurrection_object_are_idempotent(self):
        for name in ['Talents','Prof','Damage','Hero_Death','Regen','Missile']:
            s=self.source(name);self.assertEqual(refresh(refresh(s)),refresh(s),name)
        reference=ROOT/'editor/FFERPG-Editor-Master.w3x'
        if not reference.exists():reference=(ROOT/'release/0.9.7.5h/FFERPG-0.9.7.5h-Save01.w3x')
        v=View(reference);data=objects(v.object_bytes('war3map.w3a'));self.assertEqual(objects(data),data)
        obj=next(o for o in read_objects(data,'w3a')['custom'] if o['id']=='pRiv');self.assertEqual(obj['base'],'AHre')

if __name__=='__main__':unittest.main()

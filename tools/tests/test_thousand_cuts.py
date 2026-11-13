from collections import defaultdict
from pathlib import Path
import math,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions
from thousand_cuts import ROOT,tooltip,objects,refresh
from mpq import MPQ
from damage_tooltips import merged
from priest_master import fields

SOURCE=(ROOT/'experiments/Forsaken/ThousandCuts.j').read_text()

class ThousandCutsTests(unittest.TestCase):
    def runtime(self):
        state={'now':0.,'caster':'thief0','spell':'A0KY','event':'effect','rank':1,'mana':10000.};store={};live=set();sound=[];hits=[];queued=[];fields_written=[]
        def save(h,p,k,value):store[p,k]=value
        def fx(*args):value=len(live)+len(store)+1;live.add(value);return value
        owner=lambda u:1 if u=='thief1' else 0
        e=mocks(SOURCE)
        e.update(CutsClock='cuts-clock',CutsData='data',CutsTimer='timer',NativeCDClock='clock',CutsNow=0.,CutsTimerRunning=False,
            CutsCaster=defaultdict(lambda:None),CutsTarget=defaultdict(lambda:None),CutsActive=defaultdict(bool),CutsRipping=defaultdict(bool),CutsRipRequested=defaultdict(bool),CutsRestore=defaultdict(bool),CutsFirst=defaultdict(lambda:1),CutsLast=defaultdict(int),CutsCount=defaultdict(int),CutsRank=defaultdict(int),CutsRipUntil=defaultdict(float),CutsRipDamage=defaultdict(float),CutsNextMana=defaultdict(float),CutsCounter=defaultdict(lambda:None),
            SaveReal=save,SaveEffectHandle=save,LoadReal=lambda h,p,k:store.get((p,k),0.),LoadEffectHandle=lambda h,p,k:store.get((p,k)),
            RemoveSavedHandle=lambda h,p,k:store.pop((p,k),None),RemoveSavedReal=lambda h,p,k:store.pop((p,k),None),
            FlushChildHashtable=lambda h,p:[store.pop(k) for k in list(store) if k[0]==p],
            AddSpecialEffect=fx,AddSpecialEffectTarget=fx,DestroyEffect=lambda handle:live.discard(handle),
            GetOwningPlayer=owner,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'thief'+str(p),
            IsUnitIllusion=lambda u:False,IsUnitEnemy=lambda u,p:u in ['enemy','other'],IsUnitType=lambda *a:False,UNIT_TYPE_STRUCTURE=0,
            GetWidgetLife=lambda u:0. if u is None else 10000.,GetUnitTypeId=lambda u:1 if u else 0,
            GetHeroAgi=lambda *a:100,Prof_GetLevel=lambda *a:10,GetUnitAbilityLevel=lambda u,r:state['rank'],
            GetUnitX=lambda u:0.,GetUnitY=lambda u:0.,GetUnitFacing=lambda u:0.,BlzGetUnitZ=lambda u:200.,GetUnitFlyHeight=lambda u:0.,
            Cos=math.cos,Sin=math.sin,Atan2=math.atan2,RAbsBJ=abs,bj_RADTODEG=180/math.pi,bj_PI=math.pi,ModuloInteger=lambda a,b:a%b,
            I2R=float,I2S=str,IMaxBJ=max,RMinBJ=min,TimerGetElapsed=lambda t:state['now'],
            CreateTextTag=lambda:'counter',CreateSoundFromLabel=lambda label,*a:sound.append(label) or 'sound',
            BlzIsUnitInvulnerable=lambda u:False,UnitDamageTarget=lambda u,t,d,*a:hits.append((u,t,d)),
            ATTACK_TYPE_PIERCE=2,DAMAGE_TYPE_NORMAL=1,GetTriggerUnit=lambda:state['caster'],GetSpellAbilityId=lambda:state['spell'],GetTriggerEventId=lambda:state['event'],EVENT_PLAYER_UNIT_SPELL_EFFECT='effect',
            BlzGetUnitAbility=lambda u,r:u+'-ability',ABILITY_ILF_MANA_COST='mana',ABILITY_RLF_COOLDOWN='cooldown',
            BlzGetAbilityManaCost=lambda raw,rank:0,UNIT_STATE_MANA='mana',GetUnitState=lambda *a:state['mana'],SetUnitState=lambda u,k,v:state.__setitem__('mana',v),
            BlzSetAbilityIntegerLevelField=lambda *a:fields_written.append(a),BlzSetAbilityRealLevelField=lambda *a:fields_written.append(a),
            SharedItemCD_Duration=lambda *a:12.6,NativeCD_Queue=lambda *a:queued.append(a))
        return execute(SOURCE,list(functions(SOURCE)),e),state,live,hits,queued,fields_written,sound

    def arm(self,e,state,caster='thief0'):
        state.update(caster=caster,event='effect');e['Cuts_Cast']()

    def test_daggers_use_the_requested_agility_formula_at_every_rank(self):
        e,s,*_=self.runtime()
        for rank in range(1,7):
            s['rank']=rank
            self.assertEqual(e['Cuts_Damage']('thief0',40),(4000+1200)*1.5)
            self.assertEqual(e['Cuts_Damage']('thief0',80),2*(4000+1200)*1.5)

    def test_lock_to_first_target_and_no_stack_cap(self):
        e,s,live,*_=self.runtime();self.arm(e,s)
        for _ in range(55):e['Cuts_OnHit']('thief0','enemy')
        e['Cuts_OnHit']('thief0','other')
        self.assertEqual(e['CutsCount'][0],55);self.assertEqual(e['CutsTarget'][0],'enemy')
        self.assertEqual(len(live),55)

    def test_other_players_cannot_add_or_clear_each_others_daggers(self):
        e,s,live,*_=self.runtime();self.arm(e,s);self.arm(e,s,'thief1')
        e['Cuts_OnHit']('thief0','enemy');e['Cuts_OnHit']('thief1','other')
        self.assertEqual(e['CutsCount'][0],1);self.assertEqual(e['CutsCount'][1],1)
        e['Cuts_Clear'](0)
        self.assertEqual(e['CutsCount'][1],1);self.assertEqual(e['CutsTarget'][1],'other');self.assertEqual(len(live),1)

    def test_expiry_does_not_refresh_older_daggers(self):
        e,s,live,*_=self.runtime();self.arm(e,s)
        e['Cuts_OnHit']('thief0','enemy');s['now']=15.;e['Cuts_OnHit']('thief0','enemy')
        s['now']=29.99;e['Cuts_Tick']();self.assertEqual(e['CutsCount'][0],2)
        s['now']=30.;e['Cuts_Tick']();self.assertEqual(e['CutsCount'][0],1)
        s['now']=45.;e['Cuts_Tick']();self.assertEqual(e['CutsCount'][0],0);self.assertFalse(live)

    def test_second_activation_rips_once_with_sound_and_reduced_cooldown(self):
        e,s,live,hits,queued,writes,sounds=self.runtime();self.arm(e,s)
        for _ in range(40):e['Cuts_OnHit']('thief0','enemy')
        self.assertFalse(sounds);s['event']='channel';e['Cuts_Cast']();s['event']='effect';e['Cuts_Cast']()
        self.assertEqual(queued[-1],('thief0','A0KY',12.6,False))
        s['now']=.25;e['Cuts_Tick']()
        self.assertEqual(hits,[('thief0','enemy',7800.)]);self.assertEqual(sounds,['MetalHeavySliceFlesh']);self.assertFalse(live)
        s['now']=.5;e['Cuts_Tick']();self.assertEqual(len(hits),1)

    def test_rip_costs_three_hundred_and_activation_cost_is_zero(self):
        e,s,live,hits,queued,writes,sounds=self.runtime();self.arm(e,s)
        e['Cuts_OnHit']('thief0','enemy')
        e['Cuts_Tick']();self.assertIn(('thief0-ability','mana',0,300),writes)
        s['event']='channel';e['Cuts_Cast']();self.assertEqual(writes[-2:], [('thief0-ability','mana',0,300),('thief0-ability','cooldown',0,12.6)])
        s['event']='effect';e['Cuts_Cast']();s['now']=.05;e['Cuts_Tick']()
        self.assertIn(('thief0-ability','mana',0,0),writes)

    def test_death_and_replaced_hero_clean_up_and_stop_timer(self):
        for replaced in [False,True]:
            e,s,live,*_=self.runtime();self.arm(e,s);e['Cuts_OnHit']('thief0','enemy')
            if replaced:e['Player_GetHero']=lambda p:'replacement'
            else:e['GetWidgetLife']=lambda u:0. if u=='thief0' else 10000.
            e['Cuts_Tick']();self.assertFalse(live);self.assertFalse(e['CutsActive'][0]);self.assertFalse(e['CutsTimerRunning'])

    def test_objects_preserve_skill_id_and_other_abilities(self):
        m=MPQ(str(ROOT/'release/development/QuickUI28/FFERPG-QuickUI28-Forsaken.w3x'))
        a,b=objects(m.read('war3map.w3a'),m.read('war3mapSkin.w3a'))
        before=merged(m.read('war3map.w3a'),m.read('war3mapSkin.w3a'),'w3a');after=merged(a,b,'w3a')
        self.assertEqual(set(before),set(after))
        for raw in before:
            if raw!='A0KY':self.assertEqual(fields(before[raw]),fields(after[raw]),raw)
        f=fields(after['A0KY']);self.assertEqual(f['alev',0],6);self.assertEqual(after['A0KY']['base'],'ANcl')
        for rank in range(1,7):
            self.assertEqual(f['Ncl1',rank],0.);self.assertEqual(f['Ncl5',rank],0)
            self.assertIn('damage per dagger',f['aub1',rank]);self.assertIn('100 + 0.3 x AGI',f['aub1',rank]);self.assertEqual(f['acdn',rank],120.);self.assertEqual(f['amcs',rank],0)
            self.assertIn('1 + 5% x Dagger proficiency',f['aub1',rank])

    def test_embedded_code_is_shared_and_uses_no_local_game_state(self):
        self.assertNotIn('GetLocalPlayer',SOURCE);self.assertNotIn('IsUnitSelected',SOURCE)
        self.assertNotIn('PauseUnit',SOURCE);self.assertIn('PauseTimer(CutsTimer)',SOURCE)

    def test_cooldown_adapter_preserves_function_signature(self):
        source="library TCooldown\nglobals\nendglobals\nfunction Trig_Cooldown_Scaling_Conditions takes nothing returns boolean\n    return true\nendfunction\nendlibrary"
        updated=refresh(source)
        self.assertIn('takes nothing returns boolean',updated)
        self.assertIn("return(GetSpellAbilityId()!='A0KY')and true",updated)
        self.assertEqual(refresh(updated),updated)

    def test_mana_drain_ticks_once_per_second_and_stops_on_rip(self):
        e,s,live,hits,queued,writes,sounds=self.runtime();s['mana']=1000.;self.arm(e,s)
        s['now']=.99;e['Cuts_Tick']();self.assertEqual(s['mana'],1000.)
        s['now']=1.;e['Cuts_Tick']();self.assertEqual(s['mana'],980.)
        s['now']=3.;e['Cuts_Tick']();self.assertEqual(s['mana'],940.)
        e['Cuts_OnHit']('thief0','enemy');s['event']='channel';e['Cuts_Cast']();s['event']='effect';e['Cuts_Cast']()
        s['now']=3.25;e['Cuts_Tick']();s['now']=5.;e['Cuts_Tick']()
        self.assertEqual(s['mana'],940.)

    def test_mana_exhaustion_clears_blades_without_free_rip(self):
        e,s,live,hits,queued,writes,sounds=self.runtime();s['mana']=19.;self.arm(e,s)
        e['Cuts_OnHit']('thief0','enemy');s['now']=1.;e['Cuts_Tick']()
        self.assertFalse(e['CutsActive'][0]);self.assertFalse(live);self.assertFalse(hits);self.assertFalse(sounds)
        self.assertEqual(queued[-1],('thief0','A0KY',12.6,False))
        self.assertFalse(e['CutsTimerRunning'])

    def test_tooltip_only_uses_per_dagger_formula_and_requested_costs(self):
        from thousand_cuts import ICON
        for rank in range(1,7):
            text=tooltip(rank)
            self.assertNotIn('Locks to',text);self.assertNotIn('Stacks have no cap',text)
            self.assertNotIn('40',text);self.assertNotIn('normal cooldown modifiers',text)
            self.assertIn('20 MP per second',text);self.assertIn('300 MP',text);self.assertIn('120 seconds',text)
            self.assertIn('Physical damage per dagger:',text)
        m=MPQ(str(ROOT/'release/development/QuickUI29/FFERPG-QuickUI29-Forsaken.w3x'))
        self.assertTrue(m.read(ICON));self.assertTrue(m.read(ICON.replace('CommandButtons\\BTN','CommandButtonsDisabled\\DISBTN')))

if __name__=='__main__':unittest.main()

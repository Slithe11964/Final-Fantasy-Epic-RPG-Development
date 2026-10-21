"""Actual relocated talent gates, exact shield display and native icon/readout wiring."""
from pathlib import Path
import sys,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1])]
from priest_followup import refresh,HOLY
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]


class PriestFollowupTests(unittest.TestCase):
    def source(self,name):return next((ROOT/'src/triggers').rglob(name+'.j')).read_text()

    def test_regen_shielding_keeps_target_queued_for_every_tick(self):
        s=refresh(self.source('Regen'));heals=[];removed=[]
        env=mocks(s);env.update(GetEnumUnit=lambda:'target',GetHandleId=lambda u:u,
            LoadUnitHandle=lambda *a:'priest',LoadRealBJ=lambda *a:100.,LoadBoolean=lambda *a:False,
            GetUnitLevel=lambda u:1,I2R=float,Talent_PriestChoice=lambda *a:True,ATTACK_TYPE_CHAOS=1,DAMAGE_TYPE_UNIVERSAL=2,
            Trig_Regen_Periodic_IsNotPaused=lambda:True,Trig_Regen_Periodic_HasRegenBuff=lambda:True,
            Trig_Regen_Periodic_HasNegateHeals=lambda:False,Trig_Regen_Periodic_IsEnumHero=lambda:False,
            Trig_Regen_Periodic_IsHostileOwned=lambda:False,Trig_Regen_Periodic_LacksNegateHeals=lambda:True,
            Trig_Regen_Periodic_HasStoredRegen=lambda:False,Trig_Regen_Periodic_HasRegenAmount=lambda:False,
            Trig_Regen_Periodic_HasClarityBuff=lambda:False,GetRandomReal=lambda *a:16.,
            UnitDamageTargetBJ=lambda *a:heals.append(a),GroupAddUnitSimple=lambda *a:removed.append(a))
        e=execute(s,['Trig_Regen_Periodic_RegenUnit'],env)
        for _ in range(3):e['Trig_Regen_Periodic_RegenUnit']()
        self.assertEqual(len(heals),3);self.assertEqual(removed,[])

    def test_world_shield_label_follows_target_and_is_cleaned_on_empty(self):
        from collections import defaultdict
        s=refresh(self.source('Talents'));store={};tags=[];destroyed=[];members=set();positions=[];labels=[];effects=[];effect_deaths=[]
        env=mocks(s);env.update(TalentShieldState='shield',TalentShieldDisplayGroup='group',TalentShieldDisplayTimer='timer',
            GetHandleId=lambda u:u,LoadReal=lambda h,p,c:store.get((p,c),0.),LoadTextTagHandle=lambda h,p,c:store.get((p,c)),
            LoadEffectHandle=lambda h,p,c:store.get((p,c)),SaveEffectHandle=lambda h,p,c,v:store.__setitem__((p,c),v),
            AddSpecialEffectTarget=lambda *a:effects.append(a) or 'barrier',DestroyEffect=effect_deaths.append,
            SaveTextTagHandle=lambda h,p,c,v:store.__setitem__((p,c),v),RemoveSavedHandle=lambda h,p,c:store.pop((p,c),None),
            CreateTextTag=lambda:tags.append('tag') or 'tag',DestroyTextTag=destroyed.append,
            GetUnitX=lambda u:400.,GetUnitY=lambda u:500.,GetUnitFlyHeight=lambda u:0.,GetWidgetLife=lambda u:100.,GetUnitTypeId=lambda u:1,
            GetOwningPlayer=lambda u:0,GetLocalPlayer=lambda:0,IsUnitVisible=lambda *a:True,IsUnitHidden=lambda *a:False,
            SetTextTagText=lambda *a:labels.append(a),SetTextTagPos=lambda *a:positions.append(a),I2S=str,R2I=int,
            FirstOfGroup=lambda g:next(iter(members),None),GroupAddUnit=lambda g,u:members.add(u),GroupRemoveUnit=lambda g,u:members.discard(u))
        e=execute(s,['Talent_ShieldDisplayClear','Talent_ShieldDisplayUpdate'],env)
        store['target',0]=75.;e['Talent_ShieldDisplayUpdate']('target')
        self.assertEqual(tags,['tag']);self.assertEqual(labels[-1][1],'Shield: 75');self.assertEqual(positions[-1][1:3],(220.,580.))
        self.assertEqual(positions[-1][3],155.)
        e['Talent_ShieldDisplayUpdate']('target');self.assertEqual(len(effects),1)
        self.assertIn('DivineShieldTarget.mdl',effects[0][0])
        store['target',0]=0.;e['Talent_ShieldDisplayUpdate']('target')
        self.assertEqual(destroyed,['tag']);self.assertEqual(members,set());self.assertEqual(effect_deaths,['barrier'])

    def test_relocated_choices_unlock_at_their_new_rank_and_have_exact_text(self):
        from test_talents import runtime
        e,heroes=runtime();h=heroes[0];e['world']['mastery'][h]=2
        self.assertEqual(e['TalentName'][e['Talent_Index'](12,2,2)],'Holy Bolts')
        self.assertEqual(e['TalentText'][e['Talent_Index'](12,2,2)],HOLY)
        self.assertEqual(e['TalentName'][e['Talent_Index'](12,3,3)],'Prolonged Cleansing')
        self.assertEqual(e['TalentName'][e['Talent_Index'](12,4,3)],'Refresh')
        self.assertTrue(e['Talent_Choose'](0,2,2));self.assertFalse(e['Talent_Choose'](0,4,3))
        e['world']['mastery'][h]=4;self.assertTrue(e['Talent_Choose'](0,4,3))

    def test_holy_bolts_checks_master_slot_not_old_ultimate_slot(self):
        s=self.source('Talents');picks={(2,2)}
        e=execute(s,['Talent_PriestChoice'],dict(Job_GetIndex=lambda u:12,Talent_Has=lambda u,r,c:(r,c) in picks))
        self.assertTrue(e['Talent_PriestChoice']('priest',3))
        picks.clear();picks.add((3,3));self.assertFalse(e['Talent_PriestChoice']('priest',3))

    def test_refresh_runtime_and_tooltip_metadata_use_legendary_slot(self):
        f=functions(self.source('Regen'))
        for name in ['Priest_CooldownBase','Priest_MasterEsuna']:
            self.assertIn(",12,4,3,'A0W9')",f[name])
            self.assertNotIn(",12,2,2,'A0W9')",f[name])
        self.assertIn("SaveInteger(SpellCalcData,'A0W9',-1,4)",self.source('Regen'))
        self.assertIn("Talent_Has(hero,3,3)",f['SpellCalc_Tooltip'])

    def test_shield_amount_tracks_pool_absorption_and_expiry(self):
        from test_priest_ultimate import PriestUltimateTests
        e,memo,timers,destroyed,buffs,world=PriestUltimateTests().runtime()
        e.update(TalentShieldState='shield',GetHandleId=lambda x:x,GetWidgetLife=lambda u:100. if world['living'] else 0.,RMaxBJ=max)
        e=execute(self.source('Talents'),['Talent_ShieldAmount'],e)
        e['Talent_AddShield']('target',300.);e['Talent_AddShield']('target',200.)
        self.assertEqual(e['Talent_ShieldAmount']('target'),500.)
        e['Talent_AbsorbShield']('target',120.);self.assertEqual(e['Talent_ShieldAmount']('target'),380.)
        e['Talent_ShieldExpire']();self.assertEqual(e['Talent_ShieldAmount']('target'),0.)

    def test_native_magic_cure_icons_and_shared_startup_readout(self):
        from mpq import MPQ
        p=ROOT/'release/pairs/PAIR036/FFERPG-PAIR036-Forsaken.w3x'
        if not p.exists():self.skipTest('native reference absent in isolated profile workspace')
        s=MPQ(str(p)).read('war3map.j').decode();s=refresh(s,native=True);f=functions(s)
        self.assertEqual(refresh(s,native=True),s)
        self.assertIn('node==4 or node==9',f['Forsaken_DrawPanels'])
        self.assertIn('infocard-attack-magic.blp',f['Forsaken_DrawPanels'])
        self.assertIn("BlzGetAbilityIcon('A00M')",f['Forsaken_DrawPanels'])
        self.assertIn('ORIGIN_FRAME_HERO_HP_BAR',f['Register_Forsaken_PanelAccess'])
        self.assertNotIn('GetLocalPlayer',f['Register_Forsaken_PanelAccess'])
        self.assertIn('BlzFrameSetVisible(ForsakenShieldReadout,false)',f['Forsaken_ShieldReadout'])
        self.assertIn(HOLY,f['Forsaken_HolyBoltsTooltip'])

    def test_shared_transform_is_idempotent_and_stats_show_shielding(self):
        for name in ['Talents','Regen','Prof','HeroStats']:
            try:s=self.source(name)
            except StopIteration:continue
            self.assertEqual(refresh(refresh(s)),refresh(s),name)
        try:self.assertIn('"Shielding",R2SW(Talent_ShieldAmount(hero)',self.source('HeroStats'))
        except StopIteration:pass


if __name__=='__main__':unittest.main()

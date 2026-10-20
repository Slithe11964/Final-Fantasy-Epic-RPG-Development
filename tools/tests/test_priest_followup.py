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
        self.assertIn('Talent_ShieldAmount(hero)',f['Forsaken_ShieldReadout'])
        self.assertIn(HOLY,f['Forsaken_HolyBoltsTooltip'])

    def test_shared_transform_is_idempotent_and_stats_show_shielding(self):
        for name in ['Talents','Regen','Prof','HeroStats']:
            try:s=self.source(name)
            except StopIteration:continue
            self.assertEqual(refresh(refresh(s)),refresh(s),name)
        try:self.assertIn('"Shielding",R2SW(Talent_ShieldAmount(hero)',self.source('HeroStats'))
        except StopIteration:pass


if __name__=='__main__':unittest.main()

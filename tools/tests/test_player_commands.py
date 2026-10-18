"""Per-player tooltip preferences, trial durability and gear carry boundaries."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from damage_tooltips import catalogue as damage_catalogue
from spell_calculations import catalogue,HMARK,TALENTS,objects
from legend_progress import refresh
from player_commands import legend_data,refresh as commands
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
from priest_master import fields
from objdata import read_objects
ROOT=Path(__file__).resolve().parents[2]


def source(stem):return next((ROOT/'src/triggers').rglob(stem+'.j')).read_text()


class PlayerCommandTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        reference=ROOT/'editor/FFERPG-Editor-Master.w3x'
        if not reference.exists():reference=next((ROOT/'release').glob('*stageATV.w3x'))
        cls.view=View(reference)
        v=cls.view
        cls.config=catalogue(damage_catalogue(v.object_bytes('war3map.w3a'),v.object_bytes('war3mapSkin.w3a'),v.object_bytes('war3map.w3t'),v.object_bytes('war3mapSkin.w3t')))

    def tooltip_runtime(self):
        s=(ROOT/'experiments/Forsaken/SpellCalculations.j').read_text();active=[False];viewer=[0]
        env=mocks(s);env.update(SpellCalcData='tips',SpellCalcHidden=defaultdict(bool),
            GetPlayerId=lambda p:p,GetLocalPlayer=lambda:viewer[0],GetHeroInt=lambda *a:90,
            BlzGetAbilityManaCost=lambda *a:100,Prof_StaffPower=lambda *a:2.,I2R=float,R2I=int,
            R2SW=lambda n,*a:format(n,'.0f'),PriestRegenDuration={1:12.},
            PriestRainHealing={1:50.,6:400.},PriestRainPeriod={1:.125,6:.125},
            LoadStr=lambda h,r,k:self.config[r][k if k<100 else k-100][0 if k<100 else 1],
            LoadInteger=lambda h,r,k:TALENTS.get(r,(0,0))[-k-1],
            Talent_Active=lambda *a:active[0],TalentName=defaultdict(lambda:'Acid Rain'),
            TalentText=defaultdict(lambda:'Converts half of healing to damage.'),Talent_Index=lambda *a:0)
        return execute(s,['SpellCalc_Tooltip'],env),active,viewer

    def test_original_description_kept_and_acid_rain_only_when_selected(self):
        e,active,viewer=self.tooltip_runtime();tip=e['SpellCalc_Tooltip']('hero','A0OM',6)
        self.assertIn('Channels a rain of healing energy',tip);self.assertIn('4000 HP per second',tip)
        self.assertIn(HMARK,tip);self.assertNotIn('Acid Rain',tip)
        active[0]=True;tip=e['SpellCalc_Tooltip']('hero','A0OM',6)
        self.assertIn('Talent: Acid Rain',tip);self.assertIn('magic damage/sec',tip)
        e['SpellCalcHidden'][0]=True;tip=e['SpellCalc_Tooltip']('hero','A0OM',6)
        self.assertNotIn(HMARK,tip);self.assertIn('Talent: Acid Rain',tip)
        self.assertNotIn('Current split',tip)

    def test_toggle_is_per_player_and_hides_healing_and_damage_calculations(self):
        e,active,viewer=self.tooltip_runtime();e['SpellCalcHidden'][0]=True
        for raw in ['A04O','A0Z3','A0Z4','A0QS','A00L']:
            tip=e['SpellCalc_Tooltip']('hero',raw,1)
            self.assertNotIn('calculations',tip);self.assertNotIn('Damage details',tip)
            viewer[0]=1;tip=e['SpellCalc_Tooltip']('hero',raw,1)
            self.assertTrue('calculations' in tip or 'Damage details' in tip)
            viewer[0]=0

    def test_current_caster_curaga_drain_osmose_and_rank_data(self):
        e,active,viewer=self.tooltip_runtime()
        for raw,number in [('A04O','2900'),('A0Z3','760'),('A0Z4','580')]:
            self.assertIn(number,e['SpellCalc_Tooltip']('hero',raw,1))
        self.assertIn('200',self.config['A0Z3'][1][1]);self.assertIn('400',self.config['A0Z3'][6][1])
        updated=objects(self.view.object_bytes('war3map.w3a'),self.config)
        indexed={o['id']:fields(o) for o in read_objects(updated,'w3a')['custom']}
        self.assertIn(HMARK,indexed['A04O']['aub1',1]);self.assertNotIn('Acid Rain',indexed['A0OM']['aub1',6])

    def test_long_tooltips_cache_only_fingerprints_and_skip_unchanged_writes(self):
        s=(ROOT/'experiments/Forsaken/SpellCalculations.j').read_text();memo={};writes=[];text=['x'*1100]
        env=mocks(s);env.update(Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,
            SpellCalcCount=1,SpellCalcRaw={0:'A0GZ'},GetUnitAbilityLevel=lambda *a:1,
            SpellCalc_Tooltip=lambda *a:text[0],SpellCalcLast='last',PriestTooltipOffset=0,
            HaveSavedInteger=lambda h,p,c:(p,c) in memo,LoadInteger=lambda h,p,c:memo.get((p,c),0),
            SaveInteger=lambda h,p,c,v:memo.__setitem__((p,c),v),StringHash=lambda s:sum(map(ord,s)),StringLength=len,
            BlzSetAbilityExtendedTooltip=lambda *a:writes.append(a))
        e=execute(s,['SpellCalc_Update'],env);e['SpellCalc_Update']();e['SpellCalc_Update']()
        self.assertEqual(len(writes),1);self.assertTrue(all(type(v) is int for v in memo.values()))
        text[0]='y'*1100;e['SpellCalc_Update']();self.assertEqual(len(writes),2)

    def test_legend_validation_rejects_bad_flags_duplicates_and_bounds(self):
        s=source('ForsakenSaveCodec')
        for values,wanted in [([2,1,1,38,1],True),([1,39,1],False),([1,1,2],False),([2,1,1,1,1],False),([39],False)]:
            queue=list(values);seen=set();ok=defaultdict(lambda:True)
            env=mocks(s);env.update(FSC_Ok=ok,FSC_Seen='seen',FSC_Read=lambda ctx:queue.pop(0) if queue else 0,
                FlushChildHashtable=lambda *a:seen.clear(),FSC_Mark=lambda c,p,i:False if i in seen else (seen.add(i) or True))
            e=execute(s,['FSC_LegendProgress'],env);e['FSC_LegendProgress'](1)
            self.assertEqual(ok[1],wanted)

    def test_bounded_codec_roundtrips_old_profile_with_optional_progress(self):
        import json
        sys.path.insert(0,str(ROOT/'experiments/Forsaken'))
        from test_save_jass import engine
        import save_vnext as codec
        old=json.loads((ROOT/'experiments/Forsaken/migration-fixtures.json').read_text())['cases'][0]['code']
        original=codec.decode(old);e=engine(bounded=True)
        self.assertTrue(e['FSC_Decode'](0,old,original.account_hash,True))
        self.assertTrue(e['FSC_Begin'](0,original.account_hash))
        for section in original.sections:
            self.assertTrue(e['FSC_Add'](0,section.id,section.version,section.required,section.payload))
        progress=codec.pairs([(3,1),(24,1),(29,1),(38,1)])
        self.assertTrue(e['FSC_Add'](0,11,1,False,progress))
        encoded=e['FSC_Finish'](0,True);self.assertIsNotNone(encoded)
        self.assertTrue(e['FSC_Decode'](1,encoded,original.account_hash,True))
        self.assertEqual(e['FSC_Reencode'](1),encoded)
        decoded=codec.decode(encoded);self.assertEqual(next(s.payload for s in decoded.sections if s.id==11),progress)

    def test_legend_capture_and_transaction_restore_all_durable_steps(self):
        s=source('ForsakenFreshLoad');membership={(0,'job2'),(0,'weak1'),(0,'weak6'),(0,'null2'),(0,'summon2')};before={};saved={3:1,24:1,29:1,31:1,38:1}
        env=mocks(s);env.update(Player=lambda p:p,udg_JobMasterForce={i:'job'+str(i) for i in range(23)},
            udg_WeakElementForce={i:'weak'+str(i) for i in range(1,7)},udg_NullElementForce={i:'null'+str(i) for i in range(1,7)},
            udg_EidolonAwardForce={i:'summon'+str(i) for i in range(3)},FFL_Before='before',
            IsPlayerInForce=lambda p,f:(p,f) in membership,SaveBoolean=lambda h,p,c,v:before.__setitem__((p,c),v),
            LoadBoolean=lambda h,p,c:before.get((p,c),False),FFL_Val=lambda p,s,i:saved.get(i,0),
            FFL_Membership=lambda p,f,v:membership.add((p,f)) if v else membership.discard((p,f)),
            udg_WeakElementCount=defaultdict(int),udg_NullElementCount=defaultdict(int))
        e=execute(s,['FFL_LegendFlags'],env);original=set(membership)
        self.assertTrue(e['FFL_LegendFlags'](0,True,False));membership.clear()
        self.assertTrue(e['FFL_LegendFlags'](0,False,False));self.assertEqual(membership,original)
        self.assertEqual(e['udg_WeakElementCount'][0],2);self.assertEqual(e['udg_NullElementCount'][0],1)
        membership.add((0,'job9'));e['FFL_LegendFlags'](0,False,True);self.assertEqual(membership,original)
        self.assertNotIn((1,'job2'),membership)

    def test_all_job_tasks_and_old_new_profile_routes(self):
        data=legend_data(self.view);self.assertEqual(set(data),set(range(23)))
        self.assertIn('60 times',data[2]);self.assertIn('Cure',data[12])
        generated=commands(source('Legendary'),data)
        self.assertIn('LegendElementName[3]="Thunder"',generated);self.assertIn('LegendElementName[4]="Water"',generated)
        for name in ['ForsakenSaveCapture','ForsakenSaveCodec','ForsakenSaveFreshPlan','ForsakenFreshLoad']:
            s=source(name);self.assertEqual(refresh(s),s,name)
        fs=functions(source('ForsakenSaveFreshPlan'))
        self.assertIn('FSC_Count[ctx]==8',fs['FFP_Build']);self.assertIn('sid==11',fs['FFP_ReadSection'])
        capture=functions(source('ForsakenSaveCapture'))
        self.assertIn('position < 66',capture['FRC_Step']);self.assertIn('FSC_Add(pid,11,1,false',capture['FRC_Step'])
        for name in ['Legendary','Bazaar']:
            s=commands(source(name),data);self.assertEqual(commands(s,data),s)

    def test_legendary_level_gate_and_green_partial_job_steps(self):
        s=source('Legendary');level=[98];lines=[]
        env=mocks(s);env.update(GetTriggerPlayer=lambda:0,GetEventPlayerChatString=lambda:'-legendary',
            Player_GetHero=lambda p:'wizard',Job_GetIndex=lambda u:11,GetHeroLevel=lambda u:level[0],
            GetUnitAbilityLevel=lambda *a:3,udg_JobName={11:'Wizard'},LegendTaskText={11:'Hit all six elements.'},
            LegendElementName={i:'Element'+str(i) for i in range(1,7)},
            udg_JobMasterForce={11:'job'},udg_WeakElementForce={i:'weak'+str(i) for i in range(1,7)},
            IsPlayerInForce=lambda p,f:f=='weak2',DisplayTimedTextToPlayer=lambda *a:lines.append(a[-1]))
        e=execute(s,['Legend_Line','Legend_Command'],env);e['Legend_Command']()
        self.assertEqual(len(lines),1);self.assertIn('level 99',lines[0])
        lines.clear();level[0]=99;e['Legend_Command']()
        self.assertIn('|cff00ff00[Done] Element2|r',lines)
        self.assertIn('|cffffffff[ ] Element1|r',lines)

    def test_bazaar_reveal_only_changes_requesters_display(self):
        s=source('Bazaar');local=[0];messages=[];flags=defaultdict(bool)
        env=mocks(s);env.update(GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:local[0],GetPlayerId=lambda p:p,
            BazaarReveal=flags,BazaarRewardRevealed=defaultdict(bool),BazaarBrowserOpen=defaultdict(bool),
            DisplayTimedTextToPlayer=lambda *a:messages.append(a[-1]),udg_BazaarRecipeHash='recipes',
            LoadInteger=lambda h,p,c:{1:0,2:1,4:1}.get(c,0),udg_BazaarResultItem={1:'sword'},GetObjectName=lambda r:r)
        e=execute(s,['Bazaar_RevealCommand','Bazaar_RewardName'],env)
        self.assertEqual(e['Bazaar_RewardName'](1),'???');e['Bazaar_RevealCommand']()
        self.assertEqual(e['Bazaar_RewardName'](1),'sword');self.assertFalse(e['BazaarRewardRevealed'][1])
        local[0]=1;self.assertEqual(e['Bazaar_RewardName'](1),'???')


if __name__=='__main__':unittest.main()

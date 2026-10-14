"""DW display restoration, real Priest picks and both house-portal object fields."""
from collections import defaultdict
from pathlib import Path
from unittest.mock import patch
import tempfile
import unittest
import sys
import build_dw_update as build
sys.path.insert(0,str(build.ROOT/'tools/tests'))
import test_quest_lifecycle as harness
from mpq import MPQ
from objdata import read_objects

class DWUpdateTests(unittest.TestCase):
    def test_reset_purchase_never_changes_job_and_removes_only_sold_token(self):
        from wct import read_wct
        base=build.ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDW.w3x'
        entries=read_wct(MPQ(str(base)).read('war3map.wct'))['entries']
        job=build.patch_job(next(e.decode() for e in entries if e.startswith(b'library TJob ')))
        sold=['nTRt'];removed=[];picks=defaultdict(int,{48:1})
        env=dict(Trig_Job_Change_IsJobShrine=lambda:True,GetSoldUnit=lambda:sold[0],
            GetUnitTypeId=lambda u:u,GetOwningPlayer=lambda u:0,Player_GetHero=lambda p:'priest',
            Job_GetIndex=lambda h:12,RemoveUnit=lambda u:removed.append(u),GetPlayerId=lambda p:p,
            TALENT_RESET_UNIT='nTRt',TALENT_ROWS=4,udg_JobCount=22,udg_JobName={12:'Priest'},
            TalentPick=picks,Talent_PickIndex=lambda p,j,r:p*100+j*4+r-1,
            DisplayTimedTextToPlayer=lambda *args:None)
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(job+'\n'+build.priest_source(),
                ['Trig_Job_Change_Conditions','Talents_ResetSold','Talent_ResetJob'],env)
        self.assertFalse(e['Trig_Job_Change_Conditions']())
        e['Talents_ResetSold']()
        self.assertEqual(removed,['nTRt']);self.assertEqual(picks[48],0)
        for token in ('n00W','n07I','n0KL'):
            sold[0]=token;self.assertFalse(e['Trig_Job_Change_Conditions']())
        sold[0]='H02L';self.assertTrue(e['Trig_Job_Change_Conditions']())

    def test_priest_points_at_each_milestone_and_after_reset(self):
        rank=[1];picks=defaultdict(int)
        source=build.patch_equip('library TEquip requires TJob\n'+(build.HERE/'Forsaken-panels.j').read_text())+'\n'+build.priest_source()
        env=dict(TALENT_ROWS=4,TALENT_JOB_PRIEST=12,udg_JobCount=22,IMinBJ=min,IMaxBJ=max,
            GetUnitAbilityLevel=lambda u,a:rank[0],TalentPick=picks,GetPlayerId=lambda p:p,
            Talent_PickIndex=lambda p,j,r:p*100+j*4+r-1,Player_GetHero=lambda p:'hero',Job_GetIndex=lambda h:12)
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(source,['Talent_Rank','Forsaken_PriestPoints','Talent_ResetJob'],env)
        # Mastery ranks 1..4 represent level 1, 50, 99 and legendary 100.
        for milestone,r in ((1,1),(50,2),(99,3),(100,4)):
            rank[0]=r
            self.assertEqual(e['Talent_Rank']('hero'),r,msg=str(milestone))
            self.assertEqual(e['Forsaken_PriestPoints'](0,r),r)
            picks[48]=2
            self.assertEqual(e['Forsaken_PriestPoints'](0,r),r-1)
            self.assertTrue(e['Talent_ResetJob'](0))
            self.assertEqual(e['Forsaken_PriestPoints'](0,r),r)

    def test_forsaken_dialog_mode_can_still_convert_without_frames(self):
        from bazaar_legacy import convert_talents
        text=convert_talents(build.priest_source())
        self.assertIn('constant boolean TalentUseFrames=false',text)
        self.assertNotRegex(text,r'\bframehandle|FRAMEEVENT|FRAMEPOINT|\bBlz')

    def test_loaded_titles_restore_categories_without_regranting_rewards(self):
        writes={};secrets=[];forces=defaultdict(set,{10:{0},32:{0},59:{1}})
        categories=defaultdict(int,{10:1,32:5,59:12})
        env=dict(Player=lambda p:p,udg_SpiritOfGaya={1:'gaya0',2:'gaya1'},
            udg_TitleForce=forces,udg_TitleChronicleIndex=categories,
            udg_ChronicleAbility={i:'cat'+str(i) for i in range(1,13)},
            GetUnitAbilityLevel=lambda u,a:3 if u=='gaya0' and a=='cat11' else 1,
            IsPlayerInForce=lambda p,f:p in f,SetPlayerAbilityAvailable=lambda p,a,b:writes.__setitem__((p,a),b),
            Chronicles_RestoreSecrets=lambda p:secrets.append(p))
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine((build.HERE/'Forsaken-fresh-load.j').read_text(),['FFL_RestoreChronicles'],env)
        for pid in (0,1):e['FFL_RestoreChronicles'](pid)
        self.assertTrue(writes[0,'A0AR']);self.assertTrue(writes[0,'cat1']);self.assertTrue(writes[0,'cat5'])
        self.assertTrue(writes[0,'cat11']);self.assertFalse(writes[0,'cat12'])
        self.assertTrue(writes[1,'cat12']);self.assertFalse(writes[1,'cat1'])
        self.assertEqual(secrets,[0,1])

    def test_priest_sync_chooses_real_talent_rejects_duplicates_and_empty_rows(self):
        panels=build.patch_equip('library TEquip requires TJob\n'+(build.HERE/'Forsaken-panels.j').read_text())
        packet=[1200];state={};picks=defaultdict(int);names=defaultdict(str)
        env=dict(GetTriggerPlayer=lambda:0,Player_GetHero=lambda p:'hero',Job_GetIndex=lambda u:12,
            S2I=int,BlzGetTriggerSyncData=lambda:str(packet[0]),GetPlayerId=lambda p:p,ModuloInteger=lambda a,b:a%b,
            TALENT_JOB_PRIEST=12,TALENT_ROWS=4,udg_JobCount=22,IMinBJ=min,IMaxBJ=max,GetUnitAbilityLevel=lambda u,a:1,
            ForsakenTalentState=state,LoadBoolean=lambda h,k,n:h.get((k,n),False),
            SaveBoolean=lambda h,k,n,v:h.__setitem__((k,n),v),SaveInteger=lambda h,k,n,v:h.__setitem__((k,n),v),
            LoadInteger=lambda h,k,n:h.get((k,n),0),TalentPick=picks,TalentName=names,
            Talent_Index=lambda job,row,choice:job*12+(row-1)*3+choice-1,
            Talent_PickIndex=lambda pid,job,row:pid*100+job*4+row-1,
            Talent_JobHasTalents=lambda job:job==12,Talent_Rank=lambda hero:1,
            DisplayTimedTextToPlayer=lambda *a:None)
        for i,n in enumerate(('Deprotect','Deshell','Blinding Light')):names[12*12+i]=n
        source=panels+'\n'+build.priest_source()
        chosen=['Forsaken_TalentCanPurchase','Forsaken_TalentRank','Forsaken_TalentSync','Talent_Choose','Talent_ResetJob']
        with patch.object(harness,'SELECTED',[]):e=harness.load_engine(source,chosen,env)
        e['Forsaken_TalentSync']();self.assertEqual(picks[48],1)
        packet[0]=1201;e['Forsaken_TalentSync']();self.assertEqual(picks[48],1)
        self.assertFalse(e['Forsaken_TalentCanPurchase'](12,3,4))
        self.assertTrue(e['Talent_ResetJob'](0));e['Forsaken_TalentSync']();self.assertEqual(picks[48],2)

    def test_both_portals_keep_cost_cooldown_and_use_three_seconds(self):
        base=build.ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenDW.w3x'
        with tempfile.TemporaryDirectory(dir=build.ROOT/'build') as folder:
            output=build.prepare_objects(base,Path(folder)/'objects.w3x')
            archive=MPQ(str(output))
            table=read_objects(archive.read('war3map.w3a'),'w3a')
            skin=read_objects(archive.read('war3mapSkin.w3a'),'w3a')
            objs={o['id']:o for o in table['custom']};skins={o['id']:o for o in skin['custom']}
            for raw,field,cooldown in [('A0P3','Hmt2',15.),('A04J','acas',90.)]:
                mods=objs[raw]['sets'][0]['mods']
                self.assertEqual(next(m['value'] for m in mods if m['field']==field and m['level']==1),3.)
                self.assertEqual(next(m['value'] for m in mods if m['field']=='acdn'),cooldown)
                text=next(m['value'] for m in skins[raw]['sets'][0]['mods'] if m['field']=='aub1')
                self.assertIn('3 seconds',text);self.assertNotIn('6 seconds',text)
            self.assertEqual(objs['A00M']['base'],'ANcl')
            self.assertTrue(all(raw in objs for raw in ('tDpr','tDsh','tBln','tBl5')))
            for member in ('war3map.w3u','war3mapSkin.w3u'):
                units=read_objects(archive.read(member),'w3u')
                for obj in units['custom']:
                    if obj['id'] in ('nTRt','n0KL'):
                        fields={m['field']:m['value'] for m in obj['sets'][0]['mods']}
                        self.assertEqual((fields['ubpx'],fields['ubpy']),(0 if obj['id']=='nTRt' else 3,2))

if __name__=='__main__':unittest.main()

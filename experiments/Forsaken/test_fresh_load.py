"""Execute the complete fresh loader with modeled natives; real engine test is CU."""
import unittest
from pathlib import Path
import test_save_fresh_objects
from test_save_jass import engine, JassArray
from test_save_life import Real32
from build_save_probe import capture_source, fresh_plan_source
import json
HERE=Path(__file__).resolve().parent

class FreshLoadTests(unittest.TestCase):
    def setUp(self):
        self.f=test_save_fresh_objects.FreshObjectsTests();self.f.setUp();f=self.f;env=dict(f.e)
        create=env['CreateUnit'];make=env['CreateItem'];remove=env['RemoveItem']
        def unit(*args):
            u=create(*args)
            if u is not None:u.update(level=1,abilities={'A02F':1,'A0B4':1,'A02K':1,'A02L':1,'A10F':1,'S009':1,'A10U':1},points=1,str=5,agi=5,intel=5)
            return u
        def item(*args):
            i=make(*args)
            if i is not None:i['abilities']=['A0MU','fGmk'] if i['raw']=='f003' else []
            return i
        def remove_item(i):
            remove(i)
            if i['raw']==0:
                for u in (f.base.house,f.base.hero,f.base.gaya):
                    for kind in ('quick','bag','equipment'):
                        for k,v in list(u.get(kind,{}).items()):
                            if v is i:del u[kind][k]
        def add(u,i):
            if self.fail_place:return False
            for kind,count in [('quick',6),('bag',30)]:
                for slot in range(count):
                    if slot not in u.setdefault(kind,{}):u[kind][slot]=i;return True
            return False
        def detach(u,i):
            for kind in ('quick','equipment','bag'):
                for slot,v in list(u[kind].items()):
                    if v is i:del u[kind][slot]
        def equip(u,i):
            for slot,v in list(u['quick'].items()):
                if v is i:del u['quick'][slot]
            u['equipment'][3]=i;return True
        def setlevel(u,level,show):u['level']=level;u['points']=level
        def learn(u,raw):
            if u['points']>0:u['abilities'][raw]=u['abilities'].get(raw,0)+1;u['points']-=1
        def setability(u,raw,level):
            if raw in u['abilities'] or raw.startswith('chron'):u['abilities'][raw]=level
            return level
        self.fail_place=False;self.messages=[];self.currency={1:123456,2:42}
        skills=JassArray(lambda:None)
        for i in range(1,111):skills[i]='skill'+str(i)
        env.update(GetHandleId=lambda h:id(h)%2147483647,CreateUnit=unit,CreateItem=item,RemoveItem=remove_item,UnitAddItem=add,UnitEquipItem=equip,UnitUnequipItem=detach,UnitRemoveItem=detach,IsItemOwned=lambda i:any(v is i for u in self.f.units for kind in ('quick','bag','equipment') for v in u[kind].values()),ForsakenGearTypes={(4,'f003'):'I00B',(1,'I00B'):3},
            SaveUnitHandle=lambda t,a,b,v:t.__setitem__((a,b),v),RemoveSavedHandle=lambda t,a,b:t.pop((a,b),None),
            SetPlayerTechResearched=lambda p,r,v:f.base.fixture.techs.__setitem__((p,r),v),
            ForceAddPlayer=lambda force,p:force.add(p),ForceRemovePlayer=lambda force,p:force.discard(p),
            SetPlayerState=lambda p,k,v:self.currency.__setitem__(k,v),GetPlayerState=lambda p,k:self.currency[k],
            SetHeroLevel=setlevel,SelectHeroSkill=learn,SetUnitAbilityLevel=setability,
            GetHeroStr=lambda u,b:u['str'],GetHeroAgi=lambda u,b:u['agi'],GetHeroInt=lambda u,b:u['intel'],
            SetHeroStr=lambda u,v,b:u.__setitem__('str',v),SetHeroAgi=lambda u,v,b:u.__setitem__('agi',v),SetHeroInt=lambda u,v,b:u.__setitem__('intel',v),
            UnitAddAbility=lambda u,r:u['abilities'].__setitem__(r,1),UnitRemoveAbility=lambda u,r:u['abilities'].pop(r,None),
            BlzGetItemAbilityByIndex=lambda i,n:i['abilities'][n] if n<len(i['abilities']) and any(v is i for u in self.f.units for kind in (('equipment',) if i['raw']=='f003' else ('quick','equipment')) for v in u[kind].values()) else None,
            BlzGetAbilityId=lambda a:a,BlzGetItemAbility=lambda i,r:r if r in i['abilities'] else None,
            BlzItemRemoveAbility=lambda i,r:i['abilities'].remove(r),
            udg_BrewAbility=JassArray(lambda:0),udg_JobSkill=skills,udg_ChronicleAbility=JassArray(lambda:'chron'),udg_TitleChronicleIndex=JassArray(lambda:0),udg_TitleChroniclePoints=JassArray(lambda:0),
            udg_ArmoryItemCount=JassArray(lambda:0),ArmoryMissingUnit=JassArray(lambda:0),
            ForsakenBagPassiveTypes={(0,'A0MU'):True},ForsakenBagAbilities={},
            Pow=lambda a,b:Real32(float(a)**float(b)),TimerGetElapsed=lambda t:Real32(1),
            DisplayTimedTextToPlayer=lambda p,x,y,d,m:self.messages.append(m),R2S=str,
            ShowUnit=lambda *a:None,SetPlayerAbilityAvailable=lambda *a:None,SetUnitInvulnerable=lambda *a:None)
        catalog=json.loads((HERE.parents[1]/'release/Forsaken/gear-slots-BS.json').read_text())
        source=(HERE/'Forsaken-save-life.j').read_text()+'\n'+capture_source(f.base.fixture.aliases)+'\n'+fresh_plan_source(f.base.fixture.registry,catalog)+'\n'+(HERE/'Forsaken-save-fresh-objects.j').read_text()+'\n'+(HERE/'Forsaken-save-transport.j').read_text()+'\n'+(HERE/'Forsaken-fresh-load.j').read_text()
        self.e=engine(source,env);self.e['FFP_Init']();self.e['FRC_Init']();self.e['FFL_Before']={}
        for alias,identity in f.base.fixture.aliases.items():self.e['FRC_Map'][(0,alias)]=identity
        self.e['FST_Result'][0]=f.base.encoded
    def apply(self):
        self.assertTrue(self.e['FFP_Build'](0,self.f.base.encoded,True),self.e['FFP_Error'][0])
        return self.e['FFL_Apply'](0)
    def finish(self):
        self.f.base.fixture.elapsed=self.e['FRC_Timer'][0]
        for _ in range(150):
            if self.e['FRC_Phase'][0]==0:break
            self.e['FRC_Tick']()
    def test_gaya_rank_three_uses_single_level_purchase_research(self):
        from test_save_capture import raw
        original=self.e['SetPlayerTechResearched']
        import save_vnext as codec
        envelope=codec.decode(self.f.base.encoded)
        sections=[codec.Section(section.id,section.version,section.required,
            codec.pairs([(i,3 if 3<=i<=5 else v) for i,v in codec.read_pairs(section.payload)]))
            if section.id==5 else section for section in envelope.sections]
        self.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,sections))
        self.e['FST_Result'][0]=self.f.base.encoded
        purchases={raw('Resi'),raw('R00F'),raw('R00G')}
        writes=[]
        def capped(owner, research, value):
            writes.append((research,value))
            original(owner,research,min(value,1) if research in purchases else value)
        self.e['SetPlayerTechResearched']=capped
        self.assertTrue(self.apply(),self.messages)
        for index, research in enumerate(('Resi','R00F','R00G'),start=3):
            rank=self.e['FFL_Val'](0,5,index)
            self.assertIn((raw(research),int(rank>0)),writes)
            self.assertEqual(self.e['GetPlayerTechCount'](0,raw(research),True),int(rank>0))
        self.assertEqual(self.e['FFN_Unit'][1]['abilities']['A0B4'],3)
        self.finish()
        self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0],self.messages)

    def test_failed_skill_reports_job_rank_and_allows_retry(self):
        self.e['SelectHeroSkill']=lambda hero, raw: None
        self.assertFalse(self.apply())
        self.assertIn('job 11 skill 1 wanted=11 actual=0',self.messages[-1])
        self.assertIn('load unused; retry allowed',self.messages[-1])
        self.assertEqual(self.e['FFL_Phase'][0],0)

    def test_failed_research_reports_exact_readback_before_restore(self):
        original=self.e['SetPlayerTechResearched']
        def research(owner, raw, value):
            original(owner,raw,0)
        self.e['SetPlayerTechResearched']=research
        self.assertFalse(self.apply())
        self.assertIn('research ',self.messages[-1])
        self.assertIn('wanted=',self.messages[-1])
        self.assertIn('actual=',self.messages[-1])

    def test_complete_readback_commit_and_one_load(self):
        self.assertTrue(self.apply(),self.messages);self.finish()
        self.assertTrue(self.e['FRC_Ready'][0],self.e['FRC_Error'][0])
        self.assertEqual(self.e['FRC_Result'][0],self.f.base.encoded)
        self.e['FFL_Tick']();self.assertTrue(self.e['udg_HasLoadedCode'][0]);self.assertEqual(self.e['FFL_Phase'][0],0)
        self.assertFalse(self.e['FFP_Build'](0,self.f.base.encoded,True))
        hero=self.e['udg_PlayerHero'][1]
        self.assertEqual([hero['abilities']['skill'+str(50+i)] for i in range(1,6)],[11,11,11,11,6])
        self.assertEqual(hero['bag'][29]['abilities'],['fGmk'])
    def test_meta_fragments_survive_fresh_load_above_legacy_limit(self):
        import save_vnext as codec
        envelope=codec.decode(self.f.base.encoded)
        sections=[codec.Section(s.id,s.version,s.required,codec.pairs([(identity,8 if identity==7 else value) for identity,value in codec.read_pairs(s.payload)])) if s.id==4 else s for s in envelope.sections]
        self.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,sections))
        self.assertTrue(self.apply(),self.messages);self.finish()
        self.assertEqual(self.e['udg_MetaFragments'][1],7)
        self.assertTrue(self.e['FRC_Ready'][0],self.e['FRC_Error'][0])
        self.assertEqual(self.e['FRC_Result'][0],self.f.base.encoded)
        self.e['FFL_Tick']();self.assertTrue(self.e['udg_HasLoadedCode'][0])

    def test_inferno_export_tier_survives_complete_fresh_load(self):
        import save_vnext as codec
        envelope = codec.decode(self.f.base.encoded)
        sections = tuple(codec.Section(section.id, section.version, section.required,
            codec.pairs([(i, 3 if i == 1 else v) for i, v in codec.read_pairs(section.payload)]))
            if section.id == 4 else section for section in envelope.sections)
        self.f.base.encoded = codec.encode(codec.Envelope(envelope.account_hash, sections))
        self.e['udg_Difficulty'] = 5
        self.assertTrue(self.apply(), self.messages)
        self.finish()
        self.assertEqual(self.e['FRC_Result'][0], self.f.base.encoded)
        self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0])
        self.assertEqual(self.e['udg_CodeDifficulty'][1], 3)

    def test_failed_placement_restores_state_and_can_retry(self):
        before=dict(self.f.base.fixture.level_table);techs=dict(self.f.base.fixture.techs)
        self.fail_place=True;self.assertFalse(self.apply());self.assertEqual(self.e['FFL_Phase'][0],0)
        self.assertFalse(self.e['udg_HasLoadedCode'][0]);self.assertIs(self.e['udg_PlayerHero'][1],self.f.base.hero)
        self.assertEqual(before,{k:v for k,v in self.f.base.fixture.level_table.items() if v});self.assertEqual(techs,{k:v for k,v in self.f.base.fixture.techs.items() if v})
        self.assertEqual(self.f.base.house['quick'],{});self.assertTrue(all(i['raw']==0 for i in self.f.items))
        self.fail_place=False;self.assertTrue(self.apply())
    def test_failed_cleanup_keeps_journal_until_retry(self):
        self.fail_place=True;self.f.block_item_removal=True;self.assertFalse(self.apply())
        self.assertEqual(self.e['FFL_Phase'][0],4);self.assertTrue(self.e['FFP_Locked'][0])
        self.assertFalse(self.e['FFP_Build'](0,self.f.base.encoded,True))
        self.f.block_item_removal=False;self.assertTrue(self.e['FFL_Restore'](0));self.assertFalse(self.e['udg_HasLoadedCode'][0])
    def test_below_mastery_resets_skills_and_refunds_points(self):
        self.assertTrue(self.e['FFP_Build'](0,self.f.base.encoded,True));self.assertTrue(self.e['FFN_Allocate'](0,True))
        hero=self.e['FFN_Unit'][0];self.assertTrue(self.e['FFL_PrepareHero'](0,hero,11,25,0))
        self.assertEqual(hero['points'],25);self.assertTrue(all(hero['abilities'].get('skill'+str(50+i),0)==0 for i in range(1,6)))
    def test_full_quick_and_bag_load_equipment_first(self):
        import save_vnext as codec
        import save_progression as progression
        envelope=codec.decode(self.f.base.encoded)
        records=list(progression.snapshot(envelope)['inventory'])
        template=records[0]
        for ordinal in range(2,36):
            kind,slot=(1,ordinal-1) if ordinal<=6 else (2,ordinal-7)
            records.append((ordinal,template[1],kind,slot,1,False,template[6]))
        records.sort(key=lambda r:r[0])
        sections=tuple(codec.Section(section.id,section.version,section.required,codec.inventory(records)) if section.id==1 else section for section in envelope.sections)
        self.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,sections))
        self.assertTrue(self.apply(),self.messages);self.finish()
        self.assertTrue(self.e['FRC_Ready'][0],self.e['FRC_Error'][0]);self.assertEqual(self.e['FRC_Result'][0],self.f.base.encoded)
        hero=self.e['udg_PlayerHero'][1];self.assertEqual(len(hero['quick']),6);self.assertEqual(len(hero['bag']),30);self.assertEqual(len(hero['equipment']),1)
    def test_failed_spacer_removal_keeps_attempt_tracking(self):
        remove=self.e['RemoveItem']
        self.e['RemoveItem']=lambda item:None if item['raw']=='fGap' else remove(item)
        self.assertFalse(self.apply());self.assertEqual(self.e['FFL_Phase'][0],4)
        self.assertGreater(self.e['FFN_SpacerCount'][0],0);self.assertTrue(self.e['FFP_Locked'][0])
        self.assertFalse(self.e['udg_HasLoadedCode'][0]);self.assertIs(self.e['udg_PlayerHero'][1],self.f.base.hero)
        self.e['RemoveItem']=remove;self.assertTrue(self.e['FFL_Restore'](0))
        self.assertEqual(self.e['FFN_SpacerCount'][0],0);self.assertFalse(self.e['FFP_Locked'][0])
if __name__=='__main__':unittest.main()

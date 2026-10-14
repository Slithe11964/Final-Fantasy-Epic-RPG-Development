"""Execute the complete fresh loader with modeled natives; real engine test is CU."""
import unittest
import re
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
            if i['raw']=='f003' and not u['abilities'].get('fGer'):return False
            for kind,count in [('quick',6),('bag',30)]:
                for slot in range(count):
                    if slot not in u.setdefault(kind,{}):u[kind][slot]=i;return True
            return False
        def detach(u,i):
            for kind in ('quick','equipment','bag'):
                for slot,v in list(u[kind].items()):
                    if v is i:del u[kind][slot]
        def equip(u,i):
            detach(u,i)
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
        env.update(Chronicles_RestoreSecrets=lambda p:None,ForsakenSaveBlocked=False,udg_SaveCommandTrig=None,udg_SaveToFileTrig=None,udg_HardcoreOff=True,GetHandleId=lambda h:id(h)%2147483647,CreateUnit=unit,CreateItem=item,RemoveItem=remove_item,UnitAddItem=add,UnitEquipItem=equip,UnitUnequipItem=detach,UnitRemoveItem=detach,IsItemOwned=lambda i:any(v is i for u in self.f.units for kind in ('quick','bag','equipment') for v in u[kind].values()),ForsakenGearTypes={(4,'f003'):'I00B',(1,'I00B'):3},
            SaveUnitHandle=lambda t,a,b,v:t.__setitem__((a,b),v),RemoveSavedHandle=lambda t,a,b:t.pop((a,b),None),
            SetPlayerTechResearched=lambda p,r,v:f.base.fixture.techs.__setitem__((p,r),v),
            ForceAddPlayer=lambda force,p:force.add(p),ForceRemovePlayer=lambda force,p:force.discard(p),
            SetPlayerState=lambda p,k,v:self.currency.__setitem__(k,v),GetPlayerState=lambda p,k:self.currency[k],
            SetHeroLevel=setlevel,SelectHeroSkill=learn,SetUnitAbilityLevel=setability,
            GetHeroStr=lambda u,b:u['str'],GetHeroAgi=lambda u,b:u['agi'],GetHeroInt=lambda u,b:u['intel'],
            SetHeroStr=lambda u,v,b:u.__setitem__('str',v),SetHeroAgi=lambda u,v,b:u.__setitem__('agi',v),SetHeroInt=lambda u,v,b:u.__setitem__('intel',v),
            UnitMakeAbilityPermanent=lambda *args:None,UnitInventorySize=lambda u:6,
            UnitExtendedInventorySize=lambda u:30 if 'abilities' not in u or u['abilities'].get('fBag') else 0,
            UnitAddAbility=lambda u,r:u['abilities'].__setitem__(r,1),UnitRemoveAbility=lambda u,r:u['abilities'].pop(r,None),
            BlzGetItemAbilityByIndex=lambda i,n:i['abilities'][n] if n<len(i['abilities']) and any(v is i for u in self.f.units for kind in (('equipment',) if i['raw']=='f003' else ('quick','equipment')) for v in u[kind].values()) else None,
            BlzGetAbilityId=lambda a:a,BlzGetItemAbility=lambda i,r:r if r in i['abilities'] else None,
            BlzItemRemoveAbility=lambda i,r:i['abilities'].remove(r),
            udg_BrewAbility=JassArray(lambda:0),udg_JobSkill=skills,udg_ChronicleAbility=JassArray(lambda:'chron'),udg_TitleChronicleIndex=JassArray(lambda:0),udg_TitleChroniclePoints=JassArray(lambda:0),
            udg_ArmoryItemCount=JassArray(lambda:0),ArmoryMissingUnit=JassArray(lambda:0),
            ForsakenBagPassiveTypes={(0,'A0MU'):True},ForsakenBagAbilities={},
            Pow=lambda a,b:Real32(float(a)**float(b)),TimerGetElapsed=lambda t:Real32(1),
            DisplayTimedTextToPlayer=lambda p,x,y,d,m:self.messages.append(m),R2S=str,
            GetLocalPlayer=lambda:0,ClearTextMessages=lambda:None,PLAYER_NEUTRAL_PASSIVE=15,SetUnitOwner=lambda u,p,c:u.__setitem__('owner',p),
            ShowUnit=lambda u,visible:u.__setitem__('visible',visible),SetPlayerAbilityAvailable=lambda *a:None,SetUnitInvulnerable=lambda *a:None,
            udg_JobCount=22,Job_GetSavedLevel=lambda p,raw:env['udg_JobLevelHash'].get((raw,p),0),PLAYER_STATE_RESOURCE_FOOD_USED='food',
            gg_trg_Title_UnlockEffects='effects',gg_trg_JobLevels_Init='joblevels',udg_JobLevelTimer='jobtimer',
            udg_TempPlayer=None,udg_TempInteger=0,EnableTrigger=lambda t:None,StartTimerBJ=lambda *a:None,ConditionalTriggerExecute=lambda t:None,
            CreateTrigger=lambda:{'conditions':[]},Condition=lambda fn:fn,TriggerAddCondition=lambda tr,c:tr['conditions'].append(c),
            TriggerEvaluate=lambda tr:[c() for c in tr['conditions']],SelectUnitForPlayerSingle=lambda u,p:None,
            CreateGroup=lambda:[],DestroyGroup=lambda g:None,
            GroupEnumUnitsOfPlayer=lambda g,p,f:g.extend([u for u in self.f.units if u.get('owner')==p]),
            FirstOfGroup=lambda g:g[0] if g else None,GroupRemoveUnit=lambda g,u:g.remove(u),
            IsUnitType=lambda u,kind:u.get('hero',True) if kind=='hero' else False,
            IsUnitHidden=lambda u:not u.get('visible',True),UNIT_TYPE_HERO='hero')
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
    def test_gaya_and_house_gear_use_carryable_original_and_roundtrip(self):
        import save_vnext as codec
        import save_progression as progression
        from build_save_probe import fresh_plan_bindings
        catalog=json.loads((HERE.parents[1]/'release/Forsaken/gear-slots-BS.json').read_text())
        rows=fresh_plan_bindings(self.f.base.fixture.registry,catalog)
        offhand=next(record for record in self.f.base.fixture.registry['items']
            if catalog.get(record['rawcode'],{}).get('variant')=='f202')
        canonical=offhand['rawcode'];identity=offhand['id']
        self.assertIn((4,identity,canonical),rows)
        self.assertIn((5,identity,canonical),rows)
        envelope=codec.decode(self.f.base.encoded)
        records=list(progression.snapshot(envelope)['inventory']);template=records[0]
        records=[record for record in records if record[2] not in (4,5)]
        records.extend([(46,identity,4,0,0,True,template[6]),
                        (52,identity,5,0,0,True,template[6])])
        sections=[codec.Section(section.id,section.version,section.required,codec.inventory(sorted(records)))
            if section.id==1 else section for section in envelope.sections]
        self.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,sections))
        original=self.e['UnitAddItem']
        def add(holder,carried):
            if holder is self.f.base.house or holder is self.e['FFN_Unit'][1]:
                if carried['raw']=='f202':return False
            return original(holder,carried)
        self.e['UnitAddItem']=add
        self.e['FRC_Map'][(0,canonical)]=identity
        self.assertTrue(self.apply(),self.messages)
        self.assertEqual(self.e['FFN_Unit'][1]['quick'][0]['raw'],canonical)
        self.assertEqual(self.f.base.house['quick'][0]['raw'],canonical)
        self.finish()
        self.assertEqual(self.e['FRC_Result'][0],self.f.base.encoded)

    def test_intentional_real_placement_failure_leaves_load_unused_for_retry(self):
        self.e['FFL_RetryCheck'][0]=True
        self.assertFalse(self.apply())
        self.assertFalse(self.e['udg_HasLoadedCode'][0])
        self.assertEqual(self.f.base.house['quick'],{})
        self.assertTrue(all(i['raw']==0 for i in self.f.items))
        self.assertIn('intentionally stopped after item placement',self.messages[-1])
        self.assertIn('you can load again',self.messages[-1])
        self.assertTrue(self.apply(),self.messages)
        self.finish();self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0])

    def test_later_tick_cleanup_unlocks_only_after_removal(self):
        self.fail_place=True;self.f.block_item_removal=True
        self.assertFalse(self.apply())
        self.assertEqual(self.e['FFL_Phase'][0],5)
        self.assertTrue(self.e['FFP_Locked'][0])
        self.e['FFL_Tick']()
        self.assertEqual(self.e['FFL_Phase'][0],5)
        self.f.block_item_removal=False
        self.e['FFL_Tick']()
        self.assertEqual(self.e['FFL_Phase'][0],0)
        self.assertFalse(self.e['FFP_Locked'][0])
        self.assertFalse(self.e['udg_HasLoadedCode'][0])
        self.assertIn('you can load again',self.messages[-1])

    def test_permanent_cleanup_failure_remains_blocked_after_bounded_retries(self):
        self.fail_place=True;self.f.block_item_removal=True
        self.assertFalse(self.apply())
        for _ in range(10):self.e['FFL_Tick']()
        self.assertEqual(self.e['FFL_Phase'][0],4)
        self.assertTrue(self.e['FFP_Locked'][0])
        self.assertFalse(self.e['udg_HasLoadedCode'][0])
        self.assertIn('Type -newcleanup',self.messages[-1])

    def test_closed_load_window_creates_nothing(self):
        self.e['FFL_CloseWindow']()
        self.assertFalse(self.e['FFP_Build'](0,self.f.base.encoded,self.e['FFL_WindowOpen']))
        self.assertIn('window has closed',self.e['FFP_Error'][0])
        self.assertEqual(self.f.units,[])
        self.assertEqual(self.f.items,[])
        self.assertFalse(self.e['udg_HasLoadedCode'][0])

    def test_stored_gear_pickup_may_enter_bag_before_equipping(self):
        original=self.e['UnitAddItem']
        pickups=[]
        def add(holder,carried):
            if carried['raw']=='f003' and not pickups:
                holder['bag'][0]=carried
                pickups.append(carried)
                return True
            return original(holder,carried)
        self.e['UnitAddItem']=add
        self.assertTrue(self.apply(),self.messages)
        self.assertEqual(len(pickups),1)
        self.finish()
        self.assertEqual(self.e['FRC_Result'][0],self.f.base.encoded)
        self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0],self.messages)

    def test_inventory_setup_failure_precedes_item_pickup_and_allows_retry(self):
        self.e['UnitExtendedInventorySize']=lambda hero:0 if 'abilities' in hero else 30
        self.assertFalse(self.apply())
        self.assertIn('hero inventory setup quick=6 bag=0',self.messages[-1])
        self.assertIn('you can load again',self.messages[-1])
        self.assertEqual(self.e['FFL_Phase'][0],0)

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
        self.assertIn('you can load again',self.messages[-1])
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
        free=self.e['udg_FreelancerHero'][1]
        self.assertEqual(free['owner'],15)
        self.assertFalse(free['visible'])
        self.assertEqual(hero['owner'],0)
        self.assertEqual(self.e['udg_SpiritOfGaya'][1]['owner'],0)
        self.assertTrue(self.e['FRC_Start'](0))
        self.finish()
        self.assertEqual(self.e['FRC_Result'][0],self.f.base.encoded)
    def test_active_freelancer_remains_player_owned(self):
        import save_vnext as codec
        envelope=codec.decode(self.f.base.encoded)
        sections=tuple(codec.Section(section.id,section.version,section.required,
            codec.pairs([(i,0 if i==13 else v) for i,v in codec.read_pairs(section.payload)]))
            if section.id==4 else section for section in envelope.sections)
        self.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,sections))
        self.assertTrue(self.apply(),self.messages);self.finish()
        self.assertTrue(self.e['FRC_Ready'][0],self.e['FRC_Error'][0])
        self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0],self.messages)
        hero=self.e['udg_PlayerHero'][1]
        self.assertIs(self.e['udg_FreelancerHero'][1],hero)
        self.assertEqual(hero['owner'],0)

    def test_mastered_load_restores_shrine_unlock_after_commit(self):
        import save_vnext as codec
        envelope=codec.decode(self.f.base.encoded)
        sections=[]
        for section in envelope.sections:
            if section.id==7:
                flags=dict(codec.read_pairs(section.payload));flags[10]=1
                section=codec.Section(section.id,section.version,section.required,codec.pairs(sorted(flags.items())))
            sections.append(section)
        self.f.base.encoded=codec.encode(codec.Envelope(envelope.account_hash,tuple(sections)))
        self.assertTrue(self.apply(),self.messages);self.finish()
        e=self.e;unlocks=[]
        def unlock(trigger):
            self.assertTrue(e['udg_HasLoadedCode'][0])
            self.assertFalse(e['FFP_Locked'][0])
            unlocks.append((trigger,e['udg_TempInteger']))
        e.update(udg_ShrineUnlocked=False,ConditionalTriggerExecute=unlock)
        e['FFL_Tick']()
        # Every owned title's unlock effects run (Master = 10 opens the Shrine), as the legacy loader does.
        self.assertIn(('effects',10),unlocks)
        self.assertNotIn(('effects',14),unlocks)
        self.assertTrue(e['udg_HasLoadedCode'][0])
        self.assertEqual(e['FRC_Result'][0],self.f.base.encoded)

    def test_starter_is_hidden_during_load_and_shown_again_on_failure(self):
        starter=self.e['udg_PlayerHero'][1];gaya=self.e['udg_SpiritOfGaya'][1]
        self.fail_place=True
        self.assertFalse(self.apply())
        for _ in range(5):self.e['FFL_Tick']()
        self.assertIs(self.e['udg_PlayerHero'][1],starter)
        self.assertTrue(starter.get('visible',True));self.assertTrue(gaya.get('visible',True))

    def test_leftover_player_heroes_are_retired_on_commit(self):
        spare = {'owner': 0, 'visible': True, 'hero': True, 'raw': 'H005',
                 'abilities': {}, 'quick': {}, 'equipment': {}, 'bag': {}, 'level': 42}
        self.f.units.append(spare)
        self.assertTrue(self.apply(), self.messages); self.finish()
        self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0])
        self.assertEqual(spare['owner'], 15, 'a leftover hero should be released to neutral')
        self.assertFalse(spare['visible'], 'a leftover hero should be hidden')
        hero = self.e['udg_PlayerHero'][1]
        self.assertEqual(hero['owner'], 0)
        self.assertTrue(hero.get('visible', True))
        self.assertEqual(self.e['udg_SpiritOfGaya'][1]['owner'], 0)
        self.assertTrue(self.e['udg_SpiritOfGaya'][1].get('visible', True))

    def test_loaded_masteries_count_as_food_used(self):
        self.assertTrue(self.apply(),self.messages);self.finish()
        e=self.e
        for i in range(22):e['udg_JobLevelHash'][(e['FRC_JobRaw'](i),0)]=99 if i<5 else 40
        e['FFL_RestoreUnlocks'](0)
        self.assertEqual(self.currency['food'],5+(1 if e['udg_FreelancerHero'][1] is not None and e['udg_FreelancerHero'][1]['level']>=99 else 0))

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

    def test_inferno_save_loads_in_easy_and_then_saves_at_easy(self):
        import save_vnext as codec
        envelope = codec.decode(self.f.base.encoded)
        sections = tuple(codec.Section(section.id, section.version, section.required,
            codec.pairs([(i, 3 if i == 1 else v) for i, v in codec.read_pairs(section.payload)]))
            if section.id == 4 else section for section in envelope.sections)
        self.f.base.encoded = codec.encode(codec.Envelope(envelope.account_hash, sections))
        self.e['udg_Difficulty'] = 2
        self.assertTrue(self.apply(), self.messages)
        self.finish()
        self.assertEqual(self.e['FRC_Result'][0], self.f.base.encoded)
        self.e['FFL_Tick']()
        self.assertTrue(self.e['udg_HasLoadedCode'][0])
        self.assertEqual(self.e['FRC_LoadTier'][0], 0)
        self.assertEqual(self.e['FRC_Difficulty'](0), 2)

    def test_failed_placement_restores_state_and_can_retry(self):
        before=dict(self.f.base.fixture.level_table);techs=dict(self.f.base.fixture.techs)
        self.fail_place=True;self.assertFalse(self.apply());self.assertEqual(self.e['FFL_Phase'][0],0)
        self.assertFalse(self.e['udg_HasLoadedCode'][0]);self.assertIs(self.e['udg_PlayerHero'][1],self.f.base.hero)
        self.assertEqual(before,{k:v for k,v in self.f.base.fixture.level_table.items() if v});self.assertEqual(techs,{k:v for k,v in self.f.base.fixture.techs.items() if v})
        self.assertEqual(self.f.base.house['quick'],{});self.assertTrue(all(i['raw']==0 for i in self.f.items))
        self.fail_place=False;self.assertTrue(self.apply())
    def test_failed_cleanup_keeps_journal_until_retry(self):
        self.fail_place=True;self.f.block_item_removal=True;self.assertFalse(self.apply())
        self.assertEqual(self.e['FFL_Phase'][0],5);self.assertTrue(self.e['FFP_Locked'][0])
        self.assertTrue(any(parent<16 for parent,child in self.e['FFL_Before']))
        self.assertFalse(self.e['FFP_Build'](0,self.f.base.encoded,True))
        self.f.block_item_removal=False;self.assertTrue(self.e['FFL_Restore'](0));self.assertFalse(self.e['udg_HasLoadedCode'][0])
        self.assertFalse(any(parent<16 for parent,child in self.e['FFL_Before']))

    def test_commit_releases_removed_starter_snapshot_without_touching_other_players(self):
        self.e['FFL_Before'][19,0]='another player snapshot'
        self.assertTrue(self.apply());self.finish();self.e['FFL_Tick']()
        self.assertFalse(any(parent<16 for parent,child in self.e['FFL_Before']))
        self.assertEqual(self.e['FFL_Before'][19,0],'another player snapshot')
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
        self.assertFalse(self.apply());self.assertEqual(self.e['FFL_Phase'][0],5)
        self.assertGreater(self.e['FFN_SpacerCount'][0],0);self.assertTrue(self.e['FFP_Locked'][0])
        self.assertFalse(self.e['udg_HasLoadedCode'][0]);self.assertIs(self.e['udg_PlayerHero'][1],self.f.base.hero)
        self.e['RemoveItem']=remove;self.assertTrue(self.e['FFL_Restore'](0))
        self.assertEqual(self.e['FFN_SpacerCount'][0],0);self.assertFalse(self.e['FFP_Locked'][0])
    def test_normal_command_routing_preserves_legacy_imports(self):
        e=self.e;calls=[];command=['-save']
        e.update(GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,GetEventPlayerChatString=lambda:command[0],
                 FRC_StartNow=lambda pid:calls.append(('save',e['FST_FileStem'][pid])) or True,
                 FST_Request=lambda pid,account:calls.append(('load',e['FST_FileStem'][pid])) or True)
        for text,kind,stem in [('-save','save','Last save'),('-savef','save','Last save'),
                ('-savef Endgame','save','Endgame'),('-savef Forsaken Endgame','save','Forsaken Endgame'),
                ('-savef   ','save','Last save'),('-load','load','Last save'),
                ('-loadf','load','Last save'),('-loadf Forsaken Endgame','load','Forsaken Endgame'),
                ('-newsave','save','Forsaken CU'),('-newload','load','Forsaken CU')]:
            command[0]=text;e['FFL_Phase'][0]=0;e['FFL_Chat']()
            self.assertEqual(calls[-1],(kind,stem),text)
        for text in ('-load E12345','-loada (ABCDEF)'):
            command[0]=text;e['FFL_Phase'][0]=0
            self.assertTrue(e['FFL_LegacyAllowed'](),text)
        for text in ('-load','-loadf','-loadf Endgame','-loadf Last save','-load FSVB:1:1:1:A'):
            command[0]=text
            self.assertFalse(e['FFL_LegacyAllowed'](),text)
        command[0]='-savefTypo';e['FFL_Phase'][0]=0;before=len(calls)
        e['FFL_Chat']();self.assertEqual(len(calls),before)
        self.assertIn('use -savef',self.messages[-1])
        command[0]='-savef ../legacy';e['FFL_Phase'][0]=0;before=len(calls)
        e['FFL_Chat']();self.assertEqual(len(calls),before)
        self.assertIn('File names must',self.messages[-1])

    def test_numbered_chat_load_is_atomic_and_accepts_reordered_parts(self):
        e=self.e;code=self.f.base.encoded;check=e['FSC_Checksum'](code)
        total=(len(code)+79)//80
        calls=[];e['FFL_Apply']=lambda pid:calls.append(pid)
        for part in range(total,0,-1):
            text=f'FSVB:{check}:{part}:{total}:'+code[(part-1)*80:part*80]
            e['FFL_LoadChat'](0,text)
            if part>1:
                self.assertEqual(calls,[])
                e['FFL_LoadChat'](0,text)
                self.assertEqual(e['FFL_ChatCount'][0],total-part+1)
        self.assertEqual(calls,[0]);self.assertEqual(e['FST_Result'][0],code)
        self.assertFalse(e['udg_HasLoadedCode'][0])

    def test_loadstatus_lists_the_parts_still_missing(self):
        e=self.e;code=self.f.base.encoded;check=e['FSC_Checksum'](code)
        total=(len(code)+79)//80
        self.assertGreater(total,3,'needs a multi-part code')
        messages=[];e['FFL_Message']=lambda pid,text:messages.append(text)
        e['FFL_LoadStatus'](0)
        self.assertIn('No load in progress',messages[-1])
        skipped={2,total-1}
        for part in range(1,total+1):
            if part in skipped: continue
            e['FFL_LoadChat'](0,f'FSVB:{check}:{part}:{total}:'+code[(part-1)*80:part*80])
        e['FFL_LoadStatus'](0)
        self.assertIn(f'{total-len(skipped)} of {total} parts received',messages[-1])
        for part in sorted(skipped):
            self.assertIn(str(part),messages[-1])
        e['FFL_Apply']=lambda pid:None
        for part in sorted(skipped):
            e['FFL_LoadChat'](0,f'FSVB:{check}:{part}:{total}:'+code[(part-1)*80:part*80])
        e['FFL_LoadStatus'](0)
        self.assertIn(f'all {total} parts received',messages[-1])

    def test_chat_rejects_corruption_without_consuming_load_and_save_needs_no_io(self):
        e=self.e;calls=[];e['FFL_Apply']=lambda pid:calls.append(pid)
        e['FFL_LoadChat'](0,'FSVB:123:1:1:FSVBAAAAAAAA')
        self.assertEqual(calls,[]);self.assertFalse(e['udg_HasLoadedCode'][0])
        self.assertIn('do not fit together',self.messages[-1])
        e['FFL_LoadChat'](0,'FSVB:1:0:2:A')
        self.assertIn('load line is incomplete',self.messages[-1])
        e['FFL_Phase'][0]=1;e['FFL_SaveFile'][0]=False
        e['FRC_Ready'][0]=True;e['FRC_Result'][0]=self.f.base.encoded
        e['FST_Write']=lambda *args:self.fail('screen save must never write a file')
        e['FFL_Tick']()
        lines=[re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',m) for m in self.messages if m.startswith('-load FSVB:')]
        self.assertTrue(lines);self.assertTrue(all(len(line)<=121 for line in lines))
        self.assertEqual(e['FST_SavedCode'][0],self.f.base.encoded)

    def test_file_save_never_shows_or_replaces_screen_code_and_uses_legacy_path(self):
        e=self.e;calls=[]
        e.update(GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:0,
                 GetEventPlayerChatString=lambda:'-savef Endgame',FRC_StartNow=lambda pid:True)
        e['FFL_Chat']()
        self.assertEqual(self.messages,['Trying to save in FFERPG\\Endgame.txt'])
        e['FST_SavedCode'][0]='previous screenshot code'
        e['FRC_Ready'][0]=True;e['FRC_Result'][0]=self.f.base.encoded
        e['FST_ShowCode']=lambda *args:self.fail('file save must not display code pages')
        e['FST_Write']=lambda pid,code,account:calls.append((pid,code)) or True
        e['FFL_Tick']()
        self.assertEqual(calls,[(0,self.f.base.encoded)])
        self.assertEqual(e['FST_SavedCode'][0],'previous screenshot code')
        self.assertEqual(self.messages,['Trying to save in FFERPG\\Endgame.txt'])

    def test_save_actions_bind_once_after_forsaken_setup(self):
        e=self.e;calls=[]
        e.update(udg_SaveCommandTrig='save',udg_SaveToFileTrig='file',
                 TriggerClearActions=lambda t:calls.append(('clear',t)),
                 TriggerAddAction=lambda t,f:calls.append(('add',t)))
        e['FFL_BindCommands']();self.assertEqual(calls,[])
        e['ForsakenSaveBlocked']=True;e['FFL_BindCommands']();e['FFL_BindCommands']()
        self.assertEqual(calls,[('clear','save'),('add','save'),('clear','file'),('add','file')])

if __name__=='__main__':unittest.main()

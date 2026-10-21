"""Execute equipment/cooldown/save boundaries and owned rain cleanup."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from equipment_integrity import catalogue,refresh,object_items
from priest_master import fields
from objdata import read_objects
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
HERE=ROOT/'experiments/Forsaken'


def source(name):return next((ROOT/'src/triggers').rglob(name+'.j')).read_text()


class EquipmentIntegrityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        p=ROOT/'editor/FFERPG-Editor-Master.w3x'
        if not p.exists():p=next((ROOT/'release').glob('*stageATV.w3x'))
        cls.view=View(p);cls.config=catalogue(cls.view)

    def test_all_six_freelancer_forms_and_active_job_detection(self):
        s=refresh(source('ForsakenSaveCapture'),self.config)
        hero=['H02L'];env=mocks(s);env.update(GetUnitTypeId=lambda u:u,
            FRC_Hero={0:'H02L'},FRC_JobRaw=lambda i:'other',udg_FreelancerHero={1:'stale'})
        e=execute(s,['FRC_FreeVariant','FRC_Selected'],env)
        for i,raw in enumerate(['H02L','H02M','H02N','H02O','H02P','H02Q'],1):
            e['FRC_Hero'][0]=raw;self.assertEqual(e['FRC_FreeVariant'](raw),i);self.assertEqual(e['FRC_Selected'](0),0)
        self.assertEqual(e['FRC_FreeVariant']('HZZZ'),-1)
        codec=refresh(source('ForsakenSaveCodec'),self.config)
        e=execute(codec,['FSC_Core2Maximum'],dict(mocks(codec),FSC_CoreMaximum=lambda x:0))
        self.assertEqual(e['FSC_Core2Maximum'](14),6);self.assertEqual(e['FSC_Core2Maximum'](12),3)
        created=functions(refresh(source('ForsakenSaveFreshObjects'),self.config))['FFN_Allocate']
        for raw in ['H02O','H02P','H02Q']:self.assertIn(raw,created)

    def test_armory_only_accepts_actual_280_entries(self):
        self.assertEqual(len(self.config['storable']),280)
        s=refresh(source('Armory'),self.config)
        env=mocks(s);env.update(udg_ItemSaveID='ids',LoadInteger=lambda h,p,r:{'gear':12,'curse':0,'potion':1,'nut':352}.get(r,0),
            LoadBoolean=lambda h,p,i:i in self.config['storable'])
        e=execute(s,['Armory_CanStore'],env)
        self.assertTrue(e['Armory_CanStore']('gear'))
        for raw in ['curse','potion','nut','unknown']:self.assertFalse(e['Armory_CanStore'](raw))
        self.assertIn('if not Armory_CanStore',functions(s)['Trig_Armory_Store_Item_Actions'])

    def test_native_cooldown_covers_weapons_books_food_and_preserves_job_spells(self):
        p=self.config['pool']
        for raw in ['A0QA','A0UX','A0VB','A0KB']:self.assertGreater(p[raw],2,raw)
        for raw in ['AIh1','AIm1','A164','A16D']:self.assertEqual(p[raw],2,raw)
        self.assertNotIn('A0PU',p);self.assertNotIn('A0A8',p)

    def test_armory_cooldown_categories_and_aliases_match_both_clients(self):
        c=self.config;p=c['item_pool']
        self.assertEqual(p['I05U'],p['I05V']) # Elemental books
        self.assertEqual(p['I01E'],p['I08N']) # Magical weapons: rod and staff
        self.assertEqual(p['I00U'],p['I0LF']) # Physical weapons, including celestial
        self.assertEqual(len({p['I05U'],p['I01E'],p['I00U'],p['I0I1']}),4)
        for raw,m in c['mapping'].items():
            if raw in p:
                for alias in [m.get('variant'),m.get('offhand'),c['quick'].get(raw)]:
                    if alias:self.assertEqual(p[raw],p[alias])
        try:legacy_source=source('Backpack')
        except StopIteration:return # Native profile has no legacy page-holder module.
        s=refresh(legacy_source,c)
        self.assertEqual(refresh(s,c),s)
        self.assertIn('LoadInteger(BackpackCategoryTypes,70,spellId)',functions(s)['Backpack_PoolOf'])
        self.assertIn('LoadTimerHandle(BackpackCategoryCooldown,pid,pool)',functions(s)['Backpack_PoolTimer'])

    def test_materia_are_independent_of_each_other_gear_and_consumables(self):
        c=self.config;seen=set()
        for raw in c['materia']:
            p=c['item_pool'][raw];self.assertNotIn(p,{1,2}|seen);seen.add(p)
            for ability in str(fields(c['items'][raw]).get(('iabi',None),'')).split(','):
                if ability in c['pool']:self.assertEqual(c['pool'][ability],p)
        for native in (False,True):
            updated=object_items(self.view.object_bytes('war3map.w3t'),c,native=native)
            cats={o['id']:fields(o).get(('icid',None)) for o in read_objects(updated,'w3t')['custom'] if o['id'] in c['materia']}
            self.assertEqual(len(cats),len(c['materia']));self.assertEqual(len(set(cats.values())),len(cats))
            self.assertEqual(object_items(updated,c,native=native),updated)

    def test_miracle_accepts_zero_level_charged_targets_from_gaya(self):
        s=refresh(source('Miracle'),self.config);hits=[]
        env=mocks(s);env.update(GetSpellAbilityId=lambda:'A0UQ',GetSpellTargetItem=lambda:'potion',GetItemType=lambda i:'charged',ITEM_TYPE_CHARGED='charged',
            GetItemLevel=lambda i:0,GetItemCharges=lambda i:2,SetItemCharges=lambda i,n:hits.append((i,n)),GetTriggerUnit=lambda:'gaya')
        e=execute(s,['Trig_Miracle_Piece_Use_Conditions','Trig_Miracle_Piece_Use_Actions'],env)
        self.assertTrue(e['Trig_Miracle_Piece_Use_Conditions']());e['Trig_Miracle_Piece_Use_Actions']();self.assertEqual(hits,[('potion',1)])
        e['GetItemCharges']=lambda i:0;self.assertFalse(e['Trig_Miracle_Piece_Use_Conditions']())

    def test_cooldown_veto_stops_script_effects_and_gaya_bypasses(self):
        s=(HERE/'SharedItemCooldown.j').read_text();store={};now=[0.];cast=['hero','book'];stops=[]
        env=mocks(s);env.update(NativeCDData='cd',NativeCDClock='clock',R2SW=lambda n,*a:format(n,'.1f'),GetHandleId=lambda u:100 if u=='hero' else 101,
            GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,Player=lambda p:p,Player_GetHero=lambda p:'hero',udg_SpiritOfGaya={1:'gaya'},
            GetTriggerUnit=lambda:cast[0],GetSpellAbilityId=lambda:cast[1],TimerGetElapsed=lambda t:now[0],RMaxBJ=max,
            LoadInteger=lambda h,p,c:store.get((p,c),0),SaveInteger=lambda h,p,c,v:store.__setitem__((p,c),v),
            LoadReal=lambda h,p,c:store.get((p,c),0.),SaveReal=lambda h,p,c,v:store.__setitem__((p,c),v),
            LoadBoolean=lambda h,p,c:store.get((p,c),False),SaveBoolean=lambda h,p,c,v:store.__setitem__((p,c),v),
            SharedItemCD_Duration=lambda *a:12.,BlzGetUnitAbilityCooldownRemaining=lambda *a:12.,GetUnitAbilityLevel=lambda *a:1,IssueImmediateOrder=lambda *a:stops.append(a))
        store[0,'book']=1;store[0,'otherbook']=1;store[0,'potion']=2
        e=execute(s,['NativeCD_Pool','NativeCD_Left','NativeCD_PlayerCaster','NativeCD_Stop','NativeCD_Channel','NativeCD_Allowed','NativeCD_DurationForCast','NativeCD_Effect'],env)
        e['NativeCD_Channel']();self.assertTrue(e['NativeCD_Allowed']());e['NativeCD_Effect']()
        self.assertEqual(store[32,1],12.)
        for actor,raw in [('hero','otherbook'),('gaya','book'),('hero','book')]:
            cast[:]=[actor,raw];e['NativeCD_Channel']();self.assertFalse(e['NativeCD_Allowed']())
        self.assertEqual(len(stops),3)
        cast[:]=['hero','potion'];e['NativeCD_Channel']();self.assertTrue(e['NativeCD_Allowed']())
        now[0]=13.;cast[:]=['hero','book'];e['NativeCD_Channel']();self.assertTrue(e['NativeCD_Allowed']())

    def test_duration_helper_does_not_gate_low_level_ability_library(self):
        s=refresh(source('Abil'),self.config,native=True)
        self.assertNotIn('TItemCooldown',s.splitlines()[0])
        self.assertNotIn('Condition(function NativeCD_Allowed)',s)
        self.assertIn('function SharedItemCD_Duration',s)
        self.assertEqual(refresh(s,self.config,native=True),s)

    def test_prototype_equipment_metadata_and_passives(self):
        self.assertTrue({'A034','A03F','A0IZ'}<=self.config['passive'])
        before=self.view.object_bytes('war3map.w3t')
        updated=object_items(before,self.config,native=True)
        self.assertEqual(object_items(updated,self.config,native=True),updated)
        p=next(o for o in read_objects(updated,'w3t')['custom'] if o['id']=='I0BQ')
        self.assertEqual(fields(p)['iequ',None],'Primary')
        self.assertEqual(fields(p)['iabi',None],fields(self.config['items']['I0BQ'])['iabi',None])

    def test_native_quick_slots_suspend_gear_while_worn_restores_it(self):
        s='library TUnit\nglobals\nendglobals\n'+(HERE/'Forsaken-active-gear.j').read_text()
        # Use the actual prepared native storage helper when available; its
        # equivalent source lives in the native reference, never legacy slots.
        p=ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEN.w3x'
        if p.exists():base=View(p).modules['TUnit']
        else:
            base=source('Unit')
            if 'Forsaken_SyncStoredEffects' not in functions(base):
                base='library TUnit\nglobals\nendglobals\n'+(HERE/'StoredGear.j').read_text()+'\nendlibrary'
        u=refresh(base,self.config,native=True);seen=[]
        env=mocks(u);env.update(ForsakenElementSources='src',UnitItemInSlot=lambda h,i:'book' if i==0 else None,
            GetItemTypeId=lambda i:i,LoadBoolean=lambda h,p,r:r=='book',
            UnitItemInEquipmentSlot=lambda h,i:'worn' if i==0 else None,ConvertLoadoutSlot=lambda i:i,
            UnitExtendedInventorySize=lambda h:1,UnitItemInBagSlot=lambda h,i:'stored',
            Forsaken_SuspendStoredItem=lambda i:seen.append(('suspend',i)),Forsaken_RestoreStoredItem=lambda i:seen.append(('restore',i)))
        e=execute(u,['Forsaken_SyncStoredEffects'],env);e['Forsaken_SyncStoredEffects']('hero')
        self.assertIn(('suspend','book'),seen);self.assertIn(('restore','worn'),seen);self.assertIn(('suspend','stored'),seen)

    def test_regeneration_display_uses_the_same_equipped_only_scan(self):
        s=(HERE/'Forsaken-panels.j').read_text()
        s=refresh(s,self.config,native=True)
        body=functions(s)['Forsaken_ReadRegeneration']
        self.assertIn('set carried=Forsaken_ActiveGear(hero,slot)',body)
        self.assertNotIn('set carried=UnitItemInSlot',body)
        self.assertEqual(refresh(s,self.config,native=True),s)

    def test_pram_nut_can_breed_and_does_not_reuse_previous_score(self):
        s=refresh(source('Chocobo_Taming'),self.config)
        fn='Trig_Chocobo_Tame_Breed_IsNotPramNutAgain'
        e=execute(s,[fn],mocks(s));self.assertTrue(e[fn]())
        b=functions(s)['Trig_Chocobo_Tame_Breed_Actions']
        self.assertLess(b.index('set udg_ChocoboAbilityIndex=0'),b.index('call ConditionalTriggerExecute(gg_trg_Chocobo_Breed_Score)'))

    def test_rain_finishes_and_releases_every_effect_group_timer(self):
        s=(HERE/'ScriptedRain.j').read_text();store={(1,8):3,(1,9):'group'};destroy=[]
        env=mocks(s);env.update(RainData='rain',GetHandleId=lambda t:1,
            LoadInteger=lambda h,p,c:store.get((p,c),0),LoadEffectHandle=lambda h,p,c:'fx'+str(c),
            LoadGroupHandle=lambda h,p,c:store.get((p,c)),DestroyEffect=lambda e:destroy.append(e),DestroyGroup=lambda g:destroy.append(g),
            PauseTimer=lambda t:destroy.append('paused'),DestroyTimer=lambda t:destroy.append(t),FlushChildHashtable=lambda h,p:destroy.append('flushed'))
        e=execute(s,['Rain_End'],env);e['Rain_End']('timer')
        self.assertEqual(destroy,['fx100','fx101','fx102','group','flushed','paused','timer'])
        self.assertIn('call Rain_Start',functions(source('Myriad'))['Trig_Myriad_Arrows_Actions'])
        self.assertNotIn('IssuePointOrderLocBJ',functions(source('Meteor'))['Trig_Meteor_Cast_Actions'])

    def test_final_rain_wave_filters_targets_and_releases_cast(self):
        s=(HERE/'ScriptedRain.j').read_text()
        for arrows in (True,False):
            store={0:'caster',1:0.,2:0.,3:250.,4:123.,6:1,7:4,8:0,9:'group',10:arrows}
            targets=['enemy','ally','invulnerable','flying'];hits=[];ended=[]
            env=mocks(s);env.update(RainData='rain',GetExpiredTimer=lambda:'timer',GetHandleId=lambda t:1,
                LoadInteger=lambda h,p,c:store.get(c,0),LoadReal=lambda h,p,c:store.get(c,0.),
                LoadUnitHandle=lambda h,p,c:store.get(c),LoadGroupHandle=lambda h,p,c:store.get(c),
                LoadBoolean=lambda h,p,c:store.get(c,False),GetUnitTypeId=lambda u:1,
                SaveInteger=lambda h,p,c,v:store.__setitem__(c,v),GroupEnumUnitsInRange=lambda *a:None,
                FirstOfGroup=lambda g:targets[0] if targets else None,GroupRemoveUnit=lambda g,u:targets.remove(u),
                IsUnitEnemy=lambda u,p:u!='ally',GetOwningPlayer=lambda u:0,GetWidgetLife=lambda u:100.,
                IsUnitType=lambda u,k:u=='flying',UNIT_TYPE_FLYING='flying',
                GetUnitAbilityLevel=lambda u,r:1 if u=='invulnerable' else 0,
                UnitDamageTarget=lambda *a:hits.append(a),Rain_End=ended.append,
                ATTACK_TYPE_PIERCE='pierce',DAMAGE_TYPE_NORMAL='normal',ATTACK_TYPE_NORMAL='normal',DAMAGE_TYPE_MAGIC='magic')
            e=execute(s,['Rain_Tick'],env);e['Rain_Tick']()
            self.assertEqual(len(hits),1);self.assertEqual(hits[0][:3],('caster','enemy',123.))
            self.assertEqual(e['udg_IsPhysicalAttack'],arrows);self.assertEqual(e['udg_DamageElement'],0)
            self.assertEqual(store[6],0);self.assertEqual(ended,['timer']);self.assertEqual(targets,[])

    def test_fishing_load_bag_alias_gaya_reveal_and_equipped_only_cast(self):
        from test_gameplay_inventory import GameplayTests,item
        setup=refresh(source('Fishing_Setup'),self.config)
        casting=refresh(source('Fishing_Casting'),self.config)
        for classic in (False,True):
            for where in ('quick','lastbag','worn','gaya'):
                with self.subTest(classic=classic,where=where):
                    env,quick,bags,gear=GameplayTests().inventory(classic)
                    raw='I0EY' if classic else 'fRod'
                    env['ForsakenGearTypes'][4,'fRod']='I0EY'
                    rod=item(raw=raw)
                    if where=='quick':quick['hero']=[rod]
                    elif where=='gaya':quick['gaya']=[rod]
                    elif where=='worn':
                        if classic:quick['page0']=[rod]
                        else:gear['hero']=[rod]
                    elif classic:quick['page6']=[None]*5+[rod]
                    else:bags['hero']=[None]*29+[rod]
                    shown=[];enabled=[];disabled=[];stock=[]
                    env.update(FishingUnlocked=False,udg_FishingSpots='spots',Player=lambda p:p,
                        Player_GetHero=lambda p:'hero' if p==0 else None,udg_SpiritOfGaya=defaultdict(lambda:None,{1:'gaya'}),
                        ForGroupBJ=lambda group,fn:shown.append(group),AddItemToStockBJ=lambda *a:stock.append(a),
                        gg_unit_n02Y_0052='ruksel',gg_trg_Fishing_Cast='cast',gg_trg_Fishing_Unlock='unlock',
                        EnableTrigger=enabled.append,DisableTrigger=disabled.append,
                        Trig_Fishing_Unlock_ShowFishingSpot=lambda:None)
                    names=['Fishing_Rod','Fishing_CarryRod','Fishing_HasAnyRod','Fishing_UnlockOnce']
                    e=execute(setup,names,env)
                    self.assertTrue(e['Fishing_HasAnyRod']())
                    e['Fishing_UnlockOnce']();e['Fishing_UnlockOnce']()
                    self.assertEqual(shown,['spots']);self.assertEqual(enabled,['cast']);self.assertEqual(disabled,['unlock'])
                    self.assertEqual(len(stock),1)
                    e=execute(casting,['Fishing_WornCast'],e)
                    self.assertEqual(e['Fishing_WornCast']('hero','A0VB'),where=='worn')
        self.assertIn('TriggerRegisterTimerEvent(gg_trg_Fishing_Unlock,1.,true)',functions(setup)['Register_Fishing_Unlock'])
        self.assertIn('Fishing_WornCast',functions(casting)['Trig_Fishing_Cast_Conditions'])
        for s in (setup,casting):self.assertEqual(refresh(s,self.config),s)

    def test_native_gear_moves_to_quick_slots_without_being_reconverted(self):
        updated=object_items(self.view.object_bytes('war3map.w3t'),self.config,native=True)
        byid={o['id']:fields(o) for o in read_objects(updated,'w3t')['custom']}
        for raw in ['I0I1','I081']:
            self.assertEqual(byid[raw].get(('icla',None)),fields(self.config['items'][raw]).get(('icla',None)))
            quick=self.config['quick'][raw]
            self.assertEqual(byid[quick]['icla',None],'Permanent');self.assertEqual(byid[quick]['iequ',None],'')
        p=ROOT/'release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEN.w3x'
        if p.exists():base=View(p).modules['TEquip']
        else:
            base=source('Equip')
            if 'Forsaken_CarryOrder' not in functions(base):return
        native=refresh(base,self.config,native=True);orders=[];order=[852002]
        env=mocks(native);env.update(GetIssuedOrderId=lambda:order[0],GetOrderTargetItem=lambda:'gear',GetOrderTargetUnit=lambda:None,
            GetItemTypeId=lambda i:'f095' if i else 0,GetOwningPlayer=lambda u:0,Player_GetHero=lambda p:'hero',
            GetHandleId=lambda u:1,ForsakenGearTypes='types',LoadInteger=lambda h,p,c:'I081' if p==4 else 0,
            Forsaken_CarryReplacement=lambda h,i,s:orders.append((h,i,s)) or 'quick',OrderId=lambda s:0)
        e=execute(native,['Forsaken_CarryOrder'],env)
        for o in (852002,852007):order[0]=o;e['Forsaken_CarryOrder']('hero')
        self.assertEqual(orders,[('hero','gear',0),('hero','gear',5)])
        created=[]
        env=mocks(native);env.update(ForsakenConvertingGear=False,UnitExtendedInventorySize=lambda h:0,
            UnitItemInSlot=lambda h,i:'quick' if i==0 else None,GetItemTypeId=lambda i:'I081' if i else 0,
            LoadInteger=lambda h,p,r:'f095' if r=='I081' else 0,GetHandleId=lambda i:1,
            LoadBoolean=lambda h,p,i:p==51,ForsakenGearTypes='types',CreateItem=lambda *a:created.append(a))
        e=execute(native,['Forsaken_PrepareQuickGear'],env);e['Forsaken_PrepareQuickGear']('hero');self.assertEqual(created,[])

    def test_direct_quick_placement_preserves_original_until_verified(self):
        s=(HERE/'CarryQuickSlot.j').read_text()
        for allowed,occupied in [(True,False),(False,False),(True,True)]:
            slots={0:'other' if occupied else None};removed=[];props=[]
            def add(hero,raw,slot):
                if allowed:slots[slot]='quick'
                return allowed
            env=mocks(s);env.update(ForsakenConvertingGear=False,ForsakenGearTypes='types',ForsakenBagAbilities='passives',
                Forsaken_HoldsItem=lambda *a:True,UnitItemInSlot=lambda h,i:slots.get(i),
                LoadInteger=lambda *a:'q095',UnitAddItemToSlotById=add,GetItemTypeId=lambda i:'q095',
                GetItemUserData=lambda i:42,GetWidgetLife=lambda i:145.25,GetItemPlayer=lambda i:0,GetItemCharges=lambda i:5,
                GetHandleId=lambda i:i,SetItemUserData=lambda i,v:props.append(('data',v)),
                SetWidgetLife=lambda i,v:props.append(('life',v)),SetItemPlayer=lambda *a:None,
                SetItemCharges=lambda i,v:props.append(('charges',v)),UnitRemoveItem=lambda *a:removed.append(a[-1]),
                RemoveItem=lambda i:removed.append(i),Forsaken_SyncStoredEffects=lambda h:props.append(('sync',h)))
            e=execute(s,['Integrity_CarryIntoSlot'],env)
            result=e['Integrity_CarryIntoSlot']('hero','original',0,'I081')
            if allowed and not occupied:
                self.assertEqual(result,'quick');self.assertEqual(removed,['original','original'])
                self.assertEqual(props,[('data',42),('life',145.25),('charges',5),('sync','hero')])
            else:self.assertEqual(result,'original');self.assertEqual(removed,[])
            self.assertFalse(e['ForsakenConvertingGear'])

    def test_native_save_load_restores_quick_gear_aliases(self):
        from equipment_integrity import native_refresh
        from test_armory_materia import execute
        from collections import defaultdict
        raw='I081';variant=self.config['mapping'][raw]['variant'];quick=self.config['quick'][raw]
        for current in [raw,variant,quick]:
            base="function FFP_Init takes nothing returns nothing\n    call SaveInteger(FFP_Bindings,1,42,'%s')\nendfunction\n"%current
            updated=native_refresh(base,self.config)
            values={};env=mocks(updated);env.update(FFP_Bindings='bindings',SaveInteger=lambda h,p,c,v:values.__setitem__((p,c),v))
            e=execute(updated,['FFP_Init'],env);e['FFP_Init']()
            self.assertEqual(values[1,42],quick)
            self.assertEqual(native_refresh(updated,self.config),updated)

    def test_native_equipment_class_allows_drag_without_losing_equip_slot(self):
        import copy
        from objdata import write_objects
        from priest_master import setf
        candidates=[r for r,o in self.config['items'].items() if 'Galbados' in str(fields(o).get(('unam',None),''))]
        self.assertTrue(candidates)
        for original in candidates:
            if original not in self.config['mapping']:continue
            variant=self.config['mapping'][original]['variant']
            item=copy.deepcopy(self.config['items'][original]);item['id']=variant
            for st in item['sets']:
                st['mods']+=[dict(field='icla',type=3,level=None,data=None,value='Equipment',end=0),dict(field='iequ',type=3,level=None,data=None,value='Offhand',end=0)]
            table=dict(version=2,original=[],custom=[item]);data=write_objects(table,2,'w3t')
            out={o['id']:fields(o) for o in read_objects(object_items(data,self.config,native=True),'w3t')['custom']}
            self.assertEqual(out[variant]['icla',None],'Permanent')
            self.assertEqual(out[variant]['iequ',None],'Offhand')
            self.assertEqual(out[variant].get(('iabi',None)),fields(self.config['items'][original]).get(('iabi',None)))

    def test_shared_transform_idempotent_and_freelancer_stats_group_variants(self):
        names=['Armory','ForsakenSaveCapture','ForsakenSaveCodec','ForsakenSaveFreshObjects','ForsakenFreshLoad','Myriad','Meteor','Chocobo_Taming']
        if any((ROOT/'src/triggers').rglob('GearSlots.j')):names.append('GearSlots')
        for name in names:
            s=refresh(source(name),self.config);self.assertEqual(refresh(s,self.config),s,name)
        b=functions(source('ForsakenFreshLoad'))['FFL_PrepareHero']
        self.assertIn('ModuloInteger(FFL_Val(pid,4,14)-1,3)+1',b)


if __name__=='__main__':unittest.main()

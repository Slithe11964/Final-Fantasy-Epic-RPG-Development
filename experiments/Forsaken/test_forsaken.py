"""Check the experimental mapping, immutable item fields and save boundary."""
from pathlib import Path
import sys
import tempfile
import struct
import re
import unittest

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import build_forsaken as build
sys.path.insert(0, str(build.ROOT/'tools/tests'))
from test_shared_context import mocks
from test_armory_materia import execute
from mpq import MPQ
from objdata import read_objects, fields
from jtok import functions


class ForsakenTests(unittest.TestCase):
    def test_native_slots_and_accessories(self):
        for category, slot in [(12, 'Primary'), (24, 'Offhand'), (28, 'Head'), (30, 'Chest')]:
            self.assertEqual(build.slot_for({'name': 'Example'}, category), slot)
        for name, slot in [('Sprint Shoes', 'Boots'), ('Genji Gloves', 'Gloves'),
                           ('Memento Ring', 'Ring'), ('Rosetta Stone', 'Trinket')]:
            self.assertEqual(build.slot_for({'name': name}, 33), slot)
        self.assertIsNone(build.slot_for({'name': 'Aeroga Materia'}, 8))

    def test_object_patch_only_changes_equipment_types_and_adds_two_abilities(self):
        base = build.ROOT/'release/FFERPG_0.9.7.3-r16-stageAS.w3x'
        with tempfile.TemporaryDirectory(dir=build.ROOT/'build') as folder:
            out = Path(folder)/'gear.w3x'
            mapping = build.prepare_objects(base, out, Path(folder)/'mapping.json')
            old, new = MPQ(base), MPQ(out)
            for filename in old.read('(listfile)').decode().splitlines():
                if filename not in ('war3map.w3t', 'war3map.w3a', 'war3map.w3i','war3map.imp','(listfile)','(attributes)'):
                    self.assertEqual(old.read(filename), new.read(filename), filename)
            info_before, info_after = old.read('war3map.w3i'),new.read('war3map.w3i')
            offset = build.game_data_version_offset(info_before)
            self.assertEqual(struct.unpack_from('<i',info_before,offset)[0],1)
            self.assertEqual(struct.unpack_from('<i',info_after,offset)[0],2)
            self.assertEqual(info_before[:offset],info_after[:offset])
            self.assertEqual(info_before[offset+4:],info_after[offset+4:])
            def items(archive):
                t = read_objects(archive.read('war3map.w3t'), 'w3t')
                return {o['id'] or o['base']: fields(o) for g in ('original', 'custom') for o in t[g]}
            before, after = items(old), items(new)
            self.assertEqual(len(after)-len(before),277)
            self.assertEqual(after['fGap']['iabi'],'')
            self.assertEqual(new.read('war3map.imp'),old.read('war3map.imp'))
            for raw, original in before.items():
                self.assertEqual(original, after[raw], raw)
                if raw in mapping and mapping[raw]['slot']!='Inventory':
                    updated = after[mapping[raw]['variant']].copy()
                    self.assertEqual(updated.pop('iequ'), mapping[raw]['slot'])
                    self.assertEqual(original, updated, raw)
            self.assertNotIn('fBpk',after)
            self.assertEqual(len(mapping), 280)
            abilities = read_objects(new.read('war3map.w3a'), 'w3a')
            abilities = {o['id'] or o['base']: o for g in ('original', 'custom') for o in abilities[g]}
            for raw, capacity_field, capacity, item_ability in [('fBag','inv6',30,0),('fBgi','inv6',30,1),('fGer','equ1',0,0)]:
                self.assertEqual(fields(abilities[raw])[(capacity_field,1)],capacity)
                self.assertEqual(fields(abilities[raw])['aite'],item_ability)
                capacity_mod = next(m for m in abilities[raw]['sets'][0]['mods'] if m['field']==capacity_field)
                self.assertEqual(capacity_mod['data'],6)

    def test_equipment_validation_uses_event_item_and_save_serializers_are_untouched(self):
        source = (build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8')
        overlay = build.equip_overlay(source)
        fs = functions(overlay)
        self.assertIn('Forsaken_ValidateEquipment', fs)
        self.assertIn('GetTriggerUnit', fs['Forsaken_ValidateEquipment'])
        self.assertNotIn('GetManipulatingUnit', fs['Forsaken_ValidateEquipment'])
        self.assertIn('GetItemEquipmentType', fs['Trig_Equip_Restrictions_Conditions'])
        self.assertNotIn('Save_WriteCode', overlay)
        self.assertNotIn('Save_WriteNewGameCode', overlay)
        self.assertIn('TriggerClearActions', fs['Forsaken_PrepareInventories'])
        self.assertIn('UnitUnequipItem', fs['Forsaken_RejectEquipment'])

    def test_native_equip_checks_level_and_rejects_the_event_item(self):
        source = (build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8')
        overlay = build.equip_overlay(source)
        selected = ['Forsaken_EventItem', 'Forsaken_RejectEquipment',
                    'Trig_Equip_Restrictions_GaiaLevelTooLow',
                    'Trig_Equip_Restrictions_JobGatedItem',
                    'Forsaken_ValidateEquipment', 'Forsaken_OnEquip']
        for gaya_level, rejected in [(10, True), (30, False)]:
            calls = []
            state = mocks(overlay)
            state.update(ForsakenEquippedItem=None, GetTriggerUnit=lambda:'hero', GetOwningPlayer=lambda u:0,
                         Player_GetHero=lambda p:'hero', GetEquippedItem=lambda:'gear',
                         GetManipulatedItem=lambda:None, IsPlayerInForce=lambda *a:True,
                         udg_PlayingPlayers='players', udg_SpiritOfGaya={1:'gaya'},
                         udg_PlayerName={1:'Slithe'}, GetConvertedPlayerId=lambda p:1,
                         I2R=float, R2I=int, I2S=str,
                         GetHeroLevel=lambda u:gaya_level, GetItemLifeBJ=lambda i:20.,
                         GetItemName=lambda i:'Example helmet',
                         UnitUnequipItem=lambda u,i:calls.append(('unequip',u,i)),
                         UnitRemoveItem=lambda u,i:calls.append(('remove',u,i)))
            runtime = execute(overlay, selected, state)
            runtime['Forsaken_OnEquip']()
            self.assertEqual(calls, [('unequip','hero','gear'), ('remove','hero','gear')] if rejected else [])
            self.assertIsNone(runtime['ForsakenEquippedItem'])

    def test_conversion_preserves_original_when_the_bag_refuses_the_variant(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        for accepts, equips, stays_equipped in [(False,False,False),(True,False,False),(True,True,False),(True,True,True)]:
            removed, copied = [], []
            state = mocks(overlay)
            state.update(ForsakenGearTypes='types', UnitItemInSlot=lambda u,s:'original' if s==0 else None,
                         GetItemTypeId=lambda i:1 if i=='original' else 0,
                         LoadInteger=lambda h,p,c:123 if c==1 else 0,
                         CreateItem=lambda *a:'variant', GetItemCharges=lambda i:4,
                         GetItemUserData=lambda i:2,
                         SetItemCharges=lambda i,v:copied.append(('charges',i,v)),
                         SetItemUserData=lambda i,v:copied.append(('owner',i,v)),
                         UnitExtendedInventorySize=lambda u:0,
                         UnitHasLoadoutSlotEmpty=lambda *a:True, ConvertLoadoutSlot=lambda i:i,
                         EQUIPMENT_LOADOUT_SLOT_RINGALT=5,
                         UnitAddItem=lambda *a:accepts, UnitEquipItem=lambda *a:equips,
                         IsItemEquipped=lambda i:stays_equipped, RemoveItem=lambda i:removed.append(i))
            runtime = execute(overlay, ['Forsaken_ConvertCarriedGear'], state)
            runtime['Forsaken_ConvertCarriedGear']('hero')
            self.assertEqual(removed, ['original'] if accepts and equips and stays_equipped else ['variant'])
            self.assertEqual(copied, [('charges','variant',4),('owner','variant',2)])

    def test_native_setup_attaches_all_three_abilities_to_the_player_hero(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        calls = []
        state = mocks(overlay)
        state.update(UnitAddAbility=lambda u,a:calls.append(('add',u,a)),
                     UnitMakeAbilityPermanent=lambda u,p,a:calls.append(('permanent',u,p,a)))
        runtime = execute(overlay, ['Forsaken_EnableHero'], state)
        runtime['Forsaken_EnableHero']('hero')
        self.assertEqual(calls, [call for raw in ['fBag','fGer','ASpc']
                               for call in [('add','hero',raw),('permanent','hero',True,raw)]])
        self.assertNotIn("UnitRemoveAbility(holder,'AInv')",overlay)

    def test_backpack_is_only_an_ability_and_automatic_conversion_is_enabled(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        self.assertNotIn('fBpk',overlay)
        self.assertIn('Forsaken_ConvertCarriedGear',functions(overlay)['Forsaken_PrepareInventories'])
        self.assertNotIn('LoadInteger',functions(overlay)['Trig_Equip_Restrictions_Conditions'])

    def test_manual_conversion_reaches_original_gear_already_in_the_native_bag(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        removed = []
        state = mocks(overlay)
        state.update(ForsakenGearTypes='types', UnitExtendedInventorySize=lambda u:2,
                     UnitItemInSlot=lambda *a:None,
                     UnitItemInBagSlot=lambda u,s:'original' if s==1 else None,
                     GetItemTypeId=lambda i:1 if i=='original' else 0,
                     LoadInteger=lambda h,p,c:123 if c==1 else 0,
                     CreateItem=lambda *a:'variant',UnitAddItem=lambda *a:True,
                     UnitHasLoadoutSlotEmpty=lambda *a:True,ConvertLoadoutSlot=lambda i:i,
                     EQUIPMENT_LOADOUT_SLOT_RINGALT=5,
                     UnitEquipItem=lambda *a:True,IsItemEquipped=lambda i:True,
                     RemoveItem=lambda i:removed.append(i))
        runtime = execute(overlay,['Forsaken_ConvertCarriedGear'],state)
        runtime['Forsaken_ConvertCarriedGear']('hero')
        self.assertEqual(removed,['original'])

    def test_automatic_slotting_never_replaces_occupied_equipment_and_uses_second_ring(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        for equipment_slot, empty_slots, expected in [(0,set(),[]),(4,{5},['original']),(4,set(),[])]:
            removed=[]
            state=mocks(overlay)
            state.update(ForsakenGearTypes='types',UnitExtendedInventorySize=lambda u:0,
                         UnitItemInSlot=lambda u,s:'original' if s==0 else None,
                         GetItemTypeId=lambda i:1 if i=='original' else 0,
                         LoadInteger=lambda h,p,c:(123 if p==0 else equipment_slot) if c==1 else 0,
                         UnitHasLoadoutSlotEmpty=lambda u,s:s in empty_slots,ConvertLoadoutSlot=lambda i:i,
                         EQUIPMENT_LOADOUT_SLOT_RINGALT=5,
                         CreateItem=lambda *a:'variant',UnitAddItem=lambda *a:True,
                         UnitEquipItem=lambda *a:True,IsItemEquipped=lambda i:True,
                         RemoveItem=lambda i:removed.append(i))
            execute(overlay,['Forsaken_ConvertCarriedGear'],state)['Forsaken_ConvertCarriedGear']('hero')
            self.assertEqual(removed,expected)

    def test_job_switch_moves_same_handles_bag_and_both_rings_and_round_trip(self):
        overlay=build.job_overlay((build.ROOT/'src/triggers/03 Jobs and progression/Job.j').read_text(encoding='utf-8'))
        fs=functions(overlay)
        action=fs['Trig_Job_Change_Actions']
        self.assertLess(action.index('set udg_PlayerHero'),action.index('call Forsaken_TransferSharedInventory'))
        self.assertLess(action.index('call Forsaken_TransferSharedInventory'),action.index('call ConditionalTriggerExecute(gg_trg_AttackSpeed_Update)'))
        self.assertLess(action.index('call UnitRemoveItemFromSlotSwapped'),action.index('call Forsaken_TransferSharedInventory'))
        self.assertLess(action.index('call Forsaken_TransferSharedInventory'),action.index('if(Trig_Job_Change_HasSavedItem())'))
        self.assertNotIn('requires TEquip',overlay)
        shared_bag=['potion','materia']+['part-'+str(i) for i in range(28)]
        bags={'squire':shared_bag.copy(),'ninja':[],'other':['other-player-item']}
        equipped={'squire':{0:'hat',4:'ring',5:'second-ring',6:'sword'},'ninja':{},'other':{}}
        quick_slots={'squire':[],'ninja':[],'other':[]}
        legacy_enabled={u:True for u in bags}
        charges={i:7 for i in shared_bag+['hat','ring','second-ring','sword']}
        initial_charges=charges.copy()
        def remove(u,i):
            if i in bags[u]: bags[u].remove(i)
            for s,v in list(equipped[u].items()):
                if v==i: del equipped[u][s]
        def add(u,i):
            if legacy_enabled[u] and len(quick_slots[u])<6:
                quick_slots[u].append(i)
                return True
            if len(bags[u])>=30: return False
            bags[u].append(i)
            return True
        def equip(u,i):
            slot={'hat':0,'ring':4,'second-ring':5,'sword':6}[i]
            bags[u].remove(i)
            equipped[u][slot]=i
            return True
        state=mocks(overlay)
        state.update(UnitExtendedInventorySize=lambda u:30,ConvertLoadoutSlot=lambda i:i,
                     ForsakenSharedBag={},
                     GetUnitAbilityLevel=lambda u,a:1 if a=='AInv' and legacy_enabled[u] else 0,
                     UnitRemoveAbility=lambda u,a:legacy_enabled.__setitem__(u,False) if a=='AInv' else None,
                     UnitAddAbility=lambda u,a:legacy_enabled.__setitem__(u,True) if a=='AInv' else None,
                     UnitItemInBagSlot=lambda u,s:bags[u][s] if s<len(bags[u]) else None,
                     UnitItemInEquipmentSlot=lambda u,s:equipped[u].get(s),
                     GetItemCharges=lambda i:charges[i],SetItemCharges=lambda i,v:charges.__setitem__(i,v),
                     UnitUnequipItem=lambda u,i:None,UnitRemoveItem=remove,UnitAddItem=add,UnitEquipItem=equip)
        runtime=execute(overlay,['Forsaken_MoveSharedItem','Forsaken_TransferSharedInventory'],state)
        for previous,current in [('squire','ninja'),('ninja','squire')]:
            runtime['Forsaken_TransferSharedInventory'](previous,current)
            self.assertEqual(bags[previous],[])
            self.assertEqual(equipped[previous],{})
            self.assertEqual(bags[current],shared_bag)
            self.assertEqual(quick_slots[current],[])
            self.assertTrue(legacy_enabled[current])
            self.assertEqual(equipped[current],{0:'hat',4:'ring',5:'second-ring',6:'sword'})
            self.assertEqual(charges,initial_charges)
            self.assertEqual(bags['other'],['other-player-item'])

    def test_failed_job_transfer_keeps_item_and_charges_at_new_hero(self):
        overlay=(HERE/'Forsaken-job.j').read_text(encoding='utf-8')
        calls=[]
        state=mocks(overlay)
        state.update(GetItemCharges=lambda i:8,UnitAddItem=lambda *a:False,
                     UnitRemoveItem=lambda *a:calls.append(('remove',)+a),
                     SetItemCharges=lambda *a:calls.append(('charges',)+a),
                     SetItemPosition=lambda *a:calls.append(('position',)+a),
                     GetUnitX=lambda u:42.,GetUnitY=lambda u:24.,
                     UnitEquipItem=lambda *a:calls.append(('equip',)+a))
        execute(overlay,['Forsaken_MoveSharedItem'],state)['Forsaken_MoveSharedItem']('old','new','potion',False)
        self.assertEqual(calls,[('remove','old','potion'),('charges','potion',0),
                               ('charges','potion',8),('position','potion',42.,24.)])

    def test_panels_use_native_bases_and_only_zero_bonus_preview_cells(self):
        table={'original':[],'custom':[]}
        build.prepare_panels(table)
        abilities={o['id']:o for o in table['custom']}
        self.assertEqual(abilities['fSta']['base'],'ASde')
        self.assertEqual(fields(abilities['fSta'])[('Asdf',1)],','.join('AS%02X'%i for i in range(1,18)))
        for player in range(8):
            tree=abilities['fT%02d'%player]
            self.assertEqual(tree['base'],'ATal')
            self.assertEqual(fields(tree)['alev'],4)
            for level in range(1,5):
                self.assertEqual(fields(tree)[('aabi',level)],'')
        for raw,cell in abilities.items():
            if raw.startswith('fV'):
                for field in ('Iagi','Iint','Istr'):
                    self.assertEqual(fields(cell)[(field,1)],0)

    def test_talent_preview_updates_only_local_ui_and_restores_shared_calc_context(self):
        overlay=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        for local_player in (0,1):
            calls=[]
            state=mocks(overlay)
            state.update(GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,Job_GetIndex=lambda u:0,
                         GetLocalPlayer=lambda:local_player,GetUnitName=lambda u:'Squire',ForsakenGearTypes='types',
                         LoadInteger=lambda h,p,c:'tree' if p==2 else 0,
                         udg_JobCount=22,udg_JobSkill={i:'skill-'+str(i) for i in range(1,6)},
                         GetUnitAbilityLevel=lambda u,a:2 if a in ('skill-1','A02F') else 0,
                         UnitAddAbility=lambda u,a:calls.append(('add',a)),
                         UnitRemoveAbility=lambda u,a:calls.append(('remove',a)),
                         BlzGetAbilityTooltip=lambda a,l:'Skill '+str(a),
                         BlzGetAbilityExtendedTooltip=lambda a,l:'Existing description',
                         BlzSetAbilityTooltip=lambda a,t,l:calls.append(('tooltip',a,t)),
                         I2S=str,IMaxBJ=max, ForsakenPanelFramesReady=True,
                         ForsakenTalentState='talents',udg_CurrentHero='previous',udg_StatCalcValue=777,
                         udg_MagicDefense={1:100},ForsakenDefenseValue='defense',ForsakenReductionValue='percent',
                         ForsakenTalentRoot='root',ForsakenTalentPoints='points',
                         ForsakenTalentIcon={i:'icon'+str(i) for i in range(12)},
                         ForsakenTalentLabel={i:'label'+str(i) for i in range(12)},
                         Forsaken_DefensePercent=lambda d:100*d/(d+50),
                         Forsaken_TalentCanPurchase=lambda k,n,r:n<3,
                         Forsaken_TalentRank=lambda u:2,ForsakenPanelOpen=True,
                         Forsaken_FindFrame=lambda n:None,ForsakenHPRegen=60.,ForsakenMPRegen=120.,
                         ForsakenStatValue={i:'stat-'+str(i) for i in range(9)},
                         LoadBoolean=lambda *a:False,ModuloInteger=lambda a,b:a%b,
                         R2SW=lambda v,w,p:format(v,'.2f'),SubString=lambda s,a,b:s[a:b],
                         BlzFrameSetText=lambda f,t:calls.append(('text',f,t)))
            runtime=execute(overlay,['Forsaken_UpdatePanels'],state)
            runtime['Forsaken_UpdatePanels']('hero')
            self.assertEqual(runtime['udg_CurrentHero'],'previous')
            self.assertEqual(runtime['udg_StatCalcValue'],777)
            self.assertEqual([a for kind,a,*_ in calls if kind=='add'],[])
            tooltip_calls=[c for c in calls if c[0]=='tooltip']
            self.assertEqual(len(tooltip_calls),0)
            if local_player==0:
                self.assertIn(('text','stat-7','100'),calls)
                self.assertIn(('text','stat-8','66.67%'),calls)
            else:
                self.assertFalse(any(c[0]=='text' for c in calls))
        self.assertNotIn('Hero_LearnSkill',functions(overlay)['Forsaken_UpdatePanels'])

    def test_gaya_keeps_its_canonical_inventory_without_native_bag(self):
        overlay=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        self.assertNotIn('gaya',functions(overlay)['Forsaken_PrepareInventories'])
        self.assertNotIn('udg_SpiritOfGaya',functions(overlay)['Forsaken_PrepareInventories'])

    def test_sparse_bag_keeps_exact_slots_and_gaps_on_job_round_trip(self):
        source=(HERE/'Forsaken-job.j').read_text()
        original=[None]*30
        for slot in (1,7,18,29): original[slot]='item-'+str(slot)
        bags={'old':original.copy(),'new':[None]*30}
        spacers=[]
        charges={i:9 for i in original if i}
        def remove(hero,item):
            bags[hero][bags[hero].index(item)]=None
        def add(hero,item):
            if None not in bags[hero]: return False
            bags[hero][bags[hero].index(None)]=item
            return True
        def create(*args):
            item='spacer-'+str(len(spacers)); spacers.append(item); return item
        def destroy(item):
            for bag in bags.values():
                if item in bag: bag[bag.index(item)]=None
        state=mocks(source)
        state.update(ForsakenSharedBag={},UnitExtendedInventorySize=lambda u:30,
                     GetUnitAbilityLevel=lambda *a:1,
                     UnitItemInEquipmentSlot=lambda *a:None,
                     UnitItemInBagSlot=lambda u,s:bags[u][s],
                     UnitRemoveItem=remove,UnitAddItem=add,CreateItem=create,RemoveItem=destroy,
                     GetItemCharges=lambda i:charges[i],SetItemCharges=lambda i,v:charges.__setitem__(i,v))
        runtime=execute(source,['Forsaken_MoveSharedItem','Forsaken_TransferSharedInventory'],state)
        for old,new in [('old','new'),('new','old')]:
            runtime['Forsaken_TransferSharedInventory'](old,new)
            self.assertEqual(bags[new],original)
            self.assertEqual(bags[old],[None]*30)
            self.assertFalse(any(runtime['ForsakenSharedBag'].values()))
        self.assertEqual(len(spacers),52)
        self.assertTrue(all(v==9 for v in charges.values()))

    def test_defense_counts_equipped_variants_but_not_gear_in_bag(self):
        original=(build.ROOT/'src/triggers/04 Combat and abilities/MagicDefense.j').read_text()
        source=build.defense_overlay(original,{'I018':{'variant':'f123'}})
        self.assertIn('LoadInteger(ForsakenDefenseTypes,0,original)',source)
        self.assertEqual(functions(source)['RegisterTriggers_MagicDefense'],functions(original)['RegisterTriggers_MagicDefense'])
        self.assertIn('Forsaken_HasDefenseItem(udg_CurrentHero',source)
        for equipped,legacy,expected in [('absorber',False,True),(None,True,True),(None,False,False)]:
            state=mocks(source)
            state.update(ForsakenDefenseTypes='types',LoadInteger=lambda *a:123,
                         UnitHasItemOfTypeBJ=lambda *a:legacy,ConvertLoadoutSlot=lambda s:s,
                         UnitItemInEquipmentSlot=lambda u,s:equipped if s==7 else None,
                         GetItemTypeId=lambda i:123 if i=='absorber' else 0)
            runtime=execute(source,['Forsaken_HasDefenseItem'],state)
            self.assertEqual(runtime['Forsaken_HasDefenseItem']('hero',18),expected)
        self.assertNotIn('UnitItemInBagSlot',functions(source)['Forsaken_HasDefenseItem'])

    def test_magic_defense_percent_matches_damage_formula(self):
        source=(HERE/'Forsaken-panels.j').read_text()
        state=mocks(source); state['I2R']=float
        from unittest.mock import patch
        import test_quest_lifecycle as harness
        expression=harness.expression
        # This helper uses real division; the quest harness defaults to integer division.
        with patch.object(harness,'expression',lambda s:expression(s).replace('//','/')):
            fn=execute(source,['Forsaken_DefensePercent'],state)['Forsaken_DefensePercent']
        for defense in (0,25,50,100,150,200,500):
            self.assertAlmostEqual(fn(defense),100*(1-50/(defense+50)))
        self.assertAlmostEqual(fn(100),66.6666666667)

    def test_talent_purchase_requires_direct_parent_and_isolates_jobs_and_players(self):
        from collections import defaultdict
        source=(HERE/'Forsaken-panels.j').read_text()
        learned=defaultdict(bool); spent=defaultdict(int)
        current={'player':0,'job':0,'packet':'5','rank':1}
        state=mocks(source)
        state.update(ForsakenTalentState='talents',udg_JobCount=22,
                     GetTriggerPlayer=lambda:current['player'],GetPlayerId=lambda p:p,
                     Player_GetHero=lambda p:'hero',Job_GetIndex=lambda u:current['job'],
                     BlzGetTriggerSyncData=lambda:current['packet'],S2I=int,ModuloInteger=lambda a,b:a%b,
                     Forsaken_TalentRank=lambda hero:current['rank'],
                     LoadBoolean=lambda h,k,n:learned[k,n],LoadInteger=lambda h,k,n:spent[k,n],
                     SaveBoolean=lambda h,k,n,v:learned.__setitem__((k,n),v),
                     SaveInteger=lambda h,k,n,v:spent.__setitem__((k,n),v))
        runtime=execute(source,['Forsaken_TalentCanPurchase','Forsaken_TalentSync'],state)
        def purchase(node):
            current['packet']=str(current['job']*100+node)
            runtime['Forsaken_TalentSync']()
        purchase(5)  # G is locked before C.
        self.assertEqual(spent[0,20],0)
        purchase(0); purchase(5)  # A cannot unlock G; row0 has only one choice.
        self.assertEqual(spent[0,20],1)
        purchase(2); self.assertFalse(learned[0,2])
        learned.clear(); spent.clear()
        purchase(2); purchase(5)
        self.assertEqual(spent[0,20],1)
        current['rank']=2; purchase(5); purchase(8)
        self.assertEqual(spent[0,20],2)
        current['rank']=3; purchase(8); purchase(11)
        self.assertEqual(spent[0,20],3)
        current['rank']=4; purchase(11); purchase(2)
        self.assertEqual(spent[0,20],4)
        self.assertTrue(all(learned[0,n] for n in (2,5,8,11)))
        current.update(player=1,job=0); purchase(5)
        self.assertEqual(spent[100,20],0)
        current.update(player=0,job=1); purchase(5)
        self.assertEqual(spent[1,20],0)
        purchase(2); purchase(5)
        self.assertEqual(spent[1,20],2)
        current['packet']='202'  # Delayed packet for another job is rejected.
        runtime['Forsaken_TalentSync']()
        self.assertFalse(learned[2,2])

    def test_regeneration_reads_live_passive_levels_equipment_and_excludes_bag(self):
        from collections import defaultdict
        source=(HERE/'Forsaken-panels.j').read_text()
        kinds={'passive':3,'gear-aura':3,'mana-ring':2,'health-gear':1}
        buffs={'passive':99,'gear-aura':99}
        cache={(30,r):k for r,k in kinds.items()}
        cache.update({(31,r):b for r,b in buffs.items()})
        cache.update({(34,0):1,(34,1):99})
        scratch=defaultdict(float); integers=defaultdict(int); booleans=defaultdict(bool)
        live={'rank':11}
        equipment={7:'shield',4:'ring',0:'hat'}
        effects={'shield':['gear-aura'],'ring':['mana-ring'],'hat':['health-gear'],'bag':['mana-ring']}
        def integer(h,p,k): return cache.get((p,k),0) if h=='types' else integers[p,k]
        def real(h,p,k): return (.05 if k==0 else .04) if h=='types' else scratch[p,k]
        def amount(effect,field,level):
            if effect=='passive': return 60. if level==10 else 120.
            if effect=='gear-aura': return 70.
            if effect=='mana-ring': return .5
            return 0.
        def flush(h,p):
            for d in (scratch,integers,booleans):
                for key in list(d):
                    if key[0]==p: del d[key]
        state=mocks(source)
        for name in set(re.findall(r'\bABILITY_[A-Z0-9_]+\b',source)):
            state.setdefault(name,name)
        state.update(ForsakenGearTypes='types',ForsakenRegenScratch='scratch',
                     ForsakenHPFlat=0.,ForsakenMPPercent=0.,ForsakenHPRegen=0.,ForsakenMPRegen=0.,
                     LoadInteger=integer,LoadReal=real,LoadBoolean=lambda h,p,k:booleans[p,k] if h=='scratch' else False,
                     SaveReal=lambda h,p,k,v:scratch.__setitem__((p,k),v),
                     SaveInteger=lambda h,p,k,v:integers.__setitem__((p,k),v),
                     SaveBoolean=lambda h,p,k,v:booleans.__setitem__((p,k),v),
                     HaveSavedReal=lambda h,p,k:(p,k) in scratch,FlushChildHashtable=flush,
                     BlzGetAbilityId=lambda a:a,BlzGetAbilityRealLevelField=amount,
                     BlzGetAbilityIntegerLevelField=lambda a,f,l:20,
                     BlzGetAbilityBooleanLevelField=lambda *a:False,
                     GetHeroStr=lambda *a:100,GetHeroInt=lambda *a:100,
                     UNIT_RF_HIT_POINTS_REGENERATION_RATE='hp',UNIT_RF_MANA_REGENERATION='mp',
                     BlzGetUnitRealField=lambda u,f:1. if f=='hp' else 2.,I2R=float,IMaxBJ=max,
                     BlzGetUnitAbilityByIndex=lambda u,i:'passive' if i==0 else None,
                     GetUnitAbilityLevel=lambda *a:live['rank'],UnitItemInSlot=lambda *a:None,
                     UnitItemInEquipmentSlot=lambda u,s:equipment.get(s),ConvertLoadoutSlot=lambda s:s,
                     BlzGetItemAbilityByIndex=lambda item,i:effects[item][i] if i<len(effects[item]) else None)
        runtime=execute(source,['Forsaken_RegenAbility','Forsaken_ReadRegeneration'],state)
        runtime['Forsaken_ReadRegeneration']('hero')
        self.assertEqual(runtime['ForsakenHPRegen'],26.)
        self.assertEqual(runtime['ForsakenMPRegen'],79.)  # (2 + 100*.04)*1.5 + strongest same-buff aura70.
        live['rank']=22
        runtime['Forsaken_ReadRegeneration']('hero')
        self.assertEqual(runtime['ForsakenMPRegen'],129.)
        equipment.clear()
        runtime['Forsaken_ReadRegeneration']('hero')
        self.assertEqual(runtime['ForsakenMPRegen'],126.)
        self.assertEqual(runtime['ForsakenHPRegen'],6.)
        self.assertNotIn('UnitItemInBagSlot',functions(source)['Forsaken_ReadRegeneration'])

    def test_panel_creation_is_independent_of_native_frame_names_and_has_twelve_buttons(self):
        from collections import defaultdict
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        state=mocks(source); frames=[]; events=[]
        for name in set(re.findall(r'\b(?:OSKEY_|ORIGIN_|FRAMEPOINT_|FRAMEEVENT_|TEXT_JUSTIFY_)[A-Z0-9_]+\b',source)):
            state.setdefault(name,name)
        def create(*args):
            frame='frame-'+str(len(frames));frames.append((frame,args));return frame
        state.update(ForsakenStatName={},ForsakenStatValue={},ForsakenTalentButton={},
                     ForsakenTalentIcon={},ForsakenTalentLabel={},Forsaken_PanelAccess=lambda:None,
                     BlzCreateFrame=create,BlzCreateFrameByType=create,ModuloInteger=lambda a,b:a%b,I2R=float,
                     BlzTriggerRegisterFrameEvent=lambda trigger,frame,event:events.append(frame))
        runtime=execute(source,['Register_Forsaken_PanelAccess'],state)
        runtime['Register_Forsaken_PanelAccess']()
        self.assertEqual(len(runtime['ForsakenTalentButton']),12)
        self.assertEqual(len(runtime['ForsakenStatValue']),9)
        self.assertTrue(set(runtime['ForsakenTalentButton'].values())<=set(events))
        self.assertNotIn('BlzGetFrameByName',functions(source)['Register_Forsaken_PanelAccess'])
        self.assertEqual(runtime['ForsakenStatName'][7],'Magic Defense')
        self.assertEqual(runtime['ForsakenStatName'][8],'Magic Defense %')


if __name__=='__main__':
    unittest.main()

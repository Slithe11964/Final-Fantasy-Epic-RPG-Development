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


def rawcode(value):
    return value


class ForsakenTests(unittest.TestCase):
    def test_penalties_update_existing_values_and_preserve_defense_status_precedence(self):
        levels={}
        runtime=self.stat_runtime(['Forsaken_StatAccuracy','Forsaken_StatDefenseMultiplier','Forsaken_StatEffectiveDefense','Forsaken_StatPenalty'],levels,
            Forsaken_Stat_GetAccuracy=lambda u:200.)
        accuracy=runtime['Forsaken_StatAccuracy']; defense=runtime['Forsaken_StatDefenseMultiplier']
        self.assertEqual(accuracy('hero'),200.)
        levels['B00P']=1;self.assertEqual(accuracy('hero'),100.)
        self.assertEqual(runtime['Forsaken_StatPenalty']('100.00',True),'|cffff4040100.00|r')
        levels['B02V']=1;self.assertEqual(accuracy('hero'),0.)
        levels.clear();levels['B003']=1;self.assertEqual(accuracy('hero'),160.)
        for physical,penalty,protect,stronger in [(True,'B06J','B007','B08R'),(False,'B06K','B005','B08S')]:
            levels.clear();levels[penalty]=1
            self.assertEqual(defense('hero',physical),1.5)
            self.assertAlmostEqual(runtime['Forsaken_StatEffectiveDefense'](80.,1.5),70.)
            levels[protect]=1;self.assertEqual(defense('hero',physical),.66666)
            levels[stronger]=1;self.assertEqual(defense('hero',physical),.5)
            levels['A0F3']=1;self.assertEqual(defense('hero',physical),.66666)
            del levels[penalty];self.assertEqual(defense('hero',physical),1.5)

    def test_element_rows_combine_equal_bonuses_and_keep_type_specific_values_honest(self):
        runtime=self.stat_runtime(['Forsaken_StatElementText','Forsaken_StatPercent'],
            Forsaken_Stat_GetElementBonus=lambda u,e,p:.5 if e==4 else 0.,R2SW=lambda n,w,d:format(n,'.'+str(d)+'f'),RAbsBJ=abs)
        self.assertEqual(runtime['Forsaken_StatElementText']('hero',4),'50.00%')
        runtime['Forsaken_Stat_GetElementBonus']=lambda u,e,p:(.1 if p else .8) if e==4 else 0.
        self.assertEqual(runtime['Forsaken_StatElementText']('hero',4),'10/80.00%')
        source=(HERE/'Forsaken-stats.j').read_text()
        for removed in ('Staff / healing power','Rod spell power','Inner Mana power','attack bonus','spell bonus','Physical buffs','Magic buffs'):
            self.assertNotIn('"'+removed+'"',source)

    def test_armory_stock_and_missing_entries_only_gain_slot_tooltips(self):
        base=build.ROOT/'release/FFERPG_0.9.7.3-r16-stageAS.w3x'
        with tempfile.TemporaryDirectory(dir=build.ROOT/'build') as folder:
            out=Path(folder)/'gear.w3x';build.prepare_objects(base,out,Path(folder)/'mapping.json')
            def units(path):
                table=read_objects(MPQ(path).read('war3map.w3u'),'w3u')
                return {o['id'] or o['base']:fields(o) for g in ('original','custom') for o in table[g]}
            before,after=units(base),units(out)
            catalog=__import__('json').loads((build.ROOT/'src/armory-hints.json').read_text())
            changed=set()
            for index,entry in catalog.items():
                slot=build.slot_for(entry,before[entry['unit']]['upoi'])
                if slot:
                    changed.update([entry['unit'],'z%03d'%int(index)])
            self.assertEqual(set(before),set(after))
            for raw,data in before.items():
                expected=dict(data)
                if raw in changed:
                    self.assertIn('Forsaken slot',after[raw]['utub'])
                    expected['utub']=after[raw]['utub']
                self.assertEqual(expected,after[raw],raw)
            self.assertEqual(len(changed),552)

    def test_regen_manifest_includes_helmet_sorcerer_inherited_ring_and_native_variants(self):
        base=build.ROOT/'release/FFERPG_0.9.7.3-r16-stageAS.w3x'
        with tempfile.TemporaryDirectory(dir=build.ROOT/'build') as folder:
            out=Path(folder)/'gear.w3x';mapping=build.prepare_objects(base,out,Path(folder)/'mapping.json')
            source='\n'.join(build.regeneration_initialization(out))
            self.assertIn("SaveReal(ForsakenRegenData,'A0OE',0,45.0)",source)
            self.assertIn("SaveReal(ForsakenRegenData,'A033',10,60.0)",source)
            self.assertIn("SaveReal(ForsakenRegenData,'A033',21,120.0)",source)
            self.assertIn("SaveReal(ForsakenRegenData,'A062',0,0.5)",source)
            for raw in ('I0FB',mapping['I0FB']['variant']):
                self.assertIn("SaveInteger(ForsakenRegenData,'%s',1001,'A0OE')"%raw,source)

    def test_regen_uses_authored_effects_when_native_handles_are_missing(self):
        from collections import defaultdict
        source=(HERE/'Forsaken-panels.j').read_text()
        cache={'types':{(30,'hat-regen'):1,(30,'mana-regen'):2,(30,'sorcerer'):3,(34,0):1,(34,1):'aura',(40,0):.05,(40,1):.04},
               'data':{(0,0):3,(0,1):'hat-regen',(0,2):'mana-regen',(0,3):'sorcerer',('hat',1000):1,('hat',1001):'hat-regen',('ring',1000):1,('ring',1001):'mana-regen',
                       ('hat-regen',0):45.,('mana-regen',0):.5,('sorcerer',10):60.,('sorcerer',21):120.,('sorcerer',210):'aura',('sorcerer',221):'aura'},
               'scratch':{}}
        equipped={0:'hat',4:'ring'};live={'rank':11}
        def get(h,p,k):return cache[h].get((p,k),0)
        state=mocks(source)
        state.update(ForsakenHPFlat=0.,ForsakenMPPercent=0.,ForsakenHPRegen=0.,ForsakenMPRegen=0.,ForsakenGearTypes='types',ForsakenRegenData='data',ForsakenRegenScratch='scratch',
            LoadInteger=get,LoadReal=get,LoadBoolean=get,HaveSavedReal=lambda h,p,k:(p,k) in cache[h],
            SaveReal=lambda h,p,k,v:cache[h].__setitem__((p,k),v),SaveInteger=lambda h,p,k,v:cache[h].__setitem__((p,k),v),SaveBoolean=lambda h,p,k,v:cache[h].__setitem__((p,k),v),
            FlushChildHashtable=lambda h,p:[cache[h].pop(key) for key in list(cache[h]) if key[0]==p],
            UnitItemInSlot=lambda u,s:None,UnitItemInEquipmentSlot=lambda u,s:equipped.get(s),ConvertLoadoutSlot=lambda s:s,GetItemTypeId=lambda i:i,
            GetHeroStr=lambda *a:100,GetHeroInt=lambda *a:100,I2R=float,IMaxBJ=max,
            UNIT_RF_HIT_POINTS_REGENERATION_RATE='hp',UNIT_RF_MANA_REGENERATION='mp',BlzGetUnitRealField=lambda u,f:11. if f=='hp' else 2.,
            BlzGetUnitAbilityByIndex=lambda *a:None,BlzGetItemAbilityByIndex=lambda *a:None,GetUnitAbilityLevel=lambda u,r:live['rank'] if r=='sorcerer' else (1 if r=='hat-regen' else 0))
        runtime=execute(source,['Forsaken_RegenEffect','Forsaken_RegenAbility','Forsaken_ReadRegeneration'],state)
        runtime['Forsaken_ReadRegeneration']('hero')
        self.assertEqual(runtime['ForsakenHPRegen'],61.)
        self.assertEqual(runtime['ForsakenMPRegen'],69.)
        live['rank']=22;runtime['Forsaken_ReadRegeneration']('hero')
        self.assertEqual(runtime['ForsakenMPRegen'],129.)
        equipped.clear();runtime['GetUnitAbilityLevel']=lambda u,r:22 if r=='sorcerer' else 0
        runtime['Forsaken_ReadRegeneration']('hero')
        self.assertEqual(runtime['ForsakenHPRegen'],16.)
        self.assertEqual(runtime['ForsakenMPRegen'],126.)

    def test_custom_controls_have_stable_anchor_and_direct_frame_dispatch(self):
        source=(HERE/'Forsaken-panels.j').read_text();inspect=(HERE/'Forsaken-inspect.j').read_text()
        self.assertIn('anchor!=ForsakenTalentAnchor',functions(source)['Forsaken_PollPanels'])
        self.assertIn('FRAMEPOINT_TOPRIGHT,anchor,FRAMEPOINT_TOPRIGHT,-.017,-.027',source)
        self.assertNotIn('BlzGetTriggerPlayerKey',functions(source)['Forsaken_PanelClick'])
        self.assertNotIn('GetTriggerUnit',functions(source)['Forsaken_PanelClick'])
        for frame in ('ForsakenTalentToggle','ForsakenPanelClose','ForsakenStatsNext'):
            self.assertIn('gg_trg_Forsaken_TalentClick,'+frame+',FRAMEEVENT_CONTROL_CLICK',source)
        self.assertIn('gg_trg_Forsaken_TalentClick,ForsakenInspectButton,FRAMEEVENT_CONTROL_CLICK',inspect)
        self.assertIn('ForsakenInspectButton,60',inspect)
        self.assertIn('FRAMEPOINT_TOPRIGHT,0,.024',inspect)

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
                if filename not in ('war3map.w3t', 'war3map.w3u', 'war3map.w3a', 'war3map.w3i','war3map.imp','(listfile)','(attributes)'):
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
                expected=original.copy()
                if raw in mapping and mapping[raw]['slot']!='Inventory':
                    expected['utub']=build.slot_tooltip(original.get('utub',''),mapping[raw]['slot'])
                self.assertEqual(expected, after[raw], raw)
                if raw in mapping and mapping[raw]['slot']!='Inventory':
                    updated = after[mapping[raw]['variant']].copy()
                    self.assertEqual(updated.pop('iequ'), mapping[raw]['slot'])
                    self.assertEqual(expected, updated, raw)
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
            state.update(EVENT_PLAYER_UNIT_PICKUP_ITEM='pickup', GetTriggerEventId=lambda:'equip', ForsakenEquippedItem=None, GetTriggerUnit=lambda:'hero', GetOwningPlayer=lambda u:0,
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

    def test_backpack_is_only_an_ability_and_automatic_equipping_is_disabled(self):
        overlay = build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text(encoding='utf-8'))
        self.assertNotIn('fBpk',overlay)
        self.assertNotIn('Forsaken_ConvertCarriedGear',functions(overlay)['Forsaken_PrepareInventories'])
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
                         ForsakenTalentRoot='root',ForsakenTalentPoints='points',ForsakenNPCSummary='npc-summary',ForsakenTalentLink={i:i for i in range(9)},
                         ForsakenTalentIcon={i:'icon'+str(i) for i in range(12)},
                         ForsakenTalentLabel={i:'label'+str(i) for i in range(12)},
                         Forsaken_DefensePercent=lambda d:100*d/(d+50),
                         Forsaken_TalentCanPurchase=lambda k,n,r:n<3,
                         Forsaken_TalentRank=lambda u:2,ForsakenPanelOpen=True,ForsakenInspectTarget=None,ForsakenPanelNeedsRefresh=False,ForsakenTalentButton={i:i for i in range(12)},ForsakenHeroHPRegen={},ForsakenHeroMPRegen={},
                         Forsaken_FindFrame=lambda n:None,ForsakenHPRegen=60.,ForsakenMPRegen=120.,
                         Forsaken_RenderStats=lambda u:calls.append(('stats',u)),
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
                self.assertIn(('stats','hero'),calls)
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
        def integer(h,p,k): return cache.get((p,k),0) if h=='types' else (integers[p,k] if h=='scratch' else 0)
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
        state.update(ForsakenGearTypes='types',ForsakenRegenScratch='scratch',ForsakenRegenData='data',
                     ForsakenHPFlat=0.,ForsakenMPPercent=0.,ForsakenHPRegen=0.,ForsakenMPRegen=0.,
                     LoadInteger=integer,LoadReal=real,LoadBoolean=lambda h,p,k:booleans[p,k] if h=='scratch' else False,
                     SaveReal=lambda h,p,k,v:scratch.__setitem__((p,k),v),
                     SaveInteger=lambda h,p,k,v:integers.__setitem__((p,k),v),
                     SaveBoolean=lambda h,p,k,v:booleans.__setitem__((p,k),v),
                     HaveSavedReal=lambda h,p,k:h=='scratch' and (p,k) in scratch,FlushChildHashtable=flush,
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
        runtime=execute(source,['Forsaken_RegenEffect','Forsaken_RegenAbility','Forsaken_ReadRegeneration'],state)
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
        for name in set(re.findall(r'\b(?:EVENT_PLAYER_UNIT_|OSKEY_|ORIGIN_|FRAMEPOINT_|FRAMEEVENT_|TEXT_JUSTIFY_)[A-Z0-9_]+\b',source)):
            state.setdefault(name,name)
        def create(*args):
            frame='frame-'+str(len(frames));frames.append((frame,args));return frame
        state.update(ForsakenTalentRoot=None,ForsakenStatsNext=None,ForsakenStatsHeading=None,
                     ForsakenStatName={},ForsakenStatValue={},ForsakenStatLabel={},ForsakenTalentButton={},
                     ForsakenTalentIcon={},ForsakenTalentLabel={},ForsakenTalentLink={},Forsaken_PanelAccess=lambda:None,Forsaken_PollPanels=lambda:None,
                     BlzCreateFrame=create,BlzCreateFrameByType=create,ModuloInteger=lambda a,b:a%b,I2R=float,
                     BlzTriggerRegisterFrameEvent=lambda trigger,frame,event:events.append(frame))
        runtime=execute(source,['Register_Forsaken_PanelAccess'],state)
        runtime['Register_Forsaken_PanelAccess']()
        self.assertEqual(len(runtime['ForsakenTalentButton']),12)
        self.assertEqual(len(runtime['ForsakenStatValue']),12)
        self.assertTrue(set(runtime['ForsakenTalentButton'].values())<=set(events))
        self.assertNotIn('BlzGetFrameByName',functions(source)['Register_Forsaken_PanelAccess'])
        self.assertEqual(runtime['ForsakenStatName'][3],'Water')
        self.assertIn(runtime['ForsakenStatsNext'],events)


    def stat_runtime(self, names, abilities=None, **extra):
        from unittest.mock import patch
        import test_quest_lifecycle as harness
        original=harness.expression
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        levels=abilities if abilities is not None else {}
        state=mocks(source)
        state.update(Forsaken_StatAbilityLevel=lambda u,raw:levels.get(raw,0),
                     GetHeroAgi=lambda *a:200,I2R=float,
                     RMinBJ=min,RMaxBJ=max,Pow=pow,
                     Prof_GetLevel=lambda *a:10,
                     IsUnitInGroup=lambda *a:False,
                     LoadInteger=lambda *a:0,LoadReal=lambda *a:.02,
                     GetUnitState=lambda u,kind:100.,
                     UNIT_STATE_LIFE=0,UNIT_STATE_MAX_LIFE=1,
                     GAME_STATE_TIME_OF_DAY=0,GetFloatGameState=lambda *a:12.,
                     ForsakenGearTypes='gear',udg_RunicHash='runic',udg_DefendingUnits='defenders')
        state.update(extra)
        with patch.object(harness,'expression',lambda e:original(e).replace('//','/')):
            return execute(source,names,state)

    def test_cooldown_buff_priority_and_live_changes(self):
        levels={}
        runtime=self.stat_runtime(['Forsaken_StatCooldown'],levels,Player_GetHero=lambda p:'hero',IsPlayerInForce=lambda *a:True,udg_PlayingPlayers='playing')
        fn=runtime['Forsaken_StatCooldown']
        self.assertAlmostEqual(fn('hero'),100*(1-1000/1200))
        levels[rawcode('B00F')]=1
        self.assertAlmostEqual(fn('hero'),37.5)
        levels[rawcode('B08T')]=1
        levels[rawcode('Bslo')]=1
        self.assertAlmostEqual(fn('hero'),100*(1-1000/1200*.67))
        levels[rawcode('A1C3')]=1
        levels[rawcode('A18K')]=1
        self.assertAlmostEqual(fn('hero'),100*(1-1000/1200*.67*.7*.8))
        levels.clear();levels[rawcode('B08Y')]=1
        self.assertAlmostEqual(fn('hero'),-25.)
        levels.clear();self.assertAlmostEqual(fn('npc'),0.)
        levels[rawcode('B00F')]=1;self.assertAlmostEqual(fn('npc'),25.)

    def test_block_combines_without_rolling_and_sword_fallback(self):
        levels={rawcode('A05F'):1,rawcode('A0S6'):1}
        runtime=self.stat_runtime(['Forsaken_StatBlockRoll','Forsaken_StatBlock'],levels)
        self.assertAlmostEqual(runtime['Forsaken_StatBlock']('hero',True),52.)
        self.assertAlmostEqual(runtime['Forsaken_StatBlock']('hero',False),100*(.2+.8*.2*.52))
        levels[rawcode('A0PP')]=1
        self.assertAlmostEqual(runtime['Forsaken_StatBlock']('hero',True),61.6)

    def test_element_bonus_and_resistance_do_not_roll_absorption(self):
        levels={rawcode('A19V'):1,rawcode('A0PM'):1}
        arrays={name:{i:0 for i in range(1,8)} for name in ['udg_ElementAttackAbil',
            'udg_ElementKnowledgeAbil','udg_ElementBoostAbil','udg_ElementSpellAmpAbil',
            'udg_ElementOrbAmpAbil','udg_ElementEnchantBuff','udg_ElementWeaknessAbil',
            'udg_ElementResistAbil','udg_ElementImmunityAbil','udg_ElementAbsorbAbil']}
        arrays['udg_ElementKnowledgeAbil'][4]=rawcode('A19V')
        arrays['udg_ElementAbsorbAbil'][4]=rawcode('A0T2')
        runtime=self.stat_runtime(['Forsaken_Stat_GetElementBonus','Forsaken_Stat_GetElementResist','Forsaken_StatResistance'],levels,**arrays)
        self.assertEqual(runtime['Forsaken_Stat_GetElementBonus']('hero',4,False),.5)
        self.assertEqual(runtime['Forsaken_StatResistance']('hero',4),'0%')
        levels[rawcode('A0T2')]=1
        self.assertEqual(runtime['Forsaken_StatResistance']('hero',4),'Absorb')
        levels[rawcode('B057')]=1
        self.assertEqual(runtime['Forsaken_StatResistance']('hero',4),'Immune')
        self.assertNotIn('GetRandom',build.combat_stat_helpers())

    def test_healing_and_armor_use_actual_stacking(self):
        levels={rawcode('B076'):1,rawcode('B07D'):1,
                rawcode('B070'):1,rawcode('A13R'):1}
        runtime=self.stat_runtime(['Forsaken_StatHealing','Forsaken_StatHealingReceived','Forsaken_StatArmorDefense'],levels)
        self.assertAlmostEqual(runtime['Forsaken_StatHealing']('hero',False),300.)
        self.assertAlmostEqual(runtime['Forsaken_StatHealing']('hero',True),100.)
        self.assertAlmostEqual(runtime['Forsaken_StatHealingReceived']('hero'),5.)
        self.assertAlmostEqual(runtime['Forsaken_StatArmorDefense'](100.),100*2/3)
        self.assertAlmostEqual(runtime['Forsaken_StatArmorDefense'](-10.),100*(.98**10-1))

    def test_stat_query_uses_only_active_gear_and_current_unit_level(self):
        items={2:'quick',6:'equipped'}
        abilities={'quick':[11], 'equipped':[22]}
        runtime=self.stat_runtime(['Forsaken_StatAbilityLevel'],
            GetUnitAbilityLevel=lambda hero,raw:3 if raw==33 else 0,
            UnitItemInSlot=lambda hero,slot:items.get(slot),
            UnitItemInEquipmentSlot=lambda hero,slot:items.get(slot+6),ConvertLoadoutSlot=lambda i:i,
            BlzGetItemAbilityByIndex=lambda item,i:abilities.get(item,[])[i] if i<len(abilities.get(item,[])) else None,
            BlzGetAbilityId=lambda a:a)
        fn=runtime['Forsaken_StatAbilityLevel']
        self.assertEqual(fn('hero',11),1)
        self.assertEqual(fn('hero',22),1)
        self.assertEqual(fn('hero',33),3)
        self.assertEqual(fn('hero',44),0)
        self.assertNotIn('UnitItemInBagSlot',functions(build.combat_stat_helpers())['Forsaken_StatAbilityLevel'])

    def test_panel_geometry_keeps_content_inside_gold_border(self):
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        state=mocks(source); frames=[]; points={};sizes={}
        for name in set(re.findall(r'\b(?:EVENT_PLAYER_UNIT_|OSKEY_|ORIGIN_|FRAMEPOINT_|FRAMEEVENT_|TEXT_JUSTIFY_)[A-Z0-9_]+\b',source)):
            state.setdefault(name,name)
        def create(*args):
            frame='frame-'+str(len(frames));frames.append((frame,args));return frame
        state.update(ForsakenTalentRoot=None,ForsakenStatsNext=None,ForsakenStatsHeading=None,
                     ForsakenStatName={},ForsakenStatValue={},ForsakenStatLabel={},ForsakenTalentButton={},
                     ForsakenTalentIcon={},ForsakenTalentLabel={},ForsakenTalentLink={},Forsaken_PanelAccess=lambda:None,Forsaken_PollPanels=lambda:None,
                     BlzCreateFrame=create,BlzCreateFrameByType=create,ModuloInteger=lambda a,b:a%b,I2R=float,
                     BlzFrameSetPoint=lambda f,p,a,ap,x,y:points.update({f:(p,a,x,y)}),
                     BlzFrameSetSize=lambda f,w,h:sizes.update({f:(w,h)}))
        runtime=execute(source,['Register_Forsaken_PanelAccess'],state)
        runtime['Register_Forsaken_PanelAccess']()
        root=runtime['ForsakenTalentRoot'];width,height=sizes[root]
        for frame,(point,anchor,x,y) in points.items():
            if anchor!=root:continue
            w,h=sizes[frame]
            if point=='FRAMEPOINT_TOPLEFT': left=x
            elif point=='FRAMEPOINT_TOPRIGHT':left=width+x-w
            else:left=(width-w)/2+x
            self.assertGreaterEqual(left,.022-1e-8)
            self.assertLessEqual(left+w,width-.022+1e-8)
            self.assertGreaterEqual(-y,.022-1e-8)
            self.assertLessEqual(-y+h,height-.022+1e-8)


    def panel_runtime(self):
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        control={'event':'frame','frame':None,'selected':'self','visible':False,'key':None}
        calls=[];state=mocks(source)
        state.update(ForsakenInspectTarget=None,ForsakenSelectedTarget=None,ForsakenPanelOpen=False,
            ForsakenPanelNeedsRefresh=False,ForsakenBackpackWasVisible=False,ForsakenStatsPage=0,
            ForsakenInspectRoot='inspect-root',ForsakenInspectButton='inspect',ForsakenInspectClose='inspect-close',
            ForsakenTalentToggle='talent-toggle',ForsakenBoardToggle='board-toggle',
            ForsakenBoardCovered=False,ForsakenTalentAnchor=None,udg_ScoreBoard='board',
            FRAMEPOINT_TOPLEFT='top-left',FRAMEPOINT_TOPRIGHT='top-right',
            MultiboardDisplay=lambda b,v:calls.append(('board',v)),
            ForsakenEquipButton='equip',ForsakenPanelClose='close',ForsakenTalentRoot='talents',ForsakenStatsNext='next',
            EVENT_PLAYER_UNIT_SELECTED='selected',EVENT_PLAYER_UNIT_DESELECTED='deselected',OSKEY_ESCAPE='escape',
            GetTriggerEventId=lambda:control['event'],GetTriggerUnit=lambda:control['selected'],
            GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:0,
            Player_GetHero=lambda p:{0:'self',1:'other',2:'third'}.get(p),
            GetOwningPlayer=lambda u:{'self':0,'other':1,'third':2,'npc':8}.get(u,8),
            UNIT_TYPE_STRUCTURE='building',UNIT_TYPE_HERO='hero',udg_BossGroup='bosses',
            IsUnitType=lambda u,t:(t=='hero' and u in ('self','other','third')) or (t=='building' and u=='house'),
            IsUnitInGroup=lambda u,g:u=='boss',
            GetPlayerId=lambda p:p,IsUnitVisible=lambda *a:True,GetUnitTypeId=lambda u:1,IsUnitHidden=lambda u:False,
            IsUnitSelected=lambda u,p:u==control['selected'],
            BlzGetTriggerPlayerKey=lambda:control['key'],BlzGetTriggerFrame=lambda:control['frame'],
            Forsaken_FindFrame=lambda n:'native',BlzFrameIsVisible=lambda f:control['visible'],
            Forsaken_RenderInspection=lambda u:calls.append(('inspect',u)),
            Forsaken_RenderStats=lambda u:calls.append(('stats',u)),ModuloInteger=lambda a,b:a%b,
            BlzSendSyncData=lambda *a:calls.append(('sync',)+a),
            BlzFrameSetVisible=lambda f,v:calls.append(('visible',f,v)))
        runtime=execute(source,['Forsaken_CanInspect','Forsaken_PanelAccess','Forsaken_PanelClick','Forsaken_PollPanels'],state)
        access=runtime['Forsaken_PanelAccess']
        runtime['Forsaken_PanelAccess']=lambda:runtime['Forsaken_PanelClick']() if control['event']=='frame' and control['frame'] in ('inspect','inspect-close','talent-toggle','close','next') else access()
        return runtime,control,calls

    def test_backpack_open_edges_restore_talents_but_close_does_not_reopen_them(self):
        runtime,c,calls=self.panel_runtime()
        poll=runtime['Forsaken_PollPanels'];access=runtime['Forsaken_PanelAccess']
        poll();self.assertFalse(runtime['ForsakenPanelOpen'])
        c['visible']=True;poll();self.assertTrue(runtime['ForsakenPanelOpen'])
        c['frame']='close';access();poll();poll()
        self.assertFalse(runtime['ForsakenPanelOpen'])
        self.assertEqual(runtime['ForsakenInspectTarget'],None)
        c['visible']=False;poll();c['visible']=True;poll()
        self.assertTrue(runtime['ForsakenPanelOpen'])
        self.assertFalse(any(a[0]=='sync' for a in calls))

    def test_talents_toggle_reopens_custom_panel_without_closing_native_backpack(self):
        runtime,c,calls=self.panel_runtime()
        c['visible']=True;runtime['Forsaken_PollPanels']()
        c['frame']='talent-toggle';runtime['Forsaken_PanelAccess']();runtime['Forsaken_PollPanels']()
        self.assertFalse(runtime['ForsakenPanelOpen'])
        self.assertTrue(c['visible'])
        runtime['Forsaken_PanelAccess']();runtime['Forsaken_PollPanels']()
        self.assertTrue(runtime['ForsakenPanelOpen'])
        self.assertFalse(any(a[0]=='sync' for a in calls))

    def test_board_hides_entirely_during_backpack_without_manual_button(self):
        runtime,c,calls=self.panel_runtime()
        poll=runtime['Forsaken_PollPanels'];access=runtime['Forsaken_PanelAccess']
        poll();self.assertIn(('board',True),calls)
        c['visible']=True;poll();self.assertEqual([a for a in calls if a[0]=='board'][-1],('board',False))
        c['visible']=False;poll();self.assertEqual([a for a in calls if a[0]=='board'][-1],('board',True))
        board=(build.ROOT/'src/triggers/09 Player features/Multiboard.j').read_text()
        overlay=build.multiboard_overlay(board)
        self.assertNotIn('call MultiboardDisplay(udg_ScoreBoard,true)',overlay)
        self.assertIn('not ForsakenBoardCovered',overlay)
        self.assertNotIn('ForsakenBoardToggle',source if False else (HERE/'Forsaken-panels.j').read_text())
        self.assertNotIn('ForsakenBoardHidden',board)
        inspect=(HERE/'Forsaken-inspect.j').read_text()
        self.assertIn('BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON,3),FRAMEPOINT_TOPRIGHT',inspect)

    def test_inspection_selects_current_other_hero_and_keeps_gear_when_talents_close(self):
        runtime,c,calls=self.panel_runtime();access=runtime['Forsaken_PanelAccess'];poll=runtime['Forsaken_PollPanels']
        c.update(event='selected',selected='other');access()
        self.assertIn(('visible','inspect',True),calls)
        c.update(event='frame',frame='inspect');access()
        self.assertEqual(runtime['ForsakenInspectTarget'],'other')
        self.assertIn(('inspect','other'),calls)
        self.assertTrue(runtime['ForsakenPanelNeedsRefresh'])
        c['frame']='close';access();poll()
        self.assertEqual(runtime['ForsakenInspectTarget'],'other')
        self.assertFalse(runtime['ForsakenPanelOpen'])
        self.assertNotEqual(calls[-1],('visible','inspect-root',False))
        c['frame']='next';access();self.assertIn(('stats','other'),calls)
        c['frame']='equip';access()
        self.assertFalse(any(a[0]=='sync' for a in calls))
        c.update(event='selected',selected='npc');access();poll()
        self.assertIsNone(runtime['ForsakenInspectTarget'])
        self.assertIn(('visible','inspect',True),calls)

    def test_inspection_is_limited_to_visible_other_players_current_hero(self):
        runtime,c,calls=self.panel_runtime();fn=runtime['Forsaken_CanInspect']
        self.assertTrue(fn('other',0))
        self.assertFalse(fn('npc',0))
        self.assertFalse(fn('house',0))
        self.assertTrue(fn('boss',0))
        for hero in ['self',None]:self.assertFalse(fn(hero,0))
        runtime['IsUnitVisible']=lambda *a:False
        self.assertFalse(fn('other',0))
        runtime['IsUnitVisible']=lambda *a:True
        runtime['Player_GetHero']=lambda *a:'new-job'
        self.assertTrue(fn('other',0))
        runtime['IsUnitHidden']=lambda u:True
        self.assertFalse(fn('npc',0))
        runtime['IsUnitHidden']=lambda u:False
        runtime['GetUnitTypeId']=lambda u:0
        self.assertFalse(fn('npc',0))

    def test_no_equip_button_or_sync_request_and_automatic_preparation_never_equips(self):
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        self.assertNotIn('ForsakenEquipButton',source)
        self.assertNotIn('FFERPGEQUIP',source)
        self.assertIn('Forsaken_PrepareQuickGear(holder)',functions(source)['Forsaken_EnableHero'])
        self.assertNotIn('UnitEquipItem',functions(source)['Forsaken_PrepareQuickGear'])
        self.assertNotIn('Forsaken_ConvertCarriedGear',functions(source)['Forsaken_PrepareInventories'])

    def test_inspect_talent_click_cannot_send_a_purchase(self):
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        calls=[];state=mocks(source)
        state.update(ForsakenInspectTarget='other',ForsakenTalentButton={i:i for i in range(12)},
            Player_GetHero=lambda *a:'self',GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,
            BlzGetTriggerFrame=lambda:0,BlzSendSyncData=lambda *a:calls.append(a))
        execute(source,['Forsaken_TalentClick'],state)['Forsaken_TalentClick']()
        self.assertEqual(calls,[])

    def test_inspection_reads_all_nine_gear_and_thirty_bag_slots_without_mutating_items(self):
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        seen=[];tips={};state=mocks(source)
        def equipped(u,slot):seen.append(('gear',u,slot));return 'ring' if slot==5 else None
        def bagged(u,slot):seen.append(('bag',u,slot));return 'nectar' if slot==29 else None
        state.update(ForsakenInspectTitle='title',ForsakenInspectBagLabel='bag-heading',UnitExtendedInventorySize=lambda u:30,ForsakenInspectIcon={i:i for i in range(39)},
            ForsakenInspectItemText={i:i for i in range(39)},ForsakenInspectSlotName={i:'gear'+str(i) for i in range(9)},
            I2S=str,GetPlayerName=lambda p:'Other',GetOwningPlayer=lambda u:1,GetUnitName=lambda u:'Sorcerer',GetHeroLevel=lambda u:99,GetUnitLevel=lambda u:99,
            UnitItemInEquipmentSlot=equipped,UnitItemInBagSlot=bagged,ConvertLoadoutSlot=lambda i:i,
            GetItemName=lambda i:i,BlzGetItemExtendedTooltip=lambda i:'Details',BlzGetItemIconPath=lambda i:'icon-'+i,
            GetItemCharges=lambda i:3,BlzFrameSetText=lambda f,t:tips.update({f:t}))
        runtime=execute(source,['Forsaken_RenderInspection'],state)
        runtime['Forsaken_RenderInspection']('other')
        self.assertEqual([s for kind,u,s in seen if kind=='gear'],list(range(9)))
        self.assertEqual([s for kind,u,s in seen if kind=='bag'],list(range(30)))
        self.assertTrue(all(u=='other' for kind,u,s in seen))
        self.assertIn('nectar',tips[38]);self.assertIn('Charges: 3',tips[38])
        seen.clear()
        runtime['UnitExtendedInventorySize']=lambda u:0
        def quick(u,slot):seen.append(('quick',u,slot));return 'axe' if slot==0 else None
        runtime['UnitItemInSlot']=quick
        runtime['Forsaken_RenderInspection']('npc')
        self.assertEqual([s for kind,u,s in seen if kind=='quick'],list(range(6)))
        self.assertFalse(any(kind=='bag' for kind,u,s in seen))
        self.assertIn('axe',tips[9]);self.assertIn('Inventory slot 1',tips[9])
        self.assertEqual(tips[38],'No backpack|nEmpty')
        for forbidden in ['UnitAddItem','UnitRemoveItem','UnitEquipItem','UnitUnequipItem','SaveInteger','BlzSendSyncData']:
            self.assertNotIn(forbidden,functions(source)['Forsaken_RenderInspection'])

    def test_inspection_frame_has_39_hover_slots_and_only_explicit_action_buttons(self):
        source=build.equip_overlay((build.ROOT/'src/triggers/05 Items crafting and shops/Equip.j').read_text())
        state=mocks(source);frames=[];events=[]
        for name in set(re.findall(r'\b(?:OSKEY_|ORIGIN_|FRAMEPOINT_|FRAMEEVENT_|TEXT_JUSTIFY_)[A-Z0-9_]+\b',source)):
            state.setdefault(name,name)
        def create(*args):frame='frame-'+str(len(frames));frames.append((frame,args));return frame
        state.update(ForsakenInspectIcon={},ForsakenInspectItemText={},ForsakenInspectSlotName={},
            ForsakenInspectButton=None,ForsakenInspectClose=None,ForsakenEquipButton=None,
            BlzCreateFrame=create,BlzCreateFrameByType=create,ModuloInteger=lambda a,b:a%b,I2R=float,
            gg_trg_Forsaken_PanelAccess='trigger',BlzTriggerRegisterFrameEvent=lambda t,f,e:events.append(f))
        runtime=execute(source,['Forsaken_CreateInspection'],state);runtime['Forsaken_CreateInspection']()
        self.assertEqual(len(runtime['ForsakenInspectIcon']),39)
        self.assertEqual(len(runtime['ForsakenInspectItemText']),39)
        self.assertEqual(set(events),{runtime['ForsakenInspectButton'],runtime['ForsakenInspectClose']})


    def test_conversion_tracks_real_handles_in_quick_or_bag_and_cleans_rejection_without_retries(self):
        source=(HERE/'Forsaken-extra.j').read_text()
        self.assertNotIn('UnitAddItemToSlotById',functions(source)['Forsaken_PrepareQuickGear'])
        for destination in ['quick','bag','rejected']:
            quick={0:'potion',3:'original',5:'native'};bag={}
            types={'original':100,'replacement':200,'potion':1,'native':200}
            charges={'original':7};tags={'original':321};life={'original':40.};owners={'original':3}
            deleted=[];created=[];failed=set();equips=[]
            state=mocks(source)
            def remove(holder,item):
                for inventory in [quick,bag]:
                    for slot in list(inventory):
                        if inventory[slot]==item:del inventory[slot]
            def create(raw,x,y):created.append('replacement');return 'replacement'
            def add(holder,item):
                # Native routing may accept into the bag instead of the requested legacy position.
                if item=='original' or destination=='quick':quick[3]=item
                elif destination=='bag':bag[0]=item
                return destination!='rejected'
            def delete(item):deleted.append(item);remove('hero',item)
            state.update(ForsakenGearTypes='gear',ForsakenConvertingGear=False,
                UnitItemInSlot=lambda h,s:quick.get(s),UnitItemInBagSlot=lambda h,s:bag.get(s),
                UnitExtendedInventorySize=lambda h:30,GetItemTypeId=lambda i:types.get(i,0),
                LoadInteger=lambda h,p,r:200 if r==100 else 0,GetHandleId=lambda i:i,
                LoadBoolean=lambda h,p,i:i in failed,SaveBoolean=lambda h,p,i,v:failed.add(i),
                RemoveSavedBoolean=lambda h,p,i:failed.discard(i),
                GetItemCharges=lambda i:charges.get(i,0),GetItemUserData=lambda i:tags.get(i,0),
                GetWidgetLife=lambda i:life.get(i,0),SetWidgetLife=lambda i,v:life.update({i:v}),
                GetItemPlayer=lambda i:owners.get(i),SetItemPlayer=lambda i,v,c:owners.update({i:v}),
                UnitRemoveItem=remove,CreateItem=create,UnitAddItem=add,GetUnitX=lambda h:0.,GetUnitY=lambda h:0.,
                SetItemCharges=lambda i,v:charges.update({i:v}),SetItemUserData=lambda i,v:tags.update({i:v}),
                RemoveItem=delete,UnitEquipItem=lambda *a:equips.append(a))
            runtime=execute(source,['Forsaken_HoldsItem','Forsaken_PrepareQuickGear'],state)
            for _ in range(100):runtime['Forsaken_PrepareQuickGear']('hero')
            self.assertEqual(created,['replacement'])
            self.assertEqual(deleted,['replacement'] if destination=='rejected' else ['original'])
            self.assertEqual(equips,[])
            self.assertFalse(runtime['ForsakenConvertingGear'])
            self.assertEqual(quick[0],'potion');self.assertEqual(quick[5],'native')
            if destination=='rejected':
                self.assertEqual(quick[3],'original');self.assertEqual(charges['original'],7)
            else:
                self.assertNotIn('original',quick.values())
                self.assertEqual(charges['replacement'],7);self.assertEqual(tags['replacement'],321)
                self.assertEqual(life['replacement'],40.);self.assertEqual(owners['replacement'],3)
                self.assertEqual(bag.get(0) if destination=='bag' else quick.get(3),'replacement')
            runtime['ForsakenConvertingGear']=True
            runtime['Forsaken_PrepareQuickGear']('hero')
            self.assertEqual(created,['replacement'])

    def test_forsaken_tooltips_put_slot_immediately_after_required_level(self):
        original='Bonuses|n|cffffcc00Required level|r: 45|nExisting footer'
        for slot,label in build.SLOT_LABELS.items():
            updated=build.slot_tooltip(original,slot)
            self.assertEqual(updated.split('|n')[2],'|cffffcc00Forsaken slot|r: '+label)
            self.assertEqual(updated.replace('|n|cffffcc00Forsaken slot|r: '+label,''),original)
        self.assertEqual(build.slot_tooltip('No level','Head'),'No level|n|cffffcc00Forsaken slot|r: Helm')
        source=(HERE/'Forsaken-extra.j').read_text()
        self.assertIn('EVENT_PLAYER_UNIT_PICKUP_ITEM',functions(source)['Register_Forsaken_Equipment'])
        self.assertIn('Forsaken_PrepareQuickGear(holder)',functions(source)['Forsaken_OnEquip'])

    def test_npc_inspection_refreshes_locally_without_granting_abilities_or_talents(self):
        runtime,c,calls=self.panel_runtime()
        runtime['Forsaken_RenderNPC']=lambda u:calls.append(('boss',u))
        c.update(event='selected',selected='boss');runtime['Forsaken_PanelAccess']()
        c.update(event='frame',frame='inspect');runtime['Forsaken_PanelAccess']();runtime['Forsaken_PollPanels']()
        self.assertIn(('boss','boss'),calls)
        source=(HERE/'Forsaken-panels.j').read_text();body=functions(source)['Forsaken_RenderNPC']
        for forbidden in ['UnitAddAbility','UnitAddItem','SaveBoolean','Forsaken_ReadRegeneration','Trig_MagicDefense']:
            self.assertNotIn(forbidden,body)
        self.assertIn('No FF job talents',body)
        stats=functions((HERE/'Forsaken-stats.j').read_text())['Forsaken_RenderStats']
        npc=stats[stats.index('        else'):stats.index('        call Forsaken_StatRow(4')]
        self.assertNotIn('udg_MagicDefense',npc)
        self.assertNotIn('ForsakenHeroHPRegen',npc)
        self.assertIn('Native armor',npc)


if __name__=='__main__':
    unittest.main()

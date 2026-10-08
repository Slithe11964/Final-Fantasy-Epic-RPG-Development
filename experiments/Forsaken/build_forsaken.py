"""Build an isolated 3.0 gear preview; canonical sources and release maps stay intact."""
import argparse
import copy
import hashlib
import json
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'tools'))
from mpq import MPQ, write_files
from objdata import read_objects, write_objects, fields
from armory_catalog import set_field


def game_data_version_offset(info):
    """Locate only the expansion selector; preserve every other map-info byte."""
    version = struct.unpack_from('<i', info)[0]
    if version not in (31, 32, 33, 39):
        raise ValueError('unsupported experimental map-info format: ' + str(version))
    offset = 28
    def strings(count):
        nonlocal offset
        for _ in range(count):
            offset = info.index(b'\0', offset) + 1
    strings(4)
    offset += 65 + (4 if version == 39 else 0)  # Bounds/loading index and v39 race HUD.
    strings(4)
    offset += 4  # Data set, distinct from expansion version.
    strings(4)
    offset += 20 + (24 if version == 39 else 0) + 4  # Fog, v39 height fog, weather.
    strings(1)
    offset += 5 + 8  # Light/water tint, script language and supported graphics modes.
    value = struct.unpack_from('<i', info, offset)[0]
    if value not in (0, 1, 2):
        raise ValueError('unexpected game data version: ' + str(value))
    return offset


def forsaken_map_info(info):
    offset = game_data_version_offset(info)
    updated = bytearray(info)
    struct.pack_into('<i', updated, offset, 2)
    return bytes(updated)


def slot_for(entry, category):
    if category == 8:
        return None
    if entry['name'] == 'Firefly':
        return 'Ring'
    if category in (28, 29):
        return 'Head'
    if category in (30, 31, 32):
        return 'Chest'
    if category in (24, 25, 26, 27, 38, 40):
        return 'Offhand'
    if category in (33, 34, 35, 36, 37, 39):
        name = entry['name'].lower()
        if any(word in name for word in ('boots', 'shoes', 'jackboots')):
            return 'Boots'
        if any(word in name for word in ('gloves', 'bracers', 'armguard')):
            return 'Gloves'
        if 'ring' in name.split():
            return 'Ring'
        return 'Trinket'
    if category in (7, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23):
        return 'Primary'
    raise ValueError('unreviewed armory category ' + str(category))


SLOT_LABELS = dict(Head='Helm', Chest='Chest', Gloves='Gloves', Boots='Boots',
                   Ring='Ring', Primary='Weapon', Offhand='Offhand', Trinket='Trinket')


def slot_tooltip(tooltip, slot):
    line = '|cffffcc00Forsaken slot|r: ' + SLOT_LABELS[slot]
    lines = tooltip.split('|n')
    for index, text in enumerate(lines):
        plain = re.sub(r'\|c[0-9a-fA-F]{8}|\|r', '', text)
        if re.search(r'required level|level requirement', plain, re.I):
            lines.insert(index + 1, line)
            return '|n'.join(lines)
    return tooltip + ('|n' if tooltip else '') + line


def prepare_objects(base, out, mapping_out):
    archive = MPQ(str(base))
    unit_table = read_objects(archive.read('war3map.w3u'), 'w3u')
    units = {o['id'] or o['base']: fields(o) for g in ('original', 'custom') for o in unit_table[g]}
    table = read_objects(archive.read('war3map.w3t'), 'w3t')
    items = {o['id'] or o['base']: o for g in ('original', 'custom') for o in table[g]}
    catalog = json.loads((ROOT / 'src/armory-hints.json').read_text(encoding='utf-8'))
    mapping = {}
    if 'fGap' in items:
        raise ValueError('reserved bag spacer ID already used')
    table['custom'].append(dict(base='ratf',id='fGap',sets=[dict(flag=0,mods=[
        dict(field=key,type=kind,value=value,end=0) for key,kind,value in
        [('unam',3,'Temporary bag spacer'),('iabi',3,''),('icla',3,'Miscellaneous'),
         ('ipow',0,0),('iuse',0,0),('idro',0,0),('igol',0,0)]])]))
    unit_objects={o["id"] or o["base"]:o for g in ("original","custom") for o in unit_table[g]}
    for number, (save_index, entry) in enumerate(catalog.items()):
        raw = entry['item']
        slot = slot_for(entry, units[entry['unit']]['upoi'])
        mapping[raw] = dict(name=entry['name'], slot=slot or 'Inventory')
        if slot:
            tooltip = fields(items[raw]).get('utub', '')
            if tooltip.startswith('TRIGSTR_'):
                raise ValueError('unresolved gear tooltip: ' + raw)
            set_field(items[raw], 'utub', slot_tooltip(tooltip, slot))
            for unit_id in (entry['unit'], 'z%03d' % int(save_index)):
                obj_unit=unit_objects[unit_id]
                set_field(obj_unit,'utub',slot_tooltip(fields(obj_unit).get('utub',''),slot))
            variant = 'f%03d' % number
            if variant in items:
                raise ValueError('experimental item ID already used: ' + variant)
            obj = copy.deepcopy(items[raw])
            obj['id'] = variant
            set_field(obj, 'iequ', slot)
            set_field(obj, 'icla', 'Equipment')
            # Keep a harmless item ability while stored passives are detached.
            # Avoid an empty list after every real passive has been suspended.
            set_field(obj, 'iabi', fields(obj).get('iabi', '') + ',fGmk')
            table['custom'].append(obj)
            mapping[raw]['variant'] = variant
            if slot == 'Primary':
                offhand = 'g%03d' % number
                if offhand in items:
                    raise ValueError('experimental offhand ID already used: '+offhand)
                alternate=copy.deepcopy(obj)
                alternate['id']=offhand
                set_field(alternate,'iequ','Offhand')
                table['custom'].append(alternate)
                mapping[raw]['offhand']=offhand
    ability_table = read_objects(archive.read('war3map.w3a'), 'w3a')
    ability_table['custom'].append(dict(base='AIi1', id='fGmk', sets=[dict(flag=0, mods=[
        dict(field='aite',type=0,level=0,data=0,value=1,end=0),
        dict(field='alev',type=0,level=0,data=0,value=1,end=0),
        dict(field='Iagi',type=0,level=1,data=1,value=0,end=0),
        dict(field='Iint',type=0,level=1,data=2,value=0,end=0),
        dict(field='Istr',type=0,level=1,data=3,value=0,end=0),
    ])]))
    if not any((o['id'] or o['base'])=='AInv' for g in ('original','custom') for o in ability_table[g]):
        # Declare the unchanged stock ability for strict object-reference verification.
        ability_table['original'].append(dict(base='AInv',id=None,sets=[dict(flag=0,mods=[])]))
    for base_id, raw, item_ability, capacity_field, capacity in (
            ('AInx', 'fBag', 0, 'inv6', 30),
            ('AIni', 'fBgi', 1, 'inv6', 30),
            ('AEqu', 'fGer', 0, 'equ1', 0)):
        if any((o['id'] or o['base']) == raw for o in ability_table['custom']):
            raise ValueError('experimental ability ID already used: ' + raw)
        mods = [dict(field=field, type=0, level=0, data=0, value=value, end=0)
                for field, value in [('aher', 0), ('aite', item_ability), ('alev', 1)]]
        # Native Data F holds bag capacity or the equipment level threshold.
        mods.append(dict(field=capacity_field, type=0, level=1, data=6, value=capacity, end=0))
        ability_table['custom'].append(dict(base=base_id, id=raw, sets=[dict(flag=0, mods=mods)]))
    if any((o['id'] or o['base']) == 'ASpc' for g in ('original','custom') for o in ability_table[g]):
        raise ValueError('base already modifies the native panel controller')
    ability_table['original'].append(dict(base='ASpc', id=None, sets=[dict(flag=0, mods=[
        dict(field='anam',type=3,level=0,data=0,value='Backpack',end=0),
        dict(field='aart',type=3,level=0,data=0,value=r'ReplaceableTextures\CommandButtons\BTNbackpack.blp',end=0),
        dict(field='abpx',type=0,level=0,data=0,value=0,end=0),
        dict(field='abpy',type=0,level=0,data=0,value=1,end=0),
        dict(field='ahky',type=3,level=0,data=0,value='B',end=0),
        dict(field='atp1',type=3,level=1,data=0,value='Backpack (B)',end=0),
        dict(field='aub1',type=3,level=1,data=0,value='Open your native backpack and equipment panel.',end=0),
    ])]))
    prepare_panels(ability_table)
    skin_updates = {}
    for ext, objects, tooltip_fields in (("w3u", unit_objects, ("utub",)),
                                         ("w3t", items, ("utub",))):
        name = "war3mapSkin." + ext
        skin_data = archive.read(name)
        if skin_data is None:
            continue
        skin = read_objects(skin_data, ext)
        for group in ("original", "custom"):
            for obj in skin[group]:
                raw = obj["id"] or obj["base"]
                updated = fields(objects[raw]) if raw in objects else {}
                for st in obj["sets"]:
                    for mod in st["mods"]:
                        field = mod["field"]
                        if field in tooltip_fields and "Forsaken slot" in updated.get(field, ""):
                            mod["value"] = updated[field]
        skin_updates[name] = write_objects(skin, skin["version"], ext)
    write_files(str(base), str(out), {
        'war3map.w3i': forsaken_map_info(archive.read('war3map.w3i')),
        'war3map.w3u': write_objects(unit_table, unit_table['version'], 'w3u'),
        'war3map.w3t': write_objects(table, table['version'], 'w3t'),
        'war3map.w3a': write_objects(ability_table, ability_table['version'], 'w3a'),
        **skin_updates,
    })
    mapping_out.write_text(json.dumps(mapping, indent=2) + '\n', encoding='utf-8')
    return mapping


def prepare_panels(table):
    existing={o['id'] or o['base'] for g in ('original','custom') for o in table[g]}
    def add(base,raw,values,leveled):
        if raw in existing:
            raise ValueError('panel ID already used: '+raw)
        existing.add(raw)
        mods=[dict(field=key,type=3 if isinstance(value,str) else 0,level=0,data=0,value=value,end=0)
              for key,value in values.items()]
        mods += [dict(field=key,type=3 if isinstance(value,str) else 0,level=level,data=data,value=value,end=0)
                 for key,level,data,value in leveled]
        table['custom'].append(dict(base=base,id=raw,sets=[dict(flag=0,mods=mods)]))
    add('ASde','fSta',dict(anam='Hero Stats',aher=0,aite=0,alev=1,abpy=-11),
        [('Asdf',1,1,','.join('AS%02X'%i for i in range(1,18)))])
    for player in range(8):
        icons=['fV%02d'%(player*6+slot) for slot in range(6)]
        add('ATal','fT%02d'%player,dict(anam='Job Talents (preview)',aher=0,aite=0,alev=4,abpy=-11),
            [('aabi',level,0,'') for level in range(1,5)])
        for icon in icons:
            # Cosmetic attribute-bonus abilities cannot grant real job skills or stats.
            add('Aamk',icon,dict(anam='Job talent preview',aher=0,aite=0,alev=1,abpy=-11,
                               aart=r'ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp'),
                [('Iagi',1,1,0),('Iint',1,2,0),('Istr',1,3,0),('Ihid',1,4,1),
                 ('atp1',1,0,'Future upgrade path'),('aub1',1,0,'Preview only. Existing job progression is unchanged.')])


def equip_overlay(original):
    text = original.replace('library TEquip requires TForce, TJob',
                            'library TEquip requires TForce, TJob, TPlayerHero, TMagicDefense, TProf, TElement, TMultiboard')
    text = text.replace('endglobals', '''    trigger gg_trg_Forsaken_Equipment=null
    trigger gg_trg_Forsaken_TestEquip=null
    timer ForsakenInventoryTimer=null
    hashtable ForsakenGearTypes=null
    item ForsakenEquippedItem=null
    item array ForsakenHandSpacers
    boolean ForsakenConvertingGear=false
    boolean ForsakenSaveBlocked=false
    trigger gg_trg_Forsaken_TalentClick=null
    trigger gg_trg_Forsaken_TalentSync=null
    trigger gg_trg_Forsaken_PanelAccess=null
    hashtable ForsakenTalentState=null
    framehandle ForsakenTalentRoot=null
    framehandle ForsakenTalentPoints=null
    framehandle array ForsakenTalentButton
    framehandle array ForsakenTalentIcon
    framehandle array ForsakenTalentLink
    framehandle ForsakenNPCSummary=null
    framehandle ForsakenInspectBagLabel=null
    framehandle array ForsakenTalentLabel
    framehandle ForsakenDefenseRow=null
    framehandle ForsakenReductionRow=null
    framehandle ForsakenDefenseValue=null
    framehandle ForsakenReductionValue=null
    boolean ForsakenPanelFramesReady=false
    timer ForsakenPanelClock=null
    real ForsakenPanelLastToggle=-1.
    boolean ForsakenPanelOpen=false
    framehandle ForsakenTalentToggle=null
    framehandle ForsakenTalentAnchor=null
    framehandle ForsakenPanelClose=null
    string array ForsakenStatName
    framehandle array ForsakenStatValue
    framehandle array ForsakenStatLabel
    framehandle ForsakenStatsNext=null
    framehandle ForsakenStatsHeading=null
    integer ForsakenStatsPage=0
    real array ForsakenHeroHPRegen
    real array ForsakenHeroMPRegen
    timer ForsakenUITimer=null
    boolean ForsakenBackpackWasVisible=false
    unit ForsakenSelectedTarget=null
    unit ForsakenInspectTarget=null
    framehandle ForsakenInspectButton=null
    boolean ForsakenPanelNeedsRefresh=false
    boolean ForsakenConditionPage=false
    framehandle ForsakenInspectRoot=null
    framehandle ForsakenInspectClose=null
    framehandle ForsakenInspectTitle=null
    framehandle array ForsakenInspectIcon
    framehandle array ForsakenInspectItemText
    string array ForsakenInspectSlotName
    hashtable ForsakenRegenScratch=null
    hashtable ForsakenRegenData=null
    real ForsakenHPFlat=0.
    real ForsakenMPPercent=0.
    real ForsakenHPRegen=0.
    real ForsakenMPRegen=0.
endglobals''', 1)
    text = text.replace('GetItemType(', 'Forsaken_GearClass(')
    text = text.replace('GetManipulatedItem()', 'Forsaken_EventItem()')
    text = text.replace('function Trig_Equip_Restrictions_Conditions', '''function Forsaken_EventItem takes nothing returns item
    if ForsakenEquippedItem!=null then
        return ForsakenEquippedItem
    endif
    return GetManipulatedItem()
endfunction

function Trig_Equip_Restrictions_Conditions''', 1)
    conditions = re.search(r'function Trig_Equip_Restrictions_Conditions.*?endfunction', text, re.S)
    body = conditions.group().replace('    return',
          '    if ForsakenConvertingGear or GetItemTypeId(GetManipulatedItem())==\'fGap\' then\n        return false\n    endif\n'
          '    if GetItemEquipmentType(GetManipulatedItem())!=EQUIPMENT_TYPE_NONE or LoadInteger(ForsakenGearTypes,0,GetItemTypeId(GetManipulatedItem()))!=0 then\n        return false\n    endif\n'
          '    return', 1)
    text = text[:conditions.start()] + body + text[conditions.end():]
    actions = re.search(r'function Trig_Equip_Restrictions_Actions.*?endfunction', text, re.S).group()
    validation = actions[actions.index('    if(Trig_Equip_Restrictions_GaiaLevelTooLow())'):]
    validation = "function Forsaken_ValidateEquipment takes nothing returns nothing\n    if LoadInteger(ForsakenGearTypes,6,GetItemTypeId(ForsakenEquippedItem))!=0 and GetUnitAbilityLevel(GetTriggerUnit(),'A0HP')==0 then\n        call UnitUnequipItem(GetTriggerUnit(),ForsakenEquippedItem)\n        return\n    endif\n" + validation
    validation = validation.replace('UnitRemoveItemSwapped(', 'Forsaken_RejectEquipment(')
    validation = validation.replace('GetManipulatingUnit()', 'GetTriggerUnit()')
    extra = (HERE / 'Forsaken-extra.j').read_text(encoding='utf-8')
    panels = (HERE / 'Forsaken-panels.j').read_text(encoding='utf-8')
    defense = re.search(r'function Forsaken_DefensePercent\b.*?endfunction', panels, re.S).group()
    panels = panels.replace(defense, '', 1)
    stats = (HERE/'Forsaken-stats.j').read_text(encoding='utf-8').replace('function Forsaken_RenderStats', (HERE/'Forsaken-conditions.j').read_text(encoding='utf-8')+'\n\n'+(HERE/'Forsaken-gear-stats.j').read_text(encoding='utf-8')+'\n\nfunction Forsaken_RenderStats',1)
    extra = defense + '\n\n' + combat_stat_helpers() + '\n\n' + stats + '\n\n' + (HERE / 'Forsaken-inspect.j').read_text(encoding='utf-8') + '\n\n' + panels + '\n\n' + extra
    extra = extra.replace('function Forsaken_EnableHero', (HERE / 'Forsaken-dual.j').read_text(encoding='utf-8') + '\n\nfunction Forsaken_EnableHero',1)
    extra = extra.replace('function Forsaken_OnEquip', (HERE / 'Forsaken-carry.j').read_text(encoding='utf-8') + '\n\nfunction Forsaken_OnEquip',1)
    extra = extra.replace('function Forsaken_OnEquip', validation + '\n\nfunction Forsaken_OnEquip', 1)
    text = text.replace('function Register_Equip_Restrictions takes', extra + '\n\nfunction Register_Equip_Restrictions takes', 1)
    text = text.replace('    call Register_Equip_Restrictions() //',
                        '    call Register_Forsaken_Equipment()\n    call Register_Forsaken_TestEquip()\n    call Register_Forsaken_TalentClick()\n    call Register_Forsaken_TalentSync()\n    call Register_Forsaken_PanelAccess()\n    call Register_Equip_Restrictions() //', 1)
    return text


def active_gear_overlay(original, module):
    selected = {
        'Unit': ['Unit_HasNoEquipment'],
        'Prof': ['Prof_GetLevel', 'Prof_GetWeaponUpgrade', 'Prof_GetArmorUpgrade'],
        'Damage': ['Trig_Damage_Engine_FindTwoHandedItem', 'Trig_Damage_Engine_ProficiencyMult',
                   'Trig_Damage_Engine_GetElementBonus', 'Trig_Damage_Engine_GetElementResist'],
        'Element': ['Element_GetOfUnit'],
        'TwoHanded': ['Trig_TwoHanded_Check_SlotCancelsBonus', 'Trig_TwoHanded_Check_ItemIsGear',
                      'Trig_TwoHanded_Check_SlotHasGear', 'Trig_TwoHanded_Check_Actions'],
    }[module]
    for name in selected:
        match = re.search(r'function '+name+r'\b.*?endfunction', original, re.S)
        body = match.group().replace('UnitItemInSlotBJ(', 'Forsaken_ActiveGearBJ(').replace('UnitItemInSlot(', 'Forsaken_ActiveGear(')
        if module in ('Prof','Element') or name in ('Trig_Damage_Engine_GetElementBonus','Trig_Damage_Engine_GetElementResist'):
            query='Forsaken_ElementAbilityLevel(' if module=='Element' or name=='Trig_Damage_Engine_GetElementBonus' else 'Forsaken_ActiveAbilityLevel('
            body = body.replace('GetUnitAbilityLevel(', query)
        if name=='Trig_Damage_Engine_FindTwoHandedItem':
            body='function Trig_Damage_Engine_FindTwoHandedItem takes unit u returns nothing\n    set udg_TwoHandedItem=Forsaken_TwoHandedWeapon(u)\nendfunction'
        if name=='Element_GetOfUnit':
            body=body.replace("Prof_GetLevel(u,'R002')>0",'Forsaken_WeaponType(u,3)').replace("Prof_GetLevel(u,'R00M')>0",'Forsaken_WeaponType(u,11)')
        if name=='Trig_TwoHanded_Check_Actions':
            body="""function Trig_TwoHanded_Check_Actions takes nothing returns nothing
    if Forsaken_TwoHandedWeapon(GetAttacker())!=null then
        call UnitAddItemByIdSwapped('I0GK',GetAttacker())
    else
        call UnitRemoveBuffBJ('B05W',GetAttacker())
    endif
endfunction"""
        body = body.replace('i>=bj_MAX_INVENTORY','i>=15').replace('udg_SlotIndex>6','udg_SlotIndex>15')
        original = original[:match.start()] + body + original[match.end():]
    original=original.replace('GetItemType(', 'Forsaken_GearClass(')
    if module=='Damage':
        # Native equipment does not reliably expose item abilities on the unit.
        # Read actual equipment for all combat checks; storage remains excluded.
        original=original.replace('GetUnitAbilityLevel(', 'Forsaken_ElementAbilityLevel(')
        match=re.search(r'function Trig_Damage_Engine_GetAccuracy\b.*?endfunction',original,re.S)
        body=match.group().replace('    return l_acc','    return l_acc+Forsaken_ItemAccuracy(u)')
        original=original[:match.start()]+body+original[match.end():]
        helper=element_damage_helper()
        original=original.replace('function Trig_Damage_Engine_Step11_ElementBonus',helper+'\n\nfunction Trig_Damage_Engine_Step11_ElementBonus',1)
        original=original.replace('1.+Trig_Damage_Engine_GetElementBonus(u,l_element,l_physical)+Trig_Damage_Engine_GetElementBonus(u,7,l_physical)','1.+Forsaken_ElementDamageBonus(u,l_element,l_physical)')
    if module == 'Unit':
        original=original.replace('globals\n','globals\n    hashtable ForsakenElementSources=null\n    hashtable ForsakenBagAbilities=null\n    hashtable ForsakenBagPassiveTypes=null\n',1)
        original = original.replace('function Unit_HasNoEquipment', (HERE/'Forsaken-bag-effects.j').read_text()+'\n'+(HERE/'Forsaken-active-gear.j').read_text()+'\nfunction Unit_HasNoEquipment',1)
    elif module in ('Prof','TwoHanded'):
        original = original.replace('library T'+module+' requires TPlayerHero','library T'+module+' requires TPlayerHero, TUnit') if module=='Prof' else original.replace('library TTwoHanded','library TTwoHanded requires TUnit',1)
    return original


def cast_overlay(original, module):
    """Read item casts from their event handle, not the legacy unit ability list."""
    if module == 'Abil':
        original = original.replace('    if udg_AbilityLevelShift then', """    // Native bag item casts need not appear in GetUnitAbilityLevel.
    if l_level<=0 and GetSpellAbilityId()==l_abilId and GetSpellAbility()!=null then
        set l_level=1
    endif
    if udg_AbilityLevelShift then""", 1)
    elif module == 'Cooldown':
        original = original.replace('library TCooldown requires TPlayerHero', 'library TCooldown requires TPlayerHero, TAbil', 1)
        helper = """function Forsaken_SetCastCooldown takes unit caster,integer raw,integer level,real duration returns nothing
    local ability castAbility=GetSpellAbility()
    if castAbility!=null and GetSpellAbilityId()==raw then
        call BlzSetAbilityRealLevelField(castAbility,ABILITY_RLF_COOLDOWN,IMaxBJ(0,level),duration)
    else
        call BlzSetUnitAbilityCooldown(caster,raw,level,duration)
    endif
    set castAbility=null
endfunction

function Forsaken_CastAbilityLevel takes integer raw,unit caster returns integer
    local integer rank=GetUnitAbilityLevel(caster,raw)
    if rank<=0 and GetSpellAbilityId()==raw and GetSpellAbility()!=null then
        return 1
    endif
    return rank
endfunction

"""
        original = original.replace('function Trig_Cooldown_Scaling_Actions',helper+'function Trig_Cooldown_Scaling_Actions',1)
        start=original.index('function Trig_Cooldown_Scaling_Actions')
        original=original[:start]+original[start:].replace('call BlzSetUnitAbilityCooldown(', 'call Forsaken_SetCastCooldown(').replace('GetUnitAbilityLevelSwapped(GetSpellAbilityId(),GetTriggerUnit())','Forsaken_CastAbilityLevel(GetSpellAbilityId(),GetTriggerUnit())')
    elif module == 'Spell_Water':
        replacement=(HERE/'Forsaken-water.j').read_text(encoding='utf-8')
        body=re.search(r'function Trig_Spell_Water_Actions\b.*?endfunction',original,re.S)
        original=original[:body.start()]+replacement+original[body.end():]
    return original


def attack_speed_helper():
    source=(ROOT/'src/triggers/04 Combat and abilities/AtkSpd.j').read_text()
    body=re.search(r'function Trig_AtkSpd_Command_Actions\b.*?endfunction',source,re.S).group()
    body=body[body.index("    set udg_StatCalcValue=(udg_StatCalcValue+'d')"):body.index('    if(Trig_AtkSpd_Command_Cond_UsesFastBaseSpeed())')]
    for name in set(re.findall(r'Trig_AtkSpd_Command_Cond_\w+',body)):
        predicate=re.search(r'function '+name+r'\b.*?endfunction',source,re.S).group()
        expression=predicate.split('    return',1)[1].splitlines()[0].split(' //',1)[0].strip()
        expression=re.sub(r"GetUnitAbilityLevelSwapped\('(.{4})',udg_CurrentHero\)",r"Forsaken_StatAbilityLevel(hero,'\1')",expression)
        expression=expression.replace("UnitHasBuffBJ(udg_CurrentHero,'B01Q')","Forsaken_StatAbilityLevel(hero,'B01Q')>0")
        body=body.replace(name+'()',expression)
    body=body.replace('udg_StatCalcValue','speed')
    body=re.sub(r"'([A-Za-z])'",lambda m:str(ord(m[1])),body)
    return """function Forsaken_StatAttackSpeed takes unit hero returns real
    local integer rank=Forsaken_StatAbilityLevel(hero,'A00V')
    local integer speed=R2I(SquareRoot(I2R(GetHeroAgi(hero,true)))*4.+I2R(GetHeroAgi(hero,true))*.4)
    if Forsaken_StatAbilityLevel(hero,'A0HS')>0 then
        set speed=0
    elseif rank==11 then
        set speed=speed+100
    elseif rank==22 then
        set speed=speed+200
    else
        set speed=speed+rank*8
    endif
""" + body + """    if Forsaken_StatAbilityLevel(hero,'B08T')>0 then
        set speed=speed+120
    elseif Forsaken_StatAbilityLevel(hero,'B00F')>0 or Forsaken_StatAbilityLevel(hero,'B07F')>0 then
        set speed=speed+80
    endif
    if Forsaken_StatAbilityLevel(hero,'B08Y')>0 then
        set speed=speed-100
    elseif Forsaken_StatAbilityLevel(hero,'Bslo')>0 then
        set speed=speed-50
    endif
    if Forsaken_StatAbilityLevel(hero,'A0GP')>0 and IsUnitType(hero,UNIT_TYPE_MELEE_ATTACKER) and Forsaken_TwoHandedWeapon(hero)!=null then
        set speed=speed+240
    endif
    return I2R(IMaxBJ(40,IMinBJ(1000,speed)))
endfunction"""


def multiboard_overlay(original):
    text=original.replace('globals\n','globals\n    boolean ForsakenBoardCovered=false\n',1)
    return text.replace('call MultiboardDisplay(udg_ScoreBoard,true)',
                        'call MultiboardDisplay(udg_ScoreBoard,not ForsakenBoardCovered)')


def element_damage_helper():
    return '''function Forsaken_ElementDamageBonus takes unit u,integer element,boolean physical returns real
    local real bonus=Trig_Damage_Engine_GetElementBonus(u,element,physical)+Trig_Damage_Engine_GetElementBonus(u,7,physical)
    if element!=7 and (Forsaken_ActiveAbilityLevel(u,'A0PN')>0 or Forsaken_ActiveAbilityLevel(u,'B08Z')>0) then
        // Gaya Strength is already included in this element; remove its duplicate half from Omni.
        set bonus=bonus-.33333*.5
    endif
    return bonus
endfunction'''


def combat_stat_helpers():
    """Reuse only read-only combat queries; never roll RNG or simulate a hit for UI."""
    source = (ROOT / 'src/triggers/04 Combat and abilities/Damage.j').read_text(encoding='utf-8')
    names = ['GetSpeedBonus', 'GetAccuracy', 'GetEvasion', 'GetElementBonus', 'GetElementResist']
    result = []
    for name in names:
        body = re.search(r'function Trig_Damage_Engine_' + name + r'\b.*?endfunction', source, re.S).group()
        if name == 'GetElementResist':
            # A random absorption proc has its own probability row, not a fluctuating rolled resistance.
            body, count = re.subn(r'    // A random whole number.*?    endif\n', '', body, count=1, flags=re.S)
            assert count == 1 and 'GetRandom' not in body
        body = body.replace('Trig_Damage_Engine_', 'Forsaken_Stat_').replace('GetUnitAbilityLevel(', 'Forsaken_StatAbilityLevel(')
        if name=='GetElementBonus':
            body=body.replace('Forsaken_StatAbilityLevel(', 'Forsaken_ElementAbilityLevel(')
        result.append(body)
    result.append(element_damage_helper().replace('Forsaken_ElementDamageBonus','Forsaken_StatElementDamageBonus').replace('Trig_Damage_Engine_GetElementBonus','Forsaken_Stat_GetElementBonus').replace('Forsaken_ActiveAbilityLevel','Forsaken_StatAbilityLevel'))
    body=re.search(r'function Trig_Damage_Engine_ProficiencyMult\b.*?endfunction',active_gear_overlay(source,'Damage'),re.S).group()
    result.append(body.replace('Trig_Damage_Engine_ProficiencyMult','Forsaken_StatAttackMultiplier'))
    prof = (ROOT / 'src/triggers/03 Jobs and progression/Prof.j').read_text(encoding='utf-8')
    body = re.search(r'function Prof_GetSpellPower\b.*?endfunction', prof, re.S).group()
    result.append(body.replace('Prof_GetSpellPower', 'Forsaken_StatSpellPower').replace('GetUnitAbilityLevel(', 'Forsaken_StatAbilityLevel('))
    block = re.search(r'function Trig_Damage_Engine_RollBlock\b.*?endfunction', source, re.S).group()
    physical, magical = block.split('    elseif l_magical then')
    physical = physical[physical.index("if(GetUnitAbilityLevel(u,'A0S0')") :]
    bodies = []
    for text, expected in [(physical,19), (magical,8)]:
        pairs = re.findall(r"if\(GetUnitAbilityLevel\(u,'(.{4})'\)>0 and GetRandomInt\(1,'d'\)<=([0-9]+|\$[0-9A-F]+)\)", text)
        assert len(pairs) == expected, pairs
        bodies.append('\n'.join("        if Forsaken_StatAbilityLevel(u,'%s')>0 then\n            set miss=miss*(1.-%s/100.)\n        endif" % (raw, str(int(chance[1:],16)) if chance.startswith('$') else chance) for raw,chance in pairs))
    result.append('''function Forsaken_StatBlockRoll takes unit u,boolean physical returns real
    local real miss=1.
    local real chance
    if Forsaken_StatAbilityLevel(u,'A0RT')>0 then
        set miss=miss*.7
    endif
    if Forsaken_StatAbilityLevel(u,'B07R')>0 then
        set chance=I2R(LoadInteger(udg_RunicHash,GetHandleId(u),6))
        if physical then
            set chance=chance*2.
        endif
        set miss=miss*(1.-RMinBJ(100.,RMaxBJ(0.,chance))/100.)
    endif
    if physical then
        if Forsaken_StatAbilityLevel(u,'A0PP')>0 then
            if IsUnitInGroup(u,udg_DefendingUnits) then
                set miss=miss*.7
            else
                set miss=miss*.8
            endif
        endif
%s
    else
%s
    endif
    // Independent block checks combine as one minus the probability that all checks miss.
    return 1.-miss
endfunction''' % tuple(bodies))
    result.append(attack_speed_helper())
    result.insert(0, (HERE / 'Forsaken-stat-ability.j').read_text(encoding='utf-8'))
    return '\n\n'.join(result)


PASSIVE_ITEM_CODES = frozenset(('AEev', 'AHab', 'AIab', 'AIas', 'AIat', 'AIde',
    'AIml', 'AImm', 'AIms', 'AIrm', 'AOac', 'AOae', 'AOcr',
    'AUau', 'AUav', 'Aasl', 'Atru', 'Arel'))


def bag_passive_types(base):
    codes = json.loads((HERE/'ability-base-codes.json').read_text(encoding='utf-8'))
    table = read_objects(MPQ(str(base)).read('war3map.w3a'), 'w3a')
    result = {raw for raw, code in codes.items() if code in PASSIVE_ITEM_CODES}
    for group in ('original', 'custom'):
        for obj in table[group]:
            code = fields(obj).get('acod') or codes.get(obj['base'], obj['base'])
            if code in PASSIVE_ITEM_CODES:
                result.add(obj['id'] or obj['base'])
    return result


def bag_passive_initialization(base):
    return ['    set ForsakenBagAbilities=InitHashtable()',
            '    set ForsakenBagPassiveTypes=InitHashtable()'] + [
        "    call SaveBoolean(ForsakenBagPassiveTypes,0,'%s',true)"%raw
        for raw in sorted(bag_passive_types(base))]


def item_accuracy_initialization(base, mapping):
    """Record item accuracy bonuses so the Forsaken panel can audit every gear item.

    The canonical map stores many item bonuses in tooltip text rather than an
    ability field.  Accuracy is one of those bonuses (for example Storm
    Lance), so the generated branch keeps a compact type-id lookup for the
    original item and every Forsaken equipment variant.
    """
    archive = MPQ(str(base))
    table = read_objects(archive.read('war3map.w3t'), 'w3t')
    fields_by_raw = {o['id'] or o['base']: fields(o)
                     for group in ('original', 'custom') for o in table[group]}

    def parse(value):
        if not value or value.startswith('TRIGSTR_'):
            return 0
        plain = re.sub(r'\|c[0-9a-fA-F]{8}|\|r', '', value)
        total = 0
        for pattern in (
                r'\baccuracy(?:\s+rating)?\s*(?:by|:|\+)\s*\+?(\d+)',
                r'\+\s*(\d+)\s+accuracy(?:\s+rating)?\b'):
            total += sum(int(match) for match in re.findall(pattern, plain, re.I))
        return total

    result = []
    for raw, entry in mapping.items():
        data = fields_by_raw.get(raw, {})
        # The same localized description is commonly present in both fields;
        # use the larger parsed value so a bonus is never counted twice.
        value = max(parse(data.get('ides', '')), parse(data.get('utub', '')))
        canonical = dict(A16L=70,A16R=200,A19E=9,A19G=20,A19F=30,A19H=35,
                         A1A1=35,A19J=40,A19I=50,A19D=60,A19K=75,A18O=255,A068=40,A02D=120)
        value = max(0, value-sum(canonical.get(ability,0) for ability in data.get('iabi','').split(',')))
        if not value:
            continue
        ids = [raw, entry.get('variant'), entry.get('offhand')]
        result.extend("    call SaveInteger(ForsakenElementSources,41,'%s',%d)" % (item, value)
                      for item in ids if item)
    return result


def job_overlay(original):
    extra = (HERE / 'Forsaken-job.j').read_text(encoding='utf-8')
    text = original.replace('endglobals','    item array ForsakenSharedBag\nendglobals',1)
    text = text.replace('function Trig_Job_Change_Actions takes',
                            extra + '\n\nfunction Trig_Job_Change_Actions takes', 1)
    text = text.replace('    local group l_tempGroup\n    set udg_SelectedJobId',
                        '    local group l_tempGroup\n    local unit forsakenPrevious=Player_GetHero(GetOwningPlayer(GetSoldUnit()))\n    set udg_SelectedJobId', 1)
    restore = '''    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=6
    loop
        exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
        if(Trig_Job_Change_HasSavedItem())then'''
    if text.count(restore)!=1:
        raise ValueError('expected one six-slot restoration boundary')
    text = text.replace(restore,'    call Forsaken_TransferSharedInventory(forsakenPrevious,Player_GetHero(udg_TempPlayer))\n    set forsakenPrevious=null\n'+restore,1)
    # Clear the additional handle on the original early-return paths too.
    start = text.index('function Trig_Job_Change_Actions takes')
    end = text.index('endfunction', start)
    action = text[start:end].replace('        return', '        set forsakenPrevious=null\n        return')
    return text[:start] + action + text[end:]


def defense_overlay(original, mapping):
    text=original.replace('endglobals','    hashtable ForsakenDefenseTypes=null\nendglobals',1)
    helper='''function Forsaken_HasDefenseItem takes unit hero,integer original returns boolean
    local integer slot=0
    local integer variant=LoadInteger(ForsakenDefenseTypes,0,original)
    local item equipped
    if UnitHasItemOfTypeBJ(hero,original) then
        return true
    endif
    if variant!=0 then
        loop
            exitwhen slot>8
            set equipped=UnitItemInEquipmentSlot(hero,ConvertLoadoutSlot(slot))
            if equipped!=null and (GetItemTypeId(equipped)==variant or GetItemTypeId(equipped)==LoadInteger(ForsakenDefenseTypes,1,original)) then
                set equipped=null
                return true
            endif
            set slot=slot+1
        endloop
    endif
    set equipped=null
    return false
endfunction

'''
    text=text.replace('UnitHasItemOfTypeBJ(', 'Forsaken_HasDefenseItem(')
    text=text.replace('function Trig_MagicDefense_',helper+'function Trig_MagicDefense_',1)
    return text


def run(command, cwd=ROOT):
    subprocess.run(list(map(str, command)), cwd=cwd, check=True)


def regeneration_initialization(base):
    archive=MPQ(base)
    table=read_objects(archive.read('war3map.w3a'),'w3a')
    defaults=json.loads((HERE/'regen-defaults.json').read_text())['abilities']
    classes=dict(Arel=1,AIrm=2,AIrn=2,AHab=3,AUau=4)
    objects={o['id'] or o['base']:o for g in ('original','custom') for o in table[g]}
    for raw in classes:
        objects.setdefault(raw,dict(base=raw,id=None,sets=[dict(mods=[])]))
    result=['    set ForsakenRegenScratch=InitHashtable()', '    set ForsakenRegenData=InitHashtable()']
    buffs=set(); regen=[]
    for raw,obj in objects.items():
        kind=classes.get(obj['base'])
        if not kind: continue
        data=fields(obj); stock=defaults[obj['base']]; regen.append(raw)
        result.append("    call SaveInteger(ForsakenGearTypes,30,'%s',%d)"%(raw,kind))
        result.append("    call SaveBoolean(ForsakenGearTypes,32,'%s',%s)"%(raw,'true' if data.get('aite',stock['item']) else 'false'))
        field={1:'Ihpr',2:'Imrp',3:'Hab1',4:'Uau2'}[kind]
        for level in range(1,data.get('alev',stock['levels'])+1):
            value=data.get((field,level),stock['amount'][min(level,len(stock['amount']))-1])
            result.append("    call SaveReal(ForsakenRegenData,'%s',%d,%s)"%(raw,level-1,str(float(value))))
            if kind>=3:
                percent=data.get((('Hab2' if kind==3 else 'Uau3'),level),stock['percent'])
                buff=data.get(('abuf',level),data.get(('abuf',1),stock['buff'])).split(',')[0]
                if len(buff)!=4: raise ValueError('unreviewed regeneration buff: '+raw)
                buffs.add(buff)
                result.append("    call SaveBoolean(ForsakenRegenData,'%s',%d,%s)"%(raw,100+level-1,'true' if percent else 'false'))
                result.append("    call SaveInteger(ForsakenRegenData,'%s',%d,'%s')"%(raw,200+level-1,buff))
                result.append("    call SaveInteger(ForsakenGearTypes,31,'%s','%s')"%(raw,buff))
    result.append('    call SaveInteger(ForsakenRegenData,0,0,%d)'%len(regen))
    result += ["    call SaveInteger(ForsakenRegenData,0,%d,'%s')"%(i,raw) for i,raw in enumerate(regen,1)]
    items=read_objects(archive.read('war3map.w3t'),'w3t')
    for group in ('original','custom'):
        for obj in items[group]:
            raw=obj['id'] or obj['base']; data=fields(obj)
            effects=[effect for effect in data.get('iabi','').split(',') if effect in regen]
            if not effects: continue
            result.append("    call SaveInteger(ForsakenRegenData,'%s',1000,%d)"%(raw,len(effects)))
            result += ["    call SaveInteger(ForsakenRegenData,'%s',%d,'%s')"%(raw,1000+i,effect) for i,effect in enumerate(effects,1)]
    result.append('    call SaveInteger(ForsakenGearTypes,34,0,%d)'%len(buffs))
    result += ["    call SaveInteger(ForsakenGearTypes,34,%d,'%s')"%(i,buff) for i,buff in enumerate(sorted(buffs),1)]
    misc=(archive.read('war3mapMisc.txt') or b'').decode('utf-8')
    for index,key,default in [(0,'StrRegenBonus',.05),(1,'IntRegenBonus',.05),(2,'DefenseArmor',.06)]:
        value=re.search(r'^'+key+r'=([^\r\n]+)',misc,re.M)
        result.append('    call SaveReal(ForsakenGearTypes,40,%d,%s)'%(index,str(float(value[1]) if value else default)))
    return result


def element_source_data(base):
    archive=MPQ(str(base))
    element=(ROOT/'src/triggers/04 Combat and abilities/Element.j').read_text(encoding='utf-8')
    damage=(ROOT/'src/triggers/04 Combat and abilities/Damage.j').read_text(encoding='utf-8')
    arrays=set(re.findall(r"set udg_Element(?:Attack|Knowledge|Boost|SpellAmp|OrbAmp)Abil\[\d\]='(.{4})'",element))
    # Item-only markers must not survive in native unit caches after unequipping.
    arrays.update('A16L A16R A19E A19G A19F A19H A1A1 A19J A19I A19D A19K A18O A068 A02D A139 A13H A0TW A182 A0HS A0OQ A13G A1DG A13F A13E A13D A13C A13B A13A A0Y7 A04H A0Y8 A0Y9 A174 A0Y6 A0YA A1AL A1FE A0YB A1AM A144 A145 A0YC A18L A1CB A10X A05L A12S A12V A03R A03D A0QK A05H A0PQ A0PR A115 A116 A118 A119 A0V9 A0VA A08N A0NP A0NN A0H4 A0H5 A0H6 A0KU'.split())
    for source,name in [(element,'Element_GetOfUnit'),(damage,'Trig_Damage_Engine_GetElementBonus')]:
        body=re.search(r'function '+name+r'\b.*?endfunction',source,re.S).group()
        arrays.update(re.findall(r"GetUnitAbilityLevel\(u,'(.{4})'\)",body))
    items=read_objects(archive.read('war3map.w3t'),'w3t')
    gear={raw for group in ('original','custom') for obj in items[group] for raw in fields(obj).get('iabi','').split(',')}
    managed=arrays & gear
    units=read_objects(archive.read('war3map.w3u'),'w3u')
    innate={}
    for group in ('original','custom'):
        for obj in units[group]:
            data=fields(obj)
            abilities=set((data.get('uabi','')+','+data.get('uhab','')).split(',')) & managed
            if abilities: innate[obj['id'] or obj['base']]=abilities
    return managed,innate


def element_source_initialization(base):
    managed,innate=element_source_data(base)
    result=['    set ForsakenElementSources=InitHashtable()']
    table=read_objects(MPQ(str(base)).read('war3map.w3t'),'w3t')
    gear={raw for group in ('original','custom') for obj in table[group] for raw in fields(obj).get('iabi','').split(',') if raw}
    result.append('    call SaveBoolean(ForsakenElementSources,43,0,true)')
    result += ["    call SaveBoolean(ForsakenElementSources,43,'%s',true)"%raw for raw in sorted(gear)]
    result += ["    call SaveBoolean(ForsakenElementSources,0,'%s',true)"%raw for raw in sorted(managed)]
    result += ["    call SaveBoolean(ForsakenElementSources,'%s','%s',true)"%(unit,raw) for unit,abilities in sorted(innate.items()) for raw in sorted(abilities)]
    return result


def manifest(base, classic_base, modern, classic, stage):
    def identity(path):
        return dict(file=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest())
    return dict(stage=stage, experimental=True, save_export_disabled=True,
                game_data_version='Forsaken Kingdom (2)',
                normal_development_stage='AS', base=identity(base),
                classic_base=identity(classic_base), output=identity(modern),
                classic_output=identity(classic),
                sources={p.name:identity(p) for p in HERE.iterdir() if p.suffix in ('.py','.j','.fdf','.json')})


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--stage', default='AT')
    parser.add_argument('--base', type=Path, default=ROOT/'release/FFERPG_0.9.7.3-r16-stageAS.w3x')
    parser.add_argument('--classic', type=Path, default=ROOT/'release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x')
    args = parser.parse_args()
    if not re.fullmatch('[A-Z][A-Z0-9]*', args.stage):
        parser.error('invalid stage')
    destination = ROOT/'release/Forsaken'
    basename = 'FFERPG_0.9.7.3-r16-Forsaken' + args.stage + '.w3x'
    final, classic = destination/basename, destination/'1.29.2'/basename
    if final.exists() or classic.exists():
        parser.error('existing test release; choose a new stage')
    (ROOT/'build').mkdir(exist_ok=True)
    run([sys.executable, HERE/'test_forsaken.py'])
    scratch = Path(tempfile.mkdtemp(prefix='Forsaken'+args.stage+'-', dir=ROOT/'build'))
    work = scratch/'FFERPG'
    for folder in ('src', 'tools', 'baseline'):
        shutil.copytree(ROOT/folder, work/folder, ignore=shutil.ignore_patterns('__pycache__'))
    shutil.copy2(ROOT/'build.ps1', work/'build.ps1')
    config_path = work/'tools/build-config.json'
    config = json.loads(config_path.read_text())
    config['prefix'] = 'FFERPG_0.9.7.3-r16-Forsaken'
    config['title'] += ' Forsaken TEST - saving disabled'
    config_path.write_text(json.dumps(config, indent=2)+'\n')
    base = scratch/'objects.w3x'
    mapping = prepare_objects(args.base.resolve(), base, scratch/'gear-slots.json')
    for module in ('Loot','Recharge','Summon_Scaling','ManaRefund','Haste','Oracle','Protect','Shell'):
        path=next((work/'src/triggers').rglob(module+'.j'))
        text=path.read_text(encoding='utf-8')
        first,rest=text.split('\n',1)
        if 'TUnit' not in first:
            first += ', TUnit' if ' requires ' in first else ' requires TUnit'
        text=re.sub(r"GetUnitAbilityLevelSwapped(?=\('(?:A12V|A12S|A05H|A03D|A0QK)')",
                    'Forsaken_EquipmentAbilityLevelSwapped',first+'\n'+rest)
        path.write_bytes(text.replace('\n','\r\n').encode('utf-8'))
    source = work/'src/triggers/05 Items crafting and shops/Equip.j'
    overlay = equip_overlay(source.read_text(encoding='utf-8'))
    initialization = ['    set ForsakenGearTypes=InitHashtable()', '    set ForsakenDefenseTypes=InitHashtable()', '    set ForsakenWaterWaves=InitHashtable()']
    initialization += ["    call SaveInteger(ForsakenDefenseTypes,0,'%s','%s')" % (raw,entry['variant'])
                       for raw, entry in mapping.items() if 'variant' in entry]
    initialization += ["    call SaveInteger(ForsakenGearTypes,0,'%s','%s')" % (raw,entry['variant'])
                       for raw, entry in mapping.items() if 'variant' in entry]
    slots = dict(Head=0,Chest=1,Gloves=2,Boots=3,Ring=4,Primary=6,Offhand=7,Trinket=8)
    initialization += ["    call SaveInteger(ForsakenGearTypes,4,'%s','%s')" % (entry['variant'],raw)
                       for raw, entry in mapping.items() if 'variant' in entry]
    initialization += ["    call SaveInteger(ForsakenGearTypes,1,'%s',%d)" % (raw,slots[entry['slot']])
                       for raw, entry in mapping.items() if 'variant' in entry]
    initialization += ["    call SaveInteger(ForsakenGearTypes,2,%d,'fT%02d')" % (i,i) for i in range(8)]
    initialization += ["    call SaveInteger(ForsakenGearTypes,3,%d,'fV%02d')" % (i,i) for i in range(48)]
    for raw, entry in mapping.items():
        if 'offhand' in entry:
            initialization += ["    call SaveInteger(ForsakenDefenseTypes,1,'%s','%s')" % (raw,entry['offhand'])]
            initialization += ["    call SaveInteger(ForsakenGearTypes,5,'%s','%s')" % (entry['variant'],entry['offhand']),
                               "    call SaveInteger(ForsakenGearTypes,6,'%s','%s')" % (entry['offhand'],entry['variant']),
                               "    call SaveInteger(ForsakenGearTypes,4,'%s','%s')" % (entry['offhand'],raw)]
    initialization += bag_passive_initialization(base)
    initialization += regeneration_initialization(base)
    initialization += element_source_initialization(base)
    initialization += item_accuracy_initialization(base, mapping)
    item_table=read_objects(MPQ(base).read('war3map.w3t'),'w3t')
    item_fields={o['id'] or o['base']:fields(o) for g in ('original','custom') for o in item_table[g]}
    classes={'Permanent':0,'Charged':1,'PowerUp':2,'Artifact':3,'Purchasable':4,'Campaign':5,'Miscellaneous':6}
    item_bases={o['id'] or o['base']:o['base'] for g in ('original','custom') for o in item_table[g]}
    class_defaults=json.loads((HERE/'item-class-defaults.json').read_text(encoding='utf-8'))
    for original,entry in mapping.items():
        if entry['slot']=='Inventory': continue
        category=classes[item_fields[original].get('icla') or class_defaults[item_bases[original]]]
        for variant in (entry.get('variant'),entry.get('offhand')):
            if variant: initialization.append("    call SaveInteger(ForsakenElementSources,3,'%s',%d)"%(variant,category+1))
    initialization += ["    call SaveBoolean(ForsakenElementSources,2,'%s',true)"%raw for original,entry in mapping.items() if entry['slot']!='Inventory' for raw in (original,entry.get('variant'),entry.get('offhand')) if raw]
    overlay = overlay.replace('    set gg_trg_Forsaken_Equipment=CreateTrigger()',
                              '\n'.join(initialization)+'\n    set gg_trg_Forsaken_Equipment=CreateTrigger()')
    source.write_bytes(overlay.replace('\n','\r\n').encode('utf-8'))
    job_source = work/'src/triggers/03 Jobs and progression/Job.j'
    job_source.write_bytes(job_overlay(job_source.read_text(encoding='utf-8')).replace('\n','\r\n').encode('utf-8'))
    defense_source=work/'src/triggers/04 Combat and abilities/MagicDefense.j'
    board_source=work/'src/triggers/09 Player features/Multiboard.j'
    board_source.write_bytes(multiboard_overlay(board_source.read_text(encoding='utf-8')).replace('\n','\r\n').encode('utf-8'))
    defense_source.write_bytes(defense_overlay(defense_source.read_text(encoding='utf-8'),mapping).replace('\n','\r\n').encode('utf-8'))
    for module, folder in [('Unit','04 Combat and abilities'),('Prof','03 Jobs and progression'),('Damage','04 Combat and abilities'),('TwoHanded','04 Combat and abilities'),('Element','04 Combat and abilities')]:
        path=work/'src/triggers'/folder/(module+'.j')
        path.write_bytes(active_gear_overlay(path.read_text(),module).replace('\n','\r\n').encode('utf-8'))
    for module,folder in [('Item_Shared','05 Items crafting and shops'),('Forge','05 Items crafting and shops'),('Loki','06 Quests and story')]:
        path=work/'src/triggers'/folder/(module+'.j')
        text=path.read_text().replace('GetItemType(', 'Forsaken_GearClass(')
        if module=='Forge': text=text.replace('library TForge requires','library TForge requires TUnit,',1)
        path.write_bytes(text.replace('\n','\r\n').encode('utf-8'))
    for module in ('Abil','Cooldown','Spell_Water'):
        path=work/'src/triggers/04 Combat and abilities'/(module+'.j')
        path.write_bytes(cast_overlay(path.read_text(encoding='utf-8'),module).replace('\n','\r\n').encode('utf-8'))
    print('Isolated sources:', work, flush=True)
    print('Mapped', sum(e['slot']!='Inventory' for e in mapping.values()), 'gear items; four Materia unchanged.', flush=True)
    run([sys.executable, work/'tools/build_stage.py', args.stage, '--base', base,
         '--allow-new', '^gg_trg_Forsaken_(Equipment|TestEquip|TalentClick|TalentSync|PanelAccess)$'], cwd=work)
    destination.mkdir(parents=True, exist_ok=True)
    classic.parent.mkdir(parents=True, exist_ok=True)
    for name in (basename, 'checks-r16-stage'+args.stage+'.txt', 'build-r16-stage'+args.stage+'.json'):
        shutil.copy2(work/'release'/name, destination/name)
    shutil.copy2(args.classic.resolve(), classic)
    shutil.copy2(scratch/'gear-slots.json', destination/('gear-slots-'+args.stage+'.json'))
    (destination/('forsaken-manifest-'+args.stage+'.json')).write_text(
        json.dumps(manifest(args.base.resolve(),args.classic.resolve(),final,classic,args.stage),indent=2)+'\n',
        encoding='utf-8')
    print('Published experimental Reforged:', final)
    print('Classic fallback is byte-identical to', args.classic)
    print('Normal sources/releases unchanged. Scratch sources retained:', work)


if __name__ == '__main__':
    main()

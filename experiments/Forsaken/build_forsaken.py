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
    for number, entry in enumerate(catalog.values()):
        raw = entry['item']
        slot = slot_for(entry, units[entry['unit']]['upoi'])
        mapping[raw] = dict(name=entry['name'], slot=slot or 'Inventory')
        if slot:
            variant = 'f%03d' % number
            if variant in items:
                raise ValueError('experimental item ID already used: ' + variant)
            obj = copy.deepcopy(items[raw])
            obj['id'] = variant
            set_field(obj, 'iequ', slot)
            table['custom'].append(obj)
            mapping[raw]['variant'] = variant
    ability_table = read_objects(archive.read('war3map.w3a'), 'w3a')
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
    imports=archive.read('war3map.imp') or struct.pack('<ii',1,0)
    version,count=struct.unpack_from('<ii',imports)
    imports=struct.pack('<ii',version,count+2)+imports[8:]+b'\x0dForsakenPanels.fdf\0\x0dForsakenPanels.toc\0'
    write_files(str(base), str(out), {
        'war3map.w3i': forsaken_map_info(archive.read('war3map.w3i')),
        'war3map.w3t': write_objects(table, table['version'], 'w3t'),
        'war3map.w3a': write_objects(ability_table, ability_table['version'], 'w3a'),
        'ForsakenPanels.fdf': (HERE/'ForsakenPanels.fdf').read_bytes(),
        'ForsakenPanels.toc': b'ForsakenPanels.fdf\r\n',
        'war3map.imp': imports,
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
                            'library TEquip requires TForce, TJob, TPlayerHero, TMagicDefense')
    text = text.replace('endglobals', '''    trigger gg_trg_Forsaken_Equipment=null
    trigger gg_trg_Forsaken_TestEquip=null
    timer ForsakenInventoryTimer=null
    hashtable ForsakenGearTypes=null
    item ForsakenEquippedItem=null
    boolean ForsakenSaveBlocked=false
    trigger gg_trg_Forsaken_TalentClick=null
    trigger gg_trg_Forsaken_TalentSync=null
    hashtable ForsakenTalentState=null
    framehandle ForsakenTalentRoot=null
    framehandle ForsakenTalentPoints=null
    framehandle array ForsakenTalentButton
    framehandle array ForsakenTalentIcon
    framehandle array ForsakenTalentLabel
    framehandle ForsakenDefenseRow=null
    framehandle ForsakenReductionRow=null
    framehandle ForsakenDefenseValue=null
    framehandle ForsakenReductionValue=null
    boolean ForsakenPanelFramesReady=false
endglobals''', 1)
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
          '    if GetItemEquipmentType(GetManipulatedItem())!=EQUIPMENT_TYPE_NONE then\n        return false\n    endif\n'
          '    return', 1)
    text = text[:conditions.start()] + body + text[conditions.end():]
    actions = re.search(r'function Trig_Equip_Restrictions_Actions.*?endfunction', text, re.S).group()
    validation = actions[actions.index('    if(Trig_Equip_Restrictions_GaiaLevelTooLow())'):]
    validation = 'function Forsaken_ValidateEquipment takes nothing returns nothing\n' + validation
    validation = validation.replace('UnitRemoveItemSwapped(', 'Forsaken_RejectEquipment(')
    validation = validation.replace('GetManipulatingUnit()', 'GetTriggerUnit()')
    extra = (HERE / 'Forsaken-extra.j').read_text(encoding='utf-8')
    extra = (HERE / 'Forsaken-panels.j').read_text(encoding='utf-8') + '\n\n' + extra
    extra = extra.replace('function Forsaken_OnEquip', validation + '\n\nfunction Forsaken_OnEquip', 1)
    text = text.replace('function Register_Equip_Restrictions takes', extra + '\n\nfunction Register_Equip_Restrictions takes', 1)
    text = text.replace('    call Register_Equip_Restrictions() //',
                        '    call Register_Forsaken_Equipment()\n    call Register_Forsaken_TestEquip()\n    call Register_Forsaken_TalentClick()\n    call Register_Forsaken_TalentSync()\n    call Register_Equip_Restrictions() //', 1)
    return text


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
            if equipped!=null and GetItemTypeId(equipped)==variant then
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


def manifest(base, classic_base, modern, classic, stage):
    def identity(path):
        return dict(file=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest())
    return dict(stage=stage, experimental=True, save_export_disabled=True,
                game_data_version='Forsaken Kingdom (2)',
                normal_development_stage='AS', base=identity(base),
                classic_base=identity(classic_base), output=identity(modern),
                classic_output=identity(classic),
                sources={p.name:identity(p) for p in HERE.iterdir() if p.suffix in ('.py','.j','.fdf')})


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
    source = work/'src/triggers/05 Items crafting and shops/Equip.j'
    overlay = equip_overlay(source.read_text(encoding='utf-8'))
    initialization = ['    set ForsakenGearTypes=InitHashtable()', '    set ForsakenDefenseTypes=InitHashtable()']
    initialization += ["    call SaveInteger(ForsakenDefenseTypes,0,'%s','%s')" % (raw,entry['variant'])
                       for raw, entry in mapping.items() if 'variant' in entry]
    initialization += ["    call SaveInteger(ForsakenGearTypes,0,'%s','%s')" % (raw,entry['variant'])
                       for raw, entry in mapping.items() if 'variant' in entry]
    slots = dict(Head=0,Chest=1,Gloves=2,Boots=3,Ring=4,Primary=6,Offhand=7,Trinket=8)
    initialization += ["    call SaveInteger(ForsakenGearTypes,1,'%s',%d)" % (raw,slots[entry['slot']])
                       for raw, entry in mapping.items() if 'variant' in entry]
    initialization += ["    call SaveInteger(ForsakenGearTypes,2,%d,'fT%02d')" % (i,i) for i in range(8)]
    initialization += ["    call SaveInteger(ForsakenGearTypes,3,%d,'fV%02d')" % (i,i) for i in range(48)]
    overlay = overlay.replace('    set gg_trg_Forsaken_Equipment=CreateTrigger()',
                              '\n'.join(initialization)+'\n    set gg_trg_Forsaken_Equipment=CreateTrigger()')
    source.write_bytes(overlay.replace('\n','\r\n').encode('utf-8'))
    job_source = work/'src/triggers/03 Jobs and progression/Job.j'
    job_source.write_bytes(job_overlay(job_source.read_text(encoding='utf-8')).replace('\n','\r\n').encode('utf-8'))
    defense_source=work/'src/triggers/04 Combat and abilities/MagicDefense.j'
    defense_source.write_bytes(defense_overlay(defense_source.read_text(encoding='utf-8'),mapping).replace('\n','\r\n').encode('utf-8'))
    print('Isolated sources:', work, flush=True)
    print('Mapped', sum(e['slot']!='Inventory' for e in mapping.values()), 'gear items; four Materia unchanged.', flush=True)
    run([sys.executable, work/'tools/build_stage.py', args.stage, '--base', base,
         '--allow-new', '^gg_trg_Forsaken_(Equipment|TestEquip|TalentClick|TalentSync)$'], cwd=work)
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

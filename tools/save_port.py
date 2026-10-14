"""Copy the new (FSVB) save system that Reforged uses into the normal map, for 1.29.2.

    python tools/save_port.py RUNTIME_MAP.w3x [--check]

The save system lives in experiments/Forsaken, where the Reforged map is built from it. This tool
never changes those files. It reads them and writes the same modules to
src/triggers/12 Save system/, changing the lines that ask Reforged's hero bag and equipment
slots where an item is: 1.29.2 has no such natives, so those questions go to TSaveSlots
(src/triggers/12 Save system/SaveSlots.j), which answers them from the backpack pages. The code,
its positions and the files it writes are otherwise exactly the Reforged ones, so a code or file
saved in either version loads in the other.

Player messages are also reworded (MESSAGES): the Reforged build is a test and reports test
details and timings, while the normal maps only say whether a save or load worked and why not.

RUNTIME_MAP is a built map of the normal line (any recent stage); the loader switches off every
trigger it names while it creates the loaded character, the same as the Reforged build does.
With --check nothing is written; the tool fails if the files in src differ from what it makes.

Each change is an exact match that must be found the expected number of times, so if the Reforged
sources change shape the tool stops instead of guessing.
"""
import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FORSAKEN = ROOT / 'experiments/Forsaken'
FOLDER = ROOT / 'src/triggers/12 Save system'
GEAR_SLOTS = ROOT / 'src/triggers/05 Items crafting and shops/GearSlots.j'
sys.path.insert(0, str(ROOT / 'tools'))
sys.path.insert(0, str(FORSAKEN))

# In dependency order: each library comes after the ones it requires.
MODULES = [
    ('ForsakenSaveCodec', 'Forsaken-save-codec.j'),
    ('ForsakenSaveLife', 'Forsaken-save-life.j'),
    ('ForsakenSaveCapture', 'Forsaken-save-capture.j'),
    ('ForsakenSaveCache', 'Forsaken-save-cache.j'),
    ('ForsakenSaveTransport', 'Forsaken-save-transport.j'),
    ('ForsakenSaveFreshPlan', 'Forsaken-save-fresh-plan.j'),
    ('ForsakenSaveFreshObjects', 'Forsaken-save-fresh-objects.j'),
    ('ForsakenFreshLoad', 'Forsaken-fresh-load.j'),
]
ADAPTER = 'SaveSlots'

KINDS = dict(PRIMARY='Primary', OFFHAND='Offhand', HEAD='Head', CHEST='Chest',
             GLOVES='Gloves', BOOTS='Boots', RING='Ring', TRINKET='Trinket')

# Reforged natives replaced everywhere they appear.
GENERIC = [
    (re.compile(r'UnitItemInEquipmentSlot\(([^,()]+),ConvertLoadoutSlot\(([^()]+)\)\)'), r'SaveSlots_Equip(\1,\2)'),
    (re.compile(r'\bUnitItemInBagSlot\('), 'SaveSlots_Bag('),
    (re.compile(r'\bUnitExtendedInventorySize\('), 'SaveSlots_BagSize('),
    (re.compile(r'BlzGetItemBooleanField\((\w+),ITEM_BF_CAN_BE_DROPPED\)'), r'SaveSlots_CanDrop(\1)'),
]

# Nothing on this list may survive the port. The transport's three sync natives are confined to
# its FSTSync_ wrappers, which tools/save_legacy.py empties for 1.29.2 as it always has.
FORBIDDEN = re.compile(r"\b(ConvertLoadoutSlot|UnitItemInBagSlot|UnitItemInEquipmentSlot|UnitExtendedInventorySize|"
                       r"UnitEquipItem|UnitUnequipItem|BlzGetItem\w*|BlzItem\w*|BlzSetItem\w*|BlzGetAbilityId|"
                       r"BlzSetHeroProperName|ForsakenBag\w*|ForsakenGear\w*|ForsakenSaveBlocked)\b|'(fBag|fGer|fGap|fGmk|ASpc)'")

PREPARE_HERO_OLD = """    // Normal Forsaken setup handlers are guarded during fresh creation.
    call UnitAddAbility(hero,'fBag')
    call UnitMakeAbilityPermanent(hero,true,'fBag')
    call UnitAddAbility(hero,'fGer')
    call UnitMakeAbilityPermanent(hero,true,'fGer')
    call UnitAddAbility(hero,'ASpc')
    call UnitMakeAbilityPermanent(hero,true,'ASpc')
    if UnitInventorySize(hero)!=6 or UnitExtendedInventorySize(hero)!=30 or GetUnitAbilityLevel(hero,'fGer')==0 then
        set FFL_Error[pid]="hero inventory setup quick="+I2S(UnitInventorySize(hero))+" bag="+I2S(UnitExtendedInventorySize(hero))+" equipment="+I2S(GetUnitAbilityLevel(hero,'fGer'))
        return false
    endif
"""
PREPARE_HERO_NEW = """    // 1.29.2: the bag and worn gear are the backpack pages (TSaveSlots), so the hero needs no
    // bag or equipment ability; the Backpack button is given to every player hero by TBackpack.
    if UnitInventorySize(hero)!=6 or SaveSlots_BagSize(hero)!=30 then
        set FFL_Error[pid]="hero inventory setup quick="+I2S(UnitInventorySize(hero))+" bag="+I2S(SaveSlots_BagSize(hero))
        return false
    endif
"""

STRIP_STORAGE = """// 1.29.2: nothing to suspend. A stored item never gives the hero its bonuses here: the
// backpack grants worn gear's bonuses itself, from the equipment pages only.
function FFL_StripStorage takes item carried returns boolean
    return carried!=null
endfunction"""

PREPARE_STORED = """// 1.29.2: a new item is only checked against what was saved. Reforged first passes each item
// through the hero to suspend its bag bonuses; the backpack needs no such step.
function FFL_PrepareStored takes integer pid,integer ordinal returns boolean
    if not FFN_MetadataMatches(pid,ordinal) then
        set FFL_Error[pid]=FFL_Error[pid]+" metadata readback"
        return false
    endif
    return true
endfunction"""

PLACE = """// 1.29.2: an item goes straight to its slot. Bag and equipment positions are backpack pages
// (TSaveSlots); quick slots, Gaya and the house are the unit's own six slots.
function FFL_Place takes integer pid,integer ordinal returns boolean
    local integer index=pid*57+ordinal
    local integer kind=FFP_Holder[index]
    local integer slot=FFP_Slot[index]
    local unit holder=FFN_Unit[pid*3]
    local item carried=FFN_Item[index]
    local boolean placed
    if kind==4 then
        set holder=FFN_Unit[pid*3+1]
    elseif kind==5 then
        set holder=udg_PlayerHouse[pid+1]
    endif
    if FFL_At(holder,kind,slot)!=null then
        set FFL_Error[pid]=FFL_Error[pid]+" destination occupied"
        return false
    endif
    if kind==2 or kind==3 then
        set placed=SaveSlots_Place(pid,kind,slot,carried)
    else
        set placed=SaveSlots_PlaceOn(holder,slot,carried)
    endif
    if not placed or FFL_At(holder,kind,slot)!=carried then
        set FFL_Error[pid]=FFL_Error[pid]+" destination readback"
        return false
    endif
    if not FFN_MetadataMatches(pid,ordinal) then
        set FFL_Error[pid]=FFL_Error[pid]+" metadata readback"
        return false
    endif
    set holder=null
    set carried=null
    return true
endfunction"""

PATCHES = {
    'ForsakenSaveCapture': [
        ('library TForsakenSaveCapture requires TForsakenSaveLife\n',
         'library TForsakenSaveCapture requires TForsakenSaveLife, TSaveSlots\n', 1),
        ('    if UnitExtendedInventorySize(udg_PlayerHero[pid+1])!=30 then\n',
         '    if not SaveSlots_Ready(pid) then\n', 1),
    ],
    'ForsakenSaveFreshObjects': [
        ('    call SetItemDroppable(carried,', '    call SaveSlots_SetDroppable(carried,', 1),
        ('    call BlzSetHeroProperName(created,udg_PlayerName[pid+1])\n',
         '    // 1.29.2 has no native to rename a hero, so it keeps its job name.\n', 1),
    ],
    'ForsakenFreshLoad': [
        ('library TForsakenFreshLoad requires TForsakenSaveFreshObjects, TForsakenSaveTransport,',
         'library TForsakenFreshLoad requires TForsakenSaveFreshObjects, TForsakenSaveTransport, TSaveSlots,', 1),
        (PREPARE_HERO_OLD, PREPARE_HERO_NEW, 1),
        ('            call FlushChildHashtable(ForsakenBagAbilities,FFL_ItemKey[pid*57+i])\n', '', 1),
        ('ForsakenSaveBlocked', 'SAVE_NEW_FORMAT', 1),
        ('    call FFL_Guard(false)\n    call FFL_RestoreUnlocks(pid)\n',
         '    call FFL_Guard(false)\n    call FFL_RestoreUnlocks(pid)\n    call SaveSlots_AfterLoad(pid)\n', 1),
        ('function InitTrig_ForsakenFreshLoad takes nothing returns nothing\n    local integer pid=0\n',
         'function InitTrig_ForsakenFreshLoad takes nothing returns nothing\n    local integer pid=0\n'
         '    if not SAVE_NEW_FORMAT then\n        return\n    endif\n', 1),
    ],
}
# What players read. The Reforged build was a test, so its messages carry test wording and
# timings; the normal maps only say whether a save or load worked and, if not, why. Every
# message is matched exactly, like the rest of the port.
MESSAGES = {
    'ForsakenFreshLoad': [
        ('"Save prototype: "+message', 'message', 1),
        ('"FAIL: "+reason+"; created objects cleaned, load unused; retry allowed."',
         '"Load failed: "+reason+". Nothing was changed; you can load again."', 1),
        ('"FAIL: "+reason+"; verifying cleanup before retry"', '"Load failed: "+reason+". Cleaning up, please wait."', 1),
        ('"FAIL: "+FFP_Error[pid]', '"Load failed: "+FFP_Error[pid]', 1),
        ('"PASS: exact full profile after fresh load. Code "+I2S(StringLength(FST_Result[pid]))+" characters; file read ~"+I2S(FST_FileMillis[pid])+" ms (game timer); transfer "+R2S(FST_TransferSeconds[pid])+" s; load/verify "+R2S(TimerGetElapsed(FST_Clock)-FFL_Started[pid])+" s."',
         '"|cff00ff00Load complete.|r"', 1),
        ('call FFL_Message(pid,FFP_Error[pid])', 'call FFL_Message(pid,"Load not possible: "+FFP_Error[pid])', 2),
        ('"invalid numbered code part; paste the complete -load line"', '"That load line is incomplete. Paste the whole -load line."', 1),
        ('"received code part "+I2S(part)+"; "+I2S(FFL_ChatCount[pid])+"/"+I2S(total)+" stored. Character unchanged until all parts validate."',
         '"Load: part "+I2S(part)+" received ("+I2S(FFL_ChatCount[pid])+" of "+I2S(total)+"). Type -loadstatus to see which parts are missing."', 1),
        ('"assembled code checksum failed; paste all parts again"', '"Load failed: the parts do not fit together. Paste all of them again."', 1),
        ('"load rejected before creation: "+FFP_Error[pid]', '"Load failed: "+FFP_Error[pid]', 2),
        ('"no chat load in progress; paste the first -load line"', '"No load in progress. Paste the first -load line."', 1),
        ('"chat load: all "+I2S(total)+" parts stored"', '"Load: all "+I2S(total)+" parts received."', 1),
        ('"chat load: "+I2S(FFL_ChatCount[pid])+"/"+I2S(total)+" stored; still need part "+parts',
         '"Load: "+I2S(FFL_ChatCount[pid])+" of "+I2S(total)+" parts received. Still missing part "+parts', 1),
        ('"no failed load requires cleanup"', '"Nothing to clean up."', 1),
        ('"another save/load is in progress"', '"Another save or load is still running."', 1),
        ('"filename must use letters', '"File names must use letters', 1),
        ('"saving is disabled in Hardcore"', '"Saving is disabled in Hardcore."', 1),
        ('"capturing the full character"', '"Saving..."', 1),
        ('"could not start character capture"', '"Save failed: the character could not be read. Try again in a moment."', 1),
        ('"reading file and transferring the complete profile"', '"Loading..."', 1),
        ('"capture verified; exporting the file"', '"Writing the save file..."', 1),
        ('"export refused: "+FSC_Error[pid]', '"Save failed: "+FSC_Error[pid]', 1),
        ('"export failed: "+FRC_Error[pid]', '"Save failed: "+FRC_Error[pid]', 1),
        ('"file/transfer failed: "+FST_Error[pid]', '"Load failed: "+FST_Error[pid]', 1),
        ('"FAIL: "+FFL_FailureReason[pid]+"; created objects cleaned, load unused; retry allowed."',
         '"Load failed: "+FFL_FailureReason[pid]+". Nothing was changed; you can load again."', 1),
        ('"FAIL: "+FFL_FailureReason[pid]+"; cleanup incomplete. Use -newcleanup before retry."',
         '"Load failed: "+FFL_FailureReason[pid]+". Type -newcleanup, then load again."', 1),
    ],
    'ForsakenSaveTransport': [
        ('"Save prototype: file written; checking exact readback."', '"Save file written; checking it..."', 1),
        ('"Save prototype: file written and read back exactly ("+I2S(StringLength(encoded))+" characters). File: "+FST_PlayerPath(pid,0)',
         '"|cff00ff00Saved.|r File: "+FST_PlayerPath(pid,0)', 1),
        ('"Save prototype: file readback failed: "+FST_FileError[pid]+"; expected "+I2S(StringLength(encoded))+" characters. Export unverified."',
         '"Saved, but the file could not be checked ("+FST_FileError[pid]+"). Save again to be sure."', 1),
        ('"Save prototype: file readback failed: expected "+I2S(StringLength(encoded))+" characters, received "+I2S(StringLength(readback))+"; prefix ["+SubString(readback,0,4)+"]. Export unverified."',
         '"Saved, but the file did not read back the same. Save again to be sure."', 1),
    ],
    'ForsakenSaveFreshPlan': [
        ('"CU requires the untouched starting character and Gaya"', '"load at the start of a game, before leveling the hero or Gaya"', 1),
        ('"CU requires fresh job progress"', '"load at the start of a game, before changing or leveling jobs"', 1),
        ('"saved job exceeds the current engine cap99"', '"a saved job is above level 99"', 1),
        ('"saved Freelancer exceeds the current engine cap99"', '"the saved Freelancer is above level 99"', 1),
        ('"; export again if this file was made before DE"', '""', 1),
    ],
}

FUNCTIONS = {
    'ForsakenFreshLoad': [
        ('FFL_StripStorage', 'function FFL_StripStorage takes item carried returns boolean', STRIP_STORAGE),
        ('FFL_PrepareStored', 'function FFL_PrepareStored takes integer pid,integer ordinal returns boolean', PREPARE_STORED),
        ('FFL_Place', 'function FFL_Place takes integer pid,integer ordinal returns boolean', PLACE),
    ],
}


def read(path):
    return path.read_bytes().decode('utf-8').replace('\r\n', '\n')


def gear_catalog():
    """Slot of every equipment item, from the same classification the backpack uses."""
    text = read(GEAR_SLOTS)
    found = re.findall(r"SaveInteger\(GearSlotTable,1,'(\w{4})',GEAR_(\w+)\)", text)
    if len(found) < 200:
        raise ValueError('GearSlots.j has an unexpected layout')
    return {raw: dict(slot=KINDS[kind]) for raw, kind in found}


def replace_function(text, name, header, body):
    pattern = re.compile(r'(?:^//[^\n]*\n)*^function %s takes[^\n]*\n.*?^endfunction' % re.escape(name), re.M | re.S)
    matches = pattern.findall(text)
    if len(matches) != 1:
        raise ValueError('expected one function %s, found %d' % (name, len(matches)))
    if header not in matches[0].splitlines():
        raise ValueError('%s changed its signature; review the port' % name)
    return pattern.sub(lambda m: body, text)


def port(module, text):
    for old, new, count in PATCHES.get(module, []):
        found = text.count(old)
        if found != count:
            raise ValueError('%s: expected %d of %r, found %d' % (module, count, old[:70], found))
        text = text.replace(old, new)
    for old, new, count in MESSAGES.get(module, []):
        found = text.count(old)
        if found != count:
            raise ValueError('%s: expected %d of message %r, found %d' % (module, count, old[:70], found))
        text = text.replace(old, new)
    for name, header, body in FUNCTIONS.get(module, []):
        text = replace_function(text, name, header, body)
    for pattern, replacement in GENERIC:
        text = pattern.sub(replacement, text)
    bad = FORBIDDEN.search(text)
    if bad:
        raise ValueError('%s: Reforged-only name left after the port: %s' % (module, bad.group(0)))
    return text


def runtime_without_save(runtime, sources):
    """The map's trigger list, minus triggers that belong to the save system itself."""
    own = set()
    for text in sources:
        own |= set(re.findall(r'^\s*trigger\s+(\w+)\s*=', text, re.M))
    own |= {'gg_trg_' + module for module, _ in MODULES} | {'gg_trg_' + ADAPTER}
    return re.sub(r'^\s*trigger\s+(\w+)\s*=[^\n]*\n', lambda m: '' if m.group(1) in own else m.group(0), runtime, flags=re.M)


def generate(runtime_map):
    import save_registry
    from build_save_probe import capture_source, fresh_plan_source
    from build_save_roundtrip import load_source
    from mpq import MPQ
    registry, _ = save_registry.check()
    canonical = {r['rawcode']: r['id'] for r in registry['items']}
    catalog = gear_catalog()
    missing = [raw for raw in catalog if raw not in canonical]
    if missing:
        raise ValueError('gear without a permanent save identity: ' + ','.join(missing))
    plain = {module: read(FORSAKEN / file) for module, file in MODULES}
    runtime = MPQ(str(runtime_map)).read('war3map.j').decode('utf-8', 'replace').replace('\r\n', '\n')
    runtime = runtime_without_save(runtime, list(plain.values()) + [read(FOLDER / (ADAPTER + '.j'))])
    out = {}
    for module, file in MODULES:
        if module == 'ForsakenSaveCapture':
            text = capture_source(canonical)
        elif module == 'ForsakenSaveFreshPlan':
            text = fresh_plan_source(registry, catalog)
        elif module == 'ForsakenFreshLoad':
            text = load_source(runtime)
        else:
            text = plain[module]
        text = text.replace('\r\n', '\n')
        if module != 'ForsakenFreshLoad':
            text = text.replace('endlibrary', 'function InitTrig_' + module + ' takes nothing returns nothing\nendfunction\nendlibrary')
        text = port(module, text)
        first, rest = text.split('\n', 1)
        notice = ('// Generated by tools/save_port.py from experiments/Forsaken/%s (the Reforged save).\n'
                  '// Edit that file and run the tool again; only slot lookups and player messages differ.\n' % file)
        out[module] = first + '\n' + notice + rest
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('runtime', type=Path)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    out = generate(args.runtime)
    stale = []
    for module, text in out.items():
        path = FOLDER / (module + '.j')
        data = text.replace('\n', '\r\n').encode('utf-8')
        if args.check:
            if not path.exists() or path.read_bytes() != data:
                stale.append(path.name)
        else:
            path.write_bytes(data)
    if stale:
        sys.exit('out of date: ' + ', '.join(stale))
    print('%s %d save modules in %s' % ('checked' if args.check else 'wrote', len(out), FOLDER.relative_to(ROOT)))


if __name__ == '__main__':
    main()

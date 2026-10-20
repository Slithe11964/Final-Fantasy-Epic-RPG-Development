"""Finalize Forsaken's 3.0 API names in both playable and editor JASS.

Internal profile adapters retain their shared input vocabulary. Published native
maps use only the supported Blz names; classic maps never run this pass.
"""
import re
from collections import Counter
from mpq import MPQ,write_files
from wct import read_wct,write_wct,text_of,raw_of

RENAMES={name:'Blz'+name for name in (
    'GetEquippedItem','GetUnequippedItem','IsItemEquipped','IsItemInBag',
    'GetItemEquipmentType','GetItemTag','UnitEquipItem','UnitUnequipItem',
    'UnitUnequipItemFromSlot','UnitHasItemBagged','UnitExtendedInventorySize',
    'UnitItemInBagSlot','UnitItemInEquipmentSlot','UnitHasItemEquipped',
    'UnitHasLoadoutSlotEmpty','UnitHasItemEquipmentOfType',
    'UnitCanEquipItemOfEquipmentType','SetItemColor')}
# Blizzard corrected the spelling in the new native, too.
RENAMES['UnitHasAnyItemEquiped']='BlzUnitHasAnyItemEquipped'
LEX=re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|//[^\n]*|/\*.*?\*/|\b[A-Za-z_]\w*\b',re.S)


def migrate(source):
    counts=Counter()
    def replace(match):
        word=match[0]
        if word in RENAMES:
            counts[word]+=1
            return RENAMES[word]
        return word
    return LEX.sub(replace,source),dict(counts)


def finalize(source,target):
    archive=MPQ(str(source));wct=read_wct(archive.read('war3map.wct'))
    runtime,counts=migrate(archive.read('war3map.j').decode('utf-8'))
    header,_=migrate(text_of(wct['header']));wct['header']=raw_of(header)
    wct['entries']=[raw_of(migrate(text_of(entry))[0]) for entry in wct['entries']]
    write_files(str(source),str(target),{'war3map.j':runtime.encode('utf-8'),
                                         'war3map.wct':write_wct(wct)})
    return counts


def future_header(source):
    """Compile with the deprecated declarations removed, as Blizzard announced."""
    return '\n'.join(line for line in source.split('\n')
                     if not (match:=re.search(r'\bnative\s+(\w+)\s+takes\b',line))
                     or match[1] not in RENAMES)

"""Read-only current-map inventory target; no allocation, placement or load route."""
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
from types import MappingProxyType
import re

import build_forsaken  # Registers the shared object/MPQ tool imports.
from mpq import MPQ
from objdata import read_objects, fields
import save_progression as progression
import save_registry as registry
import save_transaction as transaction
import save_vnext as codec

EQUIPMENT_SLOTS=('Head','Chest','Gloves','Boots','Ring','Ring','Primary','Offhand','Trinket')


@dataclass(frozen=True)
class RuntimeCatalog:
    map_hash: str
    mapping_hash: str
    items: dict
    mapping: dict
    objects: dict
    passives: frozenset


@dataclass(frozen=True)
class Placement:
    material: transaction.Material
    stored: bool
    effects: tuple


@dataclass(frozen=True)
class InventoryPlan:
    envelope: codec.Envelope
    catalog_hashes: tuple
    placements: tuple
    dormant: tuple
    reserved_positions: tuple


def catalog(map_path, mapping_path):
    map_path,mapping_path=Path(map_path),Path(mapping_path)
    mapping=json.loads(mapping_path.read_text(encoding='utf-8'))
    identities,_=registry.check(mapping)
    archive=MPQ(str(map_path))
    objects={}
    for name in ('war3map.w3t','war3mapSkin.w3t'):
        data=archive.read(name)
        if data:
            table=read_objects(data,'w3t')
            for group in ('original','custom'):
                for obj in table[group]:
                    objects.setdefault(obj['id'] or obj['base'],{}).update(fields(obj))
    passive=re.findall(r"SaveBoolean\(\s*ForsakenBagPassiveTypes\s*,\s*0\s*,\s*'(.{4})'\s*,\s*true\s*\)",archive.read('war3map.j').decode('utf-8'))
    if not passive:
        raise transaction.Failure('runtime stored-passive policy is unresolved')
    # Cross-check the supplied alias mapping against the actual item's native slot.
    for raw,entry in mapping.items():
        for alias,slot in ((entry.get('variant'),entry['slot']),(entry.get('offhand'),'Offhand')):
            if alias and (alias not in objects or objects[alias].get('iequ')!=slot):
                raise transaction.Failure('mapping differs from actual native item slot')
    return RuntimeCatalog(hashlib.sha256(map_path.read_bytes()).hexdigest(),
                          hashlib.sha256(mapping_path.read_bytes()).hexdigest(),
                          MappingProxyType({r['id']:r['rawcode'] for r in identities['items']}),
                          MappingProxyType({k:MappingProxyType(dict(v)) for k,v in mapping.items()}),
                          MappingProxyType({k:MappingProxyType(dict(v)) for k,v in objects.items()}),frozenset(passive))


def runtime_raw(runtime, identity, holder, slot):
    raw=runtime.items[identity]
    mapped=runtime.mapping.get(raw)
    if holder==3:
        wanted=EQUIPMENT_SLOTS[slot]
        if not mapped or 'variant' not in mapped:
            raise transaction.Failure('non-equipment item in equipment slot')
        if wanted=='Offhand' and mapped['slot']=='Primary':
            return mapped['offhand']
        if mapped['slot']!=wanted:
            raise transaction.Failure('equipment item belongs to a different slot')
        return mapped['variant']
    if holder==2 and mapped and 'variant' in mapped:
        return mapped['variant']
    # Original canonical objects remain the Gaya/house/quick inventory form.
    return raw


def plan(envelope, expected_account, pid, runtime, charge_defaults=None, legacy_defaults=None, ability_defaults=None):
    """Freeze a complete target before any native mutation.

    Missing inherited object defaults must be supplied from reviewed runtime data.
    Legacy life/flags are never guessed from a base object or a display tooltip.
    """
    if type(pid) is not int or not 0<=pid<8:
        raise transaction.Failure('invalid player binding context')
    if type(expected_account) is not int or not 0<=expected_account<1048576 or envelope.account_hash!=expected_account:
        raise transaction.Failure('account mismatch')
    snapshot=progression.snapshot(envelope)
    if snapshot['core']['cheater_flag']:
        raise transaction.Failure('cheat status requires reviewed inventory policy')
    if snapshot['migration'] is not None:
        import migrate_save
        if not migrate_save.comparison(envelope)['equal']:
            raise transaction.Failure('legacy evidence comparison failed')
    charge_defaults=charge_defaults or {};legacy_defaults=legacy_defaults or {};ability_defaults=ability_defaults or {}
    placements,dormant,reserved=[],[],[]
    for record in sorted(snapshot['inventory'],key=lambda r:(r[2],r[3])):
        _,identity,holder,slot,quantity,_,metadata=record
        reserved.append((holder,slot))
        if identity not in runtime.items or any(i not in (1,2) for i,_,_ in metadata):
            dormant.append(transaction.Dormant(record));continue
        raw=runtime_raw(runtime,identity,holder,slot)
        definition=runtime.objects.get(raw)
        if definition is None:
            raise transaction.Failure('runtime object definition is unresolved')
        charges=quantity if quantity is not None else charge_defaults.get(identity,definition.get('iuse'))
        if type(charges) is not int or not 0<=charges<=127:
            raise transaction.Failure('reviewed charge default is unresolved')
        meta={i:data for i,_,data in metadata}
        if not {1,2}<=meta.keys():
            fallback=legacy_defaults.get((identity,holder,slot))
            if snapshot['migration'] is None or fallback is None or fallback.rawcode!=raw:
                raise transaction.Failure('legacy life/flags defaults are unresolved')
        else:
            # Explicit values will replace these placeholders in resolve_item.
            fallback=transaction.Defaults(raw,charges,1.,0)
        material=transaction.resolve_item(record,pid,set(runtime.items),
                    {(identity,holder,slot):transaction.Defaults(raw,charges,fallback.life,fallback.flags)},
                    snapshot['migration'] is not None)
        if 'iabi' in definition:
            abilities=tuple(a for a in definition['iabi'].split(',') if a)
        elif raw in ability_defaults:
            abilities=tuple(ability_defaults[raw])
        else:
            raise transaction.Failure('inherited item ability defaults are unresolved')
        if any(not isinstance(a,str) or len(a)!=4 for a in abilities):
            raise transaction.Failure('invalid runtime ability binding')
        if len(abilities)>16 or len(set(abilities))!=len(abilities):
            raise transaction.Failure('runtime item abilities exceed exact audit capacity')
        effects=tuple((a,1 if a in runtime.passives and a!='fGmk' else 2) for a in abilities)
        placements.append(Placement(material,holder==2,effects))
    return InventoryPlan(envelope,(runtime.map_hash,runtime.mapping_hash),tuple(placements),
                         tuple(dormant),tuple(reserved))

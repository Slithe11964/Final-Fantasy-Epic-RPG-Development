"""Reference controller fault injection, not native Warcraft restoration."""
from copy import deepcopy
from dataclasses import dataclass, asdict
import json
from pathlib import Path
import unittest

import migrate_save as migration
import save_progression as progression
import save_transaction as tx
import save_vnext as codec
from test_save_migration import native_sections


@dataclass
class Item:
    handle: int
    rawcode: str
    charges: int
    life: float
    flags: int
    user_data: int
    owner: int
    hidden: bool = False
    passives: tuple = ()
    cooldown: float = 0.


def target(count=57, dormant=False):
    records = []
    for holder, size in codec.HOLDERS.items():
        for slot in range(size):
            if len(records) >= count: break
            identity = 1000+len(records)
            records.append((len(records)+1, identity, holder, slot,
                            [None, 0, 120, 127][len(records) % 4], bool(len(records) % 2),
                            ((1, True, codec.life_words(145.25)), (2, True, codec.uint(5)))))
    if dormant:
        last = records[-1]
        records[-1] = last[:6]+(last[6]+((100, False, 'ABC'),),)
    sections = (codec.Section(1, 1, True, codec.inventory(records)),
                codec.Section(2, 1, True, codec.pairs([(i, 100) for i in range(1, 43)])))+native_sections()
    sections += (codec.Section(100, 1, False, 'ABC123'),)
    return codec.Envelope(42, sections)


class Backend:
    """Test double with real object identities, journals and deliberately partial faults."""
    def __init__(self, envelope, fault=None, nth=1):
        self.fault, self.nth, self.calls = fault, nth, {}
        self.busy, self.frozen, self.used, self.eligible = False, False, False, True
        self.accepted, self.last_save, self.revision = None, 'prior-good-file', 12
        self.items, self.positions, self.reserved = {}, {}, {}
        for i, position in enumerate([(1, 0), (2, 7), (3, 4), (3, 5), (4, 5), (5, 5)]):
            handle = i+900
            self.items[handle] = Item(handle, 'old'+str(i), 127-i, 42.25+i, i % 8,
                                      i % 3, 10+i, passives=('old-bonus',), cooldown=37.5+i)
            self.positions[position] = handle
        self.reserved[(2, 29)] = (100, 90000, 2, 29, 127, True, ((99, False, 'XYZ'),))
        self.progress = dict(core={'gold': 123, 'shards': 4, 'speedrun_level': 0}, jobs={1: 12},
                             gaya={'level': 1}, upgrades={1: 1}, titles=[18], armory=[29])
        self.available = set()
        self.defaults = {}
        for record in progression.snapshot(envelope)['inventory']:
            identity, holder, slot = record[1:4]
            self.available.add(identity)
            self.defaults[identity, holder, slot] = tx.Defaults(
                ('equipped-' if holder == 3 else 'stored-')+str(identity), 1, 99., 6)
        self.allocated = []
        self.next_handle = 10000
        self.last_journal = None
        self.before = self.image()

    def hit(self, phase):
        self.calls[phase] = self.calls.get(phase, 0)+1
        if self.fault == phase and self.calls[phase] == self.nth:
            raise tx.Failure('injected '+phase)

    def image(self):
        return deepcopy(dict(items={h: asdict(i) for h, i in self.items.items()},
            positions=self.positions, reserved=self.reserved, progress=self.progress,
            used=self.used, accepted=self.accepted, last_save=self.last_save, revision=self.revision))

    def validate_policy(self, snapshot):
        if not self.eligible: raise tx.Failure('runtime mode/eligibility rejected')

    def acquire(self):
        if self.busy or self.frozen or self.used: return False
        self.busy = True
        return True

    def release(self): self.busy = False

    def journal(self):
        self.hit('journal')
        self.last_journal = dict(image=self.image(), objects=dict(self.items))
        return self.last_journal

    def project_progression(self, snapshot):
        self.hit('project')
        result = deepcopy(self.progress)
        result['core'].update(snapshot['core'])  # Absent legacy fields keep explicit current defaults.
        result.update(gaya=deepcopy(snapshot['gaya']), upgrades=deepcopy(snapshot['upgrades']),
                      jobs={i: v for i, v in snapshot['jobs'].items() if i <= 22},
                      titles=[i for i in snapshot['titles'] if i <= 59],
                      armory=[i for i in snapshot['armory'] if i in self.available])
        return result

    def resolve(self, record, legacy):
        self.hit('resolve')
        return tx.resolve_item(record, 0, self.available, self.defaults, legacy)

    def create_hidden(self, spec):
        self.hit('create')
        handle = self.next_handle
        self.next_handle += 1
        self.items[handle] = Item(handle, spec.rawcode, 0, 1., 0, 0, 0, hidden=True)
        # Backend owns allocations immediately, even before returning a handle.
        self.allocated.append(handle)
        self.hit('created')
        return handle

    def configure_hidden(self, handle, spec):
        self.hit('configure')
        item = self.items[handle]
        item.charges, item.life, item.flags = spec.charges, spec.life, spec.flags
        item.user_data, item.owner = spec.user_data, spec.owner
        self.hit('configured')

    def verify_original(self, journal):
        self.hit('verify_original')
        current = self.image()
        current['items'] = {h: i for h, i in current['items'].items() if h not in self.allocated}
        if current != journal['image']: raise tx.Failure('original world changed')

    def quarantine_originals(self, journal):
        for position, handle in list(self.positions.items()):
            self.hit('quarantine')
            del self.positions[position]
            self.items[handle].hidden = True
            self.items[handle].passives = ()
            self.hit('quarantined')
        self.reserved.clear()

    def place(self, handle, spec):
        self.hit('place')
        position = spec.record[2:4]
        if position in self.positions or position in self.reserved: raise tx.Failure('occupied slot')
        self.positions[position] = handle
        self.items[handle].hidden = False
        self.hit('placed')
        if position[0] == 3:
            self.hit('equip')
            self.items[handle].passives = ('equipped-bonus',)
        else:
            self.hit('suspend')
            self.items[handle].passives = ()

    def reserve(self, spec):
        self.hit('reserve')
        position = spec.record[2:4]
        if position in self.positions or position in self.reserved: raise tx.Failure('occupied slot')
        self.reserved[position] = spec.record
        self.hit('reserved')

    def apply_progression(self, target_progress):
        for name, value in target_progress.items():
            self.progress[name] = deepcopy(value)
            self.hit('progression')

    def verify_staged(self, resolved, expected):
        self.hit('verify_staged')
        wanted_positions, wanted_reserved = set(), {}
        for spec in resolved:
            position = spec.record[2:4]
            if isinstance(spec, tx.Dormant):
                wanted_reserved[position] = spec.record
                continue
            wanted_positions.add(position)
            item = self.items[self.positions[position]]
            actual = item.rawcode, item.charges, item.life, item.flags, item.user_data, item.owner, item.hidden
            wanted = spec.rawcode, spec.charges, spec.life, spec.flags, spec.user_data, spec.owner, False
            if actual != wanted: raise tx.Failure('placed metadata mismatch')
            if position[0] != 3 and item.passives: raise tx.Failure('stored passive bonus')
            if position[0] == 3 and item.passives != ('equipped-bonus',): raise tx.Failure('equip rejected')
        if set(self.positions) != wanted_positions or self.reserved != wanted_reserved or self.progress != expected:
            raise tx.Failure('staged world mismatch')

    def publish(self, envelope):
        self.hit('publish')
        self.accepted, self.used = envelope, True
        self.revision += 1
        self.hit('published')

    def retire_originals(self, journal):
        for handle in journal['objects']:
            if handle in self.items:
                self.hit('cleanup')
                if not self.items[handle].hidden: raise tx.Failure('original is not quarantined')
                del self.items[handle]

    def recover(self, journal, created):
        self.hit('recover')
        # Verify original objects still exist. Recreating them would lose cooldown/handle state.
        if any(self.items.get(h) is not item for h, item in journal['objects'].items()):
            raise tx.Failure('original handle lost')
        for handle in self.allocated:
            self.items.pop(handle, None)
        for handle, item in journal['objects'].items():
            item.__dict__.update(deepcopy(journal['image']['items'][handle]))
            self.hit('recover_item')
        old = journal['image']
        self.positions, self.reserved, self.progress = deepcopy((old['positions'], old['reserved'], old['progress']))
        self.used, self.accepted = old['used'], old['accepted']
        self.last_save, self.revision = old['last_save'], old['revision']

    def verify_recovery(self, journal, created):
        self.hit('verify_recovery')
        if self.image() != journal['image']: raise tx.Failure('rollback verification mismatch')
        if any(self.items[h] is not item for h, item in journal['objects'].items()):
            raise tx.Failure('rollback replaced original handle')

    def verify_unstarted(self):
        if self.image() != self.before: raise tx.Failure('journal failure mutated world')

    def contain(self): self.frozen = True


class TransactionTests(unittest.TestCase):
    def test_capture_all57_positions_is_independent_of_loading_player_slot(self):
        expected = progression.snapshot(target())['inventory']
        for pid in [0, 7]:
            live, aliases = [], {}
            for record in expected:
                ordinal, identity, holder, slot, quantity, bound, metadata = record
                raw = 'alias-'+str(identity)
                aliases[raw] = tx.ItemType(identity, quantity is not None, 1)
                live.append(tx.LiveItem(ordinal+900, raw, holder, slot,
                    quantity if quantity is not None else 1,
                    codec.read_life(metadata[0][2]), pid+1 if bound else 0, 5))
            self.assertEqual(codec.read_inventory(tx.capture_inventory(live, pid, aliases))[0], expected)

    def test_capture_sparse_aliases_binding_quantity_and_flags_without_mutation(self):
        aliases = {'orig': tx.ItemType(29, False, 1), 'f003': tx.ItemType(29, False, 1),
                   'g003': tx.ItemType(29, False, 1), 'potion': tx.ItemType(7, True, 0)}
        items = [tx.LiveItem(1, 'orig', 2, 7, 1, 145.25, 0, 5),
                 tx.LiveItem(2, 'f003', 3, 4, 1, 145.25, 1, 5),
                 tx.LiveItem(3, 'g003', 3, 5, 1, 145.25, 1, 5),
                 tx.LiveItem(4, 'potion', 1, 0, 127, 20., 1, 7)]
        before = deepcopy(items)
        result, _ = codec.read_inventory(tx.capture_inventory(items, 0, aliases))
        self.assertEqual([r[1] for r in result], [7, 29, 29, 29])
        self.assertEqual([r[4] for r in result], [127, None, None, None])
        self.assertEqual([r[5] for r in result], [True, False, True, True])
        self.assertEqual([r[2:4] for r in result], [(1, 0), (2, 7), (3, 4), (3, 5)])
        self.assertEqual(items, before)

    def test_capture_refuses_duplicate_foreign_unresolved_and_inflight_state(self):
        aliases = {'item': tx.ItemType(7, True, 0)}
        good = tx.LiveItem(1, 'item', 2, 7, 120, 145.25, 1, 5)
        for values in [[good, good], [tx.LiveItem(2, 'item', 2, 7, 0, 1., 1, 5), good],
                       [tx.LiveItem(1, 'unknown', 2, 7, 120, 1., 1, 5)],
                       [tx.LiveItem(1, 'item', 2, 7, 120, 1., 2, 5)],
                       [tx.LiveItem(1, 'item', 2, 7, 120, 1., 1, None)],
                       [tx.LiveItem(1, 'item', 2, 7, 128, 1., 1, 5)]]:
            with self.assertRaises(ValueError): tx.capture_inventory(values, 0, aliases)
        with self.assertRaises(tx.Failure): tx.capture_inventory([good], 0, aliases, ready=False)
        with self.assertRaises(tx.Failure): tx.capture_inventory([good], -1, aliases)
        with self.assertRaises(tx.Failure):
            tx.capture_inventory([good], 0, {'item': tx.ItemType(7, False, 1)})

    def test_capture_keeps_unavailable_records_and_reserves_slots(self):
        record = (17, 50000, 2, 29, 127, True, ((99, False, 'XYZ'),))
        item = tx.LiveItem(1, 'item', 2, 7, 120, 145.25, 1, 5)
        aliases = {'item': tx.ItemType(7, True, 0)}
        rows, _ = codec.read_inventory(tx.capture_inventory([item], 0, aliases, (record,)))
        self.assertEqual(rows[0], record)
        self.assertEqual(rows[1][0], 1)
        occupied = tx.LiveItem(2, 'item', 2, 29, 120, 1., 1, 5)
        with self.assertRaises(codec.Error): tx.capture_inventory([occupied], 0, aliases, (record,))
        available = (17, 7, 2, 29, 120, True, ())
        with self.assertRaises(tx.Failure): tx.capture_inventory([], 0, aliases, (available,))

    def test_full57_success_exact_positions_and_unknown_progression_retention(self):
        envelope = target()
        backend = Backend(envelope)
        old_handles = set(backend.items)
        result = tx.restore(codec.encode(envelope), 42, backend)
        self.assertEqual(result.status, 'committed')
        self.assertEqual(len(backend.positions), 57)
        self.assertFalse(old_handles & set(backend.items))
        self.assertEqual(len(backend.items), 57)
        self.assertTrue(backend.used)
        self.assertFalse(backend.busy)
        self.assertEqual(codec.encode(backend.accepted), codec.encode(envelope))
        self.assertEqual(len(progression.snapshot(backend.accepted)['jobs']), 42)
        self.assertEqual(len(backend.progress['jobs']), 22)  # Unknown jobs grant nothing.
        self.assertEqual(backend.last_save, 'prior-good-file')
        self.assertEqual(tx.restore(codec.encode(envelope), 42, backend).status, 'rejected')

    def test_unavailable_item_and_optional_metadata_stay_inaccessible(self):
        envelope = target(dormant=True)
        backend = Backend(envelope)
        backend.available.remove(1000)
        result = tx.restore(codec.encode(envelope), 42, backend)
        self.assertEqual(result.status, 'committed')
        self.assertEqual(len(backend.positions), 55)
        self.assertEqual(len(backend.reserved), 2)
        self.assertEqual(len(backend.items), 55)
        self.assertEqual(backend.accepted, envelope)

    def test_each_creation_configuration_placement_and_equipment_failure_rolls_back(self):
        envelope = target()
        encoded = codec.encode(envelope)
        for phase, count in [('create', 57), ('created', 57), ('configure', 57), ('configured', 57),
                             ('place', 57), ('placed', 57), ('equip', 9), ('suspend', 48),
                             ('quarantine', 6), ('quarantined', 6), ('progression', 6)]:
            for nth in range(1, count+1):
                with self.subTest(phase=phase, nth=nth):
                    backend = Backend(envelope, phase, nth)
                    originals = dict(backend.items)
                    result = tx.restore(encoded, 42, backend)
                    self.assertEqual(result.status, 'rolled_back')
                    self.assertEqual(backend.image(), backend.before)
                    self.assertTrue(all(backend.items[h] is item for h, item in originals.items()))
                    self.assertFalse(backend.busy)
                    self.assertFalse(backend.used)

    def test_other_failure_boundaries_preserve_journal_and_save(self):
        envelope = target(dormant=True)
        for phase in ['journal', 'project', 'resolve', 'verify_original', 'reserve', 'reserved',
                      'verify_staged', 'publish', 'published']:
            with self.subTest(phase=phase):
                backend = Backend(envelope, phase)
                result = tx.restore(codec.encode(envelope), 42, backend)
                self.assertEqual(result.status, 'rolled_back')
                self.assertEqual(backend.image(), backend.before)
                self.assertFalse(backend.busy)

    def test_null_creation_and_silent_native_style_failures_require_readback(self):
        envelope = target()
        for fault in ['null_creation', 'silent_place', 'clamped_life', 'rejected_equip']:
            backend = Backend(envelope)
            if fault == 'null_creation': backend.create_hidden = lambda spec: None
            elif fault == 'silent_place': backend.place = lambda handle, spec: None
            elif fault == 'clamped_life':
                original = backend.configure_hidden
                def configure(handle, spec):
                    original(handle, spec)
                    backend.items[handle].life = 1.
                backend.configure_hidden = configure
            else:
                original_place = backend.place
                def place(handle, spec):
                    original_place(handle, spec)
                    backend.items[handle].passives = ()
                backend.place = place
            result = tx.restore(codec.encode(envelope), 42, backend)
            self.assertEqual(result.status, 'rolled_back', fault)
            self.assertEqual(backend.image(), backend.before)
            self.assertFalse(backend.busy)

    def test_legacy_evidence_tampering_rejects_before_backend_mutation(self):
        case = json.loads(Path(__file__).with_name('legacy-fixtures.json').read_text())['cases'][-1]
        envelope = migration.translate(case['code'])
        sections = []
        for section in envelope.sections:
            if section.id == 4:
                rows = [(i, value+1 if i == 2 else value) for i, value in codec.read_pairs(section.payload)]
                section = codec.Section(4, 1, True, codec.pairs(rows))
            sections.append(section)
        tampered = codec.Envelope(envelope.account_hash, tuple(sections))
        backend = Backend(tampered)
        result = tx.restore(codec.encode(tampered), envelope.account_hash, backend)
        self.assertEqual(result.status, 'rejected')
        self.assertEqual(backend.calls, {})
        self.assertEqual(backend.image(), backend.before)

    def test_validation_wrong_account_mode_and_busy_reject_before_mutation(self):
        envelope = target()
        for encoded, account in [(codec.encode(envelope), -1), (codec.encode(envelope), 43), ('broken', 42)]:
            backend = Backend(envelope)
            self.assertEqual(tx.restore(encoded, account, backend).status, 'rejected')
            self.assertEqual(backend.image(), backend.before)
            self.assertEqual(backend.calls, {})
        for attribute in ['busy', 'used', 'frozen']:
            backend = Backend(envelope)
            setattr(backend, attribute, True)
            before = backend.image()
            self.assertEqual(tx.restore(codec.encode(envelope), 42, backend).status, 'rejected')
            self.assertEqual(backend.image(), before)
        backend = Backend(envelope)
        backend.eligible = False
        self.assertEqual(tx.restore(codec.encode(envelope), 42, backend).status, 'rejected')
        self.assertFalse(backend.busy)

    def test_failed_recovery_keeps_guard_locked_and_contains_player(self):
        envelope = target()
        for phase in ['recover', 'recover_item', 'verify_recovery']:
            backend = Backend(envelope, phase)
            def fail_placement(handle, spec): raise tx.Failure('placement failed')
            backend.place = fail_placement
            result = tx.restore(codec.encode(envelope), 42, backend)
            self.assertEqual(result.status, 'blocked')
            self.assertTrue(backend.busy)
            self.assertTrue(backend.frozen)
            self.assertFalse(backend.used)
            self.assertEqual(tx.restore(codec.encode(envelope), 42, backend).status, 'rejected')

    def test_after_publish_cleanup_failure_quarantines_without_rollback(self):
        envelope = target()
        backend = Backend(envelope, 'cleanup', 2)
        old_handles = set(backend.items)
        result = tx.restore(codec.encode(envelope), 42, backend)
        self.assertEqual(result.status, 'committed_cleanup_pending')
        self.assertTrue(backend.used)
        self.assertFalse(backend.busy)
        self.assertEqual(len(backend.positions), 57)
        self.assertFalse(old_handles & set(backend.positions.values()))
        self.assertTrue(all(backend.items[h].hidden for h in old_handles & backend.items.keys()))
        self.assertEqual(backend.accepted, envelope)
        backend.fault = None
        backend.retire_originals(backend.last_journal)
        self.assertEqual(len(backend.items), 57)

    def test_legacy_defaults_are_explicit_and_missing_review_refuses(self):
        cases = json.loads(Path(__file__).with_name('legacy-fixtures.json').read_text())['cases']
        for case in cases:
            envelope = migration.translate(case['code'])
            backend = Backend(envelope)
            result = tx.restore(codec.encode(envelope), envelope.account_hash, backend)
            self.assertEqual(result.status, 'committed')
            for item in backend.items.values():
                self.assertEqual(item.life, 99.)  # Test-provided defaults, not inferred actual objects.
                self.assertEqual(item.flags, 6)
            backend = Backend(envelope)
            backend.defaults.clear()
            self.assertEqual(tx.restore(codec.encode(envelope), envelope.account_hash, backend).status, 'rolled_back')
            self.assertEqual(backend.image(), backend.before)


if __name__ == '__main__': unittest.main()

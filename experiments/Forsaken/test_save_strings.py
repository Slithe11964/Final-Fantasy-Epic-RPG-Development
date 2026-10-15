"""Bounded runtime strings must keep the independent FSVB format byte-identical."""
import json
import random
import re
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / 'tools'))
from save_strings import lower_module
from test_save_jass import engine
import test_save_transport as transport
from test_save_transport import profile
import save_vnext as codec


def materialize(env, value):
    identity = env['FSS_Id'](value)
    if not identity:
        return value
    length = env['FSS_Length'](value)
    return ''.join(env['FSS_Table'](value)[(identity, i + 1)]
                   for i in range((length + 959) // 960))


def fragments(env, value):
    result = ''
    for start in range(0, len(value), 160):
        result = env['FSS_Concat'](result, value[start:start+160])
    return result


class StringTests(unittest.TestCase):
    def setUp(self):
        self.e = engine(bounded=True)

    def bounded(self):
        for value in (self.e['FSS_Store'] or {}).values():
            if isinstance(value, str):
                self.assertLessEqual(len(value), 960)

    def test_boundaries_substrings_equality_and_empty(self):
        rng = random.Random(16449)
        for length in (959, 960, 961, 1500, 2053, 4096, 16449):
            text = ''.join(rng.choice(codec.ALPHABET) for _ in range(length))
            value = fragments(self.e, text)
            other = fragments(self.e, text)
            self.assertEqual(materialize(self.e, value), text)
            self.assertEqual(self.e['FSS_Length'](value), length)
            self.assertTrue(self.e['FSS_Equals'](value, other))
            self.assertFalse(self.e['FSS_Equals'](value, fragments(self.e, text[:-1]+'!')))
            for first, last in ((0, 960), (950, 970), (959, 1921), (0, length),
                                (960, length+10), (-1, 500), (length, length)):
                self.assertEqual(materialize(self.e, self.e['FSS_SubString'](value, first, last)),
                                 text[max(0, first):last])
            self.bounded()
        self.assertEqual(self.e['FSS_Concat']('', ''), '')
        self.assertEqual(self.e['FSS_Length'](None), 0)

    def test_golden_and_endgame_decode_encode_exactly(self):
        cases = [c['code'] for c in json.loads((HERE/'migration-fixtures.json').read_text())['cases']]
        cases += [profile(large=True), codec.encode(codec.Envelope(42, (
            codec.Section(99, 1, False, 'A'*4096),)))]
        for text in cases:
            value = fragments(self.e, text)
            self.assertTrue(self.e['FSC_Decode'](0, value, -1, False))
            self.assertEqual(materialize(self.e, self.e['FSC_Reencode'](0)), text)
            envelope = codec.decode(text)
            self.assertTrue(self.e['FSC_Begin'](0, envelope.account_hash))
            for section in envelope.sections:
                self.assertTrue(self.e['FSC_Add'](0, section.id, section.version,
                                                section.required, fragments(self.e, section.payload)))
            self.assertEqual(materialize(self.e, self.e['FSC_Finish'](0, False)), text)
            self.bounded()
        for invalid in (cases[-1][:-1], cases[-1]+'A', 'FSVB'+'A'*16449):
            self.assertFalse(self.e['FSC_Decode'](0, fragments(self.e, invalid), -1, False))

    def test_lowering_keeps_numeric_math_and_is_idempotent(self):
        source = '''library TForsakenSaveCodec
function Example takes integer a,string b returns string
    local integer c=a+2
    return b+I2S(c)
endfunction
endlibrary
'''
        lowered = lower_module(source)
        self.assertIn('local integer c=(a + 2)', lowered)
        self.assertIn('return FSS_Concat(b,I2S(c))', lowered)
        self.assertEqual(lower_module(lowered), lowered)

    def test_refresh_old_editor_transport_keeps_exact_canonical_layout(self):
        from save_strings import refresh_runtime
        canonical=lower_module((HERE/'Forsaken-save-transport.j').read_text())
        old=re.sub(r"// Only the owning client's sender calls this[^\n]*\nfunction FST_LocalLegacyHash takes.*?^endfunction\n\n",'',canonical,flags=re.M|re.S)
        for name in ('FST_LocalCheck','FST_LocalLegacy','FST_LocalHashPosition','FST_LocalHashA','FST_LocalHashB'):
            old=re.sub(r'^    (?:integer|boolean) array '+name+r'\n','',old,flags=re.M)
        refreshed=refresh_runtime(old)
        self.assertEqual(refreshed,canonical)
        self.assertEqual(refresh_runtime(refreshed),canonical)

    def test_long_profile_places_items_and_exactly_recaptures_after_load(self):
        import test_fresh_load
        original = test_fresh_load.engine
        with patch.object(test_fresh_load, 'engine',
                          lambda *a, **kw: original(*a, **kw, bounded=True)):
            fixture = test_fresh_load.FreshLoadTests()
            fixture.setUp()
        env = fixture.e
        before = codec.decode(fixture.f.base.encoded)
        sections = tuple(codec.Section(s.id, s.version, s.required,
                         codec.pairs([(i, 1) for i in range(1, 359)]) if s.id == 8 else s.payload)
                         for s in before.sections)
        text = codec.encode(codec.Envelope(before.account_hash, sections))
        self.assertGreater(len(text), 1023)
        value = fragments(env, text)
        env['FST_Result'][0] = value
        self.assertTrue(env['FFP_Build'](0, value, True), env['FFP_Error'][0])
        self.assertTrue(env['FFL_Apply'](0), fixture.messages)
        fixture.finish()
        self.assertEqual(materialize(env, env['FRC_Result'][0]), text)
        env['FFL_Tick']()
        self.assertTrue(env['udg_HasLoadedCode'][0], fixture.messages)
        self.assertTrue(all(len(v) <= 960 for v in env['FSS_Store'].values() if isinstance(v, str)))

    def test_large_decode_has_bounded_work_in_each_execution_thread(self):
        # This models a work ceiling, not the engine's exact bytecode counter.
        # ATT's whole-profile scan exceeded this ceiling in the caller thread.
        env = self.e
        value = fragments(env, profile(large=True))
        budgets = [0]
        executions = []
        def dispatch(name):
            budgets.append(0)
            try:
                env[name]()
            finally:
                executions.append((name, budgets.pop()))
        def trace(frame, event, argument):
            if event == 'line' and frame.f_code.co_filename == '<string>':
                budgets[-1] += 1
                self.assertLess(budgets[-1], 25000, frame.f_code.co_name)
            return trace
        env['ExecuteFunc'] = dispatch
        sys.settrace(trace)
        try:
            self.assertTrue(env['FSC_Decode'](0, value, 42, True))
        finally:
            sys.settrace(None)
        self.assertGreater(len(executions), 10)
        self.assertTrue(any(name == 'FSS_ScanChunk' for name, _ in executions))

    def test_interrupted_scan_or_reader_fails_closed_and_releases_busy(self):
        value = fragments(self.e, profile(large=True))
        for target in ('FSS_ScanChunk', 'FSS_Call_FSC_Read_Run', 'FSS_Call_FSC_ValidateSection_Run'):
            self.e['ExecuteFunc'] = lambda name: None if name == target else self.e[name]()
            self.assertFalse(self.e['FSC_Decode'](0, value, 42, True), target)
            self.assertFalse(self.e['FSC_Busy'][0], target)


class BoundedTransportTests(transport.TransportTests):
    """Reuse native IO fixtures with transformed production modules."""
    def setUp(self):
        import test_save_transport
        original = test_save_transport.engine
        test_save_transport.engine = lambda *a, **kw: original(*a, **kw, bounded=True)
        try:
            super().setUp()
        finally:
            test_save_transport.engine = original

    # Existing tests assert raw private buffers. Run only explicit boundary tests here.
    def test_bounded_file_roundtrip(self):
        text = profile(large=True)
        self.assertGreater(len(text), 1023)
        self.assertEqual(materialize(self.e, self.e['FST_ReadFile'](0)), text)
        self.assertTrue(self.e['FST_Write'](0, fragments(self.e, text), 42))
        self.assertEqual(self.file, text)
        self.assertTrue(all(len(v) <= 960 for v in self.e['FSS_Store'].values() if isinstance(v, str)))

    def test_bounded_transfer_and_screenshot_parts(self):
        self.assertTrue(self.e['FST_Request'](0, 42))
        self.receive(self.packets())
        self.assertTrue(self.e['FST_Ready'][0])
        self.assertEqual(materialize(self.e, self.e['FST_Result'][0]), self.file)
        self.e['FST_SavedCode'][0] = self.e['FST_Result'][0]
        parts = []
        for page in range(1, (len(self.file)+239)//240+1):
            self.messages.clear()
            self.e['FST_ShowCode'](0, page)
            for message in self.messages:
                self.assertLessEqual(len(message), 960)
                plain = re.sub(r'\|c[0-9a-fA-F]{8}|\|r', '', message)
                if plain.startswith('-load '):
                    parts.append(plain.split(':', 4)[-1])
        self.assertEqual(''.join(parts), self.file)

    def test_bounded_legacy_file_dispatch_preserves_original_text(self):
        value = fragments(self.e, 'G'+'A'*1500)
        self.assertEqual(self.e['FSS_LegacyText'](value), 'G'+'A'*1500)

    def test_bounded_classic_game_cache_delivery(self):
        self.e['FST_UseSyncNative'] = False
        self.e['FSG_Init']()
        self.assertTrue(self.e['FST_Request'](0, 42))
        for _ in range(400):
            self.e['FST_Pump']()
            if self.e['FST_Ready'][0] or self.e['FST_Error'][0]:
                break
        self.assertEqual(self.e['FST_Error'][0], '')
        self.assertTrue(self.e['FST_Ready'][0])
        self.assertEqual(materialize(self.e, self.e['FST_Result'][0]), self.file)
        self.assertEqual(self.sent, [])
        self.assertGreater(len(self.synced), 100)

    def test_two_clients_local_reads_do_not_change_shared_fragment_state(self):
        other=BoundedTransportTests();other.setUp();other.local=1
        clients=(self,other)
        decoded=codec.decode(other.file)
        other.file=codec.encode(codec.Envelope(decoded.account_hash,tuple(
            codec.Section(s.id,s.version,s.required,codec.pairs([(i,99) for i in range(1,43)]))
            if s.id==2 else s for s in decoded.sections)))
        for pid in (0,1):
            for client in clients:self.assertTrue(client.e['FST_Request'](pid,42))
        self.assertGreater(self.e['FSS_LocalNext'],0)
        self.assertGreater(other.e['FSS_LocalNext'],0)
        for client in clients:
            self.assertEqual(client.e['FSS_Next'],0)
            self.assertEqual(client.e['FSS_Store'],{})
        seen=[0,0]
        for tick in range(400):
            for client in clients:client.e['FST_Pump']()
            for pid,sender in enumerate(clients):
                for _,packet in sender.sent[seen[pid]:]:
                    self.assertFalse(packet.startswith(('!FS:','!FL:')))
                    for client in clients:client.e['FST_Receive'](pid,packet)
                seen[pid]=len(sender.sent)
            self.assertEqual(self.e['FSS_Next'],other.e['FSS_Next'])
            self.assertEqual(self.e['FSS_Store'],other.e['FSS_Store'])
            if all(c.e['FST_Ready'][0] and c.e['FST_Ready'][1] for c in clients):break
        for pid,sender in enumerate(clients):
            for client in clients:
                self.assertTrue(client.e['FST_Ready'][pid],client.e['FST_Error'][pid])
                self.assertEqual(materialize(client.e,client.e['FST_Result'][pid]),sender.file)

    def test_private_file_read_and_sender_never_enter_shared_scan_threads(self):
        calls=[]
        self.e['ExecuteFunc']=lambda name: calls.append(name)
        scan={k:self.e[k] for k in self.e if k.startswith('FSS_Scan') and not callable(self.e[k])}
        self.assertTrue(self.e['FST_Request'](0,42))
        for _ in range(200):
            self.e['FST_Pump']()
            if self.e['FST_LocalPhase'][0]==0:break
        self.assertTrue(self.sent)
        self.assertTrue(self.sent[0][1].startswith('B'))
        self.assertEqual(calls,[])
        self.assertEqual(scan,{k:self.e[k] for k in scan})
        self.assertEqual(self.e['FSS_Store'],{})
        # The observer performs all validation from the synchronized packet bytes.
        other=BoundedTransportTests();other.setUp();other.local=1
        self.assertTrue(other.e['FST_Request'](0,42))
        for _,packet in self.sent:other.e['FST_Receive'](0,packet)
        self.assertTrue(other.e['FST_Ready'][0],other.e['FST_Error'][0])
        self.assertEqual(materialize(other.e,other.e['FST_Result'][0]),self.file)

    def test_long_legacy_sender_uses_private_bounded_checksum_steps(self):
        code='H'+'ABC(DEF)'*200
        self.e['FST_AllowLegacy'][0]=True
        self.files={self.e['FST_PlayerPath'](0,0):{0:code}}
        calls=[]
        self.e['ExecuteFunc']=lambda name:calls.append(name)
        self.assertTrue(self.e['FST_Request'](0,42))
        self.assertEqual(self.e['FST_LocalPhase'][0],5)
        previous=0
        for _ in range(200):
            self.e['FST_Pump']()
            current=self.e['FST_LocalHashPosition'][0]
            self.assertLessEqual(current-previous,128)
            previous=current
            if self.e['FST_LocalPhase'][0]==0:break
        self.assertEqual(calls,[])
        self.assertTrue(self.sent[0][1].startswith('L'))
        other=BoundedTransportTests();other.setUp();other.local=1
        other.e['FST_AllowLegacy'][0]=True
        self.assertTrue(other.e['FST_Request'](0,42))
        for _,packet in self.sent:other.e['FST_Receive'](0,packet)
        self.assertTrue(other.e['FST_Ready'][0],other.e['FST_Error'][0])
        self.assertEqual(materialize(other.e,other.e['FST_Result'][0]),code)

    def test_corrupt_private_contents_are_rejected_after_synchronization(self):
        original=self.e['Preloader']
        def damaged(path):
            original(path)
            self.names[0]='!'+self.names[0][1:]
        self.e['Preloader']=damaged
        self.assertTrue(self.e['FST_Request'](0,42))
        self.assertEqual(self.e['FST_LocalPhase'][0],1)
        for _ in range(200):
            self.e['FST_Pump']()
            if self.e['FST_LocalPhase'][0]==0:break
        self.receive([packet for _,packet in self.sent])
        self.assertFalse(self.e['FST_Ready'][0])
        self.assertTrue(self.e['FST_Error'][0])

    def test_local_write_readback_leaves_shared_virtual_ids_unchanged(self):
        other=BoundedTransportTests();other.setUp();other.local=1
        text=profile(large=True);value=fragments(self.e,text)
        remote=fragments(other.e,text)
        # Each client does shared preflight; only the owner does file IO/readback.
        self.assertTrue(self.e['FST_Write'](0,value,42))
        self.assertTrue(other.e['FST_Write'](0,remote,42))
        self.assertEqual(self.e['FSS_Store'],other.e['FSS_Store'])
        self.assertEqual(self.e['FSS_Next'],other.e['FSS_Next'])
        for key in ('FSS_ScanText','FSS_ScanMode','FSS_ScanA','FSS_ScanB','FSS_ScanValid','FSS_ScanDone'):
            self.assertEqual(self.e[key],other.e[key],key)
        self.assertEqual(self.file,text)


# Do not inherit tests that deliberately compare logical buffers to native strings.
for _name in list(vars(transport.TransportTests)):
    if _name.startswith('test_'):
        setattr(BoundedTransportTests, _name, None)

if __name__ == '__main__':
    unittest.main()

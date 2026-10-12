"""Exercise actual transport JASS; native file/sync IO is simulated, not timed."""
from pathlib import Path
import re
import unittest

import save_vnext as codec
from test_save_jass import engine
from test_save_migration import native_sections

HERE = Path(__file__).resolve().parent


def profile(account=42, large=False):
    records = []
    for pos in range(57 if large else 1):
        holder, slot = ((1, pos) if pos < 6 else (2, pos-6) if pos < 36 else
                        (3, pos-36) if pos < 45 else (4, pos-45) if pos < 51 else (5, pos-51))
        records.append((pos+1, 1001+pos, holder, slot, 120, True,
                        ((1, True, codec.life_words(145.25)), (2, True, codec.uint(5)))))
    sections = (codec.Section(1, 1, True, codec.inventory(records)),
                codec.Section(2, 1, True, codec.pairs([(i, 100) for i in range(1, 43)]))) + native_sections()
    return codec.encode(codec.Envelope(account, sections))


class TransportTests(unittest.TestCase):
    def setUp(self):
        self.now = 0.
        self.local = 0
        self.file = profile(large=True)
        self.names = ['Player'+str(i) for i in range(24)]
        self.sent = []
        self.preloads = []
        self.messages = []
        self.send_ok = True
        self.files = {}
        self.generated = ""
        def preload(path):
            if self.file is None: return
            if self.files:
                values=self.files.get(path,{})
            else:
                page=0 if ' part ' not in path else int(re.search(r'part (\d+)',path)[1])
                pages=(len(self.file)+3679)//3680
                values={slot:self.file[page*3680+slot*160:page*3680+(slot+1)*160] for slot in range(23) if page*3680+slot*160<len(self.file)}
                values[23]=f'FSC1{len(self.file):05d}{codec.checksum(self.file):010d}{page}{pages}'
            for slot,text in values.items(): self.names[slot]=text
        def send(prefix, packet):
            self.sent.append((prefix, packet))
            return self.send_ok
        def genend(path):
            self.generated='function PreloadFiles takes nothing returns nothing\n call PreloadStart()\n'+''.join(' call Preload( "'+line+'" )\n' for line in self.preloads)+' call PreloadEnd(0.)\nendfunction\n'
            values={}
            for line in self.preloads:
                self.assertLessEqual(len(line), 255, "Preload truncates the generated JASS injection")
                match = re.search(r'SetPlayerName\(Player\((\d+)\), "([A-Za-z0-9$#]+)"\)', line)
                if match: values[int(match[1])]=match[2]
            self.files[path]=values
            self.preloads.clear()
            self.file=''.join(values[slot] for path,values in sorted(self.files.items(),key=lambda kv:0 if ' part ' not in kv[0] else int(re.search(r'part (\d+)',kv[0])[1])) for slot in sorted(values) if slot<23)
        natives = dict(I2S=lambda v: str(int.from_bytes(v.encode(),"big")) if isinstance(v,str) and len(v)==4 else str(v), I2R=float, R2I=int, Player=lambda p: p, GetLocalPlayer=lambda: self.local,
                       GetPlayerName=lambda p: self.names[p],
                       SetPlayerName=lambda p, name: self.names.__setitem__(p, name),
                       TimerGetElapsed=lambda t: self.now, CreateTimer=object,
                       TimerStart=lambda *a: None, CreateTrigger=object,
                       BlzTriggerRegisterPlayerSyncEvent=lambda *a: None,
                       TriggerAddAction=lambda *a: None, ClearTextMessages=lambda:None, BlzSendSyncData=send,
                       Preloader=preload, PreloadGenClear=lambda: self.preloads.clear(),
                       PreloadGenStart=lambda: None, Preload=self.preloads.append,
                       PreloadGenEnd=genend,
                       DisplayTimedTextToPlayer=lambda *a: self.messages.append(a[-1]))
        self.e = engine((HERE/'Forsaken-save-transport.j').read_text(), natives)
        self.e['FST_Init']()

    def packets(self, code=None, request=1, sent_millis=0):
        code = self.file if code is None else code
        req = f'{request:06d}'
        return ['B'+req+f'{len(code):05d}{codec.checksum(code):010d}000017{sent_millis:09d}'] + [
            'D'+req+f'{i//192:03d}'+code[i:i+192] for i in range(0, len(code), 192)] + ['E'+req]

    def receive(self, packets):
        for packet in packets: self.e['FST_Receive'](0, packet)

    def test_local_file_is_never_accepted_without_sync(self):
        self.assertTrue(self.e['FST_Request'](0, 42))
        self.assertEqual(self.names[0], 'Player0')
        self.assertFalse(self.e['FST_Ready'][0])
        self.assertFalse(self.e['FST_Write'](0, self.file, 42))
        for _ in range(len(self.packets())):
            self.e['FST_Pump']()
        self.assertEqual([packet for _, packet in self.sent], [self.packets()[0][:22]+'000000000000000']+self.packets()[1:])
        self.assertTrue(all(len(packet) <= 202 for _, packet in self.sent))
        self.assertFalse(self.e['FST_Ready'][0])
        self.receive([packet for _, packet in self.sent])
        self.assertTrue(self.e['FST_Ready'][0])
        self.assertEqual(self.e['FST_Result'][0], self.file)
        self.assertEqual(self.e['FSC_Reencode'](0), self.file)

    def test_wrong_account_rejected_retry_and_stale_packets_ignored(self):
        self.assertTrue(self.e['FST_Request'](0, 43))
        self.receive(self.packets())
        self.assertFalse(self.e['FST_Ready'][0])
        self.assertIn('validation', self.e['FST_Error'][0])
        self.assertTrue(self.e['FST_Request'](0, 42))
        self.receive(self.packets())
        self.assertTrue(self.e['FST_Pending'][0])
        self.receive(self.packets(request=2))
        self.assertTrue(self.e['FST_Ready'][0])

    def test_reorder_duplicate_missing_corrupt_and_malformed_packets(self):
        packets = self.packets()
        cases = [packets[:1]+[packets[2]], packets[:2]+[packets[1]],
                 packets[:2]+[packets[-1]], packets[:1]+[packets[1][:-1]+'!'],
                 packets[:1]+[packets[0]], [packets[0][:-1]], ['Z000001'],
                 ['B00000199999'+packets[0][12:]], packets[:-1]+['E000001extra']]
        for candidate in cases:
            with self.subTest(packet=candidate[-1][:40]):
                self.setUp()
                self.e['FST_Request'](0, 42)
                self.receive(candidate)
                self.assertFalse(self.e['FST_Pending'][0])
                self.assertFalse(self.e['FST_Ready'][0])
                self.assertIsNone(self.e['FST_Result'][0])
                self.assertIsNone(self.e['FST_Buffer'][0])

    def test_whole_profile_validation_even_with_valid_transport_checksum(self):
        invalid = codec.encode(codec.Envelope(42, (codec.Section(1, 1, True, codec.inventory([])),)))
        self.e['FST_Request'](0, 42)
        self.receive(self.packets(invalid))
        self.assertIn('validation', self.e['FST_Error'][0])
        self.assertFalse(self.e['FST_Ready'][0])

    def test_timeout_missing_file_and_send_failure_are_retryable(self):
        self.e['FST_Request'](0, 42)
        self.now = 46.
        self.e['FST_Pump']()
        self.assertIn('timed out', self.e['FST_Error'][0])
        self.file = None
        self.assertTrue(self.e['FST_Request'](0, 42))
        self.e['FST_Pump']()
        self.assertEqual(self.sent[-1][1], 'X000002')
        self.receive([self.sent[-1][1]])
        self.assertFalse(self.e['FST_Pending'][0])
        self.file = profile()
        self.assertTrue(self.e['FST_Request'](0, 42))
        self.send_ok = False
        self.e['FST_Pump']()
        self.send_ok = True
        self.e['FST_Pump']()
        self.assertEqual(self.sent[-1][1], 'X000003')

    def test_other_client_does_not_access_file_or_send_owner_data(self):
        self.local = 1
        self.e['FST_Request'](0, 42)
        self.e['FST_Pump']()
        self.assertEqual(self.sent, [])
        self.assertEqual(self.names, ['Player'+str(i) for i in range(24)])
        self.receive(self.packets())
        self.assertTrue(self.e['FST_Ready'][0])

    def test_write_chunked_file_and_exact_local_readback_preserves_name(self):
        code = self.file
        self.assertTrue(self.e['FST_Write'](0, code, 42))
        self.assertEqual(self.file, code)
        self.assertEqual(self.names[0], 'Player0')
        self.assertIn('read back exactly', self.messages[-1])
        before = list(self.preloads)
        self.assertFalse(self.e['FST_Write'](0, code, 43))
        self.assertEqual(self.preloads, before)

    def test_numeric_overflow_and_request_boundaries(self):
        for text in ['', 'x', '2147483648', '9999999999']:
            self.assertEqual(self.e['FST_Digits'](text), -1)
        self.assertEqual(self.e['FST_Digits']('2147483647'), 2147483647)
        self.assertFalse(self.e['FST_Request'](-1, 42))
        self.e['FST_RequestId'][0] = 999999
        self.assertFalse(self.e['FST_Request'](0, 42))

    def test_eight_senders_keep_profiles_and_requests_separate(self):
        for pid in range(8):
            self.local = pid
            self.file = profile(account=pid+40)
            self.assertTrue(self.e['FST_Request'](pid, pid+40))
        for pid in range(8):
            encoded = profile(account=pid+40)
            for packet in self.packets(encoded):
                self.e['FST_Receive'](pid, packet)
            self.assertTrue(self.e['FST_Ready'][pid])
            self.assertEqual(self.e['FST_Result'][pid], encoded)
        self.assertEqual(self.names, ['Player'+str(i) for i in range(24)])

    def test_future_timestamp_and_oversized_local_file_rejected(self):
        self.e['FST_Request'](0, 42)
        self.receive(self.packets(sent_millis=1000)[:1])
        self.assertFalse(self.e['FST_Pending'][0])
        self.file = 'FSVB'+'A'*17000
        self.assertTrue(self.e['FST_Request'](0, 42))
        self.e['FST_Pump']()
        self.assertEqual(self.sent[-1][1], 'X000002')
        self.assertFalse(self.e['FST_Ready'][0])

    def test_file_readback_failure_is_reported_and_never_claimed_verified(self):
        self.e['Preloader'] = lambda path: None
        self.assertTrue(self.e['FST_Write'](0, self.file, 42))
        self.assertIn('readback failed', self.messages[-1])
        self.assertNotIn('read back exactly', self.messages[-1])
        self.assertEqual(self.names[0], 'Player0')

    def test_file_initializes_readback_without_empty_player_name(self):
        self.e['SetPlayerName'] = lambda p,name: self.names.__setitem__(p,name) if name else None
        encoded=self.file
        self.assertTrue(self.e['FST_Write'](0,encoded,42))
        self.assertIn('read back exactly',self.messages[-1])
        self.assertNotIn('GetPlayerName',self.generated)
        self.assertEqual(self.names,['Player'+str(i) for i in range(24)])
        self.assertEqual(self.names[0],'Player0')
        self.e['Preloader']=lambda path: None
        self.assertTrue(self.e['FST_Write'](0,encoded,42))
        self.assertIn('header was not returned',self.messages[-1])
        self.assertEqual(self.names[0],'Player0')

    def test_generated_file_contains_one_native_assignment_per_chunk(self):
        self.assertTrue(self.e['FST_Write'](0,self.file,42))
        self.assertEqual(self.generated.count('call SetPlayerName('),(len(self.file)+159)//160+1)
        self.assertNotIn('GetPlayerName',self.generated)
        (HERE.parents[1]/'build/save-file-DC.j').write_text(self.generated)

    def test_multi_page_file_restores_all_names_and_rejects_missing_part(self):
        self.assertTrue(self.e['FST_SetFileStem'](0,'Forsaken Endgame'))
        envelope=codec.decode(self.file)
        encoded=codec.encode(codec.Envelope(envelope.account_hash,envelope.sections+(codec.Section(10,1,False,'A'*3000),)))
        self.assertGreater(len(encoded),3680)
        self.assertTrue(self.e['FST_Write'](0,encoded,42))
        self.assertIn('read back exactly',self.messages[-1])
        self.assertEqual(self.names,['Player'+str(i) for i in range(24)])
        self.assertIn('.\\FFERPG\\Forsaken Endgame.txt',self.files)
        self.files.pop(self.e['FST_PlayerPath'](0,1))
        self.assertIsNone(self.e['FST_ReadFile'](0))
        self.assertIn('page 1 header',self.e['FST_FileError'][0])
        self.assertEqual(self.names,['Player'+str(i) for i in range(24)])

    def test_legacy_file_is_detected_locally_and_dispatched_only_after_sync(self):
        code='HABCDEFGHIJK(ABCDE)'
        self.e['FST_AllowLegacy'][0]=True
        self.e['FST_SetFileStem'](0,'Endgame')
        self.files={self.e['FST_PlayerPath'](0,0):{0:code}}
        self.assertTrue(self.e['FST_Request'](0,42))
        self.assertFalse(self.e['FST_Ready'][0])
        self.assertEqual(self.names,['Player'+str(i) for i in range(24)])
        for _ in range(10):self.e['FST_Pump']()
        self.assertTrue(self.sent[0][1].startswith('L'))
        self.receive([packet for _,packet in self.sent])
        self.assertTrue(self.e['FST_Ready'][0],self.e['FST_Error'][0])
        self.assertTrue(self.e['FST_Legacy'][0]);self.assertEqual(self.e['FST_Result'][0],code)

    def test_code_display_pages_reassemble_without_file_io(self):
        code=self.file;self.e['FST_SavedCode'][0]=code
        total=(len(code)+79)//80;parts=[]
        for page in range(1,(total+2)//3+1):
            self.messages.clear();self.assertTrue(self.e['FST_ShowCode'](0,page))
            lines=[re.sub(r'\|c[0-9a-fA-F]{8}|\|r','',m) for m in self.messages if m.startswith('-load FSVB:')]
            self.assertTrue(all(len(line)<=121 for line in lines))
            self.assertLessEqual(len(lines),3)
            self.assertIn(f'PAGE {page} OF {(total+2)//3}',self.messages[0])
            self.assertTrue(any(f'Capture ALL {(total+2)//3} pages' in m for m in self.messages))
            parts.extend(line.split(':',4)[4] for line in lines)
        self.assertEqual(''.join(parts),code)
        self.assertEqual(self.files,{})

    def test_display_uses_legacy_colors_without_changing_code_or_other_players_screen(self):
        expected='|c00C8C8C8O|c00E6E700o|c000068DE0|c00C8C8C8I|c00E6E700l|c000068DE1|c0016D116$#|r'
        self.assertEqual(self.e['FST_ColorCode']('Oo0Il1$#'),expected)
        self.assertLess(len(self.e['FST_ColorCode']('A1'*40))+40,1000)
        clears=[];self.e['ClearTextMessages']=lambda:clears.append(self.local)
        self.e['FST_SavedCode'][1]=self.file
        self.assertTrue(self.e['FST_ShowCode'](1,1));self.assertEqual(clears,[])
        self.local=1;self.assertTrue(self.e['FST_ShowCode'](1,1));self.assertEqual(clears,[1])
        self.assertTrue(any('-savepage 2' in m for m in self.messages))

    def test_normal_file_save_uses_legacy_success_and_unverified_wording(self):
        self.e['FST_LegacySaveMessages'][0]=True
        self.assertTrue(self.e['FST_Write'](0,self.file,42))
        self.assertEqual(self.messages,['Saved successfully'])
        self.messages.clear();self.e['FST_ReadFile']=lambda pid:None
        self.assertTrue(self.e['FST_Write'](0,self.file,42))
        self.assertEqual(self.messages,['Saved but could not verify if successful. Check saves folder manually.'])

    def test_file_stems_are_bounded_and_player_specific(self):
        for stem in ('../legacy','x/y','x\\y','x.txt','', 'x'*65):
            self.assertFalse(self.e['FST_SetFileStem'](0,stem),stem)
        self.assertTrue(self.e['FST_SetFileStem'](0,'Forsaken Endgame_1'))
        self.assertTrue(self.e['FST_SetFileStem'](1,'Forsaken Other'))
        self.assertNotEqual(self.e['FST_PlayerPath'](0,0),self.e['FST_PlayerPath'](1,0))
        self.assertEqual(self.e['FST_PlayerPath'](2,0),self.e['FST_FILE'])

    def test_transfer_reading_includes_sync_latency_but_not_file_read(self):
        self.e['FST_Request'](0, 42)
        self.now = 2.
        self.receive(self.packets(sent_millis=1000)[:1])
        self.now = 5.
        self.receive(self.packets(sent_millis=1000)[1:])
        self.assertEqual(self.e['FST_FileMillis'][0], 17)
        self.assertEqual(self.e['FST_TransferSeconds'][0], 4.)


if __name__ == '__main__':
    unittest.main()

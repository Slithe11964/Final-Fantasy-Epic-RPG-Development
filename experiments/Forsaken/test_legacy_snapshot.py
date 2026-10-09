"""Detached decoding vs pinned vectors and executed legacy JASS with mocked natives."""
from collections import defaultdict
import json
import random
import re
from pathlib import Path
import sys
import unittest

import legacy_snapshot as legacy
sys.path.insert(0, str(legacy.ROOT / 'tools/tests'))
from test_armory_materia import execute, CMD, SAVE, INDEX, original, LEGACY_FLAGS
from test_shared_context import mocks
from source_checks import fingerprint, literal_int
from jtok import functions

FIXTURES = Path(__file__).with_name('legacy-fixtures.json')


def fixture(version, capped=False, with_armory=False):
    """Independent explicit wire assembly, not a copy of decode's output."""
    v = 'EFGH'.index(version) + 4
    w = legacy.savecode.Writer(v)
    put = w.bits_
    put(legacy.savecode.name_hash('MigrationFixture'), 20); put(2, 2); put(424242, 20)
    if v >= 6:
        put(int(capped), 1); put(1, 1)
    put(int(capped), 1)
    for i in range(22):
        if capped:
            put(1, 1)
            if v >= 6: put(i % 2, 1)
        else:
            put(0, 1); put(i + 10, 7)
    put(1, 1)  # Freelancer: 0 in uncapped, 99/100 in capped.
    if capped and v >= 6: put(1, 1)
    if not (capped and v >= 6):
        put(0, 1); put(45, 7)
    if v >= 6 and not capped:
        for value, width in [(2,2),(1,2),(3,2),(1,1),(0,1),(1,1)]: put(value,width)
    if v >= 6: put(1, 1)  # NG bit4.
    # Packed inventory ordinals, including zero and max quantities and a V2
    # rejected item (18); slots cannot be reconstructed from legacy codes.
    for records in [[(7,0),(29,None),(352,127)],[(18,None)],[(7,127),(29,None)]]:
        put(len(records), 3)
        for item_id, qty in records:
            put(item_id, 9)
            if qty is not None: put(qty, 7)
    if v >= 6: put(0, 1)
    for i in range(15):
        if v >= 6: put(0, 1)
        put(i, 4)
    if v <= 5:
        for value, width in [(2,2),(1,2),(3,2),(1,1),(0,1),(1,1)]: put(value,width)
        for i in list(range(15,35))+list(range(39,44)): put(int(i in (19,32,42)),1)
        put(3,2); put(2,2); put(4,3); put(0,1)
    else:
        put(0,1)  # NG bit2 => total NG bits 5 + bit8 below => 13 => NG 2.
        # Title18, ignored19, first ladder, title20, Keg Hunter59.
        for value,width in [(1,1),(1,1),(3,2),(1,1),(1,1),
                            (3,2),(1,1),(1,1),(0,1),(3,2),(1,1),(1,1),(1,1),
                            (7,3),(1,1),(1,1),(3,2),(1,1),(1,1)]: put(value,width)
        for value,width in [(1,1),(9,4),(1,1),(0,1),(3,2),(6,3),(1,1),(1,1),(1,1)]: put(value,width)
    if w.bits: put(0,6-w.bits)
    main = w.out
    cs = legacy.savecode.checksum(main)
    cs3 = ''.join(legacy.savecode.ALPHABET[(cs >> s) & 63] for s in (12,6,0))
    segment = ''
    if with_armory:
        layout = json.loads(legacy.LAYOUT.read_text())
        put(0,18); put(0,18)  # Header reads advance key; bytes replaced below.
        owned = {layout['armory_order'][0],18,layout['armory_order'][-1],71,150}
        order = layout['armory_order']
        cursor = 0
        while cursor < len(order):
            value = int(order[cursor] in owned)
            length = 1
            while cursor+length < len(order) and length < 63 and int(order[cursor+length] in owned)==value:
                length += 1
            put(1,1); put(value,1); put(length,6)
            cursor += length
        put(0,1); put(0,1); put(0,1)
        if w.bits: put(0,6-w.bits)
        rest = cs3 + w.out[len(main)+6:]
        acs = legacy.savecode.checksum(rest)
        acs3 = ''.join(legacy.savecode.ALPHABET[(acs >> s) & 63] for s in (12,6,0))
        segment = '(' + acs3 + rest + ')'
    return version + cs3 + main + segment


def source_armory_code(code, owned, modern=True):
    """Actual Armory writer control flow with the existing bit codec."""
    decoded, trace = legacy.decode(code)
    w = legacy.savecode.Writer(legacy.savecode.value_of(code[0]))
    for _,width,value in trace: w.bits_(value,width)
    main = w.out
    source=(SAVE.read_text()+'\n'+CMD.read_text()) if modern else original(SAVE)+'\n'+original(CMD)
    layout=json.loads(legacy.LAYOUT.read_text())
    e=mocks(source)
    eligible=layout['armory_order'] if modern else list(LEGACY_FLAGS)
    e.update(udg_SaveFlagUnitID=defaultdict(lambda:None,{i:True for i in eligible}),
        udg_SaveFlagForce=defaultdict(set,{i:{0} for i in owned}),
        udg_SaveFlagCount=358 if modern else 351,udg_SaveDebug=False,udg_SavePlayer={0:0},
        udg_SaveCodePlain=defaultdict(str,{0:main}),udg_SaveCodeChunk=defaultdict(str),
        udg_SaveChunkIndex=defaultdict(int),udg_SaveChunkBase=defaultdict(int),
        udg_CodeBits=defaultdict(int),IsPlayerInForce=lambda p,f:p in f,
        I2S=str,StringLength=len,SubString=lambda s,a,b:s[a:b],
        Save_ColorChar=lambda *a:'',Trig_Cmd_Load_Code_Checksum=lambda *a:0)
    def write(sid,value,width):
        w.bits_(value,width)
        live['udg_CodeBits'][sid]=w.bits
        live['udg_SaveCodePlain'][sid]=w.out
    e['Save_WriteBits']=write
    live=execute(source,([INDEX] if modern else [])+['Save_EncodeUnitFlags'],e)
    live['Save_EncodeUnitFlags'](0,legacy.value3(code[1:4]))
    rest=code[1:4]+w.out[len(main)+6:]
    cs=legacy.savecode.checksum(rest)
    header=''.join(legacy.savecode.ALPHABET[(cs>>s)&63] for s in (12,6,0))
    return code+'('+header+rest+')'


def source_main(code):
    """Execute AS reader control flow, mocking world operations only."""
    text = CMD.read_text(encoding='utf-8')
    version = legacy.savecode.value_of(code[0])
    r = legacy.Reader(version, code[4:].partition('(')[0])
    for width in (20,2,20): r.bits_(width, 'header')
    header_reads = len(r.log)
    e = mocks(text)
    jobs, levels, upgrades = {}, {}, {}
    layout = json.loads(legacy.LAYOUT.read_text())
    inv = defaultdict(list)
    e.update(udg_JobCount=22, udg_JobUnitType={i:i+1 for i in range(22)},
        udg_SavePlayer={1:0}, udg_SaveVersion={1:version},
        udg_CodeCapFlag=defaultdict(bool), TRUE=True, FALSE=False,
        udg_FreelancerHero={1:'freelancer'}, udg_SpiritOfGaya={1:'gaya'},
        udg_PlayerHouse={1:'house'}, udg_Difficulty=2,
        udg_TitleForce=defaultdict(set), udg_CheaterForce=set(),
        udg_LegendaryGuardianForce=set(), udg_NewGamePlusLevel=defaultdict(int),
        udg_ItemIdTable={int(i):int(i) for i in layout['items']},
        udg_SaveFlagForce=defaultdict(set,{i:{9} for i in layout['legacy_rejected_items']}),
        udg_SpeedrunMode=False, bj_MAX_INVENTORY=6, ITEM_TYPE_CHARGED='charged',
        Trig_Cmd_Load_Code_OpenCode=lambda *a:1,
        Trig_Cmd_Load_Code_ReadBits=lambda sid,n:r.bits_(n,'source'),
        Trig_Cmd_Load_Code_CharToValue=legacy.savecode.value_of,
        Trig_Cmd_Load_Code_ApplyJobLevel=lambda p,i,l:jobs.update({str(i):l}),
        Trig_Cmd_Load_Code_FlushBits=lambda sid:r.finish(),
        Player_GetHero=lambda p:'hero',GetPlayerId=lambda p:p,GetHeroLevel=lambda u:1,
        GetUnitAbilityLevel=lambda *a:0,GetPlayerState=lambda *a:0,
        SetHeroLevel=lambda u,l,b:levels.update({u:l}),
        SetPlayerTechResearched=lambda p,i,v:upgrades.update({i:v}),
        GetUnitX=lambda u:0,GetUnitY=lambda u:0,Player=lambda p:p,
        CreateItem=lambda raw,x,y:dict(item_id=raw,quantity=None),
        GetItemType=lambda item:'charged' if layout['items'][str(item['item_id'])]['charged'] else 'gear',
        SetItemCharges=lambda item,qty:item.update(quantity=qty),
        UnitAddItem=lambda u,item:inv[u].append(item) or True,
        IsPlayerInForce=lambda p,f:p in f,ForceAddPlayer=lambda f,p:f.add(p),
        StringLength=len,SubString=lambda s,a,b:s[a:b],
        PLAYER_NEUTRAL_PASSIVE=15,PLAYER_STATE_RESOURCE_FOOD_USED=0)
    names=['Trig_Cmd_Load_Code_ReadLevelCapFlag','Trig_Cmd_Load_Code_ReadUpgradeCapFlag',
        'Trig_Cmd_Load_Code_ReadLevel','Trig_Cmd_Load_Code_LoadJobLevel',
        'Trig_Cmd_Load_Code_LoadHeroLevel','Trig_Cmd_Load_Code_LoadInventory',
        'Trig_Cmd_Load_Code_LoadUpgrade','Trig_Cmd_Load_Code_LoadUpgradeCapped',
        'Trig_Cmd_Load_Code_LoadForceFlag','Trig_Cmd_Load_Code_ItemAllowed',
        'Trig_Cmd_Load_Code_IsChocoboFood','Trig_Cmd_Load_Code_LoadCodeV2',
        'Trig_Cmd_Load_Code_LoadCodeV3']
    # The existing subset harness retains rawcode literals as strings; JASS's
    # single-character 'd' literal is integer 100 in this comparison.
    e=execute(text.replace("'d'", '100'),names,e)
    e['Trig_Cmd_Load_Code_LoadCodeV2' if version<=5 else 'Trig_Cmd_Load_Code_LoadCodeV3'](code,0,False)
    return r.log[header_reads:],jobs,levels,upgrades,inv,e


def source_new_game(minus):
    source=SAVE.read_text()
    e=mocks(source)
    result=[]
    def begin(version,p,blank):
        nonlocal writer
        writer=legacy.savecode.Writer(version)
        for value,width in [(legacy.savecode.name_hash('MigrationFixture'),20),(0,2),(300,20)]:
            writer.bits_(value,width)
        return 0
    def finish(sid,armory):
        assert not armory
        if writer.bits: writer.bits_(0,6-writer.bits)
        cs=legacy.savecode.checksum(writer.out)
        header=''.join(legacy.savecode.ALPHABET[(cs>>s)&63] for s in (12,6,0))
        result.append('G'+header+writer.out)
    writer=None
    e.update(udg_ArmoryItemCount=defaultdict(int),udg_Difficulty=2,
        udg_CodeDifficulty=defaultdict(int),udg_JobUnitType=defaultdict(lambda:None,{i:i+1 for i in range(22)}),
        udg_NewGamePlusLevel=defaultdict(int),udg_PlayerName=defaultdict(str),
        udg_LegendaryGuardianForce=set(),udg_MiracleStage=defaultdict(int,{0:-1,1:2}),
        GetPlayerId=lambda p:p,Util_BoolToInt=int,IsPlayerInForce=lambda p,f:p in f,
        ModuloInteger=lambda a,b:a%b,Save_Begin=begin,
        Save_WriteBits=lambda sid,value,width:writer.bits_(value,width),
        Save_PushForceFlag=lambda sid,force:writer.bits_(0,1),
        Save_Finish=finish,I2S=str,StringLength=len,SubString=lambda s,a,b:s[a:b])
    env=execute(source,['Save_WriteNewGameCode'],e)
    env['Save_WriteNewGameCode'](0,minus)
    return result[0]


class LegacyTests(unittest.TestCase):
    def test_new_game_source_routes_are_audited_without_fixing_runtime(self):
        plus,_=legacy.decode(source_new_game(False))
        minus,_=legacy.decode(source_new_game(True))
        self.assertEqual((plus['currency'],plus['miracle_stage'],plus['new_game_plus']),(300,2,1))
        self.assertTrue(all(value==0 for value in plus['jobs'].values()))
        self.assertTrue(all(not items for items in plus['inventories'].values()))
        # Source audit finding: NG- emits NG bits9, which the current reader
        # marks as cheating. Record the discrepancy; do not alter old code here.
        self.assertEqual(minus['ng_wire_value'],9)
        self.assertIsNone(minus['new_game_plus'])
        self.assertTrue(minus['cheater_flag'])

    def test_frozen_charge_and_rejection_classification(self):
        layout=json.loads(legacy.LAYOUT.read_text())
        table=legacy.savecode.load_items(str(legacy.ROOT/'src/itemtable.txt'))
        self.assertEqual({str(i):dict(rawcode=x['id'],charged=x['charged']) for i,x in table.items()},layout['items'])
        armory=(legacy.ROOT/'src/triggers/05 Items crafting and shops/Armory.j').read_text()
        actual={literal_int(x) for x in re.findall(r'ForceAddPlayerSimple\(Player\(9\),udg_SaveFlagForce\[([^]]+)\]\)',armory)}
        self.assertEqual(actual,set(layout['legacy_rejected_items']))

    def test_coloring_whitespace_and_alphabet_aliases(self):
        code=fixture('H',with_armory=True)
        expected,_=legacy.decode(code)
        colored=' '.join('|cffffcc00'+c+'|r' for c in code.replace('$','-').replace('#','.'))
        self.assertEqual(legacy.decode(colored)[0],expected)

    def test_actual_armory_writer_dense_sparse_random_roundtrips(self):
        order=json.loads(legacy.LAYOUT.read_text())['armory_order']
        rng=random.Random(24342)
        cases=[set(),set(order),{order[0]},{order[-1]},set(order[::2]),{71,150}]
        cases += [{i for i in order if rng.randrange(4)==0} for _ in range(20)]
        for version in 'FH':
            for owned in cases:
                code=source_armory_code(fixture(version),owned)
                decoded,_=legacy.decode(code)
                self.assertEqual(set(decoded['armory']['saved_item_ids']),owned)

    def test_historical_armory_writer_stops_before_appended_materia(self):
        order=sorted(LEGACY_FLAGS)
        for version in 'FH':
            for owned in [set(),set(order),{order[-1]},set(order[::2])]:
                decoded,_=legacy.decode(source_armory_code(fixture(version),owned,modern=False))
                self.assertEqual(set(decoded['armory']['saved_item_ids']),owned)

    def test_invalid_inventory_and_nonzero_padding_rejected(self):
        code=fixture('G')
        _,trace=legacy.decode(code)
        for field,value in [('hero.count',7),('hero.item_id',511),('padding',1)]:
            writer=legacy.savecode.Writer(6)
            changed=False
            for label,width,old in trace:
                if label==field and not changed:
                    old,changed=value,True
                writer.bits_(old,width)
            self.assertTrue(changed,field)
            checksum=legacy.savecode.checksum(writer.out)
            header=''.join(legacy.savecode.ALPHABET[(checksum>>s)&63] for s in (12,6,0))
            with self.assertRaises(legacy.Error):legacy.decode('G'+header+writer.out)

    def test_reader_source_fingerprints_are_still_reviewed(self):
        data=json.loads(legacy.LAYOUT.read_text())
        f=functions(CMD.read_text())
        for name,expected in data['source_fingerprints'].items():
            self.assertEqual(fingerprint(f[name]),expected,name)
        writers=functions(SAVE.read_text())
        for name,expected in data['writer_fingerprints'].items():
            self.assertEqual(fingerprint(writers[name]),expected,name)

    def test_pinned_vectors_and_independent_expectations(self):
        for case in json.loads(FIXTURES.read_text())['cases']:
            with self.subTest(case=case['name']):
                self.assertEqual(fixture(case['version'],case['capped'],case['armory']),case['code'])
                decoded,_=legacy.decode(case['code'],'MigrationFixture#1234')
                for key,expected in case['expected'].items():
                    self.assertEqual(decoded[key],expected,key)

    def test_every_main_field_matches_executed_jass(self):
        for version in 'EFGH':
            for capped in (False,True):
                with self.subTest(version=version,capped=capped):
                    code=fixture(version,capped)
                    snapshot,trace=legacy.decode(code)
                    source,jobs,levels,upgrades,inv,e=source_main(code)
                    self.assertEqual([(n,v) for _,n,v in trace[3:]],[(n,v) for _,n,v in source])
                    self.assertEqual(jobs,snapshot['jobs'])
                    self.assertEqual(levels.get('freelancer',0),snapshot['freelancer'])
                    self.assertEqual(levels['gaya'],snapshot['gaya']['level'])
                    for i,raw in json.loads(legacy.LAYOUT.read_text())['upgrades'].items():
                        self.assertEqual(upgrades.get(raw,0),snapshot['upgrades'][i])
                    for holder,records in snapshot['inventories'].items():
                        effective=[dict(item_id=x['item_id'],quantity=x['quantity']) for x in records
                                   if version in 'GH' or x['item_id'] not in json.loads(legacy.LAYOUT.read_text())['legacy_rejected_items']]
                        self.assertEqual(inv[holder],effective)
                    self.assertEqual(e['udg_NewGamePlusLevel'][1],snapshot['new_game_plus'])

    def test_wrong_account_and_checksum_rejected(self):
        code=fixture('G')
        with self.assertRaisesRegex(legacy.Error,'another account'): legacy.decode(code,'Other')
        changed='A' if code[5]!='A' else 'B'
        with self.assertRaisesRegex(legacy.Error,'checksum'): legacy.decode(code[:5]+changed+code[6:])

    def test_armory_corruption_and_link_rejected(self):
        code=fixture('H',with_armory=True)
        prefix,segment=code[:-1].split('(')
        with self.assertRaisesRegex(legacy.Error,'armory checksum'):
            legacy.decode(prefix+'('+segment[:6]+'A'+segment[7:]+')')
        rest='AAA'+segment[6:]
        checksum=legacy.savecode.checksum(rest)
        header=''.join(legacy.savecode.ALPHABET[(checksum>>s)&63] for s in (12,6,0))
        with self.assertRaisesRegex(legacy.Error,'link mismatch'):
            legacy.decode(prefix+'('+header+rest+')')

    def test_missing_armory_is_explicitly_pending(self):
        snapshot,_=legacy.decode(fixture('F'))
        self.assertTrue(snapshot['armory_pending'])
        self.assertIsNone(snapshot['armory'])

    def test_trailing_characters_and_all_truncations_rejected(self):
        code=fixture('E')
        body=code[4:]+'A'
        cs=legacy.savecode.checksum(body)
        header=''.join(legacy.savecode.ALPHABET[(cs>>s)&63] for s in (12,6,0))
        with self.assertRaisesRegex(legacy.Error,'trailing'):legacy.decode('E'+header+body)
        for length in range(len(code)):
            with self.assertRaises(legacy.Error):legacy.decode(code[:length])


if __name__=='__main__':
    unittest.main()

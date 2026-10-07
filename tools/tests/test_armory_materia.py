"""Execute armory storage and both legacy/current bitmap serializers with mocked natives."""
from collections import defaultdict
import copy
import json
import random
import re
import subprocess
import sys
from pathlib import Path
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT
from check_save_compat import compare, MATERIA_EXTENSION
from jtok import functions
import test_quest_lifecycle as harness
from test_shared_context import mocks
from test_armory_catalog import runtime

ARMORY = ROOT/'src/triggers/05 Items crafting and shops/Armory.j'
CMD = ROOT/'src/triggers/09 Player features/Cmd.j'
SAVE = ROOT/'src/triggers/09 Player features/Save.j'
INDEX = 'Trig_Cmd_Load_Code_ArmoryFlagIndex'
MATERIA = {71: 'I025', 100: 'I03F', 103: 'I03N', 150: 'I07P'}
CONTRACT = json.loads((ROOT/'tools/contracts/save-compatibility.json').read_text())
LEGACY_FLAGS = {int(k): v[-1] for k, v in CONTRACT['armory_flags'].items() if int(k)<=351}


def execute(source, names, env):
    source=re.sub(r'\b(if|elseif|exitwhen)\(', r'\1 (', source)
    source=source.replace(')then', ') then')
    with patch.object(harness, 'SELECTED', []):
        return harness.load_engine(source, names, env)


def original(path):
    return subprocess.check_output(['git', '-c', 'safe.directory='+str(ROOT).replace('\\', '/'),
                                    'show', '0db1622:'+path.relative_to(ROOT).as_posix()],
                                   cwd=ROOT).decode('utf-8')


def writer(source, owned, current):
    cmd = CMD.read_text()
    env = mocks(source+'\n'+cmd)
    flags = dict(LEGACY_FLAGS)
    if current:
        flags.update({i: 'm%03d'%i for i in MATERIA})
    env.update(udg_SaveFlagUnitID=defaultdict(lambda:None, flags),
               udg_SaveFlagForce=defaultdict(set, {i: {1} for i in owned}),
               udg_SaveFlagCount=351, udg_SaveDebug=False,
               udg_SavePlayer=defaultdict(int, {0: 1}),
               udg_SaveCodePlain=defaultdict(str), udg_SaveCodeChunk=defaultdict(str),
               udg_SaveChunkIndex=defaultdict(int), udg_SaveChunkBase=defaultdict(int),
               udg_CodeBits=defaultdict(int), IsPlayerInForce=lambda p,f: p in f,
               I2S=str, StringLength=len, SubString=lambda s,a,b: s[a:b],
               Save_ColorChar=lambda *a: '', Trig_Cmd_Load_Code_Checksum=lambda *a: 0)
    bits=[]
    def write(sid,value,size):
        bits.extend(int(c) for c in format(value, '0%db'%size))
        env_live['udg_CodeBits'][sid]=len(bits)%6
        if len(bits)%6==0:
            env_live['udg_SaveCodePlain'][sid]+='A'
    env['Save_WriteBits']=write
    env_live=execute(source+'\n'+cmd, ([INDEX] if current else [])+['Save_EncodeUnitFlags'], env)
    env_live['Save_EncodeUnitFlags'](0,0)
    return bits


def reader(source, bits, current):
    env=mocks(source)
    flags=dict(LEGACY_FLAGS)
    if current:
        flags.update({i:'m%03d'%i for i in MATERIA})
    forces=defaultdict(set)
    pos=0
    def read(reader,size):
        nonlocal pos
        value=0
        for bit in bits[pos:pos+size]:
            value=value*2+bit
        if pos+size>len(bits):
            raise AssertionError('armory reader ran past payload')
        pos+=size
        return value
    env.update(udg_SaveFlagUnitID=defaultdict(lambda:None,flags), udg_SaveFlagForce=forces,
               udg_SaveFlagCount=351, udg_ArmoryItemCount=defaultdict(int),
               Trig_Cmd_Load_Code_ArmoryHeader=lambda r:'AAAAAA',
               Trig_Cmd_Load_Code_CharToValue=lambda c:0,
               Trig_Cmd_Load_Code_ArmoryChecksum=lambda r:0,
               Trig_Cmd_Load_Code_GetCodeChecksum=lambda r:0,
               Trig_Cmd_Load_Code_ReadBits=read, GetPlayerId=lambda p:p-1,
               ForceAddPlayer=lambda f,p:f.add(p), StringLength=len,
               SubString=lambda s,a,b:s[a:b], I2S=str)
    env=execute(source, ([INDEX] if current else [])+['Trig_Cmd_Load_Code_LoadArmory'],env)
    env['Trig_Cmd_Load_Code_LoadArmory'](0,1)
    return {i for i,f in forces.items() if 1 in f},env['udg_ArmoryItemCount'][1]


class MateriaTests(unittest.TestCase):
    def test_save_guard_requires_exact_reviewed_extension_and_blocks_interleaving(self):
        extension=json.loads(MATERIA_EXTENSION.read_text())
        current=copy.deepcopy(CONTRACT)
        current['armory_flags'].update(extension['armory_flags'])
        current['armory_flags']['508']=['mCat']
        for name,entry in extension['serializers'].items():
            current['serializers'][name]=entry['extended']
        current['serializers'][INDEX]=extension['helper']['fingerprint']
        self.assertEqual(compare(current,CONTRACT),[])
        for section,key,value in [('armory_flags','70',['new!']),
                                  ('armory_flags','71',['bad!']),
                                  ('serializers',INDEX,'wrong'),
                                  ('serializers','Save_EncodeUnitFlags','wrong')]:
            changed=copy.deepcopy(current)
            changed[section][key]=value
            self.assertTrue(compare(changed,CONTRACT))

    def test_save_order_preserves_all_existing_flags_and_appends_materia(self):
        env=execute(CMD.read_text(),[INDEX],{})
        order=[env[INDEX](i) for i in range(1,356)]
        eligible=set(LEGACY_FLAGS)|set(MATERIA)
        self.assertEqual([i for i in order if i in eligible],sorted(LEGACY_FLAGS)+list(MATERIA))
        # Future append-only inventory indexes follow the four new armory bits.
        self.assertEqual(env[INDEX](356),352)

    def test_legacy_payloads_load_without_shift_and_new_materia_roundtrip(self):
        old_save,old_cmd=original(SAVE),original(CMD)
        new_save,new_cmd=SAVE.read_text(),CMD.read_text()
        rng=random.Random(129)
        existing=sorted(LEGACY_FLAGS)
        cases=[set(),set(existing),{existing[0]},{existing[-1]},set(existing[:254]),set(existing[::2])]
        cases += [{i for i in existing if rng.randrange(4)==0} for _ in range(20)]
        for owned in cases:
            old_bits=writer(old_save,owned,False)
            self.assertEqual(reader(new_cmd,old_bits,True),(owned,len(owned)))
            new_bits=writer(new_save,owned,True)
            self.assertEqual(reader(old_cmd,new_bits,False),(owned,len(owned)))
            for added in [set(MATERIA),{71},{150}]:
                all_owned=owned|added
                self.assertEqual(reader(new_cmd,writer(new_save,all_owned,True),True),(all_owned,len(all_owned)))

    def test_only_final_materia_can_be_stored_and_duplicate_deposit_is_kept(self):
        source=ARMORY.read_text()
        env=mocks(source)
        env.update(udg_PlayerHouse=defaultdict(str,{1:'house'}),
                   udg_TitleForce=defaultdict(set,{35:{1}}),
                   GetTriggerUnit=lambda:'house', GetOwningPlayer=lambda u:1,
                   GetConvertedPlayerId=lambda p:p, GetManipulatedItem=lambda:'item',
                   IsPlayerInForce=lambda p,f:p in f, ITEM_TYPE_CAMPAIGN='campaign',
                   ITEM_TYPE_CHARGED='charged', GetItemUserData=lambda i:0,
                   GetItemType=lambda i:'charged', GetItemTypeId=lambda i:'I025')
        env=execute(source,['Armory_IsStorableMateria','Trig_Armory_Store_Item_ItemIsMine',
                            'Trig_Armory_Store_Item_Conditions'],env)
        for raw in MATERIA.values():
            env['GetItemTypeId']=lambda i,r=raw:r
            self.assertTrue(env['Trig_Armory_Store_Item_Conditions']())
        for raw in ['I023','I024','I03G','I03H','I03L','I03M','I07N','I07O','phea']:
            env['GetItemTypeId']=lambda i,r=raw:r
            self.assertFalse(env['Trig_Armory_Store_Item_Conditions']())
        env['GetItemTypeId']=lambda i:'I025'
        env['GetItemUserData']=lambda i:2
        self.assertFalse(env['Trig_Armory_Store_Item_Conditions']())
        env['GetItemUserData']=lambda i:0
        env['udg_TitleForce'][35].clear()
        self.assertFalse(env['Trig_Armory_Store_Item_Conditions']())
        flags=defaultdict(set)
        removed=[]
        env.update(udg_SaveFlagForce=flags,udg_ArmoryItemCount=defaultdict(int),
                   udg_ItemIndex=0,LoadInteger=lambda *a:71,
                   ForceAddPlayerSimple=lambda p,f:f.add(p),RemoveItem=removed.append,
                   GetItemName=lambda i:'Wateraga Materia',
                   Trig_Armory_Store_Item_ArmoryOpen=lambda:False,
                   Trig_Armory_Store_Item_No50Award=lambda:True,
                   Trig_Armory_Store_Item_Has50Items=lambda:False)
        env=execute(source,['Trig_Armory_Store_Item_NewArmoryEntry','Trig_Armory_Store_Item_Actions'],env)
        env['Trig_Armory_Store_Item_Actions']()
        self.assertEqual(flags[71],{1})
        self.assertEqual(env['udg_ArmoryItemCount'][1],1)
        env['Trig_Armory_Store_Item_Actions']()
        self.assertEqual(removed,['item'])
        self.assertEqual(env['udg_ArmoryItemCount'][1],1)

    def test_materia_category_hint_count_and_withdrawal(self):
        env,shop,stock,flags=runtime()
        env['ArmoryMissingUnit']=defaultdict(int)
        env['Armory_InitHints']()
        for i in MATERIA:
            env['udg_SaveFlagUnitID'][i]='m%03d'%i
        env['udg_SaveFlagUnitID'][508]='mCat'
        env['GetUnitPointValueByType']=lambda raw:8 if raw in ['m%03d'%i for i in MATERIA] else 0
        env['I2S']=str
        env=execute(ARMORY.read_text(),['Armory_CollectionText','Armory_InCategory',
                    'Armory_ClearStock','Armory_ShowCategory','Trig_Armory_Select_Actions',
                    'Trig_Armory_Select_CanWithdraw'],env)
        self.assertTrue(env['Armory_InCategory'](508,0))
        env['Armory_ShowCategory'](shop,8)
        self.assertEqual(stock,['z071','z100','z103','z150'])
        self.assertEqual(env['Armory_CollectionText'](1),'0 / 280')
        flags[150].add(1)
        env['udg_TitleForce'][35]={1}
        env['udg_ArmoryItemCount'][1]=1
        env['udg_ItemIdTable'][150]='I07P'
        env['GetSoldUnit']=lambda:{'raw':'m150','index':150}
        env['Trig_Armory_Select_HasStockId']=lambda:True
        env['Trig_Armory_Select_IsCategoryNode']=lambda:False
        created=[]
        env['CreateItemLoc']=lambda raw,loc:created.append(raw)
        env['GetLastCreatedItem']=lambda:'item'
        env['GetItemName']=lambda i:'Aeroga Materia'
        env['ForceRemovePlayerSimple']=lambda p,f:f.remove(p)
        env['Armory_ShowCategory'](shop,8)
        self.assertIn('m150',stock)
        self.assertEqual(env['Armory_CollectionText'](1),'1 / 280')
        env['Trig_Armory_Select_Actions']()
        self.assertEqual(created,['I07P'])
        self.assertNotIn(1,flags[150])
        self.assertIn('z150',stock)
        self.assertEqual(env['Armory_CollectionText'](1),'0 / 280')

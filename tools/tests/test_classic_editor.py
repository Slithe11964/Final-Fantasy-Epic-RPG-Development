"""Classic baseline files must preserve GUI actions, source pairing and disabled flags."""
import unittest
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from wtg import read_wtg, write_wtg, ITEM_TYPES, action, string_param
from wct import read_wct, write_wct
from editor_layout import normalize, layout_errors


class ClassicEditorTests(unittest.TestCase):
    def fixture(self):
        tree=dict(format='classic', counts={k:0 for k in ITEM_TYPES},
                  deleted={k:[] for k in ITEM_TYPES}, game_version=2, tail=b'',
                  variables=[dict(name='Number',type='integer',unk=1,is_array=1,size=12,
                                  is_init=1,init='4',id=-100000,parent=0)],items=[
                      dict(kind=1,id=0,name='Map',is_comment=0,expanded=1,parent=-1),
                      dict(kind=4,id=22,name='Folder',is_comment=0,expanded=1,parent=0)])
        for i,name in enumerate(('Code','GUI')):
            tree['items'].append(dict(kind=8,id=-i-1,name=name,desc='Description',is_comment=0,
                                     enabled=not i,custom=not i,initially_off=i,run_on_init=not i,
                                     parent=22,functions=[] if not i else [action('CommentString',[string_param('Keep me')])]))
        source=dict(format='classic',comment=b'Comment',header=b'globals\r\nendglobals\r\n\0',
                    entries=[b'function InitTrig_Code takes nothing returns nothing\r\nendfunction\0',b''])
        return tree,source

    def test_classic_roundtrip_preserves_gui_and_source_pairing(self):
        tree,source=self.fixture()
        raw_tree,raw_source=write_wtg(tree),write_wct(source)
        restored,custom=read_wtg(raw_tree),read_wct(raw_source)
        self.assertEqual(write_wtg(restored),raw_tree)
        self.assertEqual(write_wct(custom),raw_source)
        self.assertFalse(restored['items'][-1]['enabled'])
        self.assertEqual(restored['items'][-1]['functions'],tree['items'][-1]['functions'])
        self.assertEqual(layout_errors(restored,custom),[])
        fixed,pairs=normalize(restored,custom)
        self.assertEqual(write_wtg(fixed),raw_tree)
        self.assertEqual(write_wct(pairs),raw_source)

    def test_nested_classic_folder_is_refused(self):
        tree,_=self.fixture()
        tree['items'][1]['parent']=22
        with self.assertRaisesRegex(ValueError,'nested'):
            write_wtg(tree)

    def test_wrong_classic_source_count_is_refused(self):
        _,source=self.fixture()
        import struct
        raw=bytearray(write_wct(source))
        offset=4+len(source['comment'])+1+4+len(source['header'])
        raw[offset:offset+4]=struct.pack('<I',3)
        with self.assertRaisesRegex(AssertionError,'count'):
            read_wct(bytes(raw))

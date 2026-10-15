"""An editor delta must reach both profiles without overwriting native inventory/UI."""
import copy
from pathlib import Path
import sys
import struct
from types import SimpleNamespace
import unittest
from unittest.mock import patch

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import Conflict, merge_value, merge_module, merge_objects, runtime_for, mirror_skin, decls, modules_for, exclude_resets
from downgrade import w3i_editor_v25, fill_missing
from jtok import functions
from objdata import read_objects,write_objects


def source(value=1,extra='',global_value=2):
    return ('library TExample requires TShared\nglobals\ninteger ExampleValue='+str(global_value)+
            '\nendglobals\nfunction Example takes nothing returns integer\n    return '+str(value)+
            '\nendfunction\n'+extra+'endlibrary\n')


def table(value,extra=None):
    def obj(raw,mods):
        return dict(base='ratf',id=raw,sets=[dict(flag=0,mods=[dict(field=k,type=3 if isinstance(v,str) else 0,
            level=None,data=None,value=v,end=0) for k,v in mods.items()])])
    entries=[obj('I031',value)]
    if extra:entries.append(obj('f016',extra))
    return write_objects(dict(version=3,original=[],custom=entries),3,'w3t')


def fields(data,raw):
    return {m['field']:m['value'] for o in read_objects(data,'w3t')['custom'] if o['id']==raw
            for st in o['sets'] for m in st['mods']}


class EditorPairTests(unittest.TestCase):
    def test_classic_fallback_preserves_explicit_field_reset(self):
        base=table({'igol':50,'ilev':2})
        edited=table({'ilev':2})
        fallback=table({'igol':60,'ilev':2,'iuse':1})
        pruned,count=exclude_resets(base,edited,fallback,'w3t')
        result=read_objects(edited,'w3t')
        fill_missing(result,read_objects(pruned,'w3t'))
        self.assertEqual(count,1)
        values=fields(write_objects(result,3,'w3t'),'I031')
        self.assertNotIn('igol',values)
        self.assertEqual(values['iuse'],1)

    def test_editor_scenario_conversion_preserves_world_settings_and_players(self):
        i=lambda *v:struct.pack('<'+'i'*len(v),*v)
        texts=b'Edited map\0Author\0Description\0Players\0'
        world=bytes(range(56))
        loading=b'Lpath\0Ltext\0Ltitle\0Lsubtitle\0'
        prologue=b'Ppath\0Ptext\0Ptitle\0Psubtitle\0'
        fog=bytes(range(20));weather=i(123)+b'Sound\0'+b'A\x01\x02\x03\x04'
        player=i(0,1,2,1)+b'Player name\0'+bytes(range(16))
        tail=i(1,3,1)+b'Team name\0'+i(0,0,0,0)
        common=i(7,7000)+texts+world+i(0x21)+b'L'+i(-1)+loading+i(1)+prologue+fog+weather
        expected=i(25)+common+i(1)+player+tail
        modern=(i(39,7,7000)+i(2,0,0,12345)+texts+world+i(0x700021)+b'L'+i(-1,0)+
                loading+i(1)+prologue+fog+bytes(24)+weather+i(0,3,2)+bytes(12+40)+i(1)+
                i(0,1,2,0)+i(1)+b'Player name\0'+bytes(range(16))+bytes(8)+tail)
        self.assertEqual(w3i_editor_v25(modern),expected)

    def test_shared_function_edit_preserves_native_helpers_and_requirements(self):
        helper='function NativePanel takes nothing returns nothing\nendfunction\n'
        native=source(extra=helper).replace('requires TShared','requires TNativeUI')
        result=merge_module(source(),source(5),native,'Example')
        self.assertIn('return 5',functions(result)['Example'])
        self.assertIn('NativePanel',functions(result))
        self.assertIn('requires TNativeUI',result)

    def test_user_and_profile_edit_same_function_requires_resolution(self):
        with self.assertRaisesRegex(Conflict,'Example/Example'):
            merge_module(source(),source(8),source(9),'Example')

    def test_new_helper_precedes_its_caller_and_new_global_is_retained(self):
        edited=source().replace('function Example takes',
            'function Added takes nothing returns integer\nreturn 3\nendfunction\nfunction Example takes')
        edited=edited.replace('return 1','return Added()').replace('integer ExampleValue=2','integer ExampleValue=7')
        result=merge_module(source(),edited,source(extra='// native extra\n'),'Example')
        self.assertLess(result.index('function Added'),result.index('function Example'))
        self.assertIn('integer ExampleValue=7',result)

    def test_text_merge_does_not_turn_jass_newlines_into_tooltip_separators(self):
        a='head\ncall A("first|nsecond")\nfoot\n'
        b=a.replace('head','new head')
        c=a.replace('foot','new foot')
        merged=merge_value(a,b,c,'source')
        self.assertIn('new head\n',merged)
        self.assertIn('first|nsecond',merged)
        self.assertIn('\nnew foot\n',merged)

    def test_changed_tooltip_and_stats_mirror_to_native_alias_with_native_slot(self):
        base=table({'unam':'Belt','igol':100,'utub':'Old description|n|cffffcc00Slot|r: Trinket','iabi':'A000'})
        edited=table({'unam':'New Belt','igol':150,'utub':'New description|n|cffffcc00Slot|r: Trinket','iabi':'A001'})
        native=table({'unam':'Belt','igol':100,'utub':'Old description|n|cffffcc00Forsaken slot|r: Trinket','iabi':'A000'},
            {'unam':'Belt','igol':100,'utub':'Old description|n|cffffcc00Forsaken slot|r: Trinket','iabi':'A000,fGmk','iequ':'Trinket','icla':'Equipment'})
        result=merge_objects(base,edited,native,'w3t',{'I031':['f016']})
        for raw in ('I031','f016'):
            values=fields(result,raw)
            self.assertEqual(values['unam'],'New Belt')
            self.assertEqual(values['igol'],150)
            self.assertEqual(values['utub'],'New description|n|cffffcc00Forsaken slot|r: Trinket')
        self.assertEqual(fields(result,'f016')['iabi'],'A001,fGmk')
        self.assertEqual(fields(result,'f016')['iequ'],'Trinket')

    def test_new_object_collision_and_conflicting_profile_field_stop(self):
        base=table({'igol':100})
        edit=table({'igol':150})
        native=table({'igol':200})
        with self.assertRaisesRegex(Conflict,'object field conflicts'):
            merge_objects(base,edit,native,'w3t')
        edited=table({'igol':100},{'unam':'New item'})
        native=table({'igol':100},{'unam':'Native item'})
        with self.assertRaisesRegex(Conflict,'collides'):
            merge_objects(base,edited,native,'w3t')

    def test_generated_alias_footer_and_new_author_text_do_not_conflict(self):
        old='Old|n|cffffcc00Slot|r: Trinket|n|cffffcc00Forsaken slot|r: Trinket'
        new='New|n|cffffcc00Slot|r: Trinket|nAccuracy: +5|n|cffffcc00Forsaken slot|r: Trinket'
        result=merge_objects(table({'utub':old}),table({'utub':new}),
            table({'utub':'Old|n|cffffcc00Forsaken slot|r: Trinket'}),'w3t')
        self.assertEqual(fields(result,'I031')['utub'],'New|nAccuracy: +5|n|cffffcc00Forsaken slot|r: Trinket')

    def test_accuracy_lookup_reads_warcraft_tooltip_linebreaks(self):
        sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'experiments/Forsaken'))
        import build_forsaken
        data=table({'utub':'A belt|nAccuracy: +5'})
        with patch.object(build_forsaken,'MPQ',lambda path:SimpleNamespace(read=lambda member:data)):
            lines=build_forsaken.item_accuracy_initialization('unused',{'I031':dict(variant='f016')})
        self.assertTrue(any("41,'I031',5" in line for line in lines))
        self.assertTrue(any("41,'f016',5" in line for line in lines))

    def test_generated_regions_change_without_copying_classic_library_globals(self):
        module=source()
        rt=('globals\ninteger ExampleValue=2\ninteger ClassicPages=7\nendglobals\n'+
            '//library TExample:\n'+functions(module)['Example']+'\n//library TExample ends\n'+
            'function CreateRegions takes nothing returns nothing\ncall RegionOld()\nendfunction\n'+
            'function InitCustomTriggers takes nothing returns nothing\nendfunction\n')
        base=SimpleNamespace(modules={'TExample':module},runtime=rt,entries={'TExample':dict(enabled=1,name='Example')})
        edited=copy.deepcopy(base);edited.runtime=rt.replace('RegionOld','RegionNew')
        native=copy.deepcopy(base);native.runtime=rt.replace('integer ClassicPages=7','integer NativeSlots=30')
        result=runtime_for(base,edited,native,dict(native.modules))
        self.assertIn('RegionNew()',result)
        self.assertIn('integer NativeSlots=30',result)
        self.assertNotIn('ClassicPages',result)

    def test_skin_does_not_hide_object_edit_but_explicit_skin_edits_are_retained(self):
        before=table({'unam':'Belt'});after=table({'unam':'New Belt'})
        self.assertEqual(fields(mirror_skin(before,after,before,before,'w3t'),'I031')['unam'],'New Belt')
        skin=table({'unam':'Localized belt'})
        self.assertEqual(fields(mirror_skin(before,after,before,skin,'w3t'),'I031')['unam'],'Localized belt')

    def test_ability_additions_preserve_native_ui_abilities(self):
        result=merge_objects(table({'iabi':'A000'}),table({'iabi':'A000,A001'}),
                             table({'iabi':'A000,fGmk'}),'w3t')
        self.assertEqual(fields(result,'I031')['iabi'],'A000,A001,fGmk')
        with self.assertRaisesRegex(Conflict,'native substitution'):
            merge_objects(table({'iabi':'A000'}),table({'iabi':'A001'}),
                          table({'iabi':'fGmk'}),'w3t')

    def test_global_url_literal_is_not_truncated_as_a_comment(self):
        self.assertEqual(decls('globals\nstring url="https://example.com" // note\nendglobals\n')['url'],
                         'string url="https://example.com"')

    def test_enabling_and_disabling_an_editor_module_updates_runtime_and_init_call(self):
        module=source(extra='function InitTrig_Example takes nothing returns nothing\nendfunction\n')
        rt='globals\nendglobals\nfunction InitCustomTriggers takes nothing returns nothing\nendfunction\n'
        base=SimpleNamespace(modules={'TExample':module},runtime=rt,entries={'TExample':dict(name='Example',enabled=0)})
        edited=copy.deepcopy(base);edited.entries['TExample']['enabled']=1
        compiled=runtime_for(base,edited,base,dict(base.modules))
        self.assertIn('Example',functions(compiled))
        self.assertIn('call InitTrig_Example()',functions(compiled)['InitCustomTriggers'])
        active=copy.deepcopy(edited);active.runtime=compiled
        result=runtime_for(active,base,active,dict(active.modules))
        self.assertNotIn('Example',functions(result))
        self.assertNotIn('InitTrig_Example()',functions(result)['InitCustomTriggers'])

    def test_codec_edits_require_explicit_save_compatibility_review(self):
        a=SimpleNamespace(modules={'TForsakenSaveCodec':source()},entries={})
        b=SimpleNamespace(modules={'TForsakenSaveCodec':source(4)},entries={})
        with self.assertRaisesRegex(Conflict,'codec migration'):modules_for(a,b,a)

    def test_macro_edits_are_rejected_instead_of_silently_dropping_expansion(self):
        a=SimpleNamespace(modules={'TExample':source()},entries={})
        b=SimpleNamespace(modules={'TExample':source().replace('endlibrary','//! runtextmacro NewBehavior()\nendlibrary')},entries={})
        with self.assertRaisesRegex(Conflict,'compiler support'):modules_for(a,b,a)

    def test_load_guard_generator_includes_new_editor_trigger(self):
        sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'experiments/Forsaken'))
        from build_save_roundtrip import load_source
        rt=('trigger udg_NewQuest=null\ntrigger array QuestStepPickupTrigger\n'
            'constant integer QUEST_MAX_STEPS=16\n')
        guard=functions(load_source(rt))['FFL_Guard']
        self.assertIn('FFL_OneGuard(udg_NewQuest,0,block)',guard)
        self.assertIn('QuestStepPickupTrigger[slot]',guard)


if __name__=='__main__':unittest.main()

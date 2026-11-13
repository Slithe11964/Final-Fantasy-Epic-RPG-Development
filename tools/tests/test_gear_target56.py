"""Unit-target cue, focus recovery and selected primary-only ability rebinding."""
import sys,unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from gear_target56 import refresh
from test_armory_materia import execute
import test_quickui55

ROOT=Path(__file__).resolve().parents[2]


class TargetTests(unittest.TestCase):
    def runtime(self):
        env,state,worn,textures,visibility,events,presented=test_quickui55.RepaintTests().runtime()
        source=refresh(View(ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x').modules['TEquip'])
        focus=[True];images={};positions={};binding=[]
        env.update(QuickGearTargetImage='target-rune',QuickGearTargetPreview=False,QuickGearClientActive=True,
            QuickGearExpectedSpell=defaultdict(int),QuickGearActualSpell=defaultdict(int),QuickGearSpellObserver=None,
            BlzIsLocalClientActive=lambda:focus[0],ShowImage=lambda handle,value:images.__setitem__(handle,value),
            SetImageRenderAlways=lambda *args:None,SetImagePosition=lambda image,x,y,z:positions.__setitem__(image,(x,y)),
            GetUnitX=lambda unit:500.,GetUnitY=lambda unit:600.,BlzGetItemAbility=lambda item,raw:'active',
            BlzItemRemoveAbility=lambda item,raw:binding.append(('remove',item,raw)) or True,
            BlzItemAddAbility=lambda item,raw:binding.append(('add',item,raw)) or True,
            QuickGearMouseKnown=True,QuickGearMouseX=100.,QuickGearMouseY=200.)
        env=execute(source,[n for n in functions(source) if n.startswith('QuickGear_')],env)
        return env,state,worn,focus,images,positions,binding

    def test_unit_target_offhand_arms_visible_cue_follows_target_and_cancels(self):
        env,state,worn,focus,images,pos,binding=self.runtime()
        env['QuickGear_Request'](1)
        self.assertEqual(env['QuickGearPending'],1)
        self.assertTrue(images['target-rune']);self.assertEqual(pos['target-rune'],(436.,536.))
        env['BlzGetMouseFocusUnit']=lambda:None
        env['QuickGearMouseX']=800.;env['QuickGearMouseY']=900.
        env['QuickGear_MovePreview']();self.assertEqual(pos['target-rune'],(736.,836.))
        env['QuickGear_ClearPreview']();self.assertFalse(images['target-rune'])
        self.assertFalse(env['QuickGearTargetPreview']);self.assertEqual(binding,[])

    def test_focus_loss_and_return_clear_stale_chat_and_pending_state(self):
        env,state,worn,focus,images,pos,binding=self.runtime()
        env['QuickGearChatOpen']=True;env['QuickGearPending']=1
        focus[0]=False;self.assertFalse(env['QuickGear_FocusReset']())
        self.assertFalse(env['QuickGearChatOpen']);self.assertEqual(env['QuickGearPending'],-1)
        env['QuickGearChatOpen']=True
        focus[0]=True;self.assertTrue(env['QuickGear_FocusReset']())
        self.assertFalse(env['QuickGearChatOpen']);self.assertEqual(binding,[])

    def test_only_primary_unit_cast_rebinds_its_exact_active_ability(self):
        env,state,worn,focus,images,pos,binding=self.runtime()
        # Read the fixture's existing table through its original loader.
        load=env['LoadInteger']
        env['LoadInteger']=lambda table,parent,child:1 if table=='data' and parent==1 and child==101 else load(table,parent,child)
        env['BlzGetTriggerSyncData']=lambda:'0:55:101:7:99:100:100'
        before=dict(worn);env['QuickGear_Receive']()
        self.assertEqual(binding,[('remove','weapon',201),('add','weapon',201)])
        self.assertEqual(worn,before)
        self.assertEqual(env['QuickGearExpectedSpell'][0],201)
        binding.clear();env['BlzGetTriggerSyncData']=lambda:'1:55:102:7:99:100:100'
        env['QuickGear_Receive']();self.assertEqual(binding,[])


if __name__=='__main__':unittest.main()

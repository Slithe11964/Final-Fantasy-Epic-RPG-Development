"""Aiming ends on matching spell events or cancellation, not incidental inputs."""
import sys,re,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
from historical_map import historical_map
from editor_pair import View
from jtok import functions,tokens
ROOT=Path(__file__).resolve().parents[2]
PAIRS=[('QuickUI67/FFERPG-QuickUI67-Forsaken','QuickUI68/FFERPG-QuickUI68-Forsaken'),
 ('VersionEHotfix15/FFERPG-0.9.7.5e-Hotfix15-Forsaken','VersionEHotfix16/FFERPG-0.9.7.5e-Hotfix16-Forsaken')]

class Preview68Tests(unittest.TestCase):
    def view(self):return View(ROOT/'release/development/QuickUI68/FFERPG-QuickUI68-Forsaken.w3x')

    def test_late_native_left_click_does_not_clear_but_fg_still_sends_once(self):
        source=self.view().runtime
        for pending,button in [(-1,0),(-1,1),(0,0)]:
            clears=[];sent=[]
            env=dict(GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,GetTriggerEventId=lambda:1,
                EVENT_PLAYER_MOUSE_DOWN=1,EVENT_PLAYER_MOUSE_MOVE=2,BagScreen_Event66=lambda:None,
                BagHandled66=False,QuickGearPending=pending,BlzGetTriggerPlayerMouseButton=lambda:button,
                MOUSE_BUTTON_TYPE_LEFT=0,MOUSE_BUTTON_TYPE_RIGHT=1,Preview_LogClear68=lambda s:None,
                GearWave_Clear=lambda:clears.append('wave'),QuickGear_ClearPreview=lambda:clears.append('all'),
                BlzGetTriggerPlayerMouseX=lambda:700.,BlzGetTriggerPlayerMouseY=lambda:300.,
                BlzGetMouseFocusUnit=lambda:'enemy',GetHandleId=lambda u:99,
                QuickGearData='data',LoadInteger=lambda *a:1,QuickGear_Send=lambda *a:sent.append(a),
                QuickGearPendingHero=1,QuickGearPendingItem=2,QuickGearPendingMark=3)
            e=execute(source,['QuickGear_Mouse'],env);e['QuickGear_Mouse']()
            if pending<0:self.assertEqual(sent,[]);self.assertEqual(clears,['wave'] if button else [])
            else:self.assertEqual(len(sent),1);self.assertEqual(clears,['all'])

    def test_unrelated_hero_effect_does_not_end_native_aim_matching_channel_does(self):
        state=dict(spell=999,event=2,local=0);clears=[]
        env=dict(GetTriggerUnit=lambda:'hero',GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,
            Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:state['local'],
            GetTriggerEventId=lambda:state['event'],EVENT_PLAYER_UNIT_SPELL_EFFECT=2,
            GetSpellAbilityId=lambda:state['spell'],QuickGearActualSpell={0:0},GearWaveMode=1,
            GearWaveCast67=123,Preview_LogClear68=lambda s:None,ExecuteFunc=clears.append)
        e=execute(self.view().runtime,['QuickGear_RecordSpell'],env)
        e['QuickGear_RecordSpell']();self.assertEqual(clears,[]);self.assertEqual(e['QuickGearActualSpell'][0],999)
        state.update(spell=123,event=1);e['QuickGear_RecordSpell']()
        self.assertEqual(clears,['QuickGear_ClearPreview'])
        state['local']=1;e['QuickGear_RecordSpell']();self.assertEqual(len(clears),1)

    def test_right_click_cancels_aim_without_inventing_pickup_state(self):
        arms=[]
        env=dict(Player_GetHero=lambda p:'hero',GetLocalPlayer=lambda:0,GearWaveMode=1,
            QuickGearPending=-1,BagHoverSlot64=7,BagMoving64=False,BagCarried66=None,
            BagSourceSlot66=-1,BagMovedAt66=-100.,NativeCDClock='clock',TimerGetElapsed=lambda t:10.,
            Preview_LogClear68=lambda s:None,BagScreen_Item67=lambda *a:'item',
            BagCast_Spell63=lambda r:123,GetItemTypeId=lambda i:456,GearWave_Arm=arms.append,
            GearInputArmedAt=0.,BagScreenArms65=0)
        e=execute(self.view().runtime,['BagScreen_Click66'],env)
        e['QuickGear_ClearPreview']=lambda:e.update(GearWaveMode=0)
        e['BagScreen_Click66'](True);self.assertFalse(e['BagMoving64'])
        self.assertEqual(e['BagSourceSlot66'],-1)
        e['BagScreen_Click66'](False);self.assertEqual(arms,[123])
        # With no active targeting, right-click pickup still suppresses placement.
        e['BagScreen_Click66'](True);self.assertTrue(e['BagMoving64'])
        e['BagScreen_Click66'](False);self.assertEqual(arms,[123])

    def test_layout_combat_chat_and_local_safety_are_preserved(self):
        def clean(body):return tokens(re.sub(r'call Preview_LogClear68\("[^"\n]*"\)','',body))
        for old,new in PAIRS:
            av=View(historical_map(ROOT, old));bv=View(historical_map(ROOT, new))
            a,b=functions(av.runtime),functions(bv.runtime)
            for n in ['Wave65_Draw','Wave65_Init','Wave65_Reset','Wave65_Clear','Wave67_BuildEdge',
                'GearChat_Sent64','GearChat_Poll63','GearRaw_Poll64','QuickGear_Input','QuickGear_Request',
                'QuickGear_Receive','QuickGear_Poll','QuickGear_PaintIcon','QuickGear_RepaintIcons',
                'GearCursor_Error60','Forsaken_WaterTick','Trig_Spell_Blizzaga_Loop']:
                self.assertEqual(clean(a[n]),clean(b[n]),n)
            self.assertIn('EVENT_PLAYER_UNIT_SPELL_CHANNEL',b['QuickGear_InitDiagnostics'])
            self.assertIn('Last wave clear=',b['QuickGear_Diagnostic'])
            self.assertEqual(unsafe_paths(b,['QuickGear_RecordSpell','QuickGear_ClearPreview',
                'BagScreen_Click66','Preview_LogClear68']),[])
            for asset in ('war3map.w3a','war3map.w3u','war3map.w3t','GearError66.fdf','GearWaveRune.tga'):
                self.assertEqual(av.archive.read(asset),bv.archive.read(asset))

if __name__=='__main__':unittest.main()

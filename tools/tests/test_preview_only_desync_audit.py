"""Exercise chat/focus/target arming without confirming any item cast.

This checks the script's request boundary, not Warcraft's multiplayer engine.
"""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class PreviewOnlyAudit(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        fs=functions(MPQ(str(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f-Forsaken.w3x')).read('war3map.j').decode())
        cls.names=['QuickGear_Input','QuickGear_FocusReset','QuickGear_Request',
            'GearChat_Sent64','GearChat_Poll63','GearWave_ModeFor','GearWave_Arm']
        cls.source='\n'.join(fs[n] for n in cls.names)

    def test_chat_alt_tab_and_wave_preview_do_not_request_casts(self):
        for cast in ['A08X','A0Q2','A0UY']:
            with self.subTest(cast=cast):
                state=dict(active=True,key='ENTER',time=20.,event=1,trigger=0)
                sent=[];armed=[];env=mocks(self.source)
                env.update(GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:state['trigger'],
                    GetTriggerEventId=lambda:state['event'],EVENT_PLAYER_CHAT=2,
                    GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',
                    QuickGear_Item=lambda h,s:'book',GetItemTypeId=lambda i:123,
                    GetWidgetLife=lambda h:100.,IsUnitSelected=lambda h,p:True,
                    GetUnitTypeId=lambda h:456,GetItemUserData=lambda i:1,
                    GetUnitAbilityLevel=lambda *a:1,IMaxBJ=max,
                    QuickGearData='table',LoadInteger=lambda table,k,r:cast if k==0 else 2,
                    TimerGetElapsed=lambda t:state['time'],NativeCDClock='clock',
                    BlzIsLocalClientActive=lambda:state['active'],
                    BlzGetTriggerPlayerKey=lambda:state['key'],BlzGetTriggerPlayerIsKeyDown=lambda:True,
                    OSKEY_RETURN='ENTER',OSKEY_ESCAPE='ESC',ConvertOsKeyType=lambda k:k,
                    QuickGearWeaponKey={0:'F'},QuickGearOffhandKey={0:'G'},TravelVisible={0:False},
                    QuickGearHeld=defaultdict(bool),QuickGearLastPress=defaultdict(lambda:-1.),
                    QuickGearChatSentAt=-100.,QuickGearChatOpen=False,QuickGearKeyEvents=0,
                    QuickGearRequests=0,QuickGearClientActive=True,GearChatRecover63=False,
                    QuickGearChatEdit=None,QuickGearPending=-1,QuickGearPreview=0,
                    GearWaveMode=0,GearWaveCast67=0,GearWaveStarted=0.,
                    QuickGear_Send=lambda *a:sent.append(a),I2S=str)
                e=execute(self.source,self.names,env)
                e['QuickGear_ClearPreview']=lambda:e.update(GearWaveMode=0)
                e['GearWave_Clear']=lambda:e.update(GearWaveMode=0)
                e['Preview_LogClear68']=lambda reason:None
                e['GearInput_Cursor']=lambda:armed.append(e['QuickGearPending'])
                e['QuickGear_Input']();self.assertTrue(e['QuickGearChatOpen'])
                state['key']='G';e['QuickGear_Input']()
                self.assertEqual(e['QuickGearPending'],-1)
                state['active']=False;e['QuickGear_FocusReset']()
                state.update(active=True,time=21.);e['QuickGear_FocusReset']()
                e['QuickGear_Input']()
                self.assertEqual(e['QuickGearPending'],1)
                self.assertEqual(e['GearWaveMode'],2 if cast=='A0UY' else 1)
                self.assertEqual(sent,[])
                # Sent chat recovers without a focus transition as well.
                e['GearChat_Sent64']();state['time']=22.;e['GearChat_Poll63']()
                self.assertFalse(e['QuickGearChatOpen'])
                state['key']='F';e['QuickGear_Input']()
                self.assertEqual(e['QuickGearPending'],0);self.assertEqual(sent,[])
                requests=e['QuickGearRequests'];state['trigger']=1
                e['QuickGear_Input']()
                self.assertEqual(e['QuickGearRequests'],requests)

if __name__=='__main__':unittest.main()

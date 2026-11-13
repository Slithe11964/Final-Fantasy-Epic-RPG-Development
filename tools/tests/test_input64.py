"""Post-chat recovery, fallback de-duplication, native inventory ownership."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
from jtok import functions,tokens
from historical_map import historical_map
from editor_pair import View
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Forsaken/Input64.j').read_text()
PAIRS=[('QuickUI63/FFERPG-QuickUI63-Forsaken','QuickUI64/FFERPG-QuickUI64-Forsaken'),
 ('VersionEHotfix11/FFERPG-0.9.7.5e-Hotfix11-Forsaken','VersionEHotfix12/FFERPG-0.9.7.5e-Hotfix12-Forsaken')]

class InputTests(unittest.TestCase):
    def test_physical_edges_recover_missing_callbacks_without_duplicate_casts(self):
        state=dict(down=set(),now=10.,active=True);requests=[]
        env=dict(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,
            BlzIsLocalClientActive=lambda:state['active'],QuickGearChatOpen=False,
            InventoryCinematicActive=False,TravelVisible={0:False},BlzIsMetaKeyPressed=lambda k:False,
            QuickGearWeaponKey={0:70},QuickGearOffhandKey={0:71},
            BlzIsKeyPressed=lambda k:k in state['down'],ConvertOsKeyType=lambda k:k,
            GearRawDown64={0:False,1:False},QuickGearLastPress={0:-1.,1:-1.},
            NativeCDClock='clock',TimerGetElapsed=lambda t:state['now'],
            GearRawRequests64=0,QuickGear_Request=requests.append)
        e=execute(SOURCE,['GearRaw_Poll64'],env)
        state['down']={70};e['GearRaw_Poll64']();e['GearRaw_Poll64']()
        self.assertEqual(requests,[0])
        state['down']=set();e['GearRaw_Poll64']()
        # Native event handled G first; the physical fallback must not double it.
        e['QuickGearLastPress'][1]=10.;state['down']={71};e['GearRaw_Poll64']()
        self.assertEqual(requests,[0])
        state['down']=set();e['GearRaw_Poll64']();state.update(now=11.,down={71})
        e['GearRaw_Poll64']();self.assertEqual(requests,[0,1])

    def test_letter_held_in_chat_does_not_cast_on_chat_close(self):
        # Same edge observer, all requests forbidden while chat is open.
        state=dict(down=True);requests=[]
        env=dict(GetPlayerId=lambda p:p,GetLocalPlayer=lambda:0,BlzIsLocalClientActive=lambda:True,
            QuickGearChatOpen=True,InventoryCinematicActive=False,TravelVisible={0:False},
            BlzIsMetaKeyPressed=lambda k:False,QuickGearWeaponKey={0:70},QuickGearOffhandKey={0:71},
            BlzIsKeyPressed=lambda k:state['down'] and k==70,ConvertOsKeyType=lambda k:k,
            GearRawDown64={0:False,1:False},QuickGearLastPress={0:-1.,1:-1.},NativeCDClock='clock',
            TimerGetElapsed=lambda t:10.,GearRawRequests64=0,QuickGear_Request=requests.append)
        e=execute(SOURCE,['GearRaw_Poll64'],env);e['GearRaw_Poll64']()
        e['QuickGearChatOpen']=False;e['GearRaw_Poll64']();self.assertEqual(requests,[])
        state['down']=False;e['GearRaw_Poll64']();state['down']=True;e['GearRaw_Poll64']()
        self.assertEqual(requests,[0])

    def test_packaged_recovery_no_longer_waits_for_return_release(self):
        for old,new in PAIRS:
            v=View(historical_map(ROOT, new));fs=functions(v.runtime)
            env=dict(GearChatRecover63=True,QuickGearChatOpen=True,NativeCDClock='clock',
                QuickGearChatSentAt=5.,QuickGearHeld={0:True,1:True},QuickGearChatEdit=None,
                BlzIsKeyPressed=lambda k:True,TimerGetElapsed=lambda t:5.2)
            e=execute(v.runtime,['GearChat_Poll63'],env);e['GearChat_Poll63']()
            self.assertFalse(e['QuickGearChatOpen']);self.assertFalse(e['GearChatRecover63'])
            self.assertIn('ExecuteFunc("GearChat_Sent64")',fs['Trig_Clear_Command_Actions'])

    def test_no_proxy_click_or_sync_registration_and_preserved_fg(self):
        for old,new in PAIRS:
            before=View(historical_map(ROOT, old));after=View(historical_map(ROOT, new))
            a,b=functions(before.runtime),functions(after.runtime)
            init=b['BagCast_Init63']
            self.assertNotIn('BlzTriggerRegisterFrameEvent',init)
            self.assertNotIn('BlzTriggerRegisterPlayerSyncEvent',init)
            self.assertIn('BlzFrameSetEnable(BagCastButton63[slot],false)',init)
            self.assertIn('BlzFrameSetTooltip',init)
            for name in ('BagCast_Click63','BagCast_Receive63','BagCast_Poll63'):
                self.assertEqual(tokens(b[name]),tokens('function '+name+' takes nothing returns nothing\nendfunction'))
            for name in ('QuickGear_Request','QuickGear_Receive','QuickGear_PaintIcon',
                'QuickGear_RepaintIcons','GearWave_Draw','Cine_Enter','Cine_Exit','Text_Caption'):
                self.assertEqual(tokens(a[name]),tokens(b[name]),name)
            self.assertEqual(unsafe_paths(b,['BagHover_Poll64','BagHover_World64','GearChat_Poll63',
                'GearRaw_Poll64','GearChat_Sent64']),[])
            self.assertIn('not left and not right and not BagMoving64',b['BagHover_Poll64'])
            self.assertIn('Width()/2),.14',b['GearCursor_Error60'])
            for asset in ('war3map.w3u','war3map.w3a','war3map.w3t','GearTarget61.tga','war3map.imp'):
                self.assertEqual(before.archive.read(asset),after.archive.read(asset))

if __name__=='__main__':unittest.main()

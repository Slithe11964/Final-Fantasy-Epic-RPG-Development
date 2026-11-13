"""Validate click routing and shared receiver; native click delivery needs Warcraft."""
import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
from jtok import functions,tokens
from editor_pair import View
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Forsaken/BagCast63.j').read_text()
PAIRS=[('QuickUI62/FFERPG-QuickUI62-Forsaken','QuickUI63/FFERPG-QuickUI63-Forsaken'),
       ('VersionEHotfix10/FFERPG-0.9.7.5e-Hotfix10-Forsaken','VersionEHotfix11/FFERPG-0.9.7.5e-Hotfix11-Forsaken')]

class BagCastTests(unittest.TestCase):
    def test_chat_submit_recovers_after_enter_release_and_delay(self):
        state=dict(down=True,time=5.);focus=[]
        env=dict(GearChatRecover63=True,QuickGearChatOpen=True,QuickGearChatSentAt=5.,
            QuickGearHeld={0:True,1:True},QuickGearChatEdit='edit',ForsakenPanelClock='clock',
            OSKEY_RETURN=13,BlzIsKeyPressed=lambda k:state['down'],
            TimerGetElapsed=lambda t:state['time'],BlzFrameSetFocus=lambda *a:focus.append(a))
        e=execute(SOURCE,['GearChat_Poll63'],env);e['GearChat_Poll63']()
        self.assertTrue(e['QuickGearChatOpen']);self.assertEqual(focus,[])
        state.update(down=False,time=5.2);e['GearChat_Poll63']();e['GearChat_Poll63']()
        self.assertFalse(e['QuickGearChatOpen']);self.assertFalse(e['GearChatRecover63'])
        self.assertEqual(focus,[('edit',False)]);self.assertEqual(e['QuickGearHeld'],{0:False,1:False})

    def receiver(self):
        state=dict(slot=7,heroRaw=111,raw=123,mark=9,x=100.,y=200.,mana=1000.,cd=0.,present=True)
        casts=[]
        def field(data,i):return [state['slot'],state['heroRaw'],state['raw'],state['mark'],state['x'],state['y']][i]
        env=dict(GetTriggerPlayer=lambda:0,Player_GetHero=lambda p:'hero',BlzGetTriggerSyncData=lambda:'packet',
            QuickGear_Field=field,S2I=int,S2R=float,GetOwningPlayer=lambda h:0,GetWidgetLife=lambda h:100.,
            BlzUnitItemInBagSlot=lambda h,s:'item' if state['present'] and s==7 else None,
            GetItemTypeId=lambda i:123 if i else 0,GetUnitTypeId=lambda h:111,GetItemUserData=lambda i:9,
            BagCast_Spell63=lambda r:456 if r==123 else 0,NativeCD_Left=lambda *a:state['cd'],
            NativeCD_Pool=lambda c:c,BlzGetUnitAbilityCooldownRemaining=lambda *a:0.,
            GetUnitState=lambda *a:state['mana'],UNIT_STATE_MANA=1,BlzGetAbilityManaCost=lambda *a:150,
            bj_mapInitialPlayableArea='map',GetRectMinX=lambda r:-1000.,GetRectMaxX=lambda r:1000.,
            GetRectMinY=lambda r:-1000.,GetRectMaxY=lambda r:1000.,UnitUseItemPoint=lambda *a:casts.append(a))
        return execute(SOURCE,['BagCast_Receive63'],env),state,casts

    def test_shared_receiver_checks_actual_slot_identity_cost_cooldown_and_bounds(self):
        e,s,casts=self.receiver();e['BagCast_Receive63']()
        self.assertEqual(casts,[('hero','item',100.,200.)])
        for changed in [dict(slot=-1),dict(slot=30),dict(slot=8),dict(heroRaw=222),dict(raw=999),
                        dict(mark=10),dict(mana=149.),dict(cd=2.),dict(x=1001.),dict(present=False)]:
            e,s,casts=self.receiver();s.update(changed);e['BagCast_Receive63']()
            self.assertEqual(casts,[],changed)

    def test_local_click_arms_wave_without_casting(self):
        arms=[];focus=[]
        e=execute(SOURCE,['BagCast_Click63'],dict(
            BagCastSlots63='slots',LoadInteger=lambda *a:8,GetHandleId=lambda f:99,
            BlzGetTriggerFrame=lambda:'button',GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:0,
            QuickGearChatOpen=False,InventoryCinematicActive=False,BlzIsLocalClientActive=lambda:True,
            BlzFrameSetFocus=lambda *a:focus.append(a),Player_GetHero=lambda p:'hero',
            BlzUnitItemInBagSlot=lambda h,s:'wateraga',BagCast_Spell63=lambda r:456,
            GetItemTypeId=lambda i:123,GetWidgetLife=lambda h:100.,IsUnitSelected=lambda *a:True,
            QuickGear_ClearPreview=lambda:None,GetUnitTypeId=lambda h:111,GetItemUserData=lambda i:9,
            NativeCDClock='clock',TimerGetElapsed=lambda t:10.,BagCastClicks63=0,
            QuickGearPending=-1,QuickGearPendingHero=0,QuickGearPendingItem=0,
            QuickGearPendingMark=0,GearInputArmedAt=0.,GearInputTarget=False,
            GearWave_Arm=arms.append,GearInput_Cursor=lambda:None))
        e['BagCast_Click63']();self.assertEqual(arms,[456])
        self.assertEqual(e['QuickGearPending'],107);self.assertEqual(e['QuickGearPendingMark'],9)
        self.assertEqual(focus,[('button',False)])

    def test_packaged_local_safety_and_confirmed_fg_preservation(self):
        for old,new in PAIRS:
            before=View(ROOT/f'tools/tests/fixtures/historical-maps/{old}.w3x');after=View(ROOT/f'tools/tests/fixtures/historical-maps/{new}.w3x')
            a,b=functions(before.runtime),functions(after.runtime)
            self.assertEqual(unsafe_paths(b,['BagCast_Click63','BagCast_Poll63','GearChat_Poll63',
                'GearInput_Cursor','GearWave_Draw','GearCursor_Draw60','QuickGear_PaintIcon','QuickGear_RepaintIcons']),[])
            for name in ['QuickGear_Request','QuickGear_Receive','QuickGear_PaintIcon','QuickGear_RepaintIcons',
                'GearInput_Cursor','GearWave_Draw','Cine_Enter','Cine_Exit','Text_Caption']:
                self.assertEqual(tokens(a[name]),tokens(b[name]),name)
            self.assertIn('QuickGearChatSentAt<.75',b['QuickGear_Input'])
            self.assertIn('set GearChatRecover63=true',b['QuickGear_Input'])
            self.assertIn('BagCast_Send63(QuickGearPending-100',b['QuickGear_Mouse'])
            self.assertIn('BlzPixelToFrameX(BlzGetLocalClientWidth()/2),.22',b['GearCursor_Error60'])
            self.assertIn('BagCast_Spell63',b['BagCast_Poll63'])
            self.assertNotIn('FRAMEEVENT_MOUSE_ENTER',b['BagCast_Init63'])
            self.assertNotIn('BlzFrame',b['GearProbe_Init62'])
            self.assertEqual(before.archive.read('GearTarget61.tga'),after.archive.read('GearTarget61.tga'))

if __name__=='__main__':unittest.main()

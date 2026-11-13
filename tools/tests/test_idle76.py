"""Exercise shared gear snapshots, idle suppression and native-slot fallback."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from idle76 import refresh as idle
from slots76 import refresh as slots
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class Idle76Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.before=View(ROOT/'release/development/QuickUI75/FFERPG-QuickUI75.w3x').modules['TEquip']
        cls.source=slots(idle(cls.before));cls.fs=functions(cls.source)

    def test_equipped_cache_is_same_on_both_clients_and_does_not_read_while_drawing(self):
        names=['Idle76_Capture','Idle76_Item'];s='\n'.join(self.fs[n] for n in names)
        for viewer in [0,1]:
            reads=[];gear={6:'staff',7:'depths'};env=mocks(s)
            env.update(Player=lambda p:p,Player_GetHero=lambda p:'hero' if p==0 else None,
                GetLocalPlayer=lambda:viewer,GetUnitTypeId=lambda u:123 if u else 0,
                GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,
                Idle76Hero=defaultdict(lambda:None),Idle76Equipment=defaultdict(lambda:None),
                EQUIPMENT_LOADOUT_SLOT_PRIMARY=6,EQUIPMENT_LOADOUT_SLOT_OFFHAND=7,
                BlzUnitItemInEquipmentSlot=lambda u,slot:(reads.append(slot),gear[slot])[1])
            e=execute(s,names,env);e['Idle76_Capture'](0)
            for _ in range(1000):self.assertEqual(e['Idle76_Item']('hero',1),'depths')
            self.assertEqual(reads,[6,7])
            gear[7]='tremors';e['Idle76_Capture'](0)
            self.assertEqual(e['Idle76_Item']('hero',1),'tremors')
            e['Player_GetHero']=lambda p:None;e['Idle76_Capture'](0)
            self.assertIsNone(e['Idle76_Item']('hero',1))

    def test_idle_mouse_does_not_scan_bag_or_quick_slots(self):
        s=self.fs['GearInput_Poll'];env=mocks(s);calls=[];held=set()
        env.update(BlzIsLocalClientActive=lambda:True,QuickGearChatOpen=False,InventoryCinematicActive=False,
            BagMoving64=False,BagLeft64=False,BagRight64=False,MOUSE_BUTTON_TYPE_LEFT=1,MOUSE_BUTTON_TYPE_RIGHT=2,
            BlzIsMouseButtonPressed=lambda b:b in held,BagScreen_Poll65=lambda:calls.append('scan'),
            GearInputTarget=False,GearCursorWasShown60=False,GearWaveMode=0)
        e=execute(s,['GearInput_Poll'],env)
        for _ in range(1000):e['GearInput_Poll']()
        self.assertEqual(calls,[])
        held.add(1);e['GearInput_Poll']();self.assertEqual(calls,['scan'])
        held.clear();e['BagLeft64']=True;e['GearInput_Poll']();self.assertEqual(calls,['scan','scan'])

    def test_hidden_legacy_button_does_not_gate_selected_native_inventory(self):
        s=self.fs['Preview75_QuickVisible'];env=mocks(s)
        env.update(Preview75_Selected=lambda:'gaya',GetUnitTypeId=lambda u:1,UnitInventorySize=lambda u:0,
            QuickGearChatOpen=False,InventoryCinematicActive=False,BlzIsLocalClientActive=lambda:True,
            BagConsole65='console',Preview75Button=None,BlzFrameIsVisible=lambda f:False)
        e=execute(s,['Preview75_QuickVisible'],env)
        self.assertTrue(e['Preview75_QuickVisible']())
        e['Preview75_Selected']=lambda:None;self.assertFalse(e['Preview75_QuickVisible']())

    def test_six_slot_hit_detection_uses_scaled_console_with_zero_legacy_button_size(self):
        # The legacy test interpreter uses // for every JASS slash. Preserve
        # real native-result arithmetic while retaining integer slot/2 behavior.
        class Real(float):
            def __add__(self,x):return Real(float(self)+x)
            __radd__=__add__
            def __sub__(self,x):return Real(float(self)-x)
            def __rsub__(self,x):return Real(x-float(self))
            def __mul__(self,x):return Real(float(self)*x)
            __rmul__=__mul__
            def __floordiv__(self,x):return Real(float(self)/x)
        s=self.fs['Preview75_QuickSlot'];env=mocks(s)
        env.update(BagConsole65='console',Preview75Button='hidden',
            BlzFrameGetHeight=lambda f:Real(.1625 if f=='console' else 0.),
            BlzFrameGetWidth=lambda f:Real(1. if f=='console' else 0.),
            BlzPixelToFrameX=lambda n:Real(n/1000.),BlzPixelToFrameY=lambda n:Real(1.-n/1000.),
            BlzGetLocalClientWidth=lambda:800,BlzGetLocalClientHeight=lambda:1000,
            I2R=float,ModuloInteger=lambda a,b:a%b)
        e=execute(s,['Preview75_QuickSlot'],env)
        for slot in range(6):
            x=-.1+(.4907+.04*(slot%2)+.015625)*1.25
            y=(.1179-.03815*(slot//2)-.015625)*1.25
            self.assertEqual(e['Preview75_QuickSlot'](x,y),200+slot)
        self.assertEqual(e['Preview75_QuickSlot'](.1,.5),-1)

    def test_receiver_native_activation_and_rune_damage_geometry_unchanged(self):
        before=functions(self.before)
        for n in ['QuickGear_Receive','QuickGear_Item','QuickGear_Mouse','Wave65_Draw','QuickGear_RecordSpell']:
            self.assertEqual(tokens(before[n]),tokens(self.fs[n]),n)
        for n in ['Idle76_Capture','Idle76_Item']:
            self.assertNotIn('GetLocalPlayer',self.fs[n])
            self.assertNotIn('Create',self.fs[n])
        for n in ['QuickGear_Draw','QuickGear_RefreshIcons','QuickGear_Request','QuickGear_SlotsChanged','BagScreen_Item67']:
            self.assertNotIn('QuickGear_Item(',self.fs[n])
        self.assertEqual(tokens(before['UI72_Tick']),tokens(self.fs['UI72_Tick']))

if __name__=='__main__':unittest.main()

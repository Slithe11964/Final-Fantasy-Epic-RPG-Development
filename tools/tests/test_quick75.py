"""Hero/Gaya six-slot previews preserve native clicks and existing geometry."""
import sys,math,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from quick75 import refresh
from test_armory_materia import execute
from test_shared_context import mocks
from test_backpack_sync import unsafe_paths
ROOT=Path(__file__).resolve().parents[2]

class Quick75Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.view=View(ROOT/'release/0.9.7.5f/FFERPG-0.9.7.5f.w3x')
        cls.before=cls.view.modules['TEquip'];cls.source=refresh(cls.before);cls.fs=functions(cls.source)

    def test_selected_caster_is_own_hero_or_gaya_only(self):
        source=self.fs['Preview75_Selected'];env=mocks(source);selected=set()
        env.update(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',
            udg_SpiritOfGaya={1:'gaya'},ForsakenSelectedTarget=None,IsUnitSelected=lambda u,p:u in selected)
        e=execute(source,['Preview75_Selected'],env)
        self.assertIsNone(e['Preview75_Selected']())
        selected.add('gaya');self.assertEqual(e['Preview75_Selected'](),'gaya')
        selected.add('hero');e['ForsakenSelectedTarget']='gaya'
        self.assertEqual(e['Preview75_Selected'](),'gaya')
        e['ForsakenSelectedTarget']='enemy';self.assertEqual(e['Preview75_Selected'](),'hero')

    def test_all_six_centers_and_gaps_match_native_grid(self):
        s=self.fs['Preview75_QuickSlot'];env=mocks(s)
        env.update(Preview75Button='button',BagConsole65='console',
            BlzFrameGetWidth=lambda f:.03125 if f=='button' else .8,
            BlzPixelToFrameX=lambda n:n/1000.,BlzPixelToFrameY=lambda n:1.-n/1000.,
            BlzGetLocalClientWidth=lambda:800,BlzGetLocalClientHeight=lambda:1000,
            I2R=float,ModuloInteger=lambda a,b:a%b)
        e=execute(s,['Preview75_QuickSlot'],env)
        for slot in range(6):
            x=.4907+.04*(slot%2)+.015625;y=.1179-.03815*(slot//2)-.015625
            self.assertEqual(e['Preview75_QuickSlot'](x,y),200+slot)
        self.assertEqual(e['Preview75_QuickSlot'](.525,.1),-1)
        self.assertEqual(e['Preview75_QuickSlot'](.2,.4),-1)

    def test_click_gaya_quick_item_arms_without_moving_or_casting(self):
        names=['Preview75_Source','BagScreen_Item67','BagScreen_Click66']
        s='\n'.join(self.fs[n] for n in names);env=mocks(s);armed=[]
        env.update(Preview75_Selected=lambda:'gaya',GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',
            BagHoverSlot64=202,UnitItemInSlot=lambda u,i:'water' if (u,i)==('gaya',2) else None,
            GetItemTypeId=lambda i:123 if i=='water' else 0,BagCast_Spell63=lambda raw:'A0Q2' if raw==123 else 0,
            GearWaveMode=0,QuickGearPending=-1,BagMoving64=False,BagMovedAt66=-100.,BagCarried66=None,BagSourceSlot66=-1,
            NativeCDClock='clock',TimerGetElapsed=lambda t:10.,Preview_LogClear68=lambda s:None,
            QuickGear_ClearPreview=lambda:None,GearWave_Arm=armed.append,
            Preview75Caster=None,GearInputArmedAt=0.,BagScreenArms65=0)
        e=execute(s,names,env);e['BagScreen_Click66'](False)
        self.assertEqual(armed,['A0Q2']);self.assertEqual(e['Preview75Caster'],'gaya')
        e['GearWaveMode']=0;e['BagScreen_Click66'](True)
        self.assertTrue(e['BagMoving64']);self.assertEqual(e['BagCarried66'],'water')
        e['BagScreen_Click66'](False);self.assertEqual(armed,['A0Q2'])

    def test_wave_origin_follows_gaya(self):
        names=['Wave65_Draw','Wave65_WaterWidth'];s='\n'.join(self.fs[n] for n in names)
        env=mocks(s);positions={}
        env.update(Preview75Caster='gaya',GetLocalPlayer=lambda:0,GetUnitTypeId=lambda u:1,
            IsUnitSelected=lambda u,p:u=='gaya',InventoryCinematicActive=False,QuickGearChatOpen=False,
            BlzIsLocalClientActive=lambda:True,BlzGetMouseFocusUnit=lambda:None,
            QuickGearMouseX=1800.,QuickGearMouseY=500.,GearWaveMode=1,GearWaveCast67='A0Q2',
            GetUnitX=lambda u:1000. if u=='gaya' else 0.,GetUnitY=lambda u:500. if u=='gaya' else 0.,
            Atan2=math.atan2,Cos=math.cos,Sin=math.sin,I2R=float,ModuloInteger=lambda a,b:a%b,
            bj_DEGTORAD=math.pi/180.,SetImagePosition=lambda image,x,y,z:positions.update({image:(x,y)}),
            ShowImage=lambda *a:None,WaterMiddle67={i:f'm{i}' for i in range(1,18)},
            GearWaveRune={i:f'r{i}' for i in range(1,65)},IceEdge67={i:f'e{i}' for i in range(1,65)},
            IceEdgeX67=defaultdict(float),IceEdgeY67=defaultdict(float),IceAreaRune65={i:f'a{i}' for i in range(1,64)})
        e=execute(s,names,env);e['Wave65_Draw']()
        self.assertEqual(positions['m1'],(952.,452.));self.assertEqual(positions['m17'],(1752.,452.))

    def test_gaya_cast_requests_deferred_cleanup_without_replacing_hero_diagnostics(self):
        s=self.fs['QuickGear_RecordSpell'];env=mocks(s)
        env.update(GetTriggerUnit=lambda:'gaya',GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,
            GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',udg_SpiritOfGaya={1:'gaya'},
            GetTriggerEventId=lambda:2,EVENT_PLAYER_UNIT_SPELL_EFFECT=2,GetSpellAbilityId=lambda:'A0Q2',
            QuickGearActualSpell={0:999},Preview75Caster='gaya',GearWaveMode=1,GearWaveCast67='A0Q2',
            UI73ClearRequested=False,UI73AimRevision=4,UI73ClearRevision=0)
        e=execute(s,['QuickGear_RecordSpell'],env);e['QuickGear_RecordSpell']()
        self.assertTrue(e['UI73ClearRequested']);self.assertEqual(e['QuickGearActualSpell'][0],999)

    def test_no_input_hooks_allocations_or_gameplay_cast_changes(self):
        a=functions(self.before)
        for n in ['QuickGear_Mouse','QuickGear_Receive','QuickGear_Input','UI72_Tick','QuickGear_PaintIcon',
            'QuickGear_Draw','Inventory71_Reconcile']:
            self.assertEqual(tokens(a[n]),tokens(self.fs[n]),n)
        self.assertEqual(unsafe_paths(self.fs,['Preview75_Selected','Preview75_Source','Preview75_QuickVisible',
            'Preview75_QuickSlot','BagScreen_Click66','Wave65_Draw','QuickGear_RecordSpell']),[])
        self.assertNotIn('BlzTriggerRegisterFrameEvent',self.fs['BagCast_Init63'])

    def test_hidden_hero_gear_dock_does_not_cancel_gaya_native_aim(self):
        s=self.fs['QuickGear_Poll'];env=mocks(s)
        env.update(GetLocalPlayer=lambda:0,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',
            NativeCDClock='clock',TimerGetElapsed=lambda t:10.,FFL_Phase={0:0},FFN_State={0:0},
            QuickGearRoot='dock',BlzFrameSetVisible=lambda *a:None,QuickGearShown=False,
            QuickGearReady=True,QuickGearHero='hero',QuickGearSeenRevision=1,QuickGearRevision={0:1},
            UI72_GearChanged=lambda *a:False,QuickGearActive={0:False,1:False},QuickGearRetryUntil=0.,
            NativeCDData='cd',LoadInteger=lambda *a:0,QuickGearSeenCooldownRevision=0,
            InventoryCinematicActive=False,IsUnitSelected=lambda u,p:u=='gaya',QuickGearPending=-1,
            BlzFrameIsVisible=lambda f:False,QuickGearButton={0:'f',1:'g'},
            QuickGearWheelPanel={0:None,1:None},QuickGearEnds={0:0.,1:0.},
            QuickGearLastSeconds={0:0,1:0},QuickGear_DrawWheel=lambda *a:None,R2I=int,RMaxBJ=max,
            GearWaveMode=1,Preview75Caster='gaya',
            QuickGear_ClearPreview=lambda:self.fail('Gaya aim cleared by hero dock'))
        e=execute(s,['QuickGear_Poll'],env)
        for _ in range(20):e['QuickGear_Poll']()
        self.assertEqual(e['GearWaveMode'],1)

if __name__=='__main__':unittest.main()

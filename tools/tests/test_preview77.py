"""Adjacent inventory slots, stale moves and Gaya-origin presentation."""
import sys,math,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from preview77 import refresh
from test_shared_context import mocks
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
ROOT=Path(__file__).resolve().parents[2]

class Real(float):
    # The shared JASS test interpreter maps / to //. Preserve real native
    # arithmetic while leaving integer row division unchanged.
    def __add__(self,x):return Real(float(self)+x)
    __radd__=__add__
    def __sub__(self,x):return Real(float(self)-x)
    def __rsub__(self,x):return Real(x-float(self))
    def __mul__(self,x):return Real(float(self)*x)
    __rmul__=__mul__
    def __floordiv__(self,x):return Real(float(self)/x)

class Preview77Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.before=View(ROOT/'release/development/QuickUI76/FFERPG-QuickUI76.w3x').modules['TEquip']
        cls.source=refresh(cls.before);cls.fs=functions(cls.source)

    def click_engine(self):
        names=['BagScreen_Click66','GearWave_ModeFor','GearWave_Arm'];s='\n'.join(self.fs[n] for n in names)
        items={202:'ice',203:'depths',200:'water'};raws={'ice':'I0DY','depths':'I05X','water':'I025','ice-repicked':'q104'}
        spells={'I0DY':'A0UY','I05X':'A08X','I025':'A0Q2','q104':'A0UY'};state={'caster':'hero'}
        env=mocks(s);clears=[]
        env.update(Preview75_Source=lambda slot:state['caster'],BagHoverSlot64=202,
            BagScreen_Item67=lambda hero,slot:items.get(slot),GetItemTypeId=lambda item:raws.get(item,0),
            BagCast_Spell63=lambda raw:spells.get(raw,0),GearWaveMode=1,QuickGearPending=-1,
            GearWaveCast67='A08X',BagMoving64=False,BagMovedAt66=20.,BagSourceSlot66=-1,
            NativeCDClock='clock',TimerGetElapsed=lambda t:20.,Preview_LogClear68=lambda *a:None,
            QuickGear_ClearPreview=lambda:clears.append('clear'),GearWave_Clear=lambda:None,
            Preview75_Selected=lambda:state['caster'],UI73AimRevision=0,UI72WaveNext=0.,
            Preview75Caster=None,GearInputArmedAt=0.,BagScreenArms65=0,
            Preview77Slot=-1,Preview77Raw=0,Preview77Spell=0)
        return execute(s,names,env),items,state,clears

    def test_new_ice_click_replaces_water_even_immediately_after_a_move(self):
        e,items,state,clears=self.click_engine()
        e['BagScreen_Click66'](False)
        self.assertEqual(e['GearWaveMode'],2);self.assertEqual(e['GearWaveCast67'],'A0UY')
        self.assertEqual(e['Preview77Slot'],202);self.assertEqual(e['Preview77Raw'],'I0DY')
        self.assertEqual(clears,['clear'])
        items[202]='ice-repicked';e['BagScreen_Click66'](False)
        self.assertEqual(e['Preview77Raw'],'q104');self.assertEqual(e['GearWaveMode'],2)
        e['BagHoverSlot64']=203;e['BagScreen_Click66'](False)
        self.assertEqual(e['GearWaveCast67'],'A08X');self.assertEqual(e['GearWaveMode'],1)
        e['BagHoverSlot64']=200;e['BagScreen_Click66'](False)
        self.assertEqual(e['GearWaveCast67'],'A0Q2');self.assertEqual(e['GearWaveMode'],1)

    def test_item_placement_remains_a_move_and_empty_slot_clears_stale_path(self):
        e,items,state,clears=self.click_engine();e['BagMoving64']=True
        e['BagScreen_Click66'](False);self.assertFalse(e['BagMoving64']);self.assertEqual(clears,[])
        e['BagHoverSlot64']=205;e['BagScreen_Click66'](False)
        self.assertEqual(e['Preview77Spell'],0);self.assertEqual(clears,['clear'])

    def test_adjacent_column_regression(self):
        env=mocks(self.fs['Preview75_QuickSlot'])
        env.update(BagConsole65='console',BlzFrameGetHeight=lambda f:Real(.13),
            BlzFrameGetWidth=lambda f:Real(.8),BlzPixelToFrameX=lambda n:Real(n/1000.),
            BlzPixelToFrameY=lambda n:Real(1.-n/1000.),BlzGetLocalClientWidth=lambda:800,
            BlzGetLocalClientHeight=lambda:1000,I2R=float,ModuloInteger=lambda a,b:a%b)
        b=execute(functions(self.before)['Preview75_QuickSlot'],['Preview75_QuickSlot'],env)
        a=execute(self.fs['Preview75_QuickSlot'],['Preview75_QuickSlot'],env)
        # Native middle-left was interpreted as middle-right; native
        # middle-right fell outside both boxes. Both now address their items.
        self.assertEqual(b['Preview75_QuickSlot'](.5318,.064125),203)
        self.assertEqual(b['Preview75_QuickSlot'](.5718,.064125),-1)
        self.assertEqual(a['Preview75_QuickSlot'](.5318,.064125),202)
        self.assertEqual(a['Preview75_QuickSlot'](.5718,.064125),203)

    def test_gaya_selection_keeps_preview_but_geometry_starts_at_hero(self):
        s=self.fs['Wave65_Draw'];env=mocks(s);positions={}
        env.update(GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',Preview75Caster='gaya',
            GetUnitTypeId=lambda u:1,IsUnitSelected=lambda u,p:u=='gaya',
            GearWaveMode=1,GearWaveCast67='A0Q2',InventoryCinematicActive=False,QuickGearChatOpen=False,
            BlzIsLocalClientActive=lambda:True,BlzGetMouseFocusUnit=lambda:None,
            QuickGearMouseX=1800.,QuickGearMouseY=500.,
            GetUnitX=lambda u:1000. if u=='hero' else 5000.,GetUnitY=lambda u:500.,
            Atan2=math.atan2,Cos=math.cos,Sin=math.sin,I2R=float,ModuloInteger=lambda a,b:a%b,
            Wave65_WaterWidth=lambda d:100.+d*.25,GearWaveRune={i:'r'+str(i) for i in range(1,65)},
            WaterMiddle67={i:'w'+str(i) for i in range(1,18)},IceEdge67={i:'e'+str(i) for i in range(1,65)},
            IceAreaRune65={i:'a'+str(i) for i in range(1,64)},
            SetImagePosition=lambda image,x,y,z:positions.update({image:(x,y)}),ShowImage=lambda *a:None)
        e=execute(s,['Wave65_Draw'],env);e['Wave65_Draw']()
        self.assertEqual(positions['w1'],(952.,452.));self.assertEqual(positions['w17'],(1752.,452.))

    def test_idle_cache_cast_receiver_and_input_paths_unchanged(self):
        old=functions(self.before)
        changed={n for n in old if tokens(old[n])!=tokens(self.fs[n])}
        self.assertEqual(changed,{'Preview75_QuickSlot','BagScreen_Click66','Wave65_Draw','QuickGear_Diagnostic'})
        self.assertEqual(unsafe_paths(self.fs,['BagScreen_Click66','Wave65_Draw','Preview75_QuickSlot']),[])

if __name__=='__main__':unittest.main()

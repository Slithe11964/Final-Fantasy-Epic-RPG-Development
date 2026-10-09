"""Contained house ownership and cleanup retry using actual JASS."""
import unittest
import test_save_inventory_profile as p
from test_save_jass import engine, SOURCE
from test_save_life import Real32
from test_save_position import SPACER

HOUSE=SOURCE.with_name('Forsaken-save-house.j')

class HouseTests(unittest.TestCase):
    def setUp(self):
        p.InventoryProfileTests.setUp(self);old=self.e;env=self.w.natives()
        env['HaveSavedInteger']=old['HaveSavedInteger'];original_type=env['IsUnitType']
        env['BlzItemRemoveAbility']=old['BlzItemRemoveAbility']
        env['CreateItem']=old['CreateItem']
        env['IsUnitType']=lambda u,t:False if u.get('raw')==1 else original_type(u,t)
        def create(owner,raw,x,y,facing):
            if raw!=1:return self.w.create_unit(owner,raw,x,y,facing)
            if not self.w.permit_unit('create'):return None
            if self.w.forced is not None:return self.w.forced
            u=self.w.unit(owner)
            u.update(life=Real32(100),body_life=Real32(100),hidden=False,paused=False,invulnerable=False,
                     inventory_size=6,x=x,y=y,facing=facing,is_hero=False)
            self.w.created.append(u);return u
        env.update(GetRectMinX=lambda r:-1000.,GetRectMinY=lambda r:-1000.,
                   GetRectMaxX=lambda r:1000.,GetRectMaxY=lambda r:1000.)
        env['CreateUnit']=create
        env.update(ShowUnit=lambda u,v:self.w.unit_flag('hidden',u,not v),
                   PauseUnit=lambda u,v:self.w.unit_flag('paused',u,v),
                   SetUnitInvulnerable=lambda u,v:self.w.unit_flag('invulnerable',u,v))
        sources='\n'.join(SOURCE.with_name('Forsaken-save-'+m+'.j').read_text() for m in p.MODULES)
        self.e=engine(p.DECLARATIONS+p.EXTRA+p.SESSION_GLOBALS+p.SKILL_GLOBALS+p.GLOBALS+
            'globals\n unit array udg_PlayerHouse\n integer bj_mapInitialPlayableArea=0\nendglobals\n'+sources+
            p.REFERENCES.read_text()+p.BODY.read_text()+p.OWNERSHIP.read_text()+p.PREPARED.read_text()+
            p.ACTIVATION.read_text()+p.CARGO.read_text()+p.PROFILE.read_text()+HOUSE.read_text(),env)
        self.e.update({k:v for k,v in old.items() if not callable(v)})

    def core(self,stage=0,pid=0,level=11):return p.InventoryProfileTests.core(self,stage,pid,level)
    def ready(self,pid=0):
        p.InventoryProfileTests.ready(self,pid);self.e['udg_PlayerHouse'][pid+1]=self.house
    def clean(self,pid=0):
        self.assertTrue(self.e['FHS_Recover'](pid));self.assertTrue(self.e['FHS_Release'](pid))
    def stage(self,pid=0):return self.e['FHS_Stage'](pid,100.,200.)

    def test_actual_map_bounds_refuse_before_allocation(self):
        self.ready()
        for x,y in ((900.,200.),(100.,-1128.),(float('nan'),200.)):
            self.assertFalse(self.e['FHS_Stage'](0,x,y))
            self.assertIsNone(self.e['FHS_Unit'][0]);self.assertFalse(self.e['FSJ_HousePending'][0])
            self.assertEqual(self.e['FHS_State'][0],0)
        self.assertTrue(self.stage());self.clean()

    def test_contained_house_player7_originals_untouched(self):
        self.ready(7);original=dict(self.house);code=self.e['FSC_Code'][7]
        self.assertTrue(self.stage(7));u=self.e['FHS_Unit'][7]
        self.assertEqual((u['raw'],u['owner'],u['hidden'],u['paused'],u['invulnerable']),(1,15,True,True,True))
        self.assertTrue(self.e['FHS_Verify'](7));self.assertTrue(self.e['FSU_Tracked'](u))
        self.assertEqual(dict(self.house),original);self.assertEqual(self.e['FSC_Code'][7],code)
        self.clean(7);self.assertEqual(u['raw'],0);self.assertIs(self.e['udg_PlayerHouse'][8],self.house)

    def test_occupied_original_house_preserved(self):
        self.ready();item=self.w.create(SPACER,0,0);self.house['quick'][5]=item;item['owned']=True
        self.e['FSJ_Item'][56]=item
        for field,native in [('Raw','GetItemTypeId'),('Charges','GetItemCharges'),('Binding','GetItemUserData'),
                             ('Owner','GetItemPlayer'),('Visible','IsItemVisible'),('Flags','FSJ_ReadFlags')]:
            self.e['FSJ_'+field][56]=self.e[native](item)
        self.assertTrue(self.e['FSL_Pack'](0,self.e['GetWidgetLife'](item)))
        self.e['FSJ_High'][56]=self.e['FSL_High'][0];self.e['FSJ_Low'][56]=self.e['FSL_Low'][0]
        self.assertTrue(self.e['FSJ_Verify'](0));self.assertTrue(self.stage());self.clean()
        self.assertIs(self.house['quick'][5],item);self.assertTrue(self.e['FSJ_Verify'](0))

    def test_creation_and_flag_failure_retain_guard(self):
        for offset in range(4):
            self.setUp();self.ready();self.w.reject_native=self.w.unit_native_count+1+offset
            self.assertFalse(self.stage());self.assertEqual(self.e['FHS_State'][0],2)
            self.assertTrue(self.e['FSJ_HousePending'][0]);self.w.reject_native=0;self.clean()

    def test_original_or_owned_handle_never_deleted(self):
        for other in ('original','hero','other_house'):
            self.setUp();self.ready()
            if other=='original':u=self.house
            elif other=='hero':u=self.e['FSU_Unit'][0]
            else:u=self.w.unit(15);self.e['FHS_Unit'][1]=u
            self.w.forced=u;self.assertFalse(self.stage());self.assertIsNone(self.e['FHS_Unit'][0])
            self.clean();self.assertNotEqual(u['raw'],0)

    def test_deletion_failure_retries(self):
        self.ready();self.assertTrue(self.stage());u=self.e['FHS_Unit'][0]
        self.w.refuse_units.add(id(u));self.assertFalse(self.e['FHS_Recover'](0))
        self.assertIs(self.e['FHS_Unit'][0],u);self.assertFalse(self.e['FHS_Release'](0))
        self.w.refuse_units.clear();self.clean()

    def test_cargo_or_publication_blocks_deletion(self):
        self.ready();self.assertTrue(self.stage());u=self.e['FHS_Unit'][0]
        item=self.w.create(SPACER,0,0);u['quick'][0]=item
        self.assertFalse(self.e['FHS_Recover'](0));self.assertNotEqual(u['raw'],0)
        u['quick'][0]=None;self.e['udg_PlayerHouse'][2]=u
        self.assertFalse(self.e['FHS_Recover'](0));self.e['udg_PlayerHouse'][2]=None
        u.update(owner=4,hidden=False,paused=False,invulnerable=False)
        self.assertFalse(self.e['FHS_Verify'](0));self.clean()

    def test_callback_reentry_and_dependent_disposal_refuse(self):
        self.ready();attempts=[]
        self.w.unit_hook=lambda *args:attempts.append((self.stage(),self.e['FHS_Recover'](0),self.e['FHS_Release'](0)))
        self.assertTrue(self.stage());self.w.unit_hook=None
        self.assertTrue(attempts);self.assertTrue(all(v==(False,False,False) for v in attempts))
        self.assertFalse(self.e['FHA_Begin'](0,0.,0.,0.,0.,0.,0.))
        for name in ('FHP_Discard','FSU_Abort','FSJ_Release'):
            self.assertFalse(self.e[name](0),name)
        self.assertTrue(self.e['FCG_Begin'](0));self.assertFalse(self.e['FHS_Recover'](0));self.assertFalse(self.stage())
        self.assertTrue(self.e['FCG_Recover'](0));self.assertTrue(self.e['FCG_Release'](0));self.clean()

    def test_invalid_preflight_never_allocates(self):
        self.ready();before=len(self.w.created)
        for pid,x,y in ((-1,0.,0.),(8,0.,0.),(0,float('nan'),0.),(0,0.,40000.)):
            self.assertFalse(self.e['FHS_Stage'](pid,x,y))
        self.e['udg_PlayerHouse'][1]=None;self.assertFalse(self.stage())
        self.assertEqual(len(self.w.created),before);self.assertFalse(self.e['FSJ_HousePending'][0])

    def test_original_drift_during_creation_retains_owned_cleanup(self):
        self.ready();owner=self.house['owner']
        self.w.unit_hook=lambda *args:self.house.update(owner=owner+1)
        self.assertFalse(self.stage());self.w.unit_hook=None
        self.assertEqual(self.e['FHS_State'][0],2)
        self.assertIsNotNone(self.e['FHS_Unit'][0])
        self.assertFalse(self.e['FSJ_Verify'](0));self.clean()
        self.assertEqual(self.house['owner'],owner+1)
        self.house['owner']=owner;self.assertTrue(self.e['FSJ_Verify'](0))

    def test_duplicate_journal_provenance_blocks_verify_and_cleanup(self):
        self.ready();self.assertTrue(self.stage());u=self.e['FHS_Unit'][0]
        self.e['FHS_Unit'][1]=u
        self.assertFalse(self.e['FHS_Verify'](0));self.assertFalse(self.e['FHS_Recover'](0))
        self.assertNotEqual(u['raw'],0);self.e['FHS_Unit'][1]=None;self.clean()

    def test_prepared_context_drift_during_creation_refuses(self):
        self.ready();hero=self.e['FSU_Unit'][0]
        self.w.unit_hook=lambda *args:hero.update(hidden=False)
        self.assertFalse(self.stage());self.w.unit_hook=None
        self.assertEqual(self.e['FHS_State'][0],2);self.clean()
        hero['hidden']=True;self.assertTrue(self.e['FHP_Verify'](0))

if __name__=='__main__':unittest.main()

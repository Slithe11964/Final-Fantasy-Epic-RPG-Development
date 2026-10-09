"""Live diagnostic source tests; these supplement the private map's build gates."""
import unittest
from test_save_jass import engine, SOURCE
from test_save_life import LIFE, Real32
from test_save_position import InventoryWorld, Handle
import save_vnext as codec
from build_save_probe import probe_source

PROBE=SOURCE.with_name('Forsaken-save-probe.j')
DECL='''
globals
    unit array udg_PlayerHero
    unit array udg_SpiritOfGaya
    unit array udg_PlayerHouse
endglobals
'''


class ProbeTests(unittest.TestCase):
    def setUp(self):
        self.w=InventoryWorld()
        self.messages=[]; self.timers=[]; self.current=None; self.deleted=[]
        def timer():
            t=Handle(); self.timers.append(t); return t
        env=self.w.natives()
        env.update(I2S=str,GetHandleId=id,CreateTimer=timer,
            GetExpiredTimer=lambda:self.current,PauseTimer=lambda t:None,
            DestroyTimer=lambda t:self.deleted.append(t),
            TimerStart=lambda t,d,r,c:t.update(callback=c),
            SaveInteger=lambda h,p,k,v:h.__setitem__((p,k),v),
            RemoveSavedInteger=lambda h,p,k:h.pop((p,k),None),
            DisplayTimedTextToPlayer=lambda p,x,y,d,s:self.messages.append(s),
            CreateTrigger=lambda:Handle(),TriggerRegisterPlayerChatEvent=lambda *a:None,
            TriggerAddAction=lambda *a:None)
        self.e=engine(DECL+LIFE.read_text()+probe_source({'i001':1,'f001':1}),env)
        self.hero=self.w.unit(bag=30); self.gaya=self.w.unit(); self.house=self.w.unit(9)
        self.e['udg_PlayerHero'][1]=self.hero; self.e['udg_SpiritOfGaya'][1]=self.gaya
        self.e['udg_PlayerHouse'][1]=self.house
        self.e['InitTrig_ForsakenSaveProbe']()

    def item(self,kind='quick',slot=0,quantity=120,holder=None):
        u=holder or self.hero
        item=self.w.create('f001',0.,0.)
        item.update(charges=quantity,binding=0,owner=0,owned=True,life=Real32(145.25))
        u[kind][slot]=item
        return item

    def run_probe(self,compare=False):
        self.e['FSX_Start'](0,compare)
        if self.e['FSX_Phase'][0]!=1: return
        self.current=self.e['FSX_Timer'][0]
        for step in range(120):
            if self.e['FSX_Phase'][0]!=0: self.e['FSX_Tick']()

    def test_all57_positions_quantities_metadata_and_original_identity(self):
        live=[]
        for kind,size,u in [('quick',6,self.hero),('bag',30,self.hero),('equip',9,self.hero),('quick',6,self.gaya),('quick',6,self.house)]:
            for slot in range(size): live.append(self.item(kind,slot,slot%128,u))
        before=[dict(i) for i in live]
        self.run_probe()
        self.assertIn('PASS: 57 items',self.messages[-1])
        result=codec.decode(self.e['FSC_Code'][0],0)
        records=codec.read_inventory(result.sections[0].payload)[0]
        self.assertEqual(len(records),57)
        self.assertEqual(records[40][2:4],(3,4)); self.assertEqual(records[41][2:4],(3,5))
        self.assertEqual([dict(i) for i in live],before)
        self.assertTrue(all(self.e['FSX_Handle'][i] is None for i in range(57)))
        self.assertEqual(len(self.deleted),2)

    def test_sparse_gaps_and_zero127_preserved(self):
        self.item('bag',29,127); self.item('equip',5,0)
        self.run_probe()
        self.assertIn('PASS: 2 items',self.messages[-1])
        records=codec.read_inventory(codec.decode(self.e['FSC_Code'][0]).sections[0].payload)[0]
        self.assertEqual([(r[2],r[3],r[4]) for r in records],[(2,29,127),(3,5,0)])

    def test_verify_unchanged_and_changed_without_overwriting_last(self):
        item=self.item(); self.run_probe(); prior=self.e['FSX_Last'][0]
        self.run_probe(True); self.assertIn('PASS:',self.messages[-1])
        item['charges']=3; self.run_probe(True)
        self.assertIn('CHANGED:',self.messages[-1]); self.assertEqual(self.e['FSX_Last'][0],prior)

    def test_unknown_foreign_and_unrepresentable_items_refuse_without_omission(self):
        for key,value in [('raw','BAD!'),('binding',3),('charges',128),('life',0.)]:
            self.setUp(); item=self.item(); item[key]=value; before=dict(item)
            self.run_probe(); self.assertIn('FAIL:',self.messages[-1])
            self.assertIsNone(self.e['FSX_Last'][0]); self.assertEqual(dict(item),before)

    def test_inflight_change_is_detected(self):
        item=self.item(); self.e['FSX_Start'](0,False); self.current=self.e['FSX_Timer'][0]
        for step in range(58): self.e['FSX_Tick']()
        item['charges']=3
        self.e['FSX_Tick']()
        self.assertIn('FAIL: inventory changed',self.messages[-1])

    def test_reference_change_is_detected(self):
        self.e['FSX_Start'](0,False); self.current=self.e['FSX_Timer'][0]
        self.e['udg_PlayerHero'][1]=self.w.unit(bag=30)
        self.e['FSX_Tick'](); self.assertIn('FAIL: hero/storage reference changed',self.messages[-1])

    def test_timeout_blocks_retry_without_loading(self):
        self.e['FSX_Start'](0,False); self.current=self.e['FSX_Watchdog'][0]
        self.e['FSX_Timeout'](); self.assertEqual(self.e['FSX_Phase'][0],-1)
        self.e['FSX_Start'](0,False); self.assertIn('timed out',self.messages[-1])
        self.assertIsNone(self.e['FSX_Last'][0])

    def test_verified_temporary_item_cleanup_and_broken_getter(self):
        self.e['BlzGetItemBooleanField']=lambda *args:False
        self.run_probe(); self.assertIn('droppability getter',self.messages[-1])
        self.assertEqual(self.w.items[-1]['raw'],0)

    def test_missing_initial_capture_and_hero_refuse(self):
        self.run_probe(True); self.assertIn('run -savecheck first',self.messages[-1])
        self.e['udg_PlayerHero'][1]=None
        self.run_probe(); self.assertIn('select a hero',self.messages[-1])

    def test_probe_source_never_calls_character_or_file_mutations(self):
        text=PROBE.read_text()
        for phrase in ('SetItemUserData(','SetItemCharges(','SetWidgetLife(','UnitAddItem(','CreateUnit(','Save_WriteCode(','Preload','SetHeroXP(','HasLoadedCode['):
            self.assertNotIn(phrase,text)
        self.assertNotIn(b'\n',PROBE.read_bytes().replace(b'\r\n',b''))


if __name__=='__main__': unittest.main()

"""Scratch codec projection parity and clearing; no allocation or live state."""
import unittest
from test_save_jass import engine
from test_save_inventory_plan import record, envelope
import save_vnext as codec


class ProjectionTests(unittest.TestCase):
    def setUp(self):self.e=engine()

    def parse(self,source,ctx=32):
        self.e['FSC_Seen']={};self.e['FSC_Clear'](ctx);self.e['FSC_ClearSeen'](ctx)
        self.assertTrue(self.e['FSC_Parse'](ctx,codec.encode(source),42,True))

    def test_all57_exact_fields_and_eight_scratch_context_bounds(self):
        rows=[]
        for h,n in codec.HOLDERS.items():
            for s in range(n):rows.append(record(7,h,s,len(rows)+1,(None,0,120,127)[len(rows)%4],bool(len(rows)%2)))
        for ctx in range(25,33):
            self.parse(envelope(rows),ctx)
            self.assertEqual(self.e['FSC_ItemCount'][ctx],57)
            for i,r in enumerate(rows):
                key=ctx*57+i
                actual=tuple(self.e['FSC_Item'+n][key] for n in ('Ordinal','Id','Holder','Slot','Quantity','Bound','High','Low','Flags','Dormant','Complete'))
                self.assertEqual(actual, r[:4]+(-1 if r[4] is None else r[4],r[5],0x4311,0x4000,5,False,True))

    def test_unknown_optional_metadata_is_record_local_and_payload_unchanged(self):
        r=record(7);optional=r[:6]+(r[6]+((100,False,'ABC'),),)
        source=envelope([optional,record(7,slot=29,ordinal=2)])
        code=codec.encode(source);self.parse(source)
        self.assertTrue(self.e['FSC_ItemDormant'][32*57]);self.assertFalse(self.e['FSC_ItemDormant'][32*57+1])
        self.assertEqual(self.e['FSC_EncodeContext'](32),code)

    def test_clear_erases_projected_records_and_cheat_state(self):
        self.parse(envelope([record(7)]));self.e['FSC_Cheater'][32]=True
        self.e['FSC_Clear'](32)
        self.assertEqual(self.e['FSC_ItemCount'][32],0);self.assertFalse(self.e['FSC_Cheater'][32])
        for n in ('Ordinal','Id','Holder','Slot','Quantity','High','Low','Flags'):
            self.assertEqual(self.e['FSC_Item'+n][32*57],0)
        for n in ('Bound','Dormant','Complete'):self.assertFalse(self.e['FSC_Item'+n][32*57])


if __name__=='__main__':unittest.main()

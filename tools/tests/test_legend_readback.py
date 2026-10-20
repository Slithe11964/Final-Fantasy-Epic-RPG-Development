"""Real bounded codec verification: old profiles, optional milestones and tampering."""
from pathlib import Path
import sys,unittest
ROOT=Path(__file__).resolve().parents[2]
sys.path[:0]=[str(ROOT/'tools'),str(ROOT/'experiments/Forsaken')]
import save_vnext as c
from save_progression import jobs2
from test_save_jass import engine


def sections(tier=2):
    return [c.Section(1,1,True,c.inventory([])),
        c.Section(2,2,True,jobs2([(i,99 if i==1 else 0,tier if i==1 else 0) for i in range(1,23)])),
        c.Section(4,2,True,c.pairs(list({1:3,2:100,3:0,4:0,5:0,6:0,7:1,8:0,9:0,10:1,11:0,12:0,13:1,14:0,15:0}.items()))),
        c.Section(5,1,True,c.pairs([(i,1 if i==2 else 0) for i in range(1,9)])),
        c.Section(6,1,True,c.pairs([(i,0) for i in range(1,16)])),
        c.Section(7,1,True,c.pairs([])),c.Section(8,1,True,c.pairs([]))]


class LegendReadbackTests(unittest.TestCase):
    def runtime(self,flags=(),tier=2,speedrun=False):
        values={(11,i):1 for i in flags};values[10,1]=tier
        helper=(ROOT/'experiments/Forsaken/LegendReadback.j').read_text()
        extra='\nglobals\n    string array FRC_Error\nendglobals\n'+helper
        e=engine(extra,dict(udg_SpeedrunMode=speedrun,FRC_Account=lambda p:42,FFL_Val=lambda p,s,i:values.get((s,i),0)),bounded=True)
        e['FSC_Seen']={}
        return e

    def code(self,ss,flags=None):
        if flags is not None:ss=ss+[c.Section(11,1,False,c.pairs([(i,1) for i in flags]))]
        return c.encode(c.Envelope(42,tuple(ss)))

    def test_old_profile_accepts_only_new_optional_defaults(self):
        for tier,flags in [(2,[]),(3,[1])]:
            e=self.runtime(tier=tier);old=self.code(sections(tier));new=self.code(sections(tier),flags)
            self.assertNotEqual(old,new)
            self.assertTrue(e['FFL_ReadbackMatches'](0,new,old))
            for ctx in (9,25):self.assertEqual(e['FSC_Count'][ctx],0)

    def test_optional_progress_requires_exact_set_and_handles_order(self):
        flags=[3,24,38,39,61];e=self.runtime(flags)
        old=self.code(sections(),flags)
        self.assertTrue(e['FFL_ReadbackMatches'](0,self.code(sections(),flags[::-1]),old))
        for wrong in [flags[:-1],flags+[40],[3,24,38,39,60]]:
            self.assertFalse(e['FFL_ReadbackMatches'](0,self.code(sections(),wrong),old))

    def test_original_payloads_cannot_change_during_readback(self):
        e=self.runtime();ss=sections();old=self.code(ss)
        # Each mutation is independently valid, but must fail strict readback.
        replacements={1:c.inventory([(1,1,1,0,1,False,())]),
            2:jobs2([(i,98 if i==1 else 0,1 if i==1 else 0) for i in range(1,23)]),
            4:c.pairs([(i,v+1 if i==2 else v) for i,v in c.read_pairs(ss[2].payload)]),
            5:c.pairs([(i,2 if i==2 else v) for i,v in c.read_pairs(ss[3].payload)]),
            6:c.pairs([(i,1 if i==1 else v) for i,v in c.read_pairs(ss[4].payload)]),
            7:c.pairs([(1,1)]),8:c.pairs([(1,1)])}
        for sid,payload in replacements.items():
            changed=[c.Section(s.id,s.version,s.required,payload if s.id==sid else s.payload) for s in ss]
            with self.subTest(section=sid):
                self.assertFalse(e['FFL_ReadbackMatches'](0,self.code(changed,[]),old))

    def test_speedrun_tag_is_informational_in_both_directions_and_old_profiles(self):
        def tag(ss,value):
            return [c.Section(s.id,s.version,s.required,c.pairs([(i,value if i==15 else v) for i,v in c.read_pairs(s.payload)]) if s.id==4 else s.payload) for s in ss]
        for saved,current in [(0,1),(1,0),(0,0),(1,1)]:
            for previous_flags in [None,[]]:
                e=self.runtime();old=self.code(tag(sections(),saved),previous_flags)
                actual=self.code(tag(sections(),current),[])
                self.assertTrue(e['FFL_ReadbackMatches'](0,actual,old),(saved,current,previous_flags))
                for ctx in (9,25):self.assertEqual(e['FSC_Count'][ctx],0)

    def test_speedrun_exception_does_not_ignore_any_other_core_field(self):
        ss=sections();e=self.runtime();old=self.code(ss)
        for changed in range(1,15):
            pairs=[(i,(1 if v==0 else 0) if i==changed else 1 if i==15 else v) for i,v in c.read_pairs(ss[2].payload)]
            actual=[c.Section(s.id,s.version,s.required,c.pairs(pairs) if s.id==4 else s.payload) for s in ss]
            self.assertFalse(e['FFL_ReadbackMatches'](0,self.code(actual,[]),old),changed)

    def test_invalid_mode_and_extra_core_records_remain_rejected(self):
        ss=sections();old=self.code(ss);e=self.runtime()
        for pairs in [[(i,2 if i==15 else v) for i,v in c.read_pairs(ss[2].payload)],c.read_pairs(ss[2].payload)+[(16,1)]]:
            self.assertFalse(e['FFL_CoreReadback'](9,25,ss[2].payload,c.pairs(pairs)))

    def test_speedrun_omits_all_greens_and_nuts_but_requires_every_other_item(self):
        def items(ss,records):return [c.Section(s.id,s.version,s.required,c.inventory(records) if s.id==1 else s.payload) for s in ss]
        # Include quick slots, backpack, Gaya and house; retain a normal item.
        metadata=((1,True,c.life_words(145.25)),(2,True,c.uint(0)))
        excluded=[(i+1,identity,1 if i<6 else 5,i if i<6 else 0,1,False,metadata) for i,identity in enumerate(range(352,359))]
        kept=(8,1,2,1,3,False,metadata)
        old=self.code(items(sections(),excluded+[kept]))
        actual=self.code(items(sections(),[(1,*kept[1:])]),[])
        self.assertTrue(self.runtime(speedrun=True)['FFL_ReadbackMatches'](0,actual,old))
        self.assertFalse(self.runtime()['FFL_ReadbackMatches'](0,actual,old))
        self.assertFalse(self.runtime(speedrun=True)['FFL_ReadbackMatches'](0,self.code(items(sections(),[]),[]),old))
        self.assertFalse(self.runtime(speedrun=True)['FFL_ReadbackMatches'](0,self.code(items(sections(),excluded+[kept]),[]),old))

if __name__=='__main__':unittest.main()

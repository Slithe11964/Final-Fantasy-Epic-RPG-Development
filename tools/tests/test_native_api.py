"""3.0.1 native aliases must migrate safely without leaking into classic."""
from pathlib import Path
import re,sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from native_api import migrate,RENAMES,future_header


class NativeAPITests(unittest.TestCase):
    def test_only_whole_code_identifiers_change(self):
        source='call UnitEquipItem(u,i) // UnitEquipItem\nset s="UnitEquipItem"\ncall UnitEquipItemSwapped(i,u)\n/* UnitEquipItem */'
        result,counts=migrate(source)
        self.assertEqual(result,source.replace('call UnitEquipItem(','call BlzUnitEquipItem('))
        self.assertEqual(counts,{'UnitEquipItem':1})
        self.assertEqual(migrate(result),(result,{}))

    def test_each_new_signature_matches_retired_signature(self):
        header=(Path(__file__).resolve().parents[1]/'bin/common.j').read_text()
        declarations=dict(re.findall(r'\bnative\s+(\w+)\s+(takes[^\r\n]+)',header))
        for old,new in RENAMES.items():
            self.assertIn(new,declarations)
            self.assertEqual(declarations[old],declarations[new],old)

    def test_all_retiring_names_and_corrected_spelling(self):
        result,counts=migrate('\n'.join('call '+name+'()' for name in RENAMES))
        self.assertEqual(len(counts),19)
        self.assertIn('BlzUnitHasAnyItemEquipped()',result)
        self.assertEqual(migrate(result)[1],{})

    def test_future_header_keeps_classic_natives_and_new_names(self):
        source=(Path(__file__).resolve().parents[1]/'bin/common.j').read_text()
        result=future_header(source)
        declarations=set(re.findall(r'\bnative\s+(\w+)\s+takes\b',result))
        self.assertTrue({'PauseUnit','UnitAddItem','UnitInventorySize'}<=declarations)
        self.assertFalse(set(RENAMES)&declarations)
        self.assertTrue(set(RENAMES.values())<=declarations)


if __name__=='__main__':unittest.main()

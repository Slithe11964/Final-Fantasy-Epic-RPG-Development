from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from talent_selection_ui import refresh
from jtok import functions
from test_armory_materia import execute
ROOT=Path(__file__).resolve().parents[2]
class TalentSelectionUITests(unittest.TestCase):
    def test_border_follows_actual_choice_and_job_instead_of_available_rank(self):
        source='library TEquip\nglobals\nendglobals\n'+(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text()+'\nfunction Forsaken_DrawPanels takes unit hero returns nothing\nendfunction\nendlibrary'
        updated=refresh(source,native=True);visible={};picks={('priest',1):2,('priest',3):3,('knight',1):1}
        e=execute(updated,['Forsaken_UpdateTalentBorder'],dict(ForsakenTalentChosenBorder={n:n for n in range(12)},
            Talent_Has=lambda h,r,c:picks.get((h,r))==c,ModuloInteger=lambda a,b:a%b,
            BlzFrameSetVisible=lambda f,v:visible.__setitem__(f,v)))
        for node in range(12):e['Forsaken_UpdateTalentBorder']('priest',node)
        self.assertEqual([n for n,v in visible.items() if v],[1,8])
        for node in range(12):e['Forsaken_UpdateTalentBorder']('knight',node)
        self.assertEqual([n for n,v in visible.items() if v],[0])
        self.assertEqual(refresh(updated,native=True),updated)
        self.assertEqual(refresh(source,native=False),source)
if __name__=='__main__':unittest.main()

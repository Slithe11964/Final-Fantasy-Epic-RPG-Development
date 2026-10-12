"""Execute the unmastered purchase path and check narrow checkpoint overlays."""
import unittest
import re
from pathlib import Path
from test_save_jass import engine
from map_presentation import job_policy, shrine_policy

ROOT=Path(__file__).resolve().parents[2]

class ShrinePolicyTests(unittest.TestCase):
    def test_unmastered_freelancer_purchase_removes_token_without_switch_or_message(self):
        source=(ROOT/'src/triggers/03 Jobs and progression/Job.j').read_text()
        source='\n'.join(re.search(r'function '+name+r' .*?endfunction',source,re.S)[0] for name in ('Trig_Job_Change_IsFreelancerId','Trig_Job_Change_IsFreelancerPick','Trig_Job_Change_Actions'))
        source=source[:source.index('    if(Trig_Job_Change_IsSameJob())then')]+'    call Player_GetHero(udg_TempPlayer)\nendfunction'
        source='\nglobals\n    integer udg_SelectedJobId=0\n    player udg_TempPlayer=null\nendglobals\n'+source
        sold={'raw':'H02L','owner':0};removed=[]
        e=engine(source,dict(GetSoldUnit=lambda:sold,GetUnitTypeId=lambda u:u['raw'],
            GetOwningPlayer=lambda u:u['owner'],RemoveUnit=removed.append,
            IsPlayerInForce=lambda p,f:False,udg_TitleForce={10:set()},
            Player_GetHero=lambda p:self.fail('must not attempt job switch'),
            DisplayTextToForce=lambda *args:self.fail('must remain silent')))
        e['Trig_Job_Change_Actions']()
        self.assertEqual(removed,[sold])

    def test_policy_changes_only_town_visibility_and_silent_mastery_gate(self):
        source=(ROOT/'src/triggers/03 Jobs and progression/Shrine.j').read_text()
        old=source.replace('    call ShowUnitShow(gg_unit_n04U_0204)',
                           '    call ShowUnitHide(gg_unit_n04U_0204)',1)
        self.assertEqual(shrine_policy(old),source)
        self.assertEqual(shrine_policy(source),source)
        job=(ROOT/'src/triggers/03 Jobs and progression/Job.j').read_text()
        guard='    if Trig_Job_Change_IsFreelancerPick() and not IsPlayerInForce(udg_TempPlayer,udg_TitleForce[10]) then\n        return\n    endif\n'
        self.assertEqual(job_policy(job.replace(guard,'')),job)
        self.assertEqual(job_policy(job),job)

if __name__=='__main__':unittest.main()

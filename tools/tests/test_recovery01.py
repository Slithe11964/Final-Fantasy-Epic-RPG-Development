import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from mpq import MPQ
from jtok import functions,tokens
from test_h20_v3 import H20V3Tests
from test_armory_materia import execute
from test_autosave_h02 import AutosaveH02Tests
from test_backpack_h02 import BackpackH02Tests
ROOT=Path(__file__).resolve().parents[2]
class RetainedFixes(unittest.TestCase):
 @classmethod
 def setUpClass(c):
  paths=['release/development/GRecovery01/FFERPG-0.9.7.5g-Recovery01.w3x','release/development/GRecovery01/FFERPG-0.9.7.5g-1.29.2-Recovery01.w3x','release/development/V11/FFERPG-V11.w3x']
  baselines=['release/0.9.7.5g/FFERPG-0.9.7.5g.w3x','release/0.9.7.5g/FFERPG-0.9.7.5g-1.29.2.w3x','release/development/V10/FFERPG-V10.w3x']
  c.maps=[(MPQ(str(ROOT/a)),MPQ(str(ROOT/b)),functions(MPQ(str(ROOT/b)).read('war3map.j').decode())) for a,b in zip(baselines,paths)];c.fs=[x[2] for x in c.maps];c.f=c.fs[0];c.original=functions(c.maps[0][0].read('war3map.j').decode())
 def setup_scheduler(self,extra_names=()):
  e,*rest=AutosaveH02Tests.setup_scheduler(self,extra_names);e['FFL_AutoRepeating']=False
  names=['FFL_TryAutosave','FFL_RetryAutosaves','FFL_QueueAutosave','FFL_AutoStart','FFL_AutoSchedule','FFL_Autosave']+list(extra_names)
  e=execute('\n'.join(self.fs[0][n] for n in names),names,e);return (e,*rest)
 def run_j(self,names,extra=None):return BackpackH02Tests.run_j(self,names,extra or {})
 def test_20_30_40_minute_dispatch(self):H20V3Tests.test_timer_dispatches_at_20_30_40_minutes_and_manual_request_does_not_reset_it(self)
 def test_optout_and_default_status(self):
  AutosaveH02Tests.test_bare_command_status_never_disables_and_only_explicit_off_opts_out(self)
  AutosaveH02Tests.test_off_before_match_start_is_not_overridden(self)
  AutosaveH02Tests.test_optout_and_departed_players_are_not_queued(self)
 def test_load_cinematic_and_capture_failures_defer_saves(self):
  AutosaveH02Tests.test_busy_or_missing_character_is_deferred_then_retried(self)
  AutosaveH02Tests.test_failed_capture_start_remains_pending_and_backs_off(self)
  AutosaveH02Tests.test_asynchronous_capture_or_export_failure_is_not_discarded(self)
 def test_physical_save_target_and_staged_capture(self):
  AutosaveH02Tests.test_actual_export_path_is_autosave_txt_owner_only(self)
  AutosaveH02Tests.test_autosave_uses_staged_capture_and_immediate_test_command_queues(self)
 def test_full_teleporter_cancel_and_existing_sync(self):
  BackpackH02Tests.test_full_and_partial_teleporter_cancel_above_hud(self)
  BackpackH02Tests.test_teleporter_click_cancel_esc_and_sync_unchanged(self)
 def test_inventory_gear_jobs_load_and_objects_match_baseline(self):
  for old,new,f in self.maps:
   baseline=functions(old.read('war3map.j').decode())
   for n in baseline:
    if n.startswith(('Inventory','QuickGear','Forsaken_','Bag','GearInput','Wave','Load_','FRC_','FSC_','FST_','Job_')):
     self.assertEqual(tokens(baseline[n]),tokens(f[n]),n)
   for name in old.read('(listfile)').decode().splitlines():
    if name.lower() not in ['war3map.j','war3map.wct','(listfile)','(attributes)','(signature)']:self.assertEqual(old.read(name),new.read(name),name)
   for bad in ['Inventory05','InventoryH03','Load04_Busy','Forsaken_KeepInventoryFrames','Inventory94_ClearAim']:self.assertFalse(any(bad in n for n in f),bad)
if __name__=='__main__':unittest.main(defaultTest='RetainedFixes')

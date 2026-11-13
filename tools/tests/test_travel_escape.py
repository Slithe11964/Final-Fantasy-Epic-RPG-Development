"""Direct Escape is local input; only the synchronized matching menu closes."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from build_travel_escape_fix import HELPERS
from test_armory_materia import execute
class TravelEscapeTests(unittest.TestCase):
 def test_close_request_is_local_and_sync_closes_only_matching_players_menu(self):
  sent=[];closed=[];visible=defaultdict(bool,{0:True,1:True});epoch=defaultdict(int,{0:4,1:7});state=dict(owner=0,local=0,payload='4')
  e=dict(TravelVisible=visible,TravelEscapeEpoch=epoch,GetTriggerPlayer=lambda:state['owner'],GetPlayerId=lambda p:p,GetLocalPlayer=lambda:state['local'],I2S=str,S2I=int,BlzSendSyncData=lambda prefix,data:sent.append((prefix,data)),BlzGetTriggerSyncData=lambda:state['payload'],Travel_Hide=lambda p:closed.append(p))
  e=execute(HELPERS,['Travel_EscapeKey','Travel_EscapeSync'],e)
  e['Travel_EscapeKey']();self.assertEqual(sent,[('FFTravelClose','4')]);self.assertEqual(closed,[]);self.assertTrue(visible[0])
  e['Travel_EscapeSync']();self.assertEqual(closed,[0])
  closed.clear();epoch[0]=5;e['Travel_EscapeSync']();self.assertEqual(closed,[],'old Escape must not close a newly opened menu')
  state.update(owner=1,local=0,payload='7');e['Travel_EscapeKey']();self.assertEqual(len(sent),1)
  e['Travel_EscapeSync']();self.assertEqual(closed,[1])
  visible[1]=False;e['Travel_EscapeSync']();self.assertEqual(closed,[1])
if __name__=='__main__':unittest.main()

"""Exercise the modeless teleporter panel's synced close and travel validation."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
from mpq import MPQ
ROOT=Path(__file__).resolve().parents[2]
class TravelPanelTests(unittest.TestCase):
 def runtime(self):
  panel=(ROOT/'experiments/Forsaken/TravelPanel.j').read_text();packed=MPQ(str(ROOT/'release/development/QuickUI39/FFERPG-QuickUI39-Forsaken.w3x'));f=functions(packed.read('war3map.j').decode());source=panel+'\n'+f['Travel_Hide'];e=mocks(source)
  state=dict(owner=0,local=0,key=27,data='');sent=[];moved=[];dialogs=[];frames=[]
  e.update(TravelPanel='panel',TravelPanelTitle='title',TravelPanelButton=defaultdict(str,{i:'button'+str(i) for i in range(16)}),TravelDialog={0:'d0',1:'d1'},TravelPage=defaultdict(int),TravelVisible=defaultdict(bool),TravelEscapeEpoch=defaultdict(int),TravelOrder=dict(enumerate([1,2,3,5,12,6,4,8,7,10,9,11,13],1)),
    udg_TravelCount=13,udg_WarpUnlocked=defaultdict(lambda:True),udg_TravelName=defaultdict(lambda:'Destination'),udg_TravelHotkey=defaultdict(int),udg_TravelX={i:i*10 for i in range(1,14)},udg_TravelY=defaultdict(float),udg_WarpEnterTrigger='warp',udg_InCinematicMode=False,QuickGearChatOpen=False,
    GetTriggerPlayer=lambda:state['owner'],GetPlayerId=lambda p:p,GetLocalPlayer=lambda:state['local'],GetHandleId=lambda k:k,BlzGetTriggerPlayerKey=lambda:state['key'],BlzGetTriggerSyncData=lambda:state['data'],BlzSendSyncData=lambda p,d:sent.append((p,d)),I2S=str,I2R=float,S2I=lambda s:int(s) if s else 0,StringLength=len,SubString=lambda s,a,b:s[a:b],IMaxBJ=max,FRAMEPOINT_TOPLEFT=0,FRAMEPOINT_TOP=1,
    DialogDisplay=lambda p,d,v:dialogs.append((p,v)),BlzFrameSetVisible=lambda f,v:frames.append((f,v)),Player_GetHero=lambda p:'hero'+str(p),DisableTrigger=lambda *a:None,EnableTrigger=lambda *a:None,TriggerSleepAction=lambda *a:None,SetUnitX=lambda u,x:moved.append((u,x)),SetUnitY=lambda *a:None,PanCameraToTimed=lambda *a:None)
  names=[n for n in functions(panel) if n!='TravelPanel_Init']+['Travel_Hide'];e=execute(source,names,e)
  return e,state,sent,moved,dialogs
 def test_escape_closes_only_own_panel_without_any_native_modal_or_teleport(self):
  e,s,sent,moved,dialogs=self.runtime();e['Travel_Show'](0,0);e['Travel_Show'](1,1);e['TravelPanel_Key']()
  self.assertEqual(sent,[('FFTravelPick','1:0')]);self.assertTrue(e['TravelVisible'][0]);self.assertTrue(e['TravelVisible'][1])
  s['data']=sent[-1][1];e['TravelPanel_Sync']();self.assertFalse(e['TravelVisible'][0]);self.assertTrue(e['TravelVisible'][1]);self.assertFalse(moved)
  self.assertFalse(any(visible for owner,visible in dialogs),'no modal dialog may open')
 def test_off_page_locked_and_stale_choices_cannot_warp(self):
  e,s,sent,moved,dialogs=self.runtime();e['Travel_Show'](0,0)
  s['data']='1:13';e['TravelPanel_Sync']();self.assertFalse(moved)
  s['data']='1:14';e['TravelPanel_Sync']();self.assertEqual(e['TravelPage'][0],1)
  s['data']='1:0';e['TravelPanel_Sync']();self.assertTrue(e['TravelVisible'][0])
  s['data']='2:13';e['udg_WarpUnlocked'][13]=False;e['TravelPanel_Sync']();self.assertFalse(moved)
  e['udg_WarpUnlocked'][13]=True;e['TravelPanel_Sync']();self.assertEqual(moved,[('hero0',130)])
 def test_escape_works_on_second_page_and_typing_chat_cannot_select_destination(self):
  e,s,sent,moved,dialogs=self.runtime();e['Travel_Show'](0,1);e['QuickGearChatOpen']=True;s['key']=68;e['TravelPanel_Key']();self.assertFalse(sent)
  s['key']=27;e['TravelPanel_Key']();s['data']=sent[-1][1];e['TravelPanel_Sync']();self.assertFalse(e['TravelVisible'][0]);self.assertFalse(moved)
if __name__=='__main__':unittest.main()

"""Exercise the local-view/shared-item boundary; not a native/MP simulation."""
from pathlib import Path
from collections import defaultdict
import re,sys,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1]),str(Path(__file__).resolve().parent)]
from jtok import functions
from test_shared_context import mocks
from test_armory_materia import execute

SOURCE=(Path(__file__).resolve().parents[2]/'experiments/InventoryPanel04/Panel.j').read_text()
FS=functions(SOURCE)

class PanelTests(unittest.TestCase):
 def view(self,local):
  e=mocks(SOURCE);shown=[];sent=[];texts={}
  e.update(GetLocalPlayer=lambda:local,Player=lambda p:p,GetPlayerId=lambda p:p,GetTriggerPlayer=lambda:local,
   Bag04Open=False,Bag04Held=-1,Bag04HeldId=0,Bag04Hover=-1,Bag04Root='root',Bag04Title='title',InvCheckScene=False,
   BlzFrameSetVisible=lambda f,v:shown.append((f,v)),BlzSendSyncData=lambda p,d:sent.append((p,d)),
   BlzFrameSetText=lambda f,t:texts.update({f:t}),GetPlayerName=lambda p:'Player '+str(p),I2S=str,
   Bag04ItemId=defaultdict(int),Bag04IconPath=defaultdict(str),Bag04Tooltip=defaultdict(str),Bag04Charges=defaultdict(str),
   Bag04Button=defaultdict(lambda:None),Bag04Icon=defaultdict(lambda:'icon'),Bag04Count=defaultdict(lambda:'count'),Bag04TipText=defaultdict(lambda:'tip'))
  e=execute(SOURCE,['Bag04_Draw','Bag04_Show','Bag04_Send','Bag04_Click','Bag04_Key'],e)
  return e,shown,sent

 def test_two_clients_keep_independent_open_state_without_messages(self):
  a,ashow,asend=self.view(0);b,bshow,bsend=self.view(1)
  a['Bag04_Show'](True);b['Bag04_Show'](True)
  b['Bag04_Show'](False)
  self.assertTrue(a['Bag04Open']);self.assertFalse(b['Bag04Open'])
  self.assertEqual(ashow,[('root',True)])
  self.assertEqual(bshow,[('root',True),('root',False)])
  self.assertEqual(asend+bsend,[])

 def test_remote_key_and_frame_events_do_not_toggle_local_panel(self):
  e,shown,sent=self.view(0)
  e.update(GetTriggerPlayer=lambda:1,BlzGetTriggerFrame=lambda:'access',Bag04Access='access',BlzGetTriggerPlayerKey=lambda:66)
  e['Bag04_Key']();e['Bag04_Click']()
  self.assertFalse(e['Bag04Open']);self.assertEqual(shown+sent,[])

 def receiver(self,payload,owner=0,item_id=123):
  e=mocks(SOURCE);actions=[];reads=[];captures=[]
  e.update(InvCheckScene=False,GetTriggerPlayer=lambda:0,GetPlayerId=lambda p:p,Player=lambda p:p,
   BlzGetTriggerSyncData=lambda:payload,I2S=str,S2I=lambda s:int(s or '0'),StringLength=len,SubString=lambda s,a,b:s[a:b],
   InvCheckHero={0:'hero'},Bag04_Item=lambda p,s:reads.append((p,s)) or ('item' if s==9 else None),
   GetOwningPlayer=lambda h:owner,GetHandleId=lambda it:item_id if it else 0,GetWidgetLife=lambda h:100.,
   GetUnitX=lambda h:1.,GetUnitY=lambda h:2.,UnitDropItemPoint=lambda *args:actions.append(('drop',args)) or True,
   UnitDropItemSlot=lambda *args:actions.append(('move',args)) or False,
   BlzUnitEquipItem=lambda *args:actions.append(('equip',args)) or True,
   Bag04_Capture=lambda p:captures.append(p),DisplayTimedTextToPlayer=lambda *args:None)
  e=execute(SOURCE,['Bag04_Field','Bag04_Receive'],e)
  return e,actions,reads,captures

 def test_sync_rejects_stale_item_foreign_unit_invalid_slot_and_cinematic(self):
  for data,owner in [('9:999:-1',0),('9:123:-1',1),('-1:123:-1',0),('45:123:-1',0),('9:123:45',0)]:
   e,actions,reads,captures=self.receiver(data,owner);e['Bag04_Receive']()
   self.assertEqual(actions,[],data);self.assertEqual(captures,[],data)
  e,actions,reads,captures=self.receiver('9:123:-1');e['InvCheckScene']=True;e['Bag04_Receive']()
  self.assertEqual(reads+actions+captures,[])

 def test_drop_executes_only_for_own_current_item_on_sync_receiver(self):
  e,actions,reads,captures=self.receiver('9:123:-1');e['Bag04_Receive']()
  self.assertEqual(actions,[('drop',('hero','item',101.,2.))]);self.assertEqual(captures,[0])
  self.assertNotIn('GetLocalPlayer',FS['Bag04_Receive'])

 def test_local_handlers_do_not_query_items_or_change_game_state(self):
  local=['Bag04_Draw','Bag04_Show','Bag04_Send','Bag04_Click','Bag04_Hover','Bag04_Mouse','Bag04_Key']
  forbidden=r'\b(?:Bag04_Item|Bag04_Capture|BlzUnit\w+|UnitDropItem\w+|UnitRemoveItem|UnitAddItem|UnitUseItem\w*|BlzGetItem\w+|BlzGetUnitAbility\w+|CreateTimer|CreateGroup|CreateUnit|RemoveItem)\s*\('
  for n in local:self.assertNotRegex(FS[n],forbidden,n)
  self.assertNotIn('TimerStart',SOURCE)
  self.assertNotIn('ForceUIKey',SOURCE)

if __name__=='__main__':unittest.main()

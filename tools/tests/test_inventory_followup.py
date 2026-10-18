"""Cooldown duration parity, safe synchronized transfers and early fishing input."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from test_shared_context import mocks
from unittest.mock import patch
from test_quest_lifecycle import expression
from test_armory_materia import execute
from jtok import functions
from equipment_integrity import refresh
HERE=ROOT/'experiments/Forsaken'

class InventoryFollowupTests(unittest.TestCase):
    def test_duration_uses_rank_base_and_identical_reductions_without_remaining_time(self):
        s=(HERE/'SharedItemDuration.j').read_text();buffs=set();agi=[1000.];seen=[];rank=[0]
        env=mocks(s);env.update(Abil_GetLevel=lambda *a:rank[0],GetUnitAbilityLevel=lambda u,r:int(r in buffs),
            Player_GetHero=lambda p:'hero',GetOwningPlayer=lambda u:0,IsPlayerInForce=lambda *a:True,udg_PlayingPlayers='players',
            GetHeroAgi=lambda *a:agi[0],I2R=float,RMaxBJ=max,
            BlzGetAbilityCooldown=lambda r,l:seen.append(l) or 60.,
            BlzGetUnitAbilityCooldownRemaining=lambda *a: (_ for _ in ()).throw(AssertionError('unsafe remaining read')))
        with patch('test_quest_lifecycle.expression',lambda text:expression(text).replace('//','/')):
            e=execute(s,['SharedItemCD_Duration'],env)
        self.assertEqual(e['SharedItemCD_Duration']('hero','book'),30.)
        buffs.update(['A1C3','A18K','B00F']);self.assertAlmostEqual(e['SharedItemCD_Duration']('hero','book'),12.6)
        self.assertAlmostEqual(e['SharedItemCD_Duration']('gaya','book'),25.2)
        buffs.clear();buffs.add('B08Y');self.assertEqual(e['SharedItemCD_Duration']('hero','book'),45.)
        rank[0]=1;self.assertEqual(e['SharedItemCD_Duration']('hero','book'),45.);self.assertEqual(seen[-1],1)
        self.assertNotIn('GetLocalPlayer',s)
        buffs.add('Avul');self.assertEqual(e['SharedItemCD_Duration']('hero','book'),60.)
        buffs.clear();self.assertEqual(e['SharedItemCD_Duration']('hero','A0C7'),60.)

    def test_shared_deadline_expires_and_rejected_casts_never_extend_it(self):
        s=(HERE/'SharedItemCooldown.j').read_text();store={};now=[100.];actor=['hero'];raw=['book'];duration=[12.]
        env=mocks(s);env.update(NativeCDData='data',NativeCDClock='clock',R2SW=lambda n,*a:format(n,'.1f'),
            GetTriggerUnit=lambda:actor[0],GetSpellAbilityId=lambda:raw[0],GetHandleId=lambda u:1000 if u=='hero' else 1001,
            GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,Player=lambda p:p,Player_GetHero=lambda p:'hero',udg_SpiritOfGaya={1:'gaya'},
            LoadInteger=lambda h,p,k:store.get((p,k),0),LoadReal=lambda h,p,k:store.get((p,k),0.),LoadBoolean=lambda h,p,k:store.get((p,k),False),
            SaveInteger=lambda h,p,k,v:store.__setitem__((p,k),v),SaveReal=lambda h,p,k,v:store.__setitem__((p,k),v),SaveBoolean=lambda h,p,k,v:store.__setitem__((p,k),v),
            TimerGetElapsed=lambda t:now[0],RMaxBJ=max,SharedItemCD_Duration=lambda *a:duration[0],
            BlzGetUnitAbilityCooldownRemaining=lambda *a:(_ for _ in ()).throw(AssertionError('stale native duration')))
        for ability in ['book','anotherbook']:store[0,ability]=1
        names=['NativeCD_Pool','NativeCD_Left','NativeCD_PlayerCaster','NativeCD_Stop','NativeCD_Channel','NativeCD_Allowed','NativeCD_DurationForCast','NativeCD_Effect']
        e=execute(s,names,env);e['NativeCD_Channel']();duration[0]=6.;e['NativeCD_Effect']();self.assertEqual(store[0,1],112.);self.assertEqual(e['NativeCD_DurationForCast']('hero','book'),12.)
        for time in [100.1,106.,111.9]:
            now[0]=time;actor[0]='gaya';raw[0]='anotherbook';e['NativeCD_Channel']();e['NativeCD_Effect']()
            self.assertFalse(e['NativeCD_Allowed']());self.assertEqual(store[0,1],112.)
        now[0]=112.;actor[0]='hero';e['NativeCD_Channel']();self.assertTrue(e['NativeCD_Allowed']())
        e['NativeCD_Effect']();self.assertEqual(store[0,1],118.)

    def transfer(self,data='123:29:5:456:8',local=0):
        s=(HERE/'CarryTransferUI.j').read_text().split('// FUNCTIONS\n')[1];moves=[];messages=[];slots={}
        state=dict(hero='hero',raw=456,mark=8)
        env=mocks(s);env.update(GetTriggerPlayer=lambda:0,Player_GetHero=lambda p:state['hero'],GetPlayerId=lambda p:p,
            BlzGetTriggerSyncData=lambda:data,S2I=lambda s:int(s) if s.lstrip('-').isdigit() else 0,I2S=str,
            StringLength=len,SubString=lambda s,a,b:s[a:b],GetUnitTypeId=lambda u:123,
            UnitExtendedInventorySize=lambda u:30,UnitItemInBagSlot=lambda u,i:'item' if i==29 else None,
            GetItemTypeId=lambda i:state['raw'],GetItemUserData=lambda i:state['mark'],
            UnitItemInSlot=lambda u,i:slots.get(i),CarryUI_Canonical=lambda r:111 if r==456 else 0,
            Integrity_CarryIntoSlot=lambda *args:moves.append(args) or 'new',
            GetLocalPlayer=lambda:local,CarryUIOpen=False,Forsaken_RequestInventoryRefresh=lambda h:None,
            DisplayTimedTextToPlayer=lambda *a:messages.append(a[-1]))
        e=execute(s,['CarryUI_Field','CarryUI_Receive'],env)
        return e,state,slots,moves,messages

    def test_transfer_validates_current_owned_bag_before_mutation(self):
        e,state,slots,moves,_=self.transfer();e['CarryUI_Receive']()
        self.assertEqual(moves,[('hero','item',5,111)])
        for data in ['123:30:5:456:8','123:29:6:456:8','124:29:5:456:8',
                     '123:29:5:999:8','123:29:5:456:9','123:29:5:456:8:0','123:029:5:456:8']:
            e,_,_,moves,_=self.transfer(data);e['CarryUI_Receive']();self.assertEqual(moves,[],data)
        e,_,slots,moves,_=self.transfer();slots[5]='occupied';e['CarryUI_Receive']();self.assertEqual(moves,[])
        e,state,_,moves,_=self.transfer();state['hero']=None;e['CarryUI_Receive']();self.assertEqual(moves,[])

    def test_transfer_ui_selection_sends_request_without_mutating_items(self):
        raw_source=(HERE/'CarryTransferUI.j').read_text();decl,s=raw_source.split('// FUNCTIONS\n',1);s='globals\n'+decl+'endglobals\n'+s;sent=[];frame=['bag29']
        env=mocks(s);env.update(GetTriggerPlayer=lambda:0,GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',
            BlzGetTriggerFrame=lambda:frame[0],CarryUIClose='close',CarryUIButton='open',CarryUIOpen=True,
            CarryUIBagButton={i:'bag'+str(i) for i in range(30)},CarryUIQuickButton={i:'quick'+str(i) for i in range(6)},
            UnitItemInBagSlot=lambda *a:'gear',CarryUI_Canonical=lambda *a:111,GetItemTypeId=lambda *a:456,
            GetItemUserData=lambda *a:8,GetUnitTypeId=lambda *a:123,GetItemName=lambda *a:'Book',
            CarryUISelected=-1,CarryUIRaw=0,CarryUIData=0,CarryUIHeroRaw=0,CarryUI_Draw=lambda *a:None,BlzSendSyncData=lambda *a:sent.append(a),I2S=str,CarryUIHint='hint')
        e=execute(s,['CarryUI_Click'],env);e['CarryUI_Click']();frame[0]='quick5';e['CarryUI_Click']()
        self.assertEqual(sent,[('FFCarry','123:29:5:456:8')])
        self.assertNotIn('CreateItem',functions(s)['CarryUI_Click'])
        self.assertNotIn('GetLocalPlayer',functions(s)['CarryUI_Init'])

    def test_early_fishing_input_preserves_state_item_and_controls(self):
        s=next((ROOT/'src/triggers').rglob('Fishing_ReelingAndCatch.j')).read_text()
        s=refresh(s,{});self.assertEqual(refresh(s,{}),s);removed=[];ended=[];messages=[]
        env=mocks(s);env.update(GetTriggerUnit=lambda:'controls',GetOwningPlayer=lambda u:0,GetConvertedPlayerId=lambda p:1,
            Trig_Fishing_Input_IsTooEarly=lambda:True,RemoveItem=lambda i:removed.append(i),
            ConditionalTriggerExecute=lambda t:ended.append(t),DisplayTimedTextToPlayer=lambda *a:messages.append(a[-1]))
        e=execute(s,['Trig_Fishing_Input_Actions'],env);e['Trig_Fishing_Input_Actions']()
        self.assertEqual(removed,[]);self.assertEqual(ended,[]);self.assertIn('Wait for the !',messages[0])

if __name__=='__main__':unittest.main()

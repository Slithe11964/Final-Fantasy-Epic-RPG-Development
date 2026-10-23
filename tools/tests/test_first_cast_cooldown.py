"""The engine's first-cast setup cannot overwrite reduced spell/item timers."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
from first_cast_cooldown import HELPER,refresh
from jtok import functions
ROOT=Path(__file__).resolve().parents[2]
SRC=(ROOT/'experiments/Forsaken/SharedItemCooldown.j').read_text()

class FirstCastTests(unittest.TestCase):
    def test_job_and_item_commit_runs_after_the_engine_first_use_setup(self):
        source=SRC+'\n'+HELPER;state={'event':'channel','time':1.};running={};prepared=[];categories=[]
        e=mocks(source);e.update(NativeCDCommitTimer='timer',NativeCDClock='clock',NativeCDCommitCount=0,
            NativeCDCommitCaster=defaultdict(lambda:None),NativeCDCommitRaw=defaultdict(int),
            NativeCDCommitDuration=defaultdict(float),NativeCDCommitTime=defaultdict(float),NativeCDCommitCategory=defaultdict(bool),
            SharedItemCD_IsItem=lambda raw:False,GetSpellAbility=lambda:'instance',GetSpellAbilityId=lambda:101,ABILITY_RLF_COOLDOWN='cooldown',
            BlzSetAbilityRealLevelField=lambda *a:prepared.append(a),IMaxBJ=max,RMaxBJ=max,
            BlzSetUnitAbilityCooldown=lambda *a:prepared.append(a),
            BlzStartUnitAbilityCooldown=lambda u,raw,d:running.__setitem__((u,raw),d),
            GetTriggerEventId=lambda:state['event'],EVENT_PLAYER_UNIT_SPELL_EFFECT='effect',
            TimerGetElapsed=lambda t:state['time'],TimerStart=lambda *a:None,GetUnitTypeId=lambda u:1,
            NativeCD_Category=lambda u,p,d,start:categories.append((u,p,d,start)),NativeCD_Left=lambda u,p:24.995)
        e=execute(source,['Cooldown_ApplyCurrent','NativeCD_Commit','NativeCD_Queue'],e)
        e['Cooldown_ApplyCurrent']('hero',101,0,25.)
        self.assertEqual(e['NativeCDCommitCount'],0);self.assertFalse(running)
        for base in [100.,100.]:
            state['event']='effect';e['Cooldown_ApplyCurrent']('hero',101,0,25.)
            running['hero',101]=base # Engine writes its first-use timer after effect callbacks.
            state['time']+=.005;e['NativeCD_Commit']()
            self.assertAlmostEqual(running['hero',101],24.995)
            self.assertEqual(e['NativeCDCommitCount'],0)
        for pool in [2,101,102,126,123456]: # Consumables, gear categories, independent materia.
            e['NativeCD_Queue']('hero',pool,25.,True);e['NativeCD_Commit']()
            self.assertEqual(categories[-1],('hero',pool,24.995,True))

    def test_native_adapter_and_precast_registration_are_both_connected(self):
        from editor_pair import View
        source=View(ROOT/'release/development/ItemFix01/FFERPG-ItemFix01-Forsaken.w3x').modules['TCooldown']
        updated=refresh(source,native=True);self.assertEqual(refresh(updated,native=True),updated)
        fs=functions(updated)
        self.assertIn('call Cooldown_ApplyCurrent(',fs['Forsaken_SetCastCooldown'])
        for event in ['SPELL_CHANNEL','SPELL_CAST','SPELL_EFFECT']:
            self.assertIn('EVENT_PLAYER_UNIT_'+event,fs['Register_Cooldown_Scaling'])
        self.assertIn('Forsaken_SetCastCooldown',fs['Trig_Cooldown_Scaling_Actions'])

if __name__=='__main__':unittest.main()

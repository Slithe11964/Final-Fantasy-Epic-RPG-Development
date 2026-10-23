"""One reduced cast duration prepares every matching carried ability before use."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]
SRC=(ROOT/'experiments/Forsaken/SharedItemCooldown.j').read_text()

class CategoryTests(unittest.TestCase):
    def test_category_prepares_all_slots_both_carriers_and_excludes_other_pools(self):
        inventory={('hero',0):'wand',('hero',6):'wand2',('hero',8):'rod',('gaya',0):'wand3'}
        abilities={'wand':[101],'wand2':[102],'rod':[103],'wand3':[104]}
        pools={101:102,102:102,103:101,104:102};sets=[];starts=[]
        e=mocks(SRC);e.update(GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,Player_GetHero=lambda p:'hero',
            udg_SpiritOfGaya={1:'gaya'},BlzUnitExtendedInventorySize=lambda u:2,
            UnitItemInSlot=lambda u,i:inventory.get((u,i)),BlzUnitItemInBagSlot=lambda u,i:inventory.get((u,i+6)),
            BlzUnitItemInEquipmentSlot=lambda u,i:inventory.get((u,i+8)),ConvertLoadoutSlot=lambda i:i,
            BlzGetItemAbilityByIndex=lambda item,i:abilities.get(item,[])[i] if i<len(abilities.get(item,[])) else None,
            BlzGetAbilityId=lambda a:a,NativeCD_Pool=lambda a:pools[a],
            ABILITY_IF_LEVELS='levels',ABILITY_RLF_COOLDOWN='cooldown',BlzGetAbilityIntegerField=lambda *a:2,
            BlzSetAbilityRealLevelField=lambda a,f,level,dur:sets.append((a,level,dur)),
            BlzStartUnitAbilityCooldown=lambda u,a,dur:starts.append((u,a,dur)))
        e=execute(SRC,['NativeCD_CategoryHolder','NativeCD_Category'],e)
        e['NativeCD_Category']('hero',102,25.,False)
        self.assertEqual(set(sets),{(a,rank,25.) for a in [101,102,104] for rank in [0,1]})
        self.assertFalse(starts)
        e['NativeCD_Category']('hero',102,25.,True)
        self.assertEqual(set(starts),{('hero',101,25.),('hero',102,25.),('gaya',104,25.)})
        sets.clear();starts.clear();e['NativeCD_Category']('hero',101,8.,True)
        self.assertEqual(sets,[(103,0,8.),(103,1,8.)]);self.assertEqual(starts,[('hero',103,8.)])

    def test_snapshot_is_calculated_before_preparation_and_reused_after_cast_delay(self):
        store={};events=[];state={'now':1.,'scaled':25.}
        e=mocks(SRC);e.update(NativeCDData='data',NativeCDClock='clock',GetTriggerUnit=lambda:'hero',
            GetSpellAbilityId=lambda:101,NativeCD_Pool=lambda raw:102,GetHandleId=lambda u:500,
            GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,NativeCD_PlayerCaster=lambda u:True,
            TimerGetElapsed=lambda t:state['now'],RMaxBJ=max,
            SaveInteger=lambda h,p,c,v:store.__setitem__((p,c),v),SaveReal=lambda h,p,c,v:store.__setitem__((p,c),v),
            SaveBoolean=lambda h,p,c,v:store.__setitem__((p,c),v),LoadInteger=lambda h,p,c:store.get((p,c),0),
            LoadReal=lambda h,p,c:store.get((p,c),0.),LoadBoolean=lambda h,p,c:store.get((p,c),False),
            SharedItemCD_Duration=lambda u,raw:events.append('calculate') or state['scaled'],
            NativeCD_Category=lambda u,p,d,start:events.append(('category',d,start)),NativeCD_Queue=lambda u,p,d,cat:events.append(('queue',d,cat)))
        e=execute(SRC,['NativeCD_Left','NativeCD_Channel','NativeCD_DurationForCast','NativeCD_Allowed','NativeCD_Effect'],e)
        e['NativeCD_Channel']();self.assertEqual(events,['calculate',('category',25.,False)])
        state.update(now=2.,scaled=99.)
        e['NativeCD_Effect']();self.assertEqual(events[-1],('queue',25.,True))
        self.assertEqual(store[32,102],27.);self.assertEqual(events.count('calculate'),1)

if __name__=='__main__':unittest.main()

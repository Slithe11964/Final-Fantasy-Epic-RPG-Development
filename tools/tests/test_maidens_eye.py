"""Carried sight covers every slot without enabling stored gear passives."""
from pathlib import Path
from collections import defaultdict
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from test_armory_materia import execute
from test_shared_context import mocks
from maidens_eye import refresh,objects
from objdata import read_objects,write_objects,fields
ROOT=Path(__file__).resolve().parents[2]
HELPER=(ROOT/'experiments/Forsaken/MaidensEye.j').read_text()

class MaidenEyeTests(unittest.TestCase):
    def runtime(self):
        holders={'hero':[], 'gaya':[],'newhero':[]};abilities=defaultdict(set);changes=[];scans=[];state={'hero':'hero','item':'I0HS','holder':'hero'}
        env=mocks(HELPER)
        env.update(MaidenEyeDirty=defaultdict(bool),MaidenEyeHero=defaultdict(lambda:None),MaidenEyeGaya=defaultdict(lambda:None),
            MaidenEyeSweep=19,MaidenEyeTimer=None,udg_SpiritOfGaya=defaultdict(lambda:None,{1:'gaya'}),udg_PlayingPlayers={0},
            Player=lambda p:p,IsPlayerInForce=lambda p,f:p in f,Player_GetHero=lambda p:state['hero'],
            GetTriggerUnit=lambda:state['holder'],GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,
            GetManipulatedItem=lambda:state['item'],GetItemTypeId=lambda i:i,
            GetUnitAbilityLevel=lambda u,a:int(a in abilities[u]),
            UnitAddAbility=lambda u,a:(abilities[u].add(a),changes.append(('add',u,a))),
            UnitRemoveAbility=lambda u,a:(abilities[u].discard(a),changes.append(('remove',u,a))))
        def has(u,raw):scans.append(u);return raw in holders[u]
        env['Carry_Has']=has
        return execute(HELPER,['MaidenEye_Update','MaidenEye_Changed','MaidenEye_Tick'],env),holders,abilities,changes,scans,state

    def test_all_hero_and_gaya_inventory_positions_grant_sight(self):
        for holder in ['hero','gaya']:
            for slot in range(45):
                e,h,a,c,scans,s=self.runtime();h[holder]=[None]*45;h[holder][slot]='I0HS'
                e['MaidenEye_Tick']();self.assertIn('aMEy',a[holder],(holder,slot))

    def test_transfer_and_last_copy_removal_leave_other_sight_untouched(self):
        e,h,a,c,scans,s=self.runtime();a['hero'].add('Atru');h['hero']=['I0HS','I0HS'];e['MaidenEye_Tick']()
        h['hero'].pop();e['MaidenEye_Changed']();e['MaidenEye_Tick']();self.assertIn('aMEy',a['hero'])
        h['gaya']=h['hero'];h['hero']=[];e['MaidenEye_Changed']();e['MaidenEye_Tick']()
        self.assertNotIn('aMEy',a['hero']);self.assertIn('Atru',a['hero']);self.assertIn('aMEy',a['gaya'])
        h['gaya']=[];s['holder']='gaya';e['MaidenEye_Changed']();e['MaidenEye_Tick']();self.assertNotIn('aMEy',a['gaya'])

    def test_idle_uses_cached_state_and_sweep_recovers_silent_removal(self):
        e,h,a,c,scans,s=self.runtime();h['hero']=['I0HS'];e['MaidenEye_Tick']();initial=list(scans)
        for _ in range(19):e['MaidenEye_Tick']()
        self.assertEqual(scans,initial)
        h['hero']=[];e['MaidenEye_Tick']();self.assertNotIn('aMEy',a['hero'])

    def test_new_hero_rebinds_without_leaving_old_bonus(self):
        e,h,a,c,scans,s=self.runtime();h['hero']=['I0HS'];e['MaidenEye_Tick']()
        s['hero']='newhero';h['newhero']=['I0HS'];e['MaidenEye_Tick']()
        self.assertNotIn('aMEy',a['hero']);self.assertIn('aMEy',a['newhero'])

    def test_object_inherits_original_true_sight_and_refresh_is_idempotent(self):
        data=write_objects({'original':[],'custom':[],'version':3},3,'w3a')
        updated=objects(data);self.assertEqual(objects(updated),updated)
        added=read_objects(updated,'w3a')['custom'][0];self.assertEqual(added['base'],'Atru')
        self.assertNotIn('aare',fields(added));self.assertEqual(fields(added)['aite'],1)
        source=next((ROOT/'src/triggers').rglob('Item_Stack.j')).read_text()
        self.assertEqual(refresh(refresh(source)),refresh(source))

if __name__=='__main__':unittest.main()

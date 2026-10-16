"""Exercise Elysium unlock gating and dummy-passive visual inheritance."""
from pathlib import Path
import sys,unittest,copy
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from objdata import read_objects,write_objects,fields
from world_visuals import clear_marker_art,ART_FIELDS
from gameplay_runtime import refresh
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]


def mod(field,value,kind=3):return dict(field=field,type=kind,level=0,data=0,value=value,end=0)


class WorldAccessTests(unittest.TestCase):
    def test_only_inherited_dummy_art_is_cleared_with_gameplay_and_custom_art_preserved(self):
        dummy=dict(base='Amgl',id='A000',sets=[dict(flag=0,mods=[mod('arac','orc'),mod('Data',7,0)])])
        authored=dict(base='Amgl',id='A001',sets=[dict(flag=0,mods=[mod('atat','custom.mdl')])])
        spell=dict(base='AHbz',id='A002',sets=[dict(flag=0,mods=[mod('anam','Blizzard')])])
        table=dict(version=3,original=[],custom=[dummy,authored,spell]);original=copy.deepcopy(table)
        result,changed=clear_marker_art(write_objects(table,3,'w3a'));parsed=read_objects(result,'w3a')
        self.assertEqual(changed,['A000','A001'])
        data=fields(parsed['custom'][0])
        for key in ART_FIELDS:self.assertEqual(data[key],'')
        self.assertEqual(data['arac'],'orc');self.assertEqual(data['Data'],7)
        self.assertEqual(fields(parsed['custom'][1])['atat'],'custom.mdl')
        self.assertEqual(parsed['custom'][2],original['custom'][2])
        again,changed=clear_marker_art(result);self.assertEqual(again,result);self.assertEqual(changed,[])

    def test_locked_elysium_has_no_live_bridge(self):
        source=(ROOT/'src/triggers/06 Quests and story/Elysium.j').read_text();env=mocks(source);removed=[]
        env.update(gg_dest_DTsb_0068='old bridge',RemoveDestructable=removed.append,
                   Player=lambda p:p)
        e=execute(source,['Trig_Elysium_Prepare_Actions'],env);e['Trig_Elysium_Prepare_Actions']()
        self.assertEqual(removed,['old bridge']);self.assertIsNone(e['gg_dest_DTsb_0068'])

    def test_mastery_rejection_does_not_open_crossing_and_unlock_opens_only_narrow_corridor(self):
        source=(ROOT/'src/triggers/06 Quests and story/Andre.j').read_text();env=mocks(source)
        created=[];cells=[];shown=[];locked=[True]
        env.update(gg_dest_DTsb_0068=None,PATHING_TYPE_WALKABILITY='walk',
            Trig_Andre_Elysium_Reveal_Cond_NoUltimateMastery=lambda:locked[0],
            Trig_Andre_Elysium_Reveal_Cond_CinematicsEnabled=lambda:False,
            Trig_Andre_Elysium_Reveal_Cond_NoGhostYet=lambda:False,
            GetTriggerPlayer=lambda:0,Player=lambda p:p,
            CreateDestructableZ=lambda *args:created.append(args) or 'bridge',
            ShowDestructable=lambda *args:shown.append(args),
            SetTerrainPathable=lambda *args:cells.append(args))
        e=execute(source,['Andre_OpenBridge','Trig_Andre_Elysium_Reveal_Actions'],env)
        e['Trig_Andre_Elysium_Reveal_Actions']();self.assertEqual(created,[]);self.assertEqual(cells,[])
        locked[0]=False;e['Trig_Andre_Elysium_Reveal_Actions']()
        self.assertEqual(len(created),1);self.assertEqual(created[0],('DTsb',0.,-9632.,-128.,90.,1.125,0))
        self.assertEqual(shown,[('bridge',True)])
        self.assertEqual(len(cells),287)
        self.assertTrue(all(-640<=x<=640 and -9728<=y<= -9536 and kind=='walk' and value for x,y,kind,value in cells))
        e['Andre_OpenBridge']();self.assertEqual(len(created),1)

    def test_bridge_maintenance_is_idempotent(self):
        for name in ['Andre','Elysium']:
            source=(ROOT/'src/triggers/06 Quests and story'/f'{name}.j').read_text()
            self.assertEqual(refresh(source),source)

if __name__=='__main__':unittest.main()

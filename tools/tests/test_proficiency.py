"""Execute proficiency/robe displays, completed house icons and local Hunt Club cover."""
import copy,sys,unittest
from unittest.mock import patch
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from proficiency import catalogue,objects,house_runtime,stat_helper,PROFS
from inventory_ui import refresh_hunt
from objdata import read_objects,write_objects
from jtok import functions
from job_objects import refresh_robe
from test_armory_materia import execute
from test_shared_context import mocks
import test_quest_lifecycle as harness
ROOT=Path(__file__).resolve().parents[2]


def mod(f,v,level=None):return dict(field=f,type=3 if isinstance(v,str) else 0,level=level,data=0 if level is not None else None,value=v,end=0)
def obj(raw,mods,base='Roch'):return dict(id=raw,base=base,sets=[dict(flag=0,mods=mods)])
def data(ext,records):return write_objects(dict(version=2,original=[],custom=records),2,ext)


class ProficiencyTests(unittest.TestCase):
    def test_robe_current_life_power_matches_staff_formula_and_hides_when_removed(self):
        template=(ROOT/'experiments/Forsaken/JobStats.j').read_text()
        for prefix,getter in [('Stats','GetUnitAbilityLevel'),('Forsaken','Forsaken_StatAbilityLevel')]:
            s=template.replace('JSTAT',prefix).replace('JGET',getter).replace('JROW',prefix+'_Row')
            abilities={'A07H':1};state={'mp':100.,'maxmp':100.};staff=[6];rows=[]
            env=mocks(s);env.update({getter:lambda u,a:abilities.get(a,0),prefix+'_Row':lambda *a:rows.append(a),
                'UNIT_STATE_MANA':'mp','UNIT_STATE_MAX_MANA':'maxmp',
                'GetUnitState':lambda u,k:state[k],'Prof_GetLevel':lambda *a:staff[0],
                'IsPlayerInForce':lambda *a:True,'I2R':float,'GetOwningPlayer':lambda u:0,
                'R2SW':lambda n,w,d:format(n,'.%df'%d)})
            expression=harness.expression
            # This function uses real division; the quest harness normally truncates integer divisions.
            with patch.object(harness,'expression',lambda text:expression(text).replace('//','/')):
                e=execute(s,[prefix+'_RenderJob'],env)
            for mp,total,high,expected in [(100.,6,0,20.),(50.,6,0,12.),(0.,6,0,0.),
                                            (100.,26,0,12.),(100.,9,1,30.)]:
                rows.clear();state['mp']=mp;staff[0]=total;abilities['A136']=high
                e[prefix+'_RenderJob']('hero',3,7)
                self.assertEqual(rows[0],(7,'White Robe Life-spell power','+%.2f%%'%expected))
            abilities.clear();rows.clear();e[prefix+'_RenderJob']('hero',3,7)
            self.assertFalse(any('White Robe' in r[1] for r in rows))
            self.assertNotIn('call SetUnitState',functions(s)[prefix+'_RenderJob'])

    def test_robe_original_equipped_variant_and_armory_descriptions_only(self):
        for ext,ids in [('w3t',['I0D2','f275','othr']),('w3u',['n0NB','othr'])]:
            records=[obj(raw,[mod('utub','HP +3500. Increases the power of Life spells.'),mod('ugol',10)],'hfoo') for raw in ids]
            original=data(ext,records);updated=refresh_robe(original,ext)
            self.assertEqual(refresh_robe(updated,ext),updated)
            after=read_objects(updated,ext)['custom']
            for before,changed in zip(records,after):
                text=changed['sets'][0]['mods'][0]['value']
                if before['id']=='othr':self.assertEqual(changed,before)
                else:
                    self.assertIn('6 Staff proficiency',text);self.assertIn('+30%',text)
                    expected=copy.deepcopy(before);expected['sets'][0]['mods'][0]['value']=text
                    self.assertEqual(changed,expected)

    def fixture(self):
        main=data('w3q',[obj('R004',[mod('glvl',10,0)])])
        skin=data('w3q',[obj('R004',[mod('gar1','Staff.blp',10),mod('gub1','Life power.|n|n|cffffcc00Required level|r: 99',10)])])
        units=data('w3u',[obj('h00N',[mod('ures','R004')],'hhou')])
        return catalogue(main,skin,units)

    def test_max_icons_are_zero_effect_passives_with_original_art_and_description(self):
        entries=self.fixture();original=data('w3a',[]);updated=objects(original,entries)
        self.assertEqual(objects(updated,entries),updated)
        record=read_objects(updated,'w3a')['custom'][0]
        f={m['field']:m['value'] for m in record['sets'][0]['mods']}
        self.assertEqual(record['base'],'AIev');self.assertEqual(f['Eev1'],0.)
        self.assertEqual(f['aite'],0);self.assertEqual(f['aart'],'Staff.blp')
        self.assertEqual(f['aub1'],'Life power.');self.assertIn('Maximum level 10',f['atp1'])

    def test_house_uses_real_owner_cap_and_current_house_type_only(self):
        s=(ROOT/'src/triggers/08 World and travel/House.j').read_text()
        entries=self.fixture();s=house_runtime(s,entries);self.assertEqual(house_runtime(s,entries),s)
        additions=[];removals=[];rank=[9];kind=['h00N']
        env=mocks(s);env.update(udg_PlayerHouse={1:'house'},GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:0,
            GetUnitTypeId=lambda u:kind[0],GetPlayerTechCount=lambda *a:rank[0],
            UnitAddAbility=lambda *a:additions.append(a),UnitRemoveAbility=lambda *a:removals.append(a))
        e=execute(s,['ProfHouse_Refresh'],env)
        e['ProfHouse_Refresh']('house');self.assertFalse(additions);self.assertEqual(len(removals),1)
        rank[0]=10;e['ProfHouse_Refresh']('house');self.assertEqual(len(additions),1)
        kind[0]='h006';e['ProfHouse_Refresh']('house');self.assertEqual(len(additions),1)
        kind[0]='h00N';e['ProfHouse_Refresh']('other');self.assertEqual(len(additions),1)
        self.assertNotIn('GetLocalPlayer',s)
        for event in ['SELECTED','RESEARCH_FINISH','SPELL_FINISH']:self.assertIn('EVENT_PLAYER_UNIT_'+event,s)
        self.assertNotIn('TimerStart',s)

    def test_fifth_page_reads_effective_levels_for_inspected_hero(self):
        for prefix in ['Stats','Forsaken']:
            rows=[];queries=[];s=stat_helper(prefix,prefix+'_Row')
            env=mocks(s);env.update({prefix+'_Row':lambda *a:rows.append(a),
                'Prof_GetLevel':lambda u,r:queries.append((u,r)) or 17,'I2S':str,
                'GetOwningPlayer':lambda u:2,'GetPlayerTechCount':lambda *a:10})
            e=execute(s,[prefix+'_RenderProficiencies'],env);e[prefix+'_RenderProficiencies']('inspected')
            self.assertEqual(len(rows),15);self.assertEqual(len(queries),14)
            self.assertTrue(all(u=='inspected' for u,r in queries));self.assertNotIn('R00I',[r for u,r in queries]);self.assertNotIn('Heavens Forged Axe',[label for _,label,_ in rows])
            self.assertEqual(dict((l,v) for i,l,v in rows)['Staff'],'17')
            self.assertEqual(dict((l,v) for i,l,v in rows)['Axe'],'10')

    def test_hunt_wanted_state_is_shared_but_visibility_is_local_presentation(self):
        s=(ROOT/'src/triggers/07 Hunts and encounters/Hunt_Board.j').read_text()
        s=refresh_hunt(s,native=True);self.assertEqual(refresh_hunt(s,native=True),s)
        writes=[];env=mocks(s);env.update(udg_HuntLeaderboard='hunt',LeaderboardDisplay=lambda *a:writes.append(a),HuntBoardWanted=False)
        e=execute(s,['HuntBoard_Display'],env)
        e['HuntBoard_Display'](True,'hunt');self.assertTrue(e['HuntBoardWanted'])
        e['HuntBoard_Display'](False,'hunt');self.assertFalse(e['HuntBoardWanted'])
        original=(ROOT/'src/triggers/07 Hunts and encounters/Hunt_Contracts.j').read_text()
        self.assertEqual(refresh_hunt(original),original)
        native=refresh_hunt(original,native=True);self.assertNotIn('call LeaderboardDisplayBJ(',native)


if __name__=='__main__':unittest.main()

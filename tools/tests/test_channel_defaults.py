"""Preserve authored Channel values and prevent runtime text writes during casts."""
import copy
from pathlib import Path
import sys,unittest
sys.path[:0]=[str(Path(__file__).resolve().parents[1])]
from channel_defaults import complete
from objdata import read_objects,write_objects
from priest_master import fields
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]


class ChannelDefaultsTests(unittest.TestCase):
    def test_sparse_rank_defaults_are_explicit_and_authored_channels_are_preserved(self):
        mods=[dict(field=k,type=t,level=r,data=d,value=v,end=0) for k,t,r,d,v in [
            ('alev',0,0,0,11),('Ncl1',2,1,1,0.),('Ncl1',2,4,1,2.),
            ('Ncl5',0,1,5,0),('Ncl5',0,8,5,1),('Ncl6',3,1,6,'roar')]]
        obj=dict(base='ANcl',id='test',sets=[dict(flag=0,mods=mods)])
        table=dict(version=2,original=[],custom=[obj])
        original=copy.deepcopy(obj);blob=write_objects(table,2,'w3a');out,_=complete(blob)
        self.assertEqual(complete(out)[0],out)
        result=read_objects(out,'w3a')['custom'][0];f=fields(result)
        for st in original['sets']:
            for m in st['mods']:self.assertIn(m,result['sets'][0]['mods'])
        for rank in range(1,12):
            self.assertEqual(f['Ncl1',rank],0. if rank<4 else 2.)
            self.assertEqual(f['Ncl5',rank],0 if rank<8 else 1)
            self.assertEqual(f['Ncl6',rank],'roar')
        self.assertNotIn(('Ncl2',1),f) # No guessed base values.

    def test_skin_override_is_used_for_later_inherited_ranks(self):
        def blob(mods):return write_objects(dict(version=2,original=[],custom=[dict(base='ANcl',id='test',sets=[dict(flag=0,mods=mods)])]),2,'w3a')
        def mod(field,level,value):return dict(field=field,type=2 if isinstance(value,float) else 0,level=level,data=1 if field=='Ncl1' else 0,value=value,end=0)
        main=blob([mod('alev',0,6),mod('Ncl1',1,0.)]);skin=blob([mod('Ncl1',3,9.)])
        a,b=complete(main,skin)
        for out in [a,b]:self.assertEqual(fields(read_objects(out,'w3a')['custom'][0])['Ncl1',6],9.)
        self.assertEqual(complete(a,b),(a,b))

    def test_actual_reported_master_spells_have_explicit_completion_fields(self):
        from mpq import MPQ
        p=ROOT/'editor/FFERPG-Editor-Master.w3x'
        if not p.exists():p=next((ROOT/'release').glob('*stageATV.w3x'))
        arc=MPQ(str(p));main,skin=complete(arc.read('war3map.w3a'),arc.read('war3mapSkin.w3a'))
        table={o['id']:o for o in read_objects(main,'w3a')['custom']}
        for raw in ['A0QS','A147','A146','A148','A12Y','A00A','A149','A11R','A0SL','A0QO','A14L']:
            f=fields(table[raw]);rank=int(f.get(('alev',0),1))
            self.assertIn(('Ncl1',rank),f,raw)
            if rank==1:
                self.assertLessEqual(f['Ncl1',rank],.5,raw)
                continue
            self.assertIn(('Ncl5',rank),f,raw)
            self.assertEqual(f['Ncl1',rank],0.,raw)
            self.assertEqual(f['Ncl5',rank],0,raw)

    def test_nonchannel_abilities_are_unchanged(self):
        from mpq import MPQ
        p=ROOT/'editor/FFERPG-Editor-Master.w3x'
        if not p.exists():p=next((ROOT/'release').glob('*stageATV.w3x'))
        source=MPQ(str(p)).read('war3map.w3a');out,_=complete(source)
        old=read_objects(source,'w3a');new=read_objects(out,'w3a')
        for group in ['original','custom']:
            for a,b in zip(old[group],new[group]):
                if a['base']!='ANcl':self.assertEqual(a,b)

    def test_tooltip_writes_wait_for_cast_end_and_ignore_other_spell_end_events(self):
        s=(ROOT/'experiments/Forsaken/SpellCalculations.j').read_text();memo={};writes=[];spell=['A147']
        env=mocks(s);env.update(SpellCalcCasting='casts',SpellCalcData='data',SpellCalcLast='cache',GetHandleId=lambda u:u,
            GetTriggerUnit=lambda:'hero',GetSpellAbilityId=lambda:spell[0],GetLocalPlayer=lambda:0,Player_GetHero=lambda p:'hero',
            SaveInteger=lambda h,p,c,v:memo.__setitem__((h,p,c),v),LoadInteger=lambda h,p,c:memo.get((h,p,c),0),
            RemoveSavedInteger=lambda h,p,c:memo.pop((h,p,c),None),HaveSavedInteger=lambda h,p,c:(h,p,c) in memo,
            SpellCalcCount=1,SpellCalcRaw={0:'A147'},GetUnitAbilityLevel=lambda *a:6,
            SpellCalc_Tooltip=lambda *a:'Neo Bahamut',PriestTooltipOffset=0,StringHash=hash,StringLength=len,
            BlzSetAbilityExtendedTooltip=lambda *a:writes.append(a))
        e=execute(s,['SpellCalc_CastBegin','SpellCalc_CastEnd','SpellCalc_Update'],env)
        e['SpellCalc_CastBegin']();e['SpellCalc_Update']();self.assertEqual(writes,[])
        spell[0]='other';e['SpellCalc_CastEnd']();e['SpellCalc_Update']();self.assertEqual(writes,[])
        spell[0]='A147';e['SpellCalc_CastEnd']();e['SpellCalc_Update']();self.assertEqual(len(writes),1)
        self.assertNotIn('GetLocalPlayer',s.split('function SpellCalc_Register',1)[1])


if __name__=='__main__':unittest.main()

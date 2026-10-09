"""Original hero progression and ability recovery with failure/readback tests."""
import itertools
import unittest

from test_save_jass import engine, SOURCE
from test_save_life import LIFE
from test_save_native import NATIVE
from test_save_position import JOURNAL, EFFECTS, POSITION, SPACER, Handle
from test_save_equipment import EQUIPMENT, RING_FILLER
from test_save_recovery import RECOVERY
from test_save_progression_journal import PROGRESSION, DECLARATIONS, ProgressionWorld
import test_save_progression_journal as progression_tests

HEROES=SOURCE.with_name('Forsaken-save-heroes.j')
EXTRA='''
globals
    unit array udg_PlayerHero
    unit array udg_FreelancerHero
    unit array udg_SpiritOfGaya
endglobals
'''


class HeroWorld(ProgressionWorld):
    def __init__(self):
        super().__init__()
        self.unit_writes=[]
        self.reject_unit=0
        self.unit_callback=None
        self.clamp_level=False
        self.stale=None

    def hero(self,raw,owner=0,bag=0):
        unit=self.unit(owner,bag)
        unit.update(raw=raw,is_hero=True,xp=2017,level=21,points=4,
                    strength=41,agility=27,intelligence=33,bonuses=(3,4,5),
                    ranks={'A02F':3,'AAA1':2},ability_handles={},cooldown=19.)
        unit['ability_handles']={raw:Handle(raw=raw) for raw in unit['ranks']}
        return unit

    def add_ability(self,unit,raw,rank=1):
        unit['ranks'][raw]=rank
        unit['ability_handles'][raw]=Handle(raw=raw)

    def permit(self,kind,unit):
        self.unit_writes.append((kind,id(unit)))
        if self.unit_callback: self.unit_callback()
        return len(self.unit_writes)!=self.reject_unit

    def xp(self,unit,value,show):
        if self.permit('xp',unit):
            # XP can raise a level; it deliberately does not lower one here.
            level=max(unit['level'],value//100+1)
            delta=level-unit['level']
            unit.update(xp=value,level=level+int(self.clamp_level),points=unit['points']+delta,
                        strength=unit['strength']+delta*2,agility=unit['agility']+delta,
                        intelligence=unit['intelligence']+delta)

    def strip(self,unit,levels):
        if self.permit('strip',unit):
            unit.update(level=unit['level']-levels,xp=(unit['level']-levels-1)*100,
                        points=max(0,unit['points']-levels),
                        strength=unit['strength']-levels*2,agility=unit['agility']-levels,
                        intelligence=unit['intelligence']-levels)
        return True

    def rank(self,unit,raw,value):
        if self.permit('rank',unit) and raw in unit['ranks']:
            unit['ranks'][raw]=value
            unit['cooldown']=0.
        return value  # Deliberately not proof that the setter worked.

    def attribute(self,unit,name,value,permanent):
        if self.permit(name,unit): unit[name]=value

    def points(self,unit,delta):
        if self.permit('points',unit): unit['points']+=delta
        return True

    def remove_ability(self,unit,raw):
        if self.permit('remove',unit):
            unit['ranks'].pop(raw,None)
            unit['ability_handles'].pop(raw,None)
        return True

    def by_index(self,unit,index):
        if self.stale is not None and index==0: return self.stale
        values=list(unit['ability_handles'].values())
        return values[index] if index<len(values) else None

    def natives(self):
        env=super().natives()
        env.update(PLAYER_NEUTRAL_PASSIVE=15,UNIT_TYPE_HERO='hero',
            IsUnitType=lambda u,t:u['is_hero'],GetHeroSkillPoints=lambda u:u['points'],
            GetHeroStr=lambda u,b:u['strength']+(u['bonuses'][0] if b else 0),
            GetHeroAgi=lambda u,b:u['agility']+(u['bonuses'][1] if b else 0),
            GetHeroInt=lambda u,b:u['intelligence']+(u['bonuses'][2] if b else 0),
            GetUnitAbilityLevel=lambda u,r:u['ranks'].get(r,0),
            BlzGetUnitAbility=lambda u,r:u['ability_handles'].get(r),
            BlzGetUnitAbilityByIndex=self.by_index,
            SetHeroXP=self.xp,UnitStripHeroLevel=self.strip,SetUnitAbilityLevel=self.rank,UnitModifySkillPoints=self.points,
            SetHeroStr=lambda u,v,p:self.attribute(u,'strength',v,p),
            SetHeroAgi=lambda u,v,p:self.attribute(u,'agility',v,p),
            SetHeroInt=lambda u,v,p:self.attribute(u,'intelligence',v,p),
            UnitRemoveAbility=self.remove_ability)
        return env


class HeroTests(unittest.TestCase):
    def setUp(self):
        template=progression_tests.ProgressionTests('test_read_only_capture_and_exact_recovery')
        template.setUp()
        self.w=HeroWorld()
        self.w.resources=template.w.resources
        self.w.techs=template.w.techs
        self.e=engine(DECLARATIONS+EXTRA+'\n'.join(p.read_text() for p in
            [LIFE,NATIVE,JOURNAL,EFFECTS,POSITION,EQUIPMENT,RECOVERY,PROGRESSION,HEROES]),self.w.natives())
        self.e.update({k:v for k,v in template.e.items() if k.startswith('udg_')})
        self.hero=self.w.hero('H000',bag=30)
        self.gaya=self.w.hero('H01D')
        self.free=self.w.hero('H02L',15)
        self.house=self.w.unit(9)
        self.table={}
        for raw in ('A0B4','A02K','A02L','A10F'): self.w.add_ability(self.gaya,raw,2)
        self.units=[self.hero,self.free,self.gaya]
        self.install(0)

    def install(self,pid):
        self.hero['owner']=pid
        self.gaya['owner']=pid
        self.e['udg_PlayerHero'][pid+1]=self.hero
        self.e['udg_SpiritOfGaya'][pid+1]=self.gaya
        self.e['udg_FreelancerHero'][pid+1]=self.free
        self.e['udg_JobHeroHash']['H000',pid]=self.hero

    def capture(self,pid=0):
        self.assertTrue(self.e['FSJ_Capture'](pid,self.hero,self.gaya,self.house,True))
        self.assertTrue(self.e['FQR_Begin'](pid,self.table))
        self.assertTrue(self.e['FPG_Begin'](pid))
        return self.e['FHU_Begin'](pid)

    def mutate(self):
        for unit in self.units:
            unit.update(xp=7717,level=78,points=999,strength=777,agility=777,intelligence=777)
            for raw in unit['ranks']: unit['ranks'][raw]+=1

    def recover_all(self,pid=0):
        self.assertTrue(self.e['FHU_Recover'](pid))
        self.assertTrue(self.e['FPG_Recover'](pid))
        self.assertTrue(self.e['FQR_Recover'](pid,SPACER,RING_FILLER,30))

    def test_exact_progression_and_alias_recovery(self):
        self.assertTrue(self.capture())
        self.assertEqual(self.w.unit_writes,[])
        self.assertEqual(self.e['FHU_Alias'][24],0)
        self.mutate()
        self.assertFalse(self.e['FPG_Recover'](0))
        self.recover_all()
        self.assertTrue(self.e['FHU_Verify'](0,True))
        self.assertEqual(sum(kind=='xp' for kind,_ in self.w.unit_writes),3)
        self.assertIs(self.e['FHU_Unit'][24],self.hero)

    def test_added_gaya_support_abilities_are_removed(self):
        self.assertTrue(self.capture())
        for raw in ('A058','S004','A07E'): self.w.add_ability(self.gaya,raw)
        self.mutate()
        self.assertTrue(self.e['FHU_Recover'](0))
        self.assertTrue(self.e['FHU_Verify'](0,True))
        self.assertFalse(any(raw in self.gaya['ranks'] for raw in ('A058','S004','A07E')))

    def test_every_native_setter_failure_is_retained_and_retryable(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.assertTrue(self.e['FHU_Recover'](0))
        count=len(self.w.unit_writes)
        self.assertEqual(count,28)
        for fault in range(1,count+1):
            with self.subTest(fault=fault):
                self.mutate()
                self.w.unit_writes=[]
                self.w.reject_unit=fault
                self.assertFalse(self.e['FHU_Recover'](0))
                self.assertEqual(self.e['FHU_State'][0],3)
                self.assertTrue(self.e['FSN_HeroBlocked'][0])
                self.assertTrue(self.e['FSJ_HeroPending'][0])
                self.assertFalse(self.e['FSN_Begin'](0))
                self.assertFalse(self.e['FSJ_Release'](0))
                self.w.reject_unit=0
                self.assertTrue(self.e['FHU_Recover'](0))

    def test_each_added_ability_removal_failure_blocks(self):
        self.assertTrue(self.capture())
        for fault in range(15,18):  # Two two-ability heroes require 7 writes each.
            for raw in ('A058','S004','A07E'): self.w.add_ability(self.gaya,raw)
            self.w.unit_writes=[]
            self.w.reject_unit=fault
            self.assertFalse(self.e['FHU_Recover'](0))
            self.assertIn(('A058','S004','A07E')[fault-15],self.gaya['ranks'])
            self.w.reject_unit=0
            self.assertTrue(self.e['FHU_Recover'](0))

    def test_missing_original_ability_refuses_before_any_setters(self):
        self.assertTrue(self.capture())
        self.gaya['ability_handles'].pop('A0B4')
        self.gaya['ranks'].pop('A0B4')
        self.assertFalse(self.e['FHU_Recover'](0))
        self.assertEqual(self.w.unit_writes,[])

    def test_replaced_original_ability_refuses(self):
        self.assertTrue(self.capture())
        self.gaya['ability_handles']['A0B4']=Handle(raw='A0B4')
        self.assertFalse(self.e['FHU_Recover'](0))
        self.assertEqual(self.w.unit_writes,[])

    def test_unit_owner_raw_and_reference_changes_refuse(self):
        self.assertTrue(self.capture())
        for unit in self.units:
            for key in ('owner','raw','is_hero'):
                old=unit[key]
                unit[key]=1 if key=='owner' else 'XXXX' if key=='raw' else False
                self.assertFalse(self.e['FHU_Recover'](0))
                unit[key]=old
        self.e['udg_FreelancerHero'][1]=self.w.hero('H02L',15)
        self.assertFalse(self.e['FHU_Recover'](0))
        self.assertEqual(self.w.unit_writes,[])

    def test_derived_totals_are_required_for_release(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.recover_all()
        self.hero['bonuses']=(999,4,5)
        self.assertTrue(self.e['FHU_Verify'](0,False))
        self.assertFalse(self.e['FHU_Verify'](0,True))
        self.assertFalse(self.e['FHU_Release'](0))
        self.assertTrue(self.e['FSN_HeroBlocked'][0])
        self.hero['bonuses']=(3,4,5)
        self.assertTrue(self.e['FHU_Release'](0))

    def test_all25_units40_abilities_player7_max_array_and_release(self):
        self.install(7)
        self.units=[]
        for slot in range(22):
            unit=self.w.hero(self.e['FPG_JobRaw'](slot),15)
            self.e['udg_JobHeroHash'][unit['raw'],7]=unit
            self.units.append(unit)
        self.units+=[self.free,self.gaya,self.hero]
        for unit in self.units:
            for i in range(40-len(unit['ranks'])): self.w.add_ability(unit,'B%03d'%i)
        self.assertTrue(self.capture(7))
        self.assertEqual(max(self.e['FHU_Ability']),7999)
        self.mutate()
        self.recover_all(7)
        self.assertTrue(self.e['FHU_Release'](7))
        self.assertTrue(all(a is None for a in self.e['FHU_Ability'].values()))
        self.assertTrue(all(u is None for u in self.e['FHU_Unit'].values()))
        self.assertIsNone(self.e['FHU_Table'][7])

    def test_ability_overflow_refuses_and_clears_partial_refs(self):
        for i in range(39): self.w.add_ability(self.gaya,'B%03d'%i)
        self.assertFalse(self.capture())
        self.assertFalse(self.e['FSJ_HeroPending'][0])
        self.assertTrue(all(a is None for a in self.e['FHU_Ability'].values()))

    def test_duplicate_and_zero_ability_ids_refuse_capture(self):
        for raw in ('A02F',0):
            self.setUp()
            self.hero['ability_handles']['AAA1']['raw']=raw
            self.assertFalse(self.capture())
            self.assertEqual(self.w.unit_writes,[])

    def test_invalid_xp_skillpoints_and_nonhero_refuse(self):
        for key,value in [('xp',-1),('level',0),('points',-1),('is_hero',False)]:
            self.setUp()
            self.gaya[key]=value
            self.assertFalse(self.capture())

    def test_xp_level_mismatch_blocks_without_guessing_xp(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.w.clamp_level=True
        self.assertFalse(self.e['FHU_Recover'](0))
        self.assertEqual(self.w.unit_writes,[('strip',id(self.hero)),('xp',id(self.hero))])
        self.w.clamp_level=False
        self.assertTrue(self.e['FHU_Recover'](0))

    def test_cached_neutral_hero_and_neutral_freelancer(self):
        inactive=self.w.hero('H003',15)
        self.e['udg_JobHeroHash']['H003',0]=inactive
        self.units.append(inactive)
        self.assertTrue(self.capture())
        self.mutate()
        self.recover_all()
        self.assertEqual(inactive['owner'],15)
        self.assertEqual(self.free['owner'],15)

    def test_reentrant_operations_are_blocked(self):
        self.assertTrue(self.capture())
        self.mutate()
        def callback():
            for name in ('FHU_Begin','FHU_Recover','FHU_Release','FPG_Recover','FPG_Release','FSN_Begin','FSJ_Release'):
                self.assertFalse(self.e[name](0))
            self.assertFalse(self.e['FQR_Recover'](0,SPACER,RING_FILLER,30))
        self.w.unit_callback=callback
        self.assertTrue(self.e['FHU_Recover'](0))

    def test_all_three_journal_release_orders_preserve_other_guards(self):
        for order in itertools.permutations(('FHU','FPG','FQR')):
            self.setUp()
            self.assertTrue(self.capture())
            self.mutate()
            self.recover_all()
            for index,prefix in enumerate(order):
                self.assertTrue(self.e[prefix+'_Release'](0),order)
                self.assertEqual(self.e['FSN_Begin'](0),index==2,order)
                if index<2: self.assertFalse(self.e['FSJ_Release'](0))
            self.assertTrue(self.e['FSJ_Release'](0))

    def test_item_recovery_failure_prevents_hero_release(self):
        item=self.w.create(1100,0.,0.)
        item['owned']=True
        self.hero['quick'][0]=item
        self.assertTrue(self.capture())
        self.assertTrue(self.e['FQR_Quarantine'](0))
        self.mutate()
        self.assertTrue(self.e['FHU_Recover'](0))
        self.assertTrue(self.e['FPG_Recover'](0))
        self.w.reject_add=1
        self.assertFalse(self.e['FQR_Recover'](0,SPACER,RING_FILLER,30))
        self.assertFalse(self.e['FHU_Release'](0))
        self.w.reject_add=0
        self.assertTrue(self.e['FQR_Recover'](0,SPACER,RING_FILLER,30))
        self.assertTrue(self.e['FHU_Release'](0))

    def test_cooldown_refresh_is_allowed(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.recover_all()
        self.assertEqual(self.hero['cooldown'],0.)
        self.assertTrue(self.e['FHU_Release'](0))

    def test_invalid_players_busy_and_recapture_refuse(self):
        for pid in (-1,8,8192):
            for name in ('FHU_Begin','FHU_Recover','FHU_Release'):
                self.assertFalse(self.e[name](pid))
            self.assertFalse(self.e['FHU_Verify'](pid,True))
        self.assertTrue(self.capture())
        self.assertFalse(self.e['FHU_Begin'](0))
        self.e['FSN_Busy'][0]=True
        self.assertFalse(self.e['FHU_Recover'](0))

    def test_stale_enumerator_removal_is_bounded(self):
        self.assertTrue(self.capture())
        self.w.stale=Handle(raw='NEWW')
        self.assertFalse(self.e['FHU_Recover'](0))
        self.assertEqual(len(self.w.unit_writes),40)
        self.assertTrue(all(kind=='remove' for kind,_ in self.w.unit_writes))

    def test_native_ability_order_can_change(self):
        self.assertTrue(self.capture())
        for unit in self.units: unit['ability_handles']=dict(reversed(list(unit['ability_handles'].items())))
        self.mutate()
        self.recover_all()
        self.assertTrue(self.e['FHU_Verify'](0,True))

    def test_absent_freelancer_stays_absent(self):
        self.e['udg_FreelancerHero'][1]=None
        self.units.remove(self.free)
        self.assertTrue(self.capture())
        self.mutate()
        self.recover_all()
        self.assertIsNone(self.e['udg_FreelancerHero'][1])

    def test_foreign_cached_owner_and_unsupported_active_type_refuse(self):
        foreign=self.w.hero('H003',1)
        self.e['udg_JobHeroHash']['H003',0]=foreign
        self.assertFalse(self.capture())
        self.setUp()
        self.e['udg_JobHeroHash'].pop(('H000',0))
        self.hero['raw']='XXXX'
        self.assertFalse(self.capture())
        self.assertEqual(self.w.unit_writes,[])

    def test_later_skillpoint_change_requires_recovery_again(self):
        self.assertTrue(self.capture())
        self.mutate()
        self.recover_all()
        self.gaya['points']+=1
        self.assertFalse(self.e['FHU_Release'](0))
        self.assertTrue(self.e['FSJ_HeroPending'][0])
        self.assertTrue(self.e['FHU_Recover'](0))
        self.assertTrue(self.e['FHU_Release'](0))

    def test_lower_level_restores_upward_from_exact_xp(self):
        self.assertTrue(self.capture())
        for unit in self.units:
            unit.update(xp=17,level=1,points=0,strength=1,agility=1,intelligence=1)
            for raw in unit['ranks']: unit['ranks'][raw]=1
        self.recover_all()
        self.assertTrue(self.e['FHU_Verify'](0,True))
        self.assertFalse(any(kind=='strip' for kind,_ in self.w.unit_writes))

    def test_freelancer_cache_identity_is_checked(self):
        self.e['udg_JobHeroHash']['H02L',0]=self.free
        self.assertTrue(self.capture())
        self.e['udg_JobHeroHash']['H02L',0]=self.w.hero('H02L',15)
        self.assertFalse(self.e['FHU_Recover'](0))
        self.assertEqual(self.w.unit_writes,[])
        self.e['udg_JobHeroHash']['H02L',0]=self.free
        self.assertTrue(self.e['FHU_Recover'](0))
        self.setUp()
        self.e['udg_JobHeroHash']['H02L',0]=self.w.hero('H02L',15)
        self.assertFalse(self.capture())

    def test_source_has_crlf_and_no_recreation_or_cooldown_requirement(self):
        data=HEROES.read_bytes()
        self.assertNotIn(b'\n',data.replace(b'\r\n',b''))
        text=data.decode()
        for native in ('CreateUnit','RemoveUnit','UnitAddAbility','SetHeroLevel','BlzGetUnitAbilityCooldownRemaining'):
            self.assertNotIn(native+'(',text)
        self.assertNotIn('initializer',text)


if __name__=='__main__': unittest.main()

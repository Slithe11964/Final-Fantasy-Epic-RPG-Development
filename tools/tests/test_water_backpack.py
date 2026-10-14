"""Execute the classic water wave: carried items, cone hits and resource cleanup."""
import math
import unittest
from pathlib import Path
from unittest.mock import patch
import test_quest_lifecycle as harness

SOURCE=Path(__file__).resolve().parents[2]/'src/triggers/04 Combat and abilities/Spell_Water.j'

class WaterBackpackTests(unittest.TestCase):
    def run_wave(self,carrier,targeted,raw,visual=False):
        cache={};timers=[];destroyed=[];damage=[];moves=[];models=[]
        positions={'hero':(0.,0.),'page':(0.,0.),'gaya':(0.,0.),
            'ground':(200.,0.),'flying':(400.,50.),'building':(650.,0.),
            'outside':(400.,500.),'ally':(300.,0.),'immune':(250.,0.),'dead':(350.,0.)}
        targets=set(positions)-{'hero','page','gaya'}
        current={'clock':None}
        def save(table,key,field,value):cache[key,field]=value
        def timer():
            t='clock'+str(len(timers));timers.append(t);return t
        def enum(group,x,y,r,filter):group.update(targets)
        env=dict(GetTriggerUnit=lambda:carrier,GetOwningPlayer=lambda u:0,GetPlayerId=lambda p:p,Player=lambda p:p,
            Player_GetHero=lambda p:'hero',Backpack_PageOf=lambda p,u:2 if u=='page' else -1,
            GetSpellAbilityId=lambda:raw,Abil_GetLevel=lambda u,r:1,
            BlzGetAbilityManaCost=lambda r,l:400 if r=='A0Q2' else 500,
            GetSpellTargetUnit=lambda:'ground' if targeted else None,GetSpellTargetLoc=lambda:(800.,0.),
            GetUnitX=lambda u:positions.get(u,(0.,0.))[0],GetUnitY=lambda u:positions.get(u,(0.,0.))[1],
            GetLocationX=lambda p:p[0],GetLocationY=lambda p:p[1],RemoveLocation=lambda p:None,
            GetUnitFacing=lambda u:0.,Atan2=math.atan2,Cos=math.cos,Sin=math.sin,bj_DEGTORAD=math.pi/180.,bj_RADTODEG=180./math.pi,
            RMaxBJ=max,RMinBJ=min,RAbsBJ=abs,I2R=float,
            GetHeroInt=lambda u,b:100 if u=='hero' else 50,
            IsUnitType=lambda u,t:u in ('hero','gaya') if t=='hero-type' else u=='immune',
            UNIT_TYPE_HERO='hero-type',UNIT_TYPE_MAGIC_IMMUNE='immune-type',
            Prof_RodPower=lambda u:1.25 if u=='hero' else 1.,
            ATTACK_TYPE_NORMAL='normal',DAMAGE_TYPE_MAGIC='magic',
            CreateTimer=timer,GetExpiredTimer=lambda:current['clock'],GetHandleId=lambda h:h,
            CreateUnit=lambda *a:'wave-unit',AddSpecialEffectTarget=lambda model,u,attach:models.append(model) or 'effect',
            SetUnitFlyHeight=lambda *a:None,SetUnitX=lambda u,x:moves.append(('x',x)),SetUnitY=lambda u,y:None,
            SaveUnitHandle=save,SaveReal=save,SaveEffectHandle=save,SaveGroupHandle=save,SaveInteger=save,
            LoadUnitHandle=lambda h,k,i:cache.get((k,i)),LoadReal=lambda h,k,i:cache.get((k,i),0.),
            LoadInteger=lambda h,k,i:cache.get((k,i),0),LoadEffectHandle=lambda h,k,i:cache.get((k,i)),
            LoadGroupHandle=lambda h,k,i:cache.get((k,i)),WaterWaves='waves',
            WaterActive=[0]*8,WaterHitCount=[0]*8,WaterStarted=[0]*8,
            CreateGroup=set,GroupEnumUnitsInRange=enum,FirstOfGroup=lambda g:next(iter(g),None),
            GroupRemoveUnit=lambda g,u:g.remove(u),GroupAddUnit=lambda g,u:g.add(u),IsUnitInGroup=lambda u,g:u in g,
            IsUnitEnemy=lambda u,p:u!='ally',GetWidgetLife=lambda u:0. if u=='dead' else 100.,
            IsUnitHidden=lambda u:False,BlzIsUnitInvulnerable=lambda u:False,BlzGetUnitCollisionSize=lambda u:16.,
            GetUnitTypeId=lambda u:1,UnitDamageTarget=lambda *a:damage.append(a),TimerStart=lambda *a:None,
            DestroyEffect=lambda v:destroyed.append(('effect',v)),DestroyGroup=lambda v:destroyed.append(('group',v)),
            RemoveUnit=lambda v:destroyed.append(('unit',v)),DestroyTimer=lambda v:destroyed.append(('timer',v)),
            FlushChildHashtable=lambda h,k:[cache.pop(e) for e in list(cache) if e[0]==k])
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(SOURCE.read_text(),['Water_Touches','Water_Tick','Water_Launch','Trig_Spell_Water_Actions'],env)
        if visual:e['Water_Launch']('hero',0.,0.,0.,0.)
        else:e['Trig_Spell_Water_Actions']()
        current['clock']=timers[-1]
        for tick in range(25):e['Water_Tick']()
        source='hero' if carrier=='page' else carrier
        if visual:self.assertEqual(damage,[])
        else:
            power=(400 if raw=='A0Q2' else 500)*5+(600 if source=='hero' else 300)
            power*=1.25 if source=='hero' else 1.
            self.assertEqual({a[1] for a in damage},{'ground','flying','building'})
            self.assertEqual(len(damage),3)
            self.assertTrue(all(a[0]==source and a[2]==power and a[5:7]==('normal','magic') for a in damage))
        self.assertEqual(moves[-1],('x',800.))
        self.assertIn('CrushingWaveMissile.mdl',models[0])
        self.assertFalse(cache)
        self.assertEqual([k for k,v in destroyed].count('group'),2)
        for kind in ('unit','effect','timer'):self.assertEqual([k for k,v in destroyed].count(kind),1)
        self.assertEqual(e['WaterActive'][0],0)

    def test_both_items_on_hero_page_and_gaya_hit_once_and_clean_up(self):
        for raw in ('A0Q2','A08X'):
            for carrier in ('hero','page','gaya'):
                for targeted in (False,True):
                    with self.subTest(raw=raw,carrier=carrier,targeted=targeted):self.run_wave(carrier,targeted,raw)

    def test_visual_check_deals_no_damage(self):self.run_wave('hero',False,'A0Q2',True)

    def test_cone_sweep_has_no_gaps_or_hits_beyond_end(self):
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(SOURCE.read_text(),['Water_Touches'],dict(RMaxBJ=max,RMinBJ=min,RAbsBJ=abs))
        touch=e['Water_Touches']
        for along in range(801):
            previous=min(792,(along//33)*33)
            self.assertTrue(touch(along,0.,0.,previous,min(800.,previous+33.)))
        self.assertTrue(touch(400.,199.,0.,396.,429.))
        self.assertFalse(touch(400.,201.,0.,396.,429.))
        self.assertFalse(touch(900.,0.,0.,792.,800.))
        self.assertFalse(touch(-50.,0.,0.,0.,33.))

if __name__=='__main__':unittest.main()

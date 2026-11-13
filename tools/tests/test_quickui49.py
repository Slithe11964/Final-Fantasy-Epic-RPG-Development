"""Native item forwarding, bag previews, packaged balance and Aqualung pulses."""
import sys
import unittest
from pathlib import Path
from collections import defaultdict

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import test_quickui48 as previous
from test_armory_materia import execute
from test_shared_context import mocks
from jtok import functions
from performance_runtime import put
from editor_pair import View
from damage_tooltips import merged
from priest_master import fields

ROOT=Path(__file__).resolve().parents[2]
NATIVE=(ROOT/'experiments/Forsaken/NativeGearButtons.j').read_text()
AQUA=(ROOT/'experiments/Forsaken/AqualungPulses.j').read_text()


class NativeGearTests(unittest.TestCase):
    def runtime(self):
        result=previous.QuickUI48Tests().runtime()
        env,state,worn,data,calls,packets,visible,textures=result
        source=previous.gear_tests.SOURCE
        for name,body in functions(NATIVE).items():
            if name in functions(source):source=put(source,name,body)
            else:source+='\n'+body+'\n'
        native_clicks=[];ui_keys=[]
        env.update(GearNative=defaultdict(lambda:None,{0:'native-primary',1:'native-offhand'}),
            GearWaiting=-1,GearWaitingHero=None,GearWaitingItem=None,GearWaitingUntil=0.,GearFrameData='frame-data',
            BlzFrameGetEnable=lambda frame:True,BlzFrameClick=native_clicks.append,ForceUIKey=ui_keys.append,LoadStr=lambda *args:'')
        visible.update({'native-primary':True,'native-offhand':True})
        result=(execute(source,list(functions(source)),env),state,worn,data,calls,packets,visible,textures,native_clicks,ui_keys)
        return result

    def test_f_and_g_forward_native_clicks_without_synthetic_item_orders_or_cursor(self):
        e,s,w,db,calls,packets,v,textures,clicked,keys=self.runtime()
        s['key']='F';e['QuickGear_Input']()
        s['key']='G';e['QuickGear_Input']()
        self.assertEqual(clicked,['native-primary','native-offhand'])
        self.assertEqual(calls,[]);self.assertEqual(packets,[]);self.assertEqual(keys,[])
        self.assertFalse(e['QuickGearTargetPreview'])

    def test_closed_panel_request_binds_then_revalidates_equipped_item(self):
        e,s,w,db,calls,packets,v,textures,clicked,keys=self.runtime()
        v['native-primary']=False;v['native-offhand']=False
        e['QuickGear_Request'](1)
        self.assertEqual(keys,['B']);self.assertEqual(e['GearWaiting'],1)
        w[1]='replacement';v['native-offhand']=True
        e['QuickGear_Poll']()
        self.assertEqual(clicked,[]);self.assertEqual(e['GearWaiting'],-1)

    def test_native_bag_click_arms_wave_runes_before_mouse_movement(self):
        e,s,w,db,calls,packets,v,textures,clicked,keys=self.runtime()
        e['BlzUnitItemInBagSlot']=lambda hero,index:'weapon'
        db[0,55]=100;db[2,201]=1
        e['Gear_FrameClick']()
        self.assertEqual(e['QuickGearPath'],1)
        self.assertTrue(e['QuickGearNativePreview'])
        positions=[];e['SetImagePosition']=lambda *args:positions.append(args)
        s['event']='move';e['QuickGear_Mouse']()
        self.assertEqual(len(positions),96)

    def test_packaged_values_and_native_controls(self):
        view=View(ROOT/'release/development/QuickUI49/FFERPG-QuickUI49-Forsaken.w3x')
        fs=functions(view.runtime)
        self.assertIn('GetUnitX(target)+5.*dx/d',fs['DG_Impact'])
        self.assertIn('1.+.05*I2R(Prof_GetLevel',fs['Cuts_Damage'])
        self.assertIn('BlzFrameClick(control)',fs['Gear_ClickNative'])
        self.assertNotIn('QuickGear_Send',fs['QuickGear_Request'])
        self.assertNotIn('QuickGearTarget.tga',fs['QuickGear_Init'])
        self.assertNotIn('BlzCreateSimpleFrame',fs['QuickGear_Init'])
        a=merged(view.object_bytes('war3map.w3a'),view.object_bytes('war3mapSkin.w3a'),'w3a')
        for rank in range(1,7):
            self.assertIn('1 + 5% x Dagger proficiency',fields(a['A0KY'])['aub1',rank])
        for raw in ('A1AB','A0SN','A0WB'):
            self.assertIn('(MP cost + INT) x Rod spell power',fields(a[raw])['aub1',1])
        u=merged(view.object_bytes('war3map.w3u'),view.object_bytes('war3mapSkin.w3u'),'w3u')
        self.assertTrue(fields(u['H00C'])['utub',None].endswith('|cff8040ffTier 5 Strength Warrior|r'))
        self.assertIn('call Aqua_Pulse(clock)',fs['Trig_Aqualung_Cast_Actions'])


class AqualungPulseTests(unittest.TestCase):
    def test_eight_visible_water_pulses_filter_targets_and_release_the_timer(self):
        data={};hits=[];effects=[];destroyed=[];timers=[]
        env=mocks(AQUA)
        save=lambda table,parent,child,value:data.__setitem__((parent,child),value)
        env.update(AquaData='aqua',GetTriggerUnit=lambda:1,GetSpellTargetUnit=lambda:None,
            GetSpellTargetX=lambda:500.,GetSpellTargetY=lambda:600.,GetSpellAbilityId=lambda:1,
            Abil_GetLevel=lambda *args:0,BlzGetAbilityManaCost=lambda *args:600,
            GetHeroInt=lambda *args:100,Prof_RodPower=lambda *args:1.5,I2R=float,
            CreateTimer=lambda:99,GetHandleId=lambda handle:handle,GetExpiredTimer=lambda:99,
            TimerStart=lambda *args:timers.append(args),PauseTimer=lambda *args:None,DestroyTimer=destroyed.append,
            SaveUnitHandle=save,SaveReal=save,SaveInteger=save,
            LoadUnitHandle=lambda t,p,c:data.get((p,c)),LoadReal=lambda t,p,c:data.get((p,c),0.),LoadInteger=lambda t,p,c:data.get((p,c),0),
            FlushChildHashtable=lambda t,p:data.clear(),CreateGroup=lambda:[],
            GroupEnumUnitsInRange=lambda group,*args:group.extend([2,3,4,5,6,7]),
            FirstOfGroup=lambda group:group[0] if group else None,GroupRemoveUnit=lambda group,u:group.remove(u),DestroyGroup=lambda *args:None,
            GetUnitTypeId=lambda u:1,GetOwningPlayer=lambda u:0,IsUnitEnemy=lambda u,p:u!=3,
            GetWidgetLife=lambda u:0. if u==4 else 1000.,IsUnitHidden=lambda u:u==6,
            BlzIsUnitInvulnerable=lambda u:u==5,UNIT_TYPE_MAGIC_IMMUNE=2,UNIT_TYPE_HERO=1,
            IsUnitType=lambda u,kind:(u==1 if kind==1 else u==7),
            ATTACK_TYPE_NORMAL=1,DAMAGE_TYPE_MAGIC=2,
            AddSpecialEffect=lambda *args:effects.append(args),DestroyEffect=lambda *args:None,
            UnitDamageTarget=lambda caster,target,amount,*args:hits.append((caster,target,amount)),
            udg_DamageElement=0,udg_IsPhysicalAttack=True)
        e=execute(AQUA,list(functions(AQUA)),env)
        e['Trig_Aqualung_Cast_Actions']()
        for _ in range(7):e['Aqua_Tick']()
        self.assertEqual(hits,[(1,2,1050.)]*8)
        self.assertEqual(len(effects),8)
        self.assertTrue(all(effect[1:]==(500.,600.) for effect in effects))
        self.assertEqual((e['udg_DamageElement'],e['udg_IsPhysicalAttack']),(4,False))
        self.assertEqual(destroyed,[99]);self.assertFalse(data)


if __name__=='__main__':unittest.main()

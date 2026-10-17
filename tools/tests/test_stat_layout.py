"""Execute ordered stat pages and verify percentage units, conditional rows and Defend."""
from collections import defaultdict
from pathlib import Path
import sys,unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from stat_layout import refresh,native_navigation
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]


class StatLayoutTests(unittest.TestCase):
    def profiles(self):
        # The native export deliberately excludes the classic inventory/stat module.
        # The classic gate and authoring tree exercise both; the native gate exercises its profile.
        return (False,True) if (ROOT/'src/triggers/09 Player features/HeroStats.j').exists() else (True,)

    def runtime(self,native=False,abilities=None):
        if native:
            s=(ROOT/'experiments/Forsaken/Forsaken-stats.j').read_text().replace(
                'function Forsaken_RenderStats takes','function Forsaken_RenderStatsUncached takes')
        else:s=(ROOT/'src/triggers/09 Player features/HeroStats.j').read_text()
        s=refresh(s,native=native);p='Forsaken' if native else 'Stats'
        row='Forsaken_StatRow' if native else 'Stats_Row'
        getter='Forsaken_StatAbilityLevel' if native else 'GetUnitAbilityLevel'
        fn='Forsaken_RenderStatsUncached' if native else 'Stats_Fill'
        values={};abilities=abilities if abilities is not None else {}
        env=mocks(s)
        env.update({getter:lambda u,a:abilities.get(a,0),row:lambda r,l,v:values.__setitem__(r,(l,v)),
            'I2S':str,'R2SW':lambda n,w,d:format(n,'.%df'%d),
            'GetOwningPlayer':lambda u:0,'GetPlayerId':lambda p:0,'Player_GetHero':lambda p:'hero',
            'Element_GetOfUnit':lambda *a:4,'BlzGetUnitArmor':lambda u:30.,
            'GetUnitMoveSpeed':lambda u:300.,'GetUnitState':lambda *a:1000.,
            'UNIT_STATE_LIFE':'hp','UNIT_STATE_MAX_LIFE':'maxhp',
            'ForsakenHeroHPRegen':{1:20.},'ForsakenHeroMPRegen':{1:3.},
            'ForsakenStatsHeading':'heading','ForsakenConditionPage':False,'ForsakenStatsPage':0,'STATS_ROWS':16,
            'udg_MagicDefense':{1:75},'Unit_HasNoEquipment':lambda u:True,
            'GetWidgetLife':lambda u:0.,'Forsaken_ElementAbilityLevel':lambda *a:0})
        env['ForsakenStatName' if native else 'StatsElementName']=dict(enumerate(['Fire','Ice','Thunder','Water','Earth','Wind']))
        for helper,value in [('Stat_GetEvasion',45.),('StatArmorDefense',20.),('StatEffectiveDefense',20.),
                ('DefensePercent',60.),('StatOutgoing',10.),('StatAttackSpeed',120.),('StatAccuracy',99.),
                ('StatHealingReceived',0.),('StatCooldown',10.),('StatDefenseMultiplier',1.)]:
            env[p+'_'+helper]=lambda *a,v=value:v
        env[p+'_StatBlock']=lambda u,physical:25. if physical else 0.
        env[p+'_StatHealing']=lambda u,mana:100. if mana else 50.
        env[p+'_StatResistance']=lambda u,element:'resistance'+str(element)
        env[p+'_StatElementText']=lambda u,element:'damage'+str(element)
        env[p+'_StatGun']=lambda u:False
        env[p+'_TwoHandedWeapon']=lambda u:None
        env[p+'_RenderJob']=lambda u,page,row:row
        names=[fn,p+'_StatElementAt',p+'_StatSignedPercent',p+'_StatPercent',p+'_StatPenalty']
        e=execute(s,names,env)
        def fill(page):
            values.clear()
            if native:e['ForsakenStatsPage']=page;e[fn]('hero')
            else:e[fn]('hero',page)
            return [values[i] for i in sorted(values) if values[i][0]]
        return s,e,fill

    def test_both_clients_have_requested_base_order(self):
        for native in self.profiles():
            s,e,fill=self.runtime(native)
            rows=fill(0);labels=[l.replace('|cff00ff00','').replace('|r','') for l,v in rows]
            self.assertEqual(labels[:10],['Accuracy','Attack speed','Physical Damage','Magical Damage',
                'Fire damage','Ice damage','Water damage','Thunder damage','Wind damage','Earth damage'])
            self.assertEqual([v for l,v in rows[4:10]],['damage1','damage2','damage4','damage3','damage6','damage5'])
            rows=fill(1)
            self.assertEqual([l for l,v in rows],['Evasion','Armor','Armor Defense %','Magic Defense',
                'Magic Defense %','Physical Block','Magical Block'])
            for label in ('Armor Defense %','Magic Defense %','Physical Block','Magical Block'):
                self.assertTrue(dict(rows)[label].endswith('%'))
            self.assertEqual(dict(rows)['Magical Block'],'0.00%')
            rows=fill(2)
            self.assertEqual([l for l,v in rows[:8]],['Fire resistance','Ice resistance','Water resistance',
                'Thunder resistance','Wind resistance','Earth resistance','Non-elemental','Random absorption'])
            self.assertEqual([v for l,v in rows[:6]],['resistance1','resistance2','resistance4','resistance3','resistance6','resistance5'])
            rows=fill(3)
            self.assertEqual([l for l,v in rows[:7]],['Health regen','Health healing efficiency','Healing received',
                'Mana Regen','Mana efficiency','Move speed','Cooldown reduction'])
            self.assertEqual(dict(rows)['Health healing efficiency'],'+50.00%')
            self.assertEqual(dict(rows)['Mana efficiency'],'+100.00%')
            self.assertEqual(refresh(s,native=native),s)

    def test_flat_damage_hidden_at_zero_and_shown_for_actual_guard(self):
        for native in self.profiles():
            abilities={};s,e,fill=self.runtime(native,abilities)
            self.assertNotIn('Flat damage',dict(fill(1)))
            abilities['A0RU']=1;self.assertEqual(dict(fill(1))['Flat damage'],'10')
            abilities['A0RV']=1;self.assertEqual(dict(fill(1))['Flat damage'],'25')

    def test_signed_efficiency_keeps_percent_and_does_not_add_plus_to_zero_or_negative(self):
        for native in self.profiles():
            s,e,fill=self.runtime(native);p='Forsaken' if native else 'Stats'
            self.assertEqual(e[p+'_StatSignedPercent'](0.),'0.00%')
            self.assertEqual(e[p+'_StatSignedPercent'](-25.),'-25.00%')
            self.assertEqual(e[p+'_StatSignedPercent'](25.),'+25.00%')

    def test_short_percentage_values_get_enough_native_width(self):
        s,e,fill=self.runtime(True);sizes=[]
        env=mocks(s);env.update(ForsakenStatLabel=defaultdict(lambda:'label'),ForsakenStatValue=defaultdict(lambda:'value'),
            StringLength=len,SubString=lambda s,a,b:s[a:b],BlzFrameSetSize=lambda *a:sizes.append(a))
        ui=execute(s,['Forsaken_StatRow'],env)
        for text in ('0.00%','100.00%','+20%'):
            sizes.clear();ui['Forsaken_StatRow'](0,'Physical Block',text)
            self.assertIn(('value',.05,.0105),sizes)

    def test_defend_uses_hold_position_and_never_sentinel_for_thirty_percent(self):
        template=(ROOT/'experiments/Forsaken/JobStats.j').read_text()
        for p,getter in [('Stats','GetUnitAbilityLevel'),('Forsaken','Forsaken_StatAbilityLevel')]:
            s=template.replace('JSTAT',p).replace('JGET',getter).replace('JROW',p+'_Row')
            active={'A0PP':1};holding=[False];rows=[]
            env=mocks(s);env.update({getter:lambda u,a:active.get(a,0),p+'_Row':lambda *a:rows.append(a),
                'udg_DefendingUnits':'holding','IsUnitInGroup':lambda u,g:holding[0],
                'R2SW':lambda n,w,d:format(n,'.%df'%d)})
            e=execute(s,[p+'_RenderJob'],env)
            e[p+'_RenderJob']('hero',1,7);self.assertEqual(rows,[(7,'Defend physical block','20%')])
            rows.clear();active['B04M']=1;e[p+'_RenderJob']('hero',1,7)
            self.assertEqual(rows,[(7,'Defend physical block','20%')])
            rows.clear();holding[0]=True;e[p+'_RenderJob']('hero',1,7)
            self.assertEqual(rows,[(7,'Defend physical block','30%')])

    def test_five_page_native_navigation_is_reversible_including_condition_overflow(self):
        s=(ROOT/'experiments/Forsaken/Forsaken-panels.j').read_text();s=native_navigation(s)
        self.assertEqual(native_navigation(s),s)
        count=[5];draws=[];env=mocks(s)
        env.update(ForsakenStatsPage=0,ForsakenConditionPage=False,ModuloInteger=lambda a,b:a%b,
            Forsaken_ConditionCount=lambda u:count[0],Forsaken_RenderStats=lambda u:draws.append(u))
        e=execute(s,['Forsaken_ChangeStats'],env);step=e['Forsaken_ChangeStats']
        expected=[(1,False),(2,False),(2,True),(3,False),(4,False),(0,False)]
        for page,conditions in expected:
            step('hero',1);self.assertEqual((e['ForsakenStatsPage'],e['ForsakenConditionPage']),(page,conditions))
        for page,conditions in [(4,False),(3,False),(2,True),(2,False),(1,False),(0,False)]:
            step('hero',-1);self.assertEqual((e['ForsakenStatsPage'],e['ForsakenConditionPage']),(page,conditions))
        count[0]=4;e['ForsakenStatsPage']=2;step('hero',1)
        self.assertEqual(e['ForsakenStatsPage'],3);step('hero',-1)
        self.assertEqual((e['ForsakenStatsPage'],e['ForsakenConditionPage']),(2,False))
        self.assertNotIn('BlzSendSyncData',functions(s)['Forsaken_ChangeStats'])


if __name__=='__main__':unittest.main()

"""Owned bag observer invariants; mocks do not prove native hover/click delivery."""
import sys, unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from jtok import functions,tokens
from historical_map import historical_map
from editor_pair import View
from test_armory_materia import execute
from test_backpack_sync import unsafe_paths
ROOT=Path(__file__).resolve().parents[2]
SOURCE=(ROOT/'experiments/Forsaken/GearProbe62.j').read_text()
PAIRS=[('QuickUI61/FFERPG-QuickUI61-Forsaken','QuickUI62/FFERPG-QuickUI62-Forsaken'),
       ('VersionEHotfix09/FFERPG-0.9.7.5e-Hotfix09-Forsaken','VersionEHotfix10/FFERPG-0.9.7.5e-Hotfix10-Forsaken')]

class ProbeTests(unittest.TestCase):
    def runtime(self):
        state=dict(down=False,open=True,active=True,slot=7,hero='hero',raw=123)
        events=[];arms=[]
        env=dict(GearProbe62=dict(enumerate(range(100,130))),GearProbeSlots62='slots',
            GearProbeCurrent62=-1,GearProbeCast62=0,GearProbeRaw62=0,GearProbeHero62=None,
            GearProbeDown62=False,GearProbeShown62=False,GearProbeBag62=None,
            GearProbeWidth62=0.,GearProbeHeight62=0.,GearProbeEnters62=0,GearProbeArms62=0,
            ForsakenLinkedBag='bag',QuickGearChatOpen=False,InventoryCinematicActive=False,
            GearInputSpells='spells',QuickGearData='gear',QuickGearPending=1,NativeCDClock='clock',
            GetLocalPlayer=lambda:0,GetTriggerPlayer=lambda:0,
            Player_GetHero=lambda p:state['hero'],IsUnitSelected=lambda *a:True,
            BlzGetTriggerFrame=lambda:100+state['slot'],GetHandleId=lambda f:f,
            LoadInteger=lambda t,k,v: v-99 if t=='slots' else (456 if v==123 else 0),
            BlzUnitItemInBagSlot=lambda h,s:state['raw'],GetItemTypeId=lambda i:i,
            GearWave_ModeFor=lambda c:1 if c==456 else 0,
            BlzFrameSetEnable=lambda *a:events.append(('enable',)+a),
            BlzFrameSetVisible=lambda *a:events.append(('visible',)+a),
            BlzFrameClearAllPoints=lambda *a:None,BlzFrameSetPoint=lambda *a:None,
            BlzFrameSetSize=lambda *a:None,BlzFrameGetWidth=lambda f:.3,
            BlzFrameGetHeight=lambda f:.25,BlzFrameIsVisible=lambda f:state['open'],
            BlzIsLocalClientActive=lambda:state['active'],
            BlzIsMouseButtonPressed=lambda b:state['down'],MOUSE_BUTTON_TYPE_LEFT='left',
            FRAMEPOINT_TOPLEFT='top',RMaxBJ=max,I2R=float,ModuloInteger=lambda a,b:a%b,
            TimerGetElapsed=lambda c:10.,QuickGear_ClearPreview=lambda:events.append(('clear',)),
            GearWave_Arm=arms.append)
        return execute(SOURCE,['GearProbe_World62','GearProbe_Enter62','GearProbe_Poll62'],env),state,events,arms

    def test_hover_releases_native_click_and_only_arms_on_left_edge(self):
        e,s,events,arms=self.runtime();e['GearProbe_Poll62']();events.clear()
        e['GearProbe_Enter62']();self.assertEqual(events[0],('enable',107,False))
        self.assertEqual(arms,[])
        s['down']=True;e['GearProbe_Poll62']();e['GearProbe_Poll62']()
        self.assertEqual(arms,[456]);self.assertEqual(e['QuickGearPending'],-1)
        self.assertEqual(e['GearProbeArms62'],1)

    def test_changed_item_hero_closed_bag_or_inactive_client_cannot_arm(self):
        for changed in [dict(raw=999),dict(hero='other'),dict(open=False),dict(active=False)]:
            e,s,events,arms=self.runtime();e['GearProbe_Poll62']();e['GearProbe_Enter62']()
            s.update(changed);s['down']=True;e['GearProbe_Poll62']()
            self.assertEqual(arms,[],changed)

    def test_two_clients_divergent_hover_has_no_shared_gameplay_effects(self):
        a,sa,ea,aa=self.runtime();b,sb,eb,ab=self.runtime()
        a['GearProbe_Poll62']();a['GearProbe_Enter62']();sa['down']=True;a['GearProbe_Poll62']()
        sb['open']=False;b['GearProbe_Poll62']()
        self.assertEqual(aa,[456]);self.assertEqual(ab,[])
        sa['down']=False;a['GearProbe_World62']()
        self.assertEqual(a['GearProbeCurrent62'],-1);self.assertEqual(aa,[456])
        self.assertEqual(b['GearProbeEnters62'],0)

    def test_shared_probe_init_has_fixed_allocation_order(self):
        orders=[]
        for local_state in (False,True):
            log=[]
            env=dict(GearProbe62={},GearProbeSlots62='slots',ORIGIN_FRAME_GAME_UI=0,
                FRAMEEVENT_MOUSE_ENTER=1,BlzGetOriginFrame=lambda *a:'root',
                CreateTrigger=lambda:'trigger',TriggerAddAction=lambda *a:None,
                GearProbe_Enter62=lambda:None,
                BlzCreateFrameByType=lambda *a:log.append(a) or 100+len(log),
                BlzFrameSetAlpha=lambda *a:None,BlzFrameSetLevel=lambda *a:None,
                BlzFrameSetVisible=lambda *a:None,SaveInteger=lambda *a:None,
                GetHandleId=lambda x:x,BlzTriggerRegisterFrameEvent=lambda *a:None,
                BlzIsLocalClientActive=lambda:local_state)
            e=execute(SOURCE,['GearProbe_Init62'],env);e['GearProbe_Init62']()
            self.assertEqual(len(log),30);orders.append(log)
        self.assertEqual(*orders)

    def test_packaged_local_call_graph_and_preserved_functions(self):
        for old,new in PAIRS:
            before=View(historical_map(ROOT, old))
            after=View(historical_map(ROOT, new))
            a,b=functions(before.runtime),functions(after.runtime)
            roots=['GearProbe_Enter62','GearProbe_Poll62','GearProbe_World62',
                'GearCursor_Draw60','GearInput_Cursor','GearCursor_Error60','GearWave_Draw',
                'QuickGear_PaintIcon','QuickGear_RepaintIcons','QuickGear_RefreshIcons']
            self.assertEqual(unsafe_paths(b,roots),[])
            for name in ('QuickGear_Request','QuickGear_Receive','QuickGear_PaintIcon',
                'QuickGear_RepaintIcons','QuickGear_RefreshIcons','QuickGear_Draw',
                'GearInput_Cursor','GearWave_Arm','GearWave_Draw','Cine_Exit','Text_Caption'):
                self.assertEqual(tokens(a[name]),tokens(b[name]),name)
            expected=a['QuickGear_Mouse'].replace('        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()',
                '        call GearProbe_World62()\n        set QuickGearMouseX=BlzGetTriggerPlayerMouseX()',1)
            self.assertEqual(tokens(expected),tokens(b['QuickGear_Mouse']))
            for name,body in b.items():
                if name.startswith('GearBag_'):
                    self.assertNotIn('BlzFrame',body)
            self.assertEqual(before.archive.read('GearTarget61.tga'),after.archive.read('GearTarget61.tga'))
            for suffix in ('w3a','w3u','w3t'):
                for prefix in ('war3map.','war3mapSkin.'):
                    self.assertEqual(before.archive.read(prefix+suffix),after.archive.read(prefix+suffix))
            fdf=after.archive.read('GearError62.fdf').decode()
            self.assertIn('IGNORETRACKEVENTS',fdf);self.assertIn('.024',fdf)
            self.assertIn('"|cffffcc00"+message+"|r"',b['GearCursor_Error60'])
            self.assertIn('BlzPixelToFrameY',b['GearCursor_Error60'])
            self.assertIn('GearCursorError60,true',b['GearInput_Init'])

if __name__=='__main__':unittest.main()

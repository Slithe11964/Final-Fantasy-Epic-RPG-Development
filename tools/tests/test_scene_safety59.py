"""Portrait-free dialogue keeps timing and story/combat logic unchanged."""
import sys,unittest
from pathlib import Path
from collections import defaultdict
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from scene_safety59 import refresh
from jtok import functions,tokens
from editor_pair import View
from test_armory_materia import execute
ROOT=Path(__file__).resolve().parents[2]


class SceneSafetyTests(unittest.TestCase):
    def runtime(self):
        source=refresh((ROOT/'src/triggers/09 Player features/Text.j').read_text())
        captions=[];waits=[];portraits=[]
        env=dict(udg_TextSpeed=240.,udg_TextSpeedFast=300.,udg_CinematicSkipped=False,
            bj_lastTransmissionDuration=0.,bj_TRANSMISSION_PORT_HANGTIME=1.5,
            udg_PlayerName=defaultdict(lambda:'Player'),GetPlayerController=lambda p:'computer',
            MAP_CONTROL_USER='user',GetOwningPlayer=lambda u:11,GetPlayerId=lambda p:p,
            IsUnitType=lambda *a:True,UNIT_TYPE_HERO=1,GetHeroProperName=lambda u:'Gilgamesh',
            GetUnitName=lambda u:'Meliadoul',StringLength=len,RMaxBJ=max,I2R=float,
            StartSound=lambda s:None,GetSoundDuration=lambda s:4000,
            GetPlayersAll=lambda:'all',DisplayTimedTextToForce=lambda *a:captions.append(a),
            TriggerSleepAction=waits.append,SetCinematicScene=lambda *a:portraits.append(a))
        return execute(source,['Text_Caption','Text_CaptionSay','Text_Transmission'],env),captions,waits,portraits

    def test_caption_preserves_name_duration_and_wait_without_portrait(self):
        env,captions,waits,portraits=self.runtime()
        env['Text_Caption']('boss',None,'Gilgamesh fights again!',None,None,2.5,False)
        self.assertEqual(captions,[('all',4.,'|cffffcc00Gilgamesh:|r Gilgamesh fights again!')])
        self.assertEqual(waits,[2.5]);self.assertEqual(portraits,[])

    def test_narrator_never_requests_rawcode_zero_portrait(self):
        env,captions,waits,portraits=self.runtime()
        env['Text_Transmission'](None,'Meliadoul','For our families!',None,None,1.25,False)
        self.assertEqual(len(captions),1);self.assertEqual(waits,[1.25]);self.assertEqual(portraits,[])

    def test_skip_and_forced_lines_keep_their_existing_rules(self):
        env,captions,waits,portraits=self.runtime();env['udg_CinematicSkipped']=True
        env['Text_Caption'](None,'Narrator','skip me',None,None,1.,False)
        self.assertEqual(captions,[]);self.assertEqual(waits,[])
        env['Text_Caption'](None,'Narrator','forced line',None,None,1.,True)
        self.assertEqual(len(captions),1);self.assertEqual(waits,[1.]);self.assertEqual(portraits,[])

    def test_packaged_changes_are_only_caption_calls_and_scene_cleanup(self):
        for before_path,after_path in [
            ('VersionEHotfix06/FFERPG-0.9.7.5e-Hotfix06-Forsaken','VersionEHotfix07/FFERPG-0.9.7.5e-Hotfix07-Forsaken'),
            ('QuickUI58/FFERPG-QuickUI58-Forsaken','QuickUI59/FFERPG-QuickUI59-Forsaken')]:
            suffix = '.unpacked.w3x' if before_path.startswith(('VersionEHotfix06/', 'QuickUI58/')) else '.w3x'
            before=View(ROOT/f'release/development/{before_path}{suffix}')
            after_suffix = '.unpacked.w3x' if after_path.startswith('QuickUI59/') else '.w3x'
            after=View(ROOT/f'release/development/{after_path}{after_suffix}')
            a,b=functions(before.runtime),functions(after.runtime)
            self.assertEqual(a.keys()-b.keys(),set())
            self.assertEqual(b.keys()-a.keys(),{'Text_Caption','Text_CaptionSay'})
            for name,body in a.items():
                if name=='Text_Transmission':continue
                if name=='Cine_Exit':
                    self.assertLess(b[name].index('call EndCinematicScene()'),b[name].index('call ShowInterface(true'))
                    self.assertEqual(tokens(body),tokens(b[name].replace('    call EndCinematicScene()\n','',1)))
                else:
                    expected=body
                    if name.startswith(('Trig_KalmSiege1_','Trig_KalmSiege2_','Trig_KalmSiege3_','Trig_Boss_Gilgamesh_')):
                        expected=body.replace('call Text_Transmission(','call Text_Caption(').replace('call Text_Say(','call Text_CaptionSay(')
                    self.assertEqual(tokens(expected),tokens(b[name]),name)
            self.assertNotIn('SetCinematicScene',b['Text_Caption'])
            self.assertNotIn('SetCinematicScene(0,',b['Text_Transmission'])
            for resource in ('war3map.w3a','war3mapSkin.w3a','war3map.w3u','war3mapSkin.w3u','war3map.w3t','war3mapSkin.w3t'):
                self.assertEqual(before.archive.read(resource),after.archive.read(resource),resource)


if __name__=='__main__':unittest.main()

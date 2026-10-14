"""Autosave must use the file-save capture path and never run the legacy writer."""
from collections import defaultdict
from pathlib import Path
from unittest.mock import patch
import unittest
import test_quest_lifecycle as harness

ROOT=Path(__file__).resolve().parents[2]

class AutosaveRouteTests(unittest.TestCase):
    def engine(self):
        self.started=[];self.paths=[];self.messages=[];self.enabled=[]
        env=dict(udg_AutosaveNextPlayer=0,udg_AutosavePlayerCount=10,udg_PlayingPlayers={0},udg_AutosaveForce={0},
            Save_UseNewAutosave=True,Save_AutosavePid=0,Player=lambda p:p,
            IsPlayerInForce=lambda p,f:p in f,FFL_Phase=defaultdict(int),FFP_Locked=defaultdict(bool),
            FFL_SaveFile=defaultdict(bool),FST_LegacySaveMessages=defaultdict(bool),udg_HardcoreOff=True,
            FSC_PlayerValid=lambda p:0<=p<8,FRC_StartNow=lambda p:self.started.append(p) or True,
            FST_SetFileStem=lambda p,s:self.paths.append((p,s)) or True,FST_PlayerPath=lambda p,n:'./FFERPG/autosave.txt',
            SubString=lambda s,a,b:s[a:b],StringLength=len,FFL_Message=lambda p,s:self.messages.append(s),
            DisplayTimedTextToPlayer=lambda p,x,y,t,s:self.messages.append(s),
            udg_TitleForce=defaultdict(set,{14:{0}}),udg_NewGamePlusLevel=defaultdict(int),udg_CheaterForce=set(),
            udg_NewGamePlusTrig='newgameplus',EnableTrigger=lambda t:self.enabled.append(t))
        def legacy(*args):raise AssertionError('Legacy autosave touched the character')
        env['Save_WriteCode']=legacy
        source=(ROOT/'src/triggers/09 Player features/Save.j').read_text(encoding='utf-8')+'\n'+(ROOT/'experiments/Forsaken/Forsaken-fresh-load.j').read_text(encoding='utf-8')
        with patch.object(harness,'SELECTED',[]):
            e=harness.load_engine(source,['Save_Autosave','FFL_Autosave','FFL_BeginSave','FFL_NotifyNewGamePlus'],env)
        e['ExecuteFunc']=lambda name:e[name]()
        return e

    def test_timer_uses_same_capture_and_file_mode_as_savef(self):
        e=self.engine();e['Save_Autosave']()
        self.assertEqual(self.started,[0]);self.assertEqual(self.paths,[(0,'autosave')])
        self.assertEqual(e['FFL_Phase'][0],1)
        self.assertTrue(e['FFL_SaveFile'][0]);self.assertTrue(e['FST_LegacySaveMessages'][0])
        self.assertEqual(e['udg_AutosaveNextPlayer'],1)

    def test_busy_locked_hardcore_and_opted_out_players_are_skipped(self):
        for gate in ('busy','locked','hardcore','opted_out'):
            e=self.engine()
            if gate=='busy':e['FFL_Phase'][0]=2
            elif gate=='locked':e['FFP_Locked'][0]=True
            elif gate=='hardcore':e['udg_HardcoreOff']=False
            else:e['udg_AutosaveForce'].clear()
            e['Save_Autosave']()
            self.assertEqual(self.started,[],gate);self.assertEqual(self.paths,[],gate)

    def test_newgameplus_notice_uses_existing_unlock_cap_and_cheater_rules(self):
        e=self.engine();e['FFL_NotifyNewGamePlus'](0)
        self.assertEqual(self.enabled,['newgameplus'])
        self.assertTrue(any('-newgameplus' in s for s in self.messages))
        self.messages.clear();self.enabled.clear();e['udg_NewGamePlusLevel'][1]=10
        e['FFL_NotifyNewGamePlus'](0);self.assertEqual(self.messages,[])
        e['udg_NewGamePlusLevel'][1]=0;e['udg_CheaterForce'].add(0)
        e['FFL_NotifyNewGamePlus'](0);self.assertEqual(self.enabled,[])

if __name__=='__main__':unittest.main()

"""All notification styles retain real text; Seeker spawning loses only teleport."""
import re,sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from editor_pair import View
from jtok import functions,tokens
from quests74 import refresh,helper
from test_armory_materia import execute
from test_shared_context import mocks
ROOT=Path(__file__).resolve().parents[2]

class Quests74Tests(unittest.TestCase):
    def runtime(self,viewer=1):
        source=helper();env=mocks(source);text=[];sound=[];flash=[]
        for n in re.findall(r'\bbj_\w+',source):env[n]=n
        env.update(GetLocalPlayer=lambda:viewer,IsPlayerInForce=lambda p,f:p in f,
            DisplayTimedTextToPlayer=lambda p,x,y,t,s:text.append(s),StartSound=sound.append,
            FlashQuestDialogButton=lambda:flash.append(True))
        e=execute(source,['QuestText_Message'],env)
        return e,text,sound,flash

    def test_all_thirteen_styles_have_real_text_only(self):
        styles=set(re.findall(r'messageType == (bj_QUESTMESSAGE_\w+)',helper()))
        self.assertEqual(len(styles),13)
        for style in styles:
            e,text,sound,flash=self.runtime()
            e['QuestText_Message']({1},style,'Bring the Beastslayer to Jessie.')
            self.assertEqual(text,['Bring the Beastslayer to Jessie.'],style)
            self.assertEqual(len(sound),0 if style=='bj_QUESTMESSAGE_REQUIREMENT' else 1)
            self.assertEqual(bool(flash),style in ['bj_QUESTMESSAGE_DISCOVERED','bj_QUESTMESSAGE_UPDATED','bj_QUESTMESSAGE_COMPLETED','bj_QUESTMESSAGE_FAILED'])

    def test_empty_null_and_literal_null_do_not_render(self):
        e,text,sound,flash=self.runtime()
        for msg in [None,'',' ','(null)']:e['QuestText_Message']({1},'bj_QUESTMESSAGE_UPDATED',msg)
        self.assertEqual((text,sound,flash),([],[],[]))

    def test_force_visibility_stays_local_without_allocations(self):
        e,text,*_=self.runtime(viewer=2)
        e['QuestText_Message']({1},'bj_QUESTMESSAGE_UPDATED','Real text')
        self.assertEqual(text,[])
        self.assertNotRegex(helper(),r'\b(?:Create\w+|Destroy\w+|SetUnit\w+|UnitAdd\w+)\(')

    def test_all_current_map_notification_sites_are_replaced(self):
        v=View(ROOT/'release/development/VersionFHotfix04/FFERPG-0.9.7.5f-Hotfix04.w3x')
        count=0
        for name,source in v.modules.items():
            updated=refresh(source)
            self.assertNotIn('QuestMessageBJ(',updated,name)
            count+=source.count('QuestMessageBJ(')
        self.assertEqual(count,54)

    def test_three_seekers_spawn_and_patrol_without_teleport(self):
        old=(ROOT/'src/triggers/06 Quests and story/Quest_SeekDestroy.j').read_text()
        # Source may already have been migrated; use the preserved map as fixture.
        v=View(ROOT/'release/development/VersionFHotfix04/FFERPG-0.9.7.5f-Hotfix04.w3x')
        old=v.modules['TQuestSeekDestroy'];source=functions(refresh(old))['QuestSeekDestroy_Started']
        env=mocks(source);spawn=[];patrol=[]
        env.update(Quest_LogEntry=lambda q:'quest',QUEST_SEEK_DESTROY=1,udg_QuestReq={},udg_SpawnDataHashRef='data',udg_SpawnRectHashRef='rects',
            udg_SeekerLeaders='group',gg_trg_Seekers_TrackEngaged='engaged',gg_trg_Quest_SeekDestroy_Count='count',
            bj_UNIT_FACING=90.,bj_lastCreatedUnit='leader',GetRandomInt=lambda *a:1,Player=lambda p:p,
            CreateNUnitsAtLoc=lambda n,raw,*a:spawn.append(raw),
            IssuePointOrderLocBJ=lambda u,o,p:patrol.append(o),
            UnitAddAbilityBJ=lambda *a:self.fail('teleport added'))
        e=execute(source,['QuestSeekDestroy_Started'],env);e['QuestSeekDestroy_Started']()
        self.assertEqual(spawn,['n0CJ','n0CA','n0CI']);self.assertEqual(patrol,['patrol']*3)
        a=functions(old)['QuestSeekDestroy_Started']
        expected=re.sub(r"(?m)^\s*call UnitAddAbilityBJ\('A102',GetLastCreatedUnit\(\)\)[^\n]*\n",'\n',a)
        self.assertEqual(tokens(expected),tokens(source))

if __name__=='__main__':unittest.main()

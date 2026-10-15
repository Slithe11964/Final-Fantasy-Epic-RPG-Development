"""Ao Madoushi must unlock both side offers regardless of the old quest counter."""
from pathlib import Path
import unittest
from test_quest_lifecycle import load_engine

ROOT=Path(__file__).resolve().parents[2]


def runtime():
    source='\n'.join((ROOT/'src/triggers/06 Quests and story'/(name+'.j')).read_text()
                     for name in ('Quest_AoMadoushi','Quest_Phoenix','Quest_AnnoyingMonster'))
    destroyed=[]
    names=['Quest_Talk','Quest_MakeAvailable','QuestAoMadoushi_Start',
           'QuestPhoenix_Available','QuestAnnoyingMonster_Available',
           'Trig_Quest_Phoenix_Available_Actions']
    e=load_engine(source,names,dict(QUEST_AO_MADOUSHI=0,QUEST_PHOENIX=0,
        QUEST_ANNOYING_MONSTER=0,GetTriggeringTrigger=lambda:'milestone',
        DestroyTrigger=destroyed.append,AddSpecialEffectTarget=lambda *args:object()))
    # Keep real engine lifecycle and availability; the quest definitions' dialogue is immaterial here.
    def define(key,name,main):
        q=e['Quest_Define'](name,e['QUEST_MAIN'] if main else e['QUEST_SIDE'],4 if main else 36,'icon')
        e[key]=q
        e['Quest_NotStory'](q)
        if main:
            e['Quest_Custom'](q,'Find Ao Madoushi')
            e['Quest_Custom'](q,'Find the flute')
        else:
            e['Quest_Talk'](q,name,'Talk')
    e['QuestAoMadoushi_Define']=lambda:define('QUEST_AO_MADOUSHI','Ao Madoushi',True)
    e['QuestPhoenix_Define']=lambda:define('QUEST_PHOENIX','Phoenix',False)
    e['QuestAnnoyingMonster_Define']=lambda:define('QUEST_ANNOYING_MONSTER','Annoying Monster',False)
    return e,destroyed


class QuestUnlockTests(unittest.TestCase):
    def test_ao_madoushi_unlocks_both_even_if_the_six_count_milestone_was_missed(self):
        for count in (3,6,9):
            with self.subTest(count=count):
                e,destroyed=runtime()
                e['udg_StoryProgress']=count
                self.assertEqual(e['QUEST_PHOENIX'],0)
                self.assertEqual(e['QUEST_ANNOYING_MONSTER'],0)
                e['QuestAoMadoushi_Start']()
                for name in ('QUEST_PHOENIX','QUEST_ANNOYING_MONSTER'):
                    self.assertEqual(e['QuestState'][e[name]],e['QUEST_STATE_AVAILABLE'])
                    self.assertEqual(e['QuestCurrent'][e[name]],1)
                self.assertEqual(e['udg_StoryProgress'],count)
                self.assertEqual(destroyed,[])  # Never destroy Cid's caller trigger.

    def test_repeated_unlock_and_old_milestone_preserve_existing_quest_state(self):
        e,destroyed=runtime()
        e['QuestAoMadoushi_Start']()
        phoenix,monster=e['QUEST_PHOENIX'],e['QUEST_ANNOYING_MONSTER']
        e['QuestState'][phoenix]=e['QUEST_STATE_ACTIVE']
        e['QuestCurrent'][phoenix]=2
        e['QuestState'][monster]=e['QUEST_STATE_DONE']
        before=e['QuestCount']
        e['QuestAoMadoushi_Start']()
        e['Trig_Quest_Phoenix_Available_Actions']()
        e['QuestAnnoyingMonster_Available']()
        self.assertEqual(e['QuestCount'],before)
        self.assertEqual(e['QuestState'][phoenix],e['QUEST_STATE_ACTIVE'])
        self.assertEqual(e['QuestCurrent'][phoenix],2)
        self.assertEqual(e['QuestState'][monster],e['QUEST_STATE_DONE'])
        self.assertEqual(e['udg_QuestsCompleted'],0)
        self.assertEqual(destroyed,['milestone'])


if __name__=='__main__':unittest.main()

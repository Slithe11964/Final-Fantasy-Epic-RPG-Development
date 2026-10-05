"""Exercise actual talk/kill/delivery event code and failure resource cleanup.

Warcraft event dispatch and inventory natives are mocked; the engine's definitions,
registration, conditions, actions and lifecycle functions execute from its JASS source.
"""
from collections import defaultdict
import unittest
from test_quest_lifecycle import load_engine


class QuestEventTests(unittest.TestCase):
    def setUp(self):
        self.trigger = None
        self.hero = {'owner': 0, 'type': 'HERO', 'inventory': []}
        self.npc = {'owner': 15, 'hidden': False}
        self.triggers, self.destroyed, self.effects, self.removed = [], [], [], []
        self.nearby, self.cinematic = True, False
        def create_trigger():
            t = {'enabled': True, 'registrations': []}
            self.triggers.append(t)
            return t
        def register(t, *args):
            t['registrations'].append(args)
        def save(table, handle, key, value):
            table[(handle, key)] = value
        def flush(table, handle):
            for key in list(table):
                if key[0] == handle:
                    del table[key]
        def item_of(u, kind):
            return next((i for i in u['inventory'] if i['type'] == kind), None)
        def remove_item(item):
            self.hero['inventory'].remove(item)
            self.removed.append(item)
        def set_charges(item, value):
            item['charges'] = value
        env = {'udg_BossUnits': [], 'udg_TalkRange': 500., 'udg_InCinematicMode': False,
               'udg_PlayingPlayers': [0], 'udg_ActivePlayers': [0], 'UNIT_TYPE_HERO': 'hero',
               'EVENT_UNIT_DEATH': 'death', 'EVENT_PLAYER_UNIT_DEATH': 'death-any',
               'EVENT_PLAYER_UNIT_PICKUP_ITEM': 'pickup',
               'CreateTrigger': create_trigger, 'SaveInteger': save,
               'LoadInteger': lambda table, handle, key: table[(handle, key)],
               'FlushChildHashtable': flush,
               'DestroyTrigger': lambda t: self.destroyed.append(t),
               'DisableTrigger': lambda t: t.update(enabled=False),
               'DestroyEffect': lambda e: self.effects.append(e),
               'GroupRemoveUnit': lambda group, unit: group.remove(unit),
               'GroupAddUnit': lambda group, unit: group.append(unit),
               'GetTriggeringTrigger': lambda: self.trigger,
               'GetTriggerUnit': lambda: self.hero, 'GetTriggerPlayer': lambda: 0,
               'GetOwningPlayer': lambda u: u['owner'], 'Player_GetHero': lambda p: self.hero,
               'GetKillingUnitBJ': lambda: self.hero, 'GetUnitTypeId': lambda u: u['type'],
               'IsUnitType': lambda u, kind: u is self.hero,
               'IsPlayerInForce': lambda p, force: p in force,
               'IsUnitHidden': lambda u: u.get('hidden', False),
               'Unit_PlayersNearby': lambda *args: self.nearby,
               'UnitHasItemOfTypeBJ': lambda u, kind: item_of(u, kind) is not None,
               'GetItemOfTypeFromUnitBJ': item_of, 'GetItemCharges': lambda i: i['charges'],
               'SetItemCharges': set_charges, 'RemoveItem': remove_item,
               'IMinBJ': min, 'IMaxBJ': max, 'I2S': str,
               'CreateQuestItemBJ': lambda log, text: {'item_text': text},
               'DisplayTextToForce': lambda *args: None,
               'Player': lambda i: i, 'Condition': lambda fn: fn,
               'TriggerRegisterPlayerSelectionEventBJ': register,
               'TriggerRegisterUnitEvent': register,
               'TriggerRegisterUnitInRangeSimple': register,
               'TriggerRegisterAnyUnitEventBJ': register,
               'TriggerAddCondition': lambda *args: None, 'TriggerAddAction': lambda *args: None,
               'QuestEngine_PickupCondition': lambda: True, 'QuestEngine_PickupAction': lambda: None,
               'QuestEngine_PingTick': lambda: None}
        names = ['Quest_Talk', 'Quest_Kill', 'Quest_Deliver', 'Quest_OnPickup',
                 'QuestEngine_BeginStep', 'QuestEngine_BeginPending', 'QuestEngine_StepOf',
                 'QuestEngine_IsHero', 'QuestEngine_IsQuestHero', 'QuestEngine_StepCondition',
                 'QuestEngine_StepAction']
        self.e = load_engine(extra_names=names, extra_env=env)

    def define(self):
        e = self.e
        q = e['Quest_Define']('Event quest', e['QUEST_SIDE'], 61, 'icon')
        e['Quest_NotStory'](q); e['Quest_NoMarker'](q)
        e['Quest_Talk'](q, self.npc, 'Defeat target')
        e['Quest_Kill'](q, {'owner': 15}, 'Bring three items')
        e['Quest_Deliver'](q, self.npc, 'I000', 3, 'Items', '')
        return q

    def fire(self, q):
        e = self.e
        slot = q * e['QUEST_MAX_STEPS'] + e['Quest_CurrentStep'](q)
        self.trigger = e['QuestStepTrigger'][slot]
        allowed = e['QuestEngine_StepCondition']()
        if allowed:
            e['QuestEngine_StepAction']()
        return allowed

    def test_talk_kill_partial_delivery_then_complete_with_remaining_charges(self):
        e, q = self.e, self.define()
        e['Quest_Start'](q, 0, self.hero)
        self.assertEqual(len(self.triggers[0]['registrations']), 8)
        self.nearby = False
        self.assertFalse(self.fire(q))
        self.assertFalse(e['Quest_IsActive'](q))
        self.nearby = True
        self.assertTrue(self.fire(q))
        self.assertEqual(e['Quest_CurrentStep'](q), 2)
        self.assertTrue(e['Quest_IsActive'](q))
        self.assertFalse(self.triggers[0]['enabled'])
        self.assertIn(self.triggers[0], self.destroyed)
        self.fire(q)
        self.assertEqual(e['Quest_CurrentStep'](q), 3)
        self.assertFalse(self.fire(q))
        self.hero['inventory'] = [{'type': 'I000', 'charges': 1}]
        self.fire(q)
        self.assertEqual(e['Quest_CurrentStep'](q), 3)
        self.assertEqual(len(self.removed), 1)
        slot = q * e['QUEST_MAX_STEPS'] + 3
        self.assertEqual(e['QuestStepDelivered'][slot], 1)
        self.hero['inventory'] = [{'type': 'I000', 'charges': 5}]
        self.fire(q)
        self.assertEqual(self.hero['inventory'][0]['charges'], 3)
        self.assertTrue(e['Quest_IsDone'](q))
        self.assertTrue(e['QuestStepRequirement'][slot]['item_done'])
        self.assertEqual(e['udg_QuestsCompleted'], 1)
        self.assertIsNone(e['QuestStepTrigger'][slot])
        self.assertEqual(e['QuestTriggerStep'], {})

    def test_delivery_failure_destroys_step_pickup_trigger_marker_and_ping_once(self):
        e, q = self.e, self.define()
        e['Quest_OnPickup'](q, 'Found it', '')
        e['Quest_Start'](q, 0, self.hero)
        self.fire(q); self.fire(q)
        slot = q * e['QUEST_MAX_STEPS'] + 3
        t, pickup = e['QuestStepTrigger'][slot], e['QuestStepPickupTrigger'][slot]
        self.assertIsNotNone(pickup)
        marker = object()
        e['QuestActiveMarker'][q] = marker
        e['QuestActiveMarkerUnit'][q] = self.npc
        e['QuestStepPingUnit'][slot] = True
        e['udg_BossUnits'].append(self.npc)
        e['Quest_Fail'](q); e['Quest_Fail'](q)
        self.assertTrue(e['Quest_IsFailed'](q))
        self.assertEqual(sum(x is t for x in self.destroyed), 1)
        self.assertEqual(sum(x is pickup for x in self.destroyed), 1)
        self.assertEqual(self.effects, [marker])
        self.assertEqual(e['udg_BossUnits'], [])
        self.assertEqual(e['QuestTriggerStep'], {})
        self.assertIsNone(e['QuestStepTrigger'][slot])
        self.assertIsNone(e['QuestStepPickupTrigger'][slot])
        self.assertEqual(e['udg_QuestsCompleted'], 0)

    def test_delivery_rejects_hidden_npc_and_cinematic_hero(self):
        e, q = self.e, self.define()
        e['Quest_Start'](q, 0, self.hero)
        self.fire(q); self.fire(q)
        self.hero['inventory'] = [{'type': 'I000', 'charges': 3}]
        self.npc['hidden'] = True
        self.assertFalse(self.fire(q))
        self.npc['hidden'] = False
        e['udg_InCinematicMode'] = True
        self.assertFalse(self.fire(q))
        self.assertEqual(e['udg_QuestsCompleted'], 0)


if __name__ == '__main__':
    unittest.main(verbosity=2)

"""Exercise stalled capture recovery and item-change rejection in built maps."""
import sys
import unittest
from collections import defaultdict
from pathlib import Path

sys.path[:0] = [str(Path(__file__).resolve().parents[1]), str(Path(__file__).resolve().parent)]
from mpq import MPQ
from jtok import functions
from test_armory_materia import execute
from test_shared_context import mocks

ROOT = Path(__file__).resolve().parents[2]
MAP = ROOT / 'release/0.9.7.5h/FFERPG-0.9.7.5h-Save01.w3x'
FUNCTIONS = functions(MPQ(str(MAP)).read('war3map.j').decode().replace('\r\n', '\n'))


class AutosaveRecoveryTests(unittest.TestCase):
    def scheduler(self):
        source = FUNCTIONS['Restore_AutosaveTick']
        state = mocks(source)
        now = [59.]
        events = []
        for name in ['RestoreAutoPending', 'RestoreAutoOff', 'FFL_Phase', 'FFP_Locked',
                     'FRC_Phase', 'FSC_Busy', 'FSC_Writing', 'FST_Pending',
                     'FRC_Ready', 'FRC_WriterOwned', 'C20SoftAutosave', 'C20RetryAfter', 'FFL_Started']:
            state[name] = defaultdict(int)
        state.update(udg_GameRunning=True, udg_HardcoreOff=True,
                     udg_InCinematicMode=False, InventoryCinematicActive=False,
                     RestoreAutoNext=1200., FST_Clock='clock',
                     TimerGetElapsed=lambda timer: now[0], Player=lambda pid: pid,
                     IsPlayerInForce=lambda player, force: True, udg_PlayingPlayers='players',
                     FFL_Message=lambda *args: events.append(('message', args)),
                     FST_SetFileStem=lambda *args: True,
                     C20_BeginAutosave=lambda pid: events.append(('start', pid)) or True,
                     udg_PlayerHero=defaultdict(lambda: 'hero'),
                     udg_SpiritOfGaya=defaultdict(lambda: 'gaya'),
                     udg_PlayerHouse=defaultdict(lambda: 'house'))
        def abort(pid):
            self.assertFalse(state['FSC_Busy'][pid])
            state['FSC_Writing'][pid] = False
            events.append(('abort', pid))
        def stop(pid, reason):
            state['FRC_Phase'][pid] = 0
            events.append(('stop', pid))
        def run(name):
            self.assertEqual(name, 'FFL_Tick')
            state['FFL_Phase'][0] = 0
            events.append(('finish', 0))
        state.update(FSC_Abort=abort, FRC_Stop=stop, ExecuteFunc=run)
        state = execute(source, ['Restore_AutosaveTick'], state)
        return state, now, events

    def test_sixty_second_stall_releases_writer_and_other_players_queue(self):
        state, now, events = self.scheduler()
        state['FFL_Phase'][0] = 1
        state['FRC_Phase'][0] = 2
        state['C20SoftAutosave'][0] = True
        state['FSC_Busy'][0] = True
        state['FSC_Writing'][0] = True
        state['RestoreAutoPending'][1] = True
        state['Restore_AutosaveTick']()
        self.assertEqual(events, [])
        now[0] = 60.
        state['Restore_AutosaveTick']()
        self.assertEqual(state['FFL_Phase'][0], 0)
        self.assertFalse(state['FSC_Busy'][0])
        self.assertFalse(state['FSC_Writing'][0])
        self.assertFalse(state['FRC_Ready'][0])
        self.assertTrue(state['RestoreAutoPending'][0])
        self.assertEqual(state['C20RetryAfter'][0], 90.)
        # Simulate the retry backoff gate in the retained starter.
        state['C20_BeginAutosave'] = lambda pid: (
            now[0] >= state['C20RetryAfter'][pid] and events.append(('start', pid)) is None)
        state['Restore_AutosaveTick']()
        self.assertIn(('start', 1), events)
        now[0] = 90.
        state['Restore_AutosaveTick']()
        state['Restore_AutosaveTick']()
        self.assertIn(('start', 1), events)

    def test_completed_capture_is_finished_without_waiting_for_profile_timer(self):
        state, now, events = self.scheduler()
        state['FFL_Phase'][0] = 1
        state['FRC_Ready'][0] = True
        state['Restore_AutosaveTick']()
        self.assertEqual(events, [('finish', 0)])
        self.assertEqual(state['FFL_Phase'][0], 0)

    def test_cinematic_and_load_transactions_are_not_timed_out_as_saves(self):
        for phase, cinematic in [(1, True), (2, False), (3, False), (5, False)]:
            state, now, events = self.scheduler()
            now[0] = 1000.
            state['FFL_Phase'][0] = phase
            state['FRC_Phase'][0] = 2
            state['C20SoftAutosave'][0] = True
            state['InventoryCinematicActive'] = cinematic
            state['Restore_AutosaveTick']()
            self.assertEqual(events, [])
            self.assertEqual(state['FFL_Phase'][0], phase)

    def test_watchdog_releases_decoder_busy_before_abort(self):
        source = FUNCTIONS['FRC_Timeout']
        state = mocks(source)
        state.update(FRC_Timers='timers', GetExpiredTimer=lambda: 'timer',
                     GetHandleId=lambda timer: 1, LoadInteger=lambda *args: 1,
                     FRC_WriterOwned=defaultdict(bool, {0: True}),
                     FSC_Busy=defaultdict(bool, {0: True}))
        calls = []
        def abort(pid):
            self.assertFalse(state['FSC_Busy'][pid])
            calls.append('abort')
        state.update(FSC_Abort=abort, FRC_Stop=lambda *args: calls.append('stop'))
        state = execute(source, ['FRC_Timeout'], state)
        state['FRC_Timeout']()
        self.assertEqual(calls, ['abort', 'stop'])
        self.assertFalse(state['FRC_WriterOwned'][0])

    def test_item_move_drop_or_property_change_rejects_partial_capture(self):
        source = FUNCTIONS['FRC_Step']
        for current_item, current_payload in [('moved', 'same'), (None, ''), ('original', 'changed')]:
            state = mocks(source)
            state.update(FRC_Position={0: 0}, FRC_Hero={0: 'hero'}, FRC_Gaya={0: 'gaya'},
                         FRC_House={0: 'house'}, udg_PlayerHero={1: 'hero'},
                         udg_SpiritOfGaya={1: 'gaya'}, udg_PlayerHouse={1: 'house'},
                         FRC_AccountHash={0: 123}, FRC_Account=lambda pid: 123,
                         FRC_At=lambda *args: current_item, FRC_Read=lambda *args: current_payload,
                         FSS_Equals=lambda a, b: a == b, FRC_Phase={0: 2},
                         FRC_Handle={0: 'original'}, FRC_Raw={0: 10},
                         FRC_Record={0: 'same'}, GetItemTypeId=lambda item: 10 if item else 0)
            stopped = []
            state['FRC_Stop'] = lambda pid, reason: stopped.append(reason)
            state = execute(source, ['FRC_Step'], state)
            state['FRC_Step'](0)
            self.assertEqual(stopped, ['inventory changed during capture'])

    def test_cutscene_resume_rearms_existing_timers_and_excludes_scene_time(self):
        source = FUNCTIONS['C20_ProfileResume']
        state = mocks(source)
        timers = []
        state.update(C20ProfilePaused=True, FST_Clock='clock', C20PauseStarted=20.,
                     TimerGetElapsed=lambda timer: 30., C20PollPaused=True,
                     FFL_Poll='poll', C20CapturePaused=defaultdict(bool, {0: True}),
                     FRC_Phase=defaultdict(int, {0: 2}), FRC_Timer={0: 'capture'},
                     FRC_Watchdog={0: 'watchdog'}, TimerGetRemaining=lambda timer: 25.,
                     C20SoftAutosave=defaultdict(bool, {0: True}),
                     FFL_Phase=defaultdict(int, {0: 1}), FFL_Started=defaultdict(float, {0: 5.}),
                     TimerStart=lambda *args: timers.append(args),
                     FRC_Tick=lambda: None, FRC_Timeout=lambda: None,
                     ExecuteFunc=lambda name: timers.append(('poll', .05, True, 'FFL_Tick')))
        state = execute(source, ['C20_ProfileResume'], state)
        state['C20_ProfileResume']()
        self.assertEqual([(timer, seconds, repeat) for timer, seconds, repeat, callback in timers],
                         [('poll', .05, True), ('capture', .1, True), ('watchdog', 25., False)])
        self.assertEqual(state['FFL_Started'][0], 15.)
        state['C20_ProfileResume']()
        self.assertEqual(len(timers), 3)

    def test_capture_and_export_failures_retry_and_release_save_phase(self):
        source = FUNCTIONS['FFL_Tick']
        for ready, exported in [(False, False), (True, False), (True, True)]:
            state = mocks(source)
            for name in ['FFL_Phase', 'FRC_Phase', 'C20SoftAutosave', 'RestoreAutoPending',
                         'RestoreAutoOff', 'C20RetryAfter', 'FRC_Ready', 'FFL_SaveFile',
                         'FST_LegacySaveMessages', 'FFL_Started']:
                state[name] = defaultdict(int)
            state.update(udg_InCinematicMode=False, InventoryCinematicActive=False,
                         FFL_BindCommands=lambda: None, FST_Clock='clock',
                         TimerGetElapsed=lambda timer: 100., FRC_Account=lambda pid: 1,
                         FRC_Result=defaultdict(lambda: 'validated code'),
                         FRC_Error=defaultdict(lambda: 'capture changed'),
                         FSC_Error=defaultdict(lambda: 'validation error'),
                         FSS_Concat=lambda a, b: a + b,
                         FFL_Message=lambda *args: None, FST_Write=lambda *args: exported)
            state['FFL_Phase'][0] = 1
            state['C20SoftAutosave'][0] = True
            state['FRC_Ready'][0] = ready
            state['FFL_SaveFile'][0] = True
            state['FST_LegacySaveMessages'][0] = True
            state = execute(source, ['FFL_Tick'], state)
            state['FFL_Tick']()
            self.assertEqual(state['FFL_Phase'][0], 0)
            self.assertFalse(state['C20SoftAutosave'][0])
            self.assertEqual(bool(state['RestoreAutoPending'][0]), not (ready and exported))


if __name__ == '__main__':
    unittest.main()

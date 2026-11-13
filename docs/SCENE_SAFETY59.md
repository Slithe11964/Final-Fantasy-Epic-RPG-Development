# UI59 / native Hotfix07 scene-safety candidate

Owner reports crashes in all three Kalm Siege quests, when Gilgamesh II is
summoned in the Arena of Darkness, and mostly when exiting FFERPG. No other
maps have shown their exit crash so far. Other players' reports are pending.

Concrete source findings: the earlier Kalm no-portrait workaround still calls
SetCinematicScene with rawcode 0; the shared normal Cine_Exit never explicitly
ends its cinematic scene. These are suspect render lifecycle paths, not a
confirmed explanation for the native CRenderBatch-related crash evidence.

Changes:

- New Text_Caption and Text_CaptionSay reuse the original transmission naming,
  durations, sound handling, skip and forced-line rules. They display timed
  text instead of invoking any portrait, ping or unit-indicator rendering.
- Every dialogue call in TKalmSiege1/2/3 and TBossGilgamesh uses those captions.
  This includes opening, retry, waves, victory/defeat, arena summon, sword phases
  and death dialogue. Actual NPC/boss world models are unchanged.
- Shared Text_Transmission uses timed text for null speakers, removing its
  rawcode-zero portrait request. Valid-speaker dialogue outside reported scenes
  retains its original portrait behavior.
- Normal Cine_Exit calls EndCinematicScene after its existing guard and before
  camera/interface restoration. Existing skip handling already ended the scene.

Builds are based directly on UI58 and native Hotfix06. All existing functions
are token-identical except these dialogue-call substitutions, null-speaker
rendering, and the single scene-ending call. No changes to equipment input,
icons, previews, item command orders, damage, mana, cooldowns, stats, save data,
quest progression, boss spawn/stage/loot logic, object data or world assets.
No native Quit-button hooks, frame destruction workaround or speculative UI
teardown hooks. The original editor master is untouched.

Validation: both playable and editor-source scripts compile; startup/source/
globals, archive readback, content references and save compatibility pass.
Four focused tests verify captions preserve names/durations/waits, narrator
lines avoid rawcode-zero portraits, skip/forced rules remain, and the complete
packaged function/object diff has exactly the stated scope.

Client acceptance still required: caption visibility/layout during cinematic
mode, Kalm I/II/III opening and full encounters, Gilgamesh summon/phase changes,
and exiting after those scenes. Passing static/mocked checks does not prove
crash resolution. In particular, general exit crashes remain unconfirmed and
Gilgamesh may fail before the first dialogue for a separate reason. Preserve
actual Crash.txt/map version and last action if any test still crashes.

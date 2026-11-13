# Quest notification and Seek and Destroy fixes

2026-10-30. Owner reports extra(null) above real quest text, Beastslayer pickup
example on0.9.7.5e, then asks to audit all quests and remove the spacer. Stock
QuestMessageBJ emits a separate single-space DisplayTimedTextToPlayer call
before most notification types. This matches the extra-line presentation, but
the exact client rendering of the screenshot cannot be proven by source alone.

All54notification call sites across35modules now route through QuestText_Message
in TText. It preserves the13message types' valid text, durations, sounds and
quest-button flashes, while omitting the spacer calls and rejecting null, empty,
single-space and literal(null) messages. Calls unrelated to dialogue retain their
same audience. Dialogue skip-text sentinels(null) are untouched. No new timers,
frames or gameplay changes are introduced by notification rendering.

Seek and Destroy explicitly granted A102(!Teleport) on spawning Kelk(n0CJ),
Kinoc(n0CA) and Mika(n0CI). Remove exactly those3grants. Their object ability
lists do not includeA102; all other abilities, random spawn/patrol calls,
scaling, quest tracking and rewards remain unchanged.

Canonical source updated in37modules (TText helper, notification callers and
Seeker module). Test harness aliases the new message renderer to its existing
notification recorder. Five focused checks and seven quest lifecycle tests
pass. Native Hotfix05, UI74 and classic Hotfix05 all pass playable/editor
compile, source pairing/startup/globals/text checks, content/save validation,
archive readback and unrelated resource byte checks. Source patch snapshot:
build/quests74-source.patch; logs build/quests74-*.txt.

Owner explicitly requests release name0.9.7.5f again. package_quest_release_f.py
promotes both Hotfix05 release profiles with public title only; byte-identical
scripts/editor/objects/assets to checked candidates. Final named pair also
passes all release checks. Dated artifact copies release/0.9.7.5f/2026-10-30;
previous named files/manifests preserved in history/2026-10-29-before-quest-fixes.
UI74 retains Dragoon/newThief separately. Original editor master unchanged.

Native branch inherits Hotfix04 cast-boundary candidate; this quest fix is not a
confirmed resolution of the multiplayer desync. Classic uses its existing UI.

# G / Book of Depths cast-boundary desync candidate

2026-10-30. Owner loads staff/offhand, previews both, then casts Book of Depths
using G. Immediately afterwards pent984 desyncs (screenshot shows desync warning).
This is new evidence that the optimized finalf has NOT resolved multiplayer
desync. Do not continue treating the earlier "seems to work" as stability proof.

Latest local report folder: Documents/Warcraft III/Errors/2026-10-30 09.16.57
5c894fc4. Desync.txt records turn2831,6human players,SD graphics,finalf map,
game W3-586272EF-371C-E88F-EE5E-EF28C65A6F34B6DC1F41. Detailed checksum log and
replay present. It does not identify a faulty JASS line. Original reports remain
untouched. A matching other-client log would permit checksum comparison.

## Focused change

QuickGear_RecordSpell previously launched ExecuteFunc("QuickGear_ClearPreview")
only for the owner from inside a shared spell-channel/effect event. Move that
visual work out of the event: observer only records local clear-pending state;
the existing10Hz UI72_Tick performs cleanup on its next update. Actual spell
diagnostics remain synchronized. No owner-only nested cleanup execution remains
in the spell observer. This avoids that execution boundary as an isolation test;
it is NOT proof that ExecuteFunc caused the desync.

A revision counter records the current aim when cleanup is requested. Opening a
new F/G or native wave aim increments it; cleanup from an older cast cannot clear
the new preview. Unrelated spell effects still do not close native wave aiming.
No new timers, groups, image allocations or input interception were introduced.

Only4TEquip functions change, plus3scalar globals. G's sync receiver, native
item activation, water wave/damage, cooldowns, runes/cursor artwork and geometry,
icons, input recovery and all objects/assets remain unchanged.

## Builds and validation

- release/development/VersionFHotfix04/FFERPG-0.9.7.5f-Hotfix04.w3x: retained
  release jobs, based on finalf.
- release/development/QuickUI73/FFERPG-QuickUI73.w3x: based onUI72, retains
  Dragoon/revised Thief.

Five focused regressions pass: same shared spell record on both mocked clients,
owner-only notice without immediate visual work, one deferred clear, new-aim
protection, unrelated cast preservation, and limited function/timer scope.
Both candidates pass playable/editor compilation, source pairing, startup,
globals/text safety, content/save checks, archive readback and unrelated resource
byte comparison. Logs build/cast73-*.txt. Client/multiplayer acceptance pending.

Test same save: preview staff, preview Book of Depths with G, cast into empty
ground, then repeat while another player remains connected. Also try cancel and
reopen a preview immediately after casting. Preserve new reports if it repeats.
This candidate does not establish resolution of the earlier preview-only desync.
Finalf and the original editor master are preserved unchanged.

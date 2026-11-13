# 0.9.7.5f multiplayer desync investigation

2026-10-29. Owner loaded a character with gear, opened inventory and tested
casting/rune previews. No quickcast indicator was visible at the disconnect.
CORRECTED owner account: the second player saw the owner's disconnect, then
LEFT normally. No second-player crash is reported. Only the owner desynced.
Owner never cast a spell: loaded gear, opened inventory, examined changed spell
previews; typing apparently blocked F/G, then alt-tab restored them and preview
arming worked again. Treat chat/focus recovery plus gear/preview work as the
primary reproduction sequence. The earlier secondary-crash account is withdrawn.

## Report evidence

Latest local report: `Documents/Warcraft III/Errors/2026-10-29 19.38.54 43f01644`.
`Desync.txt` explicitly records network desync, turn 2265, map
`Maps/Download/TEST/FFERPG-0.9.7.5f.w3x`, seven human players, SD graphics,
Warcraft 3.0.1 build24371. The detailed log contains48 checksum sections for
turns2263-2265. This establishes a multiplayer state mismatch, not an access
violation, and does not identify a faulty JASS function or the first divergent
client. Keep the replay and original reports unchanged.

The immediately preceding19:30:32 report is an ACCESS_VIOLATION; its first
executable offsets match the previously audited0x2c5ed4 teardown signature.
Do not conflate that distinct event with the19:38 desync.

## Source audit

Traced release-f runtime functions reachable from QuickGear_Poll,
QuickGear_WheelTick, GearCursor_Draw60, QuickGear_Mouse, QuickGear_RecordSpell,
Forsaken_PollPanels, SpellCalc_Update and Armory_PollCounter. Static ExecuteFunc
targets are included. Polls continue even when aiming is inactive.

No reachable direct gameplay unit/item mutation, stat write, random call,
gameplay order, location creation, timer/group/image creation or destruction was
found in these paths. The icon path reads existing equipped items and repaints
existing frames. Native bag observation reads coordinates and items, and arms
local visual state. Rune images are preallocated during shared startup; the
preview moves/hides/shows existing images. This is a source observation, NOT a
proof that every native call is safe in this Warcraft build.

Local UI caches ForsakenStatReadCache and SpellCalcLast are written. Item casts
are requested through BlzSendSyncData; QuickGear_Receive validates current gear
and performs UnitUseItem/Point/Target on the synchronized receiver. That receiver
does not use QuickGearPending, local pointer coordinates or the local icon cache
as gameplay authority. Presentation image/frame operations and engine-native
inventory reads remain investigation leads, not proven causes.

Machine-readable audit: `build/desync70-audit.json`. Extracted reachable bodies:
`build/desync70-local-reachable.txt` and `build/desync70-panel-reachable.txt`.

## Separate lifecycle finding (not this incident's cause)

The subsequent disconnect-order clarification adds a separate cleanup lead:
Trig_Player_Leaves_Game_Actions removes all units belonging to the departing
player but leaves udg_PlayerHero[player+1] populated. Forsaken_PrepareInventories
continues iterating all eight slots each second and only checks hero!=null,
then calls Forsaken_EnableHero, which immediately modifies inventory abilities
and reads native equipment/bag state. A removed hero can therefore still reach
those calls. This is a concrete missing lifecycle guard; it could explain a
secondary failure after a player leaves, but cannot explain the owner's FIRST
desync. No other player's dump currently proves a crash in these calls.

Owner additionally reports being the only player with a loaded character carrying
the active items under test. Keep this as a focused reproduction condition. The
separate synchronized1s Forsaken_PrepareInventories -> Forsaken_EnableHero path
does re-add inventory abilities, convert unprepared items and reconcile stored
passives. It differs from the local read/render paths audited above. It runs
the eight player slots on every client; this observation alone does not prove
different results across clients. Do not claim that all inventory polling is
read-only or that icon rendering has been ruled out by the report.

## Narrow secondary cleanup guard

Built `FFERPG-0.9.7.5f-Hotfix01.w3x` and development `FFERPG-QuickUI70.w3x`.
Only three TEquip functions change: maintenance skips removed heroes;
Forsaken_EnableHero rejects null/removed owners before any inventory work; the
deferred bag-rebind callback validates the owner before its first native bag-size
read. The deferred timer still cleans itself up on rejection. These are guards
against invalid owners, not a change to normal live gear updates or polling rate.
F/G dispatch/icons, preview geometry/input, spell balance and all object assets
remain unchanged. Four focused regressions and both candidates' map/editor,
content, save and archive checks pass. Live multiplayer confirmation is pending.
This does NOT resolve or identify the initial network desync.

## Preview-only focus audit after correction

`tools/tests/test_preview_only_desync_audit.py` executes the actual released
QuickGear_Input, QuickGear_FocusReset, QuickGear_Request, GearChat_Sent64,
GearChat_Poll63, GearWave_ModeFor and GearWave_Arm bodies. For Depths, Wateraga
and Ice Wand U, it covers opening chat (F/G suppressed), losing/regaining focus,
arming each targeted preview, sending chat/recovering, and ignoring another
player's key event. The script requests zero casts in those sequences. This
passes with mocked engine calls; it cannot establish native multiplayer safety
or reproduce the checksum mismatch. The existing source does not require a
confirmed cast for local preview image/frame changes to run.

Do not request a nonexistent second player's crash report based on the withdrawn
account. If another participant has same-match desync diagnostics, comparing the
same turn's checksum tree remains useful, but their existence is unknown. Current
evidence is insufficient to blame a specific polling function or declare a fix.
The initial desync remains unresolved; live multiplayer reproduction/isolation
is still needed. Original release preserved. No new map is built from this
focus audit; Hotfix01/UI70 address only the unrelated lifecycle guard.

Naming going forward: omit Forsaken from public map names; use `0.9.7.5f` and
`0.9.7.5f 1.29.2` as requested. Preserve existing files unchanged.

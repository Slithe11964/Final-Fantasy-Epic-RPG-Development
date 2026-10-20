# FF Epic RPG handoff

Read this first. Keep it short: it says where things stand, not what happened. Build-by-build
notes go in one row of [STAGES.md](STAGES.md); details go in the doc for that feature. The long
logs up to 2026-10-10 are in [history/](history/).

## Where things stand (2026-10-20)

PAIR037 is the latest test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Explicit Backpack close now persists until a deliberate
Backpack/B reopen, suppressing native refreshes after combat/selection. Priest
row2 is Acid Rain/Holy Bolts/Swiftmend; row3 Shielding/Blessed Rain/Prolonged
Cleansing; row4 Healing Bolts/Tranquility of Life/Refresh. Effect gates, cooldown
and tooltip metadata follow the new slots. Holy/Healing Bolts use magic damage
icons; Shielding uses Cure. Holy Bolts has the user's exact short description.
Shielding's current pool appears in Defenses in both clients and beside the first
hero health bar in Forsaken. Acid Rain heals on the authored pulse interval and
damages once per second at half the authored HP/sec: master 200 HP/.1 seconds and
2000 base magic damage/second. Channel object inheritance is materialized from
earlier authored ranks across main/skin ability tables; active casts defer live
calculation tooltip writes until matching cast-end. PAIR019 comparison found the
reported Channel data unchanged and sparse in PAIR036, with live writes added
later: this is a protected engine hypothesis, not an in-game diagnosis. Retest
all reported high-rank summons, Death Screech, Tornado, Dragon Breath, Fan of
Knives, Rave Kick and Assault for restored control, plus genuine channels.
All paired gates pass: native258/classic358, 2/12 expected skips; final archive,
master/tool hashes and both TEST copies verified. dev.txt read-only check passes,
file unchanged. Editor master unchanged. PAIR036 armory behavior retained.
Legacy large-profile menu checkpoint issue remains unresolved. See
PAIR037_PRIEST_CASTING_AND_BACKPACK.md for exact changes and acceptance tests.

PAIR036 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Native Backpack retains a confirmed binding to the same hero
across closes/reopens, uses a real owned button after binding, and hides both
panes without toggling the engine on close. Initial/new-hero binding stays native
and bounded. Armory indexes category entries once, clears only visible stock per
shop, and uses a separate single-rank Back ability. Holy Bolts now uses full
Prof_StaffPower plus healing buffs/Rejuvenation, including White Robe and equipped
Staff/house proficiency. Priest Legendary row: Healing Bolts (25% of actual basic
health damage heals allies along its path), Tranquility of Life (death-location
revival with full HP/MP), Prolonged Cleansing (ten seconds of repeated negative
status cleansing after Esuna). Native row 4 icons/purchase checks and selected
spell/Attack tooltip sections are included. All paired gates pass: native246/
classic346 regressions, 1/11 expected skips; final archive/master/tool hashes and
both TEST copies verified. dev.txt passes the read-only check and is unchanged.
Editor master unchanged. Actual Warcraft acceptance remains required, especially
repeat Backpack opens, White Robe withdrawal then Back, ordinary-unit resurrection
and status protection. Legacy large-profile menu checkpoint issue remains unresolved.
See PAIR036_PRIEST_LEGENDARY_AND_INVENTORY.md.

PAIR035 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Speedrun imports omit all seven chocobo nuts/greens across
all holders; final readback permits exactly those omissions and keeps retained
items/metadata strict. The existing dev.txt passed a read-only bounded-codec check
with Silkis Greens/Zeio Nut removed; the file is unchanged. Hardcore remains
save/load-disabled, and difficulty provenance is preserved. Native Backpack
restores the real button/B hotkey without an input overlay, observes opening,
closes both panes and the engine on X/Escape, and adds input counters to -bagdebug.
Armory Back rebuilds after Channel returns and preserves category Back/Close
labels. Repeated damage-calculation and armory-hint sentences are removed.
Priest row 3 now offers Shielding (final Cure/Regen/Tranquility overheal stacks,
30 seconds after last addition), Blessed Rain (10% damage reduction in active
Tranquility) and Holy Bolts (healing increases boost basic attacks; Rejuvenation
alone +50%, same attack type, native Attack tooltip). Food cannot inherit expired
Regen's shield eligibility. All paired build gates passed (native 237/classic337
regressions, 1/11 expected skips), final archive/master/tool/output hashes were
verified, and both TEST installs match. Editor master unchanged. Actual Warcraft
acceptance is still needed for backpack focus/opening, armory navigation, Speedrun
placement and new combat talents. The separate older legacy large-profile menu
checkpoint issue remains unresolved. See PAIR035_PRIEST_INVENTORY_AND_SPEEDRUN.md.

PAIR034 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Normal, Eternity and Speedrun character loads are compatible
in both directions; the saved Speedrun tag remains informational. The user
explicitly confirmed Hardcore saving/loading must remain disabled. Preflight
and creation recheck no longer require Speedrun mode to match. Final readback
allows only boolean core field15 to differ, retaining strict section metadata,
record count/order/IDs, all other core values and existing payloads. Difficulty
provenance/Inferno restrictions, Hardcore/manual/autosave gates, capture writer
and codec ranges are unchanged. All paired gates and final archive checks passed.
The existing dev.txt passed a read-only Normal-to-Speedrun bounded-codec readback
check without file modification. Editor master unchanged; PAIR033 UI retained.
Actual Warcraft acceptance remains required: -loadf dev in fresh Speedrun, then
resave/import in Normal/Eternity, and verify Hardcore and difficulty gates.
See PAIR034_SAVE_MODE_COMPATIBILITY.md.

PAIR033 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. User reports PAIR032 still fails to open by mouse and B,
temporarily improves with alt-tab, and behaves as desired once visible. PAIR033
uses one owned transparent input over the native Backpack button and clears only
Forsaken's competing native ASpc B hotkey. Every explicit open invalidates the
cached binding and waits for a real native result. Frame visibility and internal
engine open state are modeled independently; one bounded retry reconciles a
script-hidden but internally open panel. No poll click loop; failed open clears
intent so the next press retries. -bagdebug privately reports UI state. Current
layout, Talents preference, gear controls and item behavior remain unchanged.
Full paired gates and final archive verification passed; both TEST copies match.
Classic runtime is token-identical to PAIR032, and the editor master is unchanged.
Engine acceptance remains essential: fresh PAIR033 plus -loadf, repeated mouse/B
opens without alt-tab, then focus changes/drop/use/selection/job changes. If it
still disappears, capture -bagdebug immediately afterward. See
PAIR033_BACKPACK_OPENING.md. The older legacy checkpoint issue remains separate.

PAIR032 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Follows the user's PAIR031 flickering report (temporarily
improved by alt-tab). B input latches until release; mouse-up is separate from
native/scripted command clicks. Already user-opened native panes are adopted;
hero rebind waits between native close/open/resolve and stops on timeout instead
of repeatedly clicking. Actual selection wins over stale selection-event cache.
Move to hero is now at the lower right above ring/offhand. Both profiles gain
optional current-rank calculations for Armor Breaker, Chakra, Mirage and summon
Mega/Giga/Tera Flare, Hellfire, Final Smash, Diamond Dust and Release. Summon
commands honor calculation visibility even when the hero lacks those abilities.
All paired gates and final archive checks passed; editor master unchanged.
Engine acceptance is pending, especially backpack B/mouse/held-key/alt-tab,
linked panes after drop/use/job changes, lower transfer button and new tooltips.
See PAIR032_BACKPACK_INPUT_AND_CALCULATIONS.md. No combat/save changes.

PAIR031 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Native shared item cooldowns snapshot one current-rank,
adjusted duration for the visible cooldown and shared deadline; rejected casts
do not extend it. The remaining-time message reports seconds. Native inventory
binding now uses the actual ASpc Backpack controller; explicit close intent stays
closed despite late native visibility. Move to hero supplies a synchronized,
validated gear-to-empty-hero-slot picker below Talents. Native drag itself is not
claimed repaired. Carried gear retains actives without equipped stat bonuses.
The talent header is two lines: Points: 3/4 then Level Ultimate. Both profiles
use Mana regen, omit the Heavens Forged Axe proficiency row, and label Axe training
as Axe. Fishing prompts players to wait for ! and ignores premature directions.
Paired compilation, regression, compatibility and final archive checks passed.
Editor master is unchanged. Engine acceptance remains required for cooldowns,
Move to hero, persistent closing, fishing guidance and independent multiplayer
UI actions. See PAIR031_INVENTORY_FOLLOWUP.md. PAIR030 save and Acid Rain fixes
below remain in both profiles.

PAIR030 is the previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Fixes PAIR029's older-save final readback comparison: existing
payloads stay exact; the optional trial section alone permits missing defaults
and already-Legendary trial inference. Real bounded codec rejects unrelated
profile mutations. Existing local dev.txt (2,053 characters, seven sections)
passed normalized readback without changing its file. Original saves stay intact.
Section11 now also persists per-job Proof of Strength, IDs39..61. -legendary shows
the solo level90+ boss proof and Spring of Life/Grand Crystal Spiritual Ritual.
Native Backpack/B toggle shared intent; binding clicks are guarded. Talent icons
have no overlaid names, hover boxes are inset/aligned within the panel, and the
heading shows earned points /4 plus Novice/Master/Ultimate/Legendary. Locked icons
remain hoverable; click eligibility remains enforced. Gear drags to empty hero
slots allocate a carried alias directly, preserving properties and withholding
passive stats. Acid Rain retains current-rank half-split pulses, master200 HP +
200 base magic damage each0.1sec; Chaos attack type avoids native attack-table
scaling, with map magic/healing modifiers retained. A second Priest does not
restart the active shared timer. Tooltip shows both pulse and per-second amounts.
Native215 tests (one reference-only skip), classic315 (11 expected skips), all
compiler/editor/startup/content/save/armory/bazaar gates and conversion PASS.
Final archives/master/tool/output/TEST hashes verified; editor master unchanged.
Actual Warcraft acceptance still required: original -loadf, Backpack/B/X/Escape,
Holy Book/Tournesol drag into empty quick slots plus normal equipping, icon hover,
and measured Acid Rain with two Priests. See PAIR030_SAVE_UI_FIXES.md.
The older large-character legacy Warcraft-menu reload issue remains unresolved.

PAIR029 is superseded: its final byte comparison rejected older seven-section
profiles after adding optional trial progress; PAIR030 corrects this. Other
PAIR029 commands/calculation sections, persistent Talents preference and open
armory refresh are retained. See PLAYER_COMMANDS_AND_LEGENDARY.md.

PAIR028 is a previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Resolves the actual native inventory bag frame, links both
panes, and rebinds the native preview when the selected hero changes. Fishing
spots unlock from carried/loaded rods across all storage/Gaya; fishing requires
a worn matching rod. Explicit quick-slot gear moves create ordinary carried
copies with suspended passives and retained actives; native save/load restores
those same copies. All276 canonical mappings verified in the final archive.
Acid Rain converts half Tranquility healing to damage (master2000 base HP/sec +
2000 magic damage/sec); healing flags clear after every target. Refresh base CD45.
Cure/Pray/Tranquility/Blessing of Light show formulas and current-caster amounts.
Both paired gates PASS: native196, classic296 tests (10 expected skips), all
compiler/editor/startup/content/save/armory/bazaar checks and classic conversion.
Final archive/input/tool/output/TEST hashes verified; editor master unchanged.
PAIR027 was an internal candidate, superseded after its final audit found a
quick-slot load binding issue. Actual engine acceptance remains pending: linked
panes/current job model, rods, quick-slot actives without bonuses, healing split.
See INVENTORY_PANEL_FISHING.md. The older legacy large-character Warcraft-menu
reload crash remains separate and unresolved.

PAIR026 is a previous test pair, installed and hash-verified in Warcraft
Maps/Download/TEST. Native bag/equipment panes share persistent open/close intent;
the portrait fallback close control is removed. Includes equipped-only native
passives/regen display, Prototype classification, worn cloak/fishing adapters,
synchronized gear/food cooldown vetoes, scripted Myriad/Meteor waves, nongear
carrying levels, 280-entry armory guards, Pram breeding and six-form Freelancer
capture/load. Existing nonpersistent developer gear is still omitted from saves.
Both paired gates PASS: native191 and classic291 tests (10 expected skips), all
compiler/editor/startup/content/save/armory/bazaar checks and classic conversion.
Final archives, tool provenance, unchanged master and TEST hashes verified.
Focused actual-JASS tests also cover all six Freelancer load variants. Actual
Warcraft acceptance is pending, especially native frame discovery/linking, fishing,
projectile visuals and multiplayer item cooldowns. See EQUIPMENT_INTEGRITY.md.
The earlier large-character legacy Warcraft-menu reload issue remains separate.

PAIR025 is the previous test pair, installed and hash-verified in Warcraft Maps/Download/TEST.
Adds rank-specific damage formulas for all requested abilities (40 families, 87 IDs),
including Finisher outcomes/chances, all Noxious Mixture consumables, per-hit/wave/pulse
amounts and combo/distance/HP scaling. Old numeric claims that contradicted scripted
values were corrected. Scroll of Shadows and 25 Curse-prefixed scrolls have no Gaya
holding-level gate; curse tooltips distinguish resulting gear's equip requirement.
Both paired gates PASS: native179 and classic279 tests (10 expected skips), compilation,
startup/content/save compatibility. Every covered rank verified in final object layers.
All non-tooltip object fields and every runtime function except the scroll level-check
predicate are unchanged from PAIR024, including combat/save/inventory. Master unchanged;
output/tool/TEST hashes match. Actual Warcraft tooltip layout and carrying acceptance
remain pending. See DAMAGE_TOOLTIPS.md. No combat damage balance changes.

PAIR024 is the previous test pair, installed and hash-verified in Warcraft Maps/Download/TEST.
Adds Priest Master choices Acid Rain, Refresh and Swiftmend. Refresh resets food/stat
buffs; special hero effects gain 3 seconds of remaining duration, including existing
Runic/Divine script timers. Esuna base cooldown20 retains normal cooldown modifiers.
Swiftmend doubles Regen healing for half its current-rank duration; the numeric Regen
tooltip explains the unchanged INT/Staff/target-STR formula. Native talent hover text
and selected-talent ability descriptions are included; classic retains text dialogs.
Both paired gates PASS: native173 tests, classic273 (10 expected skips), compilation,
startup/content/save compatibility. Final runtime/object/profile separation, tool
provenance, output hashes and unchanged editor master verified. Save transport,
combat engine and native backpack/rebind functions are token-identical to PAIR023.
Actual Warcraft acceptance of the new talents/buff replays is pending. Test each
choice, reset, lower/master ranks, food/stat refresh, Runic +3 seconds and multiple
players; see TALENTS.md. Runtime lives in TRegen to avoid classic dependency cycles.

PAIR023 is the previous test pair, installed in Warcraft Maps/Download/TEST.
It bundles PAIR022 master summon level40 nonhero templates, corrected Rage tooltips,
Trance/Mirage/Aim rows, requested stat ordering/percentages and Hold Position-only
Defend display (the user revoked connecting 30% to Sentinel). White Robe explains
its +6 Staff proficiency and displays the current relative Life-power bonus.
Maxed house research keeps read-only proficiency icons/descriptions. Page5 shows
effective proficiencies; native Back/Next wraps five pages including conditions;
classic supports -stats 5/next/back. Native Hunt Club hides/restores with inventory.
Native 162 and classic 262 regressions (10 expected skips) plus all build gates PASS.
Final archives and TEST hashes verified; editor master unchanged. Combat/save-read
functions are unchanged from PAIR021, as are native equip/rebind/backpack handlers.
In-game acceptance is pending. See JOB_EFFECTS.md and STAGES.md for mechanics.
PAIR022 passed as an internal candidate but was superseded before installation.

PAIR021 is the previous test pair, installed in Warcraft Maps/Download/TEST.
The user reported a fresh native backpack closing within one second. The native
UI now remembers open intent until B, Escape or explicit close, through idle and
item refreshes; selection retains intent for the hero. A shared-startup close
control overlays a discovered native X or appears as Close bag beside Talents.
No local handle allocations or gameplay writes were added. Item listeners are
not duplicated on checkpoint UI rebuild. Ten focused UI tests, native 144 and
classic 244 regressions (10 expected skips), compiler/map gates, archive and
installation hashes PASS. Classic runtime is token-identical to PAIR020; native
inventory/gameplay/save functions are unchanged. Fresh-game idle/drop/use/close
and saved-game UI restoration still need actual engine acceptance.

PAIR020 adds read-only omission of unregistered/nonpersistent and foreign-bound
items from -save/-savef/autosave. These produce empty saved slots without moving
or deleting live items; eligible items retain exact positions. Record counts use
emitted records only. Capture/bounded-string tests and both paired gates passed.
The master remains the user-edited authoring map; paired transforms carry these
runtime fixes automatically without overwriting it.

PAIR019 is the public release candidate: PAIR018 with the scenario name set to 0.9.7.4.
PAIR018: the user's editor master (0.9.7.4 patch notes in
Intro and the quest log, Reminder links, quest and map edits) plus PAIR017's backpack fix.
Its object data matches PAIR017's. Not copied to TEST; outputs are in release/pairs/PAIR018.
The master was saved by a newer World Editor (no HM3W header, fields moved into skin tables,
default-valued fields dropped); build_pair.py now normalizes that, see EDITOR_PAIR.md.

PAIR017 is the checked backpack-visibility pair, installed in TEST as
FFERPG-PAIR017-Forsaken.w3x and FFERPG-PAIR017-1.29.2.w3x (hash verified).
The user reports PAIR016 working well and is preparing a public release. Dropping
backpack items was the clearest automatic-close case. Native UI now restores an
already open backpack through a short drop/use/unequip refresh window; B/Escape,
selection changes and checkpoint rebuilding cancel restoration. Inventory/gameplay
handlers are unchanged, verified against PAIR016. All gates passed (native 139;
classic 239 with 10 expected skips), including five local UI regressions. In-game
backpack drop/use acceptance is pending. The saved editor master is snapshotted by
the builder; user edits made after the snapshot belong to the next build.

After PAIR018 all build scratch, old crash checkpoints and superseded release maps
(3.7 GB) moved to ../_delete/2026-10-16-after-PAIR018 with a manifest, for the user to
delete. Kept: pinned references, PAIR016-018, and older maps experiment tests read.

PAIR016 is the checked job behavior/stat pair, installed in the Warcraft TEST folder
as FFERPG-PAIR016-Forsaken.w3x and FFERPG-PAIR016-1.29.2.w3x (hash verified).
It covers Necromancer/Skeleton Champion moon markers, mana healing, 90-second
Undying, Aim, channeled Myriad/Meteor proxies, full-bag Chemist consumers and
rank-aware stat rows for Archer, Rage, Dark Knight, Wizard, Calculator and Prophet.
Divine Shield retains the user-approved 2-to-5 blocked damage per mana efficiency,
with clean two-caster handoff. Exact row allocation preserves space for gear bonuses.
All gates passed: native 134 tests; classic 234 tests with 10 expected skips. Ten
focused JASS/object regressions pass; final archives and editor-master hash verified.
PAIR014/015 were checked internal candidates and were not installed in TEST.
See JOB_EFFECTS.md for behavior and required engine acceptance. In-game casting,
revival, icons and panel presentation still need user testing; mocks are not engine proof.

PAIR013 is the checked passive-art/bridge pair, installed in the Warcraft TEST folder
as FFERPG-PAIR013-Forsaken.w3x and FFERPG-PAIR013-1.29.2.w3x (hash verified). The user reports PAIR012 fixes working.
Custom Amgl dummy passives now explicitly suppress inherited attachment art while
preserving authored art, extending the Ninja/Chemist fix to Dark Knight, The Reaper
and Arena circles/hints. Elysium's bridge is absent while locked, then recreated
longer/raised on Andre's unlock with a narrow walkable approach corridor. Engine
appearance/walking acceptance is pending. See LEGACY_129.md for evidence and tests.

PAIR012 is the checked gameplay follow-up, installed in the Warcraft TEST folder
as FFERPG-PAIR012-Forsaken.w3x and FFERPG-PAIR012-1.29.2.w3x (hash verified): proximity turn-in for Eidolon
Challenge; separate per-player travel dialogs with ten destinations per page and
unchanged unlock IDs; native quest searches across all carried slots; charged-item
stacking across the full inventory; Gather consolidation of existing hero/Gaya/house
stacks and matching house-ground items; equipped-only Hero Medicine refill and
Sleipnir stale-marker/aura cleanup. Both inventory interfaces and the shared save
format are retained. See BACKPACK.md for behavior and engine acceptance checks.
The first private PAIR012 attempt stopped at an outdated native quest test fixture;
the corrected fixture passes against both profiles. No incomplete pair was published.

The user reproduced a Forsaken PAIR007 multiplayer desync during `-loadf dev`.
The seven-player report/replay narrows this attempt to private preparation/first
send: the command is present without a subsequent FSCU packet for that request.
The user confirmed PAIR010 Forsaken multiplayer import no longer desynchronizes.
That private-IO separation remains: synchronized receivers validate content, export
checksums run before private writing, and file bytes/inventory interfaces are retained.

PAIR011 is the checked performance follow-up, installed in the Warcraft TEST folder
as FFERPG-PAIR011-Forsaken.w3x and FFERPG-PAIR011-1.29.2.w3x (hash verified). It reclaims unrooted save
fragments through bounded shared/private queues, releases finished projectile hit
groups, guards exhausted motion pools, caches native UI searches/render reads and
invalidates Armory/Chronicle totals on changes. Cross-module save assignments retain
roots, preserving active work and screenshot pages. The canonical source and paired
runtime maintenance carry these changes into future editor-master builds without
rewriting the master. See PERFORMANCE_AUDIT.md and SAVE_129.md.

The freeze report was after loading, with three players questing and about four
quests completed; another player had a medium-progress import. These changes repair
concrete audit findings but do not identify the engine's freezing instruction.
Extended multiplayer quest/combat acceptance remains required. PAIR008/PAIR009 and
the interrupted first PAIR011 attempt did not publish output pairs.

The large imported-character Warcraft menu checkpoint passed in PAIR004 Reforged
but still crashed in 1.29.2 Simple after quests and a complete restart. That classic
checkpoint fix remains unresolved; CheckpointNoItems.txt is installed separately
for isolation (SAVE_129.md). Earlier failed checkpoints embed the old map.

[PERFORMANCE_AUDIT.md](PERFORMANCE_AUDIT.md) distinguishes confirmed resource/work
issues from unmeasured startup opportunities. Preserve combat timer timing and
preloads unless profiling supports another change.

| Line | Map | State |
|---|---|---|
| Reforged gameplay | `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenEN.w3x` | EN lets hero/Gaya curse scrolls find matching gear across their native quick, bag and equipment slots; inventory failure keeps the original and scroll. Curse acceptance pending. EM unlocks Phoenix and Annoying Monster directly when Ao Madoushi starts; in-game quest acceptance pending. EL uses the standard gold Secrets category counter and removes the outdated Simple load warning. EK recreates Bazaar/Stats/Talents frames after Warcraft menu loads, defers initial panel setup and supplies fallback button access. UI acceptance pending; fresh-versus-saved-game clarification is still unanswered. EI validation work/timeout rollback remain; preserves DW native inventory and the FSVB format. Import and Warcraft menu checkpoint acceptance pending. EH is superseded before tester acceptance. EF Tiny import/checkpoint cycle passed. Classic Backpack/SaveSlots modules are rejected by the builder. Gameplay features and prior acceptance are recorded in SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |
| 1.29.2 development | `release/1.29.2/FFERPG_0.9.7.3-r16-stageATV.w3x` | ATV adds curses across all seven classic pages, both scroll users, and shared Ao Madoushi side offers/Simple text; in-game acceptance pending. ATU splits validation into bounded execution steps after ATT -loadf dev hung for over a minute. It drains one cache packet/player/tick and recovers stopped imports using verified rollback. Exact format, interrupted-work and load/recapture models pass; in-game import and Warcraft menu checkpoint acceptance pending. ATS Tiny import/checkpoint cycle passed. The long-string isolation probe failed with an intact container; native checkpoint acceptance for endgame profiles remains unresolved. Backpack pages, cooldowns, water projectiles, equip routing, Armory/Bazaar, autosave and collection changes remain (BACKPACK.md, SAVE_129.md). The corresponding release/...stageATV.w3x is an authoring intermediate, not the Reforged gameplay map. |
| Public baseline | `baseline/Reforged/` and `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` (stage Z) | Tracked in Git; confirmed working 2026-10-06. |

| New save system | Forsaken EN (Reforged) and ATV (1.29.2) | Shared FSVB format and permanent IDs; native Reforged equipment maps to classic equipment pages. Tiny full checkpoint round-trip confirmed in ATS/EF; ATU/EI need an endgame import test first, then a new-checkpoint test. ATT stalled during import in classic; the Python data model did not model Warcraft's thread execution budget. DW/DZ round-trip, multiplayer delivery, endgame slots, cleanup/retry, one-load and fifteen-minute cutoff passed. Priest reset, Chronicle restoration and three-second portals remain. DX is the separate multi-file test. See SAVE_FRESH_LOAD_TEST.md and SAVE_129.md. |

All 93 quests run on QuestEngine (QUEST_ENGINE.md). Bugs are deferred by user request (BUGS.md).

## Building

User editing workflow: [editor/README.md](../editor/README.md). Open/save the shared
Reforged-format `editor/FFERPG-Editor-Master.w3x`, then run `.\build-pair.ps1`.
The checked initial pair is `release/pairs/PAIR004/` (native 110 tests, classic 201
tests with 8 skipped, compiler/content/startup/save gates passed). Actual World
Editor Save As and gameplay acceptance remain pending.
The pinned authoring reference is ATV and the pinned native reference is EN;
`editor/pair-config.json` verifies their hashes. Keep these ignored binary files
with the master when backing up. Outputs publish together in `release/pairs/`.
Root `src/`, the master and reference maps are never rewritten by the paired builder.
The master uses classic/shared inventory while authoring; only the native output
contains the native Forsaken inventory and panels. Do not use a generated map as
a replacement master. Compatibility conflicts stop with retained private build logs.

1.29.2 authoring build (Windows PowerShell, from this folder):

```powershell
.\build.ps1 -Stage <next unused> -Base release/FFERPG_0.9.7.3-r16-stageATV.w3x
```

It finds changed modules in `src/`, syncs them into the base map, orders libraries, checks the
result and writes `release/<name>-stage<X>.w3x` **and** the matching 1.29.2 map in
`release/1.29.2/` (same name). The 1.29.2 conversion is part of the checks: shared code must
compile against 1.29.2, and Reforged-only UI lives in add-ons the converter swaps for dialogs
(`BazaarFrame_`, `TalentFrame_`). `-NoClassic` skips it. Existing files are never overwritten.
For a World Editor save, `.\make_129.ps1 -Map release/<map>.w3x` still converts one map.
Details and failure handling: BUILDS.md.

Design rule (user, 2026-10-10): edit in the Reforged editor, but the default map and every change
target 1.29.2 where possible; Reforged gets nicer UI on top (Bazaar 3 panels, talent panel,
the native Forsaken inventory). Saves must stay compatible between the two. Reforged gameplay
uses the Forsaken branch; paged Backpack/SaveSlots modules belong only to the classic line.
Build the native Reforged update with `python experiments/Forsaken/build_dw_update.py --stage <next>`;
its builder rejects classic inventory modules.

- The 96 regression tests and the base-map checks only rerun when `tools/`, `src/`, `baseline/`
  or the base map changed since they last passed (cache in `%USERPROFILE%\.cache\fferpg-build`).
  The output map is always fully checked. Add `-FullChecks` to force a full rerun.
- Forsaken gameplay build: `python experiments/Forsaken/build_forsaken.py --stage <X>`.
- Save diagnostic build: `python experiments/Forsaken/build_save_probe.py --stage <X> --gear-probe`
  (or `--house-probe`). Default base is ForsakenBT.
- Complete private round trip: `python experiments/Forsaken/build_save_roundtrip.py --stage <X>`.
- World Editor: enable JassHelper/vJass, Save As a new file, then `python tools/export_sources.py`
  and review the source diff before committing.

## Rules

- `.j` sources stay CRLF; one vJass library per trigger under `src/triggers/<folder>/`.
- Comment calculations only when they are not trivial (CONTRIBUTING.md).
- Keep dialogue, rewards and behaviour unless the change asks for it. Keep save item/job indexes
  append-only (tools/contracts).
- After a build: add one STAGES.md row, update this page only if "where things stand" changed,
  commit. Don't paste test counts, hashes or scratch paths into docs; the build writes them to
  `release/checks-*.txt` and `build-*.json` next to the map.
- Future Forsaken builds use the r17 metadata in experiments/Forsaken/map-presentation.json
  and the current src/triggers/06 Quests and story/Intro.j, including private test maps.
- When a map is superseded, it can be moved out of `release/`; keep the current AS pair and any
  Forsaken map a doc names as the current test.

## Next

1. PAIR013: check the reported moon effects and cross the Elysium bridge in both directions after Andre unlocks it (LEGACY_129.md); then start a fresh multiplayer game with the same endgame/medium imports; complete more than four quests and exercise projectile combat. Check inventory, inspection, stats/talents and collection updates after gains/removals. Confirm normal save screenshot pages remain available and file saves still import. Report whether a freeze affects one or every client and the last activity. PAIR010 loading desync acceptance passed; PAIR011 freezing acceptance is pending. The 1.29.2 large-import Warcraft-menu checkpoint issue remains unresolved; compare the separately installed CheckpointNoItems diagnostic and test only newly created checkpoints. Tiny checkpoint success does not prove the endgame case. Future edits remain in the editor master; the paired builder applies reviewed maintenance to both profiles.
2. Armory ATP/EC: root total only, each category button has its own progress and opens the right page; Close/Back has no counts. Bazaar: prepare consumes parts, purchase pays and delivers, rewards reveal and recipe-ready text returns.
3. Forsaken: load a DW save in EC and reset Priest talents: the hero/job/gear must remain, the point returns, and the Shrine positions and milestone totals match. DX remains the separate multi-file test; multiplayer timings remain pending. See SAVE_FRESH_LOAD_TEST.md.
4. Talents: user is writing each job's list (Priest first); Shrine sells Reset Talents. New content on ASC: CONTENT_DEVELOPMENT.md has worked quest/boss/item examples.
5. Optional cleanup of shared temp variables: PHASE16.md.

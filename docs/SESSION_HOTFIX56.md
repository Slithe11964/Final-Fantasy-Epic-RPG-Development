# Version E Hotfix04 and UI56

2026-10-28. User requests shared bug fixes on the latest release without Dragoon
or the Thief ultimate change, and on UI56 with those changes. Also requests the
now-confirmed UI55 icon fix on the release line. Baselines: VersionEHotfix03
Forsaken/1.29.2 and QuickUI55 native. Prior files and editor master preserved.

## Jobs and Gaya

Job_GetHero no longer recreates/removes Gaya when allocating a new class. That
side effect removed a live Gaya shrine buyer mid-transaction, unnecessarily
replaced inventory/Chronicle state and could run nested callbacks. Cached job
handles are checked against the requested unit type before reuse.

Job change now captures owner, buyer, old/current/new hero, requested class,
progression scratch, item/loop indices, saved vitals/facing and location in
transaction-local values. Its simple boolean predicates are expanded into the
action before localization so they do not keep reading stale GUI globals. A
per-player guard prevents reentrant purchases and is released only by the
invocation that acquired it. Saved quick items are indexed per player. Promotion
uses the captured player ID. Legacy trigger consumers receive their expected
scratch inputs immediately before execution. Summon cleanup explicitly excludes
H01D. These are prevention fixes, not an automatic repair of an already-corrupt
Warcraft checkpoint containing duplicate heroes.

Three executable transaction regressions pass, including Gaya as buyer, callbacks
overwriting all old scratch variables and nested purchases. They assert one new
active hero, old hero hidden/neutral, other players unchanged, Gaya retained,
one inventory transfer and correct lock behavior.

## Native backpack and checkpoint UI

ASpc's authored object override is item-class (aite=1, aher=0), retaining its
native command and slot/hotkey while excluding it from ordinary spell Silence.
No local-frame traversal, synthetic command retry or silence cleansing is added.
Real client validation is required: object/compile checks do not emulate engine
Silence rules or native inventory command visibility.

Warcraft game-load UI recovery now also rebuilds TravelPanel. It retains
page/open state, replaces old click/key/sync listeners, re-creates frames after
native UI restoration and renders the local player's open menu. It invalidates
the menu epoch to refuse stale sync requests. Stale frame handles are not
destroyed. Only the startup wrapper destroys its startup timer; reusable panel
initialization cannot destroy a caller's rebuild timer. A repeated-rebuild test
proves three active listeners, no duplicate hotkeys, retained page/open state and
one local render per rebuild. Test with a NEW Warcraft save made in this map;
old Warcraft saves embed the previous script. Portable character format unchanged.

## Confirmed icons and additional user testing

User confirms UI55 icons work. UI56 preserves all UI55 icon paint/cache/repaint
functions exactly. Release-native receives UI53 input/load recovery plus UI54/55
icon refresh and repaint, without new job content or Wave/Dragoon/Cuts helpers.
Classic receives the shared job fixes; its existing inventory/dialog system stays.

While these builds were being prepared, user reported single-target items lack
a targeting cue; later confirmed multiple offhands cast correctly after clicking
the hero. Target mode1 now arms one preallocated target ring which follows mouse
or hovered unit and clears on cast/cancel. This is a selection cue, not a new
damage radius. Original spell target modes/damage are unchanged. No backlog
native-backpack-click preview hooks are reintroduced.

User then confirms equipped Siphoning Staff casts carried Gaya's Rod after a
target click, while gearcheck shows the correct staff; dropping Gaya's Rod lets
Life Staff work. This rules out a stale item-name lookup and motivates a
PRIMARY unit-target cast-only active-ability rebind before the existing native
UnitUseItemTarget call. It changes only that item's active ability binding;
no item movement, passive changes or ownership/charges/userdata edits. Native
shared cooldown/mana checks still precede dispatch. Offhand dispatch remains
unchanged. This is an UNVERIFIED engine workaround, not a demonstrated root-cause
fix: test with Gaya's Rod/Nirvana still in the bag. A spell-effect observer records
the actual hero spell; -gearcheck prints expected versus actual raw spell IDs.

User reports alt-tab disables F/G, restored by changing jobs. Existing wheel
polling now detects local-client focus transitions and clears stale local chat,
key-latch, repeat timing and pending preview state. It does not change equipment,
send orders, register thousands of extra key events or create timers. Unit cue,
focus transitions and primary-only binding have three focused executable tests.

Installed candidates:
- release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-Forsaken.w3x
- release/development/VersionEHotfix04/FFERPG-0.9.7.5e-Hotfix04-1.29.2.w3x
- release/development/QuickUI56/FFERPG-QuickUI56-Forsaken.w3x

All three pass playable/editor compilation, trigger/source pairing, startup,
globals, native save-text, content-reference and save compatibility gates
(358 items/22 jobs). Ten focused tests pass: three job transactions, three package
scope checks, one repeated travel rebuild, three target/focus/binding cases.
All unrelated named resources are checked byte-identical to their respective
baselines. Real client/multiplayer acceptance remains outstanding for new fixes.

Authoring maintenance: these transforms live in session_hotfix56.py and
gear_target56.py; build_session_hotfix56.py applies them to both native branches
and the shared job patch to Classic. They must be applied when rebuilding from
the editor master; the master has not been rewritten. Historical pass1 candidates
in build/candidates are failed/unpublished and must not be installed.

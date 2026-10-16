# Reforged development and 1.29.2 compatibility

Develop from baseline/Reforged/FFERPG_0.9.7.3-r16.w3x or the newest Reforged build. Save As in the
Reforged World Editor with JassHelper/vJass enabled, check the saved file, then generate its classic copy:

```powershell
.\make_129.ps1 -Map release/<saved-Reforged-map>.w3x
```

downgrade_129.bat invokes this local script. No arguments converts the baseline. Output defaults
to release/1.29.2/<same-filename>.w3x; -Out and -PythonPath are supported. Existing files are refused.
The map-list name uses the filename's stem without a (1.29.2) suffix. Baseline files share both names.

Conversion rewrites terrain, doodads, units, objects, map info, regions/cameras and editor formats.
It merges skin data, restores missing classic fields from the pinned classic baseline, adapts
unsupported generated calls and compiles the script against bundled 1.29.2 libraries. Object text
is written inline; only referenced strings remain in WTS. Game Interface and HM3W header are kept.
Both copies retain editor files; custom vJass saves require JassHelper. Keep Reforged as the master.

The FF profile clears inherited attachment art on Chemist Pharmacology A0HL and Ninja Dual Wield
A0HP, preserving authored spell art and unit selection settings. Stage X's Gaya selection workaround
was removed in Y and is absent from this baseline.

## Client display

Flying Gaya/crow lines can be Warcraft 3.0 Air-to-Ground Indicators. If the menu option is unavailable,
close the game, set showAirToGroundIndicators=0 in the Gameplay section of Documents/Warcraft III/
War3Preferences.txt and restart. Conversion does not edit client preferences. Test a fresh baseline
game for Gaya selection/health-panel behavior with restored normal unit settings.

## Release testing

The user confirms both baseline maps work great (2026-10-06). For future releases, test: map loading, welcome/
quest log, hero spells, Gaya selection, quest completion, save/load and multiplayer where relevant.
Include Thief Fan of Knives/Channel spells to check missing object defaults. See QUEST_TESTS.md.
Compilation does not establish cross-client visual/gameplay equivalence. Historical experiments are
in the external archive; the current workflow requires neither sibling MapToolkit nor r7.

## Bazaar presentation from stage AG

Reforged releases show recipe panels with custom frame APIs. The local converter uses
`bazaar_legacy.py` to replace those frame functions in both runtime and editor source with AE's
single-recipe dialog. Crafting data, prices, result charges and the shared material transaction
are preserved. Classic releases use this dialog even when played in Reforged; use the Reforged
release to see the three-panel interface. Continue development from the Reforged master. Two unused frame event
triggers remain as classic startup placeholders. Test both presentations as described in BAZAAR.md.

## Natives the new save system needs that 1.29.2 does not have

Checked against the bundled `tools/versions/1.29.2/common.j`, which carries 94 Blz natives
but none of these:

| Native | Used by | 1.29.2 replacement |
|---|---|---|
| `BlzSendSyncData`, `BlzGetTriggerSyncData`, `BlzTriggerRegisterPlayerSyncEvent` | save transport, to share a locally read file with every player | game cache: `StoreInteger` + `SyncStoredInteger` + `GetStoredInteger`, all present |
| `BlzGetItemBooleanField`, `BlzGetItemIntegerField` | capture, journal, native, probe | the map's own item tables (`udg_ItemSaveID` and the save item index) |
| `UnitExtendedInventorySize` | capture, journal, probe | the Backpack equipment model, which replaces the 30-slot native bag |

So the save system cannot run on 1.29.2 as built, and the gap is wider than the equipment
layer alone. What already works on both: the save format itself (`ForsakenSaveCodec` is plain
JASS), writing and reading files through `PreloadStart`/`Preloader`/`SetPlayerName`, and chat
loading, because chat events are already synchronous and need no sync natives.

Merge order that follows from this: the codec and session modules can join the normal build
now; transport needs a second delivery backend built on the game cache; capture and the rest
wait for the Backpack model.

### Game-cache delivery, proved as far as it can be offline

`experiments/Forsaken/Forsaken-save-cache.j` carries the transport's own packets as
synchronised game-cache integers, five code characters to an integer in base 66 (the 64
code characters plus the two legacy brackets). A packet's length key is written last, so a
packet is never handed on half-arrived; every value is stored one above its real value
because a missing key also reads as zero.

Checked: it compiles against the bundled 1.29.2 `common.j` and `blizzard.j`, and a real
1,701-character endgame save survives the round trip character for character, brackets and
whole alphabet included (`test_save_cache.py`).

The transport now chooses its path from one constant. The three sync natives live only
in its `FSTSync_` wrappers; `tools/save_legacy.py` empties those and flips
`FST_UseSyncNative` to false, and refuses the conversion if any of the three survives
anywhere else. Both stacks compile: codec, cache and transport parse against the Reforged
libraries as they are, and against the 1.29.2 libraries after conversion. A whole save
file also travels end to end through the transport's own pump on the cache path, with no
sync packet sent (`test_save_transport.py`), and the converter has its own gate in
`tools/tests/test_save_legacy.py`.

Not checked, and only a real 1.29.2 multiplayer game can: how many `SyncStoredInteger`
calls one frame tolerates. That save needs 389 keys. Sending one 192-character packet per
pump tick means about 39 of them in a single frame and finishes in roughly half a second;
shorter packets spread the same work thinner, so 64-character packets would be 14 keys a
frame over about 1.4 seconds. Start short and raise it only if the game is happy.



## PAIR013 passive-art and Elysium crossing follow-up

The user reports PAIR012 gameplay fixes working, then reports inherited moon art on
Dark Knight, The Reaper and the two Arena circles. Paired output maintenance now
explicitly clears missing caster/target/effect/special attachment fields on custom
Amgl dummy passives in both profiles, extending the earlier Chemist/Ninja approach.
Authored art remains intact; ability icons, gameplay fields, unit models, selection
settings and UI geometry are retained. Relevant markers include A0KV (Dark Knight),
A1FC (The Reaper), A0VR (the entrance) and the Arena's Amgl-based hint passives.

The Elysium crossing is DTsb at (0,-9632). The PAIR012 static pathing map marks the
western shore approach unwalkable at the original model endpoint. Inspection of
the installed legacy model also shows low bridge-end geometry relative to its
original -190.2 spawn elevation. The candidate creates a longer, raised bridge at
unlock, restores its stand animation, makes it invulnerable and enables walking
only across a narrow road between the banks. Before unlock, the startup
bridge is removed so it cannot provide a hidden crossing. The mastery and dialogue
requirements are retained, with the same post-dialogue unlock point for both text
modes. Runtime maintenance applies to both profiles from the unchanged master.

Tests cover inherited-art clearing/custom-art preservation, locked-state removal,
mastery rejection, a single bridge on repeat opening and the bounded walking cells.
Engine acceptance must check visibility and walking in both directions after Andre's
unlock, plus a pre-unlock rejection, in a fresh PAIR013 game. Earlier Warcraft menu
checkpoints embed their previous map code.

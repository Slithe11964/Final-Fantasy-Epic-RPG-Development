# First private save-engine test: Forsaken BU

BU is a private **inventory capture/codec diagnostic**, based on BT. It lets a
human test the new inventory format against Warcraft's actual native APIs today.
Full character restoration, progression saving, file export, restarting with a
code and multiplayer transport remain unfinished. A PASS here does not establish
those features. Existing save exports stay blocked; no usable character save is
printed or written. The test does not replace heroes, move items, bind items or
apply progression.

## How to test

Use `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBU.w3x` with the modern Forsaken
client that runs BT. This build has no new classic counterpart. Start a fresh
test game, select a hero and stand still in town.

1. Type **`-savecheck`**. Stand still for about three seconds. The test captures
   quick slots, all 30 backpack positions, nine equipment slots, Gaya's six slots
   and your house's six slots, including empty gaps and both ring positions.
2. Expect **`Save test: PASS`**, an item count and encoded character count. This
   means the captured inventory passed native metadata checks, encode/decode,
   payload equality and re-encoding. Wrong-account and trailing-data input were
   also rejected without replacing the accepted test snapshot.
3. Type **`-saveverify`** without changing inventory. Expect PASS again.
4. Move an item to another backpack slot, equip/unequip something, or change a
   stack quantity. Type `-saveverify`; expect **CHANGED**. The last passing
   capture remains available. Type `-savecheck` to establish a new comparison.
5. Repeat with consumables, sparse backpack gaps, a lone alternate ring, active
   books, offhand gear, Gaya items and house items when available. Compare each
   reported item count with the occupied slots. Test fuller inventories last.

Normal quantities remain capped by gameplay at 120; the format also preserves
imported 121..127. The automated tests exercise 0 and 127 without requiring you
to manufacture those values in gameplay.

If the test reports **FAIL**, retain the exact message and inventory arrangement.
Unknown items and foreign bindings reject the entire diagnostic; nothing is
silently omitted. Moving items or changing characters during capture can produce
a normal capture-change failure; retry while standing still. A **TIMEOUT** may
indicate engine operation limits or another interrupted job: restart the test
game and report the item count. A timeout blocks retries in that game and does
not attempt a character load. Temporary flag-probe cleanup failures likewise
require a restart.

Record client build, hero/job, player slot, item count, approximate duration,
PASS/CHANGED/FAIL/TIMEOUT text and any crash or unexpected item change. First
run single-player. Separate multiplayer users can exercise per-player diagnostic
isolation later; this does not test save-code transport or desynchronization-free
character restoration.

## What the diagnostic measures

It maps actual BT originals/fNNN/gNNN aliases to the 358 frozen permanent item IDs.
The builder verifies the BS mapping against BT's actual alias tables before use.
One position is read per timer callback, followed by a second verification pass
over every position. Original handle, raw type, owner, visibility and serialized
data must still match. Life uses the exact binary32 capture module; quantities,
account-relative binding and three persistent flags are explicit.

The only item setters/deletion target a newly created, tracked `fGap` probe. It
verifies both droppability values before capturing original flags and verifies
its own deletion. No setter is applied to an original carried item. Native
creation/removal behavior still needs the human engine test.

The diagnostic stores a temporary inventory-only envelope in memory, using the
player slot as its diagnostic account ID. It is not a real account-bound profile
and never enters the existing load/file/autosave/NG routes. Talents and partial
monographs remain unsaved; cooldown refresh remains permitted for future loads.
The final codec work runs in one callback: the watchdog detects a stall, but
engine operation capacity is not yet accepted or optimized.

## Build and evidence

`build_save_probe.py` makes an isolated source copy, exports BT's actual editor
source, adds only codec/life/probe modules, and uses the existing stage builder.
It runs playable/editor compilation, layout/startup/source agreement, quest,
legacy compatibility, content, Armory/Bazaar, 96 repository regression tests and
2,000 legacy codec cases. It compares all listed original archive content except
the three intended script/editor members and MPQ CRC metadata, and retains all
original editor source. Canonical sources and BT remain untouched.

10 new probe harness tests and all 239 previous save-system checks pass (249
total). These supplement the build gates and are not native engine execution.
The legacy decoder's pre-existing unclosed item-table ResourceWarning remains.
The build compiler required execution outside the sandbox for DLL loading.

Artifacts: `checks-r16-stageBU.txt`, `build-r16-stageBU.json` and
`save-probe-BU.json` beside the map. The probe report records hashes, preserved
archive members, mapping and scratch source location. The initial failed build
retained its scratch; the duplicate diagnostic trigger declaration was corrected
before publication. CRC metadata changes are allowed explicitly, while original
gameplay content remains byte-identical.

BU SHA256: `733aac9ca30ec790b9d625768d9a794e6f98d7448ab0cca4d59a538130202d22`.
The report verifies 517 listed preserved archive members. Scratch sources:
`build/SaveProbeBU-tmtmwb6j/FFERPG`. BT SHA256 remains
`4a7cd22fe195ffec8740ff418c0d02ea17d6539d275348962f7609a34aea74b2`.

```powershell
& $ffPython experiments/Forsaken/test_save_probe.py
& $ffPython experiments/Forsaken/build_save_probe.py --stage BV
```

Choose a fresh stage for another build. Checked-build resume requires matching
map/log hashes and exact current diagnostic source, and reruns compilation/startup
and source agreement before publication. It never overwrites an existing release.

Next: complete reference promotion/reversal and character effects, then assemble
the controller. The human BU results determine any codec scheduling/native fixes
before a private full save/load build. Public release still requires the gates
in SAVE_SYSTEM_PLAN.md.

## Human result — 2026-10-09

User reports PASS for -savecheck followed by -saveverify with boots equipped,
then moving the boots into the 30-slot backpack and receiving PASS for a new
-savecheck followed by -saveverify. Attached screenshot shows a Level 1 Chemist,
one captured item, a 40-character passing snapshot followed by two 39-character
passing snapshots, and the boots in the backpack. This is evidence of the
reported one-item engine capture/codec checks across equipment and backpack.
The exact client build and player slot were not supplied. This does not establish
full character restoration, fuller inventories or multiplayer acceptance.

User subsequently reports CHANGED after moving the boots and running -saveverify
directly without another -savecheck. The second screenshot shows a passing
one-item, 39-character capture followed by "CHANGED: inventory differs from the
last passing capture", boots equipped and an empty backpack. This confirms the
reported one-item equipment/backpack change-detection case in the engine.
A new -savecheck deliberately replaces the comparison baseline, so PASS after
recapture is expected. Fuller inventories, stack changes, Gaya/house and actual
character restoration remain unverified by these results.

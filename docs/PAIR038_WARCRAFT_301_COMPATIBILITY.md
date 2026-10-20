# PAIR038: Warcraft 3.0.1 compatibility

The user reports that PAIR019 now has the same casting lockups after the client
update. This invalidates the earlier assumption that a recent map change alone
introduced them. No Warcraft gameplay was executed for this investigation.

## Evidence and casting correction

Official notes: https://us.forums.blizzard.com/en/warcraft3/t/warcraft-iii-reforged-forsaken-kingdom-patch-notes/38400/4

October 19 hotfix: https://us.forums.blizzard.com/en/warcraft3/t/warcraft-iii-reforged-hotfixes-updated-october-19-2026/28629/28
The 24371 hotfix lists a Korean-locale resource-transfer crash correction, rather
than an additional casting correction.

Blizzard changed ability defaults above level four, added a setting controlling
zero-duration buff interruption, and deprecated the original names of new 3.0
inventory natives. The installed client is 3.0.1.24371, not the older 24342 build
previously represented by our compiler headers. Current common.j, blizzard.j,
AbilityData.slk and MiscData.txt were extracted read-only from that installation.

PAIR019's reported multi-rank spells explicitly set Channel follow-through to zero
and Disable Other Abilities to false at ranks 1–4, but leave higher ranks sparse:
Fan of Knives, Bahamut/Neo Bahamut/Bahamut Zero, Death Screech, Tornado, Dragon
Breath, Rave Kick and Assault. The installed base ANcl data has 180 seconds of
follow-through and Disable Other Abilities enabled. That is a concrete exposure
to the changed inheritance behavior and fits prolonged control loss. It remains
an engine diagnosis to confirm in Warcraft, not proof from a playable test.

PAIR037's channel_defaults pass already fills all six Channel data fields from
the last explicitly authored rank, in both main and skin tables. PAIR038 retains
that correction and the active-cast tooltip guard. Deliberate true channels and
rank-specific settings remain authored. No forced global unpause or blanket
channel cancellation was added. The zero-duration interruption constant was not
changed speculatively; changing it would affect every buff/channel interaction.

## Deprecated API protection

The warning refers to the listed new 3.0 inventory APIs, not to removal of all
traditional JASS natives. The Forsaken profile uses several of these for saving,
loading, inventory, equipment, quests, fishing, and UI item inspection. Leaving
their old names in a future map could therefore break compilation/loading or
those systems when Blizzard removes them.

tools/native_api.py finalizes BOTH published playable JASS and editor custom-text
source to the supported Blz names after internal shared-profile transformations.
It changes whole code identifiers only, preserving strings, comments and BJ
wrapper names. All 19 announced aliases are covered, including the spelling fix
UnitHasAnyItemEquiped → BlzUnitHasAnyItemEquipped. Existing adapter inputs stay
compatible; this profile adaptation runs automatically on every paired build.
The shared editor master stays authoritative and is not rewritten.

Both build profiles use the actual installed common/blizzard headers for normal
checks. Classic conversion still uses the separate 1.29.2 headers. Native
publication additionally compiles the finished playable and editor scripts with
ALL 19 retiring declarations removed from common.j. This catches any dependency
on the deprecated names instead of relying on their temporary aliases.

This guards against the announced removal, not arbitrary future client changes.
The legacy build receives no Blz inventory migration and remains a separate
compatibility adaptation of the same editor master. Save format is unchanged.
Published native maps now target 3.0.1 or newer; the separate legacy output
targets 1.29.2.

## Validation and outputs

Full paired gates pass: native 258 tests (2 expected skips), classic 362 tests
(12 expected skips), plus four focused API regressions. Both profiles pass
compiler/editor/source/startup/save compatibility/content/Armory/Bazaar gates;
legacy conversion passes. The finished native map additionally compiles both
script representations with deprecated declarations removed. Its final audit
proves exactly the intended identifier translation in both scripts and byte-
identical remaining archive members relative to the gated internal build.

Both final maps are installed under new names in Maps/Download/TEST:

- FFERPG-PAIR038-Forsaken.w3x — SHA256 84012f7583176c9c5ad7a3aa4d6782706953dd7380a34df620735df6fa16f3c8
- FFERPG-PAIR038-1.29.2.w3x — SHA256 3e3272228ec81c311cb1714fedea415408900e9a17dfacdbc79ab5c16e7b4445

The authoritative final hashes and API migration evidence are in
release/pairs/PAIR038/pair-report.json. Forsaken-build.json describes the checked
internal component before API finalization; pair-report.json records its input
hash and the published output hash. Additional audits are in
build/PAIR038-final-audit.json, PAIR038-native-api-audit.json,
PAIR038-dev-save-compatibility.json and PAIR038-TEST-install.json. The shared
editor master is unchanged. dev.txt was checked read-only and remains unchanged.

## Required Warcraft acceptance

Start a new PAIR038 Forsaken game on 3.0.1, import the affected profile and test
master Fan of Knives, all three Bahamut summons, Death Screech, Tornado, Dragon
Breath, Rave Kick and Assault. After each, select another unit and return, move,
cast a second spell, and verify cooldowns and absence of repeated effects. Check
lower ranks too. Verify real Tranquility channeling remains intact. Test bag,
equipment, quick slots, job changes, fishing, quests and save/load in multiplayer.
Retest Classic on the actual 1.29.2 client. Pre-patch Warcraft menu checkpoints
are distinct from the map's portable -savef/-loadf format.

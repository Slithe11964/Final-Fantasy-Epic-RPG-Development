# Legacy save migration ledger

Audited 2026-10-08 against AS source and the BT checkpoint. This is the input
contract for the detached reference decoder in
`experiments/Forsaken/legacy_snapshot.py`, not an enabled game loader.
The frozen lookup tables are `legacy-layouts.json`. The eight synthetic vectors
in `legacy-fixtures.json` contain independent expected fields; none is a player
capture. Real E/F/G/H restart and multiplayer acceptance remains outstanding.

## Findings that affect migration

- **E/F have 22 job values.** Positions 5,6,7 target current job indexes 7,5,6:
  Lancer, Geomancer, Samurai. They are not skipped. The initial plan's proposed
  19-value V2 layout was wrong and has been corrected before implementation.
- **A low short level reads as 0 in JASS**, in both formats. The existing Python
  inspector reports 1 for that encoding. Zero can mean an unplayed job or skipped
  Freelancer creation; engine SetHeroLevel behavior and cached-job state matter.
  The snapshot retains 0 and does not silently replace it with 1. BT's playable
  ReadLevel and V2 functions were inspected and agree with this source behavior.
- **Legacy inventory positions are packed.** The writer records eligible items
  in scan order, omitting empty slots; original sparse positions are irrecoverable.
  `legacy_ordinal` is an item sequence number, not a recovered physical slot.
- **Quantities stay seven bits.** User preference: normal gameplay need not exceed
  120. Preserve imported legacy quantities 0..127 exactly, including 121..127;
  do not clamp or split them during migration. Larger quantity support is removed
  from the new-save acceptance requirements. Expandable identities/counts remain.
- **G/H fragments are the saved three-bit value**, including the writer's +1
  transformation/cap. The reader assigns that value directly. E/F use two bits.
  Migration must not subtract one merely because the writer's formula says +1.
- **Title19 is consumed but not restored.** E/F additionally derives title51
  from title32. G/H Keg Hunter is title59; partial monographs and all talent
  selections have no save fields.
- **Missing F/H Armory is pending, not empty.** Legacy permits loading its separate
  segment later. The detached snapshot marks this explicitly; a future writer
  must not produce a supposedly complete save while that segment is unresolved.

## Common envelope and primitive encoding

| Sequence | Width | Interpretation / target |
|---|---|---|
| Version | 1 plain character | E=4, F=5, G=6, H=7; F/H support separate Armory |
| Main checksum | 3 plain characters (18 bits) | Sum alphabet values of main text +11941, historical modulo rule; stops before `(` |
| Account hash | 20 bits | abs(StringHash(account name before #)) mod 2^20 |
| Difficulty | 2 bits | 0 blank NG code; 1 Simple; 2 Normal; 3 higher; see rules below |
| Currency | 20 bits | Gold +1500*lumber capped at999999; load assigns GOLD, does not restore lumber separately |

Alphabet `A-Z a-z 1-9 0 $ #`; `-`/`.` are aliases for `$`/`#`.
Every field is mixed with a rolling key initially13*version, adding211 per field
read/write, **not per bit or character**. Main and Armory padding are their own
field operations; key state continues into Armory. A reader cannot decode the
Armory payload by creating a fresh version-seeded reader.

One level cap flag covers jobs, Freelancer and (when present) Gaya. Level encoding:
short flag0 → seven-bit literal; short1 with cap0 → value0 in JASS;
short1 with cap1 →99 for E/F, or99 plus one additional mastery bit for G/H.
Saved100 represents Legendary Mastery: cached hero restoration gives mastery4
and level99; the detached value remains100. E/F short-max99 restores mastery3.
Explicit literal values remain explicit, subject to a later runtime validation
review; this parser does not invent stricter clamps than the supported reader.

## E/F main payload, after common fields

| Order | Width | Meaning / default when absent elsewhere |
|---|---|---|
| 1 | 1 | Level cap flag |
| 2 | 22 encoded levels | Job permanent IDs1..5,8,6,7,9..22; frozen independent of live JobCount |
| 3 | encoded level | Freelancer; zero skips its creation |
| 4 | encoded level | Gaya; no mastered shortcut |
| 5 | three inventory records | Hero, Gaya, house, in that order |
| 6 | 15*4 | Upgrade literals in order below; no upgrade cap flag |
| 7 | 2,2,2,1,1,1 | Gaya Break Stun, Mana Transfer, Mega Heal, Tarugaya, Sukugaya, Rakugaya |
| 8 | 20*1 | Title flags15..34; consume19 without granting;32 also grants51 |
| 9 | 5*1 | Title flags39..43 |
| 10 | 2 | Miracle stage |
| 11 | 2 | Meta fragments, direct assigned value |
| 12 | 3 | NG level0..5 assigns;6/7 leaves current default unchanged (snapshot null) |
| 13 | 1 | Cheater flag; true applies existing cheat-force/stat behavior |
| 14 | to next six-bit character | Encrypted zero padding |

Speedrun level, Legendary Guardian, Gaya mastered flag, title59 and the higher
Armory eligibility bit do not exist in E/F. Snapshot null means no encoded value,
not permission to erase a current-game default. No fabricated save progress.

## G/H main payload, after common fields

| Order | Width | Meaning |
|---|---|---|
| 1 | 1 | Gaya mastered shortcut |
| 2 | 1 | NG bit1 |
| 3 | 1 | Level cap flag |
| 4 | 22 encoded levels | Job permanent IDs1..22 in current frozen order |
| 5 | encoded level | Freelancer |
| 6 | encoded level +2,2,2,1,1,1 | Gaya level/abilities, **only if not mastered** |
| 7 | 1 | NG bit4 |
| 8 | three inventory records | Hero, Gaya, house |
| 9 | 1 | Upgrade cap flag |
| 10 | 15 encoded upgrades | Short flag1 means10 if cap1, otherwise leaves research default0; short0 adds four-bit literal |
| 11 | 1 | NG bit2 |
| 12 | 1,1,2,1,1 | Title18; ignored19; ladder15/16/17; title20; title59 |
| 13 | 2 + conditional1 | Ladder21/22/23; title24 only when ladder reaches3 |
| 14 | 1,1 | Title29,54 |
| 15 | 2 + conditional1 | Ladder25/26/27; title28 only when ladder reaches3 |
| 16 | 1,1 | Title53,34 |
| 17 | 3 | Title ladder30/31/32/33/49 plus51, detailed below |
| 18 | 1,1 | Title50,43 |
| 19 | 2 + conditional1 | Ladder39/40/41; title42 only when ladder reaches3 |
| 20 | 1 | Title55 |
| 21 | 1,4,1,1 | Ignored reserved bit; Speedrun level; two ignored reserved bits |
| 22 | 2,3 | Miracle stage, saved fragment value |
| 23 | 1,1,1 | NG bit8, Legendary Guardian flag, Armory higher-difficulty eligibility |
| 24 | to next six-bit character | Encrypted zero padding |

Mastered Gaya implies level99, all three bought abilities at3, all three support
skills present, their purchases researched and Spiritual Power level8. Preserve
this explicit implication rather than reading nonexistent level/ability fields.
Unmastered support skills add1/2/4 to Spiritual Power according to their flags.

NG value = bit1 +2*bit2 +4*bit4 +8*bit8. Values11..15 restore15-value;
0..5 restore5+value;6..10 trigger existing cheat handling. Preserve wire value
and resulting status separately. Runtime cheat handling is not performed here.

For the three-bit title ladder:1 grants30;2 grants30+51;3 grants30+31;
4 adds51;5 adds32;6 adds33;7 adds49. Each ordinary two-bit ladder grants all
lower ranks through its value. Title recomputation after load remains necessary.

## Inventory and progression identities

Each inventory: three-bit count followed by count*(nine-bit item ID plus seven-bit
quantity **only when frozen charged classification says so**). Count must be0..6.
IDs1..358 resolve through save-identities.json; unknown IDs reject before mutation.
Noncharged quantity is null: use the reviewed object's creation defaults later,
not an invented saved quantity. Charged0 and127 are retained. No item binding,
owner player number, life/proficiency or cooldown field exists in these codes.
The legacy loader binds accepted items to the loading account/player. V2's21
rejected item IDs are consumed (including quantity) but not materialized; Speedrun
food is likewise consumed and discarded under the current mode policy. The
snapshot retains raw records so that these intentional rules can be applied
explicitly in the transaction adapter, rather than mistaken for parser losses.

Upgrade IDs1..15 correspond to R000..R00B,R00M,R00N,R00L in that order: Tools,
Sword,Bow,Rod,Staff,Plate,Leather,Mystic,Axe,Spear,Katana,Dagger,Gun,Greatsword,
Inner Mana. These IDs are namespaced independently of item/job IDs. Legacy title
flags are represented by their flag IDs in a separate namespace. This does not
allocate new persistent quest/era IDs or promise saving all current quest stages.

## Armory segment and eligibility

Plain Armory header is own checksum(3) followed by main checksum copy(3).
Validate both before decoding records. The current reader performs two ignored
18-bit reads through those plain headers, advancing the rolling key. Bitmap
order is the frozen276 legacy eligible records, then Materia71,100,103,150.
The four original positions of those Materia are skipped. Category records
501..540 are not inventory identities or bitmap entries.

Opcodes are field operations: `1,value(1),count(6)` repeats a bit;
`0,1,count(8)` reads count literal one-bit values; `0,0,1` means one owned entry;
`0,0,0` ends the bitmap, defaulting all remaining entries to false. Zero-length
runs, runs exceeding the frozen order and unsupported trailing data reject.
Writer always appends000, even when the game reader has exhausted its catalogue.
Then encrypted zero padding. E/F removes the21 legacy-rejected IDs after Armory
decode; retain saved and effective ID sets separately. The historical writer's
early terminator does not accidentally grant any of the appended Materia.

Runtime policies are separate from syntax validation: name ownership, loading
window/Hardcore/once-only rules, difficulty restrictions and item eligibility.
Current OpenCode allows blank difficulty0; higher-difficulty rejection is
`current>1 && saved>0 && ((current==5 && saved<3) || saved<2)`.
Current difficulty6 records the saved difficulty instead. G/H's final eligibility
bit0 blocks Armory when current difficulty>=5. F uses its legacy removal rule.
No detached decode constitutes an accepted runtime load.

## Routes and intentional New Game changes

Normal chat/file/autosave shares Save_WriteCode. NG+/− uses a distinct legacy
writer: blank difficulty0, currency300; resets jobs/Freelancer/Gaya, abilities,
inventories, upgrades, title ladders and Speedrun level; retains Miracle stage;
fragments become0. NG+ increments level (extra increment for Guardian), capped10,
conditionally carries Armory and Guardian, and sets its higher-difficulty bit
from current/original difficulty. NG− omits Armory/Guardian. **Source discrepancy:**
the current NG− branch emits NG wire value9, which the current reader treats as
cheating rather than a valid reset. Executed-source regression reproduces this;
the BT playable writer matches source tokens. This is not an in-game acceptance
result and no legacy function was changed. **User decision: retire New Game
Minus from the replacement system.** Do not implement a successor Minus writer,
command or repair project. Keep historical decoding and this audit fixture for
compatibility research; current experimental exports remain blocked.
Exact condition fingerprints remain protected; new implementations need captured
NG+ fixtures before claiming parity. Armory-only load attaches to the pending
reader/main checksum and must never materialize inventory a second time.

## Validation and next work

Run with the bundled Python path documented in FORSAKEN_REAPPLICATION.md:

```powershell
& $ffPython experiments/Forsaken/test_legacy_snapshot.py
& $ffPython experiments/Forsaken/legacy_snapshot.py --input build/player-code.txt --player AccountName --trace
```

Input is plain code text (not a preload script); decoder does not execute it or
write files. It enforces a research input bound16384 characters, not a measured
Warcraft transport limit. It rejects bad checksums/links, unknown inventory IDs,
oversized counts, malformed framing, trailing text and nonzero padding.
The legacy additive checksum cannot detect every corruption or forgery.

Automated evidence: fixed E/F/G/H vectors; every main-field read width/value and
key transition compared with executed source under mocked world operations;
current Armory writer dense/sparse/random and historical writer before Materia;
executed NG+ reset and NG− discrepancy;
frozen charge/rejection classification; truncation/corruption/owner tests.
The subset harness substitutes JASS's single-character integer literal 'd'=100;
this is documented test translation, not a changed game function.

Outstanding: consented real legacy codes with independently recorded expected
progress/Armory, real NG+ and default-level engine behavior, all runtime mode
rules, persistent item metadata audit, deterministic inventory adapter, frozen
quest/Chronicle registry review and multiplayer/restart tests. Step2's decoder
foundation is implemented; its real-data and runtime acceptance gates remain open.

Checkpoint validation:13 new tests pass, covering eight pinned E/F/G/H vectors,
eight main-reader configurations,52 current Armory writer cases and eight
historical Armory writer cases. Existing itemtable helper emits a file-handle
ResourceWarning; validation still passes. BT runtime/source token equality was
checked for ReadLevel, LoadCodeV2 and Save_WriteNewGameCode.
Existing codec selftest:2,000 cases PASS. Repository regression run:95 passed;
one test failed because Windows sandbox temporary-file access was denied. The
same build-overwrite protection test passed when rerun with TEMP/TMP pointing to
`build/save-migration-test-temp`. No test or game code was relaxed to resolve it.

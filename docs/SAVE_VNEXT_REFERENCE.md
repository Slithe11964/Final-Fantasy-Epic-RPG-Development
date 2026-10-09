# New save reference prototype, version1

Implemented in `experiments/Forsaken/save_vnext.py`; tests in test_save_vnext.py.
The bounded envelope/inventory/job foundation now includes a logical progression
profile and detached legacy translation: [SAVE_PROGRESSION_MIGRATION.md](SAVE_PROGRESSION_MIGRATION.md).
Core currency/NG+ state, titles, Gaya abilities, upgrades and Armory are represented.
Runtime capture, item eligibility and NG+ export policy are not implemented.
No Warcraft route recognizes this envelope. Keep saving blocked.

## Encoding and limits

Use the existing64-character alphabet. Unsigned scalar integers use base32
varints: each alphabet value has five data bits and one continuation bit, least
significant group first. Range0..2147483647; at most seven groups; shortest form
required. Readers validate the seventh group's range before accepting it.
Length units are encoded alphabet characters, not UTF-8 bytes or decoded bits.
No whitespace, colors or alternate alphabet is accepted by this prototype.

Envelope order: literal `FSV`; envelope version varint1;20-bit-range account hash
as varint; payload character length; section count; checksum varint; payload.
Checksum covers header up to section count plus payload, excluding checksum.
Two accumulators start a=1,b=0; for each alphabet value v, update
a=(a+v+1)%32749 and b=(b+a)%32749. Result=b*32768+a. Intermediates fit signed JASS
integers. This detects tested corruption, not forgery or every possible change.
Canonical encoding permits byte-identical decode/re-encode comparison.

Reference bounds: payload16384 characters; at most32 unique sections; aggregate
unknown optional payload/metadata4096 characters; at most57 inventory records;
at most2048 counted scalar records; at most256 dormant extension progression
records. Bounds are enforced before unbounded count-driven loops. The decoder
checks total input length before parsing. These are research parser budgets,
not measured Warcraft chat/file/string/memory/operation capacities.

Each section: ID, schema version, required flag0/1, length, payload. All header
fields are canonical varints. Reject duplicate section IDs, unsupported flags,
unsupported required schema, truncated lengths or trailing bytes. Unknown
optional section/version is retained exactly and grants nothing. Required vs
optional is part of the sender's schema contract, not permission to ignore a
required unknown section. Only the future complete-save profile can define
which sections must be present; this generic envelope does not yet enforce one.

## Typed section reservations

| Section | Schema1 payload | Prototype meaning |
|---|---|---|
| 1 | Counted length-delimited item records | Detached inventory data |
| 2 | Count then `(permanent job ID,saved level)` pairs | Levels0..100; default semantics remain a later adapter obligation |
| 3 | Count then `(extension progression ID,unsigned value)` pairs | Optional and dormant; bounded preservation only, no actual quest rewards/state application |

Sections 4–9 reserve core, Gaya, upgrades, titles, Armory and required migration
evidence. Their field IDs, profile requirements and absence semantics are specified
in [SAVE_PROGRESSION_MIGRATION.md](SAVE_PROGRESSION_MIGRATION.md).

These are experimental section reservations. They do not allocate real new
jobs/items/quest IDs or make unreviewed quest state persistent. Scalar records
carry explicit counts; permanent IDs are positive and unique per namespace.
Known missing job IDs are not automatically replaced with live defaults here.

Item record: record ordinal; canonical item ID; holder ID; zero-based slot;
quantity-present flag; optional fixed-seven-bit quantity; account-binding flag;
metadata count; metadata entries. Each record is prefixed by its character length.
Quantity is two alphabet characters: low6 bits then high1 bit; remaining high
bits must be zero. Presence=false is different from explicit zero. Quantities
0..127 round-trip; gameplay target remains120, with121..127 retained for imported
codes. Values128+ reject; no truncation or implicit splitting.

Holder IDs:1 quick(6),2 bag(30),3 equipment(9),4 Gaya(6),5 house(6).
Equipment slots0..8 are Helm,Chest,Gloves,Boots,Ring1,Ring2,Primary,Offhand,Trinket.
Unoccupied slots have no record; occupied positions and record ordinals must be
unique. Legitimate identical item IDs in different slots remain separate items.
Binding0 means unbound;1 means bound to the envelope account, never a player slot.
The eventual capture policy must apply historical owner/save eligibility before
encoding. Decoder data by itself does not authorize item creation.

Metadata entry: ID; required flag; length; payload. At most16 entries per item,
with no duplicate IDs. Metadata1 is life: two varints containing unsigned16-bit
words of the exact finite-positive binary32 value. Metadata2 is item flags varint:
bit0 invulnerable, bit1 droppable, bit2 pawnable. Absence means uncaptured/default
provenance to resolve explicitly, not zero life or cleared flags. Runtime capture
must supply fields required by the eventual complete-save schema. Unknown optional
metadata is retained; required unknown metadata rejects the whole envelope.

## Unknown content preservation

There is no materializer in this prototype. An item with an unavailable canonical
ID remains a detached record in its original holder/slot; an adapter must keep
that slot reserved and prohibit duplication or use. Do not materialize a fallback
item with the same record ordinal. Unknown optional metadata, sections and schema
versions re-emit exact bytes under the shared4096-character budget. Known-format
dormant progression also has a256-record budget. Unknown schema cannot expose a
trusted record count, so its independent byte budget applies instead.

Checksums, envelope framing and known structural schemas are validated. The
prototype cannot validate the semantics inside an unknown schema; it preserves
bounded opaque bytes without executing them. Exhausted budgets reject, never
drop unknown records. Updated classic preservation remains a later implementation;
this codec is not proof of Forsaken/classic round trips.

## Evidence and outstanding work

Tests: all57 positions; sparse bag1/7/18/29; both ring positions; repeated item
types; permanent item IDs above500;42 jobs;50 dormant future progression records;
0/120/127 quantity; exact fractional life; golden envelopes;1000 seeded randomized
reference round trips; duplicate/count/length/overflow/unknown-schema/account and
corruption rejection; combined opaque budgets and known payload overflow.

Golden fixture files pin three envelopes and checksum recurrence is independently
recalculated in tests. These synthetic fixtures were not generated by Warcraft.
Run with the bundled Python from FORSAKEN_REAPPLICATION.md:

```powershell
& $ffPython experiments/Forsaken/test_save_vnext.py
& $ffPython experiments/Forsaken/measure_save_vnext.py
```

Measured synthetic profiles (account hash1048575, each item has quantity120,
life145.25 and flag metadata5):

| Profile | Encoded characters |
|---|---:|
| All57 occupied inventory positions | 1453 |
| Same +42 jobs +50 dormant progression records | 1804 |
| Same + optional data filling the shared4096-character preservation budget | 5705 |

These exclude complete progression, Armory, transport framing and engine overhead.
They demonstrate reference-parser handling, not a maximum population guarantee.
Validation at this checkpoint:13 prototype tests PASS, including1000 seeded
random round trips;13 existing legacy migration tests PASS. No runtime sources
changed, so no new playable map, compilation or in-game acceptance is claimed.

The next checkpoint implements logical progression, legacy-to-new translation,
62-entry comparison reports and fuller size profiles; see the migration document.
Next: differential JASS codec/adapters, exact life conversion, failure rollback and
real restart/multiplayer transport tests. No public capacity or preservation claim
is warranted from these Python round trips alone.

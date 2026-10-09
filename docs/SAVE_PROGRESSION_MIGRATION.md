# Logical progression and detached migration, schema 1

2026-10-08. `save_progression.py` extends the reference codec with the progression
fields audited in E/F/G/H. `migrate_save.py` translates a complete legacy code into
that reference format and compares the typed result with its retained source.
These tools do not create Warcraft items, accept a runtime load, or enable saving.
New Game Minus has no successor writer or command.

## Permanent section and field IDs

Sections 1–3 retain their definitions in [SAVE_VNEXT_REFERENCE.md](SAVE_VNEXT_REFERENCE.md).
The following schema-1 sections use counted `(ID, unsigned value)` pairs unless
otherwise specified. IDs are namespaced by section. Do not reorder/reassign them.

| Section | Meaning | Validation |
|---|---|---|
| 4 | Core fields in the table below | Unique known field IDs and per-field ranges |
| 5 | Gaya fields below | All eight fields in a logical snapshot; mastery implications checked |
| 6 | Upgrades | IDs 1–15 from frozen legacy-layouts.json; values 0–15, preserving four-bit legacy literals |
| 7 | Saved title flags | Positive title flag IDs with value 1; absent flags grant nothing |
| 8 | Armory ownership | Canonical item IDs with value 1; category records 501–540 are not migrated ownership |
| 9 | Legacy provenance | Policy version, Speedrun flag, original-code character count, then ASCII codepoints as varints |

| Section 4 field | Meaning | Range |
|---|---|---|
| 1 | Saved difficulty/origin | 0–6; E/F/G/H retain their original 0–3 value |
| 2 | Gold balance | 0–2147483647 |
| 3 | Shard balance | 0–2147483647; absent in migrated legacy snapshots |
| 4 | Freelancer level | 0–100 |
| 5 | New Game Plus level | 0–10 |
| 6 | Miracle stage | 0–3 |
| 7 | Meta fragments | 0–7 |
| 8 | Speedrun level | 0–15; absent when E/F did not encode it |
| 9 | Legendary Guardian flag | 0/1; absent for E/F |
| 10 | Armory eligibility on higher difficulties | 0/1; absent for E/F |
| 11 | Legacy cheat status | 0/1; translation refuses true rather than clearing it |

Section 5 IDs: 1 mastered (0/1), 2 level (0–100), 3 Break Stun (0–3),
4 Mana Transfer (0–3), 5 Mega Heal (0–3), 6 Tarugaya (0/1), 7 Sukugaya (0/1),
8 Rakugaya (0/1). Mastered requires level 99, bought abilities 3 and support flags 1.
Research unlocks, Spiritual Power and mastery bonuses remain adapter-derived effects.

`snapshot()` validates the logical profile in addition to generic envelope syntax.
Sections 1, 2, 4–8 must be present, required and schema 1, including empty sets.
Frozen job IDs 1–22 and upgrade IDs 1–15 must be present. Additional counted job
IDs remain detached data; an unavailable job grants no runtime level or bonus.
Core fields 1, 2, 4, 6, 7, 11 are mandatory. Omission of other migrated fields
means **not encoded**, not saved zero or permission to replace a game default.
An E/F NG value 6/7 remains absent because the old reader does not assign a level.

Profiles without legacy provenance require every core field and explicit item
life/flag metadata. This is a capture contract, not an implemented capture path.
Gold and shards are separate logical fields for future capture; the runtime
currency/export policy still needs verification. Legacy `Save_Begin` combines
gold +1500*shards, caps the result at 999999, and the loader assigns that number
to GOLD only. Migration preserves that saved number as gold and does not invent
a shard balance or reverse a lossy conversion. No economy behavior changes here.

## Frozen migration policy 1

`migration-policy.json` pins 276 canonical gear IDs from the retained BS mapping,
seven Chocobo food IDs from Cmd, and the 21 V2-rejected IDs from the legacy ledger.
Tests compare these lists with canonical Armory identities and the reviewed
source predicate. Changing behavior requires a new policy version; do not edit
policy 1 to reinterpret an existing migration's evidence.

Process hero, Gaya, then house records in their saved packed order. Assign a
unique ordinal before filtering. V2-rejected items are excluded for E/F in every
container. Speedrun context excludes food in every container. Each exclusion has
an explicit report entry and remains recoverable from the required source evidence.
Hero gear occupies successive bag slots starting at 0; other hero items occupy
successive quick slots. Equipment stays empty. Gaya and house retain separate
holders, with accepted items packed in saved order. No original sparse gaps can
be recovered from legacy bits. Identical items remain separate; quantity null,
zero, 120 and imported 121–127 keep their meanings. Every accepted item is bound
to the source account, matching the old loader's binding policy.

No life or flags are guessed. Their absence, together with section 9, means
`legacy-object-defaults-unresolved`. The future adapter must resolve reviewed
canonical creation defaults, enforce eligibility and capture provenance before
mutation. Original code evidence also preserves ignored/reserved bits, source
version, NG wire encoding, original inventory records and pre-filter Armory.
Partial monographs and per-game talent choices are not added as durable fields.

Provenance policy 1 stores the cleaned original E/F/G/H code, including the linked
Armory segment. Its ASCII values are varints so parentheses can be represented
inside the restricted envelope alphabet. Bound: 8–4096 original characters.
It is known required data with its own bound, separate from the 4096-character
unknown-data allowance; the entire envelope still fits the 16384 payload bound.
No truncation. The old decoder can research inputs larger than this migration
budget; those cannot be exported as this profile.

F/H without their linked segment are pending and refuse translation. Wrong-account
checks, legacy checksums/links and syntax errors fail before translation. Cheat
status refuses a clean successor export, including the audited broken Minus
output. Other runtime policies are intentionally not evaluated: difficulty
acceptance, Hardcore/load window, once-per-game, item eligibility and current-world
effects must pass the later transactional adapter.

## Equality report and evidence

Each translation can be encoded, decoded and passed to `comparison()`. It compares
62 entries: account; each core field (including absence); job values/ID set;
upgrades; Gaya fields; titles; effective Armory; the exact placed item tuples;
and source readiness. Report `equal` requires every comparison to pass. Checksums
recomputed after a typed-field change still yield a failed semantic comparison.
Item exclusions appear separately as deliberate policy decisions, not codec loss.

The CLI emits a successor code only after the comparison passes. Generic envelope
decoding and `snapshot()` alone are structural validation, not migration approval:
they do not replay the embedded legacy decoder. Consumers must run the semantic
comparison and later runtime eligibility checks. Unknown optional sections remain
in the original Envelope for byte-identical re-emission; the projected dictionary
is not a lossless replacement for that Envelope. No materializer exists.

Policy-1 evidence describes the immutable migration artifact. After actual gameplay
changes, its comparison is no longer an equality test of the current character.
The later adapter must finish validated migration/default resolution and establish
a newly captured profile; it must not present an old source comparison as proof
that subsequent runtime saves were captured correctly.

```powershell
& $ffPython experiments/Forsaken/test_save_migration.py
& $ffPython experiments/Forsaken/migrate_save.py --input build/player-code.txt --player AccountName
# Add --speedrun only when evaluating that actual load context.
& $ffPython experiments/Forsaken/measure_save_vnext.py
```

Eight synthetic E/F/G/H fixtures have pinned successor codes, independent typed
expectations and passing equality reports. They are not consented real player
captures. Tests also cover actual source-produced NG+ reset, refusal of the
broken Minus result, dense Armory in F/H, Speedrun food filtering, required fields,
metadata provenance, ranges, evidence bounds and 250 seeded progression round trips.
Checkpoint validation: 16 migration tests, 13 reference codec tests (1000 seeded
round trips), 13 legacy decoder tests and 10 identity tests PASS. CLI tests verify
passing account/comparison checks emit a code and a wrong account emits none.

Measured profiles: full 57-item logical snapshot with 42 jobs, 31 title flags,
280 Armory entries and 50 dormant progression records is **2803 characters**;
adding the full shared unknown-data budget gives **6704**. Migrated fixtures range
346–521 characters including source evidence. These are specific synthetic sizes,
not maximum-content or Warcraft string/file/chat/multiplayer capacity guarantees.

The isolated JASS implementation/vectors are now recorded in
[SAVE_JASS_CODEC.md](SAVE_JASS_CODEC.md). Next: engine execution limits, runtime capture,
default resolution, transactional restoration/rollback and measured transport.
Real-code and in-game acceptance gates in [SAVE_SYSTEM_PLAN.md](SAVE_SYSTEM_PLAN.md)
remain open. Saving stays blocked; baseline Z, development AS and experiment BT
are unchanged, and map stage BU remains unused.

# Connected57-position inventory and house cargo

Bounds correction,2026-10-09: staging now rejects points outside the actual playable
rectangle with128 clearance before any allocation. BW/BX's private probe used a
point below terrain; BY uses the journaled original house location. Original houses
are preplaced; the separate owned house is transaction/test scaffolding. Real-engine
acceptance remains pending. See [SAVE_HOUSE_ENGINE_TEST.md](SAVE_HOUSE_ENGINE_TEST.md).

2026-10-09, isolated transaction preparation; no full character load command.

The saved-profile and guarded cargo routes now cover all57 positions: six quick,
30 bag, nine equipment, six Gaya and six house. The separately owned replacement
house stays hidden, paused, invulnerable and neutral-owned; original house items
remain in their original journaled slots. A prepared house attaches at cargo Begin.
No house record is materialized without a verified owned house context.

Cargo/profile row strides and the ordinal position map now use57 consistently.
House entries use canonical item rawcodes, exact slot, quantity/binding/life/flags
and the existing ability preparation/placement primitives. Placement readback
checks the house container owner independently from the item owner: neutral house,
item bound/owned by the loading player. Full-batch audits include all hero-role
units and the house. Equipment remains first, before a potentially full bag.

Unknown house records retain the entire source and remain dormant in their logical
positions; a prepared house is still required. Existing house contents may now
remain untouched during target preparation when that replacement is present.
Legacy migration evidence and unknown optional metadata preservation rules are
unchanged. Imported quantities121..127 remain lossless.

House context/provenance functions live below the cargo bridge to avoid circular
library dependencies. FSP_HouseShape supplies shared native container readback.
Pending house guards continue blocking activation and prepared-unit disposal.
House deletion/release refuses while cargo or profile state remains active.
Cargo recovery removes only tracked replacement items, verifies every owned unit
and house empty, and releases its plan before house recovery is allowed. Failed
item deletion or unexpected house cargo retains guards for retry; foreign items
are never deleted to force a passing audit.

Validation: five new house-cargo cases plus43 prior house/profile/cargo/placement
checks PASS (48 distinct tests; one failure-injection fixture was corrected and
rerun). Full57 and sparse house layouts, player7, quantities0/120/127, dormant
house records, placement/deletion failure and unexpected cargo are covered.
Ten private house-probe checks plus32 codec/probe/position regressions also PASS.
Three final isolated compilation probes PASS:
`build/save-codec-compile-kloyunqa/report.json`;24 source hashes/CRLF verified.
These are mocked-native and compiler evidence, not Warcraft engine acceptance.

The next required human gate is the BW synthetic house diagnostic documented in
SAVE_HOUSE_ENGINE_TEST.md. It exercises the same native staging, metadata, ability
preparation, exact-house placement and shared house-shape readback using temporary
zero-ability spacer items. It does not execute the full prepared hero/profile
transaction or publish a character save/load.

Still pending: equipment-derived projection, reviewed runtime policy initialization,
legacy migration/default integration, reversible live house references, loaded
activation, complete controller/transport and multiplayer acceptance. Saving stays
blocked. BT/BU remain unchanged; BW is a private diagnostic, not a public release.

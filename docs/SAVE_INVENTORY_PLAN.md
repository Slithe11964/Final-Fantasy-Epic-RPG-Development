# Current-map inventory targets

2026-10-09, isolated read-only checkpoint. No new map, native item creation,
placement or successful character-load route.

`experiments/Forsaken/save_inventory_plan.py` resolves the validated logical
profile against the actual BT item objects, BS gear mapping and compiled BT
stored-passive table. The immutable catalog contains 358 canonical identities,
276 equipment mappings and 1,012 passive IDs. Map and mapping SHA256 values are
attached to each target so a future controller can require the same inputs.
The supplied native alias slots must agree with the actual object definitions.

All 57 positions remain explicit: quick6, backpack30, equipment9, Gaya6 and
house6. Bag gear resolves to its native equipment variant; equipment resolves
to the exact type for that slot, including a primary weapon's offhand variant.
Both ring slots remain separate. Quick/Gaya/house records use canonical objects.
These choices describe targets; native holder eligibility, requirements and
placement success still require the synchronized adapter and exact readback.

Captured life and flags are restored from their exact metadata. Bound items use
the destination player's binding and owner. Explicit quantities retain0–127,
including imported121–127; the user's normal120 limit is unchanged. Missing
quantities require an explicit object charge field or caller-supplied reviewed
default. Missing inherited abilities require caller-supplied reviewed defaults.
Legacy life/flags require matching migration evidence and an explicit per-position
default for the exact resolved rawcode. There are no inferred base-item defaults.
The supplied values in the legacy tests are synthetic, not approved engine defaults.

Every actual item ability receives an audit role from the compiled passive table;
the harmless fGmk marker retains the non-suspended role. Duplicate ability IDs
and lists beyond the existing16-ability audit capacity refuse the target.
Unknown canonical IDs and unknown optional item metadata remain complete dormant
records with reserved positions. Wrong accounts, invalid players, cheat status,
incomplete profiles and wrong equipment slots refuse before any native mutation.

Validation: 12 new checks plus53 focused transaction/registry/migration/codec
regressions PASS. Coverage includes all276 gear mappings, complete57-position
targets, sparse backpack slot29, duplicate rings, binding, life/flags, quantities,
dormant preservation and explicit legacy defaults across all eight pinned vectors.
BT and BU hashes remain unchanged. No JASS changed; compilation was not rerun.

Next integration must extend the existing guards to audit owned prepared cargo
through recovery phases. FSN/FSA/FSP/FSE currently refuse while preceding journals
are active, and FSU/FSO/FHP/FHA checks assume empty replacement units. Do not bypass
those guards. Equipment effects must become part of the expected prepared hero
projection, and original house items must be quarantined before house writes.
Availability verification, broader player effects, native inventory placement,
controller commit and installed-engine acceptance remain pending. Full new saves
and loads remain blocked; BV is still unused.

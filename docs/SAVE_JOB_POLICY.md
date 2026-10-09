# Saved normal-job preparation bridge

2026-10-09, isolated experiment; no new map or gameplay load route.

save_hero_policy.py validates a complete accepted logical profile and expected
account before resolving the 22 reviewed permanent job IDs. It retains the
original envelope, legacy evidence, optional sections and unknown job records.
Unknown jobs remain dormant and grant no native units, mastery or bonuses.
Cheat status refuses this clean-load policy rather than guessing an override.

Normal-job schema1 values map as follows:

| Saved value | Native target level | Mastery rank | Added base attribute bonus | Five learned skill ranks | Final points |
|---|---|---|---|---|---|
| 0 | 1 when materialized | 1 | 0 | 0, 0, 0, 0, 0 | 1 |
| 1–49 | saved level | 1 | 0 | 0, 0, 0, 0, 0 | level |
| 50–98 | saved level | 2 | 20 each | 11, 11, 11, 11, 6 | level−50 |
| 99 | 99 | 3 | 50 each | 11, 11, 11, 11, 6 | 49 |
| 100 | 99 | 4 | 100 each | 11, 11, 11, 11, 6 | 49 |

The last row preserves the existing enhanced-mastery sentinel. Zero retains
the saved absence of progress; the table does not eagerly allocate every job.
The controller still selects which reviewed roles to materialize. Per-skill
choices and unspent points are not durable inputs to these fresh normal jobs.

Forsaken-save-job-policy.j maps a permanent identity to the matching staged
normal role and records its core/mastery ability plan through the existing
prepared-hero APIs. It refuses role mismatches, Gaya/Freelancer roles, repeated
plans, invalid levels, overflow and conflicting mastery/skill IDs before recording
the core. It adds the mastery bonus exactly once to caller-supplied grown base
attributes. The caller must supply reviewed XP and natural grown base attributes
for the target native level, excluding mastery/title/equipment bonuses.
No XP curve, growth rounding or native level clamp is invented. FHP_Apply still
verifies XP and level; a mismatch retains the failed plan for disposal/recovery.
The bridge itself performs no native setters and introduces no new journal.

This is a partial normal-job plan, not a complete combat projection. Mastery bonus
abilities, Chemist Alchemy/brew availability, titles and other derived effects
still need translation and verification. Gaya's persisted support ranks/research
and Freelancer's per-game borrowed choices remain separate pending policies.
The original units and skills continue to recover through the existing journals.

Evidence: 12 new policy/actual-source bridge tests and 53 focused prepared-hero,
migration, format and registry regressions PASS (65 unique checks this checkpoint).
Coverage includes all 101 schema1 values across all 22 identities, detached
legacy translation, unknown optional data, account/cheat rejection, read-only
planning, native XP mismatch, overflow, player7, missing mastery ability and
retry without doubling bonuses. Standalone/BT runtime/editor compile PASS:
build/save-codec-compile-zgse3g26/report.json. Earlier 320-check checkpoint remains
recorded separately; the entire prior suite was not rerun for this additive bridge.

Run test_save_hero_policy.py plus the prepared-hero, migration, format and registry
regressions. Compile with check_save_jass.py --activation --job-policy and the
existing BT/native-library arguments. Native mocks and compiler acceptance do
not establish in-game behavior. Full export/load/commit stays blocked; BT/BU
remain unchanged, BV unused.

## Future level caps

Following checkpoint: [SAVE_GAYA_POLICY.md](SAVE_GAYA_POLICY.md) resolves Gaya's
support/chant fields and separate player targets. Freelancer and remaining combat
effects/native evidence/controller integration remain open.

The user wants the option of level 150, with save-format headroom for 999.
The underlying bounded integer encoding can represent both, but current job
schema1 and preparation guards deliberately accept only the existing 0–100
interpretation. Never relax that guard and reinterpret old value100 as level100.

Before changing the cap, introduce a reviewed versioned job record with separate
actual level and mastery tier. Migrate legacy value100 to level99/tier4 and retain
all other legacy meanings. Future records can then store level150 or999 without
overloading a level as a status flag. Unsupported required record schemas must
reject on older readers; retain version1 decoding for existing characters.
Use an explicit supported level cap and separate mastery thresholds in the load
policy. Skill mastery at50 remains the user's current rule unless changed.

The engine XP curve, native level readback, integer budgets, attribute growth,
skill points, cap rewards, UI, save transport and classic adapter all need tests
at the chosen cap. This checkpoint records the requirement, not a claim that the
current map or Warcraft client has passed level999 acceptance.

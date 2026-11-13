# QuickUI91 and Creature Review 03

QuickUI91 continues the full Dragoon test from QuickUI90. Production releases, the classic map, editor master and all earlier candidates are preserved.

## World-pool cleanup

Removed `nlpd`, `nlpr`, `nmrv`, `nmsn`, `ntrh`, `ntrt` and Dark Goblin Great Shaman (`ndth`) from all ordinary world spawn pools. Removed Dark Goblin (`ndtr`), Dark Goblin Berserker (`ndtb`), Dark Goblin Trapper (`ndtt`) and Dark Goblin Shaman (`ndtp`) from Central Islands only. Forest occurrences of Dark Goblin and Dark Goblin Shaman remain.

Only `Trig_Spawn_Pools_Init_Actions` changes in the playable script. Every other pool entry and weight stays unchanged. Unit objects, loot taxonomy, equipment mappings and arena definitions are retained, allowing these creatures to remain in arena teams.

Arena audit:

| Unit | Arena usage |
|---|---|
| nmrv, nmsn | Dark Fish Clan, team 46 |
| Dark Goblin Shaman (ndtp) | Top Gang, team 97 |
| Dark Goblin Great Shaman (ndth) | Registered arena roster entry; no named team reference found |
| nlpd, nlpr, ntrh, ntrt, ndtr, ndtb, ndtt | No named team reference found |

## Creature Review 03

Separate map built from QuickUI91's actual current objects and trigger modules, including all Forest, Barrens, Mountains and Highroad changes. Earlier review builds scanned the source checkout; this build exports and scans the current candidate instead.

Each of the nine world areas has separate groups for regular pools, Boundary/later additions, rare hunts, and local bosses/summons. All 28 Hunt Board creatures are explicitly included, including creatures dynamically selected by the hunt system. Hunt descriptions provide location hints where available; otherwise original hunt spawn rectangles and nearest regional spawn footprints determine placement. The location evidence is exported in `Encounter-Origins.json`. Nilrem's Necromancer form is explicitly beside Guardia Forest, separate from its spawn pool. The Cultist's Demon Hound is beside Northern Mountains. Arena of Darkness, other story/world encounters and Battle Arena retain separate sections. Arena duplicates are intentional.

Selection stays silent. Exhibits are player-controlled and damageable, with Normal one-player baseline data and authored boss equipment, ability ranks and hero levels where identifiable. Ability tooltips include calculation information; gameplay fields remain unchanged. The current damage engine and regional monster-role mechanics run in this review. Full boss encounter phases, quest progression, loot, ordinary world spawning, save/load and RPG inventory UI do not start.

Controls:

- `-area 1` through `-area 13`: world/encounter sections and practice arena.
- `-info`: selected creature's origin and live stats.
- `-abilities [page]`: on-card spell calculations.
- `-spells [page]`: scripted mechanics and calculations.
- `-test`: player-controlled practice copy.
- `-enemy`: hostile practice copy using current monster-role AI.
- `-wound`: halve selected creature's health for healing/Devour tests.
- `-day` / `-night`: test Night Might.
- `-refresh`, `-mana`, `-reset`, `-hurt`, `-safe` / `-vulnerable`: practice controls.

Alert countdowns can be observed, but the isolated review does not generate live regional spawn waves. Devour can be tested on injured allied exhibits from the matching pool. Native spell behavior, layout usability and live AI still need in-game acceptance; compilation alone does not establish multiplayer stability.

## Verification

Focused checks compare every before/after spawn pool and all unchanged weights, forest exceptions, exact arena definitions, object data, all 28 rare hunts, Nilrem and hound placement, non-overlapping exhibit positions, current unit stats, unchanged ability gameplay payloads, silent selection, damageable control and single combat startup registration. Both playable and editable scripts compile and pass startup/source/global pairing checks. QuickUI91 also passes content-reference and save-compatibility checks (358 items, 22 jobs). See build logs and the release-directory reports for results and hashes.

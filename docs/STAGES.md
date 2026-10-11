# Stage log

One line per build. Full build notes up to 2026-10-10 are in
[history/STAGES_LOG_2026-10.md](history/STAGES_LOG_2026-10.md); details for a feature belong in that feature's doc,
not here. Maps kept in `release/`: stage AS (Reforged + 1.29.2) and Forsaken BT, CB, CP and newer.
Older maps were moved out of the repo on 2026-10-10.

Add a new row after each build: `| <stage> | <one sentence> |`. Mark Forsaken builds with "Forsaken:".

| Stage | What |
|---|---|
| start | r15: phases 8-9 |
| A | `docs/BUGS.md`: suspected bugs found while writing the guides |
| B | Developer test commands: module `DevCommands` (folder 11), `docs/DEBUG_COMMANDS.md` |
| C | Save code tool `tools/savecode.py` (decode/encode/selftest), `-dumpitems` dev command, `tools/sync_module.py` (put a changed module into the... |
| D | Object reference: `tools/objects.py` + `tools/objdata.py` (reads/writes object data, byte-exact round trip) -> `docs/OBJECTS.md`,... |
| E | 1.29.2 converter `MapToolkit/tools/downgrade.py` (terrain, doodads, units, objects, map info, script) |
| F | Quest map: `tools/quest_map.py` -> `docs/QUESTS.md` (quest-log entries and links per quest/boss module) + `docs/quest-graph.mmd` |
| G | System guides: `CHOCOBOS.md`, `GAYA.md`, `SUMMONS_AND_SHADOWS.md`, `CRAFTING.md`, `HUNTS.md` |
| H | Map list fix: our built maps (since r13) had lost the 512-byte `HM3W` header, so 1.29.2's map list skipped them |
| I | 1.29.2 crash on selecting the map: Reforged had moved all object names/tooltips into `war3map.wts` (37,926 strings, 5 MB) and 1.29.2 crashes... |
| J | 1.29.2: caster frozen after Fan of Knives |
| K | Phase 16 tidy-up: shared `udg_Temp*` variables became locals in 509 functions (321 modules), proven private to each function... |
| L | Built from your editor save (FFETEST = stage K saved in World Editor, DevCommands switched off) |
| M | Quest engine (`QuestEngine` module, `docs/QUEST_ENGINE.md`): quests as data, with talk / return / kill / deliver / custom steps |
| N | Quest engine batch 1: Arachnophobia, Harpy Hunt, Gnoll Hunt, Phoenix, Find Shimmerweed, Deliver Letter, Greed is Good and Elixir now run on the... |
| O | 62 side quests on the quest engine (all side quests but Cartographer) |
| P | Main story on the quest engine (Find Mid ... Advent of Ice Age, 18 quests incl. Necrophobe) |
| Q | Kalm Siege I/II: Complete trigger disables itself (no repeated reward / "Quest Completed" when the siege timer runs out again) |
| R | Ao Madoushi (MainQuest[4]) on the quest engine with custom steps |
| S | Last two quests converted: Cartographer repeat reports/first-talk completion and True Ice Age shared log/delayed announcement/retries |
| T | Readiness #2/3/4: one-command build, full enabled-body drift guard, quest/content/save checks, fixed G/H vectors, event/lifecycle tests and... |
| U | Final safeguard review: trace waits inside conditions/returns/nested arguments |
| V | Readiness #6 first pass: six functions in TrueIceAge/Cartographer own summoner/group/location/scan/reward scratch values and pass helper context... |
| W | Repair World Editor folder/source pairing: appended QuestEngine shifted 118 editor source assignments |
| X | Legacy appearance mitigation in downgrade shortcut: explicit empty inherited art on Chemist Pharmacology/Ninja Dual Wield |
| Y | Correct X selection workaround: restore all Gaya/unit UI geometry, keep explicit Chemist/Ninja passive art |
| Z | New paired r16 baseline: user quest-log/pathing edits and complete object data carried into W master |
| AA | Verify pinned default build after baseline packaging, no enabled module changes |
| AB | Armory discovery: 276 missing gear entries show question-mark icons with hover/click hints |
| AC | Correct Mina and Halberd of Justice discovery hints using user-confirmed routes: Fairy Voodoo and level-99 Valfodr |
| AD | Remove armory page controls |
| AE | Bazaar last-slot Recipes icon |
| AF | Bazaar five anonymous recipe choices per page |
| AG | Five complete Reforged Bazaar panels (three top, two below), scrollable ingredients and individual Craft buttons |
| AH | Three tall Reforged Bazaar panels |
| AI | Inset Bazaar ingredient and price text |
| AJ | Move Bazaar Close above the panels, away from normal game controls, and set its frame level explicitly |
| AK | Eight marks per recipe-1 page with grouped heading |
| AL | House Armory tooltip adds local stored/total collection counter, refreshed after deposit/withdraw/load within one second |
| AM | Materia category beside Accessories: Aeroga, Demiga, Quakeraga and Wateraga storage, question marks/hints, 280-entry counter |
| AN | All seven active chocobo nuts/greens append to inventory save IDs (352..358), preserving quantities |
| AO | Harpy Hunt opens two seconds after accepting Kollin's Arachnophobia task |
| AP | Chronicles page 2 moves Time Trial and adds Secrets/Keg Hunter |
| AQ | Secrets Chronicle category and Keg Hunter remain hidden until completion |
| AR | Replace the Next page Chronicle icon with Warcraft's standard move-arrow icon (`BTNMove.blp`) |
| AS | Integrate user-placed Shipyard/ArenaDarkness travel regions from the editor-saved AR |
| AT | Forsaken: Separate native 3.0 bag/equipment preview: 276 Armory gear items assigned to loadout types, 4 Materia unchanged |
| AU | Forsaken: Replace global equipment-type edits with 276 separate native variants |
| AV | Forsaken: Explicit fBgi/fGer item abilities based on native AIni/AEqu |
| AW | Forsaken: Attach fBag,fGer,ASpc directly/permanently to the player hero to bypass item attachment |
| AX | Forsaken: Enable required Game Data Version 2 (Forsaken Kingdom) in map metadata |
| AY | Forsaken: Stop automatic gear conversion |
| AZ | Forsaken: Automatically fill empty native equipment slots using AY's safe conversion checks |
| BA | Forsaken: Keep consumables in the native bag across jobs: transfer after clearing destination quick slots, temporarily suspend that empty AInv, move... |
| BB | Forsaken: Preserve exact 30-slot sparse bag positions using temporary ability-free spacers and synchronous cleanup |
| BC | Forsaken: Keep accepted BB sparse bag transfer |
| BD | Forsaken: Accepted BC UI/bag retained |
| BE | Forsaken: BD accepted |
| BF | Forsaken: Remove Equip gear button/sync |
| BG | Forsaken: Fix BF duplication by tracking actual replacement handles, accept quick/bag routing, delete rejection/retain original, no failed retry or pickup... |
| BH | Forsaken: Fix item/passive regeneration via prepared-map raw-ID/rank metadata |
| BI | Forsaken: Rearrange stats: flat guard page 1, elemental labels and Physical/Magical damage page 3 without Split values legend, HP regen page 4 |
| BJ | Forsaken: Fix Reforged skin tooltip overrides for Armory gear/missing entries and item gear descriptions |
| BK | Forsaken: Extended-only slot hints |
| BL | Forsaken: Includes BK UI/stats/gear-passive/dual-wield/Firefly changes |
| BM | Forsaken: Internal spacer warning fix |
| BN | Forsaken: Native Equipment class attempted to prevent bagged stat effects (native testing failed) |
| BO | Forsaken: Suppress only stored passive abilities |
| BP | Forsaken: Independent choices within each mastery-unlocked talent row |
| BQ | Forsaken: Retain BP's independent talent rows and bagged active book abilities |
| BR | Forsaken: Correct doubled accuracy |
| BS | Forsaken: Retry full-bag rejected gear on fresh pickup |
| BT | Forsaken: labels-only patch of BS (Cat's Bell, Deathbringer); last gameplay checkpoint for the Forsaken gear branch |
| BU-CA | Forsaken: private save-system diagnostics (`-savecheck`, `-savehousecheck`); see SAVE_ENGINE_TEST.md / SAVE_HOUSE_ENGINE_TEST.md |
| CB | Forsaken: house storage diagnostic, **user-confirmed PASS** |
| CC-CS | Forsaken: boots / equipment diagnostic development; see SAVE_GEAR_ENGINE_TEST.md |
| CT | Forsaken: contained real-boots equipment/storage/speed/cleanup diagnostic, **user-confirmed PASS** on savecheck, savegearcheck and saveverify; full character saving remains disabled |
| CU | Private file save/fresh-load prototype built, superseded before playtesting by CV with stored-item activation preparation. |
| CV | Private fresh-load build added stored-item activation preparation, superseded before playtesting by CW with Freelancer skill-choice handling. |
| CW | Private real-character file save/restart/fresh-load prototype ready for engine testing, with exact full-profile verification and retryable attempt cleanup. |
| ASB | From your editor save ASA (bigger Shipyard region): Esc closes the Bazaar panels; Armory and Chronicle counters also try the 1.29.2 tooltip level so they can show in classic |
| CX | Private full-character round trip now reports capture validation details to identify the real export failure. |
| ASC | Job talents (TALENTS.md): Talents button on every hero, Reforged panel / 1.29.2 dialog; Priest row 1 = Deprotect, Deshell, Blinding Light |
| CY | Private full-character saving preserves Meta Fragment counts beyond the legacy bit limit, with fresh-load readback verified in modeled checks. |
| CZ | Private full-character file export uses smaller chunks to avoid the engine truncation observed in CY. |
| ASD | Talents: compact 1.29.2 dialog, short Priest texts, Blinding Light 5 s on pass-through, Cure rebased on Channel so it can target any enemy, Shrine sells Reset Talents (1000 gold, current job) |
| DA | Private save files initialize readback directly and report non-execution or returned length after CZ produced a valid disk profile. |
| ASE | Talent rows named Beginner, Master, Ultimate, Legendary |
| ASF | Tooling: one build makes both the Reforged and the 1.29.2 map (same content as ASE) |
| DB | Private file readback assembles separate temporary local fields and restores them, replacing DA’s player-name accumulation that returned only the final chunk. |
| DC | Private file readback uses separate player-name slots with checked file parts and restores all names, replacing DB's unavailable tooltip fields. |
| DD | Private export uses bounded character lookup and capture/write progress messages after DC stopped before reporting file readback. |
| DE | Capture and fresh loading use the legacy writer's difficulty tiers consistently, correcting DD's false Inferno rejection. |

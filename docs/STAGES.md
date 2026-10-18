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
| DB | Private file readback assembles separate temporary local fields and restores them, replacing DAÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢s player-name accumulation that returned only the final chunk. |
| DC | Private file readback uses separate player-name slots with checked file parts and restores all names, replacing DB's unavailable tooltip fields. |
| DD | Private export uses bounded character lookup and capture/write progress messages after DC stopped before reporting file readback. |
| DE | Capture and fresh loading use the legacy writer's difficulty tiers consistently, correcting DD's false Inferno rejection. |
| DF | Fresh loading reports the exact failed setup step after DE reached creation and manual cleanup preserved retry eligibility. |
| DG | Fresh loading restores Gaya purchase research as flags and ability ranks separately, fixing DFÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢s rank3 versus research1 failure. |
| DH | Fresh creation directly enables and checks Forsaken hero backpack/equipment abilities after DG failed the first stored-item pickup. |
| DI | Stored-item preparation verifies pickup across quick, bag and equipment while keeping exact final placement and distinguishing native rejection. |
| DJ | Tester build adds bounded later-tick cleanup confirmation and a real-profile failure/retry check, retaining one-load and window restrictions. |
| DK | Fresh loading creates carryable original gear for Gaya and house, fixing DJÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢s native Tome placement failure while preserving permanent IDs. |
| DL | Forsaken builders carry the approved r17 scenario description and current Intro into editor and playable sources, retaining DKÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢s verified loader. |
| DM | Updated developer editor module adds all saveable item copies and missing Chronicle awards, including Time Trial progress, while retaining single-player gating. |
| DN | Private Forsaken integration routes normal and named save/load commands to the verified new format while retaining legacy imports and r17 presentation. |
| DO | Morning tester build adds a usage guard for malformed save commands while retaining DN normal/named file routing, legacy imports and fresh-load safeguards. |
| DP | Fresh load transfers the inactive Freelancer to Neutral Passive after verification, removing its player portrait while retaining saved progression and job switching. |
| DQ | Screen-only saves display numbered screenshot pages, chat loads assemble the complete validated profile, and exact-name file imports detect legacy or new format. |
| DR | Screenshot save pages restore legacy character colors, show prominent repeated page totals and next-page commands, and fit three complete parts while preserving existing codes. |
| DS | File saves show legacy destination and verification messages without displaying or replacing screenshot codes; only normal save updates the colored code pages. |
| DT | Town Shrine of Individuality stays visible, unmastered Freelancer purchases are silent, and mastered fresh loads restore the original shrine unlock and menus. |
| DW | Saves capture in one frame (no standing still), loads replace the starter in place, loaded masteries restore food used, title unlocks and total job level, and files load whatever page size wrote them. |
| DX | DW with 920-character file pages, for testing multi-file saves and missing-part rejection. Test only. |
| ASG | Backpack holder, withdrawn: invented object fields corrupted the object data. |
| ASH | ASG with the Backpack objects rebuilt from fields, icons and order strings the map itself already uses. |
| ASI | Backpack order string moved to the column Channel reads, the bagged item keeps its own instance and charges, and -bag opens the holder without the button. |
| ASJ | Backpack holder gets a real model, loses Locust-like traits and the pause, so it can be selected; -bagwhere reports the holder. |
| ASM | Backpack holder rebuilt from the stock footman, and a dialog list of stored items when the game will not select it. |
| ASN | Blinding Light blinds an enemy it is aimed at, Reset Talents moves to the shrine bottom-left, and the backpack holder keeps only its own buttons. |
| ASO | Reset Talents returns to the slot it shipped in after moving it broke the shop, and -blindcheck counts what the blinding sphere hook sees. |
| ASQ | Backpack gains seven pages with Next and Previous buttons, pickups fill bag pages only, and -blindcheck reports whether the sphere hook is registered at all. |
| ASR | The backpack page stands beside the hero and follows it, so items drop within reach and can be dragged between hero and holder; -grab takes the nearest item off the ground into the open page. |
| ASS | Equipment pages enforce one item per slot kind from the reviewed gear table, wrong or doubled pieces go to the bag, worn items grant their passive bonuses to the hero, and -gear lists what is worn. |
| AST | Blinding Light registers on the missile system's own hit hook instead of a second condition on the damage trigger, which was never reached, and -blindcheck counts how often a missile touches a unit. |
| ASU | The backpack holder stands invisibly on the hero, pickups land on the open page, the holder has no attacks or cast point so pages turn at once, and page 2 blocks its three surplus slots so both versions offer the same space. |
| ASV | The backpack holder moves and so its wisp follows, it is scaled away rather than only made transparent, blocked slots wear a Locked slot icon, and power-ups are left alone so buying a tome no longer crashes 1.29.2. |
| ASW | Backpack object fields are written once instead of twice, every item move waits for a timer outside the event that announced it so pickups no longer crash 1.29.2, the holder uses a model that transparency hides, and blocked slots read "Blocked". |
| ASX | Worn-gear bonuses move off the hero's command card, so job abilities stop being replaced by "Tool tip missing"; the Backpack button wears a loot sack; and Blinding Light sweeps around the sphere itself instead of waiting for its healing splash to touch someone. |
| ASY | The hero's six slots become carrying space that pays out nothing, items cast from a page spend the hero's mana, gear and consumables each share one cooldown across the pages and the hero, and the Backpack button wears a chest. |
| ATC | Classic water casts use an active transparent proxy, and item magic plus food/potions each share their own item-duration cooldown across all backpack pages and hero slots. |
| ATD | Adds one water-engine check that compares normal, delayed, detector-free and stock proxy casts and reports real spell events, while preserving the confirmed cross-page cooldowns. |
| ATE | Replaces rejected native water-proxy casts with the Forsaken scripted cone wave and classic moving effects, keeping the original damage formula and confirmed shared cooldowns. |
| ATF | Ground pickups fill empty matching equipment kinds before regular bag routing, preserving occupied gear, original items and deferred bonus refresh. |
| ATG | The 1.29.2 map saves with the Reforged FSVB code: the new save modules are ported unchanged except bag and equipment lookups, which read the backpack pages (SAVE_129.md); old codes still load. Keg Hunter and Secrets read like the other Chronicles. |
| ForsakenDY | Built on DW with unchanged normal save paging, restored loaded Chronicle categories, active Priest talents and three-second hero/Gaya house portals. |
| ForsakenDZ | Fixed Priest talent reset deleting the hero, moved Reset to bottom-left and Legendary Bonus to bottom-right, and restored earned/unspent milestone points on the DW save base. |
| ATH | The map's item checks see the backpack: quests, keys and hand-ins find items anywhere in it, while magic defense, proficiency, two-handed, bare-handed and cursed-gear rules read only the two equipment pages. |
| ATI | Equipment pages enforce the original Equip rules: Spirit of Gaya level and Legendary Master requirements (refused gear goes to the bag, or the ground when full), two weapons only with Dual Wield, and wearing gear ends the No Gear speedrun accolade. |
| ATJ | Merges Forsaken DZ gameplay into the normal map: Gaya Strength counted once, Trident/Storm Lance accuracy, ammunition elements follow the weapon in hand, item spells keep rank while cast, slot lines on gear tooltips, 3-second house portals and the DZ shrine layout (FORSAKEN_PARITY.md). |
| ATK | `-stats` shows the Forsaken stat pages as text (damage, defenses, resistances, other bonuses); save and load messages drop the prototype wording and timings and say only whether it worked and why not. |
| ATL | The new save is on in the Reforged map too; save/load wording is plain in the Reforged sources; difficulty rule: Simple-Hard saves load in Simple-Hard, Inferno saves anywhere, Nightmare loads any save, Inferno refuses saves made below it (new and old codes). |
| ATM | Preserved imported save eligibility through Nightmare resaves in both clients and fixed the reserved parameter name in the shared save-cache helper. |
| ForsakenEA | Restored the native Reforged Forsaken inventory from DW/DZ with current save messages and Nightmare tier rules, rejecting classic backpack modules. |
| ATN | Added explicit classic collection-tooltip levels, category and total summaries through -armory/-chronicle, and all nine equipment slots through -equipment for 1.29.2. |
| ATO | Fixed classic autosave to use the full file-save pipeline, added Secrets and Armory category/subcategory progress, and restored the eligible New Game Plus load notice. |
| ForsakenEB | Kept native Reforged inventory while routing autosave through the full file-save pipeline and restoring the eligible New Game Plus load notice. |
| ATP | Added per-category Armory ability tooltips, restored Bazaar prepare/purchase and recipe notices, and released import snapshots for the classic Warcraft saved-game crash retest. |
| ForsakenEC | Kept native inventory while adding per-category Armory tooltips, Bazaar prepare/purchase and recipe notices, and completed import snapshot cleanup. |
| ATQ | Moved recipe-ready notices to the merchant receiving sold parts; Warcraft menu-load crash after import remains unresolved. |
| ForsakenED | Kept native inventory and moved recipe-ready notices to the merchant receiving sold parts. |
| ATR | Retained replaced starter bodies as hidden, paused neutral units for the classic imported-character Warcraft checkpoint crash retest; same-session memory failure remains separate. |
| ForsakenEE | Retained replaced starter bodies as hidden, paused neutral units for the Reforged imported-character checkpoint crash retest; native inventory and save format preserved. |
| ATS | Guarded hero/Gaya level restoration to correct level-one Tiny import promotion; native checkpoint failure remains unresolved. |
| ForsakenEF | Applied the same guarded level restoration while preserving native inventory and the shared save format. |
| ATS-StringProbe | Separate classic diagnostic: one command creates a long runtime string without importing or changing a character; gameplay objects match ATS. |
| ATT | Bounded new-format save runtime strings for the classic native-checkpoint failure; byte-identical codes/files and paged inventory retained. Endgame Warcraft menu reload awaits acceptance. |
| ForsakenEG | Matching bounded new-format save storage on DW native inventory; code/file format preserved. Endgame Warcraft menu reload awaits acceptance. |
| ATU | Split bounded-code validation into limited execution steps, drain one cache packet per player/tick, and recover timed-out imports through verified cleanup after ATT stalled. In-game acceptance pending. |
| ForsakenEH | Initial matching bounded-validation build on native inventory; superseded by EI before tester acceptance to include final owned-writer timeout cleanup. |
| ForsakenEI | Final native-inventory match for ATU: isolated validation execution steps and verified timeout rollback, including owned capture-writer cleanup. Import and native checkpoint acceptance pending. |
| ForsakenEK | Secrets wording/count updated in native base and skin; Bazaar and Stats/Talents frames rebuild after Warcraft menu loads, with safe fresh-game initialization and fallback button access. Native inventory and save format retained; in-game acceptance pending. |
| ForsakenEL | Secrets uses the standard gold Chronicle category counter (category 12); removes the outdated Simple difficulty save restriction message. Retains EK UI recovery and native inventory; in-game presentation acceptance pending. |
| ForsakenEM | Starting Ao Madoushi directly offers Phoenix and Annoying Monster independently of the exact-six counter; repeated availability preserves active/completed quests. Retains EL Secrets/Simple text and native inventory. In-game quest acceptance pending. |
| ForsakenEN | Native curse scrolls used by hero/Gaya search both inventories, every extended bag slot and equipment, resolving native aliases. Replace one item, consume scroll on success, retain original/scroll on failure. Retains EM quests and native inventory; curse acceptance pending. |
| ATV | Classic all-page hero/Gaya curses with equipment-rule recheck and rollback; includes shared Ao Madoushi side offers and removes the outdated Simple warning. Classic compilation/conversion passed; in-game acceptance pending. |
| PAIR004 | Single Reforged editor master -> paired native EN/ATV classic outputs; preserves compatible world/scenario/object/trigger edits and each inventory/UI. Compiler/content/startup/save gates pass; native 110 tests and classic 201 tests (8 skipped). Includes 18 merge/scenario/default-reset regressions and edited-map conversion checks. Actual editor-save/gameplay acceptance pending. |
| PAIR007 | Isolates local file-assembly fragments from shared decode state, preserves FSVB/file/packet bytes and refreshes reviewed runtime support from an unchanged editor master. Both profile gates and concurrent two-client model pass. Native multiplayer engine retest pending; classic Warcraft checkpoint crash unresolved, with a separately named no-items diagnostic prepared. PAIR005/PAIR006 stopped at gates and did not publish pairs. |
| PAIR010 | Removes shared scanner/ExecuteFunc calls from private file IO and first-packet preparation; synchronized receivers validate contents, export checksums run before local writes, and legacy checksums use bounded private steps. Both profile gates passed (native 110; classic 202 with 8 skipped); focused IO 16, transport 23, pair 19, port 7 tests passed. TEST copies hash verified. Native multiplayer retest pending; classic checkpoint crash unresolved. PAIR008/PAIR009 stopped at classic source-agreement gates and did not publish. |
| PAIR011 | PAIR010 multiplayer desync fix accepted; follow-up releases finished projectile hit groups, guards motion pools, reclaims unrooted save fragments with separate shared/private queues, caches native UI reads and invalidates collection counts on changes. Editor master unchanged; both profile gates pass (native 110; classic 210 with 10 skipped), plus focused strings 20, runtime health 8, transport 23 and port 7. TEST copies hash verified. Extended multiplayer freezing retest pending; classic endgame Warcraft checkpoint remains unresolved. |
| PAIR012 | Eidolon proximity return; independent ten-destination travel pages in requested order with stable unlock IDs; native full-bag quest lookups; all-slot charged-item stacking and Gather consolidation of hero/Gaya/house and house-ground stacks; equipped-only Hero Medicine refill and native Sleipnir stale-effect cleanup. Editor master unchanged; both profile gates pass (native 120; classic 220 with 10 skipped), including 10 focused inventory/travel/equipment tests. TEST copies hash verified. Warcraft gameplay acceptance pending; retains PAIR011 stability work and shared save format. |
| PAIR013 | Extends Chemist/Ninja inherited-attachment suppression to custom Amgl markers in both profiles, including Dark Knight, Reaper and Arena circle/hint passives; preserves authored art and unit UI. Elysium starts with no live bridge; Andre unlock creates a raised/extended invulnerable crossing, stand animation and narrow walkable shore corridor. Editor master unchanged. All gates passed (native 124; classic 224 with 10 skipped), including four new visual/unlock regressions; TEST copies hash verified. In-game icon/bridge acceptance pending; PAIR012 gameplay accepted by user. |

| PAIR014 | Internal checked job-effects candidate: native 132 tests; classic 232 with 10 skipped. Not installed in TEST; superseded by PAIR016. |
| PAIR015 | Internal checked follow-up adds two-Prophet shield handoff cleanup and Enraged attack-speed display: native 134 tests; classic 234 with 10 skipped. Not installed in TEST; superseded by PAIR016 row-allocation correction. |
| PAIR016 | Final shared job patch: Necromancer/Skeleton Champion inert markers; mana healing no longer inverted on undead; timer-based 90-second Undying; rank-correct Aim data/15-level damage marker; visible-to-engine Myriad/Meteor channel proxies; full-bag Chemist consumption; robust Divine Shield mana payment/handoff; detailed Imperil ladder; rank-aware active-effect stat rows with exact row allocation. Editor master unchanged. All gates passed (native 134; classic 234 with 10 skipped), including 10 focused regressions. Final archives and TEST copies hash verified. In-game acceptance pending; see JOB_EFFECTS.md. |
| PAIR017 | Native-only short visibility restore after backpack drop/use/unequip refresh; B/Escape, selection changes and checkpoint rebuild cancel. Local UI state never gates shared item operations; gameplay handlers verified unchanged against PAIR016. All gates pass (native 139; classic 239 with 10 skips), including five focused UI regressions. Final archives and TEST hashes verified; engine acceptance pending. Obsolete scratch cleanup moved 186 entries/77,239 files/~17.26 GB into outer _delete with verified manifest, retaining sources, tools, all releases and unresolved crash diagnostics. |
| PAIR018 | Release candidate from the user's editor master: 0.9.7.4 patch notes (Intro, quest log), Reminder links, quest/map edits, with PAIR017's backpack fix. Builder lays out base/skin object fields like the editor reference, keeps reference values for fields World Editor dropped as defaults, and supplies the HM3W header when the save has none; resulting object data equals PAIR017's. All gates pass. |
| PAIR019 | PAIR018 plus the master's scenario name change to 0.9.7.4. Release candidate. All gates pass. |

PAIR020: Save capture skips nonpersistent/unregistered items and foreign-bound gear as empty saved slots; no live inventory mutations, no format/identity changes. Count only emitted records; preserve two-pass capture checks. Covers both paired profiles through reviewed save-string refresh, retaining native/classic storage adapters. Capture and bounded-string regression tests pass. Paired build/engine acceptance recorded separately.
PAIR020 validation: both paired build gates PASS (native 139 tests; classic 239 with 10 expected skips). Focused actual-JASS capture 17 and bounded-string 22 regressions PASS. Final archives verified for skip policy and profile-specific drop adapters; FRC_At/FRC_StartNow token-identical to PAIR019. Pair manifest and current transform hashes match. Outputs in release/pairs/PAIR020; engine acceptance pending.

PAIR021: Persistent local native backpack open intent replaces the PAIR017 item-only half-second restore. Explicit B/Escape/close actions clear intent with native-toggle race suppression; selection keeps intent. A shared-startup close control overlays a named native close child or falls back beside Talents, using bounded/cached UI-only queries. Item listener creation is idempotent across UI rebuilds. Classic inventory and gameplay functions unchanged. Ten focused control-flow tests PASS; paired gates and engine acceptance recorded separately.
PAIR021 validation: paired gates PASS, native 144 tests and classic 244 (10 expected skips). Final native archive includes persistent intent and explicit close controls; inventory/rebind/carry and save capture functions token-identical to PAIR020. Final classic runtime entirely token-identical to PAIR020. Output hashes and current inventory_ui.py provenance verified. Both TEST copies hash-verified. Fresh-game idle/drop/use/close and checkpoint UI acceptance pending.

PAIR022: Master-rank summon monster levels40 via isolated nonhero templates (Animal/Dragon, Summoner, Bahamut/Neo, Raise Dead, Battle Ward; Bahamut Zero already40). Lower ranks and world originals preserved. Rage A070/A025 tooltips match actual rank-aware +120/+100 master bonuses. Trance lethal protection and Mirage +40 physical evasion/x0.8 physical-hit chance added to Defenses; Aim +20% master verified. Sixteen focused regression tests PASS; full pair/archive/engine acceptance recorded separately.

PAIR022 validation: paired gates passed; superseded before installation by PAIR023 with further user-requested stat presentation changes.

PAIR023: Includes PAIR022 summon/Rage/effect rows; requested stat ordering/percentage units, conditional Flat damage, Hold Position-only Defend display, dynamic White Robe Life bonus and explanatory tooltips. Fifth proficiency page and reversible native Back/Next buttons (legacy -stats next/back); max house upgrades keep informational proficiency icons. Hunt Club hides/restores with native inventory using original desired visibility. Master is snapshotted without modification; both profiles retain their distinct inventory/save implementations. Validation pending.
PAIR023 validation: native 162 tests and classic 262 (10 expected skips) PASS; all compiler/editor/startup/content/save-compatibility/armory/bazaar gates PASS. Final native and 1.29.2 archives verified for robe descriptions, completed proficiency passives, five pages/navigation, level40 nonhero summon templates and profile separation. Damage engine and save-read functions token-identical to PAIR021; native equip/rebind/backpack-intent functions unchanged. Output/tool/master hashes verified. First attempt stopped on a test trying to read absent classic HeroStats from native export; corrected profile-aware fixture and reran both complete gates. Both TEST installations hash-verified. In-game acceptance of house icons, navigation, Hunt cover and new rows is pending.

PAIR024: Priest Master row Acid Rain (50% Tranquility healing value as enemy damage), Refresh (food/stat buff duration reset, special hero effects +3 seconds, base Esuna cooldown20), Swiftmend (same Regen healing in half time). Numeric Regen tooltip, native talent hover descriptions and selected talents appended to affected spell text. Synchronized buff metadata and per-buff replay copies preserve rank; Runic/Divine timers extend without replaying gameplay actions. No save IDs changed. Initial compiler reserved-name issue corrected; an internal candidate stopped for icon/mana-recovery audit corrections. Full paired validation pending.
PAIR024 validation: native173 tests and classic273 (10 expected skips), all compiler/editor/startup/content/save compatibility/armory/bazaar gates PASS. Corrected classic dependency cycle by keeping talent choice/UI data below inventory and placing spell runtime in TRegen; independent cooldown override avoids reverse dependency. Final archives verified for shared Priest hooks, half-duration master Regen, profile UI separation and preserved save transport/combat/backpack functions. Master/tool/output hashes match; both TEST copies hash-verified. In-engine talent/proxy/buff-duration acceptance remains pending.

PAIR025: Rank-aware damage details for 40 requested spell families (87 ability IDs), preserving authored effects and gameplay data. Finisher outcomes/probabilities, full Noxious Mixture quality table, per-hit/wave/pulse distinctions, combo/distance/HP scaling. Both object layers updated from editor master. Scroll of Shadows and 25 curse scrolls exempt from Gaya holding-level checks, including older item life values; resulting gear levels remain intact and are labeled explicitly. Six focused regressions pass, including correction of stale Holy Blast travel percentages, Meteor wave counts, Liquid Steel hit counts and Thundaga targets in the original prose. First internal candidate stopped for these wording corrections; full paired validation pending. See DAMAGE_TOOLTIPS.md.
PAIR025 validation: both paired gates PASS, native179 tests and classic279 (10 expected skips), compiler/editor/startup/content/save compatibility/armory/bazaar checks. Final native base+skin and classic object archives cover all requested ranks and scroll descriptions. All non-tooltip object fields unchanged; only runtime difference from PAIR024 is the scroll Gaya-level exemption predicate. Combat/save/inventory routines identical. Master/tool/output hashes match and both TEST copies hash-verified. Actual Warcraft tooltip rendering and scroll carrying acceptance pending.

PAIR026: Strict equipped-only native passive bonuses while allowing quick-slot gear, Prototype Crossbow equipment metadata, worn cloak/fishing adapters, synchronized gear/consumable cooldown vetoes, scripted falling-wave Myriad/Meteor, nongear carrying-level exemption, 280-entry-only armory deposits, Pram basic breeding, six-form Freelancer capture/load, and linked native bag/gear visibility without the portrait close button. Same editor master and shared build pipeline; profile-specific inventory adapters retained. Focused tests include six-form load verification, final-wave damage/filter/cleanup, cooldown denial across hero/Gaya, armory membership and linked pane controls. Full paired validation pending. See EQUIPMENT_INTEGRITY.md.

PAIR026 internal validation: initial private gates caught missing/new profile fixture setup, generation consistency for nonpersistent Prototype gear and lowered codec formatting; corrected the generator/port exclusion and verified the affected tests against both actual exported profiles before the final paired rerun. No incomplete candidate was installed or published.

PAIR026 validation: native191 and classic291 tests (10 expected skips), compiler/editor/startup/content/save compatibility/armory/bazaar gates and 1.29.2 conversion PASS. Final archive audit verifies 280 armory entries, six Freelancer forms, both rain handlers, strict quick/worn passive and regen scans, prototype metadata, native cooldown pools and linked pane controls; native/classic profile separation retained. Current tool/input/output hashes match; both TEST copies hash-verified. Master unchanged. Native SHA256 b35573e271fb8158ed68653599ffe597f40ec5e82e2a5a2880468673fb3f5918; classic SHA256 115b08c87f7961544e2135be4b5ccbbc74f17bef77370c72905df2ae5b535e60. Actual engine acceptance remains pending; no claim to repair the earlier legacy large-character menu-checkpoint issue.

PAIR027: Resolve the actual SimpleEquipmentInventoryPanel and rebind native inventory commands to the current hero before restoring a linked pair; failed binding hides both. Fishing discovery scans carried/loaded/aliased rods across both profile adapters and Gaya, while casting requires a worn matching rod. Native explicit quick-slot moves create carried gear copies, suspend passives and retain actives. Acid Rain splits Tranquility healing 50/50 into healing/magic damage; rank-aware healing formulas/current amounts for Tranquility, Cure, Pray, Blessing of Light; Refresh base cooldown45. Focused UI12/equipment13/Priest12 regressions and full native195/classic295 gates passed. Not installed: final archive audit caught native quick-slot load bindings still creating equipment aliases; superseded by PAIR028. See INVENTORY_PANEL_FISHING.md.

PAIR028: Final quick-slot save restoration handles both canonical and native equipment bindings; per-target healing flags clear even without damage events. Includes PAIR027 panel/fishing/healing changes. Focused equipment14/Priest12 PASS; full validation pending.

PAIR028 validation: native196/classic296 tests (10 expected skips), compilation, editor/startup/content/save compatibility/armory/bazaar checks and classic conversion PASS. Final archive audit verifies all276 carried-gear aliases and native quick-slot save bindings, unchanged canonical item classes/IDs/actives, profile UI separation, exact native bag frame/current-hero binding, fishing discovery/worn cast gates, zero native Tranquility healing plus scripted half-split pulse and per-target flag reset, rank healing descriptions and Refresh45. Master/tool/output hashes verified; both TEST copies hash-verified. Native SHA256 1ded9750e4d6222f30654799851b94e482574872bf079d8cce79ac099769bdb9; classic SHA256 7040ca76158ea6ffc66a43a458cc41c6d1a2400c75054fed21a5023f3c85bf11. Actual engine acceptance remains pending.

PAIR029: Per-player bazaar reveal, level99 current-job legendary checklist with green completed milestones, optional calculation sections preserving authored spell prose, Curaga/Osmose/Drain formulas, selected-only Acid Rain text, durable legendary trials/element/summon save section11 with rollback, native gear carry classification, header X/Escape, persistent Talents toggle and open-armory refresh. Initial native206 regression candidate passed but stopped before publication to correct Water/Thunder labels. Added bounded real-codec old/new profile round-trip coverage. Final build pending. See PLAYER_COMMANDS_AND_LEGENDARY.md.

PAIR029 validation: native208/classic308 tests (10 expected skips), all compilation/editor/startup/content/save compatibility/armory/bazaar gates and classic conversion PASS. Second internal candidate stopped to replace full-string tooltip caching with integer fingerprints; final cache/old-new bounded codec/rollback/player display regressions pass. Final archives verified for all105 ability/rank calculation texts, conditional talents, optional trial section11, old-profile acceptance, 276 native carry aliases/load bindings, native gear metadata, X/Escape/persistent Talents and armory refresh. Editor master/tool/output hashes match and both TEST copies hash-verified. Native SHA256 1aa69f5962030b0e06aa3d168a9cc15a6150b8d96cfeb8a3643b67612de84292; classic SHA256 41eaa0ad63f53317166b89a96a90edcf510b4a780c50a876e0934c60b40628b4. Actual engine acceptance remains pending; older legacy large-character menu reload issue is separate.

PAIR030: Fix older-profile readback by exact comparison of existing sections plus semantic optional trial defaults, persist Proof of Strength IDs39..61 and show Spiritual Ritual, toggle native Backpack/B safely, show icon-only talents with inset hover and earned-points/tier heading, place carried gear directly into empty hero slots, and retain rank-aware Acid Rain half pulses with Chaos attack type and shared-timer preservation; native215/classic315 regressions (1/11 expected skips), all compilation/editor/startup/content/save/armory/bazaar gates and conversion PASS, final archive/master/tool/output/TEST hashes verified and original local dev.txt passed read-only normalized comparison; native SHA256 79d8af52d4a9c1d45064975e2f625e7e9f50c878f16a64ee607428e3b0ba84ea, classic SHA256 01cd99bddb6010da390d020340ecd0b7b88385f1529404fcfe8e2bd76c002cce; actual engine acceptance pending, older legacy large-profile menu reload issue remains separate; see PAIR030_SAVE_UI_FIXES.md.

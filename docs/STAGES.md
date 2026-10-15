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
| DF | Fresh loading reports the exact failed setup step after DE reached creation and manual cleanup preserved retry eligibility. |
| DG | Fresh loading restores Gaya purchase research as flags and ability ranks separately, fixing DF’s rank3 versus research1 failure. |
| DH | Fresh creation directly enables and checks Forsaken hero backpack/equipment abilities after DG failed the first stored-item pickup. |
| DI | Stored-item preparation verifies pickup across quick, bag and equipment while keeping exact final placement and distinguishing native rejection. |
| DJ | Tester build adds bounded later-tick cleanup confirmation and a real-profile failure/retry check, retaining one-load and window restrictions. |
| DK | Fresh loading creates carryable original gear for Gaya and house, fixing DJ’s native Tome placement failure while preserving permanent IDs. |
| DL | Forsaken builders carry the approved r17 scenario description and current Intro into editor and playable sources, retaining DK’s verified loader. |
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

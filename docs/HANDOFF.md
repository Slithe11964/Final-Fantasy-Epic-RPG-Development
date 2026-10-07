# FF Epic RPG handoff - 2026-10-07, stage AS travel regions

Read this first, then STAGES.md and QUEST_ENGINE.md. Z remains the confirmed public baseline.
User requests Chronicle paging/counters, Secrets/Keg Hunter, monograph effects and Bazaar reopening.
Next unused stage: AY. Normal development stays on AS; Forsaken AX enables the required expansion data.

## Separate experiment - Forsaken AX

- AW native test FAILED: capacity0, direct fBag/fGer/ASpc all0, legacy AInv1. Investigation found AS and every earlier experimental map still use war3map.w3i Game Data Version1 (Frozen Throne). Installed new ability records have version2; editor strings identify expansion2 as Forsaken Kingdom.
- AX changes only that four-byte expansion selector to2 in map info. Format39 has extra race-HUD and height-fog fields; explicit version-aware parsing preserves all other metadata bytes. This is separate from Game Data Set and installed executable version. Earlier builds missed this prerequisite.
- Object preparation now always enables expansion2 for Forsaken modern maps; manifest records it. Regression verifies selector1->2 and all surrounding bytes identical. Existing original item bases were audited against installed stock data: none inherit native equipment types; source has no stock ChooseRandomItem/ChooseRandomCreep calls, using explicit drop lists.
- AW direct native setup, Backpack item, variants, legacy AInv retention and save blocking retained. Normal AS and byte-identical classic fallback remain Frozen Throne/current behavior.
- Final checks in STAGES; native Backpack click/bag capacity still needs acceptance.
- Validation: all gates,96 regressions,2,000 codec cases,6 experiment tests PASS. Final AX vs AW audit confirms only map expansion selector and diagnostic stage text changed; object/world/NPC payloads identical. Scratch build/ForsakenAX-nmj40hbx/FFERPG.

## Separate experiment - Forsaken AW

- AV user test FAILED: Backpack visible in slot1, capacity0, queried hero levels fBgi/fGer/ASpc all0, clicking did not open UI. GetUnitAbilityLevel on a holder is not a reliable proof about item-attached abilities; zero native capacity is the confirmed failure.
- AW bypasses item attachment by giving the player hero fBag, fGer and stock ASpc directly/permanently. fGer is a unit ability (aite0); Backpack remains present. Original stock ASpc receives a name/icon and hidden command-card position to keep existing job buttons. Its native behavior is unchanged.
- Diagnostic reports direct hero ability levels and stock AInv legacy level. Legacy inventory/item definitions are retained; no inventory-removal experiment or global NPC changes. Conversion still waits for native bag capacity and successful variant acceptance.
- Release/check results in STAGES. Normal AS and exact AS classic fallback retained; saving blocked in modern experiment. Native acceptance pending.
- Validation: full gates,96 regressions,2,000 codec cases,6 experiment tests PASS. Scratch build/ForsakenAW-d1e4ofp7/FFERPG. Native Backpack click and direct ability levels need user testing.

## Separate experiment - Forsaken AV

- AU user test restored original items/NPC gear, but Backpack click did not open the panel; diagnostic showed backpack=1, bag capacity=0. Do not treat AU's native UI as accepted.
- AV adds explicit custom item abilities fBgi (AIni) and fGer (AEqu). Installed 3.0 AbilityMetaData defines inv6/equ1 as Data F (pointer6); AV writes level1 bag capacity30 and equipment level threshold0 instead of relying on inherited stock defaults. Backpack carries fBgi,fGer,ASpc to include the native interface controller. Gaya uses the explicitly configured fBag.
- This is a candidate correction, not a reproduced in-game fix. Native acceptance must confirm clicking Backpack opens the equipment/bag panel. The -forsaken diagnostic includes custom bag/gear and ASpc ability levels plus bag capacity.
- Original items/NPCs, isolated variant conversion, save blocking and exact AS classic fallback retained. Full build results in STAGES; normal development remains AS.
- Validation: full build gates,96 regressions,2,000 codec cases and5 experiment tests PASS. Scratch source: build/ForsakenAV-rp5wnkdm/FFERPG. Native play-test pending.

## Separate experiment - Forsaken AU

- User play-test rejected AT: no backpack controls and map-wide NPC/hero gear dropped. Global changes to existing equipment item types were unsafe for legacy inventories; adding the native abilities directly did not expose usable UI in that test.
- AU preserves every original item definition and adds276 native equipment variants plus a visible fBpk Backpack based on stock ebac with AIni,AEqu. Hero gets the item once there is a free six-slot slot; click it to open the native UI. Gaya gets stock AInx. `-forsaken` reports Backpack slot/native bag capacity for diagnosis.
- Only the player's hero's carried mapped gear converts, after native bag capacity is available. Variant must be accepted before deleting original; charges/ownership retained. NPC/preplaced item definitions stay untouched. Existing equip level/mastery checks retained.
- Pair under release/Forsaken/ with basename FFERPG_0.9.7.3-r16-ForsakenAU.w3x; classic fallback remains exact AS classic. Test line only, saving still blocked. New variants do not yet map back to Armory or other item-ID-based features; migration remains necessary.
- Source/builder/tests remain isolated in experiments/Forsaken. Build/native acceptance status is recorded in STAGES; automated compilation does not prove native UI rendering. Test visible Backpack click, NPC gear retention, conversion/full-bag failure and native slots. Normal development stays AS.
- AU validation: full build gates,96 regressions,2,000 codec cases and5 experiment tests PASS. Every existing item object and NPC/unit/terrain/region payload retained exactly; classic fallback byte-identical to AS. Native acceptance still pending. Generated source tree: build/ForsakenAU-riidd9k2/FFERPG.

## Separate experiment - Forsaken AT

- User requested the actual 3.0 native bag/loadout, with Armory gear assigned to its slots, and explicitly asked to keep these maps in a separate `Forsaken` release folder.
- Reforged test: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenAT.w3x`. Classic fallback: same basename under `release/Forsaken/1.29.2/`, byte-identical to the working AS classic map. Do not downgrade this native test using the regular shortcut.
- Reproducible isolated source overlay/build/tests: `experiments/Forsaken/`. Canonical `src` and ordinary releases remain unchanged; generated source tree under `build/ForsakenAT-y4rpudog/FFERPG`.
- 276 Armory gear objects receive native `iequ` slot types; four Materia remain inventory items. Add native-based fBag/fGer abilities; heroes receive both, Gaya gets the bag. Equip event runs existing level/mastery gates. Mapping is in `release/Forsaken/gear-slots-AT.json`.
- This is a UI/basic-equipment preview. Save/savef/autosave/New Game exports are blocked by replacing trigger actions, with a message; existing serializers/readers/Armory indexes remain unchanged. Expanded inventory saving, item procs/queries, crafting/quests/transfers/job changes and Ninja dual-wield migration are still required before progression play. See the experiment README.
- Full Reforged gates,96 regressions,2,000 codec cases and4 experiment tests PASS. No native in-game acceptance yet; verify actual UI, slotting/bonuses, unequipping, restrictions, Gaya, hero recreation and multiplayer. Classic fallback hash equality verified.

## Current development build - AS

- Pair: release/FFERPG_0.9.7.3-r16-stageAS.w3x and release/1.29.2/FFERPG_0.9.7.3-r16-stageAS.w3x.
- Base is the user's World Editor saved AR from Documents/Warcraft III/Maps/Download/TEST. It already contains both new regions and compiled Travel entries; the earlier stale-script diagnosis does not apply to that saved copy.
- Editor save produced 557 source/runtime differences from JassHelper transformations. Integration preserves editor terrain/regions/units and generated map functions, retaining checked AR library bodies before syncing Travel/Warp. No historical-difference contracts were relaxed.
- World Editor split unit/item display fields into skin files, omitted default-valued fields and externalized tooltips into WTS. The build copies missing skin fields into the main unit/item tables, restores omitted AR defaults and resolves WTS text there; skins and original editor input retained.
- Shipyard region bounds: (3040,-5984) to (3328,-5696). ArenaDarkness: (26176,-24608) to (26496,-24320).
- Append Shipyard and Arena of Darkness at indexes12/13; original indexes1..11 stay fixed, including Ice Realm9 and Elysium11.
- Warp entry selects GetTriggeringRegion instead of rechecking IsUnitInRegion. This avoids dependence on membership timing at the entry boundary; the reported native failure is not yet reproduced or confirmed fixed.
- Hero-only entry, shared per-game unlock, one effect per destination and menu behavior retained. Test both new destinations in game, including ordinary walking, repeat visits, both clients and multiplayer.
- Validation: all Reforged build gates,classic check_map,96 regressions and2,000 codec cases PASS; source/runtime agreement has0 new differences. Final editor preservation audit PASS: only script/editor text and normalized unit/item tables differ; region placements and all other named payloads retained.
- New source regressions exercise stale membership, repeat visits and fixed destination indexes. For future incremental builds use AS or another map containing these regions; the original baseline lacks them.

## Current development build - AQ

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAQ.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAQ.w3x (AE Bazaar UI).
- Chronicle category buttons now show only their names; unlocked/maximum counters remain in the descriptions.
- Secrets and its Keg Hunter entry are hidden until title59 is completed. Keg Hunter displays the standard green title and rare-drop effect wording.
- Next page uses a navigation icon and has no category preview description.
- Next page now uses `ReplaceableTextures\\CommandButtons\\BTNMove.blp`, the standard move-arrow icon.
- Full gates,94 regressions,2,000 codec cases,classic check_map and preservation PASS;1508 startup triggers,0 independent reorder.
- Elysium report remains under investigation: the east rainbow bridge is `gg_dest_DTsb_0068`, hidden during preparation and shown when Andre's reveal completes. Confirm whether the failure occurs in a fresh game after the reveal or only after loading.

## Current development build - AP

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAP.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAP.w3x (AE Bazaar UI).
- Chronicles: first10 categories + Next page; nested page2 has Time Trial and Secrets; Secrets
  contains Keg Hunter. Additive abilities cPg2/cSec/cKeg, distinct spellbook orders. Only existing
  A0AR spell list and A10C button position changed. Each category shows unlocked titles / maximum,
  including root total63. Count force membership rather than internal weighted ability levels.
  Local tooltip update1sec; synchronized pickup/inventory paths own progression.
- Keg Hunter: collect all10 books one at a time with your own hero/Gaya in one game. Duplicates,
  other units/players and rejected pickups do not count. Completion grants title59; partial
  progress stays in this game per user choice. Existing dedicated title59 save bit already read/
  written: no serializer, field, contract or inventory index changes. Restores after load/Gaya
  recreation. Full title applies all monograph bonuses without inventory space; no stacking.
- Regional books already worked on hero OR Gaya. Shared Loot predicate adds earned title59 and
  zone0 for Knight's previously excluded ordinary-loot effect. Preserve drop tables/chances,
  charged/powerup/Spider Leg rules, hero-kill restriction and essence region1..8 behavior.
  Detailed effects/region table in docs/CHRONICLES.md.
- User also reports Bazaar will not reopen after closing once. Recipe entry now explicitly
  removed/re-added at full stock after each purchase, preventing exhausted stock from blocking
  reopening. UI/session/crafting code unchanged. Source regression opens/closes3 times and
  rejects old Close packets; in-game cause/fix acceptance still needs confirmation.
- Full gates,93 regressions,2,000 codec cases,classic check_map and scoped preservation PASS.
  New pickup trigger allowed explicitly;1508 startup triggers, no existing pair reorder.
  Objects/items/recipes/quests/rewards/save format outside requested changes unchanged.
- Test native nested page navigation/Cancel and counters in both clients, sequential10 books,
  two-player isolation, completion save/load/recreation, Knight/regional loot and repeated Bazaar
  reopening from hero/Gaya/shops. Multiplayer and World Editor Save As remain unconfirmed.
  AO blue-girl timing and concurrent hunts still need user confirmation. AN/AM retained.
- Next incremental: .\build.ps1 -Stage AQ -Base release/FFERPG_0.9.7.3-r16-stageAP.w3x.
  Fresh objects/build: docs/BUILDS.md. Chronicle implementation: Titles/Loot/GameLoad/Gaya_Shared.

## Previous development build - AO

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAO.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAO.w3x (AE Bazaar UI).
- Completing Kollin's opening Arachnophobia conversation schedules Harpy Hunt availability
  two seconds later. Spider completion still unlocks Thextera only; both hunts can run together.
  Caroline: "Hello. Since you're helping Kollin, could you help me too?" Her next line drops
  "As such,". Hunt targets, 15/20 counts, rewards, logs and rare hunts are unchanged.
- Blue girl: AN source AND compiled map already had a 300-second timer on all three town visits.
  User saw her at about15:10 and absent by17:20 before talking. Early removal was not reproduced.
  Her object inherits Archer movement; AO pauses her and sets propulsion window0 on each spawn,
  preventing her walking away (including after cinematics unpause units). This is a stationarity
  safeguard, not a confirmed diagnosis of that report. Existing300-second timer, spawn chance,
  dialogue, conversation exits, gifts and ending sequence remain unchanged.
- Full gates,84 regressions,2,000 codec cases,classic check_map and scoped preservation pass.
  No objects/save serializers/startup or other modules changed. Prior AN/AM features retained.
- Test: talk to Kollin, visit Caroline before killing15 spiders; run both hunts concurrently,
  verify separate counters/rewards and rare hunts. With cinematics on/off, verify her introduction.
  Blue girl should stay at her town spawn from appearance until five minutes later when untouched;
  approach/select her during that window and check normal conversation/gift. Test with intervening
  cinematics, both clients and multiplayer. Her reported early disappearance still needs play-test.
- Next incremental: .\build.ps1 -Stage AP -Base release/FFERPG_0.9.7.3-r16-stageAO.w3x.

## Previous development build - AN

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAN.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAN.w3x.
  Classic retains AE Bazaar presentation. Develop from the Reforged map.
- Seven active chocobo foods appended at inventory indexes 352..358: Pram Nut/I045,
  Luchil Nut/I07F, Carob Nut/I07G, Zeio Nut/I07H, Gysahl Greens/I027,
  Mimett Greens/I07Q and Silkis Greens/I0KE. Charged classification recorded; quantities saved.
  BP/bazaar purchase proxies, information items and unused OLD greens remain unsavable.
- ItemAllowed checks udg_SpeedrunMode, not difficulty. All other modes/difficulties allow the
  seven items. Inventory save count and payload both skip food in Speedrun; load consumes its
  charge bits and discards it through the existing rejection path. Other inventory still loads.
  Shared inventory functions cover hero, house, Gaya and other serialized inventory containers;
  manual/autosaving use the same mode check. Ownership and legacy F rejection retained.
- Old 351 inventory IDs, jobs, fields and existing G/H fixtures unchanged; SaveFlagCount now358.
  No new armory flag/proxy: counter stays280. AM's four appended materia bits retain their order;
  its helper already places future inventory indexes after them. No object/ability/item edits.
- Only Save_EncodeInventory and Cmd LoadInventory gain mode predicates. Separate reviewed
  tools/contracts/chocobo-food-save-extension.json pins exact body/helper hashes and appended
  item/charge mappings. Original compatibility contract and AM extension remain unchanged.
  Reverse only mode predicates to recover original serializer fingerprints. Older saves remain valid.
  New saves containing food need AN+ to restore it outside Speedrun.
- Full gates, 82 regressions, 2,000 codec cases, classic compile/check_map and scoped preservation
  pass. Original objects/rewards/Bazaar/travel/Gaya behavior and other modules unchanged.
  Tests execute actual source across every difficulty, all seven quantities, skipped-item alignment,
  mixed/all-food inventories, ownership, legacy rejection and reviewed-policy refusal.
- AM Materia storage/hints/N / 280 and earlier UI/Gaya/dev changes retained; no new in-game
  confirmation has been reported. Test each food quantity outside Speedrun, then load the same
  mixed inventory into Speedrun: food absent, other items/quantities correct. Test Speedrun saves
  omit food, hero/house/Gaya, old codes, both clients/multiplayer and World Editor Save As.
- Incremental: .\build.ps1 -Stage AP -Base release/FFERPG_0.9.7.3-r16-stageAO.w3x.
  Fresh clone workflow: docs/ARMORY.md / BAZAAR.md. Food policy: docs/SAVE_CODES.md.

Git attribution: the user requested all repository history and future commits use Slithe with
338753050+Slithe11964@users.noreply.github.com. Historical comparison references were updated after
rewriting author/committer metadata; all 47 tests pass. The original history bundle is kept outside
this repository in ../_archive/FFERPG-before-slithe-attribution-2026-10-06/. Map bytes are unchanged.

## Confirmed public baseline

- **Develop/edit:** baseline/Reforged/FFERPG_0.9.7.3-r16.w3x.
- **Play in 1.29.2 or Reforged:** baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x.
- baseline/manifest.json records hashes and provenance. build-config.json pins the development
  master. Both maps are tracked; generated release builds are ignored.

The user chose the parent-folder r16 as the starting point, then agreed to carry its edits into the
Reforged master and generate the matching classic copy. That input was already classic format.
Its substantive differences from Y were quest-log GUI/text and pathing; object field values were
unchanged. Most script differences came from JassHelper inlining. Z carries the quest-log/pathing
edits and complete object data into W's repaired editor layout, retaining the latest user-authored
Intro.j welcome wording. No new gameplay, dialogue or reward changes were made.

All 93 quests use QuestEngine. S is user-confirmed working. Later safeguards, V shared-context
cleanup and W editor pairing remain included. Bugs remain deferred by user request. The Chemist/
Ninja passive-art fix remains; Gaya selection settings are preserved. Flying Gaya/crow lines are
the client's Air-to-Ground Indicators, independent of conversion.

## Workflow

```powershell
.\build.ps1 -Stage AQ -Base release/FFERPG_0.9.7.3-r16-stageAP.w3x
```

The builder selects changed enabled modules, syncs, normalizes pairing, orders libraries, runs
all map/source/quest/content/save checks, regressions and codec tests, then adds the header and
publishes new files without overwrite. Use -Base with the newest reviewed Reforged build for
incremental work. World Editor edits: enable JassHelper/vJass, Save As a new file, check it,
export/review source changes, then convert that saved file:

```powershell
.\make_129.ps1 -Map release/<editor-saved-map>.w3x
```

The converter uses the tracked classic baseline for map-info template/missing object defaults,
compiles the runtime against 1.29.2, preserves editor files and outputs the same basename under
release/1.29.2/. The local batch accepts the same arguments. Bazaar frame UI is converted to the AE dialog
in both runtime and editor source. No sibling toolkit/r7 dependency.

Keep .j sources CRLF; comment calculations only when non-trivial. Preserve behavior/dialogue/
rewards unless requested. Record builds in STAGES.md and update this handoff and local parent
RESUME_PROMPT.txt. Commit relevant changes. Read BUILDS.md before resolving source/runtime failures:
exact historical contracts are intentional; never regenerate them to silence new differences.

## Verification and pending tests

Z passes all gates and 2,000 codec cases. Packaging has 47 passing regression tests. Both editor
formats round-trip byte-exact with valid pairing. The classic baseline compiles for 1.29.2 and
passes check_map against the master: 1,503 startup triggers, no reorder. Selected r16 quest-log
GUI actions/pathing are preserved in both; object files/WTS are byte-identical in the Reforged
master. Classic runtime exactly matches the converter transform of the master.

The user confirms both paired maps are working great on 2026-10-06. This is the confirmed
development starting point for Reforged and 1.29.2. Specific multiplayer/save-load/cinematic coverage
was not itemized. A separate editor Save As was not explicitly confirmed. Test each future change
in both clients and use QUEST_TESTS.md for focused content.

GitHub readiness checked: baseline pair, sources, toolchain, contracts, fixtures and guides are
tracked. The local downgrade_129.bat/make_129.ps1 and every conversion dependency are included.
No MapToolkit installation or parent-folder r7 map is needed. Use Python 3; JassHelper/World Editor
are external requirements for editor saves. Historical source regressions require full Git history.

## Repository and archive

Keep baseline/, src/, tools/, docs/, wrappers and release/ for future outputs. Retain contracts,
fixtures, PHASE16.md/handoff CSV, system/content guides and source/object references. Historical
auditors remain: current regressions depend on the V auditor and Git history.

Old stages, reports, obsolete surveys/readability plan and scratch files are preserved at
`../_archive/FFERPG-before-r16-baseline-2026-10-06/`, including the original user r16, previous docs,
pre-cleanup diff and eleven already-deleted reports recovered from Git. The paired baseline/source repository is now published under Slithe11964.
Next: play-test AC, then requested content; bugs remain deferred.

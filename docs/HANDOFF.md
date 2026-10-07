# FF Epic RPG handoff - 2026-10-06, stage AE Bazaar browser

Read this first, then STAGES.md and QUEST_ENGINE.md. Z remains the confirmed public baseline.
User confirms stage AD armory is working excellently; client versions were not specified.
Next unused stage: AF.

## Current development build - AE

- Reforged/editor: release/FFERPG_0.9.7.3-r16-stageAE.w3x.
- Shared playable copy: release/1.29.2/FFERPG_0.9.7.3-r16-stageAE.w3x.
- Bazaar bottom-right Recipes icon opens all 56 anonymous recipes. Ingredient counts become green
  when satisfied; rewards stay hidden until crafted. Previous/Next wraps, selection is per player.
  The original shared sold-material pool remains. Selling, browsing and timers spend no parts.
  Craft rechecks parts/buyer/payment, spends exactly one recipe set and original gold/shard price,
  and gives original rewards/charges. Other open browsers refresh after spending. Wolf Fangs retained.
- AD single-panel armory, hints and required-level ordering retained, including Mina/Halberd hints.
- All map/source/quest/content/save/armory/Bazaar gates, 2,000 codec cases and 60 regressions pass.
  Classic compilation/check_map and preservation audit pass. Against AD: only Bazaar runtime/editor
  source, one recipe button unit and Bazaar's added Sell Units ability differ; item/recipe data unchanged.
- Needs focused both-client shop/dialog layout and transactions, shared-pool multiplayer, save/load
  and Editor Save As checks: docs/BAZAAR.md. Recipe 1 has sixteen ingredients; confirm full display.
- Incremental: .\build.ps1 -Stage AF -Base release/FFERPG_0.9.7.3-r16-stageAE.w3x.
  Fresh clones must prepare both armory and Bazaar objects and explicitly allow the two added
  browser triggers for the first build; see BAZAAR.md. Never use the pinned baseline alone with
  current sources. Subsequent builds from AE need no new-trigger allowance.

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
.\build.ps1 -Stage AF -Base release/FFERPG_0.9.7.3-r16-stageAE.w3x
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
release/1.29.2/. The local batch accepts the same arguments. No sibling toolkit/r7 dependency.

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

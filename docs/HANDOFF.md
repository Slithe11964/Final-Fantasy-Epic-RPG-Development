# FF Epic RPG handoff - 2026-10-07, stage AG Bazaar panels

Read this first, then STAGES.md and QUEST_ENGINE.md. Z remains the confirmed public baseline.
User confirms AD armory works excellently and likes AE's Bazaar overall. AF's five-choice list
was rejected: the user wants five complete AE-style panels simultaneously with Next 5.
User chose Reforged frames with AE single-dialog fallback for the classic conversion.
Next unused stage: AH.

## Current development build - AG

- Reforged play/editor: release/FFERPG_0.9.7.3-r16-stageAG.w3x.
- Classic play: release/1.29.2/FFERPG_0.9.7.3-r16-stageAG.w3x.
  This also runs in Reforged, but uses the AE dialog. Play the Reforged build for five panels.
- Five complete panels: three top, two below; each has ingredients, counts, hidden reward,
  original price and Craft button. Next/Previous move by five, wrap across twelve groups;
  eleven Next clicks reach recipe 56. Long ingredient lists scroll inside each panel.
- Craft/Close use synchronized session/recipe messages. Navigation is local presentation;
  only synchronized crafting spends parts. Delayed/duplicate successful clicks are rejected.
  All frame handles are created globally. Classic conversion replaces frame functions in both
  runtime and editor text with the AE dialog; two unused event triggers keep startup aligned.
- Shared sold-material pool, prices, all recipe data, outputs/charges and payment code unchanged.
  AD armory, hints and required-level ordering retained, including Mina/Halberd hints.
- Full gates, 65 regressions, 2,000 codec cases, classic compilation/check_map and preservation
  audit pass. Changes confined to Bazaar presentation and the classic presentation converter.
- Needs native Reforged panel/scroll rendering, real multiplayer, transactions, save/load and
  Editor Save As tests: docs/BAZAAR.md. Do not mark user-tested until actually confirmed.
- Incremental: .\build.ps1 -Stage AH -Base release/FFERPG_0.9.7.3-r16-stageAG.w3x.
  Fresh clones prepare armory and Bazaar objects and allow four new Bazaar event triggers;
  see BAZAAR.md. Builds from AG need no allowance. Never use the pinned baseline alone with
  current sources. Use the Reforged build for development, not the converted classic source.

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
.\build.ps1 -Stage AH -Base release/FFERPG_0.9.7.3-r16-stageAG.w3x
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

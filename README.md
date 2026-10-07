# FF Epic RPG

Warcraft III RPG sources and development tools. The starting point for new development is the
paired 0.9.7.3-r16 baseline, assembled in stage Z on 2026-10-06.

| File | Use |
|---|---|
| `baseline/Reforged/FFERPG_0.9.7.3-r16.w3x` | Development master: open in the Reforged World Editor. |
| `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` | Matching classic playable copy; also usable in Reforged. |
| `baseline/manifest.json` | Hashes, provenance, verification and pending play tests. |

Both maps retain the latest quest-log/pathing edits, welcome source text and Chemist/Ninja passive
art fix. Automated checks pass, including 1.29.2 compilation. The user confirms both baseline maps work well (2026-10-06). A separate World Editor Save As
confirmation was not reported; future gameplay/editor changes need their focused checks.

The two baseline maps are tracked in Git. Future builds, scratch files and generated reports are
ignored. Sources, compiler libraries, compatibility contracts and regression fixtures stay tracked.

## Development

Read docs/HANDOFF.md, docs/STAGES.md, then docs/QUEST_ENGINE.md. Install Python 3 and use PowerShell;
Windows pjass and both sets of script libraries are included. Editor saves require JassHelper/vJass.

```powershell
python tools/armory_catalog.py baseline/Reforged/FFERPG_0.9.7.3-r16.w3x build/armory-objects.w3x
python tools/bazaar_catalog.py build/armory-objects.w3x build/bazaar-objects.w3x
.\build.ps1 -Stage AM -Base build/bazaar-objects.w3x -AllowNew '^gg_trg_Bazaar_(OpenRecipes|BrowseRecipes|FrameClick|FrameSync)$'
```

Stages AB through AL add armory question marks and hints on one panel per category, sorted by required level; AL adds a stored/total counter on the house Armory tooltip; see docs/ARMORY.md for testing and hint editing.
Stages AE through AK add a spoiler-free Bazaar browser. AI shows three padded, larger-text recipe panels per group
in Reforged, with green counts and click-to-craft; the classic conversion uses AE's single dialog; see docs/BAZAAR.md. AK also increases Gaya gather/follow ranges by 25% and adds
`-teleporters` to the disabled developer module (docs/DEBUG_COMMANDS.md). The preparers add both reviewed shop features to the public baseline. The builder syncs changed modules, orders libraries, runs all
safeguards and adds the header. A new map/report/manifest goes to release/. Use the next unused
stage. For incremental work, pass `-Base release/<latest-Reforged-map>.w3x`. Keep vJass .j sources
CRLF. Preserve behavior, dialogue and rewards unless a change is requested.

For editor changes: open the Reforged master or newest Reforged build, Save As to a new file,
check/export/review it, then convert the saved map:

```powershell
.\make_129.ps1 -Map release/<editor-saved-map>.w3x
```

The classic copy goes to release/1.29.2/ with the same filename and no version suffix in its
displayed name. The converted Bazaar uses AE's dialog even in Reforged; play the Reforged release
for the three-panel interface. Existing outputs are refused. downgrade_129.bat runs the same wrapper; without
arguments it converts the pinned baseline. No sibling toolkit is required.

See CONTRIBUTING.md, docs/BUILDS.md, docs/LEGACY_129.md and docs/CONTENT_DEVELOPMENT.md.
Record each build in STAGES.md and update HANDOFF.md. Preserve existing save item/job indexes.

## Local archive

Older maps, checks, scratch builds and superseded surveys are preserved outside this repo:
`../_archive/FFERPG-before-r16-baseline-2026-10-06/`. Its manifest lists moved material. Previous
documentation and the untouched user r16 are saved there too. Git retains source history.
The archive is for local recovery and is not required for normal development.

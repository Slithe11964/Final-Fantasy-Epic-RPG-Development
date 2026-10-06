# FF Epic RPG

Warcraft III RPG sources and development tools. The starting point for new development is the
paired 0.9.7.3-r16 baseline, assembled in stage Z on 2026-10-06.

| File | Use |
|---|---|
| `baseline/Reforged/FFERPG_0.9.7.3-r16.w3x` | Development master: open in the Reforged World Editor. |
| `baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x` | Matching classic playable copy; also usable in Reforged. |
| `baseline/manifest.json` | Hashes, provenance, verification and pending play tests. |

Both maps retain the latest quest-log/pathing edits, welcome source text and Chemist/Ninja passive
art fix. Automated checks pass, including 1.29.2 compilation. A fresh smoke test in both clients
and a Reforged World Editor Save As remain required before release.

The two baseline maps are tracked in Git. Future builds, scratch files and generated reports are
ignored. Sources, compiler libraries, compatibility contracts and regression fixtures stay tracked.

## Development

Read docs/HANDOFF.md, docs/STAGES.md, then docs/QUEST_ENGINE.md. Install Python 3 and use PowerShell;
Windows pjass and both sets of script libraries are included. Editor saves require JassHelper/vJass.

```powershell
.\build.ps1 -Stage AB
```

This builds from the pinned Reforged baseline, syncs changed modules, orders libraries, runs all
safeguards and adds the header. A new map/report/manifest goes to release/. Use the next unused
stage. For incremental work, pass `-Base release/<latest-Reforged-map>.w3x`. Keep vJass .j sources
CRLF. Preserve behavior, dialogue and rewards unless a change is requested.

For editor changes: open the Reforged master or newest Reforged build, Save As to a new file,
check/export/review it, then convert the saved map:

```powershell
.\make_129.ps1 -Map release/<editor-saved-map>.w3x
```

The classic copy goes to release/1.29.2/ with the same filename and no version suffix in its
displayed name. Existing outputs are refused. downgrade_129.bat runs the same wrapper; without
arguments it converts the pinned baseline. No sibling toolkit is required.

See CONTRIBUTING.md, docs/BUILDS.md, docs/LEGACY_129.md and docs/CONTENT_DEVELOPMENT.md.
Record each build in STAGES.md and update HANDOFF.md. Preserve existing save item/job indexes.

## Local archive

Older maps, checks, scratch builds and superseded surveys are preserved outside this repo:
`../_archive/FFERPG-before-r16-baseline-2026-10-06/`. Its manifest lists moved material. Previous
documentation and the untouched user r16 are saved there too. Git retains source history.
The archive is for local recovery and is not required for normal development.

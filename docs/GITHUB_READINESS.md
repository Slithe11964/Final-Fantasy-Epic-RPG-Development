# GitHub package readiness — 2026-10-06

Upload the FFERPG Git repository, including its history. Both baseline maps are tracked, together
with source modules/header/variables/item table, build and conversion tools, Windows pjass, both
compiler-library sets, reviewed contracts, fixtures and documentation. No sibling MapToolkit or
parent r7 file is required. Original archive/build scratch/logs are excluded. The remote is
https://github.com/Slithe11964/FF-Epic-RPG.git. Author/committer history and future local identity
were changed to Slithe using the account's private email by explicit user request.

The user confirms both maps work great. Map hashes remain pinned in baseline/manifest.json and
tools/build-config.json. Code checks and 47 regressions pass. Historical source-preservation tests
need full Git history; a ZIP download or shallow clone does not provide the old comparison commits.

## Standalone downgrade shortcut

downgrade_129.bat calls make_129.ps1 in this folder. Its dependencies are all tracked:

- tools/downgrade.py, mpq.py, objdata.py, wtg.py, wct.py, add_header.py;
- tools/bin/pjass.exe and tools/versions/1.29.2/common.j, blizzard.j;
- baseline/1.29.2/FFERPG_0.9.7.3-r16.w3x as the template/object-default source.

Install Python 3; the wrapper uses Python on PATH or accepts -PythonPath. The Codex bundled Python
is an optional local convenience, not a required dependency. Run:

```powershell
.\make_129.ps1 -Map release/<Reforged-editor-save>.w3x
```

Output is release/1.29.2/<same-filename>.w3x, without an added version suffix. With no arguments,
the batch converts the pinned Reforged baseline. Existing output is refused. Editing/saving vJass
in World Editor requires Warcraft III and enabled JassHelper/vJass, which are not bundled.

This audit prepares the files; it does not create a GitHub repository or publish anything.
No project LICENSE has been selected. Compiler/game libraries and map assets retain their original
ownership; do not treat the entire package as having a newly assigned blanket open-source license.

Fresh full-history clone verification passed: all 47 regressions, then make_129.ps1 ran using only
files in that clone and an explicitly supplied Python executable. Its output SHA256 was
9a4bf6206812fa373566a2f7bb31bfa266a61f908e9309fa14f49143c1ce8472, byte-identical to the tracked
classic baseline. No MapToolkit files were used.

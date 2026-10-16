# Obsolete build cleanup (2026-10-16)

Moved 186 superseded build entries (77,239 files, approximately 17.26 GB) into
`../../_delete/2026-10-16-obsolete-builds/`.
The folder is intended for the user to delete after review; nothing was deleted.

`manifest.json` records each original path, destination, file count, byte size and
reason. All original paths were verified absent after moving; destination file
counts and byte sizes match the pre-move inventory. Candidate names were checked
against project code/configuration references before moving.

Retained: editor master/configuration, sources, tests, tools, MapToolkit, game
libraries, baselines, all released maps and paired reports, latest PAIR016 build
reference, active/new builds, and unreproduced saved-game/crash diagnostics. The
pinned authoring/native maps were checked against their configured SHA256 hashes.
Older build-log paths in historical documentation now refer to the move manifest.

The new native backpack repair is independent of cleanup; both profile build gates
run after the old scratch is moved. Future builds create new scratch directories.

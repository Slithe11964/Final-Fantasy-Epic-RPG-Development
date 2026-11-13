# Exit crash investigation — 2026-10-28

Owner clarification: most of their ACCESS_VIOLATION / address
0xFFFFFFFFFFFFFFFF crashes occur when clicking to exit a Warcraft map. Other
players' exact map versions, actions and reports remain unknown; owner is asking.
Do not conflate their possible in-game crashes with the owner's exit crash.

Read-only local investigation found 81 Crash.txt reports. Thirty-seven have
Warcraft III.exe fault offset 0x2c5ed4 after normalizing executable load address.
They span 0.9.7.5c (October 21), Stability02, QuickDock, QuickUI01 through UI57,
and native Hotfix04. The latest local report is UI57 at 13:52 on October 28.
There is no local UI58/Hotfix06 crash report in this set. This is evidence of a
pre-existing failure signature; it does not prove every recent report shares
that cause or establish UI58/Hotfix06 stability.

Representative reports:

- Errors/2026-10-28 13.52.19 052fba5c: UI57.
- Errors/2026-10-28 13.36.37 97b20434: UI56, same first seven stack offsets.
- Errors/2026-10-28 13.14.05 db706468: Hotfix04, same first seven offsets.
- Errors/2026-10-21 13.42.38 8839a43c: 0.9.7.5c, same fault offset.

UI57 main-thread stack begins 0x2c5ed4, 0x2c680b, 0x2e4380, 0x1fac90e,
0x2978f3, 0x1e028d, 0x1e0dcb. The actual dump context has a noncanonical
object pointer (RDI=0x0100000000000010) at a container-clearing instruction.
RAX points to the installed executable's CRenderBatch vtable, identified through
MSVC RTTI. Together with the owner's timing, renderer/UI resource teardown is
a lead, not a confirmed map-level cause. No source symbols or reproducible
before/after test identifies a specific faulty JASS function yet.

The log also contains repeated empty-model creation failures and a duplicate
ReplayPanelStringTemplate FDF warning. These are leads, not causation. Avoid
changing graphics settings, spells, equipment orders or user data on that basis.

Investigation tooling reads existing reports/dumps only. Build-local debugging
libraries do not modify Warcraft. Full data remains local. The read-only report
collector is tools/audit_crash_reports.py. No new map or speculative teardown
patch has been installed for this report. Original master is unchanged.

Owner subsequently confirms only FFERPG has shown the exit crash so far. They
also report all three Kalm Siege quests and the Arena of Darkness Gilgamesh II
summon crashing with the same displayed error. Those reports have no dump/map
version/action timing yet, so matching text is not proof of the same stack.

Next evidence needed: collect
other players' actual Crash.txt and map identity, especially any crashes during
play. A targeted cleanup change must first establish which owned resources and
exit events are involved. Do not add native Quit-button click hooks or destroy
native frames as an unverified workaround; these can replace built-in actions
or introduce a second cleanup fault.

Focused follow-up candidate: UI59 / native Hotfix07 removes portrait rendering
from all Kalm Siege and arena Boss_Gilgamesh dialogue, replaces narrator rawcode
0 portrait calls with timed text, and calls EndCinematicScene on normal Cine_Exit.
See SCENE_SAFETY59.md. These remove a suspect scene-rendering path, but do not
prove the exit crash or summon crash fixed. Normal Quit buttons are untouched.

# PAIR034 save-mode compatibility

Normal, Eternity and Speedrun accept one another's character saves in both
profiles. The user explicitly confirmed that Hardcore saving and loading should
remain disabled. Difficulty provenance and Inferno/Nightmare rules are unchanged.

The old fresh-load planner rejected a profile when its core field15 Speedrun bit
differed from the current game. The planner's preflight and creation recheck no
longer require that match. The recheck still validates eligibility, account,
starter/Gaya/house identities and difficulty context. Hardcore eligibility,
manual saving and autosave gates are retained.

The existing writer continues recording field15 as information about the game
that created the save. No format, field identity, item binding or codec maximum
changes. Normal/Eternity write zero; Speedrun writes one. A later save records its
current game mode without restricting later imports.

Final load verification permits only this boolean field to differ in the core
payload. Section schema/required flags, pair count/order/IDs, all other core
values and all other existing payloads stay strict. This preserves Speedrun
progress (core field8), difficulty provenance, resources and character data.
Existing optional legendary-section defaults remain supported. Invalid mode
values and extra core records are rejected.

Regressions cover all nine Normal/Eternity/Speedrun combinations, both flag
directions, older seven-section profiles, recheck after switching mode, Hardcore
load/recheck rejection, manual/autosave Hardcore gates and unrelated core/payload
mutations. The existing dev.txt was checked read-only with the bounded real JASS
codec/readback helper: Normal-to-Speedrun readback passed, original file unchanged.
This is not a substitute for actual Warcraft placement/commit acceptance.

Full paired build, regression/compiler/editor/startup/content/save compatibility/
armory/bazaar checks, classic conversion, final archive audit and hash-verified
TEST installation passed. Both outputs retain token-identical capture and
Hardcore save/eligibility gates, with no unrelated classic runtime changes.
The authoring master is unchanged. Engine acceptance remains necessary. Test a
fresh PAIR034 game with -loadf dev in Speedrun, then export and import that character
in Normal and Eternity. Retest existing difficulty restrictions and confirm
Hardcore still refuses manual save/load and skips autosave. Backpack behavior and
other PAIR033 features are retained.

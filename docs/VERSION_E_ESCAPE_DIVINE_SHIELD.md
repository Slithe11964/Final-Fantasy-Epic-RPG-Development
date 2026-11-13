# Version E Hotfix01 / QuickUI38 — Escape and Divine Shield

2026-10-25. Installed/hash-verified in Maps/Download/TEST: FFERPG-0.9.7.5e-Hotfix01-Forsaken.w3x, FFERPG-0.9.7.5e-Hotfix01-1.29.2.w3x, FFERPG-QuickUI38-Forsaken.w3x. Original Version E pair remains intact. Current development continuation is UI38.

## Teleporter Escape (Reforged)

Previous code depended on the end-cinematic event plus the dialog's built-in Escape hotkey, reported ineffective by the owner. Added OSKEY_ESCAPE key-down handler at shared startup for all eight players and a separate FFTravelClose sync handler. Local input only sends the current menu generation; shared callback hides only the requesting player's visible dialog when the generation matches. Rebuilding/reopening a menu increments generation, rejecting stale requests. Existing Cancel button and end-cinematic fallback remain. No teleport/unit mutation occurs on close. Local UI call-graph audit passes. Input in the actual modal Warcraft dialog still needs owner testing; no real-client success claimed.

1.29.2 does not support the OSKEY/sync native handlers. Its script is unchanged from Version E; that output receives only the Divine Shield object correction. Native-only behavior is kept out of the portable TravelPages source and injected by the native gameplay adapter.

## Divine Shield correction — supersedes the earlier Ndh patch

The prior fix was wrong: Ndh1/Ndh2 are not the metadata fields for ANdh. Installed Warcraft AbilityMetaData.slk identifies Nsi1..Nsi4 as ANdh Data A..D. Divine Shield authored Nsi2/Nsi3 only at ranks 1..4, leaving higher ranks inheriting base behavior. Both profiles now explicitly set Nsi1=0 (flags), Nsi2=0, Nsi3=0 and Nsi4=0 at every rank 1..11 in every applicable ability table. Bogus Ndh1/Ndh2 entries are removed. tools/job_objects.py carries the same correction for future builds. The shield script, absorption amounts and scripted gun accuracy are unchanged.

Metadata read-only provenance: local installed Warcraft storage, war3.w3mod:units/abilitymetadata.slk; extracted to build/abilitymetadata-current.slk. Final object readback verifies all 44 real ANdh fields per table against that metadata and confirms no Ndh fields remain. The user is testing gun/ammo attacks while self-shielded on ranged Freelancer; actual gameplay acceptance remains required, especially skill ranks above four/mastery.

## Validation

All three playable/editor scripts compile; startup wiring, source/runtime startup consistency, globals, text safety and save compatibility pass (358 items, 22 jobs, G/H fixtures). Archive readback and unrelated resources match inputs. Native Escape local UI call-graph audit passes. Direct-key/sync/stale-menu/other-player behavioral test passes; existing paged two-player dialog navigation/cancel regression passes. Three hotfix tests and 16 job-effect tests pass, including metadata-correct Divine Shield rank fields. No Warcraft or multiplayer run performed by agent. Packaging reports are adjacent to each map.

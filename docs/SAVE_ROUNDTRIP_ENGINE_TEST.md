# Real save/restart/load prototype

CU is being implemented from BT; no CU test map is ready yet. The next user test
will be one complete real-character file save, restart, fresh load and comparison.
House and gear diagnostics remain reference results.

## File transport

`Forsaken-save-transport.j` writes the private `FFERPG/Forsaken CU.txt` file in
chunks and checks local readback. Loading sends ordered, request-bound sync
packets, then validates the complete account-bound profile before exposing it to
the controller. Missing files, corruption, lost/repeated chunks and timeouts fail
without consuming a gameplay load. Concurrent players have separate requests.
This module does not create characters or set HasLoadedCode; controller eligibility
must be checked before requesting and again before applying.

Transport control flow and compiler integration have been checked locally. Native
file IO and real multiplayer have not been tested. The sender timestamp measures
send-to-validated-receipt using the game timer; file reading is recorded separately
with the same timer and may report zero for sub-frame work. This does not establish
wall-clock file performance. The real test must report that limitation and obtain
an external timing if needed.

## Real character capture and job schema

Read-only capture now covers quick slots, bag, equipment, Gaya and the existing
house, plus progression, separate currencies, upgrades, Chronicles and Armory.
It compares another capture before producing the code and rejects unsupported
items, foreign binding, unfinished Armory imports and unsupported Freelancer
variants. It creates no gameplay objects and imports no live-swap recovery modules.
The build binds runtime item aliases to the existing permanent registry.

Required schema2 job records are counted triples: permanent job ID, actual level
and mastery tier. Tiers0/1/2/3 mean ordinary, level50 mastery, level99 mastery and
enhanced mastery. Numeric levels accept up to999; this does not raise the engine
cap. Legacy schema1 marker100 still decodes as level99/tier3. Schema2 core adds
Freelancer mastery, active normal job ID (zero selects Freelancer), Speedrun mode,
and Freelancer variant1/2/3 for Strength/Agility/Intelligence. Existing live staging rejects this
schema rather than confusing real level100 with the legacy marker. Local capture
and codec checks pass; real Warcraft execution is still pending.

## Detached fresh-load plan

The new planner validates the whole profile into separate player-owned plan data,
resolves permanent item IDs to reviewed runtime variants and checks equipment
positions. It rejects unknown sections, IDs and metadata rather than dropping them.
It leaves the accepted codec profile and gameplay state untouched. Eligibility and
starting references are checked again immediately before creation.

The first CU path is restricted to an empty level1 starter/Gaya, empty assigned
house, matching saved/game difficulty and Speedrun mode, and levels within the
current engine cap99. These prototype restrictions do not change the format's
future level capacity. Closed-window, Hardcore and already-loaded states are
rejected without consuming a load; failed validation can be retried.

## Remaining before CU

Wire real capture, current-job/progression schemas and durable flags into export;
implement fresh creation, attempt-only cleanup and post-load comparison. Keep
unsupported export states explicit. Then build CU and measure the same real code
through restart and multiplayer; do not add separate temporary-hero test rounds.

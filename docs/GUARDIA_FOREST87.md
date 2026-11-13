# QuickUI87: Guardia Forest follow-up

Full Dragoon map, built from QuickUI86. All other forest changes and the 7% house health/mana regeneration remain.

| Change | Result |
|---|---|
| Forest Spider poison | 5 + 2 × poisoned hero level damage per second; 33% chance, 5 seconds. |
| Bandit Assassin poison | 5 + 4 × poisoned hero level damage per second; 15% chance, 5 seconds. |
| Alert | Moved from Dark Goblin (`ndtr`) to Forest Triton (`nmrl`). 15-second call, with Calling Reinforcements and a final 5–4–3–2–1 countdown. Killing the caller cancels it. Successful calls retain doubled forest spawn frequency, wave size and population cap for 60 seconds. |
| Forest Gnoll Taunt | Forces attacks for 3 seconds; grants +40 evasion for 15 seconds; 20-second cooldown, 25 mana. The former 20% damage reduction is removed. |

Dark Goblins are in Guardia Forest's night-only pool at weight 0.5. Forest Tritons appear in both day and night pools. Spawn membership and weights are unchanged. Unit and ability tooltips match the new values.

No new timers, inventory handlers or client-local callbacks. The existing shared one-second forest heartbeat is retained. Only seven forest functions change relative to QuickUI86.

Validation: five focused tests pass, exercising victim-level poison damage, Alert timing/countdown/death cancellation, pool membership, taunt/evasion expiry, native cooldown and tooltips, and preservation of other unit values. Playable and editor scripts compile; editor pairing, startup wiring, globals, text safety, object-reference and save-compatibility checks pass. Archive readback matches the intended changes. Live gameplay and multiplayer acceptance remain pending.

Build: `tools/build_forest87.py`. Tests: `tools/tests/test_forest87.py`. Output: `release/development/QuickUI87/FFERPG-QuickUI87.w3x`. Earlier maps, editor master, normal release, classic build and creature-review map are preserved.

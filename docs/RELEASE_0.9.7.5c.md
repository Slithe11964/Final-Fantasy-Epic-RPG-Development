# FF Epic RPG 0.9.7.5c

- Restored the original three-panel Bazaar layout. Prepare recipe buttons accept clicks across their visible area and use the same hover highlight as Next and Close. The native bottom console stays visible; the top-right board hides while browsing recipes.
- Included 53 updated armory hints from the JSON catalogue. Both hint tooltips and click messages now follow that file automatically in both versions.
- Backpack display follows the actual native inventory panels, preserving item movement and cooldown overlays. Removed forced alternate displays and orphaned Talents controls; retained X, Move to hero and the remembered Talents preference.
- Acid Rain heals and deals magic damage once per second, with 2,000 base healing and 2,000 base damage at master rank. Lower ranks scale with Tranquility. Invulnerable companions no longer interrupt the healing/damage pulse.
- Shielding converts 25% of overhealing into shields. Each contribution expires separately after 30 seconds; incoming damage consumes the oldest first. Added a white shield effect and moved the floating shield amount clear of health bars.
- Cure's projectile is a white light. Chosen talents have a gold border and the header reads Points Earned. Removed obsolete (Not Savable) labels from Chocobo greens and nuts.
- Compacted map archives to remove unused replacement data and keep downloads small.

Both maps use the same editor master and preserve the portable-save format. Hardcore saving/loading remains disabled; Speedrun's item restrictions remain in place.

## Validation

Automated release checks passed for both profiles, including playable/editor compilation, startup and source checks, save compatibility, fixed save fixtures and 2,000 randomized save-code round trips. The native build also compiles against a header without deprecated API aliases. Final publication verifies all 280 hints in tooltips, runtime and editable script, local Backpack call safety, unchanged checked archive contents and output hashes.

The user confirmed the recent native gameplay fixes in development testing. These final release files have not been tested by the agent in Warcraft or a multiplayer lobby; automated checks do not reproduce engine networking.

Forsaken: 274 tests, 2 expected skips. 12,624,522 bytes.

SHA-256: `caf22c89a84560b1bcf06d634ec20f92e2a19363cebc4f9c6d3fcdaac621bcf7`

Classic: 374 tests, 13 expected skips. 11,596,812 bytes.

SHA-256: `0474de61dc78d91571a1cc52d2166ea1b55bfd40698c5747d943bac7b8144cc6`


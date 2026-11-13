# Idle inventory isolation candidate: UI76 / 0.9.7.5f Hotfix07

2026-10-30. Owner reports a fresh normal-map desync after approximately twenty minutes of ordinary play, with castable gear loaded and no inventory/preview/cast action at the instant of disconnect. Owner identifies background inventory work as the primary lead, rather than the Forest/Barrens boundary. The hero/Gaya native-six-slot preview test was specifically QuickUI75 and showed the mouse cursor only.

## Evidence and limits

Local report `Documents/Warcraft III/Errors/2026-10-30 10.59.19 8a679f7c/Desync.txt` confirms a network desync on turn 76323, six humans, SD graphics, plain `Maps/Download/TEST/FFERPG-0.9.7.5f.w3x`. The adjacent 10.59.20 report is a separate ACCESS_VIOLATION after that desync; do not treat it as identifying the first divergent function. Neither report establishes which JASS/native operation diverged. No matched second-client checksum log has been supplied. Background-call frequency alone is not proof of desync causation.

## Idle isolation change (tools/idle76.py)

F/G presentation and request preparation read a two-item equipped-reference snapshot per player. Every client captures it from the existing synchronized inventory maintenance, gear-change and load-completion handlers. The existing one-second maintenance supplies fallback refresh. No new timers, units, items, groups, images, frame hooks, overlays or hashtables are allocated. Snapshot storage never comes from a GetLocalPlayer branch. Original QuickGear_Item and QuickGear_Receive remain unchanged: the synchronized receiver validates the actual currently equipped item before casting, rather than treating this presentation cache as gameplay authority. A delayed native gear event can cause up to the maintenance interval of icon lag; the receiver rejects stale requests.

The native click fallback no longer checks bag/quick-slot geometry on every idle heartbeat. It runs while either mouse button is held/released or an item move is in progress. Original mouse events and the existing ten-hertz fallback are retained; no click or right-click behavior is intercepted. Active rune drawing remains capped at ten hertz. The normal ten-hertz UI/frame/cooldown heartbeat and synchronized one-second inventory reconciliation continue. This does not eliminate all recurring map work or prove every native is safe.

## Separate six-slot detector change (tools/slots76.py)

The failed UI75 detector required visibility, size and legacy inventory capacity from the old origin-button path. The candidate removes those gates: selected own hero/Gaya plus the console provide the presentation context, console height scales the grid, and the actual item-slot lookup determines whether a supported castable item exists. Native cursor, tooltips, item movement, original casts, rune geometry and caster source are retained. No native item button events/hooks or overlays are added. This is a plausible detector correction; actual client geometry/behavior remains unverified.

## Outputs and validation

- `release/development/VersionFHotfix07/FFERPG-0.9.7.5f-Hotfix07.w3x`: retained release jobs, based on Hotfix06.
- `release/development/QuickUI76/FFERPG-QuickUI76.w3x`: retains Dragoon/Thief, based on QuickUI75.

Five focused tests pass: two mocked clients share the same equipment snapshot, repeated presentation reads do not query live equipment, gear replacement/removal updates correctly, idle/release mouse gating, hidden legacy button and zero legacy capacity do not block a selected native inventory, six scaled grid centers work without a legacy button size, and native cast receiver/rune geometry are unchanged. These are mocked/source checks, not multiplayer acceptance. Both maps pass playable/editor compilation, pairing/wiring/globals/text safety, content and save-compatibility checks. Archive readback and unrelated-resource identity pass. `build/idle76-local-audit.json` finds no forbidden mutations/allocations in the inspected TEquip presentation paths; external modules/native behavior are outside that proof.

Original releases/master and all previous candidates remain preserved. Test multiplayer idle loaded gear first, then F/G casts and hero/Gaya native clicks. No stability resolution or release promotion is claimed.

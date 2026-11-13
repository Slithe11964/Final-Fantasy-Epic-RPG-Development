# QuickUI49 native item activation

The owner rejected UI48 in Warcraft: backpack artwork covered the gear icons, targeting differed from clicking an item, bag wave runes did not appear, and Aqualung still did nothing. UI48's simulated checks did not establish client acceptance.

UI49 routes F/G and dock clicks to the actual native EquipmentButton_6/7 controls from the installed InventoryBar.fdf. Native Warcraft now owns the targeting cursor, target eligibility, item activation, cancellation and eventual item order. The custom cursor/synchronized substitute item-cast path is not registered. When the equipment panel is closed, B first binds the selected hero; a bounded retry clicks only if the exact hero and equipped item still match the initiating request.

The dock uses ordinary button/backdrop/text controls throughout, removing the simple button's painted backpack texture. Native frame discovery and click registration run on all clients at startup, in bounded batches; local input uses those cached handles. Inventory buttons and command-selection callbacks arm the existing rune renderer for Wateraga, Book of Depths and Ice Wand U. Water uses its widening 800-unit path; Ice retains its three authored wave directions. Client acceptance of the native callbacks remains pending.

Aqualung no longer depends on a dummy Blizzard order. Eight explicit pulses use the existing NagaDeath water-burst art, radius 250 and per-pulse `(MP cost + INT) x Rod spell power`, with water-element damage and normal enemy/invulnerability/immunity checks. Pulses are immediate and then once per second, eight total. Tooltips describe this calculation and timing. This replacement requires in-game balance/effect acceptance.

Sonic Thrust now moves the whole target by 5 units. Dragoon's shrine tier footer uses the other Tier 5 jobs' exact `|cff8040ff` purple. 1000 Cuts rip multiplier is now `(1 + 5% x Dagger proficiency)`; its base remains `100 + 0.3 x AGI` per dagger and its rear bonus remains 25%. All six ability ranks receive the current formula.

The owner explicitly requests that future balance changes update their tooltips in the same build. This is recorded in HANDOFF.md and final packaged object checks cover the current multiplier.

Focused checks cover native F/G forwarding, stale-item rejection while opening the panel, a native bag click arming runes, eight filtered Aqualung damage/effect pulses with timer cleanup, the packaged formula/color/push values, plus the retained Thief and Dragoon regressions. Final compiler/editor/startup/save/content checks pass. The live older client was inspected, but its ongoing session was not replaced to claim new-build gameplay acceptance.

# QuickUI51 loaded gear and preview follow-up

The owner reports UI50 F/G cannot initially cast loaded equipment, start working after gear changes, display stale equipment icons, and redraw correctly after a job change. The screenshot shows native worn gear disagreeing with the F/G artwork.

The released F/G poll previously trusted only its equip-event revision and hero identity. QuickUI51 additionally compares both live item handles and raw IDs with the last draw. Replacements, changes and removals now trigger the same existing redraw that job changes already use. The released frame layout, icon controls, input, synchronized requests, targeting and item-use functions are preserved.

After a successful load commit releases its guards, a shared zero-delay callback restores stored effects, refreshes worn-item support and rebinds only the two equipped active spells. The items remain in their slots; charges, ownership, binding, life and item handles are not rewritten. Learned ranks above one are retained. The callback verifies the hero is still current and loading has finished, then invalidates the UI revision. This addresses the missing normal equip activation path during guarded item placement; real-client confirmation remains needed.

Backpack previews identify each item's actual active spell, including carried aliases, instead of relying solely on a released raw-ID lookup. Read-only native item observers are reinstalled when native panel controls are created/rebuilt; the earlier Damage startup occurs before those controls are ready. Calculator's Blizzaga A17S receives both its native command-button hook and E-key hook, using the identical three-wave renderer as Ice Wand U. The callback leaves the same command-grid slot alone for jobs without Blizzaga, preserving Dragoon input.

The owner-confirmed Aqualung, Sonic push5, shrine color and current 1000 Cuts damage remain unchanged, as do gameplay object tables. No balance tooltips change in this UI-only follow-up.

Checks exercise missed equip events, same-type item replacement, item removal, guarded/replaced load callbacks, active-spell rebinding without item movement, native bag aliases, Calculator input, command-slot noninterference, preserved F/G casting functions and unchanged combat/object data. Compiler/editor/startup/save/content checks pass. Loaded gear activation, current icons and physical backpack/Calculator targeting still need Warcraft acceptance.

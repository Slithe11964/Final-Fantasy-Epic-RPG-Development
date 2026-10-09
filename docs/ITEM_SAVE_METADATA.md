# Item metadata audit for durable saves

2026-10-08, AS canonical sources plus BT Forsaken overlays. This is a code audit,
not proof of Warcraft restoration. Gameplay sources/releases are unchanged.
Search scope: all src/triggers and experiments/Forsaken JASS, item-specific
life/charges/user-data/player APIs, visibility/drop/invulnerability mutations,
handle-keyed state and Forsaken replacement/job/passive lifecycle paths.

## Durable data

| Property | Actual source uses | Save decision |
|---|---|---|
| Canonical item identity | Armory.j, Save.j, Cmd.j; generated fNNN/gNNN aliases | Persist permanent item ID, resolve runtime variant from container/equipment position |
| Holder and position | Forsaken-job.j, Forsaken-extra.j, Forsaken-bag-effects.j | Preserve quick6/bag30/equipment9/Gaya6/house6; sparse positions and both rings distinct |
| Charges | Item_Stack.j, Craft.j, Chemist.j, Book.j, Miracle.j, Item_Upgrade.j, fishing/gathering and quest consumption | Persist explicit presence plus seven-bit value0..127; gameplay target<=120; imported121..127 untouched |
| Item life | Prof_GetLevel; Equip Gaya/mastery checks; Forge and Loki gates; Damage Two-Handed bonus | Preserve exact finite positive binary32 value for newly captured items; do not round to integer or treat as disposable HP |
| Ownership user data | Item_Stack ownership/merge; Forge outputs inherit binding; Save_EncodeInventory eligibility; Gaya_Inventory; Player transfers | Persist account-relative binding. Runtime sender/account determines the new player-number marker; foreign-bound items fail eligibility |
| Invulnerability/drop/pawn flags | Quest/item creation sets invulnerability; Dwarves changes reforge-item droppability; other droppable changes include NPC gear | Reserve explicit flag metadata, with presence distinct from defaults. Capture/restore native APIs and per-item policy still require adapter verification |

Item life examples: Prof.j truncates it for proficiency; Equip.j tests145 for
Legendary Master requirement and compares other life values with Gaya level;
Forge.j tests99; Loki.j compares20/30/45; Damage.j adds item life*5 for Two-Handed.
Arena shop proxies use life as price and fishing encounter items as monster count.
Those observations do not make every proxy save-eligible: retain canonical
save-ID/mode/owner restrictions before capture. Do not invent metadata for an
unsaveable object just because a search found its life field.

No canonical `SetItemLifeBJ`/`SetWidgetLife` mutation of player items was found
in this source audit; authored object life supplies many of these values.
Forsaken replacement paths explicitly copy widget life. Engine damage to a
destructible item or future scripts could produce a fraction; preserve it rather
than assuming that all observed authored values are integral.

## Runtime state to reconstruct, not serialize

ForsakenBagAbilities stores removed passive ability IDs by item handle. Rebuild
that state from current canonical definitions and actual restored container:
stored gear suppresses passives; equipped gear restores them; active book spells
stay installed. Do not persist a suspended ability list and replay it into an
updated map. Conversion rejection markers, temporary spacers, timer handles,
pending transfers, selection/UI state and pickup/drop guards are transient.
Capture must refuse an in-progress conversion/transfer and deduplicate actual
item handles before assigning snapshot ordinals. Unique encoded ordinals alone
cannot prove that an adapter did not capture one handle twice.

Item owner player (`GetItemPlayer`) is different from the user-data ownership
marker. This audit found its use in Forsaken replacement preservation, not as
canonical save authority. Do not serialize a player slot as account identity.
Derive engine owner from the validated account/binding and reviewed container
policy on load; retain exact engine owner in same-game rollback journals.

Visibility, dummy/path probes and temporary invulnerability can be transaction
state. Persist only the reviewed flags of eligible real items, not hidden probes
or temporary adapter settings. Per-instance book cooldowns and active ability
handles remain session state unless an explicit future requirement changes that.

## Legacy limitation and adapter obligations

E/F/G/H saved item ID and conditional quantity only. Life, flags and unbound/bound
distinction cannot be recovered from those bits. Legacy migration uses reviewed
canonical object creation defaults and binds accepted items as the old loader
does; record provenance so a missing field is not mistaken for a captured zero.
Gaya/house stay separate containers. Recompute runtime requirements/variants
without changing permanent identity or granting bagged passive bonuses.

The reference codec represents life as two unsigned16-bit words containing an
IEEE binary32 value. Python conversion and fractional round trips are tested.
Exact JASS real conversion is **not implemented or verified**; this is an explicit
milestone4/5 requirement. Reject nonfinite/nonpositive/unrepresentable life,
invalid binding, unknown required metadata, and occupied duplicate positions
before gameplay mutation. No runtime save writer is enabled by this audit.

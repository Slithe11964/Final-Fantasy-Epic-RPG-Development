# PAIR031 inventory follow-up

Build transforms apply to the saved editor master without changing it. The new
native transfer controls, panel binding and cooldown handling are Forsaken-only;
stat labels and fishing guidance apply to both profiles. PAIR030 save readback,
legendary progress and Acid Rain changes remain.

## Shared cooldowns

The previous shared tracker ran before the separate cooldown-scaling trigger and
could use unscaled or inappropriate remaining-time values from an item ability.
The visible cooldown could therefore finish before the shared veto expired.

Native item spells now use a single duration calculation from their immutable
object cooldown at the casting rank, respecting the same Agility, Slashed/Reduced
Cooldown, Haste/Hastera and Slow/Slowra factors as the normal scaling trigger.
Invulnerable casters and Spirit Potion/Blood Ether retain the original scaling
exceptions. The ability-rank adapter handles item abilities not listed on units.

Admission snapshots that duration for the cast. Both the native ability instance
cooldown and shared deadline read the snapshot; a food/book that applies Haste or
changes Agility during its own effect cannot change only one of them. Rejected
casts never extend the deadline. Native remaining-time queries are not used as
shared-duration authority. Hero/Gaya and all gear aliases share the owner's
gear or consumable pool. The message reports the remaining seconds.

## Moving gear to the hero

The native drag path still did not accept backpack equipment in the user's
PAIR030 test. This patch supplies an explicit **Move to hero** button below
Talents on the native gear pane. Open it, choose a gear icon from the 30-slot
backpack picker, then choose an empty destination among hero slots1..6. Occupied
slots and nongear choices are disabled. Items in quick slots keep their actives;
equipment bonuses require actual equipment slots.

The local controls send only a bounded request containing hero type, bag position,
destination slot, item type and item user data. The synchronized receiver derives
the hero from the sender and checks current ownership/location/identity, bounds,
empty destination and a known gear mapping before moving anything. All mutations
run on every Warcraft client. Requests with changed/stale inventories are rejected.
Repeated requests cannot duplicate the item. Existing direct placement verifies
the new carried alias before removing the original and preserves charges, saved
life, user data and item ownership. Real gear aliases and save IDs are unchanged.

Frame handles and sync registrations are created at shared startup. The picker
scans inventory only on opening, choosing or receiving a move; it does not add a
periodic inventory scan. Its event/sync triggers join the generated fresh-load
trigger guard. Closing the main inventory also hides the picker.

## Panel closing

The actual visible Backpack controller is stock ASpc, authored at command position
0,1 with B. fBag/fGer provide native bag/equipment data. Poll binding and mouse
toggling now use ASpc rather than clicking passive inventory ability positions.

Open intent is authoritative: seeing a stale native pane never reopens an
explicitly closed inventory. B/mouse toggles, X and Escape hide both panes;
late native visibility is suppressed indefinitely until an explicit open.
Programmatic binding clicks are guarded and duplicate notifications debounced.

## Requested text

The talent heading is exactly two lines, e.g. `Points: 3/4` then `Level Ultimate`.
Points are earned tiers, independent of spending. Icons stay free of name labels;
hover descriptions remain inset. Other bonuses uses `Mana regen`, including Mana
Spring. The Proficiencies stat page omits the Heavens Forged Axe row and calls
Axe training `Axe`; research effects, IDs and house maximum-upgrade icons stay.

Fishing shows "Wait for the ! bite indicator, then pull toward shore." An early
direction input repeats that hint and leaves the cast/fish/controls intact. Once
the bite arrives, the existing pull/slack/side/timing and catch rules remain.
The user confirmed fishing itself works when waiting for the bite.

## Validation and engine checks

Full paired build, final archive audit and hash-verified TEST installation passed.
Compiler, editor-source, startup, content, save compatibility, armory, bazaar and
classic conversion checks passed. Focused checks cover duration/rank reductions,
own-cast buff snapshot, deadline expiration
without extension, malformed/stale/occupied-slot transfer requests, UI-only
request submission, persistent closing after late visibility, actual controller
binding, fishing early-input preservation and both profiles' stat text.

In Warcraft start PAIR031 and import a character with -loadf. Cast a book from
gear, then test other gear and Gaya before/after the displayed shared timer,
including a Haste item and a high-Agility hero. Use Move to hero on Holy Book of
Galbados/Tournesol: check the chosen empty slot, active cast, no passive bonus,
normal equipping afterward and save/load. Test B/mouse/X/Escape at intervals and
job changes, picker closing, independent two-player UI/transfer requests, fishing
before/after !, two-line heading and stat labels. Native drag itself is not
claimed repaired. Older legacy large-profile Warcraft-menu reload issue remains
separate; old Warcraft menu saves still contain their old map's code.

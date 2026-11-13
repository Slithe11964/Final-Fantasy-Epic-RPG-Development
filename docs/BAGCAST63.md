# UI63 / native Hotfix11 candidate

Owner reports F/G stop after -clear and recover on alt-tab; UI62 warning is
better but too high, and native bag wave previews still fail. This candidate
preserves the accepted cyan cursor and confirmed icon/casting implementation.

Changes only TEquip plus new owned FDF imports:

- After any submitted chat, defer local edit-focus release until Return is up
  and .1 seconds have elapsed. Clear held keys and stale chat latch; extend the
  late-send Enter guard from .25 to .75 seconds. No native key synthesis/clicks.
  This is a candidate for the -clear focus/latch symptom, not proven by a live
  reproduction.
- Warning remains gold/.024 with shadow; lower its position from the previous
  pixel-derived center to native frame Y .22. Exact above-HUD placement needs
  visual acceptance.
- Retire UI62 normal BUTTON hover probes. Shared initialization creates an
  owned SIMPLEFRAME with 30 owned SIMPLEBUTTONs, using the same class as the
  confirmed F/G controls. Show controls ONLY over bag slots containing water
  or three-line ice wave abilities. Non-wave items keep native item controls.
  Buttons are visually empty, leaving existing native item art/cooldown drawn.
- Real CONTROL_CLICK arms the existing GearWave renderer and cyan target
  cursor. This changes the wave item's click entry point, rather than trying
  to detect native item targeting afterward or convert an item into a hero
  ability. It still spends/casts the actual item through UnitUseItemPoint.
- New FFBagWave63 sync receiver validates slot, current hero type, current item
  raw ID/user mark, mana, shared/native cooldowns and world bounds. No item use
  occurs in local callbacks. Existing F/G request/receiver and icon functions
  are token-identical; shared mouse callback routes only pending slots >=100
  to the new bag receiver. No runtime item movement/ability rebinding.

Four focused tests pass: chat focus recovery ordering; local click arms without
casting; invalid/stale/uncastable synchronized requests are rejected; transitive
local callback safety and packaged preservation checks. Both maps pass playable
and editor compilation, startup/source/global, save compatibility, content,
archive readback and unrelated-resource identity checks.

**Unverified:** native SIMPLEBUTTON delivery/stacking and six-by-five slot
geometry, actual bag cast success/preview appearance, native hover/tooltips and
drag behavior over the wave overlays, exact warning placement, -clear fix, and
multiplayer/crash behavior. Do not claim native in-game acceptance from mocks.
Owned frames and triggers are created unconditionally in fixed shared order;
local UI changes allocate no handles or gameplay objects. Original master and
prior maps are preserved. Scene audit is separate: CINEMATIC_COMPARISON63.md.

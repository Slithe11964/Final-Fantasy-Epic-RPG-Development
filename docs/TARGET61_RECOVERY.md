# UI61 / native Hotfix09 — visible cursor, yellow warning, backpack wave observer

Owner rejects UI60: G hides the pointer but replacement is invisible; native
empty-ground error should be yellow and centered above the interface. Book of
Depths / Wateraga / Ice Wand U backpack clicks still show only the native teal
cursor, with no runes.

Concrete cursor failure identified: UI60's UV rectangle selected texture row
y32..64 in HumanCursor.dds, which has entirely transparent alpha. This was an
asset selection error, not evidence that the native cursor itself was broken.

Recovery:

- Restore the normal BACKDROP cursor display route proven visible in UI58.
  Package the exact native cyan cursor cell from HumanCursor.dds at pixel
  rectangle (32,96)-(64,128), with its original colors, alpha and shape. No
  recoloring or guessed drawing. The exported TGA is checked for nonempty alpha
  and pixel equality to that native cell.
- The replacement is independent of the atlas SIMPLEFRAME/FDF that failed.
  Cursor updates still use the existing dedicated .01-second UI timer. The
  normal pointer is enabled first and is only hidden after the owned replacement
  frame exists and reports visible. This cannot test GPU texture rendering, but
  avoids hiding the pointer for a missing/invisible frame.
- Ground-target warning uses yellow MasterFont text with black shadow, centered
  at (.4,.295), matching the supplied screenshot's placement above the console.
  Existing empty-ground no-cast / keep-armed behavior and error sound remain.
  This is an owned UI text frame, never chat or DisplayTimedText output.

Backpack rune detection changes:

- Native inventory hover/click hooks were ineffective in owner testing. Stop
  registering those hooks. Do not replace native input or issue a second cast.
- At shared initialization cache the two native tooltip roots, up to eight
  direct children of each, and known tooltip title/text names. Never walk native
  Simple inventory panes or recurse into unknown child frame types.
- Read currently shown tooltip text while the native bag/equipment panel is
  open, map the wave item's normalized name to its actual spell, and cache that
  match before the click. This handles the engine hiding the tooltip immediately
  as targeting starts. The snapshot expires in .2s and must remain within 12
  screen pixels of the hovered item before it can arm a wave.
- Native Book of Depths and Wateraga arm the existing 800-unit line; Ice Wand U
  arms the existing three Blizzaga paths. Native targeting and casting remain
  owned by the real item input. The local observer changes only preview state.
- Tooltip text scans are throttled to .03s, bounded to 160 characters per frame,
  with bounded name-prefix matching. -gearcheck includes tooltip-buffer count,
  preview-arm count and last readable tooltip text for actual client diagnosis.

Unchanged: F/G request/receiver/click validation, icons, cooldowns, damage and
all object data, Dragoon skin fallback and prior Kalm/Gilgamesh scene candidate.
Exact native item-targeting activation from G remains unresolved; the cursor
is still a scripted overlay, not a native targeting-mode claim.

Five focused tests cover all three items (including a tooltip hidden on click),
stale/moved/closed-panel snapshot rejection, visible-pointer fallback, no cast or
frame discovery in the preview poll, exact cursor pixel packaging, warning
style, and preserved casting/icons/scenes/objects. Compiler/editor/startup,
content/save and archive checks pass. Prior candidate files are preserved.
Final archives were installed into Documents/Warcraft III/Maps/Download/TEST
with matching SHA256 copies. The final cyan bitmap was visually inspected and
matches the exact native cell pixel-for-pixel. Final script/editor/gameplay bytes
also match the previously checked candidate; the last packaging change only
replaced the cursor pixels with the native precolored cell.

Live Warcraft validation could not be performed: computer-use initialization
failed with missing runtime/kernel assets before any UI action. Actual tooltip
readback on the installed client, cursor/error appearance, perceived latency,
and multiplayer acceptance remain unverified. Do not describe mocks as proof
that native tooltip detection works. Original master and earlier maps unchanged.

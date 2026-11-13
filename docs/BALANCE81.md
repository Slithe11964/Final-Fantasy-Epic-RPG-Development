# QuickUI81: house recovery, damage multiplier and tooltip copies

Dragoon development test only, based on QuickUI80. House hH79/hM79 recover 10% maximum health/mana per second within the existing radius; original Fountain of Restoration unchanged.

Drakesbane and Rise of the Dragon now multiply their complete base damage (including STR, MP cost and Spear Proficiency scaling) by max(0, 1 + 0.02 x (Accuracy - target Evasion)). Owner confirmed difference-in-parentheses and coefficient .02. A 20-point advantage yields x1.4; a 10-point disadvantage yields x0.8. The factor floors at zero so large disadvantages cannot turn damage into healing. Rise retains its existing 50% bonus below 30% target HP and Fire type; Drakesbane retains attack element.

Sonic Thrust costs 200 mana at maximum rank only; lower ranks retain 150. Jump impact radius is 300 (diameter 600); its distance damage factor and cooldown are unchanged. All affected ranked tooltips and live spell-calculation strings match.

The house armory uses separate unit objects, whose tooltips were missed by the previous item-only balance patch. All eleven named spear display units now copy the current canonical item description, including new accuracy/physical/element bonuses, poison/Shock, Holy healing conversion and removal of Halberd HP/Holy regen. All ten R009 research ranks plus capped pF04 Spear proficiency ability now use the requested mana-regeneration/block description and Dragoon name. No unrelated object field edits.

Five focused tests cover actual Jump radius inclusion/exclusion, multiplier behavior, house-only recovery, max-rank-only mana change, every house tooltip copy and preservation of earlier spear/summon scaling. Full map/editor compile, startup/pairing/globals/text, content IDs, save compatibility and archive readback pass. Native in-game acceptance pending. No bag, inventory, F/G, preview, polling or timer changes. Confirmed cross-player bag closure remains unresolved. Normal release, 1.29.2 and editor master preserved.

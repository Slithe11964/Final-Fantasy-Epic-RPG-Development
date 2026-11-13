# UI42 Dragoon tuning (2026-10-26)

Installed full RPG map: FFERPG-QuickUI42-Forsaken.w3x in Warcraft III Maps/Download/TEST. Earlier maps preserved. Based on confirmed UI40 with all prior fixes.

Drakesbane reach300, cone180 degrees. Rise and Dragon Ally exchange button positions, keeping R/D hotkeys. Jump requires an enemy and follows it during the approved arc. Eye uses BTNedricseye. All active abilities use existing cooldown reduction. Original Dragon Ally retained.

Damage uses Spear Technique multiplier P = 1 + 0.1 * proficiency level:
- Sonic: (5 * MP cost + 3 * STR) * P, Knight Armor Breaker reference.
- Drakesbane: (3 * MP cost + 4 * STR) * P + positive accuracy minus enemy evasion, Knight Shock reference.
- Rise: (4 * MP cost + 4 * STR) * P + positive accuracy minus enemy evasion, Flare reference with STR replacing INT.
- Jump: (MP cost + STR + AGI + INT) * .02 * (min(1000, initial distance) + 200) * P, original Jump reference.

Sonic/W/Jump MP costs:60/80/100/120/140/160/180/200/220/240/300. Rise:460/580/700/820/940/1200. Existing Rise range800/radius300, visual, stun and low-HP bonus retained. Sonic target-only stacking evasion reduction and20 push retained. Invalid late casts refund mana/cooldown.

17 behavior/object checks and final playable/editor compilation, startup, archive readback, save compatibility and typed references pass. Native game and multiplayer acceptance pending.

Sources: experiments/Dragoon/DragoonRPG.j, DragoonUI.j and tools/dragoon_rpg.py. Build tools/build_dragoon_ui42.py. UI41 artifact is preserved; current shared sources include UI42 tuning.

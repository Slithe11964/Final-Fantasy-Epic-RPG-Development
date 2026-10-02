# Developer test commands

Module: `DevCommands`, in the Trigger Editor folder "11 Developer tools".
They work **only in single player**, and only while `DEV_COMMANDS_ON` (top of the module) is `true`.
The map says so 5 seconds after it starts; type `-dev` for the list.

**For a public release:** untick the DevCommands trigger. Nothing else needs it: start-up skips it
automatically, and `tools/disable_check.py` confirms this.

| Command | Does |
|---|---|
| `-dev` | List the commands. |
| `-gold N` | Add N gold. |
| `-shards N` | Add N Crystal Shards (lumber). |
| `-bp N` | Add N arena Battle Points (capped at 999,999). |
| `-lvl N` | Raise the current hero to level N. |
| `-heal` | Refill the hero's life and mana. |
| `-god` | Toggle invulnerability for the hero. |
| `-cd` | Reset the hero's cooldowns. |
| `-item XXXX` | Create the item with that rawcode at the hero, e.g. `-item I01Z` (Crystal Shard). Rawcodes are in the Object Editor (Ctrl+D shows them), or in comments next to IDs in the code. |
| `-unit XXXX [N]` | Create N (1–20) enemy units of that type around the hero, e.g. to test damage. |
| `-kill` | Kill your selected units (not your own heroes). |
| `-tp X Y` | Move the hero to map coordinates. `-tp` alone moves it to the centre of the camera. |
| `-pos` | Show the hero's coordinates. Useful to note boss locations for `-tp`. |
| `-time H` | Set the time of day (0–24; night spawns differ). |
| `-reveal` | Toggle full map vision for you. |
| `-spawns on/off` | Pause or resume monster spawns. |
| `-title N` | Grant title N (sets the save-code title flags, so it's useful for testing save codes). |

## Notes

- **Cheat detection:** the map's own cheat detection (module `Cheat`) only reacts to Warcraft's built-in
  cheat codes, so these commands don't trigger it. `-reveal` uses a vision modifier, not "fog off".
- **Save codes:** a code saved after using the commands includes whatever they gave you. That's fine for
  testing, but don't share such codes.
- **Adding a command:** add an `elseif cmd=="-name" then` branch in
  `Trig_DevCommands_Chat_Actions` and a line in `DevCommands_Help`.

# Save codes: how `-save` and `-load` work

Modules: `Save` (09), `Load` (09), `Cmd` (09, the `Trig_Cmd_Load_Code_*` functions), `Code` (01),
`Autosave` (09), `SaveDebug` (09).

## What a player sees

| Command | What it does |
|---|---|
| `-save` | Shows the code in chat. |
| `-savef <name>` | Writes the code to `Documents\Warcraft III\CustomMapData\FFERPG\<name>.txt`. |
| `-load <code>` | Loads a typed or pasted code. |
| `-loadf <name>` / `-loadx <name>` | Loads from a file written by `-savef`. In multiplayer (or with `-loadx`) the code is typed into the load unit's UI so every player's game runs the load (`Load_TypeCodeWithUIKeys`). |
| `-loada` | Loads the armory part of a code. |
| `-autosave on/off` | Writes the `autosave` file regularly, one player at a time. |
| `-newgameplus` / `-newgameminus` | Writes a New Game+/− code once the needed title is earned. |
| `-sdebug` | Turns save debug messages on/off (`SaveDebug`). |

- **Load window:** loading is only allowed early in the game. `Load_Warn_5Min` warns at 5
  minutes and `Load_Disable` turns loading off at 15 minutes.
- **Hardcore mode:** loading is not allowed at all.
- **Already loaded:** each player can load once per game (`udg_HasLoadedCode`).
- **How the save file works:** the file is a Warcraft "preload" script (`Save_WriteCodeFile`).
  When `-loadf` runs it, the script sets the player's name to the code. `Load_OnLoadFile` then
  reads the name back and restores it.

## What is saved

`Save_WriteCode` writes the values below **in this order**:

1. **Header**, written by `Save_Begin`:
   - player-name hash (20 bits)
   - difficulty (2 bits)
   - gold + 1500 × lumber, capped at 999,999 (20 bits)
2. Gaya mastered (1 bit) and the New Game+ parity bit (1 bit).
3. **Job levels:** one level for every job in `udg_JobUnitType`, in table order (see
   [JOBS.md](JOBS.md)). A mastered job is saved as level 100.
4. Freelancer level, then the Spirit of Gaya's level and her bought abilities.
5. A New Game+ flag.
6. **Inventories:** the hero, Gaya, and the player's house, 6 items each.
7. **Weapon and armor upgrades:** `R000`–`R00B`, `R00M`, `R00N`, `R00L`, in that order.
8. **Title and quest flags:** membership in `udg_TitleForce[n]` groups, as 1–2 bits each.

`Save_Finish` then:

- adds a 3-character checksum to the front;
- adds the optional `( … )` unit-flag part;
- puts the **version character** at the very front.

## How the bits become text (`Code` module)

- **Writing:** `Code_WriteInt` packs values bit by bit. Each bit is mixed with a rolling key
  that starts at 13 × version and grows by 211 per character.
- **Alphabet:** every 6 bits become one character from `A–Z a–z 1–9 0 $ #`.
- **Colors:** characters are colored by range so they are easier to read and type.
- **Reading:** `Code_ReadInt` and `Trig_Cmd_Load_Code_ReadBits` undo the same steps.
- **Validity checks:** a code is rejected when the checksum does not match
  (`Trig_Cmd_Load_Code_Checksum`) or when the name hash is not the loading player's
  (`Trig_Cmd_Load_Code_PlayerNameHash`).

## Versions

The first character is the version: `A` = 0, `B` = 1, and so on.
`Trig_Cmd_Load_Code_LoadCodeDispatch` picks the reader:

| Char | Reader | Notes |
|---|---|---|
| A–D | — | Too old ("before 0.9.6"); refused. |
| E / F | `LoadCodeV2` | F = with armory. |
| G / H | `LoadCodeV3` | **Current.** `-save` writes G (version 6), or H (version 7) when the player has armory items. |

## Changing what is saved: the rules

- **Keep writer and reader in step.** The writer (`Save_WriteCode`) and the reader
  (`Trig_Cmd_Load_Code_LoadCodeV3`) must read and write the same values in the same order with
  the same bit sizes. One mismatch shifts every value after it, and the code loads garbage or
  fails the checksum.
- **Don't edit a current reader in place.** Players have G/H codes, so change the format like
  this:
  1. Bump the version in `Save_WriteCode` (`6 + armory` becomes `8 + armory`, which writes I/J).
  2. Copy `LoadCodeV3` to `LoadCodeV4` and add the new values there.
  3. Add the `I`/`J` branches to the dispatch.
  4. Leave `LoadCodeV3` untouched, so G/H codes keep loading.
- **New jobs:** adding one to `udg_JobUnitType` changes the job-level part of the code. Old
  readers loop over `udg_JobCount`, so they would read one level too many. A new job therefore
  needs a new code version too; the reader for old codes must stop at the old job count.
- **New items:** items are saved by their position in `udg_ItemIdTable`, in 9 bits. Add new items
  at the **end** of the table and stay below 501. Reordering it changes what old codes load.
  See [LOOT.md](LOOT.md).
- **Testing:** test every save change by saving, restarting, and loading, in both a code (`-load`)
  and a file (`-loadf`). `-sdebug` prints what is being written.
- **Long text:** keep long text out of custom script. Very long JASS strings break loading saved
  *games* (the in-game Save Game menu, not codes). See `SYSTEMS.md`, "Long text".

## Reading a code outside the game: `tools/savecode.py`

```
python tools/savecode.py decode "<code>" [--name PLAYER] [--log]
python tools/savecode.py selftest
```

`decode` lists what a code holds: difficulty, gold, every job level, Freelancer/Gaya, the three
inventories, upgrades, titles and New Game+ level. `--log` prints every field with its bit size,
which is handy when a code fails to load. It follows the game's reader (`LoadCodeV3`) step by step,
for G/H codes.

**Item charges:** a charged item stores 7 extra bits, so the tool must know which items are
charged. The in-game developer command `-dumpitems` writes `itemtable.txt` (see
`DEBUG_COMMANDS.md`). A copy from 0.9.7.3-r16 is in `src/itemtable.txt` (351 items, 63 charged) and is
used by default. Run `-dumpitems` again and replace it whenever an item table changes. `--items FILE`
uses another table. Checked on a real level-923 code: every field decodes and nothing is left over.
A charged item can show `x0`: that is the value the game saved (`GetItemCharges`).

**Testing:** `selftest` writes 2,000 random codes with a Python copy of `Save_WriteCode` and reads
them back. That proves reader and writer agree with each other. **It still needs checking against
a real code from the game.**

**When you change the save format,** change `savecode.py` the same way (`decode` and `encode`)
and run `selftest`.

## A player changed their account name: `savecode.py rename`

A code only loads for the player it was saved by: its first field is a 20-bit hash of the account
name (everything before the `#` of the BattleTag, case ignored): `abs(StringHash(name)) mod 2^20`,
see `Trig_Cmd_Load_Code_PlayerNameHash`. A player who renames their Battle.net account gets
"This code belongs to a different player!". To give them their progress back:

    python tools/savecode.py checkname CODE OldName                      # is this really their code?
    python tools/savecode.py rename CODE NewName --old OldName           # prints the new code

The same tool as a web page: `tools/web/name-swap.html` (open it in any browser; it works offline).
It accepts the code, a `-load` line or the whole save `.txt`.

Only the name hash and the 3-character checksum change (code characters 2-8). The armory part (in
brackets) starts with its own 3-character checksum and a copy of the main checksum: that copy is how
`-loada` checks "Armory subcode does not belong with this code!". `rename` rewrites those 6 characters
to match. Jobs, items, titles and the armory contents stay exactly as they were. `--old` refuses to rewrite a code that does not
belong to OldName, so ask the player for the old name and check it. The hash was checked against a
real code (saved by "Slithe": hash 268296).

Names with letters outside plain English (accents, Cyrillic, Chinese ...) may hash differently
between 1.29 and Reforged; check the result with `checkname` and in game.

Note for maintainers: `rename` lets anyone move any code to any name. Keep the old-name check, and
only do this for players who can show the old account was theirs.

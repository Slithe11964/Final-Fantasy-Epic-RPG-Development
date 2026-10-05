# Quest play-test list (stages O and P)

Stage O put 62 side quests on the quest engine, stage P the main story (18 more). Stage N's 10 quests are
listed in docs/QUEST_ENGINE.md. Every dialogue line was kept word for word (checked by comparing all text
in the old and new code). Play each quest at least once with cinematics on; the main story also once with
cinematics off. Tick a box when a quest has been played to the end.

Not on the engine (on purpose): **Cartographer** (rewards worked out over repeated reports, can complete in
its first talk), **True Ice Age** (one log entry shared by five quest slots), **Ao Madoushi** (not yet looked at).

## What changed for every quest

- The quest log, "New Quest Received / Completed / Failed", the quest count and the story count are now
  done by the engine. Texts, names, colours and icons are the same.
- Where the engine draws the "?" (simple quests), it is removed after the final dialogue instead of before.
- A few updates that went only to playing players now go to all players (only players who left notice).
- Minimap pings of quest items use one shared 15 s timer.

## Side quests (stage O)

| Done | Quest | How it starts | Check |
|---|---|---|---|
| [ ] | Find Beastslayer | Cid | lizard spawns, pinged; arrow drops; pickup note to picker only; 1500/1000; Wyrm hunt |
| [ ] | Brothers | after Kill Elmdor | first line names the hero type; fight; "Return to Izlude." with ping; 3000/2500 |
| [ ] | Caravan | Sam, then Dio | both fail (all horses die) and success; gold 1000 + 2000 per extra horse |
| [ ] | Cooking Choices | walk to the fireplace | first meal; 0/2000; story count unchanged |
| [ ] | Kill Setag | Cid (Halaster) | ambush; fail if Halaster dies; 2000/1500 |
| [ ] | Lady Nashj | Night Elves talk | charm to the talker; Nashj pinged; 3000/2500 |
| [ ] | Seek and Destroy | Clemydar | 3 leaders, 0/3 -> 3/3; return ping; 2500/2500 |
| [ ] | Annoying Monster | Lady Curse marker | monster; pickup note; 0/2000 |
| [ ] | Young Engineer | Mid | prototype; report after 15 s; 5000/4000, Auto-Crossbow |
| [ ] | Fishy Deals | find the fishing pole | soup 5000/2000, bread 12000/6000 |
| [ ] | Nebra Angler | Anabel | one charge taken; 6000/3000; Muramata |
| [ ] | Eidolon Challenge | Minotaur after Kalm Siege | 0/4 counter; 4000/4000; rematch alert 60 s later |
| [ ] | Spirit Hunt | Frakir | "Spirits to kill: 20"; 6500/6000 |
| [ ] | Haunted Tree | Oaka IV | capture with the pendant; 3000/2500 |
| [ ] | Mystical Glyph | glyph drop | hand-in; 8 min later "!" and "Talk to Storm."; 0/2000 |
| [ ] | Ancient Hunt | Krjn | both talk branches; "Ancients to kill: 20"; 3000/3000 |
| [ ] | Arcanium | Forge (Bali) | pickup note; 9000/3000 |
| [ ] | Dwarf Disappearance | enter the empty Forge | Valigarmanda; 8000/8000 |
| [ ] | Ore Supplies | Loki | 0/5 -> 5/5; 6000/1500 |
| [ ] | Divine Order | Siegfried, 3 min after Impervious Beast | 20000/20000 |
| [ ] | Fiery Wings | Watts | Matriarch; "Return to Zone and Watts."; 4000/2000 |
| [ ] | Impervious Beast | Ziegfried at the mine | Fafnir; 4000/12000, Grand Armor |
| [ ] | Holy Knight | Agrias | "Kill Agrias.", "Kill Shadow Queen Lilith" |
| [ ] | Fallen Ranger | Liniel | Yukale, Dark Ranger; 3500/3500 |
| [ ] | Spirit of Water | Priscilla | Water Gem, Vodyan, Tiara; 10000/5000 |
| [ ] | Ultima Weapon / Omega Weapon | attack them | log and music; item and titles on death |
| [ ] | Shinra's Plan / Almighty Shinra | after World Liberation | 3 hand-ins, 20000/10000; red title, Dimension Cup |
| [ ] | Scorched Earth | McBurn | red log; barrier; McBurn's true form |
| [ ] | Hydra Egg | Jack (from the start) | egg pickup note; 0/1500 + Water Materia |
| [ ] | Arena Resources | Limma | escort; lose the ship once (retry text, -1000); win |
| [ ] | Fire Golem's Heart | 60 s after Phoenix | Alma camera; golem pinged; heart + Fire Wand; 2500/2000 |
| [ ] | Rematch | Brothers alert | 6000/6000, Quake Materia |
| [ ] | The Strongest Eidolon | Priscilla | Eden; 0/10000 |
| [ ] | Tower of Summoning | old man | Quezacotl; the Tower |
| [ ] | Trial By Fire | McBurn | survive 30 s for 6666/6666, or lose and fail |
| [ ] | Blazing Demon | after dark Ifrit and Phoenix | all three endings |
| [ ] | The Northern God | Alberich (attack or spare) | red title; "Defeat Odin."; 80000 gold |
| [ ] | Mithril Golem's Heart | 5 min after Fire Golem | key, cage, golem, heart; 5000/5000 |
| [ ] | Save Nimphrodel | Night Elves | crystal ball note; 5000/4000 |
| [ ] | Defiled Fountain | Night Elves | hoof, bulb, scroll; 4000/3000 |
| [ ] | Healing Waters | | Cure 4000/500 and CureBlood 8000/4000 |
| [ ] | Mysterious Curse | | both liars and the witness path |
| [ ] | The Bridge-Battle | Mae'chen | Gilgamesh; "Return to Mae'chen."; 10000/10000 |
| [ ] | Ogre / Adamant / Wendigo / Dragon Hunt | Monica / Bansat / Ward / Ma'kenroh | board rows 4 / 3 / 8 / 9; rewards; next hunts |
| [ ] | Flan Hunt | Dana, then Olga | 20 flans; fail if Dana dies |
| [ ] | Tentacles | lure Ultros | "Defeat Ultros.", "Return to Sarai."; fail if Dana dies |
| [ ] | Dragon Egg | Dana | pickup note; 3000/3000 |
| [ ] | Target Practice | Aisha | gauntlet; retry after timeout; 4000/4000 |
| [ ] | Save Timmy | Katya, or free Timmy first | both orders; then Gnoll Hunt "!" over Kiros |
| [ ] | King of the Sea | fish him up | escape and re-catch updates; head to Anabel 20000/20000 |
| [ ] | Monstrum of the Sea | Grattheos Charm, night | dive/reappear updates; Slither Shield |
| [ ] | Lost Memories | Shadow | with and without the faded ring; ring-fade fail |
| [ ] | Name Diary | Timmy | name list grows; 26 names; 6500/7500 |
| [ ] | Hunt Festival | Montblanc | text at start and end; completes at the end |
| [ ] | Arena Expansion | Limma after Dimensional Boundary | Shadow Stone, dust, final cinematic; 6000/6000 |
| [ ] | Chocobo Rider | rider, or arrive with a chocobo | both ways |
| [ ] | Dimensional Boundary | Shinra's chain | gold title; both endings (empty border, Zeromus) |

## Main story (stage P)

| Done | Quest | Check |
|---|---|---|
| [ ] | Find Mid | talk to Cid first, and free Mid first ("Talk to Cid to speak to him about Mid."); Arena opens |
| [ ] | Find Artifact | pickup note to picker only; both routes (artifact to Cid, or a Brave dies first) |
| [ ] | Stop Cid | beat Cid to 3000 HP; 1500/1000 |
| [ ] | Eye of Jenova | after Ao Madoushi; hand-in 2000/2000, Demi Materia |
| [ ] | Night Elves | first visit and Lothlorien-already-open routes |
| [ ] | Dark Knight / Necrophobe | scrying vision; "Destroy Zalera..."; World Liberation starts on his death |
| [ ] | World Liberation | "Zodiac Braves defeated: n/12"; at 12 the reward 6 s later |
| [ ] | Kalm Siege I / II / III | lose once (retry text), then win; story count as before |
| [ ] | Corrupted Orcs | both starts (Meliadoul, gate guard); fountain; Shemhazai |
| [ ] | Illusions to Illusions | Dana, Famfrit |
| [ ] | Last Rites | Zack, the priest's reveal, Exodus |
| [ ] | Voice of the Forest | Galadriel, crystal at the soul fire, Chaos |
| [ ] | Light of Judgment | Ramza, Alma, Ultima |
| [ ] | God Dragon | Montblanc, Zodiark |
| [ ] | End of Zodiac Age | Celeborn (three gate states) or Hashmalum; updates along the way |
| [ ] | Advent of Ice Age | announced 4 s after Hashmalum dies; Echele |

## Fixed in stage Q

Kalm Siege I and II no longer re-give their reward when the siege timer runs out again later.

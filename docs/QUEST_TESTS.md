# Quest play-test list (stages O, P, R and S)

Stage O put 62 side quests on the quest engine, stage P the main story (18 more). Stage N's 10 quests are
listed in docs/QUEST_ENGINE.md. Every dialogue line was kept word for word (checked by comparing all text
in the old and new code). Play each quest at least once with cinematics on; the main story also once with
cinematics off. Tick a box when a quest has been played to the end.

All 93 quests are now on the engine. Ao Madoushi was converted in stage R (user reports it works great);
Cartographer and True Ice Age in stage S. Their targeted checklists are below.

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

## Ao Madoushi (stage R)

Use release/FFERPG_0.9.7.3-r16-stageR.w3x. Both branches should complete once, add exactly one completed
quest, leave story progress unchanged and start Eye of Jenova once. The existing 1500 gold / 1500 XP
reward follows Reward_Give (including Eternity rules); reward and Eye of Jenova/music timing match Q.

| Done | Path | Check |
|---|---|---|
| [ ] | Before Hashmalum appears, cinematics on | Cid's Zodiac Stone description; first Turk sends you to the other; second gives one invulnerable flute; original wolf/bear spawns and markers; flute consumed at hut; sage first talk gives no reward and asks for the Stone; Stone-break scene updates to Visit Ao Madoushi; report gives 1500/1500, completes once, starts Eye of Jenova, adds the report's random-object marker, changes music after 4 s |
| [ ] | Hashmalum already free at first talk, cinematics on | Cid's description reflects his state when the quest starts; sage uses the correct discovered-MainQuest[3] dialogue variants, including incremental People call me that transmissions; first talk gives 1500/1500, completes once, starts Eye of Jenova; no Stone handoff/report needed |
| [ ] | Hashmalum breaks free between Cid's request and first sage talk | Initial Stone description stays valid until the usual updates; first sage talk takes the already-free completion path regardless of the initial description |
| [ ] | Both completion paths, cinematics off | Same log updates, markers, reward/count and Eye of Jenova start; no dialogue; music still changes after 4 s |
| [ ] | Alternative Stone-break scene after the first sage talk | Original alternative scene/spawns; Visit Ao Madoushi log and marker; report completes normally |
| [ ] | True Ice Age interrupts at Cid stages 9, 10, 11 or 12 | Existing direct quest-log completion and stage-dependent marker/item/trigger cleanup remain as in Q; no new completion announcement, reward or quest-count increment from the custom engine steps |
| [ ] | Eye of Jenova follow-through | Arena target ping/drop enabled; pickup update; bring Eye to sage; original hand-in, Demi Materia and next Cid quest work |

## Cartographer and True Ice Age (stage S)

Use release/FFERPG_0.9.7.3-r16-stageS.w3x. Automated checks pass, including the lifecycle source harness,
but game behavior, editor Save As, multiplayer and native save/load need confirmation.

| Done | Quest/path | Check |
|---|---|---|
| [ ] | Cartographer, accept below 15% | Log and exploration requirement exist before dialogue; original announcement afterward; original markers/Makenroh unlock; no payout yet |
| [ ] | Cartographer, accept at 15–89% | Same introductory payout for every achieved tier; no paid tier can be paid again; progress requirement tracks the original exploration scan |
| [ ] | Cartographer, accept at 90%+, cinematics on/off | Original 24000 gold/XP via Reward_Give; completion during introduction; only Quest Completed, no New Quest Received; requirement Sufficiently explored!, counted once, no story increment |
| [ ] | Cartographer, repeat reports, cinematics on/off | Every unpaid tier pays once via Reward_GiveAll (1000/2000/3000/4000/6000/8000); skipping tiers pays their sum; final report at 90%+ completes/counts once; total tier payouts 24000 gold/XP; marker shared with Hunt Festival behaves as before |
| [ ] | Cartographer, revealed fog | Original Cancelled requirement/marker and plagiarism dialogue; failure announcement once; total quests decreases once; no completion count or further report payout |
| [ ] | True Ice Age, summon | Same red title/icon/text; one log replaces slots 8/9/11/19/20 before cinematic; no early New Quest Received; original announcement after cinematic; original world changes and interrupted-quest cleanup |
| [ ] | True Ice Age, timeout/retry | Freeze cinematic and respawn behave as before; quest stays active without new failure/discovery messages; another attempt can complete it |
| [ ] | True Ice Age, hardcore timeout | Original frozen-world ending; no new quest failure announcement |
| [ ] | True Ice Age, victory | Original cinematic, loot, 50000 gold/XP, 5 shards, awards and epilogue unlocks; one completion/count for the shared log; both original story increments occur at their original summon/victory points |
| [ ] | Existing engine quests, multiplayer/save/load/editor Save As | At least one ordinary talk/reward quest and Ao Madoushi still work; no duplicate messages/rewards with multiple players; native save/load and editor-saved stage S compile and play |

## Shared temporary-context cleanup (stage V)

Use release/FFERPG_0.9.7.3-r16-stageV.w3x. Automated gates/38 tests/whole-script reversal pass.
The intended dialogue, reward amounts, timings and world changes are unchanged. Check:

- [ ] Cartographer: accept, explore more, report twice; progress changes normally and paid tiers never pay again.
- [ ] Cartographer: reach 90% and finish once; check both first-talk and later-report completion if practical.
- [ ] True Ice Age: summon with a hero near the summoning area; all hero lines keep the selected speaker through the cinematic.
- [ ] True Ice Age: summon with nobody nearby so the fallback party choice is used; same speaker throughout, then normal encounter/retry/victory.
- [ ] Repeat the affected flows with cinematics disabled and in a two-player game; speaker and rewards remain correct while other triggers run.
- [ ] Quick old-code save/load smoke test. No objects, item tables, jobs or save format changed.

DevCommands remains disabled; it is not necessary for normal testing. Use separate test copies if enabling it.

# QuickUI93 and Creature Review 03c

Built from QuickUI92. These candidates preserve earlier maps, production releases, classic builds and the editor master. Creature Review 03c retains readable calculations, nearby rare hunts/local bosses, the review projectile initialization fix and the separate Forest/Highroad spider exhibits.

## Confirmed world-pool moves

- `ngno`, `ngns`, `ngnv`, `ngnw` now occur in ordinary world pools **only in Galbados Highroad**, using their existing Highroad definitions. This supersedes the request to create separate Mountains versions. Their unit definitions are unchanged from QuickUI92: no extra regional variants were introduced.
- `nsgn`, `nsgh`, `nsgb`, `nsel`, `nrel` move from Central Islands to Naga Islands with their original day/night weights.
- The owner explicitly chose **Flan (`n01O`)**, not Lesser Flan. Flan had no ordinary world-pool entry, so it is added to Naga Islands day/night pools at weight 1. Lesser Flan (`n01P`) stays in Highroad.
- All arena modules, team definitions, roster arrays, offers and Battle Arena setup functions remain byte-for-byte unchanged. The moved creatures' unit definitions also remain unchanged. The pool moves do not remove them from arena teams. World-role balance/icon changes below are the requested shared spell changes, rather than an arena-roster redesign.

Highroad baselines retained: `ngno` level 19 / 2500 HP / 52 armor; `ngns` level 19 / 2300 HP / 28 armor / 130–136 attack; `ngnv` level 24 / 4100 HP / 54 armor / 161–185 attack; `ngnw` level 23 / 2750 HP / 45 armor / 210–219 attack. Their current Highroad spell loadouts are retained. Highroad poison descriptions now match the existing formulas.

## Balance and behavior

- Forest Goblin Great Shaman `nfsh` swaps Devotion Aura for `nggr`'s Evasive Endurance Aura: +20% evasion within 600. `nggr` receives Devotion Aura: +10% armor within 600. Native aura effects remain. The evasion calculation now allows `nggr` to benefit from a nearby shaman's evasion aura, while retaining its own specified base evasion.
- `nsgg`: 20% physical block. `narg`: 15% physical block.
- `nowe`: 20% physical and magical block; Taunt reflects 20% of received physical/spell damage for five seconds. Existing three-second taunt, range and cooldown remain. Reflection retains its recursion guard.
- `ngst` Expanding Ground Slam and `nsgg` Immovable Taunt AI activate only with an enemy within 150. Their actual damage/taunt effect areas remain unchanged.
- `nhar` receives Barrens Alert: 15-second interrupted-by-death call, final 5–4–3–2–1 countdown, then 60 seconds of doubled Barrens spawn frequency/wave amount. Existing one-call and refresh rules apply.
- Penance's Left/Right Arms `n08E` / `n08B` acquire targets within 800. Native acquisition data and the arms' unpause setup both enforce this; encounter radii and roster definitions are unchanged.
- All animal-companion, Summoner, Bahamut and Dragoon summon tiers acquire within 1000. Forty-eight resolved summon definitions have native acquisition data updated. Every summon-powerup caller sets the range before the conditional scaling call, covering already-scaled/master variants as well; the shared scaling action also enforces 1000. Summon damage/HP/armor formulas are unchanged.

## Spell casting and Firebolt

The existing one-second role AI continues to attempt ready spells. It now lets an existing spell order complete instead of interrupting it with the same order every second. A three-second stale-order watchdog allows blocked/stale orders to be retried. No new polling timer is added.

`nwzg` starts with Aeroaga and has no research/Devour prerequisites. `nwzd` still unlocks its stronger Aeroaga through its own Devour. Wizard AI retains ready-spell branches for Aeroaga, lightning spells, shielding and Firebolt.

`nwzr` Firebolt now launches a visible homing FireBall missile through the existing missile engine (scale 1.5, speed 27 per existing 0.03-second active tick). Impact deals 800 Fire magic damage and applies the existing three-second native stun. Expired/missing/dead/distant targets cannot receive a remote impact. The missile tag is reserved as 93 and is reset by the existing allocator. The launcher is invoked by name to preserve library dependency boundaries; no local-client gameplay branch is introduced.

## Presentation and status markers

- 108 new role ability records receive icons selected by spell name. Different names have different icon paths; identical names share icons, including poison/guard variants. Paths come from existing map icons or the cached classic asset catalogue. No blanket bear-roaring icon remains for unrelated spells.
- New and retained cast visuals distinguish spells with appropriate art, scale and tint. Taunts intentionally use the same Taunt visual family. Weakening/War shouts use Demoralizing Roar visuals, with War Shout tinted/scaled distinctly. Pack Howl, Armor Shout, Accumulate, Field Kit, Evasive Action and Rocky Defense receive appropriate distinct cast effects. Poison/status families intentionally share matching native status visuals.
- Scripted taunt, weakening, increased-damage-taken, evasion reduction, bleed and five-/ten-second poison effects have matching visible buff/debuff markers and status descriptions. These marker abilities have zero native miss chance and no extra damage/stat payload: the existing scripted calculation remains authoritative.
- Gaya's Break Stun clears the taunt marker as well as the existing forced-order state. Taunt expiration/caster death also clears the marker.
- Lesser Flan's Entangle explicitly binds a private Entangled buff with the standard Entangling Roots target art. Existing 400 damage/second, three-second root, 200 mana and 12-second cooldown remain.
- Avatar's effect sound and looping effect sound fields are blank, removing the dwarf callout while retaining the transformation.

All newly referenced effect models were checked against the cached classic Warcraft asset catalogue. Markers do not introduce new cleansing rules for existing scripted poison/bleed calculations. Native dispel/visual timing and sound acceptance still require Warcraft testing.

## Validation

Fifteen focused checks verify exact pool membership/weights, unchanged arena modules and moved definitions, review grouping, aura swap, real block/reflection calculations, 150-unit AI gates, Barrens Alert mapping, cast-order completion/retry, Firebolt payload, summon-tier/arm acquisition, Aeroaga prerequisites, Avatar sound fields, unique icons, status/root bindings and taunt cleansing. Both maps pass playable/editor compilation, startup/source/global checks and typed content validation. QuickUI93 passes save compatibility for 358 items and 22 jobs.

Native visual/sound, live AI and multiplayer acceptance remain pending. No production release is replaced.

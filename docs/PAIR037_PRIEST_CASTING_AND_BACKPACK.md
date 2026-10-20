# PAIR037: casting protection, Priest layout, shields and Backpack close intent

Both profiles are generated from the same unchanged editor master. The maintained
final Priest adaptation is `tools/priest_followup.py`; Channel object adaptation
is `tools/channel_defaults.py`. No save-code identifiers or format are changed.

## Backpack close intent

An explicit close now latches a closed state until the player requests another
open through Backpack/B. A native panel becoming visible after combat, item
refresh or selection is hidden again instead of being adopted as a new open
request. The initial native binding path and confirmed same-hero binding reuse
remain. A regression opens the bag, closes it, advances twenty seconds, simulates
both native panes reappearing, and confirms both stay hidden until an explicit
reopen. The working PAIR036 armory implementation is retained.

## Priest talent layout and icons

| Row | Rank | First | Second | Third |
|---|---|---|---|---|
| 2 | Master | Acid Rain | Holy Bolts | Swiftmend |
| 3 | Ultimate | Shielding | Blessed Rain | Prolonged Cleansing |
| 4 | Legendary | Healing Bolts | Tranquility of Life | Refresh |

The actual effect gates, Refresh's 45-second cooldown override, spell tooltip
metadata and descriptions use the new slots. One choice per row and existing
rank requirements remain. Holy Bolts and Healing Bolts use the stock magic damage
icon; Shielding uses Cure's icon, and Prolonged Cleansing uses Esuna's icon.

Holy Bolts' description is exactly:

> All life spell power increases also increase basic-attack damage.

The Attack tooltip includes that description and the current percentage.
Life-power calculations, Staff/White Robe contributions and attack damage type
are unchanged from PAIR036.

## Visible Shielding amount

Defenses in both clients show a Shielding row while the remaining pool is positive.
Forsaken also shows a small gold `Shield: number` beside the first hero portrait's
health bar. It follows the local hero's actual shield pool, including additions,
damage absorption, expiration and death; zero hides the readout. It is independent
of whether the Backpack or Talents panel is open. The frame is created at shared
startup and rebuilt with other native frames; local presentation does not change
the synchronized shield state.

The existing rule remains: qualifying Cure/Regen/Tranquility overheal stacks and
expires thirty seconds after the latest addition.

## Acid Rain timing

Healing keeps the authored Tranquility pulse interval. Acid Rain damage now uses
explicit one-second pulses, each equal to half the authored healing per second:

`damage per pulse = PriestRainHealing[rank] * 0.5 / PriestRainPeriod[rank]`.

At the current master rank this is 200 HP every 0.1 seconds and 2,000 base magic
damage every one second. Each damage pulse is ten times the old 0.1-second pulse;
the intended per-second split remains 2,000 healing/2,000 damage before modifiers.
Damage has its own per-caster countdown, reset on each new channel. Healing and
damage use the same radius and existing ally/enemy filters. Ending/interruption,
death or losing the channel ends both. Tooltips describe the separate intervals.

## Shared Channel lockup protections

The user reported Bahamut/Neo Bahamut/Bahamut Zero, Death Screech, Tornado,
Dragon Breath, Fan of Knives, Rave Kick and Assault losing hero control, including
when the Backpack was closed and Escape/right-click did not release it.

PAIR019 comparison found the reported Channel settings unchanged in PAIR036;
most payload handlers are also unchanged. Both versions contain sparse higher-rank
Channel settings. Live calculation tooltip writes were added after PAIR019 and
may expose that inherited-data problem. This is an engine hypothesis, not a
reproduced Warcraft diagnosis.

Before packaging either profile, materialize each Channel field Ncl1–Ncl6 from
the most recent explicitly authored earlier rank. Preserve every explicit value,
including intentional channel durations, targeting/options and base orders. Do
not guess base defaults or substitute zero for genuine channels. Main and skin
tables use the effective authored values when filling later ranks. In particular,
the reported multi-rank instant spells now explicitly have zero follow-through
and disabled-other-abilities=false at their maximum rank.

Live calculation tooltips also defer writes from synchronized spell-channel start
until the matching spell-end event. This protects active casts from object-text
mutation. Matching is per unit and ability, so another spell's end event cannot
clear the active marker. Existing fingerprint caching and calculation toggle
remain. There is no broad forced unpause, cooldown reset or repeated Stop order.

## Warcraft acceptance

Use fresh PAIR037 games in both clients. At high rank, cast each reported spell,
select a summon and return to the hero, then move and cast another spell. Repeat
with the bag closed/open and with calculations on/off. Check intended channels
such as Pray and Tranquility still channel and can be interrupted normally.

Close the bag, kill/loot a monster and switch selections; it must remain closed.
Reopen deliberately with mouse/B and close with Backpack/X/Escape. Test the new
talent slots, icons and exact Holy Bolts text. Build Shielding through overheal,
take hits and confirm the displayed pool falls and vanishes on expiry/death.
Measure Acid Rain over a full second at several ranks, including master.

Actual engine and multiplayer acceptance is still required. The separate older
legacy large-profile Warcraft-menu checkpoint problem remains unresolved.

## Validation and delivery

Both complete build pipelines passed. Native has 258 regression checks with two
expected skips; classic has 358 with twelve expected skips. Playable/editor source
compilation, source/startup agreement, save compatibility and native save text
safety, armory/bazaar/content checks and classic conversion passed. The final
archive audit verifies the reported Channel ranks, cast-safe text hooks, talent
slots/icons, remaining-shield displays, persistent close flag and separate Acid
Rain countdown. All 119 calculation entries remain present. Both TEST copies
match the release hashes. A read-only check of the original dev.txt passes and
leaves its bytes unchanged; capture/codec/eligibility and autosave functions match
PAIR036.

Editor master SHA256 remains
ae4b422d24c8a5bc5f67250b7ff290b00873cdf1031f7be12071a4e1876e1276.
Forsaken SHA256:
d6c22d7744a62b3796e6e3eae38b275bcbe62ce635bbea48fb0c9dc39d48647a.
Classic SHA256:
19b5bfab96d316602239e32af9d35e3bd11b54229a0355b0e397e7e80b70f8bd.

# PAIR029 player commands and legendary progress

Follow-up: PAIR029 has a confirmed final-readback compatibility regression for
older seven-section saves. PAIR030 fixes it and extends Proof of Strength
persistence; see [PAIR030_SAVE_UI_FIXES.md](PAIR030_SAVE_UI_FIXES.md). The native
drag path below also needed the PAIR030 direct-slot placement follow-up.

All changes are build transforms from the saved editor master. The master is not
modified by this patch. Both profiles receive shared gameplay/save/command logic;
native inventory presentation remains Forsaken-only.

## Commands

- `-bazaarreveal`: reveals recipe reward names for the requester for the current
  game, including an already-open browser. All recipes remain browsable. It does
  not consume parts, prepare recipes, alter shop stock or bypass prices/requirements.
- `-legendary`: shows the current job's trial only at level 99 or higher. Completed
  requirements are green. Wizard/Calculator show each elemental milestone;
  Summoner shows Shiva/Ifrit/Cyclops; Freelancer lists Legendary job mastery.
  Lower-level heroes receive only the eligibility message.
- `-spellcalculations on` / `-spellcalculations off`: per-player, per-game display
  setting, initially on. Hides/shows the calculation section, preserving authored
  effects/targeting/duration and the selected talent description. Cached local
  tooltip writes run only when text changes; the cache keeps integer fingerprints,
  not full tooltip strings.

Healing descriptions keep the editor's prose, followed by a gold
"Healing calculations" section. Tranquility's original healing rate is corrected
for the current rank; Acid Rain is absent until selected and then appears in its
own talent section. Cure, Curaga/Cura, Pray, Regen, Blessing of Light, Osmose and
Drain have formulas; current-caster amounts appear where meaningful. Curaga is
(10 x rank mana cost + 5 x INT) x Staff power. Osmose is floor[((rank+4) x 40 +
2 x INT) x Staff power], capped by actual target MP drained. Drain is
floor[(2 x rank mana cost + INT) x Staff power] base damage per second; actual
damage dealt restores HP. Existing target recovery/defense and maximum HP/MP
limits still apply. No healing/damage balance changes in this patch.

## Saved trial progress

Optional section 11 schema 1 is a bounded counted list of unique `(identity,1)`
pairs. IDs 1..23 are completed job trials (job index + 1); 24..29 are Wizard
technical elements, 30..35 Calculator instant-death elements, 36..38 Summoner
normal-attack milestones. Element ID order is Fire, Ice, Thunder, Water, Wind,
Earth. Summons are Shiva, Ifrit, Cyclops. There are at most 38 entries.

Capture includes these flags in its two-pass stability check. Decode rejects
invalid IDs, counts, duplicate entries and non-boolean values. Fresh-load plans
accept older seven-section profiles and new eight-section profiles, restore the
flags per player, and recount Wizard/Calculator totals. Failed loads restore the
snapshot memberships and counters. Existing Legendary job tiers remain unchanged.
Both PAIR029 clients understand the same section; older builds' fresh-load gates
may reject newly written saves, so use the updated pair for new saves.

Durable steps and completed trials persist. Timed/combo attempts (for example,
60 Blind Spot hits within one Aim) restart; restarting must not turn separate
attempts into a completed single-attempt requirement. NPC introductions, shared
story stages and the current map's quests remain session state.

## Native inventory

Gear variants retain their native equipment-slot metadata but use ordinary
inventory classification so native drag can reach the quick-slot handler.
Explicit quick-slot moves still create the carried copy, suspend passive stats
and retain active abilities/cooldowns; native save/load restores carried copies.
The Holy Book of Galbados regression checks classification, offhand metadata and
unchanged abilities. Actual engine acceptance of both dragging and equipping
remains required.

A small X in the gear header closes both panes. Talents moves below it and
remembers its toggle across closing/reopening the backpack. Escape closes the
pair without erasing that preference. Armory withdrawals invalidate the owning
client's open native panel binding so its next presentation refresh shows the new
item. No selection or gameplay mutation occurs in this local refresh path.

## Engine checks

Test both maps with a below-99 and a level-99 hero; check partial Wizard,
Calculator and Summoner progress, then save/load across the two versions.
Verify an unsuccessful load leaves trial flags unchanged. Toggle calculations
on/off on two different players, including selected/reset Acid Rain and Curaga,
Osmose and Drain at low/master ranks. Reveal recipes for one player while another
retains hidden reward names; prepare/purchase normally. In Forsaken drag Holy Book
of Galbados and Tournesol into hero slots, cast actives, verify no stats, save/load,
then equip normally. Test X/Escape, both Talents toggle states across reopen/job
change, and armory withdrawal with inventory open.

Validation: native208/classic308 regressions passed (10 expected legacy skips),
plus compiler/editor/startup/content/save compatibility/armory/bazaar gates and
classic conversion. The final archive audit checked all 105 abilities at every
rank in both object layers, selected-only Acid Rain presentation, local command
paths, the durable trial extension and native/classic separation, all 276 carried
aliases and native load bindings, native classification and panel controls.
Master/tool/output hashes match; both TEST copies are installed and hash-verified.
Actual Warcraft acceptance of the engine checks above remains pending.

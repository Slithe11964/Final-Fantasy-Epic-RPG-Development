# Forsaken equipment experiment

BT is a labels-only patch of BS: Cat's Bell now reads `HP regen not in combat` / `1%`; Deathbringer reads `Kill Commons below 40` / `5%`. Playable/editor sources updated. Normal checks PASS: 87 focused tests, 96 regressions, 2,000 codec cases, installed-library compilation, source/map/content checks and all-276 gear audit. Output: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBT.w3x`. Next unused stage BU.

## Separate experiment - Forsaken BS

BS retries original-to-native gear conversion on a fresh external pickup after a full-backpack rejection. The internal conversion guard and failed-attempt suppression still prevent repeated replacement loops. Charges, user data, durability and ownership are preserved. Native acceptance: fill the bag, withdraw Armory gear, free a slot, pick up the dropped item and equip it; repeat without duplicate items or lost bonuses.

Stat values remain in the right column even for long labels. Add Dagger/Platinum Dagger Backstab 1.5x, Storm Lance Chance to Shock 10%, and Reflect Shield Movement speed penalty -20%. Use the requested Molotov, Cat's Bell, Blue Amulet, White Materia, Summoner's Horn and Deathbringer wording; Blue Amulet's two mana rewards have separate rows. These summaries use the target's active equipment when inspecting another player.

Ammo combat math is unchanged. Bow/gun proficiency scales the flat bonus by `(10 + proficiency) / 10`. Bow proficiency 4 produces Artemis +1120 and Icecloud +140; gun proficiency 6 produces Scatter +400, Onion +560 and Rock/Piercing +240. Arrow percentage multiplies incoming damage separately before the flat term is added; it does not multiply that flat term.

Validation: 87 focused tests, 96 repository regressions, 2,000 codec cases, all stage checks, installed 3.0.1.24342 compilation and the all-276 gear audit PASS. Complete source/runtime agreement: 0 new differences. Output: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBS.w3x`; scratch: `build/ForsakenBS-hz94mr9k/FFERPG`. Normal AS sources/releases and the classic fallback remain unchanged. Saving is disabled in this experiment. Next unused stage BT.

## Separate experiment - Forsaken BR

BR corrects BQ's doubled lance accuracy. Tooltip accuracy contributes only the residual missing from the original formula, and that residual now reaches actual combat as well as the panel. Source-aware equipment queries prevent stale item markers from bagged/unequipped gear, while preserving innate and shrine passives. Requested trinket hooks (drop rolls, mana on kill, gold-for-MP, enhanced buffs and summon scaling) read native equipment.

All 276 native gear variants keep a zero-stat fGmk marker while their real passive abilities are suspended in storage. Its AGI/INT/STR fields are explicitly zero with the installed metadata's data pointers 1/2/3. This addresses the reported passive-only claws, fists, helmets and shields losing native equip interaction; actual in-game equip acceptance remains to be confirmed. Real level/mastery restrictions, original/Gaya items, active book spells and cooldown groups are preserved. No automatic equipping.

Damage bonuses adds base gun Critical Chance/multiplier (including Canister multiplier), katana combo chance/minimum total hits, elemental weakness damage, Deathbringer execute chance (disabled in Eternity), bow-only technique bonuses, gun-only perfect accuracy and shot effects, Chimes and Setzer's Coin. Ammo element highlighting follows actual equipped bow/gun and the existing elemental priority. Flat ammunition damage includes current proficiency. Rock/Piercing Shot adds armor-piercing damage rather than subtracting armor. Gun proficiency/time buildup still applies on top of the displayed base critical chance. Molotov's text follows its original tooltip; its existing proc cadence is unchanged.

Other bonuses adds Cat's Bell, Blue Amulet (the item referred to as Blue Gorget), Turtleshell Choker, White Materia, Bag of Tricks (+20 percentage points to the normal drop roll) and Summoner's Horn. Existing outgoing-damage rows dynamically show Leather/Steel Gorget at <=30% HP and Magic Gloves at >=99% HP. Armguard's halved-damage row appears only at <=30% HP. Defenses has no blank accuracy row. The talent grid is smaller and raised, leaving 16 stat rows with the same text size, gold-border padding and HUD clearance.

Repeatable audit: `experiments/Forsaken/audit_gear.py`; full 276-entry report: `docs/FORSAKEN_GEAR_AUDIT.md`. Checks compare all original gear ability definitions/numeric fields and every native variant's abilities, slots, charges, cooldown groups and requirements. Lifecycle tests cycle all 276 items between stored/equipped states while retaining active abilities. These do not substitute for native in-game equip and damage testing.

Validation: all build/editor/playable/source gates, 85 focused Forsaken tests, 96 repository regressions, 2,000 codec cases, all-276 final gear/object audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. JASS CRLF and byte-identical AS classic fallback verified. Scratch: build/ForsakenBR-qbnzzpyu/FFERPG. Reforged output: `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBR.w3x`. Normal sources/AS and exact AS classic fallback remain unchanged; saving is disabled. Native acceptance: equip the reported claws/hats/shields after meeting their requirements; repeat equip/unequip and job changes; check lance accuracy, gun/katana/ammunition rows, low/full-HP effects, trinkets and panel spacing. Next unused stage BS.


## Separate experiment - Forsaken BQ

BQ is the current test checkpoint. It preserves BP's independent talent rows and bagged active book abilities, replaces the Depths/Wateraga proxy with a direct scripted Crushing Wave missile sweep using the original mana and rod-power formula, and applies one water hit per target with timer/effect cleanup. Accuracy rating is shown on Damage bonuses and is generated from item descriptions for every original, Forsaken equipment variant and offhand type ID; only active equipped slots contribute. The catalogue audit covers all 280 armory entries (276 equipment items plus four unchanged Materia).

Validation: all source/editor/playable/map gates, 80 focused Forsaken tests, 96 repository regressions, 2,000 codec cases, armory/Bazaar checks, startup preservation and installed 3.0.1.24342 compilation PASS. Reforged output is `release/Forsaken/FFERPG_0.9.7.3-r16-ForsakenBQ.w3x`; the classic output remains the unchanged AS fallback. Native acceptance is still needed for Depths/Wateraga wave and damage, Storm Lance Accuracy rating, and bagged static-stat exclusion. Saving remains disabled. Next unused stage BR.

## Separate experiment - Forsaken BP

BP removes the same-column prerequisite from talent purchases. Each mastery-unlocked row independently permits one of its three choices; job/player isolation, mastery gates and cosmetic-only behavior remain unchanged.
Native testing of BO reported that equipped-then-bagged Storms/Winds stopped casting and sharing cooldowns, and Depths/Wateraga lost their water wave. BP queues one zero-delay bag owner refresh after native unequip completes, suspending passives before removing/re-adding the same item handles. Keep sparse bag positions, charges and the six quick slots; never recreate real items, mutate active ability lists or automatically equip. Ignore a delayed refresh for a hero that is no longer the player's current job. Original and variant book active abilities and shared Acdh cooldown groups stay identical.
Experimental Abil/Cooldown overlays fall back to the actual spell event when a bagged item has no legacy unit ability rank, and apply cooldown scaling to the event ability handle. Water uses a local proxy reference, explicit zero proxy mana cost/cast point, and the existing invisible-model/Locust dummy without engine ShowUnitHide, so native proxy casting/projectiles are not gated by hidden-unit state. Keep original source damage formulas, book spell IDs, targets and rewards. These are fixes for the reported symptoms; native success is not established by mocked tests or compilation.
All changes stay in experiments/Forsaken and isolated scratch/release/Forsaken. Canonical AS, exact AS classic fallback, original item/gameplay object fields and world/import assets remain unchanged; saving disabled.

Validation: all stage source/editor/playable/map gates, 77 experimental tests, 96 regression tests, 2,000 codec cases, final object/skin/archive isolation audit and installed 3.0.1.24342 compilation PASS. Complete source/runtime agreement: 0 new differences. JASS CRLF and exact AS classic fallback verified. Scratch: build/ForsakenBP-205nu15d/FFERPG. Native acceptance required in a fresh BP game: equip Storms and Winds, unequip to bag, cast both and verify the original shared book cooldown; repeat through multiple cycles and job changes. Cast Depths and Wateraga at ground and units and confirm visible wave/damage; verify bagged passive stats remain off, equipped bonuses restore, sparse bag order/charges survive and Gaya carrying remains intact. Next unused stage BQ.

## Separate experiment - Forsaken BO

BO supersedes BN after native testing showed +605 INT and other bonuses from bagged books/Firefly despite Equipment classification. The class correction alone was insufficient. Add per-item passive ability suspension in the 30-slot bag, driven by bundled base ability codes and the actual map ability definitions. Snapshot/remove only passive abilities (attributes, damage, armor, regeneration, movement/attack speed, evasion, auras and scripted passive markers). Leave active abilities installed: Book of Storms Bolt, other book spells and item casts retain their actual ability handles, cooldowns, charges and spell triggers. Restore passives for equipped/quick-slot items, pickup/drop/Gaya transfer and equipped job transfers; re-suspend stored items on native equip/unequip/pickup and the existing inventory refresh. Conversion disposal clears snapshots. Hero gear still routes out of six slots; Gaya storage and native bag order remain unchanged. No automatic equipping.
Move mana regeneration and cooldown reduction from Defenses to Other bonuses. Show owned condition protections on Resistances (Blind, Disease, Sleep, Slow, Pain, Fog, Deprotect, Deshell; bosses' Stun/Freeze), with Dark Knight Ailment Defense shown as the verified 80% knockback reduction, not an invented stun percentage. Show only present protections; more than four gets a condition continuation through More stats, within the Resistances stage of the four-page cycle. Format split elemental values as physical% | magical% with explicit percent signs, preserving a single percentage for matching values. Widen the stats value space and panel to keep values inside the gold border. Place inspection Stats inside the border to the left of X. Shorten both custom panels to .415 high (bottom .170) and reflow talent icons, stats, summary and inspection slots above the normal HUD; retain font sizes and all 30 inspection bag positions.
All changes remain in experiments/Forsaken and isolated scratch/release/Forsaken. Canonical AS and exact AS classic fallback remain unchanged; saving disabled. Validation: all build/editor/source/map gates, 96 regression tests, 2,000 codec cases, 74 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Test coverage includes 100 stored/equipped cycles, actual book/Firefly passive classifications, untouched Bolt/Fire ability and cooldown state, conditional protections, stat-page moves and panel border geometry. JASS CRLF and exact AS classic fallback verified. Scratch: build/ForsakenBO-jnou7c1o/FFERPG. Native acceptance pending: fresh BO game, compare bag-only vs equipped book/Firefly stats, cast Bolt from the bag and check cooldown persistence, equip/unequip repeatedly, Gaya transfer, sparse job bag transfer, conditional protections and panel/HUD clearance. Next unused stage BP.

## BN equipped-only gear bonuses

BN gives every native Forsaken gear variant the actual Equipment item class used by installed Forsaken stock gear. The previous variants retained legacy Permanent/PowerUp/Artifact/etc classes. Native testing after BN confirmed the class correction alone does not suppress bagged bonuses; BO addresses passive abilities directly. Keep original items unchanged for Gaya/ground/shop use, and keep variant abilities/values/slots unchanged. Add Forsaken_GearClass and per-variant original category metadata, including 25 bundled inherited base-item classes, so original proficiency/Monk/Two-Handed/equipment/forge/Loki/ItemShared comparisons retain their existing semantics despite the native class change. Patch these queries only in experimental scratch modules.
Hero six-slot gear carrying is removed: convert legacy gear to native variants, route any six-slot gear into the 30-slot bag using guarded temporary spacers, and preserve the actual item handle and its data. If the bag is full, leave the item safely beside the hero with one message. Consumables remain in the six slots; no auto-equip. Gaya retains legacy six-slot pickup/give/drop behavior and no backpack. Active-gear queries exclude mapped gear in hero quick slots immediately.
Elemental combat, basic-attack element and UI queries use a shared source-aware lookup for 41 gear-provided elemental properties. Recompute from currently equipped items rather than trusting a possibly stale unit ability rank; exclude bagged/quick-slot gear, preserve genuine innate unit abilities and NPC/summon/copied abilities. Keep original additive rates, type-specific attack/spell boosts, Omni equipment contributions, enchant stacking and BM Gaya33% correction. Test Book of Flames through100 equip/unequip cycles, all elemental gear across six elements and physical/magical types, source clearing, native item classification/original category compatibility, safe full-bag routing and Gaya carrying.

Validation: all build/editor/source/map gates, 96 regression tests, 2,000 codec cases, 71 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Tests cover native Equipment classification and original category compatibility, Book of Flames through 100 equip/removal cycles, all elemental gear across six elements and physical/magical damage, safe six-slot routing/full-bag preservation and unchanged Gaya carrying. CRLF JASS and exact AS classic fallback verified. Scratch: build/ForsakenBN-f9f6lmy6/FFERPG. Native acceptance pending in a fresh BN game: compare INT with books equipped, bagged and held by Gaya, repeat Book of Flames removal, and check ordinary consumables and job bag order. Saving disabled. Next unused stage BO.

## BM passive feedback and Ninja warnings

BM excludes internal conversions and fGap bag-position spacers from legacy accessory restrictions. Shared Two-Handed eligibility explicitly rejects an occupied native offhand and is reused by the attack event, damage query and panel. Clear an existing swing buff when eligibility is lost; retain original I0GK attack-triggered speed and weapon-life damage formulas. Damage bonuses shows Two-Handed conditional damage/speed, Monk Brawler Active/Inactive and its scripted attack multiplier. Warcraft's normal damage tooltip does not include these scripted hit bonuses. Monk barehanded/fist eligibility and existing60/90 proficiency formulas are unchanged; shields/tomes cancel the bonus. Remove talent letter labels; selected + and mouse/mastery rules remain; Escape still closes.
Correct Gaya Strength's duplicate count in experimental combat and display: remove only its duplicate half33% from the Omni lookup when evaluating a specific element. Actual Omni equipment bonuses remain (Magus Rod variants A0MG, Force of Nature A0MI); Geomancer receives no Omni ability. Omni-element attacks retain one33% Gaya bonus; enchant stacking preserved. Canonical AS, exact AS classic fallback, world/imports/dialogue/rewards and original object gameplay fields unchanged; saving disabled.

Validation: all build/editor/source/map gates, 96 regression tests, 2,000 codec cases, 66 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Tests cover spacer restrictions, Monk native shield/fist attack multipliers, Two-Handed offhand cancellation/restoration and speed, matching combat/display33% with aura/enchant/real Omni bonus, and no talent letter bindings. CRLF JASS and exact AS classic fallback verified. Scratch: build/ForsakenBM-dr4l_j5b/FFERPG. Fresh-game native acceptance pending. Next unused stage BN.

BO is the current experiment. BF generated duplicate items in native testing; use BO for a fresh test. BD stats/layout were accepted in game. BC was accepted visually in game; BD adds four readable stats pages and wider padding. Click **More stats >** to cycle Combat, Resistances, Element bonuses, and Other bonuses. Each page refreshes from active gear/passives/buffs; bagged gear is excluded. Haste changes cooldown reduction, including Agility and gear stacking. Strength/Agility/Intelligence/max HP/max MP are removed from the displayed list.

BC UI and sparse bag transfer accepted in game. BD removes STR/AGI/INT/maxHP/maxMP from the displayed stats. Wider .21 x .49 panel, .028 side insets, centered3x4 talent grid/title, inset close button;12 reusable rows and More stats cycles four local pages, retaining talent state.
Combat: health/mana regeneration, Magic Defense raw/%, live armor and armor defense%, evasion/accuracy ratings, physical/magical block%, cooldown reduction%. Resistances: six elemental states, non-elemental, random absorption proc separately. Elements: six attack/spell bonus pairs including omni contribution. Other bonuses: physical/magic buffs, HP/MP healing buffs, healing received, Staff/healing/Rod/Inner Mana power, flat damage guard and movement speed.
Copied read-only accuracy/evasion/element/proficiency queries are generated from canonical sources with an active ability lookup: current unit level first, else quick6/equipped9 item abilities; bag excluded. Random absorption roll deliberately removed from resistance query; separate15% row, no UI RNG/combat probes/stat mutations. Imperil displays one lower resistance tier. Block combines independent rolls as1-product(miss); includes Interceptor, Runic, Defend and Sword fallback; attacker bypass cannot be folded into a universal chance. Evasion/accuracy remain ratings, not standalone hit probabilities.
Cooldown reduction mirrors Cooldown.j's AGI denominator, multiplicative gear .7/.8, Hastera .67 > Haste/Auto-Haste .75 > Slowra1.5 > Slow1.3. Refresh every second and on gear events; gear/passive/buff/HP/MP changes reflected. Skill exceptions/Pharmacology's specific base cooldown remain conditional. Armor uses map DefenseArmor0.02 and native live armor; negative armor exponential vulnerability. Per-player regen cache prevents local page clicks borrowing another player's last regen. HP/MP regeneration limits from BC remain.
Bonuses show separate applicable layers, not one promised final damage/heal multiplier. Staff power includes proficiency/current mana/Mind Charge/Concentration; physical/magic buffs include bravery/faith/pain/fog, HP-dependent Focus/Adrenaline/Serenity/Spellbreaker, Night Might/Inner Fire/Oversoul where applicable. General HP/MP healing buffs and incoming Rejuvenation/Death Screech are separate. Target/position/skill/proc-specific effects are not represented as unconditional percentages. Existing item-ID/proc/save migration remains future work; no gameplay/equipment/talent/save mechanics changed.
All build/editor/source/map gates,96 regressions,2,000 codec cases,26 experiment tests, archive audit and additional installed3.0.1.24342 check_map PASS;0 new source/runtime differences. Original ability/item fields/world/NPC/imports intact; classic fallback exact AS, canonical AS untouched, Gaya unchanged, saving disabled. Experimental JASS CRLF. Unpublished attempts were stopped on declaration order and incorrect native equipment-slot signature/type; corrected without relaxing checks. Native page controls/readability/live buff acceptance pending. Next BE.

## BL live basic-attack element indication

BL includes all BK changes and the subsequently requested live basic-attack element highlight. Damage bonuses is page1; its matching Fire/Ice/Thunder/Water/Earth/Wind label turns green using Element_GetOfUnit(hero,true), the same function combat calls. Existing enchantment priority is preserved: an active enchantment overrides the weapon element, and expiration restores the weapon indication. Non-elemental attacks clear the highlight; Omni uses a separate green Basic attack element: Omni indicator rather than incorrectly coloring six unrelated bonus rows. Refresh follows the existing one-second panel clock and inspected target.
Add Forsaken_ActiveAbilityLevel to the TUnit scratch overlay: read native unit/buff rank first, then abilities of six quick-slot and nine equipped items; never include thirty-slot bag storage. Use it only in selected original Prof weapon/armor/proficiency queries, Element_GetOfUnit and Damage elemental bonus/resistance queries. This makes native equipment elemental properties and proficiency dummies participate in combat as well as display, including Geomancer elemental bonuses. Preserve original precedence, rates/formulas, buffs, rolls and other combat functions; no probes or UI gameplay mutations. Existing Monk empty-hand/Striker checks, Holy Swordsman Two-Handed checks and Ninja offhand manual equipping from BK remain.
Validation: all build/editor/source/map gates, 96 regressions, 2,000 codec cases, 61 experimental tests, final archive/object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Tests cover native weapon elements, enchantment priority/expiration, non-elemental reset, Omni and green-row refresh, as well as preceding inventory/UI/passive cases. World/imports and original gameplay object fields preserved except requested tooltips; CRLF JASS and exact AS classic fallback verified. Scratch: build/ForsakenBL-vvf5pf1l/FFERPG. Source changes stay exclusively in the experimental overlay/scratch. Canonical AS, world/imports, rewards/dialogue and exact AS 1.29.2 fallback remain unchanged. Saving disabled. Native acceptance pending: fresh BL game; extended-only Armory slot hints and Firefly Ring; Talents closed on B/bag open then clickable near corner; new stat page order/attack speed; equip primary then manually equip highlighted Ninja offhand weapon, unequip without automatic refilling, job switches with bag positions and metadata; Monk hands empty vs weapon/tome; Holy Swordsman one weapon/no offhand vs occupied offhand; Geomancer elemental weapon/Enfire and expiration; green row follows actual basic-attack element. Next unused stage BM.

## BK manual talents, equipment passives and damage page (superseded by BL)

BK responds to BJ in-game feedback. Armory slot text now appears only in extended descriptions below the requirement; restore the untouched basic unit title, including Reforged skin title overrides. Firefly is a Forsaken Ring. Talents opens only with its custom button; remove native Backpack B/command-button/chat activation and automatic open-on-bag visibility. Move its button nearer the upper-right corner (-.010,-.010), clear V row markers while preserving prerequisite rules, and keep independent close/toggle. Stats pages: Damage bonuses (1, includes live attack speed), Defenses (2), Resistances (3), Other bonuses (4). Attack speed reuses the canonical read-only -atkspd calculation and active gear queries, plus Haste/Hastera/Slow effects; no gameplay state mutation.
Add a shared active-gear view of six quick slots plus nine equipment slots, excluding the bag. Patch only relevant Unit/Prof/Damage/TwoHanded functions in scratch: Monk empty-hand/Striker checks, Two-Handed detection and proficiency-derived damage now see equipped native gear and preserve existing formulas. Proficiency and Versatility gear contributions include native equipment. Ninja Dual Wield (A0HP, including borrowed passive) receives equivalent offhand weapon variants; with a primary equipped, bag weapons become offhand-compatible for manual equipping. Removing the primary restores primary-compatible bag weapons. No auto-equip. Non-dual jobs reject/unequip offhand weapons. Full transaction uses actual handles, preserves charges/user data/proficiency life/owner and bag index, fills earlier empty positions with removable spacers, verifies replacement position and rolls back rejected additions. Conversion is guarded against recursion; six-slot Gaya carry and shared sparse job bag remain intact.
All changes remain in experiments/Forsaken and scratch/release/Forsaken. Validation: all build/editor/map/source gates, 96 regressions, 2,000 codec cases, 59 experiment tests, final object/skin isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. Skin change boundary is 552 unit extended tooltip fields plus 276 item extended tooltip fields; basic titles unchanged. Native offhand variants match primary variants except equipment type. World/imports/canonical AS unchanged, JASS CRLF, classic fallback exact AS. First unpublished run stopped on a forward function declaration and was corrected without relaxing checks. Scratch: build/ForsakenBK-6qbf8dge/FFERPG. Native acceptance remains pending for the UI position, native bag conversions/equip/unequip, job swaps and passives. Saving disabled. Next BL incorporates the subsequently requested active basic-attack element highlight.

## BJ Reforged skin tooltip overrides and Gaya inspection (superseded by BK)

BJ fixes the Armory tooltip override and Gaya inspection reported after BI. BI already contained slot labels in war3map.w3u/w3t, but the Reforged war3mapSkin.w3u/w3t files retained TRIGSTR references to older tooltips. Mirror the prepared gear unit basic/extended tooltips and item extended descriptions into the existing skin tooltip modifications, across every modification set. Other skin fields, names, icons, gameplay values, hints, catalog order and rewards remain unchanged. Germinas Boots now has Forsaken slot: Boots below Required level: 14 in both object layers. No shared WTS changes.
Explicitly reject Spirit of Gaya rawcode H01D before the hero/boss inspection predicate, so selection cannot show Inspect and clicks cannot open it even if Gaya qualifies as a hero or belongs to the boss group. Existing hero/boss inspection and Gaya six-slot carrying are preserved. Changes remain exclusively in the Forsaken experiment; canonical AS and its exact classic fallback remain unchanged. Saving remains disabled.
Validation: all build/editor/source/map checks, 96 regression tests, 2,000 codec cases, 53 experimental tests, final archive/object isolation audit and installed 3.0.1.24342 compilation PASS; 0 new source/runtime differences. The final skin audit verifies exactly 1,104 unit tooltip fields and 276 item extended tooltip fields changed, with every other skin field identical. CRLF JASS and byte-identical AS classic fallback verified. Scratch: build/ForsakenBJ-sku2xngk/FFERPG. Native acceptance pending: start a fresh BJ game, hover stored Germinas Boots and a missing Armory entry, verify the slot line, select Gaya and verify no Inspect, and verify another hero/boss still supports Inspect. Next unused stage BK.

## BI stat pages, Armory hover titles and six-slot carry (superseded by BJ)

BI responds to user feedback that BH mostly works. Stat page1 retains mana regeneration/combat stats and now includes Flat damage guard; page3 labels each element simply Ice damage/Earth damage/etc, removes the Split values legend and adds Physical damage/Magical damage; page4 now contains Health regen with healing/movement rows. Preserve actual combat calculations, current penalty colors and same-row elemental physical/magical values where they differ.
Armory BH archive inspection confirmed Forsaken slot labels were already in extended unit descriptions, including Germinas Boots/Jackboots and missing entries. BI also appends the explicit label to the basic utip hover title for all276 gear entries plus their276 missing placeholders, retaining the extended line. This addresses visibility in the stock hover header; it is not claimed that BH lacked object data. Only Armory utip/utub are changed on those original units; all other unit fields/hints/prices/order, item data boundaries, four Materia and world/import payloads remain intact.
Add isolated Forsaken-carry.j and reverse native-variant-to-original raw mapping. Explicit native gear drags to hero quick slots use the original six-slot-compatible form, preserve charges/user data/item life (proficiency)/owner, reuse UnitDropItemSlot with the actual created handle and verify the requested slot. Failed addition/placement deletes only the replacement and restores the original (including previously equipped state); no UnitAddItemToSlotById. Mark explicit legacy carry handles in hash parent51 so the existing periodic native preparation honors occupied six-slot storage, while unmarked starting gear retains prior native preparation. Legacy gear picked up by Gaya receives the same marker; it survives transfer/job changes on the same handle. Putting that gear into the30-slot bag allows native preparation again. Mapped legacy items bypass the old one-item-per-type pickup restriction to allow carrying; native equip still runs the existing level/job restrictions. Legacy gear in quick slots retains its canonical active item effects; this experiment does not claim six-slot storage is inert.
Gaya retains its original six slots and receives no backpack, gear abilities or panels. Native gear ground pickup orders for hero/Gaya convert to the compatible carry form and retarget pickup, without changing attack orders. Track same-owner give-item recipients through the existing Equipment trigger's order events; deferred dropped-item handling converts unowned native gear or gear held by the intended recipient. Already-owned gear without that recipient is left untouched so scripted job transfers are not rewritten. Busy guard prevents recursion; rejected/full recipient retains the one item on the ground, not deleted/duplicated. Existing sparse bag transfer/manual native equipping remain. No new trigger or canonical module edits; all changes stay in experiments/Forsaken/scratch/release/Forsaken.
Validation: all build/editor/map/source gates,96 regressions,2,000 codec cases,51 experimental tests, archive/object isolation audit and installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover explicit carry persistence, native-to-legacy metadata and rejection, quick-slot/give/pickup order handling, Gaya marking, owned job-transfer exclusion, requested stat pages and552 Armory basic/extended tooltip-only boundaries. Exact AS classic fallback and CRLF JASS verified. First BI run was stopped before publication to retain native starting-gear preparation alongside explicit carry choices. Final scratch: build/ForsakenBI-557ox66h/FFERPG. Saving remains disabled; normal development AS; next BJ. Native acceptance pending: fresh BI game, all four stat pages, Armory Boots hover title/description, native equipped/bag gear dragged into an occupied/free hero quick slot, give to Gaya and back, Gaya ground pickup, full inventories, charges/proficiency/ownership, job changes and no item copies/losses.

## BH regeneration, stat presentation and controls (superseded by BI)

BH addresses BG native-test feedback only in experiments/Forsaken and release/Forsaken. Remove the Board button/manual preference; keep full scoreboard/title hiding during backpack or inspection and restoration after closing. Custom Inspect/Talents/X/More-stats callbacks now have a direct frame-only action on the existing TalentClick trigger, separate from unit/key access events. Elevate Inspect and Talents to frame level60; Inspect sits .024 above the top-right command button with a stock Far Sight icon. Find visible native frame contexts first. Anchor Talents inside the character panel's upper-right gold border and only reset its points when the anchor changes, rather than every0.1sec. Independent talent close/reopen and native backpack remain.
Inspect is restricted to visible, non-hidden other heroes and members of the existing BossGroup; structures, houses, ordinary NPCs and shops excluded. Read-only boss/hero inspection does not grant abilities or mutate gear. Armory stock and missing-item hint unit tooltips now also receive the same Forsaken slot label as the276 gear items (552 unit tooltips); all other unit/item fields, original hints/order/costs/requirements, four Materia and canonical source/maps remain unchanged.
Regeneration now has generated raw-ID metadata from the actual prepared map, including original/native equipment variants, authored ability values for every rank and audited inherited stock defaults in regen-defaults.json. Scan only active quick6/equipped9; direct GetUnitAbilityLevel reads current job/passive ranks even when native ability-handle enumeration omits them. Item raw-ID links include45HP/sec helmet A0OE, Sorcerer A033 rank11=60 and rank22=120MP/sec, and inherited A062=50% normal mana regeneration. Deduplicate item effects also exposed on the hero and strongest same-buff auras; bag items excluded. Existing map attribute coefficients and synchronized per-hero caches retained. This is passive regeneration, not net HP/MP change from damage, costs or instant healing; external aura sources and dynamic native field overrides are not reconstructed by the authored metadata.
Consolidate each element into one damage-increased row; equal physical/magical values show one percentage, differing values show Physical/Magical in that same row with a legend (these are different combat calculations, not additive bonuses). Remove Staff/Rod/Inner Mana rows; rename Physical/Magical damage. Existing stat values turn red for Blind/Total Blind/Oil accuracy, Deprotect/Deshell effective defense, Imperil resistance tiers, Pain/Painra and Fog/Fogra damage, Slow cooldown/movement, healing-received penalty and evasion penalty. Blind halves the target-independent displayed accuracy rating; actual hit chance still depends on target evasion and combat's hit-margin thresholds. No extra debuff rows. Deprotect/Deshell and their auto forms multiply remaining damage by1.5, not raw armor/MagicDefense; effective defense percentages compose this multiplier, retain Protect/Shell/stronger versions' precedence and defense inversion. Raw ratings remain the actual raw ratings. Combat behavior is unchanged.
Validation: all build/editor/map/source gates,96 regressions,2,000 codec cases,44 experimental tests, archive/object isolation audit and installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover missing native regen handles,45HP helmet,60/120MP Sorcerer, inherited mana ring, bag exclusion/item deduplication, existing toggles/read-only inspection,552 Armory tooltip-only changes and penalty/defense precedence. Exact AS classic fallback, CRLF JASS, world/NPC/imports preserved. Scratch: build/ForsakenBH-jfs5ejom/FFERPG. Saving remains disabled; normal development stays AS; next BI. Native acceptance pending: new BH game, Inspect only heroes/bosses, higher Inspect, upper-right working Talents toggle, automatic board hiding/restoration without Board button, Armory slot hints, live gear/passive regen, same-row red penalties and consolidated elemental rows.

## BG item conversion, slot descriptions and controls (superseded by BH)

BF failed native testing: its UnitAddItemToSlotById path generated copies at the hero's feet when equipment was redirected into native storage rather than the requested quick slot. BG removes that native call from conversion. Create/track the actual replacement handle, preserve charges/userdata/item life/proficiency/owner, vacate the original and use UnitAddItem. Verify actual possession in quick6 OR native bag rather than trusting the return value or a requested slot. Accepted replacements delete the original; rejected replacements are always deleted and the original restored (or retained on ground). Mark each attempted original to avoid failed conversion retries; synchronous busy guard prevents pickup recursion. Native equipment variants already have iequ metadata for normal matching-slot highlights/manual equipping. No automatic UnitEquipItem. Existing bag variants/actually equipped items untouched. Preparation handles quick6 and original gear in native bag, runs on current-player-hero pickups plus the periodic scan for starting gear; Gaya/NPC inventories are not converted.
Only the experimental object overlay adds Forsaken slot: Helm/Chest/Gloves/Boots/Ring/Weapon/Offhand/Trinket immediately after the Required level line (append if no such line exists). All276 original mapped gear tooltips and their copied native variants receive the label. Original iequ/abilities/requirements/rewards/prices and all other original fields remain intact; four Materia unchanged. Canonical sources/maps and exact AS classic fallback retain original descriptions and inventory behavior.
Inspect moves from the middle of the world view to immediately above native command-card slot3 (top-right), with tooltip anchored to the button. Use the user's offered alternative instead of inserting a real ability into NPC/boss command cards. A local Talents toggle sits beside the native character backpack (or inspected inventory); Stats label on NPCs, toggles only the FF side panel, preserves native gear/bag and independent X. BE automatic opening on each native Backpack opening remains, toggle can reopen after X. No gameplay abilities granted to NPCs for inspection.
Experimental Multiboard overlay owns local ForsakenBoardHidden/ForsakenBoardCovered state; TEquip adds TMultiboard dependency. Entire scoreboard, including minimized title, hides during native backpack or inspection display. Existing two-second refresh respects those flags so it cannot immediately force the title back. Restore after closing unless manually hidden. Board button at top-right is available outside those windows to toggle full hiding. UI preferences/events remain per-client; board contents/gameplay are unchanged. Existing NPC read-only stats/talents/inventory behavior and sparse job transfer retained.
All build/editor/map/source gates,96 regressions,2,000 codec cases,38 experimental tests, archive audit and additional installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Regression covers100 consecutive scans accepting quick/bag or rejecting conversion with only one replacement created, rejection cleanup/original retention, state/proficiency/owner preservation, recursion guard, all276 tooltip/object-field boundaries, new toggle/open/close/persistent board preferences and existing inspection/bag/talent paths. Archive audit allows only requested gear tooltip changes on originals and verifies world/NPC/imports unchanged and classic exact AS; JASS CRLF. An unfinished BG attempt was stopped to include subsequent user UI requests. Native acceptance pending: fresh BG game with no copy pile; pickup/drag matching-slot highlight; manual equip/unequip; slot tooltips; job/bag positions; Inspect above top-right card cell; Talents/Stats toggle beside backpack; full title hiding/restoration/manual Board toggle. BF must not be used for further play. Saving remains disabled; normal development AS, next BH.

## BF manual gear and solo inspection (failed native testing; superseded)

BF removes Equip gear and its FFERPGEQUIP sync hook. Once each second, prepare only mapped original gear in the current player's six quick slots: replace it with its native equipment variant in the same slot without UnitEquipItem. Preserve charges, user data, item life/proficiency and item owner. Delete the original only after verifying the variant occupies the intended slot; failed placement restores the original or leaves it safely on the ground. Existing native variants, bag contents and equipped items are untouched. Native manual equipping needs no command/button; unequipping stays unequipped. Legacy -forsaken-equip remains an optional diagnostic only. Shared sparse bag/job transfer unchanged.
Inspect now accepts any visible, non-hidden, non-deleted selected unit except the viewer's own current hero, including NPCs and bosses for solo tests. Changing selection/loss of visibility closes inspection. Native nine equipment slots and30 bag slots remain read only. Units without a backpack show their six ordinary inventory items in the first bag row and label the remainder No backpack; no abilities/bag/items are granted. Use GetUnitLevel for NPC level.
NPC inspection refreshes the four stats pages and HP/MP/level summary every0.1sec using read-only queries. Hide FF talent buttons/links and state No FF job talents instead of borrowing owner/job data; restore controls on player-hero rendering. NPC base HP/MP regeneration reads native base fields and is explicitly labeled; no player regeneration cache or udg_MagicDefense is used. NPC magical damage uses native armor in canonical Damage.j, so show Native armor basis/reduction and explain attack/damage types/scripted effects can alter the result. NPC cooldown omits the player hero AGI denominator, retaining live Haste/Slow/gear modifiers. Existing resistance/block/element/healing rows expose applicable layers, not a guaranteed final damage result. Own/other current-player-hero stats and talents retain BE behavior. NPC UI reads no RNG, probes, gameplay mutation or shared regeneration scratch.
All build/editor/map/source gates,96 regressions,2,000 codec cases,35 experiment tests, archive audit and extra installed3.0.1.24342 compilation PASS;0 new source/runtime differences. Tests cover no equip UI/sync/auto-equip, exact quick slot conversion with state/proficiency/owner preservation, rejected conversion retaining original, NPC visibility/deleted guards, NPC six-slot hover inventory, own/player versus NPC stat isolation and cooldown, local refresh, read-only callbacks and existing bag/talent/access behavior. Original objects/world/NPC/imports intact; canonical AS unchanged, classic fallback exact AS, Gaya unchanged, saving blocked; experimental JASS CRLF. An unfinished first build was stopped and restarted to include item-life/proficiency preservation. Native acceptance pending: manually equip converted quick-slot gear, unequip stays empty, job/bag order/charges, solo NPC/boss inspect/icon/inventory/live stats and player inspection. Next BG.

Test BF: start a fresh game, allow the one-second preparation, open Backpack and manually move gear from a quick slot to the matching native equipment slot. Take it off and confirm it stays off. Change jobs and verify bag layout/charges remain. Select a town NPC or visible boss, click the portrait Inspect icon above the ordinary inventory, hover its inventory items and use More stats. NPC talents should be absent; the summary and native armor basis must belong to that unit. Verify closing just the talent/stats window retains the inspected inventory; X/Esc/selection/fog close inspection. These changes still need in-game acceptance.

## BE equipment, access and inspection (historical)

BD accepted in game. BE removes the recurring automatic conversion/equip call from the one-second inventory preparation; empty equipment slots stay empty. Existing -forsaken-equip remains explicit. Add Equip gear button shown beside the standard inventory while the owner's native Backpack is visible; sends FFERPGEQUIP sync to the existing TestEquip trigger, resolves only sender's own current hero. Converts original carried gear into native variants and equips accepted empty slots; existing native variants can be equipped by the normal gear UI. No unsolicited pickup/init equip. Shared job transfer still restores only actually equipped items; bag order/handles/charges unchanged.
Own talents/stats automatically open on each native SimpleEquipmentPanel visibility rising edge, polled every0.1sec. B/command-card access also opens them; no longer guesses native state by toggling the custom window. Independent custom X hides only talents/stats and latches the current native opening, so polling does not instantly reopen it. Closing and reopening Backpack restores talents. Esc/selection close displays. Native visibility/control behavior needs in-game acceptance; native gear/bag remain authoritative.
Selecting another player's visible current hero displays a portrait Inspect icon above standard inventory. Click opens a separate read-only equipment/backpack window alongside the existing twelve talents/four stats pages. Nine named equipment positions + thirty bag positions with actual icons and hovered item names/descriptions/charges. Name/job/level identify target. Inspect panel's X/Esc closes inspection; talent X leaves gear/bag view open. Native body model is not cloned; this is a separate read-only view. No other player's abilities/control/inventory modified.
Local selection/inspection state controls UI only. Current-hero and visibility predicates exclude self/NPC/Gaya/inactive jobs/fog targets. Changing selection or losing target validity closes inspection. Target owner/job key drives talent state, borrowed skills, mastery and stat cache, refreshed each second. New inspection hides old talent/stats until target refresh, preventing stale self-details. Inspection disables talent buttons and click sender guard blocks purchases; sync still validates sender's own current hero. Manual equip UI refuses inspection requests. Talent focus reset is local/owned only. Item hover slots have no action events. Creates frames uniformly at startup, no local gameplay handles/objects/RNG/probes.
All build/editor/source/map gates,96 regressions,2,000 codec cases,33 experiment tests, archive audit and extra installed3.0.1.24342 check_map PASS;0 new source/runtime differences. Original objects/world/NPC/imports intact; canonical AS unchanged, classic fallback exact AS, Gaya unchanged, saving blocked. JASS CRLF. First unpublished build stopped on local button colliding with native button type; renamed slotButton without relaxing checks. Native acceptance pending: unequip stays empty; native drag/manual Equip gear; talent close/reopen via B/mouse; second-player icon/gear/bag hover/stats/choices/read-only/selection/fog/job changes. Next BF.

## Earlier test iterations

This is the separate Forsaken test line requested by the user. BB's sparse bag preservation was confirmed in game, but its stat overlays did not render and native talents showed2x4 placeholder icons. BC replaces those displays with an independently created FF talent/stat panel beside the native gear and bag. Gaya retains its original inventory. Normal development stays on Stage AS. All test releases go in `release/Forsaken/`; the regular sources and release pair remain intact.

The Reforged test uses native Warcraft III 3.0 expanded inventory/equipment. Local data from build 3.0.0.24268 identifies `AInx` (expanded inventory), `AEqu` (equipment inventory), `AIni` (item inventory) and the item equipment field `iequ`. The native equipment UI has Head, Chest, Gloves, Boots, two Ring slots, Primary, Offhand and Trinket. The hero receives fBag/fGer and the visible ASpc Backpack command (B). No physical Backpack item is created. Gaya keeps its canonical six-slot inventory with no native bag or new panels. Setup runs on the current player hero.

AZ preserves all original item definitions, so NPCs and preplaced heroes keep their existing gear. It adds 276 equipment variants for Armory gear; the four final Materia remain usable items. Each second, mapped original gear in visible inventory or bag fills an empty matching equipment slot, including either ring slot. Occupied slots are never automatically replaced. The original is removed only after the replacement is accepted, equipped and remains equipped after restrictions. Failure retains the original; replacement charges/ownership are copied. Weapons use Primary; shields, ammunition and books use Offhand; helmets use Head; armor uses Chest. Accessory names identify shoes/boots, gloves/bracers/armguards and rings; other accessories use Trinket. The build writes the full original/variant/slot list beside the map. Existing item IDs/classes/bonuses/prices/hints/Armory flags stay unchanged. Existing level and Legendary Master restrictions run when equipping. Original items retain the canonical legacy pickup restrictions.

The isolated Job overlay transfers the same equipped and bagged item handles after clearing the destination's six slots, before restoring the saved six-slot items and recalculating stats. During native transfer only, remove the destination's empty stock AInv inventory so ordinary item addition uses the bag; restore AInv at its original level before restoring quick-slot items. The source's quick inventory is never disabled. All nine equipment slots are carried across first; snapshot the 30 bag slots before moving their contents in order, tolerating source compaction. Charges are preserved using the canonical transfer convention. A failed addition leaves the item beside the new hero with a message; it is never deleted. The temporary item array is cleared synchronously, and only this player's previous/current heroes are used. Returning to a cached job transfers the same inventory back. The object table declares stock AInv with no modified fields so strict reference checks can validate its new calls.

BB preserves empty backpack positions by inserting temporary, ability-free bag spacers while transferring the source snapshot in slot order, then removing only those spacers. No undocumented extended-slot index is assumed. The same actual item handles and charges survive; failed additions retain the earlier ground fallback. Test sparse positions 2,8,19,30 and a full bag across jobs and back.

BC does not attach ASde/ATal to heroes: their native default displays are not authoritative for FF's older abilities. It creates its own normal frames at startup without requiring native stat-row handles or mixing simple/normal frame anchors. The nine labeled values are Strength, Agility, Intelligence, maximum HP/MP, health/mana regeneration, Magic Defense and Magic Defense %. Native gear/bag remain intact. A visible native EquipmentPanelBackdrop, when found across contexts, provides alignment; otherwise a fixed screen anchor displays the panel. B and command-card slot4 toggle it; Esc/X close it, and selecting another unit hides it. `-forsaken-panels` provides independent access if native mouse-click forwarding is unavailable. A local clock debounces duplicate key/button notifications. Presentation state remains local; talent purchases use synchronized validation. Dormant legacy panel object definitions remain unassigned; obsolete FDF/toc imports are removed.

Regeneration reads live ability levels/fields rather than the native modifier panel's incomplete totals. Base unit regeneration and attribute contributions use map IntRegenBonus0.04/default StrRegenBonus0.05; Arel adds flat health, AIrm/AIrn add mana percentage, AHab/AUau read aura amount and flat/percent flags. Item abilities are counted from the active six slots/all9 equipped positions, not the bag or a second copy in the hero ability list. Same-buff own auras contribute once, using the strongest value. Sorcerer's A033/Hab1 gives60 at level11 and120 at level22 during Burst; add that to intrinsic/gear regeneration. This models continuous intrinsic/own-ability/equipment regeneration, not instant potions, scripted heal-over-time ticks or nearby other units' auras. Refresh runs each second, after the game's passive sync updates live levels. Those additional sources need separate integration before claiming a complete combat-stat panel.

Magic Defense retains BB's isolated possession helper: original legacy items plus equipped native variants, excluding bag gear, preserve canonical calculation/shield priority. Refresh restores shared calculation context. Damage.j scales eligible magical damage by `50 / (defense + 50)`, so reduction is `100 * defense / (defense + 50)`. Total100 means66.67% reduction; Absorber adds100 plus Intelligence/upgrades/other gear. This is display-only: no second native resistance bonus is introduced.

Talents have exactly four rows/three columns. Paths are A→D→H→K, B→F→I→L, C→G→J→M. Row1 is available immediately, row2 at Master, row3 at Ultimate Master, row4 at Legendary Master: canonical A02F ranks1-4. One choice per row; an immediately preceding parent is required. A fresh job therefore starts with one available choice, gaining another at each mastery tier. Synchronized validation rejects duplicates, another choice in the same row, wrong-job packets, missing parents and locked tiers. Progress is isolated by player/job and survives job switches in this match. Icons use each job's first3 abilities (Freelancer's borrowed abilities); green marks purchased, yellow available, dim locked. No actual skills, stats, elements or save fields are granted; real talent design is future work. Rendering and Backpack mouse/key forwarding need native acceptance.

The existing 1.29.2 map is copied byte-for-byte as the classic fallback. It has the current six-slot inventory, current Armory, and normal saving. It does not use the new abilities or equipment fields. Do not pass the experimental Reforged map through the normal downgrade shortcut: that converter has not been extended to undo this experiment.

## Testing

Start a fresh game in BC and open Backpack with B. Confirm native gear/bag plus the FF3x4 talents/nine labeled stats, including Magic Defense/%; Esc/X should close the FF panel. Also test mouse-click Backpack; if native forwarding is unavailable, use B or `-forsaken-panels`. On Sorcerer with rank11 regeneration, note intrinsic+gear+60 mana regen; activate Burst, allow passive sync/one-second refresh, verify it changes to intrinsic+gear+120. Move regen gear between active slots and bag; bagged gear contributes nothing. Test mastery ranks1/2/3/4: only corresponding rows unlocked, one choice per row, G requires C, progress isolated across jobs/players. Choices still grant no real bonuses. Retest sparse/full bag slots, charges and both rings across jobs/back, Gaya's original inventory, another player and NPC gear. `-forsaken` remains diagnostic; `-forsaken-equip` rescans gear. Armory/item-ID/save migration remains pending.

AY removes the ASpc hidden-button override, authors the Backpack name/icon/hotkey/tooltips, and supplies the physical Backpack with `UnitAddItemToSlotById` into a free visible slot. It carries only ASpc; storage and equipment abilities remain directly attached to the hero. The periodic setup never calls gear conversion. The native bag is storage, so merely putting equipment in it is insufficient to activate stats; the explicit conversion tests native equipping as well.

AV uses custom fBgi/fGer item abilities, based on AIni/AEqu, with level1 bag capacity and equipment level threshold explicitly authored in Data F: inv6=30 and equ1=0. Installed AbilityMetaData identifies both fields with data pointer6. The Backpack also carries stock ASpc, the native interface controller. Gaya gets custom fBag with inv6=30. The stock SLK capacity in Data A differs from the current metadata's Data F field; this is a candidate explanation for AU's zero-capacity result, requiring a native play-test. No campaign talents or talent bonuses are added.

AW attaches fBag, fGer and ASpc directly and permanently to the player hero, bypassing the Backpack attachment path. fGer is configured as a unit ability; fBag already was. The stock panel controller has an explicit name/icon and hidden command-card position so it can be referenced and does not occupy a job spell button. The physical Backpack remains the intended entry point. Original AInv and existing carried items remain intact. GetUnitAbilityLevel checks the holder, so AV's zero item-ability readings alone did not prove that the engine failed to load those item abilities. AW's readings check abilities explicitly attached to the unit.

AX enables **Scenario → Map Options → Game Data Version → Forsaken Kingdom** (expansion selector2). All earlier experiments still selected Frozen Throne1 in war3map.w3i; the installed new ability records are version2. This prerequisite is independent of running the3.0 executable. The builder patches only the four-byte selector, preserving bounds, fog, HUD, players, random tables and other metadata. It handles the format39 race-HUD/height-fog additions according to [War3Net's binary map-info reader](https://github.com/Drake53/War3Net/blob/master/src/War3Net.Build.Core/Serialization/Binary/Info/MapInfo.cs). The installed editor's localized strings confirm expansion2 is Forsaken Kingdom. The item bases used by the existing map have no native equipment defaults; source drops use explicit item lists rather than stock expansion-wide random selectors. No global item classification changes are introduced.

This first build is for evaluating native UI and basic equipment assignment, not normal progression. Save, save-to-file, autosave and New Game export actions are blocked in the test: the unchanged save format only encodes up to six items per holder and cannot preserve a native bag/loadout. Normal save serializers and item/Armory indexes are not rewritten. Existing load code remains present, but old-save loading into the new inventory has not been validated.

Remaining migration work before progression play includes custom item procs and possession queries, quest/crafting scans of six-slot inventories, transfer/stacking/use helpers, and save/load of bags and equipped slots. AZ adds ordinary job-change handling; hero recreation/load paths still need validation. Ninja Dual Wield needs a design for weapons in Offhand: a native equipment type assigns one slot family per item, so the original two-weapon rule is not represented by the initial Primary mapping. Multiple accessory slots also change how much gear can be active. These are not claimed as complete or balanced by a compilation pass.

## Rebuilding

From the repository root, with the Stage AS Reforged/classic pair available:

```powershell
python experiments/Forsaken/test_forsaken.py
python experiments/Forsaken/build_forsaken.py --stage BQ
```

Existing releases are refused. Choose a new stage for another test. `--base` and `--classic` accept explicit input maps. The builder copies sources/tools into an isolated scratch tree under `build/`, applies the Equip, Job and MagicDefense overlays there, prepares the equipment objects, and runs the complete existing stage pipeline: source/quest/save/content/editor checks, regressions, codec test, module sync, library ordering, map checks and header finalization. Only successful builds are copied into `release/Forsaken`. Scratch sources and logs remain available for review; the overlays and builder in this directory are the reproducible source of the test.

Blizzard confirms the new campaign's gear/inventory features are available to custom map creators in its [Forsaken Kingdom deep dive](https://news.blizzard.com/en-gb/article/24298590/warcraft-iii-reforged-forsaken-kingdom-deep-dive-recap). Native names were verified against the locally installed3.0 libraries; the [PTR patch notes](https://us.forums.blizzard.com/en/warcraft3/t/new-300-ptr-build-24306/39295) describe newer Blz-prefixed aliases. BB also passes playable/editor compilation against freshly extracted installed3.0.1.24342 common.j/blizzard.j; the earlier native aliases remain present. UI row/frame names were read from that installation's StatDetailsPanel.fdf and InventoryBar.fdf. Native rendering still requires in-game acceptance.
# Save-system work

The durable successor plan is [SAVE_SYSTEM_PLAN.md](../../docs/SAVE_SYSTEM_PLAN.md)
and the checkpoint procedure is [FORSAKEN_REAPPLICATION.md](../../docs/FORSAKEN_REAPPLICATION.md).
`save-identities.json` freezes canonical item/job identities; `save_registry.py`
checks source and optional generated gear mappings. `test_save_registry.py`
tests rejected drift and alias resolution. These are read-only tools, not a game
save codec. Saving remains blocked; no new release stage is consumed.

`legacy_snapshot.py` now decodes E/F/G/H to a detached snapshot using frozen
`legacy-layouts.json`; `legacy-fixtures.json` contains eight synthetic vectors.
Run `test_legacy_snapshot.py` for source/codec comparisons. Field ledger:
[LEGACY_SAVE_LEDGER.md](../../docs/LEGACY_SAVE_LEDGER.md). These tests do not
establish native, real-player or multiplayer acceptance. Quantities stay seven
bits (gameplay120; preserve imported127); V2 contains22 reordered job values.

`save_vnext.py` is the first isolated new-format reference prototype, described
in [SAVE_VNEXT_REFERENCE.md](../../docs/SAVE_VNEXT_REFERENCE.md). Run
`test_save_vnext.py` and `measure_save_vnext.py` for bounded sections, sparse
inventory, metadata, expanded IDs, unknown-data tests and synthetic size profiles.
See [ITEM_SAVE_METADATA.md](../../docs/ITEM_SAVE_METADATA.md) for the source audit.
`save_progression.py` and `migrate_save.py` now add logical progression, automated
legacy translation and62-entry comparison reports with original-code provenance.
Run `test_save_migration.py`; frozen policy and eight successor goldens are checked.
See [SAVE_PROGRESSION_MIGRATION.md](../../docs/SAVE_PROGRESSION_MIGRATION.md).
`Forsaken-save-codec.j` now implements the isolated JASS envelope/schema codec
with per-player accepted/scratch/writer buffers. Run `test_save_jass.py` for source
differential vectors and standalone compilation, and `check_save_jass.py` for
read-only BT runtime/editor compile probes. See
[SAVE_JASS_CODEC.md](../../docs/SAVE_JASS_CODEC.md). Real-engine limits, capture,
restoration/rollback and transport remain pending; the codec is not wired into
the map, and saving remains blocked.

`Forsaken-save-life.j` adds JASS binary32 real/word conversion and read-only life
capture. `save_transaction.py` provides reference inventory capture and staged
restore/recovery orchestration against a future backend contract. Run
`test_save_life.py` and `test_save_transaction.py`; add `--life` to compilation
probes. See [SAVE_RESTORE_PROTOCOL.md](../../docs/SAVE_RESTORE_PROTOCOL.md).
Native flags, inventory capture/restoration and engine limits remain unverified;
the fault-injection backend is a test model, and saving stays blocked.

`Forsaken-save-native.j` now implements isolated modern-client hidden allocation,
exact metadata readback and verified owned-allocation cleanup/retry. It probes
droppability on each newly created handle and refuses an unchanged-default getter.
Run `test_save_native.py`; `check_save_jass.py --native` includes all three modules.
See [SAVE_NATIVE_STAGING.md](../../docs/SAVE_NATIVE_STAGING.md). Original capture,
placement, passive effects, complete rollback and publication remain open. No
map wiring or native-engine acceptance yet; saving remains blocked.

`Forsaken-save-journal.j` records original handles/metadata across all 57 positions,
requiring an external verified droppability capability. `Forsaken-save-position.j`
places tracked items in exact quick/bag/Gaya/house positions and tracks fillers
through cleanup. Equipment refuses until session/passive rollback exists. Run
`test_save_position.py`; compile with `check_save_jass.py --position`. See
[SAVE_ITEM_JOURNAL.md](../../docs/SAVE_ITEM_JOURNAL.md). Native quarantine/full
rollback, progression, guards and publication remain open; saving stays blocked.

`Forsaken-save-effects.j` classifies/verifies staged ability sets and removes
stored passives without removing active abilities. Storage now requires prepared
effects. `Forsaken-save-equipment.j` places prepared gear in exact equipment
positions, with tracked inert-ring filler checks for a lone alternate ring.
Run `test_save_equipment.py`; compile all modules with `--equipment`. See
[SAVE_EQUIPMENT_RESTORE.md](../../docs/SAVE_EQUIPMENT_RESTORE.md). Live policy
and filler objects, original quarantine/session rollback and native acceptance
remain open; no map integration or saving enabled.

`Forsaken-save-recovery.j` quarantines/restores actual original handles, verifying
exact positions, native ability instances and known passive bookkeeping. Failure
retains journals and blocks staging until verified release. Run
`test_save_recovery.py`; compile all modules with `--recovery`. See
[SAVE_ORIGINAL_RECOVERY.md](../../docs/SAVE_ORIGINAL_RECOVERY.md). Cooldown refresh
on character changes is permitted. Full session/progression rollback, derived
effects, gameplay guards and native acceptance remain open; saving stays blocked.

`Forsaken-save-progression.j` journals/restores actual per-player globals,
resources, research, force membership and stored job-table entries with readback.
Job heroes are read-only boundaries; unit/derived-state recovery remains open.
Independent progression guards retain journals and block staging until verified
release. Run `test_save_progression_journal.py`; compile with `--progression`.
See [SAVE_PROGRESSION_JOURNAL.md](../../docs/SAVE_PROGRESSION_JOURNAL.md).
No map integration or saving enabled; cooldown refresh remains permitted.

`Forsaken-save-heroes.j` captures/restores existing job/Freelancer/Gaya/active
heroes: exact XP/levels, skill points, base attributes and actual ability ranks/
instances. Added abilities can be removed; missing/replaced originals refuse.
Release checks total primary attributes after other recoveries. Independent hero
guards retain journals; cached neutral owners and aliased references are supported.
Run `test_save_heroes.py`; compile with `--heroes`. See
[SAVE_HERO_RECOVERY.md](../../docs/SAVE_HERO_RECOVERY.md). Wider effects/session
state, owned new units and the full controller remain open. No saving enabled;
cooldown refresh remains permitted.

`Forsaken-save-session.j` journals/restores talent typed presence and values,
six selected skills, partial monographs and prior accepted codec state. Choices
remain per-game and are never serialized. Read-only hero/table identities refuse
changes; independent session guards block staging/codec publication after a
recovery attempt. Writer Abort remains allowed for cleanup/retry. Run
`test_save_session.py`; compile with `--session`. See
[SAVE_SESSION_RECOVERY.md](../../docs/SAVE_SESSION_RECOVERY.md). Wider effects,
owned new units, gameplay exclusion/scheduling and the full controller remain
open; no map integration or saving enabled.

`Forsaken-save-units.j` allocates up to 24 tracked replacement job/Freelancer/Gaya
heroes with hidden/paused/invulnerable and empty-inventory readback. Originals and
live references are preserved. Cleanup refuses published/item-carrying heroes,
retains failed deletions for retry and clears only its own staging/codec guards.
Run `test_save_units.py`; compile with `--units`. See
[SAVE_UNIT_STAGING.md](../../docs/SAVE_UNIT_STAGING.md). No reference promotion or
commit API yet; hook exclusion, operation limits/scheduling, body/combat recovery
and full controller/engine acceptance remain open. No map integration or saving.

First private engine diagnostic: `Forsaken-save-probe.j` and
`build_save_probe.py` produce BT-based BU with `-savecheck`/`-saveverify`. These
capture all 57 live positions, test the inventory codec and compare snapshots;
they never load a character or export a usable save. Run `test_save_probe.py`.
See [SAVE_ENGINE_TEST.md](../../docs/SAVE_ENGINE_TEST.md) for human tests and
limits. Existing save exports remain blocked; full controller work continues.

Forsaken-save-references.j journals 26 hero references with typed handle presence,
plans only owned replacement roles, and switches/reverses references with native
readback. Independent guards retain recovery state and prevent premature cleanup.
Replacement heroes remain hidden and empty; no activation or successful commit.
Run test_save_references.py and check_save_jass.py --references with the existing
BT/native-library arguments. 15 new tests plus 249 earlier checks PASS (264).
See ../../docs/SAVE_REFERENCE_SWITCH.md for recovery ordering and open work.

Forsaken-save-body.j captures/restores living original heroes' health/mana,
position/facing and hidden/paused/invulnerable flags. It deduplicates 25 reference
positions, requires original identities/recovered maxima/reference reversal,
and verifies all eight native writes per unique hero. Independent guards retain
failed recovery for retry. Run test_save_body.py and check_save_jass.py --body
with BT/native-library arguments. 17 new plus 264 prior checks PASS (281).
See ../../docs/SAVE_BODY_RECOVERY.md for ordering and engine/remaining-state limits.

Forsaken-save-ownership.j prepares player ownership on the published owned
active/Gaya pair while keeping both hidden/paused/invulnerable/empty. Original
heroes are untouched. Verified neutralization/release precedes reference reversal
and owned-unit deletion; independent guards retain failed recovery. Run
test_save_ownership.py and check_save_jass.py --ownership with BT/native-library
arguments. 13 new plus 281 prior checks PASS (294). No activation or commit.
See ../../docs/SAVE_OWNERSHIP_PREPARATION.md for controller ordering and open work.

Forsaken-save-prepared-heroes.j prepares exact owned hero XP/level/base attributes
and explicit ability ranks with readback/retry. Normal jobs below 50 keep skills
unlearned and refund level points; mastered jobs learn four rank-11 skills and
ultimate rank 6 through bounded SelectHeroSkill calls. Targets stay contained,
originals unchanged. Plan discard precedes ownership/reference/unit cleanup. Run
test_save_prepared_heroes.py and check_save_jass.py --prepared-heroes with existing
BT/native-library arguments. 14 new plus 294 prior checks PASS (308). See
../../docs/SAVE_PREPARED_HEROES.md for untranslated policy and engine limits.

Forsaken-save-activation.j reversibly exposes an empty prepared active hero/Gaya
pair after protecting both originals and verifying replacement positions.
Containment and release precede prepared-plan discard and existing recovery.
Independent guards retain interrupted exposure; no successful commit is enabled.
Run test_save_activation.py and check_save_jass.py --activation with existing
BT/native-library arguments. 12 new plus 308 prior checks PASS (320). See
../../docs/SAVE_ACTIVATION.md for controller exclusion and remaining integration.

save_hero_policy.py and Forsaken-save-job-policy.j resolve accepted normal-job
levels into contained core/mastery plans without XP/growth guesses. All saved
schema1 meanings, including enhanced mastery100→native99, remain intact. Run
test_save_hero_policy.py and compile --activation --job-policy. 12 new tests and
53 focused regressions PASS; three compile probes PASS. SAVE_JOB_POLICY.md records
remaining native evidence/effects and future cap150/headroom999 schema planning.

Forsaken-save-gaya-policy.j and the extended save_hero_policy.py preserve Gaya
support purchases/chant ownership and plan exact Spiritual Power. Player research
and availability are separate targets, with no setters in this bridge. Run
test_save_gaya_policy.py and compile --activation --job-policy --gaya-policy.
10 new plus51 focused regressions PASS; three compile probes and BT object binding
checks PASS. See ../../docs/SAVE_GAYA_POLICY.md for remaining controller/effects.

Forsaken-save-freelancer-policy.j and the extended hero policy prepare H02L
level/mastery/derived attributes. Canonical Freelancer source parity covers160
vectors; borrowed choices remain fresh session targets. Run
test_save_freelancer_policy.py and compile with --freelancer-policy plus prior
options. Eight new and61 focused regressions PASS; three compile checks PASS.
See ../../docs/SAVE_FREELANCER_POLICY.md for variant/controller/engine limits.

Forsaken-save-player-target.j applies/readbacks three Gaya research flags and
six fresh skill choices, with verified original recovery and disposal guards.
Run test_save_player_target.py and compile all prior options plus --player-target.
Ten new plus74 focused checks PASS; three compile probes PASS. Availability has
no native getter and remains pending. See ../../docs/SAVE_PLAYER_TARGET.md.

save_inventory_plan.py resolves read-only exact inventory targets against BT
objects/compiled passive roles and BS mapping, with explicit legacy/inherited
defaults and complete dormant position preservation. Run test_save_inventory_plan.py.
12 new plus53 focused regressions PASS, including all276 gear aliases and57 slots.
Native placement needs phase-aware cargo/equipment auditing before controller
integration. No JASS changes, compile rerun or new map. Full saves remain blocked.
See ../../docs/SAVE_INVENTORY_PLAN.md.

Forsaken-save-cargo.j plans/audits contained exact owned cargo and verifies cleanup
with retry. Sealed cargo is accepted by ongoing ownership/prepared contexts;
fresh capture stays empty, activation/disposal remains guarded. Run
test_save_cargo.py and compile with --cargo plus prior options.
12 new plus122 focused regressions and three final compile probes PASS.
Allocation/placement authorization, fillers, equipment effects, house and loaded
activation/controller
remain pending. See ../../docs/SAVE_CARGO.md. No new map; full saves stay blocked.

The cargo journal now freezes plans and invokes guarded native creation,
preparation and exact placement through operation-specific internal primitives.
Original public phase guards stay intact; shared locking covers post-readback.
Sparse bag/ring fillers support verified cleanup retry. Run
test_save_cargo_placement.py; compile options remain --cargo plus prior policies.
12 new plus63 focused regressions and three final compile probes PASS.
Place equipment before filling the complete bag. Saved-profile adapter, house,
equipment effects and loaded activation/controller remain pending. See
../../docs/SAVE_CARGO_PLACEMENT.md. No new map or usable load command.

The explicit saved inventory profile bridge freezes non-house targets against the
permanent registry and actual gear tables, then drives guarded cargo preparation
and exact placement. Full source retains dormant records through recovery.
Saved/existing house contents and migration evidence refuse before allocation.
Run test_save_inventory_profile.py and test_save_inventory_projection.py;
compile with --inventory-profile plus prior policies.11 new tests plus25 focused
regressions and three compile probes PASS. See ../../docs/SAVE_INVENTORY_PROFILE.md
for remaining policy initialization, house, equipment effects and controller work.
No map build; full character save/load remains blocked.

Forsaken-save-house.j stages a separately owned contained empty replacement house
without changing original house items or live references. Failed containment and
deletion retain a cleanup guard; published/borrowed handles and unexpected cargo
refuse deletion. Run test_save_house.py; compile --house plus prior policies.11 new checks plus66
focused regressions and three final compiler probes PASS.
See ../../docs/SAVE_HOUSE.md. House cargo, reference switching and controller
integration remain pending. No new map; full character saves remain blocked.

The inventory/cargo route now covers57 positions with an attached separately owned
neutral house, canonical house items and owner-aware readback. Cargo must recover
and release before house deletion; originals remain untouched. Five new plus43
focused checks PASS, along with ten house-probe plus32 storage/codec regressions.
Compile --house plus prior policies; see ../../docs/SAVE_HOUSE_CARGO.md.
The opt-in build_save_probe.py --house-probe adds a private synthetic house test
with bounded static/dynamic trigger-state restoration and watchdog/cleanup retry. Engine acceptance
and full loaded activation/controller remain pending; exports stay blocked.

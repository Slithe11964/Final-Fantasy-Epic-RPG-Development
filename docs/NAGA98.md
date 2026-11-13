# QuickUI98 — Naga Islands and Tidal Wave

Built from QuickUI97. Full Dragoon development map only; production 0.9.7.5g, classic, master and older tests remain unchanged. Creature Review 03f uses the same current combat code and authored Normal statistics.

## Included

All 15 Naga Islands creature roles and Normal stats requested by the owner, plus level20 Hydra Hatchlings (2000 HP,35 armor,83–97 damage;25% poison30+4×attacker level/s for10s). Old duplicate poison/pulverize/critical abilities removed on the affected units. Readable ability calculations and unit summaries updated.

Sea Witch: injured friendly regional Devour, Queen stat absorption/two-use limit/20s cooldown; unlock Maelstrom only after a successful consume. Purple Brilliance visual and +30% magic damage aura800; +50 armor/50% ice resistance Frost Armor; regeneration equals caster maximum HP over60s; Vortex pulls enemies to the chosen point. Maelstrom retains Diablos native15s storm with1% maxHP/sec,1800mana,60s cooldown. Original1600 mana means the Witch must absorb sufficient additional maximum mana to afford Maelstrom.

Royal Guard: no Night Might,2000 water wave,1000 water bolt/5s stun,60 evasion. Revenant freezing attacks:30% movement/20% attack slow and -30 evasion for5s. Sea Elemental:400 water per Aqualung burst,8bursts from0 through7seconds. Dragon Turtle:10% physical/spell block,60% while Shell Taunt buff is active;100 flat damage reduction, minimum1.

Murloc/Prawn and Naga Myrmidon callers use20-second Naga-only Alert and the existing final5–1 countdown; successful calls double wave size/frequency for60s. Snap Dragon poison uses victim hero level; Hydra Hatchling poison uses attacker level. Flans fork lightning at3targets; Aqua Flan wave strikes each enemy for2000water and heals each ally for1000 once along its1000-unit path.

Storm Wyrm:2nearby images,25% outgoing/150% incoming damage. Each image death independently grants its living original +50% attack speed,+1500 maximum/current HP,+120 base damage. Bonuses stack without overwriting outside gains; Warcraft attack-speed cap still applies. Death/removal cleanup is idempotent. Expired/removed images and removed actors are reclaimed through existing monster heartbeat.

Sea Giant pulverizes:33%500water/40%750thunder/50%100omni, radius300. Hunter Roots:500water/s5s. Behemoth stomp1500/radius500 and boulder1500/3s stun. Distinct role icons and familiar status visuals; native assets verified.

## Unspecified tuning chosen for this test

Sea Witch Devour250mana; Regeneration retains300mana. Guard wave100mana/CD15; bolt150mana/CD15. Snap Dragon frenzy10s/CD20. Mirror Images30s/CD30/150mana. Roots150mana/CD15. Stomp100mana/CD15/2s stun; Boulder100mana/CD15. Active caster mana pools/regeneration support repeated AI casts. Exact authored values are in tools/build_naga98.py and its manifest.

## Pool / arena scope

Existing day/night pool assignments audited: nsgn/nsgh/nsgb/nrel/nsel/Flan(n01O) in Naga Islands and absent from Central Islands; Lesser Flan(n01P) stays Highroad. Pool scripts, loot tables, arena rosters and arena modules unchanged from QuickUI97.

## Shinryu Tidal Wave

Shared Famfrit/Shinryu A0ZX handler previously hid its proxy units before ordering native Carrion Swarm. Proxies now remain active, transparent and without pathing. Isolated nTW8 clone of A0PZ supplies the verified CrushingWaveMissile model and costs no dummy mana. Actual boss spell and its mana cost, damage formula, five rows, spacing, water element, shared once-per-target hit group,6s proxy lifetime and2s group cleanup unchanged. Original A0PZ and all other water item spells unchanged.

## Performance and verification

No new client-local gameplay, sync channel or always-active polling timer. Existing1Hz monster heartbeat handles AI/buffs/cleanup. Only Vortex movement starts a10Hz timer while targets are actually being pulled and pauses when empty; mirror binding uses a one-shot timer. Gear/cursor/inventory controls are unchanged.

Eleven focused executable/data regressions pass, including image bonuses, poison probability, pool/scope checks and Tidal Wave damage preservation. Full map playable/editor compilation, startup/source/globals, native save-text safety, content references, and save compatibility(358items/22jobs) pass. Archive readback matches all unchanged resources. Live visual/AI/multiplayer acceptance remains pending.

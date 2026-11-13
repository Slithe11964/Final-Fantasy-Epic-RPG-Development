# QuickUI99 — Ancient Forest and Naga corrections

Full Dragoon development candidate from QuickUI98. Production g, classic g, master and all previous test maps preserved. Creature Review 03g has the same Normal stats and combat code, with seven new summon types and original Brood Mothers beside Lothlorien / Ancient Forest. Mother Spider accepts -split; Hydra split support retained.

## Naga corrections

- Frost Armor was writing Ufa1 (cold-effect duration), while the native armor field is Ufa2. nFA8 now has Ufa2=50, cold duration5seconds, buff duration30seconds. Existing50%ice resistance retained.
- Abyssal Brilliance is now a baked purple variant of the native aura model/texture. Evasive Endurance uses a baked green variant. Native blue texture pixels could not become purple by multiplying runtime vertex colors. Model geometry/animation retained, static color white, recolored map-local TGA textures. Four imported assets registered in war3map.imp for editor round trips. Native buff art supplies the effect consistently; duplicate N98 caster effect removed.
- Vortex now shows a Dark Portal target effect for2seconds instead of destroying a birth effect immediately. Existing250radius/1second10Hzpull unchanged.

## Ancient Forest

All14requested unit stat sets authored on Normal. Mother Spider replaces Vile Spider. New spell tooltips use plain damage/healing/effect calculations. Removed the requested old haste,critical,blind,frost armor,manablow and duplicate poison/split abilities on the relevant units. New unit/ability IDs isolated; raw values in tools/build_ancient99.py.

Tree of Life:50/9000HP; +100armor and stationary building animation for30seconds; produces six Life of the Forest wisps at5-second intervals. Wisps40/2000HP/30Unarmored seek nearest enemy hero,detonate within250for3000fire in500radius,can be killed beforehand. Two Dryads40/4000HP/62Light/212–244piercing,independent -1accuracy stacks30s. Sylph45/5000HP/10Impenetrable/175–225chaos casts5sSilence,Haste,Imperil,Protect,Shell. Queen-style injured-friendly regional Devour absorbs damage/HP/mana/armor,two uses/CD20. Thorns aura reflects10%physical/magic to attacker with recursion guards. AI summons first,devours valid food,roots only after both summon cooldowns start and no valid Devour is cast. Sylph is a normal available summon.

Rooted forms preserve their original unit handles and creature targeting. Building animations plus movement removal prevent walking. Uproot restores movement and previous combat values without replacing the unit or losing unrelated stat gains. Ancient of War produces six40/3600HP/30Light/180–197piercing Archers over30seconds; Cover Archers transfers50%of received damage to the nearest living allied guardian within800. Rooted War/Protector take25%extra damage. Protector roots to451–512siege at1000range and returns to351–362at128range on uproot.

Plague Treant44/7500HP/55armor; Plague400/s. Poison Treant46/8000/44/345–348 with Night Might and30%poison300+7×victim hero level/s10s. Satyr40/4500/42/303–313calls20sAncientForestAlert with final5–1countdown; success doubles region7wave amount/frequency60s. Assassin45/6200/44/469–477has Night Might. Greater Flan48/5500/20/301–304:1750lightning fork to3;2000ice nova radius200;1500water bolt/3s stun,explicit projectile and element.

Mother Spider49/10000/64/376–400. Brood Shell hatches after10seconds or on death into the same3nsbmBrood Mothers as original split. Mother death independently creates3. Each shell hatches once. Binding Poison adds10%attack/movement slow per landed attack against heroes,with45sindependent stack expiry. Movement slow caps90%; attack slow uses native cap. At15stacks,5sstun and all stacks clear. Slow levels update downward when individual stacks expire.

Trickster43/4500/50/256–284has Blind and one50%-damage/150%-damage-taken nearby image. Soulstealer45/6000/57/274–301: channel1000life/s5s; heal caster and each friendly ally within600by50%actualHPdrained after reductions. Mana channel takes up to300MP/s5s and deals2×actualMPdrained,returns MP to caster. Stop/move/pause/outside800cancels. Cura1500HP. All3CD30.

Shadowdancer46/5400/54copies an enemy hero into a friendly native illusion dealing20%copied attack damage. No hero inventory/save/job copy logic; native illusion plus shared summon tagging/fallback binding. Trickster/Shadow Double are allowed past the map's default zero-illusion-damage rule,without changing older illusion exceptions.

Hellcaller50/7200/61/360–370: Accumulate restores50%maxHP,+200base attack/+50armor20s. Infernal45/4000HP/20Demon/200–243chaos;2000fire in300radius on arrival. Demon's Contest taunts5s,+60armor20s,CD30; existing Gaya Break Stun clears forced attack. Corrupted Treant43/5950/65/316–324 summons three40/2200HP/41Fortified/212–232siege Ents. Death yell grants nearby allies independently stacking20%attack speed.

## Unspecified tuning chosen for testing

Normal caster mana pools1200,Tree2400;20MP/s regen. Temporary Dryads/Sylph/Infernal/Ents/Archers/wisps last60seconds. Shell2000HP/30Fortified. Root production forms and Protector use30second duration/CD60,plus manual Uproot. Dryads250MP/CD60;Sylph800/CD30;Devour300/CD20;Shell150/CD30;Infernal300/CD60;Ents200/CD30. Flan spells200MP/CD15. Drain spells200MP/CD30;Cura150/CD30. Mirror/Blind150/100MP/CD30/15. Hero Double200MP/CD30,duration30. Accumulate125MP/CD30. Sylph support spells100MP/CD15(exceptSilenceCD20),Haste15s,Protect/Shell/Imperil20s. Death-yell haste lasts20sper independent stack and respects Warcraft attack-speed cap. All remaining unchanged requested stats/armor/types preserved.

## Verification

Sixteen focused executable/data tests pass: exact authored stats/dice,summon armor types,UI/item/arena/pool preservation,correct Frost Armor field/imported aura bytes,individual accuracy and slow-stack expiry,15-stack stun,independent Ent fury,shell single hatch,six rooted production ticks,stat restoration,poison probability/hero level,nearest allied guardian and recursion guard,actual life/mana drain math,regional Alert/Devour conditions. All new native icons/models/runtime effects validated against installed assets. Both playable/editor scripts compile;startup/source/globals/native-save-text safety,content refs and save compatibility(358items/22jobs)pass. Review summon placement/name/split/readable spells/asset readback checked.

No new always-active polling or client-local gameplay. Existing1Hzshared monster heartbeat handles AI,timed stacks,channels,summons and cleanup. Only one-shot visual-lifetime and illusion-binding timers added. Existing Vortex active10Hzpull retained. Gear F/G/cursor/frame logic unchanged; only accuracy readers subtract the new shared Dryad stack count. Arena roster/team and spawn-pool scripts unchanged. Live graphics,AI behavior and multiplayer acceptance remain pending.

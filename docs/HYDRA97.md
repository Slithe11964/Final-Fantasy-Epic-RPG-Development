Hydra offspring and Highroad presentation — 2026-11-04

QuickUI97 / Creature Review 03e, based on UI96 and preserving the UI display fix.
nhyd (direct Ancient Hydra offspring): level25,3000HP,41armor,135–140attack.
Poison20% on landed hit:50+5*attackerLevel/s for10s (175/s at level25).
Old A0PH poison removed so it does not stack with the replacement.

Explicit synchronized death splits: nahy -> two nhyd; each nhyd -> two nhyh
Hatchlings. Original Aspy/Aspt removed from those two unit definitions to prevent
native duplicate spawns. Same owner/facing/zone/wave membership; no new timer.
Hatchling stats/poison unchanged. Offspring included in Central regional membership,
but regular world spawn pools and arena rosters unchanged.
Review -split accepts living Ancient Hydra or Hydra, ignores case/trailing spaces,
and explains that hatchlings do not divide. New offspring/hatchling exhibits are
beside Central Islands summons. Previous command only accepted nahy and relied on
native death splitting; the exact reason the earlier native test failed was not
confirmed. New command uses the real shared death handler rather than a separate
fake preview spawn.

ngnv Whirlwind of Steel: previous Orc/Whirlwind/Whirlwind.mdl is absent from the
installed asset index. Use the actual Orc/Bladestorm/BladestormTarget.mdl effect.
Damage500 physical/s for5s/radius250,150MP,20CD unchanged.
ngrk Avatar: silent ANcl cast replaces native AHav, which still played its voice
after effect-sound fields were cleared. Same150MP/45CD/30sduration,1.5scale,
+100 attack,+1000maxHP,currentHPgain1000,+25%attack speed and spell immunity.
Existing hA25/scale expiry retained. Separate Forest86Data171/172 flags keep Avatar
state independent of Central buff cleanup. Begin is idempotent; expiry/death
subtract only its bonuses and preserve pre-existing magic immunity.

Eight focused executable/data tests pass; both playable/editor compilers,
startup/source/global/readback/text checks, normal save compatibility and both
content checks pass. Native visual/audio/AI and multiplayer acceptance pending.
Productiong/classic/editor master and all previous TEST maps unchanged.

Tools:build_hydra97.py,build_review03_revision97.py; tests:test_hydra97.py.
Parameterized review95 builder keeps its previous defaults. Intermediate candidates
preserved under build/candidates/hydra97-* and review97-*.

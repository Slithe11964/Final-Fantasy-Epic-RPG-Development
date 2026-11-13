# QuickUI82: Dragoon balance adjustment

From QuickUI81, Dragoon test only. Drakesbane damage multiplier is max(0, 1 + 0.004 x (Accuracy - target Evasion)); Rise of the Dragon uses max(0, 1 + 0.01 x (Accuracy - target Evasion)). At +20 accuracy advantage these are x1.08 and x1.20. Existing base damage, Spear Proficiency damage scaling, elemental types and Rise execute bonus remain.

Spear proficiency now increases normal mana regeneration by 5% per point, in both the synchronized native regeneration ability updater and read-only stat panel. Its 1 percentage point enemy block reduction remains. All affected ranked spell and cached calculation tooltips match; all ten house proficiency upgrade ranks and capped proficiency tooltip state the quantitative bonus. House recovery stays 10% maximum HP/MP per second. Jump radius300 and Sonic max-rank200MP unchanged.

Three focused tests exercise both accuracy coefficients, negative clamp, actual native mana updater values, matching stats/tooltips and preserved prior balance/objects. Full compile/editor/pair/startup/globals/text/content/save checks and archive readback pass. Native game testing pending. No new timers, inventory/input/preview changes or bag cross-close fix. Normal release, classic and master preserved.

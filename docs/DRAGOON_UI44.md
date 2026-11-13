# UI44 Rise readiness fix (2026-10-26)

Owner confirms visible Rise button is middle row, second column, beside backpack: native command index5. Attach ready sprite there. Preserve UI43 object positions and all visible icons, including Eye of the Dragon and Mastery. Earlier experimental candidate01 moved/hidden icons; it was never installed and is superseded.

Replace repeated per-tick native disable calls with DG_Gate transition state per hero. Ability existence uses BlzGetUnitAbility, allowing a disabled ability to be restored even if level lookup returns0. Disable once without Life; enable once on proc; disable on consumption/expiry/death/job change. Proc enables immediately. No repeated native disable nesting. Tests cover repeated false/true gate calls and restoration when level reads0.

Jump icon changed to BTNAttackGround. Other UI43 balance, descriptions, damage, jump impact and spell behavior retained.19 behavior/object checks pass. Native in-game acceptance pending.

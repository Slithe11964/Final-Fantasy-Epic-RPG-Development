# FF Epic RPG 0.9.7.5d

Reforged/Forsaken is the QuickUI28 development build (play-tested by the user) with the version labels changed to 0.9.7.5d.
The 1.29.2 map is built from the same editor master with the Classic inventory and menus; the quick-gear
buttons, cooldown wheel and native inventory controls are Reforged only. The Thief dagger experiment is not included.

## Quick-gear buttons (Reforged)

- The weapon and offhand buttons show the game's own cooldown wheel (UI-Cooldown-Indicator model on a status bar
  over each button). It is redrawn every 0.05 s only while a cooldown runs. No countdown numbers.
- Default keys F (weapon) and G (offhand). `-gearhotkey X Y` (or `-gearhotkeys`) sets any two different letters A-Z
  or numbers 0-9; `-gearhotkey reset` restores F/G; `-gearhotkey` alone shows the current keys in chat.
  After a change the corner letters on the buttons are blank (the chat message confirms the new keys).
- Fixed: after any chat message the quick-gear keys stayed blocked until Enter was pressed again (the Enter that sends
  a message was counted as opening the chat box).
- Targeted items (for example the offhand Water) work as before: press the key, then click the target or ground.
- Multiplayer: frames are created in shared startup only; local code changes only that player's frames and sends the
  cast request through the existing sync, so nothing can desync.

## Other changes since 0.9.7.5c

Included sources: ArmoryVisits.j (armory awards/visits per visitor), MaidensEye.j (quest sight follows possession),
quest keys carried by the hero or Gaya (tools/quest_carry.py), first-cast cooldown preparation (tools/first_cast_cooldown.py),
channelled boss/shared spell proxies (tools/channel_casting.py), and updates to BackpackVisibility, PriestLegendary,
SharedItemCooldown/Duration, TravelPages and the Bazaar prepare frame.

## Validation

Both playable and editor scripts compile against their target APIs; source startup and globals checks pass; save
compatibility passes (358 items, 22 jobs, G/H fixtures); Reforged startup matches UI28 (1518 triggers); local UI call
safety passes. The old quick-cast fixture suite still expects the earlier number overlay and is not a passing gate.
Not yet tested in a real multiplayer lobby.

Forsaken: 13,198,449 bytes. SHA-256: `a97c18c855203116aaa58cf809dfd9cb95162ceb4c7fe6cf5a31841ed7fb8ff1`

1.29.2: 11,337,548 bytes. SHA-256: `c7ad97ff14cea4f7beca7b1c30713d0e551cfa858730be4fd421c839d07d97f0`

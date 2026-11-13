# UI43 Dragoon follow-up (2026-10-26)

Full native RPG test, building on UI42 tuning. Q Sonic, W Drakesbane, E Dragon Ally, R Jump on the bottom row; T Rise at3,1, clear of backpack0,1. Ready glow anchors the actual Rise button7. Rise disabled without Life, preventing native target previews before it is available.

Life lasts5 seconds, shows a native hero status, and multiplies physical damage by1.1 once in the common physical damage pipeline, covering basic attacks and techniques. Native status is cosmetic: zero Bloodlust modifiers; dummy casts custom dGLf/BdGL. Status removed on consumption/death/job change; natural duration matches Life. Existing fiery aura retained.

Descriptions use owner wording and Damage Calculation sections. Max rank labels say MASTER. Eye description uses owner wording; job shrine Special is simply Eye of the Dragon. Jump icon is Bear Blink. Jump has STR and MP scaling only, and radius100 (200 diameter) impact around the tracked enemy. Sonic and Drakesbane cost150 MP at every rank, which their existing MP-based damage formulas use. Rise uses fire element1 through the real elemental damage pipeline.

Drakesbane executes its sweep immediately at spell effect instead of a deferred0.1-second timer. Hero native cast point0 removes engine wind-up; existing cast backswing is interruptible. Range300/cone180 and proc pity unchanged.

18 behavior/object checks pass, including immediate sweep, Life status creation, fire dispatch, Jump stat independence and100-radius boundary. Previous maps preserved. Native gameplay/multiplayer acceptance remains pending.

# Preparing for new development

Updated 2026-10-06. The paired r16 baseline is ready for development; see HANDOFF.md for paths and
verification limits. All 93 quests use QuestEngine. Bugs remain deferred by user request.

1. **Confirmed paired starting point.** The user reports both maps work great (2026-10-06).
   Continue focused tests for new changes; verify a separate editor Save As with JassHelper enabled.
2. **Add the next requested content.** CONTENT_DEVELOPMENT.md gives worked quest, boss, item and
   reward examples. Build with the complete gates and test the affected content in both clients.
3. **Continue shared-context cleanup when useful.** PHASE16.md and phase16-handoffs.csv identify
   remaining arena/job/cross-module handoffs. V covered TrueIceAge and Cartographer. Work one
   subsystem at a time, preserving behavior and using focused tests.
4. **Capture real player saves before progression changes.** Existing append-only compatibility
   guards, fixed codec vectors and 2,000 randomized cases are in place; real saves add coverage.
5. **Publish when ready.** The repository now includes baseline maps and local build/conversion
   tooling. Old material lives in the external archive. No remote publication has been performed.

Readiness #2/3/4 (repeatable builds, quest checks/inspection, content/save guards), #7 (content
guide) and developer packaging are complete. #6 shared-state cleanup has a first pass. Bugs are
still deferred. The tool suite has 47 regression tests; keep contracts/fixtures and Git history.

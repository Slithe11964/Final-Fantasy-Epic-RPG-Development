# Recovery12 failure: multiplayer render investigation

Owner confirms both failures persist: native backpacks close each other and a mage-equipped cutscene crashes. **The same equipped cutscene works in single player.** Treat the multiplayer condition as essential; do not call another guard-only change a fix. Recovery12's shutdown was insufficient. V23 shares it but was not separately confirmed in live play.

## New crash evidence

Latest report: 2026-11-09 13.26.32 913ccee4, seven players, modern Recovery12, Warcraft 3.0.1 build24371. It is a native ACCESS_VIOLATION, not a report establishing network desynchronization. Native instruction address/rva repeats Recovery10's crash.

Read-only analysis of **captured minidump memory** (not encrypted on-disk code) shows the fault at RVA 0x2c5ed4: `mov dword ptr [rdi + 0x20], ebx`, with invalid RDI 0x0100000000000010. Captured register R12 points to an object whose matching-executable RTTI identifies `CRenderBatch`; the immediate stack points to `CSimpleTop`. This is stronger evidence for a simple-frame render-batch failure than the unsymbolized stack alone. It does not identify the first corrupting operation, exact widget, F/G renderer, or prove that inventory polling caused it. The executable timestamp is checked against the dump module to avoid mapping a different build.

Artifacts: release/development/RenderInvestigation20261109/render-dump-analysis.json and evidence/ copies. Analyzer: tools/analyze_render_crash.py; local read-only PE/disassembly dependencies are under build/crash-analysis-deps. No executable, client process, registry or game configuration was modified.

Local-source callback reachability audit from UI72_Tick, QuickGear_Mouse/Input/Click, Forsaken_PanelClick, BagScreen_Event66, GearInput_Hover and GearWave_CalculatorArm found no explicit frame/group/unit/timer creation or frame lookups in the 116 reachable functions. A broader scan **did find BlzGetItemAbilityByIndex in Forsaken_ActiveAbilityLevel, Forsaken_ElementAbilityLevel and Forsaken_StatAbilityLevelUncached**. Those return ability handles and remain a separate locality lead; the native's allocation behavior and causal relation to this fault have not been established. Do not describe this as an absence of all handle-returning calls. This static graph is a limited source check, not an engine or multiplayer proof. Source report: ui-reachability.json.

## Native Inventory Check 02

Small clean map using the exact Recovery12 fBag/fGer/ASpc definitions and item/ability tables, with eight player slots. Each tester starts at level99 with Ice Wand U f104 and Book of Depths f220 equipped. If the native equip call is refused, the map prints that it must be equipped manually. No save files or load codes are involved.

There are **no custom frame APIs, F/G UI, inventory polling, sync requests, RPG scripts or repeating callbacks**. One self-destroying startup timer positions the camera. Commands are event-driven:

- Two human players select their own testers, open Backpack with B, and alternate opening/closing while the other leaves theirs open. A cross-close here reproduces without this project's custom Backpack callbacks.
- `-scene` plays a three-second native cinematic with the normal .5-second UI fade and portrait. It pauses testers, clears selection, hides UI and restores control afterward.
- `-instant` runs the same short scene with a zero-duration UI transition.
- `-bare` removes only the caller's test wand/book; `-mage` equips fresh test copies. These permit an equipment control without restarting or importing anything.
- `-home` returns to the tester; `-help` repeats instructions. Commands are ignored while the shared test cinematic runs.

Interpretation: a crash here would show that F/G/custom inventory polling is not required for that reproduction. A pass would keep the full-map UI integration under suspicion; it would not establish safety. Testing must include multiple human clients because owner reports single-player works. Item spell damage is not an RPG test in this stripped map.

The same native cross-closing has a first-hand report including failed separate ability/bag/cooldown-group attempts: https://www.hiveworkshop.com/threads/new-equipment-inventory-system-in-multiplayer-doesnt-work-properly-forsaken.374745/ . It is a lead, not proof that this map has the same root cause. No verified native-preserving workaround was found. Do not add automatic pane reopening or local gameplay mutations.

## Full-map transition comparison

Recovery13 (from Recovery12) and V24 (from V23) change exactly **two constants**: Cine_Enter/Exit call ShowInterface with duration0 instead of bj_CINEMODE_INTERFACEFADE (.5). This tests whether the animated HUD transition interacts with the captured rendering failure. It is an inference-based diagnostic candidate, **not a confirmed fix**.

F/G's normal renderer/models, all shutdown/resume guards, Backpack handling, inventory/profile/save/autosave, objects/imports, jobs/creatures, scene dialogue/camera/waits/rewards remain unchanged. No Recovery11 pane-restoring or renderer-replacing workaround is included. Full-map archive/runtime parity checks permit only the two functions plus editor source. The legacy Recovery12 map is unchanged because the failing UI/inventory paths are modern-only.

All three maps pass playable/editor compilation, startup, source/global pairing and native saved-game text checks. The native map builder asserts the absence of custom frame/polling/save/sync code and exact current item/ability resources. Live multiplayer results are pending for **both** issues. Do not promote these as a stable production release.

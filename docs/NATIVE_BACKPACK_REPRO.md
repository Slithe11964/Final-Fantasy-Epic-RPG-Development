# Reproduction: expanded inventory closes another player's inventory

Prepared locally for review; not submitted or published.

Observed on the project's Warcraft III 3.0.1 environment (recent supplied crash reports identify build24371). The native-only map is FFERPG-Inventory-Multiplayer-Check-02.w3x, under release/development/InventoryMultiplayerCheck02 and installed in Maps/Download/TEST.

1. Two human players join different player slots. Each receives an independently owned Inventory Tester with native six-slot inventory, expanded backpack and equipment abilities.
2. Player A selects their own tester and opens Backpack with B/the native icon.
3. Player B selects their own tester and opens Backpack.
4. Player A's Backpack closes. The same interference occurs in the other direction when players alternate opening/closing.

Expected: each player's native inventory open/close state remains independent.

Owner confirms cross-closing in this stripped map. Its runtime has no custom frame APIs, F/G hotkey UI, RPG inventory integration, polling, sync requests or repeating callbacks. The only startup timer positions the camera then destroys itself. B and native inventory clicks have no custom handlers. Chat commands provide a short native cinematic and test equipment controls only. No save files are loaded or written.

Follow-up control confirmed by owner: **both players use `-bare` to remove the test wand/book; backpacks still close each other.** The equipped mage items are therefore not required for this reproduction. This is distinct from the equipped cutscene crash.

The map uses the exact Recovery12 item/ability definitions. Ice Wand U and Book of Depths start equipped; `-bare` removes those test items and `-mage` restores them. The clean map result demonstrates that the custom Backpack scripts are not required for the reported reproduction. It does not establish which engine implementation/configuration field is responsible.

Separate observation: the owner reports `-scene` succeeds with gear equipped in this map, which intentionally lacks F/G widgets. Their full RPG map still has a multiplayer equipped-scene access violation; those two symptoms should not be conflated into one proven root cause.

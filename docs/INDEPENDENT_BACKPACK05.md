# Independent Backpack05

Owner reports native Check03 cross-closes across its test modes. Check04 also
cross-closed, but the owner saw the normal backpack without the replacement's
Drop held item control. This indicates the test likely did not exercise the
replacement and does not establish the exact startup or UI failure.

Check05 removes ASpc at object definition from both standalone test units;
their fBag/fGer/native storage and equipment remain. No runtime ability removal
is needed. Setup runs separately and creates slot controls in 15-slot batches;
the 45-slot total is checked. The conspicuous Test Bag 05 button uses an absolute
anchor separate from native command buttons. The panel is identified by X 05 and
Drop held item. `-bagstate` prints native opener levels (expected 0/0), initialized
slots (expected 45), transitions, local open state and frame visibility. There
is no additional timer, polling, or change to item movement/sync or input rules.

Map/editor/startup/source/globals/text checks and five existing scripted
boundary tests passed; archive readback confirms both object removals. Native
and multiplayer isolation remain unverified. Installed separately in TEST;
canonical h, h Dialogue01 and full development V35 were not changed.

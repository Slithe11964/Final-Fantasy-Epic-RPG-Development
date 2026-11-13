# V13 / Creature Review03n: Omni Breath model geometry

2026-11-07. Owner still sees long lines extending from Omni Breath. V12/Review03m already had no RIBB or PRE2 chunks, so earlier emitter removal did not solve it. No assumption that the remaining geometry change is live verified.

The dark Carrion Swarm asset contains three geosets: a520vertex animated creature mesh using material3/creature-skin atlas; a72vertex wave mesh; and a4vertex wave/glow quad. This revision removes the first mesh, retaining the two wave geosets byte exact. Removes its GEOA record, remaps remaining GEOA geoset IDs and BONE geoset/animation associations. The70bones belonging to removed mesh have NONE/NONE association; the remaining6+1bones map to wave0/1. Node IDs, transforms, parents, pivots and animation tracks remain exact. Materials/textures/sequences/events are unchanged. No new textures or effects imported.

Only existing resource war3mapImported\DarkSwarmBreathV7.mdx changes in each archive. The historical filename is retained to avoid ability edits. No change to ANY playable/editor script, object/ability definition, damage, cone/range, casting/AI, Dusk Wyrm effect, inventory, visibility, save or polling. Outer map labels/files name V13 and Review03n; internal review text remains its prior version because scripts/WTS are exact. Production gRecovery02 and classicRecovery01 unchanged; this is the development-only Black Dragon spell.

Verification: archive readback proves all other resources exact, including war3map.j and war3map.wct. Binary chunk boundaries validated; only GEOS/GEOA/BONE payloads differ. Both retained geosets byte exact; all live bone/geoset-animation IDs valid, no shift to node IDs. Both maps use identical corrected asset. No new script compilation needed because scripts are byte exact to checked baselines. Native visual result remains unconfirmed; do not promise the line is gone before user sees it.

Installed TEST FFERPG-V13.w3x and FFERPG-Creature-Review-03n.w3x; V13/installed.json hashes. Prior V12/Review03m/master/releases preserved. Current full developmentV13,nextV14.

Implementation tools/omni_wave_v13.py and tools/build_omni_v13.py. Inspected source material/texture/geometry associations; format reference https://github.com/flowtsohg/mdx-m3-viewer .

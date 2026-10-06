# Reforged development and 1.29.2 compatibility

Develop from baseline/Reforged/FFERPG_0.9.7.3-r16.w3x or the newest Reforged build. Save As in the
Reforged World Editor with JassHelper/vJass enabled, check the saved file, then generate its classic copy:

```powershell
.\make_129.ps1 -Map release/<saved-Reforged-map>.w3x
```

downgrade_129.bat invokes this local script. No arguments converts the baseline. Output defaults
to release/1.29.2/<same-filename>.w3x; -Out and -PythonPath are supported. Existing files are refused.
The map-list name uses the filename's stem without a (1.29.2) suffix. Baseline files share both names.

Conversion rewrites terrain, doodads, units, objects, map info, regions/cameras and editor formats.
It merges skin data, restores missing classic fields from the pinned classic baseline, adapts
unsupported generated calls and compiles the script against bundled 1.29.2 libraries. Object text
is written inline; only referenced strings remain in WTS. Game Interface and HM3W header are kept.
Both copies retain editor files; custom vJass saves require JassHelper. Keep Reforged as the master.

The FF profile clears inherited attachment art on Chemist Pharmacology A0HL and Ninja Dual Wield
A0HP, preserving authored spell art and unit selection settings. Stage X's Gaya selection workaround
was removed in Y and is absent from this baseline.

## Client display

Flying Gaya/crow lines can be Warcraft 3.0 Air-to-Ground Indicators. If the menu option is unavailable,
close the game, set showAirToGroundIndicators=0 in the Gameplay section of Documents/Warcraft III/
War3Preferences.txt and restart. Conversion does not edit client preferences. Test a fresh baseline
game for Gaya selection/health-panel behavior with restored normal unit settings.

## Release testing

Conversion and compilation pass; actual 1.29.2 and Reforged smoke tests remain: map loading, welcome/
quest log, hero spells, Gaya selection, quest completion, save/load and multiplayer where relevant.
Include Thief Fan of Knives/Channel spells to check missing object defaults. See QUEST_TESTS.md.
Compilation does not establish cross-client visual/gameplay equivalence. Historical experiments are
in the external archive; the current workflow requires neither sibling MapToolkit nor r7.

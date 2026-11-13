"""Build UI49: real native item targeting and direct Aqualung pulses."""
import build_dragoon_ui41 as builder
import thousand_cuts
import aqualung_pulses
import native_gear_buttons
from editor_pair import View
from equipment_integrity import catalogue


def configure():
    config=catalogue(View(builder.ROOT/'editor/FFERPG-Editor-Master.w3x'))
    original=builder.refresh
    builder.refresh=lambda source:native_gear_buttons.refresh(aqualung_pulses.refresh(thousand_cuts.refresh(original(source))),config)
    original_objects=builder.patch_objects
    def objects(archive):
        files=original_objects(archive)
        files['war3map.w3a'],files['war3mapSkin.w3a']=thousand_cuts.objects(files['war3map.w3a'],files['war3mapSkin.w3a'])
        files['war3map.w3a'],files['war3mapSkin.w3a']=aqualung_pulses.objects(files['war3map.w3a'],files['war3mapSkin.w3a'])
        return files
    builder.patch_objects=objects
    builder.EXTRA_FILES={}
    builder.STAGE='QuickUI49'
    builder.OUT=builder.ROOT/'release/development/QuickUI49/FFERPG-QuickUI49-Forsaken.w3x'


if __name__=='__main__':
    configure()
    builder.build()

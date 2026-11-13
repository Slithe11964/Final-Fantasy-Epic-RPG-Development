"""Retain current gameplay and restore released F/G without later experiments."""
import build_dragoon_ui41 as builder
import thousand_cuts
import aqualung_pulses
import release_gear
import wave_runes


def configure():
    original=builder.refresh
    builder.refresh=lambda source:wave_runes.refresh(release_gear.refresh(aqualung_pulses.refresh(thousand_cuts.refresh(original(source)))))
    original_objects=builder.patch_objects
    def objects(archive):
        files=original_objects(archive)
        files['war3map.w3a'],files['war3mapSkin.w3a']=thousand_cuts.objects(files['war3map.w3a'],files['war3mapSkin.w3a'])
        files['war3map.w3a'],files['war3mapSkin.w3a']=aqualung_pulses.objects(files['war3map.w3a'],files['war3mapSkin.w3a'])
        return files
    builder.patch_objects=objects
    builder.EXTRA_FILES={}
    builder.STAGE='QuickUI50'
    builder.OUT=builder.ROOT/'release/development/QuickUI50/FFERPG-QuickUI50-Forsaken.w3x'


if __name__=='__main__':
    configure()
    builder.build()
    release_gear.audit(builder.OUT)

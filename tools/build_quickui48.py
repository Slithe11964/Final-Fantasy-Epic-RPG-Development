"""Build UI48 with authored wave previews and refreshed live/object data."""
import io
from PIL import Image,ImageDraw
import build_dragoon_ui41 as builder
import thousand_cuts
import aqualung_fix
from editor_pair import View
from equipment_integrity import catalogue
from equipment_quickcast import refresh as quickcast_refresh


def target_cursor():
    image=Image.new('RGBA',(64,64))
    draw=ImageDraw.Draw(image)
    for width,color in [(7,(0,0,0,240)),(3,(255,225,80,255))]:
        draw.ellipse((16,16,48,48),outline=color,width=width)
        for start,end in [((32,3),(32,21)),((32,43),(32,60)),((3,32),(21,32)),((43,32),(60,32))]:
            draw.line((start,end),fill=color,width=width)
    result=io.BytesIO()
    image.save(result,format='TGA')
    return result.getvalue()


def configure():
    config=catalogue(View(builder.ROOT/'editor/FFERPG-Editor-Master.w3x'))
    original=builder.refresh
    builder.refresh=lambda s:quickcast_refresh(aqualung_fix.refresh(thousand_cuts.refresh(original(s))),config,native=True)
    original_objects=builder.patch_objects
    def objects(archive):
        files=original_objects(archive)
        files['war3map.w3a'],files['war3mapSkin.w3a']=thousand_cuts.objects(files['war3map.w3a'],files['war3mapSkin.w3a'])
        return files
    builder.patch_objects=objects
    builder.EXTRA_FILES={'QuickGearTarget.tga':target_cursor()}
    builder.STAGE='QuickUI48'
    builder.OUT=builder.ROOT/'release/development/QuickUI48/FFERPG-QuickUI48-Forsaken.w3x'


if __name__=='__main__':
    configure()
    builder.build()

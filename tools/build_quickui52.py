"""Loaded equipment lifecycle, continuous dock redraw, and native bag observers."""
import build_quickui50 as previous
import build_dragoon_ui41 as builder
import gear_refresh52

if __name__=='__main__':
    previous.configure()
    original=builder.refresh
    builder.refresh=lambda source:gear_refresh52.refresh(original(source))
    builder.STAGE='QuickUI52'
    builder.OUT=builder.ROOT/'release/development/QuickUI52/FFERPG-QuickUI52-Forsaken.w3x'
    builder.build()

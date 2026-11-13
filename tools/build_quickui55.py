"""Retain UI54 casting; change only icon repaint scheduling and diagnostics."""
import build_quickui54 as builder
from gear_icons55 import refresh


if __name__=='__main__':
    builder.BASE=builder.ROOT/'release/development/QuickUI54/FFERPG-QuickUI54-Forsaken.w3x'
    builder.OUT=builder.ROOT/'release/development/QuickUI55/FFERPG-QuickUI55-Forsaken.w3x'
    builder.refresh=lambda source,items:refresh(source)
    builder.ALLOWED={'QuickGear_PaintIcon','QuickGear_WheelTick','QuickGear_Diagnostic'}
    # The shared packaging function otherwise writes UI54's map-list label.
    builder.STAGE='QuickUI55'
    builder.build()

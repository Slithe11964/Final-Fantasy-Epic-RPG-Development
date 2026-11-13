import build_dragoon_ui41 as builder
import thousand_cuts
if __name__=='__main__':
 original=builder.refresh
 builder.refresh=lambda source:thousand_cuts.refresh(original(source))
 builder.STAGE='QuickUI45'
 builder.OUT=builder.ROOT/'release/development/QuickUI45/FFERPG-QuickUI45-Forsaken.w3x'
 builder.build()

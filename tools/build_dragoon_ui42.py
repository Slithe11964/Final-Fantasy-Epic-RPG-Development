"""Next native test: rank damage, enemy-target Jump, layout and CDR."""
from pathlib import Path
import build_dragoon_ui41 as builder
if __name__=='__main__':
 builder.STAGE='QuickUI42'
 builder.OUT=builder.ROOT/'release/development/QuickUI42/FFERPG-QuickUI42-Forsaken.w3x'
 builder.build()

"""Keep released controls; fix stale slot state and extend wave rune activation."""
import build_quickui50 as previous
import build_dragoon_ui41 as builder
import gear_load_refresh


if __name__=='__main__':
    previous.configure()
    original=builder.refresh
    builder.refresh=lambda source:gear_load_refresh.refresh(original(source))
    builder.STAGE='QuickUI51'
    builder.OUT=builder.ROOT/'release/development/QuickUI51/FFERPG-QuickUI51-Forsaken.w3x'
    builder.build()

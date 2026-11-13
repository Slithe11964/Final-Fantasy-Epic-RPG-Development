"""Remove UI52's mutations/frame walk; recover released input and add tracing."""
import build_quickui50 as previous
import build_dragoon_ui41 as builder
import gear_recovery53
import wave_recovery53

if __name__=='__main__':
    previous.configure()
    original=builder.refresh
    builder.refresh=lambda source:wave_recovery53.refresh(gear_recovery53.refresh(original(source)))
    builder.STAGE='QuickUI53'
    builder.OUT=builder.ROOT/'release/development/QuickUI53/FFERPG-QuickUI53-Forsaken.w3x'
    builder.build()

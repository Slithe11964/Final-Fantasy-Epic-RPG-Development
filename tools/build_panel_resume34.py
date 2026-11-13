from build_gear_layer31 import build,ROOT
from panel_resume34 import refresh

if __name__=='__main__':
    opts=dict(refresh_fn=refresh,expected={'C20_UIPause','C20_UIResume','QuickGear_Diagnostic'},added_globals=0,scope='Pause existing periodic UI timer by lifetime; restart same timer/callback at original .1 period before optional cinematic UI restore. Add explicit timer diagnostic. No new timer, inventory discovery, casting, save or gameplay changes.')
    build(ROOT/'release/development/H20261110UI05/FFERPG-0.9.7.5h-UI05.w3x',ROOT/'release/development/H20261110UI06/FFERPG-0.9.7.5h-UI06.w3x','FFERPG 0.9.7.5h UI06','h UI05','h UI06',**opts)
    build(ROOT/'release/development/V33/FFERPG-V33.w3x',ROOT/'release/development/V34/FFERPG-V34.w3x','FFERPG V34','V33','V34',**opts)

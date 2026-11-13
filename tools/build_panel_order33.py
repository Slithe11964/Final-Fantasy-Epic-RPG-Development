from build_gear_layer31 import build,ROOT
from panel_order33 import refresh

if __name__=='__main__':
    opts=dict(refresh_fn=refresh,expected={'UI72_Tick','QuickGear_Diagnostic'},added_globals=0,scope='Run existing isolated panel observer before gear helpers; append explicit diagnostic native cache/context/gate readout. No new timers, frame discovery, item mutation, casting or save changes.')
    build(ROOT/'release/development/H20261110UI04/FFERPG-0.9.7.5h-UI04.w3x',ROOT/'release/development/H20261110UI05/FFERPG-0.9.7.5h-UI05.w3x','FFERPG 0.9.7.5h UI05','h UI04','h UI05',**opts)
    build(ROOT/'release/development/V32/FFERPG-V32.w3x',ROOT/'release/development/V33/FFERPG-V33.w3x','FFERPG V33','V32','V33',**opts)

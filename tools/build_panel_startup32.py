from build_gear_layer31 import build,ROOT
from panel_startup32 import refresh

if __name__=='__main__':
    options=dict(refresh_fn=refresh,expected={'Register_Forsaken_PanelAccess','Forsaken_RegisterBackpackActivity','QuickGear_Diagnostic'},added_globals=0,scope='Separate existing UI setup calls with ExecuteFunc; correct debug registration; append on-demand setup/cache diagnostics. All gear rendering, panel visibility, item, input, save and gameplay functions unchanged.')
    build(ROOT/'release/development/H20261110UI03/FFERPG-0.9.7.5h-UI03.w3x',ROOT/'release/development/H20261110UI04/FFERPG-0.9.7.5h-UI04.w3x','FFERPG 0.9.7.5h UI04','h UI03','h UI04',**options)
    build(ROOT/'release/development/V31/FFERPG-V31.w3x',ROOT/'release/development/V32/FFERPG-V32.w3x','FFERPG V32','V31','V32',**options)

"""Pin the owner-confirmed F/G implementation to the named 0.9.7.5e release."""
import re
from functools import lru_cache
from pathlib import Path
from editor_pair import View,decls
from jtok import functions,tokens
from gameplay_runtime import dependency

ROOT=Path(__file__).resolve().parents[1]
REFERENCE=ROOT/'release/0.9.7.5e/FFERPG-0.9.7.5e-Forsaken.w3x'


@lru_cache(maxsize=1)
def reference():
    return View(REFERENCE)


def refresh(source):
    if 'Forsaken_PollPanels' not in functions(source):return source
    source=dependency(dependency(source,'TItemCooldown'),'TTravel')
    pinned=reference().modules['TEquip']
    wanted={name:body for name,body in functions(pinned).items() if name.startswith('QuickGear_')}
    for name in functions(source):
        if name.startswith(('QuickGear_','Gear_')):
            source=re.sub(r'^function '+name+r' takes[^\n]*\n.*?^endfunction\n*','',source,flags=re.M|re.S)
    pinned_globals={name:line for name,line in decls(pinned).items() if name.startswith('QuickGear')}
    source=re.sub(r'^\s*\w+\s+(?:array\s+)?(?:QuickGear\w+|GearNative|GearFrameData|GearCacheContext|GearWaiting\w*|GearFrameClicks|GearWaterCommands|GearIceCommands)(?:=[^\n]*)?\n','',source,flags=re.M)
    source=source.replace('endglobals','\n'.join('    '+line for line in pinned_globals.values())+'\nendglobals',1)
    source=source.replace('function Forsaken_PanelAccess takes','\n\n'.join(wanted.values())+'\n\nfunction Forsaken_PanelAccess takes',1)
    result=functions(source)
    assert {n for n in result if n.startswith('QuickGear_')}==set(wanted)
    assert all(tokens(result[name])==tokens(body) for name,body in wanted.items())
    return source


def audit(path):
    built=View(path)
    expected=reference()
    a,b=functions(expected.modules['TEquip']),functions(built.modules['TEquip'])
    names={n for n in a if n.startswith('QuickGear_')}
    assert {n for n in b if n.startswith('QuickGear_')}==names
    assert all(tokens(a[n])==tokens(b[n]) for n in names)
    ga={n:v for n,v in decls(expected.modules['TEquip']).items() if n.startswith('QuickGear')}
    gb={n:v for n,v in decls(built.modules['TEquip']).items() if n.startswith('QuickGear')}
    assert ga==gb
    assets=[n for n in expected.archive.read('(listfile)').decode().splitlines() if 'quickgear' in n.lower()]
    assert all(expected.archive.read(n)==built.archive.read(n) for n in assets)
    assert not any(n.startswith('Gear_') for n in b)
    print('PASS released F/G functions, globals and assets match 0.9.7.5e exactly')

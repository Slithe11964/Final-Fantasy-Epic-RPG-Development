"""Replace FF's frame presentation with its AE dialog when targeting Warcraft 1.29.2.

Only the named BazaarFrame_ UI functions and frame globals are removed. The shared
recipe transaction remains byte-for-byte unchanged. Runtime and editor text both use this.
"""
import re
from jtok import functions
from wct import read_wct, write_wct, raw_of, text_of

DIALOG = '''function Bazaar_ShowRecipe takes player p returns nothing
    local integer id=GetPlayerId(p)
    local integer recipe=BazaarSelectedRecipe[id]
    call DialogClear(BazaarDialog[id])
    call DialogSetMessage(BazaarDialog[id],Bazaar_RecipeText(recipe))
    set BazaarPrevious[id]=DialogAddButton(BazaarDialog[id],"Previous recipe",0)
    set BazaarNext[id]=DialogAddButton(BazaarDialog[id],"Next recipe",0)
    set BazaarCraft[id]=DialogAddButton(BazaarDialog[id],"Craft this recipe",0)
    call DialogAddButton(BazaarDialog[id],"Close",0)
    call DialogDisplay(p,BazaarDialog[id],true)
endfunction'''

def convert(text):
    if 'BazaarFrame_Init' not in text:
        return text
    crlf = '\r\n' in text
    text = text.replace('\r\n', '\n')
    bodies = functions(text)
    for name in ['Bazaar_ShowRecipe', 'BazaarFrame_Init', 'Register_Bazaar_FrameSync', 'Bazaar_CraftRecipe']:
        if name not in bodies:
            raise ValueError('incomplete Bazaar frame module: ' + name)
    text = re.sub(r'^\s*framehandle\s+(?:array\s+)?BazaarFrame\w+[^\n]*\n', '', text, flags=re.M)
    text = re.sub(r'(constant boolean BazaarUseFrames\s*=\s*)true\b', r'\1false', text)
    for name, body in bodies.items():
        if name.startswith('BazaarFrame_'):
            header = re.search(r'^\s*(function[^\n]+)', body, re.M)[1]
            if not header.endswith('returns nothing'):
                raise ValueError('unexpected Bazaar UI signature: ' + header)
            replacement = header+'\nendfunction'
        elif name == 'Bazaar_ShowRecipe':
            replacement = DIALOG
        else:
            continue
        text, count = re.subn(r'^\s*function '+name+r'\s+takes.*?^\s*endfunction[^\n]*',
                             lambda m: '\n'+replacement, text, flags=re.M|re.S)
        if count != 1:
            raise ValueError('expected one Bazaar function: ' + name)
    return text.replace('\n', '\r\n') if crlf else text


def convert_wct(data):
    wct = read_wct(data)
    wct['entries'] = [raw_of(convert(text_of(entry))) if 'BazaarFrame_Init' in text_of(entry) else entry
                      for entry in wct['entries']]
    return write_wct(wct)

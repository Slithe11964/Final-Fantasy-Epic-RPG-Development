"""Display-only map identities. Reuse for future test packaging."""
import re,struct
from jtok import tokens
from downgrade import R

def script_labels(source,label,short):
    source=re.sub(r'(\budg_BoardTitlePrefix\s*=\s*)"[^"\r\n]*"',lambda m:m[1]+'"'+label+' - "',source)
    source=re.sub(r'Welcome to Final Fantasy Epic RPG 0\.9\.7\.[0-9]+[a-z]?', 'Welcome to '+label,source)
    source=source.replace('Welcome to |cffffcc00Final Fantasy Epic RPG|r!', 'Welcome to |cffffcc00'+label+'|r!')
    source=re.sub(r'UI\d+ F/G:',short+' F/G:',source)
    source=source.replace('Native inventory: two-player test',label)
    source=source.replace('Creature Review 03s ready.',label+' ready.')
    # Prefix the existing standalone helper's message; no new action/timer.
    match=re.search(r'(function InvCheck_Help takes.*?endfunction)',source,re.S)
    if match:
        body=match[0];index=body.index('"')
        body=body[:index+1]+'|cffffcc00'+label+'|r|n'+body[index+1:]
        source=source[:match.start()]+body+source[match.end():]
    return source

def without_literals(source):
    return tokens(re.sub(r'"(?:\\.|[^"\\])*"','"DISPLAY"',source))

def info_labels(data,label,purpose=None):
    r=R(data);version=r.i();assert version in (25,28,31,32,33,39),version
    r.raw(8)
    if version>=28:r.raw(16)
    start=r.o;values=[r.z() for _ in range(4)];end=r.o
    # Version labeling must not replace the author's map description.
    values[0]=b'TRIGSTR_38788'
    prefix=data[:start]+b''.join(v+b'\0' for v in values)
    # Current maps use v39; preserve every binary field and replace only the
    # loading-screen title/subtitle. Older v25/28/31 layouts are also explicit.
    if version in (25,28,31,39):
        r.raw(32+16+12+1+4)
        if version>=39:r.raw(4)
        loadstart=r.o;loading=[r.z() for _ in range(4)];loadend=r.o
        # Only the version identity; no test rationale or duplicated subtitle.
        loading[2]=label.encode();loading[3]=b''
        return prefix+data[end:loadstart]+b''.join(v+b'\0' for v in loading)+data[loadend:]
    return prefix+data[end:]

"""Reader/writer for war3map.wct (custom-text trigger source). Supports classic version 1
and Reforged subversion 0x80000004, format 1."""
import struct
def read_wct(d):
    sub,=struct.unpack_from('<I',d,0)
    if sub == 1:
        fmt='classic'; o=4
    else:
        assert sub==0x80000004 and struct.unpack_from('<I',d,4)[0]==1, 'unsupported wct'
        fmt='reforged'; o=8
    e=d.index(b'\0',o); comment=d[o:e]; o=e+1
    n,=struct.unpack_from('<I',d,o); o+=4; header=d[o:o+n]; o+=n
    entries=[]; count=None
    if fmt == 'classic':
        count,=struct.unpack_from('<I',d,o); o+=4
    while o<len(d):
        L,=struct.unpack_from('<I',d,o); o+=4; entries.append(d[o:o+L]); o+=L
    assert o==len(d) and (count is None or count==len(entries)), 'invalid wct entry lengths/count'
    return dict(format=fmt,comment=comment,header=header,entries=entries)
def write_wct(w):
    classic=w.get('format')=='classic'
    out=(struct.pack('<I',1) if classic else struct.pack('<II',0x80000004,1))+w['comment']+b'\0'
    out+=struct.pack('<I',len(w['header']))+w['header']
    if classic: out+=struct.pack('<I',len(w['entries']))
    for e in w['entries']: out+=struct.pack('<I',len(e))+e
    return out
def text_of(raw):
    return raw[:-1].decode('utf-8') if raw.endswith(b'\0') else raw.decode('utf-8')
def raw_of(text):
    return (text.encode('utf-8')+b'\0') if text else b''

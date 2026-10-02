"""Reader/writer for war3map.wct (custom-text trigger source). Supports the Reforged
format used by this map (subversion 0x80000004, format 1)."""
import struct
def read_wct(d):
    sub,fmt=struct.unpack_from('<II',d,0)
    assert sub==0x80000004 and fmt==1, 'unsupported wct'
    o=8; e=d.index(b'\0',o); comment=d[o:e]; o=e+1
    n,=struct.unpack_from('<I',d,o); o+=4; header=d[o:o+n]; o+=n
    entries=[]
    while o<len(d):
        L,=struct.unpack_from('<I',d,o); o+=4; entries.append(d[o:o+L]); o+=L
    return dict(comment=comment,header=header,entries=entries)
def write_wct(w):
    out=struct.pack('<II',0x80000004,1)+w['comment']+b'\0'
    out+=struct.pack('<I',len(w['header']))+w['header']
    for e in w['entries']: out+=struct.pack('<I',len(e))+e
    return out
def text_of(raw):
    return raw[:-1].decode('utf-8') if raw.endswith(b'\0') else raw.decode('utf-8')
def raw_of(text):
    return (text.encode('utf-8')+b'\0') if text else b''

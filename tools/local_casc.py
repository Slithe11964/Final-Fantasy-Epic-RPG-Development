"""Read-only access to installed Warcraft assets; never writes to game storage."""
import ctypes as c
from pathlib import Path

class LocalCasc:
    def __init__(self):
        candidates=[Path.home()/'Chat GPT Projects/tools/vendor/casclib/runtimes/win-x64/native/CascLib.dll']
        dll=next(p for p in candidates if p.exists())
        self.lib=c.WinDLL(str(dll),use_last_error=True)
        defs={
            'CascOpenStorage':([c.c_void_p,c.c_uint32,c.POINTER(c.c_void_p)],c.c_bool),
            'CascOpenFile':([c.c_void_p,c.c_char_p,c.c_uint32,c.c_uint32,c.POINTER(c.c_void_p)],c.c_bool),
            'CascGetFileSize':([c.c_void_p,c.POINTER(c.c_uint32)],c.c_uint32),
            'CascReadFile':([c.c_void_p,c.c_void_p,c.c_uint32,c.POINTER(c.c_uint32)],c.c_bool),
            'CascCloseFile':([c.c_void_p],c.c_bool),'CascCloseStorage':([c.c_void_p],c.c_bool),
            'CascFindFirstFile':([c.c_void_p,c.c_char_p,c.c_void_p,c.c_char_p],c.c_void_p),
            'CascFindNextFile':([c.c_void_p,c.c_void_p],c.c_bool),'CascFindClose':([c.c_void_p],c.c_bool)}
        for name,(args,result) in defs.items():
            f=getattr(self.lib,name);f.argtypes=args;f.restype=result
        self.storage=c.c_void_p()
        assert self.lib.CascOpenStorage(c.c_char_p(b'C:\\Program Files (x86)\\Warcraft III'),2,c.byref(self.storage)),c.get_last_error()

    def read(self,name):
        h=c.c_void_p()
        if not self.lib.CascOpenFile(self.storage,name.encode(),2,0,c.byref(h)):return None
        try:
            high=c.c_uint32();size=self.lib.CascGetFileSize(h,c.byref(high))
            if size==0xffffffff or high.value:raise ValueError(name)
            buf=c.create_string_buffer(size);got=c.c_uint32()
            assert self.lib.CascReadFile(h,buf,size,c.byref(got)) and got.value==size,name
            return buf.raw
        finally:self.lib.CascCloseFile(h)

    def names(self,mask='*'):
        buf=c.create_string_buffer(8192)
        h=self.lib.CascFindFirstFile(self.storage,mask.encode(),buf,None)
        if not h or h==c.c_void_p(-1).value:return []
        result=[]
        try:
            while True:
                result.append(buf.value.decode('utf-8','replace'))
                if not self.lib.CascFindNextFile(h,buf):break
        finally:self.lib.CascFindClose(h)
        return result

    def head(self,name,count=8):
        h=c.c_void_p()
        if not self.lib.CascOpenFile(self.storage,name.encode(),2,0,c.byref(h)):return None
        try:
            buf=c.create_string_buffer(count);got=c.c_uint32()
            if not self.lib.CascReadFile(h,buf,count,c.byref(got)):return None
            return buf.raw[:got.value]
        finally:self.lib.CascCloseFile(h)

    def close(self):self.lib.CascCloseStorage(self.storage)

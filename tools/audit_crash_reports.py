"""Read local Warcraft reports; collect crash/map identities without modifying them."""
import json,re
from pathlib import Path

def audit(root):
    rows=[]
    for path in sorted(Path(root).glob('*/Crash.txt'),reverse=True):
        text=path.read_text(errors='replace')
        summary=re.search(r'<Exception.Summary:>\s*(.*?)\s*<:Exception.Summary>',text,re.S)
        base=re.search(r'DBG-MODULE<([0-9A-Fa-f]+) [^\n]*"Warcraft III.exe"',text)
        stack=re.search(r'<Exception.Assertion:>\s*(.*?)\s*<:Exception.Assertion>',text,re.S)
        addresses=re.findall(r'DBG-ADDR<([0-9A-Fa-f]+)>\("Warcraft III.exe"\)',stack[1] if stack else '')
        map=re.search(r'^<Map>\s*(.*)',text,re.M)
        rows.append(dict(report=str(path),map=map[1].strip() if map else None,
            summary=summary[1].split(' DBG-OPTIONS')[0] if summary else None,
            offsets=[hex(int(a,16)-int(base[1],16)) for a in addresses] if base else []))
    return rows

if __name__=='__main__':
    print(json.dumps(audit(Path.home()/'Documents/Warcraft III/Errors'),indent=2))

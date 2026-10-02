import re
OPEN=re.compile(r'^(if\b.*\bthen|loop)\s*(//.*)?$')
MID=re.compile(r'^(else|elseif\b.*\bthen)\s*(//.*)?$')
CLOSE=re.compile(r'^(endif|endloop)\b')
def reindent_function(text, drop_blank=True, unit='    '):
    """Re-indent a JASS function: body at one level, nested if/loop blocks deeper."""
    lines=text.replace('\r\n','\n').split('\n')
    out=[]; depth=0
    for i,raw in enumerate(lines):
        s=raw.strip()
        if not s:
            if not drop_blank: out.append('')
            continue
        if re.match(r'^(constant\s+)?function\b',s): out.append(s); depth=1; continue
        if re.match(r'^endfunction\b',s): out.append(s); depth=0; continue
        if CLOSE.match(s): depth-=1; out.append(unit*depth+s); continue
        if MID.match(s): out.append(unit*(depth-1)+s); continue
        out.append(unit*depth+s)
        if OPEN.match(s): depth+=1
    return '\n'.join(out)
def blank_ratio(text):
    body=text.replace('\r\n','\n').split('\n')[1:-1]
    return (sum(1 for l in body if not l.strip())/len(body)) if body else 0

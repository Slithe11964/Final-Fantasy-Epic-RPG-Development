import re
TOK=re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|\$[0-9A-Fa-f]+|0[xX][0-9A-Fa-f]+|\d+\.\d*|\.\d+|\d+|\w+|==|!=|<=|>=|[^\s\w]')
def strip_comments(s):
    out=[];i=0
    for line in s.split('\n'):
        # remove // comments not inside strings
        res='';inq=None;j=0
        while j<len(line):
            c=line[j]
            if inq:
                res+=c
                if c=='\\': res+=line[j+1:j+2]; j+=2; continue
                if c==inq: inq=None
            else:
                if c in '"\'': inq=c
                elif line.startswith('//',j): break
                res+=c
            j+=1
        out.append(res)
    return '\n'.join(out)
def norm_num(t):
    try:
        if t.startswith('$'): return str(int(t[1:],16))
        if t[:2] in('0x','0X'): return str(int(t[2:],16))
        if re.fullmatch(r'\d+',t): return str(int(t))
        if re.fullmatch(r'\d+\.\d*|\.\d+',t): return repr(float(t))
    except: pass
    return t
def tokens(s,normalize=True):
    t=TOK.findall(strip_comments(s.replace('\r\n','\n')))
    return [norm_num(x) for x in t] if normalize else t
FUNC=re.compile(r'^\s*(?:constant\s+)?function\s+(\w+)\s+takes.*?^\s*endfunction[^\n]*$',re.M|re.S)
def functions(s):
    return {m.group(1):m.group(0) for m in FUNC.finditer(s.replace('\r\n','\n'))}

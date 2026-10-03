"""Remove the step-by-step calculation comments on simple lines.

    python tools/refactor/trim_calc_comments.py report
    python tools/refactor/trim_calc_comments.py apply [--min-ops N]

The GUI-to-text conversion left a word-for-word comment above every calculation:
    // (udg_TempInteger) plus (1).
    // Calculation 1: ... / Result 1: ... / Increase X by 6. / Starting value for l_x:
On a line like `set x=x+5` or `GetRandomInt(1,10)` that only repeats the code. This keeps those comments
only where the line has real arithmetic: at least N (default 3) arithmetic operators per computed value. Comments written
as explanations (plain sentences) are never touched. Only comment lines change; the tokens of every
module stay identical (checked).
"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.dirname(HERE))
from jtok import tokens, strip_comments

GEN = re.compile(r'^(\(|Calculation \d+:|Result \d+:|Starting value for |Increase |Decrease |Udg_\w+ treated as|'
                 r'The straight-line distance between )')
OPERAND_END = re.compile(r'[\w\)\]\.]$')

def ops(code):
    code = re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'', 'S', strip_comments(code))
    if '=' in code and code.lstrip().startswith(('set ', 'local ')):
        code = code.split('=', 1)[1]
    n, prev = 0, ''
    for t in re.findall(r'\w+|\.\d+|[-+*/]|\S', code):
        if t in '+-*/' and OPERAND_END.search(prev or ''):
            n += 1
        prev = t
    return n

def process(text, min_ops):
    lines = text.split('\n')
    out, removed, kept = [], 0, 0
    i = 0
    while i < len(lines):
        if not lines[i].strip().startswith('//'):
            out.append(lines[i]); i += 1; continue
        j = i
        while j < len(lines) and lines[j].strip().startswith('//'):
            j += 1
        block = lines[i:j]
        nxt = lines[j] if j < len(lines) else ''
        # mark generated lines (and the wrapped continuations of generated lines)
        gen, prev_gen_open = [], False
        for ln in block:
            t = ln.strip()[2:].strip()
            g = bool(GEN.match(t)) or prev_gen_open
            gen.append(g)
            prev_gen_open = g and not t.endswith(('.', ':'))
        # a line computing several values (Calculation 1, 2, 3 ...) is judged per value
        parts = max(1, sum(1 for ln in block if re.match(r'\s*//\s*Calculation \d+:', ln)))
        simple = nxt.strip() and not nxt.strip().startswith('//') and ops(nxt) / parts < min_ops
        for ln, g in zip(block, gen):
            if g and simple:
                removed += 1
            else:
                out.append(ln)
                kept += g
        i = j
    return '\n'.join(out), removed, kept

def files():
    for d, _, fs in os.walk(os.path.join(ROOT, 'src', 'triggers')):
        for f in sorted(fs):
            if f.endswith('.j'):
                yield os.path.join(d, f)

def main():
    min_ops = int(sys.argv[sys.argv.index('--min-ops') + 1]) if '--min-ops' in sys.argv else 3
    tr = tk = nf = 0
    for p in files():
        raw = open(p, 'rb').read(); crlf = b'\r\n' in raw
        text = raw.decode('utf-8').replace('\r\n', '\n')
        new, r, k = process(text, min_ops)
        tr += r; tk += k
        if r and sys.argv[1] == 'apply':
            assert tokens(new) == tokens(text), p
            open(p, 'wb').write((new.replace('\n', '\r\n') if crlf else new).encode('utf-8'))
            nf += 1
    print('calculation comment lines removed: %d, kept (complex lines): %d, files changed: %d' % (tr, tk, nf))

if __name__ == '__main__':
    main()

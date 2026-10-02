"""Phase 1 (formatting only). Kept as a record of exactly what changed.

* Re-indents the 1,607 functions that were double-spaced and unindented by earlier
  generators (trigger registration helpers, main_old and four Units_* setup functions).
* Removes the 8 auto-generated "Calculation N" comments on main_old's camera-bounds line.
Verifies every trigger file keeps exactly the same code tokens (comments excluded).
"""
import glob, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from jfmt import reindent_function, blank_ratio
from jtok import tokens, FUNC

def fix_text(text):
    lf = text.replace('\r\n', '\n')
    changed = []
    def repl(m):
        f = m.group(0)
        body = f.split('\n')
        if len(body) > 4 and blank_ratio(f) >= 0.4:
            changed.append(m.group(1))
            out = reindent_function(f, drop_blank=True)
            if m.group(1) == 'main_old':
                lines = out.split('\n'); keep = []; skip = False
                for l in lines:
                    s = l.strip()
                    if re.match(r'^// Calculation \d+:$', s):
                        skip = True; continue
                    if skip and re.match(r'^// \(.*\)\.$', s):
                        continue
                    skip = False; keep.append(l)
                out = '\n'.join(keep)
            return out
        return f
    new = FUNC.sub(repl, lf)
    assert tokens(new) == tokens(lf), 'token change!'
    return new.replace('\n', '\r\n'), changed

if __name__ == '__main__':
    src = sys.argv[1]
    total = []
    for path in sorted(glob.glob(os.path.join(src, 'triggers', '*', '*.j'))):
        text = open(path, encoding='utf-8', newline='').read()
        new, changed = fix_text(text)
        if changed:
            open(path, 'w', encoding='utf-8', newline='').write(new)
            total += changed
    print('reformatted functions:', len(total))

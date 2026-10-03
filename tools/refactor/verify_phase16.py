"""Check a phase-16 map against its base: every changed function must be the base function with
shared udg_Temp* variables turned into locals and nothing else. Undoing the change (dropping the new
`local <type> l_tempX` lines and the `set l_tempX=null` lines, renaming l_tempX back to udg_TempX)
must give the base function token for token.

    python tools/refactor/verify_phase16.py BASE.w3x NEW.w3x     compare two playable scripts
    python tools/refactor/verify_phase16.py --src [GIT_REV]        compare src/triggers with a Git revision (default HEAD)

Compare NEW with a map built the same way from the unchanged sources (sync_module.py), not with an
editor-saved map: JassHelper inlines one-line functions and sync_module's compiler doesn't.
"""
import re, sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from jtok import functions, tokens, strip_comments
from startup_audit import load_script

def undo(ftext):
    keep = []
    for ln in ftext.split('\n'):
        c = strip_comments(ln).strip()
        if re.fullmatch(r'local\s+\w+\s+l_temp\w+', c) or re.fullmatch(r'set\s+l_temp\w+\s*=\s*null', c):
            continue
        keep.append(ln)
    return re.sub(r'\bl_temp(\w+?)(?:_\d+)?\b', r'udg_Temp\1', '\n'.join(keep))

def main(a, b):
    fa, fb = functions(load_script(a)), functions(load_script(b))
    if set(fa) != set(fb):
        sys.exit('function lists differ: +%s -%s' % (sorted(set(fb) - set(fa))[:5], sorted(set(fa) - set(fb))[:5]))
    changed = bad = 0
    for n in fa:
        if tokens(fa[n]) == tokens(fb[n]):
            continue
        changed += 1
        if tokens(undo(fb[n])) != tokens(fa[n]):
            bad += 1
            print('NOT a pure temp-to-local change:', n)
    print('%d functions, %d changed, %d changed in some other way' % (len(fa), changed, bad))
    return bad == 0

def main_src(rev='HEAD'):
    import subprocess
    root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    files = subprocess.run(['git', 'diff', '--name-only', rev, '--', 'src/triggers'], cwd=root, capture_output=True, text=True).stdout.split('\n')
    changed = bad = 0
    for f in filter(None, files):
        old = subprocess.run(['git', 'show', '%s:%s' % (rev, f)], cwd=root, capture_output=True, text=True, encoding='utf-8').stdout
        new = open(os.path.join(root, f), encoding='utf-8').read()
        fa, fb = functions(old), functions(new)
        if set(fa) != set(fb):
            print('function list changed in', f); bad += 1; continue
        for n in fa:
            if tokens(fa[n]) != tokens(fb[n]):
                changed += 1
                if tokens(undo(fb[n])) != tokens(fa[n]):
                    bad += 1; print('NOT a pure temp-to-local change:', n)
        rest_a = tokens(re.sub(r'(?ms)^\s*function\s.*?^\s*endfunction', '', old))
        rest_b = tokens(re.sub(r'(?ms)^\s*function\s.*?^\s*endfunction', '', new))
        if rest_a != rest_b:
            bad += 1; print('code outside functions changed in', f)
    print('source: %d files, %d functions changed, %d changed in some other way' % (len([x for x in files if x]), changed, bad))
    return bad == 0

if __name__ == '__main__':
    if sys.argv[1] == '--src':
        sys.exit(0 if main_src(*sys.argv[2:3]) else 1)
    sys.exit(0 if main(sys.argv[1], sys.argv[2]) else 1)

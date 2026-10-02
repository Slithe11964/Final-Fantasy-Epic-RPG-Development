"""Compare every function of two playable scripts (war3map.j). Reports functions that were added,
removed or changed. Startup-family functions are left to startup_audit.py; local renames can be
declared as OLD=NEW pairs per function with --rename FUNC:old=new,old=new."""
import sys, os, re, json
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from jtok import functions, tokens
from startup_audit import load_script
STARTUP = re.compile(r'^(main_old|Startup_\w+|RegisterTriggers_\w+|Register_\w+|RegisterR11_\w+)$')
def main(a, b, renames):
    fa, fb = functions(load_script(a)), functions(load_script(b))
    added = sorted(set(fb) - set(fa)); removed = sorted(set(fa) - set(fb))
    changed = []
    for n in sorted(set(fa) & set(fb)):
        if STARTUP.match(n):
            continue
        tb = tokens(fb[n])
        if n in renames:
            inv = {v: k for k, v in renames[n].items()}
            tb = [inv.get(t, t) for t in tb]
        if tokens(fa[n]) != tb:
            changed.append(n)
    r = dict(functions_before=len(fa), functions_after=len(fb), added=[x for x in added if not STARTUP.match(x)],
             removed=[x for x in removed if not STARTUP.match(x)], changed_non_startup=changed)
    print(json.dumps(r, indent=1))
    return r
if __name__ == '__main__':
    ren = {}
    for arg in sys.argv[3:]:
        f, pairs = arg.split(':', 1)
        ren[f] = dict(p.split('=') for p in pairs.split(','))
    r = main(sys.argv[1], sys.argv[2], ren)
    sys.exit(1 if r['added'] or r['removed'] or r['changed_non_startup'] else 0)

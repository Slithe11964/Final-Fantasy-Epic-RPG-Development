"""Put the libraries of a map's playable script (war3map.j) in an order JASS accepts, without a World Editor save.

    python tools/order_libraries.py IN_MAP.w3x OUT_MAP.w3x

JASS only lets a function call functions defined above it. World Editor (JassHelper) orders libraries by
their `requires`; tools/sync_module.py and add_module.py keep a library where it already is, so a library
that starts using another one placed below it (e.g. a quest module that now calls the quest engine) would
not compile. This tool reads which library calls which (direct calls in the compiled code) and moves as few
libraries as possible: the order stays the same except that every library comes after the libraries it
calls. ExecuteFunc("Name") calls are by name and need no order.
Code outside the `//library X:` ... `//library X ends` blocks (triggers, main, config) is left as it is.
"""
import heapq, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ, replace_files, compact
from jtok import strip_comments

BLOCK = re.compile(r'^//library (\w+):\n.*?^//library \1 ends\n', re.M | re.S)
FUNC = re.compile(r'^(?:constant\s+)?function\s+(\w+)', re.M)

def order(rt):
    blocks = list(BLOCK.finditer(rt))
    if not blocks:
        return rt, []
    start, end = blocks[0].start(), blocks[-1].end()
    if any(blocks[i].end() != blocks[i + 1].start() for i in range(len(blocks) - 1)):
        # keep any text between blocks attached to the block that follows it
        pass
    names = [b.group(1) for b in blocks]
    texts = []
    prev = start
    for b in blocks:
        texts.append(rt[prev:b.end()])
        prev = b.end()
    owner = {}
    for i, b in enumerate(blocks):
        for f in FUNC.findall(b.group(0)):
            owner[f] = i
    deps = [set() for _ in blocks]
    for i, b in enumerate(blocks):
        code = strip_comments(b.group(0))
        code = re.sub(r'"(?:\\.|[^"\\])*"', '""', code)
        for w in set(re.findall(r'\b(\w+)\s*\(', code)) | set(re.findall(r'\bfunction\s+(\w+)', code)):
            j = owner.get(w)
            if j is not None and j != i:
                deps[i].add(j)
    users = [set() for _ in blocks]
    for i, d in enumerate(deps):
        for j in d:
            users[j].add(i)
    need = [len(d) for d in deps]
    ready = [i for i in range(len(blocks)) if need[i] == 0]
    heapq.heapify(ready)
    out = []
    while ready:
        i = heapq.heappop(ready)
        out.append(i)
        for u in users[i]:
            need[u] -= 1
            if need[u] == 0:
                heapq.heappush(ready, u)
    if len(out) != len(blocks):
        stuck = [names[i] for i in range(len(blocks)) if need[i] > 0]
        sys.exit('libraries call each other in a circle: %s' % ', '.join(stuck[:10]))
    moved = [names[i] for k, i in enumerate(out) if i != k]
    return rt[:start] + ''.join(texts[i] for i in out) + rt[end:], moved

def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    src, dst = sys.argv[1:]
    if os.path.exists(dst):
        sys.exit('output exists: ' + dst)
    raw = MPQ(src).read('war3map.j')
    crlf = b'\r\n' in raw
    rt = raw.decode('utf-8').replace('\r\n', '\n')
    new, moved = order(rt)
    out = new.replace('\n', '\r\n') if crlf else new
    tmp = dst + '.tmp'
    replace_files(src, tmp, {'war3map.j': out.encode('utf-8')})
    compact(tmp, dst); os.remove(tmp)
    print('%d libraries changed place' % len(moved) + (': ' + ', '.join(moved[:20]) + (' ...' if len(moved) > 20 else '') if moved else ''))

if __name__ == '__main__':
    main()

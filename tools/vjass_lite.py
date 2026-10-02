"""A small stand-in for JassHelper, used only for automated compile checks.

It understands the vJass features this map uses (library/endlibrary with `requires`, and
library-level globals blocks), orders libraries the way JassHelper does (alphabetical
depth-first over `requires`), and produces plain JASS that pjass can check.
World Editor + JassHelper remain the real compiler; this lets tools catch mistakes early.
"""
import re

LIB_RE = re.compile(r'^[ \t]*library\s+(\w+)(?:\s+(?:requires|needs|uses)\s+([^\r\n/]*))?[^\n]*\n(.*?)^[ \t]*endlibrary[^\n]*\n?', re.M | re.S)
GLOBALS_RE = re.compile(r'^[ \t]*globals[ \t]*\n(.*?)^[ \t]*endglobals[^\n]*\n?', re.M | re.S)

def split_libraries(texts):
    libs, order, rest = {}, [], []
    for t in texts:
        t = t.replace('\r\n', '\n')
        pos = 0
        for m in LIB_RE.finditer(t):
            rest.append(t[pos:m.start()])
            reqs = [r.strip() for r in (m.group(2) or '').split(',') if r.strip()]
            if m.group(1) in libs:
                raise ValueError('library declared twice: ' + m.group(1))
            libs[m.group(1)] = dict(requires=reqs, body=m.group(3))
            order.append(m.group(1))
            pos = m.end()
        rest.append(t[pos:])
    return libs, order, rest

def jasshelper_order(libs):
    seen, out = set(), []
    def visit(name, chain=()):
        if name not in libs:
            raise ValueError('missing required library %s (needed by %s)' % (name, chain[-1] if chain else '?'))
        if name in chain:
            raise ValueError('library requirement cycle: ' + ' -> '.join(chain + (name,)))
        if name in seen:
            return
        for r in sorted(libs[name]['requires']):
            visit(r, chain + (name,))
        seen.add(name)
        out.append(name)
    for name in sorted(libs):
        visit(name)
    return out

def flatten(header, trigger_texts, extra_globals='', tail=''):
    """Return plain JASS: one globals block, then libraries, then other trigger code."""
    header = header.replace('\r\n', '\n')
    hm = GLOBALS_RE.search(header)
    header_globals = hm.group(1) if hm else ''
    header_code = (header[:hm.start()] + header[hm.end():]) if hm else header
    libs, _, rest = split_libraries(trigger_texts)
    order = jasshelper_order(libs)
    lib_globals, lib_code = [], []
    for name in order:
        body = libs[name]['body']
        lib_globals.append('constant boolean LIBRARY_%s=true\n' % name)
        for gm in GLOBALS_RE.finditer(body):
            lib_globals.append(gm.group(1))
        body = GLOBALS_RE.sub('', body)
        body = re.sub(r'^([ \t]*)(?:private|public)\s+(function|constant)', r'\1\2', body, flags=re.M)
        lib_code.append('//library %s:\n%s//library %s ends\n' % (name, body, name))
    rest_code = '\n'.join(rest)
    if re.search(r'^\s*(struct|scope|module|interface|method)\b', rest_code + ''.join(lib_code), re.M):
        raise ValueError('vJass feature not supported by vjass_lite (struct/scope/module/method)')
    # JassHelper order: library globals, then World Editor generated globals, then the map header's
    return ('globals\n' + ''.join(lib_globals) + extra_globals + header_globals + 'endglobals\n'
            + header_code + '\n' + ''.join(lib_code) + rest_code + '\n' + tail), order

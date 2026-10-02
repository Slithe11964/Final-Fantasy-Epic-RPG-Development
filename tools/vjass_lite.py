"""A small stand-in for JassHelper, used only for automated compile checks.

It understands the vJass features this map uses (library/endlibrary with `requires` and
`requires optional`, library-level globals blocks, and `static if LIBRARY_X then` blocks), orders libraries the way JassHelper does (alphabetical
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
            reqs, optional = [], set()
            for r in (m.group(2) or '').split(','):
                r = r.strip()
                if r.startswith('optional '):
                    r = r[len('optional '):].strip()
                    optional.add(r)
                if r:
                    reqs.append(r)
            if m.group(1) in libs:
                raise ValueError('library declared twice: ' + m.group(1))
            libs[m.group(1)] = dict(requires=reqs, optional=optional, body=m.group(3))
            order.append(m.group(1))
            pos = m.end()
        rest.append(t[pos:])
    return libs, order, rest

def jasshelper_order(libs, lenient=False):
    seen, out = set(), []
    def visit(name, chain=()):
        if name not in libs:
            raise ValueError('missing required library %s (needed by %s)' % (name, chain[-1] if chain else '?'))
        if name in chain:
            raise ValueError('library requirement cycle: ' + ' -> '.join(chain + (name,)))
        if name in seen:
            return
        for r in sorted(libs[name]['requires']):
            if r not in libs and (lenient or r in libs[name].get('optional', ())):
                continue
            visit(r, chain + (name,))
        seen.add(name)
        out.append(name)
    for name in sorted(libs):
        visit(name)
    return out

STATIC_IF = re.compile(r'^\s*static\s+if\s+(.*?)\s+then\s*(?://.*)?$')

def eval_static(expr, present):
    py = re.sub(r'\bLIBRARY_(\w+)\b', lambda m: 'True' if m.group(1) in present else 'False', expr)
    py = re.sub(r'\btrue\b', 'True', re.sub(r'\bfalse\b', 'False', py))
    if re.search(r'[^\sA-Za-z()]', py) or set(re.findall(r'[A-Za-z]+', py)) - {'True', 'False', 'and', 'or', 'not'}:
        raise ValueError('unsupported static if expression: ' + expr)
    return eval(py)

def resolve_static_ifs(text, present):
    """Keep or drop `static if` blocks the way JassHelper does, given the libraries present."""
    if 'static' not in text:
        return text
    out, stack = [], []          # stack entries: [is_static, keep_this_branch, parent_keep]
    def keeping():
        return all(e[1] for e in stack if e[0]) if stack else True
    for line in text.split('\n'):
        s = line.strip()
        m = STATIC_IF.match(line)
        if m:
            stack.append([True, eval_static(m.group(1), present)])
            continue
        if re.match(r'^if\b|^if\(', s) and re.search(r'\bthen\s*(//.*)?$', s):
            stack.append([False, True])
        elif re.match(r'^endif\b', s):
            if not stack:
                raise ValueError('endif without if')
            e = stack.pop()
            if e[0]:
                continue
        elif re.match(r'^else\s*(//.*)?$', s) and stack and stack[-1][0]:
            stack[-1][1] = not stack[-1][1]
            continue
        if keeping():
            out.append(line)
    if stack:
        raise ValueError('unclosed if/static if block')
    return '\n'.join(out)

def flatten(header, trigger_texts, extra_globals='', tail='', lenient=False):
    """Return plain JASS: one globals block, then libraries, then other trigger code."""
    header = header.replace('\r\n', '\n')
    hm = GLOBALS_RE.search(header)
    header_globals = hm.group(1) if hm else ''
    header_code = (header[:hm.start()] + header[hm.end():]) if hm else header
    libs, _, rest = split_libraries(trigger_texts)
    order = jasshelper_order(libs, lenient)
    present = set(libs)
    for name in libs:
        libs[name]['body'] = resolve_static_ifs(libs[name]['body'], present)
    rest = [resolve_static_ifs(r, present) for r in rest]
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

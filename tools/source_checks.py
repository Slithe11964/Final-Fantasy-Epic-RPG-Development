"""Shared, read-only source/map inspection for development gates."""
from pathlib import Path
import hashlib
import json
import re

from jtok import functions, strip_comments, tokens
from mpq import MPQ
from vjass_lite import split_libraries, resolve_static_ifs, GLOBALS_RE
from wct import read_wct, text_of
from wtg import read_wtg

ROOT = Path(__file__).resolve().parents[1]


def sources(root=ROOT):
    entries = json.loads((root / 'src/trigger-list.json').read_text(encoding='utf-8'))
    texts = {e['name']: (root / 'src/triggers' / e['folder'] / (e['name'] + '.j')).read_text(encoding='utf-8')
             for e in entries if e.get('library')}
    return entries, texts


def map_sources(path):
    archive = MPQ(str(path))
    wct = read_wct(archive.read('war3map.wct'))
    off = {e['name'] for e in read_wtg(archive.read('war3map.wtg'))['items']
           if e.get('kind') == 8 and not e.get('enabled', 1)}
    return archive, wct, off


def arguments(text):
    out, current, depth = [], [], 0
    for token in tokens(text, normalize=False):
        if token == ',' and depth == 0:
            out.append(''.join(current)); current = []
        else:
            current.append(token)
            depth += (token in ('(', '[')) - (token in (')', ']'))
    if current:
        out.append(''.join(current))
    return out


def calls(body):
    """Calls by line, with balanced argument parsing; comments and quoted commas are safe."""
    for number, line in enumerate(strip_comments(body).splitlines(), 1):
        match = re.search(r'\b(?:call\s+|=\s*)(\w+)\s*\((.*)\)\s*$', line)
        if match:
            yield number, match[1], arguments(match[2])


def invocations(body):
    """Every call expression, including nested arguments, conditions and returns."""
    stream = tokens(body, normalize=False)
    for i in range(len(stream) - 1):
        if not re.fullmatch(r'\w+', stream[i]) or stream[i + 1] != '(':
            continue
        depth, end = 1, i + 2
        while end < len(stream) and depth:
            depth += (stream[end] == '(') - (stream[end] == ')')
            end += 1
        if depth == 0:
            yield stream[i], arguments(' '.join(stream[i + 2:end - 1]))


def literal_int(value):
    if re.fullmatch(r'\$[0-9a-fA-F]+', value):
        return int(value[1:], 16)
    if re.fullmatch(r'-?\d+', value):
        return int(value)
    if re.fullmatch(r"'[^']'", value):
        return ord(value[1])
    return None


def literal_string(value):
    return value[1:-1] if re.fullmatch(r'"(?:\\.|[^"\\])*"', value) else None


def fingerprint(text):
    return hashlib.sha256(json.dumps(tokens(text), separators=(',', ':')).encode()).hexdigest()


def runtime_agreement(path, root=ROOT, capture=None):
    """Every enabled library function must match its source, after static-if resolution."""
    archive, wct, off = map_sources(path)
    entries, texts = sources(root)
    runtime = archive.read('war3map.j').decode('utf-8').replace('\r\n', '\n')
    present = set(re.findall(r'^constant boolean LIBRARY_(\w+)=true$', runtime, re.M))
    actual = functions(runtime)
    contract_path = root / 'tools/contracts/runtime-baseline-differences.json'
    contract = json.loads(contract_path.read_text(encoding='utf-8'))['functions'] if contract_path.exists() else {}
    observed = {}
    errors, checked = [], 0
    for entry in entries:
        if not entry.get('library') or entry['name'] in off:
            continue
        name, library = entry['name'], entry['library']
        if library not in present:
            errors.append(f'{name}: enabled source library missing from runtime'); continue
        text = texts[name]
        if len(wct['entries']) <= entry['index'] or tokens(text_of(wct['entries'][entry['index']])) != tokens(text):
            errors.append(f'{name}: repository source differs from embedded editor source')
        libs, _, _ = split_libraries([text])
        body = resolve_static_ifs(libs[library]['body'], present)
        body = GLOBALS_RE.sub('', body)
        body = re.sub(r'^([ \t]*)(?:private|public)\s+(function|constant)', r'\1\2', body, flags=re.M)
        expected = functions(body)
        compiled = re.search(r'^// ?library ' + re.escape(library) + r':\n(.*?)^// ?library ' + re.escape(library) + r' ends', runtime, re.M | re.S)
        if not compiled:
            errors.append(f'{name}: missing runtime library block'); continue
        extra = set(functions(compiled[1])) - set(expected)
        if extra:
            errors.append(f'{name}: extra compiled functions: {sorted(extra)}')
        for fn, source in expected.items():
            checked += 1
            if tokens(source) != tokens(actual.get(fn, '')):
                pair = {'source': fingerprint(source), 'runtime': fingerprint(actual.get(fn, ''))}
                observed[fn] = pair
                if contract.get(fn) != pair:
                    errors.append(f'{name}/{fn}: source/runtime body differs from both direct compilation and the tested baseline')
    if capture is not None:
        capture.update(observed)
    return errors, checked


def object_ids(path):
    from objdata import read_objects, fields
    archive = MPQ(str(path))
    ids, item_fields, errors = {}, {}, []
    for ext, kind in [('w3u', 'unit'), ('w3t', 'item'), ('w3a', 'ability'), ('w3b', 'destructable'),
                      ('w3d', 'doodad'), ('w3h', 'buff'), ('w3q', 'upgrade')]:
        name = 'war3map.' + ext
        if archive.block_index(name) is None:
            continue
        table = read_objects(archive.read(name), ext)
        seen = set()
        for obj in table['original'] + table['custom']:
            rawcode = obj['id'] or obj['base']
            if rawcode in seen:
                errors.append(f'{name}: duplicate object ID {rawcode}')
            seen.add(rawcode)
            ids.setdefault(kind, set()).update([rawcode, obj['base']])
            if kind == 'item':
                item_fields[rawcode] = {**fields(obj), '_base': obj['base']}
    return ids, item_fields, errors

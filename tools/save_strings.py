"""Lower save-code string operations to checkpoint-safe fragmented storage.

The logical codec remains the format specification. Its built runtime/editor copy
uses bounded strings; filenames, packet bytes, code parts and permanent IDs stay
unchanged. Types are resolved before replacing + or equality, so numeric math is
never changed. Unknown string-producing calls fail the build instead of guessing.
"""
from functools import lru_cache
from pathlib import Path
import re
from jtok import tokens, strip_comments

ROOT = Path(__file__).resolve().parents[1]
HERE = ROOT / 'experiments/Forsaken'
HELPER = HERE / 'SaveStrings.j'
SCAN = HERE / 'SaveScan.j'
PRIORITY = {'or': 1, 'and': 2, '==': 3, '!=': 3, '<': 3, '>': 3,
            '<=': 3, '>=': 3, '+': 4, '-': 4, '*': 5, '/': 5}


def refresh_runtime(source):
    """Apply reviewed storage/IO safeguards to already lowered editor references."""
    source=source.replace('\r\n','\n')
    if 'function FSS_Id takes' in source:
        helper=HELPER.read_text(encoding='utf-8').replace('\r\n','\n')
        block=re.search(r'^globals\n(.*?)^endglobals\n',helper,re.M|re.S)
        start=re.search(r'^function (?:FSS_Table|FSS_EnterLocal|FSS_Id) takes',source,re.M)
        end=re.search(r'^function FSS_LegacyText takes.*?^endfunction',source,re.M|re.S)
        if not start or not end:raise ValueError('unrecognized save string helper layout')
        source=source[:start.start()]+helper[block.end():].strip()+'\n\n'+source[end.end():].lstrip('\n')
        globals_=re.search(r'^globals\n(.*?)^endglobals',source,re.M|re.S)
        # Keep the exact canonical helper prefix, including declaration order.
        # Existing editor references may contain the older prefix and newly
        # introduced helper globals must not be stranded at its block's end.
        body=re.sub(r'^    constant integer FSS_CHUNK[^\n]*\n.*?^    boolean FSS_ScanDone[^\n]*\n',
                    '',globals_[1],count=1,flags=re.M|re.S)
        names=set(re.findall(r'^\s*(?:constant\s+)?\w+\s+(\w+)',block[1],re.M))
        body=''.join(line+'\n' for line in body.splitlines() if not any(
            re.match(r'\s*(?:constant\s+)?\w+\s+'+name+r'\s*(?:=|$)',line) for name in names))
        source=source[:globals_.start(1)]+block[1]+body+source[globals_.end(1):]
    # The reader is only called by the owning client's file-IO branches. Give
    # its concatenations an explicit local arena, without a mode flag that could
    # leak into shared validation if the VM interrupts a thread.
    pattern=r'(^function FST_ReadFile takes[^\n]+\n).*?^endfunction'
    source=re.sub(pattern,lambda m:re.sub(r'\bFSS_Concat\(', 'FSS_LocalConcat(',m[0]),
                  source,flags=re.M|re.S)
    return source


def isolate_reader(source, name):
    """Reset the VM budget per varint/section and fail closed if execution stops."""
    pattern = re.compile(r'^function '+name+r' takes (.*?) returns (\w+)\n.*?^endfunction', re.M | re.S)
    found = pattern.search(source)
    if not found:
        return source
    parameters = [part.strip().split() for part in found[1].split(',')]
    prefix = 'FSS_Call_'+name
    declarations = ''.join('    '+kind+' '+prefix+'_'+arg+'\n' for kind, arg in parameters)
    declarations += '    boolean '+prefix+'_Done=false\n'
    if found[2] != 'nothing':
        declarations += '    '+found[2]+' '+prefix+'_Result=0\n'
    source = source.replace('globals\n', 'globals\n'+declarations, 1)
    implementation = found[0].replace('function '+name+' takes', 'function '+prefix+'_Impl takes', 1)
    arguments = ','.join(prefix+'_'+arg for _, arg in parameters)
    operation = ('call ' if found[2] == 'nothing' else 'set '+prefix+'_Result=')
    worker = ('\n\nfunction '+prefix+'_Run takes nothing returns nothing\n    '+operation+
              prefix+'_Impl('+arguments+')\n    set '+prefix+'_Done=true\nendfunction\n\n')
    wrapper = found[0].split('\n', 1)[0]+'\n'
    for _, arg in parameters:
        wrapper += '    set '+prefix+'_'+arg+'='+arg+'\n'
    if found[2] != 'nothing':
        wrapper += '    set '+prefix+'_Result=0\n'
    wrapper += ('    set '+prefix+'_Done=false\n    call ExecuteFunc("'+prefix+'_Run")\n'
                '    if not '+prefix+'_Done then\n        set FSC_Ok[ctx]=false\n    endif\n')
    if found[2] != 'nothing':
        wrapper += '    return '+prefix+'_Result\n'
    wrapper += 'endfunction'
    return pattern.sub(lambda _: implementation+worker+wrapper, source, count=1)


@lru_cache(None)
def types():
    returns, variables = {}, {}
    paths = list(HERE.glob('Forsaken*.j')) + [ROOT / 'tools/versions/1.29.2/common.j',
                                             ROOT / 'tools/versions/1.29.2/blizzard.j']
    for path in paths:
        if not path.exists():
            continue
        source = strip_comments(path.read_text(encoding='utf-8-sig'))
        for m in re.finditer(r'\b(?:function|native)\s+(\w+)\s+takes[^\n]*?\breturns\s+(\w+)', source):
            returns[m[1]] = m[2]
        for m in re.finditer(r'^\s*(?:constant\s+)?(\w+)\s+(?:array\s+)?(\w+)\s*(?:=.*)?$', source, re.M):
            if m[1] in ('string', 'integer', 'real', 'boolean', 'unit', 'item', 'player', 'timer', 'hashtable'):
                variables[m[2]] = m[1]
    return returns, variables


class Expression:
    def __init__(self, text, variables):
        self.parts = tokens(text, normalize=False)
        self.position = 0
        self.returns, _ = types()
        self.variables = variables

    def take(self):
        result = self.parts[self.position]
        self.position += 1
        return result

    def peek(self):
        return self.parts[self.position] if self.position < len(self.parts) else ''

    def parse(self, minimum=0):
        token = self.take()
        if token in ('not', '-', '+'):
            value, kind = self.parse(6)
            value = '(' + token + ' ' + value + ')'
            kind = 'boolean' if token == 'not' else kind
        elif token == '(':
            value, kind = self.parse()
            assert self.take() == ')'
            value = '(' + value + ')'
        elif token == 'function':
            value, kind = 'function ' + self.take(), 'code'
        else:
            value = token
            kind = ('string' if token.startswith('"') else 'integer' if token.startswith("'") or
                    token.startswith('$') or token[0].isdigit() else
                    'boolean' if token in ('true', 'false') else
                    'null' if token == 'null' else self.variables.get(token, 'unknown'))
            if self.peek() == '(':
                self.take()
                arguments = []
                if self.peek() != ')':
                    while True:
                        argument, _ = self.parse()
                        arguments.append(argument)
                        if self.peek() != ',':
                            break
                        self.take()
                assert self.take() == ')'
                name = {'StringLength': 'FSS_Length', 'SubString': 'FSS_SubString'}.get(token, token)
                kind = self.returns.get(token, 'unknown')
                if token == 'StringLength': kind = 'integer'
                if token == 'SubString': kind = 'string'
                value = name + '(' + ','.join(arguments) + ')'
            elif self.peek() == '[':
                self.take()
                index, _ = self.parse()
                assert self.take() == ']'
                value += '[' + index + ']'
        while self.peek() in PRIORITY and PRIORITY[self.peek()] >= minimum:
            operator = self.take()
            right, right_kind = self.parse(PRIORITY[operator] + 1)
            if operator == '+' and (kind == 'string' or right_kind == 'string'):
                if kind not in ('string', 'null') or right_kind not in ('string', 'null'):
                    raise ValueError('unresolved string concatenation: ' + value + '+' + right)
                value, kind = 'FSS_Concat(' + value + ',' + right + ')', 'string'
            elif operator in ('==', '!=') and (kind == 'string' or right_kind == 'string'):
                value = ('not ' if operator == '!=' else '') + 'FSS_Equals(' + value + ',' + right + ')'
                value, kind = '(' + value + ')', 'boolean'
            else:
                value = '(' + value + ' ' + operator + ' ' + right + ')'
                if operator in ('and', 'or', '==', '!=', '<', '>', '<=', '>='):
                    kind = 'boolean'
        return value, kind

    def lower(self):
        value, _ = self.parse()
        if self.position != len(self.parts):
            raise ValueError('unparsed expression: ' + repr(self.parts[self.position:]))
        return value


def lower_module(source, helpers=None):
    source = source.replace('\r\n', '\n')
    if 'function FSS_Id takes' in source:
        return refresh_runtime(source)
    _, globals_ = types()
    variables = dict(globals_)
    # Include generated/classic-only functions and declarations in type inference.
    returns, _ = types()
    for m in re.finditer(r'^function (\w+) takes[^\n]*? returns (\w+)', source, re.M):
        returns[m[1]] = m[2]
    for m in re.finditer(r'^\s*(?:constant\s+)?(string|integer|real|boolean)\s+(?:array\s+)?(\w+)', source, re.M):
        variables[m[2]] = m[1]
    globals_ = dict(variables)
    output = []
    in_function = False
    native_only = False
    for line in source.splitlines():
        code = strip_comments(line).strip()
        if code.startswith('function '):
            in_function = True
            # These primitives only process a single character or a bounded integer.
            # Keeping their native operations avoids extra calls for every decoded digit.
            name = code.split()[1]
            native_only = name in ('FSC_InitCharacters', 'FSC_Value', 'FSC_Uint') or name.startswith('FSG_')
            variables = dict(globals_)
            for kind, name in re.findall(r'\b(string|integer|real|boolean|unit|item|player)\s+(\w+)', code.split(' returns ')[0]):
                variables[name] = kind
            output.append(line)
            continue
        if code == 'endfunction':
            in_function = False
        if not in_function or not code or native_only:
            output.append(line)
            continue
        if code.startswith('local '):
            m = re.match(r'local (\w+) (\w+)(.*)', code)
            variables[m[2]] = m[1]
        match = re.match(r'(set\s+[^=]+=|local\s+\w+\s+\w+\s*=|return\s+|call\s+|exitwhen\s+)(.+)$', code)
        condition = re.match(r'(if|elseif)\s*(.+?)\s*then$', code)
        try:
            if match:
                lowered = match[1] + Expression(match[2], variables).lower()
            elif condition:
                lowered = condition[1] + ' ' + Expression(condition[2], variables).lower() + ' then'
            else:
                output.append(line)
                continue
        except Exception as error:
            raise ValueError('cannot lower: ' + code) from error
        indent = line[:len(line) - len(line.lstrip())]
        comment = line[len(line.rstrip()):]  # trailing whitespace has no semantics
        output.append(indent + lowered + comment)
    result = '\n'.join(output) + '\n'
    # Whole-code scans must not spend the caller's budget walking fragmented text.
    for name, replacement in [('FSC_AlphabetValid', 'return FSS_Scan(text,0)==1'),
                              ('FSC_Checksum', 'return FSS_Scan(text,1)'),
                              ('FST_TextChecksum', 'return FSS_Scan(text,2)')]:
        pattern = r'(^function '+name+r' takes[^\n]+\n).*?^endfunction'
        result = re.sub(pattern, lambda m: m[1]+'    '+replacement+'\nendfunction', result,
                        flags=re.M | re.S)
    for name in ('FSC_Read', 'FSC_ValidateSection'):
        result = isolate_reader(result, name)
    result = result.replace('Trig_Cmd_Load_Code_LoadCodeDispatch(FST_Result[pid],',
                            'Trig_Cmd_Load_Code_LoadCodeDispatch(FSS_LegacyText(FST_Result[pid]),')
    if helpers is None:
        helpers = bool(re.search(r'^library TForsakenSaveCodec\s*$', source, re.M))
    if helpers:
        helper = HELPER.read_text(encoding='utf-8').replace('\r\n', '\n')
        block = re.search(r'^globals\n(.*?)^endglobals\n', helper, re.M | re.S)
        # The map synchronizer expects a single globals block in each library.
        if '\nglobals\n' not in result:
            first, rest = result.split('\n', 1)
            result = first+'\nglobals\nendglobals\n'+rest
        result = result.replace('globals\n', 'globals\n'+block[1], 1)
        functions = helper[block.end():].rstrip()+'\n\n'
        result = result.replace('endglobals\n', 'endglobals\n'+functions+'\n', 1)
        value = re.search(r'^function FSC_Value takes\b.*?^endfunction', result, re.M | re.S)
        if value:
            result = result[:value.end()]+'\n\n'+SCAN.read_text(encoding='utf-8').replace('\r\n','\n')+result[value.end():]
    return refresh_runtime(result)

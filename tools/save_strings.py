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
PRIORITY = {'or': 1, 'and': 2, '==': 3, '!=': 3, '<': 3, '>': 3,
            '<=': 3, '>=': 3, '+': 4, '-': 4, '*': 5, '/': 5}


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
        return source  # already lowered generated module
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
            native_only = code.split()[1] in ('FSC_InitCharacters', 'FSC_Value', 'FSC_Uint')
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
        functions = helper[block.end():]
        result = result.replace('endglobals\n', 'endglobals\n'+functions+'\n', 1)
    return result

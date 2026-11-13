"""Quest notification text without empty spacers; Seekers without !Teleport."""
import re
from pathlib import Path
from jtok import functions
from performance_runtime import put

ROOT=Path(__file__).resolve().parents[1]

def helper():
    body=functions((ROOT/'tools/bin/blizzard.j').read_text())['QuestMessageBJ']
    body=body.replace('function QuestMessageBJ takes','function QuestText_Message takes',1)
    body=re.sub(r'^.*call DisplayTimedTextToPlayer\([^\n]*, " "\)\s*\n','',body,flags=re.M)
    body=body.replace('    if (IsPlayerInForce', '''    // No placeholder/blank text can reach the engine's notification renderer.
    if message==null or message=="" or message==" " or message=="(null)" then
        return
    endif
    if (IsPlayerInForce''',1)
    return body

def refresh(source):
    fs=functions(source)
    if 'Text_Transmission' in fs and 'QuestText_Message' not in fs:
        source=source.replace('function Text_Transmission takes',helper()+'\n\nfunction Text_Transmission takes',1)
    if 'QuestMessageBJ(' in source:
        source=source.replace('QuestMessageBJ(','QuestText_Message(')
        # Make the shared text helper available before every source caller.
        match=re.search(r'^library (\w+)([^\n]*)',source,re.M)
        if match and match[1]!='TText' and not re.search(r'\bTText\b',match[2]):
            line=match[0]+(', TText' if 'requires' in match[2] else ' requires TText')
            source=source[:match.start()]+line+source[match.end():]
    fs=functions(source)
    if 'QuestSeekDestroy_Started' in fs:
        body=fs['QuestSeekDestroy_Started']
        pattern=r"(?m)^\s*call UnitAddAbilityBJ\('A102',GetLastCreatedUnit\(\)\)[^\n]*\n"
        assert len(re.findall(pattern,body))==3
        source=put(source,'QuestSeekDestroy_Started',re.sub(pattern,'\n',body))
    return source

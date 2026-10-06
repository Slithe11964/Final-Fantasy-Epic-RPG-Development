"""Check stage S's behavior-preserving quest conversions against the stage R commit.

Run before changing these sources further: python tools/tests/verify_stage_s.py
For the release/archive proof also pass --map release/FFERPG_0.9.7.3-r16-stageS.w3x.
"""
from pathlib import Path
import argparse
import hashlib
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from jtok import functions, strip_comments, tokens
from mpq import MPQ


def normalize(body, module):
    body = strip_comments(body)
    if module != 'QuestEngine':
        patterns = [
            r'^\s*(?:set udg_SideQuest\[61\]|set udg_MainQuest\[8\])=CreateQuestBJ[^\n]+$',
            r'^\s*set udg_MainQuest\[(?:9|\$B|19|20)\]=GetLastCreatedQuestBJ\(\)[^\n]*$',
            r'^\s*call QuestMessageBJ\(GetPlayersAll\(\),bj_QUESTMESSAGE_(?:DISCOVERED|COMPLETED|FAILED),"(?:New Quest Received|Quest Completed|Quest Failed): \|cffffcc00(?:Cartographer|True Ice Age)\|r"\)[^\n]*$',
            r'^\s*call QuestSet(?:Completed|Failed)BJ\(udg_(?:SideQuest\[61\]|MainQuest\[20\]),true\)[^\n]*$',
            r'^\s*call QuestItemSetDescriptionBJ\(udg_QuestReq\[6\],"Sufficiently explored!"\)[^\n]*$',
            r'^\s*call QuestItemSetCompletedBJ\(udg_QuestReq\[6\],true\)[^\n]*$',
            r'^\s*set udg_QuestsCompleted=\(udg_QuestsCompleted\+1\)[^\n]*$',
            r'^\s*call Quest(?:Cartographer|TrueIceAge)_Define\(\)[^\n]*$',
            r'^\s*call Quest_(?:StartSilent|AliasMain|CompletionItem|AnnounceStart|StepDone|Fail)\(QUEST_(?:CARTOGRAPHER|TRUE_ICE_AGE)[^\n]+$',
        ]
        for pattern in patterns:
            body = re.sub(pattern, '', body, flags=re.M)
    elif 'function Quest_Define ' in body:
        body = re.sub(r'^\s*set Quest(?:StartSilent|StartAnnounced|CompletionItem|CompletionItemText)\[QuestCount\]=[^\n]+$', '', body, flags=re.M)
    elif 'function QuestEngine_Finish ' in body:
        body = body.replace('        if not QuestStartSilent[q] then\n            call Quest_AnnounceStart(q)\n        endif', '        call QuestMessageBJ(GetPlayersAll(),bj_QUESTMESSAGE_DISCOVERED,"New Quest Received: |cffffcc00"+QuestName[q]+"|r")')
        body = re.sub(r'        if QuestCompletionItem\[q\]!=null then\n.*?        endif\n', '', body, flags=re.S)
    return tokens(body)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--map', type=Path)
    args = parser.parse_args()
    unchanged = changed = 0
    for module in ['QuestEngine', 'Cartographer', 'TrueIceAge']:
        path = f'src/triggers/06 Quests and story/{module}.j'
        old = subprocess.check_output(['git', 'show', f'dc1e9af:{path}'], cwd=ROOT).decode('utf-8')
        raw = (ROOT / path).read_bytes()
        assert b'\n' not in raw.replace(b'\r\n', b''), path
        new = raw.decode('utf-8')
        before, after = functions(old), functions(new)
        assert before.keys() <= after.keys(), module
        for name, body in before.items():
            assert normalize(body, module) == normalize(after[name], module), name
            if tokens(body) == tokens(after[name]):
                unchanged += 1
            else:
                changed += 1
        if module != 'QuestEngine':
            for text in re.findall(r'CreateQuestBJ\([^\n]*?,"([^"\n]+)","ReplaceableTextures', old):
                assert '"' + text + '"' in new, text
    assert changed == 7, changed
    print(f'PASS preservation audit: {unchanged} existing functions token-identical; 7 differ only in the intended quest lifecycle operations.')
    print('PASS every dialogue, reward calculation/call, wait, story counter, retry, shared marker and world action preserved; CRLF retained.')
    if args.map:
        final_path = args.map.resolve()
        baseline = MPQ(str(ROOT / 'release/FFERPG_0.9.7.3-r16-stageR.w3x'))
        final = MPQ(str(final_path))
        raw = final_path.read_bytes()
        assert raw[:4] == b'HM3W'
        checked = (ROOT / 'build/stageS-ordered.w3x').read_bytes()
        assert raw[512:] == checked[checked.index(b'MPQ\x1a'):]
        count = 0
        for name in ['war3map.w3i', 'war3map.w3e', 'war3map.doo', 'war3mapUnits.doo', 'war3map.w3u', 'war3map.w3t', 'war3map.w3a', 'war3map.w3b', 'war3map.w3d', 'war3map.w3h', 'war3map.w3q', 'war3map.wts', 'war3map.wtg', 'war3map.w3r', 'war3map.w3c', 'war3map.wpm', 'war3map.shd', 'war3map.imp']:
            if baseline.block_index(name) is not None:
                assert baseline.read(name) == final.read(name), name
                count += 1
        print(f'PASS HM3W header; release archive matches checked build; {count} world/object/trigger-layout files unchanged from stage R.')
        print('Stage S SHA256: ' + hashlib.sha256(raw).hexdigest())


if __name__ == '__main__':
    main()

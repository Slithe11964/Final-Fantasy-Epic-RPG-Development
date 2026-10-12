"""Apply the approved r17 presentation without importing editor gameplay changes."""
import json
import struct
from pathlib import Path
from mpq import MPQ, replace_files
from wct import raw_of

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
INTRO = Path('src/triggers/06 Quests and story/Intro.j')


def settings():
    return json.loads((HERE/'map-presentation.json').read_text(encoding='utf-8'))


def patch_info(data, stage):
    version = struct.unpack_from('<i', data)[0]
    if version not in (25, 28, 31, 33, 39):
        raise ValueError('unsupported map info version')
    start = end = 28 if version >= 28 else 12
    for _ in range(4):
        end = data.index(b'\0', end)+1
    values = settings()
    texts = [values['name']+' - Forsaken '+stage, values['author'],
             values['description'], values['players']]
    return data[:start]+b''.join(text.encode('utf-8')+b'\0' for text in texts)+data[end:]


def prepare_map(base, output, stage):
    archive = MPQ(str(base))
    replace_files(str(base), str(output), {'war3map.w3i': patch_info(archive.read('war3map.w3i'), stage)})
    return output


def sync_intro(work):
    text = (ROOT/INTRO).read_text(encoding='utf-8')
    (work/INTRO).write_bytes(text.replace('\n', '\r\n').encode('utf-8'))


def expected_source(entry, work):
    if entry.startswith(b'library TIntro '):
        return raw_of((work/INTRO).read_text(encoding='utf-8').replace('\n', '\r\n'))
    return entry

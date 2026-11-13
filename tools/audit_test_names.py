from pathlib import Path
import re,struct,sys
from mpq import MPQ
from downgrade import wts_read
from add_header import read_header
ROOT=Path(__file__).resolve().parents[1]
TEST=Path('C:/Users/jaked/Documents/Warcraft III/Maps/Download/TEST')
for path in TEST.glob('*.w3x'):
    m=MPQ(str(path));s=m.read('war3map.j').decode();w=wts_read(m.read('war3map.wts'))
    info=m.read('war3map.w3i');version=struct.unpack_from('<i',info)[0];start=28 if version>=28 else 12
    names=info[start:].split(b'\0',4)[:4]
    print(path.name,'HEADER=',read_header(str(path))[0],'INFO=',names,'WTS38788=',w.get(38788))
    for line in s.splitlines():
        if re.search(r'udg_BoardTitlePrefix=|Welcome to Final Fantasy Epic RPG|call DisplayTimedTextToPlayer.*(?:[Rr]eview|[Tt]est)|QuestSetTitle\(info',line):
            print(line[:280])

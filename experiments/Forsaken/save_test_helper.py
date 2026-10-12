"""Helpers for in-game save tests (no map changes).

python experiments/Forsaken/save_test_helper.py chat SAVEFILE.txt [--out lines.txt] [--seed N]
    Read a new-format save file set (SAVEFILE.txt plus "SAVEFILE part N.txt" beside it) and print
    the numbered "-load FSVB:..." chat lines that -save/-savepage would show, shuffled and with one
    duplicate, for the screenshot-only loading test.
"""
import argparse
from pathlib import Path
import random
import re

ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890$#'
NAME = re.compile(r'SetPlayerName\(Player\((\d+)\), "([^"]*)"\)')


def text_checksum(text):
    # Mirrors FST_TextChecksum in Forsaken-save-transport.j.
    a, b = 1, 0
    for char in text:
        digit = 64 if char == '(' else 65 if char == ')' else ALPHABET.index(char)
        a = (a + digit + 1) % 32749
        b = (b + a) % 32749
    return b * 32768 + a


def read_page(path):
    slots = {int(m[1]): m[2] for m in NAME.finditer(Path(path).read_text(encoding='utf-8', errors='replace'))}
    marker = slots.get(23, '')
    if len(marker) != 21 or not marker.startswith('FSC1'):
        raise SystemExit(f'{path}: not a new-format save page (no FSC1 header)')
    return slots, int(marker[4:9]), int(marker[9:19]), int(marker[19]), int(marker[20])


def read_save(path):
    path = Path(path)
    slots, size, check, page, pages = read_page(path)
    code = ''
    for index in range(pages):
        page_path = path if index == 0 else path.with_name(f'{path.stem} part {index}.txt')
        if not page_path.exists():
            raise SystemExit(f'missing {page_path.name}')
        slots, p_size, p_check, p_page, p_pages = read_page(page_path)
        if (p_size, p_check, p_page, p_pages) != (size, check, index, pages):
            raise SystemExit(f'{page_path.name}: header does not match the main file')
        for slot in range(23):
            if len(code) >= size:
                break
            code += slots.get(slot, '')
    if len(code) != size or text_checksum(code) != check:
        raise SystemExit('assembled code length/checksum does not match the header')
    return code


def chat_lines(code):
    total = (len(code) + 79) // 80
    check = text_checksum(code)
    return [f'-load FSVB:{check}:{n + 1}:{total}:{code[n * 80:(n + 1) * 80]}' for n in range(total)]


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest='command', required=True)
    chat = sub.add_parser('chat')
    chat.add_argument('save')
    chat.add_argument('--out')
    chat.add_argument('--seed', type=int, default=1)
    a = parser.parse_args()
    code = read_save(a.save)
    lines = chat_lines(code)
    test = lines[:]
    random.Random(a.seed).shuffle(test)
    test.insert(len(test) // 2, test[0])  # one duplicate
    text = '\n'.join(test) + '\n'
    if a.out:
        Path(a.out).write_text(text, encoding='utf-8')
        print(f'{len(code)} characters, {len(lines)} parts (+1 duplicate) written to {a.out}')
    else:
        print(text, end='')
    for line in lines:
        assert len(line) <= 127, 'chat line longer than Warcraft allows'


if __name__ == '__main__':
    main()

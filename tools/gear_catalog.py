"""Keep worn-gear bonuses off the hero's command card.

    python tools/gear_catalog.py BASE OUT

Worn gear is carried by a backpack holder, so in 1.29.2 the hero is given each worn item's
passive abilities by script (see tools/gear_slots.py). An ability added to a unit takes a
command-card button, and these abilities inherit their position from the stock ability they
are built on, so they landed on top of the job's own buttons: a job showed its abilities for
a moment, then a granted bonus replaced one and the card read "Tool tip missing!".

A button position outside the three-by-four card is not drawn, so every ability the backpack
can grant is moved off the card here. Nothing else changes: an item in an inventory never
used the command card, so items are unaffected, and these are all passive bonuses.
"""
import argparse
import os
import sys
from pathlib import Path

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mpq import MPQ, write_files
from objdata import read_objects, write_objects
from backpack_catalog import setf, dedupe
import gear_slots

# Off the card: the card is four columns by three rows, and anything outside it is not drawn.
HIDDEN_X = 0
HIDDEN_Y = -11


def hide(table, ids):
    """Move each ability off the command card, adding an entry for a stock one with none."""
    entries = {}
    for obj in table['custom']:
        entries[obj['id']] = obj
    for obj in table['original']:
        entries.setdefault(obj['base'], obj)
    changed = 0
    for raw in sorted(ids):
        obj = entries.get(raw)
        if obj is None:
            obj = dict(base=raw, id=None, sets=[dict(flag=0, mods=[])])
            table['original'].append(obj)
        dedupe(obj)
        setf(obj, 'abpx', 0, HIDDEN_X)
        setf(obj, 'abpy', 0, HIDDEN_Y)
        changed += 1
    return changed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    args = parser.parse_args()
    if args.out.exists():
        parser.error('Output already exists; choose a new path.')
    archive = MPQ(str(args.base))
    bonuses = {raw for _, _, _, abilities in gear_slots.classify(args.base) for raw in abilities}
    files = {}
    for name in ('war3map.w3a', 'war3mapSkin.w3a'):
        raw = archive.read(name)
        if not raw:
            continue
        table = read_objects(raw, 'w3a')
        count = hide(table, bonuses)
        files[name] = write_objects(table, table['version'], 'w3a')
        print('%s: %d gear bonuses moved off the command card' % (name, count))
    write_files(str(args.base), str(args.out), files)


if __name__ == '__main__':
    main()

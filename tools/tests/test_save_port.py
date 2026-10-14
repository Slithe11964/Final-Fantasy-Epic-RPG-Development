"""The 1.29.2 copy of the new save must be the Reforged save with only slot lookups changed."""
import re
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import save_port
from save_legacy import convert
from jtok import strip_comments

ROOT = Path(__file__).resolve().parents[2]
FOLDER = ROOT / 'src/triggers/12 Save system'
# Modules that carry no slot lookups: everything but the generated notice and the empty
# InitTrig function must match the Reforged file, so the code and file format cannot drift.
UNCHANGED = ('ForsakenSaveCodec', 'ForsakenSaveLife', 'ForsakenSaveCache', 'ForsakenSaveTransport')


def text(path):
    return path.read_bytes().decode('utf-8').replace('\r\n', '\n')


def strip_port(module, body):
    lines = body.split('\n')
    del lines[1:3]  # the generated notice
    body = '\n'.join(lines)
    return body.replace('function InitTrig_%s takes nothing returns nothing\nendfunction\n' % module, '')


class SavePortTests(unittest.TestCase):
    def setUp(self):
        if not save_port.FORSAKEN.exists():
            self.skipTest('Reforged save sources not present')

    def test_format_modules_are_the_reforged_ones(self):
        files = dict(save_port.MODULES)
        for module in UNCHANGED:
            ported = strip_port(module, text(FOLDER / (module + '.j')))
            self.assertEqual(ported, text(save_port.FORSAKEN / files[module]), module)

    def test_no_reforged_only_natives_remain(self):
        for module, _ in save_port.MODULES:
            body = text(FOLDER / (module + '.j'))
            if module == 'ForsakenSaveTransport':
                body = convert(body)  # its sync natives are removed by the 1.29.2 conversion
            self.assertIsNone(save_port.FORBIDDEN.search(body), module)
            self.assertNotRegex(strip_comments(body), r'\bBlz\w+', module)

    def test_slot_lookups_go_to_the_backpack(self):
        capture = text(FOLDER / 'ForsakenSaveCapture.j')
        self.assertIn('return SaveSlots_Bag(FRC_Hero[pid],position-6)', capture)
        self.assertIn('return SaveSlots_Equip(FRC_Hero[pid],position-36)', capture)
        self.assertIn('if not SaveSlots_Ready(pid) then', capture)
        load = text(FOLDER / 'ForsakenFreshLoad.j')
        self.assertIn('call SaveSlots_AfterLoad(pid)', load)
        self.assertIn('if not SAVE_NEW_FORMAT then\n        return\n    endif', load)

    def test_every_gear_item_has_a_permanent_identity_and_bindings(self):
        plan = text(FOLDER / 'ForsakenSaveFreshPlan.j')
        catalog = save_port.gear_catalog()
        masks = dict(Head=1, Chest=2, Gloves=4, Boots=8, Ring=48, Primary=192, Offhand=128, Trinket=256)
        found = {}
        for identity, value in re.findall(r'SaveInteger\(FFP_Bindings,6,(\d+),(\d+)\)', plan):
            found[int(identity)] = int(value)
        ids = {raw: int(i) for i, raw in re.findall(r"SaveInteger\(FFP_Bindings,1,(\d+),'(\w{4})'\)", plan)}
        for raw, entry in catalog.items():
            self.assertEqual(found[ids[raw]], masks[entry['slot']], raw)
        # 1.29.2 has no Reforged gear variants: every binding names the item itself.
        self.assertNotRegex(plan, r"'[fg]\d{3}'")

    def test_the_switch_is_off_until_the_classic_conversion(self):
        slots = text(FOLDER / 'SaveSlots.j')
        self.assertIn('constant boolean SAVE_NEW_FORMAT=false', slots)
        joined = slots + text(FOLDER / 'ForsakenSaveTransport.j')
        self.assertIn('constant boolean SAVE_NEW_FORMAT=true', convert(joined))

    def test_equipment_positions_follow_reforged_order(self):
        # Helm, chest, gloves, boots, ring, ring, weapon, offhand, trinket -> page, slot.
        slots = text(FOLDER / 'SaveSlots.j')
        page = re.search(r'function SaveSlots_LoadoutPage.*?endfunction', slots, re.S).group(0)
        self.assertIn('if position==4 or position==5 or position==8 then\n        return 1', page)
        slot = re.search(r'function SaveSlots_LoadoutSlot.*?endfunction', slots, re.S).group(0)
        self.assertIn('if position<4 then\n        return position+2', slot)
        self.assertIn('elseif position==4 or position==6 then\n        return 0', slot)
        self.assertIn('elseif position==5 or position==7 then\n        return 1', slot)


if __name__ == '__main__':
    unittest.main()

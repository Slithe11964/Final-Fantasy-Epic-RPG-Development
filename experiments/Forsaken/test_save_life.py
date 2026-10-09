"""Actual JASS life arithmetic, with every real operation rounded to binary32."""
import math
from pathlib import Path
import random
import struct
import subprocess
import tempfile
import unittest

import save_vnext as codec
from test_save_jass import engine, ROOT, SOURCE, flatten

LIFE = Path(__file__).with_name('Forsaken-save-life.j')


class Real32:
    """Wrap harness real expressions, including its // translation of JASS /."""
    def __init__(self, value):
        try:
            self.value = struct.unpack('>f', struct.pack('>f', float(value)))[0]
        except OverflowError:
            self.value = math.copysign(float('inf'), float(value))

    def __float__(self): return self.value
    def __add__(self, other): return Real32(self.value+float(other))
    def __radd__(self, other): return Real32(float(other)+self.value)
    def __sub__(self, other): return Real32(self.value-float(other))
    def __rsub__(self, other): return Real32(float(other)-self.value)
    def __mul__(self, other): return Real32(self.value*float(other))
    def __rmul__(self, other): return Real32(float(other)*self.value)
    def __floordiv__(self, other): return Real32(self.value/float(other))
    def __eq__(self, other): return self.value == float(other)
    def __ne__(self, other): return self.value != float(other)
    def __lt__(self, other): return self.value < float(other)
    def __le__(self, other): return self.value <= float(other)
    def __gt__(self, other): return self.value > float(other)
    def __ge__(self, other): return self.value >= float(other)


class LifeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.e = engine(LIFE.read_text(), dict(I2R=Real32, R2I=lambda v: int(float(v)),
            GetItemTypeId=lambda item: item['raw'] if item else 0,
            GetWidgetLife=lambda item: Real32(item['life'])))

    def check_bits(self, bits):
        value = struct.unpack('>f', struct.pack('>I', bits))[0]
        self.assertTrue(self.e['FSL_Pack'](0, Real32(value)), hex(bits))
        self.assertEqual((self.e['FSL_High'][0], self.e['FSL_Low'][0]), (bits >> 16, bits & 65535))
        self.assertEqual(float(self.e['FSL_Real'](bits >> 16, bits & 65535)), value)
        self.assertEqual(self.e['FSL_Encode'](0, Real32(value)), codec.life_words(value))

    def test_authored_fractional_and_all_exponent_boundaries(self):
        for value in [1., 20., 30., 42.25, 99., 145., 145.25, 123456.125]:
            self.check_bits(struct.unpack('>I', struct.pack('>f', value))[0])
        for exponent in range(255):
            for mantissa in [0, 1, 0x3fffff, 0x7ffffe, 0x7fffff]:
                bits = exponent*8388608+mantissa
                if bits: self.check_bits(bits)

    def test_5000_seeded_finite_positive_bit_patterns(self):
        rng = random.Random(20261011)
        for _ in range(5000): self.check_bits(rng.randrange(1, 0x7f800000))

    def test_invalid_life_and_player_preserve_previous_words(self):
        self.check_bits(0x43114000)  # 145.25.
        previous = self.e['FSL_High'][0], self.e['FSL_Low'][0]
        for value in [0., -0., -1., float('inf'), float('-inf'), float('nan')]:
            self.assertFalse(self.e['FSL_Pack'](0, Real32(value)))
            self.assertIsNone(self.e['FSL_Encode'](0, Real32(value)))
            self.assertEqual((self.e['FSL_High'][0], self.e['FSL_Low'][0]), previous)
        for pid in [-1, 8, 2147483647]:
            self.assertFalse(self.e['FSL_Pack'](pid, Real32(145.25)))
        for high, low in [(-1, 1), (0, -1), (65536, 1), (0, 65536), (0, 0),
                          (0x7f80, 0), (0x7fc0, 1), (0x8000, 0)]:
            self.assertEqual(float(self.e['FSL_Real'](high, low)), 0.)

    def test_read_only_item_life_capture(self):
        item = dict(raw=1, life=145.25, charges=127, owner=3)
        before = dict(item)
        self.assertEqual(self.e['FSL_CaptureLife'](0, item), codec.life_words(145.25))
        self.assertEqual(item, before)
        for invalid in [None, dict(raw=0, life=145.25), dict(raw=1, life=0.)]:
            self.assertIsNone(self.e['FSL_CaptureLife'](0, invalid))

    def test_crlf_and_standalone_modern_classic_compile(self):
        self.assertNotIn(b'\n', LIFE.read_bytes().replace(b'\r\n', b''))
        flat, _ = flatten('', [SOURCE.read_text(), LIFE.read_text()],
                          tail='function main takes nothing returns nothing\nendfunction\n'
                               'function config takes nothing returns nothing\nendfunction\n')
        with tempfile.TemporaryDirectory(dir=ROOT / 'build') as directory:
            path = Path(directory) / 'life.j'
            path.write_text(flat, encoding='utf-8')
            for libraries in [ROOT / 'tools/bin', ROOT / 'tools/versions/1.29.2']:
                result = subprocess.run([str(ROOT/'tools/bin/pjass.exe'), str(libraries/'common.j'),
                                         str(libraries/'blizzard.j'), str(path)], capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stdout+result.stderr)


if __name__ == '__main__': unittest.main()

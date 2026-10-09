"""Reference-format checks only; no Warcraft engine, transport or adapters."""
import json
import random
from pathlib import Path
import unittest

import save_vnext as codec


def unchecked(sections, account=42):
    body=''.join(codec.uint(s.id)+codec.uint(s.version)+codec.uint(int(s.required))+
                 codec.uint(len(s.payload))+s.payload for s in sections)
    header=codec.MAGIC+codec.uint(1)+codec.uint(account)+codec.uint(len(body))+codec.uint(len(sections))
    return header+codec.uint(codec.checksum(header+body))+body


def item(ordinal=1, identity=29, holder=2, slot=0, quantity=None, metadata=()):
    return (ordinal,identity,holder,slot,quantity,True,metadata)


class FormatTests(unittest.TestCase):
    def test_integer_boundaries_and_noncanonical_forms(self):
        for value in [0,1,31,32,63,64,1023,1024,65535,1048575,codec.MAX_INT]:
            reader=codec.Reader(codec.uint(value))
            self.assertEqual(reader.uint(),value)
            reader.finish()
        for text in ['gA','g'*8,'ggggggC','']:
            with self.assertRaises(codec.Error):codec.Reader(text).uint()
        for value in [-1,2147483648,True,1.5]:
            with self.assertRaises(codec.Error):codec.uint(value)

    def test_all_57_positions_and_stable_ids_beyond_legacy_ceiling(self):
        records=[]
        for holder,size in codec.HOLDERS.items():
            for slot in range(size):
                records.append(item(len(records)+1,1000+len(records),holder,slot,120,
                    ((1,True,codec.life_words(145.)),(2,False,codec.uint(5)))))
        section=codec.Section(1,1,True,codec.inventory(records))
        envelope=codec.Envelope(12345,(section,))
        decoded=codec.decode(codec.encode(envelope),12345)
        self.assertEqual(codec.read_inventory(decoded.sections[0].payload)[0],records)
        self.assertEqual(len(records),57)

    def test_sparse_bag_both_rings_and_identical_items_are_distinct(self):
        records=[item(i+1,29,2,slot) for i,slot in enumerate([1,7,18,29])]
        records += [item(5,29,3,4),item(6,29,3,5),item(7,29,4,5),item(8,29,5,5)]
        self.assertEqual(codec.read_inventory(codec.inventory(records))[0],records)
        for changed in [records+[item(1,29,1,0)],records+[item(9,29,2,29)],
                        [item(slot=30)],[item(holder=3,slot=9)]]:
            with self.assertRaises(codec.Error):codec.inventory(changed)

    def test_seven_bit_quantities_including_legacy_127_and_zero(self):
        for quantity in [None,0,1,99,120,121,127]:
            self.assertEqual(codec.read_inventory(codec.inventory([item(quantity=quantity)]))[0][0][4],quantity)
        for quantity in [-1,128,True,1.2]:
            with self.assertRaises(codec.Error):codec.inventory([item(quantity=quantity)])

    def test_exact_binary32_life_and_invalid_values(self):
        for value in [1.,20.,30.,42.25,99.,145.,123456.125]:
            self.assertEqual(codec.read_life(codec.life_words(value)),value)
        for value in [0.,-1.,float('nan'),float('inf'),1e100,1e-100]:
            with self.assertRaises(codec.Error):codec.life_words(value)
        # Direct malformed NaN bytes must also fail, not just the capture helper.
        with self.assertRaises(codec.Error):codec.read_life(codec.uint(0x7fc0)+codec.uint(0))

    def test_unknown_optional_metadata_is_preserved_and_required_rejected(self):
        record=item(metadata=((100,False,'ABC123'),))
        self.assertEqual(codec.read_inventory(codec.inventory([record]))[0],[record])
        for metadata in [((100,True,'ABC'),),((1,True,'A'),),
                         ((2,False,codec.uint(8)),),((100,False,'A'),(100,False,'B'))]:
            with self.assertRaises(codec.Error):codec.inventory([item(metadata=metadata)])

    def test_counted_jobs_and_dormant_future_progression(self):
        jobs=codec.Section(2,1,True,codec.pairs([(i,100) for i in range(1,43)]))
        quests=codec.Section(3,1,False,codec.pairs([(10000+i,1) for i in range(50)]))
        envelope=codec.Envelope(42,(jobs,quests))
        self.assertEqual(codec.decode(codec.encode(envelope)),envelope)
        self.assertEqual(len(codec.read_pairs(jobs.payload)),42)
        for records in [[(1,0),(1,2)],[(0,1)]]:
            with self.assertRaises(codec.Error):codec.pairs(records)
        with self.assertRaises(codec.Error):
            codec.encode(codec.Envelope(42,(codec.Section(2,1,True,codec.pairs([(1,101)])),)))

    def test_unknown_sections_and_versions_reemit_exact_bytes(self):
        for section in [codec.Section(99,1,False,'XYZ'),codec.Section(1,2,False,'ABC')]:
            text=codec.encode(codec.Envelope(42,(section,)))
            self.assertEqual(codec.encode(codec.decode(text)),text)
            required=codec.Section(section.id,section.version,True,section.payload)
            with self.assertRaises(codec.Error):codec.decode(unchecked([required]))

    def test_combined_preservation_budgets_and_counts(self):
        item_section=codec.Section(1,1,True,codec.inventory([item(metadata=((99,False,'A'*2000),))]))
        unknown=codec.Section(99,1,False,'B'*2096)
        codec.encode(codec.Envelope(42,(item_section,unknown)))
        with self.assertRaises(codec.Error):
            codec.encode(codec.Envelope(42,(item_section,codec.Section(99,1,False,'B'*2097))))
        for count in [256,257]:
            section=codec.Section(3,1,False,codec.pairs([(i+1,0) for i in range(count)]))
            if count==256:codec.decode(codec.encode(codec.Envelope(42,(section,))))
            else:
                with self.assertRaises(codec.Error):codec.decode(unchecked([section]))
        with self.assertRaises(codec.Error):codec.encode(codec.Envelope(42,tuple(codec.Section(i+10,1,False,'') for i in range(33))))
        # Known section can exceed the envelope byte budget independently of the
        # unknown-data limit. Never truncate it to make a save fit.
        large=codec.Section(2,1,True,codec.pairs([(codec.MAX_INT-i,100) for i in range(2048)]))
        with self.assertRaisesRegex(codec.Error,'payload budget'):
            codec.encode(codec.Envelope(42,(large,)))

    def test_duplicate_sections_truncation_corruption_and_owner(self):
        section=codec.Section(2,1,True,codec.pairs([(1,99)]))
        text=codec.encode(codec.Envelope(42,(section,)))
        for length in range(len(text)):
            with self.assertRaises(codec.Error):codec.decode(text[:length])
        with self.assertRaises(codec.Error):codec.decode(text+'A')
        with self.assertRaises(codec.Error):codec.decode(text,43)
        with self.assertRaises(codec.Error):codec.decode(text[:-1]+('A' if text[-1]!='A' else 'B'))
        with self.assertRaises(codec.Error):codec.decode(unchecked([section,section]))

    def test_pinned_golden_envelopes(self):
        cases=json.loads(Path(__file__).with_name('vnext-fixtures.json').read_text())['cases']
        for case in cases:
            sections=tuple(codec.Section(**s) for s in case['sections'])
            envelope=codec.Envelope(case['account_hash'],sections)
            self.assertEqual(codec.encode(envelope),case['code'])
            self.assertEqual(codec.decode(case['code']),envelope)
            # Independent implementation of the documented checksum recurrence.
            r=codec.Reader(case['code'])
            r.take(3)
            for _ in range(4):r.uint()
            header=case['code'][:r.pos]
            actual=r.uint()
            a=1;b=0
            for char in header+case['code'][r.pos:]:
                a=(a+codec.ALPHABET.index(char)+1)%32749
                b=(b+a)%32749
            self.assertEqual(actual,b*32768+a)

    def test_reproducible_size_profiles(self):
        from measure_save_vnext import profiles
        data=profiles()['profiles']
        self.assertEqual([row['inventory_records'] for row in data],[57,57,57])
        self.assertEqual([row['section_count'] for row in data],[1,3,4])
        self.assertLess(data[0]['encoded_characters'],data[1]['encoded_characters'])
        self.assertLess(data[1]['encoded_characters'],data[2]['encoded_characters'])

    def test_randomized_reference_roundtrips(self):
        rng=random.Random(20261008)
        for _ in range(1000):
            slots=rng.sample(range(30),rng.randrange(31))
            records=[item(i+1,rng.randrange(1,50000),2,slot,rng.choice([None,0,120,127]),
                ((1,True,codec.life_words(rng.randrange(1,1000)+.25)),)) for i,slot in enumerate(slots)]
            sections=(codec.Section(1,1,True,codec.inventory(records)),
                      codec.Section(2,1,True,codec.pairs([(i, rng.randrange(101)) for i in range(1,43)])))
            envelope=codec.Envelope(rng.randrange(1048576),sections)
            self.assertEqual(codec.decode(codec.encode(envelope)),envelope)


if __name__=='__main__':
    unittest.main()

"""Audit a Bazaar browser stage against its reviewed predecessor."""
import argparse
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from source_checks import ROOT
from mpq import MPQ
from objdata import read_objects, fields
from jtok import functions, tokens
from check_bazaar import check
from check_armory import check as check_armory
from editor_layout import paired_text
from wct import read_wct, text_of
from wtg import read_wtg


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--stage', default='AL')
    parser.add_argument('--base', type=Path, default=ROOT/'release/FFERPG_0.9.7.3-r16-stageAK.w3x')
    args = parser.parse_args()
    final = ROOT/f'release/FFERPG_0.9.7.3-r16-stage{args.stage}.w3x'
    classic = ROOT/f'release/1.29.2/FFERPG_0.9.7.3-r16-stage{args.stage}.w3x'
    a, b = MPQ(str(args.base)), MPQ(str(final))
    names = set(a.read('(listfile)').decode().splitlines()) | set(b.read('(listfile)').decode().splitlines())
    changed = sorted(n for n in names if a.read(n) != b.read(n))
    assert set(changed) <= {'war3map.j', 'war3map.wct', 'war3map.w3u'}, changed
    old = read_objects(a.read('war3map.w3u'), 'w3u')
    new = read_objects(b.read('war3map.w3u'), 'w3u')
    assert old['original'] == new['original']
    browser_exists = any(o['id'] == 'bRcp' for o in old['custom'])
    assert len(new['custom']) == len(old['custom'])+int(not browser_exists)
    if not browser_exists:
        assert new['custom'][-1]['id'] == 'bRcp'
    for before, after in zip(old['custom'], new['custom']):
        if before['id'] == 'n030' and not browser_exists:
            assert fields(after)['uabi'].split(',') == fields(before)['uabi'].split(',')+['Asud']
            for obj in (before, after):
                for group in obj['sets']:
                    group['mods'][:] = [m for m in group['mods'] if m['field'] != 'uabi']
        assert before == after
    before = functions(a.read('war3map.j').decode('utf-8'))
    after = functions(b.read('war3map.j').decode('utf-8'))
    different = sorted(name for name in before if tokens(before[name]) != tokens(after.get(name, '')))
    allowed = ('Bazaar_', 'BazaarFrame_', 'Trig_Bazaar_', 'Register_Bazaar_', 'RegisterTriggers_Bazaar')
    if args.stage == 'AL':
        allowed += ('Armory_', 'Trig_Armory_')
        prior_modules = paired_text(read_wtg(a.read('war3map.wtg')), read_wct(a.read('war3map.wct')))
        next_modules = paired_text(read_wtg(b.read('war3map.wtg')), read_wct(b.read('war3map.wct')))
        prior_armory = functions(text_of(prior_modules['Armory']))
        next_armory = functions(text_of(next_modules['Armory']))
        for name, body in prior_armory.items():
            restored = next_armory[name]
            if name == 'Trig_Armory_Init_Actions':
                restored = restored.replace('    call Armory_InitCounter()\r\n', '').replace('    call Armory_InitCounter()\n', '')
            assert tokens(restored) == tokens(body), name
        assert set(next_armory)-set(prior_armory) == {'Armory_CollectionText', 'Armory_RefreshCounter', 'Armory_InitCounter'}
    if args.stage == 'AK':
        allowed += ('Trig_Gaya_',)
        prior_modules = paired_text(read_wtg(a.read('war3map.wtg')), read_wct(a.read('war3map.wct')))
        next_modules = paired_text(read_wtg(b.read('war3map.wtg')), read_wct(b.read('war3map.wct')))
        edits = {
            'Gaya_Movement': ('Trig_Gaya_Follow_MoveGayaToHero', [('>=480', '>=384')]),
            'Gaya_Inventory': ('Trig_Gaya_GatherItems_Actions', [('625.', '500.'), ('375.', '300.')]),
        }
        for module, (edited, replacements) in edits.items():
            prior_functions = functions(text_of(prior_modules[module]))
            next_functions = functions(text_of(next_modules[module]))
            assert set(prior_functions) == set(next_functions)
            for name, body in next_functions.items():
                restored = body
                if name == edited:
                    for new_value, old_value in replacements:
                        restored = restored.replace(new_value, old_value)
                assert tokens(restored) == tokens(prior_functions[name]), name
                assert tokens(body) == tokens(after[name]), name
        developer = functions(text_of(next_modules['DevCommands']))
        source_developer = functions((ROOT/'src/triggers/11 Developer tools/DevCommands.j').read_text(encoding='utf-8'))
        for name in ['DevCommands_UnlockTeleporters', 'DevCommands_Help', 'Trig_DevCommands_Chat_Actions']:
            assert tokens(developer[name]) == tokens(source_developer[name]), name
        assert 'DevCommands_UnlockTeleporters' not in after
    assert all(name.startswith(allowed) for name in different), different
    assert not set(before)-set(after)
    old_editor = functions(text_of(paired_text(read_wtg(a.read('war3map.wtg')), read_wct(a.read('war3map.wct')))['Bazaar']))
    new_editor = functions(text_of(paired_text(read_wtg(b.read('war3map.wtg')), read_wct(b.read('war3map.wct')))['Bazaar']))
    for name in ['Trig_Bazaar_Recipes_Actions', 'Trig_Bazaar_PawnMaterial_Actions', 'Trig_Bazaar_Sell_Bundle_Actions']:
        assert tokens(old_editor[name]) == tokens(new_editor[name]), name
        assert tokens(new_editor[name]) == tokens(after[name]), name
    assert tokens(before['Trig_Bazaar_Recipes_Actions']) == tokens(after['Trig_Bazaar_Recipes_Actions'])
    if browser_exists:
        for name in ['Bazaar_CraftRecipe', 'Bazaar_MaterialsReady', 'Bazaar_InitBrowserData']:
            assert tokens(before[name]) == tokens(after[name]), name
    assert not check(final) and not check(classic)
    assert not check_armory(final) and not check_armory(classic)
    legacy = functions(MPQ(str(classic)).read('war3map.j').decode('utf-8'))
    preserved = ['Bazaar_CraftRecipe', 'Bazaar_MaterialsReady', 'Bazaar_InitBrowserData', 'Trig_Bazaar_Recipes_Actions']
    if args.stage == 'AK':
        preserved += ['Trig_Gaya_Follow_MoveGayaToHero', 'Trig_Gaya_GatherItems_Actions']
    if args.stage == 'AL':
        preserved += ['Armory_CollectionText', 'Armory_RefreshCounter', 'Armory_InitCounter']
    for name in preserved:
        assert tokens(after[name]) == tokens(legacy[name]), name
    assert 'Blz' not in legacy['BazaarFrame_Init']
    assert legacy['Bazaar_ShowRecipe'].count('DialogAddButton') == 4
    report = dict(changed_assets=changed, changed_runtime_functions=different,
                  new_runtime_functions=sorted(set(after)-set(before)),
                  recipe_ingredients_results_and_charges_unchanged=True,
                  original_items_and_armory_unchanged=True,
                  classic_uses_AE_dialog_with_same_recipe_transaction=True,
                  unchanged_editor_handlers_resynced=['Trig_Bazaar_PawnMaterial_Actions', 'Trig_Bazaar_Sell_Bundle_Actions'],
                  existing_unit_change=None if browser_exists else 'n030: append Asud only',
                  added_units=[] if browser_exists else ['bRcp'],
                  hashes={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                          for p in [args.base, final, classic]})
    (ROOT/f'release/preservation-r16-stage{args.stage}.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print('PASS preservation: scoped UI changes; recipe data/items/armory collection behavior unchanged.' +
          (' Objects and craft transaction unchanged.' if browser_exists else ' Added recipe button/shop selling ability.'))


if __name__ == '__main__':
    main()

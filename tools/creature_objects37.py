"""Object edits for the V37 creature balance pass."""
import copy
from build_forest86 import all_objects
from priest_master import fields, setf

STATS = {
    'ntrd': (16000, 360), 'ntrg': (None, 210), 'nsgg': (3200, 120),
    'ngst': (3000, None), 'ngrk': (1750, 44), 'ngna': (None, 32),
    'ngnw': (2200, 31), 'ngnv': (3700, None), 'ngno': (None, 35),
    'nwzg': (1900, 19), 'nwzr': (1550, 16), 'nenf': (None, 37),
    'nhdc': (1700, 22), 'n0MQ': (None, 55),
}

def objects(view):
    units = all_objects(view, 'w3u')
    abilities = all_objects(view, 'w3a')
    changed_units, changed_abilities = {}, {}

    def unit(raw):
        return changed_units.setdefault(raw, copy.deepcopy(units[raw]))

    def ability(raw, **values):
        if raw not in changed_abilities:
            changed_abilities[raw] = copy.deepcopy(abilities[raw])
        obj = changed_abilities[raw]
        for field, value in values.items():
            rank = 0 if field in ('anam', 'aart', 'amat') else 1
            setf(obj, field, value, rank)
        return obj

    def describe(raw, name, tooltip, **values):
        return ability(raw, anam=name, atp1=name, aub1=tooltip, **values)

    def clone(raw, template, base=None, **values):
        obj = copy.deepcopy(abilities[template])
        obj['id'] = raw
        if base:
            obj['base'] = base
        changed_abilities[raw] = obj
        return ability(raw, **values)

    def kit(raw, remove=(), add=()):
        obj = unit(raw)
        known = fields(obj).get(('uabi', None), '').split(',')
        setf(obj, 'uabi', ','.join(x for x in dict.fromkeys(known + list(add)) if x and x not in remove), None)

    def channel(raw, template, name, tooltip, order, cooldown, mana, reach, mode):
        clone(raw, template)
        describe(raw, name, tooltip, Ncl6=order, Ncl2=mode, Ncl3=1, acdn=cooldown, amcs=mana, aran=reach)

    for raw, (health, armor) in STATS.items():
        if health is not None:
            setf(unit(raw), 'uhpm', health, None)
        if armor is not None:
            setf(unit(raw), 'udef', float(armor), None)

    describe('fT86', 'Swipe', 'Sweeps the area ahead for 75 physical damage. 400 range, 5-second cooldown.',
             Ncl6='cripple', Ncl2=1, Ncl3=1, aran=400., aare=0., amcs=0, acdn=5.)
    ability('fN86', aub1='Ensnare the enemy with a net. 15-second cooldown.')
    kit('ndtr', ('A03N',))
    kit('nowe', ('bT88',), ('vR37',))
    clone('vR37', 'bBW8')
    describe('vR37', 'Reflection', 'Passively reflects 30% of physical and spell damage received.')
    # The reflection ability is display-only. The shared damage hook owns reflection.
    describe('bG88', 'Charging Strike', 'Dashes to an enemy for 200 fire damage and reduces their evasion by 25% for 5 seconds. 50 mana, 15-second cooldown.')
    ability('xG93', aub1='Evasion is reduced by 25% for 5 seconds.')
    describe('bB88', 'Swipe', 'Sweeps the area ahead for 300 physical damage. Enemies hit bleed for 2% of maximum health each second for 5 seconds. 400 range, 15-second cooldown.', aran=400.)
    clone('vS37', 'Awrs', adur=1., ahdu=1., aub1='Stuns for 1 second. 80 mana, 20-second cooldown.')
    kit('nowk', ('Awrs',), ('vS37',))
    channel('vF37', 'mFB9', 'Fira', 'Deals 200 fire damage in a 300-radius area, then burns it for 100 fire damage per second for 5 seconds. 10-second cooldown.',
            'flamestrike', 10., 40, 600., 2)
    kit('nhrh', ('ACcs',), ('vF37',))
    ability('bS88', adur=1., ahdu=1., aub1='Deals 100 spell damage and stuns for 1 second. 15-second cooldown.')
    ability('bK88', aub1='Taunts for 2 seconds and grants 50 armor for 15 seconds. 150 mana, 30-second cooldown.')
    ability('cP25', aub1='25% chance to inflict 50 + 6 × enemy hero level damage per second for 10 seconds. Venom from different hydras stacks.')
    ability('cP33', aub1='33% chance to inflict 100 + 5 × attacker level damage per second for 10 seconds. Venom from different hydras stacks.')
    ability('cBU5', aub1='Burrows at half health or below for 5 seconds. Emerges fully healed with 25% physical block chance for 10 seconds.')
    ability('cNT5', adur=3., ahdu=3., aub1='Binds the target for 3 seconds. 300 mana, 20-second cooldown.')
    ability('nBU8', adur=0., ahdu=0., aub1='Hurls a boulder for 1500 damage. 100 mana, 15-second cooldown.')
    clone('vW37', 'nBO8', adur=0., ahdu=0., amcs=0, acdn=0.)
    clone('nBO8', 'mFB9')
    describe('nBO8', 'Aquatic Bolt', 'Deals 1000 water damage and reduces water resistance by 25% for 10 seconds.', Ncl6='thunderbolt', acdn=15., amcs=150)
    describe('mTV9', 'Elemental Guard', 'Grants 50% elemental resistance for 15 seconds. 125 mana, 30-second cooldown.')
    clone('vD37', 'bBW8')
    describe('vD37', 'Deconstruct', 'Explodes on death for 2000 wind damage within 400 range.')
    kit('nsgg', ('hTT0',), ('vD37',))
    ability('hHB0', adur=1., ahdu=1., aub1='Deals 800 spell damage and stuns for 1 second. 100 mana, 30-second cooldown.')
    ability('mBI9', acdn=6., aub1='Bites for 600 spell damage and heals the caster for 500. 6-second cooldown.')
    clone('vE37', 'mST9', adur=2., ahdu=2.)
    ability('mSL9', aub1='Deals 600 earth damage and stuns for 2 seconds in a 300 radius.')
    describe('mFB9', 'Slicing Wind', 'Deals 1000 wind damage to a single enemy. 200 mana, 10-second cooldown.', Ncl6='cyclone')
    kit('qS99', ('zIM9',))
    ability('zSY9', aub1='Summons a Sylph for 120 seconds. 800 mana.')
    ability('zDV9', aub1='Devours an injured Ancient Forest ally and gains its stats. The first successful Devour unlocks Imperil.')
    ability('zBP9', aub1='Each attack adds 5% movement and attack speed slow for 60 seconds. At 20 stacks, clears the slow and poisons the hero for 5% max health per second for 5 seconds.')
    slow = ability('zSL9', aub1='Slows movement and attack speed by 5% per active Binding Poison stack.')
    for level in range(1, 20):
        for field, value in [('Slo1', level*.05), ('Slo2', level*.05), ('adur', 60.), ('ahdu', 60.), ('abuf', 'bSL9')]:
            setf(slow, field, value, level)
    setf(ability('zSL9'), 'alev', 19, 0)
    ability('zIT9', aub1='Taunts for 3 seconds and gains 60 armor for 20 seconds.')
    ability('jCL2', aub1='Sends a cold line forward that heals allies for 2500 HP. 100 mana, 15-second cooldown.')
    clone('jRO2', 'mFB9')
    describe('jRO2', 'Wendigo Jump', 'Leaps to an enemy and deals earth damage in a 300 radius. Base 4000, scaled by starting distance up to 1000. 75 mana, 10-second cooldown.',
             Ncl6='clap', acdn=10., amcs=75, aran=1000.)
    ability('kOF2', adur=0., ahdu=0., aub1='Launches a fireball for 2000 omni-elemental damage. 200 mana, 15-second cooldown.')
    for raw, mana, cd in [('kOB2', 1000, 30.), ('kLB2', 200, 10.), ('kWB2', 200, 10.), ('kFB2', 200, 10.)]:
        original = fields(abilities[raw])
        clone(raw, 'mFB9')
        describe(raw, original['anam', 0], original['aub1', 1], Ncl2=2, Ncl6='breathoffire', aran=800., acdn=cd, amcs=mana)
        setf(ability(raw), 'aart', original['aart', 0], 0)
    describe('zAB9', 'Holy Bolt', 'Launches a holy bolt that deals 2000 spell damage.', Ncl6='thunderbolt')
    describe('zIC9', 'Scourge', 'Deals up to 2000 spell damage over 10 seconds and slows enemies around the target.', Ncl6='acidbomb')
    clone('vH37', 'zQB9', adur=0., ahdu=0., Htb1=2000., amat=r'Abilities\Spells\Human\HolyBolt\HolyBoltMissile.mdl')
    clone('vT37', 'xT93', adur=1., ahdu=1.)
    clone('vU37', 'xT93', adur=2., ahdu=2.)
    notes = {
        'nftr':'20 passive evasion.', 'ndtr':'30 passive evasion.', 'nrzs':'30 passive evasion.',
        'nmbg':'40 passive evasion.', 'nowe':'Passively reflects 30% of physical and spell damage received. Blocks 20% of physical attacks and spells.',
        'n00P':'Imperil unlocks after the first successful Devour. Sylph lasts 120 seconds.',
        'qS99':'Summoned for 120 seconds.',
    }
    role_spells = {
        'ngnb':('fT86',), 'nftt':('fN86',), 'nrzb':('bB88',), 'nrzg':('bG88',),
        'nowk':('vS37',), 'nhrh':('vF37',), 'ncea':('bS88',), 'ncnk':('bK88',),
        'nahy':('cP25','cSP7'), 'nehy':('cP33',), 'nsc3':('cBU5',), 'nsrv':('cNT5',),
        'nsgb':('nBU8',), 'nnrg':('nBO8',), 'ngnv':('mTV9','hWW0'), 'nsgg':('vD37',),
        'narg':('hHB0',), 'ngno':('mBI9','hFK0'), 'nogm':('mSL9',), 'nwzr':('mFB9',),
        'nenf':('mTE9',), 'n010':('zBP9','zEG9'), 'qI99':('zIT9',), 'n025':('jCL2','jRG2'),
        'n026':('jRO2',), 'n01N':('zAB9','zIC9','zFL9'), 'n03H':('kOB2','kOF2'),
    }
    ability('mTE9', aub1='Taunts nearby enemies for 1 second. Gains 66% physical and 50% magical block for 10 seconds.')
    for raw in sorted(set(STATS)|set(notes)|set(role_spells)):
        obj=unit(raw)
        data=fields(obj)
        summary=[]
        for field, suffix in [('ulev','level'),('uhpm','HP'),('udef','armor')]:
            value=data.get((field,None))
            if value is not None:
                summary.append(f'{value:g} {suffix}')
        lines=[', '.join(summary)+'.'] if summary else []
        if raw in notes:
            lines.append(notes[raw])
        for spell in role_spells.get(raw,()):
            data=fields(changed_abilities.get(spell) or abilities[spell])
            description=data.get(('aub1',1),'')
            if description and not description.startswith('TRIGSTR_'):
                lines.append(data.get(('anam',0),spell)+': '+description)
        setf(obj,'utub','|n'.join(lines),None)
    return changed_units, changed_abilities


"""Rank-specific damage explanations; no combat balance changes.

The formulas mirror the named spell modules and CombatFormulas.j. Numeric mana
terms and proxy wave counts come from the saved editor master, not fixed ranks.
"""
import copy,re
from objdata import read_objects,write_objects
from priest_master import fields,at,setf
from jtok import functions
from performance_runtime import put

GROUPS={
 'fan':'A0QS', 'knot':'A0SP A17D A0SQ', 'shock':'A13K A15A',
 'rapid':'A0AE', 'arrows':'A0QQ', 'myriad':'A0R0',
 'wave':'A01L A0ZN', 'rave':'A0QO', 'gaya':'A05P', 'gaya_limit':'A0TR',
 'iai':'A18P', 'mineuchi':'A02E A0XR', 'tatsumaki':'A18H A1AT',
 'breath':'A11R A0EL A0SL', 'slam':'A03M', 'jump':'A14D',
 'ambush':'A156', 'shuriken':'A0AD', 'liquid':'A0QH A01Q',
 'eclipse':'A0QJ', 'finisher':'A0HN', 'darkness':'A0KS A0U5 A183',
 'minus':'A0Z5', 'mixture':'A0GZ', 'molotov':'A0ZZ',
 'bolt':'A00O A0TO A07O A19R', 'ice':'A0Q7 A0Q9 A19Q A0IO A0UT A0BG',
 'fire':'A0PU A0QA A19P A0SH', 'tornado':'A149 A00A',
 'meteor':'A0QM A0QN A12I A1F2', 'wide_meteor':'A028',
 'shot':'A171', 'scourge':'A0VM A12M A0VL A0X5',
 'firaga':'A0QD A0UX A0SG', 'thundaga':'A0QF A0UZ A0TN',
 'blizzaga':'A17S A0TM A0UY', 'blast':'A039 A0UF',
 'flare':'A0TB A0TD A0TC A0TF A0TE',
 'holy':'A04K A01V A0E5 A11X A0UE A0XI A0CY A11L', 'oblivion':'A0ZV',
}
KINDS={raw:kind for kind,raws in GROUPS.items() for raw in raws.split()}
MARK='|n|n|cffffcc00Damage details|r|n'
FOOT='|nSTR/AGI/INT include bonuses. Mana fraction = current MP / maximum MP at cast time. Values are before damage bonuses, defenses and hit rolls; integer divisions round down.'


def merged(main,skin,ext):
    result={o['id']:copy.deepcopy(o) for o in read_objects(main,ext)['custom']}
    if skin:
        for o in read_objects(skin,ext)['custom']:
            if o['id'] not in result:result[o['id']]=copy.deepcopy(o);continue
            for st in o['sets']:
                for m in st['mods']:
                    target=result[o['id']]['sets'][0]['mods']
                    target[:]=[old for old in target if (old['field'],old['level'])!=(m['field'],m['level'])]
                    target.append(copy.deepcopy(m))
    return result


def catalogue(main,skin,item_main,item_skin):
    abilities=merged(main,skin,'w3a');items=merged(item_main,item_skin,'w3t')
    missing=set(KINDS)-abilities.keys()
    if missing:raise ValueError('damage tooltip abilities missing: '+','.join(sorted(missing)))
    scrolls={r for r,o in items.items() if r=='I073' or fields(o).get(('unam',None),'').startswith('Curse: ')}
    if 'I073' not in scrolls or len(scrolls)<2:raise ValueError('curse scroll catalogue missing')
    return dict(abilities=abilities,scrolls=scrolls)


def technique(base,proficiency,rate=.1):
    return base+' x (1 + '+str(int(rate*100))+'% x '+proficiency+' proficiency).'


def spell(base,proficiency,weight=.5):
    return (base+' x '+proficiency+' spell power.|n'+proficiency+' spell power = 1 + '
            +str(int(weight*100))+'% x mana fraction x (1 + 10% x effective '+proficiency+' proficiency). '
            'Mind Charge doubles it; Concentration multiplies it by 1.5 at full mana.')


def details(raw,rank,config):
    kind=KINDS[raw];a=config['abilities'];f=fields(a[raw]);mana=int(at(f,'amcs',rank,0))
    proxy=lambda r,k,level=1,default=0:at(fields(a[r]),k,level,default)
    if kind=='fan':return 'Damage to each enemy: '+technique(f'({mana*2} + 4 x AGI)','Dagger')
    if kind=='knot':return 'Damage: '+technique(f'({mana*4} + floor(20% of current HP))','Tools')
    if kind=='shock':return 'Thunder damage to each enemy: '+technique(f'({mana*3} + 4 x STR)','combined Sword/Axe')+' Combined proficiency is effective Sword plus Axe proficiency.'
    if kind=='rapid':return ('Damage per arrow: 93.75%-100% of '+technique(f'({mana} + 2 x AGI)','Bow')+' 16 arrows; each can explode on nearby enemies.')
    if kind=='arrows':return 'Damage to each enemy: '+technique(f'({mana*4} + 2 x AGI)','Bow')
    if kind=='myriad':return ('Physical damage per wave: '+technique(f'({mana//2} + AGI)','Bow')+f" {int(proxy('A0X4','Hbz1',rank,20))} waves if all land.")
    if kind in {'wave','rave'}:
        base=f'({mana*3} + 8 x STR)' if kind=='wave' else f'({mana*4} + 10 x STR)'
        return ('Damage: '+base+'. When unarmed (barehanded weapons qualify): x2, or x3 against a stunned/dazed target. '
                'High Proficiency additionally multiplies this by 5/3.'+(' Collision with an obstacle deals the same amount again.' if kind=='wave' else ''))
    if kind=='gaya':return 'Damage to each enemy: '+technique(f'({mana*6} + 6 x STR)','Axe')
    if kind=='gaya_limit':return 'True damage to each enemy: 93,749.9-99,999.9 (93.75%-100% of 99,999.9).'
    if kind=='iai':return ('Damage: '+technique(f'({mana*10} + 8 x STR + 8 x AGI)','Katana')+' During Combo Strike, multiply by (1 + 10% x recorded combo hits).')
    if kind=='mineuchi':return 'Damage: '+technique(f'({mana*3} + 2 x STR + 2 x AGI)','Katana')
    if kind=='tatsumaki':return ('Final strike damage: '+technique(f'({mana*3} + 3 x STR + 3 x AGI)','Katana')+' Each spinning damage tick deals 10% of that amount.')
    if kind=='breath':return ('Fire damage per burn tick: '+technique(f'floor(({mana*4} + STR + AGI + INT) / 4)','Spear',.2)+f" Burn lasts {proxy('A0RJ','adur'):g} seconds; the initial cone has no separate damage.")
    if kind=='slam':return 'Earth damage to each enemy: '+technique(f'({mana*3} + STR + AGI + INT)','Spear',.2)
    if kind=='jump':return ('Direct damage: '+technique(f'({mana} + STR + AGI + INT) x 0.02 x (starting distance + 200)','Spear')+' Distance caps at 1,000. Nearby enemies take 50% of direct damage; the main target is excluded from this splash.')
    if kind=='ambush':return 'Damage: '+technique(f'({mana} + 3 x AGI)','Dagger')+' Starting within 420 range triples damage; farther away uses normal damage and stuns.'
    if kind=='shuriken':return 'Damage per contact: '+technique(f'({mana*5} + 3 x AGI)','Dagger')
    if kind=='liquid':return 'Water damage per hit: '+technique(f'({mana*2} + 3 x STR + INT)','Hybrid')+hybrid()
    if kind=='eclipse':return 'Ice damage to each enemy: '+technique(f'({mana*2} + 5 x STR + 2 x INT)','Hybrid')+hybrid()
    if kind=='finisher':
        counts=[sum(test(n) for n in range(rank,rank+26)) for test in [lambda n:n<=10,lambda n:10<n<=18,lambda n:18<n<=24,lambda n:n>24]]
        chances=[f'{v}/26 ({v/26*100:.1f}%)' for v in counts]
        return ('Possible outcomes at this rank:|nFailed: 0 damage; '+chances[0]+'.'
            '|nMighty Swipe: (200 + 3 x STR) x (10 + Hybrid proficiency) physical damage in 300 radius; '+chances[1]+'.'
            '|nHoly Strike: (50 + 2 x STR) x (10 + Hybrid proficiency) physical damage, ignoring damage reduction; '+chances[2]+'.'
            '|nElemental Quartet: 9,999 pure base damage using the last recorded element; fails if none is recorded; '+chances[3]+'.'
            '|nWhile Holy Power is active, Holy Strike is guaranteed.'+hybrid())
    if kind=='darkness':return 'Damage to each enemy: '+spell(f'({mana*4} + 6 x INT)','Staff')+' Costs 12.5% of maximum HP.'
    if kind=='minus':return ('Damage: 500 + ['+technique(f'({mana*30} + 25 x STR)','Hybrid').rstrip('.')+' / max(1, sqrt(current HP percent / 4))]. '+hybrid())
    if kind=='mixture':return (f'Damage per cloud pulse: [({mana//10} x potency + INT bonus) x Tools spell power] / 10.'
        '|nPotion / Hi / Mega / X: potency 80 / 125 / 200 / 300, INT bonus = 6 x INT.'
        '|nEther / Hi / Mega / Turbo / Elixir: potency 100 / 156 / 250 / 375 / 625, INT bonus = 6 x INT.'
        '|nNectar / Greater Nectar / Hero Drink: potency 80 / 125 / 200, INT bonus = 3 x INT; pure damage also multiplied by difficulty scale.'
        '|nOther mixtures deal magical damage. Cloud lasts 5.7 seconds. Uses the first Chemist item in hero slots, then backpack order.'
        '|n'+spell('Tools spell power','Tools').split('|n',1)[1])
    if kind=='molotov':return 'Fire damage each time the victim attacks: '+spell(f'({mana//5+2} + INT)','Tools')
    if kind=='bolt':return 'Direct Thunder damage: '+spell(f'({mana*2} + 3 x INT)','Rod')+' Each of the 10 outgoing bolts deals 30% of direct damage.'
    if kind=='ice':return 'Ice damage: '+spell(f'({mana*3} + 4 x INT)','Rod')
    if kind=='fire':return 'Fire damage per damage pulse: '+spell(f'({mana//4} + floor(INT / 2))','Rod')+' The same damage formula applies to both burning phases while the enemy remains in the fire.'
    if kind=='tornado':return 'Wind damage: '+spell(f'({mana*3} + 4 x INT)','Rod')
    if kind=='meteor':return ('Damage per wave: '+spell('(250 + floor(INT / 2))','Inner Mana',1.)+f" {int(proxy('A0X3','Hbz1',max(1,min(20,mana//50)),2))} waves if all land.")
    if kind=='wide_meteor':return 'Damage per wave: '+spell('(100 + 2 x INT)','Inner Mana',1.)+f" {int(proxy('A0W0','Hbz1',1,20))} waves if all land."
    if kind=='shot':return ('MP damage = floor('+spell(f'({mana*2} + floor(INT / 4))','Gun').split('|n')[0].rstrip('.')+'). HP damage = 4 x MP damage. Allies recover those amounts instead.'+'|n'+spell('','Gun').split('|n',1)[1])
    if kind=='scourge':return 'Damage per poison pulse: '+spell(f'({mana//3} + floor(INT / 2))','Inner Mana',1.)+f" Pulse interval {proxy('A0VK','Nab6',1,.5):g} seconds for {proxy('A0VK','adur',1,10):g} seconds."
    if kind=='firaga':return 'Fire damage: '+spell(f'({mana*4} + 3 x INT)','Rod')
    if kind=='thundaga':return 'Thunder damage to each struck enemy: '+spell(f'({mana*2} + 3 x INT)','Rod')
    if kind=='blizzaga':return 'Damage per Ice wave: '+spell(f'({mana*.65:g} + 1.5 x INT)','Rod')+f' Each shard: ({mana*.25:g} + INT) x Rod spell power. Fires 3 waves; the middle wave splits into shards.'
    if kind=='blast':return 'Direct damage: '+spell(f'({mana*6} + 4 x INT)','Staff')+' Enemies passed by the missile take 66% of direct damage.'
    if kind=='flare':return 'Damage to each enemy: '+spell(f'({mana*4} + 4 x INT)','Inner Mana',1.)
    if kind=='holy':return 'Enemy damage and allied healing: '+spell(f'({mana*2} + 2 x INT)','Staff')
    if kind=='oblivion':return ('Enemy damage per pulse: 3 x ('+str(mana//3)+' + floor(INT / 2)) x Staff spell power.'
        '|nUndead hero healing per pulse: 93.75%-100% of floor(('+str(mana//3)+' + floor(INT / 2)) x Staff spell power); other undead allies receive half.'
        '|nPulses every 0.8 seconds for 8 seconds.'+'|n'+spell('','Staff').split('|n',1)[1])
    raise ValueError(kind)


def hybrid():return '|nHybrid proficiency = floor((effective Greatsword + Sword + Staff proficiency) / 2).'


def description(raw,rank,text,config):
    """Remove authored numeric claims contradicted by the scripted calculation."""
    kind=KINDS[raw];a=config['abilities']
    if kind=='blast':text=text.replace('33% damage','66% damage')
    if kind in {'bolt','ice'}:
        text=re.sub(r'dealing \d+ damage','dealing damage',text)
        text=re.sub(r'damaging them for \d+ hit points','damaging them',text)
    if kind=='fire':
        text=re.sub(r'Conjures a pillar.*?(?=\|n|$)',
            'Conjures a pillar of fire that repeatedly burns enemies in the target area. Damage per pulse is shown below.',text)
    if kind=='meteor':
        f=fields(a[raw]);mana=int(at(f,'amcs',rank,0))
        waves=int(at(fields(a['A0X3']),'Hbz1',max(1,min(20,mana//50)),2))
        text=re.sub(r'\d+ waves of meteors',str(waves)+' waves of meteors',text)
    if kind=='myriad':text=text.replace('over the next 5 seconds','over successive waves')
    if kind=='liquid':
        hits=10 if raw=='A01Q' else 15 if rank>=11 else rank+2
        text=re.sub(r'for up to \d+ bounces','for up to '+str(hits)+' hits',text)
    if kind=='thundaga':
        targets=int(at(fields(a['A0QE']),'Ocl2',rank,3))
        text=re.sub(r'up to \d+ enemy units','up to '+str(targets)+' enemy units',text)
    if kind=='scourge':text=text.replace('for 5 seconds','for 10 seconds')
    return text


def abilities(data,config):
    if not data:return data
    table=read_objects(data,'w3a')
    for obj in table['custom']:
        raw=obj['id']
        if raw not in KINDS:continue
        original=fields(config['abilities'][raw]);levels=original.get(('alev',0),1)
        for rank in range(1,levels+1):
            base=description(raw,rank,str(at(original,'aub1',rank,'' )).split(MARK)[0],config)
            # Keep authored effects, targeting and duration text; add precise rank data.
            text=base+MARK+details(raw,rank,config)+FOOT
            setf(obj,'aub1',text,rank)
        learn=str(original.get(('arut',0),original.get(('arut',1),''))).split(MARK)[0]
        if learn:setf(obj,'arut',learn+'|n|nLearned-rank damage formulas are shown on the ability tooltip.',1)
    return write_objects(table,table['version'],'w3a')


def scroll_objects(data,config):
    if not data:return data
    table=read_objects(data,'w3t')
    for obj in table['custom']:
        if obj['id'] not in config['scrolls']:continue
        for st in obj['sets']:
            mods=st['mods']
            for m in mods:
                if m['field'] in {'utub','ides'}:
                    # This is the resulting equipment's level, not the scroll's.
                    m['value']=m['value'].replace('Required level','Resulting gear required level')
                    if 'No level requirement to carry this scroll.' not in m['value']:
                        m['value']+='|n|nNo level requirement to carry this scroll.'
    return write_objects(table,table['version'],'w3t')


def runtime(source):
    name='Trig_Equip_Restrictions_GaiaLevelTooLow'
    fs=functions(source)
    if name not in fs:return source
    body=fs[name]
    if '"Curse: "' in body:return source
    item='Forsaken_EventItem()' if 'Forsaken_EventItem()' in body else 'GetManipulatedItem()'
    body=body.replace('    return(',f'    return(GetItemTypeId({item})!=\'I073\')and(SubString(GetItemName({item}),0,7)!="Curse: ")and(',1)
    return put(source,name,body)

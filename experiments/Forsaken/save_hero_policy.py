"""Detached saved-job policy. No native XP/stat guesses or gameplay writes."""
from dataclasses import dataclass

import save_progression as progression
import save_vnext as codec

# Reviewed runtime bindings, derived after decoding; never persisted identities.
GAYA_SUPPORT_RESEARCH = ('Resi', 'R00F', 'R00G')


@dataclass(frozen=True)
class JobPlan:
    identity: int
    saved_level: int
    native_level: int
    mastery_rank: int
    attribute_bonus: int
    skill_ranks: tuple
    points: int


@dataclass(frozen=True)
class HeroPolicy:
    envelope: codec.Envelope
    jobs: tuple
    dormant_jobs: tuple
    gaya: 'GayaPlan'
    freelancer: 'FreelancerPlan'


@dataclass(frozen=True)
class FreelancerPlan:
    saved_level: int
    native_level: int
    mastery_rank: int
    attributes: tuple
    borrowed_choices: tuple = (0, 0, 0, 0)


def freelancer(saved_level, jobs):
    # Current staging owns H02L, the Strength variant. Other variants need adapters.
    marker = normal_job(1, saved_level)
    if not set(range(1,23)) <= jobs.keys():
        raise codec.Error('missing reviewed Freelancer inheritance job')
    for identity in range(1,23): normal_job(identity, jobs[identity])
    bonus = (0,0,20,50,100)[marker.mastery_rank]
    strength = agility = intelligence = 10 + bonus
    # Existing inheritance uses saved level99+, independently of skill mastery50.
    for index in range(10):
        if jobs[index+1] >= 99:
            if index % 9 == 0:
                strength += 24; agility += 24
            elif index % 2:
                strength += 48
            else:
                agility += 48
    intelligence += 24 * sum(jobs[i+1] >= 99 for i in range(10,20))
    if jobs[21] >= 99: strength += 16; agility += 16
    if jobs[22] >= 99: intelligence += 16
    strength += marker.native_level + 39
    agility += marker.native_level // 2
    intelligence += marker.native_level // 2
    return FreelancerPlan(saved_level, marker.native_level, marker.mastery_rank,
                           (strength,agility,intelligence))


@dataclass(frozen=True)
class GayaPlan:
    saved_level: int
    native_level: int
    mastered: bool
    support_ranks: tuple
    chants: tuple
    spiritual_power: int
    purchases: tuple

    @property
    def research(self):
        return tuple((raw, int(purchased)) for raw, purchased in zip(GAYA_SUPPORT_RESEARCH, self.purchases))

    @property
    def spiritual_power_available(self):
        return any(self.chants)


def gaya(values):
    # Validate through the existing reviewed schema, including mastered consistency.
    encoded = progression.scalars(values, progression.GAYA)
    checked = progression.read_scalars(encoded, progression.GAYA)
    if set(checked) != {name for name, _ in progression.GAYA.values()}:
        raise codec.Error('missing Gaya field')
    if checked['mastered'] and (checked['level'] != 99 or any(
            checked[name] != maximum for i, (name, maximum) in progression.GAYA.items() if i >= 3)):
        raise codec.Error('inconsistent mastered Gaya')
    supports = tuple(checked[n] for n in ('break_stun', 'mana_transfer', 'mega_heal'))
    chants = tuple(bool(checked[n]) for n in ('tarugaya', 'sukugaya', 'rakugaya'))
    return GayaPlan(checked['level'], max(1, checked['level']), bool(checked['mastered']),
                    supports, chants, 1 + sum(weight for weight, owned in zip((1,2,4), chants) if owned),
                    tuple(rank > 0 for rank in supports))


def normal_job(identity, saved_level):
    if type(identity) is not int or not 1 <= identity <= 22:
        raise codec.Error('unreviewed normal job identity')
    if type(saved_level) is not int or not 0 <= saved_level <= 100:
        raise codec.Error('invalid saved job level')
    # Zero means no saved progress; materializing later creates a level-one job.
    # 100 is the existing enhanced-mastery sentinel, not a native normal-job level.
    level = max(1, min(saved_level, 99))
    rank, bonus = (4, 100) if saved_level == 100 else (
        (3, 50) if saved_level == 99 else ((2, 20) if saved_level >= 50 else (1, 0)))
    skills = (11, 11, 11, 11, 6) if level >= 50 else (0, 0, 0, 0, 0)
    return JobPlan(identity, saved_level, level, rank, bonus, skills,
                   level - 50 if level >= 50 else level)


def plan(envelope, expected_account):
    """Resolve reviewed jobs while retaining the complete accepted envelope."""
    if type(expected_account) is not int or not 0 <= expected_account < 1048576:
        raise codec.Error('invalid expected account')
    if envelope.account_hash != expected_account:
        raise codec.Error('account mismatch')
    snapshot = progression.snapshot(envelope)
    if snapshot['core']['cheater_flag']:
        raise codec.Error('cheat status requires separate reviewed load policy')
    jobs = tuple(normal_job(i, snapshot['jobs'][i]) for i in range(1, 23))
    dormant = tuple(sorted((i, v) for i, v in snapshot['jobs'].items() if i > 22))
    return HeroPolicy(envelope, jobs, dormant, gaya(snapshot['gaya']),
                       freelancer(snapshot['core']['freelancer'], snapshot['jobs']))

"""Detached saved-job policy. No native XP/stat guesses or gameplay writes."""
from dataclasses import dataclass

import save_progression as progression
import save_vnext as codec


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
    return HeroPolicy(envelope, jobs, dormant)

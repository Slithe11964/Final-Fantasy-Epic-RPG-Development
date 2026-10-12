"""Swap the save transport's sync delivery for the game cache when targeting 1.29.2.

1.29.2 has no BlzSendSyncData, BlzGetTriggerSyncData or BlzTriggerRegisterPlayerSyncEvent.
Those three natives are confined to the FSTSync_ wrappers, so the conversion empties those
functions and flips FST_UseSyncNative, leaving the transport to carry the same packets
through the game cache. Every other line of the save system is untouched.
"""
import re

from jtok import functions

SWITCH = re.compile(r'(constant boolean FST_UseSyncNative\s*=\s*)true\b')


def convert(text):
    if 'FST_UseSyncNative' not in text:
        return text
    crlf = '\r\n' in text
    text = text.replace('\r\n', '\n')
    text, count = SWITCH.subn(r'\1false', text)
    if count != 1:
        raise ValueError('expected one FST_UseSyncNative constant, found %d' % count)
    emptied = 0
    for name, body in functions(text).items():
        if not name.startswith('FSTSync_'):
            continue
        header = re.search(r'^\s*(function[^\n]+)', body, re.M)[1]
        if not header.endswith('returns nothing'):
            raise ValueError('a sync wrapper must return nothing: ' + header)
        text, found = re.subn(r'^\s*function ' + name + r'\s+takes.*?^\s*endfunction[^\n]*',
                              lambda m: '\n' + header + '\nendfunction', text, flags=re.M | re.S)
        if found != 1:
            raise ValueError('expected one sync wrapper: ' + name)
        emptied += 1
    if emptied < 3:
        raise ValueError('expected the three sync wrappers, emptied %d' % emptied)
    for native in ('BlzSendSyncData', 'BlzGetTriggerSyncData', 'BlzTriggerRegisterPlayerSyncEvent'):
        if native in text:
            raise ValueError('a 1.29.2 native that does not exist survived the conversion: ' + native)
    return text.replace('\n', '\r\n') if crlf else text

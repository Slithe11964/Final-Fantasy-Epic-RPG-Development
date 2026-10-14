"""Swap the save transport's sync delivery for the game cache when targeting 1.29.2.

1.29.2 has no BlzSendSyncData, BlzGetTriggerSyncData or BlzTriggerRegisterPlayerSyncEvent.
Those three natives are confined to the FSTSync_ wrappers, so the conversion empties those
functions and flips FST_UseSyncNative, leaving the transport to carry the same packets
through the game cache. Every other line of the save system is untouched.

The same conversion switches on SAVE_NEW_FORMAT (src/triggers/12 Save system/SaveSlots.j), so the
1.29.2 map saves the new code that Reforged uses and still loads old codes, while the Reforged
map keeps its own save.
"""
import re

from jtok import functions, strip_comments

SWITCH = re.compile(r'(constant boolean FST_UseSyncNative\s*=\s*)true\b')
NEW_FORMAT = re.compile(r'(constant boolean SAVE_NEW_FORMAT\s*=\s*)false\b')


def convert(text):
    if 'FST_UseSyncNative' not in text:
        return text
    crlf = '\r\n' in text
    text = text.replace('\r\n', '\n')
    text, count = SWITCH.subn(r'\1false', text)
    if count != 1:
        raise ValueError('expected one FST_UseSyncNative constant, found %d' % count)
    if 'SAVE_NEW_FORMAT' in text:
        text, count = NEW_FORMAT.subn(r'\1true', text)
        if count != 1:
            raise ValueError('expected one SAVE_NEW_FORMAT constant, found %d' % count)
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
        if native in strip_comments(text):  # a comment may still name it
            raise ValueError('a 1.29.2 native that does not exist survived the conversion: ' + native)
    return text.replace('\n', '\r\n') if crlf else text

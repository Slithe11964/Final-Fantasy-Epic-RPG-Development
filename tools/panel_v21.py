"""Observe live native panes; never let a presentation latch hide companions."""
from jtok import functions
from performance_runtime import put

def refresh(source):
 fs=functions(source)
 b=fs['Forsaken_BackpackVisible']
 b=b.replace('local boolean visible=gear!=null and backdrop!=null and bag!=null',
 '''// The engine may rebind the two content panes separately after an item
    // transfer. Either live content pane means the native backpack is open.
    // The decorative backdrop is an anchor, not an open/closed authority.
    local boolean visible=gear!=null or bag!=null''')
 old='''    elseif ForsakenBackpackExplicitlyClosed then
        set visible=false
    elseif visible then'''
 assert old in b
 b=b.replace(old,'''    elseif visible then
        // Native visibility wins over stale B/mouse intent. Explicit close
        // already hides the live panes; observation must never reopen them.
        set ForsakenBackpackExplicitlyClosed=false''',1)
 source=put(source,'Forsaken_BackpackVisible',b)
 b=fs['Forsaken_PollPanels']
 marker='''    set nativePanel=ForsakenCachedEquipment
    set anchor=ForsakenCachedBackdrop
    call Forsaken_BackpackInputControl'''
 assert marker in b
 b=b.replace(marker,'''    set nativePanel=ForsakenCachedEquipment
    set anchor=ForsakenCachedBackdrop
    if visible and anchor==null then
        set anchor=nativePanel
        if anchor==null then
            set anchor=ForsakenLinkedBag
        endif
    endif
    call Forsaken_BackpackInputControl''',1)
 # Do not replace the valid fallback again later in the same poll.
 old='''        if nativePanel!=null then
            set nativePanel=ForsakenCachedEquipment
            set anchor=ForsakenCachedBackdrop
            if not visible then
                set ForsakenPanelOpen=false
            endif
        endif'''
 assert old in b
 b=b.replace(old,'''        if not visible then
            set ForsakenPanelOpen=false
        endif''',1)
 return put(source,'Forsaken_PollPanels',b)

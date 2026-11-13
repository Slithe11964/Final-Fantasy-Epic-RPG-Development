"""Regular gear dock on a persistent native full-width UI host."""
from jtok import functions
from performance_runtime import put

def refresh(source):
    source=source.replace('endglobals','    leaderboard GearLayer31Board=null\n    framehandle GearLayer31Host=null\nendglobals',1)
    f=functions(source)
    b=f['QuickGear_Init']
    b=b.replace('    local integer modifier','    local leaderboard previousBoard=null\n    local integer modifier',1)
    old='    set QuickGearRoot=BlzCreateFrameByType("FRAME","GearDock25",BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)),"",900)'
    assert old in b
    b=b.replace(old,'''    // Allocate the native host once in shared startup, never in a local poll.
    // Preserve each player's existing Hunt/Festival leaderboard association.
    if GearLayer31Board==null then
        set GearLayer31Board=CreateLeaderboard()
        call LeaderboardSetLabel(GearLayer31Board,"")
        set pid=0
        loop
            exitwhen pid>=bj_MAX_PLAYERS
            set previousBoard=PlayerGetLeaderboard(Player(pid))
            call PlayerSetLeaderboard(Player(pid),GearLayer31Board)
            call PlayerSetLeaderboard(Player(pid),previousBoard)
            set pid=pid+1
        endloop
        call LeaderboardDisplay(GearLayer31Board,true)
        set GearLayer31Host=BlzGetFrameByName("Leaderboard",0)
        call BlzFrameSetSize(GearLayer31Host,0.,0.)
        call BlzFrameSetVisible(BlzGetFrameByName("LeaderboardBackdrop",0),false)
        call BlzFrameSetVisible(BlzGetFrameByName("LeaderboardTitle",0),false)
        set pid=0
    endif
    set QuickGearRoot=BlzCreateFrameByType("FRAME","GearDock25",GearLayer31Host,"",900)''',1)
    b=b.replace('    set displayParent=null\nendfunction','    set displayParent=null\n    set previousBoard=null\nendfunction')
    source=put(source,'QuickGear_Init',b)
    source=put(source,'QuickGear_Layout','''function QuickGear_Layout takes nothing returns nothing
    // Owner-confirmed bottom-right location, beside command rows two and three.
    call BlzFrameClearAllPoints(QuickGearRoot)
    call BlzFrameSetAbsPoint(QuickGearRoot,FRAMEPOINT_TOPLEFT,.812,.085)
endfunction''')
    b=f['QuickGear_Poll']
    old='        if show!=BlzFrameIsVisible(QuickGearRoot) then'
    assert old in b
    b=b.replace(old,'''        // Native Hunt/Festival board switching can hide another board frame.
        // Restore only this empty presentation host; leave those boards alone.
        if show and GearLayer31Host!=null and not BlzFrameIsVisible(GearLayer31Host) then
            call BlzFrameSetVisible(GearLayer31Host,true)
        endif
'''+old,1)
    source=put(source,'QuickGear_Poll',b)
    return source

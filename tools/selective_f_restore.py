"""Small independent restorations on the dated-f inventory rollback.

No Inventory94 catalogue, snapshots, local inventory mutations, or alternate
profile capture path. Cinematic gates read only shared cinematic flags.
"""
import re
from jtok import functions
from performance_runtime import put

AUTO_GLOBALS='''    real RestoreAutoNext=1200.
    boolean array RestoreAutoPending
    boolean array RestoreAutoOff
'''
AUTO='''function Restore_AutosaveTick takes nothing returns nothing
    local integer pid=0
    local integer active=0
    local real now=TimerGetElapsed(FST_Clock)
    if not udg_GameRunning or not udg_HardcoreOff then
        return
    endif
    if now>=RestoreAutoNext then
        loop
            exitwhen pid>=8
            if IsPlayerInForce(Player(pid),udg_PlayingPlayers) and not RestoreAutoOff[pid] then
                set RestoreAutoPending[pid]=true
            endif
            set pid=pid+1
        endloop
        loop
            exitwhen RestoreAutoNext>now
            set RestoreAutoNext=RestoreAutoNext+600.
        endloop
    endif
    if udg_InCinematicMode or InventoryCinematicActive then
        return
    endif
    set pid=0
    loop
        exitwhen pid>=8
        if FFL_Phase[pid]!=0 or FFP_Locked[pid] or FRC_Phase[pid]!=0 or FSC_Busy[pid] or FSC_Writing[pid] or FST_Pending[pid] then
            return
        endif
        set pid=pid+1
    endloop
    set pid=0
    loop
        exitwhen pid>=8
        if RestoreAutoPending[pid] then
            if RestoreAutoOff[pid] or not IsPlayerInForce(Player(pid),udg_PlayingPlayers) then
                set RestoreAutoPending[pid]=false
            elseif udg_PlayerHero[pid+1]!=null and udg_SpiritOfGaya[pid+1]!=null and udg_PlayerHouse[pid+1]!=null then
                if FST_SetFileStem(pid,"autosave") then
                    if FFL_BeginSave(pid,true,true) then
                        set RestoreAutoPending[pid]=false
                    endif
                endif
                // At most one capture starts per shared heartbeat.
                return
            endif
        endif
        set pid=pid+1
    endloop
endfunction
'''
COMMAND='''function Trig_Autosave_Command_Actions takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    local string command=StringCase(GetEventPlayerChatString(),false)
    if pid<0 or pid>=8 then
        return
    endif
    if command=="-autosave off" then
        set RestoreAutoOff[pid]=true
        set RestoreAutoPending[pid]=false
        call Collection_ForceRemovePlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
    elseif command=="-autosave on" then
        set RestoreAutoOff[pid]=false
        call Collection_ForceAddPlayerSimple(GetTriggerPlayer(),udg_AutosaveForce)
    elseif command=="-autosave now" then
        if not RestoreAutoOff[pid] then
            set RestoreAutoPending[pid]=true
        endif
    elseif command!="-autosave" then
        return
    endif
    if RestoreAutoOff[pid] then
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is OFF. Use -autosave on to enable it.")
    else
        call DisplayTimedTextToPlayer(GetTriggerPlayer(),0.,0.,10.,"Autosave is ON. First save at minute 20, then every 10 minutes. Busy or cinematic saves wait until ready.")
    endif
endfunction'''

def guard(body):
    lines=body.splitlines();i=next(j for j,line in enumerate(lines) if line.startswith('function '))+1;initializers=[]
    while i<len(lines) and (not lines[i].strip() or lines[i].lstrip().startswith(('local ','//'))):
        m=re.match(r'(\s*local \w+ )(\w+)=(.*)',lines[i])
        if m:
            lines[i]=m[1]+m[2];initializers.append('    set '+m[2]+'='+m[3])
        i+=1
    lines[i:i]=['    if udg_InCinematicMode or InventoryCinematicActive then','        return','    endif']+initializers
    return '\n'.join(lines)+'\n'

# These are shared heartbeat entry points or presentation entry points. Gate
# before their executable reads. No owner test controls any gameplay mutation.
GATED={'UI72_Tick','Forsaken_PollPanels','Forsaken_PrepareInventories',
 'Forsaken_UpdatePanels','Forsaken_SyncStoredEffects','Inventory71_Reconcile',
 'Chronicles_Tick','Trig_Passive_Bonus_Sync_Actions',
 'Trig_Status_AutoCleanse_Actions','Talent_ShieldDisplayTick',
 'QuickGear_Request','BagScreen_Click66','Forsaken_PanelAccess',
 'Forsaken_BackpackToggleAction','Forsaken_BackpackCloseAction'}

def refresh(lib,s,classic=False):
    fs=functions(s)
    if lib=='TAutosave':
        s=s.replace('endglobals',AUTO_GLOBALS+'endglobals',1) if 'endglobals' in s else s.replace('\nfunction ','\nglobals\n'+AUTO_GLOBALS+'endglobals\n\nfunction ',1)
        s=put(s,'Trig_Autosave_Command_Actions',COMMAND)
    if lib=='TSave':
        # Old native timer can be enabled by game/load setup in classic. It must
        # not independently save one player per minute ahead of the new cadence.
        s=put(s,'Save_Autosave','''function Save_Autosave takes nothing returns nothing
    // One shared scheduler owns cadence and pending work on every build.
    call ExecuteFunc("Restore_AutosaveTick")
endfunction''')
    if lib=='TForsakenFreshLoad':
        s=s.replace('function FFL_Autosave takes',AUTO+'\nfunction FFL_Autosave takes',1)
        if classic:
            b=functions(s)['InitTrig_ForsakenFreshLoad']
            b=b.replace('    call FRC_Init()','    call TimerStart(CreateTimer(),1.,true,function Restore_AutosaveTick)\n    call FRC_Init()',1)
            s=put(s,'InitTrig_ForsakenFreshLoad',b)
    if lib=='TEquip' and 'Forsaken_PrepareInventories' in fs:
        b=fs['Forsaken_PrepareInventories']
        remove='        call TriggerClearActions(udg_NewGamePlusTrig)\n        call TriggerAddAction(udg_NewGamePlusTrig,function Forsaken_SaveUnavailable)\n'
        assert remove in b;b=b.replace(remove,'',1)
        # Shared existing 1Hz callback, independent of legacy timer action clearing.
        b=b.replace('    local unit hero\n','    local unit hero\n    call ExecuteFunc("Restore_AutosaveTick")\n',1)
        s=put(s,'Forsaken_PrepareInventories',b)
        # Native controls keep their engine binding. Do not infer another owner's
        # inventory from arbitrary visible frames while inspecting that player.
        s=put(s,'Forsaken_InventoryContext','''function Forsaken_InventoryContext takes unit hero,player viewer returns boolean
    return hero!=null and GetOwningPlayer(hero)==viewer and IsUnitSelected(hero,viewer) and ForsakenInspectTarget==null
endfunction''')
        b=fs['Forsaken_BackpackVisible'];needle='    if InventoryCinematicActive then'
        assert needle in b
        b=b.replace(needle,'''    if not Forsaken_InventoryContext(hero,GetLocalPlayer()) then
        set gear=null
        set backdrop=null
        set bag=null
        set hero=null
        return false
    endif
'''+needle,1);s=put(s,'Forsaken_BackpackVisible',b)
        context=functions(s)['Forsaken_InventoryContext']
        s=s.replace(context,'',1)
        s=s.replace('function Forsaken_BackpackVisible takes',context+'\n\nfunction Forsaken_BackpackVisible takes',1)
        # Only the native button/key input owns visibility intent. A synchronized
        # spell-cast notification must not toggle a presentation a second time.
        b=fs['Forsaken_RegisterBackpackActivity']
        b=b.replace('        call TriggerRegisterAnyUnitEventBJ(ForsakenBackpackToggleEvents,EVENT_PLAYER_UNIT_SPELL_CAST)\n','')
        s=put(s,'Forsaken_RegisterBackpackActivity',b)
        b=fs['Forsaken_BackpackToggleAction']
        b=b.replace("set clicked=GetSpellAbilityId()=='ASpc' and GetTriggerUnit()==hero","set clicked=false",1)
        s=put(s,'Forsaken_BackpackToggleAction',b)
        # Owner refreshes may update shared stats; only the owner (or an explicit
        # inspector) draws that hero's presentation. No unit/item change here.
        b=fs['Forsaken_DrawPanels'];needle='    if job<0 then'
        b=b.replace(needle,'''    if GetLocalPlayer()!=owner and ForsakenInspectTarget!=hero then
        set owner=null
        set previous=null
        return
    endif
'''+needle,1);s=put(s,'Forsaken_DrawPanels',b)
    if lib=='TSpellBlizzaga':
        b=fs['Trig_Spell_Blizzaga_Start'];needle='    set udg_BlizzagaCaster[d]=c'
        b=b.replace(needle,'''    if c==udg_SpiritOfGaya[GetPlayerId(GetOwningPlayer(c))+1] and Player_GetHero(GetOwningPlayer(c))!=null then
        set c=Player_GetHero(GetOwningPlayer(c))
    endif
'''+needle,1);s=put(s,'Trig_Spell_Blizzaga_Start',b)
    if lib=='TCine':
        # Same shared flags, moved before any scene preparation. No forced local
        # cancel or catalogue rebuild and no gameplay reads from frame state.
        b=fs['Cine_Enter'];b=b.replace('    set udg_InCinematicMode=true\n    set InventoryCinematicActive=true\n','',1)
        needle='    if(udg_MiracleStage[0]==2)then';assert needle in b
        b=b.replace(needle,'    set udg_InCinematicMode=true\n    set InventoryCinematicActive=true\n'+needle,1)
        s=put(s,'Cine_Enter',b)
    # The control gates do not touch profile capture, transport, loading, or its
    # timeout clock. Autosaves are deferred before starting, never halfway saved.
    for n,b in functions(s).items():
        if n in GATED:s=put(s,n,guard(b))
    return s

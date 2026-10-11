library TTalents requires TJob, TPlayerHero, TMissile
// Job talents: four rows of three choices for each job. Row 1 is open from the start, row 2
// at mastery (level 50), row 3 at ultimate mastery (level 99) and row 4 at legendary master
// (level 100). The Shrine of Individuality sells a reset of the current job's picks. One choice per row; picks last for the current game only. A talent works only
// while the hero's current job is the talent's job and the hero has the spell it changes.
// Reforged shows a frame panel; the 1.29.2 conversion removes the TalentFrame_ functions and
// uses the dialog below instead (TalentUseFrames becomes false).
globals
    trigger gg_trg_Talents_Open=null
    trigger gg_trg_Talents_Guard=null
    trigger gg_trg_Talents_Reset=null
    trigger gg_trg_Talents_Dialog=null
    trigger gg_trg_Talents_FrameClick=null
    trigger gg_trg_Talents_FrameSync=null
    constant integer TALENT_ABILITY='tTal'
    constant integer TALENT_ROWS=4
    constant boolean TalentUseFrames=true
    constant integer TALENT_JOB_PRIEST=12
    constant integer TALENT_MISSILE_BLIND=1
    constant integer TALENT_RESET_UNIT='nTRt'
    constant integer TALENT_RESET_GOLD=1000
    // Dialog lines longer than this run off the 1.29.2 dialog box.
    constant integer TALENT_LINE=30
    group array TalentBlindGroup
    // Indexed job*12+(row-1)*3+(choice-1).
    string array TalentName
    string array TalentText
    string array TalentRowLabel
    // Indexed (player id)*100+job*4+(row-1); 0 = no pick, otherwise the chosen 1..3.
    integer array TalentPick
    dialog array TalentDialog
    button array TalentDialogChoice
    button array TalentDialogNext
    integer array TalentDialogRow
    boolean array TalentOpen
    integer array TalentHover
    framehandle TalentFrameRoot=null
    framehandle TalentFrameHeading=null
    framehandle TalentFrameText=null
    framehandle TalentFrameClose=null
    framehandle array TalentFrameLabel
    framehandle array TalentFrameButton
endglobals

function Talent_Index takes integer job,integer row,integer choice returns integer
    return job*12+(row-1)*3+choice-1
endfunction

function Talent_PickIndex takes integer pid,integer job,integer row returns integer
    return pid*100+job*4+row-1
endfunction

// Rows unlocked by the hero's mastery: 1 at start, 2 at 50, 3 at 99, 4 at 100.
function Talent_Rank takes unit hero returns integer
    return IMinBJ(TALENT_ROWS,IMaxBJ(1,GetUnitAbilityLevel(hero,'A02F'))) // 'A02F': ability "Mastery"
endfunction

function Talent_JobHasTalents takes integer job returns boolean
    return job>=0 and job<udg_JobCount and TalentName[Talent_Index(job,1,1)]!=""
endfunction

function Talent_Has takes unit hero,integer row,integer choice returns boolean
    local integer job=Job_GetIndex(hero)
    local integer pid=GetPlayerId(GetOwningPlayer(hero))
    if job<0 or job>=udg_JobCount or pid<0 or pid>=bj_MAX_PLAYERS or row>Talent_Rank(hero) then
        return false
    endif
    return TalentPick[Talent_PickIndex(pid,job,row)]==choice
endfunction

// True when the hero's current job is (job), it has (spell) and the talent is picked.
function Talent_Active takes unit hero,integer job,integer row,integer choice,integer spell returns boolean
    return hero!=null and Job_GetIndex(hero)==job and GetUnitAbilityLevel(hero,spell)>0 and Talent_Has(hero,row,choice)
endfunction

function Talent_DummyCast takes unit caster,unit target,integer abil,string order returns nothing
    local unit d=CreateUnit(GetOwningPlayer(caster),'h02S',GetUnitX(target),GetUnitY(target),0.) // 'h02S': unit "Simple Casting Dummy"
    call ShowUnitHide(d)
    call UnitApplyTimedLife(d,'BTLF',2.)
    call UnitAddAbility(d,abil)
    call IssueTargetOrder(d,order,target)
    set d=null
endfunction

// Blinding Light: the Cure sphere blinds each enemy it passes, once per sphere.
function Talent_MarkBlindingMissile takes integer d,boolean healsNoOne returns nothing
    if TalentBlindGroup[d]==null then
        set TalentBlindGroup[d]=CreateGroup()
    endif
    call GroupClear(TalentBlindGroup[d])
    set MissileTag[d]=TALENT_MISSILE_BLIND
    set MissileNoDamage[d]=healsNoOne
endfunction

function Talents_MissileHit takes nothing returns boolean
    local integer d=udg_ArgIndex
    local unit u=udg_ArgUnit
    if MissileTag[d]==TALENT_MISSILE_BLIND and IsUnitEnemy(u,GetOwningPlayer(udg_MissileCaster[d])) and not IsUnitInGroup(u,TalentBlindGroup[d]) and GetWidgetLife(u)>.405 then
        call GroupAddUnit(TalentBlindGroup[d],u)
        if u==udg_MissileTarget[d] then
            call Talent_DummyCast(udg_MissileCaster[d],u,'tBln',"curse") // 15 seconds
        else
            call Talent_DummyCast(udg_MissileCaster[d],u,'tBl5',"curse") // 5 seconds
        endif
    endif
    set u=null
    return false
endfunction

function Talent_Choose takes player p,integer row,integer choice returns boolean
    local unit hero=Player_GetHero(p)
    local integer job=Job_GetIndex(hero)
    local integer pid=GetPlayerId(p)
    local boolean ok=hero!=null and Talent_JobHasTalents(job) and row>=1 and row<=Talent_Rank(hero) and choice>=1 and choice<=3
    if ok and TalentPick[Talent_PickIndex(pid,job,row)]==0 and TalentName[Talent_Index(job,row,choice)]!="" then
        set TalentPick[Talent_PickIndex(pid,job,row)]=choice
        call DisplayTimedTextToPlayer(p,0,0,8,"|cffffcc00Talent learned:|r "+TalentName[Talent_Index(job,row,choice)])
    else
        set ok=false
    endif
    set hero=null
    return ok
endfunction

// Clears the current job's picks (used by the talent trainer in town).
function Talent_ResetJob takes player p returns boolean
    local integer job=Job_GetIndex(Player_GetHero(p))
    local integer row=1
    local boolean any=false
    if job<0 or job>=udg_JobCount then
        return false
    endif
    loop
        exitwhen row>TALENT_ROWS
        if TalentPick[Talent_PickIndex(GetPlayerId(p),job,row)]!=0 then
            set any=true
        endif
        set TalentPick[Talent_PickIndex(GetPlayerId(p),job,row)]=0
        set row=row+1
    endloop
    return any
endfunction

function Talent_RowStatus takes player p,integer job,integer row returns string
    local integer pick=TalentPick[Talent_PickIndex(GetPlayerId(p),job,row)]
    if row>Talent_Rank(Player_GetHero(p)) then
        return "|cff808080Locked|r"
    elseif pick>0 then
        return "|cff00ff00Learned: "+TalentName[Talent_Index(job,row,pick)]+"|r"
    endif
    return "|cffffcc00Choose one|r"
endfunction

// Breaks text into lines of at most TALENT_LINE characters at spaces (dialogs do not wrap).
function Talent_Wrap takes string text returns string
    local string out=""
    local string line=""
    local string word=""
    local integer i=0
    local integer n=StringLength(text)
    local string c
    loop
        exitwhen i>n
        if i<n then
            set c=SubString(text,i,i+1)
        else
            set c=" "
        endif
        if c==" " then
            if line=="" then
                set line=word
            elseif StringLength(line)+1+StringLength(word)<=TALENT_LINE then
                set line=line+" "+word
            else
                set out=out+line+"|n"
                set line=word
            endif
            set word=""
        else
            set word=word+c
        endif
        set i=i+1
    endloop
    return out+line
endfunction

function Talent_ShowDialog takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local integer job=Job_GetIndex(Player_GetHero(p))
    local integer row=TalentDialogRow[pid]
    local integer choice=1
    local integer named=0
    local string text
    call DialogClear(TalentDialog[pid])
    if not Talent_JobHasTalents(job) then
        call DialogSetMessage(TalentDialog[pid],"This job has no talents yet.")
        call DialogAddButton(TalentDialog[pid],"Close",0)
        call DialogDisplay(p,TalentDialog[pid],true)
        return
    endif
    set text="|cffffcc00"+udg_JobName[job]+" talents|r|nRow "+I2S(row)+" of 4: "+TalentRowLabel[row]+"|n"+Talent_RowStatus(p,job,row)
    loop
        exitwhen choice>3
        if TalentName[Talent_Index(job,row,choice)]!="" then
            set named=named+1
            set text=text+"|n|n|cffffcc00"+TalentName[Talent_Index(job,row,choice)]+"|r|n"+Talent_Wrap(TalentText[Talent_Index(job,row,choice)])
        endif
        set choice=choice+1
    endloop
    if named==0 then
        set text=text+"|n|nNo talents written|nfor this row yet."
    endif
    call DialogSetMessage(TalentDialog[pid],text)
    set choice=1
    loop
        exitwhen choice>3
        set TalentDialogChoice[pid*3+choice-1]=null
        if row<=Talent_Rank(Player_GetHero(p)) and TalentPick[Talent_PickIndex(pid,job,row)]==0 and TalentName[Talent_Index(job,row,choice)]!="" then
            set TalentDialogChoice[pid*3+choice-1]=DialogAddButton(TalentDialog[pid],"Learn "+TalentName[Talent_Index(job,row,choice)],0)
        endif
        set choice=choice+1
    endloop
    set TalentDialogNext[pid]=DialogAddButton(TalentDialog[pid],"Next row",0)
    call DialogAddButton(TalentDialog[pid],"Close",0)
    call DialogDisplay(p,TalentDialog[pid],true)
endfunction

// Shrine of Individuality "Reset Talents": clears the current job's picks only.
function Talents_ResetSold takes nothing returns nothing
    local unit sold=GetSoldUnit()
    local player p=GetOwningPlayer(sold)
    local integer job=Job_GetIndex(Player_GetHero(p))
    if GetUnitTypeId(sold)==TALENT_RESET_UNIT then
        call RemoveUnit(sold)
        if Talent_ResetJob(p) then
            call DisplayTimedTextToPlayer(p,0,0,8,"|cffffcc00Talents reset for "+udg_JobName[job]+".|r Other jobs keep theirs.")
        else
            call SetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)+TALENT_RESET_GOLD)
            if job>=0 and job<udg_JobCount then
                call DisplayTimedTextToPlayer(p,0,0,8,"No "+udg_JobName[job]+" talents to reset. Gold refunded.")
            else
                call DisplayTimedTextToPlayer(p,0,0,8,"This job has no talents. Gold refunded.")
            endif
        endif
    endif
    set sold=null
    set p=null
endfunction

function Talents_DialogClick takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local integer pid=GetPlayerId(p)
    local button clicked=GetClickedButton()
    local integer choice=1
    if clicked==TalentDialogNext[pid] then
        set TalentDialogRow[pid]=ModuloInteger(TalentDialogRow[pid],TALENT_ROWS)+1
        call Talent_ShowDialog(p)
    else
        loop
            exitwhen choice>3
            if clicked!=null and clicked==TalentDialogChoice[pid*3+choice-1] then
                call Talent_Choose(p,TalentDialogRow[pid],choice)
                call Talent_ShowDialog(p)
            endif
            set choice=choice+1
        endloop
    endif
    set clicked=null
    set p=null
endfunction

function TalentFrame_Show takes player p returns nothing
    local integer pid=GetPlayerId(p)
    local integer job=Job_GetIndex(Player_GetHero(p))
    local integer row=1
    local integer choice
    local integer pick
    local string name
    if GetLocalPlayer()==p then
        call BlzFrameSetVisible(TalentFrameRoot,true)
        call BlzFrameSetText(TalentFrameHeading,udg_JobName[job]+" talents")
        call BlzFrameSetText(TalentFrameText,"Point at a talent to read it. One choice per row; picks last for this game.")
        loop
            exitwhen row>TALENT_ROWS
            set pick=TalentPick[Talent_PickIndex(pid,job,row)]
            call BlzFrameSetText(TalentFrameLabel[row],TalentRowLabel[row]+": "+Talent_RowStatus(p,job,row))
            set choice=1
            loop
                exitwhen choice>3
                set name=TalentName[Talent_Index(job,row,choice)]
                if name=="" then
                    set name="|cff808080Not written yet|r"
                elseif pick==choice then
                    set name="|cff00ff00"+name+"|r"
                endif
                call BlzFrameSetText(TalentFrameButton[row*3+choice-1],name)
                call BlzFrameSetEnable(TalentFrameButton[row*3+choice-1],pick==0 and row<=Talent_Rank(Player_GetHero(p)) and TalentName[Talent_Index(job,row,choice)]!="")
                set choice=choice+1
            endloop
            set row=row+1
        endloop
    endif
endfunction

function TalentFrame_Hide takes player p returns nothing
    if GetLocalPlayer()==p then
        call BlzFrameSetVisible(TalentFrameRoot,false)
    endif
endfunction

function TalentFrame_OnClick takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local framehandle clicked=BlzGetTriggerFrame()
    local integer node=3
    local integer job=Job_GetIndex(Player_GetHero(p))
    if clicked==TalentFrameClose then
        set TalentOpen[GetPlayerId(p)]=false
        call TalentFrame_Hide(p)
    else
        loop
            exitwhen node>=TALENT_ROWS*3+3
            if clicked==TalentFrameButton[node] then
                if BlzGetTriggerFrameEvent()==FRAMEEVENT_MOUSE_ENTER then
                    if GetLocalPlayer()==p then
                        call BlzFrameSetText(TalentFrameText,"|cffffcc00"+TalentName[Talent_Index(job,node/3,ModuloInteger(node,3)+1)]+"|r|n"+TalentText[Talent_Index(job,node/3,ModuloInteger(node,3)+1)])
                    endif
                elseif GetLocalPlayer()==p then
                    call BlzFrameSetEnable(clicked,false)
                    call BlzSendSyncData("FFERPGTAL",I2S(node))
                endif
            endif
            set node=node+1
        endloop
    endif
    set clicked=null
    set p=null
endfunction

function TalentFrame_OnSync takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local integer node=S2I(BlzGetTriggerSyncData())
    if TalentOpen[GetPlayerId(p)] then
        call Talent_Choose(p,node/3,ModuloInteger(node,3)+1)
        call TalentFrame_Show(p)
    endif
    set p=null
endfunction

function TalentFrame_OnEscape takes nothing returns nothing
    local player p=GetTriggerPlayer()
    if TalentOpen[GetPlayerId(p)] then
        set TalentOpen[GetPlayerId(p)]=false
        call TalentFrame_Hide(p)
    endif
    set p=null
endfunction

function TalentFrame_Init takes nothing returns nothing
    local trigger escape=CreateTrigger()
    local integer row=1
    local integer choice
    local integer id=0
    loop
        exitwhen id>=bj_MAX_PLAYERS
        call BlzTriggerRegisterPlayerSyncEvent(gg_trg_Talents_FrameSync,Player(id),"FFERPGTAL",false)
        call TriggerRegisterPlayerEvent(escape,Player(id),EVENT_PLAYER_END_CINEMATIC)
        set id=id+1
    endloop
    call TriggerAddAction(escape,function TalentFrame_OnEscape)
    set TalentFrameRoot=BlzCreateFrame("EscMenuBackdrop",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),0,0)
    call BlzFrameSetAbsPoint(TalentFrameRoot,FRAMEPOINT_CENTER,.4,.33)
    call BlzFrameSetSize(TalentFrameRoot,.52,.42)
    call BlzFrameSetLevel(TalentFrameRoot,10)
    set TalentFrameHeading=BlzCreateFrameByType("TEXT","TalentHeading",TalentFrameRoot,"",0)
    call BlzFrameSetAbsPoint(TalentFrameHeading,FRAMEPOINT_TOP,.4,.52)
    call BlzFrameSetSize(TalentFrameHeading,.4,.02)
    call BlzFrameSetFont(TalentFrameHeading,"Fonts\\FRIZQT__.TTF",.014,0)
    call BlzFrameSetTextAlignment(TalentFrameHeading,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
    loop
        exitwhen row>TALENT_ROWS
        set TalentFrameLabel[row]=BlzCreateFrameByType("TEXT","TalentRowLabel",TalentFrameRoot,"",row)
        call BlzFrameSetAbsPoint(TalentFrameLabel[row],FRAMEPOINT_TOPLEFT,.17,.49-I2R(row-1)*.07)
        call BlzFrameSetSize(TalentFrameLabel[row],.46,.016)
        set choice=1
        loop
            exitwhen choice>3
            set TalentFrameButton[row*3+choice-1]=BlzCreateFrame("ScriptDialogButton",TalentFrameRoot,0,row*3+choice-1)
            call BlzFrameSetAbsPoint(TalentFrameButton[row*3+choice-1],FRAMEPOINT_TOPLEFT,.17+I2R(choice-1)*.155,.472-I2R(row-1)*.07)
            call BlzFrameSetSize(TalentFrameButton[row*3+choice-1],.15,.034)
            call BlzTriggerRegisterFrameEvent(gg_trg_Talents_FrameClick,TalentFrameButton[row*3+choice-1],FRAMEEVENT_CONTROL_CLICK)
            call BlzTriggerRegisterFrameEvent(gg_trg_Talents_FrameClick,TalentFrameButton[row*3+choice-1],FRAMEEVENT_MOUSE_ENTER)
            set choice=choice+1
        endloop
        set row=row+1
    endloop
    set TalentFrameText=BlzCreateFrameByType("TEXT","TalentText",TalentFrameRoot,"",0)
    call BlzFrameSetAbsPoint(TalentFrameText,FRAMEPOINT_TOPLEFT,.17,.2)
    call BlzFrameSetSize(TalentFrameText,.46,.06)
    set TalentFrameClose=BlzCreateFrame("ScriptDialogButton",TalentFrameRoot,0,99)
    call BlzFrameSetAbsPoint(TalentFrameClose,FRAMEPOINT_TOP,.4,.145)
    call BlzFrameSetSize(TalentFrameClose,.12,.028)
    call BlzFrameSetText(TalentFrameClose,"Close")
    call BlzTriggerRegisterFrameEvent(gg_trg_Talents_FrameClick,TalentFrameClose,FRAMEEVENT_CONTROL_CLICK)
    call BlzFrameSetVisible(TalentFrameRoot,false)
    set escape=null
endfunction

function Talent_Open takes player p returns nothing
    local integer pid=GetPlayerId(p)
    if TalentUseFrames and Talent_JobHasTalents(Job_GetIndex(Player_GetHero(p))) then
        set TalentOpen[pid]=true
        call TalentFrame_Show(p)
    else
        set TalentDialogRow[pid]=1
        call Talent_ShowDialog(p)
    endif
endfunction

function Talents_OnCast takes nothing returns nothing
    local integer id=GetSpellAbilityId()
    local unit caster=GetTriggerUnit()
    local unit target=GetSpellTargetUnit()
    if id==TALENT_ABILITY then
        call Talent_Open(GetOwningPlayer(caster))
    elseif target!=null and IsUnitEnemy(target,GetOwningPlayer(caster)) then
        if id=='A00G' and Talent_Active(caster,TALENT_JOB_PRIEST,1,1,id) then // 'A00G': ability "Protect"
            call Talent_DummyCast(caster,target,'tDpr',"faeriefire")
        elseif id=='A0TZ' and Talent_Active(caster,TALENT_JOB_PRIEST,1,2,id) then // 'A0TZ': ability "Shell"
            call Talent_DummyCast(caster,target,'tDsh',"faeriefire")
        endif
    endif
    set caster=null
    set target=null
endfunction

// Protect, Shell and Cure can target enemies only with their talent; otherwise the cast stops
// before it costs anything.
function Talents_GuardCast takes nothing returns nothing
    local integer id=GetSpellAbilityId()
    local unit caster=GetTriggerUnit()
    local unit target=GetSpellTargetUnit()
    local integer choice=1
    if id=='A0TZ' then // 'A0TZ': ability "Shell"
        set choice=2
    elseif id=='A00M' then // 'A00M': ability "Cure"
        set choice=3
    endif
    if (id=='A00G' or id=='A0TZ' or id=='A00M') and target!=null and IsUnitEnemy(target,GetOwningPlayer(caster)) and not Talent_Active(caster,TALENT_JOB_PRIEST,1,choice,id) then
        call IssueImmediateOrder(caster,"stop")
        call DisplayTimedTextToPlayer(GetOwningPlayer(caster),0,0,5,"|cffff0000Casting this on an enemy needs the Priest's "+TalentName[Talent_Index(TALENT_JOB_PRIEST,1,choice)]+" talent.|r")
    endif
    set caster=null
    set target=null
endfunction

// Every job hero gets the Talents button; job changes and loads create new hero units.
function Talents_GiveButton takes nothing returns nothing
    local integer i=0
    local unit hero
    loop
        exitwhen i>=bj_MAX_PLAYERS
        set hero=Player_GetHero(Player(i))
        if hero!=null and GetUnitAbilityLevel(hero,TALENT_ABILITY)==0 then
            call UnitAddAbility(hero,TALENT_ABILITY)
            call UnitMakeAbilityPermanent(hero,true,TALENT_ABILITY)
        endif
        set i=i+1
    endloop
    set hero=null
endfunction

function Talents_InitData takes nothing returns nothing
    local integer job=12 // Priest
    set TalentRowLabel[1]="Start"
    set TalentRowLabel[2]="Level 50"
    set TalentRowLabel[3]="Level 99"
    set TalentRowLabel[4]="Level 100"
    set TalentName[Talent_Index(job,1,1)]="Deprotect"
    set TalentText[Talent_Index(job,1,1)]="Protect can be cast on an enemy."
    set TalentName[Talent_Index(job,1,2)]="Deshell"
    set TalentText[Talent_Index(job,1,2)]="Shell can be cast on an enemy."
    set TalentName[Talent_Index(job,1,3)]="Blinding Light"
    set TalentText[Talent_Index(job,1,3)]="Enemies Cure affects are blinded."
endfunction

// Missile hits are evaluated through udg_MissileDamageTrig; hook in once startup has made it.
function Talents_HookMissiles takes nothing returns nothing
    call TriggerAddCondition(udg_MissileDamageTrig,Condition(function Talents_MissileHit))
    call DestroyTimer(GetExpiredTimer())
endfunction

function Talents_Init takes nothing returns nothing
    local integer id=0
    call Talents_InitData()
    loop
        exitwhen id>=bj_MAX_PLAYERS
        set TalentDialog[id]=DialogCreate()
        call TriggerRegisterDialogEvent(gg_trg_Talents_Dialog,TalentDialog[id])
        set id=id+1
    endloop
    if TalentUseFrames then
        call TalentFrame_Init()
    endif
    call TimerStart(CreateTimer(),1.,true,function Talents_GiveButton)
    call TimerStart(CreateTimer(),0.,false,function Talents_HookMissiles)
endfunction

function Register_Talents_Open takes nothing returns nothing
    set gg_trg_Talents_Open=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Talents_Open,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddAction(gg_trg_Talents_Open,function Talents_OnCast)
endfunction

function Register_Talents_Guard takes nothing returns nothing
    set gg_trg_Talents_Guard=CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_Talents_Guard,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddAction(gg_trg_Talents_Guard,function Talents_GuardCast)
endfunction

function Register_Talents_Reset takes nothing returns nothing
    set gg_trg_Talents_Reset=CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(gg_trg_Talents_Reset,Player(PLAYER_NEUTRAL_PASSIVE),EVENT_PLAYER_UNIT_SELL,null)
    call TriggerAddAction(gg_trg_Talents_Reset,function Talents_ResetSold)
endfunction

function Register_Talents_Dialog takes nothing returns nothing
    set gg_trg_Talents_Dialog=CreateTrigger()
    call TriggerAddAction(gg_trg_Talents_Dialog,function Talents_DialogClick)
endfunction

function Register_Talents_FrameClick takes nothing returns nothing
    set gg_trg_Talents_FrameClick=CreateTrigger()
    call TriggerAddAction(gg_trg_Talents_FrameClick,function TalentFrame_OnClick)
endfunction

function Register_Talents_FrameSync takes nothing returns nothing
    set gg_trg_Talents_FrameSync=CreateTrigger()
    call TriggerAddAction(gg_trg_Talents_FrameSync,function TalentFrame_OnSync)
    // Last of the four registrations: the dialogs and frames need all four triggers.
    call Talents_Init()
endfunction

function RegisterTriggers_Talents takes nothing returns nothing
    call Register_Talents_Open()
    call Register_Talents_Guard()
    call Register_Talents_Reset()
    call Register_Talents_Dialog()
    call Register_Talents_FrameClick()
    call Register_Talents_FrameSync()
endfunction

function InitTrig_Talents takes nothing returns nothing
endfunction

endlibrary

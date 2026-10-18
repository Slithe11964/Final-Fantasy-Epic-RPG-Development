"""Player-facing recipe reveal and current-job legendary checklist."""
import re
from jtok import functions
from performance_runtime import put
from gameplay_runtime import dependency
from damage_tooltips import merged
from priest_master import fields,at


def quote(text):return '"'+text.replace('\\','\\\\').replace('"','\\"').replace('\n','|n').replace('\r','')+'"'


def legend_data(view):
    abilities=merged(view.object_bytes('war3map.w3a'),view.object_bytes('war3mapSkin.w3a'),'w3a')
    result={}
    for index,raw in re.findall(r"udg_LegendTaskAbility\[([^]]+)\]='(....)'",view.modules['TElysium']):
        job=int(index[1:],16) if index.startswith('$') else int(index)
        result[job]=at(fields(abilities[raw]),'aub1',1,'')
    result[14]='Master the forbidden spell of traveling back through time (New Game Plus).'
    result[22]='Achieve Legendary Mastery in every other job, then complete the Freelancer ritual.'
    return result


def refresh(source,data):
    fs=functions(source)
    if 'RegisterTriggers_Legendary' in fs:
        source=dependency(dependency(source,'TPlayerHero'),'TJob')
        if 'LegendTaskText' not in source:source=source.replace('endglobals','    string array LegendTaskText\n    string array LegendElementName\nendglobals',1)
        helper='''function Legend_Line takes player viewer,string text,boolean done returns nothing
    local string color="|cffffffff"
    local string mark="[ ] "
    if done then
        set color="|cff00ff00"
        set mark="[Done] "
    endif
    call DisplayTimedTextToPlayer(viewer,0,0,35,color+mark+text+"|r")
endfunction

function Legend_Command takes nothing returns nothing
    local player viewer=GetTriggerPlayer()
    local unit hero=Player_GetHero(viewer)
    local integer job=Job_GetIndex(hero)
    local integer i=0
    local boolean done
    if GetEventPlayerChatString()!="-legendary" then
        return
    endif
    if hero==null or GetHeroLevel(hero)<99 or job<0 or job>22 then
        call DisplayTimedTextToPlayer(viewer,0,0,10,"Legendary tasks are available at level 99 on your current job.")
    else
        set done=IsPlayerInForce(viewer,udg_JobMasterForce[job]) or GetUnitAbilityLevel(hero,'A02F')>=4
        if job==14 and udg_NewGamePlusLevel[GetPlayerId(viewer)+1]>0 then
            set done=true
        endif
        call DisplayTimedTextToPlayer(viewer,0,0,35,"|cffffcc00Legendary "+udg_JobName[job]+"|r")
        call Legend_Line(viewer,"Proof of Strength: defeat a level 90+ boss solo on this job.",IsPlayerInForce(viewer,udg_QuestForce[job]) or GetUnitAbilityLevel(hero,'A02F')>=4)
        call Legend_Line(viewer,LegendTaskText[job],done)
        if job==11 or job==17 then
            set i=1
            loop
                exitwhen i>6
                if job==11 then
                    call Legend_Line(viewer,LegendElementName[i],done or IsPlayerInForce(viewer,udg_WeakElementForce[i]))
                else
                    call Legend_Line(viewer,LegendElementName[i],done or IsPlayerInForce(viewer,udg_NullElementForce[i]))
                endif
                set i=i+1
            endloop
        elseif job==22 then
            loop
                exitwhen i>=22
                call Legend_Line(viewer,udg_JobName[i],LoadInteger(udg_JobLevelHash,udg_JobUnitType[i],GetPlayerId(viewer))==100 or GetUnitAbilityLevel(LoadUnitHandle(udg_JobHeroHash,udg_JobUnitType[i],GetPlayerId(viewer)),'A02F')>=4)
                set i=i+1
            endloop
        elseif job==13 then
            call Legend_Line(viewer,"Shiva: normal attack for at least 10,000 damage",done or IsPlayerInForce(viewer,udg_EidolonAwardForce[0]))
            call Legend_Line(viewer,"Ifrit: normal attack for at least 10,000 damage",done or IsPlayerInForce(viewer,udg_EidolonAwardForce[1]))
            call Legend_Line(viewer,"Cyclops: normal attack for at least 10,000 damage",done or IsPlayerInForce(viewer,udg_EidolonAwardForce[2]))
        endif
        call Legend_Line(viewer,"Spiritual Ritual: bring a Grand Crystal into the Spring of Life after completing both proofs.",GetUnitAbilityLevel(hero,'A02F')>=4)
    endif
    set hero=null
    set viewer=null
endfunction

function Legend_InitCommand takes nothing returns nothing
    local trigger command=CreateTrigger()
    local integer i=0
'''
        helper+='\n'.join('    set LegendElementName['+str(i)+']='+quote(t) for i,t in enumerate(['Fire','Ice','Thunder','Water','Wind','Earth'],1))+'\n'
        helper+='\n'.join('    set LegendTaskText['+str(i)+']='+quote(t) for i,t in sorted(data.items()))+'\n'
        helper+='''    loop
        exitwhen i>=8
        call TriggerRegisterPlayerChatEvent(command,Player(i),"-legendary",true)
        set i=i+1
    endloop
    call TriggerAddAction(command,function Legend_Command)
    set command=null
endfunction

'''
        for name,body in functions(helper).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function InitTrig_Legendary takes',body+'\n\nfunction InitTrig_Legendary takes',1)
        body=functions(source)['RegisterTriggers_Legendary']
        if 'Legend_InitCommand()' not in body:body=body.replace('endfunction','    call Legend_InitCommand()\nendfunction')
        source=put(source,'RegisterTriggers_Legendary',body)
    if 'Bazaar_RewardName' in fs:
        if 'boolean array BazaarReveal' not in source:source=source.replace('endglobals','    boolean array BazaarReveal\nendglobals',1)
        # RewardName only produces UI text. Never use this local reveal value
        # for recipes, stock, costs, parts, handles or any gameplay mutation.
        body=fs['Bazaar_RewardName']
        if 'BazaarReveal[' not in body:body=body.replace('not BazaarRewardRevealed[recipe]','not BazaarRewardRevealed[recipe] and not BazaarReveal[GetPlayerId(GetLocalPlayer())]')
        source=put(source,'Bazaar_RewardName',body)
        helper='''function Bazaar_RevealCommand takes nothing returns nothing
    local player p=GetTriggerPlayer()
    local integer id=GetPlayerId(p)
    set BazaarReveal[id]=true
    call DisplayTimedTextToPlayer(p,0,0,15,"Bazaar recipe rewards revealed. Parts and preparation requirements still apply.")
    if BazaarBrowserOpen[id] then
        call Bazaar_ShowRecipe(p)
    endif
    set p=null
endfunction

function Bazaar_RegisterReveal takes nothing returns nothing
    local trigger command=CreateTrigger()
    local integer i=0
    loop
        exitwhen i>=8
        call TriggerRegisterPlayerChatEvent(command,Player(i),"-bazaarreveal",true)
        set i=i+1
    endloop
    call TriggerAddAction(command,function Bazaar_RevealCommand)
    set command=null
endfunction

'''
        # ShowRecipes resolves the native/classic presentation in this module.
        for name,body in functions(helper).items():
            if name in functions(source):source=put(source,name,body)
            else:source=source.replace('function InitTrig_Bazaar takes',body+'\n\nfunction InitTrig_Bazaar takes',1)
        name='RegisterTriggers_Bazaar';name=next((n for n in functions(source) if n.startswith(name)),None)
        if name:
            body=functions(source)[name]
            if 'Bazaar_RegisterReveal()' not in body:body=body.replace('endfunction','    call Bazaar_RegisterReveal()\nendfunction')
            source=put(source,name,body)
    return source

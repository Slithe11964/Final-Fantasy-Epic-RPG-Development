"""Build an arena roster and team-practice map from Creature Review 03t."""
import json
import re
from collections import Counter
from pathlib import Path
from arena_roster37 import data_for
from build_creature_review import q
from build_forest86 import all_objects
from editor_pair import View
from priest_master import fields
from jtok import functions
from performance_runtime import put
from mpq import MPQ, write_files, compact
from wct import read_wct, raw_of, write_wct
from add_header import read_header, build_header
from downgrade import wts_read, wts_write
from test_map_identity import info_labels

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT/'release/development/V37/FFERPG-V37.w3x'
REVIEW = ROOT/'release/development/CreatureReview03t/FFERPG-Creature-Review-03t.w3x'
OUT = ROOT/'release/development/ArenaCreatureTest02/FFERPG-Arena-Creature-Test-02.w3x'
NAME = 'FFERPG Arena Creature Test 02'

LABELS = r'''
function ReviewArena_RefreshLabels takes nothing returns nothing
    local integer cup=Review03_AreaAt(GetCameraTargetPositionX(),GetCameraTargetPositionY())
    local integer i=1
    local integer labelPage=-1000-cup
    local integer count=LoadInteger(ReviewArenaData,labelPage,0)
    if cup==ReviewArenaLabelCup then
        return
    endif
    set ReviewArenaLabelCup=cup
    loop
        exitwhen i>ReviewArenaLabelLimit
        call SetTextTagVisibility(ReviewArenaLabels[i],i<=count)
        if i<=count then
            call SetTextTagText(ReviewArenaLabels[i],LoadStr(ReviewArenaData,labelPage,i),.024)
            call SetTextTagPos(ReviewArenaLabels[i],LoadReal(ReviewArenaData,labelPage,i*2),LoadReal(ReviewArenaData,labelPage,i*2+1),80.)
        endif
        set i=i+1
    endloop
endfunction
'''

HELPERS = r'''
function ReviewArena_Setup takes unit u,integer team,integer slot returns nothing
    local integer preset=team*10+slot
    local integer i=0
    local integer level=LoadInteger(ReviewArenaData,preset,1)
    local integer authored=LoadInteger(ReviewArenaData,preset,20)
    local boolean boosted=false
    local integer h=GetHandleId(u)
    call SaveInteger(ReviewHash,h,3,team)
    call SaveInteger(ReviewHash,h,4,slot)
    call BlzSetUnitName(u,LoadStr(Review02Data,GetUnitTypeId(u),-2))
    if authored>0 then
        call SetUnitUserData(u,authored+10)
        if level>0 then
            call SetHeroLevel(u,level,false)
            if GetUnitTypeId(u)=='Uear' then
                call GroupAddUnit(udg_BossGroup,u)
                call UnitAddAbility(u,'A0KS')
                call SetUnitAbilityLevel(u,'A0KS',2)
                call UnitAddAbility(u,'A0Z5')
                call SetUnitAbilityLevel(u,'A0Z5',10)
                call UnitAddAbility(u,'A0R1')
                call UnitAddAbility(u,'A0TU')
                call SetUnitAbilityLevel(u,'A0TU',10)
                call UnitAddAbility(u,'A1AA')
            endif
        elseif not IsUnitType(u,UNIT_TYPE_RESISTANT) and not IsUnitType(u,UNIT_TYPE_HERO) then
            set boosted=true
        endif
    endif
    call SaveInteger(ReviewHash,h,5,BlzGetUnitMaxHP(u))
    call SaveInteger(ReviewHash,h,6,BlzGetUnitBaseDamage(u,0))
    call SaveInteger(ReviewHash,h,7,BlzGetUnitBaseDamage(u,1))
    call SaveReal(ReviewHash,h,8,BlzGetUnitArmor(u))
    call SaveBoolean(ReviewHash,h,9,boosted)
    if boosted then
        call BlzSetUnitMaxHP(u,BlzGetUnitMaxHP(u)*2)
        call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,0)*2,0)
        call BlzSetUnitBaseDamage(u,BlzGetUnitBaseDamage(u,1)*2,1)
        call BlzSetUnitArmor(u,BlzGetUnitArmor(u)+50.)
    endif
    if LoadBoolean(ReviewArenaData,-team,21) then
        call GroupAddUnit(udg_BossGroup,u)
        call UnitAddAbility(u,'Agyv')
    endif
    if slot==LoadInteger(ReviewArenaData,-team,22) then
        set ReviewArenaLeader=u
    elseif ReviewArenaLeader!=null then
        call UnitAddAbility(u,'A0X2')
        call Link_SaveCaster(ReviewArenaLeader,u,0.)
    endif
    loop
        exitwhen i>=LoadInteger(ReviewArenaData,preset,2)
        call UnitAddItemByIdSwapped(LoadInteger(ReviewArenaData,preset,3+i),u)
        set i=i+1
    endloop
    call SetWidgetLife(u,I2R(BlzGetUnitMaxHP(u)))
    call SetUnitState(u,UNIT_STATE_MANA,GetUnitState(u,UNIT_STATE_MAX_MANA))
endfunction

function ReviewArena_Scaling takes unit u returns nothing
    local integer h=GetHandleId(u)
    local integer team=LoadInteger(ReviewHash,h,3)
    local integer slot=LoadInteger(ReviewHash,h,4)
    local string bonus="No arena-only stat boost for this member."
    local string damage
    local integer level=LoadInteger(ReviewArenaData,team*10+slot,1)
    local string rank="default"
    if team==0 then
        return
    endif
    if LoadBoolean(ReviewHash,h,9) then
        set bonus="Arena bonus: x2 max HP, x2 base attack damage, +50 armor."
    endif
    if level>0 then
        set rank=I2S(level)
    endif
    set damage=I2S(LoadInteger(ReviewHash,h,6))+"/"+I2S(LoadInteger(ReviewHash,h,7))+" -> "+I2S(BlzGetUnitBaseDamage(u,0))+"/"+I2S(BlzGetUnitBaseDamage(u,1))
    call DisplayTimedTextToPlayer(Player(0),0.,0.,20.,"|cffffcc00"+LoadStr(ReviewArenaData,-team,1)+" - Solo Normal|r|n"+bonus+"|nHP: "+I2S(LoadInteger(ReviewHash,h,5))+" -> "+I2S(BlzGetUnitMaxHP(u))+"   Armor: "+R2SW(LoadReal(ReviewHash,h,8),1,1)+" -> "+R2SW(BlzGetUnitArmor(u),1,1)+"|nBase attack damage (slots 1/2): "+damage+"|nPreset level: "+rank+"   Starting items: "+I2S(LoadInteger(ReviewArenaData,team*10+slot,2)))
endfunction

function ReviewArena_Clear takes nothing returns nothing
    local unit u
    loop
        set u=FirstOfGroup(ReviewArenaEnemies)
        exitwhen u==null
        call GroupRemoveUnit(ReviewArenaEnemies,u)
        call FlushChildHashtable(ReviewHash,GetHandleId(u))
        call FlushChildHashtable(udg_LinkedCasterHash,GetHandleId(u))
        call GroupRemoveUnit(udg_BossGroup,u)
        call RemoveUnit(u)
    endloop
    set u=null
endfunction

function ReviewArena_Test takes unit model returns nothing
    local integer team=LoadInteger(ReviewHash,GetHandleId(model),3)
    local integer count=LoadInteger(ReviewArenaData,-team,0)
    local integer index=0
    local integer slot=0
    local integer leader=LoadInteger(ReviewArenaData,-team,22)
    local unit u=null
    if team==0 or count==0 then
        call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Select a cup exhibit and type -team.")
        return
    endif
    call ReviewArena_Clear()
    call Review_Targets()
    set ReviewArenaLeader=null
    loop
        exitwhen index>count
        set slot=index
        if index==0 then
            set slot=leader
        endif
        if slot>0 and (index==0 or slot!=leader) then
        set u=CreateUnit(Player(11),LoadInteger(ReviewArenaData,team*10+slot,0),18100.+I2R(slot-1)*240.,-22200.,90.)
        call ReviewArena_Setup(u,team,slot)
        call SetUnitInvulnerable(u,false)
        call UnitRemoveAbility(u,'Avul')
        call SetUnitAcquireRange(u,1920.)
        call GroupAddUnit(ReviewArenaEnemies,u)
        call IssueTargetOrder(u,"attack",ReviewFriend)
        endif
        set index=index+1
    endloop
    set ReviewArenaLeader=null
    call PanCameraToTimedForPlayer(Player(0),18500.,-22200.,.4)
    call DisplayTimedTextToPlayer(Player(0),0.,0.,15.,"Practice team |cffffcc00"+LoadStr(ReviewArenaData,-team,1)+"|r")
    set u=null
endfunction
'''

def build():
    assert not OUT.exists()
    source = View(SOURCE)
    archive = MPQ(str(REVIEW))
    script = archive.read('war3map.j').decode().replace('\r\n','\n')
    roster = data_for(source.runtime)
    enemy_init = functions(source.runtime)['Trig_Init_EnemyUpgrades_Actions']
    enemy_upgrades = re.findall(r"SetPlayerTechResearchedSwap\(('....'),(\d+),Player\(\$B\)\)", enemy_init)
    assert enemy_upgrades
    units = all_objects(source,'w3u')
    strings = wts_read(source.archive.read('war3map.wts'))
    catalogue = json.loads((REVIEW.parent/'Creature-Catalogue.json').read_text())
    review_names = {row['raw']:row['name'] for row in catalogue['creatures']}
    cups = {11:'Special Battles'}
    for obj in units.values():
        data = fields(obj)
        name = data.get(('unam',None),'')
        number = data.get(('upoi',None),0)
        if isinstance(name,str) and name.startswith('Arena: ') and name.endswith(' Cup') and 1<=number<=10:
            cups[number] = name.removeprefix('Arena: ')
    assert set(cups)==set(range(1,12)),cups
    label_limit=max(sum(cup in team['cups'] for team in roster) for cup in cups)
    script=script.replace('endglobals',f'    hashtable ReviewArenaData=null\n    group ReviewArenaEnemies=null\n    unit ReviewArenaLeader=null\n    texttag array ReviewArenaLabels\n    integer ReviewArenaLabelCup=0\n    constant integer ReviewArenaLabelLimit={label_limit}\nendglobals',1)
    fs=functions(script)
    script=script.replace('function Review_Chat takes',LABELS+'\n'+HELPERS+'\nfunction Review_Chat takes',1)
    # Review_Add appears before the practice controls. Place its setup helper
    # earlier while keeping the team-spawn helper after Review_Targets.
    setup = functions(HELPERS)['ReviewArena_Setup']
    script=script.replace(setup,'',1).replace('function Review_Add takes',setup+'\nfunction Review_Add takes',1)
    body=fs['Review_Add'].replace('string info returns nothing','string info,integer team,integer slot returns nothing')
    body=body.replace('call Review02_Setup(u)','call ReviewArena_Setup(u,team,slot)')
    body=re.sub(r'call SetHeroLevel\(u,IMaxBJ\(1,LoadInteger\(Review02Data,GetUnitTypeId\(u\),-1\)\),false\)', 'call SetHeroLevel(u,1,false)',body)
    script=put(script,'Review_Add',body)
    body=fs['Review_Chat']
    body=body.replace('    elseif s=="-enemy" and u!=null then','    elseif s=="-scaling" and u!=null then\n        call ReviewArena_Scaling(u)\n    elseif s=="-enemy" and u!=null then',1)
    body=body.replace('        call Review02_Stats(u)','        call Review02_Stats(u)\n        call ReviewArena_Scaling(u)',1)
    body=body.replace('    elseif s=="-enemy" and u!=null then','    elseif s=="-team" and u!=null then\n        call ReviewArena_Test(u)\n    elseif s=="-enemy" and u!=null then',1)
    body=body.replace('    elseif s=="-reset" then','    elseif s=="-reset" then\n        call ReviewArena_Clear()',1)
    body=body.replace('        call Review02_Setup(ReviewFighter)','        call ReviewArena_Setup(ReviewFighter,LoadInteger(ReviewHash,GetHandleId(u),3),LoadInteger(ReviewHash,GetHandleId(u),4))\n        set ReviewArenaLeader=null',1)
    script=put(script,'Review_Chat',body)
    hostile=fs['Review03_Hostile'].replace('call Review02_Setup(Review03Enemy)','call ReviewArena_Setup(Review03Enemy,LoadInteger(ReviewHash,GetHandleId(model),3),LoadInteger(ReviewHash,GetHandleId(model),4))')
    script=put(script,'Review03_Hostile',hostile)
    data = ['    set ReviewArenaData=InitHashtable()', '    set ReviewArenaEnemies=CreateGroup()']
    for team in roster:
        team_id=team['id']
        data.append(f'    call SaveInteger(ReviewArenaData,-{team_id},0,{len(team["members"])})')
        data.append(f'    call SaveStr(ReviewArenaData,-{team_id},1,{q(team["name"])})')
        data.append(f'    call SaveBoolean(ReviewArenaData,-{team_id},21,{str(team["detection"]).lower()})')
        data.append(f'    call SaveInteger(ReviewArenaData,-{team_id},22,{team["leader"]})')
        for slot,member in enumerate(team['members'],1):
            raw=member['raw']
            key=team_id*10+slot
            data.extend([f"    call SaveInteger(ReviewArenaData,{key},0,'{raw}')",
                         f"    call SaveInteger(ReviewArenaData,{key},1,{member['level']})",
                         f"    call SaveInteger(ReviewArenaData,{key},2,{len(member['gear'])})",
                         f"    call SaveInteger(ReviewArenaData,{key},20,{member['preset']})"])
            data.extend(f"    call SaveInteger(ReviewArenaData,{key},{3+i},'{item}')" for i,item in enumerate(member['gear']))
    counts=Counter()
    for cup,cup_name in sorted(cups.items()):
        x=-2800.+((cup-1)%3)*10300.
        y=2900.-((cup-1)//3)*6000.
        data.extend([f'    set ReviewX[{cup}]={x}',f'    set ReviewY[{cup}]={y}',f'    call Review_Label({q(str(cup)+". "+cup_name)},{x},{y})'])
        cup_teams=[t for t in roster if cup in t['cups']]
        data.append(f'    call SaveInteger(ReviewArenaData,{-1000-cup},0,{len(cup_teams)})')
        for index,team in enumerate(cup_teams):
            left=x+index%4*2370.
            top=y-450.-index//4*650.
            label=index+1
            data.extend([f'    call SaveStr(ReviewArenaData,{-1000-cup},{label},{q(team["name"])})',
                         f'    call SaveReal(ReviewArenaData,{-1000-cup},{label*2},{left})',
                         f'    call SaveReal(ReviewArenaData,{-1000-cup},{label*2+1},{top})',
                         '    set ReviewArenaLeader=null'])
            slots=sorted(enumerate(team['members'],1),key=lambda row: row[0]!=team['leader'])
            for slot,member in slots:
                raw=member['raw']
                name=review_names.get(raw,raw)
                info=f'{cup_name} | {team["name"]} | {name} ({raw})'
                if member['leader']:
                    info+=' | Team leader'
                data.append(f"    call Review_Add('{raw}',{left+(slot-1)*340.},{top-260.},{q(info)},{team['id']},{slot})")
                counts[cup]+=1
    data.extend(['    set ReviewArenaLeader=null', '    set ReviewX[13]=17800.', '    set ReviewY[13]=-21100.',
                 '    call Review_Label("Team practice",17800.,-21100.)'])
    chunks=[data[i:i+30] for i in range(0,len(data),30)]
    generated='\n'.join('function ReviewArena_Data'+str(i)+' takes nothing returns nothing\n'+'\n'.join(chunk)+'\nendfunction\n' for i,chunk in enumerate(chunks))
    script=re.sub(r'^function Review_Data\d+ takes nothing returns nothing\n.*?^endfunction\n','',script,flags=re.M|re.S)
    script=script.replace('function main takes',generated+'\nfunction main takes',1)
    start=functions(script)['Review_Start']
    tech = ['    call InitUpgrades_Player11()']
    for player in (0,11):
        tech.extend(f'    call SetPlayerTechResearched(Player({player}),{raw},{level})' for raw,level in enemy_upgrades)
    start=start.replace('    call ExecuteFunc("Review02_Load")','\n'.join(tech)+'\n    call ExecuteFunc("Review02_Load")',1)
    start=start.replace('    local trigger t=CreateTrigger()','    local integer label=1\n    local trigger t=CreateTrigger()',1)
    start=start.replace('    call Review_Targets()', '''    loop
        exitwhen label>ReviewArenaLabelLimit
        set ReviewArenaLabels[label]=CreateTextTag()
        call SetTextTagColor(ReviewArenaLabels[label],255,215,80,255)
        call SetTextTagVisibility(ReviewArenaLabels[label],false)
        set label=label+1
    endloop
    call TimerStart(CreateTimer(),.25,true,function ReviewArena_RefreshLabels)
    call Review_Targets()''',1)
    start=re.sub(r'(?m)^    call ExecuteFunc\("Review_Data\d+"\)\n','',start)
    # Keep data creation after ReviewHash and combat initialization.
    calls='\n'.join(f'    call ExecuteFunc("ReviewArena_Data{i}")' for i in range(len(chunks)))
    start=start.replace('    loop\n        exitwhen label>ReviewArenaLabelLimit',calls+'\n    loop\n        exitwhen label>ReviewArenaLabelLimit',1)
    assert calls in start
    help_text='Play as Red. Solo Normal Arena stats. Select a creature for -info, -scaling, or -abilities. -team spawns its full team as opponents in practice. -test creates one controlled copy. -reset clears practice. -area 1 to 10 visits each cup; -area 11 shows special battles.'
    start=re.sub(r'call QuestSetDescription\(questInfo,.*?\)', 'call QuestSetDescription(questInfo,'+q(help_text)+')',start,count=1)
    start=re.sub(r'call DisplayTimedTextToPlayer\(Player\(0\),0\.,0\.,60\.,.*?\)\n','call DisplayTimedTextToPlayer(Player(0),0.,0.,60.,'+q(help_text)+')\n',start,count=1)
    script=put(script,'Review_Start',start)
    assert len(re.findall(r'call Review_Add\(',script))==sum(counts.values())
    strings[38788]=strings[4]=NAME
    fs=functions(script)
    editor=script
    for name in ['main','config','InitCustomPlayerSlots','InitCustomTeams','InitAllyPriorities']:
        if name in fs:
            editor=editor.replace(fs[name],'',1)
    editor+='\nfunction Review_EditorMain takes nothing returns nothing\n'+'\n'.join(fs['main'].strip().splitlines()[1:-1])+'\nendfunction\nfunction InitTrig_CreatureReview takes nothing returns nothing\n    call Review_EditorMain()\nendfunction\n'
    globals_match=re.search(r'^globals\n.*?^endglobals\n',editor,re.M|re.S)
    globals_text=globals_match[0]
    editor=editor.replace(globals_text,'',1)
    wct=read_wct(archive.read('war3map.wct'))
    wct['header']=raw_of(globals_text)
    wct['entries']=[raw_of(editor)]
    files={'war3map.j':script.replace('\n','\r\n').encode(),'war3map.wct':write_wct(wct),
           'war3map.wts':wts_write(strings),'war3map.w3i':info_labels(archive.read('war3map.w3i'),NAME)}
    OUT.parent.mkdir(parents=True,exist_ok=True)
    tmp=OUT.with_suffix('.unpacked.w3x')
    write_files(str(REVIEW),str(tmp),files)
    compact(str(tmp),str(OUT))
    _,flags,players=read_header(str(REVIEW))
    binary=OUT.read_bytes()
    OUT.write_bytes(build_header(NAME,flags,players)+binary[binary.index(b'MPQ\x1a'):])
    final=MPQ(str(OUT))
    for name,content in files.items():
        assert final.read(name)==content,name
    for name in ['war3map.w3u','war3map.w3a','war3mapSkin.w3a','war3mapSkin.w3u']:
        assert final.read(name)==archive.read(name),name
    OUT.with_suffix('.j').write_text(script)
    (OUT.parent/'Arena-Roster.json').write_text(json.dumps(dict(cups=cups,teams=roster,exhibits=counts,profile='Solo Normal',label_pool=label_limit,arena_regular_unit_bonus=dict(max_hp_multiplier=2,base_attack_multiplier=2,flat_armor=50)),indent=2),encoding='utf-8')
    print(OUT, len(roster),'teams',sum(counts.values()),'exhibits',flush=True)

if __name__=='__main__':
    build()


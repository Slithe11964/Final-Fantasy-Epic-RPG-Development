"""Read the authored Battle Arena team slots and their cup eligibility."""
import re
from collections import Counter
from build_creature_review03 import literal
from jtok import functions

TEAM_FUNCTIONS = (
    'Trig_Arena_TeamData1_Actions', 'Trig_Arena_TeamData2_Actions',
    'Trig_Arena_Team_Data_A_Actions', 'Trig_Arena_Team_Data_B_Actions',
)
INTEGER = r"(?:\$[0-9A-Fa-f]+|-?\d+|'[^']+')"

def data_for(script):
    fs = functions(script)
    init = fs['Trig_Arena_InitData_Actions']
    size = re.search(r'call SaveIntegerBJ\(('+INTEGER+r'),\s*2,\s*0,\s*udg_GameStateHash\)',init)
    offset = literal(size[1])
    raw_types = {literal(index):raw for index,raw in re.findall(r"set\s+udg_ArenaMonsterType\[("+INTEGER+r")\]\s*=\s*'(.{4})'",init)}
    def numeric_fields(body):
        body = re.sub(r'LoadIntegerBJ\(\s*2\s*,\s*0\s*,\s*udg_GameStateHash\s*\)',str(offset),body)
        result = {}
        pattern = r'call SaveIntegerBJ\(([^,\n]+),\s*('+INTEGER+r'),\s*([^,\n]+),\s*udg_GameStateHash\)'
        def value(text):
            return sum(literal(part) for part in text.strip().strip('()').split('+'))
        for item,field,parent in re.findall(pattern,body):
            result[(value(parent),literal(field))] = value(item)
        return result
    team_source = '\n'.join(fs[name] for name in TEAM_FUNCTIONS)
    values = numeric_fields(team_source)
    names = {literal(team):name for name,team in re.findall(r'SaveStringBJ\("([^"\n]+)",\s*1,\s*('+INTEGER+r'),\s*udg_GameStateHash\)',team_source)}
    assert len(names)==offset, (len(names),offset)
    member_data = numeric_fields(fs['Trig_Arena_Unit_Data_Actions'])
    item_ids = {}
    for array in ('udg_ItemIdTable','udg_ArenaMonsterItem'):
        item_ids[array] = {literal(index):raw for index,raw in re.findall(r"set\s+"+array+r"\[("+INTEGER+r")\]\s*=\s*'(.{4})'",script)}
    bonus = {literal(i) for i in re.findall(r'set udg_ArenaBonusBattle\[(?:1|udg_ArenaBonusBattle\[0\])\]\s*=\s*('+INTEGER+r')',script)}
    dimension_finals = bonus | {7,166,167,168,169,170}
    result = []
    for team, name in sorted(names.items()):
        cups = [cup for cup in range(1,11) if any(values.get((team,field))==cup for field in range(10,10+cup))]
        if team in dimension_finals:
            cups = sorted(set(cups)|{10})
        if team==139:
            cups = sorted(set(cups)|set(range(1,10)))
        members = []
        for slot in range(1,values[team,6]+1):
            preset = values[team,6+slot]
            raw = raw_types[member_data.get((preset,1),preset-offset)]
            gear = []
            for i in range(member_data.get((preset,2),0)):
                code = member_data.get((preset,3+i),0)
                if not code:
                    continue
                table = item_ids['udg_ArenaMonsterItem'] if code>=1000 else item_ids['udg_ItemIdTable']
                gear.append(table[code-1000 if code>=1000 else code])
            members.append(dict(raw=raw,level=member_data.get((preset,9),0),gear=gear,preset=preset,
                                leader=slot==values.get((team,20))))
        if team==171:
            for raw in re.findall(r"CreateNUnitsAtLoc\(1, '(.{4})'",fs['Trig_Arena_Spawn_Team_Actions']):
                members.append(dict(raw=raw,level=0,gear=[],preset=0,leader=False))
        result.append(dict(id=team,name=name,cups=cups or [11],members=members,
                           detection=values.get((team,4),0)>=1, leader=values.get((team,20),0)))
    return result

if __name__=='__main__':
    from pathlib import Path
    from mpq import MPQ
    root=Path(__file__).resolve().parents[1]
    rows=data_for(MPQ(str(root/'release/development/V37/FFERPG-V37.w3x')).read('war3map.j').decode())
    print(len(rows),'teams',sum(len(team['members']) for team in rows),'members',Counter(cup for team in rows for cup in team['cups']))


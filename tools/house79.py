"""House recovery uses its existing native percentage auras, with no new timer."""
import copy
from objdata import read_objects,write_objects
from priest_master import setf,fields

def abilities(data):
    if not data:return data
    t=read_objects(data,'w3a')
    additions=[]
    for original in t['custom']+t['original']:
        o=copy.deepcopy(original)
        raw=o['id'] or o['base']
        if raw=='A001':
            o['id']='hH79'
            setf(o,'Oar1',.05,1,data=1);setf(o,'Oar2',1,1,data=2)
            setf(o,'aub1','Nearby friendly units recover 5% of their maximum health each second.',1)
        elif raw=='A00F':
            o['id']='hM79'
            setf(o,'Arm1',.05,1,data=1);setf(o,'Arm2',1,1,data=2)
            setf(o,'aub1','Nearby friendly units recover 5% of their maximum mana each second.',1)
        else:continue
        additions.append(o)
    assert len(additions)==2
    t['custom'].extend(additions)
    return write_objects(t,t['version'],'w3a')

def units(data):
    t=read_objects(data,'w3u')
    for o in t['original']+t['custom']:
        if (o['id'] or o['base']) in ['h006','h00N']:
            f=fields(o)
            for key in list(f):
                if key[0]=='uabi':setf(o,'uabi',f[key].replace('A001','hH79').replace('A00F','hM79'),key[1])
    return write_objects(t,t['version'],'w3u')

"""A bounded gold sweep mesh: no particles can spill outside the damage cone."""
import math
import struct


def ints(*values):
    return struct.pack('<'+'I'*len(values), *values)


def floats(*values):
    return struct.pack('<'+'f'*len(values), *values)


def chunk(tag, data):
    return tag.encode()+ints(len(data))+data


def sized(data):
    return ints(len(data)+4)+data


def text(value, size):
    return value.encode().ljust(size, b'\0')


def sweep_vertices(reach=450., segments=48):
    # Ribbon and its fading inner wake share the exact damage-sector boundary.
    return [(reach*r*math.cos(a), reach*r*math.sin(a), 8.)
            for r in (0., .60, .88, 1.)
            for a in [-math.pi/4+math.pi/2*i/segments for i in range(segments+1)]]


def sweep_model(reach=450., segments=48):
    verts=sweep_vertices(reach, segments)
    count=len(verts)
    extent=floats(reach, 0., -reach/math.sqrt(2), 0., reach, reach/math.sqrt(2), 12.)
    model=text('Dragoon bounded sweep',80)+text('',260)+extent+ints(150)
    seq=text('Stand',80)+ints(0,350)+floats(0.)+ints(1)+floats(0.)+ints(0)+extent
    texture=ints(0)+text('DragoonSweep.blp',260)+ints(0)
    # Add-alpha, unshaded, unfogged, two-sided; no environment UV mapping or depth writes.
    layer=sized(ints(4,0xB1,0,0xffffffff,0)+floats(1.))
    material=sized(ints(0,0)+b'LAYS'+ints(1)+layer)
    indices=[]
    for row in range(3):
        for col in range(segments):
            a=row*(segments+1)+col;b=a+segments+1
            indices.extend((a,b,a+1,a+1,b,b+1))
    geo=b'VRTX'+ints(count)+b''.join(floats(*v) for v in verts)
    geo+=b'NRMS'+ints(count)+floats(0.,0.,1.)*count
    geo+=b'PTYP'+ints(1,4)+b'PCNT'+ints(1,len(indices))
    geo+=b'PVTX'+ints(len(indices))+struct.pack('<'+'H'*len(indices),*indices)
    geo+=b'GNDX'+ints(count)+bytes(count)
    geo+=b'MTGC'+ints(1,1)+b'MATS'+ints(1,0)
    geo+=ints(0,0,0)+extent+ints(1)+extent
    geo+=b'UVAS'+ints(1)+b'UVBS'+ints(count)
    geo+=b''.join(floats(col/segments, v) for v in (0.,.60,.88,1.) for col in range(segments+1))
    alpha=b'KGAO'+ints(4,1,0xffffffff)+ints(0)+floats(1.)+ints(35)+floats(1.)+ints(140)+floats(.85)+ints(350)+floats(0.)
    anim=sized(floats(1.)+ints(0)+floats(1.,1.,1.)+ints(0)+alpha)
    bone=sized(text('Sweep root',80)+ints(0,0xffffffff,0x100))+ints(0,0)
    return b'MDLX'+chunk('VERS',ints(800))+chunk('MODL',model)+chunk('SEQS',seq)+chunk('MTLS',material)+chunk('TEXS',texture)+chunk('GEOS',sized(geo))+chunk('GEOA',anim)+chunk('BONE',bone)+chunk('PIVT',floats(0.,0.,0.))


def sweep_texture():
    pixels=bytearray()
    for y in range(64):
        v=y/63.
        for x in range(64):
            u=x/63.
            edge=min(1.,u*20.,(1.-u)*20.)
            glow=math.exp(-((v-.88)/.075)**2)
            wake=.16*math.sin(math.pi*v)
            alpha=int(255*edge*max(glow,wake)) if 0<x<63 and 0<y<63 else 0
            pixels.extend((100,210,255,alpha))
    return struct.pack('<BBBHHBHHHHBB',0,0,2,0,0,0,0,0,64,64,32,8)+pixels


def sweep_blp():
    """Native BLP2 paletted texture with an explicit 8-bit alpha plane."""
    rgba=sweep_texture()[18:]
    alpha=bytes(rgba[i+3] for i in range(0,len(rgba),4))
    offsets=[1172]+[0]*15
    sizes=[8192]+[0]*15
    header=struct.pack('<4sIBBBBII',b'BLP2',1,1,8,0,0,64,64)
    header+=struct.pack('<16I',*offsets)+struct.pack('<16I',*sizes)
    return header+bytes((100,210,255,255))*256+bytes(4096)+alpha

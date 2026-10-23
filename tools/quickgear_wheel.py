"""Small radial shadow textures for simple-frame item cooldown overlays."""
from pathlib import Path
import math,re,struct
ROOT=Path(__file__).resolve().parents[1]/'experiments/Forsaken/QuickGearUI/wheel'

def generate():
    from PIL import Image,ImageDraw,ImageFont
    ROOT.mkdir(parents=True,exist_ok=True)
    for step in range(65):
        path=ROOT/f'CD{step:02}.tga'
        image=Image.new('RGBA',(64,64))
        pixels=[]
        cutoff=2.*math.pi*(1.-step/64.)
        for y in range(64):
            for x in range(64):
                angle=math.atan2(x-31.5,31.5-y)%(2.*math.pi)
                pixels.append((0,0,0,225 if step>0 and angle>=cutoff else 0))
        image.putdata(pixels);image.save(path)
    font=ImageFont.truetype('C:/Windows/Fonts/arialbd.ttf',34)
    for seconds in range(301):
        image=Image.new('RGBA',(64,64))
        if seconds>0:
            draw=ImageDraw.Draw(image)
            draw.text((32,32),str(seconds),font=font,anchor='mm',fill='white',stroke_width=2,stroke_fill='black')
        image.save(ROOT/f'Number{seconds}.tga')


def blp1(image):
    """Lossless grayscale BLP1 with explicit 8-bit alpha and a full mip chain.

    Layout: Magos BLP specification / Kanma BLPConverter, palette type 4.
    The cooldown art is grayscale, so it needs no color quantization.
    """
    from PIL import Image
    image=image.convert('RGBA')
    width,height=image.size
    assert width==height and width>0 and width&(width-1)==0
    red,green,blue,alpha=image.split()
    assert red.tobytes()==green.tobytes()==blue.tobytes()
    payloads=[]
    while True:
        payloads.append(image.getchannel('R').tobytes()+image.getchannel('A').tobytes())
        if image.size==(1,1):break
        image=image.resize((max(1,image.width//2),max(1,image.height//2)),Image.Resampling.BOX)
    offsets=[0]*16;lengths=[0]*16;position=156+1024
    for level,payload in enumerate(payloads):
        offsets[level]=position;lengths[level]=len(payload);position+=len(payload)
    header=b'BLP1'+struct.pack('<6I',1,8,width,height,4,1)
    header+=struct.pack('<16I',*offsets)+struct.pack('<16I',*lengths)
    palette=b''.join(bytes((value,value,value,255)) for value in range(256))
    return header+palette+b''.join(payloads)


def assets():
    from PIL import Image
    result={}
    paths=list(sorted(ROOT.glob('CD*.tga')))+[ROOT/f'Number{i}.tga' for i in range(301)]
    for path in paths:
        name='QuickGearWheel'+path.stem if path.stem.startswith('CD') else 'QuickGear'+path.stem
        with Image.open(path) as image:result['war3mapImported/'+name+'.blp']=blp1(image)
    return result


def import_entries(data):
    if not data:return []
    version,count=struct.unpack_from('<II',data);assert version==1
    entries=[];position=8
    for _ in range(count):
        flag=data[position];end=data.index(b'\0',position+1)
        entries.append((flag,data[position+1:end].decode('utf-8')));position=end+1
    assert position==len(data)
    return entries


def add_assets(replacements,archive):
    # Honor the format in the selected UI definition, including a verified rollback.
    fdf=(ROOT.parent/'QuickGear.fdf').read_text()
    if '.tga"' in fdf:
        selected={}
        for path in list(sorted(ROOT.glob('CD*.tga')))+[ROOT/f'Number{i}.tga' for i in range(301)]:
            stem='QuickGearWheel'+path.stem if path.stem.startswith('CD') else 'QuickGear'+path.stem
            selected['war3mapImported/'+stem+'.tga']=path.read_bytes()
        for name in (archive.read('(listfile)') or b'').decode('utf-8').splitlines():
            if re.fullmatch(r'war3mapImported/QuickGear(?:WheelCD\d+|Number\d+|Digit\d+)\.blp',name.replace('\\','/'),re.I):
                replacements[name]=None
        replacements.update(selected)
        entries=import_entries(replacements.get('war3map.imp') or archive.read('war3map.imp'))
        entries=[e for e in entries if not ('quickgear' in e[1].lower() and e[1].lower().endswith('.blp'))]
        replacements['war3map.imp']=struct.pack('<II',1,len(entries))+b''.join(bytes([flag])+name.encode('utf-8')+b'\0' for flag,name in entries)
        return
    # Delete the old TGA resources before adding BLPs so the archive hash table
    # does not fill with obsolete copies. Preserve all unrelated imports.
    names=(archive.read('(listfile)') or b'').decode('utf-8').splitlines()
    legacy=re.compile(r'war3mapImported/QuickGear(?:WheelCD[0-9]+|Number[0-9]+|Digit[0-9]+)\.tga',re.I)
    for name in names:
        if legacy.fullmatch(name.replace('\\','/')):replacements[name]=None
    replacements.update(assets())
    entries=import_entries(replacements.get('war3map.imp') or archive.read('war3map.imp'))
    def fullpath(flag,path):
        return (path if flag==13 else 'war3mapImported/'+path).replace('\\','/').lower()
    entries=[entry for entry in entries if not legacy.fullmatch(fullpath(*entry))]
    known={fullpath(*entry) for entry in entries}
    wanted=list(assets_names())+['war3mapImported/QuickGear.fdf','war3mapImported/QuickGear.toc']
    for name in wanted:
        if name.lower() not in known:
            entries.append((13,name.replace('/','\\')));known.add(name.lower())
    replacements['war3map.imp']=struct.pack('<II',1,len(entries))+b''.join(bytes([flag])+name.encode('utf-8')+b'\0' for flag,name in entries)


def assets_names():
    return ['war3mapImported/QuickGearWheelCD%02d.blp'%step for step in range(65)]+['war3mapImported/QuickGearNumber%d.blp'%seconds for seconds in range(301)]


if __name__=='__main__':generate()

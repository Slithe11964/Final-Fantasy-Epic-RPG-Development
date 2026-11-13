import sys,os
from PIL import Image,ImageDraw,ImageFont
font_path,out=sys.argv[1],sys.argv[2]
os.makedirs(out,exist_ok=True)
big=ImageFont.truetype(font_path,36)
small=ImageFont.truetype(font_path,17)
for n in range(301):
    im=Image.new('RGBA',(64,64))
    if n>0:
        ImageDraw.Draw(im).text((32,33),str(n),font=big,anchor='mm',fill=(255,255,255,255),stroke_width=2,stroke_fill=(0,0,0,255))
    im.save(os.path.join(out,'Number%d.tga'%n))
for ch in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789':
    im=Image.new('RGBA',(64,64))
    ImageDraw.Draw(im).text((4,2),ch,font=small,anchor='lt',fill=(255,255,255,255),stroke_width=1,stroke_fill=(0,0,0,255))
    im.save(os.path.join(out,'Key%s.tga'%ch))
print('ok')
